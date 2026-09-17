//! TLS 1.3 NewSessionTicket encoding and parsing.
//! RFC 8446 §4.6.1.
const std = @import("std");
const testing = std.testing;
const fuzz_compat = @import("fuzz_compat.zig");

const extension_type = @import("extension_type.zig");
const ExtensionType = extension_type.ExtensionType;
const frame = @import("frame.zig");
const handshake = @import("handshake.zig");
const wire = @import("wire.zig");

const NewSessionTicket = @This();

ticket_lifetime: u32,
ticket_age_add: u32,
ticket_nonce: []const u8,
ticket: []const u8,
max_early_data_size: ?u32 = null,

pub const max_ticket_lifetime_sec = 7 * 24 * 60 * 60;
pub const max_nonce_len = std.math.maxInt(u8);

pub const EncodeError = error{
    BufferTooShort,
    TicketLifetimeTooLong,
    TicketNonceTooLong,
    EmptyTicket,
    TicketTooLong,
    TicketTooLarge,
    InputAliasesOutput,
};

pub const ParseError = error{
    UnexpectedEof,
    InvalidHandshakeType,
    InvalidHandshakeLength,
    EmptyTicket,
    InvalidExtensionLength,
    DuplicateExtension,
};

/// Encode a complete NewSessionTicket handshake message into caller-owned storage.
/// `ticket_age_add` must be freshly generated for each ticket, and `ticket_nonce` must
/// be unique across all tickets issued on one connection. The caller owns both inputs.
pub fn encode(out: []u8, ticket: NewSessionTicket) EncodeError![]const u8 {
    if (ticket.ticket_lifetime > max_ticket_lifetime_sec)
        return error.TicketLifetimeTooLong;
    if (ticket.ticket_nonce.len > max_nonce_len) return error.TicketNonceTooLong;
    if (ticket.ticket.len == 0) return error.EmptyTicket;
    if (ticket.ticket.len > std.math.maxInt(u16)) return error.TicketTooLong;
    if (slicesOverlap(out, ticket.ticket_nonce) or slicesOverlap(out, ticket.ticket))
        return error.InputAliasesOutput;

    const extensions_len: usize = if (ticket.max_early_data_size != null) 8 else 0;
    const fixed_body_len: usize = 4 + 4 + 1 + 2 + 2;
    const body_len = fixed_body_len + ticket.ticket_nonce.len +
        ticket.ticket.len + extensions_len;
    const encoded_len = 4 + body_len;
    if (encoded_len > frame.max_plaintext_len) return error.TicketTooLarge;
    if (out.len < encoded_len) return error.BufferTooShort;

    var writer: wire.Writer = .init(out);
    writer.append(handshake.Type, .new_session_ticket);
    writer.append(u24, @intCast(body_len));
    writer.append(u32, ticket.ticket_lifetime);
    writer.append(u32, ticket.ticket_age_add);
    writer.append(u8, @intCast(ticket.ticket_nonce.len));
    writer.appendSlice(ticket.ticket_nonce);
    writer.append(u16, @intCast(ticket.ticket.len));
    writer.appendSlice(ticket.ticket);
    writer.append(u16, @intCast(extensions_len));
    if (ticket.max_early_data_size) |max_early_data_size| {
        writer.append(ExtensionType, .early_data);
        writer.append(u16, 4);
        writer.append(u32, max_early_data_size);
    }
    std.debug.assert(writer.written().len == encoded_len);
    return writer.written();
}

fn slicesOverlap(a: []const u8, b: []const u8) bool {
    if (a.len == 0 or b.len == 0) return false;
    const a_start = @intFromPtr(a.ptr);
    const b_start = @intFromPtr(b.ptr);
    return a_start < b_start + b.len and b_start < a_start + a.len;
}

