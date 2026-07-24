//! Minimal TLS 1.3 client using the ztls-std higher-order API.
//!
//! Inspired by `openssl s_client`: connects to a host, completes the TLS
//! handshake, prints connection info, then relays stdin → TLS → stdout in
//! both directions at once.
//!
//! Unlike the top-level ztls examples that drive the Sans-I/O engine
//! manually (ClientHello, handleRecord loop, record buffer management),
//! this uses `ztls_std.Client` + `connect` — the wrapper runs the handshake,
//! record protection, and close_notify. The caller just reads and writes
//! through `*std.Io.Reader` / `*std.Io.Writer`.
//!
//! Usage:
//!     zig build example-tls_client -- --host example.com --port 443
//!     zig build example-tls_client -- --host 127.0.0.1 --port 8443 --insecure
//!
//! Pipe an HTTP request:
//!     printf 'GET / HTTP/1.0\r\nHost: example.com\r\n\r\n' | \
//!         zig build example-tls_client -- --host example.com
//!
//! Or type interactively with --crlf, which translates bare newlines so an
//! HTTP request line works from a terminal. The relay is duplex, so each chunk
//! you type is sent immediately and responses print as they arrive. Ctrl-D
//! sends TLS close_notify but keeps reading until the peer replies with
//! close_notify.
const std = @import("std");
const assert = std.debug.assert;
const Io = std.Io;
const net = Io.net;
const mem = std.mem;
const posix = std.posix;
const testing = std.testing;
const print = std.debug.print;

const tls = @import("ztls_std");

/// Retain the verified chain so `info().peer_chain` can report it. Default
/// `tls.Client` skips retention and is ~64 KB smaller.
const Client = tls.ClientWith(.{
    .peer_chain_storage = tls.core.ClientHandshake.recommended_handshake_storage,
});

const usage =
    \\Usage: tls_client --host <host> [--port <port>] [--insecure] [--alpn <proto>] [--crlf]
    \\
    \\Options:
    \\  --host <host>       Server hostname or IP (required). Used for SNI + verification.
    \\  --port <port>       Port number (default: 443).
    \\  --insecure          Skip certificate chain verification (demo/test only).
    \\  --alpn <proto>      ALPN protocol to offer (default: http/1.1).
    \\  --crlf              Translate bare LF from stdin to CRLF, for typing HTTP
    \\                      requests interactively. Off by default so piped binary
    \\                      input passes through untouched.
    \\
;

