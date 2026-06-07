//! Fixed-capacity buffer backed by an array.
//!
//! Useful for building messages or accumulating bytes without heap allocation.
const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;
const Alignment = std.mem.Alignment;

pub fn SliceBuffer(comptime T: type) type {
    return struct {
        const Self = @This();

        buffer: []T,
        len: usize,

        pub const empty: Self = .{ .buffer = &.{}, .len = 0 };

        pub fn init(buffer: []T) Self {
            return .{ .buffer = buffer, .len = 0 };
        }

        pub fn constSlice(self: *const Self) []const T {
            return self.buffer[0..self.len];
        }

        pub fn slice(self: *Self) []T {
            return self.buffer[0..self.len];
        }

        pub fn fullSlice(self: *Self) []T {
            return self.buffer;
        }

        pub fn unusedCapacitySlice(self: *Self) []T {
            return self.buffer[self.len..];
        }

        pub fn remainingCapacity(self: *const Self) usize {
            return self.buffer.len - self.len;
        }

        pub fn appendSlice(self: *Self, items: []const T) error{NoSpaceLeft}!void {
            if (items.len > self.remainingCapacity()) return error.NoSpaceLeft;
            self.appendSliceAssumeCapacity(items);
        }

        pub fn appendSliceAssumeCapacity(self: *Self, items: []const T) void {
            assert(items.len <= self.remainingCapacity());
            @memcpy(self.unusedCapacitySlice()[0..items.len], items);
            self.len += items.len;
        }

        pub fn retainFrom(self: *Self, items: []const T) error{NoSpaceLeft}!void {
            if (items.len > self.buffer.len) return error.NoSpaceLeft;
            @memmove(self.buffer[0..items.len], items);
            self.len = items.len;
        }

        pub fn clear(self: *Self) void {
            self.len = 0;
        }

        pub fn secureZero(self: *Self) void {
            std.crypto.secureZero(T, self.fullSlice());
            self.len = 0;
        }
    };
}

pub fn ArrayBuffer(comptime T: type, comptime buffer_capacity: comptime_int) type {
    return ArrayBufferAligned(T, .of(T), buffer_capacity);
}

fn ArrayBufferAligned(
    comptime T: type,
    comptime alignment: Alignment,
    comptime buffer_capacity: comptime_int,
) type {
    return struct {
        const Self = @This();

        pub const Index = std.math.IntFittingRange(0, buffer_capacity);
        pub const capacity: Index = @intCast(buffer_capacity);

        buffer: [capacity]T align(alignment.toByteUnits()),
        len: Index,

        pub const empty: Self = .{ .buffer = undefined, .len = 0 };

        pub fn constSlice(self: *const Self) []align(alignment.toByteUnits()) const T {
            return self.buffer[0..self.len];
        }

        pub fn slice(self: *Self) switch (@TypeOf(&self.buffer)) {
            *align(alignment.toByteUnits()) [capacity]T => []align(alignment.toByteUnits()) T,
            // ziglint-ignore: Z024
            *align(alignment.toByteUnits()) const [capacity]T => []align(alignment.toByteUnits()) const T,
            else => unreachable,
        } {
            return self.buffer[0..self.len];
        }

        pub fn fullSlice(self: *Self) []align(alignment.toByteUnits()) T {
            return &self.buffer;
        }

        pub fn unusedCapacitySlice(self: *Self) []align(alignment.toByteUnits()) T {
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
            self.buffer[self.len] = item;
            self.len += 1;
        }

        pub fn appendSlice(self: *Self, items: []const T) error{NoSpaceLeft}!void {
            if (items.len > self.remainingCapacity()) return error.NoSpaceLeft;
            self.appendSliceAssumeCapacity(items);
        }

        pub fn appendSliceAssumeCapacity(self: *Self, items: []const T) void {
            assert(items.len <= self.remainingCapacity());
            @memcpy(self.unusedCapacitySlice()[0..items.len], items);
            self.len += @intCast(items.len);
        }

        /// Return the element at index `i` of the slice.
        pub fn get(self: *const Self, i: usize) T {
            return self.constSlice()[i];
        }

        /// Set the value of the element at index `i` of the slice.
        pub fn set(self: *Self, i: usize, item: T) void {
            self.slice()[i] = item;
        }

        pub fn resize(self: *Self, len: Index) void {
            assert(len <= self.buffer.len);
            self.len = len;
        }

        pub fn clear(self: *Self) void {
            self.len = 0;
        }

        pub fn secureZero(self: *Self) void {
            std.crypto.secureZero(T, self.fullSlice());
            self.len = 0;
        }
    };
}

test "SliceBuffer: append and retain" {
    var storage: [8]u8 = undefined;
    var buf: SliceBuffer(u8) = .init(&storage);

    try buf.appendSlice("hello");
    try testing.expectEqualStrings("hello", buf.constSlice());
    try buf.retainFrom(buf.constSlice()[2..]);
    try testing.expectEqualStrings("llo", buf.constSlice());
}

test "append and slice" {
    var buf: ArrayBuffer(u8, 32) = .empty;

    try buf.appendSlice("hello");
    try testing.expectEqualStrings("hello", buf.constSlice());

    try buf.appendSlice(" world");
    try testing.expectEqualStrings("hello world", buf.constSlice());
}

test "appendAssumeCapacity" {
    var buf: ArrayBuffer(u8, 16) = .empty;

    buf.appendSliceAssumeCapacity("test");
    try testing.expectEqualStrings("test", buf.constSlice());
    try testing.expectEqual(12, buf.remainingCapacity());
}

test "secureZero clears full storage and length" {
    var buf: ArrayBuffer(u8, 8) = .empty;
    try buf.appendSlice("secret");
    buf.secureZero();

    try testing.expectEqual(@as(usize, 0), buf.len);
    try testing.expectEqualSlices(u8, &.{ 0, 0, 0, 0, 0, 0, 0, 0 }, buf.fullSlice());
}

test "append returns error on overflow" {
    var buf: ArrayBuffer(u8, 4) = .empty;

    try buf.appendSlice("hi");
    try testing.expectError(error.NoSpaceLeft, buf.appendSlice("hello"));
    try testing.expectEqualStrings("hi", buf.constSlice());
}

test "clear resets length" {
    var buf: ArrayBuffer(u8, 16) = .empty;

    try buf.appendSlice("data");
    try testing.expectEqual(4, buf.len);

    buf.clear();
    try testing.expectEqual(0, buf.len);
    try testing.expectEqualStrings("", buf.constSlice());
}
