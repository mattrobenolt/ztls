//! Signature helpers for TLS 1.3 CertificateVerify.
const std = @import("std");
const testing = std.testing;

const backend = @import("crypto/backend.zig");
const SignatureScheme = @import("signature_scheme.zig").SignatureScheme;

pub const SignError = backend.sign.SignError;
pub const NonceMode = backend.sign.NonceMode;

pub const Signer = struct {
    scheme: SignatureScheme,
    context: *anyopaque,
    sign: *const fn (context: *anyopaque, msg: []const u8, out: []u8) SignError![]const u8,
};

pub const PrivateKey = struct {
    scheme: SignatureScheme,
    key: *backend.sign.pkey,
    /// Opt-in RFC 6979 deterministic ECDSA nonces (mattrobenolt/ztls#82):
    /// `.deterministic` makes identical key and message yield identical
    /// signature bytes, so a seeded handshake transcript is reproducible
    /// byte-for-byte. Requires a backend compiled with nonce-type provider
    /// support (OpenSSL 3.2+ headers) and an ECDSA scheme; any other
    /// combination fails with error.DeterministicNonceUnsupported rather
    /// than silently signing with a random nonce. Production signing keeps
    /// the default `.random`.
    nonce_mode: NonceMode = .random,

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
        return backend.sign.sign(self.key, self.scheme, msg, out, self.nonce_mode);
    }
};

// RFC 8446 §4.2.3 — RSA-PSS CertificateVerify uses the scheme hash for both
// the signature digest and MGF1, with salt length equal to the digest length.
test "PrivateKey.sign: RSA-PSS SHA-256 uses TLS parameters" {
    const rsa_pss_key_pem = @import("fixtures").rsa_pss_key_pem;
    var key: PrivateKey = try .fromPem(.rsa_pss_rsae_sha256, rsa_pss_key_pem);
    defer key.deinit();

    var sig: [256]u8 = undefined;
    const out = try key.sign("test message", &sig);
    try testing.expectEqual(@as(usize, 256), out.len);
}

