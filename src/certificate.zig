/// TLS 1.3 Certificate and CertificateVerify handshake message handling.
///
/// RFC 8446 §4.4.2, §4.4.3
const std = @import("std");
const crypto = std.crypto;
const Certificate = @import("cryptox/Certificate.zig");
const ecdsa = crypto.sign.ecdsa;
const sha2 = crypto.hash.sha2;
const testing = std.testing;

const wire = @import("wire.zig");

pub const ParseError = error{
    UnexpectedEof,
    InvalidHandshakeType,
    EmptyCertificateList,
    CertificateIssuerNotFound,
} || Certificate.ParseError || Certificate.Parsed.VerifyError || Certificate.Parsed.VerifyHostNameError;

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
            if (policy.host_name) |host_name| try parsed.verifyHostName(host_name);
        }
        if (subject_to_verify) |subject| try subject.verify(parsed, policy.now_sec);
        subject_to_verify = parsed;
        cert_index += 1;
    }

    if (policy.bundle) |bundle| {
        try verifyAgainstBundle(bundle, subject_to_verify orelse return error.EmptyCertificateList, policy.now_sec);
    }

    return leaf_pub_key orelse error.EmptyCertificateList;
}

fn verifyAgainstBundle(bundle: *const Certificate.Bundle, subject: Certificate.Parsed, now_sec: i64) ParseError!void {
    const issuer_index = bundle.find(subject.issuer()) orelse return error.CertificateIssuerNotFound;
    const issuer_cert: Certificate = .{ .buffer = bundle.bytes.items, .index = issuer_index };
    try subject.verify(try issuer_cert.parse(), now_sec);
}

pub const AuthError = ParseError || VerifyError;

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
    scheme: crypto.tls.SignatureScheme,
    signature: []const u8,
) CertificateVerifyEncodeError![]const u8 {
    const len = certificateVerifyEncodedLen(signature);
    if (out.len < len) return error.BufferTooShort;
    var w: wire.Writer = .init(out);
    w.append(u8, 0x0f);
    w.append(u24, @intCast(len - 4));
    w.append(crypto.tls.SignatureScheme, scheme);
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
    IdentityElement,
    NonCanonical,
    NotSquare,
    SignatureVerificationFailed,
    CertificateSignatureInvalid,
    TlsBadRsaSignatureBitCount,
} ||
    Certificate.rsa.PublicKey.ParseDerError ||
    Certificate.rsa.PublicKey.FromBytesError ||
    Certificate.rsa.PSSSignature.VerifyError ||
    Certificate.rsa.PKCS1v1_5Signature.VerifyError;

/// Verify a CertificateVerify handshake message.
///
/// `pub_key` is a slice into the caller's Certificate message buffer.
/// `transcript_hash` covers all messages up to and including Certificate.
///
/// RFC 8446 §4.4.3
pub fn verifySignature(
    msg: []const u8,
    pub_key: []const u8,
    transcript_hash: []const u8,
) VerifyError!void {
    var r: wire.Reader = .init(msg);

    const handshake_type = try r.read(u8);
    if (handshake_type != 0x0f) return error.InvalidHandshakeType;
    try r.skip(3);

    const scheme = try r.read(crypto.tls.SignatureScheme);
    const sig_len = try r.read(u16);
    const sig = try r.readSlice(sig_len);

    switch (scheme) {
        inline .ecdsa_secp256r1_sha256,
        .ecdsa_secp384r1_sha384,
        => |tag| {
            const Ecdsa = switch (tag) {
                .ecdsa_secp256r1_sha256 => ecdsa.EcdsaP256Sha256,
                .ecdsa_secp384r1_sha384 => ecdsa.EcdsaP384Sha384,
                else => unreachable,
            };
            const signature: Ecdsa.Signature = try .fromDer(sig);
            const public_key: Ecdsa.PublicKey = try .fromSec1(pub_key);
            var verifier = try signature.verifier(public_key);
            verifier.update(server_context);
            verifier.update(transcript_hash);
            try verifier.verify();
        },
        inline .rsa_pss_rsae_sha256,
        .rsa_pss_rsae_sha384,
        .rsa_pss_rsae_sha512,
        => |tag| {
            const Hash = switch (tag) {
                .rsa_pss_rsae_sha256 => sha2.Sha256,
                .rsa_pss_rsae_sha384 => sha2.Sha384,
                .rsa_pss_rsae_sha512 => sha2.Sha512,
                else => unreachable,
            };
            const PublicKey = Certificate.rsa.PublicKey;
            const PSSSignature = Certificate.rsa.PSSSignature;
            const components = try PublicKey.parseDer(pub_key);
            const public_key: PublicKey = try .fromBytes(components.exponent, components.modulus);
            switch (components.modulus.len) {
                inline 128, 256, 384, 512 => |modulus_len| {
                    const rsa_sig = PSSSignature.fromBytes(modulus_len, sig);
                    try PSSSignature.concatVerify(modulus_len, rsa_sig, &.{ server_context, transcript_hash }, public_key, Hash);
                },
                else => return error.TlsBadRsaSignatureBitCount,
            }
        },
        else => return error.UnsupportedSignatureScheme,
    }
}

