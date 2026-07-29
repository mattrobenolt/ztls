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
const testing = std.testing;

const fixtures = @import("fixtures");
const ztls = @import("ztls");
const tls = @import("ztls_std");

const frame = ztls.frame;
const test_cert_der: []const u8 = &fixtures.server_ecdsa_cert_der;
const test_scalar: []const u8 = &fixtures.server_ecdsa_scalar;
const test_host = "ztls.server.test";

/// A client that retains the peer chain, to exercise `info().peer_chain`.
const IntrospectingClient = tls.ClientWith(.{
    .peer_chain_storage = ztls.ClientHandshake.recommended_handshake_storage,
});

fn testIo() Io {
    return Io.Threaded.global_single_threaded.io();
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

    fn fail(ctx: *ServerCtx, err: anyerror) void {
        ctx.err = err;
    }
};

fn serverRun(ctx: *ServerCtx) void {
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

    conn.close();
    server.join();
    if (sctx.err) |err| return err;
}
