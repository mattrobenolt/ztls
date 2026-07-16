//! Smoke executable: proves the ztls-std + ztls wiring builds and runs under
//! Zig 0.16. The real demo (a TLS connection over std.Io.net) lands with #77.
const std = @import("std");
const Io = std.Io;

const ztls_std = @import("ztls_std");

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_file_writer: Io.File.Writer = .init(.stdout(), io, &stdout_buffer);
    const stdout_writer = &stdout_file_writer.interface;

    try stdout_writer.print("ztls-std scaffold OK (ztls core wired)\n", .{});
    try stdout_writer.flush();
    _ = ztls_std;
}

test "smoke: ztls_std import resolves" {
    _ = ztls_std;
}
