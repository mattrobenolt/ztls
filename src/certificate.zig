/// TLS 1.3 Certificate and CertificateVerify handshake message handling.
///
/// RFC 8446 §4.4.2, §4.4.3
const std = @import("std");
const Sha256 = std.crypto.hash.sha2.Sha256;
const testing = std.testing;

const Certificate = @import("cryptox/Certificate.zig");
const wire = @import("wire.zig");

const c = @import("c.zig").openssl;

pub const PolicyError = error{
    CertificateKeyUsageRejected,
    CertificateExtendedKeyUsageRejected,
    CertificateSignatureAlgorithmRejected,
};

pub const ParseError = error{
    UnexpectedEof,
    InvalidHandshakeType,
    EmptyCertificateList,
    CertificateIssuerNotFound,
} || PolicyError ||
    Certificate.ParseError ||
    Certificate.Parsed.VerifyError ||
    Certificate.Parsed.VerifyHostNameError;

pub const LeafUsage = enum {
    none,
    server_auth,
};

/// Certificate validation policy.
pub const Policy = struct {
    /// Trust anchors for chain validation. null = signature-only, no chain
    /// anchoring (the leaf public key is still extracted and the CV signature
    /// still verified).
    bundle: ?*const Certificate.Bundle = null,
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

/// RFC 8446 §4.2.3 signature schemes supported by ztls.
pub const SignatureScheme = enum(u16) {
    ecdsa_secp256r1_sha256 = 0x0403,
    ecdsa_secp384r1_sha384 = 0x0503,
    rsa_pss_rsae_sha256 = 0x0804,
    rsa_pss_rsae_sha384 = 0x0805,
    rsa_pss_rsae_sha512 = 0x0806,
    _,
};

pub const EncodeError = error{BufferTooShort};
pub const CertificateVerifyEncodeError = error{BufferTooShort};

pub fn encodedLen(certs_der: []const []const u8) usize {
    var list_len: usize = 0;
    for (certs_der) |cert_der| list_len += 3 + cert_der.len + 2;
    return 4 + 1 + 3 + list_len;
}

/// Encode a TLS 1.3 Certificate handshake message with empty request_context
/// and empty per-certificate extensions. RFC 8446 §4.4.2.
pub fn encode(out: []u8, certs_der: []const []const u8) EncodeError![]const u8 {
    const len = encodedLen(certs_der);
    if (out.len < len) return error.BufferTooShort;
    var w: wire.Writer = .init(out);
    const list_len = len - 4 - 1 - 3;
    w.append(u8, 0x0b);
    w.append(u24, @intCast(len - 4));
    w.append(u8, 0x00);
    w.append(u24, @intCast(list_len));
    for (certs_der) |cert_der| {
        w.append(u24, @intCast(cert_der.len));
        w.appendSlice(cert_der);
        w.append(u16, 0x0000);
    }
    return w.written();
}

/// Parse a Certificate handshake message and extract the leaf certificate
/// public key as a slice into `msg`. The caller must keep `msg` alive until
/// verifySignature has been called. Optionally validates the chain against
/// the policy's trust bundle.
///
/// RFC 8446 §4.4.2
// ziglint-ignore: Z015 -- ParseError is a public error-set alias.
pub fn parse(msg: []const u8, policy: Policy) ParseError![]const u8 {
    var r: wire.Reader = .init(msg);

    const handshake_type = try r.read(u8);
    if (handshake_type != 0x0b) return error.InvalidHandshakeType;
    try r.skip(3); // body length

    const ctx_len = try r.read(u8);
    try r.skip(ctx_len);

    const list_len = try r.read(u24);
    if (list_len == 0) return error.EmptyCertificateList;

    const list_end = r.pos + list_len;
    var cert_index: usize = 0;
    var leaf_pub_key: ?[]const u8 = null;
    var subject_to_verify: ?Certificate.Parsed = null;

    while (r.pos < list_end) {
        const cert_len = try r.read(u24);
        const cert_der = try r.readSlice(cert_len);
        const ext_len = try r.read(u16);
        try r.skip(ext_len);

        const cert: Certificate = .{ .buffer = cert_der, .index = 0 };
        const parsed = try cert.parse();

        if (cert_index == 0) {
            leaf_pub_key = parsed.pubKey();
            switch (policy.leaf_usage) {
                .none => {},
                .server_auth => try verifyServerAuthPolicy(parsed),
            }
            if (policy.host_name) |host_name| try parsed.verifyHostName(host_name);
        }
        if (subject_to_verify) |subject| try subject.verify(parsed, policy.now_sec);
        subject_to_verify = parsed;
        cert_index += 1;
    }

    if (policy.bundle) |bundle| {
        const subject = subject_to_verify orelse return error.EmptyCertificateList;
        try verifyAgainstBundle(bundle, subject, policy.now_sec);
    }

    return leaf_pub_key orelse error.EmptyCertificateList;
}

const eku_server_auth_oid = [_]u8{ 0x2b, 0x06, 0x01, 0x05, 0x05, 0x07, 0x03, 0x01 };
const key_usage_digital_signature: u4 = 0;

fn verifyServerAuthPolicy(parsed: Certificate.Parsed) ParseError!void {
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

fn verifyAgainstBundle(
    bundle: *const Certificate.Bundle,
    subject: Certificate.Parsed,
    now_sec: i64,
) ParseError!void {
    const issuer_index = bundle.find(subject.issuer()) orelse
        return error.CertificateIssuerNotFound;
    const issuer_cert: Certificate = .{ .buffer = bundle.bytes.items, .index = issuer_index };
    try subject.verify(try issuer_cert.parse(), now_sec);
}

pub const AuthError = ParseError || VerifyError;

fn publicKeyFromCertificateBits(
    scheme: SignatureScheme,
    pub_key: []const u8,
) VerifyError!*c.EVP_PKEY {
    return switch (scheme) {
        .ecdsa_secp256r1_sha256 => ecPublicKeyFromSec1(c.NID_X9_62_prime256v1, pub_key),
        .ecdsa_secp384r1_sha384 => ecPublicKeyFromSec1(c.NID_secp384r1, pub_key),
        .rsa_pss_rsae_sha256,
        .rsa_pss_rsae_sha384,
        .rsa_pss_rsae_sha512,
        => rsaPublicKeyFromDer(pub_key),
        else => error.UnsupportedSignatureScheme,
    };
}

fn ecPublicKeyFromSec1(nid: c_int, pub_key: []const u8) VerifyError!*c.EVP_PKEY {
    var ec: ?*c.EC_KEY = c.EC_KEY_new_by_curve_name(nid) orelse return error.InvalidEncoding;
    errdefer c.EC_KEY_free(ec);
    var ptr: [*c]const u8 = pub_key.ptr;
    if (c.o2i_ECPublicKey(&ec, &ptr, @intCast(pub_key.len)) == null) return error.InvalidEncoding;

    const key = c.EVP_PKEY_new() orelse return error.SignatureVerificationFailed;
    errdefer c.EVP_PKEY_free(key);
    if (c.EVP_PKEY_assign_EC_KEY(key, ec) != 1) return error.SignatureVerificationFailed;
    return key;
}

fn rsaPublicKeyFromDer(pub_key: []const u8) VerifyError!*c.EVP_PKEY {
    var ptr: [*c]const u8 = pub_key.ptr;
    const rsa = c.d2i_RSAPublicKey(null, &ptr, @intCast(pub_key.len)) orelse
        return error.InvalidEncoding;
    errdefer c.RSA_free(rsa);

    const key = c.EVP_PKEY_new() orelse return error.SignatureVerificationFailed;
    errdefer c.EVP_PKEY_free(key);
    if (c.EVP_PKEY_assign_RSA(key, rsa) != 1) return error.SignatureVerificationFailed;
    return key;
}

const server_context = " " ** 64 ++ "TLS 1.3, server CertificateVerify\x00";
const client_context = " " ** 64 ++ "TLS 1.3, client CertificateVerify\x00";

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
) CertificateVerifyEncodeError![]const u8 {
    const len = certificateVerifyEncodedLen(signature);
    if (out.len < len) return error.BufferTooShort;
    var w: wire.Writer = .init(out);
    w.append(u8, 0x0f);
    w.append(u24, @intCast(len - 4));
    w.append(SignatureScheme, scheme);
    w.append(u16, @intCast(signature.len));
    w.appendSlice(signature);
    return w.written();
}

pub const server_certificate_verify_context = server_context;
pub const client_certificate_verify_context = client_context;

pub const VerifyError = error{
    InvalidEnumTag,
    UnexpectedEof,
    InvalidHandshakeType,
    UnsupportedSignatureScheme,
    InvalidEncoding,
    SignatureVerificationFailed,
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
    return verifySignature(server_context, msg, pub_key, transcript_hash);
}

/// Verify a client CertificateVerify handshake message. RFC 8446 §4.4.3.
pub fn verifyClientSignature(
    msg: []const u8,
    pub_key: []const u8,
    transcript_hash: []const u8,
) VerifyError!void {
    return verifySignature(client_context, msg, pub_key, transcript_hash);
}

fn verifySignature(
    context: []const u8,
    msg: []const u8,
    pub_key: []const u8,
    transcript_hash: []const u8,
) VerifyError!void {
    var r: wire.Reader = .init(msg);

    const handshake_type = try r.read(u8);
    if (handshake_type != 0x0f) return error.InvalidHandshakeType;
    try r.skip(3);

    const scheme = try r.read(SignatureScheme);
    const sig_len = try r.read(u16);
    const sig = try r.readSlice(sig_len);

    const md = switch (scheme) {
        .ecdsa_secp256r1_sha256, .rsa_pss_rsae_sha256 => c.EVP_sha256(),
        .ecdsa_secp384r1_sha384, .rsa_pss_rsae_sha384 => c.EVP_sha384(),
        .rsa_pss_rsae_sha512 => c.EVP_sha512(),
        else => return error.UnsupportedSignatureScheme,
    } orelse return error.SignatureVerificationFailed;

    const key = try publicKeyFromCertificateBits(scheme, pub_key);
    defer c.EVP_PKEY_free(key);

    const ctx = c.EVP_MD_CTX_new() orelse return error.SignatureVerificationFailed;
    defer c.EVP_MD_CTX_free(ctx);
    var pctx: ?*c.EVP_PKEY_CTX = null;
    if (c.EVP_DigestVerifyInit(ctx, &pctx, md, null, key) != 1)
        return error.SignatureVerificationFailed;
    switch (scheme) {
        .rsa_pss_rsae_sha256, .rsa_pss_rsae_sha384, .rsa_pss_rsae_sha512 => {
            if (c.EVP_PKEY_CTX_set_rsa_padding(pctx, c.RSA_PKCS1_PSS_PADDING) != 1)
                return error.SignatureVerificationFailed;
            if (c.EVP_PKEY_CTX_set_rsa_pss_saltlen(pctx, c.RSA_PSS_SALTLEN_DIGEST) != 1)
                return error.SignatureVerificationFailed;
        },
        else => {},
    }
    if (c.EVP_DigestVerifyUpdate(ctx, context.ptr, context.len) != 1)
        return error.SignatureVerificationFailed;
    if (c.EVP_DigestVerifyUpdate(ctx, transcript_hash.ptr, transcript_hash.len) != 1)
        return error.SignatureVerificationFailed;
    if (c.EVP_DigestVerifyFinal(ctx, sig.ptr, sig.len) != 1)
        return error.SignatureVerificationFailed;
}

// Fixtures generated with: just gen-fixtures
// Transcript hash: SHA-256("test transcript")

const fixture_cert_der = @embedFile("test_fixtures/server.crt.der");
const fixture_cv_sig = @embedFile("test_fixtures/cv.sig");
const chain_root_pem = "tests/fixtures/chain/root.crt";
const chain_leaf_der = @embedFile("test_fixtures/chain/leaf.der");
const chain_intermediate_der = @embedFile("test_fixtures/chain/intermediate.der");
const name_constraints_der = @embedFile("test_fixtures/name_constraints.der");
const name_constraints_noncritical_der =
    @embedFile("test_fixtures/name_constraints_noncritical.der");

fn buildCertMsg(buf: []u8, cert_der: []const u8) []const u8 {
    return buildCertChainMsg(buf, &.{cert_der});
}

fn buildCertChainMsg(buf: []u8, certs_der: []const []const u8) []const u8 {
    return encode(buf, certs_der) catch unreachable;
}

fn buildCvMsg(buf: []u8, sig: []const u8) []const u8 {
    return encodeCertificateVerify(buf, .ecdsa_secp256r1_sha256, sig) catch unreachable;
}

const test_transcript_hash = blk: {
    @setEvalBranchQuota(100_000);
    var out: [32]u8 = undefined;
    Sha256.hash("test transcript", &out, .{});
    break :blk out;
};

test "parse: extracts public key from ECDSA P-256 certificate" {
    var buf: [1024]u8 = undefined;
    const pub_key = try parse(buildCertMsg(&buf, fixture_cert_der), .{});
    try testing.expect(pub_key.len > 0);
}

test "parse: wrong handshake type" {
    var buf: [1024]u8 = undefined;
    _ = buildCertMsg(&buf, fixture_cert_der);
    buf[0] = 0x01;
    try testing.expectError(error.InvalidHandshakeType, parse(&buf, .{}));
}

test "encode: round trips certificate chain" {
    var buf: [4096]u8 = undefined;
    const msg = try encode(&buf, &.{ chain_leaf_der, chain_intermediate_der });
    try testing.expectEqual(encodedLen(&.{ chain_leaf_der, chain_intermediate_der }), msg.len);
    const pub_key = try parse(msg, .{ .host_name = "chain.test", .now_sec = 1_780_300_000 });
    try testing.expect(pub_key.len > 0);
}

test "parse: validates hostname" {
    var buf: [1024]u8 = undefined;
    const pub_key = try parse(buildCertMsg(&buf, fixture_cert_der), .{ .host_name = "test.local" });
    try testing.expect(pub_key.len > 0);
}

test "parse: rejects hostname mismatch" {
    var buf: [1024]u8 = undefined;
    try testing.expectError(
        error.CertificateHostMismatch,
        parse(buildCertMsg(&buf, fixture_cert_der), .{ .host_name = "wrong.local" }),
    );
}

test "parse: validates leaf against trust bundle" {
    var bundle: Certificate.Bundle = .{};
    defer bundle.deinit(testing.allocator);
    try bundle.addCertsFromFilePath(testing.allocator, std.fs.cwd(), "tests/fixtures/server.crt");

    var buf: [1024]u8 = undefined;
    const pub_key = try parse(buildCertMsg(&buf, fixture_cert_der), .{
        .bundle = &bundle,
        .now_sec = 1_780_300_000,
        .host_name = "test.local",
    });
    try testing.expect(pub_key.len > 0);
}

test "parse: validates leaf-intermediate-root chain" {
    var bundle: Certificate.Bundle = .{};
    defer bundle.deinit(testing.allocator);
    try bundle.addCertsFromFilePath(testing.allocator, std.fs.cwd(), chain_root_pem);

    var buf: [4096]u8 = undefined;
    const pub_key = try parse(
        buildCertChainMsg(&buf, &.{ chain_leaf_der, chain_intermediate_der }),
        .{ .bundle = &bundle, .now_sec = 1_780_300_000, .host_name = "chain.test" },
    );
    try testing.expect(pub_key.len > 0);
}

test "parse: rejects chain with missing intermediate" {
    var bundle: Certificate.Bundle = .{};
    defer bundle.deinit(testing.allocator);
    try bundle.addCertsFromFilePath(testing.allocator, std.fs.cwd(), chain_root_pem);

    var buf: [4096]u8 = undefined;
    try testing.expectError(
        error.CertificateIssuerNotFound,
        parse(
            buildCertChainMsg(&buf, &.{chain_leaf_der}),
            .{ .bundle = &bundle, .now_sec = 1_780_300_000, .host_name = "chain.test" },
        ),
    );
}

test "parse: rejects chain hostname mismatch" {
    var bundle: Certificate.Bundle = .{};
    defer bundle.deinit(testing.allocator);
    try bundle.addCertsFromFilePath(testing.allocator, std.fs.cwd(), chain_root_pem);

    var buf: [4096]u8 = undefined;
    try testing.expectError(
        error.CertificateHostMismatch,
        parse(
            buildCertChainMsg(&buf, &.{ chain_leaf_der, chain_intermediate_der }),
            .{ .bundle = &bundle, .now_sec = 1_780_300_000, .host_name = "wrong.chain.test" },
        ),
    );
}

test "parse: rejects untrusted leaf when bundle misses issuer" {
    const bundle: Certificate.Bundle = .{};
    var buf: [1024]u8 = undefined;
    try testing.expectError(
        error.CertificateIssuerNotFound,
        parse(buildCertMsg(&buf, fixture_cert_der), .{
            .bundle = &bundle,
            .now_sec = 1_780_300_000,
        }),
    );
}

test "parse: malformed DER length is rejected, not crashed" {
    const msg = [_]u8{
        0x0b, 0x00, 0x00, 0x0d, // Certificate, length 13
        0x00, // context length
        0x00, 0x00, 0x09, // certificate_list length
        0x00, 0x00, 0x05, // cert length
        0x30, 0x82, 0x01, 0xd3, 0x00, // SEQUENCE claims 467 content bytes, has 1
        0x00, 0x00, // extensions length
    };
    try testing.expectError(error.CertificateFieldHasInvalidLength, parse(&msg, .{}));
}

// Build a Parsed leaf carrying only the fields verifyServerAuthPolicy reads,
// so policy enforcement can be tested without generating full DER fixtures.
fn policyLeaf(
    buffer: []const u8,
    key_usage: Certificate.Parsed.Slice,
    ext_key_usage: Certificate.Parsed.Slice,
    signature_algorithm: Certificate.Algorithm,
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
        .validity = .{ .not_before = 0, .not_after = 0 },
        .version = .v3,
    };
}

