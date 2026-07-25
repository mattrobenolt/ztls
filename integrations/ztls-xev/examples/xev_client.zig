//! TLS 1.3 client driven entirely by libxev completions.
//!
//! Compare `ztls-std`'s `examples/tls_client.zig`: that one reads like a
//! program, because a blocking wrapper lets you write the steps in order. Here
//! every step is a callback, and the connection state lives in `App` between
//! them. That is the cost of a completion loop, and it is why ztls-xev exists as
//! a separate integration rather than a flag on ztls-std.
//!
//! DNS is resolved once up front through a blocking `std.Io` — libxev has no
//! resolver. Everything after that (TCP connect, TLS handshake, application
//! data, shutdown) is completion-driven.
//!
//! Usage:
//!     zig build example-xev_client -- --host example.com
//!     zig build example-xev_client -- --host 127.0.0.1 --port 8443 --insecure
const std = @import("std");
const Io = std.Io;
const mem = std.mem;
const print = std.debug.print;
const testing = std.testing;

const xev = @import("xev");
const tls = @import("ztls_xev");

const usage =
    \\Usage: xev_client --host <host> [--port <port>] [--insecure] [--alpn <proto>] [--path <path>]
    \\
    \\Options:
    \\  --host <host>   Server hostname or IP (required). Used for SNI + verification.
    \\  --port <port>   Port number (default: 443).
    \\  --insecure      Skip certificate chain verification (demo/test only).
    \\  --alpn <proto>  ALPN protocol to offer (default: http/1.1).
    \\  --path <path>   HTTP path to GET (default: /).
    \\
;

fn die(comptime fmt: []const u8, args: anytype) noreturn {
    print("[xev] " ++ fmt ++ "\n", args);
    std.process.exit(1);
}

/// Everything the callbacks need. In a completion API this is what a blocking
/// wrapper would have kept on the stack.
const App = struct {
    loop: *xev.Loop,
    config: *const tls.Config,
    io: Io,
    host: []const u8,
    request: []const u8,

    conn: tls.Conn = undefined,
    connect_c: xev.Completion = .{},

    record_buf: [tls.Conn.recommended_record_len]u8 = undefined,
    out_buf: [tls.Conn.recommended_out_len]u8 = undefined,
    reassembly_buf: [tls.Conn.recommended_reassembly_len]u8 = undefined,
    read_buf: [16 * 1024]u8 = undefined,

    body_bytes: usize = 0,
    saw_status_line: bool = false,
    failed: bool = false,

    fn onTcpConnected(
        self_opt: ?*App,
        _: *xev.Loop,
        _: *xev.Completion,
        socket: xev.TCP,
        r: xev.ConnectError!void,
    ) xev.CallbackAction {
        const self = self_opt.?;
        r catch |err| {
            print("[xev] TCP connect failed: {t}\n", .{err});
            self.failed = true;
            return .disarm;
        };
        print("[xev] TCP connected; starting TLS handshake\n", .{});

        self.conn.init(self.io, self.loop, socket, self.config, self.host, .{
            .record = &self.record_buf,
            .out = &self.out_buf,
            .reassembly = &self.reassembly_buf,
        });
        self.conn.handshake(self, onHandshake);
        return .disarm;
    }

    fn onHandshake(self: *App, r: tls.HandshakeResult) void {
        r.result catch |err| {
            // The peer already got the matching fatal alert (RFC 8446 §6.2).
            print("[xev] handshake failed: {t}\n", .{err});
            self.failed = true;
            return;
        };
        print("[xev] handshake complete\n", .{});
        print("[xev]   cipher: {t}\n", .{self.conn.cipherSuite()});
        print("[xev]   ALPN: {s}\n", .{self.conn.selectedAlpn() orelse "(none)"});
        self.conn.write(self.request, self, onWrite);
    }

    fn onWrite(self: *App, r: tls.WriteResult) void {
        const n = r.written catch |err| {
            print("[xev] write failed: {t}\n", .{err});
            self.failed = true;
            return self.conn.closeReset(self, onClose);
        };
        print("[xev] sent {d} byte request\n", .{n});
        self.conn.read(&self.read_buf, self, onRead);
    }

    fn onRead(self: *App, r: tls.ReadResult) void {
        switch (r) {
            .data => |bytes| {
                if (!self.saw_status_line) {
                    self.saw_status_line = true;
                    const line_end = mem.indexOfScalar(u8, bytes, '\n') orelse bytes.len;
                    print("[xev] {s}\n", .{mem.trimEnd(u8, bytes[0..line_end], "\r")});
                }
                self.body_bytes += bytes.len;
                self.conn.read(&self.read_buf, self, onRead);
            },
            // RFC 8446 §6.1 — an authenticated shutdown, distinguishable here
            // from a truncated transport. A byte-stream reader cannot tell them
            // apart; a callback API can, so it does.
            .close_notify => {
                print("[xev] peer sent close_notify after {d} bytes\n", .{self.body_bytes});
                self.conn.close(self, onClose);
            },
            .eof => {
                print("[xev] transport EOF with no close_notify after {d} bytes " ++
                    "(truncated, not a clean close)\n", .{self.body_bytes});
                self.conn.close(self, onClose);
            },
            .err => |err| {
                print("[xev] read failed: {t}\n", .{err});
                self.failed = true;
                self.conn.closeReset(self, onClose);
            },
        }
    }

    fn onClose(self: *App) void {
        self.conn.deinit();
        print("[xev] connection closed\n", .{});
    }
};

