//! X.509 policy checks used by TLS Certificate parsing.
//!
//! RFC 8446 §4.4.2.2
const std = @import("std");
const backend = @import("crypto/backend.zig");
const Certificate = @import("certificate_parser.zig");
const SignatureScheme = @import("signature_scheme.zig").SignatureScheme;

pub const PolicyError = error{
    UnsupportedCertificateVersion,
    CertificateKeyUsageRejected,
    CertificateExtendedKeyUsageRejected,
    CertificateSignatureAlgorithmRejected,
};

pub const LeafUsage = enum {
    none,
    server_auth,
    /// Client-auth leaf policy: EKU clientAuth and KeyUsage.digitalSignature
    /// enforced when present, plus X.509v3 and signature-algorithm checks.
    client_auth,
};

/// Certificate validation policy.
pub const Policy = struct {
    /// Trust anchors for chain validation. If null, certificate parsing fails
    /// unless insecure_no_chain_anchor is set. That opt-in still extracts the
    /// leaf public key and lets CertificateVerify prove key possession, but it
    /// does not authenticate the chain to any trust root.
    bundle: ?*const Certificate.Bundle = null,
    /// Explicit test/demo escape hatch for self-signed fixtures. Production
    /// clients should leave this false and provide bundle.
    insecure_no_chain_anchor: bool = false,
    /// Current time in seconds since the Unix epoch, for validity checks.
    now_sec: i64 = 0,
    /// DNS name expected in the leaf certificate SAN/CN. null = no hostname
    /// check. ClientHandshake.Config.host_name seeds this field at init time so
    /// normal callers use one value for SNI and certificate validation.
    host_name: ?[]const u8 = null,
    /// Enforce TLS 1.3 certificate residual policy for the leaf's intended use.
    /// `.server_auth` requires KeyUsage.digitalSignature when KeyUsage is present,
    /// EKU serverAuth when EKU is present, and a TLS 1.3-compatible certificate
    /// signature algorithm. `.client_auth` mirrors that with EKU clientAuth.
    /// `.none` skips all leaf policy checks.
    leaf_usage: LeafUsage = .server_auth,
    /// Algorithms accepted for signatures appearing in certificates. This is the
    /// `signature_algorithms_cert` policy; when that extension is omitted, RFC
    /// 8446 §4.2.3 says `signature_algorithms` applies to certificates too.
    certificate_signature_schemes: []const SignatureScheme =
        backend.capabilities.certificate_signature_schemes,
};

// RFC 5280 §4.2.1.12 — id-kp-serverAuth (1.3.6.1.5.5.7.3.1).
const eku_server_auth_oid = [_]u8{ 0x2b, 0x06, 0x01, 0x05, 0x05, 0x07, 0x03, 0x01 };
// RFC 5280 §4.2.1.12 — id-kp-clientAuth (1.3.6.1.5.5.7.3.2).
const eku_client_auth_oid = [_]u8{ 0x2b, 0x06, 0x01, 0x05, 0x05, 0x07, 0x03, 0x02 };
const key_usage_digital_signature: u4 = 0;

pub const VerifyServerAuthError = PolicyError || Certificate.ParseError;
pub const VerifyClientAuthError = PolicyError || Certificate.ParseError;

// ziglint-ignore: Z015 -- VerifyServerAuthError is a public error-set alias.
pub fn verifyServerAuth(parsed: Certificate.Parsed) VerifyServerAuthError!void {
    return verifyServerAuthWithSignatureSchemes(
        parsed,
        backend.capabilities.certificate_signature_schemes,
    );
}

// ziglint-ignore: Z015 -- VerifyServerAuthError is a public error-set alias.
pub fn verifyServerAuthWithSignatureSchemes(
    parsed: Certificate.Parsed,
    certificate_signature_schemes: []const SignatureScheme,
) VerifyServerAuthError!void {
    return verifyLeafAuth(parsed, certificate_signature_schemes, &eku_server_auth_oid);
}

// ziglint-ignore: Z015 -- VerifyClientAuthError is a public error-set alias.
pub fn verifyClientAuth(parsed: Certificate.Parsed) VerifyClientAuthError!void {
    return verifyClientAuthWithSignatureSchemes(
        parsed,
        backend.capabilities.certificate_signature_schemes,
    );
}

