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

/// Draws `generate` may take: each fails independently with probability
/// ~2^-32, but an unbounded retry is a promise no code can keep (#88).
const generate_attempts_max: u8 = 4;

/// Caller-owned P-256 keypair. The public key is SEC1 uncompressed form:
/// 0x04 || X || Y.
pub const KeyPair = struct {
    secret_key: SecretKey,
    public_key: PublicKey,

    /// Generate a keypair using the OS CSPRNG; the draw itself still aborts
    /// on CSPRNG failure (see `entropy.fill`). Fallible only for the backend
    /// half — see `generateRetry` for the policy and `fromSecret` to supply
    /// entropy.
    pub fn generate() Error!KeyPair {
        return generateRetry(EntropyAttempt);
    }

    /// Construct a keypair from a caller-supplied raw scalar.
    /// Production callers must supply fresh CSPRNG bytes for each handshake.
    /// Invalid scalars return `error.IdentityElement`; callers can draw again.
    /// `error.LibcryptoFailed` reports a terminal backend failure.
    pub fn fromSecret(secret_key: SecretKey) Error!KeyPair {
        return .{
            .secret_key = secret_key,
            .public_key = try publicFromSecret(secret_key),
        };
    }

    pub fn generateDeterministic(seed: SecretKey) Error!KeyPair {
        return fromSecret(seed);
    }

    /// Erase the secret and public key bytes.
    /// The keypair is invalid after this call.
    pub fn secureZero(self: *KeyPair) void {
        std.crypto.secureZero(u8, std.mem.asBytes(self));
    }
};

/// The draw `generate` actually makes: CSPRNG secret, then keypair from it.
const EntropyAttempt = struct {
    fn next() Error!KeyPair {
        var secret_key: [secret_length]u8 = undefined;
        // The drawn scalar is caller-owned scratch (#125): wipe it on every
        // exit, including an invalid draw that the retry discards.
        defer std.crypto.secureZero(u8, &secret_key);
        entropy.fill(&secret_key);
        return KeyPair.fromSecret(.init(secret_key));
    }
};

/// The #88 retry policy: retry a bad draw (an invalid scalar, ~2^-32 of
/// draws), propagate a backend failure on the first occurrence.
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
/// The caller owns out. The function clears out on error.
pub fn sharedSecret(
    secret_key: SecretKey,
    peer_public_key: PublicKey,
    out: *[secret_length]u8,
) Error!void {
    errdefer std.crypto.secureZero(u8, out);
    const ours = try privateKey(secret_key);
    defer backend.p256.freeKey(ours);
    const peer = try publicKey(peer_public_key);
    defer backend.p256.freeKey(peer);

    try backend.p256.sharedSecretDerive(ours, peer, out);
}

const test_seed_a = hex(32, "000102030405060708090a0b0c0d0e0f" ++
    "101112131415161718191a1b1c1d1e1f");
const test_seed_b = hex(32, "202122232425262728292a2b2c2d2e2f" ++
    "303132333435363738393a3b3c3d3e3f");

// RFC 8448 §5 — the fixed P-256 scalar derives the documented SEC1 public key.
test "KeyPair.fromSecret: RFC 8448 public key" {
    const secret = hex(32, "ab5473467e19346ceb0a0414e41da21d" ++
        "4d2445bc3025afe97c4e8dc8d513da39");
    const expected = hex(65, "04a6da7392ec591e17abfd535964b99894d13befb221b3def2ebe3830eac8f0151" ++
        "812677c4d6d2237e85cf01d6910cfb83954e76ba7352830534159897e8065780");
    const keypair = try KeyPair.fromSecret(.init(secret));
    try testing.expectEqualSlices(u8, &expected, &keypair.public_key.data);
}

// SEC 1 §3.2.1 — callers retry IdentityElement with a fresh scalar and stop on
// the first accepted scalar.
test "KeyPair.fromSecret: caller retries a rejected scalar" {
    const candidates = [_]SecretKey{
        .init(@splat(0)),
        .init(test_seed_a),
    };
    var attempts: usize = 0;
    var keypair: ?KeyPair = null;
    for (candidates) |candidate| {
        attempts += 1;
        keypair = KeyPair.fromSecret(candidate) catch |err| switch (err) {
            error.IdentityElement => continue,
            error.LibcryptoFailed => return err,
        };
        break;
    }

    try testing.expect(keypair != null);
    try testing.expectEqual(@as(usize, 2), attempts);
    try testing.expectEqual(@as(u8, 0x04), keypair.?.public_key.data[0]);
}

