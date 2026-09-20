//! RFC 10024 provider-neutral hybrid key agreement.
//!
//! The backend supplies pure ML-KEM and ECDHE primitives. This module owns the
//! role-specific key_share component order and the shared-secret concatenation
//! required by RFC 10024, without allocating or copying whole shares.
const std = @import("std");
const testing = std.testing;

const backend = @import("crypto/backend.zig");
const KeyPairs = @import("handshake_key_pairs.zig").KeyPairs;
const kex = @import("kex.zig");
const mlkem = @import("mlkem.zig");
const p256 = @import("p256.zig");
const p384 = @import("p384.zig");
const x25519 = @import("x25519.zig");

const NamedGroup = kex.NamedGroup;

pub const max_client_share_len = 1665;
pub const max_server_share_len = 1665;
pub const max_shared_secret_len = 80;

pub const Error = error{
    BufferTooShort,
    IdentityElement,
    LibcryptoFailed,
    MalformedKeyShare,
    UnsupportedGroup,
};

pub const ClientKeyPair = struct {
    group: NamedGroup,
    mlkem_key: mlkem.KeyHandle,

    pub fn generate(group: NamedGroup) Error!ClientKeyPair {
        const spec = group.hybridSpec() orelse return error.UnsupportedGroup;
        return .{
            .group = group,
            .mlkem_key = try mlkem.generate(spec.parameter_set),
        };
    }

    pub fn deinit(self: *ClientKeyPair) void {
        self.mlkem_key.deinit();
        self.* = undefined;
    }

    /// Encode the RFC 10024 §4.1 ClientHello key_exchange value.
    pub fn publicKey(
        self: *const ClientKeyPair,
        keypairs: *const KeyPairs,
        out: []u8,
    ) Error![]u8 {
        const spec = self.group.hybridSpec() orelse return error.UnsupportedGroup;
        const share_len = spec.client_share_len;
        if (out.len < share_len) return error.BufferTooShort;
        const share = out[0..share_len];
        // Reuse the handshake's classical ephemeral when ClientHello also
        // carries its standalone group; RFC 10024 requires fresh per-handshake
        // components, not a second scalar for another encoding of that group.
        const classical_len = classicalPublicLen(spec.classical_group);
        const mlkem_len = spec.parameter_set.publicKeyLen();
        if (spec.component_order == .mlkem_first) {
            _ = try mlkem.publicKey(&self.mlkem_key, share[0..mlkem_len]);
            try writeClassicalPublic(
                spec.classical_group,
                keypairs,
                share[mlkem_len..][0..classical_len],
            );
        } else {
            try writeClassicalPublic(
                spec.classical_group,
                keypairs,
                share[0..classical_len],
            );
            _ = try mlkem.publicKey(
                &self.mlkem_key,
                share[classical_len..][0..mlkem_len],
            );
        }
        return share;
    }
};

pub const Encapsulation = struct {
    server_share: []const u8,
    shared_secret: []const u8,
};

/// RFC 10024 §4.2-§4.3 server operation. ztls performs the FIPS 203 §7.2
/// encapsulation-key check before provider import and encapsulation.
pub fn encapsulate(
    group: NamedGroup,
    client_share: []const u8,
    keypairs: *const KeyPairs,
    server_share_out: []u8,
    shared_secret_out: []u8,
) Error!Encapsulation {
    const spec = group.hybridSpec() orelse return error.UnsupportedGroup;
    if (client_share.len != spec.client_share_len) return error.MalformedKeyShare;
    if (server_share_out.len < spec.server_share_len or
        shared_secret_out.len < spec.shared_secret_len)
    {
        return error.BufferTooShort;
    }

    const classical_len = classicalPublicLen(spec.classical_group);
    const mlkem_public_len = spec.parameter_set.publicKeyLen();
    const client_classical = if (spec.component_order == .mlkem_first)
        client_share[mlkem_public_len..][0..classical_len]
    else
        client_share[0..classical_len];
    const client_mlkem = if (spec.component_order == .mlkem_first)
        client_share[0..mlkem_public_len]
    else
        client_share[classical_len..][0..mlkem_public_len];

    var peer = try mlkem.loadPeerPublic(spec.parameter_set, client_mlkem);
    defer peer.deinit();

    var classical_secret: [p384.secret_length]u8 = undefined;
    defer std.crypto.secureZero(u8, &classical_secret);
    const classical_secret_len = try deriveClassicalSecret(
        spec.classical_group,
        keypairs,
        client_classical,
        &classical_secret,
    );

    const server_share = server_share_out[0..spec.server_share_len];
    const ciphertext_len = spec.parameter_set.ciphertextLen();
    const server_classical = if (spec.component_order == .mlkem_first)
        server_share[ciphertext_len..][0..classical_len]
    else
        server_share[0..classical_len];
    const ciphertext = if (spec.component_order == .mlkem_first)
        server_share[0..ciphertext_len]
    else
        server_share[classical_len..][0..ciphertext_len];
    try writeClassicalPublic(spec.classical_group, keypairs, server_classical);

    var mlkem_secret: [mlkem.max_shared_secret_len]u8 = undefined;
    defer std.crypto.secureZero(u8, &mlkem_secret);
    const kem = try mlkem.encapsulate(&peer, ciphertext, &mlkem_secret);
    const shared_secret = shared_secret_out[0..spec.shared_secret_len];
    writeCombinedSecret(
        spec.component_order,
        classical_secret[0..classical_secret_len],
        kem.secret,
        shared_secret,
    );
    return .{ .server_share = server_share, .shared_secret = shared_secret };
}

