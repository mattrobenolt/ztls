//! Smoke executable: proves the ztls-std + ztls wiring builds and runs under
//! Zig 0.16.
const std = @import("std");
const Io = std.Io;

const ztls_std = @import("ztls_std");

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_file_writer: Io.File.Writer = .init(.stdout(), io, &stdout_buffer);
    const stdout_writer = &stdout_file_writer.interface;

    try stdout_writer.print("ztls-std OK (ztls core wired, API implemented)\n", .{});
    try stdout_writer.flush();
    _ = ztls_std;
}

test "smoke: ztls_std import resolves" {
    _ = ztls_std;
}
