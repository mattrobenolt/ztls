/// TLS 1.3 ServerHello handshake message parsing.
///
/// RFC 8446 §4.1.3
const std = @import("std");
const testing = std.testing;

const CipherSuite = @import("root.zig").CipherSuite;
const wire = @import("wire.zig");
const x25519 = @import("x25519.zig");
const NamedGroup = @import("kex.zig").NamedGroup;

pub const ServerHello = struct {
    /// The negotiated cipher suite. Determines which HKDF hash to use.
    cipher_suite: CipherSuite,
    /// Server's ephemeral X25519 public key from the key_share extension.
    server_public_key: x25519.PublicKey,
};

pub const ParseError = error{
    UnexpectedEof,
    /// Handshake type byte is not server_hello (0x02).
    InvalidHandshakeType,
    /// Handshake length field does not match the supplied message.
    InvalidHandshakeLength,
    /// Extension block or extension length is malformed.
    InvalidExtensionLength,
    /// A singleton extension appeared more than once.
    DuplicateExtension,
    /// A field contained an unrecognised enum value.
    InvalidEnumTag,
    /// Server selected HelloRetryRequest; ztls does not implement the retry path yet.
    HelloRetryRequest,
    /// supported_versions extension does not include TLS 1.3 (0x0304).
    UnsupportedTlsVersion,
    /// key_share extension uses a group other than x25519, or wrong key length.
    UnsupportedKeyShareGroup,
    /// A required extension (supported_versions or key_share) was absent.
    MissingExtension,
};

const hello_retry_request_random = [_]u8{
    0xcf, 0x21, 0xad, 0x74, 0xe5, 0x9a, 0x61, 0x11,
    0xbe, 0x1d, 0x8c, 0x02, 0x1e, 0x65, 0xb8, 0x91,
    0xc2, 0xa2, 0x11, 0x16, 0x7a, 0xbb, 0x8c, 0x5e,
    0x07, 0x9e, 0x09, 0xe2, 0xc8, 0xa8, 0x33, 0x9c,
};

/// A parsed HelloRetryRequest message.  RFC 8446 §4.1.4.
///
/// The HRR is wire-encoded identically to a ServerHello (type 0x02) but with
/// a fixed Random value (hello_retry_request_random).  This struct carries the
/// fields that a client needs to construct ClientHello2.
///
/// `cookie` is a slice into the caller-supplied message buffer — it is only
/// valid for the lifetime of that buffer.
pub const HelloRetryRequest = struct {
    /// The cipher suite selected by the server.  Determines the transcript hash.
    cipher_suite: CipherSuite,
    /// The named group the server wants the client to use for its key share.
    /// Null when the HRR contains no key_share extension (unusual but legal).
    selected_group: ?NamedGroup,
    /// The server cookie, if present.  RFC 8446 §4.2.2.  The client MUST echo
    /// this verbatim in the cookie extension of ClientHello2.
    cookie: ?[]const u8,
};

pub const HrrParseError = error{
    UnexpectedEof,
    /// Handshake type byte is not server_hello (0x02).
    InvalidHandshakeType,
    /// Handshake length field does not match the supplied message.
    InvalidHandshakeLength,
    /// The Random field does not match the HelloRetryRequest magic value.
    NotHelloRetryRequest,
    /// Extension block or extension length is malformed.
    InvalidExtensionLength,
    /// A singleton extension appeared more than once.
    DuplicateExtension,
    /// A field contained an unrecognised enum value.
    InvalidEnumTag,
    /// supported_versions extension does not contain TLS 1.3 (0x0304).
    UnsupportedTlsVersion,
    /// A required extension was absent or malformed.
    MissingExtension,
};

