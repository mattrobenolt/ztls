/// TLS 1.3 HKDF key derivation.
///
/// Wraps std.crypto.kdf.hkdf with TLS 1.3-specific label expansion per
/// RFC 8446 §7.1 and §7.3.
const std = @import("std");
const assert = std.debug.assert;
const crypto = std.crypto;
const HmacSha256 = crypto.auth.hmac.sha2.HmacSha256;
const HmacSha384 = crypto.auth.hmac.sha2.HmacSha384;
const Sha256 = crypto.hash.sha2.Sha256;
const Sha384 = crypto.hash.sha2.Sha384;
const testing = std.testing;

const aead = @import("aead.zig");
const CipherSuite = @import("cipher_suite.zig").CipherSuite;
const Iv = @import("aead.zig").Iv;
const memx = @import("memx.zig");
const RecordLayer = @import("RecordLayer.zig");

/// TLS_AES_128_GCM_SHA256 and TLS_CHACHA20_POLY1305_SHA256.
pub const HkdfSha256 = Hkdf(HmacSha256);

/// TLS_AES_256_GCM_SHA384.
pub const HkdfSha384 = Hkdf(HmacSha384);

fn Hkdf(comptime Hmac: type) type {
    const H = crypto.kdf.hkdf.Hkdf(Hmac);

    return struct {
        /// Length of the pseudorandom key and all derived secrets.
        pub const prk_len = H.prk_length;
        pub const Prk = memx.Array(prk_len);
        pub const TranscriptHash = memx.Array(prk_len);
        pub const TrafficSecret = memx.Array(prk_len);
        pub const FinishedKey = memx.Array(prk_len);
        const prk_zero = &Prk.zero.data;

        comptime {
            assert(prk_len == 32 or prk_len == 48);
        }

        /// RFC 8446 §7.1 — HKDF-Extract.
        pub inline fn extract(salt: []const u8, ikm: []const u8) Prk {
            return .init(H.extract(salt, ikm));
        }

        /// RFC 8446 §7.1 — HKDF-Expand-Label.
        ///
        /// Derives `out.len` bytes from `prk` using a TLS 1.3 structured label.
        /// `label` must be a comptime string (all TLS 1.3 labels are literals).
        /// `context` is runtime — typically a transcript hash or empty.
        pub fn expandLabel(
            out: []u8,
            comptime label: []const u8,
            context: []const u8,
            prk: Prk,
        ) void {
            const tls13_prefix = "tls13 ";
            comptime assert(tls13_prefix.len + label.len <= 255); // label<7..255>
            assert(context.len <= 255); // context<0..255>
            assert(out.len <= std.math.maxInt(u16)); // length is uint16

            // HkdfLabel wire encoding (RFC 8446 §7.1):
            //   uint16 length
            //   opaque label<7..255>  = "tls13 " + label
            //   opaque context<0..255>
            const full_label = tls13_prefix ++ label;
            const length_field = @sizeOf(u16);
            const label_len_field = @sizeOf(u8);
            const context_len_field = @sizeOf(u8);
            const max_context_len = 255;
            const header_len = length_field + label_len_field + context_len_field;
            const buf_len = header_len + full_label.len + max_context_len;
            var buf: [buf_len]u8 = undefined;
            var pos: usize = 0;

            buf[pos..][0..2].* = memx.toBytes(u16, @intCast(out.len));
            pos += 2;
            buf[pos] = full_label.len;
            pos += 1;
            buf[pos..][0..full_label.len].* = full_label.*;
            pos += full_label.len;
            buf[pos] = @intCast(context.len);
            pos += 1;
            @memcpy(buf[pos..][0..context.len], context);
            pos += context.len;

            H.expand(out, buf[0..pos], prk.data);
        }

        // Hash("") — used as the transcript context for the "derived" steps
        // between key schedule levels. RFC 8446 §7.1: Derive-Secret(., "derived", "")
        // uses Transcript-Hash of empty input = Hash("").
        const empty_hash: TranscriptHash = blk: {
            @setEvalBranchQuota(100_000);
            var out: TranscriptHash = undefined;
            const S = switch (prk_len) {
                32 => Sha256,
                48 => Sha384,
                else => unreachable,
            };
            S.hash(&.{}, &out.data, .{});
            break :blk out;
        };

        /// EarlySecret for a full handshake with no PSK.
        /// Salt and IKM are both zero — comptime constant per RFC 8446 §7.1.
        pub const early_secret: Prk = blk: {
            @setEvalBranchQuota(100_000);
            break :blk .init(H.extract(prk_zero, prk_zero));
        };

        /// RFC 8446 §7.1 — EarlySecret for a PSK or resumption handshake.
        pub inline fn pskEarlySecret(psk: []const u8) Prk {
            return .init(H.extract(prk_zero, psk));
        }

        /// RFC 8446 §7.1 — Derive-Secret.
        ///
        /// Expands `secret` using `label` and a transcript hash as context.
        /// Output is always `prk_len` bytes (the hash output length).
        pub inline fn deriveSecret(
            secret: Prk,
            comptime label: []const u8,
            transcript_hash: *const TranscriptHash,
        ) Prk {
            var out: Prk = undefined;
            expandLabel(&out.data, label, &transcript_hash.data, secret);
            return out;
        }

        /// RFC 8446 §7.1 — HandshakeSecret.
        ///
        /// Mixes the DHE shared secret into the key schedule.
        /// `dhe` is the raw ECDH output: 32 bytes for X25519/P-256, 48 for
        /// P-384. The key exchange layer owns the sizing; the key schedule
        /// just extracts over whatever bytes it is given.
        pub fn handshakeSecret(early: Prk, dhe: []const u8) Prk {
            const salt = deriveSecret(early, "derived", &empty_hash);
            return .init(H.extract(&salt.data, dhe));
        }

        /// RFC 8446 §7.1 — MasterSecret.
        ///
        /// No new key material at this stage; IKM is zero.
        pub fn masterSecret(handshake: Prk) Prk {
            const salt = deriveSecret(handshake, "derived", &empty_hash);
            return .init(H.extract(&salt.data, prk_zero));
        }

        // RFC 8446 §7.1 — secrets derived from EarlySecret.

        pub inline fn externalBinderKey(early: Prk) FinishedKey {
            return .init(deriveSecret(early, "ext binder", &empty_hash).data);
        }

        pub inline fn resumptionBinderKey(early: Prk) FinishedKey {
            return .init(deriveSecret(early, "res binder", &empty_hash).data);
        }

        pub inline fn clientEarlyTrafficSecret(
            early: Prk,
            transcript_hash: *const TranscriptHash,
        ) TrafficSecret {
            return .init(deriveSecret(early, "c e traffic", transcript_hash).data);
        }

        pub inline fn earlyExporterMasterSecret(
            early: Prk,
            transcript_hash: *const TranscriptHash,
        ) Prk {
            return deriveSecret(early, "e exp master", transcript_hash);
        }

        // RFC 8446 §7.1 — traffic secrets from HandshakeSecret.

        pub inline fn clientHandshakeTrafficSecret(
            handshake: Prk,
            transcript_hash: *const TranscriptHash,
        ) TrafficSecret {
            return .init(deriveSecret(handshake, "c hs traffic", transcript_hash).data);
        }

        pub inline fn serverHandshakeTrafficSecret(
            handshake: Prk,
            transcript_hash: *const TranscriptHash,
        ) TrafficSecret {
            return .init(deriveSecret(handshake, "s hs traffic", transcript_hash).data);
        }

        // RFC 8446 §7.1 — traffic secrets from MasterSecret.

        pub inline fn clientApplicationTrafficSecret(
            master: Prk,
            transcript_hash: *const TranscriptHash,
        ) TrafficSecret {
            return .init(deriveSecret(master, "c ap traffic", transcript_hash).data);
        }

        pub inline fn serverApplicationTrafficSecret(
            master: Prk,
            transcript_hash: *const TranscriptHash,
        ) TrafficSecret {
            return .init(deriveSecret(master, "s ap traffic", transcript_hash).data);
        }

        pub inline fn resumptionMasterSecret(
            master: Prk,
            transcript_hash: *const TranscriptHash,
        ) Prk {
            return deriveSecret(master, "res master", transcript_hash);
        }

        pub fn resumptionPsk(resumption_master: Prk, ticket_nonce: []const u8) Prk {
            var out: Prk = undefined;
            expandLabel(&out.data, "resumption", ticket_nonce, resumption_master);
            return out;
        }

        /// RFC 8446 §7.2 — next-generation application traffic secret.
        /// application_traffic_secret_N+1 =
        ///   HKDF-Expand-Label(secret_N, "traffic upd", "", Hash.length)
        pub inline fn nextTrafficSecret(secret: TrafficSecret) TrafficSecret {
            var out: TrafficSecret = undefined;
            expandLabel(&out.data, "traffic upd", "", .init(secret.data));
            return out;
        }

        /// Derive both the write key and IV from a traffic secret and return
        /// a ready-to-use RecordLayer. `key` selects the AEAD at runtime (the
        /// negotiated cipher suite), so a single arm serves all suites of its
        /// hash (e.g. SHA-256 covers AES-128-GCM and ChaCha20-Poly1305).
        pub fn makeRecordLayer(key: CipherSuite, prk: TrafficSecret) aead.Error!RecordLayer {
            const layer_aead: aead.Aead = switch (key) {
                inline else => |k| @unionInit(aead.Aead, @tagName(k), trafficKey(k, prk)),
            };
            return .init(layer_aead, trafficIv(prk));
        }

        /// RFC 8446 §4.4.4 — derive the finished key from a traffic secret.
        pub inline fn finishedKey(prk: TrafficSecret) FinishedKey {
            var out: FinishedKey = undefined;
            expandLabel(&out.data, "finished", "", .init(prk.data));
            return out;
        }

        /// RFC 8446 §7.3 — derive the write key from a traffic secret.
        pub inline fn trafficKey(
            comptime key: CipherSuite,
            prk: TrafficSecret,
        ) @FieldType(aead.Aead, @tagName(key)) {
            var out: @FieldType(aead.Aead, @tagName(key)) = undefined;
            expandLabel(&out.data, "key", "", .init(prk.data));
            return out;
        }

        /// RFC 8446 §7.3 — derive the write IV from a traffic secret.
        /// Always 12 bytes for all TLS 1.3 cipher suites.
        pub inline fn trafficIv(prk: TrafficSecret) Iv {
            var iv: Iv = undefined;
            expandLabel(&iv.data, "iv", "", .init(prk.data));
            return iv;
        }
    };
}

