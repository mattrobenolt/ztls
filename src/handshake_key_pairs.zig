//! Caller-owned ephemeral ECDHE keypairs used by client and server handshakes.
//!
//! TLS 1.3 ClientHello may carry multiple KeyShareEntry values, so this is a
//! small product type rather than a tagged union.
const std = @import("std");
const mem = std.mem;
const testing = std.testing;

const NamedGroup = @import("kex.zig").NamedGroup;
const memx = @import("memx.zig");
const p256 = @import("p256.zig");
const p384 = @import("p384.zig");
const x25519 = @import("x25519.zig");

pub const KeyPairs = struct {
    /// Only `secret_key` is meaningful until `derived` contains `.x25519`.
    x25519: x25519.KeyPair,
    /// Only `secret_key` is meaningful until `derived` contains `.p256`.
    p256: p256.KeyPair,
    p384: ?p384.KeyPair = null,
    /// The public keys that hold their scalar's point. A server can defer
    /// one: it stays all zero until `deriveFor` fills it. Every byte zero
    /// reads as nothing derived, so a wiped keypair cannot pass for one
    /// whose all-zero keys are real. P-384 is never deferred.
    derived: std.EnumSet(Public) = .initFull(),

    pub const Public = enum { x25519, p256 };
    pub const DeriveError = x25519.Error || p256.Error;

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
            .derived = .init(.{ .x25519 = true }),
        };
    }

    /// Server only: defer both public keys. The server then pays one
    /// fixed-base multiplication, for the group the ClientHello selects,
    /// instead of one per group (#136). Same client rule as
    /// `initDeferredP256`.
    pub fn initDeferred(x25519_secret: x25519.SecretKey, p256_secret: p256.SecretKey) KeyPairs {
        return .{
            .x25519 = .{ .secret_key = x25519_secret, .public_key = .init(@splat(0)) },
            .p256 = .{ .secret_key = p256_secret, .public_key = .init(@splat(0)) },
            .derived = .initEmpty(),
        };
    }

    /// Derive the deferred public key that `group` puts on the wire: its own
    /// for a classical group, its classical component's for a hybrid. No-op
    /// for a key that was never deferred or is derived already.
    pub fn deriveFor(self: *KeyPairs, group: NamedGroup) DeriveError!void {
        const classical = if (group.hybridSpec()) |spec| spec.classical_group else group;
        switch (classical) {
            .x25519 => try self.deriveX25519(),
            .secp256r1 => try self.deriveP256(),
            // Only X25519 and P-256 can be deferred (`Public`). P-384 is
            // always eager, and selection requires its keypair. A new
            // deferrable group needs its own arm here.
            else => {},
        }
    }

    /// Every 32-byte string is a valid X25519 scalar (RFC 7748 §5 clamps
    /// it), so the only failure is the backend's.
    fn deriveX25519(self: *KeyPairs) x25519.Error!void {
        if (self.derived.contains(.x25519)) return;
        var fresh: x25519.KeyPair = try .fromSecret(self.x25519.secret_key);
        defer fresh.secureZero();
        self.x25519.public_key = fresh.public_key;
        self.derived.insert(.x25519);
    }

    /// An invalid caller scalar (`error.IdentityElement`, ~2^-32 of draws)
    /// is replaced by a `p256.KeyPair.generate` draw under its bounded retry
    /// (#88), so a bad scalar costs one OS CSPRNG read, not the handshake.
    /// The bound is one caller scalar plus generate's own
    /// `generate_attempts_max` draws.
    fn deriveP256(self: *KeyPairs) p256.Error!void {
        if (self.derived.contains(.p256)) return;
        var fresh = p256.KeyPair.fromSecret(self.p256.secret_key) catch |err| switch (err) {
            error.IdentityElement => try p256.KeyPair.generate(),
            error.LibcryptoFailed => return err,
        };
        defer fresh.secureZero();
        // A redrawn keypair replaces a rejected caller scalar: wipe it first.
        std.crypto.secureZero(u8, std.mem.asBytes(&self.p256));
        self.p256 = fresh;
        self.derived.insert(.p256);
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
test "deriveFor secp256r1 matches the eager keypair and is idempotent" {
    const seed: p256.SecretKey = .init(@splat(0x42));
    const eager = try p256.KeyPair.fromSecret(seed);
    var kp: KeyPairs = .initDeferredP256(.generate(), seed);
    defer kp.secureZero();
    try testing.expect(!kp.derived.contains(.p256));
    try kp.deriveFor(.secp256r1);
    try testing.expect(kp.derived.contains(.p256));
    try testing.expectEqualSlices(u8, &eager.public_key.data, &kp.p256.public_key.data);
    try testing.expectEqualSlices(u8, &seed.data, &kp.p256.secret_key.data);
    try kp.deriveFor(.secp256r1);
    try testing.expectEqualSlices(u8, &eager.public_key.data, &kp.p256.public_key.data);
}

// SEC 1 §3.2.1 — the zero scalar is invalid. Deriving redraws instead of
// failing, and the redraw is a consistent keypair.
test "deriveFor secp256r1 replaces an invalid scalar with a fresh draw" {
    var kp: KeyPairs = .initDeferredP256(.generate(), .init(@splat(0)));
    defer kp.secureZero();
    try kp.deriveFor(.secp256r1);
    try testing.expect(!mem.allEqual(u8, &kp.p256.secret_key.data, 0));
    const check = try p256.KeyPair.fromSecret(kp.p256.secret_key);
    try testing.expectEqualSlices(u8, &check.public_key.data, &kp.p256.public_key.data);
}

// RFC 7748 §6.1 — a deferred X25519 key derives to the scalar's public key.
// RFC 10024 §4 — a hybrid group derives its classical component's key only.
test "deriveFor derives the selected group's key and no other" {
    const Case = struct { group: NamedGroup, derived: std.EnumSet(KeyPairs.Public) };
    const cases = [_]Case{
        .{ .group = .x25519, .derived = .init(.{ .x25519 = true }) },
        .{ .group = .x25519_mlkem768, .derived = .init(.{ .x25519 = true }) },
        .{ .group = .secp256r1, .derived = .init(.{ .p256 = true }) },
        .{ .group = .secp256r1_mlkem768, .derived = .init(.{ .p256 = true }) },
        .{ .group = .secp384r1, .derived = .initEmpty() },
        .{ .group = .secp384r1_mlkem1024, .derived = .initEmpty() },
    };
    const x25519_seed = memx.hex(32, "77076d0a7318a57d3c16c17251b26645" ++
        "df4c2f87ebc0992ab177fba51db92c2a");
    const x25519_public = memx.hex(32, "8520f0098930a754748b7ddcb43ef75a" ++
        "0dbf3a0d26381af4eba4a98eaa9b4e6a");
    const p256_seed: p256.SecretKey = .init(@splat(0x42));
    const p256_public = (try p256.KeyPair.fromSecret(p256_seed)).public_key.data;
    const zero: [p256.public_length]u8 = @splat(0);
    for (cases) |case| {
        var kp: KeyPairs = .initDeferred(.init(x25519_seed), p256_seed);
        defer kp.secureZero();
        try testing.expect(kp.derived.eql(.initEmpty()));
        try kp.deriveFor(case.group);
        try testing.expect(kp.derived.eql(case.derived));
        const x25519_want = if (case.derived.contains(.x25519)) &x25519_public else zero[0..32];
        try testing.expectEqualSlices(u8, x25519_want, &kp.x25519.public_key.data);
        const p256_want = if (case.derived.contains(.p256)) &p256_public else &zero;
        try testing.expectEqualSlices(u8, p256_want, &kp.p256.public_key.data);
        try testing.expectEqualSlices(u8, &x25519_seed, &kp.x25519.secret_key.data);
    }
}

// RFC 8446 §4.2.8 — a wiped keypair carries no secret, and it reads as
// nothing derived, so its all-zero public keys can never pass as real.
test "secureZero zeroes all secret material" {
    var eager: KeyPairs = .initWithP256P384(.generate(), try .generate(), try .generate());
    var deferred: KeyPairs = .initDeferred(.init(@splat(0x11)), .init(@splat(0x42)));
    try deferred.deriveFor(.x25519);
    for ([_]*KeyPairs{ &eager, &deferred }) |kp| {
        kp.secureZero();
        try testing.expect(mem.allEqual(u8, mem.asBytes(kp), 0));
        // Every byte zero must also leave the optional readable as null, not
        // as a present-but-zeroed keypair.
        try testing.expect(kp.p384 == null);
        try testing.expect(kp.derived.eql(.initEmpty()));
    }
}
