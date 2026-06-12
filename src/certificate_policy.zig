//! X.509 policy checks used by TLS Certificate parsing.
//!
//! RFC 8446 §4.4.2.2
const Certificate = @import("cryptox/Certificate.zig");

pub const PolicyError = error{
    CertificateKeyUsageRejected,
    CertificateExtendedKeyUsageRejected,
    CertificateSignatureAlgorithmRejected,
};

pub const LeafUsage = enum {
    none,
    server_auth,
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
    /// check. ClientHandshake.start() fills this from its `server_name` when
    /// unset, so explicit policy values override SNI-derived defaults.
    host_name: ?[]const u8 = null,
    /// Enforce TLS 1.3 certificate residual policy for the leaf's intended use.
    /// `.server_auth` requires KeyUsage.digitalSignature when KeyUsage is present,
    /// EKU serverAuth when EKU is present, and a TLS 1.3-compatible certificate
    /// signature algorithm.
    leaf_usage: LeafUsage = .server_auth,
};

const eku_server_auth_oid = [_]u8{ 0x2b, 0x06, 0x01, 0x05, 0x05, 0x07, 0x03, 0x01 };
const key_usage_digital_signature: u4 = 0;

pub const VerifyServerAuthError = PolicyError || Certificate.ParseError;

// ziglint-ignore: Z015 -- VerifyServerAuthError is a public error-set alias.
pub fn verifyServerAuth(parsed: Certificate.Parsed) VerifyServerAuthError!void {
    // RFC 8446 §4.4.2.2 — server certificates must permit CertificateVerify
    // signing via KeyUsage.digitalSignature when KeyUsage is present.
    if (!try parsed.allowsKeyUsage(key_usage_digital_signature))
        return error.CertificateKeyUsageRejected;

    // RFC 5280 §4.2.1.12 — when EKU is present it restricts certificate use;
    // id-kp-serverAuth is required for TLS server authentication.
    if (!try parsed.allowsExtKeyUsage(&eku_server_auth_oid))
        return error.CertificateExtendedKeyUsageRejected;

    switch (parsed.signature_algorithm) {
        .sha256WithRSAEncryption,
        .sha384WithRSAEncryption,
        .sha512WithRSAEncryption,
        .ecdsa_with_SHA256,
        .ecdsa_with_SHA384,
        .ecdsa_with_SHA512,
        .curveEd25519,
        => {},
        else => return error.CertificateSignatureAlgorithmRejected,
    }
}

pub fn verifyAgainstBundle(
    bundle: *const Certificate.Bundle,
    subject: Certificate.Parsed,
    now_sec: i64,
) (PolicyError ||
    Certificate.ParseError ||
    Certificate.Parsed.VerifyError ||
    error{CertificateIssuerNotFound})!void {
    const issuer_index = bundle.find(subject.issuer()) orelse
        return error.CertificateIssuerNotFound;
    const issuer_cert: Certificate = .{ .buffer = bundle.bytes.items, .index = issuer_index };
    try subject.verify(try issuer_cert.parse(), now_sec);
}
