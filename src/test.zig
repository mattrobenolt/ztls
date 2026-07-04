const std = @import("std");
const ztls = @import("root.zig");

pub fn hex(comptime len: usize, comptime encoded: []const u8) [len]u8 {
    var out: [len]u8 = @splat(0);
    _ = std.fmt.hexToBytes(&out, encoded) catch unreachable;
    return out;
}

test {
    std.testing.refAllDeclsRecursive(ztls);
    _ = @import("wycheproof.zig");
    _ = @import("interop.zig");
    _ = @import("crypto/backend_primitive_tests.zig");
}
