//! TLS wire format writing primitives.
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

    /// Append a value in big-endian byte order.
    ///
    /// Supports:
    ///   - Integer types (u8, u16, u24, u32, ...): written big-endian
    ///   - Enum types: written as their backing integer, big-endian
    /// For byte slices and arrays, use appendSlice instead.
    pub fn append(self: *Writer, comptime T: type, value: T) void {
        switch (@typeInfo(T)) {
            .int => {
                const n = comptime @divExact(@bitSizeOf(T), 8);
                assert(self.pos + n <= self.buf.len);
                inline for (0..n) |i| {
                    self.buf[self.pos + i] = @intCast((value >> ((n - 1 - i) * 8)) & 0xff);
                }
                self.pos += n;
            },
            .@"enum" => |info| self.append(info.tag_type, @intFromEnum(value)),
            else => @compileError("Writer.append: unsupported type " ++ @typeName(T)),
        }
    }

    /// Append a runtime-length byte slice.
    pub fn appendSlice(self: *Writer, data: []const u8) void {
        assert(self.pos + data.len <= self.buf.len);
        @memcpy(self.buf[self.pos..][0..data.len], data);
        self.pos += data.len;
    }

    /// Reserve `n` bytes in the buffer and return a pointer to them.
    /// The caller writes directly into the returned pointer.
    pub fn reserve(self: *Writer, comptime n: usize) *[n]u8 {
        assert(self.pos + n <= self.buf.len);
        const ptr = self.buf[self.pos..][0..n];
        self.pos += n;
        return ptr;
    }

    /// Return the slice of bytes written so far.
    pub fn written(self: *const Writer) []u8 {
        return self.buf[0..self.pos];
    }
};

/// A forward-only reader over a caller-owned byte slice.
///
/// Returns `error.UnexpectedEof` if a read would go past the end of the buffer.
/// At the handshake message level this always indicates a protocol error, since
/// `RecordLayer.decrypt` guarantees a complete decrypted payload.
pub const Reader = struct {
    buf: []const u8,
    pos: usize = 0,

    pub fn init(buf: []const u8) Reader {
        return .{ .buf = buf };
    }

    /// Read a value of type T from the buffer in big-endian byte order.
    ///
    /// Supports integer and enum types.
    pub fn read(self: *Reader, comptime T: type) !T {
        switch (@typeInfo(T)) {
            .int => {
                const n = comptime @divExact(@bitSizeOf(T), 8);
                if (self.pos + n > self.buf.len) return error.UnexpectedEof;
                var value: u64 = 0;
                inline for (0..n) |i| {
                    value = (value << 8) | self.buf[self.pos + i];
                }
                self.pos += n;
                assert(value <= std.math.maxInt(T));
                return @intCast(value);
            },
            .@"enum" => |info| {
                const tag = try self.read(info.tag_type);
                return std.enums.fromInt(T, tag) orelse return error.InvalidEnumTag;
            },
            else => @compileError("Reader.read: unsupported type " ++ @typeName(T)),
        }
    }

    /// Return a zero-copy slice of `n` bytes and advance.
    pub fn readSlice(self: *Reader, n: usize) error{UnexpectedEof}![]const u8 {
        if (self.pos + n > self.buf.len) return error.UnexpectedEof;
        const s = self.buf[self.pos..][0..n];
        self.pos += n;
        return s;
    }

    /// Skip `n` bytes.
    pub fn skip(self: *Reader, n: usize) error{UnexpectedEof}!void {
        if (self.pos + n > self.buf.len) return error.UnexpectedEof;
        self.pos += n;
    }

    /// Return unread bytes remaining in the buffer.
    pub fn remaining(self: *const Reader) []const u8 {
        return self.buf[self.pos..];
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

test "Writer.append: enum" {
    const E = enum(u16) { foo = 0x001d };
    var buf: [2]u8 = undefined;
    var w: Writer = .init(&buf);
    w.append(E, .foo);
    try testing.expectEqualSlices(u8, &.{ 0x00, 0x1d }, w.written());
}

test "Reader.read: u8" {
    var r: Reader = .init(&.{ 0xab, 0xcd });
    try testing.expectEqual(@as(u8, 0xab), try r.read(u8));
    try testing.expectEqual(@as(u8, 0xcd), try r.read(u8));
}

test "Reader.read: u16 big-endian" {
    var r: Reader = .init(&.{ 0x03, 0x04 });
    try testing.expectEqual(@as(u16, 0x0304), try r.read(u16));
}

test "Reader.read: enum" {
    const E = enum(u16) { foo = 0x001d };
    var r: Reader = .init(&.{ 0x00, 0x1d });
    try testing.expectEqual(E.foo, try r.read(E));
}

test "Reader.readSlice: zero-copy" {
    const buf = [_]u8{ 0x01, 0x02, 0x03 };
    var r: Reader = .init(&buf);
    const s = try r.readSlice(2);
    try testing.expectEqualSlices(u8, &.{ 0x01, 0x02 }, s);
    try testing.expectEqual(@as(usize, 1), r.remaining().len);
}

test "Reader.read: UnexpectedEof" {
    var r: Reader = .init(&.{0x01});
    try testing.expectError(error.UnexpectedEof, r.read(u16));
}

test "Writer.reserve: write directly into buffer" {
    var buf: [4]u8 = undefined;
    var w: Writer = .init(&buf);
    w.append(u8, 0x01);
    const slot = w.reserve(2);
    slot.* = .{ 0x02, 0x03 };
    w.append(u8, 0x04);
    try testing.expectEqualSlices(u8, &.{ 0x01, 0x02, 0x03, 0x04 }, w.written());
}

test "Writer: sequential appends" {
    var buf: [8]u8 = undefined;
    var w: Writer = .init(&buf);
    w.append(u8, 0x01);
    w.append(u16, 0x0303);
    w.append(u24, 0x0000c0);
    try testing.expectEqualSlices(u8, &.{ 0x01, 0x03, 0x03, 0x00, 0x00, 0xc0 }, w.written());
}
