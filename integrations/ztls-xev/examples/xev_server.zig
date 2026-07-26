//! TLS 1.3 echo server driven by libxev completions.
//!
//! The caller owns the listener and the accept loop; ztls-xev wraps one accepted
//! socket in TLS and nothing more. There is no `tls.Server` listener
//! abstraction, deliberately — an accept loop is four lines of libxev, and
//! wrapping it would only get in the way of the protocol-detection patterns
//! (StartTLS and friends) that a real proxy needs.
//!
//! One `ServerConfig` backs every connection: the certificate and signer are
//! the same for all of them.
//!
//! Usage:
//!     zig build example-xev_server -- --port 8443
//!     openssl s_client -connect 127.0.0.1:8443 -tls1_3 -alpn echo
const std = @import("std");
const heap = std.heap;
const Allocator = std.mem.Allocator;
const mem = std.mem;
const print = std.debug.print;
const testing = std.testing;

const xev = @import("xev");
const ztls = @import("ztls");
const tls = @import("ztls_xev");

/// Test credentials, embedded so the example runs with no setup. A real server
/// loads a chain and key from disk; nothing about the shape changes.
const fixtures = @import("fixtures");

const usage =
    \\Usage: xev_server [--port <port>] [--alpn <proto>]
    \\
    \\Options:
    \\  --port <port>   Port to listen on (default: 8443).
    \\  --alpn <proto>  ALPN protocol to accept (default: echo).
    \\
;

fn die(comptime fmt: []const u8, args: anytype) noreturn {
    print("[xev] " ++ fmt ++ "\n", args);
    std.process.exit(1);
}

/// One connection. The pool owns these; each frees itself in its close
/// callback, which is the natural lifetime in a completion API.
const Session = struct {
    server: *Listener,
    conn: tls.Server = undefined,
    storage: tls.Server.Storage = .{},
    read_buf: [16 * 1024]u8 = undefined,
    echoed: usize = 0,

    fn onHandshake(self: *Session, r: tls.HandshakeResult) void {
        r.result catch |err| {
            // The peer already received the matching fatal alert (RFC 8446 §6.2).
            print("[xev] handshake failed: {t}\n", .{err});
            return;
        };
        print("[xev] handshake ok: cipher={t} alpn={s}\n", .{
            self.conn.cipherSuite(),
            self.conn.selectedAlpn() orelse "(none)",
        });
        self.conn.read(&self.read_buf, self, onRead);
    }

    fn onRead(self: *Session, r: tls.ReadResult) void {
        switch (r) {
            .data => |bytes| self.conn.write(bytes, self, onWrite),
            // RFC 8446 §6.1 — an authenticated shutdown, distinct from a peer
            // that simply vanished.
            .close_notify => {
                print("[xev] client closed cleanly after {d} echoed bytes\n", .{self.echoed});
                self.conn.close(self, onClose);
            },
            .eof => {
                print("[xev] client vanished after {d} echoed bytes (no close_notify)\n", .{
                    self.echoed,
                });
                self.conn.closeReset(self, onClose);
            },
            .err => |err| {
                print("[xev] read failed: {t}\n", .{err});
                self.conn.closeReset(self, onClose);
            },
        }
    }

    fn onWrite(self: *Session, r: tls.WriteResult) void {
        const n = r.written catch |err| {
            print("[xev] write failed: {t}\n", .{err});
            return self.conn.closeReset(self, onClose);
        };
        self.echoed += n;
        self.conn.read(&self.read_buf, self, onRead);
    }

    fn onClose(self: *Session) void {
        self.conn.deinit();
        // deinit leaves lent memory alone (#81), so the owner clears it — and
        // the record buffer held decrypted client traffic.
        self.storage.secureZero();
        self.server.pool.destroy(self);
    }
};

