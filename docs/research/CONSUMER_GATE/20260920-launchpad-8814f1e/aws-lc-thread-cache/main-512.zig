const std = @import("std");
extern "c" fn RAND_bytes(output: [*]u8, len: usize) c_int;
extern "c" fn ERR_set_mark() c_int;
fn exercise() void {
    var output: [32]u8 = undefined;
    for (0..512) |_| {
        _ = ERR_set_mark();
        std.debug.assert(RAND_bytes(&output, output.len) == 1);
    }
}
pub fn main() void {
    exercise();
}
