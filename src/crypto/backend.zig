//! Libcrypto-family provider selection.
//!
//! This is the narrow compile-time facade used while the concrete OpenSSL
//! calls still live in the existing primitive modules. It gives future AWS-LC /
//! BoringSSL ports one typed switch point instead of scattering product names
//! through handshake code.
const std = @import("std");
const testing = std.testing;
const assert = std.debug.assert;
const build_options = @import("build_options");

const CipherSuite = @import("../cipher_suite.zig").CipherSuite;
const SignatureScheme = @import("../signature_scheme.zig").SignatureScheme;
const backend_aws_lc = @import("backend_aws_lc.zig");
const backend_boringssl = @import("backend_boringssl.zig");
const backend_openssl = @import("backend_openssl.zig");

// Backend kind enum is emitted into `build_options` by build.zig (see
// `build.Backend`). Field names are the wire strings, so @tagName round-trips
// to the CLI/metadata value.

pub const active = build_options.crypto_backend;

/// True when the active backend is a FIPS-narrowed capability identity.
/// The FIPS tables drop non-approved algorithms (ChaCha20-Poly1305, RSA PKCS1
/// v1.5 certificate signatures, Ed25519, ML-KEM) at compile time. The caller
/// is responsible for ensuring the linked libcrypto is actually in FIPS mode.
pub const is_fips: bool = switch (active) {
    .openssl, .@"aws-lc", .boringssl => false,
    .@"openssl-fips", .@"aws-lc-fips" => true,
};

const x25519_impl = switch (active) {
    .openssl, .@"openssl-fips" => backend_openssl,
    .@"aws-lc", .@"aws-lc-fips" => backend_aws_lc,
    .boringssl => backend_boringssl,
};

const p256_impl = switch (active) {
    .openssl, .@"openssl-fips" => backend_openssl,
    .@"aws-lc", .@"aws-lc-fips" => backend_aws_lc,
    .boringssl => backend_boringssl,
};

const p384_impl = switch (active) {
    .openssl, .@"openssl-fips" => backend_openssl,
    .@"aws-lc", .@"aws-lc-fips" => backend_aws_lc,
    .boringssl => backend_boringssl,
};

const aead_impl = switch (active) {
    .openssl, .@"openssl-fips" => backend_openssl,
    .@"aws-lc", .@"aws-lc-fips" => backend_aws_lc,
    .boringssl => backend_boringssl,
};

const sign_impl = switch (active) {
    .openssl, .@"openssl-fips" => backend_openssl,
    .@"aws-lc", .@"aws-lc-fips" => backend_aws_lc,
    .boringssl => backend_boringssl,
};

pub const kem_impl = switch (active) {
    .openssl, .@"openssl-fips" => backend_openssl,
    .@"aws-lc", .@"aws-lc-fips" => backend_aws_lc,
    .boringssl => backend_boringssl,
};

pub const capabilities = switch (active) {
    .openssl => backend_openssl.capabilities,
    .@"openssl-fips" => backend_openssl.capabilities_fips,
    .@"aws-lc" => backend_aws_lc.capabilities,
    .@"aws-lc-fips" => backend_aws_lc.capabilities_fips,
    .boringssl => backend_boringssl.capabilities,
};

comptime {
    assert(capabilities.cipher_suites.len > 0);
    assert(capabilities.client_x25519 or capabilities.client_p256);
    assert(capabilities.server_x25519 or capabilities.server_p256);
    assert(capabilities.certificate_verify_schemes.len > 0);
    assert(capabilities.certificate_signature_schemes.len > 0);
    assert(capabilities.client_p384 == capabilities.server_p384);
    assert(
        capabilities.client_x25519_mlkem768 == capabilities.server_x25519_mlkem768,
    );

    // FIPS capability tables must be a strict subset of their non-FIPS
    // counterparts: every cipher suite and signature scheme advertised under
    // FIPS must also appear in the non-FIPS table. This is checked at compile
    // time for both backends so a FIPS table drift is caught even when the
    // active build is non-FIPS.
    assertSubset(backend_openssl.capabilities_fips.cipher_suites, backend_openssl.capabilities.cipher_suites);
    assertSubset(backend_openssl.capabilities_fips.certificate_verify_schemes, backend_openssl.capabilities.certificate_verify_schemes);
    assertSubset(backend_openssl.capabilities_fips.certificate_signature_schemes, backend_openssl.capabilities.certificate_signature_schemes);
    assertSubset(backend_aws_lc.capabilities_fips.cipher_suites, backend_aws_lc.capabilities.cipher_suites);
    assertSubset(backend_aws_lc.capabilities_fips.certificate_verify_schemes, backend_aws_lc.capabilities.certificate_verify_schemes);
    assertSubset(backend_aws_lc.capabilities_fips.certificate_signature_schemes, backend_aws_lc.capabilities.certificate_signature_schemes);
}