// RFC 8446 §7.3 — traffic key calculation
// Test vectors from RFC 8448 §3 (server handshake traffic keys).
// https://www.rfc-editor.org/rfc/rfc8448
//
// Cipher suite: TLS_AES_128_GCM_SHA256
// server_handshake_traffic_secret:
//   b67b7d690cc16c4e75e54213cb2d37b4e9c912bcded9105d42befd59d391ad38
// Expected:
//   server_write_key: 3fce516009c21727d0f2e4e86ee403bc  (16 bytes)
//   server_write_iv:  5d313eb2671276ee13000b30          (12 bytes)

const dhe_rfc8448 = [_]u8{
    0x8b, 0xd4, 0x05, 0x4f, 0xb5, 0x5b, 0x9d, 0x63,
    0xfd, 0xfb, 0xac, 0xf9, 0xf0, 0x4b, 0x9f, 0x0d,
    0x35, 0xe6, 0xd6, 0x3f, 0x53, 0x75, 0x63, 0xef,
    0xd4, 0x62, 0x72, 0x90, 0x0f, 0x89, 0x49, 0x2d,
};

const transcript_hs_rfc8448: HkdfSha256.TranscriptHash = .init(.{
    0x86, 0x0c, 0x06, 0xed, 0xc0, 0x78, 0x58, 0xee,
    0x8e, 0x78, 0xf0, 0xe7, 0x42, 0x8c, 0x58, 0xed,
    0xd6, 0xb4, 0x3f, 0x2c, 0xa3, 0xe6, 0xe9, 0x5f,
    0x02, 0xed, 0x06, 0x3c, 0xf0, 0xe1, 0xca, 0xd8,
});

