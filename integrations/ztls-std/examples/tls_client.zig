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
//! Or use an interactive terminal — the relay is duplex, so each line you
//! type is sent immediately and responses print as they arrive. Bare
//! newlines are translated to CRLF so you can type HTTP requests directly.
//! Ctrl-D sends TLS close_notify but keeps reading until the peer replies with
//! close_notify.
const std = @import("std");
const Io = std.Io;
const net = Io.net;
const mem = std.mem;
const posix = std.posix;
const print = std.debug.print;

const tls = @import("ztls_std");

const usage =
    \\Usage: tls_client --host <host> [--port <port>] [--insecure] [--alpn <proto>]
    \\
    \\Options:
    \\  --host <host>       Server hostname or IP (required). Used for SNI + verification.
    \\  --port <port>       Port number (default: 443).
    \\  --insecure          Skip certificate chain verification (demo/test only).
    \\  --alpn <proto>      ALPN protocol to offer (default: http/1.1).
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
    // surface here — not leaked into the first read.
    //
    // --insecure skips chain-anchor verification (self-signed certs)
    // but SNI and hostname verification still run. Use a cert whose
    // CN/SAN matches --host, or connect by IP with a cert that lists
    // that IP in its SAN.
    var conn: tls.Client = undefined;
    conn.connect(init.gpa, io, sock, .{
        .host = host_str,
        .verify = if (insecure) .insecure else .system_bundle,
        .alpn = &.{alpn},
    }) catch |err| die("handshake failed: {}", .{err});
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

    // Duplex relay: poll stdin and the TLS socket.
    // stdin → TLS: each chunk is CRLF-translated and flushed immediately so
    // interactive typing behaves like openssl s_client. TLS → stdout: each
    // decrypted record is written out, and Stream.hasBuffered() drains
    // records coalesced into one transport read before going back to poll.
    //
    // Sequential phases (read all of stdin, then read the response) would
    // deadlock against servers that wait for more input before answering
    // mid-request; polling both directions avoids that.
    const tls_r = conn.reader();
    const tls_w = conn.writer();
    const sock_fd = conn.sock.socket.handle;

    var stdin_open = true;
    var stdin_buf: [4096]u8 = undefined;
    var translated: [8192]u8 = undefined; // worst case: every byte is \n → 2×
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
                // Translate bare \n → \r\n so HTTP requests can be typed
                // interactively; existing \r\n from piped input is untouched.
                var ti: usize = 0;
                for (stdin_buf[0..n]) |b| {
                    if (b == '\n' and !prev_was_cr) {
                        translated[ti] = '\r';
                        ti += 1;
                    }
                    translated[ti] = b;
                    ti += 1;
                    prev_was_cr = (b == '\r');
                }
                tls_w.writeAll(translated[0..ti]) catch |err|
                    die("TLS write failed: {}", .{err});
                tls_w.flush() catch |err|
                    die("TLS flush failed: {}", .{err});
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
                        print("\n[tls] TLS read failed: {}\n", .{err});
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
