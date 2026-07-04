//! OpenSSL backend primitive wrappers.
const std = @import("std");

const c = @import("c_openssl.zig").openssl;
const CipherSuite = @import("../cipher_suite.zig").CipherSuite;
const SignatureScheme = @import("../signature_scheme.zig").SignatureScheme;

pub const capabilities = struct {
    pub const cipher_suites: []const CipherSuite = &.{
        .aes_128_gcm_sha256,
        .aes_256_gcm_sha384,
        .chacha20_poly1305_sha256,
    };

    pub const client_x25519 = true;
    pub const client_p256 = true;
    pub const server_x25519 = true;
    pub const server_p256 = true;

    pub const certificate_verify_schemes: []const SignatureScheme = &.{
        .ecdsa_secp256r1_sha256,
        .ecdsa_secp384r1_sha384,
        .rsa_pss_rsae_sha256,
        .rsa_pss_rsae_sha384,
    };

    // Keep signature_algorithms_cert aligned with the current CertificateVerify
    // public-key path. Ed25519 chain signatures are not advertised until ztls can
    // also complete an Ed25519 leaf CertificateVerify under the backend seam.
    pub const certificate_signature_schemes: []const SignatureScheme = &.{
        .rsa_pkcs1_sha256,
        .rsa_pkcs1_sha384,
        .rsa_pkcs1_sha512,
        .ecdsa_secp256r1_sha256,
        .ecdsa_secp384r1_sha384,
    };
};

pub const Error = error{ LibcryptoFailed, IdentityElement };
pub const pkey = c.EVP_PKEY;
pub const x25519_pkey = *pkey;

pub fn privateKeyFromSecret(secret: *const [32]u8) Error!x25519_pkey {
    return c.EVP_PKEY_new_raw_private_key(
        c.EVP_PKEY_X25519,
        null,
        secret,
        secret.len,
    ) orelse error.LibcryptoFailed;
}

pub fn publicKeyFromRaw(public_key: *const [32]u8) Error!x25519_pkey {
    return c.EVP_PKEY_new_raw_public_key(
        c.EVP_PKEY_X25519,
        null,
        public_key,
        public_key.len,
    ) orelse error.LibcryptoFailed;
}

pub fn rawPublicKeyFromPrivate(key: *const x25519_pkey) Error![32]u8 {
    var public_key: [32]u8 = undefined;
    var len: usize = public_key.len;
    if (c.EVP_PKEY_get_raw_public_key(key.*, &public_key, &len) != 1) return error.LibcryptoFailed;
    if (len != public_key.len) return error.LibcryptoFailed;
    return public_key;
}

pub fn sharedSecretDerive(
    ours: *const x25519_pkey,
    peer: *const x25519_pkey,
    out: *[32]u8,
) Error!void {
    const ctx = c.EVP_PKEY_CTX_new(ours.*, null) orelse return error.LibcryptoFailed;
    defer c.EVP_PKEY_CTX_free(ctx);
    if (c.EVP_PKEY_derive_init(ctx) != 1) return error.LibcryptoFailed;
    if (c.EVP_PKEY_derive_set_peer(ctx, peer.*) != 1) return error.LibcryptoFailed;

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
    var ptr: [*]u8 = &public_key;
    len = c.i2o_ECPublicKey(ec, @ptrCast(&ptr));
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
}

pub fn x25519FreeKey(key: *x25519_pkey) void {
    c.EVP_PKEY_free(key.*);
    key.* = undefined;
}

pub fn freeKey(key: *pkey) void {
    c.EVP_PKEY_free(key);
}

pub const AeadError = error{
    AuthenticationFailed,
    AeadSetupFailed,
    AeadEncryptFailed,
};

pub const AeadContext = struct {
    enc: *c.EVP_CIPHER_CTX,
    dec: *c.EVP_CIPHER_CTX,
};

