//! Adapter from std.testing.fuzz's Smith-driven input to byte-slice targets.
const std = @import("std");
const testing = std.testing;

const max_input_len = 64 * 1024;

pub fn fuzzBytes(
    comptime testOne: anytype,
    context: anytype,
    options: testing.FuzzInputOptions,
) anyerror!void {
    const Wrapper = struct {
        fn run(ctx: @TypeOf(context), smith: *testing.Smith) anyerror!void {
            var buf: [max_input_len]u8 = undefined;
            const len = smith.slice(&buf);
            return testOne(ctx, buf[0..len]);
        }
    };

    return testing.fuzz(context, Wrapper.run, options);
}
