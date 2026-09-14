//! OpenSSL interoperability tests for the ztls-std public API.
//!
//! These tests use real TCP sockets and external peers. They stay separate from
//! the socketpair suite so the process and network boundary remains explicit.
const std = @import("std");
const Io = std.Io;
const mem = std.mem;
const net = Io.net;
const testing = std.testing;
const Child = std.process.Child;

const fixtures = @import("fixtures");
const ztls = @import("ztls");
const tls = @import("ztls_std");

const alpn = "http/1.1";
const cipher = "TLS_AES_128_GCM_SHA256";
const host = "127.0.0.1";
const request = "GET / HTTP/1.0\r\n\r\n";
const response = "HTTP/1.0 200 OK\r\nContent-Length: 5\r\n\r\nhello";
const peer_timeout_ms = 5000;
const server_cert_der: []const u8 = &fixtures.server_ecdsa_cert_der;
const server_scalar: []const u8 = &fixtures.server_ecdsa_scalar;

const ServerCtx = struct {
    listener: net.Server,
    suite: ?ztls.CipherSuite = null,
    err: ?anyerror = null,
};

const Exchange = struct {
    term: Child.Term,
    stdout: [4096]u8,
    stdout_len: usize,
};

fn testIo() Io {
    return testing.io;
}

fn requireOpenSsl() !void {
    const io = testIo();
    var child = try std.process.spawn(io, .{
        .argv = &.{ "openssl", "version" },
        .stdout = .ignore,
        .stderr = .ignore,
    });
    if (!exitedZero(try child.wait(io))) return error.OpenSslUnavailable;
}

fn generateCertificate(cert_path: []const u8, key_path: []const u8) !void {
    const io = testIo();
    var child = try std.process.spawn(io, .{
        .argv = &.{
            "openssl",                 "req",     "-x509",
            "-newkey",                 "ec",      "-pkeyopt",
            "ec_paramgen_curve:P-256", "-keyout", key_path,
            "-out",                    cert_path, "-days",
            "1",                       "-nodes",  "-subj",
            "/CN=localhost",           "-addext", "subjectAltName=DNS:localhost",
        },
        .stdout = .ignore,
        .stderr = .ignore,
    });
    if (!exitedZero(try child.wait(io))) return error.CertificateGenerationFailed;
}

fn startOpenSslServer(
    allocator: mem.Allocator,
    cert_path: []const u8,
    key_path: []const u8,
    port: u16,
) !Child {
    const port_text = try std.fmt.allocPrint(allocator, "{d}", .{port});
    return std.process.spawn(testIo(), .{
        .argv = &.{
            "openssl", "s_server",
            "-tls1_3", "-ciphersuites",
            cipher,    "-key",
            key_path,  "-cert",
            cert_path, "-port",
            port_text, "-www",
            "-alpn",   alpn,
            "-quiet",
        },
        .stdout = .ignore,
        .stderr = .ignore,
    });
}

fn startOpenSslClient(
    allocator: mem.Allocator,
    ca_path: []const u8,
    port: u16,
) !Child {
    const target = try std.fmt.allocPrint(allocator, "{s}:{d}", .{ host, port });
    return std.process.spawn(testIo(), .{
        .argv = &.{
            "openssl",          "s_client",
            "-tls1_3",          "-connect",
            target,             "-ciphersuites",
            cipher,             "-CAfile",
            ca_path,            "-verify_return_error",
            "-verify_hostname", "ztls.server.test",
            "-servername",      "ztls.server.test",
            "-alpn",            alpn,
            "-quiet",
        },
        .stdin = .pipe,
        .stdout = .pipe,
        .stderr = .ignore,
    });
}

fn availablePort() !u16 {
    const io = testIo();
    const addr = try net.IpAddress.parse(host, 0);
    var listener = try addr.listen(io, .{ .reuse_address = true });
    defer listener.deinit(io);
    return listener.socket.address.getPort();
}

