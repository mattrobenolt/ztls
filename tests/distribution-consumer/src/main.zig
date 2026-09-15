const std = @import("std");
const ztls = @import("ztls");
const integration = @import("integration");
const options = @import("consumer_options");

comptime {
    _ = ztls.RecordBuffer;
    if (std.mem.eql(u8, options.mode, "core")) {
        _ = integration.ClientHandshake;
    } else {
        _ = integration.Client;
    }
}

pub fn main() void {}
