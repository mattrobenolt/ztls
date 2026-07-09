//! AWS-LC backend primitive wrappers.
//!
//! X25519 uses AWS-LC's BoringSSL-style flat API. AEAD uses AWS-LC's
//! BoringSSL-style EVP_AEAD one-shot API. The remaining primitives delegate to
//! the OpenSSL-compatible implementation while the build recipe links AWS-LC's
//! libcrypto; those modules should diverge when a backend-specific fast path or
//! API difference warrants it.
const std = @import("std");
const assert = std.debug.assert;
const c = @import("c_openssl.zig").openssl;
const compat = @import("backend_openssl.zig");
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
    pub const client_p384 = true;
    pub const client_x25519_mlkem768 = false;
    pub const server_x25519 = true;
    pub const server_p256 = true;
    pub const server_p384 = true;
    pub const server_x25519_mlkem768 = false;

    pub const certificate_verify_schemes: []const SignatureScheme = &.{
        .ecdsa_secp256r1_sha256,
        .ecdsa_secp384r1_sha384,
        .rsa_pss_rsae_sha256,
        .rsa_pss_rsae_sha384,
    };

    // Match the current AWS-LC-linked signature facade. These are declared here,
    // not reexported from OpenSSL, so AWS-LC can diverge when provider/FIPS
    // version probing says it must.
    pub const certificate_signature_schemes: []const SignatureScheme = &.{
        .rsa_pkcs1_sha256,
        .rsa_pkcs1_sha384,
        .rsa_pkcs1_sha512,
        .ecdsa_secp256r1_sha256,
        .ecdsa_secp384r1_sha384,
    };
};

/// FIPS 140-3 narrowed capability table. The build option `aws-lc-fips`
/// selects this table at compile time. The caller is responsible for ensuring
/// the linked AWS-LC libcrypto is actually a FIPS-validated build. No runtime
/// provider probing is performed by ztls.
pub const capabilities_fips = struct {
    // FIPS 140-3 does not approve ChaCha20-Poly1305 for TLS 1.3.
    pub const cipher_suites: []const CipherSuite = &.{
        .aes_128_gcm_sha256,
        .aes_256_gcm_sha384,
    };

    pub const client_x25519 = true;
    pub const client_p256 = true;
    pub const client_p384 = true;
    // FIPS 140-3 does not approve ML-KEM (NIST FIPS 203 is not yet in the
    // 140-3 validated algorithms list as of 2026-07).
    pub const client_x25519_mlkem768 = false;
    pub const server_x25519 = true;
    pub const server_p256 = true;
    pub const server_p384 = true;
    pub const server_x25519_mlkem768 = false;

    pub const certificate_verify_schemes: []const SignatureScheme = &.{
        .ecdsa_secp256r1_sha256,
        .ecdsa_secp384r1_sha384,
        .rsa_pss_rsae_sha256,
        .rsa_pss_rsae_sha384,
    };

    // FIPS 140-3 does not approve RSA PKCS#1 v1.5 for TLS 1.3 certificate
    // signatures (only RSASSA-PSS is approved) and does not approve Ed25519.
    pub const certificate_signature_schemes: []const SignatureScheme = &.{
        .ecdsa_secp256r1_sha256,
        .ecdsa_secp384r1_sha384,
    };
};

pub const Error = compat.Error;
pub const pkey = compat.pkey;
// KEM functions are OpenSSL-only for now. AWS-LC 5.0 has the NID for
// X25519MLKEM768 but the EVP_PKEY keygen path doesn't support hybrid KEM
// yet. These stubs ensure the backend compiles; the capability flags are
// false so the KEM path is never reached under AWS-LC.
pub const KemKey = *c.EVP_PKEY;
pub const KemPeerKey = *c.EVP_PKEY;
pub fn kemKeygen(name: [*:0]const u8) compat.Error!KemKey {
    _ = name;
    return error.LibcryptoFailed;
}
pub fn kemPublic(key: KemKey, out: []u8) compat.Error![]u8 {
    _ = key;
    _ = out;
    return error.LibcryptoFailed;
}
pub fn kemLoadPublic(name: [*:0]const u8, pub_key: []const u8) compat.Error!KemPeerKey {
    _ = name;
    _ = pub_key;
    return error.LibcryptoFailed;
}
pub fn kemEncapsulate(
    peer: KemPeerKey,
    enc_out: []u8,
    sec_out: []u8,
) compat.Error!struct { enc: []u8, sec: []u8 } {
    _ = peer;
    _ = enc_out;
    _ = sec_out;
    return error.LibcryptoFailed;
}
pub fn kemDecapsulate(key: KemKey, enc: []const u8, sec_out: []u8) compat.Error![]u8 {
    _ = key;
    _ = enc;
    _ = sec_out;
    return error.LibcryptoFailed;
}
pub const freeKey = compat.freeKey;

pub const x25519_pkey = union(enum) {
    private: [32]u8,
    public: [32]u8,
};

pub fn privateKeyFromSecret(secret: *const [32]u8) Error!x25519_pkey {
    return .{ .private = secret.* };
}

pub fn publicKeyFromRaw(public_key: *const [32]u8) Error!x25519_pkey {
    return .{ .public = public_key.* };
}

pub fn rawPublicKeyFromPrivate(key: *const x25519_pkey) Error![32]u8 {
    assert(std.meta.activeTag(key.*) == .private);
    var public_key: [32]u8 = undefined;
    c.X25519_public_from_private(&public_key, &key.*.private);
    return public_key;
}

