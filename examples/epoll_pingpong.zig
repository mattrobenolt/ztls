//! TLS 1.3 epoll client/server ping-pong over a real TCP loopback.
//!
//! Two threads, each with its own epoll instance and non-blocking socket,
//! perform a full TLS 1.3 handshake and then exchange ping/pong messages for
//! a fixed number of rounds. No HTTP, no external process, no blocking I/O.
//!
//! The interesting part is how ztls's Sans-I/O engine composes with edge-ish,
//! non-blocking sockets. ztls hands back one wire-ready record at a time and
//! requires it to reach the transport before the next engine call. `ztls.Outbox`
//! captures the single unsent record and calls `completeWrite()` only after the
//! kernel accepts every byte; `Conn` owns the socket and epoll interest bits.
//!
//! Run:
//!     zig build example-epoll_pingpong
//!
//! With real certificates:
//!     zig build example-epoll_pingpong -- \
//!       --cert /path/to/chain.pem \
//!       --key /path/to/leaf.key \
//!       --trust /path/to/root.pem \
//!       --host rsa-pss.test \
//!       --rounds 4
const std = @import("std");
const debug_print = std.debug.print;
const mem = std.mem;
const posix = std.posix;
const crypto = std.crypto;
const linux = std.os.linux;
const Allocator = mem.Allocator;
const Thread = std.Thread;
const Base64Decoder = std.base64.standard.Decoder;
const Io = std.Io;
const IpAddress = Io.net.IpAddress;
const builtin = @import("builtin");

const ztls = @import("ztls");

comptime {
    if (builtin.os.tag != .linux) @compileError("epoll_pingpong is Linux-only");
}

/// One-shot cross-thread signal, futex-backed through the Io.
const ReadyEvent = struct {
    state: std.atomic.Value(u32) = .init(0),

    fn set(self: *ReadyEvent, io: Io) void {
        self.state.store(1, .release);
        io.futexWake(u32, &self.state.raw, 1);
    }

    fn wait(self: *ReadyEvent, io: Io) void {
        while (self.state.load(.acquire) == 0) {
            io.futexWaitUncancelable(u32, &self.state.raw, 0);
        }
    }
};

const host = "127.0.0.1";
const default_cert = "tests/fixtures/rsa_pss/server.crt";
const default_key = "tests/fixtures/rsa_pss/server.key";
const default_host_name = "rsa-pss.test";
const default_rounds = 4;
const alpn = "pingpong";

const usage =
    \\usage: example-epoll_pingpong [options]
    \\  --cert PATH   server certificate chain (PEM)
    \\  --key PATH    server private key (PEM)
    \\  --trust PATH  client trust anchor (PEM)
    \\  --host NAME   SNI host name
    \\  --rounds N    number of ping/pong rounds
    \\  --port P      fixed port (default: ephemeral)
    \\
;

// -- Thread-safe stdio --------------------------------------------------------

/// Both threads log to the same descriptor, so writes are serialized behind a
/// mutex. Print failures are ignored: this is example output, not a side effect
/// the protocol depends on.
const LockedWriter = struct {
    io: Io,
    mutex: Io.Mutex = .init,

    fn print(self: *LockedWriter, comptime fmt: []const u8, args: anytype) void {
        self.mutex.lockUncancelable(self.io);
        defer self.mutex.unlock(self.io);
        debug_print(fmt, args);
    }

    fn writeAll(self: *LockedWriter, bytes: []const u8) void {
        self.print("{s}", .{bytes});
    }

    fn flush(_: *LockedWriter) void {}
};

// Runtime-initialized in main before any thread spawns: the mutex locks
// through the Io.
var stdout: LockedWriter = undefined;
var stderr: LockedWriter = undefined;

// -- Connection: socket + epoll + ztls write outbox --------------------------

pub const EpollSender = struct {
    fd: posix.fd_t,

    pub fn write(self: EpollSender, bytes: []const u8) !usize {
        return sendFd(self.fd, bytes) catch |err| switch (err) {
            error.WouldBlock => 0,
            else => err,
        };
    }
};

