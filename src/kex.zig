/// TLS 1.3 key-exchange abstraction: shared NamedGroup type and a
/// group-parameterized ephemeral keypair surface.
///
/// This is the backend-agnostic KEX shape the handshake state machines target
/// (see docs/research/PROVIDER_INTERFACE.md §3). Only X25519 is wired at runtime
/// today; the type carries P-256/P-384 group ids so the negotiation/parse layer
/// can name groups instead of hardcoding 0x001d, and so shared-secret sizing is
/// already group-correct. Other groups return error.UnsupportedGroup until their
/// backend math lands.
///
/// RFC 8446 §4.2.7 (supported_groups), §4.2.8 (key_share)
const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;
const crypto = std.crypto;

const ArrayBuffer = @import("array_buffer.zig").ArrayBuffer;
const x25519 = @import("x25519.zig");

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
};

/// Sized for the widest named group we plan to support, not a fixed 32.
/// X25519 = 32, P-256 uncompressed SEC1 = 65, P-384 = 97,
/// X25519MLKEM768 = 1216, SecP256r1MLKEM768 = 1249,
/// SecP384r1MLKEM1024 = 1665.
pub const max_public_key_len = 1665;
/// Widest shared secret: P-384 || ML-KEM-1024 = 48 + 32.
/// X25519/P-256/P-384 alone remain 32/32/48.
pub const max_shared_secret_len = 80;

pub const PublicKeyMaterial = ArrayBuffer(u8, max_public_key_len);
pub const SharedSecretMaterial = ArrayBuffer(u8, max_shared_secret_len);

pub const Error = error{ UnsupportedGroup, LibcryptoFailed, IdentityElement };

/// Wire length of a group's public key (key_exchange field), or null if the
/// group is not implemented yet.
pub fn publicKeyLen(group: NamedGroup) ?u16 {
    return switch (group) {
        .x25519 => x25519.public_length,
        else => null,
    };
}

/// Wire length for known future groups, even before backend math is available.
/// Values for the ML-KEM hybrids come from draft-ietf-tls-ecdhe-mlkem-05 §3.
pub fn plannedPublicKeyLen(group: NamedGroup) ?u16 {
    return switch (group) {
        .x25519 => x25519.public_length,
        .secp256r1 => 65,
        .secp384r1 => 97,
        .x25519_mlkem768 => 32 + 1184,
        .secp256r1_mlkem768 => 65 + 1184,
        .secp384r1_mlkem1024 => 97 + 1568,
        else => null,
    };
}

pub fn plannedSharedSecretLen(group: NamedGroup) ?u8 {
    return switch (group) {
        .x25519, .secp256r1 => 32,
        .secp384r1 => 48,
        .x25519_mlkem768, .secp256r1_mlkem768 => 32 + 32,
        .secp384r1_mlkem1024 => 48 + 32,
        else => null,
    };
}