// RFC 8446 §4.4.2.2 — a server certificate whose KeyUsage extension is present
// but omits digitalSignature cannot sign CertificateVerify and must be rejected.
test "verifyServerAuthPolicy: KeyUsage without digitalSignature is rejected" {
    // BIT STRING, 6 unused bits, 0x40 sets bit 1 (nonRepudiation) but not bit 0.
    const key_usage = "\x03\x02\x06\x40";
    const leaf = policyLeaf(
        key_usage,
        .{ .start = 0, .end = key_usage.len },
        .empty,
        .ecdsa_with_SHA256,
    );
    try testing.expectError(error.CertificateKeyUsageRejected, verifyServerAuthPolicy(leaf));
}

// RFC 5280 §4.2.1.12 — when EKU is present it restricts allowed uses; without
// id-kp-serverAuth the certificate must not be accepted for TLS server auth.
test "verifyServerAuthPolicy: EKU without serverAuth is rejected" {
    // SEQUENCE { OID id-kp-clientAuth (1.3.6.1.5.5.7.3.2) }
    const eku = "\x30\x0a\x06\x08\x2b\x06\x01\x05\x05\x07\x03\x02";
    const leaf = policyLeaf(eku, .empty, .{ .start = 0, .end = eku.len }, .ecdsa_with_SHA256);
    try testing.expectError(
        error.CertificateExtendedKeyUsageRejected,
        verifyServerAuthPolicy(leaf),
    );
}