fn assertSubset(comptime fips: anytype, comptime base: anytype) void {
    for (fips) |item| {
        var found = false;
        for (base) |b| {
            if (item == b) {
                found = true;
                break;
            }
        }
        assert(found);
    }
}

pub fn supportsCipherSuite(suite: CipherSuite) bool {
    for (capabilities.cipher_suites) |supported| {
        if (supported == suite) return true;
    }
    return false;
}

pub fn supportsServerX25519() bool {
    return capabilities.server_x25519;
}

pub fn supportsServerP256() bool {
    return capabilities.server_p256;
}

pub fn supportsServerP384() bool {
    return capabilities.server_p384;
}

pub fn supportsServerX25519Mlkem768() bool {
    return capabilities.server_x25519_mlkem768;
}

pub fn supportsCertificateVerifyScheme(scheme: SignatureScheme) bool {
    for (capabilities.certificate_verify_schemes) |supported| {
        if (supported == scheme) return true;
    }
    return false;
}

pub const x25519 = struct {
    pub const Error = x25519_impl.Error;
    pub const pkey = x25519_impl.x25519_pkey;

    pub inline fn privateKeyFromSecret(secret: *const [32]u8) Error!pkey {
        return x25519_impl.privateKeyFromSecret(secret);
    }

    pub inline fn publicKeyFromRaw(public_key: *const [32]u8) Error!pkey {
        return x25519_impl.publicKeyFromRaw(public_key);
    }

    pub inline fn rawPublicKeyFromPrivate(key: *const pkey) Error![32]u8 {
        return x25519_impl.rawPublicKeyFromPrivate(key);
    }

    pub inline fn sharedSecretDerive(
        ours: *const pkey,
        peer: *const pkey,
        out: *[32]u8,
    ) Error!void {
        return x25519_impl.sharedSecretDerive(ours, peer, out);
    }

    pub inline fn freeKey(key: *pkey) void {
        x25519_impl.x25519FreeKey(key);
    }
};

pub const p256 = struct {
    pub const Error = p256_impl.Error;
    pub const pkey = p256_impl.pkey;

    pub inline fn privateKeyFromSecret(secret: *const [32]u8) Error!*pkey {
        return p256_impl.p256PrivateKeyFromSecret(secret);
    }

    pub inline fn publicKeyFromRaw(public_key: *const [65]u8) Error!*pkey {
        return p256_impl.p256PublicKeyFromRaw(public_key);
    }

    pub inline fn rawPublicKeyFromPrivate(key: *pkey) Error![65]u8 {
        return p256_impl.p256RawPublicKeyFromPrivate(key);
    }

    pub inline fn sharedSecretDerive(ours: *pkey, peer: *pkey, out: *[32]u8) Error!void {
        return p256_impl.p256SharedSecretDerive(ours, peer, out);
    }

    pub inline fn freeKey(key: *pkey) void {
        p256_impl.freeKey(key);
    }
};

pub const p384 = struct {
    pub const Error = p384_impl.Error;
    pub const pkey = p384_impl.pkey;

    pub inline fn privateKeyFromSecret(secret: *const [48]u8) Error!*pkey {
        return p384_impl.p384PrivateKeyFromSecret(secret);
    }

    pub inline fn publicKeyFromRaw(public_key: *const [97]u8) Error!*pkey {
        return p384_impl.p384PublicKeyFromRaw(public_key);
    }

    pub inline fn rawPublicKeyFromPrivate(key: *pkey) Error![97]u8 {
        return p384_impl.p384RawPublicKeyFromPrivate(key);
    }

    pub inline fn sharedSecretDerive(ours: *pkey, peer: *pkey, out: *[48]u8) Error!void {
        return p384_impl.p384SharedSecretDerive(ours, peer, out);
    }

    pub inline fn freeKey(key: *pkey) void {
        p384_impl.freeKey(key);
    }
};

