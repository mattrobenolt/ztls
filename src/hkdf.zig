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

const Iv = @import("nonce.zig").Iv;
const memx = @import("memx.zig");

/// TLS_AES_128_GCM_SHA256 and TLS_CHACHA20_POLY1305_SHA256.
pub const HkdfSha256 = Hkdf(HmacSha256);

/// TLS_AES_256_GCM_SHA384.
pub const HkdfSha384 = Hkdf(HmacSha384);

fn Hkdf(comptime Hmac: type) type {
    const H = crypto.kdf.hkdf.Hkdf(Hmac);

    return struct {
        /// Length of the pseudorandom key and all derived secrets.
        pub const prk_len = H.prk_length;
        pub const Prk = [prk_len]u8;

        comptime {
            assert(prk_len == 32 or prk_len == 48);
        }

        /// RFC 8446 §7.1 — HKDF-Extract.
        pub fn extract(salt: []const u8, ikm: []const u8) Prk {
            return H.extract(salt, ikm);
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
            const buf_len = length_field + label_len_field + full_label.len + context_len_field + max_context_len;
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

            H.expand(out, buf[0..pos], prk);
        }

        // Hash("") — used as the transcript context for the "derived" steps
        // between key schedule levels. RFC 8446 §7.1: Derive-Secret(., "derived", "")
        // uses Transcript-Hash of empty input = Hash("").
        const empty_hash: Prk = blk: {
            @setEvalBranchQuota(100_000);
            var out: Prk = undefined;
            const S = switch (prk_len) {
                32 => Sha256,
                48 => Sha384,
                else => unreachable,
            };
            S.hash(&.{}, &out, .{});
            break :blk out;
        };

        /// EarlySecret for a full handshake with no PSK.
        /// Salt and IKM are both zero — comptime constant per RFC 8446 §7.1.
        pub const early_secret: Prk = blk: {
            @setEvalBranchQuota(100_000);
            const zero: Prk = @splat(0);
            break :blk H.extract(&zero, &zero);
        };

        /// RFC 8446 §7.1 — Derive-Secret.
        ///
        /// Expands `secret` using `label` and a transcript hash as context.
        /// Output is always `prk_len` bytes (the hash output length).
        pub fn deriveSecret(secret: Prk, comptime label: []const u8, transcript_hash: []const u8) Prk {
            var out: Prk = undefined;
            expandLabel(&out, label, transcript_hash, secret);
            return out;
        }

        /// RFC 8446 §7.1 — HandshakeSecret.
        ///
        /// Mixes the DHE shared secret into the key schedule.
        /// `dhe` is the raw ECDH output (32 bytes for X25519/P-256).
        pub fn handshakeSecret(early: Prk, dhe: []const u8) Prk {
            const salt = deriveSecret(early, "derived", &empty_hash);
            return H.extract(&salt, dhe);
        }

        /// RFC 8446 §7.1 — MasterSecret.
        ///
        /// No new key material at this stage; IKM is zero.
        pub fn masterSecret(handshake: Prk) Prk {
            const salt = deriveSecret(handshake, "derived", &empty_hash);
            const zero: Prk = @splat(0);
            return H.extract(&salt, &zero);
        }

        // RFC 8446 §7.1 — traffic secrets from HandshakeSecret.

        pub fn clientHandshakeTrafficSecret(handshake: Prk, transcript_hash: []const u8) Prk {
            return deriveSecret(handshake, "c hs traffic", transcript_hash);
        }

        pub fn serverHandshakeTrafficSecret(handshake: Prk, transcript_hash: []const u8) Prk {
            return deriveSecret(handshake, "s hs traffic", transcript_hash);
        }

        // RFC 8446 §7.1 — traffic secrets from MasterSecret.

        pub fn clientApplicationTrafficSecret(master: Prk, transcript_hash: []const u8) Prk {
            return deriveSecret(master, "c ap traffic", transcript_hash);
        }

        pub fn serverApplicationTrafficSecret(master: Prk, transcript_hash: []const u8) Prk {
            return deriveSecret(master, "s ap traffic", transcript_hash);
        }

        /// RFC 8446 §7.3 — derive the write key from a traffic secret.
        /// `out.len` must match the AEAD key length for the cipher suite.
        pub fn trafficKey(prk: Prk, out: []u8) void {
            expandLabel(out, "key", "", prk);
        }

        /// RFC 8446 §7.3 — derive the write IV from a traffic secret.
        /// Always 12 bytes for all TLS 1.3 cipher suites.
        pub fn trafficIv(prk: Prk) Iv {
            var iv: Iv = undefined;
            expandLabel(&iv, "iv", "", prk);
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
//   fe927ae271312e8bf0275b581c54eef020450dc4ecffaa05a1a35d27518e7803
// Expected:
//   server_write_key: 27c6bdc0a3dcea39a47326d79bc9e4ee  (16 bytes)
//   server_write_iv:  9569ecdd4d0536705e9ef725          (12 bytes)

test "HkdfSha256.trafficKey: RFC 8448 §3 server handshake" {
    const secret: HkdfSha256.Prk = .{
        0xfe, 0x92, 0x7a, 0xe2, 0x71, 0x31, 0x2e, 0x8b,
        0xf0, 0x27, 0x5b, 0x58, 0x1c, 0x54, 0xee, 0xf0,
        0x20, 0x45, 0x0d, 0xc4, 0xec, 0xff, 0xaa, 0x05,
        0xa1, 0xa3, 0x5d, 0x27, 0x51, 0x8e, 0x78, 0x03,
    };

    var key: [16]u8 = undefined;
    HkdfSha256.trafficKey(secret, &key);
    try testing.expectEqualSlices(u8, &.{
        0x27, 0xc6, 0xbd, 0xc0, 0xa3, 0xdc, 0xea, 0x39,
        0xa4, 0x73, 0x26, 0xd7, 0x9b, 0xc9, 0xe4, 0xee,
    }, &key);
}

test "HkdfSha256.trafficIv: RFC 8448 §3 server handshake" {
    const secret: HkdfSha256.Prk = .{
        0xfe, 0x92, 0x7a, 0xe2, 0x71, 0x31, 0x2e, 0x8b,
        0xf0, 0x27, 0x5b, 0x58, 0x1c, 0x54, 0xee, 0xf0,
        0x20, 0x45, 0x0d, 0xc4, 0xec, 0xff, 0xaa, 0x05,
        0xa1, 0xa3, 0x5d, 0x27, 0x51, 0x8e, 0x78, 0x03,
    };

    const iv = HkdfSha256.trafficIv(secret);
    try testing.expectEqualSlices(u8, &.{
        0x95, 0x69, 0xec, 0xdd, 0x4d, 0x05, 0x36, 0x70,
        0x5e, 0x9e, 0xf7, 0x25,
    }, &iv);
}

// RFC 8446 §7.1 — key schedule
// All vectors from RFC 8448 §3 (simple 1-RTT handshake, X25519, TLS_AES_128_GCM_SHA256).
// https://www.rfc-editor.org/rfc/rfc8448

test "HkdfSha256.earlySecret: RFC 8448 §3" {
    const early = HkdfSha256.early_secret;
    try testing.expectEqualSlices(u8, &.{
        0x33, 0xad, 0x0a, 0x1c, 0x60, 0x7e, 0xc0, 0x3b,
        0x09, 0xe6, 0xcd, 0x98, 0x93, 0x68, 0x0c, 0xe2,
        0x10, 0xad, 0xf3, 0x00, 0xaa, 0x1f, 0x26, 0x60,
        0xe1, 0xb2, 0x2e, 0x10, 0xf1, 0x70, 0xf9, 0x2a,
    }, &early);
}

test "HkdfSha256.handshakeSecret: RFC 8448 §3" {
    const early = HkdfSha256.early_secret;
    // X25519 shared secret from RFC 8448 §3
    const dhe: [32]u8 = .{
        0x8b, 0xd4, 0x05, 0x4f, 0xb5, 0x5b, 0x9d, 0x63,
        0xfd, 0xfb, 0xac, 0xf9, 0xf0, 0x4b, 0x9f, 0x0d,
        0x35, 0xe6, 0xd6, 0x3f, 0x53, 0x75, 0x63, 0xef,
        0xd4, 0x62, 0x72, 0x90, 0x0f, 0x89, 0x49, 0x2d,
    };
    const handshake = HkdfSha256.handshakeSecret(early, &dhe);
    try testing.expectEqualSlices(u8, &.{
        0x1d, 0xc8, 0x26, 0xe9, 0x36, 0x06, 0xaa, 0x6f,
        0xdc, 0x0a, 0xad, 0xc1, 0x2f, 0x74, 0x1b, 0x01,
        0x04, 0x6a, 0xa6, 0xb9, 0x9f, 0x69, 0x1e, 0xd2,
        0x21, 0xa9, 0xf0, 0xca, 0x04, 0x3f, 0xbe, 0xac,
    }, &handshake);
}

test "HkdfSha256.masterSecret: RFC 8448 §3" {
    const early = HkdfSha256.early_secret;
    const dhe: [32]u8 = .{
        0x8b, 0xd4, 0x05, 0x4f, 0xb5, 0x5b, 0x9d, 0x63,
        0xfd, 0xfb, 0xac, 0xf9, 0xf0, 0x4b, 0x9f, 0x0d,
        0x35, 0xe6, 0xd6, 0x3f, 0x53, 0x75, 0x63, 0xef,
        0xd4, 0x62, 0x72, 0x90, 0x0f, 0x89, 0x49, 0x2d,
    };
    const handshake = HkdfSha256.handshakeSecret(early, &dhe);
    const master = HkdfSha256.masterSecret(handshake);
    try testing.expectEqualSlices(u8, &.{
        0x18, 0xdf, 0x06, 0x84, 0x3d, 0x13, 0xa0, 0x8b,
        0xf2, 0xa4, 0x49, 0x84, 0x4c, 0x5f, 0x8a, 0x47,
        0x80, 0x01, 0xbc, 0x4d, 0x4c, 0x62, 0x79, 0x84,
        0xd5, 0xa4, 0x1d, 0xa8, 0xd0, 0x40, 0x29, 0x19,
    }, &master);
}

test "HkdfSha256.clientHandshakeTrafficSecret: RFC 8448 §3" {
    const early = HkdfSha256.early_secret;
    const dhe: [32]u8 = .{
        0x8b, 0xd4, 0x05, 0x4f, 0xb5, 0x5b, 0x9d, 0x63,
        0xfd, 0xfb, 0xac, 0xf9, 0xf0, 0x4b, 0x9f, 0x0d,
        0x35, 0xe6, 0xd6, 0x3f, 0x53, 0x75, 0x63, 0xef,
        0xd4, 0x62, 0x72, 0x90, 0x0f, 0x89, 0x49, 0x2d,
    };
    // Transcript hash: SHA-256(ClientHello || ServerHello)
    const transcript_hash: [32]u8 = .{
        0x86, 0x0c, 0x06, 0xed, 0xc0, 0x78, 0x58, 0xee,
        0x8e, 0x78, 0xf0, 0xe7, 0x42, 0x8c, 0x58, 0xed,
        0xd6, 0xb4, 0x3f, 0x2c, 0xa3, 0xe6, 0xe9, 0x5f,
        0x02, 0xed, 0x06, 0x3c, 0xf0, 0xe1, 0xca, 0xd8,
    };
    const handshake = HkdfSha256.handshakeSecret(early, &dhe);
    const secret = HkdfSha256.clientHandshakeTrafficSecret(handshake, &transcript_hash);
    try testing.expectEqualSlices(u8, &.{
        0xb3, 0xed, 0xdb, 0x12, 0x6e, 0x06, 0x7f, 0x35,
        0xa7, 0x80, 0xb3, 0xab, 0xf4, 0x5e, 0x2d, 0x8f,
        0x3b, 0x1a, 0x95, 0x07, 0x38, 0xf5, 0x2e, 0x96,
        0x00, 0x74, 0x6a, 0x0e, 0x27, 0xa5, 0x5a, 0x21,
    }, &secret);
}

test "HkdfSha256.serverHandshakeTrafficSecret: RFC 8448 §3" {
    const early = HkdfSha256.early_secret;
    const dhe: [32]u8 = .{
        0x8b, 0xd4, 0x05, 0x4f, 0xb5, 0x5b, 0x9d, 0x63,
        0xfd, 0xfb, 0xac, 0xf9, 0xf0, 0x4b, 0x9f, 0x0d,
        0x35, 0xe6, 0xd6, 0x3f, 0x53, 0x75, 0x63, 0xef,
        0xd4, 0x62, 0x72, 0x90, 0x0f, 0x89, 0x49, 0x2d,
    };
    const transcript_hash: [32]u8 = .{
        0x86, 0x0c, 0x06, 0xed, 0xc0, 0x78, 0x58, 0xee,
        0x8e, 0x78, 0xf0, 0xe7, 0x42, 0x8c, 0x58, 0xed,
        0xd6, 0xb4, 0x3f, 0x2c, 0xa3, 0xe6, 0xe9, 0x5f,
        0x02, 0xed, 0x06, 0x3c, 0xf0, 0xe1, 0xca, 0xd8,
    };
    const handshake = HkdfSha256.handshakeSecret(early, &dhe);
    const secret = HkdfSha256.serverHandshakeTrafficSecret(handshake, &transcript_hash);
    try testing.expectEqualSlices(u8, &.{
        0xb6, 0x7b, 0x7d, 0x69, 0x0c, 0xc1, 0x6c, 0x4e,
        0x75, 0xe5, 0x42, 0x13, 0xcb, 0x2d, 0x37, 0xb4,
        0xe9, 0xc9, 0x12, 0xbc, 0xde, 0xd9, 0x10, 0x5d,
        0x42, 0xbe, 0xfd, 0x59, 0xd3, 0x91, 0xad, 0x38,
    }, &secret);
}
