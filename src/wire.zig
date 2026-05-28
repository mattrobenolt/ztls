/// TLS wire format writing primitives.
const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;

/// A forward-only writer into a caller-owned buffer.
///
/// Tracks the current position. Call `written()` to get the filled slice.
pub const Writer = struct {
    buf: []u8,
    pos: usize = 0,

    pub fn init(buf: []u8) Writer {
        return .{ .buf = buf };
    }

    /// Append an integer value in big-endian byte order.
    ///
    /// Supports any integer type: u8, u16, u24, u32, etc.
    /// For byte slices and arrays, use appendSlice instead.
    pub fn append(self: *Writer, comptime T: type, value: T) void {
        comptime assert(@typeInfo(T) == .int);
        const n = comptime @divExact(@bitSizeOf(T), 8);
        assert(self.pos + n <= self.buf.len);
        inline for (0..n) |i| {
            self.buf[self.pos + i] = @intCast((value >> ((n - 1 - i) * 8)) & 0xff);
        }
        self.pos += n;
    }

    /// Append a runtime-length byte slice.
    pub fn appendSlice(self: *Writer, data: []const u8) void {
        assert(self.pos + data.len <= self.buf.len);
        @memcpy(self.buf[self.pos..][0..data.len], data);
        self.pos += data.len;
    }

    /// Return the slice of bytes written so far.
    pub fn written(self: *const Writer) []u8 {
        return self.buf[0..self.pos];
    }
};

test "Writer.append: u8" {
    var buf: [4]u8 = undefined;
    var w: Writer = .init(&buf);
    w.append(u8, 0xab);
    try testing.expectEqualSlices(u8, &.{0xab}, w.written());
}

test "Writer.append: u16 big-endian" {
    var buf: [4]u8 = undefined;
    var w: Writer = .init(&buf);
    w.append(u16, 0x0304);
    try testing.expectEqualSlices(u8, &.{ 0x03, 0x04 }, w.written());
}

test "Writer.append: u24 big-endian" {
    var buf: [4]u8 = undefined;
    var w: Writer = .init(&buf);
    w.append(u24, 0x0000c0);
    try testing.expectEqualSlices(u8, &.{ 0x00, 0x00, 0xc0 }, w.written());
}

test "Writer.appendSlice" {
    var buf: [8]u8 = undefined;
    var w: Writer = .init(&buf);
    w.appendSlice("hello");
    try testing.expectEqualSlices(u8, "hello", w.written());
}

test "Writer: sequential appends" {
    var buf: [8]u8 = undefined;
    var w: Writer = .init(&buf);
    w.append(u8, 0x01);
    w.append(u16, 0x0303);
    w.append(u24, 0x0000c0);
    try testing.expectEqualSlices(u8, &.{ 0x01, 0x03, 0x03, 0x00, 0x00, 0xc0 }, w.written());
}
