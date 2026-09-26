//! Round-trip tests for the ztls-std public API.
//!
//! These live outside `root.zig` because they need certificate fixtures, and
//! the library module must not carry a test-fixture dependency into consumer
//! builds. Everything here goes through the public surface only.
const std = @import("std");
const builtin = @import("builtin");
const Io = std.Io;
const net = Io.net;
const mem = std.mem;
const posix = std.posix;
const assert = std.debug.assert;
const testing = std.testing;

const fixtures = @import("fixtures");
const ztls = @import("ztls");
const tls = @import("ztls_std");

const frame = ztls.frame;
const test_cert_der: []const u8 = &fixtures.server_ecdsa_cert_der;
const test_scalar: []const u8 = &fixtures.server_ecdsa_scalar;
const test_host = "ztls.server.test";
const client_cert_der: []const u8 = &fixtures.client_ecdsa_cert_der;
const client_scalar: []const u8 = &fixtures.client_ecdsa_scalar;

/// A client that retains the peer chain, to exercise `info().peer_chain`.
const IntrospectingClient = tls.ClientWith(.{
    .peer_chain_storage = ztls.ClientHandshake.recommended_handshake_storage,
});

fn testIo() Io {
    return testing.io;
}

/// Wrap a raw fd as a `net.Stream`. The address is unused by the read/write
/// vtable hooks ztls-std drives.
fn streamFor(fd: posix.fd_t) net.Stream {
    return .{ .socket = .{ .handle = fd, .address = .{ .ip4 = undefined } } };
}

fn socketPair() ![2]posix.fd_t {
    var fds: [2]posix.fd_t = undefined;
    try testing.expectEqual(
        @as(c_int, 0),
        std.c.socketpair(posix.AF.UNIX, posix.SOCK.STREAM, 0, &fds),
    );
    // On Darwin a write to a peer-closed socket raises SIGPIPE, and no test
    // runner suppresses it under 0.16, so a server thread that writes after
    // the client closes kills the whole suite — whether a given run hits
    // that race is scheduling luck (found by the ztest adoption turning a
    // latent hazard into a red macOS lane). Suppress it at the socket so the
    // write fails with EPIPE the way the test's error handling expects.
    if (builtin.os.tag == .macos) {
        const opt = mem.toBytes(@as(c_int, 1));
        for (fds) |fd|
            try posix.setsockopt(fd, posix.SOL.SOCKET, std.c.SO.NOSIGPIPE, &opt);
    }
    return fds;
}

test "option preflight reports hybrid policy faults without a socket" {
    const client_options: tls.Client.Options = .{
        .host = test_host,
        .verify = .insecure,
        .hybrid = .{ .initial_key_share = .x25519_mlkem768 },
    };
    try testing.expectError(error.InvalidHybridPolicy, client_options.validate());

    var key: ztls.signature.PrivateKey = try .fromP256Scalar(@ptrCast(test_scalar[0..32]));
    defer key.deinit();
    const server_options: tls.Server.Options = .{
        .cert_chain = &.{test_cert_der},
        .signer = key.signer(),
        .hybrid_groups = &.{ .x25519_mlkem768, .x25519_mlkem768 },
    };
    try testing.expectError(error.InvalidHybridPolicy, server_options.validate());
}

fn sleepMs(ms: u64) void {
    var ts: posix.timespec = .{
        .sec = @intCast(ms / std.time.ms_per_s),
        .nsec = @intCast((ms % std.time.ms_per_s) * std.time.ns_per_ms),
    };
    _ = std.c.nanosleep(&ts, null);
}

// ───────────────────────────────
// Scripted server thread
// ───────────────────────────────

/// What the test server does after the handshake. Each step is one flush, so
/// `.send` maps to one TLS record and the client sees the record boundaries the
/// step list describes.
const Step = union(enum) {
    /// Write bytes and flush: one TLS record.
    send: []const u8,
    /// Read exactly this many bytes before continuing.
    expect_bytes: usize,
    /// Read until close_notify / EOF, accumulating into `read_total`.
    drain,
    /// Hostile peer: emit N zero-length `application_data` records, which
    /// RFC 8446 §5.1 permits and rate-limits nowhere. Goes through the engine
    /// directly because the public Writer (correctly) drops empty writes.
    send_empty_records: usize,
    /// Send a post-handshake KeyUpdate. RFC 8446 §4.6.3.
    send_key_update: ztls.ServerHandshake.KeyUpdateRequest,
    /// Hostile peer: emit a record whose ciphertext has one flipped bit, so the
    /// AEAD tag cannot verify. RFC 8446 §5.2.
    send_corrupt_record,
    /// Abort with a fatal alert instead of close_notify. RFC 8446 §6.2.
    send_fatal_alert: ztls.alert.Description,
    /// Delay, to force the client to see a record boundary.
    pause_ms: u64,
    /// close_notify + socket close.
    close,
};

const ServerCtx = struct {
    fd: posix.fd_t,
    steps: []const Step,
    alpn: []const []const u8 = &.{},
    read_total: usize = 0,
    err: ?anyerror = null,
    done: Gate = .{},

    fn fail(ctx: *ServerCtx, err: anyerror) void {
        ctx.err = err;
    }
};

fn serverRun(ctx: *ServerCtx) void {
    defer ctx.done.open();
    const io = testIo();

    var key: ztls.signature.PrivateKey = ztls.signature.PrivateKey.fromP256Scalar(
        @ptrCast(test_scalar[0..32]),
    ) catch |err| {
        ctx.err = err;
        _ = std.c.close(ctx.fd);
        return;
    };
    defer key.deinit();

    var conn: tls.Server = undefined;
    conn.accept(io, streamFor(ctx.fd), .{
        .cert_chain = &.{test_cert_der},
        .signer = key.signer(),
        .alpn = ctx.alpn,
    }) catch |err| {
        ctx.err = err;
        return;
    };
    defer conn.deinit();

    const r = conn.reader();
    const w = conn.writer();

    for (ctx.steps) |step| switch (step) {
        .send => |bytes| {
            w.writeAll(bytes) catch |err| return ctx.fail(err);
            w.flush() catch |err| return ctx.fail(err);
        },
        .expect_bytes => |n| {
            var buf: [4096]u8 = undefined;
            var got: usize = 0;
            while (got < n) {
                const want = @min(buf.len, n - got);
                const read = r.readSliceShort(buf[0..want]) catch |err| return ctx.fail(err);
                if (read == 0) return ctx.fail(error.UnexpectedEof);
                got += read;
            }
            ctx.read_total += got;
        },
        .drain => while (true) {
            r.fillMore() catch |err| switch (err) {
                error.EndOfStream => break,
                else => return ctx.fail(err),
            };
            const chunk = r.buffered();
            ctx.read_total += chunk.len;
            r.toss(chunk.len);
        },
        .send_empty_records => |count| for (0..count) |_| {
            const record = conn.hs.sendApplicationData("", &conn.out.buffer) catch |err|
                return ctx.fail(err);
            const written = std.c.write(ctx.fd, record.ptr, record.len);
            conn.hs.completeWrite();
            if (written != @as(isize, @intCast(record.len))) return ctx.fail(error.ShortWrite);
        },
        .send_key_update => |request| {
            const record = conn.hs.sendKeyUpdate(&conn.out.buffer, request) catch |err|
                return ctx.fail(err);
            const written = std.c.write(ctx.fd, record.ptr, record.len);
            conn.hs.completeWrite();
            if (written != @as(isize, @intCast(record.len))) return ctx.fail(error.ShortWrite);
        },
        .send_corrupt_record => {
            const record = conn.hs.sendApplicationData("tamper", &conn.out.buffer) catch |err|
                return ctx.fail(err);
            // Flip a bit in the ciphertext body, past the 5-byte record header.
            const mutable = @constCast(record);
            mutable[frame.header_len] ^= 0x01;
            const written = std.c.write(ctx.fd, mutable.ptr, mutable.len);
            conn.hs.completeWrite();
            if (written != @as(isize, @intCast(mutable.len))) return ctx.fail(error.ShortWrite);
        },
        .send_fatal_alert => |description| {
            const record = conn.hs.sendAlert(description, &conn.out.buffer) catch |err|
                return ctx.fail(err);
            const written = std.c.write(ctx.fd, record.ptr, record.len);
            conn.hs.completeWrite();
            if (written != @as(isize, @intCast(record.len))) return ctx.fail(error.ShortWrite);
        },
        .pause_ms => |ms| sleepMs(ms),
        .close => conn.close(),
    };
}

