/// Signature helpers for TLS 1.3 CertificateVerify.
const certificate = @import("certificate.zig");

const c = @cImport({
    @cInclude("openssl/bio.h");
    @cInclude("openssl/bn.h");
    @cInclude("openssl/ec.h");
    @cInclude("openssl/evp.h");
    @cInclude("openssl/obj_mac.h");
    @cInclude("openssl/pem.h");
});

pub const SignError = error{ BufferTooShort, IdentityElement, LibcryptoFailed, NonCanonical };

pub const Signer = struct {
    scheme: certificate.SignatureScheme,
    context: *anyopaque,
    sign: *const fn (context: *anyopaque, msg: []const u8, out: []u8) SignError![]const u8,
};

pub const PrivateKey = struct {
    scheme: certificate.SignatureScheme,
    key: *c.EVP_PKEY,

    pub fn fromDer(scheme: certificate.SignatureScheme, der: []const u8) SignError!PrivateKey {
        var ptr: [*c]const u8 = der.ptr;
        const key = c.d2i_AutoPrivateKey(null, &ptr, @intCast(der.len)) orelse return error.LibcryptoFailed;
        return .{ .scheme = scheme, .key = key };
    }

    pub fn fromPem(scheme: certificate.SignatureScheme, pem: []const u8) SignError!PrivateKey {
        const bio = c.BIO_new_mem_buf(pem.ptr, @intCast(pem.len)) orelse return error.LibcryptoFailed;
        defer _ = c.BIO_free(bio);
        const key = c.PEM_read_bio_PrivateKey(bio, null, null, null) orelse return error.LibcryptoFailed;
        return .{ .scheme = scheme, .key = key };
    }

    pub fn fromP256Scalar(scalar: *const [32]u8) SignError!PrivateKey {
        return .{ .scheme = .ecdsa_secp256r1_sha256, .key = try p256KeyFromScalar(scalar) };
    }

    pub fn deinit(self: *PrivateKey) void {
        c.EVP_PKEY_free(self.key);
        self.* = undefined;
    }

    pub fn signer(self: *PrivateKey) Signer {
        return .{ .scheme = self.scheme, .context = self, .sign = signOpaque };
    }

    fn signOpaque(context: *anyopaque, msg: []const u8, out: []u8) SignError![]const u8 {
        const self: *PrivateKey = @ptrCast(@alignCast(context));
        return self.sign(msg, out);
    }

    pub fn sign(self: *const PrivateKey, msg: []const u8, out: []u8) SignError![]const u8 {
        const md = switch (self.scheme) {
            .ecdsa_secp256r1_sha256, .rsa_pss_rsae_sha256 => c.EVP_sha256(),
            .ecdsa_secp384r1_sha384, .rsa_pss_rsae_sha384 => c.EVP_sha384(),
            .rsa_pss_rsae_sha512 => c.EVP_sha512(),
            else => return error.LibcryptoFailed,
        } orelse return error.LibcryptoFailed;

        const ctx = c.EVP_MD_CTX_new() orelse return error.LibcryptoFailed;
        defer c.EVP_MD_CTX_free(ctx);

        if (c.EVP_DigestSignInit(ctx, null, md, null, self.key) != 1) return error.LibcryptoFailed;
        if (c.EVP_DigestSignUpdate(ctx, msg.ptr, msg.len) != 1) return error.LibcryptoFailed;

        var len: usize = out.len;
        if (c.EVP_DigestSignFinal(ctx, out.ptr, &len) != 1) return error.BufferTooShort;
        return out[0..len];
    }
};

fn p256KeyFromScalar(scalar: *const [32]u8) SignError!*c.EVP_PKEY {
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
pub fn signEcdsaP256Sha256(scalar: *const [32]u8, msg: []const u8, out: []u8) SignError![]const u8 {
    var key = try PrivateKey.fromP256Scalar(scalar);
    defer key.deinit();
    return key.sign(msg, out);
}
