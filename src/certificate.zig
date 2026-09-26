//! TLS 1.3 Certificate and CertificateVerify handshake message handling.
//!
//! RFC 8446 §4.4.2, §4.4.3
const std = @import("std");
const Io = std.Io;
const Sha256 = std.crypto.hash.sha2.Sha256;
const testing = std.testing;
const fixtures = @import("fixtures");
const fuzz_compat = @import("fuzz_compat.zig");

const ArrayBuffer = @import("array_buffer.zig").ArrayBuffer;
const certificate_policy = @import("certificate_policy.zig");
pub const LeafUsage = certificate_policy.LeafUsage;
pub const Policy = certificate_policy.Policy;
pub const PolicyError = certificate_policy.PolicyError;
const backend = @import("crypto/backend.zig");
const Certificate = @import("certificate_parser.zig");
const extension_type = @import("extension_type.zig");
const ExtensionType = extension_type.ExtensionType;
const handshake = @import("handshake.zig");
pub const SignatureScheme = @import("signature_scheme.zig").SignatureScheme;
const wire = @import("wire.zig");

pub const ParseError = error{
    UnexpectedEof,
    InvalidHandshakeType,
    InvalidHandshakeLength,
    UnexpectedCertificateRequestContext,
    EmptyCertificateList,
    InvalidExtensionLength,
    DuplicateExtension,
    UnsupportedExtension,
    UnexpectedExtension,
    CertificateIssuerNotFound,
    MissingTrustAnchor,
    CertificateChainTooLong,
} || PolicyError ||
    Certificate.ParseError ||
    Certificate.Parsed.VerifyError ||
    Certificate.Parsed.VerifyHostNameError ||
    Certificate.Parsed.NameConstraintError;

pub const EncodeError = error{ BufferTooShort, RequestContextTooLong };

pub const ClientCertificateStatus = enum {
    empty,
    present,
};

/// Verified client leaf material borrowed from the Certificate message.
pub const VerifiedClientChain = struct {
    pub_key: []const u8,
    leaf_der: []const u8,
};

pub fn encodedLen(certs_der: []const []const u8) usize {
    return encodedLenWithRequestContext(0, certs_der);
}

pub fn encodedLenWithRequestContext(
    request_context_len: usize,
    certs_der: []const []const u8,
) usize {
    var list_len: usize = 0;
    for (certs_der) |cert_der| list_len += 3 + cert_der.len + 2;
    return 4 + 1 + request_context_len + 3 + list_len;
}

/// Encode a TLS 1.3 Certificate handshake message with empty request_context
/// and empty per-certificate extensions. RFC 8446 §4.4.2.
pub fn encode(out: []u8, certs_der: []const []const u8) EncodeError![]const u8 {
    return encodeWithRequestContext(out, &.{}, certs_der);
}

/// Encode a TLS 1.3 Certificate handshake message with the request_context
/// echoed from CertificateRequest. RFC 8446 §4.4.2.
pub fn encodeWithRequestContext(
    out: []u8,
    request_context: []const u8,
    certs_der: []const []const u8,
) EncodeError![]const u8 {
    if (request_context.len > std.math.maxInt(u8)) return error.RequestContextTooLong;
    const len = encodedLenWithRequestContext(request_context.len, certs_der);
    if (out.len < len) return error.BufferTooShort;
    var w: wire.Writer = .init(out);
    const list_len = len - 4 - 1 - request_context.len - 3;
    w.append(handshake.Type, .certificate);
    w.append(u24, @intCast(len - 4));
    w.append(u8, @intCast(request_context.len));
    w.appendSlice(request_context);
    w.append(u24, @intCast(list_len));
    for (certs_der) |cert_der| {
        w.append(u24, @intCast(cert_der.len));
        w.appendSlice(cert_der);
        w.append(u16, 0x0000);
    }
    return w.written();
}

/// Parse a client Certificate message enough for server-side client-auth state
/// machine decisions. Full client certificate validation is intentionally left
/// to the later #4 verification slice; this helper validates framing,
/// request_context echo, list bounds, and per-entry extension syntax.
///
/// RFC 8446 §4.4.2
// ziglint-ignore: Z015 -- ParseError is a public error-set alias.
pub fn parseClientCertificate(
    msg: []const u8,
    expected_request_context: []const u8,
) ParseError!ClientCertificateStatus {
    if (msg.len < 4 + 1 + 3) return error.UnexpectedEof;
    var r: wire.Reader = .init(msg);

    const handshake_type = r.assumeRead(handshake.Type);
    if (handshake_type != .certificate) return error.InvalidHandshakeType;
    const body_len = r.assumeRead(u24);
    if (body_len != msg.len - 4) return error.InvalidHandshakeLength;

    const ctx_len = r.assumeRead(u8);
    if (r.remaining().len < @as(usize, ctx_len) + 3) return error.UnexpectedEof;
    const request_context = r.assumeReadSlice(ctx_len);
    if (!std.mem.eql(u8, request_context, expected_request_context))
        return error.UnexpectedCertificateRequestContext;

    const list_len = r.assumeRead(u24);
    if (r.remaining().len < list_len) return error.UnexpectedEof;
    if (list_len == 0) return .empty;

    const list_end = r.pos + list_len;
    while (r.pos < list_end) {
        if (list_end - r.pos < 3) return error.UnexpectedEof;
        const cert_len = r.assumeRead(u24);
        if (list_end - r.pos < @as(usize, cert_len) + 2) return error.UnexpectedEof;
        r.assumeSkip(cert_len);
        const ext_len = r.assumeRead(u16);
        if (list_end - r.pos < ext_len) return error.UnexpectedEof;
        try parseCertificateEntryExtensions(r.assumeReadSlice(ext_len));
    }
    if (r.pos != list_end) return error.UnexpectedEof;
    return .present;
}

/// Parse a client Certificate handshake message (echoing the CertificateRequest
/// request_context), return the verified leaf public key and DER as slices into
/// `msg`, and run chain validation per `policy`. Mirrors `parse` but accepts the
/// non-empty client request_context and uses the client-auth leaf policy. The
/// caller must keep `msg` alive until the returned slices have been consumed.
/// RFC 8446 §4.4.2 (client Certificate), §4.4.3 (client CertificateVerify).
// ziglint-ignore: Z015 -- ParseError is a public error-set alias.
pub fn parseClientChain(
    msg: []const u8,
    expected_request_context: []const u8,
    policy: Policy,
) ParseError!VerifiedClientChain {
    if (msg.len < 4 + 1 + 3) return error.UnexpectedEof;
    var r: wire.Reader = .init(msg);

    const handshake_type = r.assumeRead(handshake.Type);
    if (handshake_type != .certificate) return error.InvalidHandshakeType;
    const body_len = r.assumeRead(u24);
    if (body_len != msg.len - 4) return error.InvalidHandshakeLength;

    const ctx_len = r.assumeRead(u8);
    if (r.remaining().len < @as(usize, ctx_len) + 3) return error.UnexpectedEof;
    const request_context = r.assumeReadSlice(ctx_len);
    if (!std.mem.eql(u8, request_context, expected_request_context))
        return error.UnexpectedCertificateRequestContext;

    const list_len = r.assumeRead(u24);
    if (list_len == 0) return error.EmptyCertificateList;
    if (r.remaining().len < list_len) return error.UnexpectedEof;

    const list_end = r.pos + list_len;
    var cert_index: usize = 0;
    var leaf_pub_key: ?[]const u8 = null;
    var leaf_der: ?[]const u8 = null;
    var subject_to_verify: ?Certificate.Parsed = null;
    var chain: ArrayBuffer(Certificate.Parsed, 8) = .empty;

    while (r.pos < list_end) {
        if (list_end - r.pos < 3) return error.UnexpectedEof;
        const cert_len = r.assumeRead(u24);
        if (list_end - r.pos < @as(usize, cert_len) + 2) return error.UnexpectedEof;
        const cert_der = r.assumeReadSlice(cert_len);
        const ext_len = r.assumeRead(u16);
        if (list_end - r.pos < ext_len) return error.UnexpectedEof;
        try parseCertificateEntryExtensions(r.assumeReadSlice(ext_len));

        const cert: Certificate = .{ .buffer = cert_der, .index = 0 };
        const parsed = try cert.parse();
        chain.append(parsed) catch return error.CertificateChainTooLong;

        if (cert_index == 0) {
            leaf_pub_key = parsed.pubKey();
            leaf_der = cert_der;
            switch (policy.leaf_usage) {
                .none => {},
                .server_auth => try certificate_policy.verifyServerAuthWithSignatureSchemes(
                    parsed,
                    policy.certificate_signature_schemes,
                ),
                .client_auth => try certificate_policy.verifyClientAuthWithSignatureSchemes(
                    parsed,
                    policy.certificate_signature_schemes,
                ),
            }
            if (policy.host_name) |host_name| try parsed.verifyHostName(host_name);
        }
        if (subject_to_verify) |subject| {
            try certificate_policy.verifyIssuerUsage(parsed);
            try subject.verify(parsed, policy.now_sec);
        }
        subject_to_verify = parsed;
        cert_index += 1;
    }
    if (r.pos != list_end) return error.UnexpectedEof;

    if (chain.constSlice().len == 0) return error.EmptyCertificateList;
    try verifyChainCertificateSignatureAlgorithms(
        chain.constSlice(),
        policy.certificate_signature_schemes,
    );
    if (policy.bundle) |bundle| {
        const anchored = try anchorChain(bundle, chain.constSlice(), policy.now_sec);
        try verifyChainPathLength(chain.constSlice(), anchored.anchor, anchored.top);
        try verifyChainNameConstraints(chain.constSlice(), anchored.anchor);
    } else if (!policy.insecure_no_chain_anchor) {
        return error.MissingTrustAnchor;
    } else {
        // RFC 5280 §6.1 — with no anchor, the whole presented chain is the
        // path; a presented self-signed root behaves like an anchor because
        // §6.1.4(l) never charges a self-issued certificate budget while
        // §6.1.4(m) still applies its constraint.
        try verifyChainPathLength(chain.constSlice(), null, chain.constSlice().len - 1);
        try verifyChainNameConstraints(chain.constSlice(), null);
    }

    return .{
        .pub_key = leaf_pub_key orelse return error.EmptyCertificateList,
        .leaf_der = leaf_der orelse return error.EmptyCertificateList,
    };
}

/// Trusted-first path building: anchor the presented chain at the highest
/// certificate whose issuer is a trust anchor in the bundle. Servers may
/// terminate the presented chain at a cross-signed root (e.g. SSL.com 2022
/// roots cross-signed by Comodo AAA Certificate Services) whose issuer is not
/// a trust anchor, while a lower certificate's issuer is. Walking the chain
/// from the top down and accepting the first bundle hit matches OpenSSL's
/// default trusted-first behavior. A bundle hit whose signature or usage
/// checks fail is a hard error, not a cue to keep walking.
const AnchoredChain = struct {
    anchor: Certificate.Parsed,
    /// Index of the highest in-path certificate — the one the anchor issues,
    /// RFC 5280 §6.1 certificate 1. Presented certificates above it are
    /// outside the path for this constraint check. The parser separately
    /// verifies all presented signatures before anchor selection.
    top: usize,
};

