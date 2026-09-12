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
/// is a promise about the future that no code can keep (#88).
const generate_attempts_max: u8 = 4;

/// Caller-owned P-256 keypair. The public key is SEC1 uncompressed form:
/// 0x04 || X || Y.
pub const KeyPair = struct {
    secret_key: SecretKey,
    public_key: PublicKey,

    /// Generate a keypair using the OS CSPRNG; the draw itself still aborts
    /// on CSPRNG failure (see `entropy.fill`). Fallible only for the backend
    /// half — see `generateRetry` for the policy and `generateDeterministic`
    /// if you need to own entropy outright.
    pub fn generate() Error!KeyPair {
        return generateRetry(EntropyAttempt);
    }

    pub fn generateDeterministic(seed: SecretKey) Error!KeyPair {
        return .{ .secret_key = seed, .public_key = try publicFromSecret(seed) };
    }
};

/// The draw `generate` actually makes: CSPRNG secret, then keypair from it.
const EntropyAttempt = struct {
    fn next() Error!KeyPair {
        var secret_key: [secret_length]u8 = undefined;
        entropy.fill(&secret_key);
        return KeyPair.generateDeterministic(.init(secret_key));
    }
};

/// The #88 retry policy, on the record: retry only what another draw can
/// fix. A random secret lands outside [1, n-1] about once in 2^32 draws and
/// the next draw is independent, so `IdentityElement` earns one more
/// attempt. `LibcryptoFailed` is the library failing — an exhausted
/// allocator answers the same way forever — so it propagates on the first
/// occurrence and the caller sheds the session instead of the process
/// spinning. The bound keeps even a misclassification from livelocking.
/// `Attempt` is a comptime type so tests can drive the policy with a
/// counting draw source; no runtime function pointers involved.
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

// #88 — `generate` retries a bad draw and only a bad draw. This exercises
// the real entropy path; the policy itself is pinned below through
// `generateRetry` with counting draw sources.
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

// #88 — a terminal backend failure must surface after exactly one attempt.
// The tripwire makes a regressed retry (the old `catch continue` over the
// whole error set) fail the error expectation instead of hanging: the
// second draw hands back a usable keypair.
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

// #88 — an invalid scalar is retryable, but only up to the bound. Past it
// the draw must not be consulted again; the tripwire seed turns an
// unbounded-retry regression into a wrong result instead of a hang.
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

// #88 — the retry exists to salvage the ~2^-32 bad draw, so one rejection
// followed by a good draw must succeed on the second attempt.
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
    const keypair = try generateRetry(Draw);
    try testing.expectEqual(@as(u8, 0x04), keypair.public_key.data[0]);
    try testing.expectEqual(@as(usize, 2), Draw.calls);
}

// SEC 1 §3.2.1 / RFC 8446 §4.2.8.2 — the private scalar must lie in
// [1, n-1]. The backend range-checks it against the group order before any
// point math (#88), so each class below is judged as a property of the
// scalar itself, never as a library failure.
test "KeyPair.generateDeterministic enforces the scalar range [1, n-1]" {
    // n, the P-256 base-point order (SEC 2, "secp256r1").
    const order = hex(32, "ffffffff00000000ffffffffffffffff" ++
        "bce6faada7179e84f3b9cac2fc632551");
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
    // 2^256 - 1: far above the range, still a 32-byte scalar.
    try testing.expectError(
        error.IdentityElement,
        KeyPair.generateDeterministic(.init(@splat(0xff))),
    );
    // n - 1: the largest valid scalar, so the upper bound is inclusive-exact.
    var order_minus_1 = order;
    order_minus_1[order.len - 1] -= 1; // n ends in 0x51; no borrow.
    const keypair = try KeyPair.generateDeterministic(.init(order_minus_1));
    try testing.expectEqual(@as(u8, 0x04), keypair.public_key.data[0]);
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
