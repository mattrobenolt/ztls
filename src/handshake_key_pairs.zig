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
    p256: p256.KeyPair,
    p384: ?p384.KeyPair = null,

    pub fn init(x25519_keypair: x25519.KeyPair) KeyPairs {
        return .{ .x25519 = x25519_keypair, .p256 = .generate() };
    }

    pub fn initWithP256(
        x25519_keypair: x25519.KeyPair,
        p256_keypair: p256.KeyPair,
    ) KeyPairs {
        return .{ .x25519 = x25519_keypair, .p256 = p256_keypair };
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

test "secureZero zeroes all secret material" {
    var kp: KeyPairs = .initWithP256P384(.generate(), .generate(), .generate());
    kp.secureZero();
    try testing.expect(mem.allEqual(u8, mem.asBytes(&kp), 0));
    // Every byte zero must also leave the optional readable as null, not as a
    // present-but-zeroed keypair.
    try testing.expect(kp.p384 == null);
}
