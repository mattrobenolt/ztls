//! TLS 1.3 cipher suite identifiers.
const std = @import("std");
const testing = std.testing;

pub const CipherSuite = enum(u16) {
    aes_128_gcm_sha256 = 0x1301,
    chacha20_poly1305_sha256 = 0x1303,
    aes_256_gcm_sha384 = 0x1302,

    pub fn fromWire(value: u16) ?CipherSuite {
        return std.enums.fromInt(CipherSuite, value);
    }
};

// RFC 8446 Appendix B.4 — TLS 1.3 cipher suite code points.
test "CipherSuite wire values" {
    try testing.expectEqual(@as(u16, 0x1301), @intFromEnum(CipherSuite.aes_128_gcm_sha256));
    try testing.expectEqual(@as(u16, 0x1302), @intFromEnum(CipherSuite.aes_256_gcm_sha384));
    try testing.expectEqual(@as(u16, 0x1303), @intFromEnum(CipherSuite.chacha20_poly1305_sha256));
}