/// Parse a HelloRetryRequest handshake message.
///
/// `msg` must be the complete handshake message including the 4-byte header
/// (type + 3-byte length).  It is the same wire format as ServerHello — type
/// 0x02, with hello_retry_request_random in the Random field.
///
/// The caller must feed `msg` into the transcript hash *after* calling this
/// function and applying the transcript collapse (see transcript.messageHashSynthetic).
///
/// RFC 8446 §4.1.4, §4.2.2, §4.2.8.
pub fn parseHelloRetryRequest(msg: []const u8) HrrParseError!HelloRetryRequest {
    var r: wire.Reader = .init(msg);

    const handshake_type = try r.read(u8);
    if (handshake_type != 0x02) return error.InvalidHandshakeType;
    const body_len = try r.read(u24);
    if (body_len != msg.len - 4) return error.InvalidHandshakeLength;

    try r.skip(2); // legacy_version
    const random = try r.readSlice(32);
    if (!std.mem.eql(u8, random, &hello_retry_request_random)) return error.NotHelloRetryRequest;

    const session_id_len = try r.read(u8);
    try r.skip(session_id_len); // legacy_session_id_echo

    const cipher_suite = try r.read(CipherSuite);
    try r.skip(1); // legacy_compression_method

    const extensions_len = try r.read(u16);
    if (extensions_len > msg.len - r.pos) return error.InvalidExtensionLength;
    const extensions_end = r.pos + extensions_len;

    var selected_group: ?NamedGroup = null;
    var cookie: ?[]const u8 = null;
    var got_supported_versions = false;
    var got_key_share = false;
    var got_cookie = false;

    while (r.pos < extensions_end) {
        const ext_type = try r.read(u16);
        const ext_len = try r.read(u16);
        if (ext_len > extensions_end - r.pos) return error.InvalidExtensionLength;

        switch (ext_type) {
            // supported_versions (RFC 8446 §4.2.1)
            0x002b => {
                if (got_supported_versions) return error.DuplicateExtension;
                if (ext_len != 2) return error.InvalidExtensionLength;
                const version = try r.read(u16);
                if (version != 0x0304) return error.UnsupportedTlsVersion;
                got_supported_versions = true;
            },
            // key_share: in HRR carries a single NamedGroup (selected_group).
            // RFC 8446 §4.2.8 KeyShareHelloRetryRequest.
            0x0033 => {
                if (got_key_share) return error.DuplicateExtension;
                if (ext_len != 2) return error.InvalidExtensionLength;
                selected_group = try r.read(NamedGroup);
                got_key_share = true;
            },
            // cookie (RFC 8446 §4.2.2) — opaque<1..2^16-1>.
            0x002c => {
                if (got_cookie) return error.DuplicateExtension;
                if (ext_len < 2) return error.InvalidExtensionLength;
                const cookie_len = try r.read(u16);
                if (cookie_len == 0 or cookie_len > ext_len - 2) return error.InvalidExtensionLength;
                cookie = try r.readSlice(cookie_len);
                // skip any trailing padding inside this extension
                try r.skip(ext_len - 2 - cookie_len);
                got_cookie = true;
            },
            else => try r.skip(ext_len),
        }
    }
    if (r.pos != extensions_end) return error.InvalidExtensionLength;

    if (!got_supported_versions) return error.MissingExtension;

    return .{
        .cipher_suite = cipher_suite,
        .selected_group = selected_group,
        .cookie = cookie,
    };
}

pub const encoded_len = 4 + 2 + 32 + 1 + 2 + 1 + 2 + (4 + 2 + 2 + 32) + (4 + 2);

pub const EncodeError = error{BufferTooShort};

/// Encode a TLS 1.3 ServerHello handshake message. The caller supplies the
/// legacy_session_id_echo from ClientHello; ztls' client currently sends an
/// empty one, but the server path needs to echo arbitrary caller-owned bytes.
/// RFC 8446 §4.1.3.
pub fn encode(
    out: []u8,
    random: [32]u8,
    session_id_echo: []const u8,
    cipher_suite: CipherSuite,
    public_key: x25519.PublicKey,
) EncodeError![]const u8 {
    if (session_id_echo.len > 32) return error.BufferTooShort;
    const len = encoded_len + session_id_echo.len;
    if (out.len < len) return error.BufferTooShort;

    var w: wire.Writer = .init(out);
    w.append(u8, 0x02);
    w.append(u24, @intCast(len - 4));
    w.append(u16, 0x0303);
    w.appendSlice(&random);
    w.append(u8, @intCast(session_id_echo.len));
    w.appendSlice(session_id_echo);
    w.append(CipherSuite, cipher_suite);
    w.append(u8, 0x00);

    w.append(u16, 0x002e); // extensions length
    w.append(u16, 0x0033); // key_share
    w.append(u16, 0x0024);
    w.append(NamedGroup, .x25519);
    w.append(u16, 0x0020);
    w.appendSlice(&public_key.data);
    w.append(u16, 0x002b); // supported_versions
    w.append(u16, 0x0002);
    w.append(u16, 0x0304);
    return w.written();
}

