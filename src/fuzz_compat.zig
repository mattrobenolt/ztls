//! Compatibility layer for byte-slice fuzz targets across Zig std.testing APIs.
const builtin = @import("builtin");
const std = @import("std");
const testing = std.testing;

const max_input_len = 64 * 1024;

pub fn fuzzBytes(
    comptime testOne: anytype,
    context: anytype,
    options: testing.FuzzInputOptions,
) anyerror!void {
    if (comptime builtin.zig_version.major == 0 and builtin.zig_version.minor < 16) {
        return testing.fuzz(context, testOne, options);
    }

    const Wrapper = struct {
        fn run(ctx: @TypeOf(context), smith: *testing.Smith) anyerror!void {
            var buf: [max_input_len]u8 = undefined;
            const len = smith.slice(&buf);
            return testOne(ctx, buf[0..len]);
        }
    };

    return testing.fuzz(context, Wrapper.run, options);
}
