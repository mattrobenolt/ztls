//! Public compile-time capability discovery for the selected crypto backend.
const std = @import("std");
const testing = std.testing;

const backend = @import("crypto/backend.zig");
const kex = @import("kex.zig");
const NamedGroup = kex.NamedGroup;

pub const Backend = enum {
    openssl,
    @"aws-lc",
    boringssl,
    @"openssl-fips",
    @"aws-lc-fips",
};

pub const Role = enum { client, server };

/// Backend identity selected by `-Dcrypto-backend`.
pub const active_backend: Backend = switch (backend.active) {
    .openssl => .openssl,
    .@"aws-lc" => .@"aws-lc",
    .boringssl => .boringssl,
    .@"openssl-fips" => .@"openssl-fips",
    .@"aws-lc-fips" => .@"aws-lc-fips",
};

/// True for a compile-time FIPS capability identity.
pub const is_fips = backend.is_fips;

/// RFC 10024 groups that ztls implements. Backend support remains selectable.
pub const hybrid_groups = [_]NamedGroup{
    .x25519_mlkem768,
    .secp256r1_mlkem768,
    .secp384r1_mlkem1024,
};

pub const HybridPolicyError = error{
    /// The group list or initial-share relation is malformed.
    InvalidHybridPolicy,
    /// The selected backend identity prohibits a known hybrid group.
    HybridGroupUnavailable,
};

/// Report whether one role can use an RFC 10024 group with the active backend.
pub fn supportsHybridGroup(role: Role, group: NamedGroup) bool {
    return switch (role) {
        .client => backend.supportsClientHybridGroup(group),
        .server => backend.supportsServerHybridGroup(group),
    };
}

/// Validate a borrowed RFC 10024 group list before key generation or wire I/O.
pub fn validateHybridGroups(
    role: Role,
    groups: []const NamedGroup,
) HybridPolicyError!void {
    if (groups.len > hybrid_groups.len) return error.InvalidHybridPolicy;
    for (groups, 0..) |group, i| {
        if (group.hybridSpec() == null) return error.InvalidHybridPolicy;
        for (groups[0..i]) |earlier| {
            if (earlier == group) return error.InvalidHybridPolicy;
        }
    }
    for (groups) |group| {
        if (!supportsHybridGroup(role, group)) return error.HybridGroupUnavailable;
    }
}

/// Report whether a group list requires a P-384 keypair.
pub fn requiresP384(groups: []const NamedGroup) bool {
    for (groups) |group| {
        const spec = group.hybridSpec() orelse continue;
        if (spec.classical_group == .secp384r1) return true;
    }
    return false;
}

test "active backend identity matches the private provider facade" {
    try testing.expectEqualStrings(@tagName(backend.active), @tagName(active_backend));
    try testing.expectEqual(backend.is_fips, is_fips);
}

// RFC 10024 §7 — public capability queries cover exactly the implemented groups.
test "hybrid capability queries match the active backend" {
    for (hybrid_groups) |group| {
        try testing.expectEqual(
            backend.supportsClientHybridGroup(group),
            supportsHybridGroup(.client, group),
        );
        try testing.expectEqual(
            backend.supportsServerHybridGroup(group),
            supportsHybridGroup(.server, group),
        );
    }
    try testing.expect(!supportsHybridGroup(.client, .x25519));
    try testing.expect(!supportsHybridGroup(.server, .secp256r1));
    const unknown: NamedGroup = @enumFromInt(0xdead);
    try testing.expect(!supportsHybridGroup(.client, unknown));
    try testing.expect(!supportsHybridGroup(.server, unknown));

    for (hybrid_groups) |group| {
        if (is_fips) {
            try testing.expect(!supportsHybridGroup(.client, group));
            try testing.expect(!supportsHybridGroup(.server, group));
        } else {
            try testing.expect(supportsHybridGroup(.client, group));
            try testing.expect(supportsHybridGroup(.server, group));
        }
    }
}

// RFC 10024 §7 — policy validation rejects non-hybrid, duplicate, and oversized lists.
test "validateHybridGroups reports local policy faults" {
    try testing.expectError(
        error.InvalidHybridPolicy,
        validateHybridGroups(.client, &.{
            .x25519_mlkem768,
            .secp256r1_mlkem768,
            .secp384r1_mlkem1024,
            .x25519_mlkem768,
        }),
    );
    try testing.expectError(
        error.InvalidHybridPolicy,
        validateHybridGroups(.client, &.{.x25519}),
    );
    try testing.expectError(
        error.InvalidHybridPolicy,
        validateHybridGroups(.client, &.{
            .x25519_mlkem768,
            .x25519_mlkem768,
        }),
    );
    if (!supportsHybridGroup(.client, .x25519_mlkem768)) {
        try testing.expectError(
            error.HybridGroupUnavailable,
            validateHybridGroups(.client, &.{.x25519_mlkem768}),
        );
    }
}

test "requiresP384 identifies only P-384 hybrid policy" {
    try testing.expect(!requiresP384(&.{}));
    try testing.expect(!requiresP384(&.{.x25519_mlkem768}));
    try testing.expect(!requiresP384(&.{.secp256r1_mlkem768}));
    try testing.expect(requiresP384(&.{.secp384r1_mlkem1024}));
}
