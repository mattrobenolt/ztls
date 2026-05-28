/// Extensions to std.mem for ztls.
///
/// TLS is entirely big-endian, so readInt/writeInt drop the endian argument.
const std = @import("std");
const mem = std.mem;
const assert = std.debug.assert;
const testing = std.testing;

/// A named, fixed-size byte array. Wraps [len]u8 as a distinct type so that
/// semantically different values (e.g. Prk vs SharedSecret) cannot be
/// accidentally substituted for one another at compile time.
pub fn Array(comptime len: comptime_int) type {
    return struct {
        const Self = @This();
        const Data = [len]u8;

        data: Data,

        pub inline fn init(data: Data) Self {
            return .{ .data = data };
        }
    };
}

pub inline fn readInt(comptime T: type, buf: *const [@divExact(@bitSizeOf(T), 8)]u8) T {
    return mem.readInt(T, buf, .big);
}

pub inline fn writeInt(comptime T: type, buf: *[@divExact(@bitSizeOf(T), 8)]u8, value: T) void {
    mem.writeInt(T, buf, value, .big);
}

pub inline fn toBytes(comptime T: type, value: T) [@sizeOf(T)]u8 {
    return mem.toBytes(mem.nativeTo(T, value, .big));
}

const vector_chunk_len = @min(std.simd.suggestVectorLength(u8) orelse 16, 32);

/// Return the index of the last non-zero byte in `buf`, or null if all zeros.
///
/// Fast path: if the last byte is non-zero, returns immediately.
/// SIMD path: processes `chunk_len` bytes at a time backwards, where
/// `chunk_len` is target-optimal (suggestVectorLength), defaulting to 16
/// and capped at 32.
/// Scalar path: handles the remaining prefix shorter than `chunk_len`.
///
/// `buf` must be non-empty — caller is responsible for ensuring this.
pub fn lastIndexOfNonZero(buf: []const u8) ?usize {
    assert(buf.len > 0);

    var i = buf.len - 1;
    if (buf[i] != 0) return i;

    const Vec = @Vector(vector_chunk_len, u8);
    const zero: Vec = @splat(0);

    while (i >= vector_chunk_len) {
        i -= vector_chunk_len;
        const chunk: Vec = buf[i..][0..vector_chunk_len].*;
        if (@reduce(.Or, chunk != zero)) {
            var j: usize = vector_chunk_len - 1;
            while (true) {
                if (buf[i + j] != 0) return i + j;
                if (j == 0) break;
                j -= 1;
            }
        }
    }

    while (i > 0) {
        i -= 1;
        if (buf[i] != 0) return i;
    }

    return null;
}

test "lastIndexOfNonZero: last byte non-zero (fast path)" {
    const buf = [_]u8{ 0, 0, 0, 0xab };
    try testing.expectEqual(@as(?usize, 3), lastIndexOfNonZero(&buf));
}

test "lastIndexOfNonZero: all zeros" {
    const buf = [_]u8{ 0, 0, 0, 0 };
    try testing.expectEqual(@as(?usize, null), lastIndexOfNonZero(&buf));
}

test "lastIndexOfNonZero: single non-zero byte at start" {
    const buf = [_]u8{ 0xab, 0, 0, 0 };
    try testing.expectEqual(@as(?usize, 0), lastIndexOfNonZero(&buf));
}

test "lastIndexOfNonZero: single byte, non-zero" {
    const buf = [_]u8{0xab};
    try testing.expectEqual(@as(?usize, 0), lastIndexOfNonZero(&buf));
}

test "lastIndexOfNonZero: single byte, zero" {
    const buf = [_]u8{0};
    try testing.expectEqual(@as(?usize, null), lastIndexOfNonZero(&buf));
}

test "lastIndexOfNonZero: non-zero in scalar tail" {
    // 3 bytes — below any chunk_len, exercises the scalar fallback
    const buf = [_]u8{ 0, 0xab, 0 };
    try testing.expectEqual(@as(?usize, 1), lastIndexOfNonZero(&buf));
}

test "lastIndexOfNonZero: exactly chunk_len bytes, non-zero at start" {
    var buf = [_]u8{0} ** vector_chunk_len;
    buf[0] = 0xab;
    try testing.expectEqual(@as(?usize, 0), lastIndexOfNonZero(&buf));
}

test "lastIndexOfNonZero: exactly chunk_len bytes, all zeros" {
    const buf = [_]u8{0} ** vector_chunk_len;
    try testing.expectEqual(@as(?usize, null), lastIndexOfNonZero(&buf));
}

test "lastIndexOfNonZero: large buffer, non-zero in first chunk" {
    var buf = [_]u8{0} ** (vector_chunk_len * 4);
    buf[1] = 0xab; // in the first chunk, not last byte
    try testing.expectEqual(@as(?usize, 1), lastIndexOfNonZero(&buf));
}

test "lastIndexOfNonZero: large buffer, non-zero in middle chunk" {
    var buf = [_]u8{0} ** (vector_chunk_len * 4);
    buf[vector_chunk_len + 3] = 0xab;
    try testing.expectEqual(@as(?usize, vector_chunk_len + 3), lastIndexOfNonZero(&buf));
}

test "lastIndexOfNonZero: large buffer, all zeros" {
    const buf = [_]u8{0} ** (vector_chunk_len * 4);
    try testing.expectEqual(@as(?usize, null), lastIndexOfNonZero(&buf));
}
