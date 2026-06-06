/// Signature helpers for TLS 1.3 CertificateVerify.
const c = @cImport({
    @cInclude("openssl/bn.h");
    @cInclude("openssl/ec.h");
    @cInclude("openssl/evp.h");
    @cInclude("openssl/obj_mac.h");
});

pub const Error = error{ BufferTooShort, LibcryptoFailed };

fn p256KeyFromScalar(scalar: *const [32]u8) Error!*c.EVP_PKEY {
    const group = c.EC_GROUP_new_by_curve_name(c.NID_X9_62_prime256v1) orelse return error.LibcryptoFailed;
    defer c.EC_GROUP_free(group);

    const priv = c.BN_bin2bn(scalar, scalar.len, null) orelse return error.LibcryptoFailed;
    defer c.BN_free(priv);

    const public = c.EC_POINT_new(group) orelse return error.LibcryptoFailed;
    defer c.EC_POINT_free(public);
    if (c.EC_POINT_mul(group, public, priv, null, null, null) != 1) return error.LibcryptoFailed;

    const ec = c.EC_KEY_new_by_curve_name(c.NID_X9_62_prime256v1) orelse return error.LibcryptoFailed;
    errdefer c.EC_KEY_free(ec);
    if (c.EC_KEY_set_private_key(ec, priv) != 1) return error.LibcryptoFailed;
    if (c.EC_KEY_set_public_key(ec, public) != 1) return error.LibcryptoFailed;

    const pkey = c.EVP_PKEY_new() orelse return error.LibcryptoFailed;
    errdefer c.EVP_PKEY_free(pkey);
    if (c.EVP_PKEY_assign_EC_KEY(pkey, ec) != 1) return error.LibcryptoFailed;
    return pkey;
}

/// Sign `msg` as ECDSA P-256 with SHA-256, returning DER-encoded ECDSA-Sig-Value.
pub fn signEcdsaP256Sha256(scalar: *const [32]u8, msg: []const u8, out: []u8) Error![]const u8 {
    const pkey = try p256KeyFromScalar(scalar);
    defer c.EVP_PKEY_free(pkey);

    const ctx = c.EVP_MD_CTX_new() orelse return error.LibcryptoFailed;
    defer c.EVP_MD_CTX_free(ctx);

    if (c.EVP_DigestSignInit(ctx, null, c.EVP_sha256(), null, pkey) != 1) return error.LibcryptoFailed;
    if (c.EVP_DigestSignUpdate(ctx, msg.ptr, msg.len) != 1) return error.LibcryptoFailed;

    var len: usize = out.len;
    if (c.EVP_DigestSignFinal(ctx, out.ptr, &len) != 1) return error.BufferTooShort;
    return out[0..len];
}