// RFC 8446 §4.2.3 — only the TLS 1.3 signature algorithms are acceptable for a
// server certificate; a legacy SHA-1/RSA cert must be rejected by policy.
test "verifyServerAuthPolicy: unsupported signature algorithm is rejected" {
    const leaf = policyLeaf("", .empty, .empty, .sha1WithRSAEncryption);
    try testing.expectError(
        error.CertificateSignatureAlgorithmRejected,
        verifyServerAuthPolicy(leaf),
    );
}

// RFC 8446 §4.4.2.2 — a leaf with no KeyUsage/EKU restrictions and a supported
// signature algorithm satisfies the residual server-auth policy.
test "verifyServerAuthPolicy: unrestricted supported leaf is accepted" {
    const leaf = policyLeaf("", .empty, .empty, .ecdsa_with_SHA256);
    try verifyServerAuthPolicy(leaf);
}

test "encodeCertificateVerify: wraps signature" {
    var buf: [512]u8 = undefined;
    const msg = try encodeCertificateVerify(&buf, .ecdsa_secp256r1_sha256, fixture_cv_sig);
    try testing.expectEqual(@as(u8, 0x0f), msg[0]);
    try testing.expectEqual(certificateVerifyEncodedLen(fixture_cv_sig), msg.len);
    try testing.expectEqualSlices(u8, fixture_cv_sig, msg[8..]);
}

