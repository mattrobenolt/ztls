//! TLS 1.3 epoll client/server ping-pong over a real TCP loopback.
//!
//! Two threads, each with its own epoll instance and non-blocking socket,
//! perform a full TLS 1.3 handshake and then exchange ping/pong messages for
//! a fixed number of rounds. No HTTP, no external process, no blocking I/O.
//!
//! The interesting part is how ztls's Sans-I/O engine composes with edge-ish,
//! non-blocking sockets. ztls hands back one wire-ready record at a time and
//! requires it to reach the transport before the next engine call. `Conn`
//! captures that contract: it owns the socket, the epoll registration, and the
//! single unsent record, toggling EPOLLOUT interest so a partial write never
//! corrupts the stream. While a write is outstanding the driver stops feeding
//! records to the engine.
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
const mem = std.mem;
const fs = std.fs;
const posix = std.posix;
const heap = std.heap;
const crypto = std.crypto;
const process = std.process;
const linux = std.os.linux;
const assert = std.debug.assert;
const Allocator = mem.Allocator;
const Thread = std.Thread;
const Address = std.net.Address;
const Base64Decoder = std.base64.standard.Decoder;
const builtin = @import("builtin");

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
    mutex: Thread.Mutex = .{},
    file: fs.File.Writer,

    fn init(file: fs.File, buffer: []u8) LockedWriter {
        return .{ .file = .init(file, buffer) };
    }

    fn print(self: *LockedWriter, comptime fmt: []const u8, args: anytype) void {
        self.mutex.lock();
        defer self.mutex.unlock();
        // ziglint-ignore: Z026
        self.file.interface.print(fmt, args) catch {};
    }

    fn writeAll(self: *LockedWriter, bytes: []const u8) void {
        self.mutex.lock();
        defer self.mutex.unlock();
        // ziglint-ignore: Z026
        self.file.interface.writeAll(bytes) catch {};
    }

    fn flush(self: *LockedWriter) void {
        self.mutex.lock();
        defer self.mutex.unlock();
        // ziglint-ignore: Z026
        self.file.interface.flush() catch {};
    }
};

var stdout_buf: [512]u8 = undefined;
var stdout: LockedWriter = .init(.stdout(), &stdout_buf);

var stderr_buf: [512]u8 = undefined;
var stderr: LockedWriter = .init(.stderr(), &stderr_buf);

// -- Connection: socket + epoll + one pending record -------------------------

/// A non-blocking socket registered with an epoll instance, tracking the single
/// record the engine has produced but the transport has not yet fully accepted.
/// `pending` is that record's unsent tail. While `writeBlocked()` is true the
/// caller must not invoke another ztls method on this connection.
const Conn = struct {
    epoll_fd: posix.fd_t,
    fd: posix.fd_t,
    ev: linux.epoll_event,
    pending: []const u8 = "",

    fn init(epoll_fd: posix.fd_t, fd: posix.fd_t, events: u32) !Conn {
        var conn: Conn = .{
            .epoll_fd = epoll_fd,
            .fd = fd,
            .ev = .{ .events = events, .data = .{ .fd = fd } },
        };
        try posix.epoll_ctl(epoll_fd, linux.EPOLL.CTL_ADD, fd, &conn.ev);
        return conn;
    }

    fn writeBlocked(self: *const Conn) bool {
        return self.pending.len != 0;
    }

    /// Update the epoll interest set, skipping the syscall when unchanged.
    fn interest(self: *Conn, events: u32) !void {
        if (self.ev.events == events) return;
        self.ev.events = events;
        try posix.epoll_ctl(self.epoll_fd, linux.EPOLL.CTL_MOD, self.fd, &self.ev);
    }

    /// Push as much of `pending` as the kernel accepts, then arm epoll: read
    /// only once drained, read+write while bytes remain. Returns true when the
    /// record has left entirely, at which point the caller calls completeWrite().
    fn flush(self: *Conn) !bool {
        while (self.pending.len > 0) {
            const n = posix.send(self.fd, self.pending, 0) catch |err| switch (err) {
                error.WouldBlock => break,
                else => return err,
            };
            if (n == 0) break;
            self.pending = self.pending[n..];
        }
        const drained = self.pending.len == 0;
        try self.interest(if (drained) linux.EPOLL.IN else linux.EPOLL.IN | linux.EPOLL.OUT);
        return drained;
    }

    /// Queue a wire-ready record and try to flush it immediately.
    fn send(self: *Conn, record: []const u8) !bool {
        assert(!self.writeBlocked());
        self.pending = record;
        return self.flush();
    }
};

