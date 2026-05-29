const std = @import("std");

/// RFC 8446 Appendix B.4
pub const CipherSuite = enum(u16) {
    aes_128_gcm_sha256 = 0x1301,
    chacha20_poly1305_sha256 = 0x1303,
    aes_256_gcm_sha384 = 0x1302,
};

pub const aead = @import("aead.zig");
pub const hkdf = @import("hkdf.zig");
pub const nonce = @import("nonce.zig");
const frame = @import("frame.zig");
pub const x25519 = @import("x25519.zig");
pub const client_hello = @import("client_hello.zig");
pub const server_hello = @import("server_hello.zig");
pub const wire = @import("wire.zig");
pub const RecordLayer = @import("RecordLayer.zig");

test {
    std.testing.refAllDeclsRecursive(@This());
}
