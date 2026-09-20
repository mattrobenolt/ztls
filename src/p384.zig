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

/// Draws `generate` may take: an out-of-range draw is ~2^-194 here, but an
/// unbounded retry is a promise no code can keep (#88).
const generate_attempts_max: u8 = 4;

/// Caller-owned P-384 keypair. The public key is SEC1 uncompressed form:
/// 0x04 || X || Y (97 bytes for P-384).
pub const KeyPair = struct {
    secret_key: SecretKey,
    public_key: PublicKey,

    /// Generate a keypair using the OS CSPRNG; the draw itself still aborts
    /// on CSPRNG failure (see `entropy.fill`). Fallible only for the backend
    /// half — the `p256.KeyPair.generate` retry policy applies unchanged.
    pub fn generate() Error!KeyPair {
        return generateRetry(EntropyAttempt);
    }

    pub fn generateDeterministic(seed: SecretKey) Error!KeyPair {
        return .{ .secret_key = seed, .public_key = try publicFromSecret(seed) };
    }

    /// Erase the secret and public key bytes.
    /// The keypair is invalid after this call.
    pub fn secureZero(self: *KeyPair) void {
        std.crypto.secureZero(u8, std.mem.asBytes(self));
    }
};

/// The draw `generate` actually makes — see `p256.EntropyAttempt`.
const EntropyAttempt = struct {
    fn next() Error!KeyPair {
        var secret_key: [secret_length]u8 = undefined;
        entropy.fill(&secret_key);
        return KeyPair.generateDeterministic(.init(secret_key));
    }
};

/// The #88 retry policy, shared with `p256.generateRetry`: retry a bad draw
/// (bounded), propagate a failing library on the first occurrence.
fn generateRetry(comptime Attempt: type) Error!KeyPair {
    var attempt: u8 = 1;
    while (true) : (attempt += 1) {
        assert(attempt <= generate_attempts_max);
        return Attempt.next() catch |err| switch (err) {
            error.IdentityElement => {
                if (attempt == generate_attempts_max) return err;
                continue;
            },
            error.LibcryptoFailed => return err,
        };
    }
}

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
/// The caller owns out. The function clears out on error.
pub fn sharedSecret(
    secret_key: SecretKey,
    peer_public_key: PublicKey,
    out: *[secret_length]u8,
) Error!void {
    errdefer std.crypto.secureZero(u8, out);
    const ours = try privateKey(secret_key);
    defer backend.p384.freeKey(ours);
    const peer = try publicKey(peer_public_key);
    defer backend.p384.freeKey(peer);

    try backend.p384.sharedSecretDerive(ours, peer, out);
}

const test_seed_a = hex(48, "000102030405060708090a0b0c0d0e0f" ++
    "101112131415161718191a1b1c1d1e1f" ++
    "202122232425262728292a2b2c2d2e2f");
const test_seed_b = hex(48, "303132333435363738393a3b3c3d3e3f" ++
    "404142434445464748494a4b4c4d4e4f" ++
    "505152535455565758595a5b5c5d5e5f");

// SEC 1 / RFC 8446 §4.2.8.2 — P-384 key shares use uncompressed points.
test "KeyPair.generateDeterministic emits uncompressed SEC1 public key" {
    var keypair: KeyPair = try .generateDeterministic(.init(test_seed_a));
    defer keypair.secureZero();
    try testing.expectEqual(@as(u8, 0x04), keypair.public_key.data[0]);
    try testing.expectEqual(@as(usize, 97), keypair.public_key.data.len);
}

test "KeyPair.secureZero erases secret and public material" {
    var keypair: KeyPair = try .generateDeterministic(.init(test_seed_a));
    keypair.secureZero();
    try testing.expect(std.mem.allEqual(u8, std.mem.asBytes(&keypair), 0));
}

// RFC 8446 §7.4.2 — two deterministic P-384 keypairs must agree on the shared
// secret (the x-coordinate of the ECDH point).
test "sharedSecret: P-384 deterministic peers agree" {
    const alice: KeyPair = try .generateDeterministic(.init(test_seed_a));
    const bob: KeyPair = try .generateDeterministic(.init(test_seed_b));

    var alice_secret: [secret_length]u8 = undefined;
    defer std.crypto.secureZero(u8, &alice_secret);
    var bob_secret: [secret_length]u8 = undefined;
    defer std.crypto.secureZero(u8, &bob_secret);
    try sharedSecret(alice.secret_key, bob.public_key, &alice_secret);
    try sharedSecret(bob.secret_key, alice.public_key, &bob_secret);
    try testing.expectEqualSlices(u8, &alice_secret, &bob_secret);
}

