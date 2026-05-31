/// TLS 1.3 NewSessionTicket parsing.
///
/// ztls does not implement PSK resumption yet, but post-handshake tickets are
/// still handshake messages on the encrypted stream. Parse enough structure to
/// reject malformed tickets instead of accepting arbitrary bytes.
/// RFC 8446 §4.6.1.
const std = @import("std");
const wire = @import("wire.zig");

pub const ParseError = error{
    UnexpectedEof,
    InvalidHandshakeType,
    InvalidHandshakeLength,
    EmptyTicket,
    InvalidExtensionLength,
};

pub const NewSessionTicket = struct {
    ticket_lifetime: u32,
    ticket_age_add: u32,
    ticket_nonce: []const u8,
    ticket: []const u8,
};

/// Parse a complete NewSessionTicket handshake message including its 4-byte
/// Handshake header. Returned slices borrow `msg` and are for inspection only;
/// current client state machine ignores the result.
pub fn parse(msg: []const u8) ParseError!NewSessionTicket {
    var r: wire.Reader = .init(msg);
    const handshake_type = try r.read(u8);
    if (handshake_type != 0x04) return error.InvalidHandshakeType;
    const body_len = try r.read(u24);
    if (body_len != msg.len - 4) return error.InvalidHandshakeLength;

    const ticket_lifetime = try r.read(u32);
    const ticket_age_add = try r.read(u32);
    const nonce_len = try r.read(u8);
    const nonce = try r.readSlice(nonce_len);
    const ticket_len = try r.read(u16);
    if (ticket_len == 0) return error.EmptyTicket;
    const ticket = try r.readSlice(ticket_len);
    const extensions_len = try r.read(u16);
    if (extensions_len != msg.len - r.pos) return error.InvalidExtensionLength;
    try r.skip(extensions_len);

    return .{
        .ticket_lifetime = ticket_lifetime,
        .ticket_age_add = ticket_age_add,
        .ticket_nonce = nonce,
        .ticket = ticket,
    };
}

const testing = std.testing;

test "parse: valid NewSessionTicket" {
    const msg = [_]u8{
        0x04, 0x00, 0x00, 0x11,
        0x00, 0x00, 0x0e, 0x10,
        0x12, 0x34, 0x56, 0x78,
        0x02, 0xaa, 0xbb, 0x00,
        0x02, 0xcc, 0xdd, 0x00,
        0x00,
    };
    const ticket = try parse(&msg);
    try testing.expectEqual(@as(u32, 3600), ticket.ticket_lifetime);
    try testing.expectEqual(@as(u32, 0x12345678), ticket.ticket_age_add);
    try testing.expectEqualSlices(u8, &.{ 0xaa, 0xbb }, ticket.ticket_nonce);
    try testing.expectEqualSlices(u8, &.{ 0xcc, 0xdd }, ticket.ticket);
}

test "parse: wrong handshake type" {
    const msg = [_]u8{ 0x08, 0x00, 0x00, 0x00 };
    try testing.expectError(error.InvalidHandshakeType, parse(&msg));
}

test "parse: rejects length mismatch" {
    const msg = [_]u8{ 0x04, 0x00, 0x00, 0x01, 0x00 };
    try testing.expectError(error.UnexpectedEof, parse(&msg));
}

test "parse: rejects empty ticket" {
    const msg = [_]u8{
        0x04, 0x00, 0x00, 0x0d,
        0x00, 0x00, 0x0e, 0x10,
        0x12, 0x34, 0x56, 0x78,
        0x00, 0x00, 0x00, 0x00,
        0x00,
    };
    try testing.expectError(error.EmptyTicket, parse(&msg));
}

test "parse: rejects malformed extensions length" {
    const msg = [_]u8{
        0x04, 0x00, 0x00, 0x0f,
        0x00, 0x00, 0x0e, 0x10,
        0x12, 0x34, 0x56, 0x78,
        0x00, 0x00, 0x02, 0xcc,
        0xdd, 0x00, 0x01,
    };
    try testing.expectError(error.InvalidExtensionLength, parse(&msg));
}

fn fuzzParse(_: void, input: []const u8) anyerror!void {
    _ = parse(input) catch {};
}

test "fuzz: parse handles arbitrary input" {
    try testing.fuzz({}, fuzzParse, .{});
}
