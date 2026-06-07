/// TLS 1.3 CertificateRequest handshake message encode and parse.
///
/// RFC 8446 §4.3.2
const std = @import("std");
const testing = std.testing;
const wire = @import("wire.zig");
const SignatureScheme = @import("certificate.zig").SignatureScheme;

pub const EncodeError = error{BufferTooShort};

pub const ParseError = error{
    UnexpectedEof,
    InvalidHandshakeType,
    MissingSignatureAlgorithmsExtension,
};

/// Wire result of `parse`. All slice fields point into the original `msg`.
pub const Parsed = struct {
    /// Must be echoed verbatim in the client Certificate request_context field.
    /// RFC 8446 §4.4.2 — "If this message is in response to a
    /// CertificateRequest, the value of this field SHALL be the same as the
    /// request_context value in that CertificateRequest."
    request_context: []const u8,
    /// Raw bytes of the supported_signature_algs list (each entry is a
    /// big-endian u16 SignatureScheme). Use `schemeIterator` to walk them.
    /// At least 2 bytes are guaranteed (parse returns
    /// MissingSignatureAlgorithmsExtension otherwise). RFC 8446 §4.2.3.
    signature_schemes_raw: []const u8,
    /// Raw distinguished-name list from the certificate_authorities extension,
    /// or empty if the extension was absent. RFC 8446 §4.2.4.
    certificate_authorities_raw: []const u8,

    /// Iterate over the signature schemes encoded in `signature_schemes_raw`.
    pub fn schemeIterator(self: *const Parsed) SchemeIterator {
        return .{ .r = .init(self.signature_schemes_raw) };
    }
};

/// Iterator over the big-endian u16 signature schemes in a raw byte slice.
pub const SchemeIterator = struct {
    r: wire.Reader,

    pub fn next(self: *SchemeIterator) ?SignatureScheme {
        const raw = self.r.read(u16) catch return null;
        return @enumFromInt(raw);
    }
};

/// Compute the encoded byte length for `encode`.
pub fn encodedLen(sig_algs: []const SignatureScheme) usize {
    // 4  handshake header (type + 3-byte length)
    // 1  request_context length prefix (always 0 for handshake-time auth)
    // 2  extensions total length
    //   2 + 2 + 2 + sig_algs.len*2  signature_algorithms extension
    const sig_algs_ext_len: usize = 2 + 2 + 2 + sig_algs.len * 2;
    return 4 + 1 + 2 + sig_algs_ext_len;
}

/// Encode a CertificateRequest with an empty request_context and a
/// signature_algorithms extension listing `sig_algs`. Writes into `out` and
/// returns the used portion.
///
/// RFC 8446 §4.3.2
pub fn encode(out: []u8, sig_algs: []const SignatureScheme) EncodeError![]const u8 {
    const len = encodedLen(sig_algs);
    if (out.len < len) return error.BufferTooShort;

    var w: wire.Writer = .init(out);

    // Handshake header — type 0x0d, 3-byte body length.
    w.append(u8, 0x0d);
    w.append(u24, @intCast(len - 4));

    // request_context: empty for handshake-time auth (RFC 8446 §4.3.2).
    w.append(u8, 0x00);

    // Extensions total length: one extension follows.
    const sig_algs_ext_len: usize = 2 + 2 + 2 + sig_algs.len * 2;
    w.append(u16, @intCast(sig_algs_ext_len));

    // signature_algorithms extension (type 0x000d, RFC 8446 §4.2.3).
    w.append(u16, 0x000d);
    w.append(u16, @intCast(2 + sig_algs.len * 2)); // extension data length
    w.append(u16, @intCast(sig_algs.len * 2)); // supported_signature_algs length
    for (sig_algs) |s| w.append(SignatureScheme, s);

    return w.written();
}

