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
    if (c.EVP_PKEY_derive(ctx, &secret, &len) != 1) return error.LibcryptoFailed;
    if (len != secret.len) return error.LibcryptoFailed;

    if (std.crypto.timing_safe.eql([secret_length]u8, secret, @splat(0))) return error.IdentityElement;
    const out: hkdf.SharedSecret = .init(secret);
    return out;
}

comptime {
    assert(@sizeOf(PublicKey) == public_length);
    assert(@sizeOf(SecretKey) == secret_length);
}
