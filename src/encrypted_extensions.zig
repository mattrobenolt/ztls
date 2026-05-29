/// TLS 1.3 EncryptedExtensions handshake message parsing.
///
/// RFC 8446 §4.3.1
const std = @import("std");
const wire = @import("wire.zig");

pub const ParseError = error{
    UnexpectedEof,
    InvalidHandshakeType,
};

/// Parse an EncryptedExtensions handshake message.
///
/// We consume the message and skip any extensions — the content is informational
/// and none of the extensions we send require server confirmation for the core
/// handshake. Returns the number of bytes consumed for transcript accounting.
///
/// RFC 8446 §4.3.1
pub fn parse(msg: []const u8) ParseError!void {
    var r: wire.Reader = .init(msg);
    const handshake_type = try r.read(u8);
    if (handshake_type != 0x08) return error.InvalidHandshakeType;
    try r.skip(3); // body length
    const extensions_len = try r.read(u16);
    try r.skip(extensions_len);
}

const testing = std.testing;

test "parse: valid EncryptedExtensions" {
    // type(1) + length(3) + extensions_len(2) + no extensions
    const msg = [_]u8{ 0x08, 0x00, 0x00, 0x02, 0x00, 0x00 };
    try parse(&msg);
}

test "parse: wrong handshake type" {
    const msg = [_]u8{ 0x01, 0x00, 0x00, 0x02, 0x00, 0x00 };
    try testing.expectError(error.InvalidHandshakeType, parse(&msg));
}

test "parse: truncated" {
    const msg = [_]u8{ 0x08, 0x00, 0x00 };
    try testing.expectError(error.UnexpectedEof, parse(&msg));
}
