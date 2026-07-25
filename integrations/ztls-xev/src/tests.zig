//! Round-trip tests: a ztls-xev client driven by a real libxev loop, against a
//! ztls-std server on a thread. Two integrations of the same core talking to
//! each other is the strongest available proof that the completion-driven pump
//! and the blocking drive loop agree on the protocol.
const std = @import("std");
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
    conn: tls.Conn = undefined,
    loop: *xev.Loop,

    storage: tls.Conn.Storage = .{},
    read_buf: [4096]u8 = undefined,

    /// Script: what to do once established.
    request: []const u8 = &.{},

    handshake_result: ?anyerror!void = null,
    alpn_seen: ?[]const u8 = null,
    received: std.ArrayList(u8) = .empty,
    read_outcomes: std.ArrayList(Outcome) = .empty,
    write_result: ?anyerror!usize = null,
    closed: bool = false,
    /// Captured before `deinit`, which sets the Conn to undefined — asserting on
    /// a deinitialized Conn proves nothing (#81).
    final_state: ?tls.State = null,
    alloc_failed: bool = false,

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
                    self.alloc_failed = true;
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
            self.alloc_failed = true;
        };
    }

    fn onClose(self: *Client) void {
        self.final_state = self.conn.state();
        self.conn.deinit();
        self.closed = true;
    }

    /// Harness cleanup, not a Conn teardown; the Conn is deinitialized in
    /// `onClose`.
    // ziglint-ignore: Z030 -- test harness, not a resource-owning type.
    fn deinit(self: *Client) void {
        self.received.deinit(testing.allocator);
        self.read_outcomes.deinit(testing.allocator);
    }
};

fn insecureConfig() tls.Config {
    return .init(.{ .verify = .insecure });
}

/// Drive the loop until the client reports closed, with a bounded number of
/// iterations so a stalled pump fails the test instead of hanging CI.
fn runUntilClosed(loop: *xev.Loop, client: *const Client) !void {
    var ticks: usize = 0;
    while (!client.closed) {
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
    try testing.expect(!client.alloc_failed);
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

    // #81 — `deinit` must not write to memory it was lent. The peer's plaintext
    // is still sitting in the record buffer afterwards, and clearing it is the
    // owner's call.
    try testing.expect(mem.indexOf(u8, &client.storage.record.data, "pong") != null);
    client.storage.secureZero();
    try testing.expect(mem.allEqual(u8, &client.storage.record.data, 0));
    try testing.expect(mem.allEqual(u8, &client.storage.out.data, 0));
    try testing.expect(mem.allEqual(u8, &client.storage.reassembly.data, 0));
}