// RFC 8446 §4.2.3 — RSA-PSS CertificateVerify signatures must fit the
// caller-provided output buffer or fail without truncation.
test "PrivateKey.sign: short RSA-PSS output buffer is rejected" {
    const rsa_pss_key_pem = @import("fixtures").rsa_pss_key_pem;
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

// RFC 6979 §A.2.5 — the P-256/SHA-256 "sample" test vector. With
// deterministic nonces the signature is a pure function of key and message,
// so the DER bytes must match the published r/s exactly, on every run.
test "PrivateKey.sign: deterministic ECDSA matches the RFC 6979 vector" {
    var scalar: [32]u8 = undefined;
    _ = try std.fmt.hexToBytes(
        &scalar,
        "C9AFA9D845BA75166B5C215767B1D6934E50C3DB36E89B127B8A622B120F6721",
    );
    var key: PrivateKey = try .fromP256Scalar(&scalar);
    defer key.deinit();
    key.nonce_mode = .deterministic;

    // A backend compiled without nonce-type provider support has no
    // deterministic path; its contract is the loud rejection, never a
    // silently random nonce.
    if (comptime !backend.sign.supportsDeterministicNonce()) {
        var sig: [96]u8 = undefined;
        try testing.expectError(error.DeterministicNonceUnsupported, key.sign("sample", &sig));
        return;
    }

    // DER SEQUENCE of the vector's r and s; both have the high bit set, so
    // each carries a leading zero pad byte.
    var expected: [72]u8 = undefined;
    _ = try std.fmt.hexToBytes(&expected, "3046" ++
        "022100" ++ "EFD48B2AACB6A8FD1140DD9CD45E81D69D2C877B56AAF991C34D0EA84EAF3716" ++
        "022100" ++ "F7CB1C942D657C41D436C7A1B6E29F65F3E900DBB9AFF4064DC4AB2F843ACDA8");

    var sig: [96]u8 = undefined;
    const out = try key.sign("sample", &sig);
    try testing.expectEqualSlices(u8, &expected, out);

    var again: [96]u8 = undefined;
    try testing.expectEqualSlices(u8, out, try key.sign("sample", &again));
}

// RFC 6979 §A.2.6 — the P-384/SHA-384 "sample" test vector, the second
// published known-answer for the deterministic-nonce option. Same contract
// as the A.2.5 test, on the 384-bit curve the TLS 1.3 ecdsa_secp384r1_sha384
// scheme signs with.
test "PrivateKey.sign: deterministic ECDSA P-384 matches the RFC 6979 A.2.6 vector" {
    var scalar: [48]u8 = undefined;
    _ = try std.fmt.hexToBytes(
        &scalar,
        "6B9D3DAD2E1B8C1C05B19875B6659F4DE23C3B667BF297BA9AA47740787137D8" ++
            "96D5724E4C70A825F872C9EA60D2EDF5",
    );
    // The P-384 ECDHE scalar loader produces the same EVP_PKEY the sign seam
    // consumes, so the fixture needs no new key-loading surface.
    var key: PrivateKey = .{
        .scheme = .ecdsa_secp384r1_sha384,
        .key = try backend.p384.privateKeyFromSecret(&scalar),
    };
    defer key.deinit();
    key.nonce_mode = .deterministic;

    // A backend compiled without nonce-type provider support has no
    // deterministic path; its contract is the loud rejection, never a
    // silently random nonce.
    if (comptime !backend.sign.supportsDeterministicNonce()) {
        var sig: [106]u8 = undefined;
        try testing.expectError(error.DeterministicNonceUnsupported, key.sign("sample", &sig));
        return;
    }

    // The RFC publishes r and s, not a DER blob, and DER INTEGERs may carry
    // a leading zero pad byte (OpenSSL emits one even when the high bit is
    // clear), so decode the two INTEGERs and compare against the vector's
    // values instead of raw signature bytes.
    const r = "94EDBB92A5ECB8AAD4736E56C691916B3F88140666CE9FA73D64C4EA95AD133C" ++
        "81A648152E44ACF96E36DD1E80FABE46";
    const s = "99EF4AEB15F178CEA1FE40DB2603138F130E740A19624526203B6351D0A3A94F" ++
        "A329C145786E679E7B82C71A38628AC8";
    var expected_r: [48]u8 = undefined;
    var expected_s: [48]u8 = undefined;
    _ = try std.fmt.hexToBytes(&expected_r, r);
    _ = try std.fmt.hexToBytes(&expected_s, s);

    var sig: [106]u8 = undefined;
    const out = try key.sign("sample", &sig);
    try expectEcDsaSigIntegers(out, &expected_r, &expected_s);

    var again: [106]u8 = undefined;
    try testing.expectEqualSlices(u8, out, try key.sign("sample", &again));
}

// RFC 6979 appendix A.2 vectors publish r and s as fixed-width integers,
// not DER. A DER INTEGER may open with a zero pad byte, so decode both
// INTEGERs of the signature's SEQUENCE and compare the pad-stripped values.
// Short-form lengths only: a P-384 signature is at most ~107 bytes.
fn expectEcDsaSigIntegers(
    der: []const u8,
    expected_r: *const [48]u8,
    expected_s: *const [48]u8,
) !void {
    try testing.expect(der.len >= 8);
    try testing.expectEqual(@as(u8, 0x30), der[0]); // SEQUENCE
    try testing.expectEqual(der.len - 2, der[1]);
    var i: usize = 2;
    const integers = [_]*const [48]u8{ expected_r, expected_s };
    for (integers) |expected| {
        try testing.expectEqual(@as(u8, 0x02), der[i]); // INTEGER
        const int_len: usize = der[i + 1];
        i += 2;
        const integer = der[i .. i + int_len];
        i += int_len;
        const value = if (integer[0] == 0) integer[1..] else integer;
        try testing.expectEqualSlices(u8, expected, value);
    }
    try testing.expectEqual(der.len, i);
}

// A scheme with no RFC 6979 to follow cannot honor the request — fail
// loudly, never fall back to a random nonce.
test "PrivateKey.sign: deterministic nonce with RSA-PSS is rejected" {
    const rsa_pss_key_pem = @import("fixtures").rsa_pss_key_pem;
    var key: PrivateKey = try .fromPem(.rsa_pss_rsae_sha256, rsa_pss_key_pem);
    defer key.deinit();
    key.nonce_mode = .deterministic;

    var sig: [256]u8 = undefined;
    try testing.expectError(
        error.DeterministicNonceUnsupported,
        key.sign("test message", &sig),
    );
}