/// Caller-owned ephemeral keypair for one named group. For X25519 the secret is
/// the raw 32-byte scalar; backend-owned key handles (EVP_PKEY) are a later
/// migration (PROVIDER_INTERFACE §"Facade migration rule").
pub const KeyPair = struct {
    group: NamedGroup,
    public_key: PublicKeyMaterial,
    secret: SharedSecretMaterial,

    pub fn generate(group: NamedGroup) Error!KeyPair {
        return switch (group) {
            .x25519 => fromX25519(.generate()),
            else => error.UnsupportedGroup,
        };
    }

    pub fn generateDeterministic(group: NamedGroup, seed: [32]u8) Error!KeyPair {
        switch (group) {
            .x25519 => {
                const kp = x25519.KeyPair.generateDeterministic(seed) catch return error.LibcryptoFailed;
                return fromX25519(kp);
            },
            else => return error.UnsupportedGroup,
        }
    }

    fn fromX25519(kp: x25519.KeyPair) KeyPair {
        var out: KeyPair = .{
            .group = .x25519,
            .public_key = .empty,
            .secret = .empty,
        };
        out.public_key.appendSliceAssumeCapacity(&kp.public_key);
        out.secret.appendSliceAssumeCapacity(&kp.secret_key);
        return out;
    }

    /// Group-sized public key as it appears in the key_share key_exchange field.
    pub fn publicKey(self: *const KeyPair) []const u8 {
        return self.public_key.constSlice();
    }

    /// Derive the DHE shared secret into `out`, returning the group-sized slice.
    /// The result feeds hkdf.handshakeSecret directly.
    ///
    /// RFC 8446 §7.4.2
    pub fn sharedSecret(self: *const KeyPair, peer_public: []const u8, out: *[max_shared_secret_len]u8) Error![]const u8 {
        switch (self.group) {
            .x25519 => {
                if (peer_public.len != x25519.public_length) return error.UnsupportedGroup;
                const peer: x25519.PublicKey = .init(peer_public[0..x25519.public_length].*);
                var scalar: [x25519.secret_length]u8 = undefined;
                @memcpy(&scalar, self.secret.constSlice());
                const ss = try x25519.sharedSecret(scalar, peer);
                @memcpy(out[0..ss.len], &ss);
                return out[0..ss.len];
            },
            else => return error.UnsupportedGroup,
        }
    }

    pub fn deinit(self: *KeyPair) void {
        crypto.secureZero(u8, self.secret.fullSlice());
        self.* = undefined;
    }
};

comptime {
    assert(max_shared_secret_len >= x25519.secret_length);
    assert(max_public_key_len >= x25519.public_length);
}

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
    try testing.expectEqual(@as(?u16, 1216), plannedPublicKeyLen(.x25519_mlkem768));
    try testing.expectEqual(@as(?u16, 1249), plannedPublicKeyLen(.secp256r1_mlkem768));
    try testing.expectEqual(@as(?u16, 1665), plannedPublicKeyLen(.secp384r1_mlkem1024));
    try testing.expectEqual(@as(?u8, 64), plannedSharedSecretLen(.x25519_mlkem768));
    try testing.expectEqual(@as(?u8, 80), plannedSharedSecretLen(.secp384r1_mlkem1024));
}

// RFC 7748 §5.2 — X25519 keypair derives the published shared secret through the
// group-parameterized KeyPair surface.
test "KeyPair.sharedSecret: RFC 7748 X25519 vector via NamedGroup" {
    var scalar: [32]u8 = undefined;
    _ = try std.fmt.hexToBytes(&scalar, "a546e36bf0527c9d3b16154b82465edd62144c0ac1fc5a18506a2244ba449ac4");
    var kp = try KeyPair.generateDeterministic(.x25519, scalar);
    defer kp.deinit();

    var peer: [32]u8 = undefined;
    _ = try std.fmt.hexToBytes(&peer, "e6db6867583030db3594c1a424b15f7c726624ec26b3353b10a903a6d0ab1c4c");

    var out: [max_shared_secret_len]u8 = undefined;
    const ss = try kp.sharedSecret(&peer, &out);

    var want: [32]u8 = undefined;
    _ = try std.fmt.hexToBytes(&want, "c3da55379de9c6908e94ea4df28d084f32eccf03491c71f754b4075577a28552");
    try testing.expectEqualSlices(u8, &want, ss);
}

// Unsupported groups are rejected, not crashed — the negotiation layer relies on
// this to fall through to UnsupportedKeyShare rather than hitting UB.
test "KeyPair.generate: unsupported groups return error" {
    try testing.expectError(error.UnsupportedGroup, KeyPair.generate(.secp256r1));
    try testing.expectError(error.UnsupportedGroup, KeyPair.generate(.secp384r1));
    try testing.expectError(error.UnsupportedGroup, KeyPair.generate(@enumFromInt(0x9999)));
}
