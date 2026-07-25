//! TLS 1.3 client running on the zio runtime instead of `std.Io.Threaded`.
//!
//! zio (https://github.com/lalinsky/zio) is a stackful-coroutine runtime that
//! ships a full `std.Io` implementation. ztls-std targets that interface, so
//! there is no zio-specific adapter and no `ztls-zio` package: `rt.io()` goes
//! straight into `Client.connect` and everything else is identical to
//! `tls_client.zig`. This example exists to prove that and to show the one
//! thing the runtime genuinely adds on top.
//!
//! That one thing is a deadline. ztls-std imposes no timeout of its own — a
//! slow peer can stall `connect` or a read indefinitely — because the right
//! mechanism is `std.Io` cancellation, which belongs to whoever owns the
//! runtime. Here the whole fetch races a sleep through `Io.Select`; whichever
//! finishes first cancels the other. When the deadline wins, the cancellation
//! reaches ztls-std as `error.Canceled` from the transport, and
//! `Client.readError()` / `Client.connectError` recovers it from the
//! `error.ReadFailed` that the `Io.Reader` vtable is limited to carrying.
//!
//! Usage:
//!     zig build example-zio_client -- --host example.com
//!     zig build example-zio_client -- --host example.com --timeout-ms 5
//!     zig build example-zio_client -- --host 127.0.0.1 --port 8443 --insecure
const std = @import("std");
const assert = std.debug.assert;
const Io = std.Io;
const net = Io.net;
const mem = std.mem;
const print = std.debug.print;

const zio = @import("zio");
const tls = @import("ztls_std");

// Route std.log / std.debug.print through zio so they cannot block the loop.
pub const std_options_debug_io = zio.debug_io;

/// Retain the verified chain so `info().peer_chain` can report it.
const Client = tls.ClientWith(.{
    .peer_chain_storage = tls.core.ClientHandshake.recommended_handshake_storage,
});

const usage =
    \\Usage: zio_client --host <host> [--port <port>] [--insecure] [--alpn <proto>]
    \\                  [--timeout-ms <ms>] [--path <path>]
    \\
    \\Options:
    \\  --host <host>       Server hostname or IP (required). Used for SNI + verification.
    \\  --port <port>       Port number (default: 443).
    \\  --insecure          Skip certificate chain verification (demo/test only).
    \\  --alpn <proto>      ALPN protocol to offer (default: http/1.1).
    \\  --timeout-ms <ms>   Deadline for the whole exchange (default: 10000). Lower
    \\                      it to watch cancellation surface through readError().
    \\  --path <path>       HTTP path to GET (default: /).
    \\  --no-request        Complete the handshake, then read without sending
    \\                      anything. The peer has nothing to say, so the deadline
    \\                      lands inside a read — which is the path that needs
    \\                      readError() to tell cancellation from a dead peer.
    \\
;

fn die(comptime fmt: []const u8, args: anytype) noreturn {
    print("[zio] " ++ fmt ++ "\n", args);
    std.process.exit(1);
}

const Options = struct {
    host: []const u8,
    port: u16 = 443,
    insecure: bool = false,
    alpn: []const u8 = "http/1.1",
    timeout_ms: u64 = 10_000,
    path: []const u8 = "/",
    no_request: bool = false,
};

/// What the fetch fiber reports back. The fiber owns the connection for its
/// whole lifetime, so nothing else touches the Stream.
const Fetch = struct {
    options: Options,
    gpa: mem.Allocator,
    io: Io,

    status_line: []const u8 = &.{},
    body_bytes: usize = 0,
    /// Failure the fiber ended on, already resolved to a real cause rather than
    /// a bare `ReadFailed`/`WriteFailed`.
    failure: ?anyerror = null,
    /// Set once the TLS handshake completed, so the caller can tell a
    /// handshake-phase deadline apart from a transfer-phase one.
    connected: bool = false,

    fn run(f: *Fetch) void {
        const io = f.io;
        const o = f.options;

        const host_name = net.HostName.init(o.host) catch |err| return f.fail(err);
        const sock = host_name.connect(io, o.port, .{ .mode = .stream }) catch |err|
            return f.fail(err);

        // Eager handshake: cert verification, ALPN, and alerts all surface
        // here. `ConnectError` already carries `Io.Cancelable`, so a deadline
        // during the handshake arrives as `error.Canceled` directly — no
        // recovery step needed on this path.
        var conn: Client = undefined;
        conn.connect(io, sock, .{
            .host = o.host,
            .verify = if (o.insecure) .insecure else .{ .system_bundle = f.gpa },
            .alpn = &.{o.alpn},
        }) catch |err| return f.fail(err);
        defer conn.deinit();

        f.connected = true;
        const info = conn.info();
        print("[zio] handshake complete\n", .{});
        print("[zio]   host: {s}:{d}\n", .{ o.host, o.port });
        print("[zio]   ALPN: {s}\n", .{info.alpn orelse "(none)"});
        print("[zio]   cipher: {t}\n", .{info.cipher_suite});
        print("[zio]   peer certificates: {d}\n", .{info.peer_chain.len});
        print("[zio]   verification: {s}\n", .{
            if (o.insecure) "skipped (--insecure)" else "system bundle",
        });

        if (o.no_request) {
            print("[zio] --no-request: reading without asking for anything\n", .{});
        } else {
            const w = conn.writer();
            w.print("GET {s} HTTP/1.0\r\nHost: {s}\r\nConnection: close\r\n\r\n", .{
                o.path, o.host,
            }) catch return f.failWrite(&conn);
            w.flush() catch return f.failWrite(&conn);
        }

        // Header lines span TLS record boundaries on any real response; the
        // reader buffers across them like any other `Io.Reader`.
        const r = conn.reader();
        f.status_line = r.takeDelimiterInclusive('\n') catch |err| switch (err) {
            error.ReadFailed => return f.failRead(&conn),
            else => return f.fail(err),
        };
        print("[zio] {s}", .{f.status_line});

        while (true) {
            // Drain what is buffered before asking for more, so the
            // `EndOfStream` from the final read does not discard the tail.
            const chunk = r.buffered();
            if (chunk.len > 0) {
                f.body_bytes += chunk.len;
                r.toss(chunk.len);
                continue;
            }
            r.fillMore() catch |err| switch (err) {
                error.EndOfStream => break, // close_notify or peer hang-up
                error.ReadFailed => return f.failRead(&conn),
            };
        }

        conn.close();
    }

    fn fail(f: *Fetch, err: anyerror) void {
        f.failure = err;
    }

    /// Turn the vtable's opaque `ReadFailed` into the real cause.
    fn failRead(f: *Fetch, conn: *Client) void {
        f.failure = conn.readError() orelse error.ReadFailed;
    }

    fn failWrite(f: *Fetch, conn: *Client) void {
        f.failure = conn.writeError() orelse error.WriteFailed;
    }
};