test "sharedSecret: P-256 deterministic peers agree" {
    const alice = try KeyPair.generateDeterministic(.init(test_seed_a));
    const bob = try KeyPair.generateDeterministic(.init(test_seed_b));

    var alice_secret: [secret_length]u8 = undefined;
    defer std.crypto.secureZero(u8, &alice_secret);
    var bob_secret: [secret_length]u8 = undefined;
    defer std.crypto.secureZero(u8, &bob_secret);
    try sharedSecret(alice.secret_key, bob.public_key, &alice_secret);
    try sharedSecret(bob.secret_key, alice.public_key, &bob_secret);
    try testing.expectEqualSlices(u8, &alice_secret, &bob_secret);
}

// Healthy-backend smoke: the real entropy path only. Under a healthy
// backend this passes with or without the #88 bug — the policy claims are
// pinned by the `generateRetry` tests below, not here.
test "KeyPair.generate: healthy entropy path" {
    var keypair = try KeyPair.generate();
    defer keypair.secureZero();
    try testing.expectEqual(@as(u8, 0x04), keypair.public_key.data[0]);
    // Two calls draw independently; identical secrets would indict the
    // entropy source, not the loop.
    var second = try KeyPair.generate();
    defer second.secureZero();
    try testing.expect(!std.mem.eql(
        u8,
        &keypair.secret_key.data,
        &second.secret_key.data,
    ));
}

test "KeyPair.secureZero erases secret and public material" {
    var keypair = try KeyPair.generateDeterministic(.init(test_seed_a));
    keypair.secureZero();
    try testing.expect(std.mem.allEqual(u8, std.mem.asBytes(&keypair), 0));
}

// #88 — a terminal backend failure surfaces after exactly one attempt.
// The tripwire seed makes a regressed retry fail the assertion, not hang.
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

// #88 — an invalid scalar retries exactly to the bound, no further.
// The tripwire seed makes an unbounded regression fail the assertion, not hang.
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

// #88 — one bad draw then a good one succeeds on the second attempt.
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

// SEC 1 §3.2.1 — the scalar must lie in [1, n-1]; the backend range-check
// against the group order judges it before any point math (#88).
test "KeyPair.fromSecret enforces the scalar range [1, n-1]" {
    // n, the P-256 base-point order (SEC 2, "secp256r1").
    const order = hex(32, "ffffffff00000000ffffffffffffffff" ++
        "bce6faada7179e84f3b9cac2fc632551");
    // zero: below the range.
    try testing.expectError(
        error.IdentityElement,
        KeyPair.fromSecret(.init(@splat(0))),
    );
    // n: the first scalar above the range.
    try testing.expectError(
        error.IdentityElement,
        KeyPair.fromSecret(.init(order)),
    );
    // 2^256 - 1: far above the range, still a 32-byte scalar.
    try testing.expectError(
        error.IdentityElement,
        KeyPair.fromSecret(.init(@splat(0xff))),
    );
    // n - 1: the largest valid scalar, so the upper bound is inclusive-exact.
    var order_minus_1 = order;
    order_minus_1[order.len - 1] -= 1; // n ends in 0x51; no borrow.
    const keypair = try KeyPair.fromSecret(.init(order_minus_1));
    try testing.expectEqual(@as(u8, 0x04), keypair.public_key.data[0]);
}

// RFC 8446 §4.2.8.2 — peers must reject malformed public keys for the group.
test "sharedSecret: rejects compressed P-256 point" {
    const alice = try KeyPair.generateDeterministic(.init(test_seed_a));
    var compressed: p256PublicKeyBytes = @splat(0);
    compressed[0] = 0x02;
    var out: [secret_length]u8 = @splat(0xa5);
    try testing.expectError(
        error.IdentityElement,
        sharedSecret(alice.secret_key, .init(compressed), &out),
    );
    try testing.expect(std.mem.allEqual(u8, &out, 0));
}

const p256PublicKeyBytes = [public_length]u8;

comptime {
    assert(@sizeOf(PublicKey) == public_length);
    assert(@sizeOf(SecretKey) == secret_length);
}