test "HkdfSha256.trafficKey: RFC 8448 §3 server handshake" {
    const secret: HkdfSha256.TrafficSecret = .init(.{
        0xb6, 0x7b, 0x7d, 0x69, 0x0c, 0xc1, 0x6c, 0x4e,
        0x75, 0xe5, 0x42, 0x13, 0xcb, 0x2d, 0x37, 0xb4,
        0xe9, 0xc9, 0x12, 0xbc, 0xde, 0xd9, 0x10, 0x5d,
        0x42, 0xbe, 0xfd, 0x59, 0xd3, 0x91, 0xad, 0x38,
    });
    const key = HkdfSha256.trafficKey(.aes_128_gcm_sha256, secret);
    try testing.expectEqualSlices(u8, &.{
        0x3f, 0xce, 0x51, 0x60, 0x09, 0xc2, 0x17, 0x27,
        0xd0, 0xf2, 0xe4, 0xe8, 0x6e, 0xe4, 0x03, 0xbc,
    }, &key.data);
}

// SHA-384 key schedule (for TLS_AES_256_GCM_SHA384). RFC 8448 has no SHA-384
// trace, so the expected values are computed independently via
// HKDF-Expand-Label(SHA-384) from a chosen 48-byte traffic secret (0x01 x48).
test "HkdfSha384: traffic key/iv, finished key, traffic-upd (independent vector)" {
    const secret: HkdfSha384.TrafficSecret = .init(@splat(0x01));
    try testing.expectEqualSlices(u8, &.{
        0x2c, 0xd3, 0xe9, 0xa3, 0x6d, 0x45, 0x99, 0x50,
        0x3b, 0xae, 0x71, 0x16, 0x22, 0x3e, 0x4c, 0x29,
        0xe6, 0xb3, 0xde, 0x23, 0xaf, 0x4b, 0x93, 0xbb,
        0xcc, 0x21, 0x95, 0xa6, 0x0e, 0xaf, 0x0b, 0x1d,
    }, &HkdfSha384.trafficKey(.aes_256_gcm_sha384, secret).data);
    try testing.expectEqualSlices(u8, &.{
        0x04, 0xc8, 0xc4, 0x44, 0x22, 0xae, 0x77, 0x21,
        0x7d, 0x56, 0x69, 0x0e,
    }, &HkdfSha384.trafficIv(secret).data);
    try testing.expectEqualSlices(u8, &.{
        0xba, 0x8d, 0x7f, 0x18, 0x52, 0x8f, 0x67, 0xe9,
        0x05, 0x92, 0x87, 0x3c, 0xa3, 0x9d, 0xab, 0x55,
        0x91, 0xf0, 0x48, 0x07, 0xa9, 0xa3, 0x1c, 0x83,
        0x7b, 0xc6, 0x49, 0x70, 0xef, 0x98, 0x6e, 0xe3,
        0x84, 0x03, 0x06, 0x9b, 0xc7, 0xc5, 0x9c, 0xe3,
        0x06, 0xc7, 0xef, 0x98, 0x55, 0x49, 0x92, 0x33,
    }, &HkdfSha384.finishedKey(secret).data);
    try testing.expectEqualSlices(u8, &.{
        0xec, 0xd9, 0xff, 0x70, 0x2d, 0xbd, 0x11, 0x1e,
        0x5d, 0x25, 0x6b, 0xd3, 0xfa, 0x91, 0x73, 0x13,
        0x6f, 0x4e, 0xd3, 0xbf, 0x19, 0x52, 0xd1, 0x12,
        0xfe, 0x82, 0x29, 0xf2, 0x5b, 0x4f, 0x43, 0x15,
        0x09, 0xf8, 0x9a, 0xb5, 0x93, 0xbe, 0x98, 0xce,
        0xca, 0xe4, 0x29, 0xe5, 0x90, 0xb4, 0xd6, 0xcb,
    }, &HkdfSha384.nextTrafficSecret(secret).data);
}

