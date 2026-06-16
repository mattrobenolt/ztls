//! OpenSSL backend X25519 primitive wrappers.
const std = @import("std");

const c = @import("c_openssl.zig").openssl;

pub const Error = error{ LibcryptoFailed, IdentityElement };
pub const pkey = c.EVP_PKEY;

pub fn privateKeyFromSecret(secret: *const [32]u8) Error!*pkey {
    return c.EVP_PKEY_new_raw_private_key(
        c.EVP_PKEY_X25519,
        null,
        secret,
        secret.len,
    ) orelse error.LibcryptoFailed;
}

pub fn publicKeyFromRaw(public_key: *const [32]u8) Error!*pkey {
    return c.EVP_PKEY_new_raw_public_key(
        c.EVP_PKEY_X25519,
        null,
        public_key,
        public_key.len,
    ) orelse error.LibcryptoFailed;
}

pub fn rawPublicKeyFromPrivate(key: *pkey) Error![32]u8 {
    var public_key: [32]u8 = undefined;
    var len: usize = public_key.len;
    if (c.EVP_PKEY_get_raw_public_key(key, &public_key, &len) != 1) return error.LibcryptoFailed;
    if (len != public_key.len) return error.LibcryptoFailed;
    return public_key;
}

pub fn sharedSecretDerive(ours: *pkey, peer: *pkey, out: *[32]u8) Error!void {
    const ctx = c.EVP_PKEY_CTX_new(ours, null) orelse return error.LibcryptoFailed;
    defer c.EVP_PKEY_CTX_free(ctx);
    if (c.EVP_PKEY_derive_init(ctx) != 1) return error.LibcryptoFailed;
    if (c.EVP_PKEY_derive_set_peer(ctx, peer) != 1) return error.LibcryptoFailed;

    var len: usize = out.len;
    if (c.EVP_PKEY_derive(ctx, out, &len) != 1) return error.IdentityElement;
    if (len != out.len) return error.LibcryptoFailed;

    // RFC 7748 §6.1 — all-zero X25519 output is a low-order peer public key.
    if (std.crypto.timing_safe.eql([32]u8, out.*, @splat(0))) return error.IdentityElement;
}

pub fn p256PrivateKeyFromSecret(secret: *const [32]u8) Error!*pkey {
    const group = c.EC_GROUP_new_by_curve_name(c.NID_X9_62_prime256v1) orelse
        return error.LibcryptoFailed;
    defer c.EC_GROUP_free(group);

    const priv = c.BN_bin2bn(secret, secret.len, null) orelse return error.LibcryptoFailed;
    defer c.BN_free(priv);

    const public = c.EC_POINT_new(group) orelse return error.LibcryptoFailed;
    defer c.EC_POINT_free(public);
    if (c.EC_POINT_mul(group, public, priv, null, null, null) != 1)
        return error.LibcryptoFailed;

    const ec = c.EC_KEY_new_by_curve_name(c.NID_X9_62_prime256v1) orelse
        return error.LibcryptoFailed;
    errdefer c.EC_KEY_free(ec);
    if (c.EC_KEY_set_private_key(ec, priv) != 1) return error.LibcryptoFailed;
    if (c.EC_KEY_set_public_key(ec, public) != 1) return error.LibcryptoFailed;
    if (c.EC_KEY_check_key(ec) != 1) return error.LibcryptoFailed;

    const key = c.EVP_PKEY_new() orelse return error.LibcryptoFailed;
    errdefer c.EVP_PKEY_free(key);
    if (c.EVP_PKEY_assign_EC_KEY(key, ec) != 1) return error.LibcryptoFailed;
    return key;
}

pub fn p256PublicKeyFromRaw(public_key: *const [65]u8) Error!*pkey {
    if (public_key[0] != 0x04) return error.IdentityElement;

    var ec: ?*c.EC_KEY = c.EC_KEY_new_by_curve_name(c.NID_X9_62_prime256v1) orelse
        return error.LibcryptoFailed;
    errdefer c.EC_KEY_free(ec);

    var ptr: ?[*]const u8 = public_key;
    if (c.o2i_ECPublicKey(&ec, &ptr, public_key.len) == null)
        return error.IdentityElement;
    if (c.EC_KEY_check_key(ec) != 1) return error.IdentityElement;

    const key = c.EVP_PKEY_new() orelse return error.LibcryptoFailed;
    errdefer c.EVP_PKEY_free(key);
    if (c.EVP_PKEY_assign_EC_KEY(key, ec) != 1) return error.LibcryptoFailed;
    return key;
}

pub fn p256RawPublicKeyFromPrivate(key: *pkey) Error![65]u8 {
    const ec = c.EVP_PKEY_get1_EC_KEY(key) orelse return error.LibcryptoFailed;
    defer c.EC_KEY_free(ec);

    var len = c.i2o_ECPublicKey(ec, null);
    if (len != 65) return error.LibcryptoFailed;
    var public_key: [65]u8 = undefined;
    var ptr: [*c]u8 = &public_key;
    len = c.i2o_ECPublicKey(ec, &ptr);
    if (len != 65) return error.LibcryptoFailed;
    if (public_key[0] != 0x04) return error.LibcryptoFailed;
    return public_key;
}

pub fn p256SharedSecretDerive(ours: *pkey, peer: *pkey, out: *[32]u8) Error!void {
    const ctx = c.EVP_PKEY_CTX_new(ours, null) orelse return error.LibcryptoFailed;
    defer c.EVP_PKEY_CTX_free(ctx);
    if (c.EVP_PKEY_derive_init(ctx) != 1) return error.LibcryptoFailed;
    if (c.EVP_PKEY_derive_set_peer(ctx, peer) != 1) return error.IdentityElement;

    var len: usize = out.len;
    if (c.EVP_PKEY_derive(ctx, out, &len) != 1) return error.IdentityElement;
    if (len != out.len) return error.LibcryptoFailed;
    if (std.crypto.timing_safe.eql([32]u8, out.*, @splat(0))) return error.IdentityElement;
}

pub fn freeKey(key: *pkey) void {
    c.EVP_PKEY_free(key);
}