fn anchorChain(
    bundle: *const Certificate.Bundle,
    chain: []const Certificate.Parsed,
    now_sec: i64,
) certificate_policy.VerifyAgainstBundleError!AnchoredChain {
    var i = chain.len;
    while (i > 0) {
        i -= 1;
        const anchor = certificate_policy.findVerifiedIssuerInBundle(
            bundle,
            chain[i],
            now_sec,
        ) catch |err| switch (err) {
            error.CertificateIssuerNotFound => continue,
            else => return err,
        };
        return .{ .anchor = anchor, .top = i };
    }
    return error.CertificateIssuerNotFound;
}

/// RFC 5280 §4.2.1.9 / §6.1 — enforce pathLenConstraint over the
/// certification path (#118). `chain` is the presented chain, leaf-first;
/// `top` is the index of the path's first certificate (§6.1 certificate 1,
/// the one the trust anchor issues); `anchor` is the parsed bundle anchor, or
/// null on the explicit no-anchor path where the whole presented chain is
/// the path.
///
/// Tracks the §6.1.2(k) max_path_length state variable: initialized to the
/// trust anchor's pathLenConstraint when the anchor certificate carries one
/// (§6.1.1(d)(g) trust-anchor inputs; OpenSSL applies an anchor's constraint
/// and ztls matches — tests/fixtures/pathlen/README.md records the
/// differential), else to the path length n, which no presented chain can
/// exceed. §6.1.4(l) charges one unit for every non-self-issued path
/// certificate except the final one (§4.2.1.9: the last certificate is not
/// an intermediate and is not counted) and rejects when the budget is
/// exhausted; §6.1.4(m) tightens the budget to any smaller pathLenConstraint
/// on a path certificate, so the tightest constraint binds. No allocation:
/// two comparisons per already-parsed certificate.
fn verifyChainPathLength(
    chain: []const Certificate.Parsed,
    anchor: ?Certificate.Parsed,
    top: usize,
) PolicyError!void {
    var max_path_length: usize = top + 1;
    if (anchor) |trust_anchor| {
        if (trust_anchor.basic_constraints_path_len) |limit| {
            max_path_length = @min(max_path_length, limit);
        }
    }

    var i = top;
    while (i > 0) : (i -= 1) {
        const cert = chain[i];
        // §6.1: self-issued certificates are not counted when evaluating
        // path length. §6.1.4(l): verify max_path_length is greater than
        // zero, then decrement.
        if (!std.mem.eql(u8, cert.subject(), cert.issuer())) {
            if (max_path_length == 0) return error.CertificatePathLengthExceeded;
            max_path_length -= 1;
        }
        // §6.1.4(m): reduce max_path_length to pathLenConstraint when smaller.
        if (cert.basic_constraints_path_len) |plc| {
            if (plc < max_path_length) max_path_length = plc;
        }
    }
}

/// Parse a Certificate handshake message and extract the leaf certificate
/// public key as a slice into `msg`. The caller must keep `msg` alive until
/// verifySignature has been called. Chain anchoring requires a trust bundle or
/// the explicit insecure_no_chain_anchor test/demo opt-in.
///
/// RFC 8446 §4.4.2
// ziglint-ignore: Z015 -- ParseError is a public error-set alias.
pub fn parse(msg: []const u8, policy: Policy) ParseError![]const u8 {
    if (msg.len < 4 + 1 + 3) return error.UnexpectedEof;
    var r: wire.Reader = .init(msg);

    const handshake_type = r.assumeRead(handshake.Type);
    if (handshake_type != .certificate) return error.InvalidHandshakeType;
    const body_len = r.assumeRead(u24);
    if (body_len != msg.len - 4) return error.InvalidHandshakeLength;

    const ctx_len = r.assumeRead(u8);
    if (ctx_len != 0) return error.UnexpectedCertificateRequestContext;
    if (r.remaining().len < 3) return error.UnexpectedEof;

    const list_len = r.assumeRead(u24);
    if (list_len == 0) return error.EmptyCertificateList;
    if (r.remaining().len < list_len) return error.UnexpectedEof;

    const list_end = r.pos + list_len;
    var cert_index: usize = 0;
    var leaf_pub_key: ?[]const u8 = null;
    var subject_to_verify: ?Certificate.Parsed = null;
    var chain: ArrayBuffer(Certificate.Parsed, 8) = .empty;

    while (r.pos < list_end) {
        if (list_end - r.pos < 3) return error.UnexpectedEof;
        const cert_len = r.assumeRead(u24);
        if (list_end - r.pos < @as(usize, cert_len) + 2) return error.UnexpectedEof;
        const cert_der = r.assumeReadSlice(cert_len);
        const ext_len = r.assumeRead(u16);
        if (list_end - r.pos < ext_len) return error.UnexpectedEof;
        try parseCertificateEntryExtensions(r.assumeReadSlice(ext_len));

        const cert: Certificate = .{ .buffer = cert_der, .index = 0 };
        const parsed = try cert.parse();
        chain.append(parsed) catch return error.CertificateChainTooLong;

        if (cert_index == 0) {
            leaf_pub_key = parsed.pubKey();
            switch (policy.leaf_usage) {
                .none => {},
                .server_auth => try certificate_policy.verifyServerAuthWithSignatureSchemes(
                    parsed,
                    policy.certificate_signature_schemes,
                ),
                .client_auth => try certificate_policy.verifyClientAuthWithSignatureSchemes(
                    parsed,
                    policy.certificate_signature_schemes,
                ),
            }
            if (policy.host_name) |host_name| try parsed.verifyHostName(host_name);
        }
        if (subject_to_verify) |subject| {
            try certificate_policy.verifyIssuerUsage(parsed);
            try subject.verify(parsed, policy.now_sec);
        }
        subject_to_verify = parsed;
        cert_index += 1;
    }
    if (r.pos != list_end) return error.UnexpectedEof;

    if (chain.constSlice().len == 0) return error.EmptyCertificateList;
    try verifyChainCertificateSignatureAlgorithms(
        chain.constSlice(),
        policy.certificate_signature_schemes,
    );
    if (policy.bundle) |bundle| {
        const anchored = try anchorChain(bundle, chain.constSlice(), policy.now_sec);
        try verifyChainPathLength(chain.constSlice(), anchored.anchor, anchored.top);
        try verifyChainNameConstraints(chain.constSlice(), anchored.anchor);
    } else if (!policy.insecure_no_chain_anchor) {
        return error.MissingTrustAnchor;
    } else {
        // RFC 5280 §6.1 — with no anchor, the whole presented chain is the
        // path; a presented self-signed root behaves like an anchor because
        // §6.1.4(l) never charges a self-issued certificate budget while
        // §6.1.4(m) still applies its constraint.
        try verifyChainPathLength(chain.constSlice(), null, chain.constSlice().len - 1);
        try verifyChainNameConstraints(chain.constSlice(), null);
    }

    return leaf_pub_key orelse error.EmptyCertificateList;
}

fn verifyChainCertificateSignatureAlgorithms(
    chain: []const Certificate.Parsed,
    certificate_signature_schemes: []const SignatureScheme,
) PolicyError!void {
    for (chain) |cert| {
        if (std.mem.eql(u8, cert.subject(), cert.issuer())) continue;
        try certificate_policy.verifyCertificateSignatureAlgorithm(
            cert.signature_algorithm,
            certificate_signature_schemes,
        );
    }
}

fn parseCertificateEntryExtensions(exts: []const u8) ParseError!void {
    try extension_type.rejectDuplicateExtensions(exts);
    var r: wire.Reader = .init(exts);
    var got_status_request = false;
    var got_sct = false;
    var unsupported = false;
    while (r.remaining().len != 0) {
        if (r.remaining().len < 4) return error.InvalidExtensionLength;
        const ext_type = r.assumeRead(ExtensionType);
        const ext_len = r.assumeRead(u16);
        if (r.remaining().len < ext_len) return error.InvalidExtensionLength;
        r.assumeSkip(ext_len);

        switch (ext_type) {
            .status_request => {
                if (got_status_request) return error.DuplicateExtension;
                got_status_request = true;
                unsupported = true;
            },
            .signed_certificate_timestamp => {
                if (got_sct) return error.DuplicateExtension;
                got_sct = true;
                unsupported = true;
            },
            .status_request_v2 => return error.UnexpectedExtension,
            else => {},
        }
    }
    if (unsupported) return error.UnsupportedExtension;
}

fn verifyChainNameConstraints(
    chain: []const Certificate.Parsed,
    trust_anchor: ?Certificate.Parsed,
) Certificate.Parsed.NameConstraintError!void {
    var ca_index: usize = 1;
    while (ca_index < chain.len) : (ca_index += 1) {
        try verifyIssuerNameConstraints(chain[ca_index], chain[0..ca_index]);
    }
    if (trust_anchor) |issuer| try verifyIssuerNameConstraints(issuer, chain);
}

fn verifyIssuerNameConstraints(
    issuer: Certificate.Parsed,
    subjects: []const Certificate.Parsed,
) Certificate.Parsed.NameConstraintError!void {
    if (issuer.nameConstraints().len == 0) return;

    // `subjects` is ordered leaf-first, so index zero is the final certificate
    // where RFC 5280 does not allow the self-issued intermediate exemption.
    for (subjects, 0..) |subject, subject_index| {
        const leaf = subject_index == 0;
        if (!leaf and std.mem.eql(u8, subject.subject(), subject.issuer())) continue;
        try issuer.verifyNameConstraints(subject);
    }
}

fn publicKeyFromCertificateBits(
    scheme: SignatureScheme,
    pub_key: []const u8,
) VerifyError!*backend.sign.pkey {
    return switch (scheme) {
        .ecdsa_secp256r1_sha256 => backend.sign.ecPublicKeyFromSec1(.secp256r1, pub_key),
        .ecdsa_secp384r1_sha384 => backend.sign.ecPublicKeyFromSec1(.secp384r1, pub_key),
        .rsa_pss_rsae_sha256,
        .rsa_pss_rsae_sha384,
        .rsa_pss_rsae_sha512,
        => backend.sign.rsaPublicKeyFromDer(pub_key),
        else => error.UnsupportedSignatureScheme,
    };
}

pub const server_certificate_verify_context = " " ** 64 ++ "TLS 1.3, server CertificateVerify\x00";
pub const client_certificate_verify_context = " " ** 64 ++ "TLS 1.3, client CertificateVerify\x00";

pub fn certificateVerifyEncodedLen(signature: []const u8) usize {
    return 4 + 2 + 2 + signature.len;
}

/// Encode a CertificateVerify handshake message from a caller-provided
/// signature. ztls does not own private keys; server-side code signs
/// `server_context || transcript_hash` outside this helper, then wraps the
/// signature here. RFC 8446 §4.4.3.
pub fn encodeCertificateVerify(
    out: []u8,
    scheme: SignatureScheme,
    signature: []const u8,
) EncodeError![]const u8 {
    const len = certificateVerifyEncodedLen(signature);
    if (out.len < len) return error.BufferTooShort;
    var w: wire.Writer = .init(out);
    w.append(handshake.Type, .certificate_verify);
    w.append(u24, @intCast(len - 4));
    w.append(SignatureScheme, scheme);
    w.append(u16, @intCast(signature.len));
    w.appendSlice(signature);
    return w.written();
}

pub const VerifyError = error{
    BufferTooShort,
    InvalidEncoding,
    InvalidEnumTag,
    InvalidHandshakeType,
    LibcryptoFailed,
    SignatureVerificationFailed,
    UnexpectedEof,
    UnsupportedSignatureScheme,
};