test "HkdfSha256.trafficIv: RFC 8448 §3 server handshake" {
    const secret: HkdfSha256.TrafficSecret = .init(.{
        0xb6, 0x7b, 0x7d, 0x69, 0x0c, 0xc1, 0x6c, 0x4e,
        0x75, 0xe5, 0x42, 0x13, 0xcb, 0x2d, 0x37, 0xb4,
        0xe9, 0xc9, 0x12, 0xbc, 0xde, 0xd9, 0x10, 0x5d,
        0x42, 0xbe, 0xfd, 0x59, 0xd3, 0x91, 0xad, 0x38,
    });
    const iv = HkdfSha256.trafficIv(secret);
    try testing.expectEqualSlices(u8, &.{
        0x5d, 0x31, 0x3e, 0xb2, 0x67, 0x12, 0x76, 0xee,
        0x13, 0x00, 0x0b, 0x30,
    }, &iv.data);
}

// RFC 8446 §7.1 — key schedule
// All vectors from RFC 8448 §3 (simple 1-RTT handshake, X25519, TLS_AES_128_GCM_SHA256).
// https://www.rfc-editor.org/rfc/rfc8448

test "HkdfSha256.earlySecret: RFC 8448 §3" {
    try testing.expectEqualSlices(u8, &.{
        0x33, 0xad, 0x0a, 0x1c, 0x60, 0x7e, 0xc0, 0x3b,
        0x09, 0xe6, 0xcd, 0x98, 0x93, 0x68, 0x0c, 0xe2,
        0x10, 0xad, 0xf3, 0x00, 0xaa, 0x1f, 0x26, 0x60,
        0xe1, 0xb2, 0x2e, 0x10, 0xf1, 0x70, 0xf9, 0x2a,
    }, &HkdfSha256.early_secret.data);
}