/// A non-blocking socket registered with an epoll instance. `outbox` tracks the
/// single record ztls produced but the transport has not yet fully accepted.
/// While `writeBlocked()` is true the caller must not invoke another
/// record-producing ztls method on this connection.
const Conn = struct {
    epoll_fd: posix.fd_t,
    fd: posix.fd_t,
    ev: linux.epoll_event,
    outbox: ztls.Outbox = .init,

    fn init(epoll_fd: posix.fd_t, fd: posix.fd_t, events: u32) !Conn {
        var conn: Conn = .{
            .epoll_fd = epoll_fd,
            .fd = fd,
            .ev = .{ .events = events, .data = .{ .fd = fd } },
        };
        try epollCtl(epoll_fd, linux.EPOLL.CTL_ADD, fd, &conn.ev);
        return conn;
    }

    fn writeBlocked(self: *const Conn) bool {
        return self.outbox.writeBlocked();
    }

    /// Update the epoll interest set, skipping the syscall when unchanged.
    fn interest(self: *Conn, events: u32) !void {
        if (self.ev.events == events) return;
        self.ev.events = events;
        try epollCtl(self.epoll_fd, linux.EPOLL.CTL_MOD, self.fd, &self.ev);
    }

    /// Push as much of the outbox as the kernel accepts, then arm epoll: read
    /// only once drained, read+write while bytes remain.
    fn flush(self: *Conn, hs: anytype) !void {
        const sender: EpollSender = .{ .fd = self.fd };
        const result = try self.outbox.flush(hs, sender);
        const drained = result == .drained;
        try self.interest(if (drained) linux.EPOLL.IN else linux.EPOLL.IN | linux.EPOLL.OUT);
    }

    /// Queue a wire-ready record and try to flush it immediately.
    fn send(self: *Conn, hs: anytype, record: []const u8) !void {
        const sender: EpollSender = .{ .fd = self.fd };
        const result = try self.outbox.send(hs, record, sender);
        const drained = result == .drained;
        try self.interest(if (drained) linux.EPOLL.IN else linux.EPOLL.IN | linux.EPOLL.OUT);
    }
};

// Raw linux syscalls, no libc: linux.* return the raw usize rc, and
// linux.errno(rc) is .SUCCESS when the call did not fail.

fn setNonBlocking(fd: posix.fd_t) !void {
    const getfl = linux.fcntl(fd, linux.F.GETFL, 0);
    if (linux.errno(getfl) != .SUCCESS) return error.FcntlFailed;
    if (linux.errno(linux.fcntl(fd, linux.F.SETFL, getfl | linux.SOCK.NONBLOCK)) != .SUCCESS)
        return error.FcntlFailed;
}

fn sendFd(fd: posix.fd_t, bytes: []const u8) !usize {
    const rc = linux.sendto(fd, bytes.ptr, bytes.len, 0, null, 0);
    return switch (linux.errno(rc)) {
        .SUCCESS => rc,
        .AGAIN => error.WouldBlock,
        else => error.SocketFailed,
    };
}

fn recvFd(fd: posix.fd_t, buf: []u8) !usize {
    const rc = linux.recvfrom(fd, buf.ptr, buf.len, 0, null, null);
    return switch (linux.errno(rc)) {
        .SUCCESS => rc,
        .AGAIN => error.WouldBlock,
        else => error.SocketFailed,
    };
}

fn closeFd(fd: posix.fd_t) void {
    _ = linux.close(fd);
}

fn epollCreate1(flags: u32) !posix.fd_t {
    const rc = linux.epoll_create1(flags);
    if (linux.errno(rc) != .SUCCESS) return error.EpollFailed;
    return @intCast(rc);
}

fn epollCtl(epfd: posix.fd_t, op: u32, fd: posix.fd_t, event: *linux.epoll_event) !void {
    if (linux.errno(linux.epoll_ctl(epfd, op, fd, event)) != .SUCCESS) return error.EpollFailed;
}

