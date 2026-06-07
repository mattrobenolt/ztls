//! Fixed-capacity, length-tracked array buffer.
//!
//! Useful for public Sans-I/O APIs that need caller-owned storage but should not
//! make callers juggle a bare array and a detached length.
const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;

pub fn ArrayBuffer(comptime T: type, comptime buffer_capacity: comptime_int) type {
    return struct {
        const Self = @This();

        pub const Index = std.math.IntFittingRange(0, buffer_capacity);
        pub const capacity: Index = @intCast(buffer_capacity);

        buffer: [capacity]T,
        len: Index,

        pub const empty: Self = .{ .buffer = undefined, .len = 0 };

        pub fn constSlice(self: *const Self) []const T {
            return self.buffer[0..self.len];
        }

        pub fn slice(self: *Self) []T {
            return self.buffer[0..self.len];
        }

        pub fn fullSlice(self: *Self) []T {
            return &self.buffer;
        }

        pub fn unusedCapacitySlice(self: *Self) []T {
            return self.buffer[self.len..];
        }

        pub fn remainingCapacity(self: *const Self) Index {
            return capacity - self.len;
        }

        pub fn append(self: *Self, item: T) error{NoSpaceLeft}!void {
            if (self.remainingCapacity() == 0) return error.NoSpaceLeft;
            self.appendAssumeCapacity(item);
        }

        pub fn appendAssumeCapacity(self: *Self, item: T) void {
            assert(self.len < capacity);
            self.buffer[self.len] = item;
            self.len += 1;
        }

        pub fn appendSlice(self: *Self, items: []const T) error{NoSpaceLeft}!void {
            if (items.len > self.remainingCapacity()) return error.NoSpaceLeft;
            self.appendSliceAssumeCapacity(items);
        }

        pub fn appendSliceAssumeCapacity(self: *Self, items: []const T) void {
            assert(items.len <= self.remainingCapacity());
            @memmove(self.unusedCapacitySlice()[0..items.len], items);
            self.len += @intCast(items.len);
        }

        pub fn resize(self: *Self, len: Index) void {
            self.len = len;
        }

        pub fn clear(self: *Self) void {
            self.len = 0;
        }
    };
}

// ztls Sans-I/O buffer contract — fixed-capacity builders retain caller-owned storage.
test "ArrayBuffer: append and slice" {
    var buf: ArrayBuffer(u8, 32) = .empty;

    try buf.appendSlice("hello");
    try testing.expectEqualStrings("hello", buf.constSlice());

    try buf.appendSlice(" world");
    try testing.expectEqualStrings("hello world", buf.constSlice());
}

// ztls Sans-I/O buffer contract — overflow is reported, never allocated around.
test "ArrayBuffer: overflow returns NoSpaceLeft" {
    var buf: ArrayBuffer(u8, 4) = .empty;

    try buf.appendSlice("hi");
    try testing.expectError(error.NoSpaceLeft, buf.appendSlice("hello"));
    try testing.expectEqualStrings("hi", buf.constSlice());
}

// ztls Sans-I/O buffer contract — clearing preserves capacity and resets visible bytes.
test "ArrayBuffer: clear resets length" {
    var buf: ArrayBuffer(u8, 16) = .empty;

    try buf.appendSlice("data");
    try testing.expectEqual(@as(@TypeOf(buf).Index, 4), buf.len);

    buf.clear();
    try testing.expectEqual(@as(@TypeOf(buf).Index, 0), buf.len);
    try testing.expectEqualStrings("", buf.constSlice());
}
