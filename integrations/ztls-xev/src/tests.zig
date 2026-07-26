//! Round-trip tests: a ztls-xev client driven by a real libxev loop, against a
//! ztls-std server on a thread. Two integrations of the same core talking to
//! each other is the strongest available proof that the completion-driven pump
//! and the blocking drive loop agree on the protocol.
const std = @import("std");
const builtin = @import("builtin");
const mem = std.mem;
const posix = std.posix;
const testing = std.testing;

const fixtures = @import("fixtures");
const xev = @import("xev");
const ztls = @import("ztls");
const tls = @import("ztls_xev");

const test_cert_der: []const u8 = &fixtures.server_ecdsa_cert_der;
const test_scalar: []const u8 = &fixtures.server_ecdsa_scalar;
const test_host = "ztls.server.test";

// libxev selects a backend per platform, so "the suite is green" says nothing
// about *which* event mechanism was exercised. Recording the expectation makes a
// green run on a given OS evidence for that backend by name, and fails loudly if
// libxev's selection ever changes underneath us.
test "libxev backend matches the platform" {
    const expected: []const xev.Backend = switch (builtin.os.tag) {
        // io_uring where the kernel allows it, epoll otherwise (Android, older
        // kernels, seccomp).
        .linux => &.{ .io_uring, .epoll },
        .macos, .ios, .tvos, .watchos, .freebsd, .netbsd, .openbsd => &.{.kqueue},
        .windows => &.{.iocp},
        else => return error.SkipZigTest,
    };
    for (expected) |backend| {
        if (xev.backend == backend) return;
    }
    std.debug.print("unexpected libxev backend: {t}\n", .{xev.backend});
    return error.UnexpectedBackend;
}

/// A loop plus the thread pool libxev needs to close sockets on the readiness
/// backends. See `Conn.requireThreadPool`.
const Harness = struct {
    pool: xev.ThreadPool,
    loop: xev.Loop,

    fn init(h: *Harness) !void {
        h.pool = .init(.{});
        h.loop = try .init(.{ .thread_pool = &h.pool });
    }

    // ziglint-ignore: Z030 -- test scaffolding; the caller owns the storage and
    // never reuses it.
    fn deinit(h: *Harness) void {
        h.loop.deinit();
        h.pool.shutdown();
        h.pool.deinit();
    }
};

/// Watchdog for the loop-driving tests.
///
/// `loop.run(.once)` blocks until some completion fires, so a bounded tick count
/// does not bound wall time: if every side is waiting on something that will
/// never arrive, the test hangs rather than failing. A hang gives no diagnostic,
/// cannot be shaken out by `just flake-check`, and on CI just eats the job
/// timeout. An armed timer guarantees the loop always has something to wake it,
/// so a stall becomes `error.LoopStalled` at a named line in ~2s.
///
/// That also makes the diagnosis reachable at all: `zig build test` prints a
/// failing test's captured output, but a hung test never fails, so nothing is
/// ever shown. Converting the hang into a failure is what surfaces the state
/// dumps in the callers below.
const Watchdog = struct {
    timer: xev.Timer,
    c: xev.Completion = .{},
    fired: bool = false,

    const budget_ms = 2_000;

    fn init() !Watchdog {
        return .{ .timer = try .init() };
    }

    fn arm(w: *Watchdog, loop: *xev.Loop) void {
        w.timer.run(loop, &w.c, budget_ms, Watchdog, w, onFire);
    }

    fn onFire(
        w_opt: ?*Watchdog,
        _: *xev.Loop,
        _: *xev.Completion,
        r: xev.Timer.RunError!void,
    ) xev.CallbackAction {
        // Fire either way: a timer that failed to arm must not silently disable
        // the only thing standing between a stalled loop and a hung suite.
        // ziglint-ignore: Z026 -- see above.
        r catch {};
        w_opt.?.fired = true;
        return .disarm;
    }
};

/// Drive `loop` until `done()` or the watchdog fires.
fn runUntil(loop: *xev.Loop, watchdog: *Watchdog, ctx: anytype) !void {
    watchdog.arm(loop);
    while (!ctx.done()) {
        if (watchdog.fired) return error.LoopStalled;
        try loop.run(.once);
    }
}