fn spawnServer(ctx: *ServerCtx) !std.Thread {
    return std.Thread.spawn(.{}, serverRun, .{ctx});
}

// ───────────────────────────────
// Client-authenticated server thread
// ───────────────────────────────

/// Servers with client-identity retention storage: enough for the fixture
/// leaf (420 bytes DER), and deliberately too small for it.
const IdentityServer = tls.ServerWith(.{ .client_identity_storage = 1024 });
const TinyIdentityServer = tls.ServerWith(.{ .client_identity_storage = 8 });

/// Thread context for client-authentication cases. `identity` and
/// `identity_zeroed` mirror server-side state for main-thread assertions
/// after `join`.
const AuthServerCtx = struct {
    fd: posix.fd_t,
    client_auth: tls.ClientAuth,
    steps: []const Step,
    /// Copy of the retained client leaf DER (`info().client_identity` points
    /// into Stream storage that teardown zeroes, so a borrowed slice cannot
    /// cross the join). Empty means no identity was retained.
    identity_buf: [1024]u8 = undefined,
    identity_len: usize = 0,
    /// Set after teardown: the wrapper zeroed its identity storage.
    identity_zeroed: bool = false,
    err: ?anyerror = null,

    fn fail(ctx: *AuthServerCtx, err: anyerror) void {
        ctx.err = err;
    }

    fn identity(ctx: *const AuthServerCtx) ?[]const u8 {
        return if (ctx.identity_len == 0) null else ctx.identity_buf[0..ctx.identity_len];
    }
};

/// A client presenting the fixture credentials (or none) to a server with a
/// `client_auth` policy. RFC 8446 §4.4.2, §4.4.3.
fn clientCredentials() !ztls.signature.PrivateKey {
    return ztls.signature.PrivateKey.fromP256Scalar(@ptrCast(client_scalar[0..32]));
}

fn authServerRun(comptime Server: type) fn (*AuthServerCtx) void {
    return struct {
        fn run(ctx: *AuthServerCtx) void {
            authServerExchange(Server, ctx) catch |err| {
                ctx.err = err;
            };
        }
    }.run;
}

fn authServerExchange(comptime Server: type, ctx: *AuthServerCtx) !void {
    const io = testIo();
    var key: ztls.signature.PrivateKey = ztls.signature.PrivateKey.fromP256Scalar(
        @ptrCast(test_scalar[0..32]),
    ) catch |err| {
        ctx.err = err;
        _ = std.c.close(ctx.fd);
        return;
    };
    defer key.deinit();

    var conn: Server = undefined;
    conn.accept(io, streamFor(ctx.fd), .{
        .cert_chain = &.{test_cert_der},
        .signer = key.signer(),
        .client_auth = ctx.client_auth,
    }) catch |err| {
        ctx.err = err;
        return;
    };
    defer {
        conn.deinit();
        ctx.identity_zeroed = mem.allEqual(u8, &conn.client_identity_storage.data, 0);
    }
    if (conn.info().client_identity) |der| {
        assert(der.len <= ctx.identity_buf.len);
        @memcpy(ctx.identity_buf[0..der.len], der);
        ctx.identity_len = der.len;
    }

    const r = conn.reader();
    const w = conn.writer();
    for (ctx.steps) |step| switch (step) {
        .send => |bytes| {
            w.writeAll(bytes) catch |err| return ctx.fail(err);
            w.flush() catch |err| return ctx.fail(err);
        },
        .expect_bytes => |n| {
            var buf: [4096]u8 = undefined;
            var got: usize = 0;
            while (got < n) {
                const want = @min(buf.len, n - got);
                const read = r.readSliceShort(buf[0..want]) catch |err| return ctx.fail(err);
                if (read == 0) return ctx.fail(error.UnexpectedEof);
                got += read;
            }
        },
        .drain => while (true) {
            r.fillMore() catch |err| switch (err) {
                error.EndOfStream => break,
                else => return ctx.fail(err),
            };
            r.toss(r.bufferedLen());
        },
        .close => conn.close(),
        else => return ctx.fail(error.UnsupportedStep),
    };
}

// ───────────────────────────────
// Split-half test gates
// ───────────────────────────────

const Gate = struct {
    const State = enum(u8) { closed, open };
    state: std.atomic.Value(State) = .init(.closed),

    fn open(gate: *Gate) void {
        gate.state.store(.open, .release);
    }

    fn isOpen(gate: *const Gate) bool {
        return gate.state.load(.acquire) == .open;
    }

    fn wait(gate: *const Gate) !void {
        for (0..1_000_000) |_| {
            if (gate.isOpen()) return;
            std.Thread.yield() catch return error.TestGateFailed;
        }
        return error.TestGateTimedOut;
    }
};

// These masks intentionally mirror the private state word. They let tests wait
// for exact operation boundaries without sleeps or scheduler guesses.
const state_tx_update_pending: u8 = 1 << 4;
const state_tx_poisoned: u8 = 1 << 5;
const state_rx_busy: u8 = 1 << 6;
const state_tx_busy: u8 = 1 << 7;

const TearWriteState = enum { idle, armed, fail };
threadlocal var tear_write_state: TearWriteState = .idle;

const AbortWriteHarness = struct {
    const State = enum(u8) { idle, armed, blocked };
    const Shutdown = enum(u8) { none, recv, send, both };
    state: std.atomic.Value(State) = .init(.idle),
    shutdown: std.atomic.Value(Shutdown) = .init(.none),
    entered: Gate = .{},
    aborted: Gate = .{},
};
var abort_write_harness: *AbortWriteHarness = undefined;

fn tearingNetWrite(
    userdata: ?*anyopaque,
    handle: net.Socket.Handle,
    header: []const u8,
    data: []const []const u8,
    splat: usize,
) net.Stream.Writer.Error!usize {
    switch (tear_write_state) {
        .idle => return testIo().vtable.netWrite(userdata, handle, header, data, splat),
        .armed => {
            assert(header.len == 0);
            assert(data.len == 1);
            assert(splat == 1);
            assert(data[0].len > 7);
            tear_write_state = .fail;
            return 7;
        },
        .fail => {
            tear_write_state = .idle;
            return error.SocketUnconnected;
        },
    }
}

fn blockingNetWrite(
    userdata: ?*anyopaque,
    handle: net.Socket.Handle,
    header: []const u8,
    data: []const []const u8,
    splat: usize,
) net.Stream.Writer.Error!usize {
    if (abort_write_harness.state.cmpxchgStrong(
        .armed,
        .blocked,
        .acq_rel,
        .acquire,
    ) == null) {
        abort_write_harness.entered.open();
        abort_write_harness.aborted.wait() catch return error.Unexpected;
        return error.SocketUnconnected;
    }
    return testIo().vtable.netWrite(userdata, handle, header, data, splat);
}

