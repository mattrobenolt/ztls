const std = @import("std");

pub const aead = @import("aead.zig");
pub const alert = @import("alert.zig");
pub const certificate = @import("certificate.zig");
pub const certificate_chain = @import("certificate_chain.zig");
pub const CertificateChain = certificate_chain.CertificateChain;
pub const client_hello = @import("client_hello.zig");
pub const ClientHandshake = @import("ClientHandshake.zig");
pub const frame = @import("frame.zig");
pub const hkdf = @import("hkdf.zig");
pub const kex = @import("kex.zig");
const memx = @import("memx.zig");
pub const RecordBuffer = @import("RecordBuffer.zig");
pub const RecordLayer = @import("RecordLayer.zig");
pub const server_hello = @import("server_hello.zig");
pub const ServerHandshake = @import("ServerHandshake.zig");
pub const signature = @import("signature.zig");
pub const SignatureScheme = @import("signature_scheme.zig").SignatureScheme;
pub const x25519 = @import("x25519.zig");

/// RFC 8446 §4.1.2 — ClientHello random bytes.
pub const Random = memx.Array(32);

/// RFC 8446 Appendix B.4
pub const CipherSuite = enum(u16) {
    aes_128_gcm_sha256 = 0x1301,
    chacha20_poly1305_sha256 = 0x1303,
    aes_256_gcm_sha384 = 0x1302,

    pub fn aeadKeys(self: CipherSuite) aead.Keys {
        return switch (self) {
            .aes_128_gcm_sha256 => .aes128_gcm,
            .chacha20_poly1305_sha256 => .chacha20_poly1305,
            .aes_256_gcm_sha384 => .aes256_gcm,
        };
    }
};

test {
    std.testing.refAllDeclsRecursive(@This());
}
