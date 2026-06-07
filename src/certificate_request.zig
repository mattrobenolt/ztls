/// TLS 1.3 CertificateRequest handshake message handling.
///
/// RFC 8446 §4.3.2
const std = @import("std");
const testing = std.testing;

const SignatureScheme = @import("signature_scheme.zig").SignatureScheme;
const wire = @import("wire.zig");

pub const EncodeError = error{BufferTooShort};

pub const ParseError = error{
    UnexpectedEof,
    InvalidHandshakeType,
    InvalidHandshakeLength,
    InvalidExtensionLength,
    DuplicateExtension,
    MissingSignatureAlgorithmsExtension,
};

pub const Parsed = struct {
    /// Echoed verbatim in the client Certificate request_context field.
    request_context: []const u8,
    /// Big-endian u16 SignatureScheme values from signature_algorithms.
    signature_schemes_raw: []const u8,
    /// Raw DistinguishedName vector from certificate_authorities, if present.
    certificate_authorities_raw: []const u8,

    pub fn schemeIterator(self: Parsed) SchemeIterator {
        return .{ .r = .init(self.signature_schemes_raw) };
    }
};

pub const SchemeIterator = struct {
    r: wire.Reader,

    pub fn next(self: *SchemeIterator) ParseError!?SignatureScheme {
        if (self.r.remaining().len == 0) return null;
        if (self.r.remaining().len < 2) return error.UnexpectedEof;
        return @enumFromInt(self.r.assumeRead(u16));
    }
};

pub fn encodedLen(sig_algs: []const SignatureScheme) usize {
    const sig_algs_ext_len = 2 + 2 + 2 + sig_algs.len * 2;
    return 4 + 1 + 2 + sig_algs_ext_len;
}

/// Encode a handshake-time CertificateRequest with empty request_context and a
/// signature_algorithms extension. RFC 8446 §4.3.2.
pub fn encode(out: []u8, sig_algs: []const SignatureScheme) EncodeError![]const u8 {
    const len = encodedLen(sig_algs);
    if (out.len < len) return error.BufferTooShort;

    var w: wire.Writer = .init(out);
    w.append(u8, 0x0d);
    w.append(u24, @intCast(len - 4));
    w.append(u8, 0x00); // empty request_context

    const sig_algs_ext_len = 2 + 2 + 2 + sig_algs.len * 2;
    w.append(u16, @intCast(sig_algs_ext_len));
    w.append(u16, 0x000d); // signature_algorithms
    w.append(u16, @intCast(2 + sig_algs.len * 2));
    w.append(u16, @intCast(sig_algs.len * 2));
    for (sig_algs) |scheme| w.append(SignatureScheme, scheme);
    return w.written();
}

/// Parse a complete CertificateRequest handshake message. Returned slices alias
/// `msg`. RFC 8446 §4.3.2.
pub fn parse(msg: []const u8) ParseError!Parsed {
    if (msg.len < 4 + 1 + 2) return error.UnexpectedEof;
    var r: wire.Reader = .init(msg);
    const handshake_type = r.assumeRead(u8);
    if (handshake_type != 0x0d) return error.InvalidHandshakeType;
    const body_len = r.assumeRead(u24);
    if (body_len != msg.len - 4) return error.InvalidHandshakeLength;

    const ctx_len = r.assumeRead(u8);
    if (r.remaining().len < ctx_len + 2) return error.UnexpectedEof;
    const request_context = r.assumeReadSlice(ctx_len);
    const exts_total_len = r.assumeRead(u16);
    if (exts_total_len != r.remaining().len) return error.InvalidExtensionLength;

    var extensions: wire.Reader = .init(r.assumeReadSlice(exts_total_len));
    var signature_schemes_raw: ?[]const u8 = null;
    var certificate_authorities_raw: []const u8 = &.{};

    while (extensions.remaining().len != 0) {
        if (extensions.remaining().len < 4) return error.InvalidExtensionLength;
        const ext_type = extensions.assumeRead(u16);
        const ext_len = extensions.assumeRead(u16);
        if (ext_len > extensions.remaining().len) return error.InvalidExtensionLength;
        const ext_data = extensions.assumeReadSlice(ext_len);

        switch (ext_type) {
            0x000d => {
                if (signature_schemes_raw != null) return error.DuplicateExtension;
                var er: wire.Reader = .init(ext_data);
                if (er.remaining().len < 2) return error.InvalidExtensionLength;
                const list_len = er.assumeRead(u16);
                if (list_len == 0 or list_len % 2 != 0) return error.InvalidExtensionLength;
                if (er.remaining().len < list_len) return error.InvalidExtensionLength;
                signature_schemes_raw = er.assumeReadSlice(list_len);
                if (er.remaining().len != 0) return error.InvalidExtensionLength;
            },
            0x002f => {
                if (certificate_authorities_raw.len != 0) return error.DuplicateExtension;
                certificate_authorities_raw = ext_data;
            },
            else => {},
        }
    }

    return .{
        .request_context = request_context,
        .signature_schemes_raw = signature_schemes_raw orelse
            return error.MissingSignatureAlgorithmsExtension,
        .certificate_authorities_raw = certificate_authorities_raw,
    };
}