/// Parse a complete NewSessionTicket handshake message including its 4-byte
/// Handshake header. Returned slices borrow `msg` and are for inspection only.
pub fn parse(msg: []const u8) ParseError!NewSessionTicket {
    if (msg.len < 4) return error.UnexpectedEof;

    var r: wire.Reader = .init(msg);
    const handshake_type = r.assumeRead(handshake.Type);
    if (handshake_type != .new_session_ticket) return error.InvalidHandshakeType;
    const body_len = r.assumeRead(u24);
    if (body_len != msg.len - 4) return error.InvalidHandshakeLength;
    if (body_len < 4 + 4 + 1 + 2 + 2) return error.UnexpectedEof;

    const ticket_lifetime = r.assumeRead(u32);
    const ticket_age_add = r.assumeRead(u32);
    const nonce_len = r.assumeRead(u8);
    if (r.remaining().len < @as(usize, nonce_len) + 2) return error.UnexpectedEof;
    const nonce = r.assumeReadSlice(nonce_len);
    const ticket_len = r.assumeRead(u16);
    if (ticket_len == 0) return error.EmptyTicket;
    if (r.remaining().len < @as(usize, ticket_len) + 2) return error.UnexpectedEof;
    const ticket = r.assumeReadSlice(ticket_len);
    const extensions_len = r.assumeRead(u16);
    if (extensions_len != r.remaining().len) return error.InvalidExtensionLength;
    const extensions_raw = r.assumeReadSlice(extensions_len);
    try extension_type.rejectDuplicateExtensions(extensions_raw);
    var extensions: wire.Reader = .init(extensions_raw);
    var max_early_data_size: ?u32 = null;
    while (extensions.remaining().len != 0) {
        if (extensions.remaining().len < 4) return error.InvalidExtensionLength;
        const ext_type = extensions.assumeRead(ExtensionType);
        const extension_len = extensions.assumeRead(u16);
        if (extension_len > extensions.remaining().len) return error.InvalidExtensionLength;
        const extension = extensions.assumeReadSlice(extension_len);
        switch (ext_type) {
            .early_data => {
                if (max_early_data_size != null) return error.DuplicateExtension;
                if (extension.len != 4) return error.InvalidExtensionLength;
                var er: wire.Reader = .init(extension);
                max_early_data_size = er.assumeRead(u32);
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

// RFC 8446 §4.6.1 — the allocation-free encoder produces a message that the
// parser recovers exactly, including the optional early_data extension.
test "encode and parse NewSessionTicket round trip" {
    const expected = [_]u8{
        0x04, 0x00, 0x00, 0x1a,
        0x00, 0x00, 0x0e, 0x10,
        0xaa, 0xbb, 0xcc, 0xdd,
        0x02, 0x01, 0x02, 0x00,
        0x03, 0x10, 0x11, 0x12,
        0x00, 0x08, 0x00, 0x2a,
        0x00, 0x04, 0x00, 0x01,
        0x00, 0x00,
    };
    var out: [expected.len]u8 = undefined;
    const encoded = try encode(&out, .{
        .ticket_lifetime = 3600,
        .ticket_age_add = 0xaabbccdd,
        .ticket_nonce = &.{ 0x01, 0x02 },
        .ticket = &.{ 0x10, 0x11, 0x12 },
        .max_early_data_size = 65536,
    });
    try testing.expectEqualSlices(u8, &expected, encoded);

    const parsed = try parse(encoded);
    try testing.expectEqual(@as(u32, 3600), parsed.ticket_lifetime);
    try testing.expectEqual(@as(u32, 0xaabbccdd), parsed.ticket_age_add);
    try testing.expectEqualSlices(u8, &.{ 0x01, 0x02 }, parsed.ticket_nonce);
    try testing.expectEqualSlices(u8, &.{ 0x10, 0x11, 0x12 }, parsed.ticket);
    try testing.expectEqual(@as(?u32, 65536), parsed.max_early_data_size);
}

// RFC 8446 §4.6.1 — ticket lifetime is capped at seven days; zero is valid,
// and nonce/ticket vectors obey their one-byte/two-byte wire bounds.
test "encode validates NewSessionTicket bounds before writing" {
    const base: NewSessionTicket = .{
        .ticket_lifetime = 0,
        .ticket_age_add = 1,
        .ticket_nonce = &.{},
        .ticket = &.{0xaa},
    };
    var out: [32]u8 = undefined;
    _ = try encode(&out, base);

    var ticket = base;
    ticket.ticket_lifetime = max_ticket_lifetime_sec + 1;
    try testing.expectError(error.TicketLifetimeTooLong, encode(&out, ticket));

    var long_nonce: [max_nonce_len + 1]u8 = @splat(0);
    ticket = base;
    ticket.ticket_nonce = &long_nonce;
    try testing.expectError(error.TicketNonceTooLong, encode(&out, ticket));

    ticket = base;
    ticket.ticket = &.{};
    try testing.expectError(error.EmptyTicket, encode(&out, ticket));

    var too_large: [frame.max_plaintext_len]u8 = @splat(0);
    ticket = base;
    ticket.ticket = &too_large;
    try testing.expectError(error.TicketTooLarge, encode(&out, ticket));

    ticket = base;
    ticket.ticket = out[20..21];
    try testing.expectError(error.InputAliasesOutput, encode(&out, ticket));

    try testing.expectError(error.BufferTooShort, encode(out[0..10], base));
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

// RFC 8701 §4 — GREASE server-initiated NewSessionTicket extensions are ignored
// like any other unknown extension.
test "parse: skips GREASE ticket extension" {
    const msg = [_]u8{
        0x04, 0x00, 0x00, 0x17,
        0x00, 0x00, 0x0e, 0x10,
        0x12, 0x34, 0x56, 0x78,
        0x02, 0xaa, 0xbb, 0x00,
        0x02, 0xcc, 0xdd, 0x00,
        0x06, 0x0a, 0x0a, 0x00,
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
    try testing.expectError(error.DuplicateExtension, parse(&msg));
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
    try fuzz_compat.fuzzBytes(fuzzParse, {}, .{});
}