// RFC 8446 §7.1 — PSK/resumption key schedule.
// Vectors from RFC 8448 §3 and §4: the first handshake derives the resumption
// master secret and ticket PSK; the resumed 0-RTT handshake derives the early
// secret, binder key, binder Finished value, client early traffic secret, and
// early exporter master secret.
test "HkdfSha256: RFC 8448 §3/§4 PSK and resumption secrets" {
    const resumption_master_hash: HkdfSha256.TranscriptHash = .init(.{
        0x20, 0x91, 0x45, 0xa9, 0x6e, 0xe8, 0xe2, 0xa1,
        0x22, 0xff, 0x81, 0x00, 0x47, 0xcc, 0x95, 0x26,
        0x84, 0x65, 0x8d, 0x60, 0x49, 0xe8, 0x64, 0x29,
        0x42, 0x6d, 0xb8, 0x7c, 0x54, 0xad, 0x14, 0x3d,
    });
    const first_master: HkdfSha256.Prk = .init(.{
        0x18, 0xdf, 0x06, 0x84, 0x3d, 0x13, 0xa0, 0x8b,
        0xf2, 0xa4, 0x49, 0x84, 0x4c, 0x5f, 0x8a, 0x47,
        0x80, 0x01, 0xbc, 0x4d, 0x4c, 0x62, 0x79, 0x84,
        0xd5, 0xa4, 0x1d, 0xa8, 0xd0, 0x40, 0x29, 0x19,
    });
    const resumption_master = HkdfSha256.resumptionMasterSecret(
        first_master,
        &resumption_master_hash,
    );
    try testing.expectEqualSlices(u8, &.{
        0x7d, 0xf2, 0x35, 0xf2, 0x03, 0x1d, 0x2a, 0x05,
        0x12, 0x87, 0xd0, 0x2b, 0x02, 0x41, 0xb0, 0xbf,
        0xda, 0xf8, 0x6c, 0xc8, 0x56, 0x23, 0x1f, 0x2d,
        0x5a, 0xba, 0x46, 0xc4, 0x34, 0xec, 0x19, 0x6c,
    }, &resumption_master.data);

    const psk = HkdfSha256.resumptionPsk(resumption_master, &.{ 0x00, 0x00 });
    try testing.expectEqualSlices(u8, &.{
        0x4e, 0xcd, 0x0e, 0xb6, 0xec, 0x3b, 0x4d, 0x87,
        0xf5, 0xd6, 0x02, 0x8f, 0x92, 0x2c, 0xa4, 0xc5,
        0x85, 0x1a, 0x27, 0x7f, 0xd4, 0x13, 0x11, 0xc9,
        0xe6, 0x2d, 0x2c, 0x94, 0x92, 0xe1, 0xc4, 0xf3,
    }, &psk.data);

    const psk_early = HkdfSha256.pskEarlySecret(&psk.data);
    try testing.expectEqualSlices(u8, &.{
        0x9b, 0x21, 0x88, 0xe9, 0xb2, 0xfc, 0x6d, 0x64,
        0xd7, 0x1d, 0xc3, 0x29, 0x90, 0x0e, 0x20, 0xbb,
        0x41, 0x91, 0x50, 0x00, 0xf6, 0x78, 0xaa, 0x83,
        0x9c, 0xbb, 0x79, 0x7c, 0xb7, 0xd8, 0x33, 0x2c,
    }, &psk_early.data);

    const binder_key = HkdfSha256.resumptionBinderKey(psk_early);
    try testing.expectEqualSlices(u8, &.{
        0x69, 0xfe, 0x13, 0x1a, 0x3b, 0xba, 0xd5, 0xd6,
        0x3c, 0x64, 0xee, 0xbc, 0xc3, 0x0e, 0x39, 0x5b,
        0x9d, 0x81, 0x07, 0x72, 0x6a, 0x13, 0xd0, 0x74,
        0xe3, 0x89, 0xdb, 0xc8, 0xa4, 0xe4, 0x72, 0x56,
    }, &binder_key.data);

    const finished_key = HkdfSha256.finishedKey(binder_key);
    try testing.expectEqualSlices(u8, &.{
        0x55, 0x88, 0x67, 0x3e, 0x72, 0xcb, 0x59, 0xc8,
        0x7d, 0x22, 0x0c, 0xaf, 0xfe, 0x94, 0xf2, 0xde,
        0xa9, 0xa3, 0xb1, 0x60, 0x9f, 0x7d, 0x50, 0xe9,
        0x0a, 0x48, 0x22, 0x7d, 0xb9, 0xed, 0x7e, 0xaa,
    }, &finished_key.data);

    const binder_hash = [_]u8{
        0x63, 0x22, 0x4b, 0x2e, 0x45, 0x73, 0xf2, 0xd3,
        0x45, 0x4c, 0xa8, 0x4b, 0x9d, 0x00, 0x9a, 0x04,
        0xf6, 0xbe, 0x9e, 0x05, 0x71, 0x1a, 0x83, 0x96,
        0x47, 0x3a, 0xef, 0xa0, 0x1e, 0x92, 0x4a, 0x14,
    };
    var binder_verify_data: [32]u8 = undefined;
    HmacSha256.create(&binder_verify_data, &binder_hash, &finished_key.data);
    try testing.expectEqualSlices(u8, &.{
        0x3a, 0xdd, 0x4f, 0xb2, 0xd8, 0xfd, 0xf8, 0x22,
        0xa0, 0xca, 0x3c, 0xf7, 0x67, 0x8e, 0xf5, 0xe8,
        0x8d, 0xae, 0x99, 0x01, 0x41, 0xc5, 0x92, 0x4d,
        0x57, 0xbb, 0x6f, 0xa3, 0x1b, 0x9e, 0x5f, 0x9d,
    }, &binder_verify_data);

    const early_hash: HkdfSha256.TranscriptHash = .init(.{
        0x08, 0xad, 0x0f, 0xa0, 0x5d, 0x7c, 0x72, 0x33,
        0xb1, 0x77, 0x5b, 0xa2, 0xff, 0x9f, 0x4c, 0x5b,
        0x8b, 0x59, 0x27, 0x6b, 0x7f, 0x22, 0x7f, 0x13,
        0xa9, 0x76, 0x24, 0x5f, 0x5d, 0x96, 0x09, 0x13,
    });
    const early_traffic = HkdfSha256.clientEarlyTrafficSecret(psk_early, &early_hash);
    try testing.expectEqualSlices(u8, &.{
        0x3f, 0xbb, 0xe6, 0xa6, 0x0d, 0xeb, 0x66, 0xc3,
        0x0a, 0x32, 0x79, 0x5a, 0xba, 0x0e, 0xff, 0x7e,
        0xaa, 0x10, 0x10, 0x55, 0x86, 0xe7, 0xbe, 0x5c,
        0x09, 0x67, 0x8d, 0x63, 0xb6, 0xca, 0xab, 0x62,
    }, &early_traffic.data);
    try testing.expectEqualSlices(u8, &.{
        0x92, 0x02, 0x05, 0xa5, 0xb7, 0xbf, 0x21, 0x15,
        0xe6, 0xfc, 0x5c, 0x29, 0x42, 0x83, 0x4f, 0x54,
    }, &HkdfSha256.trafficKey(.aes_128_gcm_sha256, early_traffic).data);
    try testing.expectEqualSlices(u8, &.{
        0x6d, 0x47, 0x5f, 0x09, 0x93, 0xc8, 0xe5, 0x64,
        0x61, 0x0d, 0xb2, 0xb9,
    }, &HkdfSha256.trafficIv(early_traffic).data);

    const early_exporter = HkdfSha256.earlyExporterMasterSecret(psk_early, &early_hash);
    try testing.expectEqualSlices(u8, &.{
        0xb2, 0x02, 0x68, 0x66, 0x61, 0x09, 0x37, 0xd7,
        0x42, 0x3e, 0x5b, 0xe9, 0x08, 0x62, 0xcc, 0xf2,
        0x4c, 0x0e, 0x60, 0x91, 0x18, 0x6d, 0x34, 0xf8,
        0x12, 0x08, 0x9f, 0xf5, 0xbe, 0x2e, 0xf7, 0xdf,
    }, &early_exporter.data);
}