fn connectWithRetry(port: u16) !net.Stream {
    const io = testIo();
    const addr = try net.IpAddress.parse(host, port);
    for (0..peer_timeout_ms / 20) |_| {
        return addr.connect(io, .{ .mode = .stream }) catch |err| switch (err) {
            error.ConnectionRefused => {
                sleepMs(20);
                continue;
            },
            else => return err,
        };
    }
    return error.OpenSslServerNeverCameUp;
}

fn sleepMs(ms: u64) void {
    var ts: std.posix.timespec = .{
        .sec = @intCast(ms / std.time.ms_per_s),
        .nsec = @intCast((ms % std.time.ms_per_s) * std.time.ns_per_ms),
    };
    _ = std.c.nanosleep(&ts, null);
}

fn serverRun(ctx: *ServerCtx) void {
    serverExchange(ctx) catch |err| {
        ctx.err = err;
    };
}

fn serverExchange(ctx: *ServerCtx) !void {
    const io = testIo();
    defer ctx.listener.deinit(io);
    var key: ztls.signature.PrivateKey = try .fromP256Scalar(
        @ptrCast(server_scalar[0..32]),
    );
    defer key.deinit();

    var poll_fds: [1]std.posix.pollfd = .{.{
        .fd = ctx.listener.socket.handle,
        .events = std.posix.POLL.IN,
        .revents = 0,
    }};
    if (try std.posix.poll(&poll_fds, peer_timeout_ms) == 0)
        return error.OpenSslClientNeverConnected;
    const sock = try ctx.listener.accept(io);

    var conn: tls.Server = undefined;
    try conn.accept(io, sock, .{
        .cert_chain = &.{server_cert_der},
        .signer = key.signer(),
        .alpn = &.{alpn},
    });
    defer conn.deinit();

    try testing.expectEqualStrings(alpn, conn.selectedAlpn().?);
    ctx.suite = conn.info().cipher_suite;
    const request_line = try conn.reader().takeDelimiterInclusive('\n');
    try testing.expect(mem.startsWith(u8, request_line, "GET / HTTP/1.0"));
    try conn.writer().writeAll(response);
    try conn.writer().flush();
    conn.close();
}

fn exchangeWithOpenSslClient(child: *Child) !Exchange {
    const io = testIo();
    const stdin = child.stdin.?;
    child.stdin = null;
    writeFileAll(stdin, request) catch |err| {
        stdin.close(io);
        return err;
    };
    stdin.close(io);

    var result: Exchange = .{
        .term = undefined,
        .stdout = undefined,
        .stdout_len = 0,
    };
    result.stdout_len = try readFileAll(child.stdout.?, &result.stdout);
    result.term = try child.wait(io);
    return result;
}

fn writeFixtureCertificate(allocator: mem.Allocator, path: []const u8) !void {
    const encoder = std.base64.standard.Encoder;
    const encoded_len = encoder.calcSize(server_cert_der.len);
    var encoded_buffer: [4096]u8 = undefined;
    if (encoded_len > encoded_buffer.len) return error.BufferTooShort;
    const encoded = encoder.encode(encoded_buffer[0..encoded_len], server_cert_der);
    const pem = try std.fmt.allocPrint(
        allocator,
        "-----BEGIN CERTIFICATE-----\n{s}\n-----END CERTIFICATE-----\n",
        .{encoded},
    );
    try Io.Dir.cwd().writeFile(testIo(), .{ .sub_path = path, .data = pem });
}

fn tmpDirPath(allocator: mem.Allocator, tmp: anytype) ![]const u8 {
    var path_buffer: [std.fs.max_path_bytes]u8 = undefined;
    const len = try tmp.dir.realPath(testIo(), &path_buffer);
    return allocator.dupe(u8, path_buffer[0..len]);
}

fn writeFileAll(file: Io.File, bytes: []const u8) !void {
    var buffer: [1024]u8 = undefined;
    var writer = file.writer(testIo(), &buffer);
    try writer.interface.writeAll(bytes);
    try writer.interface.flush();
}

