//! TLS Alert protocol.
//!
//! RFC 8446 §6
const std = @import("std");
const testing = std.testing;

const frame = @import("frame.zig");

pub const Level = enum(u8) {
    warning = 1,
    fatal = 2,
    _,
};

pub const Description = enum(u8) {
    close_notify = 0,
    unexpected_message = 10,
    bad_record_mac = 20,
    record_overflow = 22,
    handshake_failure = 40,
    bad_certificate = 42,
    unsupported_certificate = 43,
    certificate_revoked = 44,
    certificate_expired = 45,
    certificate_unknown = 46,
    illegal_parameter = 47,
    unknown_ca = 48,
    access_denied = 49,
    decode_error = 50,
    decrypt_error = 51,
    protocol_version = 70,
    insufficient_security = 71,
    internal_error = 80,
    inappropriate_fallback = 86,
    user_canceled = 90,
    missing_extension = 109,
    unsupported_extension = 110,
    unrecognized_name = 112,
    bad_certificate_status_response = 113,
    unknown_psk_identity = 115,
    certificate_required = 116,
    no_application_protocol = 120,
    _,
};

pub const Alert = struct {
    level: Level,
    description: Description,

    pub inline fn isCloseNotify(self: Alert) bool {
        return self.description == .close_notify;
    }

    pub inline fn isFatal(self: Alert) bool {
        return self.level == .fatal and !self.isCloseNotify();
    }
};

pub const ParseError = error{UnexpectedEof};

pub fn parse(msg: []const u8) ParseError!Alert {
    if (msg.len < 2) return error.UnexpectedEof;
    return .{
        .level = @enumFromInt(msg[0]),
        .description = @enumFromInt(msg[1]),
    };
}

pub fn encode(out: []u8, level: Level, description: Description) error{BufferTooShort}![]u8 {
    if (out.len < 2) return error.BufferTooShort;
    out[0] = @intFromEnum(level);
    out[1] = @intFromEnum(description);
    return out[0..2];
}

pub fn plaintextRecord(msg: *const [2]u8, out: []u8) error{BufferTooShort}![]u8 {
    const total = frame.header_len + msg.len;
    if (out.len < total) return error.BufferTooShort;
    const header: frame.Header = .init(.alert, msg.len);
    header.write(out[0..frame.header_len]);
    out[frame.header_len..][0..msg.len].* = msg.*;
    return out[0..total];
}

// RFC 8446 §6.1 — closure alerts
test "parse: close_notify" {
    const a = try parse(&.{ 1, 0 });
    try testing.expectEqual(.warning, a.level);
    try testing.expectEqual(.close_notify, a.description);
    try testing.expect(a.isCloseNotify());
}

// RFC 8446 §6.2 — error alerts
test "parse: fatal unexpected_message" {
    const a = try parse(&.{ 2, 10 });
    try testing.expectEqual(.fatal, a.level);
    try testing.expectEqual(.unexpected_message, a.description);
    try testing.expect(a.isFatal());
}

test "parse: truncated" {
    try testing.expectError(error.UnexpectedEof, parse(&.{1}));
}

test "encode" {
    var buf: [2]u8 = undefined;
    try testing.expectEqualSlices(u8, &.{ 2, 50 }, try encode(&buf, .fatal, .decode_error));
}

// RFC 8446 §6 — Alert messages are exactly two bytes; fuzz arbitrary inputs to
// ensure parse rejects truncation and never crashes. Run with `zig build test --fuzz`.
fn fuzzParse(_: void, input: []const u8) anyerror!void {
    _ = parse(input) catch return;
}

test "fuzz: parse handles arbitrary input" {
    try testing.fuzz({}, fuzzParse, .{ .corpus = &.{ &.{ 1, 0 }, &.{ 2, 10 } } });
}
