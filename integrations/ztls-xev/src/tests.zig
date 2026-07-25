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

    var loop: xev.Loop = try .init(.{});
    defer loop.deinit();

    var config = insecureConfig();
    defer config.deinit();

    var client: Client = .{ .loop = &loop, .request = "ping" };
    defer client.deinit();

    client.conn.init(
        std.Io.Threaded.global_single_threaded.io(),
        &loop,
        .initFd(fds[0]),
        &config,
        test_host,
        client.storage.buffers(),
    );
    client.conn.handshake(&client, Client.onHandshake);

    try runUntilClosed(&loop, &client);
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

    var loop: xev.Loop = try .init(.{});
    defer loop.deinit();

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
    var pair: Pair = .{ .loop = &loop };
    defer pair.client_received.deinit(testing.allocator);

    pair.server.init(
        io,
        &loop,
        .initFd(fds[1]),
        &server_config,
        null,
        pair.server_storage.buffers(),
    );
    pair.client.init(
        io,
        &loop,
        .initFd(fds[0]),
        &client_config,
        test_host,
        pair.client_storage.buffers(),
    );

    pair.server.handshake(&pair, Pair.onServerHandshake);
    pair.client.handshake(&pair, Pair.onClientHandshake);

    var ticks: usize = 0;
    while (!pair.done()) {
        if (ticks == 10_000) return error.LoopStalled;
        ticks += 1;
        try loop.run(.once);
    }

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

    var loop: xev.Loop = try .init(.{});
    defer loop.deinit();

    var key: ztls.signature.PrivateKey = try .fromP256Scalar(@ptrCast(test_scalar[0..32]));
    defer key.deinit();

    const server_config: tls.ServerConfig = .init(.{
        .cert_chain = &.{test_cert_der},
        .signer = key.signer(),
    });
    var client_config: tls.ClientConfig = .init(.{ .verify = .insecure });
    defer client_config.deinit();

    const io = std.Io.Threaded.global_single_threaded.io();
    var s: Silent = .{ .loop = &loop };

    s.server.init(io, &loop, .initFd(fds[1]), &server_config, null, s.server_storage.buffers());
    s.client.init(
        io,
        &loop,
        .initFd(fds[0]),
        &client_config,
        test_host,
        s.client_storage.buffers(),
    );
    s.server.handshake(&s, Silent.onServerHandshake);
    s.client.handshake(&s, Silent.onClientHandshake);

    var ticks: usize = 0;
    while (!s.done()) {
        if (ticks == 10_000) return error.LoopStalled;
        ticks += 1;
        try loop.run(.once);
    }

    // The handshake must be reported as a success, not swallowed and then
    // surfaced as a failure when the peer's close arrives.
    try testing.expect(s.server_handshake != null);
    try s.server_handshake.?;
    // And the disappearance arrives on the read path as a truncated stream,
    // where a caller can act on it, rather than as a handshake error.
    try testing.expectEqual(Silent.Outcome.eof, s.server_read.?);
}