fn die(comptime fmt: []const u8, args: anytype) noreturn {
    print("[tls] " ++ fmt ++ "\n", args);
    std.process.exit(1);
}

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var args = init.minimal.args.iterate();
    _ = args.skip(); // program name

    var host: ?[]const u8 = null;
    var port: u16 = 443;
    var insecure = false;
    var crlf = false;
    var alpn: []const u8 = "http/1.1";

    while (args.next()) |arg| {
        if (mem.eql(u8, arg, "--host")) {
            host = args.next() orelse
                die("missing value for --host\n{s}", .{usage});
        } else if (mem.eql(u8, arg, "--port")) {
            const port_str = args.next() orelse
                die("missing value for --port\n{s}", .{usage});
            port = std.fmt.parseInt(u16, port_str, 10) catch
                die("invalid port: {s}", .{port_str});
        } else if (mem.eql(u8, arg, "--insecure")) {
            insecure = true;
        } else if (mem.eql(u8, arg, "--crlf")) {
            crlf = true;
        } else if (mem.eql(u8, arg, "--alpn")) {
            alpn = args.next() orelse
                die("missing value for --alpn\n{s}", .{usage});
        } else {
            die("unknown argument: {s}\n{s}", .{ arg, usage });
        }
    }

    const host_str = host orelse
        die("--host is required\n{s}", .{usage});

    // DNS resolve + TCP connect.
    print("[tls] connecting to {s}:{d}\n", .{ host_str, port });
    const host_name = try net.HostName.init(host_str);
    const sock = host_name.connect(io, port, .{ .mode = .stream }) catch |err|
        die("TCP connect failed: {}", .{err});

    // TLS handshake via the wrapper.
    // connect() runs the full TLS 1.3 handshake to completion before
    // returning. All handshake errors (cert verification, ALPN, alerts)
    // surface here — not leaked into the first read — and on failure the
    // wrapper alerts the peer and closes the socket itself.
    //
    // --insecure skips chain-anchor verification (self-signed certs)
    // but SNI and hostname verification still run. Use a cert whose
    // CN/SAN matches --host, or connect by IP with a cert that lists
    // that IP in its SAN.
    var conn: Client = undefined;
    conn.connect(io, sock, .{
        .host = host_str,
        .verify = if (insecure) .insecure else .{ .system_bundle = init.gpa },
        .alpn = &.{alpn},
    }) catch |err| die("handshake failed: {t}", .{err});
    defer conn.deinit();

    // Print connection info.
    print("[tls] handshake complete\n", .{});
    print("[tls]   host: {s}:{d}\n", .{ host_str, port });
    const info = conn.info();
    print("[tls]   ALPN: {s}\n", .{info.alpn orelse "(none)"});
    print("[tls]   cipher: {t}\n", .{info.cipher_suite});
    print("[tls]   peer certificates: {d}\n", .{info.peer_chain.len});
    const verification = if (insecure) "skipped (--insecure)" else "system bundle";
    print("[tls]   verification: {s}\n", .{verification});
    print("[tls] relaying stdin <-> TLS (Ctrl-D to half-close stdin)\n", .{});

    // Buffered stdout.
    var stdout_buf: [4096]u8 = undefined;
    var stdout_writer: Io.File.Writer = .init(.stdout(), io, &stdout_buf);
    const stdout = &stdout_writer.interface;
    defer stdout.flush() catch {};

    // Duplex relay.
    //
    // Both directions must run on one thread: a ztls-std Stream shares its
    // handshake engine and outbound record buffer between reader and writer, so
    // it is not safe to drive the two halves concurrently. That rules out
    // `io.async` per direction, and sequential phases (read all of stdin, then
    // read the response) deadlock against a server that waits for more input
    // mid-request. What is left is readiness multiplexing in one thread, and
    // `std.Io` 0.16 is a completion API with no readiness primitive — hence
    // `posix.poll` on `conn.socketHandle()` rather than something Io-native.
    // `hasBuffered()` covers the gap poll cannot see: records already decrypted
    // or already framed inside the wrapper.
    const tls_r = conn.reader();
    const tls_w = conn.writer();
    const sock_fd = conn.socketHandle();

    var stdin_open = true;
    var stdin_buf: [4096]u8 = undefined;
    var translated: [2 * stdin_buf.len]u8 = undefined; // worst case: every byte is \n
    var prev_was_cr = false;

    defer {
        conn.close();
        print("[tls] connection closed\n", .{});
    }

    while (true) {
        var pfds: [2]posix.pollfd = .{
            // poll ignores negative fds — stdin drops out after EOF.
            .{
                .fd = if (stdin_open) posix.STDIN_FILENO else -1,
                .events = posix.POLL.IN,
                .revents = 0,
            },
            .{ .fd = sock_fd, .events = posix.POLL.IN, .revents = 0 },
        };
        _ = posix.poll(&pfds, -1) catch |err|
            die("poll failed: {}", .{err});

        // stdin → TLS.
        if (pfds[0].revents != 0) {
            const n = posix.read(posix.STDIN_FILENO, &stdin_buf) catch |err|
                die("stdin read failed: {}", .{err});
            if (n == 0) {
                stdin_open = false; // EOF (Ctrl-D or drained pipe)
                conn.closeWrite();
            } else {
                const chunk = if (crlf)
                    crlfTranslate(stdin_buf[0..n], &translated, &prev_was_cr)
                else
                    stdin_buf[0..n];
                tls_w.writeAll(chunk) catch |err|
                    die("TLS write failed: {t}", .{err});
                tls_w.flush() catch |err|
                    die("TLS flush failed: {t}", .{err});
            }
        }

        // TLS → stdout. fillMore does exactly one underlying read (one
        // decrypted record) per call — readSliceShort would block trying to
        // fill the whole buffer, which hangs on keep-alive connections. One
        // poll wakeup can cover several records coalesced into a single
        // transport read; hasBuffered() drains those without blocking before
        // we poll again.
        if (pfds[1].revents != 0) {
            while (true) {
                tls_r.fillMore() catch |err| switch (err) {
                    error.EndOfStream => return,
                    else => {
                        print("\n[tls] TLS read failed: {t}\n", .{err});
                        return;
                    },
                };
                const chunk = tls_r.buffered();
                if (chunk.len == 0) break;
                stdout.writeAll(chunk) catch |err|
                    die("stdout write failed: {}", .{err});
                tls_r.toss(chunk.len);
                stdout.flush() catch |err|
                    die("stdout flush failed: {}", .{err});
                if (!conn.hasBuffered()) break;
            }
        }
    }
}

/// Translate bare LF to CRLF so HTTP request lines can be typed interactively.
/// `prev_was_cr` carries the state across chunk boundaries so an existing CRLF
/// split by a read is not doubled. `out` must be twice `in`.
fn crlfTranslate(in: []const u8, out: []u8, prev_was_cr: *bool) []const u8 {
    assert(out.len >= 2 * in.len);
    var i: usize = 0;
    for (in) |b| {
        if (b == '\n' and !prev_was_cr.*) {
            out[i] = '\r';
            i += 1;
        }
        out[i] = b;
        i += 1;
        prev_was_cr.* = (b == '\r');
    }
    return out[0..i];
}

test "crlfTranslate: bare LF becomes CRLF, existing CRLF is untouched" {
    var out: [64]u8 = undefined;
    var cr = false;
    try testing.expectEqualStrings(
        "GET /\r\n\r\n",
        crlfTranslate("GET /\n\n", &out, &cr),
    );
    cr = false;
    try testing.expectEqualStrings(
        "GET /\r\n",
        crlfTranslate("GET /\r\n", &out, &cr),
    );
}

// A CRLF pair split across two reads must not become CR CR LF.
test "crlfTranslate: carries CR state across chunks" {
    var out: [64]u8 = undefined;
    var cr = false;
    try testing.expectEqualStrings("a\r", crlfTranslate("a\r", &out, &cr));
    try testing.expectEqualStrings("\nb", crlfTranslate("\nb", &out, &cr));
}
