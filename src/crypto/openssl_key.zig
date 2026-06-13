//! OpenSSL-specific key construction helpers.
//!
//! These intentionally keep the current fast OpenSSL construction APIs instead
//! of forcing all libcrypto-family backends through one provider-style API.
//! Future backends should get their own implementation behind the same semantic
//! boundary and be measured before replacing this path.
const c = @import("c_openssl.zig").openssl;

pub const PublicKeyError = error{ InvalidEncoding, SignatureVerificationFailed };
pub const PrivateKeyError = error{LibcryptoFailed};

pub const EcCurve = enum {
    secp256r1,
    secp384r1,

    fn nid(comptime self: EcCurve) c_int {
        return switch (self) {
            .secp256r1 => c.NID_X9_62_prime256v1,
            .secp384r1 => c.NID_secp384r1,
        };
    }
};

pub fn ecPublicKeyFromSec1(
    comptime curve: EcCurve,
    pub_key: []const u8,
) PublicKeyError!*c.EVP_PKEY {
    var ec: ?*c.EC_KEY = c.EC_KEY_new_by_curve_name(curve.nid()) orelse
        return error.InvalidEncoding;
    errdefer c.EC_KEY_free(ec);

    var ptr: [*c]const u8 = pub_key.ptr;
    if (c.o2i_ECPublicKey(&ec, &ptr, @intCast(pub_key.len)) == null)
        return error.InvalidEncoding;

    const key = c.EVP_PKEY_new() orelse return error.SignatureVerificationFailed;
    errdefer c.EVP_PKEY_free(key);
    if (c.EVP_PKEY_assign_EC_KEY(key, ec) != 1)
        return error.SignatureVerificationFailed;
    return key;
}

pub fn rsaPublicKeyFromDer(pub_key: []const u8) PublicKeyError!*c.EVP_PKEY {
    var ptr: [*c]const u8 = pub_key.ptr;
    const rsa = c.d2i_RSAPublicKey(null, &ptr, @intCast(pub_key.len)) orelse
        return error.InvalidEncoding;
    errdefer c.RSA_free(rsa);

    const key = c.EVP_PKEY_new() orelse return error.SignatureVerificationFailed;
    errdefer c.EVP_PKEY_free(key);
    if (c.EVP_PKEY_assign_RSA(key, rsa) != 1)
        return error.SignatureVerificationFailed;
    return key;
}

pub fn p256KeyFromScalar(scalar: *const [32]u8) PrivateKeyError!*c.EVP_PKEY {
    const group = c.EC_GROUP_new_by_curve_name(c.NID_X9_62_prime256v1) orelse
        return error.LibcryptoFailed;
    defer c.EC_GROUP_free(group);

    const priv = c.BN_bin2bn(scalar, scalar.len, null) orelse return error.LibcryptoFailed;
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

    const pkey = c.EVP_PKEY_new() orelse return error.LibcryptoFailed;
    errdefer c.EVP_PKEY_free(pkey);
    if (c.EVP_PKEY_assign_EC_KEY(pkey, ec) != 1) return error.LibcryptoFailed;
    return pkey;
}
