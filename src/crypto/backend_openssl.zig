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

pub fn freeKey(key: *pkey) void {
    c.EVP_PKEY_free(key);
}
