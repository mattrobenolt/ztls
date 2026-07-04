//! AWS-LC backend primitive wrappers.
//!
//! X25519 uses AWS-LC's BoringSSL-style flat API. The remaining primitives
//! delegate to the OpenSSL-compatible implementation while the build recipe
//! links AWS-LC's libcrypto; those modules should diverge when a backend-specific
//! fast path or API difference warrants it.
const std = @import("std");
const assert = std.debug.assert;
const c = @import("c_openssl.zig").openssl;
const compat = @import("backend_openssl.zig");
const CipherSuite = @import("../cipher_suite.zig").CipherSuite;
const SignatureScheme = @import("../signature_scheme.zig").SignatureScheme;

pub const capabilities = compat.capabilities;

pub const Error = compat.Error;
pub const pkey = compat.pkey;
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

pub inline fn freeKey(key: *pkey) void {
    compat.freeKey(key);
}

pub const AeadError = compat.AeadError;
pub const AeadContext = compat.AeadContext;
pub const aead_tag_len = compat.aead_tag_len;
pub const aead_nonce_len = compat.aead_nonce_len;

pub inline fn aeadInit(suite: CipherSuite, key_bytes: []const u8) AeadError!AeadContext {
    return compat.aeadInit(suite, key_bytes);
}

pub inline fn aeadDeinit(ctx: *AeadContext) void {
    compat.aeadDeinit(ctx);
}

pub inline fn aeadEncrypt(
    ctx: *AeadContext,
    ciphertext: []u8,
    tag: *[aead_tag_len]u8,
    plaintext: []const u8,
    ad: []const u8,
    npub: *const [aead_nonce_len]u8,
) AeadError!void {
    return compat.aeadEncrypt(ctx, ciphertext, tag, plaintext, ad, npub);
}

pub inline fn aeadDecrypt(
    ctx: *AeadContext,
    plaintext: []u8,
    ciphertext: []const u8,
    tag: *const [aead_tag_len]u8,
    ad: []const u8,
    npub: *const [aead_nonce_len]u8,
) AeadError!void {
    return compat.aeadDecrypt(ctx, plaintext, ciphertext, tag, ad, npub);
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
