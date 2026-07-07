//! Signature helpers for TLS 1.3 CertificateVerify.
const std = @import("std");
const testing = std.testing;

const backend = @import("crypto/backend.zig");
const SignatureScheme = @import("signature_scheme.zig").SignatureScheme;

pub const SignError = backend.sign.Error;

pub const Signer = struct {
    scheme: SignatureScheme,
    context: *anyopaque,
    sign: *const fn (context: *anyopaque, msg: []const u8, out: []u8) SignError![]const u8,
};

pub const PrivateKey = struct {
    scheme: SignatureScheme,
    key: *backend.sign.pkey,

    pub fn fromDer(scheme: SignatureScheme, der: []const u8) SignError!PrivateKey {
        return .{ .scheme = scheme, .key = try backend.sign.privateKeyFromDer(der) };
    }

    pub fn fromPem(scheme: SignatureScheme, pem: []const u8) SignError!PrivateKey {
        return .{ .scheme = scheme, .key = try backend.sign.privateKeyFromPem(pem) };
    }

    pub fn fromP256Scalar(scalar: *const [32]u8) SignError!PrivateKey {
        return .{
            .scheme = .ecdsa_secp256r1_sha256,
            .key = try backend.sign.privateKeyFromP256Scalar(scalar),
        };
    }

    pub fn deinit(self: *PrivateKey) void {
        backend.sign.freeKey(self.key);
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
        return backend.sign.sign(self.key, self.scheme, msg, out);
    }
};

// RFC 8446 §4.2.3 — RSA-PSS CertificateVerify uses the scheme hash for both
// the signature digest and MGF1, with salt length equal to the digest length.
test "PrivateKey.sign: RSA-PSS SHA-256 uses TLS parameters" {
    const rsa_pss_key_pem = @embedFile("test_fixtures/rsa_pss/server.key");
    var key: PrivateKey = try .fromPem(.rsa_pss_rsae_sha256, rsa_pss_key_pem);
    defer key.deinit();

    var sig: [256]u8 = undefined;
    const out = try key.sign("test message", &sig);
    try testing.expectEqual(@as(usize, 256), out.len);
}

// RFC 8446 §4.2.3 — RSA-PSS CertificateVerify signatures must fit the
// caller-provided output buffer or fail without truncation.
test "PrivateKey.sign: short RSA-PSS output buffer is rejected" {
    const rsa_pss_key_pem = @embedFile("test_fixtures/rsa_pss/server.key");
    var key: PrivateKey = try .fromPem(.rsa_pss_rsae_sha256, rsa_pss_key_pem);
    defer key.deinit();

    var sig: [1]u8 = undefined;
    try testing.expectError(error.BufferTooShort, key.sign("test message", &sig));
}

// RFC 8446 §4.4.3 — the CertificateVerify scheme must be compatible with the
// signing key; backend failures are not reported as output-buffer failures.
test "PrivateKey.sign: key and scheme mismatch is a libcrypto failure" {
    const scalar = [_]u8{0} ** 31 ++ .{1};
    var key: PrivateKey = try .fromP256Scalar(&scalar);
    defer key.deinit();
    key.scheme = .rsa_pss_rsae_sha256;

    var sig: [256]u8 = undefined;
    try testing.expectError(error.LibcryptoFailed, key.sign("test message", &sig));
}