test "verifySignature: valid ECDSA P-256 signature" {
    var cert_buf: [1024]u8 = undefined;
    const pub_key = try parse(buildCertMsg(&cert_buf, fixture_cert_der), .{});
    var cv_buf: [512]u8 = undefined;
    try verifyServerSignature(buildCvMsg(&cv_buf, fixture_cv_sig), pub_key, &test_transcript_hash);
}

test "verifySignature: wrong transcript hash" {
    var cert_buf: [1024]u8 = undefined;
    const pub_key = try parse(buildCertMsg(&cert_buf, fixture_cert_der), .{});
    var cv_buf: [512]u8 = undefined;
    const bad_hash: [32]u8 = @splat(0);
    try testing.expectError(
        error.SignatureVerificationFailed,
        verifyServerSignature(buildCvMsg(&cv_buf, fixture_cv_sig), pub_key, &bad_hash),
    );
}

// RFC 8446 §4.4.3 — CertificateVerify context string binds the endpoint role.
test "verifySignature: server signature is not valid for client context" {
    var cert_buf: [1024]u8 = undefined;
    const pub_key = try parse(buildCertMsg(&cert_buf, fixture_cert_der), .{});
    var cv_buf: [512]u8 = undefined;
    try testing.expectError(
        error.SignatureVerificationFailed,
        verifyClientSignature(buildCvMsg(&cv_buf, fixture_cv_sig), pub_key, &test_transcript_hash),
    );
}

