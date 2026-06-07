const std = @import("std");

pub const alert = @import("alert.zig");
pub const aead = @import("aead.zig");
pub const client_hello = @import("client_hello.zig");
pub const ClientHandshake = @import("ClientHandshake.zig");
pub const hkdf = @import("hkdf.zig");
pub const kex = @import("kex.zig");
pub const nonce = @import("nonce.zig");
pub const RecordLayer = @import("RecordLayer.zig");
pub const RecordBuffer = @import("RecordBuffer.zig");
pub const certificate = @import("certificate.zig");
pub const certificate_request = @import("certificate_request.zig");
pub const encrypted_extensions = @import("encrypted_extensions.zig");
pub const finished = @import("finished.zig");
pub const frame = @import("frame.zig");
pub const new_session_ticket = @import("new_session_ticket.zig");
pub const server_hello = @import("server_hello.zig");
pub const transcript = @import("transcript.zig");
pub const signature = @import("signature.zig");
pub const ServerHandshake = @import("ServerHandshake.zig");
pub const wire = @import("wire.zig");
pub const x25519 = @import("x25519.zig");

/// RFC 8446 Appendix B.4
pub const CipherSuite = enum(u16) {
    aes_128_gcm_sha256 = 0x1301,
    chacha20_poly1305_sha256 = 0x1303,
    aes_256_gcm_sha384 = 0x1302,
};

test {
    std.testing.refAllDeclsRecursive(@This());
}
