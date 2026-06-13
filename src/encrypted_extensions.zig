/// TLS 1.3 EncryptedExtensions handshake message parsing.
///
/// RFC 8446 §4.3.1
const std = @import("std");
const mem = std.mem;
const testing = std.testing;

const handshake = @import("handshake.zig");
const wire = @import("wire.zig");

pub const ParseError = error{
    UnexpectedEof,
    InvalidHandshakeType,
    InvalidHandshakeLength,
    InvalidExtensionLength,
    UnexpectedExtension,
    DuplicateExtension,
    EmptyAlpnProtocol,
    TooManyAlpnProtocols,
    UnofferedAlpnProtocol,
};

pub const Parsed = struct {
    alpn_protocol: ?[]const u8 = null,
};

const ExtensionType = enum(u16) {
    server_name = 0x0000,
    supported_groups = 0x000a,
    signature_algorithms = 0x000d,
    alpn = 0x0010,
    padding = 0x0015,
    pre_shared_key = 0x0029,
    early_data = 0x002a,
    supported_versions = 0x002b,
    cookie = 0x002c,
    psk_key_exchange_modes = 0x002d,
    certificate_authorities = 0x002f,
    oid_filters = 0x0030,
    post_handshake_auth = 0x0031,
    signature_algorithms_cert = 0x0032,
    key_share = 0x0033,
    _,
};

pub const EncodeError = error{ BufferTooShort, EmptyAlpnProtocol, AlpnProtocolTooLong };

pub fn encodedLen(alpn_protocol: ?[]const u8) usize {
    const alpn_len: usize = if (alpn_protocol) |p| 4 + 2 + 1 + p.len else 0;
    return 4 + 2 + alpn_len;
}

/// Encode EncryptedExtensions. Currently only ALPN is supported as server
/// output. RFC 8446 §4.3.1, RFC 7301 §3.2.
pub fn encode(out: []u8, alpn_protocol: ?[]const u8) EncodeError![]const u8 {
    if (alpn_protocol) |p| {
        if (p.len == 0) return error.EmptyAlpnProtocol;
        if (p.len > 255) return error.AlpnProtocolTooLong;
    }
    const len = encodedLen(alpn_protocol);
    if (out.len < len) return error.BufferTooShort;

    var w: wire.Writer = .init(out);
    w.append(handshake.Type, .encrypted_extensions);
    w.append(u24, @intCast(len - 4));
    w.append(u16, @intCast(len - 6));
    if (alpn_protocol) |p| {
        w.append(ExtensionType, .alpn);
        w.append(u16, @intCast(2 + 1 + p.len));
        w.append(u16, @intCast(1 + p.len));
        w.append(u8, @intCast(p.len));
        w.appendSlice(p);
    }
    return w.written();
}

/// Parse an EncryptedExtensions handshake message.
///
/// Recognizes ALPN when the caller offered protocols. Unknown extensions are
/// skipped because they are informational for ztls' current core handshake, but
/// ALPN is rejected if unsolicited or if it selects a protocol we did not offer.
/// RFC 8446 §4.3.1, RFC 7301 §3.2.
pub fn parse(msg: []const u8, offered_alpn: []const []const u8) ParseError!Parsed {
    if (msg.len < 6) return error.UnexpectedEof;

    var r: wire.Reader = .init(msg);
    const handshake_type = r.assumeRead(handshake.Type);
    if (handshake_type != .encrypted_extensions) return error.InvalidHandshakeType;
    const body_len = r.assumeRead(u24);
    if (body_len != msg.len - 4) return error.InvalidHandshakeLength;

    if (body_len < 2) return error.InvalidHandshakeLength;
    const extensions_len = r.assumeRead(u16);
    if (extensions_len != body_len - 2) return error.InvalidExtensionLength;
    const extensions_end = r.pos + extensions_len;

    var result: Parsed = .{};
    while (r.pos < extensions_end) {
        if (extensions_end - r.pos < 4) return error.InvalidExtensionLength;
        const ext_type = r.assumeRead(ExtensionType);
        const ext_len = r.assumeRead(u16);
        if (r.pos + ext_len > extensions_end) return error.InvalidExtensionLength;
        const ext = r.assumeReadSlice(ext_len);

        switch (ext_type) {
            .alpn => {
                if (result.alpn_protocol != null) return error.DuplicateExtension;
                result.alpn_protocol = try parseAlpn(ext, offered_alpn);
            },
            // RFC 8446 §4.2 — recognized extensions sent in a message where
            // they are not specified are semantic errors, not ignorable grease.
            .signature_algorithms,
            .padding,
            .pre_shared_key,
            .early_data,
            .supported_versions,
            .cookie,
            .psk_key_exchange_modes,
            .certificate_authorities,
            .oid_filters,
            .post_handshake_auth,
            .signature_algorithms_cert,
            .key_share,
            => return error.UnexpectedExtension,
            else => {},
        }
    }
    if (r.pos != extensions_end) return error.InvalidExtensionLength;
    return result;
}

