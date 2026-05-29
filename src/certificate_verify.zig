/// TLS 1.3 CertificateVerify handshake message parsing and verification.
///
/// RFC 8446 §4.4.3
const std = @import("std");
const crypto = std.crypto;
const Certificate = std.crypto.Certificate;
const testing = std.testing;


const wire = @import("wire.zig");

/// The context string prepended to the transcript hash when signing.
/// RFC 8446 §4.4.3
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

/// Parse and verify a CertificateVerify handshake message.
///
/// `transcript_hash` is the hash of all handshake messages up to and
/// including the Certificate message, before this message is fed in.
///
/// RFC 8446 §4.4.3
/// `pub_key` is a slice into the caller's Certificate message buffer.
/// It must remain valid for the duration of this call.
pub fn verify(
    msg: []const u8,
    pub_key: []const u8,
    transcript_hash: []const u8,
) VerifyError!void {
    var r: wire.Reader = .init(msg);

    const handshake_type = try r.read(u8);
    if (handshake_type != 0x0f) return error.InvalidHandshakeType;
    try r.skip(3); // body length

    const scheme = try r.read(std.crypto.tls.SignatureScheme);
    const sig_len = try r.read(u16);
    const sig = try r.readSlice(sig_len);

    const key = pub_key;

    switch (scheme) {
        inline .ecdsa_secp256r1_sha256,
        .ecdsa_secp384r1_sha384,
        => |comptime_scheme| {
            const Ecdsa = switch (comptime_scheme) {
                .ecdsa_secp256r1_sha256 => crypto.sign.ecdsa.EcdsaP256Sha256,
                .ecdsa_secp384r1_sha384 => crypto.sign.ecdsa.EcdsaP384Sha384,
                else => unreachable,
            };
            const signature = try Ecdsa.Signature.fromDer(sig);
            const public_key = try Ecdsa.PublicKey.fromSec1(key);
            var verifier = try signature.verifier(public_key);
            verifier.update(server_context);
            verifier.update(transcript_hash);
            try verifier.verify();
        },
        inline .rsa_pss_rsae_sha256,
        .rsa_pss_rsae_sha384,
        .rsa_pss_rsae_sha512,
        => |comptime_scheme| {
            const Hash = switch (comptime_scheme) {
                .rsa_pss_rsae_sha256 => crypto.hash.sha2.Sha256,
                .rsa_pss_rsae_sha384 => crypto.hash.sha2.Sha384,
                .rsa_pss_rsae_sha512 => crypto.hash.sha2.Sha512,
                else => unreachable,
            };
            const components = try Certificate.rsa.PublicKey.parseDer(key);
            const public_key = try Certificate.rsa.PublicKey.fromBytes(components.exponent, components.modulus);
            switch (components.modulus.len) {
                inline 128, 256, 384, 512 => |modulus_len| {
                    const rsa_sig = Certificate.rsa.PSSSignature.fromBytes(modulus_len, sig);
                    try Certificate.rsa.PSSSignature.concatVerify(modulus_len, rsa_sig, &.{ server_context, transcript_hash }, public_key, Hash);
                },
                else => return error.TlsBadRsaSignatureBitCount,
            }
        },
        else => return error.UnsupportedSignatureScheme,
    }
}
