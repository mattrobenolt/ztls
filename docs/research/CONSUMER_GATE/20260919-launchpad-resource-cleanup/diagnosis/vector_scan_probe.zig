const std = @import("std");

noinline fn scan(input: *const [16]u8, use_or: bool) bool {
    const value = if (use_or) asm volatile (
        \\ldr q0, [%[input]]
        \\cmeq v0.16b, v0.16b, #0
        \\ext v1.16b, v0.16b, v0.16b, #8
        \\orr v0.16b, v0.16b, v1.16b
        \\fmov %[result], d0
        : [result] "=r" (-> u64),
        : [input] "r" (input),
        : .{ .v0 = true, .v1 = true }
    ) else asm volatile (
        \\ldr q0, [%[input]]
        \\cmeq v0.16b, v0.16b, #0
        \\umaxp v0.4s, v0.4s, v0.4s
        \\fmov %[result], d0
        : [result] "=r" (-> u64),
        : [input] "r" (input),
        : .{ .v0 = true }
    );
    return value != 0;
}

noinline fn check(index: usize, initialize: bool, use_or: bool) !void {
    var input: [16]u8 align(16) = undefined;
    if (initialize) @memset(&input, 0);
    @memset(input[0..index], 'a');
    input[index] = 0;
    if (!scan(&input, use_or)) return error.MissedTerminator;
}

pub fn main() !void {
    const initialize = std.posix.getenv("ZERO_TAIL") != null;
    const use_or = std.posix.getenv("USE_OR") != null;
    for (0..16) |index| try check(index, initialize, use_or);
    std.debug.print("all 16 terminator positions detected\n", .{});
}