fn epollWait(epfd: posix.fd_t, events: []linux.epoll_event, timeout_ms: i32) !usize {
    const rc = linux.epoll_wait(epfd, events.ptr, @intCast(events.len), timeout_ms);
    if (linux.errno(rc) != .SUCCESS) return error.EpollFailed;
    return rc;
}

const FillResult = enum { more, closed };

/// Drain the socket into the record buffer until it would block.
fn fillRecordBuffer(fd: posix.fd_t, rb: *ztls.RecordBuffer) !FillResult {
    while (true) {
        const writable = rb.writable();
        if (writable.len == 0) return .more;
        const n = recvFd(fd, writable) catch |err| return switch (err) {
            error.WouldBlock => .more,
            else => err,
        };
        if (n == 0) return .closed;
        rb.advance(n);
    }
}

/// Format a "ping N\n" / "pong N\n" line into caller storage. Call sites use a
/// 64-byte buffer, which always fits, so a short write is unreachable.
fn ping(buf: []u8, round: usize) []const u8 {
    return std.fmt.bufPrint(buf, "ping {d}\n", .{round}) catch unreachable;
}

fn pong(buf: []u8, round: usize) []const u8 {
    return std.fmt.bufPrint(buf, "pong {d}\n", .{round}) catch unreachable;
}

// -- Configuration ------------------------------------------------------------

const Args = struct {
    cert: []const u8,
    key: []const u8,
    trust: []const u8,
    host: []const u8,
    rounds: u32,
    port: u16,

    fn init(process_args: std.process.Args) !Args {
        var result: Args = .{
            .cert = default_cert,
            .key = default_key,
            .trust = default_cert,
            .host = default_host_name,
            .rounds = default_rounds,
            .port = 0,
        };

        var args = std.process.Args.iterate(process_args);
        _ = args.skip();
        while (args.next()) |arg| {
            if (mem.eql(u8, arg, "--cert")) {
                result.cert = args.next() orelse return error.MissingCertValue;
            } else if (mem.eql(u8, arg, "--key")) {
                result.key = args.next() orelse return error.MissingKeyValue;
            } else if (mem.eql(u8, arg, "--trust")) {
                result.trust = args.next() orelse return error.MissingTrustValue;
            } else if (mem.eql(u8, arg, "--host")) {
                result.host = args.next() orelse return error.MissingHostValue;
            } else if (mem.eql(u8, arg, "--rounds")) {
                const rounds = args.next() orelse return error.MissingRoundsValue;
                result.rounds = std.fmt.parseInt(u32, rounds, 10) catch return error.InvalidRounds;
            } else if (mem.eql(u8, arg, "--port")) {
                const port = args.next() orelse return error.MissingPortValue;
                result.port = try std.fmt.parseInt(u16, port, 10);
            } else {
                stderr.print("error: unknown argument: {s}\n", .{arg});
                return error.UnknownArgument;
            }
        }
        return result;
    }
};

fn parsePemCerts(arena: Allocator, pem: []const u8) !std.ArrayList([]const u8) {
    const begin = "-----BEGIN CERTIFICATE-----";
    const end = "-----END CERTIFICATE-----";
    var list: std.ArrayList([]const u8) = .empty;

    var pos: usize = 0;
    while (mem.findPos(u8, pem, pos, begin)) |start| {
        const body_start = start + begin.len;
        const body_end = mem.findPos(u8, pem, body_start, end) orelse
            return error.MissingPemEndMarker;

        var clean: std.ArrayList(u8) = .empty;
        for (pem[body_start..body_end]) |c| switch (c) {
            ' ', '\t', '\n', '\r' => {},
            else => try clean.append(arena, c),
        };

        const size = try Base64Decoder.calcSizeForSlice(clean.items);
        const der = try arena.alloc(u8, size);
        try Base64Decoder.decode(der, clean.items);
        try list.append(arena, der);

        pos = body_end + end.len;
    }

    if (list.items.len == 0) return error.NoCertificates;
    return list;
}