test "verifySignature: wrong handshake type" {
    var cert_buf: [1024]u8 = undefined;
    const pub_key = try parse(buildCertMsg(&cert_buf, fixture_cert_der), .{});
    var cv_buf: [512]u8 = undefined;
    _ = buildCvMsg(&cv_buf, fixture_cv_sig);
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
    const pub_key = try parse(buildCertMsg(&buf, name_constraints_der), .{});
    try testing.expect(pub_key.len > 0);

    // Verify the extension was extracted by parsing the leaf directly.
    const cert: Certificate = .{ .buffer = name_constraints_der, .index = 0 };
    const parsed = try cert.parse();
    const nc = parsed.nameConstraints();
    try testing.expect(nc.len > 0);
    // First byte should be SEQUENCE (0x30) for NameConstraints.
    try testing.expectEqual(@as(u8, 0x30), nc[0]);
}

// RFC 5280 §4.2.1.10 — non-critical Name Constraints are also parsed.
test "parse: extracts non-critical name constraints" {
    var buf: [1024]u8 = undefined;
    const pub_key = try parse(buildCertMsg(&buf, name_constraints_noncritical_der), .{});
    try testing.expect(pub_key.len > 0);

    const cert: Certificate = .{ .buffer = name_constraints_noncritical_der, .index = 0 };
    const parsed = try cert.parse();
    const nc = parsed.nameConstraints();
    try testing.expect(nc.len > 0);
    try testing.expectEqual(@as(u8, 0x30), nc[0]);
}

// Fuzz target: parse must reject arbitrary Certificate bytes with an error,
// never crash. Exercises our framing plus cryptox.Certificate's X.509 parser.
// Run with `zig build test --fuzz`.
fn fuzzParse(_: void, input: []const u8) anyerror!void {
    _ = parse(input, .{}) catch return;
}

test "fuzz: parse handles arbitrary input" {
    var buf: [1024]u8 = undefined;
    try testing.fuzz({}, fuzzParse, .{ .corpus = &.{buildCertMsg(&buf, fixture_cert_der)} });
}