/// Parse a ServerHello handshake message.
///
/// `msg` must be the complete handshake message including the 4-byte header
/// (type + 3-byte length). Feed it into the transcript hash before calling.
///
/// RFC 8446 §4.1.3
pub fn parse(msg: []const u8) ParseError!ServerHello {
    var r: wire.Reader = .init(msg);

    // Handshake header (RFC 8446 §4)
    const handshake_type = try r.read(u8);
    if (handshake_type != 0x02) return error.InvalidHandshakeType;
    const body_len = try r.read(u24);
    if (body_len != msg.len - 4) return error.InvalidHandshakeLength;

    // ServerHello body (RFC 8446 §4.1.3). HelloRetryRequest is encoded as a
    // ServerHello with a fixed Random value; detect it explicitly so callers
    // get a clean unsupported-feature error instead of a misleading key_share
    // parse failure. RFC 8446 §4.1.3.
    try r.skip(2); // legacy_version
    const random = try r.readSlice(32);
    if (std.mem.eql(u8, random, &hello_retry_request_random)) return error.HelloRetryRequest;

    const session_id_len = try r.read(u8);
    try r.skip(session_id_len); // legacy_session_id_echo

    const cipher_suite = try r.read(CipherSuite);
    try r.skip(1); // legacy_compression_method

    // Extensions
    const extensions_len = try r.read(u16);
    if (extensions_len > msg.len - r.pos) return error.InvalidExtensionLength;
    const extensions_end = r.pos + extensions_len;

    var got_supported_versions = false;
    var server_public_key: x25519.PublicKey = undefined;
    var got_key_share = false;

    while (r.pos < extensions_end) {
        const ext_type = try r.read(u16);
        const ext_len = try r.read(u16);
        if (ext_len > extensions_end - r.pos) return error.InvalidExtensionLength;

        switch (ext_type) {
            // supported_versions (RFC 8446 §4.2.1)
            0x002b => {
                if (got_supported_versions) return error.DuplicateExtension;
                if (ext_len != 2) return error.InvalidExtensionLength;
                const version = try r.read(u16);
                if (version != 0x0304) return error.UnsupportedTlsVersion;
                got_supported_versions = true;
            },
            // key_share (RFC 8446 §4.2.8)
            0x0033 => {
                if (got_key_share) return error.DuplicateExtension;
                const ext_end = r.pos + ext_len;
                const group = try r.read(u16);
                if (group != @intFromEnum(NamedGroup.x25519)) return error.UnsupportedKeyShareGroup; // x25519 only
                const key_len = try r.read(u16);
                if (key_len != 32) return error.UnsupportedKeyShareGroup;
                server_public_key = .init((try r.readSlice(32))[0..32].*);
                if (r.pos != ext_end) return error.InvalidExtensionLength;
                got_key_share = true;
            },
            else => try r.skip(ext_len),
        }
    }
    if (r.pos != extensions_end) return error.InvalidExtensionLength;

    if (!got_supported_versions or !got_key_share) return error.MissingExtension;

    return .{
        .cipher_suite = cipher_suite,
        .server_public_key = server_public_key,
    };
}

// RFC 8446 §4.1.3
// Test vectors from RFC 8448 §3.

const server_hello_rfc8448: []const u8 = &.{
    0x02, 0x00, 0x00, 0x56, 0x03, 0x03, 0xa6, 0xaf, 0x06, 0xa4, 0x12, 0x18, 0x60,
    0xdc, 0x5e, 0x6e, 0x60, 0x24, 0x9c, 0xd3, 0x4c, 0x95, 0x93, 0x0c, 0x8a, 0xc5,
    0xcb, 0x14, 0x34, 0xda, 0xc1, 0x55, 0x77, 0x2e, 0xd3, 0xe2, 0x69, 0x28, 0x00,
    0x13, 0x01, 0x00, 0x00, 0x2e, 0x00, 0x33, 0x00, 0x24, 0x00, 0x1d, 0x00, 0x20,
    0xc9, 0x82, 0x88, 0x76, 0x11, 0x20, 0x95, 0xfe, 0x66, 0x76, 0x2b, 0xdb, 0xf7,
    0xc6, 0x72, 0xe1, 0x56, 0xd6, 0xcc, 0x25, 0x3b, 0x83, 0x3d, 0xf1, 0xdd, 0x69,
    0xb1, 0xb0, 0x4e, 0x75, 0x1f, 0x0f, 0x00, 0x2b, 0x00, 0x02, 0x03, 0x04,
};