/// Verify a server CertificateVerify handshake message.
///
/// `pub_key` is a slice into the caller's Certificate message buffer.
/// `transcript_hash` covers all messages up to and including Certificate.
///
/// RFC 8446 §4.4.3
pub fn verifyServerSignature(
    msg: []const u8,
    pub_key: []const u8,
    transcript_hash: []const u8,
) VerifyError!void {
    return verifySignature(server_certificate_verify_context, msg, pub_key, transcript_hash);
}

pub fn verifyServerSignatureWithSchemes(
    msg: []const u8,
    pub_key: []const u8,
    transcript_hash: []const u8,
    offered_schemes: []const SignatureScheme,
) VerifyError!void {
    const scheme = try certificateVerifyScheme(msg);
    if (std.mem.indexOfScalar(SignatureScheme, offered_schemes, scheme) == null)
        return error.UnsupportedSignatureScheme;
    return verifyServerSignature(msg, pub_key, transcript_hash);
}

/// Verify a client CertificateVerify handshake message. RFC 8446 §4.4.3.
pub fn verifyClientSignature(
    msg: []const u8,
    pub_key: []const u8,
    transcript_hash: []const u8,
) VerifyError!void {
    return verifySignature(client_certificate_verify_context, msg, pub_key, transcript_hash);
}

/// Verify a client CertificateVerify and require the scheme to be one the
/// server offered in the CertificateRequest. RFC 8446 §4.4.3: the signature
/// algorithm MUST be one offered in the signature_algorithms extension of the
/// CertificateRequest. `offered_schemes` is the set the server sent.
pub fn verifyClientSignatureWithSchemes(
    msg: []const u8,
    pub_key: []const u8,
    transcript_hash: []const u8,
    offered_schemes: []const SignatureScheme,
) VerifyError!void {
    const scheme = try certificateVerifyScheme(msg);
    if (std.mem.indexOfScalar(SignatureScheme, offered_schemes, scheme) == null)
        return error.UnsupportedSignatureScheme;
    return verifyClientSignature(msg, pub_key, transcript_hash);
}

fn certificateVerifyScheme(msg: []const u8) VerifyError!SignatureScheme {
    if (msg.len < 4 + 2) return error.UnexpectedEof;
    var r: wire.Reader = .init(msg);
    const handshake_type = r.assumeRead(handshake.Type);
    if (handshake_type != .certificate_verify) return error.InvalidHandshakeType;
    r.assumeSkip(3);
    return r.read(SignatureScheme);
}

fn verifySignature(
    context: []const u8,
    msg: []const u8,
    pub_key: []const u8,
    transcript_hash: []const u8,
) VerifyError!void {
    if (msg.len < 4 + 2 + 2) return error.UnexpectedEof;
    var r: wire.Reader = .init(msg);

    const scheme = try certificateVerifyScheme(msg);
    r.assumeSkip(4 + 2);
    const sig_len = r.assumeRead(u16);
    if (r.remaining().len < sig_len) return error.UnexpectedEof;
    const sig = r.assumeReadSlice(sig_len);

    const key = try publicKeyFromCertificateBits(scheme, pub_key);
    defer backend.sign.freeKey(key);

    try backend.sign.verify(key, scheme, context, transcript_hash, sig);
}

// Fixtures generated with: scripts/gen-fixtures.sh
// Wrapped in functions so the @import of fixtures is never analyzed
// unless a test calls these — the published tarball doesn't include
// the fixtures module. Issue #66.
fn fixtureCertDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").server_cert_der;
}
fn fixtureCvSig() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").cv_sig;
}
fn fixtureRsaPssCertDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").rsa_pss_cert_der;
}
fn fixtureRsaPssCvSig() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").rsa_pss_cv_sig;
}
fn fixtureRsaPssCvSalt20Sig() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").rsa_pss_cv_salt20_sig;
}
const chain_root_pem = "tests/fixtures/chain/root.crt";
fn chainLeafDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").chain_leaf_der;
}
fn ed25519CertDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").ed25519_cert_der;
}
fn chainIntermediateDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").chain_intermediate_der;
}
const crosssigned_root_pem = "tests/fixtures/crosssigned/root.crt";
fn crosssignedLeafDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").crosssigned_leaf_der;
}
fn crosssignedIntermediateDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").crosssigned_intermediate_der;
}
fn crosssignedRootCrossDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").crosssigned_root_cross_der;
}
fn auditS5LeafDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").audit_s5_leaf_der;
}
fn auditS5IssuerDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").audit_s5_issuer_der;
}
fn nameConstraintsDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").name_constraints_der;
}
fn nameConstraintsNoncriticalDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").name_constraints_noncritical_der;
}
const nc_root_pem = "tests/fixtures/nameconstraints/root.crt";
fn ncIntermediateDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").nc_intermediate_der;
}
fn ncLeafAllowedDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").nc_leaf_allowed_der;
}
fn ncLeafExcludedDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").nc_leaf_excluded_der;
}
fn ncLeafOutsideDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").nc_leaf_outside_der;
}
const pathlen_root_pem = "tests/fixtures/pathlen/root.crt";
const pathlen_root_plc1_pem = "tests/fixtures/pathlen/root_plc1.crt";
const pathlen_crosssign_root_pem = "tests/fixtures/pathlen/crosssign_root.crt";
const pathlen_crosssign_untrusted_pem = "tests/fixtures/pathlen/crosssign_untrusted.crt";
fn pathlenZeroInterDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_zero_inter_der;
}
fn pathlenBelowZeroInterDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_below_zero_inter_der;
}
fn pathlenSelfIssuedInterDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_self_issued_inter_der;
}
fn pathlenBelowSiInterDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_below_si_inter_der;
}
fn pathlenBelowZeroLeafDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_below_zero_leaf_der;
}
fn pathlenSelfIssuedLeafDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_self_issued_leaf_der;
}
fn pathlenBelowSiLeafDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_below_si_leaf_der;
}
fn pathlenCaTargetDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_ca_target_der;
}
fn pathlenClientBelowZeroLeafDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_client_below_zero_leaf_der;
}
fn pathlenClientZeroLeafDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_client_zero_leaf_der;
}
fn pathlenOneInterDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_one_inter_der;
}
fn pathlenOneMidInterDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_one_mid_inter_der;
}
fn pathlenOneDeepInterDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_one_deep_inter_der;
}
fn pathlenOneLeafDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_one_leaf_der;
}
fn pathlenOneDeepLeafDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_one_deep_leaf_der;
}
fn pathlenMultiOuterInterDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_multi_outer_inter_der;
}
fn pathlenMultiInnerInterDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_multi_inner_inter_der;
}
fn pathlenMultiDeepInterDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_multi_deep_inter_der;
}
fn pathlenMultiLeafDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_multi_leaf_der;
}
fn pathlenMultiDeepLeafDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_multi_deep_leaf_der;
}
fn pathlenAbsentAInterDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_absent_a_inter_der;
}
fn pathlenAbsentBInterDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_absent_b_inter_der;
}
fn pathlenAbsentLeafDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_absent_leaf_der;
}
fn pathlenAnchorMidInterDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_anchor_mid_inter_der;
}
fn pathlenAnchorDeepInterDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_anchor_deep_inter_der;
}
fn pathlenAnchorLeafDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_anchor_leaf_der;
}
fn pathlenAnchorDeepLeafDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_anchor_deep_leaf_der;
}
fn pathlenCrossRootCrossDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_cross_root_cross_der;
}
fn pathlenCrossMidInterDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_cross_mid_inter_der;
}
fn pathlenCrossDeepInterDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_cross_deep_inter_der;
}
fn pathlenCrossLeafDer() []const u8 {
    // ziglint-ignore: Z028
    return &@import("fixtures").pathlen_cross_leaf_der;
}

fn buildCertMsg(buf: []u8, cert_der: []const u8) []const u8 {
    return buildCertChainMsg(buf, &.{cert_der});
}

fn buildCertChainMsg(buf: []u8, certs_der: []const []const u8) []const u8 {
    return encode(buf, certs_der) catch unreachable;
}

fn buildCvMsg(buf: []u8, sig: []const u8) []const u8 {
    return encodeCertificateVerify(buf, .ecdsa_secp256r1_sha256, sig) catch unreachable;
}

fn appendLeafCertificateExtensions(msg: []u8, msg_len: usize, extensions: []const u8) []const u8 {
    const ext_len_pos = msg_len - 2;
    @memcpy(msg[msg_len..][0..extensions.len], extensions);
    const ext_len: u16 = @intCast(extensions.len);
    msg[ext_len_pos..][0..2].* = .{ @intCast(ext_len >> 8), @intCast(ext_len & 0xff) };
    incrementU24(msg[1..4], @intCast(extensions.len));
    incrementU24(msg[5..8], @intCast(extensions.len));
    return msg[0 .. msg_len + extensions.len];
}

fn incrementU24(field: *[3]u8, n: u24) void {
    const value: u24 = (@as(u24, field[0]) << 16) |
        (@as(u24, field[1]) << 8) |
        field[2];
    const updated = value + n;
    field[0] = @intCast(updated >> 16);
    field[1] = @intCast((updated >> 8) & 0xff);
    field[2] = @intCast(updated & 0xff);
}

const test_transcript_hash = blk: {
    @setEvalBranchQuota(100_000);
    var out: [32]u8 = undefined;
    Sha256.hash("test transcript", &out, .{});
    break :blk out;
};

// RFC 8446 §4.4.2 — Certificate message framing. A cert_len near u24 max
// must not overflow the bounds-check arithmetic in the certificate-list loop.
test "parse: oversized cert_len does not overflow bounds check" {
    // 11-byte Certificate: type=0x0b, body_len=7, list_len=3, cert_len=0xFFFFFF
    const msg = [_]u8{ 0x0b, 0x00, 0x00, 0x07, 0x00, 0x00, 0x00, 0x03, 0xff, 0xff, 0xff };
    const result = parse(&msg, .{});
    _ = result catch return; // any error is fine; a panic is the bug
}

// RFC 8446 §4.4.2 — client Certificate request_context. A ctx_len near u8 max
// must not overflow the bounds-check arithmetic.
test "parseClientCertificate: oversized ctx_len does not overflow" {
    // 8-byte client Certificate: type=0x0b, body_len=4, ctx_len=0xFF
    const msg = [_]u8{ 0x0b, 0x00, 0x00, 0x04, 0xff, 0x00, 0x00, 0x00 };
    const result = parseClientCertificate(&msg, &.{});
    _ = result catch return; // any error is fine; a panic is the bug
}

test "parse: extracts public key from ECDSA P-256 certificate" {
    var buf: [1024]u8 = undefined;
    const msg = buildCertMsg(&buf, fixtureCertDer());
    const policy: Policy = .{ .insecure_no_chain_anchor = true };
    const pub_key = try parse(msg, policy);
    try testing.expect(pub_key.len > 0);

    // RFC 8446 §4.4.2 — client-chain validation also surfaces the leaf DER
    // borrowed from the Certificate message for caller-owned retention.
    const verified = try parseClientChain(msg, &.{}, policy);
    try testing.expectEqualSlices(u8, pub_key, verified.pub_key);
    try testing.expectEqualSlices(u8, fixtureCertDer(), verified.leaf_der);
}

test "parse: wrong handshake type" {
    var buf: [1024]u8 = undefined;
    _ = buildCertMsg(&buf, fixtureCertDer());
    buf[0] = 0x01;
    try testing.expectError(error.InvalidHandshakeType, parse(&buf, .{}));
}