// ziglint-ignore: Z015 -- VerifyClientAuthError is a public error-set alias.
pub fn verifyClientAuthWithSignatureSchemes(
    parsed: Certificate.Parsed,
    certificate_signature_schemes: []const SignatureScheme,
) VerifyClientAuthError!void {
    return verifyLeafAuth(parsed, certificate_signature_schemes, &eku_client_auth_oid);
}

/// Shared leaf-auth policy for both server-auth and client-auth: X.509v3,
/// KeyUsage.digitalSignature when KU is present, the role-specific EKU when
/// EKU is present, and a TLS 1.3-compatible certificate signature algorithm.
fn verifyLeafAuth(
    parsed: Certificate.Parsed,
    certificate_signature_schemes: []const SignatureScheme,
    eku_oid: []const u8,
) VerifyClientAuthError!void {
    // RFC 8446 §4.4.2.2 — unless another certificate type is negotiated, the
    // leaf certificate must be X.509v3.
    if (parsed.version != .v3) return error.UnsupportedCertificateVersion;

    // RFC 8446 §4.4.2.2 — leaf certificates must permit CertificateVerify
    // signing via KeyUsage.digitalSignature when KeyUsage is present.
    if (!try parsed.allowsKeyUsage(key_usage_digital_signature))
        return error.CertificateKeyUsageRejected;

    // RFC 5280 §4.2.1.12 — when EKU is present it restricts certificate use;
    // the role-specific id-kp-{server,client}Auth OID is required.
    if (!try parsed.allowsExtKeyUsage(eku_oid))
        return error.CertificateExtendedKeyUsageRejected;

    try verifyCertificateSignatureAlgorithm(
        parsed.signature_algorithm,
        certificate_signature_schemes,
    );
}

pub fn verifyCertificateSignatureAlgorithm(
    algorithm: Certificate.Algorithm,
    certificate_signature_schemes: []const SignatureScheme,
) PolicyError!void {
    const scheme = switch (algorithm) {
        .sha256WithRSAEncryption => SignatureScheme.rsa_pkcs1_sha256,
        .sha384WithRSAEncryption => .rsa_pkcs1_sha384,
        .sha512WithRSAEncryption => .rsa_pkcs1_sha512,
        .ecdsa_with_SHA256 => .ecdsa_secp256r1_sha256,
        .ecdsa_with_SHA384 => .ecdsa_secp384r1_sha384,
        .ecdsa_with_SHA512 => .ecdsa_secp521r1_sha512,
        .curveEd25519 => .ed25519,
        else => return error.CertificateSignatureAlgorithmRejected,
    };
    if (std.mem.indexOfScalar(SignatureScheme, certificate_signature_schemes, scheme) == null)
        return error.CertificateSignatureAlgorithmRejected;
}

pub const VerifyAgainstBundleError = PolicyError ||
    Certificate.ParseError ||
    Certificate.Parsed.VerifyError ||
    error{CertificateIssuerNotFound};

// ziglint-ignore: Z015 -- VerifyAgainstBundleError is a public error-set alias.
pub fn findVerifiedIssuerInBundle(
    bundle: *const Certificate.Bundle,
    subject: Certificate.Parsed,
    now_sec: i64,
) VerifyAgainstBundleError!Certificate.Parsed {
    const issuer_index = bundle.find(subject.issuer()) orelse
        return error.CertificateIssuerNotFound;
    const issuer_cert: Certificate = .{ .buffer = bundle.bytes.items, .index = issuer_index };
    const issuer = try issuer_cert.parse();
    try subject.verify(issuer, now_sec);
    return issuer;
}

// ziglint-ignore: Z015 -- VerifyAgainstBundleError is a public error-set alias.
pub fn verifyAgainstBundle(
    bundle: *const Certificate.Bundle,
    subject: Certificate.Parsed,
    now_sec: i64,
) VerifyAgainstBundleError!void {
    _ = try findVerifiedIssuerInBundle(bundle, subject, now_sec);
}