fn setNonBlocking(fd: posix.fd_t) !void {
    const flags = try posix.fcntl(fd, linux.F.GETFL, 0);
    _ = try posix.fcntl(fd, linux.F.SETFL, flags | linux.SOCK.NONBLOCK);
}

/// Drain the socket into the record buffer until it would block. Returns false
/// when the peer has closed (recv returned 0).
fn fillRecordBuffer(fd: posix.fd_t, rb: *ztls.RecordBuffer) !bool {
    while (true) {
        const writable = rb.writable();
        if (writable.len == 0) return true;
        const n = posix.recv(fd, writable, 0) catch |err| switch (err) {
            error.WouldBlock => return true,
            else => return err,
        };
        if (n == 0) return false;
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

    fn init() !Args {
        var result: Args = .{
            .cert = default_cert,
            .key = default_key,
            .trust = default_cert,
            .host = default_host_name,
            .rounds = default_rounds,
            .port = 0,
        };

        var args = process.args();
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
    ready: Thread.ResetEvent = .{},
    port: u16 = 0,
};

var debug_allocator: heap.DebugAllocator(.{}) = .init;

pub fn main() !u8 {
    const gpa = debug_allocator.allocator();
    defer _ = debug_allocator.deinit();
    var arena_allocator: heap.ArenaAllocator = .init(gpa);
    defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();
    defer stdout.flush();
    defer stderr.flush();

    const args = Args.init() catch |err| {
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

    const cert_pem = try fs.cwd().readFileAlloc(arena, args.cert, 1 << 20);
    var cert_list = try parsePemCerts(arena, cert_pem);
    const certs = try cert_list.toOwnedSlice(arena);

    var shared: Shared = .{};
    const server_thread: Thread = try .spawn(.{}, serverRun, .{ arena, &args, certs, &shared });
    defer server_thread.join();

    shared.ready.wait();

    const client_thread: Thread = try .spawn(.{}, clientRun, .{ arena, &args, shared.port });
    defer client_thread.join();

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
    const addr: Address = try .parseIp(host, args.port);
    var listener = try addr.listen(.{ .reuse_address = true });
    defer listener.deinit();
    const listen_fd = listener.stream.handle;
    try setNonBlocking(listen_fd);

    const actual_port = listener.listen_address.in.getPort();
    stdout.print("[server] listening on {s}:{d}\n", .{ host, actual_port });
    shared.port = actual_port;
    shared.ready.set();

    const key_pem = try fs.cwd().readFileAlloc(arena, args.key, 1 << 20);
    const scheme = try signatureSchemeForCert(certs[0]);
    var private_key: ztls.signature.PrivateKey = try .fromPem(scheme, key_pem);
    defer private_key.deinit();
    const signer = private_key.signer();

    const epoll_fd = try posix.epoll_create1(0);
    defer posix.close(epoll_fd);
    var listen_ev: linux.epoll_event = .{ .events = linux.EPOLL.IN, .data = .{ .fd = listen_fd } };
    try posix.epoll_ctl(epoll_fd, linux.EPOLL.CTL_ADD, listen_fd, &listen_ev);

    var hs: ztls.ServerHandshake = .init(.generate());
    defer hs.deinit();
    var hs_storage: ztls.ServerHandshake.Storage = .empty;
    hs.useHandshakeBuffer(&hs_storage.buffer);
    hs.supportAlpn(&.{alpn});

    var random: ztls.Random = undefined;
    crypto.random.bytes(&random.data);
    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);
    var out: ztls.ServerHandshake.OutBuffer = .empty;
    var flight: ztls.ServerHandshake.FlightBuffer = .empty;

    var conn: Conn = undefined;
    var connected = false;
    defer if (connected) posix.close(conn.fd);

    var flight_sent = false;
    var handshake_logged = false;
    var round: usize = 1;
    var msg_buf: [64]u8 = undefined;
    var events: [8]linux.epoll_event = undefined;

    outer: while (true) {
        const n = posix.epoll_wait(epoll_fd, &events, -1);
        for (events[0..n]) |event| {
            if (event.data.fd == listen_fd) {
                const accepted = listener.accept() catch |err| switch (err) {
                    error.WouldBlock => continue,
                    else => return err,
                };
                if (connected) {
                    posix.close(accepted.stream.handle); // one client only
                    continue;
                }
                try setNonBlocking(accepted.stream.handle);
                conn = try .init(epoll_fd, accepted.stream.handle, linux.EPOLL.IN);
                connected = true;
                stdout.writeAll("[server] accepted connection\n");
                continue;
            }
            if (!connected or event.data.fd != conn.fd) continue;
            if (event.events & linux.EPOLL.IN != 0) {
                if (!try fillRecordBuffer(conn.fd, &rb)) break :outer;
            }
            if (event.events & linux.EPOLL.OUT != 0 and conn.writeBlocked()) {
                if (try conn.flush()) hs.completeWrite();
            }
        }
        if (!connected) continue;

        // Feed buffered records to the engine while no write is outstanding.
        while (!conn.writeBlocked()) {
            const record = (try rb.next()) orelse break;
            switch (try hs.handleRecord(record, random, &out.buffer)) {
                .write => |w| if (try conn.send(w)) hs.completeWrite(),
                .application_data => |data| {
                    if (!mem.eql(u8, data, ping(&msg_buf, round)))
                        return error.UnexpectedPing;
                    const reply = try hs.sendApplicationData(pong(&msg_buf, round), &out.buffer);
                    if (try conn.send(reply)) hs.completeWrite();
                    round += 1;
                },
                .closed => {
                    _ = try conn.send(try hs.sendAlert(.close_notify, &out.buffer));
                    break :outer;
                },
                .none => {},
            }
        }

        // The authenticated flight becomes available once ServerHello is sent.
        if (!conn.writeBlocked() and !flight_sent and hs.needsServerFlight()) {
            flight_sent = true;
            const bytes = try hs.sendAuthenticatedFlightBuffered(certs, signer, &flight);
            if (try conn.send(bytes)) hs.completeWrite();
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
    const addr: Address = try .parseIp(host, port);
    const fd = try posix.socket(@intCast(addr.any.family), posix.SOCK.STREAM, 0);
    defer posix.close(fd);
    try setNonBlocking(fd);

    const epoll_fd = try posix.epoll_create1(0);
    defer posix.close(epoll_fd);

    posix.connect(fd, &addr.any, addr.getOsSockLen()) catch |err| switch (err) {
        error.WouldBlock => {}, // EINPROGRESS: completion signalled by EPOLLOUT
        else => return err,
    };
    var conn: Conn = try .init(epoll_fd, fd, linux.EPOLL.OUT);

    var bundle: crypto.Certificate.Bundle = .{};
    try bundle.addCertsFromFilePath(arena, fs.cwd(), args.trust);

    var hs: ztls.ClientHandshake = .init(.generate());
    defer hs.deinit();
    var hs_storage: ztls.ClientHandshake.Storage = .empty;
    hs.useHandshakeBuffer(&hs_storage.buffer);
    hs.offerAlpn(&.{alpn});
    hs.policy.host_name = args.host;
    hs.policy.now_sec = std.time.timestamp();
    hs.policy.bundle = &bundle;

    var random: ztls.Random = undefined;
    crypto.random.bytes(&random.data);
    var out: ztls.ClientHandshake.OutBuffer = .empty;
    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);

    var connected = false;
    var handshake_logged = false;
    var round: usize = 1;
    var msg_buf: [64]u8 = undefined;
    var events: [8]linux.epoll_event = undefined;

    outer: while (true) {
        const n = posix.epoll_wait(epoll_fd, &events, -1);
        for (events[0..n]) |event| {
            if (!connected and event.events & linux.EPOLL.OUT != 0) {
                try posix.getsockoptError(fd); // surfaces a failed async connect
                connected = true;
                stdout.print("[client] connected to {s}:{d}\n", .{ host, port });
                if (try conn.send(try hs.start(&out.buffer, random, args.host)))
                    hs.completeWrite();
                stdout.print("[client] ClientHello sent → state={s}\n", .{@tagName(hs.state)});
                continue;
            }
            if (event.events & linux.EPOLL.IN != 0) {
                if (!try fillRecordBuffer(fd, &rb)) break :outer;
            }
            if (event.events & linux.EPOLL.OUT != 0 and conn.writeBlocked()) {
                if (try conn.flush()) hs.completeWrite();
            }
        }

        while (!conn.writeBlocked()) {
            const record = (try rb.next()) orelse break;
            switch (try hs.handleRecord(record, &out.buffer)) {
                .write => |w| if (try conn.send(w)) hs.completeWrite(),
                .application_data => |data| {
                    if (!mem.eql(u8, data, pong(&msg_buf, round)))
                        return error.UnexpectedPong;
                    stdout.print("[client] received: {s}", .{data});
                    if (round == args.rounds) {
                        _ = try conn.send(try hs.sendAlert(.close_notify, &out.buffer));
                        break :outer;
                    }
                    round += 1;
                    const next = try hs.sendApplicationData(ping(&msg_buf, round), &out.buffer);
                    if (try conn.send(next)) hs.completeWrite();
                },
                .closed => {
                    stdout.writeAll("[client] server sent close_notify\n");
                    _ = try conn.send(try hs.sendAlert(.close_notify, &out.buffer));
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
            if (try conn.send(first)) hs.completeWrite();
        }
    }
}
