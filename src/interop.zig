const std = @import("std");
const crypto = std.crypto;
const fs = std.fs;
const heap = std.heap;
const mem = std.mem;
const net = std.net;
const testing = std.testing;
const Child = std.process.Child;
const Allocator = mem.Allocator;

const ztls = @import("root.zig");

const host = "127.0.0.1";
const alpn_protocol = "http/1.1";
const response = "HTTP/1.0 200 OK\r\nContent-Length: 5\r\n\r\nhello";

const shared_fixtures = @import("test_fixtures/shared_fixtures.zig");
const server_cert_der: []const u8 = &shared_fixtures.server_ecdsa_cert_der;
const server_scalar: []const u8 = &shared_fixtures.server_ecdsa_scalar;

const client_suites = [_][]const u8{
    "TLS_AES_128_GCM_SHA256",
    "TLS_CHACHA20_POLY1305_SHA256",
    "TLS_AES_256_GCM_SHA384",
};

const ServerSuite = struct {
    openssl_name: []const u8,
    ztls_suite: ztls.CipherSuite,
};

const server_suites = [_]ServerSuite{
    .{ .openssl_name = "TLS_AES_128_GCM_SHA256", .ztls_suite = .aes_128_gcm_sha256 },
    .{ .openssl_name = "TLS_CHACHA20_POLY1305_SHA256", .ztls_suite = .chacha20_poly1305_sha256 },
    .{ .openssl_name = "TLS_AES_256_GCM_SHA384", .ztls_suite = .aes_256_gcm_sha384 },
};

test "OpenSSL s_server interoperates with ztls client" {
    var arena_allocator: heap.ArenaAllocator = .init(testing.allocator);
    defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();

    var tmp = testing.tmpDir(.{});
    defer tmp.cleanup();
    const dir = try tmp.dir.realpathAlloc(arena, ".");
    const cert_path = try fs.path.join(arena, &.{ dir, "cert.pem" });
    const key_path = try fs.path.join(arena, &.{ dir, "key.pem" });

    try genCert(arena, cert_path, key_path);

    for (client_suites, 0..) |suite, i| {
        try runClientSuite(arena, cert_path, key_path, suite, 14433 + @as(u16, @intCast(i)));
    }
}

test "OpenSSL s_client interoperates with ztls server" {
    var arena_allocator: heap.ArenaAllocator = .init(testing.allocator);
    defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();

    for (server_suites, 0..) |suite, i| {
        try runServerSuite(arena, suite, 16433 + @as(u16, @intCast(i)));
    }
}

fn runClientSuite(
    arena: Allocator,
    cert_path: []const u8,
    key_path: []const u8,
    suite: []const u8,
    port: u16,
) !void {
    var server = try startServer(arena, cert_path, key_path, suite, port);
    defer _ = server.kill() catch {};
    const stream = try connectWithRetry(port);
    defer stream.close();
    try clientInterop(stream);
}

fn genCert(arena: Allocator, cert_path: []const u8, key_path: []const u8) !void {
    var child = Child.init(&.{
        "openssl",                 "req",     "-x509",
        "-newkey",                 "ec",      "-pkeyopt",
        "ec_paramgen_curve:P-256", "-keyout", key_path,
        "-out",                    cert_path, "-days",
        "1",                       "-nodes",  "-subj",
        "/CN=localhost",
    }, arena);
    child.stdout_behavior = .Ignore;
    child.stderr_behavior = .Ignore;
    const term = try child.spawnAndWait();
    if (term != .Exited or term.Exited != 0) return error.CertGenFailed;
}

fn startServer(
    arena: Allocator,
    cert_path: []const u8,
    key_path: []const u8,
    suite: []const u8,
    port: u16,
) !Child {
    const port_str = try std.fmt.allocPrint(arena, "{d}", .{port});
    var child = Child.init(&.{
        "openssl", "s_server",
        "-tls1_3", "-ciphersuites",
        suite,     "-key",
        key_path,  "-cert",
        cert_path, "-port",
        port_str,  "-www",
        "-alpn",   alpn_protocol,
        "-quiet",
    }, arena);
    child.stdout_behavior = .Ignore;
    child.stderr_behavior = .Ignore;
    try child.spawn();
    return child;
}