test "HkdfSha256.handshakeSecret: RFC 8448 §3" {
    const handshake = HkdfSha256.handshakeSecret(HkdfSha256.early_secret, &dhe_rfc8448);
    try testing.expectEqualSlices(u8, &.{
        0x1d, 0xc8, 0x26, 0xe9, 0x36, 0x06, 0xaa, 0x6f,
        0xdc, 0x0a, 0xad, 0xc1, 0x2f, 0x74, 0x1b, 0x01,
        0x04, 0x6a, 0xa6, 0xb9, 0x9f, 0x69, 0x1e, 0xd2,
        0x21, 0xa9, 0xf0, 0xca, 0x04, 0x3f, 0xbe, 0xac,
    }, &handshake.data);
}

test "HkdfSha256.masterSecret: RFC 8448 §3" {
    const handshake = HkdfSha256.handshakeSecret(HkdfSha256.early_secret, &dhe_rfc8448);
    const master = HkdfSha256.masterSecret(handshake);
    try testing.expectEqualSlices(u8, &.{
        0x18, 0xdf, 0x06, 0x84, 0x3d, 0x13, 0xa0, 0x8b,
        0xf2, 0xa4, 0x49, 0x84, 0x4c, 0x5f, 0x8a, 0x47,
        0x80, 0x01, 0xbc, 0x4d, 0x4c, 0x62, 0x79, 0x84,
        0xd5, 0xa4, 0x1d, 0xa8, 0xd0, 0x40, 0x29, 0x19,
    }, &master.data);
}