// Fixtures generated with: just gen-fixtures
// Transcript hash: SHA-256("test transcript")

const fixture_cert_der = @embedFile("test_fixtures/server.crt.der");
const fixture_cv_sig = @embedFile("test_fixtures/cv.sig");
const chain_root_pem = "tests/fixtures/chain/root.crt";
const chain_leaf_der = @embedFile("test_fixtures/chain/leaf.der");
const chain_intermediate_der = @embedFile("test_fixtures/chain/intermediate.der");

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
    sha2.Sha256.hash("test transcript", &out, .{});
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
    try testing.expectError(error.CertificateHostMismatch, parse(buildCertMsg(&buf, fixture_cert_der), .{ .host_name = "wrong.local" }));
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
    const pub_key = try parse(buildCertChainMsg(&buf, &.{ chain_leaf_der, chain_intermediate_der }), .{
        .bundle = &bundle,
        .now_sec = 1_780_300_000,
        .host_name = "chain.test",
    });
    try testing.expect(pub_key.len > 0);
}

test "parse: rejects chain with missing intermediate" {
    var bundle: Certificate.Bundle = .{};
    defer bundle.deinit(testing.allocator);
    try bundle.addCertsFromFilePath(testing.allocator, std.fs.cwd(), chain_root_pem);

    var buf: [4096]u8 = undefined;
    try testing.expectError(error.CertificateIssuerNotFound, parse(buildCertChainMsg(&buf, &.{chain_leaf_der}), .{
        .bundle = &bundle,
        .now_sec = 1_780_300_000,
        .host_name = "chain.test",
    }));
}

test "parse: rejects chain hostname mismatch" {
    var bundle: Certificate.Bundle = .{};
    defer bundle.deinit(testing.allocator);
    try bundle.addCertsFromFilePath(testing.allocator, std.fs.cwd(), chain_root_pem);

    var buf: [4096]u8 = undefined;
    try testing.expectError(error.CertificateHostMismatch, parse(buildCertChainMsg(&buf, &.{ chain_leaf_der, chain_intermediate_der }), .{
        .bundle = &bundle,
        .now_sec = 1_780_300_000,
        .host_name = "wrong.chain.test",
    }));
}

test "parse: rejects untrusted leaf when bundle misses issuer" {
    const bundle: Certificate.Bundle = .{};
    var buf: [1024]u8 = undefined;
    try testing.expectError(error.CertificateIssuerNotFound, parse(buildCertMsg(&buf, fixture_cert_der), .{
        .bundle = &bundle,
        .now_sec = 1_780_300_000,
    }));
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
    try verifySignature(buildCvMsg(&cv_buf, fixture_cv_sig), pub_key, &test_transcript_hash);
}

test "verifySignature: wrong transcript hash" {
    var cert_buf: [1024]u8 = undefined;
    const pub_key = try parse(buildCertMsg(&cert_buf, fixture_cert_der), .{});
    var cv_buf: [512]u8 = undefined;
    const bad_hash: [32]u8 = @splat(0);
    try testing.expectError(error.SignatureVerificationFailed, verifySignature(buildCvMsg(&cv_buf, fixture_cv_sig), pub_key, &bad_hash));
}

test "verifySignature: wrong handshake type" {
    var cert_buf: [1024]u8 = undefined;
    const pub_key = try parse(buildCertMsg(&cert_buf, fixture_cert_der), .{});
    var cv_buf: [512]u8 = undefined;
    _ = buildCvMsg(&cv_buf, fixture_cv_sig);
    cv_buf[0] = 0x01;
    try testing.expectError(error.InvalidHandshakeType, verifySignature(&cv_buf, pub_key, &test_transcript_hash));
}

// Fuzz target: parse must reject arbitrary Certificate bytes with an error,
// never crash. Exercises our framing plus cryptox.Certificate's X.509 parser.
// Run with `zig build test --fuzz`.
fn fuzzParse(_: void, input: []const u8) anyerror!void {
    _ = parse(input, .{}) catch {};
}

test "fuzz: parse handles arbitrary input" {
    var buf: [1024]u8 = undefined;
    try testing.fuzz({}, fuzzParse, .{ .corpus = &.{buildCertMsg(&buf, fixture_cert_der)} });
}