fn blockingNetShutdown(
    userdata: ?*anyopaque,
    handle: net.Socket.Handle,
    how: net.ShutdownHow,
) net.ShutdownError!void {
    abort_write_harness.shutdown.store(switch (how) {
        .recv => .recv,
        .send => .send,
        .both => .both,
    }, .release);
    abort_write_harness.aborted.open();
    return testIo().vtable.netShutdown(userdata, handle, how);
}

fn waitState(conn: *const tls.Client, mask: u8) !void {
    for (0..1_000_000) |_| {
        if (conn.state.load(.acquire) & mask != 0) return;
        std.Thread.yield() catch return error.TestGateFailed;
    }
    return error.TestGateTimedOut;
}

const ClientReadCtx = struct {
    conn: *tls.Client,
    data: [16]u8 = undefined,
    len: usize = 0,
    err: ?anyerror = null,
    done: Gate = .{},
};

fn clientReadRun(ctx: *ClientReadCtx) void {
    defer ctx.done.open();
    ctx.len = ctx.conn.reader().readSliceShort(&ctx.data) catch |err| {
        ctx.err = if (err == error.ReadFailed)
            ctx.conn.readError() orelse err
        else
            err;
        return;
    };
}

const ClientWriteCtx = struct {
    conn: *tls.Client,
    data: []const u8,
    err: ?anyerror = null,
    done: Gate = .{},
};

fn clientWriteRun(ctx: *ClientWriteCtx) void {
    defer ctx.done.open();
    const w = ctx.conn.writer();
    w.writeAll(ctx.data) catch |err| {
        ctx.err = if (err == error.WriteFailed)
            ctx.conn.writeError() orelse err
        else
            err;
        return;
    };
    w.flush() catch |err| {
        ctx.err = if (err == error.WriteFailed)
            ctx.conn.writeError() orelse err
        else
            err;
    };
}

const KeyUpdateExpectation = enum { application_data, close_notify };
const KeyUpdateSource = enum { peer_request, published_request };

const KeyUpdateServerCtx = struct {
    fd: posix.fd_t,
    expectation: KeyUpdateExpectation = .application_data,
    source: KeyUpdateSource = .peer_request,
    ready: Gate = .{},
    release: Gate = .{},
    done: Gate = .{},
    err: ?anyerror = null,
};

fn keyUpdateServerRun(ctx: *KeyUpdateServerCtx) void {
    defer ctx.done.open();
    keyUpdateServerExchange(ctx) catch |err| {
        ctx.err = err;
    };
}

fn keyUpdateServerExchange(ctx: *KeyUpdateServerCtx) !void {
    const io = testIo();
    var key: ztls.signature.PrivateKey = try .fromP256Scalar(
        @ptrCast(test_scalar[0..32]),
    );
    defer key.deinit();

    var conn: tls.Server = undefined;
    try conn.accept(io, streamFor(ctx.fd), .{
        .cert_chain = &.{test_cert_der},
        .signer = key.signer(),
    });
    defer conn.deinit();

    ctx.ready.open();
    try ctx.release.wait();

    // RFC 8446 §4.6.3 — request a reciprocal key update. The client must
    // answer before its next application-data record.
    if (ctx.source == .peer_request) {
        const update = try conn.hs.sendKeyUpdate(
            &conn.out.buffer,
            .update_requested,
        );
        const written = std.c.write(ctx.fd, update.ptr, update.len);
        if (written != @as(isize, @intCast(update.len))) return error.ShortWrite;
        conn.hs.completeWrite();
    }

    var storage: [ztls.RecordBuffer.recommended_storage]u8 = undefined;
    var rb: ztls.RecordBuffer = .init(&storage);
    var stage: enum { response, application, done } = .response;
    while (stage != .done) {
        while (try rb.next()) |record| {
            const event = try conn.hs.receiveRecord(record);
            switch (event) {
                .key_update => |request| {
                    if (stage != .response or request != .update_not_requested)
                        return error.BadKeyUpdateOrder;
                    stage = .application;
                },
                .application_data => |data| {
                    if (ctx.expectation != .application_data or
                        stage != .application or
                        !mem.eql(u8, data, "payload"))
                    {
                        return error.BadApplicationOrder;
                    }
                    stage = .done;
                },
                .none => {},
                .closed => {
                    if (ctx.expectation != .close_notify or stage != .application)
                        return error.UnexpectedEof;
                    stage = .done;
                },
            }
            if (stage == .done) break;
        }
        if (stage == .done) break;
        const n = try posix.read(ctx.fd, rb.writable());
        if (n == 0) return error.UnexpectedEof;
        rb.advance(n);
    }

    if (ctx.expectation == .application_data) {
        const w = conn.writer();
        try w.writeAll("go");
        try w.flush();
    }
    conn.close();
}

const ClientCloseCtx = struct {
    conn: *tls.Client,
    started: Gate = .{},
    done: Gate = .{},
    err: ?tls.WriteError = null,
};

fn clientCloseRun(ctx: *ClientCloseCtx) void {
    defer ctx.done.open();
    ctx.started.open();
    ctx.conn.closeWrite();
    ctx.err = ctx.conn.writeError();
}

// ───────────────────────────────
// Tests
// ───────────────────────────────

// RFC 8446 — full TLS 1.3 handshake, application data both directions, ALPN,
// and clean close_notify over a socketpair.
test "round-trip: handshake, both directions, ALPN, close_notify" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: ServerCtx = .{
        .fd = fds[1],
        .alpn = &.{"h2"},
        .steps = &.{ .{ .expect_bytes = 18 }, .{ .send = "hello" }, .close },
    };
    const server = try spawnServer(&sctx);

    var gpa_state: std.heap.DebugAllocator(.{}) = .init;
    defer _ = gpa_state.deinit();

    var conn: IntrospectingClient = undefined;
    try conn.connect(io, streamFor(fds[0]), .{
        .host = test_host,
        .verify = .insecure,
        .alpn = &.{"h2"},
    });
    defer conn.deinit();

    try testing.expectEqualStrings("h2", conn.selectedAlpn().?);
    const info = conn.info();
    try testing.expectEqual(.aes_128_gcm_sha256, info.cipher_suite);
    try testing.expectEqualStrings("h2", info.alpn.?);
    try testing.expectEqual(@as(usize, 1), info.peer_chain.len);
    try testing.expectEqualSlices(u8, test_cert_der, info.peer_chain[0]);

    const w = conn.writer();
    try w.writeAll("GET / HTTP/1.0\r\n\r\n");
    try w.flush();

    const r = conn.reader();
    var buf: [5]u8 = undefined;
    const n = try r.readSliceShort(&buf);
    try testing.expectEqualStrings("hello", buf[0..n]);

    conn.close();
    server.join();
    if (sctx.err) |err| return err;
}

// RFC 8446 §5.2 — a blocked RX half does not own the TX sequence or output
// buffer. One writer can therefore send the record that unblocks its peer.
test "split halves: blocked read permits write progress" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: ServerCtx = .{
        .fd = fds[1],
        .steps = &.{ .{ .expect_bytes = 4 }, .{ .send = "pong" }, .close },
    };
    const server = try spawnServer(&sctx);
    defer server.join();

    var conn: tls.Client = undefined;
    try conn.connect(io, streamFor(fds[0]), .{
        .host = test_host,
        .verify = .insecure,
    });
    defer conn.deinit();

    var read_ctx: ClientReadCtx = .{ .conn = &conn };
    const reader_thread = try std.Thread.spawn(.{}, clientReadRun, .{&read_ctx});
    defer reader_thread.join();
    errdefer conn.abort();
    try waitState(&conn, state_rx_busy);

    var write_ctx: ClientWriteCtx = .{ .conn = &conn, .data = "ping" };
    const writer_thread = try std.Thread.spawn(.{}, clientWriteRun, .{&write_ctx});
    defer writer_thread.join();
    errdefer conn.abort();

    try write_ctx.done.wait();
    try read_ctx.done.wait();
    try sctx.done.wait();
    if (write_ctx.err) |err| return err;
    if (read_ctx.err) |err| return err;
    if (sctx.err) |err| return err;
    try testing.expectEqualStrings("pong", read_ctx.data[0..read_ctx.len]);
    try testing.expectEqual(@as(usize, 4), sctx.read_total);

    conn.close();
}

