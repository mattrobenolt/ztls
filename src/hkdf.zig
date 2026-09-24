//! TLS 1.3 HKDF key derivation.
//!
//! HKDF (RFC 5869) over hmac.zig and the libcrypto-backed SHA-2 types in
//! crypto/sha2.zig (#138), with TLS 1.3-specific label expansion per
//! RFC 8446 §7.1 and §7.3.
const std = @import("std");
const assert = std.debug.assert;
const crypto = std.crypto;
const testing = std.testing;

const aead = @import("aead.zig");
const backend = @import("crypto/backend.zig");
const CipherSuite = @import("cipher_suite.zig").CipherSuite;
const hmac = @import("hmac.zig");
const Iv = @import("aead.zig").Iv;
const memx = @import("memx.zig");
const RecordLayer = @import("RecordLayer.zig");
const sha2 = backend.sha2;

/// TLS_AES_128_GCM_SHA256 and TLS_CHACHA20_POLY1305_SHA256.
pub const HkdfSha256 = Hkdf(sha2.Sha256, crypto.hash.sha2.Sha256);

/// TLS_AES_256_GCM_SHA384.
pub const HkdfSha384 = Hkdf(sha2.Sha384, crypto.hash.sha2.Sha384);

/// `Hash` is the libcrypto-backed hash for every runtime derivation (#138).
/// `ComptimeHash` is the same function in std, used only for the constants
/// below: libcrypto cannot run at comptime.
fn Hkdf(comptime Hash: type, comptime ComptimeHash: type) type {
    comptime assert(Hash.digest_length == ComptimeHash.digest_length);
    const ComptimeHmac = hmac.Hmac(ComptimeHash);

    return struct {
        /// Length of the pseudorandom key and all derived secrets.
        pub const prk_len = Hash.digest_length;
        pub const Prk = memx.Array(prk_len);
        pub const TranscriptHash = memx.Array(prk_len);
        pub const TrafficSecret = memx.Array(prk_len);
        pub const FinishedKey = memx.Array(prk_len);
        const prk_zero = &Prk.zero.data;

        /// HMAC keyed by one secret. Every derivation below that takes a
        /// `*const Keyed` reuses its pad states (#138). A `Keyed` is a
        /// secret: stack only, wiped with `secureZero` in a `defer`.
        pub const Keyed = hmac.Hmac(Hash);

        comptime {
            assert(prk_len == 32 or prk_len == 48);
        }

        /// RFC 8446 §7.1 — HKDF-Extract.
        pub fn extract(salt: []const u8, ikm: []const u8) Prk {
            var out: Prk = undefined;
            Keyed.create(&out.data, ikm, salt);
            return out;
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
            var key: Keyed = .init(&prk.data);
            defer key.secureZero();
            expandLabelKeyed(out, label, context, &key);
        }

        /// HKDF-Expand-Label under a secret that is already keyed.
        pub fn expandLabelKeyed(
            out: []u8,
            comptime label: []const u8,
            context: []const u8,
            key: *const Keyed,
        ) void {
            expandLabelWith(Keyed, out, label, context, key);
        }

        fn expandLabelWith(
            comptime K: type,
            out: []u8,
            comptime label: []const u8,
            context: []const u8,
            key: *const K,
        ) void {
            const tls13_prefix = "tls13 ";
            comptime assert(tls13_prefix.len + label.len <= 255); // label<7..255>
            assert(context.len <= 255); // context<0..255>
            assert(out.len <= 255 * prk_len); // RFC 5869 §2.3: L <= 255*HashLen

            // HkdfLabel wire encoding (RFC 8446 §7.1):
            //   uint16 length
            //   opaque label<7..255>  = "tls13 " + label
            //   opaque context<0..255>
            // followed by the one-byte HKDF-Expand block counter.
            const full_label = tls13_prefix ++ label;
            const length_field = @sizeOf(u16);
            const label_len_field = @sizeOf(u8);
            const context_len_field = @sizeOf(u8);
            const counter_field = @sizeOf(u8);
            const max_context_len = 255;
            const header_len = length_field + label_len_field + context_len_field;
            const buf_len = header_len + full_label.len + max_context_len + counter_field;
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
            const info = buf[0 .. pos + counter_field];

            // RFC 5869 §2.3 — T(i) = HMAC(PRK, T(i-1) || info || i).
            var partial: [prk_len]u8 = undefined;
            defer hmac.wipe(&partial);
            var done: usize = 0;
            var counter: u8 = 1;
            while (done < out.len) : (counter += 1) {
                buf[pos] = counter;
                const block = if (out.len - done >= prk_len) out[done..][0..prk_len] else &partial;
                if (done == 0)
                    key.mac(block, .{info})
                else
                    key.mac(block, .{ out[done - prk_len ..][0..prk_len], info });
                if (block == &partial) @memcpy(out[done..], partial[0 .. out.len - done]);
                done += block.len;
            }
        }

        // Hash("") — used as the transcript context for the "derived" steps
        // between key schedule levels. RFC 8446 §7.1: Derive-Secret(., "derived", "")
        // uses Transcript-Hash of empty input = Hash("").
        const empty_hash: TranscriptHash = blk: {
            @setEvalBranchQuota(100_000);
            var out: TranscriptHash = undefined;
            ComptimeHash.hash(&.{}, &out.data, .{});
            break :blk out;
        };

        /// EarlySecret for a full handshake with no PSK.
        /// Salt and IKM are both zero — comptime constant per RFC 8446 §7.1.
        pub const early_secret: Prk = blk: {
            @setEvalBranchQuota(100_000);
            var out: Prk = undefined;
            ComptimeHmac.create(&out.data, prk_zero, prk_zero);
            break :blk out;
        };

        /// Derive-Secret(early_secret, "derived", ""): the HandshakeSecret
        /// salt for a handshake without a PSK, also a comptime constant.
        const early_derived: Prk = blk: {
            @setEvalBranchQuota(1_000_000);
            const key: ComptimeHmac = .init(&early_secret.data);
            var out: Prk = undefined;
            expandLabelWith(ComptimeHmac, &out.data, "derived", &empty_hash.data, &key);
            break :blk out;
        };

        /// RFC 8446 §7.1 — EarlySecret for a PSK or resumption handshake.
        pub inline fn pskEarlySecret(psk: []const u8) Prk {
            return extract(prk_zero, psk);
        }

        /// RFC 8446 §7.1 — Derive-Secret.
        ///
        /// Expands `secret` using `label` and a transcript hash as context.
        /// Output is always `prk_len` bytes (the hash output length).
        pub fn deriveSecret(
            secret: Prk,
            comptime label: []const u8,
            transcript_hash: *const TranscriptHash,
        ) Prk {
            var key: Keyed = .init(&secret.data);
            defer key.secureZero();
            return deriveSecretKeyed(&key, label, transcript_hash);
        }

        /// Derive-Secret under a secret that is already keyed.
        pub fn deriveSecretKeyed(
            key: *const Keyed,
            comptime label: []const u8,
            transcript_hash: *const TranscriptHash,
        ) Prk {
            var out: Prk = undefined;
            expandLabelKeyed(&out.data, label, &transcript_hash.data, key);
            return out;
        }

        /// RFC 8446 §7.1 — HandshakeSecret.
        ///
        /// Mixes the DHE shared secret into the key schedule.
        /// `dhe` is the raw ECDH output: 32 bytes for X25519/P-256, 48 for
        /// P-384. The key exchange layer owns the sizing; the key schedule
        /// just extracts over whatever bytes it is given.
        pub fn handshakeSecret(early: Prk, dhe: []const u8) Prk {
            var salt = deriveSecret(early, "derived", &empty_hash);
            defer salt.secureZero();
            return extract(&salt.data, dhe);
        }

        /// RFC 8446 §7.1 — HandshakeSecret from the negotiated PSK, or from
        /// none. Without a PSK the "derived" salt is `early_derived`, so only
        /// the extract runs.
        pub fn handshakeSecretFor(psk: ?[]const u8, dhe: []const u8) Prk {
            const p = psk orelse return extract(&early_derived.data, dhe);
            var early = pskEarlySecret(p);
            defer early.secureZero();
            return handshakeSecret(early, dhe);
        }

        /// RFC 8446 §7.1 — MasterSecret.
        ///
        /// No new key material at this stage; IKM is zero.
        pub fn masterSecret(handshake: Prk) Prk {
            var salt = deriveSecret(handshake, "derived", &empty_hash);
            defer salt.secureZero();
            return extract(&salt.data, prk_zero);
        }

        // RFC 8446 §7.1 — secrets derived from EarlySecret.

        pub inline fn externalBinderKey(early: Prk) FinishedKey {
            return deriveSecret(early, "ext binder", &empty_hash);
        }

        pub inline fn resumptionBinderKey(early: Prk) FinishedKey {
            return deriveSecret(early, "res binder", &empty_hash);
        }

        pub inline fn clientEarlyTrafficSecret(
            early: Prk,
            transcript_hash: *const TranscriptHash,
        ) TrafficSecret {
            return deriveSecret(early, "c e traffic", transcript_hash);
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
            return deriveSecret(handshake, "c hs traffic", transcript_hash);
        }

        pub inline fn serverHandshakeTrafficSecret(
            handshake: Prk,
            transcript_hash: *const TranscriptHash,
        ) TrafficSecret {
            return deriveSecret(handshake, "s hs traffic", transcript_hash);
        }

        // RFC 8446 §7.1 — traffic secrets from MasterSecret.

        pub inline fn clientApplicationTrafficSecret(
            master: Prk,
            transcript_hash: *const TranscriptHash,
        ) TrafficSecret {
            return deriveSecret(master, "c ap traffic", transcript_hash);
        }

        pub inline fn serverApplicationTrafficSecret(
            master: Prk,
            transcript_hash: *const TranscriptHash,
        ) TrafficSecret {
            return deriveSecret(master, "s ap traffic", transcript_hash);
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
            expandLabel(&out.data, "traffic upd", "", secret);
            return out;
        }

        /// Derive both the write key and IV from a traffic secret and return
        /// a ready-to-use RecordLayer. `key` selects the AEAD at runtime (the
        /// negotiated cipher suite), so a single arm serves all suites of its
        /// hash (e.g. SHA-256 covers AES-128-GCM and ChaCha20-Poly1305).
        pub fn makeRecordLayer(key: CipherSuite, prk: TrafficSecret) aead.Error!RecordLayer {
            var secret: Keyed = .init(&prk.data);
            defer secret.secureZero();
            return makeRecordLayerKeyed(key, &secret);
        }

        /// makeRecordLayer plus the RFC 8446 §4.4.4 finished key, for a
        /// handshake traffic secret: three expands under one keying.
        pub fn makeRecordLayerAndFinishedKey(
            key: CipherSuite,
            prk: TrafficSecret,
            finished_key: *FinishedKey,
        ) aead.Error!RecordLayer {
            var secret: Keyed = .init(&prk.data);
            defer secret.secureZero();
            expandLabelKeyed(&finished_key.data, "finished", "", &secret);
            return makeRecordLayerKeyed(key, &secret);
        }

        fn makeRecordLayerKeyed(key: CipherSuite, secret: *const Keyed) aead.Error!RecordLayer {
            var layer_aead: aead.Aead = undefined;
            defer layer_aead.secureZero();
            switch (key) {
                inline else => |k| {
                    layer_aead = @unionInit(aead.Aead, @tagName(k), undefined);
                    expandLabelKeyed(&@field(layer_aead, @tagName(k)).data, "key", "", secret);
                },
            }
            var iv: Iv = undefined;
            expandLabelKeyed(&iv.data, "iv", "", secret);
            return .init(layer_aead, iv);
        }

        /// RFC 8446 §4.4.4 — derive the finished key from a traffic secret.
        pub inline fn finishedKey(prk: TrafficSecret) FinishedKey {
            var out: FinishedKey = undefined;
            expandLabel(&out.data, "finished", "", prk);
            return out;
        }

        /// RFC 8446 §4.2.11.2 — compute a PSK binder: HMAC(finished_key,
        /// transcript_hash) over the truncated ClientHello prefix. The binder
        /// key is resumptionBinderKey(pskEarlySecret(psk)); the finished_key is
        /// finishedKey(binder_key). `transcript_hash` is Hash(prefix).
        pub fn binder(
            finished_key: FinishedKey,
            transcript_hash: *const TranscriptHash,
        ) [prk_len]u8 {
            var out: [prk_len]u8 = undefined;
            Keyed.create(&out, &transcript_hash.data, &finished_key.data);
            return out;
        }

        /// RFC 8446 §7.3 — derive the write key from a traffic secret.
        pub inline fn trafficKey(
            comptime key: CipherSuite,
            prk: TrafficSecret,
        ) @FieldType(aead.Aead, @tagName(key)) {
            var out: @FieldType(aead.Aead, @tagName(key)) = undefined;
            expandLabel(&out.data, "key", "", prk);
            return out;
        }

        /// RFC 8446 §7.3 — derive the write IV from a traffic secret.
        /// Always 12 bytes for all TLS 1.3 cipher suites.
        pub inline fn trafficIv(prk: TrafficSecret) Iv {
            var iv: Iv = undefined;
            expandLabel(&iv.data, "iv", "", prk);
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
    const binder_verify_data = HkdfSha256.binder(finished_key, &.init(binder_hash));
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

// RFC 8446 §7.1 — the comptime constants come from std (libcrypto cannot run
// at comptime), and every runtime derivation runs on the backend hash (#138).
// With a zero PSK, the runtime PSK early secret is the comptime early_secret,
// the backend Hash("") is the comptime "derived" context, and the runtime
// Derive-Secret(early_secret, "derived", "") is the comptime salt.
test "comptime std constants match the runtime backend hash" {
    inline for (.{
        .{ HkdfSha256, sha2.Sha256 },
        .{ HkdfSha384, sha2.Sha384 },
    }) |pair| {
        const H, const Hash = pair;
        const runtime_early = H.pskEarlySecret(H.prk_zero);
        try testing.expectEqualSlices(u8, &H.early_secret.data, &runtime_early.data);
        var runtime_empty: [H.prk_len]u8 = undefined;
        Hash.hash(&.{}, &runtime_empty, .{});
        try testing.expectEqualSlices(u8, &H.empty_hash.data, &runtime_empty);
        const runtime_derived = H.deriveSecret(runtime_early, "derived", &.init(runtime_empty));
        try testing.expectEqualSlices(u8, &H.early_derived.data, &runtime_derived.data);
    }
}

/// Independent HKDF-Expand-Label: std HKDF and HMAC over std SHA-2, with no
/// code from hmac.zig or the libcrypto backend.
fn referenceExpandLabel(
    comptime S: type,
    out: []u8,
    label: []const u8,
    context: []const u8,
    secret: *const [S.digest_length]u8,
) void {
    var info: [2 + 1 + 255 + 1 + 255]u8 = undefined;
    std.mem.writeInt(u16, info[0..2], @intCast(out.len), .big);
    info[2] = @intCast("tls13 ".len + label.len);
    @memcpy(info[3..][0.."tls13 ".len], "tls13 ");
    @memcpy(info[9..][0..label.len], label);
    info[9 + label.len] = @intCast(context.len);
    @memcpy(info[10 + label.len ..][0..context.len], context);
    const Ref = crypto.kdf.hkdf.Hkdf(crypto.auth.hmac.Hmac(S));
    Ref.expand(out, info[0 .. 10 + label.len + context.len], secret.*);
}

const sha256_suites = [_]CipherSuite{ .aes_128_gcm_sha256, .chacha20_poly1305_sha256 };
const hkdf_reference_pairs = .{
    .{ HkdfSha256, crypto.hash.sha2.Sha256, sha256_suites },
    .{ HkdfSha384, crypto.hash.sha2.Sha384, [_]CipherSuite{.aes_256_gcm_sha384} },
};

// RFC 8446 §7.1 — one keying per secret gives the same bytes as independent
// HKDF-Expand-Label calls. The label sets are the ones ztls derives from one
// secret: the handshake secret (c hs traffic, s hs traffic, derived), the
// master secret (c ap traffic, s ap traffic, exp master, res master), the
// early secret (binders, c e traffic, e exp master), a traffic secret
// (finished, key, iv, traffic upd), and the resumption master (resumption).
// A multi-block output covers RFC 5869 §2.3 chaining.
test "batched expands under one keying match independent HKDF-Expand-Label" {
    var prng: std.Random.DefaultPrng = .init(0x1383);
    const random = prng.random();
    inline for (hkdf_reference_pairs) |pair| {
        const H, const S, _ = pair;
        for (0..8) |_| {
            var secret: H.Prk = undefined;
            random.bytes(&secret.data);
            var th: H.TranscriptHash = undefined;
            random.bytes(&th.data);
            var key: H.Keyed = .init(&secret.data);
            defer key.secureZero();

            const transcript_labels = .{
                "c hs traffic", "s hs traffic", "c ap traffic", "s ap traffic",
                "exp master",   "res master",   "c e traffic",  "e exp master",
            };
            inline for (transcript_labels) |label| {
                var want: [H.prk_len]u8 = undefined;
                referenceExpandLabel(S, &want, label, &th.data, &secret.data);
                const got = H.deriveSecretKeyed(&key, label, &th);
                try testing.expectEqualSlices(u8, &want, &got.data);
            }
            inline for (.{ "derived", "ext binder", "res binder" }) |label| {
                var want: [H.prk_len]u8 = undefined;
                referenceExpandLabel(S, &want, label, &H.empty_hash.data, &secret.data);
                const got = H.deriveSecretKeyed(&key, label, &H.empty_hash);
                try testing.expectEqualSlices(u8, &want, &got.data);
            }
            inline for (.{
                .{ "finished", H.prk_len }, .{ "traffic upd", H.prk_len },
                .{ "key", 16 },             .{ "key", 32 },
                .{ "iv", 12 },              .{ "exporter", 3 * H.prk_len + 5 },
            }) |case| {
                var want: [case[1]]u8 = undefined;
                referenceExpandLabel(S, &want, case[0], "", &secret.data);
                var got: [case[1]]u8 = undefined;
                H.expandLabelKeyed(&got, case[0], "", &key);
                try testing.expectEqualSlices(u8, &want, &got);
            }
            var nonce: [8]u8 = undefined;
            random.bytes(&nonce);
            var want_psk: [H.prk_len]u8 = undefined;
            referenceExpandLabel(S, &want_psk, "resumption", &nonce, &secret.data);
            try testing.expectEqualSlices(u8, &want_psk, &H.resumptionPsk(secret, &nonce).data);
        }
    }
}

// RFC 8446 §7.3, §4.4.4 — the batched record-layer derivations install the
// write key and IV, and the finished key, that independent HKDF-Expand-Label
// calls produce, for every cipher suite of each hash.
test "batched record layer and finished key match independent HKDF-Expand-Label" {
    var prng: std.Random.DefaultPrng = .init(0x1384);
    inline for (hkdf_reference_pairs) |pair| {
        const H, const S, const suites = pair;
        inline for (suites) |suite| {
            if (backend.supportsCipherSuite(suite))
                try expectBatchedRecordLayer(H, S, suite, prng.random());
        }
    }
}

fn expectBatchedRecordLayer(
    comptime H: type,
    comptime S: type,
    comptime suite: CipherSuite,
    random: std.Random,
) !void {
    var secret: H.TrafficSecret = undefined;
    random.bytes(&secret.data);
    var want_key: @FieldType(aead.Aead, @tagName(suite)) = undefined;
    referenceExpandLabel(S, &want_key.data, "key", "", &secret.data);
    var want_iv: [12]u8 = undefined;
    referenceExpandLabel(S, &want_iv, "iv", "", &secret.data);
    var want_finished: [H.prk_len]u8 = undefined;
    referenceExpandLabel(S, &want_finished, "finished", "", &secret.data);

    var finished_key: H.FinishedKey = undefined;
    var both = try H.makeRecordLayerAndFinishedKey(suite, secret, &finished_key);
    defer both.deinit();
    var layer = try H.makeRecordLayer(suite, secret);
    defer layer.deinit();
    try testing.expectEqualSlices(u8, &want_finished, &finished_key.data);
    for ([_]*const RecordLayer{ &both, &layer }) |l| {
        try testing.expectEqualSlices(u8, &want_key.data, &@field(l.aead, @tagName(suite)).data);
        try testing.expectEqualSlices(u8, &want_iv, &l.iv.data);
    }
}

// RFC 8446 §7.1 — handshakeSecretFor matches the unbatched schedule, with
// and without a PSK. Without one it extracts under the comptime salt.
test "handshakeSecretFor matches handshakeSecret over the early secret" {
    const dhe: [48]u8 = @splat(0x5a);
    const psk: [32]u8 = @splat(0xa5);
    inline for (.{ HkdfSha256, HkdfSha384 }) |H| {
        try testing.expectEqualSlices(
            u8,
            &H.handshakeSecret(H.early_secret, &dhe).data,
            &H.handshakeSecretFor(null, &dhe).data,
        );
        try testing.expectEqualSlices(
            u8,
            &H.handshakeSecret(H.pskEarlySecret(&psk), &dhe).data,
            &H.handshakeSecretFor(&psk, &dhe).data,
        );
    }
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