fn clientInterop(stream: net.Stream) !void {
    const kp: ztls.x25519.KeyPair = .generate();
    var random: ztls.client_hello.Random = undefined;
    crypto.random.bytes(&random.data);

    var hs: ztls.ClientHandshake = .init(.{
        .keypair = kp,
        .host_name = "localhost",
        .now_sec = 0,
        .random = random,
        .insecure_no_chain_anchor = true,
        .alpn_protocols = &.{alpn_protocol},
    });

    var out: [1024]u8 = undefined;
    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);

    try stream.writeAll(try hs.start(&out));
    hs.completeWrite();

    while (!hs.isConnected()) {
        const n = try stream.read(rb.writable());
        if (n == 0) return error.ServerClosed;
        rb.advance(n);
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out)) {
            .write => |w| {
                try stream.writeAll(w);
                hs.completeWrite();
            },
            .application_data, .closed => return error.UnexpectedDuringHandshake,
            .none => {},
        };
    }
    try testing.expectEqualStrings(alpn_protocol, hs.selectedAlpnProtocol().?);

    try stream.writeAll(try hs.sendApplicationData("GET / HTTP/1.0\r\n\r\n", &out));
    hs.completeWrite();

    while (true) {
        const n = try stream.read(rb.writable());
        if (n == 0) break;
        rb.advance(n);
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out)) {
            .application_data => |data| if (mem.startsWith(u8, data, "HTTP/1.0 200")) return,
            .write => |w| {
                try stream.writeAll(w);
                hs.completeWrite();
            },
            .none => {},
            .closed => return error.ServerClosedBeforeResponse,
        };
    }
    return error.NoHttpResponse;
}

const ServerArgs = struct {
    port: u16,
    suite: ztls.CipherSuite,
};

fn runServerSuite(arena: Allocator, suite: ServerSuite, port: u16) !void {
    var args: ServerArgs = .{ .port = port, .suite = suite.ztls_suite };
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
}

fn startClient(arena: Allocator, suite: []const u8, port: u16) !Child {
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
    try serve(conn.stream, args.suite);
}

fn serve(stream: net.Stream, suite: ztls.CipherSuite) !void {
    const server_keypair: ztls.x25519.KeyPair = .generate();
    var hs: ztls.ServerHandshake = .init(server_keypair);
    defer hs.deinit();
    hs.supportAlpn(&.{alpn_protocol});
    const supported = [_]ztls.CipherSuite{suite};
    hs.supportSuites(&supported);

    var signer = try ztls.signature.PrivateKey.fromP256Scalar(server_scalar[0..32]);
    defer signer.deinit();
    hs.setCredentials(&.{server_cert_der}, signer.signer());

    var random: ztls.client_hello.Random = undefined;
    crypto.random.bytes(&random.data);
    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);
    var out: [4096]u8 = undefined;
    errdefer |err| sendBestEffortAlert(&hs, stream, err, &out);

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
                    if (try hs.sendPreparedServerFlight(&out)) |flight| {
                        try stream.writeAll(flight);
                        hs.completeWrite();
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

fn sendBestEffortAlert(
    hs: *ztls.ServerHandshake,
    stream: net.Stream,
    err: anyerror,
    out: []u8,
) void {
    const description = ztls.ServerHandshake.alertForError(err);
    const alert_record = hs.sendAlert(description, out) catch return;
    stream.writeAll(alert_record) catch return;
}

fn connectWithRetry(port: u16) !net.Stream {
    const addr: net.Address = try .parseIp("127.0.0.1", port);
    for (0..100) |_| {
        return net.tcpConnectToAddress(addr) catch {
            std.Thread.sleep(20 * std.time.ns_per_ms);
            continue;
        };
    }
    return error.ServerNeverCameUp;
}