// RFC 8446 §4.6.3 — after RX accepts update_requested, the reciprocal
// KeyUpdate precedes the next application record and both use correct epochs.
test "split halves: KeyUpdate response precedes concurrent application data" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: KeyUpdateServerCtx = .{ .fd = fds[1] };
    const server_thread = try std.Thread.spawn(.{}, keyUpdateServerRun, .{&sctx});
    defer server_thread.join();

    var conn: tls.Client = undefined;
    try conn.connect(io, streamFor(fds[0]), .{
        .host = test_host,
        .verify = .insecure,
    });
    defer conn.deinit();
    try sctx.ready.wait();

    // Hold TX so the reader must publish the update request before either half
    // can write. This forces the ordering without sleeps.
    conn.tx_mutex.lockUncancelable(io);
    var lease_held = true;

    var read_ctx: ClientReadCtx = .{ .conn = &conn };
    const reader_thread = try std.Thread.spawn(.{}, clientReadRun, .{&read_ctx});
    defer reader_thread.join();
    errdefer conn.abort();
    sctx.release.open();
    waitState(&conn, state_tx_update_pending) catch |err| {
        conn.tx_mutex.unlock(io);
        lease_held = false;
        conn.abort();
        return err;
    };

    var write_ctx: ClientWriteCtx = .{ .conn = &conn, .data = "payload" };
    const writer_thread = std.Thread.spawn(.{}, clientWriteRun, .{&write_ctx}) catch |err| {
        conn.tx_mutex.unlock(io);
        lease_held = false;
        conn.abort();
        return err;
    };
    defer writer_thread.join();
    defer if (lease_held) conn.tx_mutex.unlock(io);
    errdefer conn.abort();

    try waitState(&conn, state_tx_busy);
    conn.tx_mutex.unlock(io);
    lease_held = false;

    try write_ctx.done.wait();
    try read_ctx.done.wait();
    try sctx.done.wait();
    if (write_ctx.err) |err| return err;
    if (read_ctx.err) |err| return err;
    if (sctx.err) |err| return err;
    try testing.expectEqualStrings("go", read_ctx.data[0..read_ctx.len]);

    conn.close();
}

// RFC 8446 §4.6.3 — every application-data boundary drains a KeyUpdate
// request that RX published before the writer acquired TX.
test "split halves: writer drains a published KeyUpdate request" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: KeyUpdateServerCtx = .{
        .fd = fds[1],
        .source = .published_request,
    };
    const server_thread = try std.Thread.spawn(.{}, keyUpdateServerRun, .{&sctx});
    defer server_thread.join();

    var conn: tls.Client = undefined;
    try conn.connect(io, streamFor(fds[0]), .{
        .host = test_host,
        .verify = .insecure,
    });
    defer conn.deinit();
    try sctx.ready.wait();

    _ = conn.state.fetchOr(state_tx_update_pending, .release);
    sctx.release.open();
    const w = conn.writer();
    try w.writeAll("payload");
    try w.flush();

    try sctx.done.wait();
    if (sctx.err) |err| return err;
    conn.close();
}

// RFC 8446 §4.6.3, §6.1 — close_notify drains an already published KeyUpdate
// request before it closes TX.
test "split halves: closeWrite drains a published KeyUpdate request" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: KeyUpdateServerCtx = .{
        .fd = fds[1],
        .expectation = .close_notify,
        .source = .published_request,
    };
    const server_thread = try std.Thread.spawn(.{}, keyUpdateServerRun, .{&sctx});
    defer server_thread.join();

    var conn: tls.Client = undefined;
    try conn.connect(io, streamFor(fds[0]), .{
        .host = test_host,
        .verify = .insecure,
    });
    defer conn.deinit();
    try sctx.ready.wait();

    _ = conn.state.fetchOr(state_tx_update_pending, .release);
    sctx.release.open();
    conn.closeWrite();

    try sctx.done.wait();
    if (sctx.err) |err| return err;
    conn.close();
}

// RFC 8446 §4.6.3, §6.1 — a pending KeyUpdate response precedes close_notify
// when the read half and close half compete for TX.
test "split halves: KeyUpdate response precedes concurrent close_notify" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: KeyUpdateServerCtx = .{
        .fd = fds[1],
        .expectation = .close_notify,
    };
    const server_thread = try std.Thread.spawn(.{}, keyUpdateServerRun, .{&sctx});
    defer server_thread.join();

    var conn: tls.Client = undefined;
    try conn.connect(io, streamFor(fds[0]), .{
        .host = test_host,
        .verify = .insecure,
    });
    defer conn.deinit();
    try sctx.ready.wait();

    conn.tx_mutex.lockUncancelable(io);
    var lease_held = true;

    var read_ctx: ClientReadCtx = .{ .conn = &conn };
    const reader_thread = try std.Thread.spawn(.{}, clientReadRun, .{&read_ctx});
    defer reader_thread.join();
    errdefer conn.abort();
    sctx.release.open();
    waitState(&conn, state_tx_update_pending) catch |err| {
        conn.tx_mutex.unlock(io);
        lease_held = false;
        conn.abort();
        return err;
    };

    var close_ctx: ClientCloseCtx = .{ .conn = &conn };
    const close_thread = std.Thread.spawn(.{}, clientCloseRun, .{&close_ctx}) catch |err| {
        conn.tx_mutex.unlock(io);
        lease_held = false;
        conn.abort();
        return err;
    };
    defer close_thread.join();
    defer if (lease_held) conn.tx_mutex.unlock(io);
    errdefer conn.abort();

    try close_ctx.started.wait();
    conn.tx_mutex.unlock(io);
    lease_held = false;

    try close_ctx.done.wait();
    try read_ctx.done.wait();
    try sctx.done.wait();
    if (close_ctx.err) |err| return err;
    if (read_ctx.err) |err| try testing.expectEqual(error.EndOfStream, err);
    try testing.expectEqual(@as(usize, 0), read_ctx.len);
    if (sctx.err) |err| return err;

    conn.close();
}

// RFC 8446 §5.3 — a failed transport write cannot release the record latch or
// reuse its sequence number. Later writes report TxPoisoned.
test "split halves: torn TX poisons later writes" {
    const base_io = testIo();
    var vtable = base_io.vtable.*;
    vtable.netWrite = tearingNetWrite;
    const io: Io = .{ .userdata = base_io.userdata, .vtable = &vtable };
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: ServerCtx = .{ .fd = fds[1], .steps = &.{.drain} };
    const server = try spawnServer(&sctx);
    defer server.join();

    var conn: tls.Client = undefined;
    try conn.connect(io, streamFor(fds[0]), .{
        .host = test_host,
        .verify = .insecure,
    });
    defer conn.deinit();

    const w = conn.writer();
    try w.writeAll("first");
    tear_write_state = .armed;
    try testing.expectError(error.WriteFailed, w.flush());
    try testing.expectEqual(error.SocketUnconnected, conn.writeError().?);
    try testing.expectEqual(TearWriteState.idle, tear_write_state);
    try testing.expect(conn.state.load(.acquire) & state_tx_poisoned != 0);
    try testing.expect(conn.hs.pending_write.isPending());

    try testing.expectError(error.WriteFailed, w.flush());
    try testing.expectEqual(error.TxPoisoned, conn.writeError().?);

    conn.close();
    try sctx.done.wait();
    if (sctx.err) |err| return err;
}