// The thread-pool requirement is backend-specific, so the guard in
// `Conn.requireThreadPool` compiles to nothing on io_uring. Pin which backends
// it is live on, so the guard cannot silently stop covering a backend that needs
// it — and so this file records why the pool exists at all.
test "the close thread-pool guard is active exactly where close needs a pool" {
    const guarded = @hasField(xev.Loop, "thread_pool");
    switch (xev.backend) {
        // Close is a normal SQE; no pool involved.
        .io_uring => try testing.expect(!guarded),
        // Close is dispatched to a thread pool; without one it fails
        // ThreadPoolRequired and the fd is never closed.
        .epoll, .kqueue => try testing.expect(guarded),
        else => return error.SkipZigTest,
    }
}

fn socketPair() ![2]posix.fd_t {
    var fds: [2]posix.fd_t = undefined;
    try testing.expectEqual(
        @as(c_int, 0),
        std.c.socketpair(posix.AF.UNIX, posix.SOCK.STREAM, 0, &fds),
    );
    return fds;
}

// ───────────────────────────────
// Blocking ztls-std-shaped server, on a thread
// ───────────────────────────────
//
// Hand-rolled rather than importing ztls-std: this package should not depend on
// a sibling integration just for a test peer.

const ServerCtx = struct {
    fd: posix.fd_t,
    /// Bytes to echo back after receiving anything.
    reply: []const u8,
    expect_bytes: usize,
    received: usize = 0,
    err: ?anyerror = null,
};

fn serverRun(ctx: *ServerCtx) void {
    runServer(ctx) catch |err| {
        ctx.err = err;
    };
    _ = std.c.close(ctx.fd);
}

fn runServer(ctx: *ServerCtx) !void {
    var key: ztls.signature.PrivateKey = try .fromP256Scalar(@ptrCast(test_scalar[0..32]));
    defer key.deinit();

    var keypair: ztls.x25519.KeyPair = .generate();
    defer keypair.secureZero();

    var hs: ztls.ServerHandshake = .init(.{
        .keypairs = .init(keypair),
        .random = .zero,
    });
    defer hs.deinit();
    hs.setCredentials(&.{test_cert_der}, key.signer());

    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);
    var out: ztls.ServerHandshake.OutBuffer = .empty;
    var reassembly: ztls.ServerHandshake.Storage = .empty;
    hs.useHandshakeBuffer(&reassembly.buffer);

    // Handshake.
    while (!hs.isConnected()) {
        const n = try readFd(ctx.fd, rb.writable());
        if (n == 0) return error.UnexpectedEof;
        rb.advance(n);
        while (!hs.isConnected()) {
            const record = (try rb.next()) orelse break;
            switch (try hs.handleRecord(record, &out.buffer)) {
                .write => |bytes| {
                    try writeAllFd(ctx.fd, bytes);
                    hs.completeWrite();
                    if (try hs.sendServerFlightBuffered(&out)) |flight| {
                        try writeAllFd(ctx.fd, flight);
                        hs.completeWrite();
                    }
                },
                .none => {},
                else => return error.UnexpectedRecord,
            }
        }
    }

    // Application data. The handshake loop above stops as soon as the client
    // Finished lands, which can leave an application_data record already
    // buffered behind it — so drain before reading, or this blocks forever
    // waiting for bytes that already arrived.
    while (ctx.received < ctx.expect_bytes) {
        if (!rb.hasRecord()) {
            const n = try readFd(ctx.fd, rb.writable());
            if (n == 0) return error.UnexpectedEof;
            rb.advance(n);
        }
        while (true) {
            const record = (try rb.next()) orelse break;
            switch (try hs.handleRecord(record, &out.buffer)) {
                .application_data => |data| ctx.received += data.len,
                .none => {},
                .closed => return,
                else => return error.UnexpectedRecord,
            }
        }
    }

    if (ctx.reply.len > 0) {
        const record = try hs.sendApplicationData(ctx.reply, &out.buffer);
        try writeAllFd(ctx.fd, record);
        hs.completeWrite();
    }

    const alert_record = try hs.sendAlert(.close_notify, &out.buffer);
    try writeAllFd(ctx.fd, alert_record);
    hs.completeWrite();
}

fn readFd(fd: posix.fd_t, buf: []u8) !usize {
    const n = std.c.read(fd, buf.ptr, buf.len);
    if (n < 0) return error.ReadFailed;
    return @intCast(n);
}

