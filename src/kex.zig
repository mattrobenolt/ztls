//! TLS 1.3 named group identifiers and fixed wire sizes.
//!
//! RFC 8446 §4.2.7, §4.2.8 and RFC 10024 §4, §7.
const std = @import("std");
const testing = std.testing;

const mlkem_parameters = @import("crypto/mlkem_parameters.zig");
const x25519 = @import("x25519.zig");
const p256 = @import("p256.zig");
const p384 = @import("p384.zig");

pub const ComponentOrder = enum {
    mlkem_first,
    classical_first,
};

pub const HybridSpec = struct {
    classical_group: NamedGroup,
    parameter_set: mlkem_parameters.ParameterSet,
    client_share_len: u16,
    server_share_len: u16,
    shared_secret_len: u8,
    component_order: ComponentOrder,
};

/// Non-exhaustive so unknown peer groups parse without UB and are rejected by
/// negotiation rather than crashing.
pub const NamedGroup = enum(u16) {
    x25519 = 0x001d,
    secp256r1 = 0x0017,
    secp384r1 = 0x0018,
    secp256r1_mlkem768 = 0x11eb,
    x25519_mlkem768 = 0x11ec,
    secp384r1_mlkem1024 = 0x11ed,
    _,

    /// Client KeyShareEntry key_exchange length for an implemented group.
    pub fn publicKeyLen(self: NamedGroup) ?u16 {
        return switch (self) {
            .x25519 => x25519.public_length,
            .secp256r1 => p256.public_length,
            .secp384r1 => p384.public_length,
            .secp256r1_mlkem768,
            .x25519_mlkem768,
            .secp384r1_mlkem1024,
            => self.hybridSpec().?.client_share_len,
            else => null,
        };
    }

    /// Server KeyShareEntry key_exchange length for an implemented group.
    pub fn serverKeyShareLen(self: NamedGroup) ?u16 {
        return switch (self) {
            .x25519 => x25519.public_length,
            .secp256r1 => p256.public_length,
            .secp384r1 => p384.public_length,
            .secp256r1_mlkem768,
            .x25519_mlkem768,
            .secp384r1_mlkem1024,
            => self.hybridSpec().?.server_share_len,
            else => null,
        };
    }

    pub fn sharedSecretLen(self: NamedGroup) ?u8 {
        return switch (self) {
            .x25519, .secp256r1 => 32,
            .secp384r1 => 48,
            .secp256r1_mlkem768,
            .x25519_mlkem768,
            .secp384r1_mlkem1024,
            => self.hybridSpec().?.shared_secret_len,
            else => null,
        };
    }

    pub fn hybridSpec(self: NamedGroup) ?HybridSpec {
        return switch (self) {
            // RFC 10024 §4.1-§4.3 — historical X25519 ordering is ML-KEM
            // first in both shares and in the combined shared secret.
            .x25519_mlkem768 => .{
                .classical_group = .x25519,
                .parameter_set = .mlkem768,
                .client_share_len = 1184 + 32,
                .server_share_len = 1088 + 32,
                .shared_secret_len = 32 + 32,
                .component_order = .mlkem_first,
            },
            // RFC 10024 §4.1-§4.3 — NIST-curve groups put the classical
            // component first in both shares and in the combined secret.
            .secp256r1_mlkem768 => .{
                .classical_group = .secp256r1,
                .parameter_set = .mlkem768,
                .client_share_len = 65 + 1184,
                .server_share_len = 65 + 1088,
                .shared_secret_len = 32 + 32,
                .component_order = .classical_first,
            },
            .secp384r1_mlkem1024 => .{
                .classical_group = .secp384r1,
                .parameter_set = .mlkem1024,
                .client_share_len = 97 + 1568,
                .server_share_len = 97 + 1568,
                .shared_secret_len = 48 + 32,
                .component_order = .classical_first,
            },
            else => null,
        };
    }
};

// RFC 8446 §4.2.7 and RFC 10024 §7 — group identifiers match their assigned
// TLS Supported Groups registry values.
test "NamedGroup wire identifiers" {
    try testing.expectEqual(@as(u16, 0x001d), @intFromEnum(NamedGroup.x25519));
    try testing.expectEqual(@as(u16, 0x0017), @intFromEnum(NamedGroup.secp256r1));
    try testing.expectEqual(@as(u16, 0x0018), @intFromEnum(NamedGroup.secp384r1));
    try testing.expectEqual(@as(u16, 0x11ec), @intFromEnum(NamedGroup.x25519_mlkem768));
    try testing.expectEqual(@as(u16, 0x11eb), @intFromEnum(NamedGroup.secp256r1_mlkem768));
    try testing.expectEqual(@as(u16, 0x11ed), @intFromEnum(NamedGroup.secp384r1_mlkem1024));
}

// RFC 10024 §4.1-§4.3 — each hybrid has distinct role-specific key_share
// lengths and a fixed combined shared-secret length.
test "RFC 10024 hybrid group sizes" {
    const cases = [_]struct {
        group: NamedGroup,
        client: u16,
        server: u16,
        secret: u8,
    }{
        .{ .group = .x25519_mlkem768, .client = 1216, .server = 1120, .secret = 64 },
        .{ .group = .secp256r1_mlkem768, .client = 1249, .server = 1153, .secret = 64 },
        .{ .group = .secp384r1_mlkem1024, .client = 1665, .server = 1665, .secret = 80 },
    };
    for (cases) |case| {
        try testing.expectEqual(@as(?u16, case.client), case.group.publicKeyLen());
        try testing.expectEqual(@as(?u16, case.server), case.group.serverKeyShareLen());
        try testing.expectEqual(@as(?u8, case.secret), case.group.sharedSecretLen());
    }
}