test "encode: round trips through parse" {
    const key: x25519.PublicKey = .init(.{
        0xc9, 0x82, 0x88, 0x76, 0x11, 0x20, 0x95, 0xfe,
        0x66, 0x76, 0x2b, 0xdb, 0xf7, 0xc6, 0x72, 0xe1,
        0x56, 0xd6, 0xcc, 0x25, 0x3b, 0x83, 0x3d, 0xf1,
        0xdd, 0x69, 0xb1, 0xb0, 0x4e, 0x75, 0x1f, 0x0f,
    });
    var out: [128]u8 = undefined;
    const msg = try encode(&out, [_]u8{0xab} ** 32, &.{}, .aes_128_gcm_sha256, key);
    try testing.expectEqual(@as(usize, encoded_len), msg.len);
    const parsed = try parse(msg);
    try testing.expectEqual(.aes_128_gcm_sha256, parsed.cipher_suite);
    try testing.expectEqualSlices(u8, &key.data, &parsed.server_public_key.data);
}

test "encode: echoes session id" {
    var out: [128]u8 = undefined;
    const sid = [_]u8{ 1, 2, 3, 4 };
    const msg = try encode(&out, [_]u8{0xab} ** 32, &sid, .aes_256_gcm_sha384, .zero);
    try testing.expectEqual(@as(u8, sid.len), msg[38]);
    try testing.expectEqualSlices(u8, &sid, msg[39..][0..sid.len]);
    const parsed = try parse(msg);
    try testing.expectEqual(.aes_256_gcm_sha384, parsed.cipher_suite);
}

test "parse: RFC 8448 §3 ServerHello" {
    const sh = try parse(server_hello_rfc8448);
    try testing.expectEqual(.aes_128_gcm_sha256, sh.cipher_suite);
    try testing.expectEqualSlices(u8, &.{
        0xc9, 0x82, 0x88, 0x76, 0x11, 0x20, 0x95, 0xfe,
        0x66, 0x76, 0x2b, 0xdb, 0xf7, 0xc6, 0x72, 0xe1,
        0x56, 0xd6, 0xcc, 0x25, 0x3b, 0x83, 0x3d, 0xf1,
        0xdd, 0x69, 0xb1, 0xb0, 0x4e, 0x75, 0x1f, 0x0f,
    }, &sh.server_public_key.data);
}

test "parse: wrong handshake type" {
    var msg = server_hello_rfc8448[0..server_hello_rfc8448.len].*;
    msg[0] = 0x01; // client_hello
    try testing.expectError(error.InvalidHandshakeType, parse(&msg));
}

test "parse: truncated message" {
    try testing.expectError(error.InvalidHandshakeLength, parse(server_hello_rfc8448[0..43]));
}

test "parse: rejects HelloRetryRequest" {
    var msg = server_hello_rfc8448[0..server_hello_rfc8448.len].*;
    @memcpy(msg[6..][0..32], &hello_retry_request_random);
    try testing.expectError(error.HelloRetryRequest, parse(&msg));
}

test "parse: missing extensions" {
    // Minimal valid ServerHello with empty extensions block.
    const msg = [_]u8{
        0x02, 0x00, 0x00, 0x28, // type + body length = 40
        0x03, 0x03, // legacy_version
    } ++ [_]u8{0} ** 32 ++ // random
        [_]u8{
            0x00, // session_id: empty
            0x13, 0x01, // cipher_suite
            0x00, // compression
            0x00, 0x00, // extensions: empty
        };
    try testing.expectError(error.MissingExtension, parse(&msg));
}

test "parse: rejects mismatched handshake length" {
    var msg = server_hello_rfc8448[0..server_hello_rfc8448.len].*;
    msg[3] -= 1;
    try testing.expectError(error.InvalidHandshakeLength, parse(&msg));
}

test "parse: rejects oversized extensions block" {
    var msg = server_hello_rfc8448[0..server_hello_rfc8448.len].*;
    msg[42] = 0xff;
    msg[43] = 0xff;
    try testing.expectError(error.InvalidExtensionLength, parse(&msg));
}

