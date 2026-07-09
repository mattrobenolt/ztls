const std = @import("std");
const builtin = @import("builtin");
const testing = std.testing;
const assert = std.debug.assert;
const ztls = @import("root.zig");

pub fn hex(comptime len: usize, comptime encoded: []const u8) [len]u8 {
    // Catch length mismatches at compile time: hexToBytes would otherwise
    // silently zero-fill `out` when `encoded` is shorter than `2*len`,
    // corrupting vectors with trailing zeros (this bit a Wycheproof P-384
    // ECDSA signature during #60-A). Require an exact match.
    comptime assert(encoded.len == 2 * len);
    var out: [len]u8 = @splat(0);
    _ = std.fmt.hexToBytes(&out, encoded) catch unreachable;
    return out;
}

fn refAllDeclsRecursive(comptime T: type) void {
    if (!builtin.is_test) return;
    inline for (comptime std.meta.declarations(T)) |decl| {
        if (@TypeOf(@field(T, decl.name)) == type) {
            switch (@typeInfo(@field(T, decl.name))) {
                .@"struct",
                .@"enum",
                .@"union",
                .@"opaque",
                => refAllDeclsRecursive(@field(T, decl.name)),
                else => {},
            }
        }
        _ = &@field(T, decl.name);
    }
}

test {
    refAllDeclsRecursive(ztls);
    _ = @import("wycheproof.zig");
    _ = @import("interop.zig");
    _ = @import("crypto/backend_primitive_tests.zig");
}
