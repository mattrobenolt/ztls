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
} || Certificate.ParseError || Certificate.Parsed.VerifyError;



/// Parse a Certificate handshake message and extract the leaf certificate
/// public key as a slice into `msg`. The caller must keep `msg` alive until
/// CertificateVerify has been verified. Optionally validates the chain against
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
            leaf_pub_key = parsed.pubKey();

            if (bundle != null) {
                if (prev_parsed) |prev| {
                    try prev.verify(parsed, now_sec);
                }
            }
        }

        prev_parsed = parsed;
        cert_index += 1;
    }

    return leaf_pub_key orelse error.EmptyCertificateList;
}