pub const aead_tag_len = 16;
pub const aead_nonce_len = 12;

fn aeadCipher(suite: CipherSuite) *const c.EVP_CIPHER {
    return switch (suite) {
        .aes_128_gcm_sha256 => c.EVP_aes_128_gcm(),
        .aes_256_gcm_sha384 => c.EVP_aes_256_gcm(),
        .chacha20_poly1305_sha256 => c.EVP_chacha20_poly1305(),
    } orelse unreachable;
}

pub fn aeadInit(suite: CipherSuite, key_bytes: []const u8) AeadError!AeadContext {
    const enc = c.EVP_CIPHER_CTX_new() orelse return error.AeadSetupFailed;
    errdefer c.EVP_CIPHER_CTX_free(enc);
    const dec = c.EVP_CIPHER_CTX_new() orelse return error.AeadSetupFailed;
    errdefer c.EVP_CIPHER_CTX_free(dec);

    if (c.EVP_EncryptInit_ex(enc, aeadCipher(suite), null, null, null) != 1)
        return error.AeadSetupFailed;
    if (c.EVP_CIPHER_CTX_ctrl(enc, c.EVP_CTRL_AEAD_SET_IVLEN, aead_nonce_len, null) != 1)
        return error.AeadSetupFailed;
    if (c.EVP_EncryptInit_ex(enc, null, null, key_bytes.ptr, null) != 1)
        return error.AeadSetupFailed;

    if (c.EVP_DecryptInit_ex(dec, aeadCipher(suite), null, null, null) != 1)
        return error.AeadSetupFailed;
    if (c.EVP_CIPHER_CTX_ctrl(dec, c.EVP_CTRL_AEAD_SET_IVLEN, aead_nonce_len, null) != 1)
        return error.AeadSetupFailed;
    if (c.EVP_DecryptInit_ex(dec, null, null, key_bytes.ptr, null) != 1)
        return error.AeadSetupFailed;

    return .{ .enc = enc, .dec = dec };
}

pub fn aeadDeinit(ctx: *AeadContext) void {
    c.EVP_CIPHER_CTX_free(ctx.enc);
    c.EVP_CIPHER_CTX_free(ctx.dec);
    ctx.* = undefined;
}

pub fn aeadEncrypt(
    ctx: *AeadContext,
    ciphertext: []u8,
    tag: *[aead_tag_len]u8,
    plaintext: []const u8,
    ad: []const u8,
    npub: *const [aead_nonce_len]u8,
) AeadError!void {
    var len: c_int = 0;
    var out_len: c_int = 0;
    if (c.EVP_EncryptInit_ex(ctx.enc, null, null, null, npub) != 1)
        return error.AeadEncryptFailed;
    if (c.EVP_EncryptUpdate(ctx.enc, null, &len, ad.ptr, @intCast(ad.len)) != 1)
        return error.AeadEncryptFailed;
    if (c.EVP_EncryptUpdate(
        ctx.enc,
        ciphertext.ptr,
        &len,
        plaintext.ptr,
        @intCast(plaintext.len),
    ) != 1) return error.AeadEncryptFailed;
    out_len += len;
    if (c.EVP_EncryptFinal_ex(ctx.enc, ciphertext.ptr + @as(usize, @intCast(out_len)), &len) != 1)
        return error.AeadEncryptFailed;
    if (c.EVP_CIPHER_CTX_ctrl(ctx.enc, c.EVP_CTRL_AEAD_GET_TAG, aead_tag_len, tag) != 1)
        return error.AeadEncryptFailed;
}