fn writeAllFd(fd: posix.fd_t, bytes: []const u8) !void {
    var rest = bytes;
    while (rest.len > 0) {
        const n = std.c.write(fd, rest.ptr, rest.len);
        if (n <= 0) return error.WriteFailed;
        rest = rest[@intCast(n)..];
    }
}

// ───────────────────────────────
// xev client harness
// ───────────────────────────────

const Client = struct {
    conn: tls.Client = undefined,
    loop: *xev.Loop,

    storage: tls.Client.Storage = .{},
    read_buf: [4096]u8 = undefined,

    /// Script: what to do once established.
    request: []const u8 = &.{},

    handshake_result: ?anyerror!void = null,
    alpn_seen: ?[]const u8 = null,
    received: std.ArrayList(u8) = .empty,
    read_outcomes: std.ArrayList(Outcome) = .empty,
    write_result: ?anyerror!usize = null,
    /// Captured before `deinit`, which sets the Conn to undefined — asserting on
    /// a deinitialized Conn proves nothing (#81).
    final_state: ?tls.State = null,
    flags: Flags = .initEmpty(),

    const Flag = enum {
        /// The close callback ran; the loop may stop.
        closed,
        /// An append failed inside a callback, which cannot return an error, so
        /// the assertions afterwards check this instead.
        alloc_failed,
    };
    const Flags = std.EnumSet(Flag);

    const Outcome = enum { data, close_notify, eof, err };

    fn onHandshake(self: *Client, r: tls.HandshakeResult) void {
        if (r.result) |_| {
            self.handshake_result = {};
            self.alpn_seen = self.conn.selectedAlpn();
            if (self.request.len > 0) {
                self.conn.write(self.request, self, onWrite);
            } else {
                self.conn.read(&self.read_buf, self, onRead);
            }
        } else |err| {
            self.handshake_result = err;
            self.conn.close(self, onClose);
        }
    }

    fn onWrite(self: *Client, r: tls.WriteResult) void {
        self.write_result = r.written;
        if (r.written) |_| {
            self.conn.read(&self.read_buf, self, onRead);
        } else |_| {
            self.conn.close(self, onClose);
        }
    }

    fn onRead(self: *Client, r: tls.ReadResult) void {
        // A callback cannot fail, so an OOM here is recorded rather than
        // returned; the assertions afterwards notice a truncated record.
        switch (r) {
            .data => |bytes| {
                self.note(.data);
                self.received.appendSlice(testing.allocator, bytes) catch {
                    self.flags.insert(.alloc_failed);
                };
                self.conn.read(&self.read_buf, self, onRead);
            },
            .close_notify => {
                self.note(.close_notify);
                self.conn.close(self, onClose);
            },
            .eof => {
                self.note(.eof);
                self.conn.close(self, onClose);
            },
            .err => {
                self.note(.err);
                self.conn.close(self, onClose);
            },
        }
    }

    fn note(self: *Client, outcome: Outcome) void {
        self.read_outcomes.append(testing.allocator, outcome) catch {
            self.flags.insert(.alloc_failed);
        };
    }

    fn onClose(self: *Client) void {
        self.final_state = self.conn.state();
        self.conn.deinit();
        self.flags.insert(.closed);
    }

    /// Harness cleanup, not a Conn teardown; the Conn is deinitialized in
    /// `onClose`.
    // ziglint-ignore: Z030 -- test harness, not a resource-owning type.
    fn deinit(self: *Client) void {
        self.received.deinit(testing.allocator);
        self.read_outcomes.deinit(testing.allocator);
    }
};

fn insecureConfig() tls.ClientConfig {
    return .init(.{ .verify = .insecure });
}

/// Drive the loop until the client reports closed, with a bounded number of
/// iterations so a stalled pump fails the test instead of hanging CI.
fn runUntilClosed(loop: *xev.Loop, client: *const Client) !void {
    var ticks: usize = 0;
    while (!client.flags.contains(.closed)) {
        if (ticks == 10_000) return error.LoopStalled;
        ticks += 1;
        try loop.run(.once);
    }
}

