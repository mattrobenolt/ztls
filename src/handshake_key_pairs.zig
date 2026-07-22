//! Caller-owned ephemeral ECDHE keypairs used by client and server handshakes.
//!
//! TLS 1.3 ClientHello may carry multiple KeyShareEntry values, so this is a
//! small product type rather than a tagged union.
const std = @import("std");

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
        std.crypto.secureZero(u8, std.mem.asBytes(self));
        self.p384 = null;
    }
};

test "secureZero zeroes all secret material" {
    var kp: KeyPairs = .initWithP256P384(.generate(), .generate(), .generate());
    kp.secureZero();
    try std.testing.expect(std.mem.allEqual(u8, std.mem.asBytes(&kp), 0));
}
