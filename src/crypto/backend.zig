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
const backend_openssl = @import("backend_openssl.zig");

pub const Backend = enum {
    openssl,
    aws_lc,
    boringssl,

    pub fn isLibcryptoFamily(comptime self: Backend) bool {
        return switch (self) {
            .openssl, .aws_lc, .boringssl => true,
        };
    }

    pub fn name(comptime self: Backend) []const u8 {
        return switch (self) {
            .openssl => "openssl",
            .aws_lc => "aws-lc",
            .boringssl => "boringssl",
        };
    }
};

pub const active: Backend = parse(build_options.crypto_backend) orelse
    @compileError("unsupported crypto backend: " ++ build_options.crypto_backend);

const x25519_impl = switch (active) {
    .openssl => backend_openssl,
    .aws_lc => backend_aws_lc,
    .boringssl => @compileError("BoringSSL backend not yet implemented"),
};

const p256_impl = switch (active) {
    .openssl => backend_openssl,
    .aws_lc => backend_aws_lc,
    .boringssl => @compileError("BoringSSL backend not yet implemented"),
};

const p384_impl = switch (active) {
    .openssl => backend_openssl,
    .aws_lc => backend_aws_lc,
    .boringssl => @compileError("BoringSSL backend not yet implemented"),
};

const aead_impl = switch (active) {
    .openssl => backend_openssl,
    .aws_lc => backend_aws_lc,
    .boringssl => @compileError("BoringSSL backend not yet implemented"),
};

const sign_impl = switch (active) {
    .openssl => backend_openssl,
    .aws_lc => backend_aws_lc,
    .boringssl => @compileError("BoringSSL backend not yet implemented"),
};

pub const capabilities = switch (active) {
    .openssl => backend_openssl.capabilities,
    .aws_lc => backend_aws_lc.capabilities,
    .boringssl => @compileError("BoringSSL backend not yet implemented"),
};

comptime {
    assert(capabilities.cipher_suites.len > 0);
    assert(capabilities.client_x25519 or capabilities.client_p256);
    assert(capabilities.server_x25519 or capabilities.server_p256);
    assert(capabilities.certificate_verify_schemes.len > 0);
    assert(capabilities.certificate_signature_schemes.len > 0);
    assert(capabilities.client_p384 == capabilities.server_p384);
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

fn parse(comptime name_: []const u8) ?Backend {
    if (std.mem.eql(u8, name_, "openssl")) return .openssl;
    if (std.mem.eql(u8, name_, "aws-lc")) return .aws_lc;
    if (std.mem.eql(u8, name_, "boringssl")) return .boringssl;
    return null;
}

// docs/research/PROVIDER_INTERFACE.md §1 — current production backend is
// OpenSSL/libcrypto; AWS-LC and BoringSSL remain named libcrypto-family targets,
// not runtime claims.
test "backend family is explicit" {
    try testing.expectEqualStrings(build_options.crypto_backend, active.name());
    try testing.expect(active.isLibcryptoFamily());
    inline for (@typeInfo(Backend).@"enum".fields) |field| {
        const backend: Backend = @enumFromInt(field.value);
        try testing.expectEqual(backend, parse(backend.name()).?);
    }
    try testing.expect(Backend.openssl.isLibcryptoFamily());
    try testing.expect(Backend.aws_lc.isLibcryptoFamily());
    try testing.expect(Backend.boringssl.isLibcryptoFamily());
    try testing.expectEqualStrings("openssl", Backend.openssl.name());
    try testing.expectEqualStrings("aws-lc", Backend.aws_lc.name());
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

// The AWS-LC X25519 path uses its flat curve25519 API with a value handle; keep
// it from silently regressing to the OpenSSL EVP_PKEY pointer shape.
test "x25519 handle shape matches active backend" {
    const evp_pointer_size = @sizeOf(*backend_openssl.pkey);
    switch (active) {
        .openssl => try testing.expectEqual(evp_pointer_size, @sizeOf(x25519.pkey)),
        .aws_lc => try testing.expect(@sizeOf(x25519.pkey) > evp_pointer_size),
        .boringssl => unreachable,
    }
}

// Client first-flight key-share plumbing currently supports X25519 and P-256.
test "client group capabilities match implemented client key-share plumbing" {
    try testing.expect(capabilities.client_x25519);
    try testing.expect(capabilities.client_p256);
}

test "aead context shape matches active backend" {
    switch (active) {
        .openssl => try testing.expectEqual(
            @sizeOf(backend_openssl.AeadContext),
            @sizeOf(aead.Context),
        ),
        .aws_lc => try testing.expect(
            @sizeOf(aead.Context) != @sizeOf(backend_openssl.AeadContext),
        ),
        .boringssl => unreachable,
    }
}

test "aws-lc aead deinit clears inline context" {
    if (active != .aws_lc) return error.SkipZigTest;

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
