/// X25519 ephemeral key exchange for TLS 1.3.
///
/// RFC 8446 §4.2.8.2, RFC 7748
const std = @import("std");
const assert = std.debug.assert;
const c = @cImport({
    @cInclude("openssl/evp.h");
});

const hkdf = @import("hkdf.zig");
const memx = @import("memx.zig");

pub const public_length = 32;
pub const secret_length = 32;

pub const PublicKey = memx.Array(public_length);
pub const SecretKey = memx.Array(secret_length);

pub const Error = error{ LibcryptoFailed, IdentityElement };

/// Caller-owned X25519 keypair. The secret key is the raw 32-byte scalar input;
/// OpenSSL performs the RFC 7748 clamping internally for X25519 operations.
pub const KeyPair = struct {
    secret_key: [secret_length]u8,
    public_key: [public_length]u8,

    pub fn generate() KeyPair {
        var secret_key: [secret_length]u8 = undefined;
        std.crypto.random.bytes(&secret_key);
        return generateDeterministic(secret_key) catch unreachable;
    }

    pub fn generateDeterministic(seed: [secret_length]u8) Error!KeyPair {
        return .{ .secret_key = seed, .public_key = try publicFromSecret(seed) };
    }
};

fn privateKey(secret_key: [secret_length]u8) Error!*c.EVP_PKEY {
    return c.EVP_PKEY_new_raw_private_key(c.EVP_PKEY_X25519, null, &secret_key, secret_key.len) orelse error.LibcryptoFailed;
}

fn publicKey(public_key: PublicKey) Error!*c.EVP_PKEY {
    return c.EVP_PKEY_new_raw_public_key(c.EVP_PKEY_X25519, null, &public_key.data, public_key.data.len) orelse error.LibcryptoFailed;
}

fn publicFromSecret(secret_key: [secret_length]u8) Error![public_length]u8 {
    const key = try privateKey(secret_key);
    defer c.EVP_PKEY_free(key);

    var public_key: [public_length]u8 = undefined;
    var len: usize = public_key.len;
    if (c.EVP_PKEY_get_raw_public_key(key, &public_key, &len) != 1) return error.LibcryptoFailed;
    if (len != public_key.len) return error.LibcryptoFailed;
    return public_key;
}

/// Compute the X25519 shared secret from our secret key and the peer's public key.
/// The result feeds directly into hkdf.handshakeSecret as the DHE input.
///
/// RFC 8446 §7.4.2
pub fn sharedSecret(secret_key: [secret_length]u8, peer_public_key: PublicKey) Error!hkdf.SharedSecret {
    const ours = try privateKey(secret_key);
    defer c.EVP_PKEY_free(ours);
    const peer = try publicKey(peer_public_key);
    defer c.EVP_PKEY_free(peer);

    const ctx = c.EVP_PKEY_CTX_new(ours, null) orelse return error.LibcryptoFailed;
    defer c.EVP_PKEY_CTX_free(ctx);
    if (c.EVP_PKEY_derive_init(ctx) != 1) return error.LibcryptoFailed;
    if (c.EVP_PKEY_derive_set_peer(ctx, peer) != 1) return error.LibcryptoFailed;

    var secret: [secret_length]u8 = undefined;
    var len: usize = secret.len;
    if (c.EVP_PKEY_derive(ctx, &secret, &len) != 1) return error.IdentityElement;
    if (len != secret.len) return error.LibcryptoFailed;

    if (std.crypto.timing_safe.eql([secret_length]u8, secret, @splat(0))) return error.IdentityElement;
    const out: hkdf.SharedSecret = .init(secret);
    return out;
}

fn hex(comptime bytes_len: usize, comptime encoded: []const u8) [bytes_len]u8 {
    var out: [bytes_len]u8 = undefined;
    _ = std.fmt.hexToBytes(&out, encoded) catch unreachable;
    return out;
}

// RFC 7748 §5.2 — X25519 scalar multiplication test vector.
test "sharedSecret: RFC 7748 X25519 vector" {
    const scalar = hex(32, "a546e36bf0527c9d3b16154b82465edd62144c0ac1fc5a18506a2244ba449ac4");
    const peer: PublicKey = .init(hex(32, "e6db6867583030db3594c1a424b15f7c726624ec26b3353b10a903a6d0ab1c4c"));
    const secret = try sharedSecret(scalar, peer);
    try std.testing.expectEqualSlices(u8, &hex(32, "c3da55379de9c6908e94ea4df28d084f32eccf03491c71f754b4075577a28552"), &secret.data);
}

// RFC 7748 §6.1 — X25519 public keys are scalar multiplication by base point 9.
test "KeyPair.generateDeterministic: RFC 7748 public keys" {
    const alice = try KeyPair.generateDeterministic(hex(32, "77076d0a7318a57d3c16c17251b26645df4c2f87ebc0992ab177fba51db92c2a"));
    try std.testing.expectEqualSlices(u8, &hex(32, "8520f0098930a754748b7ddcb43ef75a0dbf3a0d26381af4eba4a98eaa9b4e6a"), &alice.public_key);

    const bob = try KeyPair.generateDeterministic(hex(32, "5dab087e624a8a4b79e17f8b83800ee66f3bb1292618b6fd1c2f8b27ff88e0eb"));
    try std.testing.expectEqualSlices(u8, &hex(32, "de9edb7d7b7dc1b4d35b61c2ece435373f8343c85b78674dadfc7e146f882b4f"), &bob.public_key);
}

comptime {
    assert(@sizeOf(PublicKey) == public_length);
    assert(@sizeOf(SecretKey) == secret_length);
}