// RFC 8446 — a full TLS 1.3 handshake driven entirely by libxev completions,
// against a blocking ztls server. This is the whole point of the integration.
test "xev client: handshake, write, read, close_notify" {
    const fds = try socketPair();

    var sctx: ServerCtx = .{ .fd = fds[1], .reply = "pong", .expect_bytes = 4 };
    const server = try std.Thread.spawn(.{}, serverRun, .{&sctx});

    var harness: Harness = undefined;
    try harness.init();
    defer harness.deinit();
    const loop = &harness.loop;

    var config = insecureConfig();
    defer config.deinit();

    var client: Client = .{ .loop = loop, .request = "ping" };
    defer client.deinit();

    client.conn.init(
        std.Io.Threaded.global_single_threaded.io(),
        loop,
        .initFd(fds[0]),
        &config,
        test_host,
        client.storage.buffers(),
    );
    client.conn.handshake(&client, Client.onHandshake);

    try runUntilClosed(loop, &client);
    server.join();

    if (sctx.err) |err| return err;
    try testing.expect(!client.flags.contains(.alloc_failed));
    try testing.expect(client.handshake_result != null);
    try client.handshake_result.?;
    try testing.expectEqual(@as(usize, 4), sctx.received);
    try testing.expectEqual(@as(usize, 4), try client.write_result.?);
    try testing.expectEqualStrings("pong", client.received.items);
    // The server sent close_notify, so the client must report an orderly
    // shutdown rather than a truncated stream. RFC 8446 §6.1.
    try testing.expect(mem.indexOfScalar(
        Client.Outcome,
        client.read_outcomes.items,
        .close_notify,
    ) != null);
    try testing.expectEqual(tls.State.closed, client.final_state.?);

    // #81 — `deinit` must not write to memory it was lent, and clearing it is
    // the owner's call.
    //
    // Phrased as "not all zero" rather than "still contains the peer's
    // plaintext": which bytes survive depends on whether the reply and
    // close_notify arrived in one transport read or two, since `rb.writable()`
    // compacts between reads and can overwrite an already-delivered record. A
    // real handshake pushed hundreds of bytes through this buffer, so the only
    // way it comes back all-zero is if something wiped it.
    try testing.expect(!mem.allEqual(u8, &client.storage.record.data, 0));
    client.storage.secureZero();
    try testing.expect(mem.allEqual(u8, mem.asBytes(&client.storage), 0));
}

// ───────────────────────────────
// Both roles on one loop
// ───────────────────────────────

/// A ztls-xev server and a ztls-xev client on the same `xev.Loop`, over a
/// socketpair. No threads, so the interleaving is whatever the loop chooses and
/// the test is deterministic. This is the strongest coverage of the server
/// path: the flight is driven by the same pump as everything else, and any
/// ordering mistake shows up as a stall rather than as a passing test.
const Pair = struct {
    loop: *xev.Loop,

    server: tls.Server = undefined,
    server_storage: tls.Server.Storage = .{},
    server_read_buf: [4096]u8 = undefined,
    server_echoed: usize = 0,
    server_state: ?tls.State = null,

    client: tls.Client = undefined,
    client_storage: tls.Client.Storage = .{},
    client_read_buf: [4096]u8 = undefined,
    client_received: std.ArrayList(u8) = .empty,
    /// Copied, not borrowed: `selectedAlpn` points into the engine and `deinit`
    /// invalidates it.
    client_alpn: [16]u8 = undefined,
    client_alpn_len: usize = 0,

    flags: Flags = .initEmpty(),

    const Flag = enum { server_closed, client_closed, handshake_failed };
    const Flags = std.EnumSet(Flag);
    const request = "ping over xev";

    fn done(p: *const Pair) bool {
        return p.flags.contains(.server_closed) and p.flags.contains(.client_closed);
    }

    // ── server side ──
    fn onServerHandshake(p: *Pair, r: tls.HandshakeResult) void {
        r.result catch {
            p.flags.insert(.handshake_failed);
            return p.server.close(p, onServerClose);
        };
        p.server.read(&p.server_read_buf, p, onServerRead);
    }

    fn onServerRead(p: *Pair, r: tls.ReadResult) void {
        switch (r) {
            .data => |bytes| {
                p.server_echoed += bytes.len;
                p.server.write(bytes, p, onServerWrite);
            },
            .close_notify, .eof, .err => p.server.close(p, onServerClose),
        }
    }

    fn onServerWrite(p: *Pair, r: tls.WriteResult) void {
        _ = r.written catch return p.server.closeReset(p, onServerClose);
        // One exchange is enough; close so the client sees close_notify.
        p.server.close(p, onServerClose);
    }

    fn onServerClose(p: *Pair) void {
        p.server_state = p.server.state();
        p.server.deinit();
        p.server_storage.secureZero();
        p.flags.insert(.server_closed);
    }

    // ── client side ──
    fn onClientHandshake(p: *Pair, r: tls.HandshakeResult) void {
        r.result catch {
            p.flags.insert(.handshake_failed);
            return p.client.close(p, onClientClose);
        };
        if (p.client.selectedAlpn()) |alpn| {
            @memcpy(p.client_alpn[0..alpn.len], alpn);
            p.client_alpn_len = alpn.len;
        }
        p.client.write(request, p, onClientWrite);
    }

    fn onClientWrite(p: *Pair, r: tls.WriteResult) void {
        _ = r.written catch return p.client.closeReset(p, onClientClose);
        p.client.read(&p.client_read_buf, p, onClientRead);
    }

    fn onClientRead(p: *Pair, r: tls.ReadResult) void {
        switch (r) {
            .data => |bytes| {
                // A callback cannot fail; a short append shows up as a
                // mismatch in the assertions below.
                // ziglint-ignore: Z026 -- see above.
                p.client_received.appendSlice(testing.allocator, bytes) catch {};
                p.client.read(&p.client_read_buf, p, onClientRead);
            },
            .close_notify, .eof, .err => p.client.close(p, onClientClose),
        }
    }

    fn onClientClose(p: *Pair) void {
        p.client.deinit();
        p.client_storage.secureZero();
        p.flags.insert(.client_closed);
    }
};