// #88 — the same three policy tests as p256, against this curve's own loop.
test "generateRetry: a LibcryptoFailed attempt is terminal, not retried" {
    const Draw = struct {
        var calls: usize = 0;
        fn next() Error!KeyPair {
            calls += 1;
            if (calls == 1) return error.LibcryptoFailed;
            return KeyPair.generateDeterministic(.init(test_seed_a));
        }
    };
    Draw.calls = 0;
    try testing.expectError(error.LibcryptoFailed, generateRetry(Draw));
    try testing.expectEqual(@as(usize, 1), Draw.calls);
}

test "generateRetry: an invalid scalar retries exactly to the bound" {
    const Draw = struct {
        var calls: usize = 0;
        fn next() Error!KeyPair {
            calls += 1;
            if (calls <= generate_attempts_max)
                return KeyPair.generateDeterministic(.init(@splat(0)));
            return KeyPair.generateDeterministic(.init(test_seed_a));
        }
    };
    Draw.calls = 0;
    try testing.expectError(error.IdentityElement, generateRetry(Draw));
    try testing.expectEqual(@as(usize, generate_attempts_max), Draw.calls);
}

test "generateRetry: retries a bad draw and succeeds" {
    const Draw = struct {
        var calls: usize = 0;
        fn next() Error!KeyPair {
            calls += 1;
            const seed: SecretKey = if (calls == 1) .init(@splat(0)) else .init(test_seed_a);
            return KeyPair.generateDeterministic(seed);
        }
    };
    Draw.calls = 0;
    const keypair: KeyPair = try generateRetry(Draw);
    try testing.expectEqual(@as(u8, 0x04), keypair.public_key.data[0]);
    try testing.expectEqual(@as(usize, 2), Draw.calls);
}

// SEC 1 §3.2.1 / RFC 8446 §4.2.8.2 — the private scalar must lie in [1, n-1];
// the backend range-checks it against the group order before point math (#88).
test "KeyPair.generateDeterministic enforces the scalar range [1, n-1]" {
    // n, the P-384 base-point order (SEC 2, "secp384r1").
    const order = hex(48, "ffffffffffffffffffffffffffffffff" ++
        "ffffffffffffffff" ++
        "c7634d81f4372ddf581a0db248b0a77aecec196accc52973");
    // zero: below the range.
    try testing.expectError(
        error.IdentityElement,
        KeyPair.generateDeterministic(.init(@splat(0))),
    );
    // n: the first scalar above the range.
    try testing.expectError(
        error.IdentityElement,
        KeyPair.generateDeterministic(.init(order)),
    );
    // 2^384 - 1: far above the range, still a 48-byte scalar.
    try testing.expectError(
        error.IdentityElement,
        KeyPair.generateDeterministic(.init(@splat(0xff))),
    );
    // n - 1: the largest valid scalar, so the upper bound is inclusive-exact.
    var order_minus_1 = order;
    order_minus_1[order.len - 1] -= 1; // n ends in 0x73; no borrow.
    const keypair: KeyPair = try .generateDeterministic(.init(order_minus_1));
    try testing.expectEqual(@as(u8, 0x04), keypair.public_key.data[0]);
    try testing.expectEqual(@as(usize, 97), keypair.public_key.data.len);
}

// RFC 8446 §4.2.8.2 — peers must reject malformed public keys for the group.
test "sharedSecret: rejects compressed P-384 point" {
    const alice: KeyPair = try .generateDeterministic(.init(test_seed_a));
    var compressed: [public_length]u8 = @splat(0);
    compressed[0] = 0x02;
    var out: [secret_length]u8 = @splat(0xa5);
    try testing.expectError(
        error.IdentityElement,
        sharedSecret(alice.secret_key, .init(compressed), &out),
    );
    try testing.expect(std.mem.allEqual(u8, &out, 0));
}

comptime {
    assert(@sizeOf(PublicKey) == public_length);
    assert(@sizeOf(SecretKey) == secret_length);
}