/// RFC 10024 §4.2-§4.3 client operation. Wrong ciphertext/share lengths are
/// rejected before provider math; all other decapsulation failures remain
/// internal errors as required by §4.2.
pub fn decapsulate(
    client_key: *const ClientKeyPair,
    server_share: []const u8,
    keypairs: *const KeyPairs,
    shared_secret_out: []u8,
) Error![]u8 {
    const spec = client_key.group.hybridSpec() orelse return error.UnsupportedGroup;
    if (server_share.len != spec.server_share_len) return error.MalformedKeyShare;
    if (shared_secret_out.len < spec.shared_secret_len) return error.BufferTooShort;

    const classical_len = classicalPublicLen(spec.classical_group);
    const ciphertext_len = spec.parameter_set.ciphertextLen();
    const server_classical = if (spec.component_order == .mlkem_first)
        server_share[ciphertext_len..][0..classical_len]
    else
        server_share[0..classical_len];
    const ciphertext = if (spec.component_order == .mlkem_first)
        server_share[0..ciphertext_len]
    else
        server_share[classical_len..][0..ciphertext_len];

    var classical_secret: [p384.secret_length]u8 = undefined;
    defer std.crypto.secureZero(u8, &classical_secret);
    const classical_secret_len = try deriveClassicalSecret(
        spec.classical_group,
        keypairs,
        server_classical,
        &classical_secret,
    );

    var mlkem_secret: [mlkem.max_shared_secret_len]u8 = undefined;
    defer std.crypto.secureZero(u8, &mlkem_secret);
    const kem_secret = try mlkem.decapsulate(
        &client_key.mlkem_key,
        ciphertext,
        &mlkem_secret,
    );
    const shared_secret = shared_secret_out[0..spec.shared_secret_len];
    writeCombinedSecret(
        spec.component_order,
        classical_secret[0..classical_secret_len],
        kem_secret,
        shared_secret,
    );
    return shared_secret;
}

fn classicalPublicLen(group: NamedGroup) u16 {
    return switch (group) {
        .x25519 => x25519.public_length,
        .secp256r1 => p256.public_length,
        .secp384r1 => p384.public_length,
        else => unreachable,
    };
}

fn writeClassicalPublic(
    group: NamedGroup,
    keypairs: *const KeyPairs,
    out: []u8,
) Error!void {
    switch (group) {
        .x25519 => @memcpy(out, &keypairs.x25519.public_key.data),
        .secp256r1 => @memcpy(out, &keypairs.p256.public_key.data),
        .secp384r1 => {
            const keypair = if (keypairs.p384) |*pair| pair else return error.UnsupportedGroup;
            @memcpy(out, &keypair.public_key.data);
        },
        else => unreachable,
    }
}

