/// TLS 1.3 Certificate and CertificateVerify handshake message handling.
///
/// RFC 8446 §4.4.2, §4.4.3
const std = @import("std");
const crypto = std.crypto;
const Certificate = std.crypto.Certificate;
const ecdsa = crypto.sign.ecdsa;
const sha2 = crypto.hash.sha2;
const testing = std.testing;

const wire = @import("wire.zig");

pub const ParseError = error{
    UnexpectedEof,
    InvalidHandshakeType,
    EmptyCertificateList,
} || Certificate.ParseError || Certificate.Parsed.VerifyError;

/// Parse a Certificate handshake message and extract the leaf certificate
/// public key as a slice into `msg`. The caller must keep `msg` alive until
/// verifySignature has been called. Optionally validates the chain against
/// a trust bundle.
///
/// RFC 8446 §4.4.2
pub fn parse(
    msg: []const u8,
    bundle: ?*const Certificate.Bundle,
    now_sec: i64,
) ParseError![]const u8 {
    var r: wire.Reader = .init(msg);

    const handshake_type = try r.read(u8);
    if (handshake_type != 0x0b) return error.InvalidHandshakeType;
    try r.skip(3); // body length

    // certificate_request_context: empty for server auth
    const ctx_len = try r.read(u8);
    try r.skip(ctx_len);

    // certificate_list length (uint24)
    const list_len = try r.read(u24);
    if (list_len == 0) return error.EmptyCertificateList;

    const list_end = r.pos + list_len;
    var cert_index: usize = 0;
    var leaf_pub_key: ?[]const u8 = null;
    var prev_parsed: ?Certificate.Parsed = null;

    while (r.pos < list_end) {
        const cert_len = try r.read(u24);
        const cert_der = try r.readSlice(cert_len);
        const ext_len = try r.read(u16);
        try r.skip(ext_len);

        const cert: Certificate = .{ .buffer = cert_der, .index = 0 };
        const parsed = try cert.parse();

        if (cert_index == 0) {
            leaf_pub_key = parsed.pubKey();
            if (bundle != null) {
                if (prev_parsed) |prev| try prev.verify(parsed, now_sec);
            }
        }

        prev_parsed = parsed;
        cert_index += 1;
    }

    return leaf_pub_key orelse error.EmptyCertificateList;
}

/// The context string prepended to the transcript hash. RFC 8446 §4.4.3
const server_context = " " ** 64 ++ "TLS 1.3, server CertificateVerify\x00";

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
    try r.skip(3); // body length

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
