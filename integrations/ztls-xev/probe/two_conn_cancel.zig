//! The failing shape, with ztls removed: two socketpair ends on ONE loop, one
//! side cancels its armed read then closes, the other side's armed read should
//! wake with EOF and then close.
//!
//! The single-socket probe (`cancel_accounting.zig`) is clean on every backend,
//! so if this one stalls the defect is in libxev's handling of the two-peer
//! sequence; if it is clean, the defect is in ztls-xev's `Conn` and this probe
//! is the control that proves it.
//!
//! Everything is armed from inside completion callbacks where the real code does,
//! because that is one of the few differences left between the clean probe and
//! the failing test.
const std = @import("std");
const builtin = @import("builtin");
const xev = @import("xev");

fn Pair(comptime Xev: type) type {
    return struct {
        const Self = @This();

        a: Xev.TCP,
        b: Xev.TCP,
        loop: *Xev.Loop,

        a_read_c: Xev.Completion = .{},
        a_cancel_c: Xev.Completion = .{},
        a_close_c: Xev.Completion = .{},
        b_read_c: Xev.Completion = .{},
        b_close_c: Xev.Completion = .{},
        a_buf: [64]u8 = undefined,
        b_buf: [64]u8 = undefined,

        a_read_err: ?anyerror = null,
        b_read_err: ?anyerror = null,
        log: [8]Step = undefined,
        len: usize = 0,

        const Step = enum { a_read, a_cancel, a_close, b_read, b_close };

        fn note(s: *Self, step: Step) void {
            if (s.len < s.log.len) {
                s.log[s.len] = step;
                s.len += 1;
            }
        }

        fn armReads(s: *Self) void {
            s.a.read(s.loop, &s.a_read_c, .{ .slice = &s.a_buf }, Self, s, onARead);
            s.b.read(s.loop, &s.b_read_c, .{ .slice = &s.b_buf }, Self, s, onBRead);
        }

        /// Cancel A's read; A's close is issued from the cancel callback, exactly
        /// as `Conn.advanceClose` does.
        fn cancelA(s: *Self) void {
            s.a_cancel_c = .{
                .op = .{ .cancel = .{ .c = &s.a_read_c } },
                .userdata = s,
                .callback = struct {
                    fn cb(
                        ud: ?*anyopaque,
                        _: *Xev.Loop,
                        _: *Xev.Completion,
                        _: Xev.Result,
                    ) Xev.CallbackAction {
                        const self: *Self = @ptrCast(@alignCast(ud.?));
                        self.note(.a_cancel);
                        self.a.close(self.loop, &self.a_close_c, Self, self, onAClose);
                        return .disarm;
                    }
                }.cb,
            };
            s.loop.add(&s.a_cancel_c);
        }

        fn onARead(
            s: ?*Self,
            _: *Xev.Loop,
            _: *Xev.Completion,
            _: Xev.TCP,
            _: Xev.ReadBuffer,
            r: Xev.ReadError!usize,
        ) Xev.CallbackAction {
            s.?.note(.a_read);
            _ = r catch |e| {
                s.?.a_read_err = e;
            };
            return .disarm;
        }

        fn onAClose(
            s: ?*Self,
            _: *Xev.Loop,
            _: *Xev.Completion,
            _: Xev.TCP,
            _: Xev.CloseError!void,
        ) Xev.CallbackAction {
            s.?.note(.a_close);
            return .disarm;
        }

        /// B sees the peer vanish and closes from inside its read callback — the
        /// step that never completes in the ztls test.
        fn onBRead(
            s: ?*Self,
            _: *Xev.Loop,
            _: *Xev.Completion,
            _: Xev.TCP,
            _: Xev.ReadBuffer,
            r: Xev.ReadError!usize,
        ) Xev.CallbackAction {
            const self = s.?;
            self.note(.b_read);
            _ = r catch |e| {
                self.b_read_err = e;
            };
            self.b.close(self.loop, &self.b_close_c, Self, self, onBClose);
            return .disarm;
        }

        fn onBClose(
            s: ?*Self,
            _: *Xev.Loop,
            _: *Xev.Completion,
            _: Xev.TCP,
            _: Xev.CloseError!void,
        ) Xev.CallbackAction {
            s.?.note(.b_close);
            return .disarm;
        }
    };
}

fn probe(comptime name: []const u8, comptime Xev: type) !void {
    var fds: [2]std.posix.fd_t = undefined;
    if (std.c.socketpair(std.posix.AF.UNIX, std.posix.SOCK.STREAM, 0, &fds) != 0)
        return error.SocketPair;

    var pool: xev.ThreadPool = .init(.{});
    var loop: Xev.Loop = try .init(.{ .thread_pool = &pool });
    // Defers run LIFO: the pool joins before the loop dies, because a close
    // task still in flight dereferences the loop (thread_pool_completions.push
    // plus a wakeup) — the reverse order is a teardown use-after-free.
    defer loop.deinit();
    defer {
        pool.shutdown();
        pool.deinit();
    }

    const P = Pair(Xev);
    var p: P = .{ .a = .initFd(fds[0]), .b = .initFd(fds[1]), .loop = &loop };

    p.armReads();
    for (0..20) |_| try loop.run(.no_wait);
    p.cancelA();

    var spins: usize = 0;
    while (spins < 2000) : (spins += 1) {
        try loop.run(.no_wait);
        var ts: std.posix.timespec = .{ .sec = 0, .nsec = 200 * std.time.ns_per_us };
        _ = std.c.nanosleep(&ts, null);
        // Done when both sides have closed.
        var closed: usize = 0;
        for (p.log[0..p.len]) |step| {
            if (step == .a_close or step == .b_close) closed += 1;
        }
        if (closed == 2) break;
    }

    std.debug.print("{s}: steps={any} active={d} spins={d} a_err={?} b_err={?}\n", .{
        name, p.log[0..p.len], loop.active, spins, p.a_read_err, p.b_read_err,
    });
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
        "\nWant: steps ending in both a_close and b_close, active=0, spins well under 2000.\n" ++
            "Missing b_close with active=0 reproduces the ztls stall in pure libxev.\n",
        .{},
    );
}