// -- Entry point --------------------------------------------------------------

/// Handoff from the server thread: the ephemeral port it bound, published once
/// the listener is ready. The ReadyEvent establishes the happens-before edge.
const Shared = struct {
    ready: ReadyEvent = .{},
    port: u16 = 0,
};

pub fn main(init: std.process.Init) !u8 {
    const io = init.io;
    stdout = .{ .io = io };
    stderr = .{ .io = io };
    const arena = init.arena.allocator();
    defer stdout.flush();
    defer stderr.flush();

    const args = Args.init(init.minimal.args) catch |err| {
        stderr.print("{s}\n", .{usage});
        switch (err) {
            error.InvalidRounds => stderr.print(
                "error: --rounds must be a non-negative integer\n",
                .{},
            ),
            else => stderr.print("error: {s}\n", .{@errorName(err)}),
        }
        return 1;
    };

    const cert_pem = try Io.Dir.cwd().readFileAlloc(io, args.cert, arena, .limited(1 << 20));
    var cert_list = try parsePemCerts(arena, cert_pem);
    const certs = try cert_list.toOwnedSlice(arena);

    var shared: Shared = .{};
    var server_result: ?anyerror = null;
    var client_result: ?anyerror = null;

    const server_thread: Thread = try .spawn(
        .{},
        serverEntry,
        .{ io, arena, &args, certs, &shared, &server_result },
    );

    shared.ready.wait(io);

    const client_thread: Thread = try .spawn(
        .{},
        clientEntry,
        .{ io, arena, &args, shared.port, &client_result },
    );
    client_thread.join();
    server_thread.join();

    // Thread.join does not propagate the entry's error, so the wrappers below
    // capture it into the result out-params. Only declare success when BOTH
    // threads completed without error.
    if (server_result != null or client_result != null) return 1;

    stdout.writeAll("\n=== epoll ping-pong OK ===\n");
    return 0;
}

/// void-returning entry wrapper for the server thread: captures serverRun's
/// error into `result` (Thread.join does not propagate it) and prints a clean
/// one-line diagnostic. Returning void also suppresses Zig's thread-wrapper
/// stack trace. On error before `shared.ready.set()` (e.g. bind/listen fails)
/// we set the event ourselves so main is not stranded in `ready.wait()`.
fn serverEntry(
    io: Io,
    arena: Allocator,
    args: *const Args,
    certs: []const []const u8,
    shared: *Shared,
    result: *?anyerror,
) void {
    serverRun(io, arena, args, certs, shared) catch |err| {
        result.* = err;
        stderr.print("[server] failed: {s}\n", .{@errorName(err)});
        shared.ready.set(io);
    };
}

/// void-returning entry wrapper for the client thread: captures clientRun's
/// error into `result` and prints a clean one-line diagnostic.
fn clientEntry(
    io: Io,
    arena: Allocator,
    args: *const Args,
    port: u16,
    result: *?anyerror,
) void {
    clientRun(io, arena, args, port) catch |err| {
        result.* = err;
        stderr.print("[client] failed: {s}\n", .{@errorName(err)});
    };
}

// -- Server -------------------------------------------------------------------

