/// TLS 1.3 NewSessionTicket parsing.
///
/// ztls does not implement PSK resumption yet, but post-handshake tickets are
/// still handshake messages on the encrypted stream. Parse enough structure to
/// reject malformed tickets instead of accepting arbitrary bytes.
/// RFC 8446 §4.6.1.
const std = @import("std");
const testing = std.testing;

const wire = @import("wire.zig");

const NewSessionTicket = @This();

ticket_lifetime: u32,
ticket_age_add: u32,
ticket_nonce: []const u8,
ticket: []const u8,
max_early_data_size: ?u32 = null,

pub const ParseError = error{
    UnexpectedEof,
    InvalidHandshakeType,
    InvalidHandshakeLength,
    EmptyTicket,
    InvalidExtensionLength,
    DuplicateEarlyData,
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
    var extensions: wire.Reader = .init(try r.readSlice(extensions_len));
    var max_early_data_size: ?u32 = null;
    while (extensions.remaining().len != 0) {
        if (extensions.remaining().len < 4) return error.InvalidExtensionLength;
        const extension_type = try extensions.read(u16);
        const extension_len = try extensions.read(u16);
        if (extension_len > extensions.remaining().len) return error.InvalidExtensionLength;
        const extension = try extensions.readSlice(extension_len);
        switch (extension_type) {
            0x002a => {
                if (max_early_data_size != null) return error.DuplicateEarlyData;
                if (extension.len != 4) return error.InvalidExtensionLength;
                var er: wire.Reader = .init(extension);
                max_early_data_size = try er.read(u32);
            },
            else => {},
        }
    }

    return .{
        .ticket_lifetime = ticket_lifetime,
        .ticket_age_add = ticket_age_add,
        .ticket_nonce = nonce,
        .ticket = ticket,
        .max_early_data_size = max_early_data_size,
    };
}

// RFC 8446 §4.6.1 — NewSessionTicket carries lifetime, age_add, nonce, ticket, and extensions.
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
    try testing.expectEqual(@as(?u32, null), ticket.max_early_data_size);
}

// RFC 8446 §4.6.1 — early_data in NewSessionTicket is a uint32 max_early_data_size.
test "parse: captures early_data max_early_data_size" {
    const msg = [_]u8{
        0x04, 0x00, 0x00, 0x19,
        0x00, 0x00, 0x0e, 0x10,
        0x12, 0x34, 0x56, 0x78,
        0x02, 0xaa, 0xbb, 0x00,
        0x02, 0xcc, 0xdd, 0x00,
        0x08, 0x00, 0x2a, 0x00,
        0x04, 0x00, 0x00, 0x40,
        0x00,
    };
    const ticket = try parse(&msg);
    try testing.expectEqual(@as(?u32, 0x4000), ticket.max_early_data_size);
}

// RFC 8446 §4.2 — extensions must be well-formed vectors; unknown extensions are ignored.
test "parse: skips unknown ticket extension" {
    const msg = [_]u8{
        0x04, 0x00, 0x00, 0x17,
        0x00, 0x00, 0x0e, 0x10,
        0x12, 0x34, 0x56, 0x78,
        0x02, 0xaa, 0xbb, 0x00,
        0x02, 0xcc, 0xdd, 0x00,
        0x06, 0xbe, 0xef, 0x00,
        0x02, 0x01, 0x02,
    };
    const ticket = try parse(&msg);
    try testing.expectEqual(@as(?u32, null), ticket.max_early_data_size);
}

// RFC 8446 §4.2 — endpoints MUST NOT send more than one extension of the same type.
test "parse: rejects duplicate early_data extension" {
    const msg = [_]u8{
        0x04, 0x00, 0x00, 0x21,
        0x00, 0x00, 0x0e, 0x10,
        0x12, 0x34, 0x56, 0x78,
        0x02, 0xaa, 0xbb, 0x00,
        0x02, 0xcc, 0xdd, 0x00,
        0x10, 0x00, 0x2a, 0x00,
        0x04, 0x00, 0x00, 0x40,
        0x00, 0x00, 0x2a, 0x00,
        0x04, 0x00, 0x00, 0x20,
        0x00,
    };
    try testing.expectError(error.DuplicateEarlyData, parse(&msg));
}

// RFC 8446 §4.6.1 — early_data has exactly four bytes of extension_data.
test "parse: rejects malformed early_data length" {
    const msg = [_]u8{
        0x04, 0x00, 0x00, 0x18,
        0x00, 0x00, 0x0e, 0x10,
        0x12, 0x34, 0x56, 0x78,
        0x02, 0xaa, 0xbb, 0x00,
        0x02, 0xcc, 0xdd, 0x00,
        0x07, 0x00, 0x2a, 0x00,
        0x03, 0x00, 0x40, 0x00,
    };
    try testing.expectError(error.InvalidExtensionLength, parse(&msg));
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
    _ = parse(input) catch return;
}

test "fuzz: parse handles arbitrary input" {
    try testing.fuzz({}, fuzzParse, .{});
}
