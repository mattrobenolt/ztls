const std = @import("std");
const builtin = @import("builtin");
const entropy = @import("entropy.zig");
const fs = std.fs;
const heap = std.heap;
const mem = std.mem;
const testing = std.testing;
const Child = std.process.Child;
const Allocator = mem.Allocator;

const is_zig_16 = builtin.zig_version.major == 0 and builtin.zig_version.minor >= 16;
const Net = if (is_zig_16) std.Io.net else std.net;
const Address = if (is_zig_16) Net.IpAddress else Net.Address;
const Stream = Net.Stream;
const Server = Net.Server;

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
    const dir = try tmpDirPath(arena, &tmp);
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
    defer killChild(&server);
    const stream = try connectWithRetry(port);
    defer closeStream(stream);
    try clientInterop(stream);
}

fn genCert(arena: Allocator, cert_path: []const u8, key_path: []const u8) !void {
    const argv = &.{
        "openssl",                 "req",     "-x509",
        "-newkey",                 "ec",      "-pkeyopt",
        "ec_paramgen_curve:P-256", "-keyout", key_path,
        "-out",                    cert_path, "-days",
        "1",                       "-nodes",  "-subj",
        "/CN=localhost",
    };
    if (comptime is_zig_16) {
        var child = try std.process.spawn(testing.io, .{
            .argv = argv,
            .stdout = .ignore,
            .stderr = .ignore,
        });
        const term = try waitChild(&child);
        if (!exitedZero(term)) return error.CertGenFailed;
        return;
    }

    var child = Child.init(argv, arena);
    child.stdout_behavior = .Ignore;
    child.stderr_behavior = .Ignore;
    const term = try child.spawnAndWait();
    if (!exitedZero(term)) return error.CertGenFailed;
}

fn startServer(
    arena: Allocator,
    cert_path: []const u8,
    key_path: []const u8,
    suite: []const u8,
    port: u16,
) !Child {
    const port_str = try std.fmt.allocPrint(arena, "{d}", .{port});
    const argv = &.{
        "openssl", "s_server",
        "-tls1_3", "-ciphersuites",
        suite,     "-key",
        key_path,  "-cert",
        cert_path, "-port",
        port_str,  "-www",
        "-alpn",   alpn_protocol,
        "-quiet",
    };
    if (comptime is_zig_16) {
        return std.process.spawn(testing.io, .{
            .argv = argv,
            .stdout = .ignore,
            .stderr = .ignore,
        });
    }

    var child = Child.init(argv, arena);
    child.stdout_behavior = .Ignore;
    child.stderr_behavior = .Ignore;
    try child.spawn();
    return child;
}

