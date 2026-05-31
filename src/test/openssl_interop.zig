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
const fs = std.fs;
const mem = std.mem;
const testing = std.testing;
const Allocator = mem.Allocator;
const Child = std.process.Child;
const Thread = std.Thread;
const crypto = std.crypto;
const net = std.net;
const heap = std.heap;
const print = std.debug.print;

const ztls = @import("ztls");

const base_port = 14433;
const host = "127.0.0.1";

// Suites the client supports today, each validated end-to-end against openssl.
const suites = [_][]const u8{
    "TLS_AES_128_GCM_SHA256",
    "TLS_CHACHA20_POLY1305_SHA256",
};

var debug_allocator: heap.DebugAllocator(.{}) = .init;

pub fn main() !void {
    defer _ = debug_allocator.deinit();
    const gpa = debug_allocator.allocator();

    var arena_allocator: heap.ArenaAllocator = .init(gpa);
    defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();

    var tmp = testing.tmpDir(.{});
    defer tmp.cleanup();
    const dir = try tmp.dir.realpathAlloc(arena, ".");
    const cert_path = try fs.path.join(arena, &.{ dir, "cert.pem" });
    const key_path = try fs.path.join(arena, &.{ dir, "key.pem" });

    try genCert(gpa, cert_path, key_path);

    // A fresh port per suite avoids TIME_WAIT rebinding races between runs.
    for (suites, 0..) |suite, i| {
        try runSuite(arena, cert_path, key_path, suite, base_port + @as(u16, @intCast(i)));
    }
}

fn runSuite(arena: Allocator, cert_path: []const u8, key_path: []const u8, suite: []const u8, port: u16) !void {
    var server = try startServer(arena, cert_path, key_path, suite, port);
    defer _ = server.kill() catch {};
    const stream = try connectWithRetry(port);
    defer stream.close();
    print("[interop] {s}\n", .{suite});
    try interop(stream);
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

fn startServer(arena: Allocator, cert_path: []const u8, key_path: []const u8, suite: []const u8, port: u16) !Child {
    const port_str = try std.fmt.allocPrint(arena, "{d}", .{port});
    var child = Child.init(&.{
        "openssl", "s_server",
        "-tls1_3", "-ciphersuites",
        suite,     "-key",
        key_path,  "-cert",
        cert_path, "-port",
        port_str,  "-www",
        "-quiet",
    }, arena);
    child.stdout_behavior = .Ignore;
    child.stderr_behavior = .Ignore;
    try child.spawn();
    return child;
}

fn connectWithRetry(port: u16) !net.Stream {
    const addr: net.Address = try .parseIp(host, port);
    var attempts: usize = 0;
    while (attempts < 100) : (attempts += 1) {
        return net.tcpConnectToAddress(addr) catch {
            Thread.sleep(20 * std.time.ns_per_ms);
            continue;
        };
    }
    return error.ServerNeverCameUp;
}

fn interop(stream: net.Stream) !void {
    const kp: ztls.x25519.KeyPair = .generate();
    var random: ztls.client_hello.Random = undefined;
    crypto.random.bytes(&random.data);

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
    print("[interop] handshake completed against openssl s_server\n", .{});

    // Request the s_server status page and read the response.
    try stream.writeAll(try hs.sendApplicationData("GET / HTTP/1.0\r\n\r\n", &out));
    hs.completeWrite();

    while (true) {
        const n = try stream.read(rb.writable());
        if (n == 0) break; // peer closed the TCP connection
        rb.advance(n);
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out)) {
            .application_data => |data| if (mem.startsWith(u8, data, "HTTP/1.0 200")) {
                print("[interop] decrypted s_server HTTP response — OK\n", .{});
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