fn fetchTask(f: *Fetch) void {
    f.run();
}

/// The losing arm of the race. When the fetch finishes first, `Select.cancel`
/// cancels this sleep, so `error.Canceled` here is the expected outcome and the
/// only one available.
fn deadline(io: Io, ms: u64) void {
    // ziglint-ignore: Z026 -- Cancelable is the whole error set, and being
    // cancelled means the fetch won, which the caller already knows.
    io.sleep(.{ .nanoseconds = @intCast(ms * std.time.ns_per_ms) }, .awake) catch {};
}

/// Whichever arm finishes first wins; `Select.cancel` stops the other.
const Race = union(enum) {
    fetch: void,
    deadline: void,
};

pub fn main(init: std.process.Init) !void {
    var args = init.minimal.args.iterate();
    _ = args.skip();

    var host: ?[]const u8 = null;
    var o: Options = .{ .host = "" };

    while (args.next()) |arg| {
        if (mem.eql(u8, arg, "--host")) {
            host = args.next() orelse die("missing value for --host\n{s}", .{usage});
        } else if (mem.eql(u8, arg, "--port")) {
            const raw = args.next() orelse die("missing value for --port\n{s}", .{usage});
            o.port = std.fmt.parseInt(u16, raw, 10) catch die("invalid port: {s}", .{raw});
        } else if (mem.eql(u8, arg, "--timeout-ms")) {
            const raw = args.next() orelse die("missing value for --timeout-ms\n{s}", .{usage});
            o.timeout_ms = std.fmt.parseInt(u64, raw, 10) catch
                die("invalid timeout: {s}", .{raw});
        } else if (mem.eql(u8, arg, "--alpn")) {
            o.alpn = args.next() orelse die("missing value for --alpn\n{s}", .{usage});
        } else if (mem.eql(u8, arg, "--path")) {
            o.path = args.next() orelse die("missing value for --path\n{s}", .{usage});
        } else if (mem.eql(u8, arg, "--insecure")) {
            o.insecure = true;
        } else if (mem.eql(u8, arg, "--no-request")) {
            o.no_request = true;
        } else {
            die("unknown argument: {s}\n{s}", .{ arg, usage });
        }
    }
    o.host = host orelse die("--host is required\n{s}", .{usage});

    var rt = try zio.Runtime.init(init.gpa, .{});
    defer rt.deinit();
    const io = rt.io();

    print("[zio] runtime up; connecting to {s}:{d} (deadline {d}ms)\n", .{
        o.host, o.port, o.timeout_ms,
    });

    var fetch: Fetch = .{ .options = o, .gpa = init.gpa, .io = io };

    var race_buffer: [2]Race = undefined;
    var race: Io.Select(Race) = .init(io, &race_buffer);
    try race.concurrent(.fetch, fetchTask, .{&fetch});
    try race.concurrent(.deadline, deadline, .{ io, o.timeout_ms });

    const winner = try race.await();
    // Cancels the loser. On the deadline path this is what interrupts whatever
    // ztls-std was blocked in.
    race.cancelDiscard();

    switch (winner) {
        .fetch => {},
        .deadline => print("[zio] deadline of {d}ms expired\n", .{o.timeout_ms}),
    }

    if (fetch.failure) |err| {
        const phase = if (fetch.connected) "transfer" else "handshake";
        // The point of readError()/writeError(): `Canceled` here is a deadline,
        // not a broken connection, and the two demand different handling.
        if (err == error.Canceled) {
            print("[zio] {s} cancelled by the deadline (recovered as error.Canceled)\n", .{phase});
        } else {
            print("[zio] {s} failed: {t}\n", .{ phase, err });
        }
        std.process.exit(1);
    }

    print("[zio] read {d} body bytes, connection closed cleanly\n", .{fetch.body_bytes});
}
