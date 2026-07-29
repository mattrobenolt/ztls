//! What does canceling a *stuck* write actually do, per backend?
//!
//! Companion to cancel_accounting.zig, which covers canceling an idle read.
//! The write case differs fundamentally: the pipe is full, so the write cannot
//! complete — on a blocking fd io_uring punts it to a worker thread blocked in
//! the syscall, which is a very different thing to cancel than a registration
//! in a readiness list. ztls-xev's close path cancels in-flight work before
//! closing the fd and then assumes the operation is retired; this probe checks
//! whether that assumption survives a write that is genuinely stuck.
//!
//! Sequence per backend: clamp SO_SNDBUF, arm a 16KB write with no reader,
//! cancel it, close the fd, then close the peer — printing every CQE that
//! arrives, in order, so the timeline is the evidence rather than a guess.
const std = @import("std");
const builtin = @import("builtin");
const xev = @import("xev");

const payload = [_]u8{0xab} ** 16384;

fn Probe(comptime Xev: type) type {
    return struct {
        const Self = @This();
        spin_no: usize = 0,
        rest: []const u8 = &payload,
        canceled: bool = false,
        c_write: Xev.Completion = .{},
        c_cancel: Xev.Completion = .{},
        c_close: Xev.Completion = .{},
        sock: Xev.TCP = undefined,
        loop: *Xev.Loop = undefined,

        fn log(s: *Self, comptime fmt: []const u8, args: anytype) void {
            std.debug.print("  spin {d: >4}: " ++ fmt ++ "\n", .{s.spin_no} ++ args);
        }

        fn armWrite(s: *Self) void {
            s.sock.write(s.loop, &s.c_write, .{ .slice = s.rest }, Self, s, onWrite);
        }

        fn onWrite(
            s_opt: ?*Self,
            _: *Xev.Loop,
            _: *Xev.Completion,
            _: Xev.TCP,
            _: Xev.WriteBuffer,
            r: Xev.WriteError!usize,
        ) Xev.CallbackAction {
            const s = s_opt.?;
            if (r) |n| {
                s.rest = s.rest[n..];
                s.log("write CQE: wrote {d}, {d} left", .{ n, s.rest.len });
                // Re-arm like a real caller draining a large write: the pipe is
                // full, so the re-armed write is the one that stays stuck.
                if (s.rest.len > 0 and !s.canceled) s.armWrite();
            } else |e| {
                s.log("write CQE: {s}", .{@errorName(e)});
            }
            return .disarm;
        }

        fn onCancel(s_opt: ?*Self, _: *Xev.Loop, _: *Xev.Completion, r: Xev.Result) Xev.CallbackAction {
            const s = s_opt.?;
            if (r.cancel) |_| {
                s.log("cancel CQE: success", .{});
            } else |e| {
                s.log("cancel CQE: {s}", .{@errorName(e)});
            }
            return .disarm;
        }

        fn onClose(
            s_opt: ?*Self,
            _: *Xev.Loop,
            _: *Xev.Completion,
            _: Xev.TCP,
            _: Xev.CloseError!void,
        ) Xev.CallbackAction {
            const s = s_opt.?;
            s.log("close CQE fired", .{});
            return .disarm;
        }
    };
}

fn spin(p: anytype, n: usize) !void {
    for (0..n) |_| {
        p.spin_no += 1;
        try p.loop.run(.no_wait);
        var ts: std.posix.timespec = .{ .sec = 0, .nsec = 500 * std.time.ns_per_us };
        _ = std.c.nanosleep(&ts, null);
    }
}

const Strategy = enum { cancel, shutdown };

fn probe(comptime name: []const u8, comptime Xev: type, comptime strategy: Strategy) !void {
    std.debug.print("{s}:\n", .{name});
    var fds: [2]std.posix.fd_t = undefined;
    if (std.c.socketpair(std.posix.AF.UNIX, std.posix.SOCK.STREAM, 0, &fds) != 0)
        return error.SocketPair;
    // fds[1] is closed explicitly at the peer-close step below.

    // Clamp the send buffer so the write cannot drain: nobody ever reads the
    // peer end. Linux doubles this to ~4.6KB, far short of the 16KB payload.
    try std.posix.setsockopt(fds[0], std.posix.SOL.SOCKET, std.posix.SO.SNDBUF, &std.mem.toBytes(@as(c_int, 2048)));

    var pool: xev.ThreadPool = .init(.{});
    defer {
        pool.shutdown();
        pool.deinit();
    }
    var loop: Xev.Loop = try .init(.{ .thread_pool = &pool });
    defer loop.deinit();

    const P = Probe(Xev);
    var p: P = .{ .loop = &loop };
    p.sock = .initFd(fds[0]);

    p.armWrite();
    try spin(&p, 50);
    p.log("armed; active={d} (partial drain expected first)", .{loop.active});

    p.canceled = true;
    switch (strategy) {
        .cancel => {
            p.c_cancel = .{
                .op = .{ .cancel = .{ .c = &p.c_write } },
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
        },
        .shutdown => {
            // A raw shutdown(2), not a libxev op: the question is whether the
            // syscall semantics alone retire the stuck write promptly.
            p.log("issuing shutdown(SHUT_RDWR) directly", .{});
            const rc = std.c.shutdown(fds[0], std.posix.SHUT.RDWR);
            p.log("shutdown rc={d} errno={s}", .{ rc, @tagName(std.posix.errno(rc)) });
        },
    }
    try spin(&p, 50);
    p.log("after {s}; active={d}", .{ @tagName(strategy), loop.active });

    p.sock.close(&loop, &p.c_close, P, &p, P.onClose);
    try spin(&p, 100);
    p.log("after close; active={d}", .{loop.active});

    // The moment of truth for a leaked request: the peer goes away, which is
    // what finally unblocks a write stuck on a full pipe (EPIPE).
    if (std.c.close(fds[1]) != 0) return error.PeerClose;
    try spin(&p, 200);
    p.log("after peer close; active={d}", .{loop.active});

    std.debug.print("{s} done: final active={d}\n", .{ name, loop.active });
}

pub fn main() !void {
    std.debug.print("default backend = {t}\n", .{xev.backend});
    switch (builtin.os.tag) {
        .linux => {
            try probe("io_uring/cancel  ", xev.IO_Uring, .cancel);
            try probe("io_uring/shutdown", xev.IO_Uring, .shutdown);
            try probe("epoll/cancel     ", xev.Epoll, .cancel);
            // No epoll/shutdown: on a readiness backend the armed write is a
            // registration, not a blocked syscall, so shutdown(2) has nothing
            // to interrupt — the registration sits there with the pipe full
            // and the probe hangs at teardown. CTL_DEL is the retirement.
        },
        .macos => try probe("kqueue/cancel    ", xev.Kqueue, .cancel),
        else => std.debug.print("unsupported host\n", .{}),
    }
    std.debug.print(
        "\nWant: write CQE with Canceled (or nothing) shortly after the cancel,\n" ++
            "active=0 after close, and NOTHING after the peer closes. A write CQE\n" ++
            "arriving only after the peer close means the request outlived its\n" ++
            "cancel and its fd — the zombie that crashes a deinitialized caller.\n",
        .{},
    );
}
