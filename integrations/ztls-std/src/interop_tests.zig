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
const client_cert_der: []const u8 = &fixtures.client_ecdsa_cert_der;
const client_scalar: []const u8 = &fixtures.client_ecdsa_scalar;

/// A server that retains the verified client leaf for `info().client_identity`.
const IdentityServer = tls.ServerWith(.{ .client_identity_storage = 1024 });

const ServerCtx = struct {
    listener: net.Server,
    suite: ?ztls.CipherSuite = null,
    err: ?anyerror = null,
};

/// Server thread context for the mTLS direction: a required client-auth
/// policy verified against a caller-owned bundle with the real clock, plus a
/// copy of the retained client identity for main-thread assertions.
const MtlsServerCtx = struct {
    listener: net.Server,
    bundle: *const std.crypto.Certificate.Bundle,
    suite: ?ztls.CipherSuite = null,
    identity_buf: [1024]u8 = undefined,
    identity_len: usize = 0,
    err: ?anyerror = null,

    fn identity(ctx: *const MtlsServerCtx) ?[]const u8 {
        return if (ctx.identity_len == 0) null else ctx.identity_buf[0..ctx.identity_len];
    }
};

const Exchange = struct {
    term: Child.Term,
    stdout: [4096]u8,
    stdout_len: usize,
};

const RejectedExchange = struct {
    term: Child.Term,
    stderr: [4096]u8,
    stderr_len: usize,
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

/// Like `startOpenSslServer`, but requiring and verifying a client
/// certificate against `ca_path` (`-Verify` + `-verify_return_error`, so a
/// certificate that does not verify aborts the handshake rather than merely
/// logging). RFC 8446 §4.4.2.
fn startOpenSslVerifyingServer(
    allocator: mem.Allocator,
    cert_path: []const u8,
    key_path: []const u8,
    ca_path: []const u8,
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
            "-quiet",  "-Verify",
            "2",       "-verifyCAfile",
            ca_path,   "-verify_return_error",
        },
        .stdout = .ignore,
        .stderr = .ignore,
    });
}

