//! X25519 ephemeral key exchange for TLS 1.3.
//!
//! RFC 8446 §4.2.8.2, RFC 7748
const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;

const backend = @import("crypto/backend.zig");
const memx = @import("memx.zig");
const hex = memx.hex;

pub const public_length = 32;
pub const secret_length = 32;

pub const PublicKey = memx.Array(public_length);
pub const SecretKey = memx.Array(secret_length);

pub const Error = backend.x25519.Error;

/// Caller-owned X25519 keypair. The secret key is the raw 32-byte scalar input;
/// the libcrypto backend performs RFC 7748 clamping internally.
pub const KeyPair = struct {
    secret_key: SecretKey,
    public_key: PublicKey,

    pub fn generate() KeyPair {
        var secret_key: [secret_length]u8 = undefined;
        std.crypto.random.bytes(&secret_key);
        return generateDeterministic(.init(secret_key)) catch unreachable;
    }

    pub fn generateDeterministic(seed: SecretKey) Error!KeyPair {
        return .{ .secret_key = seed, .public_key = try publicFromSecret(seed) };
    }
};

fn privateKey(secret_key: SecretKey) Error!*backend.x25519.pkey {
    return backend.x25519.privateKeyFromSecret(&secret_key.data);
}

fn publicKey(public_key: PublicKey) Error!*backend.x25519.pkey {
    return backend.x25519.publicKeyFromRaw(&public_key.data);
}

fn publicFromSecret(secret_key: SecretKey) Error!PublicKey {
    const key = try privateKey(secret_key);
    defer backend.x25519.freeKey(key);

    return .init(try backend.x25519.rawPublicKeyFromPrivate(key));
}

/// Compute the X25519 shared secret from our secret key and the peer's public key.
/// The result feeds directly into hkdf.handshakeSecret as the DHE input.
///
/// RFC 8446 §7.4.2
pub fn sharedSecret(secret_key: SecretKey, peer_public_key: PublicKey) Error![secret_length]u8 {
    const ours = try privateKey(secret_key);
    defer backend.x25519.freeKey(ours);
    const peer = try publicKey(peer_public_key);
    defer backend.x25519.freeKey(peer);

    var secret: [secret_length]u8 = undefined;
    try backend.x25519.sharedSecretDerive(ours, peer, &secret);
    return secret;
}

// RFC 7748 §5.2 — X25519 scalar multiplication test vector.
test "sharedSecret: RFC 7748 X25519 vector" {
    const scalar: SecretKey = .init(
        hex(32, "a546e36bf0527c9d3b16154b82465edd62144c0ac1fc5a18506a2244ba449ac4"),
    );
    const peer: PublicKey = .init(
        hex(32, "e6db6867583030db3594c1a424b15f7c726624ec26b3353b10a903a6d0ab1c4c"),
    );
    const secret = try sharedSecret(scalar, peer);
    const want = hex(32, "c3da55379de9c6908e94ea4df28d084f32eccf03491c71f754b4075577a28552");
    try testing.expectEqualSlices(u8, &want, &secret);
}

// RFC 7748 §6.1 — X25519 public keys are scalar multiplication by base point 9.
test "KeyPair.generateDeterministic: RFC 7748 public keys" {
    const alice_seed = hex(32, "77076d0a7318a57d3c16c17251b26645df4c2f87ebc0992ab177fba51db92c2a");
    const alice = try KeyPair.generateDeterministic(.init(alice_seed));
    const alice_pub = hex(32, "8520f0098930a754748b7ddcb43ef75a0dbf3a0d26381af4eba4a98eaa9b4e6a");
    try testing.expectEqualSlices(u8, &alice_pub, &alice.public_key.data);

    const bob_seed = hex(32, "5dab087e624a8a4b79e17f8b83800ee66f3bb1292618b6fd1c2f8b27ff88e0eb");
    const bob = try KeyPair.generateDeterministic(.init(bob_seed));
    const bob_pub = hex(32, "de9edb7d7b7dc1b4d35b61c2ece435373f8343c85b78674dadfc7e146f882b4f");
    try testing.expectEqualSlices(u8, &bob_pub, &bob.public_key.data);
}

comptime {
    assert(@sizeOf(PublicKey) == public_length);
    assert(@sizeOf(SecretKey) == secret_length);
}