pub const aead = struct {
    pub const Error = aead_impl.AeadError;
    pub const Context = aead_impl.AeadContext;
    pub const tag_len = aead_impl.aead_tag_len;
    pub const nonce_len = aead_impl.aead_nonce_len;

    pub inline fn init(suite: CipherSuite, key_bytes: []const u8) Error!Context {
        return aead_impl.aeadInit(suite, key_bytes);
    }

    pub inline fn deinit(ctx: *Context) void {
        aead_impl.aeadDeinit(ctx);
        ctx.* = undefined;
    }

    pub inline fn encrypt(
        ctx: *Context,
        ciphertext: []u8,
        tag: *[tag_len]u8,
        plaintext: []const u8,
        ad: []const u8,
        npub: *const [nonce_len]u8,
    ) Error!void {
        return aead_impl.aeadEncrypt(ctx, ciphertext, tag, plaintext, ad, npub);
    }

    pub inline fn decrypt(
        ctx: *Context,
        plaintext: []u8,
        ciphertext: []const u8,
        tag: *const [tag_len]u8,
        ad: []const u8,
        npub: *const [nonce_len]u8,
    ) Error!void {
        return aead_impl.aeadDecrypt(ctx, plaintext, ciphertext, tag, ad, npub);
    }
};

pub const sign = struct {
    pub const Error = sign_impl.SignatureError;
    pub const EcCurve = sign_impl.EcCurve;
    pub const pkey = sign_impl.pkey;

    pub inline fn privateKeyFromDer(der: []const u8) Error!*pkey {
        return sign_impl.privateKeyFromDer(der);
    }

    pub inline fn privateKeyFromPem(pem: []const u8) Error!*pkey {
        return sign_impl.privateKeyFromPem(pem);
    }

    pub inline fn privateKeyFromP256Scalar(scalar: *const [32]u8) Error!*pkey {
        return sign_impl.privateKeyFromP256Scalar(scalar);
    }

    pub inline fn ecPublicKeyFromSec1(comptime curve: EcCurve, pub_key: []const u8) Error!*pkey {
        return sign_impl.ecPublicKeyFromSec1(curve, pub_key);
    }

    pub inline fn rsaPublicKeyFromDer(pub_key: []const u8) Error!*pkey {
        return sign_impl.rsaPublicKeyFromDer(pub_key);
    }

    pub inline fn freeKey(key: *pkey) void {
        sign_impl.freeKey(key);
    }

    pub inline fn sign(
        key: *pkey,
        scheme: SignatureScheme,
        msg: []const u8,
        out: []u8,
    ) Error![]const u8 {
        return sign_impl.signatureSign(key, scheme, msg, out);
    }

    pub inline fn verify(
        key: *pkey,
        scheme: SignatureScheme,
        context: []const u8,
        transcript_hash: []const u8,
        sig: []const u8,
    ) Error!void {
        return sign_impl.signatureVerify(key, scheme, context, transcript_hash, sig);
    }
};

// docs/research/PROVIDER_INTERFACE.md §1 — current production backend is
// OpenSSL/libcrypto; AWS-LC and BoringSSL are selectable libcrypto-family
// backends behind the same seam. The backend kind is chosen in build.zig and
// emitted as a typed build_option, so `active` is already a typed enum value
// here — no string parse to validate.
// `openssl-fips` and `aws-lc-fips` are FIPS-narrowed capability identities that
// link the same libcrypto as their non-FIPS counterparts.
test "active backend is a buildable libcrypto-family member" {
    try testing.expect(active == .openssl or active == .@"aws-lc" or
        active == .boringssl or
        active == .@"openssl-fips" or active == .@"aws-lc-fips");
    // field names are the wire strings, so @tagName round-trips to the CLI value
    try testing.expectEqualStrings("openssl", @tagName(@as(@TypeOf(active), .openssl)));
    try testing.expectEqualStrings("aws-lc", @tagName(@as(@TypeOf(active), .@"aws-lc")));
    try testing.expectEqualStrings("boringssl", @tagName(@as(@TypeOf(active), .boringssl)));
    try testing.expectEqualStrings("openssl-fips", @tagName(@as(@TypeOf(active), .@"openssl-fips")));
    try testing.expectEqualStrings("aws-lc-fips", @tagName(@as(@TypeOf(active), .@"aws-lc-fips")));
}