fn deriveClassicalSecret(
    group: NamedGroup,
    keypairs: *const KeyPairs,
    peer_public: []const u8,
    out: *[p384.secret_length]u8,
) Error!usize {
    return switch (group) {
        .x25519 => blk: {
            if (peer_public.len != x25519.public_length) return error.MalformedKeyShare;
            const peer: x25519.PublicKey = .init(peer_public[0..x25519.public_length].*);
            try x25519.sharedSecret(keypairs.x25519.secret_key, peer, out[0..x25519.secret_length]);
            break :blk x25519.secret_length;
        },
        .secp256r1 => blk: {
            if (peer_public.len != p256.public_length or peer_public[0] != 0x04)
                return error.MalformedKeyShare;
            const peer: p256.PublicKey = .init(peer_public[0..p256.public_length].*);
            try p256.sharedSecret(keypairs.p256.secret_key, peer, out[0..p256.secret_length]);
            break :blk p256.secret_length;
        },
        .secp384r1 => blk: {
            if (peer_public.len != p384.public_length or peer_public[0] != 0x04)
                return error.MalformedKeyShare;
            const keypair = if (keypairs.p384) |*pair| pair else return error.UnsupportedGroup;
            const peer: p384.PublicKey = .init(peer_public[0..p384.public_length].*);
            try p384.sharedSecret(keypair.secret_key, peer, out);
            break :blk p384.secret_length;
        },
        else => unreachable,
    };
}

fn writeCombinedSecret(
    component_order: kex.ComponentOrder,
    classical_secret: []const u8,
    mlkem_secret: []const u8,
    out: []u8,
) void {
    switch (component_order) {
        .mlkem_first => {
            @memcpy(out[0..mlkem_secret.len], mlkem_secret);
            @memcpy(out[mlkem_secret.len..], classical_secret);
        },
        .classical_first => {
            @memcpy(out[0..classical_secret.len], classical_secret);
            @memcpy(out[classical_secret.len..], mlkem_secret);
        },
    }
}

comptime {
    for ([_]NamedGroup{
        .x25519_mlkem768,
        .secp256r1_mlkem768,
        .secp384r1_mlkem1024,
    }) |group| {
        const spec = group.hybridSpec().?;
        std.debug.assert(spec.client_share_len <= max_client_share_len);
        std.debug.assert(spec.server_share_len <= max_server_share_len);
        std.debug.assert(spec.shared_secret_len <= max_shared_secret_len);
    }
}

// RFC 10024 §4 — both roles independently produce the same combined shared
// secret for every standardized hybrid group, with exact role-specific shares.
test "RFC 10024 hybrid groups round-trip" {
    var client_keys: KeyPairs = .initWithP256P384(
        .generate(),
        try .generate(),
        try .generate(),
    );
    defer client_keys.secureZero();
    var server_keys: KeyPairs = .initWithP256P384(
        .generate(),
        try .generate(),
        try .generate(),
    );
    defer server_keys.secureZero();

    for ([_]NamedGroup{
        .x25519_mlkem768,
        .secp256r1_mlkem768,
        .secp384r1_mlkem1024,
    }) |group| {
        if (!backend.supportsClientHybridGroup(group)) continue;
        var client_key = try ClientKeyPair.generate(group);
        defer client_key.deinit();

        var client_share_buf: [max_client_share_len]u8 = undefined;
        const client_share = try client_key.publicKey(&client_keys, &client_share_buf);
        try testing.expectEqual(@as(usize, group.publicKeyLen().?), client_share.len);

        var server_share_buf: [max_server_share_len]u8 = undefined;
        var server_secret_buf: [max_shared_secret_len]u8 = undefined;
        defer std.crypto.secureZero(u8, &server_secret_buf);
        const server = try encapsulate(
            group,
            client_share,
            &server_keys,
            &server_share_buf,
            &server_secret_buf,
        );
        try testing.expectEqual(@as(usize, group.serverKeyShareLen().?), server.server_share.len);

        var client_secret_buf: [max_shared_secret_len]u8 = undefined;
        defer std.crypto.secureZero(u8, &client_secret_buf);
        const client_secret = try decapsulate(
            &client_key,
            server.server_share,
            &client_keys,
            &client_secret_buf,
        );
        try testing.expectEqualSlices(u8, server.shared_secret, client_secret);
    }
}

// RFC 10024 §4.2 — reject a role-wrong or truncated server share before KEM or
// ECDHE processing.
test "hybrid decapsulation rejects wrong server share length" {
    if (!backend.supportsClientHybridGroup(.x25519_mlkem768))
        return error.SkipZigTest;
    var keys = try KeyPairs.init(.generate());
    defer keys.secureZero();
    var client_key = try ClientKeyPair.generate(.x25519_mlkem768);
    defer client_key.deinit();
    var secret: [max_shared_secret_len]u8 = undefined;
    try testing.expectError(error.MalformedKeyShare, decapsulate(
        &client_key,
        &[_]u8{0} ** 1119,
        &keys,
        &secret,
    ));
}