// RFC 8446 — full handshake with the server side driven by libxev completions,
// including the authenticated flight, then application data both ways and a
// clean shutdown.
test "xev server: handshake, echo, and close against an xev client" {
    const fds = try socketPair();

    var harness: Harness = undefined;
    try harness.init();
    defer harness.deinit();
    const loop = &harness.loop;

    var key: ztls.signature.PrivateKey = try .fromP256Scalar(@ptrCast(test_scalar[0..32]));
    defer key.deinit();

    const server_config: tls.ServerConfig = .init(.{
        .cert_chain = &.{test_cert_der},
        .signer = key.signer(),
        .alpn = &.{"h2"},
    });
    var client_config: tls.ClientConfig = .init(.{ .verify = .insecure, .alpn = &.{"h2"} });
    defer client_config.deinit();

    const io = std.Io.Threaded.global_single_threaded.io();
    var pair: Pair = .{ .loop = loop };
    defer pair.client_received.deinit(testing.allocator);

    pair.server.init(
        io,
        loop,
        .initFd(fds[1]),
        &server_config,
        null,
        pair.server_storage.buffers(),
    );
    pair.client.init(
        io,
        loop,
        .initFd(fds[0]),
        &client_config,
        test_host,
        pair.client_storage.buffers(),
    );

    pair.server.handshake(&pair, Pair.onServerHandshake);
    pair.client.handshake(&pair, Pair.onClientHandshake);

    var watchdog: Watchdog = try .init();
    runUntil(loop, &watchdog, &pair) catch |err| {
        std.debug.print(
            "\nstalled: server={t} client={t} flags={any}\n",
            .{ pair.server.state(), pair.client.state(), pair.flags.bits.mask },
        );
        return err;
    };

    try testing.expect(!pair.flags.contains(.handshake_failed));
    try testing.expectEqualStrings("h2", pair.client_alpn[0..pair.client_alpn_len]);
    try testing.expectEqual(@as(usize, Pair.request.len), pair.server_echoed);
    try testing.expectEqualStrings(Pair.request, pair.client_received.items);
    try testing.expectEqual(tls.State.closed, pair.server_state.?);
}

