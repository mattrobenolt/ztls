//! Interop test: drive the ztls client handshake against `openssl s_server`.
//!
//! This is an I/O harness, not part of the no-I/O library. It spawns openssl
//! s_server with a freshly generated P-256 cert, drives a real handshake
//! (client_hello.encode → processRecord loop), then fetches the s_server status
//! page over the negotiated keys. Run with: `zig build test-openssl`.
//!
//! Forces TLS_AES_128_GCM_SHA256 (the only suite the client supports today).
//! Certificate validation is signature-only (default policy): we verify
//! openssl's CertificateVerify against the presented leaf key but do not anchor
//! to a trust store.
const std = @import("std");

const ztls = @import("ztls");

const port = 14433;
const host = "127.0.0.1";

pub fn main() !void {
    var gpa: std.heap.DebugAllocator(.{}) = .init;
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    var tmp = std.testing.tmpDir(.{});
    defer tmp.cleanup();
    const dir = try tmp.dir.realpathAlloc(alloc, ".");
    defer alloc.free(dir);
    const cert_path = try std.fs.path.join(alloc, &.{ dir, "cert.pem" });
    defer alloc.free(cert_path);
    const key_path = try std.fs.path.join(alloc, &.{ dir, "key.pem" });
    defer alloc.free(key_path);

    try genCert(alloc, cert_path, key_path);

    var server = try startServer(alloc, cert_path, key_path);
    defer _ = server.kill() catch {};

    const stream = try connectWithRetry();
    defer stream.close();

    try interop(stream);
}

fn genCert(alloc: std.mem.Allocator, cert_path: []const u8, key_path: []const u8) !void {
    var child = std.process.Child.init(&.{
        "openssl",                 "req",     "-x509",
        "-newkey",                 "ec",      "-pkeyopt",
        "ec_paramgen_curve:P-256", "-keyout", key_path,
        "-out",                    cert_path, "-days",
        "1",                       "-nodes",  "-subj",
        "/CN=localhost",
    }, alloc);
    child.stdout_behavior = .Ignore;
    child.stderr_behavior = .Ignore;
    const term = try child.spawnAndWait();
    if (term != .Exited or term.Exited != 0) return error.CertGenFailed;
}

fn startServer(alloc: std.mem.Allocator, cert_path: []const u8, key_path: []const u8) !std.process.Child {
    var child = std.process.Child.init(&.{
        "openssl",                             "s_server",
        "-tls1_3",                             "-ciphersuites",
        "TLS_AES_128_GCM_SHA256",              "-key",
        key_path,                              "-cert",
        cert_path,                             "-port",
        std.fmt.comptimePrint("{d}", .{port}), "-www",
        "-quiet",
    }, alloc);
    child.stdout_behavior = .Ignore;
    child.stderr_behavior = .Ignore;
    try child.spawn();
    return child;
}

fn connectWithRetry() !std.net.Stream {
    const addr = try std.net.Address.parseIp(host, port);
    var attempts: usize = 0;
    while (attempts < 100) : (attempts += 1) {
        return std.net.tcpConnectToAddress(addr) catch {
            std.Thread.sleep(20 * std.time.ns_per_ms);
            continue;
        };
    }
    return error.ServerNeverCameUp;
}

fn interop(stream: std.net.Stream) !void {
    const kp = ztls.x25519.KeyPair.generate();
    var random: ztls.client_hello.Random = undefined;
    std.crypto.random.bytes(&random.data);

    var hs: ztls.ClientHandshake = .init(kp);

    // `out` holds records we emit (ClientHello, Finished, app data); the engine
    // owns framing, so we just write what it returns and acknowledge with
    // completeWrite(). `storage` backs the record-framing buffer that turns the
    // byte stream into whole records.
    var out: [1024]u8 = undefined;
    var storage: [ztls.RecordBuffer.recommended_storage]u8 = undefined;
    var rb: ztls.RecordBuffer = .init(&storage);

    // ClientHello.
    try stream.writeAll(try hs.start(&out, random, "localhost"));
    hs.completeWrite();

    // Drive the handshake: read bytes, pull whole records, feed the engine,
    // send whatever it hands back.
    while (!hs.isConnected()) {
        const n = try stream.read(rb.writable());
        if (n == 0) return error.ServerClosed;
        rb.advance(n);
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out)) {
            .write => |w| {
                try stream.writeAll(w);
                hs.completeWrite();
            },
            .none => {},
            .application_data, .closed => return error.UnexpectedDuringHandshake,
        };
    }
    std.debug.print("[interop] handshake completed against openssl s_server\n", .{});

    // Request the s_server status page and read the response.
    try stream.writeAll(try hs.sendApplicationData("GET / HTTP/1.0\r\n\r\n", &out));
    hs.completeWrite();

    while (true) {
        const n = try stream.read(rb.writable());
        if (n == 0) break; // peer closed the TCP connection
        rb.advance(n);
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out)) {
            .application_data => |data| if (std.mem.startsWith(u8, data, "HTTP/1.0 200")) {
                std.debug.print("[interop] decrypted s_server HTTP response — OK\n", .{});
                return;
            },
            .write => |w| { // e.g. a KeyUpdate response
                try stream.writeAll(w);
                hs.completeWrite();
            },
            .none => {},
            .closed => return error.ServerClosedBeforeResponse,
        };
    }
    return error.NoHttpResponse;
}
