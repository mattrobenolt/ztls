/// Extensions to std.mem for ztls.
///
/// TLS is entirely big-endian, so readInt/writeInt drop the endian argument.
const std = @import("std");
const mem = std.mem;
const assert = std.debug.assert;

pub inline fn readInt(comptime T: type, buf: *const [@divExact(@bitSizeOf(T), 8)]u8) T {
    return mem.readInt(T, buf, .big);
}

pub inline fn writeInt(comptime T: type, buf: *[@divExact(@bitSizeOf(T), 8)]u8, value: T) void {
    mem.writeInt(T, buf, value, .big);
}

pub inline fn toBytes(comptime T: type, value: T) [@sizeOf(T)]u8 {
    return mem.toBytes(mem.nativeTo(T, value, .big));
}

/// Return the index of the last non-zero byte in `buf`, or null if all zeros.
///
/// Processes 16 bytes at a time using SIMD, falling back to scalar for the
/// remaining prefix. std.mem.lastIndexOfNone compiles to a scalar loop even
/// at ReleaseFast, so we hand-roll this.
pub fn lastIndexOfNonZero(buf: []const u8) ?usize {
    assert(buf.len > 0);
    if (buf[buf.len - 1] != 0) return buf.len - 1;

    const chunk_len = @min(std.simd.suggestVectorLength(u8) orelse 16, 32);
    const Vec = @Vector(chunk_len, u8);
    const zero: Vec = @splat(0);

    var i = buf.len - 1;

    while (i >= chunk_len) {
        i -= chunk_len;
        const chunk: Vec = buf[i..][0..chunk_len].*;
        if (@reduce(.Or, chunk != zero)) {
            var j: usize = chunk_len - 1;
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