pub fn main(init: std.process.Init) !void {
    var args = init.minimal.args.iterate();
    _ = args.skip();

    var host: ?[]const u8 = null;
    var port: u16 = 443;
    var insecure = false;
    var alpn: []const u8 = "http/1.1";
    var path: []const u8 = "/";

    while (args.next()) |arg| {
        if (mem.eql(u8, arg, "--host")) {
            host = args.next() orelse die("missing value for --host\n{s}", .{usage});
        } else if (mem.eql(u8, arg, "--port")) {
            const raw = args.next() orelse die("missing value for --port\n{s}", .{usage});
            port = std.fmt.parseInt(u16, raw, 10) catch die("invalid port: {s}", .{raw});
        } else if (mem.eql(u8, arg, "--alpn")) {
            alpn = args.next() orelse die("missing value for --alpn\n{s}", .{usage});
        } else if (mem.eql(u8, arg, "--path")) {
            path = args.next() orelse die("missing value for --path\n{s}", .{usage});
        } else if (mem.eql(u8, arg, "--insecure")) {
            insecure = true;
        } else {
            die("unknown argument: {s}\n{s}", .{ arg, usage });
        }
    }
    const host_str = host orelse die("--host is required\n{s}", .{usage});

    // libxev has no resolver, and the certificate bundle load is file I/O, so
    // both go through a blocking std.Io before the event loop starts.
    const blocking = Io.Threaded.global_single_threaded.io();
    const address = try resolve(blocking, host_str, port);

    var config = if (insecure)
        tls.Config.init(.{ .verify = .insecure, .alpn = &.{alpn} })
    else
        try tls.Config.initSystemBundle(blocking, init.gpa, .{
            .verify = .owned_bundle,
            .alpn = &.{alpn},
        });
    defer config.deinit();

    var loop: xev.Loop = try .init(.{});
    defer loop.deinit();

    var request_buf: [512]u8 = undefined;
    const request = try std.fmt.bufPrint(
        &request_buf,
        "GET {s} HTTP/1.0\r\nHost: {s}\r\nConnection: close\r\n\r\n",
        .{ path, host_str },
    );

    var app: App = .{
        .loop = &loop,
        .config = &config,
        .io = blocking,
        .host = host_str,
        .request = request,
    };

    const socket: xev.TCP = try .init(address);
    print("[xev] connecting to {s}:{d}\n", .{ host_str, port });
    socket.connect(&loop, &app.connect_c, address, App, &app, App.onTcpConnected);

    try loop.run(.until_done);
    if (app.failed) std.process.exit(1);
}

/// One-shot DNS through a blocking `std.Io`, taking the first address returned.
fn resolve(io: Io, host: []const u8, port: u16) !Io.net.IpAddress {
    // An IP literal needs no lookup.
    if (Io.net.IpAddress.resolve(io, host, port)) |addr| return addr else |_| {}

    const host_name = try Io.net.HostName.init(host);
    var results: [16]Io.net.HostName.LookupResult = undefined;
    var queue: Io.Queue(Io.net.HostName.LookupResult) = .init(&results);
    try host_name.lookup(io, &queue, .{ .port = port });

    while (queue.getOne(io)) |result| switch (result) {
        .address => |addr| return addr,
        .canonical_name => {},
    } else |_| {}
    return error.UnknownHostName;
}

// An IP literal must not go anywhere near a resolver: no /etc/resolv.conf, no
// network, no surprises in a test.
test "resolve: an IP literal needs no DNS" {
    const io = Io.Threaded.global_single_threaded.io();
    const addr = try resolve(io, "127.0.0.1", 8443);
    try testing.expect(addr == .ip4);
}
