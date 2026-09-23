//! Caller-owned ephemeral ECDHE keypairs used by client and server handshakes.
//!
//! TLS 1.3 ClientHello may carry multiple KeyShareEntry values, so this is a
//! small product type rather than a tagged union.
const std = @import("std");
const mem = std.mem;
const testing = std.testing;

const p256 = @import("p256.zig");
const p384 = @import("p384.zig");
const x25519 = @import("x25519.zig");

pub const KeyPairs = struct {
    x25519: x25519.KeyPair,
    /// Only `secret_key` is meaningful while `p256_public` is `.deferred`.
    p256: p256.KeyPair,
    p384: ?p384.KeyPair = null,
    p256_public: P256Public = .derived,

    /// Whether `p256.public_key` holds the scalar's public point yet.
    pub const P256Public = enum { derived, deferred };

    /// Fallible because generating the P-256 half is: the backend can
    /// refuse, and a refusal it would repeat is the caller's to handle
    /// (shed this handshake), not this function's to hide behind a retry
    /// (#88).
    pub fn init(x25519_keypair: x25519.KeyPair) p256.Error!KeyPairs {
        return .{ .x25519 = x25519_keypair, .p256 = try .generate() };
    }

    pub fn initWithP256(
        x25519_keypair: x25519.KeyPair,
        p256_keypair: p256.KeyPair,
    ) KeyPairs {
        return .{ .x25519 = x25519_keypair, .p256 = p256_keypair };
    }

    /// Server only: defer the P-256 public key. It is a fixed-base scalar
    /// multiplication (plus the backend's key check), wasted on every client
    /// that picks X25519. ServerHandshake derives it when a ClientHello selects
    /// a P-256 group. A client must send its shares up front, so
    /// ClientHandshake rejects deferred keypairs.
    pub fn initDeferredP256(
        x25519_keypair: x25519.KeyPair,
        p256_secret: p256.SecretKey,
    ) KeyPairs {
        return .{
            .x25519 = x25519_keypair,
            .p256 = .{ .secret_key = p256_secret, .public_key = .init(@splat(0)) },
            .p256_public = .deferred,
        };
    }

    /// Derive a deferred P-256 public key. No-op once derived. An invalid
    /// caller scalar (`error.IdentityElement`, ~2^-32 of draws) is replaced
    /// by a `p256.KeyPair.generate` draw under its bounded retry (#88), so a
    /// bad scalar costs one OS CSPRNG read, not the handshake. The bound is
    /// one caller scalar plus generate's own `generate_attempts_max` draws.
    pub fn deriveP256(self: *KeyPairs) p256.Error!void {
        if (self.p256_public == .derived) return;
        var derived = p256.KeyPair.fromSecret(self.p256.secret_key) catch |err| switch (err) {
            error.IdentityElement => try p256.KeyPair.generate(),
            error.LibcryptoFailed => return err,
        };
        defer derived.secureZero();
        // A redrawn keypair replaces a rejected caller scalar: wipe it first.
        std.crypto.secureZero(u8, std.mem.asBytes(&self.p256));
        self.p256 = derived;
        self.p256_public = .derived;
    }

    pub fn initWithP256P384(
        x25519_keypair: x25519.KeyPair,
        p256_keypair: p256.KeyPair,
        p384_keypair: p384.KeyPair,
    ) KeyPairs {
        return .{ .x25519 = x25519_keypair, .p256 = p256_keypair, .p384 = p384_keypair };
    }

    pub fn secureZero(self: *KeyPairs) void {
        // Order matters. Assigning `null` to an optional with a struct payload
        // is free to fill that payload with Debug-mode `undefined` bytes, so
        // clearing the optional after zeroing leaves 0xaa where a P-384 scalar
        // used to be (x86_64 Debug does exactly this; aarch64 did not, which is
        // why it only showed up in CI). Clear first, zero second: a zeroed tag
        // byte is `null`, which the whole-struct zeroing already relies on.
        self.p384 = null;
        std.crypto.secureZero(u8, std.mem.asBytes(self));
    }
};

// RFC 8446 §4.2.8.2 — the deferred public key is the scalar's SEC1 point,
// the same one the eager constructor computes.
test "deriveP256 matches the eager keypair and is idempotent" {
    const seed: p256.SecretKey = .init(@splat(0x42));
    const eager = try p256.KeyPair.fromSecret(seed);
    var kp: KeyPairs = .initDeferredP256(.generate(), seed);
    defer kp.secureZero();
    try testing.expectEqual(KeyPairs.P256Public.deferred, kp.p256_public);
    try kp.deriveP256();
    try testing.expectEqual(KeyPairs.P256Public.derived, kp.p256_public);
    try testing.expectEqualSlices(u8, &eager.public_key.data, &kp.p256.public_key.data);
    try testing.expectEqualSlices(u8, &seed.data, &kp.p256.secret_key.data);
    try kp.deriveP256();
    try testing.expectEqualSlices(u8, &eager.public_key.data, &kp.p256.public_key.data);
}

// SEC 1 §3.2.1 — the zero scalar is invalid. Deriving redraws instead of
// failing, and the redraw is a consistent keypair.
test "deriveP256 replaces an invalid scalar with a fresh draw" {
    var kp: KeyPairs = .initDeferredP256(.generate(), .init(@splat(0)));
    defer kp.secureZero();
    try kp.deriveP256();
    try testing.expect(!mem.allEqual(u8, &kp.p256.secret_key.data, 0));
    const check = try p256.KeyPair.fromSecret(kp.p256.secret_key);
    try testing.expectEqualSlices(u8, &check.public_key.data, &kp.p256.public_key.data);
}

test "secureZero zeroes all secret material" {
    var kp: KeyPairs = .initWithP256P384(.generate(), try .generate(), try .generate());
    kp.secureZero();
    try testing.expect(mem.allEqual(u8, mem.asBytes(&kp), 0));
    // Every byte zero must also leave the optional readable as null, not as a
    // present-but-zeroed keypair.
    try testing.expect(kp.p384 == null);
}