pub fn aeadDecrypt(
    ctx: *AeadContext,
    plaintext: []u8,
    ciphertext: []const u8,
    tag: *const [aead_tag_len]u8,
    ad: []const u8,
    npub: *const [aead_nonce_len]u8,
) AeadError!void {
    var len: c_int = 0;
    var out_len: c_int = 0;
    if (c.EVP_DecryptInit_ex(ctx.dec, null, null, null, npub) != 1)
        return error.AuthenticationFailed;
    if (c.EVP_DecryptUpdate(ctx.dec, null, &len, ad.ptr, @intCast(ad.len)) != 1)
        return error.AuthenticationFailed;
    // EVP_DecryptUpdate writes plaintext to `plaintext` before
    // EVP_DecryptFinal_ex verifies the tag — the output buffer
    // holds unauthenticated data until the call succeeds.
    if (c.EVP_DecryptUpdate(
        ctx.dec,
        plaintext.ptr,
        &len,
        ciphertext.ptr,
        @intCast(ciphertext.len),
    ) != 1) return error.AuthenticationFailed;
    out_len += len;
    if (c.EVP_CIPHER_CTX_ctrl(
        ctx.dec,
        c.EVP_CTRL_AEAD_SET_TAG,
        aead_tag_len,
        // OpenSSL's control API takes a mutable pointer, but SET_TAG reads it.
        @constCast(tag),
    ) != 1) return error.AuthenticationFailed;
    if (c.EVP_DecryptFinal_ex(ctx.dec, plaintext.ptr + @as(usize, @intCast(out_len)), &len) != 1)
        return error.AuthenticationFailed;
}

pub const SignatureError = error{
    BufferTooShort,
    InvalidEncoding,
    LibcryptoFailed,
    SignatureVerificationFailed,
    UnsupportedSignatureScheme,
};

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

fn signatureDigest(scheme: SignatureScheme) SignatureError!*const c.EVP_MD {
    return switch (scheme) {
        .ecdsa_secp256r1_sha256, .rsa_pss_rsae_sha256 => c.EVP_sha256(),
        .ecdsa_secp384r1_sha384, .rsa_pss_rsae_sha384 => c.EVP_sha384(),
        .rsa_pss_rsae_sha512 => c.EVP_sha512(),
        else => return error.UnsupportedSignatureScheme,
    } orelse return error.LibcryptoFailed;
}

fn configureRsaPss(
    ctx: ?*c.EVP_PKEY_CTX,
    scheme: SignatureScheme,
    md: *const c.EVP_MD,
) SignatureError!void {
    switch (scheme) {
        .rsa_pss_rsae_sha256, .rsa_pss_rsae_sha384, .rsa_pss_rsae_sha512 => {
            if (c.EVP_PKEY_CTX_set_rsa_padding(ctx, c.RSA_PKCS1_PSS_PADDING) != 1)
                return error.LibcryptoFailed;
            if (c.EVP_PKEY_CTX_set_rsa_mgf1_md(ctx, md) != 1)
                return error.LibcryptoFailed;
            if (c.EVP_PKEY_CTX_set_rsa_pss_saltlen(ctx, c.RSA_PSS_SALTLEN_DIGEST) != 1)
                return error.LibcryptoFailed;
        },
        else => {},
    }
}

pub fn privateKeyFromDer(der: []const u8) SignatureError!*pkey {
    var ptr: ?[*]const u8 = der.ptr;
    return c.d2i_AutoPrivateKey(null, &ptr, @intCast(der.len)) orelse error.LibcryptoFailed;
}

pub fn privateKeyFromPem(pem: []const u8) SignatureError!*pkey {
    const bio = c.BIO_new_mem_buf(pem.ptr, @intCast(pem.len)) orelse
        return error.LibcryptoFailed;
    defer _ = c.BIO_free(bio);
    return c.PEM_read_bio_PrivateKey(bio, null, null, null) orelse error.LibcryptoFailed;
}

pub fn privateKeyFromP256Scalar(scalar: *const [32]u8) SignatureError!*pkey {
    return p256PrivateKeyFromSecret(scalar) catch |err| switch (err) {
        error.LibcryptoFailed, error.IdentityElement => error.LibcryptoFailed,
    };
}

