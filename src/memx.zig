/// Extensions to std.mem for ztls.
///
/// TLS is entirely big-endian, so readInt/writeInt drop the endian argument.
const mem = @import("std").mem;

pub inline fn readInt(comptime T: type, buf: *const [@divExact(@bitSizeOf(T), 8)]u8) T {
    return mem.readInt(T, buf, .big);
}

pub inline fn writeInt(comptime T: type, buf: *[@divExact(@bitSizeOf(T), 8)]u8, value: T) void {
    mem.writeInt(T, buf, value, .big);
}