// RFC 8446 §6.1 — abort wakes a blocked half but does not tear down its state.
// The owner joins that half before deinit clears the connection.
test "split halves: abort wakes blocked read before teardown" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: ServerCtx = .{ .fd = fds[1], .steps = &.{.drain} };
    const server = try spawnServer(&sctx);
    defer server.join();

    var conn: tls.Client = undefined;
    try conn.connect(io, streamFor(fds[0]), .{
        .host = test_host,
        .verify = .insecure,
    });
    defer conn.deinit();

    var read_ctx: ClientReadCtx = .{ .conn = &conn };
    {
        const reader_thread = try std.Thread.spawn(.{}, clientReadRun, .{&read_ctx});
        defer reader_thread.join();
        errdefer conn.abort();
        try waitState(&conn, state_rx_busy);

        conn.abort();
        try read_ctx.done.wait();
        try testing.expectEqual(error.TlsAborted, read_ctx.err.?);
    }

    // Peer completion is not part of the abort contract. Close only after the
    // local half joins, then verify that the peer drains without error.
    conn.deinit();
    try sctx.done.wait();
    if (sctx.err) |err| return err;
}

// RFC 8446 §5.3, §6.1 — abort reaches the transport provider and wakes a
// writer after encryption but before transport progress.
test "split halves: abort wakes blocked write before teardown" {
    const base_io = testIo();
    var vtable = base_io.vtable.*;
    vtable.netWrite = blockingNetWrite;
    vtable.netShutdown = blockingNetShutdown;
    const io: Io = .{ .userdata = base_io.userdata, .vtable = &vtable };
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var harness: AbortWriteHarness = .{};
    abort_write_harness = &harness;

    var sctx: ServerCtx = .{ .fd = fds[1], .steps = &.{.drain} };
    const server = try spawnServer(&sctx);
    defer server.join();

    var conn: tls.Client = undefined;
    try conn.connect(io, streamFor(fds[0]), .{
        .host = test_host,
        .verify = .insecure,
    });
    defer conn.deinit();

    harness.state.store(.armed, .release);
    var write_ctx: ClientWriteCtx = .{ .conn = &conn, .data = "blocked" };
    {
        const writer_thread = try std.Thread.spawn(.{}, clientWriteRun, .{&write_ctx});
        defer writer_thread.join();
        errdefer conn.abort();

        try harness.entered.wait();
        conn.abort();
        try testing.expect(harness.aborted.isOpen());
        try testing.expectEqual(
            AbortWriteHarness.Shutdown.both,
            harness.shutdown.load(.acquire),
        );
        try write_ctx.done.wait();
        try testing.expectEqual(error.TlsAborted, write_ctx.err.?);
        try testing.expect(conn.hs.pending_write.isPending());
        try testing.expect(conn.state.load(.acquire) & state_tx_poisoned != 0);
    }

    conn.deinit();
    try sctx.done.wait();
    if (sctx.err) |err| return err;
}

// `Config.peer_chain_storage` defaults to null, so the default Client does not
// retain the chain: `info().peer_chain` is empty and the struct is smaller.
test "info: peer_chain is empty without peer_chain_storage" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: ServerCtx = .{ .fd = fds[1], .steps = &.{.close} };
    const server = try spawnServer(&sctx);

    var conn: tls.Client = undefined;
    try conn.connect(io, streamFor(fds[0]), .{ .host = test_host, .verify = .insecure });
    defer conn.deinit();

    try testing.expectEqual(@as(usize, 0), conn.info().peer_chain.len);

    conn.close();
    server.join();
    if (sctx.err) |err| return err;
}

// #81 — the core deliberately does not clear buffers it was lent, so whoever
// owns them must. Here that is the wrapper: `teardown` zeroes every buffer the
// Stream declares, including the retained chain and the record storage that
// held decrypted plaintext. Nothing else in the stack would.
test "deinit zeroes the wrapper's own buffers, including the retained chain" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: ServerCtx = .{ .fd = fds[1], .steps = &.{ .{ .send = "secret-payload" }, .drain } };
    const server = try spawnServer(&sctx);

    var conn: IntrospectingClient = undefined;
    try conn.connect(io, streamFor(fds[0]), .{ .host = test_host, .verify = .insecure });

    const r = conn.reader();
    try r.fillMore();
    try testing.expectEqualStrings("secret-payload", r.buffered());
    r.toss(r.bufferedLen());

    // Before teardown: the DER is retained in the Stream's storage and the
    // plaintext is in its record and read buffers.
    try testing.expect(mem.indexOf(u8, &conn.peer_chain_storage.data, test_cert_der) != null);
    try testing.expect(mem.indexOf(u8, &conn.read_storage.data, "secret-payload") != null);

    conn.deinit();

    try testing.expect(mem.allEqual(u8, &conn.peer_chain_storage.data, 0));
    try testing.expect(mem.allEqual(u8, &conn.read_storage.data, 0));
    try testing.expect(mem.allEqual(u8, &conn.storage.data, 0));
    try testing.expect(mem.allEqual(u8, &conn.reassembly.data, 0));

    server.join();
}

// A partially consumed record plus a `peek` past its end is the shape that
// breaks a reader whose buffer is the record itself: the stdlib rebases the
// leftover and asks for more, and the unconsumed tail must survive.
test "reader: peek past the current record keeps the unconsumed tail" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: ServerCtx = .{
        .fd = fds[1],
        .steps = &.{
            .{ .send = "0123456789" },
            .{ .pause_ms = 50 },
            .{ .send = "ABCDEFGHIJ" },
            .drain,
        },
    };
    const server = try spawnServer(&sctx);

    var conn: tls.Client = undefined;
    try conn.connect(io, streamFor(fds[0]), .{ .host = test_host, .verify = .insecure });
    defer conn.deinit();

    const r = conn.reader();
    try r.fillMore();
    try testing.expectEqual(@as(usize, 10), r.bufferedLen());
    r.toss(4);

    // Needs 8 bytes with only 6 buffered: crosses into the second record.
    try testing.expectEqualStrings("456789AB", try r.peek(8));
    // And the bytes before the peek are still gone, not resurrected.
    try testing.expectEqualStrings("456789ABCDEFGHIJ", try r.peek(16));

    conn.close();
    server.join();
    if (sctx.err) |err| return err;
}

// The line-oriented path an HTTP header parser uses. The delimiter lands in the
// second TLS record, so the reader must buffer across the record boundary.
test "reader: takeDelimiterInclusive spans a record boundary" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: ServerCtx = .{
        .fd = fds[1],
        .steps = &.{
            .{ .send = "HTTP/1.1 200 OK\r\nContent-Len" },
            .{ .pause_ms = 50 },
            .{ .send = "gth: 5\r\n\r\nhello" },
            .drain,
        },
    };
    const server = try spawnServer(&sctx);

    var conn: tls.Client = undefined;
    try conn.connect(io, streamFor(fds[0]), .{ .host = test_host, .verify = .insecure });
    defer conn.deinit();

    const r = conn.reader();
    try testing.expectEqualStrings("HTTP/1.1 200 OK\r\n", try r.takeDelimiterInclusive('\n'));
    try testing.expectEqualStrings("Content-Length: 5\r\n", try r.takeDelimiterInclusive('\n'));
    try testing.expectEqualStrings("\r\n", try r.takeDelimiterInclusive('\n'));

    var body: [5]u8 = undefined;
    try r.readSliceAll(&body);
    try testing.expectEqualStrings("hello", &body);

    conn.close();
    server.join();
    if (sctx.err) |err| return err;
}