/// Like `startOpenSslClient`, but presenting `cert_path`/`key_path` as client
/// credentials. RFC 8446 §4.4.2, §4.4.3.
fn startOpenSslMtlsClient(
    allocator: mem.Allocator,
    ca_path: []const u8,
    cert_path: []const u8,
    key_path: []const u8,
    port: u16,
) !Child {
    const target = try std.fmt.allocPrint(allocator, "{s}:{d}", .{ host, port });
    return std.process.spawn(testIo(), .{
        .argv = &.{
            "openssl",          "s_client",
            "-tls1_3",          "-connect",
            target,             "-ciphersuites",
            cipher,             "-CAfile",
            ca_path,            "-cert",
            cert_path,          "-key",
            key_path,           "-verify_return_error",
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

/// Generate a CA and a clientAuth leaf under it. The leaf carries
/// extendedKeyUsage=clientAuth so a verifying peer accepts it as a client
/// certificate (RFC 8446 §4.4.2). PEM paths for the peers, a DER copy of
/// the leaf for exactness assertions.
fn generateClientAuthCertificate(
    allocator: mem.Allocator,
    dir: []const u8,
) !struct { ca: []const u8, cert: []const u8, key: []const u8, der: []const u8 } {
    const ca_path = try std.fs.path.join(allocator, &.{ dir, "client-ca.pem" });
    const ca_key = try std.fs.path.join(allocator, &.{ dir, "client-ca.key" });
    const csr_path = try std.fs.path.join(allocator, &.{ dir, "client.csr" });
    const key_path = try std.fs.path.join(allocator, &.{ dir, "client.key" });
    const cert_path = try std.fs.path.join(allocator, &.{ dir, "client.pem" });
    const der_path = try std.fs.path.join(allocator, &.{ dir, "client.der" });
    const ext_path = try std.fs.path.join(allocator, &.{ dir, "client.ext" });
    try Io.Dir.cwd().writeFile(testIo(), .{
        .sub_path = ext_path,
        .data = "basicConstraints=critical,CA:FALSE\n" ++
            "keyUsage=critical,digitalSignature\n" ++
            "extendedKeyUsage=clientAuth\n",
    });
    try runOpenSsl(&.{
        "openssl", "ecparam", "-name", "prime256v1",
        "-genkey", "-noout",  "-out",  ca_key,
    });
    const ca_bc = "basicConstraints=critical,CA:TRUE,pathlen:0";
    const ca_ku = "keyUsage=critical,keyCertSign,cRLSign";
    try runOpenSsl(&.{
        "openssl", "req",     "-x509", "-new",    "-key",                       ca_key,
        "-sha256", "-days",   "2",     "-subj",   "/CN=ztls interop client CA", "-out",
        ca_path,   "-addext", ca_bc,   "-addext", ca_ku,
    });
    try runOpenSsl(&.{
        "openssl", "ecparam", "-name", "prime256v1",
        "-genkey", "-noout",  "-out",  key_path,
    });
    try runOpenSsl(&.{
        "openssl", "req",   "-new",                    "-key",
        key_path,  "-subj", "/CN=ztls interop client", "-out",
        csr_path,
    });
    try runOpenSsl(&.{
        "openssl", "x509",            "-req",    "-in",
        csr_path,  "-CA",             ca_path,   "-CAkey",
        ca_key,    "-CAcreateserial", "-out",    cert_path,
        "-days",   "1",               "-sha256", "-extfile",
        ext_path,
    });
    try runOpenSsl(&.{
        "openssl",  "x509", "-in",  cert_path,
        "-outform", "DER",  "-out", der_path,
    });
    return .{ .ca = ca_path, .cert = cert_path, .key = key_path, .der = der_path };
}

fn runOpenSsl(argv: []const []const u8) !void {
    var child = try std.process.spawn(testIo(), .{
        .argv = argv,
        .stdout = .ignore,
        .stderr = .ignore,
    });
    if (!exitedZero(try child.wait(testIo()))) return error.CertificateGenerationFailed;
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

fn startOpenSslClientCapturingFailure(
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
        .stdout = .ignore,
        .stderr = .pipe,
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

fn mtlsServerRun(ctx: *MtlsServerCtx) void {
    mtlsServerExchange(ctx) catch |err| {
        ctx.err = err;
    };
}

/// RFC 8446 §4.4.2, §4.4.3 — accept one connection requiring a verified
/// client certificate, then serve the plain HTTP exchange.
fn mtlsServerExchange(ctx: *MtlsServerCtx) !void {
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

    var conn: IdentityServer = undefined;
    try conn.accept(io, sock, .{
        .cert_chain = &.{server_cert_der},
        .signer = key.signer(),
        .alpn = &.{alpn},
        .client_auth = .{ .required = .{ .bundle = ctx.bundle } },
    });
    defer conn.deinit();
    ctx.suite = conn.info().cipher_suite;
    if (conn.info().client_identity) |der| {
        @memcpy(ctx.identity_buf[0..der.len], der);
        ctx.identity_len = der.len;
    }

    const request_line = try conn.reader().takeDelimiterInclusive('\n');
    try testing.expect(mem.startsWith(u8, request_line, "GET / HTTP/1.0"));
    try conn.writer().writeAll(response);
    try conn.writer().flush();
    conn.close();
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

fn waitForRejectedOpenSslClient(child: *Child) !RejectedExchange {
    const io = testIo();
    child.stdin.?.close(io);
    child.stdin = null;

    var result: RejectedExchange = .{
        .term = undefined,
        .stderr = undefined,
        .stderr_len = 0,
    };
    result.stderr_len = try readFileAll(child.stderr.?, &result.stderr);
    result.term = try child.wait(io);
    return result;
}

fn writeDerCertificatePem(allocator: mem.Allocator, der: []const u8, path: []const u8) !void {
    const encoder = std.base64.standard.Encoder;
    const encoded_len = encoder.calcSize(der.len);
    var encoded_buffer: [4096]u8 = undefined;
    if (encoded_len > encoded_buffer.len) return error.BufferTooShort;
    const encoded = encoder.encode(encoded_buffer[0..encoded_len], der);
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
    try writeDerCertificatePem(allocator, server_cert_der, ca_path);

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

// RFC 8446 §4.1, §4.4.2, §4.4.3 — the wrapper's client credentials
// interoperate with `openssl s_server -Verify -verifyCAfile`: OpenSSL
// requires and verifies the fixture client certificate (clientAuth EKU,
// self-signed so it is its own anchor in the CAfile), and `-verify_return_error`
// makes a failed verification abort the handshake, so a completed exchange
// proves the verification happened rather than merely being logged.
test "ztls_std.Client credentials interoperate with openssl s_server -Verify" {
    try requireOpenSsl();

    var arena_state: std.heap.ArenaAllocator = .init(testing.allocator);
    defer arena_state.deinit();
    const allocator = arena_state.allocator();
    var tmp = testing.tmpDir(.{});
    defer tmp.cleanup();
    const dir = try tmpDirPath(allocator, &tmp);
    const cert_path = try std.fs.path.join(allocator, &.{ dir, "cert.pem" });
    const key_path = try std.fs.path.join(allocator, &.{ dir, "key.pem" });
    const client_ca_path = try std.fs.path.join(allocator, &.{ dir, "client-ca.pem" });
    try generateCertificate(cert_path, key_path);
    try writeDerCertificatePem(allocator, client_cert_der, client_ca_path);

    const port = try availablePort();
    var child = try startOpenSslVerifyingServer(
        allocator,
        cert_path,
        key_path,
        client_ca_path,
        port,
    );
    defer child.kill(testIo());

    const sock = try connectWithRetry(port);
    var client_key: ztls.signature.PrivateKey = try .fromP256Scalar(
        @ptrCast(client_scalar[0..32]),
    );
    defer client_key.deinit();
    var conn: tls.Client = undefined;
    try conn.connect(testIo(), sock, .{
        .host = "localhost",
        .verify = .insecure,
        .alpn = &.{alpn},
        .client_credentials = .{
            .cert_chain = &.{client_cert_der},
            .signer = client_key.signer(),
        },
    });
    defer conn.deinit();

    try conn.writer().writeAll(request);
    try conn.writer().flush();
    const status_line = try conn.reader().takeDelimiterInclusive('\n');
    try testing.expect(mem.startsWith(u8, status_line, "HTTP/1.0 200"));
    conn.close();
}

// RFC 8446 §4.4.2 — an OpenSSL server configured with `-Verify` rejects a
// wrapper client that sends an empty Certificate. The peer's fatal alert is
// authenticated and surfaces through the wrapper read-error channel.
test "ztls_std.Client without credentials is rejected by openssl s_server -Verify" {
    try requireOpenSsl();

    var arena_state: std.heap.ArenaAllocator = .init(testing.allocator);
    defer arena_state.deinit();
    const allocator = arena_state.allocator();
    var tmp = testing.tmpDir(.{});
    defer tmp.cleanup();
    const dir = try tmpDirPath(allocator, &tmp);
    const cert_path = try std.fs.path.join(allocator, &.{ dir, "cert.pem" });
    const key_path = try std.fs.path.join(allocator, &.{ dir, "key.pem" });
    const client_ca_path = try std.fs.path.join(allocator, &.{ dir, "client-ca.pem" });
    try generateCertificate(cert_path, key_path);
    try writeDerCertificatePem(allocator, client_cert_der, client_ca_path);

    const port = try availablePort();
    var child = try startOpenSslVerifyingServer(
        allocator,
        cert_path,
        key_path,
        client_ca_path,
        port,
    );
    defer child.kill(testIo());

    const sock = try connectWithRetry(port);
    var conn: tls.Client = undefined;
    try conn.connect(testIo(), sock, .{
        .host = "localhost",
        .verify = .insecure,
        .alpn = &.{alpn},
    });
    defer conn.deinit();

    try testing.expectError(error.ReadFailed, conn.reader().fillMore());
    try testing.expectEqual(tls.ReadError.TlsAlertReceived, conn.readError().?);
}

// RFC 8446 §4.4.2, §4.4.3 — `openssl s_client -cert -key`
// interoperates with a requiring ztls_std.Server that verifies the client
// chain against a caller-owned Bundle using the real clock, retains the leaf,
// and surfaces it through `info().client_identity`.
test "openssl s_client credentials interoperate with a requiring ztls_std.Server" {
    try requireOpenSsl();

    var arena_state: std.heap.ArenaAllocator = .init(testing.allocator);
    defer arena_state.deinit();
    const allocator = arena_state.allocator();
    var tmp = testing.tmpDir(.{});
    defer tmp.cleanup();
    const dir = try tmpDirPath(allocator, &tmp);
    const creds = try generateClientAuthCertificate(allocator, dir);
    const server_ca_path = try std.fs.path.join(allocator, &.{ dir, "ca.pem" });
    try writeDerCertificatePem(allocator, server_cert_der, server_ca_path);

    // The caller-owned trust bundle the server verifies clients against.
    var bundle: std.crypto.Certificate.Bundle = .empty;
    defer bundle.deinit(allocator);
    try bundle.addCertsFromFilePath(
        allocator,
        testIo(),
        Io.Timestamp.now(testIo(), .real),
        Io.Dir.cwd(),
        creds.ca,
    );

    const addr = try net.IpAddress.parse(host, 0);
    var ctx: MtlsServerCtx = .{
        .listener = try addr.listen(testIo(), .{ .reuse_address = true }),
        .bundle = &bundle,
    };
    const port = ctx.listener.socket.address.getPort();
    var child = startOpenSslMtlsClient(
        allocator,
        server_ca_path,
        creds.cert,
        creds.key,
        port,
    ) catch |err| {
        ctx.listener.deinit(testIo());
        return err;
    };
    defer child.kill(testIo());
    const thread = std.Thread.spawn(.{}, mtlsServerRun, .{&ctx}) catch |err| {
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
    try testing.expect(mem.containsAtLeast(
        u8,
        exchange.stdout[0..exchange.stdout_len],
        1,
        "hello",
    ));
    try testing.expectEqual(ztls.CipherSuite.aes_128_gcm_sha256, ctx.suite.?);

    // The retained identity is the exact generated leaf DER, read back from
    // the DER copy the generator wrote.
    var der_buffer: [1024]u8 = undefined;
    const leaf_der = try Io.Dir.cwd().readFile(testIo(), creds.der, &der_buffer);
    try testing.expectEqualSlices(u8, leaf_der, ctx.identity().?);
}

// RFC 8446 §4.4.2, §4.4.4 — a requiring wrapper server rejects an OpenSSL
// client that sends an empty Certificate. OpenSSL must decrypt the server's
// post-Finished alert as certificate_required (116), proving the server write
// direction has advanced to application traffic keys.
test "openssl s_client without credentials receives certificate_required from ztls_std.Server" {
    try requireOpenSsl();

    var arena_state: std.heap.ArenaAllocator = .init(testing.allocator);
    defer arena_state.deinit();
    const allocator = arena_state.allocator();
    var tmp = testing.tmpDir(.{});
    defer tmp.cleanup();
    const dir = try tmpDirPath(allocator, &tmp);
    const server_ca_path = try std.fs.path.join(allocator, &.{ dir, "ca.pem" });
    try writeDerCertificatePem(allocator, server_cert_der, server_ca_path);

    var bundle: std.crypto.Certificate.Bundle = .empty;
    defer bundle.deinit(allocator);
    const addr = try net.IpAddress.parse(host, 0);
    var ctx: MtlsServerCtx = .{
        .listener = try addr.listen(testIo(), .{ .reuse_address = true }),
        .bundle = &bundle,
    };
    const port = ctx.listener.socket.address.getPort();
    var child = startOpenSslClientCapturingFailure(
        allocator,
        server_ca_path,
        port,
    ) catch |err| {
        ctx.listener.deinit(testIo());
        return err;
    };
    defer child.kill(testIo());
    const thread = std.Thread.spawn(.{}, mtlsServerRun, .{&ctx}) catch |err| {
        ctx.listener.deinit(testIo());
        return err;
    };

    const exchange = waitForRejectedOpenSslClient(&child) catch |err| {
        child.kill(testIo());
        thread.join();
        return err;
    };
    thread.join();

    try testing.expect(!exitedZero(exchange.term));
    try testing.expectEqual(@as(?anyerror, error.ClientCertificateRejected), ctx.err);
    try testing.expect(mem.containsAtLeast(
        u8,
        exchange.stderr[0..exchange.stderr_len],
        1,
        "alert number 116",
    ));
}
