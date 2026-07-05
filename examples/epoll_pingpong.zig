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
const fs = std.fs;
const posix = std.posix;
const heap = std.heap;
const crypto = std.crypto;
const linux = std.os.linux;
const Allocator = mem.Allocator;
const Thread = std.Thread;
const NoopMutex = struct {
    fn lock(_: *NoopMutex) void {}
    fn unlock(_: *NoopMutex) void {}
};
const Mutex = if (is_zig_16) NoopMutex else Thread.Mutex;
const SpinEvent = struct {
    ready: std.atomic.Value(bool) = .init(false),

    fn set(self: *SpinEvent) void {
        self.ready.store(true, .release);
    }

    fn wait(self: *SpinEvent) void {
        const req: std.c.timespec = .{ .sec = 0, .nsec = std.time.ns_per_ms };
        while (!self.ready.load(.acquire)) _ = std.c.nanosleep(&req, null);
    }
};
const ResetEvent = if (is_zig_16) SpinEvent else Thread.ResetEvent;
const net = @import("net_compat.zig");
const Address = net.Address;
const Base64Decoder = std.base64.standard.Decoder;
const Io = std.Io;
const builtin = @import("builtin");
const is_zig_16 = builtin.zig_version.major == 0 and builtin.zig_version.minor >= 16;
const ArgsVector = if (is_zig_16) std.process.Args.Vector else void;
const Init = if (is_zig_16) std.process.Init else void;

const ztls = @import("ztls");

comptime {
    if (builtin.os.tag != .linux) @compileError("epoll_pingpong is Linux-only");
}

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
    mutex: Mutex = .{},

    fn init() LockedWriter {
        return .{};
    }

    fn print(self: *LockedWriter, comptime fmt: []const u8, args: anytype) void {
        self.mutex.lock();
        defer self.mutex.unlock();
        debug_print(fmt, args);
    }

    fn writeAll(self: *LockedWriter, bytes: []const u8) void {
        self.print("{s}", .{bytes});
    }

    fn flush(_: *LockedWriter) void {}
};

var stdout: LockedWriter = .init();
var stderr: LockedWriter = .init();

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

fn setNonBlocking(fd: posix.fd_t) !void {
    if (comptime is_zig_16) {
        const flags = std.c.fcntl(fd, linux.F.GETFL, @as(i32, 0));
        if (flags < 0) return error.FcntlFailed;
        if (std.c.fcntl(fd, linux.F.SETFL, flags | linux.SOCK.NONBLOCK) < 0)
            return error.FcntlFailed;
        return;
    }

    const flags = try posix.fcntl(fd, linux.F.GETFL, 0);
    _ = try posix.fcntl(fd, linux.F.SETFL, flags | linux.SOCK.NONBLOCK);
}

fn sendFd(fd: posix.fd_t, bytes: []const u8) !usize {
    if (comptime !is_zig_16) return posix.send(fd, bytes, 0);
    const n = std.c.send(fd, bytes.ptr, bytes.len, 0);
    if (n < 0) return switch (std.c.errno(n)) {
        .AGAIN => error.WouldBlock,
        else => error.SocketFailed,
    };
    return @intCast(n);
}

fn recvFd(fd: posix.fd_t, buf: []u8) !usize {
    if (comptime !is_zig_16) return posix.recv(fd, buf, 0);
    const n = std.c.recv(fd, buf.ptr, buf.len, 0);
    if (n < 0) return switch (std.c.errno(n)) {
        .AGAIN => error.WouldBlock,
        else => error.SocketFailed,
    };
    return @intCast(n);
}

fn checkConnect(fd: posix.fd_t) !void {
    if (comptime is_zig_16) return;
    try posix.getsockoptError(fd);
}

fn closeFd(fd: posix.fd_t) void {
    if (comptime is_zig_16) _ = linux.close(fd) else posix.close(fd);
}

fn epollCreate1(flags: u32) !posix.fd_t {
    if (comptime !is_zig_16) return posix.epoll_create1(flags);
    const fd = std.c.epoll_create1(flags);
    if (fd < 0) return error.EpollFailed;
    return fd;
}

fn epollCtl(epfd: posix.fd_t, op: u32, fd: posix.fd_t, event: *linux.epoll_event) !void {
    if (comptime !is_zig_16) return posix.epoll_ctl(epfd, op, fd, event);
    if (std.c.epoll_ctl(epfd, op, fd, event) < 0) return error.EpollFailed;
}

fn epollWait(epfd: posix.fd_t, events: []linux.epoll_event, timeout_ms: i32) !usize {
    if (comptime !is_zig_16) return posix.epoll_wait(epfd, events, timeout_ms);
    const n = std.c.epoll_wait(epfd, events.ptr, @intCast(events.len), timeout_ms);
    if (n < 0) return error.EpollFailed;
    return @intCast(n);
}

const FillResult = enum { more, closed };