fn serverRun(
    io: Io,
    arena: Allocator,
    args: *const Args,
    certs: []const []const u8,
    shared: *Shared,
) !void {
    const addr: IpAddress = try .parse(host, args.port);
    var listener = try addr.listen(io, .{ .reuse_address = true });
    defer listener.deinit(io);
    const listen_fd = listener.socket.handle;
    try setNonBlocking(listen_fd);

    const actual_port = listener.socket.address.getPort();
    stdout.print("[server] listening on {s}:{d}\n", .{ host, actual_port });
    shared.port = actual_port;
    shared.ready.set(io);

    const key_pem = try Io.Dir.cwd().readFileAlloc(io, args.key, arena, .limited(1 << 20));
    var private_key: ztls.signature.PrivateKey = try .fromPemAuto(key_pem);
    defer private_key.deinit();
    try private_key.pairsWith(certs[0]);

    const epoll_fd = try epollCreate1(0);
    defer closeFd(epoll_fd);
    var listen_ev: linux.epoll_event = .{ .events = linux.EPOLL.IN, .data = .{ .fd = listen_fd } };
    try epollCtl(epoll_fd, linux.EPOLL.CTL_ADD, listen_fd, &listen_ev);

    var random: ztls.Random = .empty;
    io.random(&random.data);
    var hs_storage: ztls.ServerHandshake.Storage = .empty;
    var hs: ztls.ServerHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .random = random,
        .alpn_protocols = &.{alpn},
        .reassembly = &hs_storage.buffer,
    });
    defer hs.deinit();
    hs.setCredentials(certs, private_key.signer());

    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);
    var out: ztls.ServerHandshake.OutBuffer = .empty;
    var flight: ztls.ServerHandshake.FlightBuffer = .empty;

    var conn: Conn = undefined;
    var connected = false;
    defer if (connected) closeFd(conn.fd);

    var handshake_logged = false;
    var round: usize = 1;
    var msg_buf: [64]u8 = undefined;
    var events: [8]linux.epoll_event = undefined;

    outer: while (true) {
        const n = try epollWait(epoll_fd, &events, -1);
        for (events[0..n]) |event| {
            if (event.data.fd == listen_fd) {
                const accepted = listener.accept(io) catch |err| switch (err) {
                    error.WouldBlock => continue,
                    else => return err,
                };
                if (connected) {
                    accepted.close(io); // one client only
                    continue;
                }
                try setNonBlocking(accepted.socket.handle);
                conn = try .init(epoll_fd, accepted.socket.handle, linux.EPOLL.IN);
                connected = true;
                stdout.writeAll("[server] accepted connection\n");
                continue;
            }
            if (!connected or event.data.fd != conn.fd) continue;
            if (event.events & linux.EPOLL.IN != 0) {
                if (try fillRecordBuffer(conn.fd, &rb) == .closed) break :outer;
            }
            if (event.events & linux.EPOLL.OUT != 0 and conn.writeBlocked()) {
                try conn.flush(&hs);
            }
        }
        if (!connected) continue;

        // Feed buffered records to the engine while no write is outstanding.
        while (!conn.writeBlocked()) {
            const record = (try rb.next()) orelse break;
            switch (try hs.handleRecord(record, &out.buffer)) {
                .write => |w| try conn.send(&hs, w),
                .application_data => |data| {
                    if (!mem.eql(u8, data, ping(&msg_buf, round)))
                        return error.UnexpectedPing;
                    const reply = try hs.sendApplicationData(pong(&msg_buf, round), &out.buffer);
                    try conn.send(&hs, reply);
                    round += 1;
                },
                .closed => {
                    try conn.send(&hs, try hs.sendAlert(.close_notify, &out.buffer));
                    break :outer;
                },
                .key_update => |ku| {
                    if (ku.response) |w| try conn.send(&hs, w);
                },
                .none => {},
            }
        }

        // The authenticated flight becomes available once ServerHello is sent.
        if (!conn.writeBlocked()) {
            if (try hs.sendServerFlightBuffered(&flight)) |bytes| {
                try conn.send(&hs, bytes);
            }
        }
        if (hs.isConnected() and !handshake_logged) {
            handshake_logged = true;
            const proto = hs.selectedAlpnProtocol() orelse "none";
            stdout.print("[server] handshake complete (ALPN={s})\n", .{proto});
        }
    }
}

// -- Client -------------------------------------------------------------------