// RFC 8446 §9.1 — TLS 1.3 endpoints need at least one mutually supported
// cipher suite, key-share group, and CertificateVerify scheme to handshake.
test "capabilities are non-empty for the active backend" {
    try testing.expect(capabilities.cipher_suites.len > 0);
    try testing.expect(capabilities.client_x25519 or capabilities.client_p256);
    try testing.expect(capabilities.server_x25519 or capabilities.server_p256);
    try testing.expect(capabilities.certificate_verify_schemes.len > 0);
    try testing.expect(capabilities.certificate_signature_schemes.len > 0);
}

// The AWS-LC and BoringSSL X25519 paths use their flat curve25519 API with a
// value handle; keep it from silently regressing to the OpenSSL EVP_PKEY
// pointer shape.
test "x25519 handle shape matches active backend" {
    const evp_pointer_size = @sizeOf(*backend_openssl.pkey);
    switch (active) {
        .openssl, .@"openssl-fips" => try testing.expectEqual(evp_pointer_size, @sizeOf(x25519.pkey)),
        .@"aws-lc", .@"aws-lc-fips", .boringssl => try testing.expect(@sizeOf(x25519.pkey) > evp_pointer_size),
    }
}

// Client first-flight key-share plumbing currently supports X25519 and P-256.
test "client group capabilities match implemented client key-share plumbing" {
    try testing.expect(capabilities.client_x25519);
    try testing.expect(capabilities.client_p256);
}

test "aead context shape matches active backend" {
    switch (active) {
        .openssl, .@"openssl-fips" => try testing.expectEqual(
            @sizeOf(backend_openssl.AeadContext),
            @sizeOf(aead.Context),
        ),
        .@"aws-lc", .@"aws-lc-fips", .boringssl => try testing.expect(
            @sizeOf(aead.Context) != @sizeOf(backend_openssl.AeadContext),
        ),
    }
}

test "aws-lc aead deinit clears inline context" {
    if (active != .@"aws-lc" and active != .@"aws-lc-fips") return error.SkipZigTest;

    const key: [16]u8 = @splat(0xab);
    var ctx = try backend_aws_lc.aeadInit(.aes_128_gcm_sha256, &key);
    backend_aws_lc.aeadDeinit(&ctx);

    for (std.mem.asBytes(&ctx)) |byte| try testing.expectEqual(@as(u8, 0), byte);
}

test "capability helpers recognize advertised algorithms" {
    for (capabilities.cipher_suites) |suite| try testing.expect(supportsCipherSuite(suite));
    for (capabilities.certificate_verify_schemes) |scheme| {
        try testing.expect(supportsCertificateVerifyScheme(scheme));
    }
}

// FIPS capability divergence — the FIPS table narrows the non-FIPS set by
// dropping non-approved algorithms. These tests verify the narrowing under the
// active backend identity, and are comptime-correct regardless of which
// libcrypto is actually linked.

// FIPS 140-3 does not approve ChaCha20-Poly1305 for TLS 1.3; the FIPS table
// must not advertise it as a cipher suite.
test "fips: chacha20_poly1305_sha256 excluded from FIPS cipher_suites" {
    const fips_suites = switch (active) {
        .openssl, .@"openssl-fips" => backend_openssl.capabilities_fips.cipher_suites,
        .@"aws-lc", .@"aws-lc-fips" => backend_aws_lc.capabilities_fips.cipher_suites,
        .boringssl => return error.SkipZigTest,
    };
    for (fips_suites) |suite| {
        try testing.expect(suite != .chacha20_poly1305_sha256);
    }
}

