/// TLS 1.3 Certificate handshake message parsing.
///
/// RFC 8446 §4.4.2
const std = @import("std");
const Certificate = std.crypto.Certificate;
const testing = std.testing;

const wire = @import("wire.zig");

pub const ParseError = error{
    UnexpectedEof,
    InvalidHandshakeType,
    EmptyCertificateList,
    CertificatePublicKeyInvalid,
} || Certificate.ParseError || Certificate.Parsed.VerifyError;

/// The server's public key extracted from the leaf certificate.
/// Held for CertificateVerify validation.
pub const CertificatePublicKey = struct {
    algo: Certificate.AlgorithmCategory,
    /// Sized to hold the largest practical public key: RSA-4096 (~512 bytes
    /// modulus + ASN.1 overhead). ECDSA keys are much smaller (65-97 bytes).
    buf: [600]u8,
    len: u32,

    pub fn init(algo: Certificate.Parsed.PubKeyAlgo, pub_key: []const u8) error{CertificatePublicKeyInvalid}!CertificatePublicKey {
        var cpk: CertificatePublicKey = undefined;
        if (pub_key.len > cpk.buf.len) return error.CertificatePublicKeyInvalid;
        cpk.algo = @as(Certificate.AlgorithmCategory, algo);
        @memcpy(cpk.buf[0..pub_key.len], pub_key);
        cpk.len = @intCast(pub_key.len);
        return cpk;
    }

    pub fn slice(self: *const CertificatePublicKey) []const u8 {
        return self.buf[0..self.len];
    }
};

/// Parse a Certificate handshake message and extract the leaf certificate
/// public key. Optionally validates the chain against a trust bundle.
///
/// RFC 8446 §4.4.2
pub fn parse(
    msg: []const u8,
    bundle: ?*const Certificate.Bundle,
    now_sec: i64,
) ParseError!CertificatePublicKey {
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
    var leaf_pub_key: ?CertificatePublicKey = null;
    var prev_parsed: ?Certificate.Parsed = null;

    while (r.pos < list_end) {
        // cert_data length (uint24) + DER bytes
        const cert_len = try r.read(u24);
        const cert_der = try r.readSlice(cert_len);

        // extensions per cert entry (uint16 length + bytes, skip)
        const ext_len = try r.read(u16);
        try r.skip(ext_len);

        const cert: Certificate = .{
            .buffer = cert_der,
            .index = 0,
        };
        const parsed = try cert.parse();

        if (cert_index == 0) {
            // Leaf certificate — extract the public key.
            leaf_pub_key = try CertificatePublicKey.init(parsed.pub_key_algo, parsed.pubKey());
        }

        if (bundle) |_| {
            if (cert_index == 0 and prev_parsed != null) {
                try prev_parsed.?.verify(parsed, now_sec);
            }
        }

        prev_parsed = parsed;
        cert_index += 1;
    }

    return leaf_pub_key orelse error.EmptyCertificateList;
}