// RFC 8446 §4.4 — the handshake header length must exactly match the
// Certificate body for both server and client chain parsers.
test "parse: rejects mismatched Certificate handshake body length" {
    var buf: [1024]u8 = undefined;
    const msg = buildCertMsg(&buf, fixtureCertDer());
    buf[1..4].* = .{ 0x00, 0x00, 0x00 };
    const policy: Policy = .{ .insecure_no_chain_anchor = true };

    try testing.expectError(error.InvalidHandshakeLength, parse(msg, policy));
    try testing.expectError(
        error.InvalidHandshakeLength,
        parseClientChain(msg, &.{}, policy),
    );
}

// RFC 8446 §4.4.2 — client Certificate echoes CertificateRequest context
// and may carry an empty certificate_list when no suitable certificate exists.
test "encodeWithRequestContext: encodes empty client certificate list" {
    var buf: [32]u8 = undefined;
    const encoded = try encodeWithRequestContext(&buf, &.{ 0xaa, 0xbb }, &.{});
    try testing.expectEqualSlices(u8, &.{
        0x0b, 0x00, 0x00, 0x06,
        0x02, 0xaa, 0xbb, 0x00,
        0x00, 0x00,
    }, encoded);
}

// RFC 8446 §4.4.2 — Certificate request_context is uint8 length-prefixed.
test "encodeWithRequestContext: rejects oversized request context" {
    var buf: [512]u8 = undefined;
    const context: [256]u8 = @splat(0xaa);
    try testing.expectError(
        error.RequestContextTooLong,
        encodeWithRequestContext(&buf, &context, &.{}),
    );
}

// RFC 8446 §4.4.2 — client Certificate in response to a handshake-time
// CertificateRequest echoes the request_context and may carry an empty list.
test "parseClientCertificate: accepts empty certificate with matching context" {
    var out: [64]u8 = undefined;
    const encoded = try encodeWithRequestContext(&out, &.{}, &.{});
    try testing.expectEqual(.empty, try parseClientCertificate(encoded, &.{}));
}

// RFC 8446 §4.4.2 — client Certificate request_context must match the
// CertificateRequest context byte-for-byte.
test "parseClientCertificate: rejects mismatched request context" {
    var out: [64]u8 = undefined;
    const encoded = try encodeWithRequestContext(&out, &.{0x01}, &.{});
    try testing.expectError(
        error.UnexpectedCertificateRequestContext,
        parseClientCertificate(encoded, &.{}),
    );
}

// RFC 8446 §4.4.2 — server Certificate request_context is always empty.
test "parse: rejects non-empty server certificate request context" {
    var buf: [2048]u8 = undefined;
    const encoded = buildCertMsg(&buf, fixtureCertDer());
    @memmove(buf[6 .. encoded.len + 1], buf[5..encoded.len]);
    buf[4] = 1;
    buf[5] = 0xaa;
    incrementU24(buf[1..4], 1);
    try testing.expectError(
        error.UnexpectedCertificateRequestContext,
        parse(buf[0 .. encoded.len + 1], .{ .insecure_no_chain_anchor = true }),
    );
}

// RFC 8446 §4.4.2.4 — server Certificate certificate_list must be non-empty.
test "parse: rejects empty certificate list" {
    const msg = [_]u8{
        @intFromEnum(handshake.Type.certificate), 0x00, 0x00, 0x04,
        0x00,                                     0x00, 0x00, 0x00,
    };
    try testing.expectError(error.EmptyCertificateList, parse(&msg, .{}));
}

// RFC 8446 §4.4.2 — Certificate.certificate_list is a uint24-length vector;
// its declared length must exactly bound the contained CertificateEntry values.
test "parse: rejects certificate list length shorter than entries" {
    var buf: [1024]u8 = undefined;
    const msg = buildCertMsg(&buf, fixtureCertDer());
    const shortened_list_len = msg.len - 4 - 1 - 3 - 1;
    buf[5..8].* = .{
        @intCast(shortened_list_len >> 16),
        @intCast((shortened_list_len >> 8) & 0xff),
        @intCast(shortened_list_len & 0xff),
    };
    try testing.expectError(
        error.UnexpectedEof,
        parse(msg, .{ .insecure_no_chain_anchor = true }),
    );
}

test "encode: round trips certificate chain" {
    var buf: [4096]u8 = undefined;
    const msg = try encode(&buf, &.{ chainLeafDer(), chainIntermediateDer() });
    try testing.expectEqual(encodedLen(&.{ chainLeafDer(), chainIntermediateDer() }), msg.len);
    const pub_key = try parse(msg, .{
        .host_name = "chain.test",
        .now_sec = 1_780_300_000,
        .insecure_no_chain_anchor = true,
    });
    try testing.expect(pub_key.len > 0);
}

// RFC 8446 §4.4.2.1 — ztls does not request or consume OCSP responses today,
// so a server CertificateEntry status_request extension is unsupported.
test "parse: rejects unsupported CertificateEntry status_request" {
    var buf: [2048]u8 = undefined;
    const msg = buildCertMsg(&buf, fixtureCertDer());
    const ext = [_]u8{ 0x00, 0x05, 0x00, 0x00 };
    const with_ext = appendLeafCertificateExtensions(&buf, msg.len, &ext);
    try testing.expectError(
        error.UnsupportedExtension,
        parse(with_ext, .{ .insecure_no_chain_anchor = true }),
    );
}

// RFC 8446 §4.4.2.1 — ztls does not request or consume SCTs today, so a server
// CertificateEntry signed_certificate_timestamp extension is unsupported.
test "parse: rejects unsupported CertificateEntry SCT" {
    var buf: [2048]u8 = undefined;
    const msg = buildCertMsg(&buf, fixtureCertDer());
    const ext = [_]u8{ 0x00, 0x12, 0x00, 0x00 };
    const with_ext = appendLeafCertificateExtensions(&buf, msg.len, &ext);
    try testing.expectError(
        error.UnsupportedExtension,
        parse(with_ext, .{ .insecure_no_chain_anchor = true }),
    );
}

// RFC 8446 §4.4.2.1 — TLS 1.3 servers must not send status_request_v2 in a
// Certificate message.
test "parse: rejects forbidden CertificateEntry status_request_v2" {
    var buf: [2048]u8 = undefined;
    const msg = buildCertMsg(&buf, fixtureCertDer());
    const ext = [_]u8{ 0x00, 0x11, 0x00, 0x00 };
    const with_ext = appendLeafCertificateExtensions(&buf, msg.len, &ext);
    try testing.expectError(
        error.UnexpectedExtension,
        parse(with_ext, .{ .insecure_no_chain_anchor = true }),
    );
}

// RFC 8446 §4.2 — duplicate extensions are forbidden in extension blocks.
test "parse: rejects duplicate CertificateEntry status_request" {
    var buf: [2048]u8 = undefined;
    const msg = buildCertMsg(&buf, fixtureCertDer());
    const ext = [_]u8{
        0x00, 0x05, 0x00, 0x00,
        0x00, 0x05, 0x00, 0x00,
    };
    const with_ext = appendLeafCertificateExtensions(&buf, msg.len, &ext);
    try testing.expectError(
        error.DuplicateExtension,
        parse(with_ext, .{ .insecure_no_chain_anchor = true }),
    );
}

// RFC 8446 §4.2 — extension blocks must be well-formed vectors.
test "parse: rejects malformed CertificateEntry extension length" {
    var buf: [2048]u8 = undefined;
    const msg = buildCertMsg(&buf, fixtureCertDer());
    const ext = [_]u8{ 0xbe, 0xef, 0x00, 0x02, 0xaa };
    const with_ext = appendLeafCertificateExtensions(&buf, msg.len, &ext);
    try testing.expectError(
        error.InvalidExtensionLength,
        parse(with_ext, .{ .insecure_no_chain_anchor = true }),
    );
}

// RFC 8446 §4.2 — unknown extensions are ignorable when they are otherwise
// well-formed.
test "parse: ignores unknown CertificateEntry extension" {
    var buf: [2048]u8 = undefined;
    const msg = buildCertMsg(&buf, fixtureCertDer());
    const ext = [_]u8{ 0xbe, 0xef, 0x00, 0x01, 0xaa };
    const with_ext = appendLeafCertificateExtensions(&buf, msg.len, &ext);
    const pub_key = try parse(with_ext, .{ .insecure_no_chain_anchor = true });
    try testing.expect(pub_key.len > 0);
}

test "parse: validates hostname" {
    var buf: [1024]u8 = undefined;
    const pub_key = try parse(buildCertMsg(&buf, fixtureCertDer()), .{
        .host_name = "test.local",
        .insecure_no_chain_anchor = true,
    });
    try testing.expect(pub_key.len > 0);
}

test "parse: rejects hostname mismatch" {
    var buf: [1024]u8 = undefined;
    try testing.expectError(
        error.CertificateHostMismatch,
        parse(buildCertMsg(&buf, fixtureCertDer()), .{ .host_name = "wrong.local" }),
    );
}

test "parse: rejects missing trust anchor by default" {
    var buf: [1024]u8 = undefined;
    try testing.expectError(
        error.MissingTrustAnchor,
        parse(buildCertMsg(&buf, fixtureCertDer()), .{ .host_name = "test.local" }),
    );
}

const empty_bundle: Certificate.Bundle = .empty;

fn addCertsFromFixturePath(bundle: *Certificate.Bundle, path: []const u8) !void {
    return bundle.addCertsFromFilePath(
        testing.allocator,
        testing.io,
        Io.Timestamp.now(testing.io, .real),
        Io.Dir.cwd(),
        path,
    );
}

test "parse: validates leaf against trust bundle" {
    var bundle: Certificate.Bundle = empty_bundle;
    defer bundle.deinit(testing.allocator);
    try addCertsFromFixturePath(&bundle, "tests/fixtures/server.crt");

    var buf: [1024]u8 = undefined;
    const pub_key = try parse(buildCertMsg(&buf, fixtureCertDer()), .{
        .bundle = &bundle,
        .now_sec = 1_780_300_000,
        .host_name = "test.local",
    });
    try testing.expect(pub_key.len > 0);
}

test "parse: validates leaf-intermediate-root chain" {
    var bundle: Certificate.Bundle = empty_bundle;
    defer bundle.deinit(testing.allocator);
    try addCertsFromFixturePath(&bundle, chain_root_pem);

    var buf: [4096]u8 = undefined;
    const pub_key = try parse(
        buildCertChainMsg(&buf, &.{ chainLeafDer(), chainIntermediateDer() }),
        .{ .bundle = &bundle, .now_sec = 1_780_300_000, .host_name = "chain.test" },
    );
    try testing.expect(pub_key.len > 0);
}

// RFC 5280 §4.2.1.9 and §4.2.1.3, RFC 8446 §4.4.2 — a certificate used as
// an issuer must assert cA and, when KeyUsage is present, keyCertSign.
test "parse: rejects end-entity certificate used as issuer" {
    var bundle: Certificate.Bundle = empty_bundle;
    defer bundle.deinit(testing.allocator);
    try addCertsFromFixturePath(&bundle, "tests/fixtures/audit_s5/root.crt");

    var buf: [4096]u8 = undefined;
    try testing.expectError(
        error.CertificateIssuerNotCa,
        parse(
            buildCertChainMsg(&buf, &.{ auditS5LeafDer(), auditS5IssuerDer() }),
            .{ .bundle = &bundle, .now_sec = 1_800_000_000, .host_name = "victim.test" },
        ),
    );
}