pub fn sharedSecretDerive(
    ours: *const x25519_pkey,
    peer: *const x25519_pkey,
    out: *[32]u8,
) Error!void {
    assert(std.meta.activeTag(ours.*) == .private);
    assert(std.meta.activeTag(peer.*) == .public);
    if (c.X25519(out, &ours.*.private, &peer.*.public) != 1) return error.IdentityElement;
    // RFC 7748 §6.1 — reject all-zero output from low-order peer public keys.
    if (std.crypto.timing_safe.eql([32]u8, out.*, @splat(0))) return error.IdentityElement;
}

pub fn x25519FreeKey(key: *x25519_pkey) void {
    switch (key.*) {
        .private => |*private| std.crypto.secureZero(u8, private),
        .public => {},
    }
    key.* = undefined;
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

pub inline fn p384PrivateKeyFromSecret(secret: *const [48]u8) Error!*pkey {
    return compat.p384PrivateKeyFromSecret(secret);
}

pub inline fn p384PublicKeyFromRaw(public_key: *const [97]u8) Error!*pkey {
    return compat.p384PublicKeyFromRaw(public_key);
}

pub inline fn p384RawPublicKeyFromPrivate(key: *pkey) Error![97]u8 {
    return compat.p384RawPublicKeyFromPrivate(key);
}

pub inline fn p384SharedSecretDerive(ours: *pkey, peer: *pkey, out: *[48]u8) Error!void {
    return compat.p384SharedSecretDerive(ours, peer, out);
}

pub const AeadError = compat.AeadError;
pub const AeadContext = struct {
    ctx: c.EVP_AEAD_CTX,
};
pub const aead_tag_len = compat.aead_tag_len;
pub const aead_nonce_len = compat.aead_nonce_len;

fn aeadCipher(suite: CipherSuite) *const c.EVP_AEAD {
    return switch (suite) {
        .aes_128_gcm_sha256 => c.EVP_aead_aes_128_gcm(),
        .aes_256_gcm_sha384 => c.EVP_aead_aes_256_gcm(),
        .chacha20_poly1305_sha256 => c.EVP_aead_chacha20_poly1305(),
    } orelse unreachable;
}

pub fn aeadInit(suite: CipherSuite, key_bytes: []const u8) AeadError!AeadContext {
    var ctx: AeadContext = undefined;
    c.EVP_AEAD_CTX_zero(&ctx.ctx);
    if (c.EVP_AEAD_CTX_init(
        &ctx.ctx,
        aeadCipher(suite),
        key_bytes.ptr,
        key_bytes.len,
        aead_tag_len,
        null,
    ) != 1) {
        c.EVP_AEAD_CTX_cleanup(&ctx.ctx);
        c.EVP_AEAD_CTX_zero(&ctx.ctx);
        return error.AeadSetupFailed;
    }
    return ctx;
}

pub fn aeadDeinit(ctx: *AeadContext) void {
    c.EVP_AEAD_CTX_cleanup(&ctx.ctx);
    c.EVP_AEAD_CTX_zero(&ctx.ctx);
}

pub fn aeadEncrypt(
    ctx: *AeadContext,
    ciphertext: []u8,
    tag: *[aead_tag_len]u8,
    plaintext: []const u8,
    ad: []const u8,
    npub: *const [aead_nonce_len]u8,
) AeadError!void {
    assert(ciphertext.len == plaintext.len);
    var tag_len: usize = 0;
    if (c.EVP_AEAD_CTX_seal_scatter(
        &ctx.ctx,
        ciphertext.ptr,
        tag,
        &tag_len,
        tag.len,
        npub,
        npub.len,
        plaintext.ptr,
        plaintext.len,
        null,
        0,
        ad.ptr,
        ad.len,
    ) != 1) return error.AeadEncryptFailed;
    if (tag_len != tag.len) return error.AeadEncryptFailed;
}

pub fn aeadDecrypt(
    ctx: *AeadContext,
    plaintext: []u8,
    ciphertext: []const u8,
    tag: *const [aead_tag_len]u8,
    ad: []const u8,
    npub: *const [aead_nonce_len]u8,
) AeadError!void {
    assert(plaintext.len == ciphertext.len);
    if (c.EVP_AEAD_CTX_open_gather(
        &ctx.ctx,
        plaintext.ptr,
        npub,
        npub.len,
        ciphertext.ptr,
        ciphertext.len,
        tag,
        tag.len,
        ad.ptr,
        ad.len,
    ) != 1) return error.AuthenticationFailed;
}

pub const SignatureError = compat.SignatureError;
pub const EcCurve = compat.EcCurve;

pub inline fn privateKeyFromDer(der: []const u8) SignatureError!*pkey {
    return compat.privateKeyFromDer(der);
}

pub inline fn privateKeyFromPem(pem: []const u8) SignatureError!*pkey {
    return compat.privateKeyFromPem(pem);
}

pub inline fn privateKeyFromP256Scalar(scalar: *const [32]u8) SignatureError!*pkey {
    return compat.privateKeyFromP256Scalar(scalar);
}

pub inline fn ecPublicKeyFromSec1(
    comptime curve: EcCurve,
    pub_key: []const u8,
) SignatureError!*pkey {
    return compat.ecPublicKeyFromSec1(curve, pub_key);
}

pub inline fn rsaPublicKeyFromDer(pub_key: []const u8) SignatureError!*pkey {
    return compat.rsaPublicKeyFromDer(pub_key);
}

pub inline fn signatureSign(
    key: *pkey,
    scheme: SignatureScheme,
    msg: []const u8,
    out: []u8,
) SignatureError![]const u8 {
    return compat.signatureSign(key, scheme, msg, out);
}

pub inline fn signatureVerify(
    key: *pkey,
    scheme: SignatureScheme,
    context: []const u8,
    transcript_hash: []const u8,
    sig: []const u8,
) SignatureError!void {
    return compat.signatureVerify(key, scheme, context, transcript_hash, sig);
}