pub fn ecPublicKeyFromSec1(
    comptime curve: EcCurve,
    pub_key: []const u8,
) SignatureError!*pkey {
    var ec: ?*c.EC_KEY = c.EC_KEY_new_by_curve_name(curve.nid()) orelse
        return error.InvalidEncoding;
    errdefer c.EC_KEY_free(ec);

    var ptr: ?[*]const u8 = pub_key.ptr;
    if (c.o2i_ECPublicKey(&ec, &ptr, @intCast(pub_key.len)) == null)
        return error.InvalidEncoding;
    if (c.EC_KEY_check_key(ec) != 1) return error.InvalidEncoding;

    const key = c.EVP_PKEY_new() orelse return error.SignatureVerificationFailed;
    errdefer c.EVP_PKEY_free(key);
    if (c.EVP_PKEY_assign_EC_KEY(key, ec) != 1)
        return error.SignatureVerificationFailed;
    return key;
}

pub fn rsaPublicKeyFromDer(pub_key: []const u8) SignatureError!*pkey {
    var ptr: ?[*]const u8 = pub_key.ptr;
    const rsa = c.d2i_RSAPublicKey(null, &ptr, @intCast(pub_key.len)) orelse
        return error.InvalidEncoding;
    errdefer c.RSA_free(rsa);

    const key = c.EVP_PKEY_new() orelse return error.SignatureVerificationFailed;
    errdefer c.EVP_PKEY_free(key);
    if (c.EVP_PKEY_assign_RSA(key, rsa) != 1)
        return error.SignatureVerificationFailed;
    return key;
}

pub fn signatureSign(
    key: *pkey,
    scheme: SignatureScheme,
    msg: []const u8,
    out: []u8,
) SignatureError![]const u8 {
    const md = try signatureDigest(scheme);
    const ctx = c.EVP_MD_CTX_new() orelse return error.LibcryptoFailed;
    defer c.EVP_MD_CTX_free(ctx);

    var pctx: ?*c.EVP_PKEY_CTX = null;
    if (c.EVP_DigestSignInit(ctx, &pctx, md, null, key) != 1) return error.LibcryptoFailed;
    try configureRsaPss(pctx, scheme, md);
    if (c.EVP_DigestSignUpdate(ctx, msg.ptr, msg.len) != 1) return error.LibcryptoFailed;

    var required_len: usize = 0;
    if (c.EVP_DigestSignFinal(ctx, null, &required_len) != 1) return error.LibcryptoFailed;
    if (out.len < required_len) return error.BufferTooShort;

    var len: usize = out.len;
    if (c.EVP_DigestSignFinal(ctx, out.ptr, &len) != 1) return error.LibcryptoFailed;
    return out[0..len];
}

pub fn signatureVerify(
    key: *pkey,
    scheme: SignatureScheme,
    context: []const u8,
    transcript_hash: []const u8,
    sig: []const u8,
) SignatureError!void {
    const md = try signatureDigest(scheme);
    const ctx = c.EVP_MD_CTX_new() orelse return error.SignatureVerificationFailed;
    defer c.EVP_MD_CTX_free(ctx);

    var pctx: ?*c.EVP_PKEY_CTX = null;
    if (c.EVP_DigestVerifyInit(ctx, &pctx, md, null, key) != 1)
        return error.SignatureVerificationFailed;
    configureRsaPss(pctx, scheme, md) catch return error.SignatureVerificationFailed;
    if (c.EVP_DigestVerifyUpdate(ctx, context.ptr, context.len) != 1)
        return error.SignatureVerificationFailed;
    if (c.EVP_DigestVerifyUpdate(ctx, transcript_hash.ptr, transcript_hash.len) != 1)
        return error.SignatureVerificationFailed;
    if (c.EVP_DigestVerifyFinal(ctx, sig.ptr, sig.len) != 1)
        return error.SignatureVerificationFailed;
}
