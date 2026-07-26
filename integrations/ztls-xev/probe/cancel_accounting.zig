//! Does libxev keep `Loop.active` straight across cancel-then-close?
//!
//! Standalone because the answer is about libxev, not ztls: if the accounting
//! drifts, a loop stops waiting while real work is outstanding, and every
//! consumer that cancels an operation before closing its fd inherits the stall.
//! Runs every backend the host supports so the three can be compared directly.
//!
//! Prints, per backend: `active` after each step, whether each callback fired,
//! and whether the peer observes EOF once the fd is closed.
const std = @import("std");
const builtin = @import("builtin");
const xev = @import("xev");

fn Probe(comptime Xev: type) type {
    return struct {
        const Self = @This();
        read_fired: bool = false,
        read_err: ?anyerror = null,
        cancel_fired: bool = false,
        close_fired: bool = false,
        c_read: Xev.Completion = .{},
        c_cancel: Xev.Completion = .{},
        c_close: Xev.Completion = .{},
        buf: [64]u8 = undefined,

        fn onRead(
            s: ?*Self,
            _: *Xev.Loop,
            _: *Xev.Completion,
            _: Xev.TCP,
            _: Xev.ReadBuffer,
            r: Xev.ReadError!usize,
        ) Xev.CallbackAction {
            s.?.read_fired = true;
            _ = r catch |e| {
                s.?.read_err = e;
                return .disarm;
            };
            return .disarm;
        }

        fn onCancel(
            s: ?*Self,
            _: *Xev.Loop,
            _: *Xev.Completion,
            _: Xev.Result,
        ) Xev.CallbackAction {
            s.?.cancel_fired = true;
            return .disarm;
        }

        fn onClose(
            s: ?*Self,
            _: *Xev.Loop,
            _: *Xev.Completion,
            _: Xev.TCP,
            _: Xev.CloseError!void,
        ) Xev.CallbackAction {
            s.?.close_fired = true;
            return .disarm;
        }
    };
}

fn spin(loop: anytype, n: usize) !void {
    for (0..n) |_| {
        try loop.run(.no_wait);
        var ts: std.posix.timespec = .{ .sec = 0, .nsec = 200 * std.time.ns_per_us };
        _ = std.c.nanosleep(&ts, null);
    }
}

fn probe(comptime name: []const u8, comptime Xev: type) !void {
    var fds: [2]std.posix.fd_t = undefined;
    if (std.c.socketpair(std.posix.AF.UNIX, std.posix.SOCK.STREAM, 0, &fds) != 0)
        return error.SocketPair;
    defer _ = std.c.close(fds[1]);

    var pool: xev.ThreadPool = .init(.{});
    defer {
        pool.shutdown();
        pool.deinit();
    }
    var loop: Xev.Loop = try .init(.{ .thread_pool = &pool });
    defer loop.deinit();

    const P = Probe(Xev);
    var p: P = .{};
    const sock: Xev.TCP = .initFd(fds[0]);

    sock.read(&loop, &p.c_read, .{ .slice = &p.buf }, P, &p, P.onRead);
    try spin(&loop, 20);
    const after_read = loop.active;

    // Cancel the armed read, the way a close-with-work-in-flight has to.
    p.c_cancel = .{
        .op = .{ .cancel = .{ .c = &p.c_read } },
        .userdata = &p,
        .callback = struct {
            fn cb(
                ud: ?*anyopaque,
                l: *Xev.Loop,
                c: *Xev.Completion,
                r: Xev.Result,
            ) Xev.CallbackAction {
                return P.onCancel(@ptrCast(@alignCast(ud)), l, c, r);
            }
        }.cb,
    };
    loop.add(&p.c_cancel);
    try spin(&loop, 50);
    const after_cancel = loop.active;

    sock.close(&loop, &p.c_close, P, &p, P.onClose);
    try spin(&loop, 100);
    const after_close = loop.active;

    // Does the peer see the endpoint go away? Non-blocking, so a still-open fd
    // reports EAGAIN rather than hanging the probe.
    var peek: [1]u8 = undefined;
    const n = std.c.recv(fds[1], &peek, 1, std.posix.MSG.DONTWAIT);
    const peer = if (n == 0) "EOF" else if (n < 0) @tagName(std.posix.errno(n)) else "DATA";

    std.debug.print(
        "{s}: active after read={d} cancel={d} close={d} | " ++
            "read_cb={} cancel_cb={} close_cb={} read_err={?} | peer={s}\n",
        .{
            name,           after_read,    after_cancel, after_close, p.read_fired,
            p.cancel_fired, p.close_fired, p.read_err,   peer,
        },
    );
}

pub fn main() !void {
    std.debug.print("default backend = {t}\n", .{xev.backend});
    switch (builtin.os.tag) {
        .linux => {
            try probe("io_uring", xev.IO_Uring);
            try probe("epoll   ", xev.Epoll);
        },
        .macos => try probe("kqueue  ", xev.Kqueue),
        else => std.debug.print("unsupported host\n", .{}),
    }
    std.debug.print(
        "\nWant: active back to 0 after close, close_cb=true, peer=EOF.\n" ++
            "active>0 with close_cb=false means a leaked registration;\n" ++
            "active=0 with close_cb=false means the loop stopped waiting on live work.\n",
        .{},
    );
}
