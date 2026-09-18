//! Signature helpers for TLS 1.3 CertificateVerify.
const std = @import("std");
const testing = std.testing;

const backend = @import("crypto/backend.zig");
const SignatureScheme = @import("signature_scheme.zig").SignatureScheme;

pub const SignError = backend.sign.SignError;
pub const NonceMode = backend.sign.NonceMode;

/// `fromPemAuto` load failure: backend load errors plus the scheme-inference
/// rejection (#112). Kept separate from `SignError` so the sign-only errors
/// do not widen the loaders.
pub const LoadError = SignError || error{UnsupportedKeyScheme};

/// `pairsWith` contract (#113): the leaf parsed but its key does not pair
/// with the loaded private key (`CertificateKeyMismatch`), or the DER is
/// not parseable X.509 (`InvalidCertificate`).
pub const PairError = error{ CertificateKeyMismatch, InvalidCertificate };

pub const Signer = struct {
    scheme: SignatureScheme,
    context: *anyopaque,
    sign: *const fn (context: *anyopaque, msg: []const u8, out: []u8) SignError![]const u8,
};

pub const PrivateKey = struct {
    scheme: SignatureScheme,
    key: *backend.sign.pkey,
    /// RFC 6979 nonce strategy (mattrobenolt/ztls#82): `.deterministic`
    /// makes identical key and message yield identical signature bytes for
    /// byte-reproducible seeded transcripts. Requires compiled nonce-type
    /// provider support and an ECDSA scheme; unsupported requests fail
    /// loudly — error.DeterministicNonceUnsupported for a missing
    /// capability or non-ECDSA scheme, error.LibcryptoFailed when the
    /// provider rejects the parameter — rather than silently signing with
    /// a random nonce. Production signing keeps the default `.random`.
    nonce_mode: NonceMode = .random,

    pub fn fromDer(scheme: SignatureScheme, der: []const u8) SignError!PrivateKey {
        return .{ .scheme = scheme, .key = try backend.sign.privateKeyFromDer(der) };
    }

    pub fn fromPem(scheme: SignatureScheme, pem: []const u8) SignError!PrivateKey {
        return .{ .scheme = scheme, .key = try backend.sign.privateKeyFromPem(pem) };
    }

    /// RFC 8446 §4.2.3 — infer the CertificateVerify scheme from the loaded
    /// key (#112). The explicit `fromPem` stays caller-pins-scheme; this
    /// path derives the scheme from the key's exact type and curve, then
    /// gates it against the active backend's advertised CertificateVerify
    /// schemes — so a key whose scheme this backend cannot sign (Ed25519,
    /// P-521 today) fails here with `error.UnsupportedKeyScheme`, at load
    /// time instead of at the first handshake signature.
    // ziglint-ignore: Z015 -- LoadError is a public error-set alias.
    pub fn fromPemAuto(pem: []const u8) LoadError!PrivateKey {
        const key = try backend.sign.privateKeyFromPem(pem);
        // Two fallible steps: a scheme-rejected key must not leak the
        // loaded EVP_PKEY.
        errdefer backend.sign.freeKey(key);
        const scheme = try backend.sign.keyScheme(key);
        if (!backend.supportsCertificateVerifyScheme(scheme)) return error.UnsupportedKeyScheme;
        return .{ .scheme = scheme, .key = key };
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

    /// RFC 8446 §4.4.3 — the CertificateVerify signature must be made with
    /// the private key matching the end-entity certificate's public key
    /// (§4.4.2: the sender's certificate is first, so the leaf is element
    /// [0] of the chain). Explicit load-time validation for startup and
    /// certificate rotation (#113): `error.CertificateKeyMismatch` means
    /// the leaf parsed but the keys do not pair; `error.InvalidCertificate`
    /// means the input is not exactly one DER-encoded X.509 certificate —
    /// distinct outcomes, so a rotation log can tell a wrong pairing from a
    /// corrupt file. Both
    /// inputs are borrowed: the parsed X509 is provider-owned and freed
    /// inside the backend wrapper, and the private key is only read, so
    /// ownership and zeroization stay with `deinit`. Rotation lifetime: a
    /// `PrivateKey` must outlive every `Signer` it handed out — swap
    /// credentials only when no in-flight handshake holds the old signer.
    pub fn pairsWith(self: *const PrivateKey, leaf_cert_der: []const u8) PairError!void {
        const paired = backend.sign.privateKeyPairsWithCertificate(
            self.key,
            leaf_cert_der,
        ) catch |err| return switch (err) {
            error.InvalidEncoding => error.InvalidCertificate,
        };
        if (!paired) return error.CertificateKeyMismatch;
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

    // DER SEQUENCE of the vector's r and s; both have the high bit set,
    // so each carries a leading zero pad byte.
    var expected: [104]u8 = undefined;
    _ = try std.fmt.hexToBytes(&expected, "3066" ++
        "023100" ++ "94EDBB92A5ECB8AAD4736E56C691916B3F88140666CE9FA73D64C4EA95AD133C" ++
        "81A648152E44ACF96E36DD1E80FABE46" ++
        "023100" ++ "99EF4AEB15F178CEA1FE40DB2603138F130E740A19624526203B6351D0A3A94F" ++
        "A329C145786E679E7B82C71A38628AC8");

    var sig: [104]u8 = undefined;
    const out = try key.sign("sample", &sig);
    try testing.expectEqualSlices(u8, &expected, out);

    var again: [104]u8 = undefined;
    try testing.expectEqualSlices(u8, out, try key.sign("sample", &again));
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

// ---------------------------------------------------------------------------
// fromPemAuto — provider-backed scheme inference (#112)
// ---------------------------------------------------------------------------

// RFC 8446 §4.4.3 — the CertificateVerify signed content is the
// concatenation of 64×0x20, the role context string, one zero separator,
// and the transcript hash. Fixed bytes stand in for the hash: the sign seam
// is content-agnostic; the shape under test is the CertificateVerify layout.
fn certificateVerifyContent() [64 + "TLS 1.3, server CertificateVerify".len + 1 + 32]u8 {
    var content: [64 + "TLS 1.3, server CertificateVerify".len + 1 + 32]u8 = @splat(0x20);
    const context = "TLS 1.3, server CertificateVerify";
    @memcpy(content[64..][0..context.len], context);
    content[64 + context.len] = 0;
    @memset(content[64 + context.len + 1 ..], 0xa5);
    return content;
}

// RFC 8446 §4.2.3 — an rsaEncryption key maps to rsa_pss_rsae_sha256
// regardless of PEM container (libcrypto owns PKCS#8/PKCS#1 parsing), and
// the auto-inferred key signs a CertificateVerify-shaped content (#112).
test "PrivateKey.fromPemAuto: RSA PKCS#8 and PKCS#1 both infer rsa_pss_rsae_sha256" {
    const rsa_pkcs1_key_pem = @import("fixtures").rsa_pkcs1_key_pem;
    const rsa_pss_key_pem = @import("fixtures").rsa_pss_key_pem;
    var key: PrivateKey = try .fromPemAuto(rsa_pss_key_pem);
    defer key.deinit();
    try testing.expectEqual(SignatureScheme.rsa_pss_rsae_sha256, key.scheme);

    var pkcs1: PrivateKey = try .fromPemAuto(rsa_pkcs1_key_pem);
    defer pkcs1.deinit();
    try testing.expectEqual(SignatureScheme.rsa_pss_rsae_sha256, pkcs1.scheme);

    const content = certificateVerifyContent();
    var sig: [256]u8 = undefined;
    const out = try key.sign(&content, &sig);
    try testing.expectEqual(@as(usize, 256), out.len);
}

// RFC 8446 §4.2.3 — a prime256v1 key maps to ecdsa_secp256r1_sha256 and the
// auto-inferred key signs a CertificateVerify-shaped content (#112).
test "PrivateKey.fromPemAuto: P-256 infers ecdsa_secp256r1_sha256 and signs" {
    const ec_p256_key_pem = @import("fixtures").ec_p256_key_pem;
    var key: PrivateKey = try .fromPemAuto(ec_p256_key_pem);
    defer key.deinit();
    try testing.expectEqual(SignatureScheme.ecdsa_secp256r1_sha256, key.scheme);

    const content = certificateVerifyContent();
    var sig: [72]u8 = undefined;
    const out = try key.sign(&content, &sig);
    try testing.expect(out.len > 0);
}

// RFC 8446 §4.2.3 — a secp384r1 key maps to ecdsa_secp384r1_sha384 and the
// auto-inferred key signs a CertificateVerify-shaped content (#112).
test "PrivateKey.fromPemAuto: P-384 infers ecdsa_secp384r1_sha384 and signs" {
    const ec_p384_key_pem = @import("fixtures").ec_p384_key_pem;
    var key: PrivateKey = try .fromPemAuto(ec_p384_key_pem);
    defer key.deinit();
    try testing.expectEqual(SignatureScheme.ecdsa_secp384r1_sha384, key.scheme);

    const content = certificateVerifyContent();
    var sig: [104]u8 = undefined;
    const out = try key.sign(&content, &sig);
    try testing.expect(out.len > 0);
}

// RFC 8446 §4.2.3 — secp521r1 maps to ecdsa_secp521r1_sha512, but no backend
// advertises that scheme for CertificateVerify yet, so the capability gate
// rejects the key at load instead of letting it fail at the first
// CertificateVerify signature (#112).
test "PrivateKey.fromPemAuto: P-521 is rejected at load by the capability gate" {
    const ec_p521_key_pem = @import("fixtures").ec_p521_key_pem;
    const backend_key = try backend.sign.privateKeyFromPem(ec_p521_key_pem);
    defer backend.sign.freeKey(backend_key);
    try testing.expectEqual(
        SignatureScheme.ecdsa_secp521r1_sha512,
        try backend.sign.keyScheme(backend_key),
    );
    try testing.expectError(
        error.UnsupportedKeyScheme,
        PrivateKey.fromPemAuto(ec_p521_key_pem),
    );
}

// RFC 8446 §4.2.3 — Ed25519 maps to the ed25519 scheme, but no backend
// advertises it for CertificateVerify (it needs a one-shot EVP_DigestSign
// flow the sign seam does not have), so the gate rejects at load (#112).
test "PrivateKey.fromPemAuto: Ed25519 is rejected at load by the capability gate" {
    const ed25519_key_pem = @import("fixtures").ed25519_key_pem;
    const backend_key = try backend.sign.privateKeyFromPem(ed25519_key_pem);
    defer backend.sign.freeKey(backend_key);
    try testing.expectEqual(
        SignatureScheme.ed25519,
        try backend.sign.keyScheme(backend_key),
    );
    try testing.expectError(
        error.UnsupportedKeyScheme,
        PrivateKey.fromPemAuto(ed25519_key_pem),
    );
}

// RFC 8446 §4.2.3 defines ECDSA schemes only for secp256r1, secp384r1, and
// secp521r1: a secp224r1 key loads on every backend but has no scheme to
// map to — the deterministic loads-then-rejects vector for the mapping
// itself (#112).
test "PrivateKey.fromPemAuto: secp224r1 has no CertificateVerify scheme" {
    const ec_secp224r1_key_pem = @import("fixtures").ec_secp224r1_key_pem;
    try testing.expectError(
        error.UnsupportedKeyScheme,
        PrivateKey.fromPemAuto(ec_secp224r1_key_pem),
    );
}

// RFC 8446 §4.2.3 — inference cannot even begin: the PEM never loads, so
// the failure is the backend load error, not a scheme rejection (#112).
test "PrivateKey.fromPemAuto: garbage PEM fails at load" {
    try testing.expectError(error.LibcryptoFailed, PrivateKey.fromPemAuto("not a pem"));
}

// ---------------------------------------------------------------------------
// pairsWith — load-time cert/key pairing (#113)
// ---------------------------------------------------------------------------

// RFC 8446 §4.4.3 + §4.4.2 — the CertificateVerify key must be the private
// key of the leaf certificate (element [0] of the sender's chain): the
// fixture scalar and certificate are one credential (#113).
test "PrivateKey.pairsWith: P-256 scalar key pairs with its leaf certificate" {
    const server_ecdsa_cert_der = @import("fixtures").server_ecdsa_cert_der;
    const server_ecdsa_scalar = @import("fixtures").server_ecdsa_scalar;
    var key: PrivateKey = try .fromP256Scalar(&server_ecdsa_scalar);
    defer key.deinit();
    try key.pairsWith(&server_ecdsa_cert_der);
}

// RFC 8446 §4.4.3 — the startup shape #112/#113 enable together: an
// auto-inferred key whose pairing with its leaf is proven at load time.
test "PrivateKey.pairsWith: auto-inferred RSA and P-256 keys pair with their leaves" {
    const ec_p256_key_pem = @import("fixtures").ec_p256_key_pem;
    const rsa_pss_cert_der = @import("fixtures").rsa_pss_cert_der;
    const rsa_pss_key_pem = @import("fixtures").rsa_pss_key_pem;
    const server_cert_der = @import("fixtures").server_cert_der;
    var rsa: PrivateKey = try .fromPemAuto(rsa_pss_key_pem);
    defer rsa.deinit();
    try rsa.pairsWith(&rsa_pss_cert_der);

    var ec: PrivateKey = try .fromPemAuto(ec_p256_key_pem);
    defer ec.deinit();
    try ec.pairsWith(&server_cert_der);
}

// RFC 8446 §4.4.3 — a different key of the same algorithm does not pair;
// the named error distinguishes a rotation mismatch from a load failure
// (#113).
test "PrivateKey.pairsWith: same-algorithm mismatch is a named error" {
    const client_ecdsa_cert_der = @import("fixtures").client_ecdsa_cert_der;
    const server_ecdsa_scalar = @import("fixtures").server_ecdsa_scalar;
    var key: PrivateKey = try .fromP256Scalar(&server_ecdsa_scalar);
    defer key.deinit();
    try testing.expectError(
        error.CertificateKeyMismatch,
        key.pairsWith(&client_ecdsa_cert_der),
    );
}

// RFC 8446 §4.4.3 — an EC key never pairs with an RSA certificate; the
// cross-algorithm case cannot pass any curve or modulus comparison (#113).
test "PrivateKey.pairsWith: cross-algorithm mismatch is a named error" {
    const rsa_pss_cert_der = @import("fixtures").rsa_pss_cert_der;
    const server_ecdsa_scalar = @import("fixtures").server_ecdsa_scalar;
    var key: PrivateKey = try .fromP256Scalar(&server_ecdsa_scalar);
    defer key.deinit();
    try testing.expectError(
        error.CertificateKeyMismatch,
        key.pairsWith(&rsa_pss_cert_der),
    );
}

// #113 — an unparseable leaf is a distinct failure from a pairing mismatch,
// so rotation tooling can tell a corrupt file from a wrong key.
test "PrivateKey.pairsWith: garbage leaf DER is not a certificate" {
    const scalar = [_]u8{0} ** 31 ++ .{1};
    var key: PrivateKey = try .fromP256Scalar(&scalar);
    defer key.deinit();
    try testing.expectError(error.InvalidCertificate, key.pairsWith("garbage"));
}

// RFC 8446 §4.4.2 — one CertificateEntry contains exactly one DER
// certificate. A valid leaf followed by trailing bytes is not exact leaf DER
// and must remain distinct from a parsed-but-unpaired certificate (#113).
test "PrivateKey.pairsWith: trailing bytes make leaf DER invalid" {
    const rsa_pss_cert_der = @import("fixtures").rsa_pss_cert_der;
    const rsa_pss_key_pem = @import("fixtures").rsa_pss_key_pem;
    const leaf_with_trailing_byte = rsa_pss_cert_der ++ [_]u8{0};
    var key: PrivateKey = try .fromPemAuto(rsa_pss_key_pem);
    defer key.deinit();
    try testing.expectError(
        error.InvalidCertificate,
        key.pairsWith(&leaf_with_trailing_byte),
    );
}