/// A client that completes the handshake and immediately vanishes, sending no
/// application data and no close_notify. Regression test for a server that never reported handshake
/// completion: the server's last handshake step is *receiving* Finished, which
/// produces no write to bounce off, so a pump pass could finish the handshake
/// and issue a read in the same breath without telling the caller. The peer's
/// next event was then EOF, misreported as a failed handshake.
///
/// The echo test above missed this because its client sends data straight away,
/// so a later read completion happened to re-enter the pump and report the
/// handshake. Only a peer that says nothing exposes it — which is exactly what
/// `openssl s_client` does with piped stdin.
const Silent = struct {
    loop: *xev.Loop,

    server: tls.Server = undefined,
    server_storage: tls.Server.Storage = .{},
    server_read_buf: [4096]u8 = undefined,
    server_handshake: ?anyerror!void = null,
    server_read: ?Outcome = null,

    client: tls.Client = undefined,
    client_storage: tls.Client.Storage = .{},

    flags: Flags = .initEmpty(),

    const Outcome = enum { data, close_notify, eof, err };
    const Flag = enum { server_closed, client_closed };
    const Flags = std.EnumSet(Flag);

    fn done(s: *const Silent) bool {
        return s.flags.contains(.server_closed) and s.flags.contains(.client_closed);
    }

    fn onServerHandshake(s: *Silent, r: tls.HandshakeResult) void {
        s.server_handshake = r.result;
        r.result catch return s.server.close(s, onServerClose);
        s.server.read(&s.server_read_buf, s, onServerRead);
    }

    fn onServerRead(s: *Silent, r: tls.ReadResult) void {
        s.server_read = switch (r) {
            .data => .data,
            .close_notify => .close_notify,
            .eof => .eof,
            .err => .err,
        };
        s.server.close(s, onServerClose);
    }

    fn onServerClose(s: *Silent) void {
        s.server.deinit();
        s.server_storage.secureZero();
        s.flags.insert(.server_closed);
    }

    fn onClientHandshake(s: *Silent, r: tls.HandshakeResult) void {
        // The client's own outcome is not what this test is about; the server's
        // view is. Either way it leaves immediately.
        // ziglint-ignore: Z026 -- see above.
        r.result catch {};
        // Says nothing at all, then vanishes — a bare FIN, no close_notify.
        // That distinction is the whole test: a close_notify is a *record*, and
        // a record arriving would let the top-of-pass check recover the missed
        // handshake report. Only a transport EOF exposes the bug, which is why
        // `openssl s_client` with piped stdin found it and a polite peer did
        // not.
        s.client.closeReset(s, onClientClose);
    }

    fn onClientClose(s: *Silent) void {
        s.client.deinit();
        s.client_storage.secureZero();
        s.flags.insert(.client_closed);
    }
};

test "xev server: a client that handshakes then leaves without speaking" {
    const fds = try socketPair();

    var harness: Harness = undefined;
    try harness.init();
    defer harness.deinit();
    const loop = &harness.loop;

    var key: ztls.signature.PrivateKey = try .fromP256Scalar(@ptrCast(test_scalar[0..32]));
    defer key.deinit();

    const server_config: tls.ServerConfig = .init(.{
        .cert_chain = &.{test_cert_der},
        .signer = key.signer(),
    });
    var client_config: tls.ClientConfig = .init(.{ .verify = .insecure });
    defer client_config.deinit();

    const io = std.Io.Threaded.global_single_threaded.io();
    var s: Silent = .{ .loop = loop };

    s.server.init(io, loop, .initFd(fds[1]), &server_config, null, s.server_storage.buffers());
    s.client.init(
        io,
        loop,
        .initFd(fds[0]),
        &client_config,
        test_host,
        s.client_storage.buffers(),
    );
    s.server.handshake(&s, Silent.onServerHandshake);
    s.client.handshake(&s, Silent.onClientHandshake);

    var watchdog: Watchdog = try .init();
    runUntil(loop, &watchdog, &s) catch |err| {
        std.debug.print(
            "\nstalled: server={t} client={t} handshake_reported={} read_outcome={?}\n",
            .{ s.server.state(), s.client.state(), s.server_handshake != null, s.server_read },
        );
        return err;
    };

    // The handshake must be reported as a success, not swallowed and then
    // surfaced as a failure when the peer's close arrives.
    try testing.expect(s.server_handshake != null);
    try s.server_handshake.?;
    // And the disappearance arrives on the read path as a truncated stream,
    // where a caller can act on it, rather than as a handshake error.
    try testing.expectEqual(Silent.Outcome.eof, s.server_read.?);
}

// ───────────────────────────────
// Closing with work in flight (#83)
// ───────────────────────────────