fn parseAlpn(ext: []const u8, offered: []const []const u8) ParseError![]const u8 {
    if (offered.len == 0) return error.UnexpectedExtension;
    if (ext.len < 3) return error.InvalidExtensionLength;
    var r: wire.Reader = .init(ext);
    const list_len = r.assumeRead(u16);
    if (list_len != ext.len - 2) return error.InvalidExtensionLength;
    const protocol_len = r.assumeRead(u8);
    if (protocol_len == 0) return error.EmptyAlpnProtocol;
    if (r.remaining().len < protocol_len) return error.InvalidExtensionLength;
    const protocol = r.assumeReadSlice(protocol_len);
    if (r.pos != ext.len) return error.TooManyAlpnProtocols;
    for (offered) |candidate| {
        if (mem.eql(u8, candidate, protocol)) return protocol;
    }
    return error.UnofferedAlpnProtocol;
}

test "encode: empty EncryptedExtensions" {
    var out: [32]u8 = undefined;
    const msg = try encode(&out, null);
    try testing.expectEqualSlices(u8, &.{ 0x08, 0x00, 0x00, 0x02, 0x00, 0x00 }, msg);
    _ = try parse(msg, &.{});
}

test "encode: ALPN EncryptedExtensions" {
    var out: [32]u8 = undefined;
    const msg = try encode(&out, "h2");
    const result = try parse(msg, &.{ "h2", "http/1.1" });
    try testing.expectEqualStrings("h2", result.alpn_protocol.?);
}

test "parse: valid EncryptedExtensions" {
    // type(1) + length(3) + extensions_len(2) + no extensions
    const msg = [_]u8{ 0x08, 0x00, 0x00, 0x02, 0x00, 0x00 };
    _ = try parse(&msg, &.{});
}

test "parse: ALPN selection" {
    const msg = [_]u8{
        0x08, 0x00, 0x00, 0x0b,
        0x00, 0x09, 0x00, 0x10,
        0x00, 0x05, 0x00, 0x03,
        0x02, 'h',  '2',
    };
    const result = try parse(&msg, &.{ "h2", "http/1.1" });
    try testing.expectEqualStrings("h2", result.alpn_protocol.?);
}

test "parse: rejects unsolicited ALPN" {
    const msg = [_]u8{
        0x08, 0x00, 0x00, 0x0b,
        0x00, 0x09, 0x00, 0x10,
        0x00, 0x05, 0x00, 0x03,
        0x02, 'h',  '2',
    };
    try testing.expectError(error.UnexpectedExtension, parse(&msg, &.{}));
}

test "parse: rejects unoffered ALPN" {
    const msg = [_]u8{
        0x08, 0x00, 0x00, 0x0b,
        0x00, 0x09, 0x00, 0x10,
        0x00, 0x05, 0x00, 0x03,
        0x02, 'h',  '2',
    };
    try testing.expectError(error.UnofferedAlpnProtocol, parse(&msg, &.{"http/1.1"}));
}

test "parse: rejects duplicate ALPN extension" {
    const msg = [_]u8{
        0x08, 0x00, 0x00, 0x14,
        0x00, 0x12, 0x00, 0x10,
        0x00, 0x05, 0x00, 0x03,
        0x02, 'h',  '2',  0x00,
        0x10, 0x00, 0x05, 0x00,
        0x03, 0x02, 'h',  '2',
    };
    try testing.expectError(error.DuplicateExtension, parse(&msg, &.{"h2"}));
}

test "parse: rejects multiple ALPN protocols" {
    const msg = [_]u8{
        0x08, 0x00, 0x00, 0x12,
        0x00, 0x10, 0x00, 0x10,
        0x00, 0x0c, 0x00, 0x0a,
        0x02, 'h',  '2',  0x06,
        's',  'p',  'd',  'y',
        '/',  '3',
    };
    try testing.expectError(error.TooManyAlpnProtocols, parse(&msg, &.{ "h2", "spdy/3" }));
}

// RFC 8446 §4.2 — extensions recognized for other handshake messages are
// forbidden in EncryptedExtensions.
test "parse: rejects forbidden supported_versions extension" {
    const msg = [_]u8{
        0x08, 0x00, 0x00, 0x08,
        0x00, 0x06, 0x00, 0x2b,
        0x00, 0x02, 0x03, 0x04,
    };
    try testing.expectError(error.UnexpectedExtension, parse(&msg, &.{}));
}

// RFC 8446 §4.2 — key_share belongs in ClientHello, ServerHello, and HRR, not
// EncryptedExtensions.
test "parse: rejects forbidden key_share extension" {
    const msg = [_]u8{
        0x08, 0x00, 0x00, 0x08,
        0x00, 0x06, 0x00, 0x33,
        0x00, 0x02, 0x00, 0x1d,
    };
    try testing.expectError(error.UnexpectedExtension, parse(&msg, &.{}));
}

// RFC 8446 §4.2.7 — supported_groups is allowed in EncryptedExtensions; the
// client must not act on it until handshake completion.
test "parse: ignores supported_groups extension" {
    const msg = [_]u8{
        0x08, 0x00, 0x00, 0x0a,
        0x00, 0x08, 0x00, 0x0a,
        0x00, 0x04, 0x00, 0x02,
        0x00, 0x1d,
    };
    _ = try parse(&msg, &.{});
}

test "parse: wrong handshake type" {
    const msg = [_]u8{ 0x01, 0x00, 0x00, 0x02, 0x00, 0x00 };
    try testing.expectError(error.InvalidHandshakeType, parse(&msg, &.{}));
}

test "parse: truncated" {
    const msg = [_]u8{ 0x08, 0x00, 0x00 };
    try testing.expectError(error.UnexpectedEof, parse(&msg, &.{}));
}
