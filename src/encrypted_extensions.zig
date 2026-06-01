/// TLS 1.3 EncryptedExtensions handshake message parsing.
///
/// RFC 8446 §4.3.1
const std = @import("std");
const mem = std.mem;
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

pub const Result = struct {
    alpn_protocol: ?[]const u8 = null,
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
    w.append(u8, 0x08);
    w.append(u24, @intCast(len - 4));
    w.append(u16, @intCast(len - 6));
    if (alpn_protocol) |p| {
        w.append(u16, 0x0010);
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
pub fn parse(msg: []const u8, offered_alpn: []const []const u8) ParseError!Result {
    var r: wire.Reader = .init(msg);
    const handshake_type = try r.read(u8);
    if (handshake_type != 0x08) return error.InvalidHandshakeType;
    const body_len = try r.read(u24);
    if (body_len != msg.len - 4) return error.InvalidHandshakeLength;

    if (body_len < 2) return error.InvalidHandshakeLength;
    const extensions_len = try r.read(u16);
    if (extensions_len != body_len - 2) return error.InvalidExtensionLength;
    const extensions_end = r.pos + extensions_len;

    var result: Result = .{};
    while (r.pos < extensions_end) {
        const ext_type = try r.read(u16);
        const ext_len = try r.read(u16);
        if (r.pos + ext_len > extensions_end) return error.InvalidExtensionLength;
        const ext = msg[r.pos..][0..ext_len];
        r.pos += ext_len;

        switch (ext_type) {
            0x0010 => {
                if (result.alpn_protocol != null) return error.DuplicateExtension;
                result.alpn_protocol = try parseAlpn(ext, offered_alpn);
            },
            else => {},
        }
    }
    if (r.pos != extensions_end) return error.InvalidExtensionLength;
    return result;
}

fn parseAlpn(ext: []const u8, offered: []const []const u8) ParseError![]const u8 {
    if (offered.len == 0) return error.UnexpectedExtension;
    var r: wire.Reader = .init(ext);
    const list_len = try r.read(u16);
    if (list_len != ext.len - 2) return error.InvalidExtensionLength;
    const protocol_len = try r.read(u8);
    if (protocol_len == 0) return error.EmptyAlpnProtocol;
    const protocol = try r.readSlice(protocol_len);
    if (r.pos != ext.len) return error.TooManyAlpnProtocols;
    for (offered) |candidate| {
        if (mem.eql(u8, candidate, protocol)) return protocol;
    }
    return error.UnofferedAlpnProtocol;
}

const testing = std.testing;

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

test "parse: wrong handshake type" {
    const msg = [_]u8{ 0x01, 0x00, 0x00, 0x02, 0x00, 0x00 };
    try testing.expectError(error.InvalidHandshakeType, parse(&msg, &.{}));
}

test "parse: truncated" {
    const msg = [_]u8{ 0x08, 0x00, 0x00 };
    try testing.expectError(error.UnexpectedEof, parse(&msg, &.{}));
}