/// Drain the socket into the record buffer until it would block.
fn fillRecordBuffer(fd: posix.fd_t, rb: *ztls.RecordBuffer) !FillResult {
    while (true) {
        const writable = rb.writable();
        if (writable.len == 0) return .more;
        const n = recvFd(fd, writable) catch |err| switch (err) {
            error.WouldBlock => return .more,
            else => return err,
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

    fn init(args_vector: ArgsVector) !Args {
        var result: Args = .{
            .cert = default_cert,
            .key = default_key,
            .trust = default_cert,
            .host = default_host_name,
            .rounds = default_rounds,
            .port = 0,
        };

        var args = if (comptime is_zig_16)
            std.process.Args.iterate(.{ .vector = args_vector })
        else
            std.process.args();
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
    while (mem.indexOfPos(u8, pem, pos, begin)) |start| {
        const body_start = start + begin.len;
        const body_end = mem.indexOfPos(u8, pem, body_start, end) orelse
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

fn signatureSchemeForCert(cert_der: []const u8) !ztls.SignatureScheme {
    const cert: crypto.Certificate = .{ .buffer = cert_der, .index = 0 };
    const parsed = try cert.parse();
    return switch (parsed.pub_key_algo) {
        .rsaEncryption, .rsassa_pss => .rsa_pss_rsae_sha256,
        .X9_62_id_ecPublicKey => |curve| switch (curve) {
            .secp384r1 => .ecdsa_secp384r1_sha384,
            else => .ecdsa_secp256r1_sha256,
        },
        .curveEd25519 => .ed25519,
    };
}

// -- Entry point --------------------------------------------------------------

/// Handoff from the server thread: the ephemeral port it bound, published once
/// the listener is ready. The ResetEvent establishes the happens-before edge.
const Shared = struct {
    ready: ResetEvent = .{},
    port: u16 = 0,
};

var debug_allocator: heap.DebugAllocator(.{}) = .init;

pub const main = if (is_zig_16) main16 else main15;

fn main16(init: Init) !u8 {
    return run(init.minimal.args.vector);
}

fn main15() !u8 {
    return run({});
}

fn run(args_vector: ArgsVector) !u8 {
    const gpa = debug_allocator.allocator();
    defer _ = debug_allocator.deinit();
    var arena_allocator: heap.ArenaAllocator = .init(gpa);
    defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();
    defer stdout.flush();
    defer stderr.flush();

    const args = Args.init(args_vector) catch |err| {
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

    const cert_pem = try net.readFileAlloc(arena, args.cert, 1 << 20);
    var cert_list = try parsePemCerts(arena, cert_pem);
    const certs = try cert_list.toOwnedSlice(arena);

    var shared: Shared = .{};
    const server_thread: Thread = try .spawn(.{}, serverRun, .{ arena, &args, certs, &shared });

    shared.ready.wait();

    const client_thread: Thread = try .spawn(.{}, clientRun, .{ arena, &args, shared.port });
    client_thread.join();
    server_thread.join();

    stdout.writeAll("\n=== epoll ping-pong OK ===\n");
    return 0;
}

// -- Server -------------------------------------------------------------------

fn serverRun(
    arena: Allocator,
    args: *const Args,
    certs: []const []const u8,
    shared: *Shared,
) !void {
    const addr: Address = try net.parseIp(host, args.port);
    var listener = try net.listen(addr, .{ .reuse_address = true });
    defer net.deinitServer(&listener);
    const listen_fd = net.serverFd(listener);
    try setNonBlocking(listen_fd);

    const actual_port = net.serverPort(listener);
    stdout.print("[server] listening on {s}:{d}\n", .{ host, actual_port });
    shared.port = actual_port;
    shared.ready.set();

    const key_pem = try net.readFileAlloc(arena, args.key, 1 << 20);
    const scheme = try signatureSchemeForCert(certs[0]);
    var private_key: ztls.signature.PrivateKey = try .fromPem(scheme, key_pem);
    defer private_key.deinit();

    const epoll_fd = try epollCreate1(0);
    defer closeFd(epoll_fd);
    var listen_ev: linux.epoll_event = .{ .events = linux.EPOLL.IN, .data = .{ .fd = listen_fd } };
    try epollCtl(epoll_fd, linux.EPOLL.CTL_ADD, listen_fd, &listen_ev);

    var random: ztls.Random = undefined;
    net.fillRandom(&random.data);
    var hs_storage: ztls.ServerHandshake.Storage = .empty;
    var hs: ztls.ServerHandshake = .init(.{
        .keypair = .generate(),
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
                const accepted = net.accept(&listener) catch |err| switch (err) {
                    error.WouldBlock => continue,
                    else => return err,
                };
                if (connected) {
                    net.close(accepted); // one client only
                    continue;
                }
                try setNonBlocking(net.fd(accepted));
                conn = try .init(epoll_fd, net.fd(accepted), linux.EPOLL.IN);
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

fn clientRun(arena: Allocator, args: *const Args, port: u16) !void {
    const addr: Address = try net.parseIp(host, port);
    const stream = try net.connect(addr);
    defer net.close(stream);
    const fd = net.fd(stream);
    try setNonBlocking(fd);

    const epoll_fd = try epollCreate1(0);
    defer closeFd(epoll_fd);
    var conn: Conn = try .init(epoll_fd, fd, linux.EPOLL.OUT);

    var bundle: crypto.Certificate.Bundle = if (@hasDecl(crypto.Certificate.Bundle, "empty"))
        .empty
    else
        .{};
    const trust_pem = try net.readFileAlloc(arena, args.trust, 1 << 20);
    const trust_list = try parsePemCerts(arena, trust_pem);
    for (trust_list.items) |trust_der| {
        const cert_start: u32 = @intCast(bundle.bytes.items.len);
        try bundle.bytes.appendSlice(arena, trust_der);
        try bundle.parseCert(arena, cert_start, net.timestamp());
    }

    var random: ztls.Random = undefined;
    net.fillRandom(&random.data);
    var hs_storage: ztls.ClientHandshake.Storage = .empty;

    var hs: ztls.ClientHandshake = .init(.{
        .keypair = .generate(),
        .host_name = args.host,
        .now_sec = net.timestamp(),
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
    var round: usize = 1;
    var msg_buf: [64]u8 = undefined;
    var events: [8]linux.epoll_event = undefined;

    outer: while (true) {
        const n = try epollWait(epoll_fd, &events, -1);
        for (events[0..n]) |event| {
            if (!connected and event.events & linux.EPOLL.OUT != 0) {
                try checkConnect(fd); // surfaces a failed async connect
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
}