// RFC 8446 §4.3.2 — CertificateRequest carries request_context and extensions;
// signature_algorithms is mandatory for TLS 1.3 certificate authentication.
test "encode round-trips via parse" {
    const schemes = [_]SignatureScheme{ .ecdsa_secp256r1_sha256, .rsa_pss_rsae_sha256 };
    var buf: [256]u8 = undefined;
    const encoded = try encode(&buf, &schemes);
    const parsed = try parse(encoded);

    try testing.expectEqualSlices(u8, &.{}, parsed.request_context);
    var it = parsed.schemeIterator();
    try testing.expectEqual(SignatureScheme.ecdsa_secp256r1_sha256, (try it.next()).?);
    try testing.expectEqual(SignatureScheme.rsa_pss_rsae_sha256, (try it.next()).?);
    try testing.expectEqual(@as(?SignatureScheme, null), try it.next());
    try testing.expectEqual(@as(usize, 0), parsed.certificate_authorities_raw.len);
}

// RFC 8446 §4.3.2 — a CertificateRequest has handshake type 0x0d.
test "parse rejects wrong handshake type" {
    const schemes = [_]SignatureScheme{.ecdsa_secp256r1_sha256};
    var buf: [256]u8 = undefined;
    const encoded = try encode(&buf, &schemes);
    var bad = buf;
    bad[0] = 0x0b;
    try testing.expectError(error.InvalidHandshakeType, parse(bad[0..encoded.len]));
}

// RFC 8446 §4.3.2 — signature_algorithms is mandatory for certificate auth.
test "parse rejects missing signature_algorithms" {
    const msg = [_]u8{ 0x0d, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00 };
    try testing.expectError(error.MissingSignatureAlgorithmsExtension, parse(&msg));
}

// RFC 8446 §4.2 — endpoints MUST NOT send duplicate extensions.
test "parse rejects duplicate signature_algorithms" {
    const msg = [_]u8{
        0x0d, 0x00, 0x00, 0x13,
        0x00, 0x00, 0x10, 0x00,
        0x0d, 0x00, 0x04, 0x00,
        0x02, 0x04, 0x03, 0x00,
        0x0d, 0x00, 0x04, 0x00,
        0x02, 0x04, 0x03,
    };
    try testing.expectError(error.DuplicateExtension, parse(&msg));
}

// RFC 8446 §4.3.2 — encodedLen matches the actual output length.
test "encodedLen is accurate" {
    const schemes = [_]SignatureScheme{ .ecdsa_secp256r1_sha256, .rsa_pss_rsae_sha256 };
    var buf: [256]u8 = undefined;
    const encoded = try encode(&buf, &schemes);
    try testing.expectEqual(encodedLen(&schemes), encoded.len);
}
