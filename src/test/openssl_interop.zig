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

const Reader = struct {
    stream: std.net.Stream,
    buf: [2 * ztls.frame.max_ciphertext_len]u8 = undefined,
    pos: usize = 0, // start of unconsumed data
    filled: usize = 0, // end of valid data

    /// Return one complete TLS record (header + fragment) as a mutable slice
    /// into `buf`, reading from the socket as needed. The slice stays valid
    /// until the next call (the caller decrypts it in place before then).
    fn next(self: *Reader) ![]u8 {
        while (true) {
            const avail = self.buf[self.pos..self.filled];
            if (avail.len >= ztls.frame.header_len) {
                const hdr = try ztls.frame.parseHeader(avail);
                const total = ztls.frame.header_len + hdr.length();
                if (avail.len >= total) {
                    defer self.pos += total;
                    return avail[0..total];
                }
            }
            // Need more data. Compact the unconsumed tail to the front first —
            // the previously returned record (before pos) is done with.
            if (self.pos > 0) {
                std.mem.copyForwards(u8, self.buf[0..], self.buf[self.pos..self.filled]);
                self.filled -= self.pos;
                self.pos = 0;
            }
            const n = try self.stream.read(self.buf[self.filled..]);
            if (n == 0) return error.ServerClosed;
            self.filled += n;
        }
    }
};

fn interop(stream: std.net.Stream) !void {
    const kp = ztls.x25519.KeyPair.generate();
    var random: ztls.client_hello.Random = undefined;
    std.crypto.random.bytes(&random.data);

    // Encode ClientHello and frame it as a plaintext handshake record.
    var ch_buf: [512]u8 = undefined;
    const ch = try ztls.client_hello.encode(&ch_buf, random, .init(kp.public_key), "localhost");

    var ch_rec: [512 + ztls.frame.header_len]u8 = undefined;
    ch_rec[0..ztls.frame.header_len].* = std.mem.toBytes(ztls.frame.Header.init(.handshake, @intCast(ch.len)));
    @memcpy(ch_rec[ztls.frame.header_len..][0..ch.len], ch);
    try stream.writeAll(ch_rec[0 .. ztls.frame.header_len + ch.len]);

    var hs: ztls.ClientHandshake = .init(kp.secret_key);
    hs.start(ch);

    var reader: Reader = .{ .stream = stream };
    var out: [512]u8 = undefined;

    // Handshake: feed records until the engine reports connected.
    while (hs.state != .connected) {
        const record = try reader.next();
        if (try hs.processRecord(record, &out)) |to_send| try stream.writeAll(to_send);
    }
    std.debug.print("[interop] handshake completed against openssl s_server\n", .{});

    // Application data: request the s_server status page and read the response.
    const request = "GET / HTTP/1.0\r\n\r\n";
    var req_rec: [request.len + ztls.RecordLayer.overhead]u8 = undefined;
    try stream.writeAll(try hs.tx.encrypt(.application_data, request, &req_rec));

    var got_http = false;
    while (!got_http) {
        const record = reader.next() catch |e| switch (e) {
            error.ServerClosed => break,
            else => return e,
        };
        switch (try hs.receive(record, &out)) {
            .application_data => |data| {
                if (std.mem.startsWith(u8, data, "HTTP/1.0 200")) got_http = true;
            },
            .closed => break,
            .none, .send => {}, // NewSessionTicket etc.
        }
    }
    if (!got_http) return error.NoHttpResponse;
    std.debug.print("[interop] decrypted s_server HTTP response — OK\n", .{});
}