fn readFileAll(file: Io.File, buffer: []u8) !usize {
    var total: usize = 0;
    while (total < buffer.len) {
        var poll_fds: [1]std.posix.pollfd = .{.{
            .fd = file.handle,
            .events = std.posix.POLL.IN,
            .revents = 0,
        }};
        if (try std.posix.poll(&poll_fds, peer_timeout_ms) == 0)
            return error.OpenSslOutputTimedOut;
        const n = try std.posix.read(file.handle, buffer[total..]);
        if (n == 0) return total;
        total += n;
    }
    return error.OpenSslOutputTooLong;
}

fn exitedZero(term: Child.Term) bool {
    return term == .exited and term.exited == 0;
}

// RFC 8446 §4.1, §4.4.4, §5; RFC 7301 §3.2 — the wrapper completes a
// TLS 1.3 client handshake with an external peer, negotiates ALPN, and
// exchanges application data in both directions.
test "ztls_std.Client interoperates with openssl s_server" {
    try requireOpenSsl();

    var arena_state: std.heap.ArenaAllocator = .init(testing.allocator);
    defer arena_state.deinit();
    const allocator = arena_state.allocator();
    var tmp = testing.tmpDir(.{});
    defer tmp.cleanup();
    const dir = try tmpDirPath(allocator, &tmp);
    const cert_path = try std.fs.path.join(allocator, &.{ dir, "cert.pem" });
    const key_path = try std.fs.path.join(allocator, &.{ dir, "key.pem" });
    try generateCertificate(cert_path, key_path);

    const port = try availablePort();
    var child = try startOpenSslServer(allocator, cert_path, key_path, port);
    defer child.kill(testIo());

    const sock = try connectWithRetry(port);
    var conn: tls.Client = undefined;
    try conn.connect(testIo(), sock, .{
        .host = "localhost",
        .verify = .insecure,
        .alpn = &.{alpn},
    });
    defer conn.deinit();

    try testing.expectEqualStrings(alpn, conn.selectedAlpn().?);
    try testing.expectEqual(ztls.CipherSuite.aes_128_gcm_sha256, conn.info().cipher_suite);
    try conn.writer().writeAll(request);
    try conn.writer().flush();
    const status_line = try conn.reader().takeDelimiterInclusive('\n');
    try testing.expect(mem.startsWith(u8, status_line, "HTTP/1.0 200"));
    conn.close();
}

// RFC 8446 §4.1.2, §4.4.2–§4.4.4, §5; RFC 7301 §3.2 — OpenSSL
// authenticates the wrapper's server flight, negotiates ALPN, and exchanges
// application data in both directions.
test "openssl s_client interoperates with ztls_std.Server" {
    try requireOpenSsl();

    var arena_state: std.heap.ArenaAllocator = .init(testing.allocator);
    defer arena_state.deinit();
    const allocator = arena_state.allocator();
    var tmp = testing.tmpDir(.{});
    defer tmp.cleanup();
    const dir = try tmpDirPath(allocator, &tmp);
    const ca_path = try std.fs.path.join(allocator, &.{ dir, "ca.pem" });
    try writeFixtureCertificate(allocator, ca_path);

    const addr = try net.IpAddress.parse(host, 0);
    var ctx: ServerCtx = .{ .listener = try addr.listen(testIo(), .{ .reuse_address = true }) };
    const port = ctx.listener.socket.address.getPort();
    var child = startOpenSslClient(allocator, ca_path, port) catch |err| {
        ctx.listener.deinit(testIo());
        return err;
    };
    defer child.kill(testIo());
    const thread = std.Thread.spawn(.{}, serverRun, .{&ctx}) catch |err| {
        ctx.listener.deinit(testIo());
        return err;
    };

    const exchange = exchangeWithOpenSslClient(&child) catch |err| {
        child.kill(testIo());
        thread.join();
        return err;
    };
    thread.join();

    if (!exitedZero(exchange.term)) return error.OpenSslClientFailed;
    if (ctx.err) |err| return err;
    try testing.expect(exchange.stdout_len != 0);
    try testing.expect(mem.containsAtLeast(
        u8,
        exchange.stdout[0..exchange.stdout_len],
        1,
        "hello",
    ));
    try testing.expectEqual(ztls.CipherSuite.aes_128_gcm_sha256, ctx.suite.?);
}
