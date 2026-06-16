//! TLS 1.3 named group identifiers.
//!
//! RFC 8446 §4.2.7 (supported_groups), §4.2.8 (key_share)
const std = @import("std");
const testing = std.testing;

const x25519 = @import("x25519.zig");
const p256 = @import("p256.zig");

/// RFC 8446 §4.2.7 — named group / curve identifiers used in supported_groups
/// and key_share. Non-exhaustive: unknown peer groups parse without UB and are
/// rejected by negotiation rather than crashing.
pub const NamedGroup = enum(u16) {
    x25519 = 0x001d,
    secp256r1 = 0x0017,
    secp384r1 = 0x0018,
    secp256r1_mlkem768 = 0x11eb,
    x25519_mlkem768 = 0x11ec,
    secp384r1_mlkem1024 = 0x11ed,
    _,

    /// Wire length of the public key (key_exchange field), or null if the group
    /// is named but not implemented yet.
    pub fn publicKeyLen(self: NamedGroup) ?u16 {
        return switch (self) {
            .x25519 => x25519.public_length,
            .secp256r1 => p256.public_length,
            else => null,
        };
    }

    /// Wire length for known future groups, even before backend math is available.
    /// Values for the ML-KEM hybrids come from draft-ietf-tls-ecdhe-mlkem-05 §3.
    pub fn plannedPublicKeyLen(self: NamedGroup) ?u16 {
        return switch (self) {
            .x25519 => x25519.public_length,
            .secp256r1 => 65,
            .secp384r1 => 97,
            .x25519_mlkem768 => 32 + 1184,
            .secp256r1_mlkem768 => 65 + 1184,
            .secp384r1_mlkem1024 => 97 + 1568,
            else => null,
        };
    }

    pub fn plannedSharedSecretLen(self: NamedGroup) ?u8 {
        return switch (self) {
            .x25519, .secp256r1 => 32,
            .secp384r1 => 48,
            .x25519_mlkem768, .secp256r1_mlkem768 => 32 + 32,
            .secp384r1_mlkem1024 => 48 + 32,
            else => null,
        };
    }
};

// RFC 8446 §4.2.7 — group identifiers match the IANA-assigned wire values.
test "NamedGroup wire identifiers" {
    try testing.expectEqual(@as(u16, 0x001d), @intFromEnum(NamedGroup.x25519));
    try testing.expectEqual(@as(u16, 0x0017), @intFromEnum(NamedGroup.secp256r1));
    try testing.expectEqual(@as(u16, 0x0018), @intFromEnum(NamedGroup.secp384r1));
    try testing.expectEqual(@as(u16, 0x11ec), @intFromEnum(NamedGroup.x25519_mlkem768));
    try testing.expectEqual(@as(u16, 0x11eb), @intFromEnum(NamedGroup.secp256r1_mlkem768));
    try testing.expectEqual(@as(u16, 0x11ed), @intFromEnum(NamedGroup.secp384r1_mlkem1024));
}

// draft-ietf-tls-ecdhe-mlkem-05 §3 / §7 — hybrid group key_share sizes are
// named now so parser/negotiation code can size buffers before backend support lands.
test "planned future group sizes" {
    try testing.expectEqual(@as(?u16, 1216), NamedGroup.x25519_mlkem768.plannedPublicKeyLen());
    try testing.expectEqual(@as(?u16, 1249), NamedGroup.secp256r1_mlkem768.plannedPublicKeyLen());
    try testing.expectEqual(@as(?u16, 1665), NamedGroup.secp384r1_mlkem1024.plannedPublicKeyLen());
    try testing.expectEqual(@as(?u8, 64), NamedGroup.x25519_mlkem768.plannedSharedSecretLen());
    try testing.expectEqual(@as(?u8, 80), NamedGroup.secp384r1_mlkem1024.plannedSharedSecretLen());
}
