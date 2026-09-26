//! Platform entropy for keypair convenience constructors.
//!
//! This stays intentionally narrower than `std.Io`: ztls core remains Sans-I/O,
//! while key generation needs only the local OS CSPRNG syscall.
const std = @import("std");
const testing = std.testing;
const c = std.c;
const posix = std.posix;
const linux = std.os.linux;
const panic = std.debug.panic;

/// Fill `buf` from the OS CSPRNG. Aborts the process if the OS CSPRNG is
/// unavailable — an unrecoverable condition (arc4random_buf cannot fail;
/// getrandom flags=0 only fails on EFAULT/EINVAL/ENOSYS, i.e. programming or
/// kernel bugs; EINTR is retried). Mirrors the syscall choice of std.Io's
/// randomSecure: arc4random_buf where the libc provides it, then getrandom.
pub fn fill(buf: []u8) void {
    // glibc >= 2.36 and musl provide arc4random_buf, which rides the getrandom
    // vDSO on kernels >= 6.11. ztls always links libc (libcrypto), so the
    // comptime decl check is the whole probe.
    if (@TypeOf(c.arc4random_buf) != void) {
        c.arc4random_buf(buf.ptr, buf.len);
        return;
    }

    // Older libc: getrandom. std.c.getrandom is void-typed where the libc
    // predates it (glibc < 2.25); fall back to the raw syscall there.
    const getrandom = if (@TypeOf(c.getrandom) != void) c.getrandom else linux.getrandom;
    var remaining = buf;
    while (remaining.len != 0) {
        const rc = getrandom(remaining.ptr, remaining.len, 0);
        switch (posix.errno(rc)) {
            .SUCCESS => remaining = remaining[@intCast(rc)..],
            .INTR => continue,
            else => |e| panic(
                "ztls: OS CSPRNG getrandom failed with {t}; " ++
                    "cannot generate key material without entropy",
                .{e},
            ),
        }
    }
}

test "fill writes caller buffer" {
    var buf: [32]u8 = @splat(0);
    fill(&buf);

    var zeroes: [32]u8 = @splat(0);
    try testing.expect(!std.mem.eql(u8, &buf, &zeroes));
}