// RFC 8446 §4.4.2 — the sender certificate is the first CertificateEntry.
test "parse: rejects chain with intermediate before leaf" {
    var bundle: Certificate.Bundle = empty_bundle;
    defer bundle.deinit(testing.allocator);
    try addCertsFromFixturePath(&bundle, chain_root_pem);

    var buf: [4096]u8 = undefined;
    try testing.expectError(
        error.CertificateKeyUsageRejected,
        parse(
            buildCertChainMsg(&buf, &.{ chainIntermediateDer(), chainLeafDer() }),
            .{ .bundle = &bundle, .now_sec = 1_780_300_000, .host_name = "chain.test" },
        ),
    );
}

// RFC 5280 §6.1, RFC 8446 §4.4.2 — trusted-first path building: when the
// presented chain ends in a cross-signed root whose issuer is not a trust
// anchor, the verifier anchors the highest certificate whose issuer IS in
// the bundle. Mirrors production chains like example.com's SSL.com 2022
// root presented cross-signed by Comodo AAA Certificate Services.
test "parse: anchors chain below a cross-signed root" {
    var bundle: Certificate.Bundle = empty_bundle;
    defer bundle.deinit(testing.allocator);
    try addCertsFromFixturePath(&bundle, crosssigned_root_pem);

    var buf: [8192]u8 = undefined;
    const pub_key = try parse(
        buildCertChainMsg(&buf, &.{
            crosssignedLeafDer(),
            crosssignedIntermediateDer(),
            crosssignedRootCrossDer(),
        }),
        .{ .bundle = &bundle, .now_sec = 1_800_000_000, .host_name = "cross.test" },
    );
    try testing.expect(pub_key.len > 0);
}

// The presented cross-signed root alone must not anchor anything: its issuer
// is not in the bundle, and no lower certificate chains to the bundle root.
test "parse: rejects cross-signed root without a bundle anchor below it" {
    const bundle: Certificate.Bundle = empty_bundle;

    var buf: [8192]u8 = undefined;
    try testing.expectError(
        error.CertificateIssuerNotFound,
        parse(
            buildCertChainMsg(&buf, &.{
                crosssignedLeafDer(),
                crosssignedIntermediateDer(),
                crosssignedRootCrossDer(),
            }),
            .{ .bundle = &bundle, .now_sec = 1_800_000_000, .host_name = "cross.test" },
        ),
    );
}

test "parse: rejects chain with missing intermediate" {
    var bundle: Certificate.Bundle = empty_bundle;
    defer bundle.deinit(testing.allocator);
    try addCertsFromFixturePath(&bundle, chain_root_pem);

    var buf: [4096]u8 = undefined;
    try testing.expectError(
        error.CertificateIssuerNotFound,
        parse(
            buildCertChainMsg(&buf, &.{chainLeafDer()}),
            .{ .bundle = &bundle, .now_sec = 1_780_300_000, .host_name = "chain.test" },
        ),
    );
}

test "parse: rejects chain hostname mismatch" {
    var bundle: Certificate.Bundle = empty_bundle;
    defer bundle.deinit(testing.allocator);
    try addCertsFromFixturePath(&bundle, chain_root_pem);

    var buf: [4096]u8 = undefined;
    try testing.expectError(
        error.CertificateHostMismatch,
        parse(
            buildCertChainMsg(&buf, &.{ chainLeafDer(), chainIntermediateDer() }),
            .{ .bundle = &bundle, .now_sec = 1_780_300_000, .host_name = "wrong.chain.test" },
        ),
    );
}

test "parse: rejects untrusted leaf when bundle misses issuer" {
    const bundle: Certificate.Bundle = empty_bundle;
    var buf: [1024]u8 = undefined;
    try testing.expectError(
        error.CertificateIssuerNotFound,
        parse(buildCertMsg(&buf, fixtureCertDer()), .{
            .bundle = &bundle,
            .now_sec = 1_780_300_000,
        }),
    );
}

fn nameConstraintsBundle() !Certificate.Bundle {
    var bundle: Certificate.Bundle = empty_bundle;
    try addCertsFromFixturePath(&bundle, nc_root_pem);
    return bundle;
}

// RFC 5280 §4.2.1.10 — an intermediate CA's permitted DNS subtree allows
// subordinate certificates whose DNS SANs are inside that subtree.
test "parse: accepts chain with matching DNS name constraints" {
    var bundle = try nameConstraintsBundle();
    defer bundle.deinit(testing.allocator);

    var buf: [4096]u8 = undefined;
    const pub_key = try parse(
        buildCertChainMsg(&buf, &.{ ncLeafAllowedDer(), ncIntermediateDer() }),
        .{ .bundle = &bundle, .now_sec = 1_782_864_000, .host_name = "ok.example.com" },
    );
    try testing.expect(pub_key.len > 0);
}

// RFC 5280 §4.2.1.10 — excluded DNS subtrees override permitted DNS subtrees.
test "parse: rejects chain with excluded DNS name constraints" {
    var bundle = try nameConstraintsBundle();
    defer bundle.deinit(testing.allocator);

    var buf: [4096]u8 = undefined;
    try testing.expectError(
        error.CertificateNameConstraintViolation,
        parse(
            buildCertChainMsg(&buf, &.{ ncLeafExcludedDer(), ncIntermediateDer() }),
            .{ .bundle = &bundle, .now_sec = 1_782_864_000, .host_name = "bad.example.com" },
        ),
    );
}

// RFC 5280 §4.2.1.10 — permitted DNS subtrees reject subordinate names outside
// the constrained CA's namespace even when the leaf hostname itself matches.
test "parse: rejects chain outside permitted DNS name constraints" {
    var bundle = try nameConstraintsBundle();
    defer bundle.deinit(testing.allocator);

    var buf: [4096]u8 = undefined;
    try testing.expectError(
        error.CertificateNameConstraintViolation,
        parse(
            buildCertChainMsg(&buf, &.{ ncLeafOutsideDer(), ncIntermediateDer() }),
            .{ .bundle = &bundle, .now_sec = 1_782_864_000, .host_name = "other.test" },
        ),
    );
}

// RFC 5280 §4.2.1.10 — the explicit no-anchor test/demo path still enforces
// name constraints from certificates carried in the handshake chain.
test "parse: insecure no-anchor path still enforces name constraints" {
    var buf: [4096]u8 = undefined;
    try testing.expectError(
        error.CertificateNameConstraintViolation,
        parse(
            buildCertChainMsg(&buf, &.{ ncLeafExcludedDer(), ncIntermediateDer() }),
            .{
                .insecure_no_chain_anchor = true,
                .now_sec = 1_782_864_000,
                .host_name = "bad.example.com",
            },
        ),
    );
}

// RFC 5280 §4.2 — unprocessed critical extensions invalidate either role's chain.
test "parse: rejects signed unprocessed critical extension for both roles" {
    var bundle: Certificate.Bundle = empty_bundle;
    defer bundle.deinit(testing.allocator);
    try addCertsFromFixturePath(&bundle, "tests/fixtures/critical/root.crt");
    var buf: [2048]u8 = undefined;
    const msg = buildCertChainMsg(&buf, &.{&fixtures.extension_critical_der});
    const policy: Policy = .{ .bundle = &bundle, .now_sec = 1_800_000_000 };
    try testing.expectError(error.CertificateUnsupportedCriticalExtension, parse(msg, policy));
    try testing.expectError(
        error.CertificateUnsupportedCriticalExtension,
        parseClientChain(msg, &.{}, policy),
    );
}

// RFC 5280 §4.2 — non-critical extensions outside the verifier's support can be ignored.
test "parse: accepts signed noncritical extension and supported critical extensions" {
    var bundle: Certificate.Bundle = empty_bundle;
    defer bundle.deinit(testing.allocator);
    try addCertsFromFixturePath(&bundle, "tests/fixtures/critical/root.crt");
    for ([_][]const u8{ &fixtures.extension_valid_der, &fixtures.extension_ignored_der }) |cert| {
        var buf: [2048]u8 = undefined;
        const msg = buildCertChainMsg(&buf, &.{cert});
        const policy: Policy = .{
            .bundle = &bundle,
            .now_sec = 1_800_000_000,
            .host_name = "critical.test",
        };
        try testing.expect((try parse(msg, policy)).len > 0);
        _ = try parseClientChain(msg, &.{}, policy);
    }
}

// RFC 5280 §4.2.1.6 — GeneralNames is a constructed universal SEQUENCE.
test "parse: rejects signed SAN with an invalid wrapper" {
    var bundle: Certificate.Bundle = empty_bundle;
    defer bundle.deinit(testing.allocator);
    try addCertsFromFixturePath(&bundle, "tests/fixtures/critical/root.crt");
    for ([_][]const u8{
        &fixtures.extension_san_application_der,
        &fixtures.extension_san_context_der,
        &fixtures.extension_san_private_der,
        &fixtures.extension_san_set_der,
        &fixtures.extension_san_primitive_der,
    }) |cert| {
        var buf: [2048]u8 = undefined;
        try testing.expectError(error.CertificateFieldHasWrongDataType, parse(
            buildCertChainMsg(&buf, &.{cert}),
            .{ .bundle = &bundle, .now_sec = 1_800_000_000, .host_name = "critical.test" },
        ));
    }
}

// RFC 5280 §4.2.1.9 / §6.1 — pathLenConstraint enforcement (#118).
//
// Fixture family and per-case OpenSSL 3.6.4 ground truth:
// tests/fixtures/pathlen/README.md. Every verdict below was first recorded
// with `openssl verify` on the same DER (error 25 = "path length constraint
// exceeded" at the constraining certificate's depth).

const pathlen_now_sec: i64 = 1_800_000_000;

fn pathlenBundle(pem: []const u8) !Certificate.Bundle {
    var bundle: Certificate.Bundle = empty_bundle;
    try addCertsFromFixturePath(&bundle, pem);
    return bundle;
}

// RFC 5280 §4.2.1.9 — "A pathLenConstraint of zero indicates that no
// non-self-issued intermediate CA certificates may follow in a valid
// certification path." OpenSSL: error 25 at depth 2 (the pathlen:0 CA).
test "parse: rejects chain exceeding pathLenConstraint zero" {
    var bundle = try pathlenBundle(pathlen_root_pem);
    defer bundle.deinit(testing.allocator);

    var buf: [8192]u8 = undefined;
    try testing.expectError(
        error.CertificatePathLengthExceeded,
        parse(
            buildCertChainMsg(&buf, &.{
                pathlenBelowZeroLeafDer(),
                pathlenBelowZeroInterDer(),
                pathlenZeroInterDer(),
            }),
            .{
                .bundle = &bundle,
                .now_sec = pathlen_now_sec,
                .host_name = "below-zero.test",
            },
        ),
    );
}

// RFC 5280 §4.2.1.9 — the last certificate in the path is not an intermediate
// and is not counted, even when it is itself a CA certificate carrying
// pathLenConstraint. OpenSSL: catarget OK.
test "parse: accepts pathLenConstraint zero with a CA target" {
    var bundle = try pathlenBundle(pathlen_root_pem);
    defer bundle.deinit(testing.allocator);

    var buf: [4096]u8 = undefined;
    const pub_key = try parse(
        buildCertChainMsg(&buf, &.{ pathlenCaTargetDer(), pathlenZeroInterDer() }),
        .{
            .bundle = &bundle,
            .now_sec = pathlen_now_sec,
            .host_name = "catarget.test",
        },
    );
    try testing.expect(pub_key.len > 0);
}

