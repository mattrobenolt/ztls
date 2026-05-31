/// TLS 1.3 ServerHello handshake message parsing.
///
/// RFC 8446 §4.1.3
const std = @import("std");
const testing = std.testing;

const CipherSuite = @import("root.zig").CipherSuite;
const wire = @import("wire.zig");
const x25519 = @import("x25519.zig");

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
                if (group != 0x001d) return error.UnsupportedKeyShareGroup; // x25519 only
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
