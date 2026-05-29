/// X25519 ephemeral key exchange for TLS 1.3.
///
/// RFC 8446 §4.2.8.2, RFC 7748
const std = @import("std");
const X25519 = std.crypto.dh.X25519;
/// Re-export the stdlib KeyPair directly. Use KeyPair.generate() to create
/// an ephemeral key pair for a handshake.
pub const KeyPair = X25519.KeyPair;

const hkdf = @import("hkdf.zig");
const memx = @import("memx.zig");

pub const PublicKey = memx.Array(X25519.public_length);
pub const SecretKey = memx.Array(X25519.secret_length);

/// Compute the X25519 shared secret from our secret key and the peer's public key.
/// The result feeds directly into hkdf.handshakeSecret as the DHE input.
///
/// RFC 8446 §7.4.2
pub fn sharedSecret(secret_key: [X25519.secret_length]u8, peer_public_key: PublicKey) !hkdf.SharedSecret {
    return .init(try X25519.scalarmult(secret_key, peer_public_key.data));
}
