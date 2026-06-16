//! AWS-LC backend X25519 primitive wrappers.
//!
//! AWS-LC exposes OpenSSL-compatible EVP raw-key APIs for X25519. This module
//! intentionally delegates to the same wrapper implementation while the build
//! still links whichever libcrypto the environment provides. Real AWS-LC
//! link/input selection is a follow-up slice on #22.
const compat = @import("backend_openssl.zig");

pub const Error = compat.Error;
pub const pkey = compat.pkey;

pub inline fn privateKeyFromSecret(secret: *const [32]u8) Error!*pkey {
    return compat.privateKeyFromSecret(secret);
}

pub inline fn publicKeyFromRaw(public_key: *const [32]u8) Error!*pkey {
    return compat.publicKeyFromRaw(public_key);
}

pub inline fn rawPublicKeyFromPrivate(key: *pkey) Error![32]u8 {
    return compat.rawPublicKeyFromPrivate(key);
}

pub inline fn sharedSecretDerive(ours: *pkey, peer: *pkey, out: *[32]u8) Error!void {
    return compat.sharedSecretDerive(ours, peer, out);
}

pub inline fn p256PrivateKeyFromSecret(secret: *const [32]u8) Error!*pkey {
    return compat.p256PrivateKeyFromSecret(secret);
}

pub inline fn p256PublicKeyFromRaw(public_key: *const [65]u8) Error!*pkey {
    return compat.p256PublicKeyFromRaw(public_key);
}

pub inline fn p256RawPublicKeyFromPrivate(key: *pkey) Error![65]u8 {
    return compat.p256RawPublicKeyFromPrivate(key);
}

pub inline fn p256SharedSecretDerive(ours: *pkey, peer: *pkey, out: *[32]u8) Error!void {
    return compat.p256SharedSecretDerive(ours, peer, out);
}

pub inline fn freeKey(key: *pkey) void {
    compat.freeKey(key);
}
