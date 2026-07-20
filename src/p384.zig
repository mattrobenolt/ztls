//! secp384r1 (P-384) ephemeral key exchange for TLS 1.3.
//!
//! RFC 8446 §4.2.8.2; RFC 8422 §5.1.1
const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;

const backend = @import("crypto/backend.zig");
pub const Error = backend.p384.Error;
const entropy = @import("entropy.zig");
const memx = @import("memx.zig");
const hex = memx.hex;

pub const public_length = 97;
pub const secret_length = 48;

pub const PublicKey = memx.Array(public_length);
pub const SecretKey = memx.Array(secret_length);

/// Caller-owned P-384 keypair. The public key is SEC1 uncompressed form:
/// 0x04 || X || Y (97 bytes for P-384).
pub const KeyPair = struct {
    secret_key: SecretKey,
    public_key: PublicKey,

    /// Generate a keypair using the OS CSPRNG. Aborts if the CSPRNG is
    /// unavailable (see `entropy.fill`); use `generateDeterministic` with your
    /// own seed if you need to own entropy or handle failure.
    pub fn generate() KeyPair {
        while (true) {
            var secret_key: [secret_length]u8 = undefined;
            entropy.fill(&secret_key);
            return generateDeterministic(.init(secret_key)) catch continue;
        }
    }

    pub fn generateDeterministic(seed: SecretKey) Error!KeyPair {
        return .{ .secret_key = seed, .public_key = try publicFromSecret(seed) };
    }
};

fn privateKey(secret_key: SecretKey) Error!*backend.p384.pkey {
    return backend.p384.privateKeyFromSecret(&secret_key.data);
}

fn publicKey(public_key: PublicKey) Error!*backend.p384.pkey {
    return backend.p384.publicKeyFromRaw(&public_key.data);
}

fn publicFromSecret(secret_key: SecretKey) Error!PublicKey {
    const key = try privateKey(secret_key);
    defer backend.p384.freeKey(key);

    return .init(try backend.p384.rawPublicKeyFromPrivate(key));
}

/// Compute the P-384 ECDHE shared secret from our scalar and the peer's SEC1
/// uncompressed public point. The result is the 48-byte x-coordinate used as
/// TLS 1.3 DHE input.
///
/// RFC 8446 §7.4.2
pub fn sharedSecret(secret_key: SecretKey, peer_public_key: PublicKey) Error!SecretKey.Data {
    const ours = try privateKey(secret_key);
    defer backend.p384.freeKey(ours);
    const peer = try publicKey(peer_public_key);
    defer backend.p384.freeKey(peer);

    var secret: SecretKey.Data = undefined;
    try backend.p384.sharedSecretDerive(ours, peer, &secret);
    return secret;
}

const test_seed_a = hex(48, "000102030405060708090a0b0c0d0e0f" ++
    "101112131415161718191a1b1c1d1e1f" ++
    "202122232425262728292a2b2c2d2e2f");
const test_seed_b = hex(48, "303132333435363738393a3b3c3d3e3f" ++
    "404142434445464748494a4b4c4d4e4f" ++
    "505152535455565758595a5b5c5d5e5f");

// SEC 1 / RFC 8446 §4.2.8.2 — P-384 key shares use uncompressed points.
test "KeyPair.generateDeterministic emits uncompressed SEC1 public key" {
    const keypair: KeyPair = try .generateDeterministic(.init(test_seed_a));
    try testing.expectEqual(@as(u8, 0x04), keypair.public_key.data[0]);
    try testing.expectEqual(@as(usize, 97), keypair.public_key.data.len);
}

// RFC 8446 §7.4.2 — two deterministic P-384 keypairs must agree on the shared
// secret (the x-coordinate of the ECDH point).
test "sharedSecret: P-384 deterministic peers agree" {
    const alice: KeyPair = try .generateDeterministic(.init(test_seed_a));
    const bob: KeyPair = try .generateDeterministic(.init(test_seed_b));

    const alice_secret = try sharedSecret(alice.secret_key, bob.public_key);
    const bob_secret = try sharedSecret(bob.secret_key, alice.public_key);
    try testing.expectEqualSlices(u8, &alice_secret, &bob_secret);
}

// RFC 8446 §4.2.8.2 — peers must reject malformed public keys for the group.
test "sharedSecret: rejects compressed P-384 point" {
    const alice: KeyPair = try .generateDeterministic(.init(test_seed_a));
    var compressed: [public_length]u8 = @splat(0);
    compressed[0] = 0x02;
    try testing.expectError(
        error.IdentityElement,
        sharedSecret(alice.secret_key, .init(compressed)),
    );
}

comptime {
    assert(@sizeOf(PublicKey) == public_length);
    assert(@sizeOf(SecretKey) == secret_length);
}
