/// TLS 1.3 HKDF key derivation.
///
/// Wraps std.crypto.kdf.hkdf with TLS 1.3-specific label expansion per
/// RFC 8446 §7.1 and §7.3.
const std = @import("std");
const assert = std.debug.assert;
const crypto = std.crypto;
const sha2 = crypto.auth.hmac.sha2;
const HmacSha256 = sha2.HmacSha256;
const HmacSha384 = sha2.HmacSha384;
const testing = std.testing;

const Iv = @import("nonce.zig").Iv;
const memx = @import("memx.zig");

/// TLS_AES_128_GCM_SHA256 and TLS_CHACHA20_POLY1305_SHA256.
pub const HkdfSha256 = Hkdf(HmacSha256);

/// TLS_AES_256_GCM_SHA384.
pub const HkdfSha384 = Hkdf(HmacSha384);

pub fn Hkdf(comptime Hmac: type) type {
    const H = crypto.kdf.hkdf.Hkdf(Hmac);

    return struct {
        /// Length of the pseudorandom key and all derived secrets.
        pub const prk_len = H.prk_length;
        pub const Prk = [prk_len]u8;

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
            comptime assert(6 + label.len <= 255);
            assert(context.len <= 255);
            assert(out.len <= 0xffff);

            // HkdfLabel wire encoding (RFC 8446 §7.1):
            //   uint16 length
            //   opaque label<7..255>  = "tls13 " + label
            //   opaque context<0..255>
            const full_label = "tls13 " ++ label;
            const length_field = @sizeOf(u16);
            const label_len_field = @sizeOf(u8);
            const context_len_field = @sizeOf(u8);
            const max_context_len = 255;
            var buf: [length_field + label_len_field + full_label.len + context_len_field + max_context_len]u8 = undefined;
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