test "parse: rejects duplicate supported_versions" {
    const msg = server_hello_rfc8448 ++ [_]u8{ 0x00, 0x2b, 0x00, 0x02, 0x03, 0x04 };
    var dup = msg[0..msg.len].*;
    dup[3] += 6;
    dup[43] += 6;
    try testing.expectError(error.DuplicateExtension, parse(&dup));
}

test "parse: rejects duplicate key_share" {
    const key_share = server_hello_rfc8448[44..84];
    const msg = server_hello_rfc8448 ++ key_share.*;
    var dup = msg[0..msg.len].*;
    dup[3] += key_share.len;
    dup[43] += key_share.len;
    try testing.expectError(error.DuplicateExtension, parse(&dup));
}

test "parse: unsupported TLS version" {
    // Patch supported_versions value from 0x0304 to 0x0303
    var msg = server_hello_rfc8448[0..server_hello_rfc8448.len].*;
    msg[msg.len - 2] = 0x03;
    msg[msg.len - 1] = 0x03;
    try testing.expectError(error.UnsupportedTlsVersion, parse(&msg));
}

// Fuzz target: parse must reject arbitrary bytes with an error, never crash
// (no panic/overflow/OOB). Run with `zig build test --fuzz`.
fn fuzzParse(_: void, input: []const u8) anyerror!void {
    _ = parse(input) catch {};
}

test "fuzz: parse handles arbitrary input" {
    try testing.fuzz({}, fuzzParse, .{ .corpus = &.{server_hello_rfc8448} });
}

// ----------------------------------------------------------------------------
// parseHelloRetryRequest tests
// ----------------------------------------------------------------------------

// RFC 8448 §5 — HelloRetryRequest (176 octets).
// The server requests P-256 (secp256r1, group 0x0017) and includes a cookie.
const hrr_rfc8448: []const u8 = &.{
    0x02, 0x00, 0x00, 0xac, 0x03, 0x03, 0xcf, 0x21, 0xad, 0x74, 0xe5, 0x9a, 0x61,
    0x11, 0xbe, 0x1d, 0x8c, 0x02, 0x1e, 0x65, 0xb8, 0x91, 0xc2, 0xa2, 0x11, 0x16,
    0x7a, 0xbb, 0x8c, 0x5e, 0x07, 0x9e, 0x09, 0xe2, 0xc8, 0xa8, 0x33, 0x9c, 0x00,
    0x13, 0x01, 0x00, 0x00, 0x84, 0x00, 0x33, 0x00, 0x02, 0x00, 0x17, 0x00, 0x2c,
    0x00, 0x74, 0x00, 0x72, 0x71, 0xdc, 0xd0, 0x4b, 0xb8, 0x8b, 0xc3, 0x18, 0x91,
    0x19, 0x39, 0x8a, 0x00, 0x00, 0x00, 0x00, 0xee, 0xfa, 0xfc, 0x76, 0xc1, 0x46,
    0xb8, 0x23, 0xb0, 0x96, 0xf8, 0xaa, 0xca, 0xd3, 0x65, 0xdd, 0x00, 0x30, 0x95,
    0x3f, 0x4e, 0xdf, 0x62, 0x56, 0x36, 0xe5, 0xf2, 0x1b, 0xb2, 0xe2, 0x3f, 0xcc,
    0x65, 0x4b, 0x1b, 0x5b, 0x40, 0x31, 0x8d, 0x10, 0xd1, 0x37, 0xab, 0xcb, 0xb8,
    0x75, 0x74, 0xe3, 0x6e, 0x8a, 0x1f, 0x02, 0x5f, 0x7d, 0xfa, 0x5d, 0x6e, 0x50,
    0x78, 0x1b, 0x5e, 0xda, 0x4a, 0xa1, 0x5b, 0x0c, 0x8b, 0xe7, 0x78, 0x25, 0x7d,
    0x16, 0xaa, 0x30, 0x30, 0xe9, 0xe7, 0x84, 0x1d, 0xd9, 0xe4, 0xc0, 0x34, 0x22,
    0x67, 0xe8, 0xca, 0x0c, 0xaf, 0x57, 0x1f, 0xb2, 0xb7, 0xcf, 0xf0, 0xf9, 0x34,
    0xb0, 0x00, 0x2b, 0x00, 0x02, 0x03, 0x04,
};