// FIPS 140-3 does not approve RSA PKCS#1 v1.5 for TLS 1.3 certificate
// signatures; the FIPS table must keep only PSS-compatible schemes.
test "fips: rsa_pkcs1_sha* excluded from FIPS certificate_signature_schemes" {
    const fips_schemes = switch (active) {
        .openssl, .@"openssl-fips" => backend_openssl.capabilities_fips.certificate_signature_schemes,
        .@"aws-lc", .@"aws-lc-fips" => backend_aws_lc.capabilities_fips.certificate_signature_schemes,
        .boringssl => return error.SkipZigTest,
    };
    for (fips_schemes) |scheme| {
        try testing.expect(scheme != .rsa_pkcs1_sha256);
        try testing.expect(scheme != .rsa_pkcs1_sha384);
        try testing.expect(scheme != .rsa_pkcs1_sha512);
    }
}

// FIPS 140-3 does not approve Ed25519; the FIPS certificate-signature table
// must not advertise it.
test "fips: ed25519 excluded from FIPS certificate_signature_schemes" {
    const fips_schemes = switch (active) {
        .openssl, .@"openssl-fips" => backend_openssl.capabilities_fips.certificate_signature_schemes,
        .@"aws-lc", .@"aws-lc-fips" => backend_aws_lc.capabilities_fips.certificate_signature_schemes,
        .boringssl => return error.SkipZigTest,
    };
    for (fips_schemes) |scheme| {
        try testing.expect(scheme != .ed25519);
    }
}

// FIPS 140-3 does not approve ML-KEM; the FIPS table must disable it.
test "fips: ML-KEM disabled in FIPS capability table" {
    const fips_caps = switch (active) {
        .openssl, .@"openssl-fips" => backend_openssl.capabilities_fips,
        .@"aws-lc", .@"aws-lc-fips" => backend_aws_lc.capabilities_fips,
        .boringssl => return error.SkipZigTest,
    };
    try testing.expect(!fips_caps.client_x25519_mlkem768);
    try testing.expect(!fips_caps.server_x25519_mlkem768);
}

// The FIPS table must be a strict subset of the non-FIPS table. The comptime
// assertion in the comptime block above proves this at build time; this test
// also verifies it at runtime for the active backend pair.
test "fips: FIPS capabilities are a subset of non-FIPS capabilities" {
    const fips_caps = switch (active) {
        .openssl, .@"openssl-fips" => backend_openssl.capabilities_fips,
        .@"aws-lc", .@"aws-lc-fips" => backend_aws_lc.capabilities_fips,
        .boringssl => return error.SkipZigTest,
    };
    const base_caps = switch (active) {
        .openssl, .@"openssl-fips" => backend_openssl.capabilities,
        .@"aws-lc", .@"aws-lc-fips" => backend_aws_lc.capabilities,
        .boringssl => return error.SkipZigTest,
    };
    for (fips_caps.cipher_suites) |suite| {
        try testing.expect(suiteInList(suite, base_caps.cipher_suites));
    }
    for (fips_caps.certificate_verify_schemes) |scheme| {
        try testing.expect(schemeInList(scheme, base_caps.certificate_verify_schemes));
    }
    for (fips_caps.certificate_signature_schemes) |scheme| {
        try testing.expect(schemeInList(scheme, base_caps.certificate_signature_schemes));
    }
}

// Under a FIPS backend identity, the active capability table must not advertise
// ChaCha20-Poly1305. Under a non-FIPS backend, it must.
test "fips: active capabilities follow FIPS identity" {
    if (is_fips) {
        try testing.expect(!supportsCipherSuite(.chacha20_poly1305_sha256));
    } else {
        try testing.expect(supportsCipherSuite(.chacha20_poly1305_sha256));
    }
}

fn suiteInList(suite: CipherSuite, list: []const CipherSuite) bool {
    for (list) |s| {
        if (s == suite) return true;
    }
    return false;
}

fn schemeInList(scheme: SignatureScheme, list: []const SignatureScheme) bool {
    for (list) |s| {
        if (s == scheme) return true;
    }
    return false;
}
