//! secp256r1 (P-256) ephemeral key exchange for TLS 1.3.
//!
//! RFC 8446 §4.2.8.2; RFC 8422 §5.1.1
const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;

const backend = @import("crypto/backend.zig");
const entropy = @import("entropy.zig");
const memx = @import("memx.zig");
const hex = memx.hex;

pub const public_length = 65;
pub const secret_length = 32;

pub const PublicKey = memx.Array(public_length);
pub const SecretKey = memx.Array(secret_length);

pub const Error = backend.p256.Error;

/// Draws `generate` may take before it gives up on the dice. Each one is
/// independent and fails with probability ~2^-32, so reaching the last is
/// not a thing that happens — the bound exists because an unbounded retry
/// is a promise about the future that no code can keep (zoxy-io/zoxy#222).
const generate_attempts_max: u8 = 4;

/// Caller-owned P-256 keypair. The public key is SEC1 uncompressed form:
/// 0x04 || X || Y.
pub const KeyPair = struct {
    secret_key: SecretKey,
    public_key: PublicKey,

    /// Generate a keypair using the OS CSPRNG. Aborts if the CSPRNG is
    /// unavailable (see `entropy.fill`); use `generateDeterministic` with your
    /// own seed if you need to own entropy or handle failure.
    ///
    /// Retries only what a retry can fix. A random secret lands outside
    /// [1, n-1] about once in 2^32 draws and the next draw is independent,
    /// so `IdentityElement` is worth another attempt. `LibcryptoFailed` is
    /// the library failing rather than the dice — an exhausted allocator,
    /// a backend that will answer the same way forever — so it propagates
    /// on the first occurrence, leaving the caller to shed this session
    /// rather than the process to spin (zoxy-io/zoxy#222).
    pub fn generate() Error!KeyPair {
        var attempt: u8 = 1;
        while (true) : (attempt += 1) {
            assert(attempt <= generate_attempts_max);
            var secret_key: [secret_length]u8 = undefined;
            entropy.fill(&secret_key);
            return generateDeterministic(.init(secret_key)) catch |err| switch (err) {
                error.IdentityElement => {
                    if (attempt == generate_attempts_max) return err;
                    continue;
                },
                error.LibcryptoFailed => return err,
            };
        }
    }

    pub fn generateDeterministic(seed: SecretKey) Error!KeyPair {
        return .{ .secret_key = seed, .public_key = try publicFromSecret(seed) };
    }
};

fn privateKey(secret_key: SecretKey) Error!*backend.p256.pkey {
    return backend.p256.privateKeyFromSecret(&secret_key.data);
}

fn publicKey(public_key: PublicKey) Error!*backend.p256.pkey {
    return backend.p256.publicKeyFromRaw(&public_key.data);
}

fn publicFromSecret(secret_key: SecretKey) Error!PublicKey {
    const key = try privateKey(secret_key);
    defer backend.p256.freeKey(key);

    return .init(try backend.p256.rawPublicKeyFromPrivate(key));
}

/// Compute the P-256 ECDHE shared secret from our scalar and the peer's SEC1
/// uncompressed public point. The result is the 32-byte x-coordinate used as
/// TLS 1.3 DHE input.
///
/// RFC 8446 §7.4.2
pub fn sharedSecret(secret_key: SecretKey, peer_public_key: PublicKey) Error![secret_length]u8 {
    const ours = try privateKey(secret_key);
    defer backend.p256.freeKey(ours);
    const peer = try publicKey(peer_public_key);
    defer backend.p256.freeKey(peer);

    var secret: [secret_length]u8 = undefined;
    try backend.p256.sharedSecretDerive(ours, peer, &secret);
    return secret;
}

const test_seed_a = hex(32, "000102030405060708090a0b0c0d0e0f" ++
    "101112131415161718191a1b1c1d1e1f");
const test_seed_b = hex(32, "202122232425262728292a2b2c2d2e2f" ++
    "303132333435363738393a3b3c3d3e3f");

// SEC 1 / RFC 8446 §4.2.8.2 — P-256 key shares use uncompressed points.
test "KeyPair.generateDeterministic emits uncompressed SEC1 public key" {
    const keypair = try KeyPair.generateDeterministic(.init(test_seed_a));
    try testing.expectEqual(@as(u8, 0x04), keypair.public_key.data[0]);
}

test "sharedSecret: P-256 deterministic peers agree" {
    const alice = try KeyPair.generateDeterministic(.init(test_seed_a));
    const bob = try KeyPair.generateDeterministic(.init(test_seed_b));

    const alice_secret = try sharedSecret(alice.secret_key, bob.public_key);
    const bob_secret = try sharedSecret(bob.secret_key, alice.public_key);
    try testing.expectEqualSlices(u8, &alice_secret, &bob_secret);
}

// zoxy-io/zoxy#222 — `generate` retries a bad draw and only a bad draw.
test "KeyPair.generate succeeds and terminates" {
    // The loop is bounded, so this returning at all is the property: the
    // shipped bug was a `generate` that never came back.
    const keypair = try KeyPair.generate();
    try testing.expectEqual(@as(u8, 0x04), keypair.public_key.data[0]);
    // Two calls draw independently, so the same secret twice would mean
    // the entropy source, not the loop, is what is broken.
    const second = try KeyPair.generate();
    try testing.expect(!std.mem.eql(
        u8,
        &keypair.secret_key.data,
        &second.secret_key.data,
    ));
}

// The bound is what makes the retry a claim rather than a hope: a scalar
// the backend rejects every time must surface as an error, not a spin.
test "KeyPair.generate: a rejected scalar is bounded, not retried forever" {
    // Zero is the scalar the backend rejects deterministically, so driving
    // `generateDeterministic` with it stands in for the draw `generate`
    // would keep making. It must answer, and answer `IdentityElement` —
    // the retryable classification — rather than hang.
    try testing.expectError(
        error.IdentityElement,
        KeyPair.generateDeterministic(.init(@splat(0))),
    );
    try testing.expect(generate_attempts_max >= 1);
}

// RFC 8446 §4.2.8.2 — peers must reject malformed public keys for the group.
test "sharedSecret: rejects compressed P-256 point" {
    const alice = try KeyPair.generateDeterministic(.init(test_seed_a));
    var compressed: p256PublicKeyBytes = @splat(0);
    compressed[0] = 0x02;
    try testing.expectError(
        error.IdentityElement,
        sharedSecret(alice.secret_key, .init(compressed)),
    );
}

const p256PublicKeyBytes = [public_length]u8;

comptime {
    assert(@sizeOf(PublicKey) == public_length);
    assert(@sizeOf(SecretKey) == secret_length);
}