const Listener = struct {
    loop: *xev.Loop,
    io: std.Io,
    gpa: Allocator,
    config: *const tls.ServerConfig,
    pool: heap.MemoryPool(Session),
    socket: xev.TCP,
    accept_c: xev.Completion = .{},

    fn onAccept(
        self_opt: ?*Listener,
        _: *xev.Loop,
        _: *xev.Completion,
        r: xev.AcceptError!xev.TCP,
    ) xev.CallbackAction {
        const self = self_opt.?;
        const socket = r catch |err| {
            print("[xev] accept failed: {t}\n", .{err});
            return .rearm;
        };
        const session = self.pool.create(self.gpa) catch {
            print("[xev] pool exhausted; dropping connection\n", .{});
            return .rearm;
        };
        session.* = .{ .server = self };
        session.conn.init(
            self.io,
            self.loop,
            socket,
            self.config,
            null, // SNI is the client's to send; a server reads it, not sets it
            session.storage.buffers(),
        );
        session.conn.handshake(session, Session.onHandshake);
        return .rearm;
    }
};

pub fn main(init: std.process.Init) !void {
    var args = init.minimal.args.iterate();
    _ = args.skip();

    var port: u16 = 8443;
    var alpn: []const u8 = "echo";
    while (args.next()) |arg| {
        if (mem.eql(u8, arg, "--port")) {
            const raw = args.next() orelse die("missing value for --port\n{s}", .{usage});
            port = std.fmt.parseInt(u16, raw, 10) catch die("invalid port: {s}", .{raw});
        } else if (mem.eql(u8, arg, "--alpn")) {
            alpn = args.next() orelse die("missing value for --alpn\n{s}", .{usage});
        } else {
            die("unknown argument: {s}\n{s}", .{ arg, usage });
        }
    }

    var key: ztls.signature.PrivateKey = try .fromP256Scalar(
        @ptrCast(fixtures.server_ecdsa_scalar[0..32]),
    );
    defer key.deinit();

    // One config, every connection. The chain and signer are borrowed, so both
    // must outlive the loop.
    const cert_chain = [_][]const u8{&fixtures.server_ecdsa_cert_der};
    const config: tls.ServerConfig = .init(.{
        .cert_chain = &cert_chain,
        .signer = key.signer(),
        .alpn = &.{alpn},
    });

    // libxev closes sockets on a thread pool on the readiness backends (kqueue,
    // epoll); without one the close fails and the fd stays open. io_uring does
    // not need it, which is exactly why it is easy to forget.
    var pool: xev.ThreadPool = .init(.{});
    defer {
        pool.shutdown();
        pool.deinit();
    }
    var loop: xev.Loop = try .init(.{ .thread_pool = &pool });
    defer loop.deinit();

    const address: std.Io.net.IpAddress = .{ .ip4 = try .parse("127.0.0.1", port) };
    const socket: xev.TCP = try .init(address);
    try socket.bind(address);
    try socket.listen(128);

    var listener: Listener = .{
        .loop = &loop,
        .io = std.Io.Threaded.global_single_threaded.io(),
        .gpa = init.gpa,
        .config = &config,
        .pool = .empty,
        .socket = socket,
    };
    defer listener.pool.deinit(init.gpa);

    print("[xev] echo server on 127.0.0.1:{d}, alpn={s}\n", .{ port, alpn });
    print("[xev] the certificate is a test fixture: expect verification to fail\n", .{});
    print("[xev] without -verify none / --insecure on the client side\n", .{});
    listener.socket.accept(&loop, &listener.accept_c, Listener, &listener, Listener.onAccept);
    try loop.run(.until_done);
}

// The listener wiring is exercised by running it; this pins the one piece of
// pure logic, so a typo in the fixture wiring fails the build rather than the
// first connection.
test "credentials build from the embedded fixture" {
    var key: ztls.signature.PrivateKey = try .fromP256Scalar(
        @ptrCast(fixtures.server_ecdsa_scalar[0..32]),
    );
    defer key.deinit();

    const cert_chain = [_][]const u8{&fixtures.server_ecdsa_cert_der};
    const config: tls.ServerConfig = .init(.{
        .cert_chain = &cert_chain,
        .signer = key.signer(),
        .alpn = &.{"echo"},
    });
    try testing.expectEqual(@as(usize, 1), config.cert_chain.len);
    try testing.expectEqualStrings("echo", config.alpn[0]);
}
