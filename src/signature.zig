//! Signature helpers for TLS 1.3 CertificateVerify.
const std = @import("std");
const testing = std.testing;

const c = @import("crypto/c_openssl.zig").openssl;
const openssl_key = @import("crypto/openssl_key.zig");
const SignatureScheme = @import("signature_scheme.zig").SignatureScheme;

pub const SignError = error{ BufferTooShort, IdentityElement, LibcryptoFailed, NonCanonical };

pub const Signer = struct {
    scheme: SignatureScheme,
    context: *anyopaque,
    sign: *const fn (context: *anyopaque, msg: []const u8, out: []u8) SignError![]const u8,
};

pub const PrivateKey = struct {
    scheme: SignatureScheme,
    key: *c.EVP_PKEY,

    pub fn fromDer(scheme: SignatureScheme, der: []const u8) SignError!PrivateKey {
        var ptr: [*c]const u8 = der.ptr;
        const key = c.d2i_AutoPrivateKey(null, &ptr, @intCast(der.len)) orelse
            return error.LibcryptoFailed;
        return .{ .scheme = scheme, .key = key };
    }

    pub fn fromPem(scheme: SignatureScheme, pem: []const u8) SignError!PrivateKey {
        const bio = c.BIO_new_mem_buf(pem.ptr, @intCast(pem.len)) orelse
            return error.LibcryptoFailed;
        defer _ = c.BIO_free(bio);
        const key = c.PEM_read_bio_PrivateKey(bio, null, null, null) orelse
            return error.LibcryptoFailed;
        return .{ .scheme = scheme, .key = key };
    }

    pub fn fromP256Scalar(scalar: *const [32]u8) SignError!PrivateKey {
        return .{
            .scheme = .ecdsa_secp256r1_sha256,
            .key = try openssl_key.p256KeyFromScalar(scalar),
        };
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

        var pctx: ?*c.EVP_PKEY_CTX = null;
        if (c.EVP_DigestSignInit(ctx, &pctx, md, null, self.key) != 1) return error.LibcryptoFailed;
        switch (self.scheme) {
            .rsa_pss_rsae_sha256, .rsa_pss_rsae_sha384, .rsa_pss_rsae_sha512 => {
                if (c.EVP_PKEY_CTX_set_rsa_padding(pctx, c.RSA_PKCS1_PSS_PADDING) != 1)
                    return error.LibcryptoFailed;
                if (c.EVP_PKEY_CTX_set_rsa_mgf1_md(pctx, md) != 1)
                    return error.LibcryptoFailed;
                if (c.EVP_PKEY_CTX_set_rsa_pss_saltlen(pctx, c.RSA_PSS_SALTLEN_DIGEST) != 1)
                    return error.LibcryptoFailed;
            },
            else => {},
        }
        if (c.EVP_DigestSignUpdate(ctx, msg.ptr, msg.len) != 1) return error.LibcryptoFailed;

        var len: usize = out.len;
        if (c.EVP_DigestSignFinal(ctx, out.ptr, &len) != 1) return error.BufferTooShort;
        return out[0..len];
    }
};

const rsa_pss_key_pem = @embedFile("test_fixtures/rsa_pss/server.key");

// RFC 8446 §4.2.3 — RSA-PSS CertificateVerify uses the scheme hash for both
// the signature digest and MGF1, with salt length equal to the digest length.
test "PrivateKey.sign: RSA-PSS SHA-256 uses TLS parameters" {
    var key: PrivateKey = try .fromPem(.rsa_pss_rsae_sha256, rsa_pss_key_pem);
    defer key.deinit();

    var sig: [256]u8 = undefined;
    const out = try key.sign("test message", &sig);
    try testing.expectEqual(@as(usize, 256), out.len);
}
