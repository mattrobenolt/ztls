//! Interop test: drive `openssl s_client` against a ztls server.
//!
//! This is an I/O harness, not part of the no-I/O library. It runs a tiny TCP
//! server around ServerHandshake, loops over every mandatory TLS 1.3 suite, and
//! verifies OpenSSL can complete the handshake and read application data.
const std = @import("std");
const mem = std.mem;
const testing = std.testing;
const crypto = std.crypto;
const net = std.net;
const Child = std.process.Child;
const sleep = std.Thread.sleep;
const print = std.debug.print;

const ztls = @import("ztls");

const harness = @import("harness.zig");

const host = "127.0.0.1";
const base_port = 16433;
const alpn_protocol = "http/1.1";
const response = "HTTP/1.0 200 OK\r\nContent-Length: 5\r\n\r\nhello";

const SuiteCase = struct {
    openssl_name: []const u8,
    ztls_suite: ztls.CipherSuite,
};

const suites = [_]SuiteCase{
    .{ .openssl_name = "TLS_AES_128_GCM_SHA256", .ztls_suite = .aes_128_gcm_sha256 },
    .{ .openssl_name = "TLS_CHACHA20_POLY1305_SHA256", .ztls_suite = .chacha20_poly1305_sha256 },
    .{ .openssl_name = "TLS_AES_256_GCM_SHA384", .ztls_suite = .aes_256_gcm_sha384 },
};

const ServerArgs = struct {
    port: u16,
    suite: ztls.CipherSuite,
    cert_der: []const u8,
    scalar: []const u8,
};

pub fn main() !void {
    var arena_allocator: std.heap.ArenaAllocator = .init(std.heap.smp_allocator);
    defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();

    const cert_der = harness.testCertDer();
    const scalar = harness.testScalar();

    for (suites, 0..) |suite, i| {
        print("[server-interop] {s}\n", .{suite.openssl_name});
        try runSuite(arena, suite, base_port + @as(u16, @intCast(i)), cert_der, scalar);
    }
}

fn runSuite(
    arena: mem.Allocator,
    suite: SuiteCase,
    port: u16,
    cert_der: []const u8,
    scalar: []const u8,
) !void {
    var args: ServerArgs = .{
        .port = port,
        .suite = suite.ztls_suite,
        .cert_der = cert_der,
        .scalar = scalar,
    };
    const thread = try std.Thread.spawn(.{}, serverThread, .{&args});

    var child = try startClient(arena, suite.openssl_name, port);
    defer _ = child.kill() catch {};
    try child.stdin.?.writeAll("GET / HTTP/1.0\r\n\r\n");
    child.stdin.?.close();
    child.stdin = null;

    var stdout_buf: [4096]u8 = undefined;
    const n = try child.stdout.?.readAll(&stdout_buf);
    const term = try child.wait();
    thread.join();

    if (term != .Exited or term.Exited != 0) return error.OpenSslClientFailed;
    if (!mem.containsAtLeast(u8, stdout_buf[0..n], 1, "hello")) return error.NoServerResponse;
    print("[server-interop] openssl s_client completed — OK\n", .{});
}

fn startClient(arena: mem.Allocator, suite: []const u8, port: u16) !Child {
    const port_str = try std.fmt.allocPrint(arena, "{d}", .{port});
    const connect = try std.fmt.allocPrint(arena, "{s}:{s}", .{ host, port_str });
    var child = Child.init(&.{
        "openssl",     "s_client",
        "-tls1_3",     "-connect",
        connect,       "-ciphersuites",
        suite,         "-alpn",
        alpn_protocol, "-quiet",
    }, arena);
    child.stdin_behavior = .Pipe;
    child.stdout_behavior = .Pipe;
    child.stderr_behavior = .Ignore;
    try child.spawn();
    return child;
}

fn serverThread(args: *const ServerArgs) !void {
    const addr: net.Address = try .parseIp(host, args.port);
    var server = try addr.listen(.{ .reuse_address = true });
    defer server.deinit();
    const conn = try server.accept();
    defer conn.stream.close();
    try serve(conn.stream, args.suite, args.cert_der, args.scalar);
}

fn serve(
    stream: net.Stream,
    suite: ztls.CipherSuite,
    cert_der: []const u8,
    scalar: []const u8,
) !void {
    const server_keypair: ztls.x25519.KeyPair = .generate();
    var hs: ztls.ServerHandshake = .init(server_keypair);
    defer hs.deinit();
    hs.supportAlpn(&.{alpn_protocol});
    const supported = [_]ztls.CipherSuite{suite};
    hs.supportSuites(&supported);

    var signer = try ztls.signature.PrivateKey.fromP256Scalar(scalar[0..32]);
    defer signer.deinit();
    const signer_api = signer.signer();

    var random: ztls.client_hello.Random = undefined;
    crypto.random.bytes(&random.data);
    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);
    var out: [4096]u8 = undefined;
    errdefer |err| harness.sendBestEffortAlert(&hs, stream, err, &out);

    var sent_flight = false;
    while (!hs.isConnected()) {
        const n = try stream.read(rb.writable());
        if (n == 0) return error.ClientClosed;
        rb.advance(n);
        while (try rb.next()) |record| {
            const ev = try hs.handleRecord(record, random, &out);
            switch (ev) {
                .write => |w| {
                    try stream.writeAll(w);
                    hs.completeWrite();
                    if (!sent_flight and hs.state == .wait_client_finished) {
                        const flight = try hs.sendPreparedAuthenticatedFlight(
                            &.{cert_der},
                            signer_api,
                            &out,
                        );
                        try stream.writeAll(flight);
                        sent_flight = true;
                    }
                },
                .none => {},
                .application_data => |data| {
                    if (!hs.isConnected()) return error.UnexpectedDuringHandshake;
                    return sendResponse(stream, &hs, data, &out);
                },
                .closed => return error.UnexpectedDuringHandshake,
            }
        }
    }

    while (true) {
        const n = try stream.read(rb.writable());
        if (n == 0) return error.ClientClosed;
        rb.advance(n);
        while (try rb.next()) |record| switch (try hs.handleRecord(record, random, &out)) {
            .application_data => |data| return sendResponse(stream, &hs, data, &out),
            .write => |w| {
                try stream.writeAll(w);
                hs.completeWrite();
            },
            .closed => return,
            .none => {},
        };
    }
}

fn sendResponse(
    stream: net.Stream,
    hs: *ztls.ServerHandshake,
    request: []const u8,
    out: []u8,
) !void {
    if (!mem.startsWith(u8, request, "GET ")) return error.UnexpectedRequest;
    const rec = try hs.sendApplicationData(response, out);
    try stream.writeAll(rec);
    hs.completeWrite();
    const close = try hs.sendAlert(.close_notify, out);
    try stream.writeAll(close);
    hs.completeWrite();
}