// RFC 5280 §4.2.1.9 — pathlen:1 admits exactly one non-self-issued
// intermediate. OpenSSL: error 25 at depth 3 (the pathlen:1 CA).
test "parse: rejects chain exceeding pathLenConstraint one" {
    var bundle = try pathlenBundle(pathlen_root_pem);
    defer bundle.deinit(testing.allocator);

    var buf: [16384]u8 = undefined;
    try testing.expectError(
        error.CertificatePathLengthExceeded,
        parse(
            buildCertChainMsg(&buf, &.{
                pathlenOneDeepLeafDer(),
                pathlenOneDeepInterDer(),
                pathlenOneMidInterDer(),
                pathlenOneInterDer(),
            }),
            .{
                .bundle = &bundle,
                .now_sec = pathlen_now_sec,
                .host_name = "one-deep.test",
            },
        ),
    );
}

// RFC 5280 §4.2.1.9 — exactly one non-self-issued intermediate below a
// pathlen:1 CA is valid. OpenSSL: one.test OK.
test "parse: accepts chain at pathLenConstraint one" {
    var bundle = try pathlenBundle(pathlen_root_pem);
    defer bundle.deinit(testing.allocator);

    var buf: [8192]u8 = undefined;
    const pub_key = try parse(
        buildCertChainMsg(&buf, &.{
            pathlenOneLeafDer(),
            pathlenOneMidInterDer(),
            pathlenOneInterDer(),
        }),
        .{
            .bundle = &bundle,
            .now_sec = pathlen_now_sec,
            .host_name = "one.test",
        },
    );
    try testing.expect(pub_key.len > 0);
}

// RFC 5280 §4.2.1.9 — "Where pathLenConstraint does not appear, no limit is
// imposed": two intermediates below an unconstrained CA stay valid.
// OpenSSL: absent.test OK.
test "parse: imposes no path-length limit when pathLenConstraint is absent" {
    var bundle = try pathlenBundle(pathlen_root_pem);
    defer bundle.deinit(testing.allocator);

    var buf: [8192]u8 = undefined;
    const pub_key = try parse(
        buildCertChainMsg(&buf, &.{
            pathlenAbsentLeafDer(),
            pathlenAbsentBInterDer(),
            pathlenAbsentAInterDer(),
        }),
        .{
            .bundle = &bundle,
            .now_sec = pathlen_now_sec,
            .host_name = "absent.test",
        },
    );
    try testing.expect(pub_key.len > 0);
}

// RFC 5280 §6.1.4(m) — pathLenConstraint tightens max_path_length, so the
// tightest constraint binds even when a looser one higher in the path would
// allow the chain (inner pathlen:0 rejects what outer pathlen:2 permits).
// OpenSSL: error 25 at depth 2 (the pathlen:0 inner CA).
test "parse: enforces the tightest of multiple pathLenConstraints" {
    var bundle = try pathlenBundle(pathlen_root_pem);
    defer bundle.deinit(testing.allocator);

    var buf: [16384]u8 = undefined;
    try testing.expectError(
        error.CertificatePathLengthExceeded,
        parse(
            buildCertChainMsg(&buf, &.{
                pathlenMultiDeepLeafDer(),
                pathlenMultiDeepInterDer(),
                pathlenMultiInnerInterDer(),
                pathlenMultiOuterInterDer(),
            }),
            .{
                .bundle = &bundle,
                .now_sec = pathlen_now_sec,
                .host_name = "multi-deep.test",
            },
        ),
    );
}

// RFC 5280 §6.1.4(l),(m) — multiple constraints all satisfied (outer
// pathlen:2 with one intermediate below it, inner pathlen:0 with only the
// target below it). OpenSSL: multi.test OK.
test "parse: accepts multiple satisfied pathLenConstraints" {
    var bundle = try pathlenBundle(pathlen_root_pem);
    defer bundle.deinit(testing.allocator);

    var buf: [8192]u8 = undefined;
    const pub_key = try parse(
        buildCertChainMsg(&buf, &.{
            pathlenMultiLeafDer(),
            pathlenMultiInnerInterDer(),
            pathlenMultiOuterInterDer(),
        }),
        .{
            .bundle = &bundle,
            .now_sec = pathlen_now_sec,
            .host_name = "multi.test",
        },
    );
    try testing.expect(pub_key.len > 0);
}

// RFC 5280 §6.1 — "self-issued certificates are not counted when evaluating
// path length": a self-issued intermediate (§6.1.4(l) skip) below a
// pathlen:0 CA with only the target beneath it stays valid.
// OpenSSL: selfissued.test OK.
test "parse: self-issued intermediate does not consume path length" {
    var bundle = try pathlenBundle(pathlen_root_pem);
    defer bundle.deinit(testing.allocator);

    var buf: [8192]u8 = undefined;
    const pub_key = try parse(
        buildCertChainMsg(&buf, &.{
            pathlenSelfIssuedLeafDer(),
            pathlenSelfIssuedInterDer(),
            pathlenZeroInterDer(),
        }),
        .{
            .bundle = &bundle,
            .now_sec = pathlen_now_sec,
            .host_name = "selfissued.test",
        },
    );
    try testing.expect(pub_key.len > 0);
}

// RFC 5280 §6.1.4(l) — the self-issued exemption exempts only the self-issued
// certificate itself: a non-self-issued intermediate beneath it still
// consumes budget and violates the pathlen:0 CA above.
// OpenSSL: error 25 at depth 3 (the pathlen:0 CA).
test "parse: intermediate below a self-issued certificate still counts" {
    var bundle = try pathlenBundle(pathlen_root_pem);
    defer bundle.deinit(testing.allocator);

    var buf: [16384]u8 = undefined;
    try testing.expectError(
        error.CertificatePathLengthExceeded,
        parse(
            buildCertChainMsg(&buf, &.{
                pathlenBelowSiLeafDer(),
                pathlenBelowSiInterDer(),
                pathlenSelfIssuedInterDer(),
                pathlenZeroInterDer(),
            }),
            .{
                .bundle = &bundle,
                .now_sec = pathlen_now_sec,
                .host_name = "below-si.test",
            },
        ),
    );
}

// RFC 5280 §6.1.1(d)(g)/§6.2 — a trust anchor supplied as a certificate
// contributes its pathLenConstraint as the initial max_path_length input
// (§6.1.2(k)); OpenSSL applies it (error 25 attributes the failure to the
// anchor root itself at depth 3) and ztls matches. Two intermediates below a
// pathlen:1 anchor are rejected.
test "parse: trust anchor pathLenConstraint limits intermediates below it" {
    var bundle = try pathlenBundle(pathlen_root_plc1_pem);
    defer bundle.deinit(testing.allocator);

    var buf: [8192]u8 = undefined;
    try testing.expectError(
        error.CertificatePathLengthExceeded,
        parse(
            buildCertChainMsg(&buf, &.{
                pathlenAnchorDeepLeafDer(),
                pathlenAnchorDeepInterDer(),
                pathlenAnchorMidInterDer(),
            }),
            .{
                .bundle = &bundle,
                .now_sec = pathlen_now_sec,
                .host_name = "anchor-deep.test",
            },
        ),
    );
}

// RFC 5280 §6.1.1(g)/§6.1.2(k) — one intermediate below a pathlen:1 anchor
// is within the anchor's initial budget. OpenSSL: anchor.test OK.
test "parse: trust anchor pathLenConstraint satisfied" {
    var bundle = try pathlenBundle(pathlen_root_plc1_pem);
    defer bundle.deinit(testing.allocator);

    var buf: [4096]u8 = undefined;
    const pub_key = try parse(
        buildCertChainMsg(&buf, &.{ pathlenAnchorLeafDer(), pathlenAnchorMidInterDer() }),
        .{
            .bundle = &bundle,
            .now_sec = pathlen_now_sec,
            .host_name = "anchor.test",
        },
    );
    try testing.expect(pub_key.len > 0);
}

// RFC 5280 §6.1 — the prospective certification path starts at the
// certificate issued by the trust anchor; certificates presented above the
// anchored certificate are outside the path, so the cross-signed root's
// pathlen:0 does not constrain it. OpenSSL (trusted-first): cross.test OK.
test "parse: certificates above the anchored path are outside the path" {
    var bundle = try pathlenBundle(pathlen_crosssign_root_pem);
    defer bundle.deinit(testing.allocator);

    var buf: [16384]u8 = undefined;
    const pub_key = try parse(
        buildCertChainMsg(&buf, &.{
            pathlenCrossLeafDer(),
            pathlenCrossDeepInterDer(),
            pathlenCrossMidInterDer(),
            pathlenCrossRootCrossDer(),
        }),
        .{
            .bundle = &bundle,
            .now_sec = pathlen_now_sec,
            .host_name = "cross.test",
        },
    );
    try testing.expect(pub_key.len > 0);
}

// RFC 5280 §6.1 — the same presented chain anchored one certificate higher
// puts the cross-signed root inside the path, where its pathlen:0 binds.
// OpenSSL: error 25 at depth 3 (the cross-signed root).
test "parse: cross-signed root constraint binds inside the anchored path" {
    var bundle = try pathlenBundle(pathlen_crosssign_untrusted_pem);
    defer bundle.deinit(testing.allocator);

    var buf: [16384]u8 = undefined;
    try testing.expectError(
        error.CertificatePathLengthExceeded,
        parse(
            buildCertChainMsg(&buf, &.{
                pathlenCrossLeafDer(),
                pathlenCrossDeepInterDer(),
                pathlenCrossMidInterDer(),
                pathlenCrossRootCrossDer(),
            }),
            .{
                .bundle = &bundle,
                .now_sec = pathlen_now_sec,
                .host_name = "cross.test",
            },
        ),
    );
}

// RFC 5280 §4.2.1.9, RFC 8446 §4.4.2 — the shared chain-verification path
// also enforces pathLenConstraint for client-auth chains (parseClientChain).
test "parseClientChain: rejects client chain exceeding pathLenConstraint zero" {
    var bundle = try pathlenBundle(pathlen_root_pem);
    defer bundle.deinit(testing.allocator);

    var buf: [8192]u8 = undefined;
    try testing.expectError(
        error.CertificatePathLengthExceeded,
        parseClientChain(
            buildCertChainMsg(&buf, &.{
                pathlenClientBelowZeroLeafDer(),
                pathlenBelowZeroInterDer(),
                pathlenZeroInterDer(),
            }),
            &.{},
            .{
                .bundle = &bundle,
                .now_sec = pathlen_now_sec,
                .leaf_usage = .client_auth,
            },
        ),
    );
}

// RFC 5280 §4.2.1.9, RFC 8446 §4.4.2 — client-auth chains at a satisfied
// constraint are accepted (target excluded from the pathlen:0 budget).
test "parseClientChain: accepts client chain at pathLenConstraint zero" {
    var bundle = try pathlenBundle(pathlen_root_pem);
    defer bundle.deinit(testing.allocator);

    var buf: [4096]u8 = undefined;
    const verified = try parseClientChain(
        buildCertChainMsg(&buf, &.{ pathlenClientZeroLeafDer(), pathlenZeroInterDer() }),
        &.{},
        .{
            .bundle = &bundle,
            .now_sec = pathlen_now_sec,
            .leaf_usage = .client_auth,
        },
    );
    try testing.expect(verified.pub_key.len > 0);
}