/// Parse a CertificateRequest handshake message. All returned slices alias
/// `msg`; the caller must keep `msg` alive for the duration of the parsed
/// result's use.
///
/// RFC 8446 §4.3.2
pub fn parse(msg: []const u8) ParseError!Parsed {
    var r: wire.Reader = .init(msg);

    const handshake_type = try r.read(u8);
    if (handshake_type != 0x0d) return error.InvalidHandshakeType;
    try r.skip(3); // body length — trust the outer record layer

    const ctx_len = try r.read(u8);
    const request_context = try r.readSlice(ctx_len);

    const exts_total_len = try r.read(u16);
    const exts_end = r.pos + exts_total_len;

    var sig_schemes: ?[]const SignatureScheme = null;
    var ca_raw: []const u8 = &.{};

    while (r.pos < exts_end) {
        const ext_type = try r.read(u16);
        const ext_len = try r.read(u16);
        const ext_data = try r.readSlice(ext_len);

        switch (ext_type) {
            // signature_algorithms (RFC 8446 §4.2.3)
            0x000d => {
                var er: wire.Reader = .init(ext_data);
                const list_len = try er.read(u16);
                // Return raw big-endian bytes; callers use schemeIterator() to
                // walk them as typed SignatureScheme values without a byte-swap
                // hazard.
                sig_schemes = try er.readSlice(list_len);
            },
            // certificate_authorities (RFC 8446 §4.2.4)
            0x002f => {
                ca_raw = ext_data;
            },
            // Unknown extension — skip (RFC 8446 §4.2: ignore unknown extensions).
            else => {},
        }
    }

    return .{
        .request_context = request_context,
        .signature_schemes_raw = sig_schemes orelse return error.MissingSignatureAlgorithmsExtension,
        .certificate_authorities_raw = ca_raw,
    };
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

// RFC 8446 §4.3.2 — CertificateRequest structure: handshake_type 0x0d,
// request_context, and extensions (signature_algorithms is mandatory).
test "encode round-trips via parse" {
    const schemes = [_]SignatureScheme{
        .ecdsa_secp256r1_sha256,
        .rsa_pss_rsae_sha256,
    };
    var buf: [256]u8 = undefined;
    const encoded = try encode(&buf, &schemes);

    // Handshake type byte must be 0x0d.
    try testing.expectEqual(@as(u8, 0x0d), encoded[0]);

    const parsed = try parse(encoded);

    // RFC 8446 §4.3.2 — request_context is empty for handshake-time auth.
    try testing.expectEqualSlices(u8, &.{}, parsed.request_context);

    // Both schemes must survive the round-trip via the iterator.
    var it = parsed.schemeIterator();
    try testing.expectEqual(schemes[0], it.next().?);
    try testing.expectEqual(schemes[1], it.next().?);
    try testing.expectEqual(@as(?SignatureScheme, null), it.next());

    // RFC 8446 §4.2.4 — certificate_authorities absent → empty raw slice.
    try testing.expectEqual(@as(usize, 0), parsed.certificate_authorities_raw.len);
}

// RFC 8446 §4.3.2 — wrong handshake type must be rejected.
test "parse rejects wrong handshake type" {
    const schemes = [_]SignatureScheme{.ecdsa_secp256r1_sha256};
    var buf: [256]u8 = undefined;
    const encoded = try encode(&buf, &schemes);

    var bad: [256]u8 = undefined;
    @memcpy(bad[0..encoded.len], encoded);
    bad[0] = 0x0b; // Certificate, not CertificateRequest

    try testing.expectError(error.InvalidHandshakeType, parse(bad[0..encoded.len]));
}

// RFC 8446 §4.3.2 — signature_algorithms extension is mandatory; a message
// without it must be rejected.
test "parse rejects missing signature_algorithms" {
    // Hand-craft a CertificateRequest with no extensions.
    // Structure: 0x0d | length(3) | ctx_len(1) | exts_total_len(2)
    const msg = [_]u8{
        0x0d, 0x00, 0x00, 0x03, // handshake header, body = 3 bytes
        0x00, // request_context length = 0
        0x00, 0x00, // extensions total length = 0
    };
    try testing.expectError(error.MissingSignatureAlgorithmsExtension, parse(&msg));
}

// RFC 8446 §4.3.2 — encodedLen must match actual encoded length.
test "encodedLen is accurate" {
    const schemes = [_]SignatureScheme{.ecdsa_secp256r1_sha256};
    var buf: [256]u8 = undefined;
    const encoded = try encode(&buf, &schemes);
    try testing.expectEqual(encodedLen(&schemes), encoded.len);
}
