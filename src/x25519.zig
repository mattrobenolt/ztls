/// X25519 ephemeral key exchange for TLS 1.3.
///
/// RFC 8446 §4.2.8.2, RFC 7748
const std = @import("std");
const X25519 = std.crypto.dh.X25519;
const memx = @import("memx.zig");
const hkdf = @import("hkdf.zig");

pub const PublicKey = memx.Array(X25519.public_length);
pub const SecretKey = memx.Array(X25519.secret_length);

pub const KeyPair = struct {
    public_key: PublicKey,
    secret_key: SecretKey,

    /// Generate a random ephemeral key pair.
    pub fn generate() KeyPair {
        const kp = X25519.KeyPair.generate();
        return .{
            .public_key = .init(kp.public_key),
            .secret_key = .init(kp.secret_key),
        };
    }

    /// Compute the X25519 shared secret from our secret key and the peer's public key.
    /// The result feeds directly into hkdf.handshakeSecret as the DHE input.
    ///
    /// RFC 8446 §7.4.2
    pub fn sharedSecret(self: KeyPair, peer_public_key: *const PublicKey) !hkdf.SharedSecret {
        const raw = try X25519.scalarmult(self.secret_key.data, peer_public_key.data);
        return .init(raw);
    }
};