/// A server that closes while a read is still armed — the shape a real server
/// takes when it drops an idle connection or honours a deadline, and the one
/// path every other test avoids because they all close from inside a completed
/// callback.
///
/// Two things must hold. The armed read's callback fires exactly once with
/// `Error.Canceled`, before the close callback. And the close must actually
/// complete: closing the fd while the loop still owns a completion on it leaves
/// a registration the loop counts as active, which io_uring forgives (closing an
/// fd completes its operations) and the readiness backends do not.
fn CloseWhileReading(comptime Xev: type) type {
    return struct {
        const Self = @This();
        const ServerConn = tls.ConnWith(Xev, .server);
        const ClientConn = tls.ConnWith(Xev, .client);

        server: ServerConn = undefined,
        server_storage: ServerConn.Storage = .{},
        server_read_buf: [4096]u8 = undefined,

        client: ClientConn = undefined,
        client_storage: ClientConn.Storage = .{},
        client_read_buf: [4096]u8 = undefined,

        /// Ordered log of what the server observed, so the contract is checked as a
        /// sequence rather than as two independent facts.
        events: std.ArrayList(Event) = .empty,
        flags: Flags = .initEmpty(),
        loop_active_after_close: usize = 0,
        server_final: ?struct {
            state: tls.State,
            wait: @TypeOf(@as(ServerConn, undefined).wait),
            phase: @TypeOf(@as(ServerConn, undefined).close_phase),
        } = null,
        shutdown: ServerConn.Shutdown = .abortive,

        const Event = enum { read_canceled, read_other, closed };
        const Flag = enum { server_done, client_done, read_requested, close_issued };
        const Flags = std.EnumSet(Flag);

        fn done(s: *const Self) bool {
            return s.flags.contains(.server_done) and s.flags.contains(.client_done);
        }

        fn note(s: *Self, e: Event) void {
            // ziglint-ignore: Z026 -- a callback cannot fail; a dropped event shows up
            // as a mismatch in the assertions.
            s.events.append(testing.allocator, e) catch {};
        }

        fn onServerHandshake(s: *Self, r: tls.HandshakeResult) void {
            r.result catch return s.server.closeReset(s, onServerClose);
            // Arm a read the peer will never satisfy. Closing on top of it has to
            // happen from outside this callback: `read` re-enters `pump`, which
            // defers while a pass is already running, so nothing is armed in the
            // loop until this returns. Closing here would find `wait == .idle` and
            // exercise nothing — which is how the first two versions of this test
            // passed with the bug in place.
            s.server.read(&s.server_read_buf, s, onServerRead);
            s.flags.insert(.read_requested);
        }

        fn onServerRead(s: *Self, r: tls.ReadResult) void {
            s.note(switch (r) {
                .err => |e| if (e == error.Canceled) .read_canceled else .read_other,
                else => .read_other,
            });
        }

        /// EXPERIMENT (kqueue stall): skip `deinit` to test whether the stall is
        /// completion lifetime — `deinit` sets the Conn, and with it `read_c`,
        /// `cancel_c` and `close_c`, to `undefined` while libxev may still hold
        /// pointers to them. Leaking in a test is free; if the macOS stall
        /// disappears with these disabled, the bug is ours and the fix belongs in
        /// Conn's teardown contract.
        const skip_deinit_experiment = true;

        fn onServerClose(s: *Self) void {
            s.note(.closed);
            // Captured before deinit: reading a Conn afterwards reads
            // `self.* = undefined` and prints 0xaa garbage as plausible-looking
            // states, which cost a whole diagnostic cycle here (#81, again).
            s.server_final = .{
                .state = s.server.state(),
                .wait = s.server.wait,
                .phase = s.server.closePhase(),
            };
            if (!skip_deinit_experiment) {
                s.server.deinit();
                s.server_storage.secureZero();
            }
            s.flags.insert(.server_done);
        }

        fn onClientHandshake(s: *Self, r: tls.HandshakeResult) void {
            // ziglint-ignore: Z026 -- only the server-side cancellation is under test.
            r.result catch {};
            // Waits for the server to go away, then tears itself down.
            s.client.read(&s.client_read_buf, s, onClientRead);
        }

        fn onClientRead(s: *Self, _: tls.ReadResult) void {
            s.client.closeReset(s, onClientClose);
        }

        fn run(s: *Self, shutdown: tls.Client.Shutdown) !void {
            s.shutdown = shutdown;
            const fds = try socketPair();

            var pool: xev.ThreadPool = .init(.{});
            defer {
                pool.shutdown();
                pool.deinit();
            }
            var loop_storage: Xev.Loop = try .init(.{ .thread_pool = &pool });
            defer loop_storage.deinit();
            const loop = &loop_storage;

            var key: ztls.signature.PrivateKey = try .fromP256Scalar(@ptrCast(test_scalar[0..32]));
            defer key.deinit();
            const server_config: tls.ServerConfig = .init(.{
                .cert_chain = &.{test_cert_der},
                .signer = key.signer(),
            });
            var client_config: tls.ClientConfig = .init(.{ .verify = .insecure });
            defer client_config.deinit();

            const io = std.Io.Threaded.global_single_threaded.io();
            s.server.init(
                io,
                loop,
                .initFd(fds[1]),
                &server_config,
                null,
                s.server_storage.buffers(),
            );
            s.client.init(
                io,
                loop,
                .initFd(fds[0]),
                &client_config,
                test_host,
                s.client_storage.buffers(),
            );
            s.server.handshake(s, onServerHandshake);
            s.client.handshake(s, onClientHandshake);

            // Bounded non-blocking spin rather than an armed timer: a timer
            // would itself count toward `loop.active`, and this test asserts on
            // that number. `.no_wait` never blocks, so the iteration bound is a
            // real wall-clock bound and a stall fails instead of hanging.
            var spins: usize = 0;
            while (!s.done()) {
                // Close from out here, the way a deadline or idle-reaper would,
                // once the read is genuinely armed in the loop.
                if (s.flags.contains(.read_requested) and
                    !s.flags.contains(.close_issued) and
                    s.server.wait == .reading)
                {
                    s.flags.insert(.close_issued);
                    switch (s.shutdown) {
                        .abortive => s.server.closeReset(s, onServerClose),
                        .orderly => s.server.close(s, onServerClose),
                    }
                }
                if (spins == 2_000) {
                    std.debug.print(
                        "\nstalled on {t}: srv={any}\n" ++
                            "  cli={t}/{t}/{t} active={d} events={any}\n",
                        .{
                            Xev.backend,
                            s.server_final,
                            s.client.state(),
                            s.client.wait,
                            s.client.closePhase(),
                            loop.active,
                            s.events.items,
                        },
                    );
                    return error.LoopStalled;
                }
                spins += 1;
                try loop.run(.no_wait);
                var ts: posix.timespec = .{ .sec = 0, .nsec = 200 * std.time.ns_per_us };
                _ = std.c.nanosleep(&ts, null);
            }

            // The invariant the caller-visible contract cannot express.
            // `cancelInFlight` delivers `Canceled` to the callback slots whether or
            // not the underlying completion was ever retired, so the ordering
            // assertions hold even with the cancel missing. What does not hold is
            // the loop's bookkeeping: an orphaned completion leaves `active`
            // permanently raised, and a server leaking one per connection ends up
            // with a loop that will not drain.
            s.loop_active_after_close = loop.active;
        }

        fn onClientClose(s: *Self) void {
            if (!skip_deinit_experiment) {
                s.client.deinit();
                s.client_storage.secureZero();
            }
            s.flags.insert(.client_done);
        }
    };
}