// RFC 5280 §4.2.1.9 — the explicit no-anchor path still enforces the
// pathLenConstraints carried by the presented chain (mirrors the name-
// constraint behavior above): the whole presented chain is the path.
test "parse: insecure no-anchor path still enforces pathLenConstraint" {
    var buf: [8192]u8 = undefined;
    try testing.expectError(
        error.CertificatePathLengthExceeded,
        parse(
            buildCertChainMsg(&buf, &.{
                pathlenBelowZeroLeafDer(),
                pathlenBelowZeroInterDer(),
                pathlenZeroInterDer(),
            }),
            .{
                .insecure_no_chain_anchor = true,
                .now_sec = pathlen_now_sec,
                .host_name = "below-zero.test",
            },
        ),
    );
}

// RFC 5280 §6.1 — on the no-anchor path a presented self-signed root behaves
// like an anchor: §6.1.4(l) never charges it budget (self-issued) while
// §6.1.4(m) still applies its pathLenConstraint to everything below.
test "parse: insecure no-anchor path accepts constrained chain with self-issued steps" {
    var buf: [8192]u8 = undefined;
    const pub_key = try parse(
        buildCertChainMsg(&buf, &.{
            pathlenSelfIssuedLeafDer(),
            pathlenSelfIssuedInterDer(),
            pathlenZeroInterDer(),
        }),
        .{
            .insecure_no_chain_anchor = true,
            .now_sec = pathlen_now_sec,
            .host_name = "selfissued.test",
        },
    );
    try testing.expect(pub_key.len > 0);
}

test "parse: malformed DER length is rejected, not crashed" {
    const msg = [_]u8{
        0x0b, 0x00, 0x00, 0x0e, // Certificate, length 14
        0x00, // context length
        0x00, 0x00, 0x0a, // certificate_list length
        0x00, 0x00, 0x05, // cert length
        0x30, 0x82, 0x01, 0xd3, 0x00, // SEQUENCE claims 467 content bytes, has 1
        0x00, 0x00, // extensions length
    };
    try testing.expectError(error.CertificateFieldHasInvalidLength, parse(&msg, .{}));
}

// Build a Parsed leaf carrying only the fields certificate_policy.verifyServerAuth reads,
// so policy enforcement can be tested without generating full DER fixtures.
fn policyLeaf(
    buffer: []const u8,
    key_usage: Certificate.Parsed.Slice,
    ext_key_usage: Certificate.Parsed.Slice,
    signature_algorithm: Certificate.Algorithm,
) Certificate.Parsed {
    return policyLeafWithVersion(
        buffer,
        key_usage,
        ext_key_usage,
        signature_algorithm,
        .v3,
    );
}

fn policyLeafWithVersion(
    buffer: []const u8,
    key_usage: Certificate.Parsed.Slice,
    ext_key_usage: Certificate.Parsed.Slice,
    signature_algorithm: Certificate.Algorithm,
    version: Certificate.Version,
) Certificate.Parsed {
    return .{
        .certificate = .{ .buffer = buffer, .index = 0 },
        .issuer_slice = .empty,
        .subject_slice = .empty,
        .common_name_slice = .empty,
        .signature_slice = .empty,
        .signature_algorithm = signature_algorithm,
        .pub_key_algo = .{ .curveEd25519 = {} },
        .pub_key_slice = .empty,
        .message_slice = .empty,
        .subject_alt_name_slice = .empty,
        .key_usage_slice = key_usage,
        .ext_key_usage_slice = ext_key_usage,
        .name_constraints_slice = .empty,
        .name_constraints_critical = false,
        .validity = .{ .not_before = 0, .not_after = 0 },
        .version = version,
    };
}

fn policyChainCert(
    buffer: []const u8,
    issuer: Certificate.Parsed.Slice,
    subject: Certificate.Parsed.Slice,
    signature_algorithm: Certificate.Algorithm,
) Certificate.Parsed {
    var cert = policyLeaf(buffer, .empty, .empty, signature_algorithm);
    cert.issuer_slice = issuer;
    cert.subject_slice = subject;
    return cert;
}

// RFC 8446 §4.4.2.2 — unless another certificate type is negotiated, the
// server certificate must be X.509v3.
test "certificate_policy.verifyServerAuth: non-v3 certificates are rejected" {
    const versions = [_]Certificate.Version{ .v1, .v2 };
    for (versions) |version| {
        const leaf = policyLeafWithVersion("", .empty, .empty, .ecdsa_with_SHA256, version);
        try testing.expectError(
            error.UnsupportedCertificateVersion,
            certificate_policy.verifyServerAuth(leaf),
        );
    }
}

// RFC 8446 §4.4.2.2 — a server certificate whose KeyUsage extension is present
// but omits digitalSignature cannot sign CertificateVerify and must be rejected.
test "certificate_policy.verifyServerAuth: KeyUsage without digitalSignature is rejected" {
    // BIT STRING, 6 unused bits, 0x40 sets bit 1 (nonRepudiation) but not bit 0.
    const key_usage = "\x03\x02\x06\x40";
    const leaf = policyLeaf(
        key_usage,
        .{ .start = 0, .end = key_usage.len },
        .empty,
        .ecdsa_with_SHA256,
    );
    try testing.expectError(
        error.CertificateKeyUsageRejected,
        certificate_policy.verifyServerAuth(leaf),
    );
}

// RFC 5280 §4.2.1.12 — when EKU is present it restricts allowed uses; without
// id-kp-serverAuth the certificate must not be accepted for TLS server auth.
test "certificate_policy.verifyServerAuth: EKU without serverAuth is rejected" {
    // SEQUENCE { OID id-kp-clientAuth (1.3.6.1.5.5.7.3.2) }
    const eku = "\x30\x0a\x06\x08\x2b\x06\x01\x05\x05\x07\x03\x02";
    const leaf = policyLeaf(eku, .empty, .{ .start = 0, .end = eku.len }, .ecdsa_with_SHA256);
    try testing.expectError(
        error.CertificateExtendedKeyUsageRejected,
        certificate_policy.verifyServerAuth(leaf),
    );
}

// RFC 5280 §4.2.1.12 — a client certificate whose EKU is present but omits
// id-kp-clientAuth must not be accepted for TLS client auth.
test "certificate_policy.verifyClientAuth: EKU without clientAuth is rejected" {
    // SEQUENCE { OID id-kp-serverAuth (1.3.6.1.5.5.7.3.1) }
    const eku = "\x30\x0a\x06\x08\x2b\x06\x01\x05\x05\x07\x03\x01";
    const leaf = policyLeaf(eku, .empty, .{ .start = 0, .end = eku.len }, .ecdsa_with_SHA256);
    try testing.expectError(
        error.CertificateExtendedKeyUsageRejected,
        certificate_policy.verifyClientAuth(leaf),
    );
}

// RFC 8446 §4.4.2.2 — a client certificate whose KeyUsage is present but omits
// digitalSignature cannot sign CertificateVerify and must be rejected.
test "certificate_policy.verifyClientAuth: KeyUsage without digitalSignature is rejected" {
    const key_usage = "\x03\x02\x06\x40";
    const leaf = policyLeaf(
        key_usage,
        .{ .start = 0, .end = key_usage.len },
        .empty,
        .ecdsa_with_SHA256,
    );
    try testing.expectError(
        error.CertificateKeyUsageRejected,
        certificate_policy.verifyClientAuth(leaf),
    );
}

// RFC 8446 §4.4.2.2 — a client certificate with clientAuth EKU and no KeyUsage
// restriction is accepted for TLS client auth.
test "certificate_policy.verifyClientAuth: clientAuth EKU is accepted" {
    // SEQUENCE { OID id-kp-clientAuth (1.3.6.1.5.5.7.3.2) }
    const eku = "\x30\x0a\x06\x08\x2b\x06\x01\x05\x05\x07\x03\x02";
    const leaf = policyLeaf(eku, .empty, .{ .start = 0, .end = eku.len }, .ecdsa_with_SHA256);
    try certificate_policy.verifyClientAuth(leaf);
}

// RFC 8446 §4.2.3 — legacy certificate signature algorithms are rejected by
// the TLS 1.3 server-auth policy.
test "certificate_policy.verifyServerAuth: legacy certificate signatures are rejected" {
    const legacy_algorithms = [_]Certificate.Algorithm{
        .sha1WithRSAEncryption,
        .sha224WithRSAEncryption,
        .md2WithRSAEncryption,
        .md5WithRSAEncryption,
    };
    for (legacy_algorithms) |algorithm| {
        const leaf = policyLeaf("", .empty, .empty, algorithm);
        try testing.expectError(
            error.CertificateSignatureAlgorithmRejected,
            certificate_policy.verifyServerAuth(leaf),
        );
    }
}

// RFC 8446 §4.2.3 — rsa_pkcs1_sha256 is a certificate-signature-only scheme;
// accepting it for X.509 signatures does not make it a CertificateVerify scheme.
test "certificate_policy.verifyServerAuth: RSA PKCS1 SHA-256 certificate signature is accepted" {
    const leaf = policyLeaf("", .empty, .empty, .sha256WithRSAEncryption);
    try certificate_policy.verifyServerAuth(leaf);
}

// RFC 8446 §4.4.2.2 vs §4.4.3 — the certificate-chain signature algorithm
// (signature_algorithms_cert) is independent of the CertificateVerify scheme.
// Ed25519 chain signatures are verified via std.crypto.sign.Ed25519 in
// certificate_parser.zig, so .ed25519 is advertised in the backend's
// certificate_signature_schemes even though certificate_verify_schemes omits it.
test "certificate_policy: Ed25519 chain signature algorithm accepted when advertised" {
    const schemes = [_]SignatureScheme{.ed25519};
    try certificate_policy.verifyCertificateSignatureAlgorithm(.curveEd25519, &schemes);
}

// RFC 8446 §4.4.2.2 — Ed25519 must be absent from the advertised schemes to be
// rejected; the chain signature algorithm is policy-gated, not hardcoded.
test "certificate_policy: Ed25519 chain signature algorithm rejected when not advertised" {
    const schemes = [_]SignatureScheme{.ecdsa_secp256r1_sha256};
    try testing.expectError(
        error.CertificateSignatureAlgorithmRejected,
        certificate_policy.verifyCertificateSignatureAlgorithm(.curveEd25519, &schemes),
    );
}

// RFC 8446 §4.4.2.2 — a real Ed25519-signed self-signed certificate fixture is
// parsed and its chain signature is verified via std.crypto.sign.Ed25519. The
// leaf passes server-auth policy because .ed25519 is now in the backend's
// certificate_signature_schemes. The insecure_no_chain_anchor escape hatch is
// used because this is a self-signed fixture without a trust bundle.
test "parse: Ed25519 self-signed certificate verified via std.crypto" {
    var buf: [1024]u8 = undefined;
    const pub_key = try parse(buildCertMsg(&buf, ed25519CertDer()), .{
        .insecure_no_chain_anchor = true,
        .now_sec = 1_790_000_000,
        .host_name = "ed25519.server.test",
    });
    try testing.expect(pub_key.len > 0);
}

// RFC 8446 §4.2.3 — signature_algorithms_cert constrains certificate
// signatures independently from CertificateVerify signatures.
test "certificate_policy.verifyServerAuth: rejects certificate signature outside policy" {
    const schemes = [_]SignatureScheme{.rsa_pkcs1_sha256};
    const leaf = policyLeaf("", .empty, .empty, .ecdsa_with_SHA256);
    try testing.expectError(
        error.CertificateSignatureAlgorithmRejected,
        certificate_policy.verifyServerAuthWithSignatureSchemes(leaf, &schemes),
    );
}

