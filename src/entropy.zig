//! Platform entropy for keypair convenience constructors.
//!
//! This stays intentionally narrower than `std.Io`: ztls core remains Sans-I/O,
//! while key generation needs only the local OS CSPRNG syscall.
const std = @import("std");
const testing = std.testing;
const builtin = @import("builtin");

pub fn fill(buf: []u8) void {
    switch (builtin.os.tag) {
        .linux => fillLinux(buf),
        .macos => std.c.arc4random_buf(buf.ptr, buf.len),
        else => @compileError("ztls entropy shim supports only Linux and macOS"),
    }
}

fn fillLinux(buf: []u8) void {
    var remaining = buf;
    while (remaining.len != 0) {
        const rc = std.os.linux.getrandom(remaining.ptr, remaining.len, 0);
        const signed_rc: isize = @bitCast(rc);
        if (signed_rc >= 0) {
            remaining = remaining[@intCast(signed_rc)..];
            continue;
        }

        const errno: usize = @intCast(-signed_rc);
        switch (errno) {
            4, 11 => continue, // EINTR, EAGAIN
            else => @panic("getrandom failed"),
        }
    }
}

test "fill writes caller buffer" {
    var buf: [32]u8 = @splat(0);
    fill(&buf);

    var zeroes: [32]u8 = @splat(0);
    try testing.expect(!std.mem.eql(u8, &buf, &zeroes));
}