fn clientInterop(stream: Stream) !void {
    const kp: ztls.x25519.KeyPair = .generate();
    var random: ztls.Random = undefined;
    entropy.fill(&random.data);

    var hs: ztls.ClientHandshake = .init(.{
        .keypairs = .init(kp),
        .host_name = "localhost",
        .now_sec = 0,
        .random = random,
        .insecure_no_chain_anchor = true,
        .alpn_protocols = &.{alpn_protocol},
    });

    var out: [1024]u8 = undefined;
    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);

    try writeAll(stream, try hs.start(&out));
    hs.completeWrite();

    while (!hs.isConnected()) {
        const n = try read(stream, rb.writable());
        if (n == 0) return error.ServerClosed;
        rb.advance(n);
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out)) {
            .write => |w| {
                try writeAll(stream, w);
                hs.completeWrite();
            },
            .key_update => |ku| {
                if (ku.response) |w| {
                    try writeAll(stream, w);
                    hs.completeWrite();
                }
            },
            .application_data, .closed => return error.UnexpectedDuringHandshake,
            .none => {},
        };
    }
    try testing.expectEqualStrings(alpn_protocol, hs.selectedAlpnProtocol().?);

    try writeAll(stream, try hs.sendApplicationData("GET / HTTP/1.0\r\n\r\n", &out));
    hs.completeWrite();

    while (true) {
        const n = try read(stream, rb.writable());
        if (n == 0) break;
        rb.advance(n);
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out)) {
            .application_data => |data| if (mem.startsWith(u8, data, "HTTP/1.0 200")) return,
            .write => |w| {
                try writeAll(stream, w);
                hs.completeWrite();
            },
            .key_update => |ku| {
                if (ku.response) |w| {
                    try writeAll(stream, w);
                    hs.completeWrite();
                }
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
    defer killChild(&child);
    try writeFileAll(child.stdin.?, "GET / HTTP/1.0\r\n\r\n");
    closeFile(child.stdin.?);
    child.stdin = null;

    var stdout_buf: [4096]u8 = undefined;
    const n = try readFileAll(child.stdout.?, &stdout_buf);
    const term = try waitChild(&child);
    thread.join();

    if (!exitedZero(term)) return error.OpenSslClientFailed;
    if (!mem.containsAtLeast(u8, stdout_buf[0..n], 1, "hello")) return error.NoServerResponse;
}

fn startClient(arena: Allocator, suite: []const u8, port: u16) !Child {
    const port_str = try std.fmt.allocPrint(arena, "{d}", .{port});
    const connect_to = try std.fmt.allocPrint(arena, "{s}:{s}", .{ host, port_str });
    const argv = &.{
        "openssl",     "s_client",
        "-tls1_3",     "-connect",
        connect_to,    "-ciphersuites",
        suite,         "-alpn",
        alpn_protocol, "-quiet",
    };
    if (comptime is_zig_16) {
        return std.process.spawn(testing.io, .{
            .argv = argv,
            .stdin = .pipe,
            .stdout = .pipe,
            .stderr = .ignore,
        });
    }

    var child = Child.init(argv, arena);
    child.stdin_behavior = .Pipe;
    child.stdout_behavior = .Pipe;
    child.stderr_behavior = .Ignore;
    try child.spawn();
    return child;
}

fn serverThread(args: *const ServerArgs) !void {
    const addr = try parseAddress(host, args.port);
    var server = try listen(addr);
    defer deinitServer(&server);
    const stream = try accept(&server);
    defer closeStream(stream);
    try serve(stream, args.suite);
}

fn serve(stream: Stream, suite: ztls.CipherSuite) !void {
    const server_keypair: ztls.x25519.KeyPair = .generate();
    var server_random: ztls.Random = undefined;
    entropy.fill(&server_random.data);

    var hs: ztls.ServerHandshake = .init(.{
        .keypairs = .init(server_keypair),
        .random = server_random,
    });
    defer hs.deinit();
    hs.supportAlpn(&.{alpn_protocol});
    const supported = [_]ztls.CipherSuite{suite};
    hs.supportSuites(&supported);

    var signer = try ztls.signature.PrivateKey.fromP256Scalar(server_scalar[0..32]);
    defer signer.deinit();
    hs.setCredentials(&.{server_cert_der}, signer.signer());

    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);
    var out: [4096]u8 = undefined;
    errdefer |err| sendBestEffortAlert(&hs, stream, err, &out);

    while (!hs.isConnected()) {
        const n = try read(stream, rb.writable());
        if (n == 0) return error.ClientClosed;
        rb.advance(n);
        while (try rb.next()) |record| {
            const ev = try hs.handleRecord(record, &out);
            switch (ev) {
                .write => |w| {
                    try writeAll(stream, w);
                    hs.completeWrite();
                    if (try hs.sendPreparedServerFlight(&out)) |flight| {
                        try writeAll(stream, flight);
                        hs.completeWrite();
                    }
                },
                .key_update => |ku| {
                    if (ku.response) |w| {
                        try writeAll(stream, w);
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
        const n = try read(stream, rb.writable());
        if (n == 0) return error.ClientClosed;
        rb.advance(n);
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out)) {
            .application_data => |data| return sendResponse(stream, &hs, data, &out),
            .write => |w| {
                try writeAll(stream, w);
                hs.completeWrite();
            },
            .key_update => |ku| {
                if (ku.response) |w| {
                    try writeAll(stream, w);
                    hs.completeWrite();
                }
            },
            .closed => return,
            .none => {},
        };
    }
}

fn sendResponse(
    stream: Stream,
    hs: *ztls.ServerHandshake,
    request: []const u8,
    out: []u8,
) !void {
    if (!mem.startsWith(u8, request, "GET ")) return error.UnexpectedRequest;
    const rec = try hs.sendApplicationData(response, out);
    try writeAll(stream, rec);
    hs.completeWrite();
    const close = try hs.sendAlert(.close_notify, out);
    try writeAll(stream, close);
    hs.completeWrite();
}

fn sendBestEffortAlert(
    hs: *ztls.ServerHandshake,
    stream: Stream,
    err: anyerror,
    out: []u8,
) void {
    const description = ztls.ServerHandshake.alertForError(err);
    const alert_record = hs.sendAlert(description, out) catch return;
    writeAll(stream, alert_record) catch return;
}

fn connectWithRetry(port: u16) !Stream {
    const addr = try parseAddress("127.0.0.1", port);
    for (0..100) |_| {
        return connect(addr) catch {
            sleep20ms();
            continue;
        };
    }
    return error.ServerNeverCameUp;
}

fn tmpDirPath(arena: Allocator, tmp: anytype) ![]const u8 {
    if (comptime is_zig_16) {
        var path_buf: [fs.max_path_bytes]u8 = undefined;
        const len = try tmp.dir.realPath(testing.io, &path_buf);
        return arena.dupe(u8, path_buf[0..len]);
    }
    return tmp.dir.realpathAlloc(arena, ".");
}

fn parseAddress(ip: []const u8, port: u16) !Address {
    return if (comptime is_zig_16)
        Net.IpAddress.parse(ip, port)
    else
        Net.Address.parseIp(ip, port);
}

fn listen(addr: Address) !Server {
    return if (comptime is_zig_16)
        addr.listen(testing.io, .{ .reuse_address = true })
    else
        addr.listen(.{ .reuse_address = true });
}

fn deinitServer(server: *Server) void {
    if (comptime is_zig_16) server.deinit(testing.io) else server.deinit();
}

fn accept(server: *Server) !Stream {
    if (comptime is_zig_16) return server.accept(testing.io);
    return (try server.accept()).stream;
}

fn connect(addr: Address) !Stream {
    return if (comptime is_zig_16)
        addr.connect(testing.io, .{ .mode = .stream })
    else
        std.net.tcpConnectToAddress(addr);
}

fn closeStream(stream: Stream) void {
    if (comptime is_zig_16) stream.close(testing.io) else stream.close();
}

fn read(stream: Stream, buf: []u8) !usize {
    if (comptime !is_zig_16) return stream.read(buf);
    var data: [1][]u8 = .{buf};
    return testing.io.vtable.netRead(testing.io.userdata, stream.socket.handle, &data);
}

fn writeAll(stream: Stream, bytes: []const u8) !void {
    if (comptime !is_zig_16) return stream.writeAll(bytes);
    var rest = bytes;
    while (rest.len != 0) {
        const data: [1][]const u8 = .{rest};
        const n = try testing.io.vtable.netWrite(
            testing.io.userdata,
            stream.socket.handle,
            "",
            &data,
            1,
        );
        rest = rest[n..];
    }
}

fn killChild(child: *Child) void {
    if (comptime is_zig_16) child.kill(testing.io) else _ = child.kill() catch return;
}

fn waitChild(child: *Child) !Child.Term {
    return if (comptime is_zig_16) child.wait(testing.io) else child.wait();
}

fn exitedZero(term: Child.Term) bool {
    return if (comptime is_zig_16)
        term == .exited and term.exited == 0
    else
        term == .Exited and term.Exited == 0;
}

fn writeFileAll(file: anytype, bytes: []const u8) !void {
    if (comptime !is_zig_16) return file.writeAll(bytes);
    var writer_buf: [1024]u8 = undefined;
    var writer = file.writer(testing.io, &writer_buf);
    try writer.interface.writeAll(bytes);
    try writer.interface.flush();
}

fn readFileAll(file: anytype, buf: []u8) !usize {
    if (comptime !is_zig_16) return file.readAll(buf);
    var reader_buf: [1024]u8 = undefined;
    var reader = file.readerStreaming(testing.io, &reader_buf);
    var total: usize = 0;
    while (total < buf.len) {
        const n = try reader.interface.readSliceShort(buf[total..]);
        if (n == 0) break;
        total += n;
    }
    return total;
}

fn closeFile(file: anytype) void {
    if (comptime is_zig_16) file.close(testing.io) else file.close();
}

fn sleep20ms() void {
    if (comptime is_zig_16) {
        const req: std.c.timespec = .{ .sec = 0, .nsec = 20 * std.time.ns_per_ms };
        _ = std.c.nanosleep(&req, null);
    } else {
        std.Thread.sleep(20 * std.time.ns_per_ms);
    }
}