fn clientRun(io: Io, arena: Allocator, args: *const Args, port: u16) !void {
    const addr: IpAddress = try .parse(host, port);
    const stream = try addr.connect(io, .{ .mode = .stream });
    defer stream.close(io);
    const fd = stream.socket.handle;
    try setNonBlocking(fd);

    const epoll_fd = try epollCreate1(0);
    defer closeFd(epoll_fd);
    var conn: Conn = try .init(epoll_fd, fd, linux.EPOLL.OUT);

    var bundle: crypto.Certificate.Bundle = .empty;
    const trust_pem = try Io.Dir.cwd().readFileAlloc(io, args.trust, arena, .limited(1 << 20));
    const trust_list = try parsePemCerts(arena, trust_pem);
    const now_sec = Io.Timestamp.now(io, .real).toSeconds();
    for (trust_list.items) |trust_der| {
        const cert_start: u32 = @intCast(bundle.bytes.items.len);
        try bundle.bytes.appendSlice(arena, trust_der);
        try bundle.parseCert(arena, cert_start, now_sec);
    }

    var random: ztls.Random = .empty;
    io.random(&random.data);
    var hs_storage: ztls.ClientHandshake.Storage = .empty;

    var hs: ztls.ClientHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .host_name = args.host,
        .now_sec = now_sec,
        .random = random,
        .alpn_protocols = &.{alpn},
        .bundle = &bundle,
        .reassembly = &hs_storage.buffer,
    });
    defer hs.deinit();

    var out: ztls.ClientHandshake.OutBuffer = .empty;
    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);

    var connected = false;
    var handshake_logged = false;
    var done = false; // set true only on the clean `round == args.rounds` exit
    var round: usize = 1;
    var msg_buf: [64]u8 = undefined;
    var events: [8]linux.epoll_event = undefined;

    outer: while (true) {
        const n = try epollWait(epoll_fd, &events, -1);
        for (events[0..n]) |event| {
            if (!connected and event.events & linux.EPOLL.OUT != 0) {
                connected = true;
                stdout.print("[client] connected to {s}:{d}\n", .{ host, port });
                try conn.send(&hs, try hs.start(&out.buffer));
                stdout.print("[client] ClientHello sent → state={s}\n", .{@tagName(hs.state)});
                continue;
            }
            if (event.events & linux.EPOLL.IN != 0) {
                if (try fillRecordBuffer(fd, &rb) == .closed) break :outer;
            }
            if (event.events & linux.EPOLL.OUT != 0 and conn.writeBlocked()) {
                try conn.flush(&hs);
            }
        }

        while (!conn.writeBlocked()) {
            const record = (try rb.next()) orelse break;
            switch (try hs.handleRecord(record, &out.buffer)) {
                .write => |w| try conn.send(&hs, w),
                .application_data => |data| {
                    if (!mem.eql(u8, data, pong(&msg_buf, round)))
                        return error.UnexpectedPong;
                    stdout.print("[client] received: {s}", .{data});
                    if (round == args.rounds) {
                        try conn.send(&hs, try hs.sendAlert(.close_notify, &out.buffer));
                        done = true;
                        break :outer;
                    }
                    round += 1;
                    const next = try hs.sendApplicationData(ping(&msg_buf, round), &out.buffer);
                    try conn.send(&hs, next);
                },
                .closed => {
                    stdout.writeAll("[client] server sent close_notify\n");
                    try conn.send(&hs, try hs.sendAlert(.close_notify, &out.buffer));
                    break :outer;
                },
                .key_update => |ku| {
                    if (ku.response) |w| try conn.send(&hs, w);
                },
                .new_session_ticket => {},
                .none => {},
            }
        }

        // Drive the first ping the moment the handshake completes.
        if (!conn.writeBlocked() and hs.isConnected() and !handshake_logged) {
            handshake_logged = true;
            const proto = hs.selectedAlpnProtocol() orelse "none";
            stdout.print("[client] handshake complete (ALPN={s})\n", .{proto});
            const first = try hs.sendApplicationData(ping(&msg_buf, round), &out.buffer);
            try conn.send(&hs, first);
        }
    }

    // A premature close (server `.closed` or EOF from fillRecordBuffer) before
    // the final round completes is a failure, not a silent success.
    if (!done) return error.IncompleteExchange;
}