// A line longer than the reader's look-ahead is a bounded, reported failure
// rather than an assert or silent truncation. `Config.read_buffer` is the knob.
test "reader: a line longer than read_buffer reports StreamTooLong" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    const line_len = frame.max_plaintext_len + 64;
    var sctx: ServerCtx = .{
        .fd = fds[1],
        // No newline anywhere in the first read_buffer bytes.
        .steps = &.{ .{ .send = &[_]u8{'x'} ** line_len }, .drain },
    };
    const server = try spawnServer(&sctx);

    var conn: tls.Client = undefined;
    try conn.connect(io, streamFor(fds[0]), .{ .host = test_host, .verify = .insecure });
    defer conn.deinit();

    const r = conn.reader();
    try testing.expectError(error.StreamTooLong, r.takeDelimiterInclusive('\n'));

    conn.close();
    server.join();
    if (sctx.err) |err| return err;
}

// Streaming straight to another writer moves record bytes to the sink without
// an intermediate copy through the reader's buffer.
test "reader: stream to a writer drains the connection" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: ServerCtx = .{
        .fd = fds[1],
        .steps = &.{ .{ .send = "abc" }, .{ .send = "def" }, .close },
    };
    const server = try spawnServer(&sctx);

    var conn: tls.Client = undefined;
    try conn.connect(io, streamFor(fds[0]), .{ .host = test_host, .verify = .insecure });
    defer conn.deinit();

    var sink_buf: [64]u8 = undefined;
    var sink: Io.Writer = .fixed(&sink_buf);
    _ = try conn.reader().streamRemaining(&sink);
    try testing.expectEqualStrings("abcdef", sink.buffered());

    conn.close();
    server.join();
    if (sctx.err) |err| return err;
}

// RFC 8446 §6.1 — close_notify is a write-side half-close; the peer's
// application data stays readable until its own close_notify arrives.
test "closeWrite: preserves the peer's response" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: ServerCtx = .{
        .fd = fds[1],
        .steps = &.{ .{ .expect_bytes = 4 }, .{ .send = "ok" }, .close },
    };
    const server = try spawnServer(&sctx);

    var conn: tls.Client = undefined;
    try conn.connect(io, streamFor(fds[0]), .{ .host = test_host, .verify = .insecure });
    defer conn.deinit();

    const w = conn.writer();
    try w.writeAll("ping");
    try w.flush();
    conn.closeWrite();

    const r = conn.reader();
    try r.fillMore();
    try testing.expectEqualStrings("ok", r.buffered());
    r.toss(2);
    try testing.expectError(error.EndOfStream, r.fillMore());

    server.join();
    if (sctx.err) |err| return err;
}

// RFC 8446 §4.6.3, §6.1 — a KeyUpdate request after our close_notify does not
// require a response when no later application record can be sent.
test "closeWrite: reads through a later KeyUpdate request" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: ServerCtx = .{
        .fd = fds[1],
        .steps = &.{
            .drain,
            .{ .send_key_update = .update_requested },
            .{ .send = "after" },
            .close,
        },
    };
    const server = try spawnServer(&sctx);

    var conn: tls.Client = undefined;
    try conn.connect(io, streamFor(fds[0]), .{ .host = test_host, .verify = .insecure });
    defer conn.deinit();
    conn.closeWrite();

    const r = conn.reader();
    var response: [5]u8 = undefined;
    try r.readSliceAll(&response);
    try testing.expectEqualStrings("after", &response);
    try testing.expectError(error.EndOfStream, r.fillMore());

    server.join();
    if (sctx.err) |err| return err;
}

// Staged plaintext the caller already handed to the Writer must reach the peer
// before close_notify, not get zeroed with the rest of the buffers.
test "close: flushes staged plaintext before close_notify" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: ServerCtx = .{ .fd = fds[1], .steps = &.{.drain} };
    const server = try spawnServer(&sctx);

    var conn: tls.Client = undefined;
    try conn.connect(io, streamFor(fds[0]), .{ .host = test_host, .verify = .insecure });
    defer conn.deinit();

    // Note the missing flush: close() owes the caller this write.
    try conn.writer().writeAll("unflushed");
    conn.close();

    server.join();
    if (sctx.err) |err| return err;
    try testing.expectEqual(@as(usize, "unflushed".len), sctx.read_total);
}

// RFC 8446 §5.1 — plaintext beyond max_plaintext_len splits across records.
test "writer: a large write spans multiple records" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    const payload_len = frame.max_plaintext_len * 2 + 137;
    var sctx: ServerCtx = .{
        .fd = fds[1],
        .steps = &.{ .{ .expect_bytes = payload_len }, .{ .send = "done" }, .close },
    };
    const server = try spawnServer(&sctx);

    var conn: tls.Client = undefined;
    try conn.connect(io, streamFor(fds[0]), .{ .host = test_host, .verify = .insecure });
    defer conn.deinit();

    var payload: [payload_len]u8 = undefined;
    for (&payload, 0..) |*b, i| b.* = @intCast(i & 0xff);
    const w = conn.writer();
    try w.writeAll(&payload);
    try w.flush();

    const r = conn.reader();
    var buf: [4]u8 = undefined;
    try r.readSliceAll(&buf);
    try testing.expectEqualStrings("done", &buf);

    conn.close();
    server.join();
    if (sctx.err) |err| return err;
    try testing.expectEqual(payload_len, sctx.read_total);
}

// A write after the write side is closed fails instead of silently dropping.
test "writer: rejects writes after closeWrite" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: ServerCtx = .{ .fd = fds[1], .steps = &.{.drain} };
    const server = try spawnServer(&sctx);

    var conn: tls.Client = undefined;
    try conn.connect(io, streamFor(fds[0]), .{ .host = test_host, .verify = .insecure });
    defer conn.deinit();

    conn.closeWrite();
    const w = conn.writer();
    // Enough to overflow the staging buffer so drain runs during writeAll.
    const big = [_]u8{'x'} ** (frame.max_plaintext_len + 1);
    try testing.expectError(error.WriteFailed, w.writeAll(&big));
    try testing.expectEqual(tls.WriteError.TlsClosed, conn.writeError().?);

    conn.close();
    server.join();
    if (sctx.err) |err| return err;
}

// `accept` with no credentials fails before touching the network, and the
// failure path still leaves the Stream teardown-safe (no undefined `deinit`).
test "accept: empty cert_chain fails and cleans up after itself" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var key: ztls.signature.PrivateKey = try .fromP256Scalar(@ptrCast(test_scalar[0..32]));
    defer key.deinit();

    var conn: tls.Server = undefined;
    try testing.expectError(error.MissingCredentials, conn.accept(io, streamFor(fds[1]), .{
        .cert_chain = &.{},
        .signer = key.signer(),
    }));
    // Documented as harmless after a failed accept.
    conn.deinit();
}