test "HkdfSha256.clientHandshakeTrafficSecret: RFC 8448 §3" {
    const handshake = HkdfSha256.handshakeSecret(HkdfSha256.early_secret, &dhe_rfc8448);
    const secret = HkdfSha256.clientHandshakeTrafficSecret(handshake, &transcript_hs_rfc8448);
    try testing.expectEqualSlices(u8, &.{
        0xb3, 0xed, 0xdb, 0x12, 0x6e, 0x06, 0x7f, 0x35,
        0xa7, 0x80, 0xb3, 0xab, 0xf4, 0x5e, 0x2d, 0x8f,
        0x3b, 0x1a, 0x95, 0x07, 0x38, 0xf5, 0x2e, 0x96,
        0x00, 0x74, 0x6a, 0x0e, 0x27, 0xa5, 0x5a, 0x21,
    }, &secret.data);
}

test "HkdfSha256.finishedKey: RFC 8448 §3 server" {
    // server_handshake_traffic_secret
    const secret: HkdfSha256.TrafficSecret = .init(.{
        0xb6, 0x7b, 0x7d, 0x69, 0x0c, 0xc1, 0x6c, 0x4e,
        0x75, 0xe5, 0x42, 0x13, 0xcb, 0x2d, 0x37, 0xb4,
        0xe9, 0xc9, 0x12, 0xbc, 0xde, 0xd9, 0x10, 0x5d,
        0x42, 0xbe, 0xfd, 0x59, 0xd3, 0x91, 0xad, 0x38,
    });
    const fk = HkdfSha256.finishedKey(secret);
    try testing.expectEqualSlices(u8, &.{
        0x00, 0x8d, 0x3b, 0x66, 0xf8, 0x16, 0xea, 0x55,
        0x9f, 0x96, 0xb5, 0x37, 0xe8, 0x85, 0xc3, 0x1f,
        0xc0, 0x68, 0xbf, 0x49, 0x2c, 0x65, 0x2f, 0x01,
        0xf2, 0x88, 0xa1, 0xd8, 0xcd, 0xc1, 0x9f, 0xc8,
    }, &fk.data);
}