// RFC 8446 §4.2.3, §4.4.2.2 — non-self-signed certificates sent by the
// server are checked against the advertised certificate signature schemes.
test "certificate signature policy checks non-self-signed chain certificates" {
    const schemes = [_]SignatureScheme{.ecdsa_secp256r1_sha256};
    const chain = [_]Certificate.Parsed{
        policyChainCert(
            "issuerleaf",
            .{ .start = 0, .end = 6 },
            .{ .start = 6, .end = 10 },
            .ecdsa_with_SHA256,
        ),
        policyChainCert(
            "issuerbad",
            .{ .start = 0, .end = 6 },
            .{ .start = 6, .end = 9 },
            .ecdsa_with_SHA384,
        ),
    };
    try testing.expectError(
        error.CertificateSignatureAlgorithmRejected,
        verifyChainCertificateSignatureAlgorithms(&chain, &schemes),
    );
}

// RFC 8446 §4.4.2.2 — self-signed certificates in the chain are not validated
// as part of the chain and may use algorithms outside the advertised list.
test "certificate signature policy skips self-signed chain certificates" {
    const schemes = [_]SignatureScheme{.ecdsa_secp256r1_sha256};
    const chain = [_]Certificate.Parsed{
        policyChainCert(
            "issuerleaf",
            .{ .start = 0, .end = 6 },
            .{ .start = 6, .end = 10 },
            .ecdsa_with_SHA256,
        ),
        policyChainCert(
            "root",
            .{ .start = 0, .end = 4 },
            .{ .start = 0, .end = 4 },
            .ecdsa_with_SHA384,
        ),
    };
    try verifyChainCertificateSignatureAlgorithms(&chain, &schemes);
}

// RFC 8446 §4.4.2.2 — a leaf with no KeyUsage/EKU restrictions and a supported
// signature algorithm satisfies the residual server-auth policy.
test "certificate_policy.verifyServerAuth: unrestricted supported leaf is accepted" {
    const leaf = policyLeaf("", .empty, .empty, .ecdsa_with_SHA256);
    try certificate_policy.verifyServerAuth(leaf);
}

test "encodeCertificateVerify: wraps signature" {
    var buf: [512]u8 = undefined;
    const msg = try encodeCertificateVerify(&buf, .ecdsa_secp256r1_sha256, fixtureCvSig());
    try testing.expectEqual(@as(u8, 0x0f), msg[0]);
    try testing.expectEqual(certificateVerifyEncodedLen(fixtureCvSig()), msg.len);
    try testing.expectEqualSlices(u8, fixtureCvSig(), msg[8..]);
}

test "verifySignature: valid ECDSA P-256 signature" {
    var cert_buf: [1024]u8 = undefined;
    const pub_key = try parse(buildCertMsg(&cert_buf, fixtureCertDer()), .{
        .insecure_no_chain_anchor = true,
    });
    var cv_buf: [512]u8 = undefined;
    try verifyServerSignature(buildCvMsg(&cv_buf, fixtureCvSig()), pub_key, &test_transcript_hash);
}

// RFC 8446 §4.2.3 — rsa_pss_rsae_sha256 uses RSASSA-PSS with SHA-256,
// MGF1(SHA-256), and salt length equal to the digest length.
test "verifySignature: valid RSA-PSS SHA-256 signature" {
    var cert_buf: [2048]u8 = undefined;
    const pub_key = try parse(buildCertMsg(&cert_buf, fixtureRsaPssCertDer()), .{
        .insecure_no_chain_anchor = true,
    });
    var cv_buf: [512]u8 = undefined;
    const cv = try encodeCertificateVerify(
        &cv_buf,
        .rsa_pss_rsae_sha256,
        fixtureRsaPssCvSig(),
    );
    try verifyServerSignature(cv, pub_key, &test_transcript_hash);
}

// RFC 8446 §4.2.3 — RSA-PSS CertificateVerify salt length is the hash output
// length, not an arbitrary PSS salt length accepted by generic RSA-PSS.
test "verifySignature: rejects RSA-PSS signature with wrong salt length" {
    var cert_buf: [2048]u8 = undefined;
    const pub_key = try parse(buildCertMsg(&cert_buf, fixtureRsaPssCertDer()), .{
        .insecure_no_chain_anchor = true,
    });
    var cv_buf: [512]u8 = undefined;
    const cv = try encodeCertificateVerify(
        &cv_buf,
        .rsa_pss_rsae_sha256,
        fixtureRsaPssCvSalt20Sig(),
    );
    try testing.expectError(
        error.SignatureVerificationFailed,
        verifyServerSignature(cv, pub_key, &test_transcript_hash),
    );
}

test "verifySignature: wrong transcript hash" {
    var cert_buf: [1024]u8 = undefined;
    const pub_key = try parse(buildCertMsg(&cert_buf, fixtureCertDer()), .{
        .insecure_no_chain_anchor = true,
    });
    var cv_buf: [512]u8 = undefined;
    const bad_hash: [32]u8 = @splat(0);
    try testing.expectError(
        error.SignatureVerificationFailed,
        verifyServerSignature(buildCvMsg(&cv_buf, fixtureCvSig()), pub_key, &bad_hash),
    );
}

// RFC 8446 §4.4.3 — CertificateVerify must use a scheme from the client's
// signature_algorithms extension, not just any scheme ztls globally supports.
test "verifySignature: rejects scheme absent from offered list" {
    var cert_buf: [1024]u8 = undefined;
    const pub_key = try parse(buildCertMsg(&cert_buf, fixtureCertDer()), .{
        .insecure_no_chain_anchor = true,
    });
    var cv_buf: [512]u8 = undefined;
    const offered = [_]SignatureScheme{.rsa_pss_rsae_sha256};
    try testing.expectError(
        error.UnsupportedSignatureScheme,
        verifyServerSignatureWithSchemes(
            buildCvMsg(&cv_buf, fixtureCvSig()),
            pub_key,
            &test_transcript_hash,
            &offered,
        ),
    );
}

// RFC 8446 §4.4.3 — a client CertificateVerify whose scheme is not in the
// server's CertificateRequest signature_algorithms is rejected with
// UnsupportedSignatureScheme (maps to illegal_parameter). This is the
// defensive guard the server uses against malicious client CVs.
test "verifySignature: client CV rejects scheme absent from offered list" {
    var cert_buf: [1024]u8 = undefined;
    const pub_key = try parse(buildCertMsg(&cert_buf, fixtureCertDer()), .{
        .insecure_no_chain_anchor = true,
    });
    var cv_buf: [512]u8 = undefined;
    const offered = [_]SignatureScheme{.rsa_pss_rsae_sha256};
    try testing.expectError(
        error.UnsupportedSignatureScheme,
        verifyClientSignatureWithSchemes(
            buildCvMsg(&cv_buf, fixtureCvSig()),
            pub_key,
            &test_transcript_hash,
            &offered,
        ),
    );
}

// RFC 8446 §4.4.3 — RSASSA-PKCS1-v1_5 schemes are certificate-signature-only
// in TLS 1.3 and must not be accepted for CertificateVerify.
test "verifySignature: rejects RSA PKCS1 CertificateVerify scheme" {
    var cert_buf: [1024]u8 = undefined;
    const pub_key = try parse(buildCertMsg(&cert_buf, fixtureCertDer()), .{
        .insecure_no_chain_anchor = true,
    });
    var cv_buf: [512]u8 = undefined;
    const cv = try encodeCertificateVerify(&cv_buf, .rsa_pkcs1_sha256, fixtureCvSig());
    try testing.expectError(
        error.UnsupportedSignatureScheme,
        verifyServerSignature(cv, pub_key, &test_transcript_hash),
    );
}

// RFC 8446 §4.2.3, §4.4.3 — the CertificateVerify scheme must be compatible
// with the certificate public key parameters.
test "verifySignature: rejects certificate key and scheme mismatch" {
    var cert_buf: [1024]u8 = undefined;
    const pub_key = try parse(buildCertMsg(&cert_buf, fixtureCertDer()), .{
        .insecure_no_chain_anchor = true,
    });
    var cv_buf: [512]u8 = undefined;
    const cv = try encodeCertificateVerify(&cv_buf, .ecdsa_secp384r1_sha384, fixtureCvSig());
    try testing.expectError(
        error.InvalidEncoding,
        verifyServerSignature(cv, pub_key, &test_transcript_hash),
    );
}

// RFC 8446 §4.4.3 — CertificateVerify context string binds the endpoint role.
test "verifySignature: server signature is not valid for client context" {
    var cert_buf: [1024]u8 = undefined;
    const pub_key = try parse(buildCertMsg(&cert_buf, fixtureCertDer()), .{
        .insecure_no_chain_anchor = true,
    });
    var cv_buf: [512]u8 = undefined;
    try testing.expectError(
        error.SignatureVerificationFailed,
        verifyClientSignature(buildCvMsg(&cv_buf, fixtureCvSig()), pub_key, &test_transcript_hash),
    );
}

test "verifySignature: wrong handshake type" {
    var cert_buf: [1024]u8 = undefined;
    const pub_key = try parse(buildCertMsg(&cert_buf, fixtureCertDer()), .{
        .insecure_no_chain_anchor = true,
    });
    var cv_buf: [512]u8 = undefined;
    _ = buildCvMsg(&cv_buf, fixtureCvSig());
    cv_buf[0] = 0x01;
    try testing.expectError(
        error.InvalidHandshakeType,
        verifyServerSignature(&cv_buf, pub_key, &test_transcript_hash),
    );
}

// RFC 5280 §4.2.1.10 — Name Constraints extension is parsed from a real
// certificate and its value slice is available, even though path-level
// enforcement is not yet implemented.
test "parse: extracts critical name constraints" {
    var buf: [1024]u8 = undefined;
    const pub_key = try parse(buildCertMsg(&buf, nameConstraintsDer()), .{
        .insecure_no_chain_anchor = true,
    });
    try testing.expect(pub_key.len > 0);

    // Verify the extension was extracted by parsing the leaf directly.
    const cert: Certificate = .{ .buffer = nameConstraintsDer(), .index = 0 };
    const parsed = try cert.parse();
    const nc = parsed.nameConstraints();
    try testing.expect(nc.len > 0);
    // First byte should be SEQUENCE (0x30) for NameConstraints.
    try testing.expectEqual(@as(u8, 0x30), nc[0]);
}

// RFC 5280 §4.2.1.10 — non-critical Name Constraints are also parsed.
test "parse: extracts non-critical name constraints" {
    var buf: [1024]u8 = undefined;
    const pub_key = try parse(buildCertMsg(&buf, nameConstraintsNoncriticalDer()), .{
        .insecure_no_chain_anchor = true,
    });
    try testing.expect(pub_key.len > 0);

    const cert: Certificate = .{ .buffer = nameConstraintsNoncriticalDer(), .index = 0 };
    const parsed = try cert.parse();
    const nc = parsed.nameConstraints();
    try testing.expect(nc.len > 0);
    try testing.expectEqual(@as(u8, 0x30), nc[0]);
}

// Fuzz target: parse must reject arbitrary Certificate bytes with an error,
// never crash. Exercises our framing plus certificate_parser's X.509 parser.
// Run with `zig build test --fuzz`.
fn fuzzParse(_: void, input: []const u8) anyerror!void {
    _ = parse(input, .{}) catch return;
}

test "fuzz: parse handles arbitrary input" {
    var buf: [1024]u8 = undefined;
    try fuzz_compat.fuzzBytes(fuzzParse, {}, .{
        .corpus = &.{buildCertMsg(&buf, fixtureCertDer())},
    });
}