// #88 — `connect`/`accept` can fail before in-place init (local keygen), and
// that path cannot be forced without a backend-fault seam, so the pre-init
// cleanup is pinned directly through `abortBeforeInit`: the owned socket is
// closed (the peer sees EOF) and the closed sentinel keeps a later `deinit`
// the documented no-op.
test "abortBeforeInit: peer sees EOF and deinit stays a no-op" {
    const io = testIo();
    // Nonblocking on purpose: if the owned end is ever left open, the read
    // below must fail with EAGAIN, not block the suite forever.
    var fds: [2]posix.fd_t = undefined;
    try testing.expectEqual(@as(c_int, 0), std.c.socketpair(
        posix.AF.UNIX,
        posix.SOCK.STREAM,
        0,
        &fds,
    ));
    defer _ = std.c.close(fds[0]);

    // Darwin does not accept SOCK_NONBLOCK in socketpair's type argument.
    const flags = std.c.fcntl(fds[0], posix.F.GETFL);
    try testing.expect(flags >= 0);
    const nonblock: posix.O = .{ .NONBLOCK = true };
    try testing.expectEqual(@as(c_int, 0), std.c.fcntl(
        fds[0],
        posix.F.SETFL,
        flags | @as(c_int, @bitCast(nonblock)),
    ));

    var client: tls.Client = undefined;
    client.abortBeforeInit(io, streamFor(fds[1]));

    // Owned end closed: the peer reads EOF, not a leaked fd.
    var buf: [1]u8 = undefined;
    try testing.expectEqual(@as(usize, 0), try posix.read(fds[0], &buf));

    // The documented failure contract: later abort and deinit calls are
    // harmless and idempotent.
    client.abort();
    client.deinit();
    client.deinit();
}

// A hostname the fixture certificate does not cover must fail verification even
// with chain anchoring disabled, and the client must not report it as a generic
// protocol error.
test "connect: hostname mismatch surfaces as CertificateVerificationFailed" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: ServerCtx = .{ .fd = fds[1], .steps = &.{.drain} };
    const server = try spawnServer(&sctx);

    var conn: tls.Client = undefined;
    try testing.expectError(
        error.CertificateVerificationFailed,
        conn.connect(io, streamFor(fds[0]), .{
            .host = "wrong.example.com",
            .verify = .insecure,
        }),
    );
    conn.deinit();

    server.join();
    // The server sees the client's bad_certificate alert (RFC 8446 §6.2) as a
    // fatal peer alert rather than a truncated connection.
    try testing.expectEqual(@as(?anyerror, error.TlsAlertReceived), sctx.err);
}

// ALPN with no overlap: the server refuses, the client learns why from the
// server's no_application_protocol alert. RFC 7301 §3.2.
test "alpn: no overlap fails both sides with a reason" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: ServerCtx = .{ .fd = fds[1], .alpn = &.{"h2"}, .steps = &.{.drain} };
    const server = try spawnServer(&sctx);

    var conn: tls.Client = undefined;
    const result = conn.connect(io, streamFor(fds[0]), .{
        .host = test_host,
        .verify = .insecure,
        .alpn = &.{"spdy/1"},
    });
    try testing.expectError(error.TlsAlertReceived, result);
    conn.deinit();

    server.join();
    try testing.expectEqual(@as(?anyerror, error.NoApplicationProtocol), sctx.err);
}

// `Io.Reader` can only carry `error.ReadFailed`, which on its own cannot tell a
// cancelled task from a forged record from a dead socket. `readError()` recovers
// the cause, matching the `std.Io.net.Stream.Reader.err` convention.
test "readError: a forged record is reported as TlsDecryptError" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: ServerCtx = .{ .fd = fds[1], .steps = &.{ .send_corrupt_record, .drain } };
    const server = try spawnServer(&sctx);

    var conn: tls.Client = undefined;
    try conn.connect(io, streamFor(fds[0]), .{ .host = test_host, .verify = .insecure });
    defer conn.deinit();

    try testing.expectError(error.ReadFailed, conn.reader().fillMore());
    try testing.expectEqual(tls.ReadError.TlsDecryptError, conn.readError().?);

    conn.deinit();
    server.join();
}

// RFC 8446 §6.2 — a peer abort is a distinct outcome from a broken transport,
// and a caller that wants to log a reason needs to see which.
test "readError: a peer fatal alert is reported as TlsAlertReceived" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: ServerCtx = .{
        .fd = fds[1],
        .steps = &.{ .{ .send_fatal_alert = .internal_error }, .drain },
    };
    const server = try spawnServer(&sctx);

    var conn: tls.Client = undefined;
    try conn.connect(io, streamFor(fds[0]), .{ .host = test_host, .verify = .insecure });
    defer conn.deinit();

    try testing.expectError(error.ReadFailed, conn.reader().fillMore());
    try testing.expectEqual(tls.ReadError.TlsAlertReceived, conn.readError().?);

    conn.deinit();
    server.join();
}

// The cause is null until something actually fails, so a caller cannot mistake a
// stale value for a fresh failure on a healthy connection.
test "readError: null on a healthy connection" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: ServerCtx = .{ .fd = fds[1], .steps = &.{ .{ .send = "fine" }, .close } };
    const server = try spawnServer(&sctx);

    var conn: tls.Client = undefined;
    try conn.connect(io, streamFor(fds[0]), .{ .host = test_host, .verify = .insecure });
    defer conn.deinit();

    const r = conn.reader();
    try r.fillMore();
    try testing.expectEqualStrings("fine", r.buffered());
    try testing.expectEqual(@as(?tls.ReadError, null), conn.readError());
    try testing.expectEqual(@as(?tls.WriteError, null), conn.writeError());

    conn.close();
    server.join();
    if (sctx.err) |err| return err;
}

// RFC 8446 §5.1 allows zero-length application_data fragments and rate-limits
// them nowhere, so a peer could otherwise keep a read call from ever returning.
// The refill gives up instead of spinning forever.
test "reader: a flood of empty records is bounded, not an infinite read" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: ServerCtx = .{
        .fd = fds[1],
        .steps = &.{ .{ .send_empty_records = 200 }, .drain },
    };
    const server = try spawnServer(&sctx);

    var conn: tls.Client = undefined;
    try conn.connect(io, streamFor(fds[0]), .{ .host = test_host, .verify = .insecure });
    defer conn.deinit();

    // Not EndOfStream (the peer is still there) and not a hang.
    try testing.expectError(error.ReadFailed, conn.reader().fillMore());
    try testing.expectEqual(tls.ReadError.IdleRecordFlood, conn.readError().?);

    conn.deinit();
    server.join();
}

// A moderate number of empty records is legal padding and must not fail: the
// bound exists to stop a flood, not to reject the countermeasure.
test "reader: a few empty records are skipped, then real data arrives" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: ServerCtx = .{
        .fd = fds[1],
        .steps = &.{ .{ .send_empty_records = 8 }, .{ .send = "payload" }, .close },
    };
    const server = try spawnServer(&sctx);

    var conn: tls.Client = undefined;
    try conn.connect(io, streamFor(fds[0]), .{ .host = test_host, .verify = .insecure });
    defer conn.deinit();

    const r = conn.reader();
    var buf: [7]u8 = undefined;
    try r.readSliceAll(&buf);
    try testing.expectEqualStrings("payload", &buf);

    conn.close();
    server.join();
    if (sctx.err) |err| return err;
}