// RFC 8446 §7.2 — traffic key update ("traffic upd").
// RFC 8448 has no KeyUpdate trace, so the expected next secret is computed
// independently (HKDF-Expand-Label with label "tls13 traffic upd") from the
// RFC 8448 §3 client_application_traffic_secret_0.
test "HkdfSha256.nextTrafficSecret: RFC 8446 §7.2" {
    const s0: HkdfSha256.TrafficSecret = .init(.{
        0x9e, 0x40, 0x64, 0x6c, 0xe7, 0x9a, 0x7f, 0x9d,
        0xc0, 0x5a, 0xf8, 0x88, 0x9b, 0xce, 0x65, 0x52,
        0x87, 0x5a, 0xfa, 0x0b, 0x06, 0xdf, 0x00, 0x87,
        0xf7, 0x92, 0xeb, 0xb7, 0xc1, 0x75, 0x04, 0xa5,
    });
    const s1 = HkdfSha256.nextTrafficSecret(s0);
    try testing.expectEqualSlices(u8, &.{
        0xfc, 0xdf, 0xcc, 0x72, 0x72, 0x5a, 0xae, 0xe4,
        0x8b, 0xf6, 0x4e, 0x4f, 0xd8, 0xb7, 0x49, 0xcd,
        0xbd, 0xba, 0xb3, 0x9d, 0x90, 0xda, 0x0b, 0x26,
        0xe2, 0x24, 0x5c, 0xa6, 0xea, 0x16, 0x72, 0x07,
    }, &s1.data);
}

test "HkdfSha256.serverHandshakeTrafficSecret: RFC 8448 §3" {
    const handshake = HkdfSha256.handshakeSecret(HkdfSha256.early_secret, &dhe_rfc8448);
    const secret = HkdfSha256.serverHandshakeTrafficSecret(handshake, &transcript_hs_rfc8448);
    try testing.expectEqualSlices(u8, &.{
        0xb6, 0x7b, 0x7d, 0x69, 0x0c, 0xc1, 0x6c, 0x4e,
        0x75, 0xe5, 0x42, 0x13, 0xcb, 0x2d, 0x37, 0xb4,
        0xe9, 0xc9, 0x12, 0xbc, 0xde, 0xd9, 0x10, 0x5d,
        0x42, 0xbe, 0xfd, 0x59, 0xd3, 0x91, 0xad, 0x38,
    }, &secret.data);
}