// RFC 8446 §4.1.4, RFC 8448 §5 — basic HRR parse.
test "parseHelloRetryRequest: RFC 8448 §5" {
    const hrr = try parseHelloRetryRequest(hrr_rfc8448);
    try testing.expectEqual(.aes_128_gcm_sha256, hrr.cipher_suite);
    try testing.expectEqual(NamedGroup.secp256r1, hrr.selected_group.?);
    // cookie is present and non-empty
    try testing.expect(hrr.cookie != null);
    try testing.expect(hrr.cookie.?.len > 0);
    // cookie inner length (first 2 bytes) should equal remaining bytes
    const cookie = hrr.cookie.?;
    try testing.expectEqual(@as(usize, 0x72), cookie.len);
}

// RFC 8446 §4.1.4 — HRR without cookie (key_share only).
test "parseHelloRetryRequest: no cookie" {
    // Minimal HRR: key_share (selected_group=x25519) + supported_versions.
    const msg: []const u8 = &([_]u8{ 0x02, 0x00, 0x00, 0x34 } // type + body len = 52
        ++ [_]u8{ 0x03, 0x03 } // legacy_version
        ++ hello_retry_request_random // Random
        ++ [_]u8{0x00} // session_id: empty
        ++ [_]u8{ 0x13, 0x01 } // cipher_suite
        ++ [_]u8{0x00} // compression
        ++ [_]u8{ 0x00, 0x0c } // extensions_len = 12
        ++ [_]u8{ 0x00, 0x33, 0x00, 0x02, 0x00, 0x1d } // key_share: x25519
        ++ [_]u8{ 0x00, 0x2b, 0x00, 0x02, 0x03, 0x04 } // supported_versions
    );
    const hrr = try parseHelloRetryRequest(msg);
    try testing.expectEqual(.aes_128_gcm_sha256, hrr.cipher_suite);
    try testing.expectEqual(NamedGroup.x25519, hrr.selected_group.?);
    try testing.expectEqual(@as(?[]const u8, null), hrr.cookie);
}

// RFC 8446 §4.1.4 — rejects message with wrong Random (not an HRR).
test "parseHelloRetryRequest: rejects non-HRR Random" {
    var msg = hrr_rfc8448[0..hrr_rfc8448.len].*;
    // overwrite Random with all-zeros
    @memset(msg[6..][0..32], 0x00);
    try testing.expectError(error.NotHelloRetryRequest, parseHelloRetryRequest(&msg));
}

// RFC 8446 §4.1.4 — rejects wrong handshake type.
test "parseHelloRetryRequest: rejects wrong type" {
    var msg = hrr_rfc8448[0..hrr_rfc8448.len].*;
    msg[0] = 0x01;
    try testing.expectError(error.InvalidHandshakeType, parseHelloRetryRequest(&msg));
}

// RFC 8446 §4.1.4 — rejects unsupported TLS version in HRR.
test "parseHelloRetryRequest: rejects TLS 1.2 in supported_versions" {
    var msg = hrr_rfc8448[0..hrr_rfc8448.len].*;
    // Last 2 bytes are the version in supported_versions
    msg[msg.len - 2] = 0x03;
    msg[msg.len - 1] = 0x03;
    try testing.expectError(error.UnsupportedTlsVersion, parseHelloRetryRequest(&msg));
}

// RFC 8446 §4.1.4 — rejects HRR with no supported_versions.
test "parseHelloRetryRequest: rejects missing supported_versions" {
    // key_share only, no supported_versions.
    const msg: []const u8 = &([_]u8{ 0x02, 0x00, 0x00, 0x2e } // type + body len = 46
        ++ [_]u8{ 0x03, 0x03 } // legacy_version
        ++ hello_retry_request_random // Random
        ++ [_]u8{0x00} // session_id: empty
        ++ [_]u8{ 0x13, 0x01 } // cipher_suite
        ++ [_]u8{0x00} // compression
        ++ [_]u8{ 0x00, 0x06 } // extensions_len = 6
        ++ [_]u8{ 0x00, 0x33, 0x00, 0x02, 0x00, 0x1d } // key_share only
    );
    try testing.expectError(error.MissingExtension, parseHelloRetryRequest(msg));
}

fn fuzzParseHrr(_: void, input: []const u8) anyerror!void {
    _ = parseHelloRetryRequest(input) catch {};
}

test "fuzz: parseHelloRetryRequest handles arbitrary input" {
    try testing.fuzz({}, fuzzParseHrr, .{ .corpus = &.{hrr_rfc8448} });
}
