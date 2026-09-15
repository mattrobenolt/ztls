//! BoringSSL backend primitive wrappers.
//!
//! X25519 uses BoringSSL's flat `curve25519.h` API. AEAD uses BoringSSL's
//! `EVP_AEAD` one-shot API. The remaining primitives (EC P-256/P-384 key
//! construction, ECDH, RSA-PSS/ECDSA sign+verify) delegate to the
//! OpenSSL-compatible implementation in `backend_openssl.zig`, which uses the
//! legacy `EC_KEY_*` / `EVP_PKEY_assign_*` / `d2i_*` / `EVP_DigestSign*` API
//! family. BoringSSL does not expose the OpenSSL 3.x provider API —
//! `EVP_PKEY_fromdata`, `OSSL_PARAM`, `OSSL_PROVIDER`,
//! `EVP_PKEY_CTX_new_from_name` are absent from the BoringSSL headers. The
//! legacy API is the only key-construction/signature path BoringSSL provides.
//! `c_openssl.zig` excludes `core.h`, `core_names.h`, and `params.h` from the
//! BoringSSL `@cImport`.
//!
//! Pure ML-KEM uses BoringSSL's EVP_PKEY_ALG and EVP_KEM interfaces. ztls owns
//! the RFC 10024 hybrid composition so the wire construction is backend-neutral.
const std = @import("std");
const assert = std.debug.assert;
const c = @import("c_openssl.zig").openssl;
const compat = @import("backend_openssl.zig");
const CipherSuite = @import("../cipher_suite.zig").CipherSuite;
const ParameterSet = @import("mlkem_parameters.zig").ParameterSet;
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
    pub const client_x25519_mlkem768 = true;
    pub const client_secp256r1_mlkem768 = true;
    pub const client_secp384r1_mlkem1024 = true;
    pub const server_x25519 = true;
    pub const server_p256 = true;
    pub const server_p384 = true;
    pub const server_x25519_mlkem768 = true;
    pub const server_secp256r1_mlkem768 = true;
    pub const server_secp384r1_mlkem1024 = true;

    pub const certificate_verify_schemes: []const SignatureScheme = &.{
        .ecdsa_secp256r1_sha256,
        .ecdsa_secp384r1_sha384,
        .rsa_pss_rsae_sha256,
        .rsa_pss_rsae_sha384,
    };

    // RFC 8446 §4.4.2.2 — signature_algorithms_cert constrains the
    // certificate-chain signature algorithm (cert-to-cert), which is
    // independent of the CertificateVerify scheme (§4.4.3). Ed25519 chain
    // signatures are verified via std.crypto.sign.Ed25519 in
    // certificate_parser.zig, not the backend seam, so they are advertised
    // here even though certificate_verify_schemes omits ed25519.
    pub const certificate_signature_schemes: []const SignatureScheme = &.{
        .rsa_pkcs1_sha256,
        .rsa_pkcs1_sha384,
        .rsa_pkcs1_sha512,
        .ecdsa_secp256r1_sha256,
        .ecdsa_secp384r1_sha384,
        .ed25519,
    };
};

pub const Error = compat.Error;
pub const pkey = compat.pkey;
pub const KemKey = *c.EVP_PKEY;
pub const KemPeerKey = *c.EVP_PKEY;

fn kemAlgorithm(parameter_set: ParameterSet) *const c.EVP_PKEY_ALG {
    return switch (parameter_set) {
        .mlkem768 => c.EVP_pkey_ml_kem_768() orelse unreachable,
        .mlkem1024 => c.EVP_pkey_ml_kem_1024() orelse unreachable,
    };
}

fn kemImplementation(parameter_set: ParameterSet) *const c.EVP_KEM {
    return switch (parameter_set) {
        .mlkem768 => c.EVP_kem_ml_kem_768() orelse unreachable,
        .mlkem1024 => c.EVP_kem_ml_kem_1024() orelse unreachable,
    };
}

pub fn kemKeygen(parameter_set: ParameterSet) Error!KemKey {
    compat.errqEnter();
    defer compat.errqExit();
    return c.EVP_PKEY_generate_from_alg(kemAlgorithm(parameter_set)) orelse
        error.LibcryptoFailed;
}

pub fn kemPublic(key: KemKey, out: []u8) Error![]u8 {
    compat.errqEnter();
    defer compat.errqExit();
    var len: usize = out.len;
    if (c.EVP_PKEY_get_raw_public_key(key, out.ptr, &len) != 1)
        return error.LibcryptoFailed;
    return out[0..len];
}

pub fn kemLoadPublic(
    parameter_set: ParameterSet,
    public_key: []const u8,
) Error!KemPeerKey {
    compat.errqEnter();
    defer compat.errqExit();
    return c.EVP_PKEY_from_raw_public_key(
        kemAlgorithm(parameter_set),
        public_key.ptr,
        public_key.len,
    ) orelse error.IdentityElement;
}

pub fn kemEncapsulate(
    parameter_set: ParameterSet,
    peer: KemPeerKey,
    ciphertext_out: []u8,
    secret_out: []u8,
) Error!struct { ciphertext: []u8, secret: []u8 } {
    compat.errqEnter();
    defer compat.errqExit();
    const kem = kemImplementation(parameter_set);
    const ciphertext_len = c.EVP_KEM_ciphertext_len(kem);
    const secret_len = c.EVP_KEM_secret_len(kem);
    if (ciphertext_out.len < ciphertext_len or secret_out.len < secret_len)
        return error.LibcryptoFailed;
    if (c.EVP_KEM_encap(
        kem,
        ciphertext_out.ptr,
        ciphertext_len,
        secret_out.ptr,
        secret_len,
        peer,
    ) != 1) return error.LibcryptoFailed;
    return .{
        .ciphertext = ciphertext_out[0..ciphertext_len],
        .secret = secret_out[0..secret_len],
    };
}

pub fn kemDecapsulate(
    parameter_set: ParameterSet,
    key: KemKey,
    ciphertext: []const u8,
    secret_out: []u8,
) Error![]u8 {
    compat.errqEnter();
    defer compat.errqExit();
    const kem = kemImplementation(parameter_set);
    const secret_len = c.EVP_KEM_secret_len(kem);
    if (secret_out.len < secret_len) return error.LibcryptoFailed;
    if (c.EVP_KEM_decap(
        kem,
        secret_out.ptr,
        secret_len,
        ciphertext.ptr,
        ciphertext.len,
        key,
    ) != 1) return error.LibcryptoFailed;
    return secret_out[0..secret_len];
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
    // Outermost public entry point: the only guard on this path (#88
    // finding 2 — see the hygiene comment in backend_openssl.zig).
    compat.errqEnter();
    defer compat.errqExit();
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
    // Per key-schedule, not per record: the unconditional guard is free here
    // (#88 finding 2 — see the hygiene comment in backend_openssl.zig).
    compat.errqEnter();
    defer compat.errqExit();
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
    compat.errqEnter();
    defer compat.errqExit();
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
    compat.errqEnter();
    defer compat.errqExit();
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
pub const SignError = compat.SignError;
pub const NonceMode = compat.NonceMode;
pub const supports_deterministic_nonce = compat.supports_deterministic_nonce;
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
    nonce_mode: NonceMode,
) SignError![]const u8 {
    return compat.signatureSign(key, scheme, msg, out, nonce_mode);
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