// hasBuffered lets a readiness loop drain records that arrived in one transport
// read without blocking on the next one.
test "hasBuffered: drains coalesced records without a transport read" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: ServerCtx = .{
        .fd = fds[1],
        .steps = &.{ .{ .send = "one" }, .{ .send = "two" }, .{ .send = "three" }, .close },
    };
    const server = try spawnServer(&sctx);

    var conn: tls.Client = undefined;
    try conn.connect(io, streamFor(fds[0]), .{ .host = test_host, .verify = .insecure });
    defer conn.deinit();

    const r = conn.reader();
    var seen: std.ArrayList(u8) = .empty;
    defer seen.deinit(testing.allocator);

    // One blocking read, then drain whatever else it delivered.
    try r.fillMore();
    while (true) {
        const chunk = r.buffered();
        try seen.appendSlice(testing.allocator, chunk);
        r.toss(chunk.len);
        if (!conn.hasBuffered()) break;
        r.fillMore() catch |err| switch (err) {
            error.EndOfStream => break,
            else => return err,
        };
    }
    try testing.expect(mem.startsWith(u8, seen.items, "one"));

    // hasBuffered does not promise that the peer finished its writes. Drain
    // the remaining payload before closing, or its next send can hit EPIPE.
    const expected = "onetwothree";
    try testing.expect(seen.items.len <= expected.len);
    var remaining: [expected.len]u8 = undefined;
    const rest = remaining[0 .. expected.len - seen.items.len];
    try r.readSliceAll(rest);
    try seen.appendSlice(testing.allocator, rest);
    try testing.expectEqualStrings(expected, seen.items);

    conn.close();
    server.join();
    if (sctx.err) |err| return err;
}

// ───────────────────────────────
// Client authentication (mTLS)
// ───────────────────────────────

// RFC 8446 §4.4.2, §4.4.3, §4.4.4 — required client auth over a socketpair:
// the client presents the fixture chain, the server verifies it (insecure
// anchoring: the self-signed fixture is its own root) and retains the exact
// leaf DER, and application data flows both directions. The wrapper zeroes
// its identity storage on teardown (#81: the core never clears lent buffers).
test "client auth: required insecure mTLS retains the exact client leaf DER" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: AuthServerCtx = .{
        .fd = fds[1],
        .client_auth = .{ .required = .insecure },
        .steps = &.{ .{ .expect_bytes = 4 }, .{ .send = "pong" }, .close },
    };
    const server = try std.Thread.spawn(.{}, authServerRun(IdentityServer), .{&sctx});

    var client_key = try clientCredentials();
    defer client_key.deinit();
    var conn: tls.Client = undefined;
    try conn.connect(io, streamFor(fds[0]), .{
        .host = test_host,
        .verify = .insecure,
        .client_credentials = .{
            .cert_chain = &.{client_cert_der},
            .signer = client_key.signer(),
        },
    });
    defer conn.deinit();

    // A client Stream never carries a client identity, credentials or not.
    try testing.expectEqual(@as(?[]const u8, null), conn.info().client_identity);

    const w = conn.writer();
    try w.writeAll("ping");
    try w.flush();
    const r = conn.reader();
    var buf: [4]u8 = undefined;
    try r.readSliceAll(&buf);
    try testing.expectEqualStrings("pong", &buf);
    conn.close();

    server.join();
    if (sctx.err) |err| return err;
    // The retained identity is the exact fixture DER, byte for byte.
    try testing.expectEqualSlices(u8, client_cert_der, sctx.identity().?);
    // And teardown zeroed the wrapper-owned storage that held it.
    try testing.expect(sctx.identity_zeroed);
}

// RFC 8446 §4.4.2 — optional client auth accepts an empty client
// Certificate: the handshake completes and no identity is retained.
test "client auth: optional with no client certificate succeeds, identity null" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: AuthServerCtx = .{
        .fd = fds[1],
        .client_auth = .{ .optional = .insecure },
        .steps = &.{ .{ .send = "ok" }, .close },
    };
    const server = try std.Thread.spawn(.{}, authServerRun(IdentityServer), .{&sctx});

    var conn: tls.Client = undefined;
    try conn.connect(io, streamFor(fds[0]), .{
        .host = test_host,
        .verify = .insecure,
    });
    defer conn.deinit();

    const r = conn.reader();
    var buf: [2]u8 = undefined;
    try r.readSliceAll(&buf);
    try testing.expectEqualStrings("ok", &buf);
    conn.close();

    server.join();
    if (sctx.err) |err| return err;
    try testing.expectEqual(@as(?[]const u8, null), sctx.identity());
}

// RFC 8446 §4.4.2 — required client auth with no client certificate is a
// rejection on the server and a certificate_required alert on the client.
test "client auth: required with no client certificate is rejected" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: AuthServerCtx = .{
        .fd = fds[1],
        .client_auth = .{ .required = .insecure },
        .steps = &.{.drain},
    };
    const server = try std.Thread.spawn(.{}, authServerRun(IdentityServer), .{&sctx});

    var conn: tls.Client = undefined;
    // The client's Finished is already on the wire when the server verifies
    // the (missing) certificate, so connect cannot carry the verdict: the
    // rejection surfaces on the read path. RFC 8446 §4.4.2, §4.4.4. The
    // server's post-Finished alert uses application traffic keys, so the
    // client receives a peer alert rather than reporting an AEAD failure.
    try conn.connect(io, streamFor(fds[0]), .{
        .host = test_host,
        .verify = .insecure,
    });
    defer conn.deinit();

    try testing.expectError(error.ReadFailed, conn.reader().fillMore());
    try testing.expectEqual(tls.ReadError.TlsAlertReceived, conn.readError().?);

    server.join();
    try testing.expectEqual(@as(?anyerror, error.ClientCertificateRejected), sctx.err);
}

// An empty credential chain is unusable caller configuration: rejected as
// InvalidOptions before any wire I/O, so the peer sees a bare EOF (the owned
// socket is closed by the failure path), and a later deinit stays a no-op.
test "client credentials: empty chain is InvalidOptions before wire I/O" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: ServerCtx = .{ .fd = fds[1], .steps = &.{.drain} };
    const server = try spawnServer(&sctx);

    var client_key = try clientCredentials();
    defer client_key.deinit();
    var conn: tls.Client = undefined;
    try testing.expectError(error.InvalidOptions, conn.connect(io, streamFor(fds[0]), .{
        .host = test_host,
        .verify = .insecure,
        .client_credentials = .{ .cert_chain = &.{}, .signer = client_key.signer() },
    }));
    conn.deinit();

    server.join();
    // The server thread observed EOF (a truncated handshake), not a hang.
    try testing.expectEqual(@as(?anyerror, error.HandshakeProtocolError), sctx.err);
}

// RFC 8446 §4.4.2 — a verified client leaf that cannot fit
// `Config.client_identity_storage` is a sizing fault, not a rejected
// certificate: the server reports HandshakeBufferTooShort and the client sees
// the resulting fatal alert.
test "client auth: undersized identity storage surfaces HandshakeBufferTooShort" {
    const io = testIo();
    const fds = try socketPair();
    defer _ = std.c.close(fds[0]);

    var sctx: AuthServerCtx = .{
        .fd = fds[1],
        .client_auth = .{ .required = .insecure },
        .steps = &.{.drain},
    };
    const server = try std.Thread.spawn(.{}, authServerRun(TinyIdentityServer), .{&sctx});

    var client_key = try clientCredentials();
    defer client_key.deinit();
    var conn: tls.Client = undefined;
    // Same verdict timing as the no-certificate case: the client's flight was
    // already sent, so the fatal alert lands on the read path.
    try conn.connect(io, streamFor(fds[0]), .{
        .host = test_host,
        .verify = .insecure,
        .client_credentials = .{
            .cert_chain = &.{client_cert_der},
            .signer = client_key.signer(),
        },
    });
    defer conn.deinit();

    try testing.expectError(error.ReadFailed, conn.reader().fillMore());
    try testing.expectEqual(tls.ReadError.TlsAlertReceived, conn.readError().?);

    server.join();
    try testing.expectEqual(@as(?anyerror, error.HandshakeBufferTooShort), sctx.err);
    try testing.expectEqual(@as(?[]const u8, null), sctx.identity());
}