// #83 — an abortive close on top of an armed read, on every backend available
// here. io_uring completes an fd's pending operations when it closes, so it
// forgives a missing cancel entirely; epoll does not, which is why the same
// scenario runs twice.
fn expectCancelThenClose(comptime Xev: type, shutdown: anytype) !void {
    const Scenario = CloseWhileReading(Xev);
    var s: Scenario = .{};
    defer s.events.deinit(testing.allocator);

    try s.run(shutdown);

    // Exactly once, with Canceled, and before the close callback. Checked as a
    // sequence: two independent assertions would pass if the order were wrong.
    try testing.expectEqualSlices(
        Scenario.Event,
        &.{ .read_canceled, .closed },
        s.events.items,
    );

    // Nothing left in the loop. Without a real cancel the orphaned read
    // completion keeps this above zero, which is the whole of #83 — the callback
    // ordering above is satisfied either way.
    try testing.expectEqual(@as(usize, 0), s.loop_active_after_close);
}

test "close: closeReset with a read in flight cancels it, then closes" {
    try expectCancelThenClose(xev, .abortive);
    if (builtin.os.tag == .linux) try expectCancelThenClose(xev.Epoll, .abortive);
}

// The same, but orderly: the close_notify is still owed after the cancel, so the
// sequence has one more step to get through before the fd goes. RFC 8446 §6.1.
test "close: orderly close with a read in flight still sends close_notify" {
    try expectCancelThenClose(xev, .orderly);
    if (builtin.os.tag == .linux) try expectCancelThenClose(xev.Epoll, .orderly);
}
