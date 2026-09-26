const std = @import("std");
const heap = std.heap;
const mem = std.mem;
const Io = std.Io;
const testing = std.testing;
const Child = std.process.Child;
const Allocator = mem.Allocator;
const IpAddress = Io.net.IpAddress;
const Stream = Io.net.Stream;
const Server = Io.net.Server;
const path = Io.Dir.path;

const fixtures = @import("fixtures");

const backend = @import("crypto/backend.zig");
const entropy = @import("entropy.zig");
const ztls = @import("root.zig");

const host = "127.0.0.1";
const alpn_protocol = "http/1.1";
const response = "HTTP/1.0 200 OK\r\nContent-Length: 5\r\n\r\nhello";

const server_cert_der: []const u8 = &fixtures.server_ecdsa_cert_der;
const server_scalar: []const u8 = &fixtures.server_ecdsa_scalar;

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

const InteropGroup = struct {
    openssl_name: []const u8,
    ztls_group: ztls.kex.NamedGroup,
};

const p384_group: InteropGroup = .{
    .openssl_name = "P-384",
    .ztls_group = .secp384r1,
};

const hybrid_groups = [_]InteropGroup{
    .{ .openssl_name = "X25519MLKEM768", .ztls_group = .x25519_mlkem768 },
    .{ .openssl_name = "SecP256r1MLKEM768", .ztls_group = .secp256r1_mlkem768 },
    .{ .openssl_name = "SecP384r1MLKEM1024", .ztls_group = .secp384r1_mlkem1024 },
};

test "OpenSSL s_server interoperates with ztls client" {
    var arena_allocator: heap.ArenaAllocator = .init(testing.allocator);
    defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();

    var tmp = testing.tmpDir(.{});
    defer tmp.cleanup();
    const dir = try tmpDirPath(arena, &tmp);
    const cert_path = try path.join(arena, &.{ dir, "cert.pem" });
    const key_path = try path.join(arena, &.{ dir, "key.pem" });

    try genCert(cert_path, key_path);

    for (client_suites, 0..) |suite, i| {
        try runClientSuite(arena, cert_path, key_path, suite, 14433 + @as(u16, @intCast(i)));
    }
}

// RFC 8446 §4.2.8.2, §7.4 — OpenSSL independently validates the ztls
// secp384r1 ClientHello share and derives matching handshake/traffic keys.
test "OpenSSL s_server interoperates with ztls P-384 client" {
    if (!backend.supportsClientP384()) return error.SkipZigTest;

    var arena_allocator: heap.ArenaAllocator = .init(testing.allocator);
    defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();

    var tmp = testing.tmpDir(.{});
    defer tmp.cleanup();
    const dir = try tmpDirPath(arena, &tmp);
    const cert_path = try path.join(arena, &.{ dir, "cert.pem" });
    const key_path = try path.join(arena, &.{ dir, "key.pem" });
    try genCert(cert_path, key_path);

    try runClientGroup(arena, cert_path, key_path, p384_group, 20343);
}

// RFC 10024 §4 — OpenSSL independently validates every ztls client hybrid
// share layout and derives matching ECDHE + ML-KEM traffic keys.
test "OpenSSL s_server interoperates with ztls RFC 10024 client groups" {
    var arena_allocator: heap.ArenaAllocator = .init(testing.allocator);
    defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();

    var tmp = testing.tmpDir(.{});
    defer tmp.cleanup();
    const dir = try tmpDirPath(arena, &tmp);
    const cert_path = try path.join(arena, &.{ dir, "cert.pem" });
    const key_path = try path.join(arena, &.{ dir, "key.pem" });
    try genCert(cert_path, key_path);

    var tested = false;
    for (hybrid_groups, 0..) |group, i| {
        if (!backend.supportsClientHybridGroup(group.ztls_group)) continue;
        tested = true;
        try runClientGroup(
            arena,
            cert_path,
            key_path,
            group,
            20433 + @as(u16, @intCast(i)),
        );
    }
    if (!tested) return error.SkipZigTest;
}

// RFC 8446 §4.6.1, §4.2.11 — ztls client resumes with openssl s_server:
// connection 1 completes a full handshake and captures the NewSessionTicket
// the server issues; connection 2 offers that ticket (startWithPsk) and the
// server resumes with the PSK.
test "ztls client resumes with OpenSSL s_server (PSK resumption)" {
    var arena_allocator: heap.ArenaAllocator = .init(testing.allocator);
    defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();

    var tmp = testing.tmpDir(.{});
    defer tmp.cleanup();
    const dir = try tmpDirPath(arena, &tmp);
    const cert_path = try path.join(arena, &.{ dir, "cert.pem" });
    const key_path = try path.join(arena, &.{ dir, "key.pem" });
    try genCert(cert_path, key_path);

    try runResumptionInterop(arena, cert_path, key_path, 19433);
}

// RFC 8446 §4.2.10, §4.5, §7.1 — ztls client sends 0-RTT early data to
// openssl s_server. Connection 1 captures an NST with early_data; connection
// 2 offers the ticket with early_data, sends 0-RTT data, then completes the
// handshake (EndOfEarlyData + Finished). The server accepts the 0-RTT data
// and responds to the GET request. See PRODUCTION_READINESS.md for status.
test "ztls client sends 0-RTT early data to OpenSSL s_server" {
    var arena_allocator: heap.ArenaAllocator = .init(testing.allocator);
    defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();

    var tmp = testing.tmpDir(.{});
    defer tmp.cleanup();
    const dir = try tmpDirPath(arena, &tmp);
    const cert_path = try path.join(arena, &.{ dir, "cert.pem" });
    const key_path = try path.join(arena, &.{ dir, "key.pem" });
    try genCert(cert_path, key_path);

    try runEarlyDataInterop(arena, cert_path, key_path, 19434);
}

test "OpenSSL s_client interoperates with ztls server" {
    var arena_allocator: heap.ArenaAllocator = .init(testing.allocator);
    defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();

    for (server_suites, 0..) |suite, i| {
        try runServerSuite(arena, suite, 16433 + @as(u16, @intCast(i)));
    }
}

// RFC 8446 §4.6.1, §4.2.11 — OpenSSL stores a ztls-issued ticket on the first
// connection and offers it on the second; the ztls server selects the PSK.
test "OpenSSL s_client resumes with ztls server-issued ticket" {
    var arena_allocator: heap.ArenaAllocator = .init(testing.allocator);
    defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();

    var tmp = testing.tmpDir(.{});
    defer tmp.cleanup();
    const dir = try tmpDirPath(arena, &tmp);
    const session_path = try path.join(arena, &.{ dir, "session.pem" });
    try runServerResumptionSuite(arena, session_path, 16533);
}

// RFC 8446 §4.2.8.2, §7.4 — OpenSSL independently validates the ztls
// secp384r1 ServerHello share and derives matching handshake/traffic keys.
test "OpenSSL s_client interoperates with ztls P-384 server" {
    if (!backend.supportsServerP384()) return error.SkipZigTest;

    var arena_allocator: heap.ArenaAllocator = .init(testing.allocator);
    defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();

    try runServerGroup(arena, p384_group, 21343);
}

// RFC 10024 §4 — OpenSSL independently validates every ztls server hybrid
// share layout and derives matching ECDHE + ML-KEM traffic keys.
test "OpenSSL s_client interoperates with ztls RFC 10024 server groups" {
    var arena_allocator: heap.ArenaAllocator = .init(testing.allocator);
    defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();

    var tested = false;
    for (hybrid_groups, 0..) |group, i| {
        if (!backend.supportsServerHybridGroup(group.ztls_group)) continue;
        tested = true;
        try runServerGroup(arena, group, 21433 + @as(u16, @intCast(i)));
    }
    if (!tested) return error.SkipZigTest;
}

// RFC 8446 §4.7.2, §4.4.2, §4.4.3 — ztls server requiring client authentication
// accepts a client certificate presented by `openssl s_client -cert -key`.
test "OpenSSL s_client with -cert interoperates with ztls server (required client auth)" {
    var arena_allocator: heap.ArenaAllocator = .init(testing.allocator);
    defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();

    var tmp = testing.tmpDir(.{});
    defer tmp.cleanup();
    const dir = try tmpDirPath(arena, &tmp);
    const client_cert_path = try path.join(arena, &.{ dir, "client.pem" });
    const client_key_path = try path.join(arena, &.{ dir, "client.key" });
    try genCert(client_cert_path, client_key_path);

    try runServerClientAuthSuite(
        arena,
        client_cert_path,
        client_key_path,
        17433,
    );
}

// RFC 8446 §4.7.2, §4.4.2, §4.4.3 — ztls client presenting a certificate to
// `openssl s_server -Verify` completes the handshake and exchanges data.
test "ztls client with credentials interoperates with OpenSSL s_server -Verify" {
    var arena_allocator: heap.ArenaAllocator = .init(testing.allocator);
    defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();

    var tmp = testing.tmpDir(.{});
    defer tmp.cleanup();
    const dir = try tmpDirPath(arena, &tmp);
    // s_server needs a server cert/key (self-signed) and a CAfile that trusts
    // the ztls client's self-signed fixture certificate. The fixture cert is
    // self-signed, so its own PEM is the CAfile.
    const server_cert_path = try path.join(arena, &.{ dir, "server.pem" });
    const server_key_path = try path.join(arena, &.{ dir, "server.key" });
    try genCert(server_cert_path, server_key_path);
    const client_ca_path = try path.join(arena, &.{ dir, "client_ca.pem" });
    try writeFixtureCertPem(arena, client_ca_path);

    try runClientAuthClientSuite(arena, server_cert_path, server_key_path, client_ca_path, 18433);
}

// RFC 8446 §4.6.3, §7.2 — ztls-to-ztls TCP loopback KeyUpdate round trip.
// The server initiates KeyUpdate(update_requested) over a real TCP connection;
// the client responds; both sides ratchet keys; application data flows under
// the new keys. Tested with ChaCha20-Poly1305 to reproduce the TLS-Anvil
// #71 scenario (BoringSSL + ChaCha20 + X25519 + CCS). Unlike the in-memory
// test, this exercises the real socket drive loop including record
// reassembly and partial reads.
test "ztls-to-ztls TCP KeyUpdate round trip with ChaCha20-Poly1305" {
    const KuCtx = struct {
        port: std.atomic.Value(u16) = .init(0),
        server_keypair: ztls.x25519.KeyPair,
    };
    const server_keypair: ztls.x25519.KeyPair = .generate();
    var ctx: KuCtx = .{ .server_keypair = server_keypair };

    const ServerThread = struct {
        fn run(c: *KuCtx) !void {
            const addr: IpAddress = try .parse(host, 0);
            var listener = try addr.listen(testing.io, .{ .reuse_address = true });
            defer listener.deinit(testing.io);
            c.port.store(listener.socket.address.getPort(), .release);

            const stream = try listener.accept(testing.io);
            defer stream.close(testing.io);

            var random: ztls.Random = .empty;
            entropy.fill(&random.data);
            var hs: ztls.ServerHandshake = .init(.{
                .keypairs = try .init(c.server_keypair),
                .random = random,
            });
            defer hs.deinit();
            const suites = [_]ztls.CipherSuite{.chacha20_poly1305_sha256};
            hs.supportSuites(&suites);
            var signer = try ztls.signature.PrivateKey.fromP256Scalar(server_scalar[0..32]);
            defer signer.deinit();
            hs.setCredentials(&.{server_cert_der}, signer.signer());

            var storage: ztls.RecordBuffer.Storage = .empty;
            var rb: ztls.RecordBuffer = .init(&storage.buffer);
            var out: ztls.ServerHandshake.OutBuffer = .empty;
            var flight: ztls.ServerHandshake.FlightBuffer = .empty;

            // Drive handshake.
            while (!hs.isConnected()) {
                const n = try ztls.io.fill(testing.io, stream, &rb);
                if (n == 0) return error.ClientClosed;
                while (try rb.next()) |record| {
                    const ev = try hs.handleRecord(record, &out.buffer);
                    switch (ev) {
                        .write => |w| {
                            try ztls.io.writeAll(testing.io, stream, w);
                            hs.completeWrite();
                            if (try hs.sendServerFlightBuffered(&flight)) |fb| {
                                try ztls.io.writeAll(testing.io, stream, fb);
                                hs.completeWrite();
                            }
                        },
                        .none => {},
                        else => return error.UnexpectedDuringHandshake,
                    }
                }
            }

            // Server sends KeyUpdate(update_requested).
            const ku = try hs.sendKeyUpdate(&out.buffer, .update_requested);
            try ztls.io.writeAll(testing.io, stream, ku);
            hs.completeWrite();

            // Echo loop: expect client's KeyUpdate response, then app data.
            while (true) {
                const n = try ztls.io.fill(testing.io, stream, &rb);
                if (n == 0) return error.ClientClosed;
                while (try rb.next()) |record| {
                    const ev = try hs.handleRecord(record, &out.buffer);
                    switch (ev) {
                        .key_update => |ku_ev| {
                            if (ku_ev.response) |w| {
                                try ztls.io.writeAll(testing.io, stream, w);
                                hs.completeWrite();
                            }
                        },
                        .application_data => |data| {
                            if (!mem.eql(u8, data, "after-ku")) return error.UnexpectedAppData;
                            const resp = try hs.sendApplicationData("pong-ku", &out.buffer);
                            try ztls.io.writeAll(testing.io, stream, resp);
                            hs.completeWrite();
                            const close = try hs.sendAlert(.close_notify, &out.buffer);
                            try ztls.io.writeAll(testing.io, stream, close);
                            hs.completeWrite();
                            return;
                        },
                        .write => |w| {
                            try ztls.io.writeAll(testing.io, stream, w);
                            hs.completeWrite();
                        },
                        .closed => return,
                        .none => {},
                    }
                }
            }
        }
    };

    const server_thread = try std.Thread.spawn(.{}, ServerThread.run, .{&ctx});
    defer server_thread.join();

    // Wait for the server to bind and publish its port.
    var server_port: u16 = 0;
    while (server_port == 0) {
        server_port = ctx.port.load(.acquire);
        if (server_port == 0) {
            std.Thread.yield() catch return error.ServerBindFailed;
        }
    }

    // Client side.
    const client_keypair: ztls.x25519.KeyPair = .generate();
    const addr: IpAddress = try .parse(host, server_port);
    const stream = try addr.connect(testing.io, .{ .mode = .stream });
    defer stream.close(testing.io);

    var random: ztls.Random = .empty;
    entropy.fill(&random.data);
    var hs: ztls.ClientHandshake = .init(.{
        .keypairs = try .init(client_keypair),
        .host_name = "ztls.server.test",
        .now_sec = 0,
        .random = random,
        .insecure_no_chain_anchor = true,
    });
    defer hs.deinit();

    var out: ztls.ClientHandshake.OutBuffer = .empty;
    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);

    try ztls.io.writeAll(testing.io, stream, try hs.start(&out.buffer));
    hs.completeWrite();

    while (!hs.isConnected()) {
        const n = try ztls.io.fill(testing.io, stream, &rb);
        if (n == 0) return error.ServerClosed;
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out.buffer)) {
            .write => |w| {
                try ztls.io.writeAll(testing.io, stream, w);
                hs.completeWrite();
            },
            .application_data,
            .closed,
            .key_update,
            .new_session_ticket,
            => return error.UnexpectedDuringHandshake,
            .none => {},
        };
    }

    // Drive: expect server's KeyUpdate, then send app data under new keys.
    var saw_key_update = false;
    var got_pong = false;
    while (!got_pong) {
        const n = try ztls.io.fill(testing.io, stream, &rb);
        if (n == 0) break;
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out.buffer)) {
            .key_update => |ku| {
                if (ku.response) |w| {
                    try ztls.io.writeAll(testing.io, stream, w);
                    hs.completeWrite();
                }
                // Send app data under the new keys after the KeyUpdate.
                if (!saw_key_update) {
                    saw_key_update = true;
                    const app = try hs.sendApplicationData("after-ku", &out.buffer);
                    try ztls.io.writeAll(testing.io, stream, app);
                    hs.completeWrite();
                }
            },
            .application_data => |data| {
                if (!mem.eql(u8, data, "pong-ku")) return error.UnexpectedPong;
                got_pong = true;
            },
            .write => |w| {
                try ztls.io.writeAll(testing.io, stream, w);
                hs.completeWrite();
            },
            .closed => return,
            .new_session_ticket => {},
            .none => {},
        };
    }
    try testing.expect(saw_key_update);
    try testing.expect(got_pong);
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
    defer stream.close(testing.io);
    try clientInterop(stream, null);
}

fn runClientGroup(
    arena: Allocator,
    cert_path: []const u8,
    key_path: []const u8,
    group: InteropGroup,
    port: u16,
) !void {
    var server = try startServerWithGroup(arena, cert_path, key_path, group, port);
    defer killChild(&server);
    const stream = try connectWithRetry(port);
    defer stream.close(testing.io);
    try clientInterop(stream, group.ztls_group);
}

fn runResumptionInterop(
    arena: Allocator,
    cert_path: []const u8,
    key_path: []const u8,
    port: u16,
) !void {
    var server = try startServer(arena, cert_path, key_path, "TLS_AES_128_GCM_SHA256", port);
    defer killChild(&server);

    // Connection 1: full handshake, capture the NewSessionTicket.
    const stream1 = try connectWithRetry(port);
    var ticket: ztls.ClientHandshake.SessionTicket = try clientInteropCaptureTicket(stream1);
    defer ticket.secureZero();
    stream1.close(testing.io);

    // Connection 2: offer the ticket and resume.
    const stream2 = try connectWithRetry(port);
    defer stream2.close(testing.io);
    try clientInteropResume(stream2, &ticket);
}

fn runEarlyDataInterop(
    arena: Allocator,
    cert_path: []const u8,
    key_path: []const u8,
    port: u16,
) !void {
    // Start s_server with -early_data to accept 0-RTT.
    const port_str = try std.fmt.allocPrint(arena, "{d}", .{port});
    const argv = &.{
        "openssl",                "s_server",
        "-tls1_3",                "-ciphersuites",
        "TLS_AES_128_GCM_SHA256", "-key",
        key_path,                 "-cert",
        cert_path,                "-port",
        port_str,                 "-www",
        "-alpn",                  alpn_protocol,
        "-early_data",            "-max_early_data",
        "16384",                  "-no_anti_replay",
    };
    var server = try std.process.spawn(testing.io, .{
        .argv = argv,
        .stdout = .ignore,
        .stderr = .ignore,
    });
    defer killChild(&server);

    // Connection 1: full handshake, capture the NST (with early_data).
    const stream1 = try connectWithRetry(port);
    var ticket: ztls.ClientHandshake.SessionTicket = try clientInteropCaptureTicket(stream1);
    defer ticket.secureZero();
    stream1.close(testing.io);

    if (ticket.max_early_data_size == null) return error.NoEarlyDataInTicket;

    // Connection 2: offer early_data + send 0-RTT data, then resume.
    const stream2 = try connectWithRetry(port);
    defer stream2.close(testing.io);
    try clientEarlyDataInterop(stream2, &ticket);
}

fn genCert(cert_path: []const u8, key_path: []const u8) !void {
    const argv = &.{
        "openssl",                 "req",     "-x509",
        "-newkey",                 "ec",      "-pkeyopt",
        "ec_paramgen_curve:P-256", "-keyout", key_path,
        "-out",                    cert_path, "-days",
        "1",                       "-nodes",  "-subj",
        "/CN=localhost",           "-addext", "subjectAltName=DNS:localhost",
    };
    var child = try std.process.spawn(testing.io, .{
        .argv = argv,
        .stdout = .ignore,
        .stderr = .ignore,
    });
    const term = try waitChild(&child);
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
    return std.process.spawn(testing.io, .{
        .argv = argv,
        .stdout = .ignore,
        .stderr = .ignore,
    });
}

fn startServerWithGroup(
    arena: Allocator,
    cert_path: []const u8,
    key_path: []const u8,
    group: InteropGroup,
    port: u16,
) !Child {
    const port_str = try std.fmt.allocPrint(arena, "{d}", .{port});
    const argv = &.{
        "openssl",                "s_server",
        "-tls1_3",                "-ciphersuites",
        "TLS_AES_128_GCM_SHA256", "-groups",
        group.openssl_name,       "-key",
        key_path,                 "-cert",
        cert_path,                "-port",
        port_str,                 "-www",
        "-alpn",                  alpn_protocol,
        "-quiet",
    };
    return std.process.spawn(testing.io, .{
        .argv = argv,
        .stdout = .ignore,
        .stderr = .ignore,
    });
}

fn clientInterop(stream: Stream, group: ?ztls.kex.NamedGroup) !void {
    const kp: ztls.x25519.KeyPair = .generate();
    var random: ztls.Random = .empty;
    entropy.fill(&random.data);

    var keypairs: ztls.ClientHandshake.KeyPairs = try .init(kp);
    if (group == .secp384r1 or group == .secp384r1_mlkem1024)
        keypairs.p384 = try .generate();
    const hybrid_group = if (group) |selected|
        if (selected.hybridSpec() != null) selected else null
    else
        null;
    const groups = [_]ztls.kex.NamedGroup{hybrid_group orelse .x25519_mlkem768};
    var hs: ztls.ClientHandshake = .init(.{
        .keypairs = keypairs,
        .host_name = "localhost",
        .now_sec = 0,
        .random = random,
        .insecure_no_chain_anchor = true,
        .alpn_protocols = &.{alpn_protocol},
        .hybrid = if (hybrid_group) |selected| .{
            .supported_groups = &groups,
            .initial_key_share = selected,
        } else .{},
    });
    defer hs.deinit();

    var out: [4096]u8 = undefined;
    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);

    try ztls.io.writeAll(testing.io, stream, try hs.start(&out));
    hs.completeWrite();

    while (!hs.isConnected()) {
        const n = try ztls.io.fill(testing.io, stream, &rb);
        if (n == 0) return error.ServerClosed;
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out)) {
            .write => |w| {
                try ztls.io.writeAll(testing.io, stream, w);
                hs.completeWrite();
            },
            .key_update => |ku| {
                if (ku.response) |w| {
                    try ztls.io.writeAll(testing.io, stream, w);
                    hs.completeWrite();
                }
            },
            .application_data,
            .closed,
            .new_session_ticket,
            => return error.UnexpectedDuringHandshake,
            .none => {},
        };
    }
    try testing.expectEqualStrings(alpn_protocol, hs.selectedAlpnProtocol().?);

    const request = try hs.sendApplicationData("GET / HTTP/1.0\r\n\r\n", &out);
    try ztls.io.writeAll(testing.io, stream, request);
    hs.completeWrite();

    while (true) {
        const n = try ztls.io.fill(testing.io, stream, &rb);
        if (n == 0) break;
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out)) {
            .application_data => |data| if (mem.startsWith(u8, data, "HTTP/1.0 200")) return,
            .write => |w| {
                try ztls.io.writeAll(testing.io, stream, w);
                hs.completeWrite();
            },
            .key_update => |ku| {
                if (ku.response) |w| {
                    try ztls.io.writeAll(testing.io, stream, w);
                    hs.completeWrite();
                }
            },
            .new_session_ticket => {},
            .none => {},
            .closed => return error.ServerClosedBeforeResponse,
        };
    }
    return error.NoHttpResponse;
}

/// Connection 1 of PSK resumption: complete a full handshake, capture the
/// NewSessionTicket the server issues post-handshake, derive a SessionTicket,
/// and exchange a request/response so the connection closes cleanly.
fn clientInteropCaptureTicket(stream: Stream) !ztls.ClientHandshake.SessionTicket {
    const kp: ztls.x25519.KeyPair = .generate();
    var random: ztls.Random = .empty;
    entropy.fill(&random.data);

    var hs: ztls.ClientHandshake = .init(.{
        .keypairs = try .init(kp),
        .host_name = "localhost",
        .now_sec = 0,
        .random = random,
        .insecure_no_chain_anchor = true,
        .alpn_protocols = &.{alpn_protocol},
    });
    defer hs.deinit();

    var out: [4096]u8 = undefined;
    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);

    try ztls.io.writeAll(testing.io, stream, try hs.start(&out));
    hs.completeWrite();

    while (!hs.isConnected()) {
        const n = try ztls.io.fill(testing.io, stream, &rb);
        if (n == 0) return error.ServerClosed;
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out)) {
            .write => |w| {
                try ztls.io.writeAll(testing.io, stream, w);
                hs.completeWrite();
            },
            .key_update => |ku| {
                if (ku.response) |w| {
                    try ztls.io.writeAll(testing.io, stream, w);
                    hs.completeWrite();
                }
            },
            .application_data,
            .closed,
            .new_session_ticket,
            => return error.UnexpectedDuringHandshake,
            .none => {},
        };
    }

    // Read post-handshake records until a NewSessionTicket arrives. The server
    // may send the NST immediately or after the request; send the GET and read
    // until both the NST and the response are seen.
    const request = try hs.sendApplicationData("GET / HTTP/1.0\r\n\r\n", &out);
    try ztls.io.writeAll(testing.io, stream, request);
    hs.completeWrite();

    var ticket: ?ztls.ClientHandshake.SessionTicket = null;
    var got_response = false;
    while (true) {
        const n = try ztls.io.fill(testing.io, stream, &rb);
        if (n == 0) break;
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out)) {
            .new_session_ticket => |nst| {
                ticket = try hs.deriveSessionTicket(nst);
            },
            .application_data => |data| if (mem.startsWith(u8, data, "HTTP/1.0 200")) {
                got_response = true;
            },
            .write => |w| {
                try ztls.io.writeAll(testing.io, stream, w);
                hs.completeWrite();
            },
            .key_update => |ku| {
                if (ku.response) |w| {
                    try ztls.io.writeAll(testing.io, stream, w);
                    hs.completeWrite();
                }
            },
            .closed => break,
            .none => {},
        };
        if (ticket != null and got_response) break;
    }
    if (ticket == null) return error.NoSessionTicket;
    return ticket.?;
}

/// Connection 2 of PSK resumption: offer the captured ticket and complete the
/// resumed handshake, then exchange application data.
fn clientInteropResume(stream: Stream, ticket: *const ztls.ClientHandshake.SessionTicket) !void {
    const kp: ztls.x25519.KeyPair = .generate();
    var random: ztls.Random = .empty;
    entropy.fill(&random.data);

    var hs: ztls.ClientHandshake = .init(.{
        .keypairs = try .init(kp),
        .host_name = "localhost",
        .now_sec = 0,
        .random = random,
        .insecure_no_chain_anchor = true,
        .alpn_protocols = &.{alpn_protocol},
    });
    defer hs.deinit();

    var out: [4096]u8 = undefined;
    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);

    try ztls.io.writeAll(testing.io, stream, try hs.startWithPsk(ticket, &out, false));
    hs.completeWrite();

    while (!hs.isConnected()) {
        const n = try ztls.io.fill(testing.io, stream, &rb);
        if (n == 0) return error.ServerClosed;
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out)) {
            .write => |w| {
                try ztls.io.writeAll(testing.io, stream, w);
                hs.completeWrite();
            },
            .key_update => |ku| {
                if (ku.response) |w| {
                    try ztls.io.writeAll(testing.io, stream, w);
                    hs.completeWrite();
                }
            },
            .application_data,
            .closed,
            .new_session_ticket,
            => return error.UnexpectedDuringHandshake,
            .none => {},
        };
    }

    const request = try hs.sendApplicationData("GET / HTTP/1.0\r\n\r\n", &out);
    try ztls.io.writeAll(testing.io, stream, request);
    hs.completeWrite();

    while (true) {
        const n = try ztls.io.fill(testing.io, stream, &rb);
        if (n == 0) break;
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out)) {
            .application_data => |data| if (mem.startsWith(u8, data, "HTTP/1.0 200")) return,
            .write => |w| {
                try ztls.io.writeAll(testing.io, stream, w);
                hs.completeWrite();
            },
            .key_update => |ku| {
                if (ku.response) |w| {
                    try ztls.io.writeAll(testing.io, stream, w);
                    hs.completeWrite();
                }
            },
            .new_session_ticket => {},
            .none => {},
            .closed => return error.ServerClosedBeforeResponse,
        };
    }
    return error.NoHttpResponse;
}

/// Connection 2 of 0-RTT: offer early_data + send 0-RTT data, then complete
/// the resumed handshake and exchange application data.
fn clientEarlyDataInterop(
    stream: Stream,
    ticket: *const ztls.ClientHandshake.SessionTicket,
) !void {
    const kp: ztls.x25519.KeyPair = .generate();
    var random: ztls.Random = .empty;
    entropy.fill(&random.data);

    var hs: ztls.ClientHandshake = .init(.{
        .keypairs = try .init(kp),
        .host_name = "localhost",
        .now_sec = 0,
        .random = random,
        .insecure_no_chain_anchor = true,
        .alpn_protocols = &.{alpn_protocol},
    });
    defer hs.deinit();

    var out: [4096]u8 = undefined;
    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);

    // Send the PSK ClientHello with early_data.
    try ztls.io.writeAll(testing.io, stream, try hs.startWithPsk(ticket, &out, true));
    hs.completeWrite();

    // Send 0-RTT data immediately (before the server responds).
    const early = try hs.sendEarlyData("GET / HTTP/1.0\r\n\r\n", &out);
    try ztls.io.writeAll(testing.io, stream, early);
    hs.completeWrite();

    // Process the server's response (ServerHello + flight).
    while (!hs.isConnected()) {
        const n = try ztls.io.fill(testing.io, stream, &rb);
        if (n == 0) return error.ServerClosed;
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out)) {
            .write => |w| {
                try ztls.io.writeAll(testing.io, stream, w);
                hs.completeWrite();
            },
            .key_update => |ku| {
                if (ku.response) |w| {
                    try ztls.io.writeAll(testing.io, stream, w);
                    hs.completeWrite();
                }
            },
            .application_data,
            .closed,
            .new_session_ticket,
            => return error.UnexpectedDuringHandshake,
            .none => {},
        };
    }

    // Read the server's response (the 0-RTT data was the GET request).
    while (true) {
        const n = try ztls.io.fill(testing.io, stream, &rb);
        if (n == 0) break;
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out)) {
            .application_data => |data| if (mem.startsWith(u8, data, "HTTP/1.0 200")) return,
            .write => |w| {
                try ztls.io.writeAll(testing.io, stream, w);
                hs.completeWrite();
            },
            .key_update => |ku| {
                if (ku.response) |w| {
                    try ztls.io.writeAll(testing.io, stream, w);
                    hs.completeWrite();
                }
            },
            .new_session_ticket => {},
            .none => {},
            .closed => return error.ServerClosedBeforeResponse,
        };
    }
    return error.NoHttpResponse;
}

const ServerArgs = struct {
    port: u16,
    suite: ztls.CipherSuite,
    group: ?ztls.kex.NamedGroup = null,
};

const server_ticket_identity = "ztls-openssl-resumption";

const ServerTicketState = struct {
    psk: [48]u8 = @splat(0),
    psk_len: u8 = 0,
    cipher_suite: ztls.CipherSuite = .aes_128_gcm_sha256,
    did_resume: bool = false,

    fn lookup(context: *anyopaque, identity: []const u8) ?ztls.ServerHandshake.PskEntry {
        const self: *ServerTicketState = @ptrCast(@alignCast(context));
        if (!mem.eql(u8, identity, server_ticket_identity)) return null;
        return .{
            .psk = self.psk[0..self.psk_len],
            .cipher_suite = self.cipher_suite,
        };
    }
};

const ServerTicketPhase = enum {
    none,
    issue,
    reuse,
};

const ServerResumptionArgs = struct {
    port: u16,
    ticket: ServerTicketState = .{},
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

fn runServerResumptionSuite(arena: Allocator, session_path: []const u8, port: u16) !void {
    var args: ServerResumptionArgs = .{ .port = port };
    defer std.crypto.secureZero(u8, &args.ticket.psk);
    const thread = try std.Thread.spawn(.{}, resumptionServerThread, .{&args});

    var first = try startClientSaveSession(arena, session_path, port);
    defer killChild(&first);
    try writeFileAll(first.stdin.?, "GET / HTTP/1.0\r\n\r\n");
    closeFile(first.stdin.?);
    first.stdin = null;
    var stdout_buf: [4096]u8 = undefined;
    const first_n = try readFileAll(first.stdout.?, &stdout_buf);
    const first_term = try waitChild(&first);
    if (!exitedZero(first_term)) return error.OpenSslClientFailed;
    if (!mem.containsAtLeast(u8, stdout_buf[0..first_n], 1, "hello"))
        return error.NoServerResponse;

    var second = try startClientReuseSession(arena, session_path, port);
    defer killChild(&second);
    try writeFileAll(second.stdin.?, "GET / HTTP/1.0\r\n\r\n");
    closeFile(second.stdin.?);
    second.stdin = null;
    const second_n = try readFileAll(second.stdout.?, &stdout_buf);
    const second_term = try waitChild(&second);
    thread.join();

    if (!exitedZero(second_term)) return error.OpenSslClientFailed;
    if (!mem.containsAtLeast(u8, stdout_buf[0..second_n], 1, "hello"))
        return error.NoServerResponse;
    if (!args.ticket.did_resume) return error.OpenSslClientDidNotResume;
}

fn runServerGroup(arena: Allocator, group: InteropGroup, port: u16) !void {
    var args: ServerArgs = .{
        .port = port,
        .suite = .aes_128_gcm_sha256,
        .group = group.ztls_group,
    };
    const thread = try std.Thread.spawn(.{}, serverThread, .{&args});

    var child = try startClientWithGroup(arena, group, port);
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
    return std.process.spawn(testing.io, .{
        .argv = argv,
        .stdin = .pipe,
        .stdout = .pipe,
        .stderr = .ignore,
    });
}

fn startClientSaveSession(
    arena: Allocator,
    session_path: []const u8,
    port: u16,
) !Child {
    const port_str = try std.fmt.allocPrint(arena, "{d}", .{port});
    const connect_to = try std.fmt.allocPrint(arena, "{s}:{s}", .{ host, port_str });
    const argv = &.{
        "openssl",                "s_client",
        "-tls1_3",                "-connect",
        connect_to,               "-ciphersuites",
        "TLS_AES_128_GCM_SHA256", "-alpn",
        alpn_protocol,            "-sess_out",
        session_path,             "-quiet",
    };
    return spawnClient(argv);
}

fn startClientReuseSession(
    arena: Allocator,
    session_path: []const u8,
    port: u16,
) !Child {
    const port_str = try std.fmt.allocPrint(arena, "{d}", .{port});
    const connect_to = try std.fmt.allocPrint(arena, "{s}:{s}", .{ host, port_str });
    const argv = &.{
        "openssl",                "s_client",
        "-tls1_3",                "-connect",
        connect_to,               "-ciphersuites",
        "TLS_AES_128_GCM_SHA256", "-alpn",
        alpn_protocol,            "-sess_in",
        session_path,             "-quiet",
    };
    return spawnClient(argv);
}

fn spawnClient(argv: []const []const u8) !Child {
    return std.process.spawn(testing.io, .{
        .argv = argv,
        .stdin = .pipe,
        .stdout = .pipe,
        .stderr = .ignore,
    });
}

fn startClientWithGroup(arena: Allocator, group: InteropGroup, port: u16) !Child {
    const port_str = try std.fmt.allocPrint(arena, "{d}", .{port});
    const connect_to = try std.fmt.allocPrint(arena, "{s}:{s}", .{ host, port_str });
    const argv = &.{
        "openssl",                "s_client",
        "-tls1_3",                "-connect",
        connect_to,               "-ciphersuites",
        "TLS_AES_128_GCM_SHA256", "-groups",
        group.openssl_name,       "-alpn",
        alpn_protocol,            "-quiet",
    };
    return std.process.spawn(testing.io, .{
        .argv = argv,
        .stdin = .pipe,
        .stdout = .pipe,
        .stderr = .ignore,
    });
}

fn serverThread(args: *const ServerArgs) !void {
    const addr: IpAddress = try .parse(host, args.port);
    var server = try addr.listen(testing.io, .{ .reuse_address = true });
    defer server.deinit(testing.io);
    const stream = try server.accept(testing.io);
    defer stream.close(testing.io);
    try serve(stream, args.suite, args.group, null, .none);
}

fn resumptionServerThread(args: *ServerResumptionArgs) !void {
    const addr: IpAddress = try .parse(host, args.port);
    var server = try addr.listen(testing.io, .{ .reuse_address = true });
    defer server.deinit(testing.io);
    {
        const stream = try server.accept(testing.io);
        defer stream.close(testing.io);
        try serve(stream, .aes_128_gcm_sha256, null, &args.ticket, .issue);
    }
    {
        const stream = try server.accept(testing.io);
        defer stream.close(testing.io);
        try serve(stream, .aes_128_gcm_sha256, null, &args.ticket, .reuse);
    }
}

fn serve(
    stream: Stream,
    suite: ztls.CipherSuite,
    group: ?ztls.kex.NamedGroup,
    ticket_state: ?*ServerTicketState,
    ticket_phase: ServerTicketPhase,
) !void {
    const server_keypair: ztls.x25519.KeyPair = .generate();
    var server_random: ztls.Random = .empty;
    entropy.fill(&server_random.data);

    var keypairs: ztls.ServerHandshake.KeyPairs = try .init(server_keypair);
    if (group == .secp384r1 or group == .secp384r1_mlkem1024)
        keypairs.p384 = try .generate();
    const hybrid_group = if (group) |selected|
        if (selected.hybridSpec() != null) selected else null
    else
        null;
    const groups = [_]ztls.kex.NamedGroup{hybrid_group orelse .x25519_mlkem768};
    var hs: ztls.ServerHandshake = .init(.{
        .keypairs = keypairs,
        .random = server_random,
        .psk_lookup = if (ticket_phase == .reuse) .{
            .context = ticket_state.?,
            .lookup = ServerTicketState.lookup,
        } else null,
        .hybrid_groups = if (hybrid_group != null) &groups else &.{},
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
        const n = try ztls.io.fill(testing.io, stream, &rb);
        if (n == 0) return error.ClientClosed;
        while (try rb.next()) |record| {
            const ev = try hs.handleRecord(record, &out);
            switch (ev) {
                .write => |w| {
                    try ztls.io.writeAll(testing.io, stream, w);
                    hs.completeWrite();
                    if (try hs.sendPreparedServerFlight(&out)) |flight| {
                        try ztls.io.writeAll(testing.io, stream, flight);
                        hs.completeWrite();
                    }
                },
                .key_update => |ku| {
                    if (ku.response) |w| {
                        try ztls.io.writeAll(testing.io, stream, w);
                        hs.completeWrite();
                    }
                },
                .none => {},
                .application_data => return error.UnexpectedDuringHandshake,
                .closed => return error.UnexpectedDuringHandshake,
            }
            if (hs.isConnected()) break;
        }
    }

    if (ticket_state) |state| switch (ticket_phase) {
        .none => {},
        .issue => {
            var ticket_psk = try hs.deriveTicketPsk();
            defer ticket_psk.secureZero();
            @memcpy(state.psk[0..ticket_psk.psk.len], ticket_psk.psk.constSlice());
            state.psk_len = ticket_psk.psk.len;
            state.cipher_suite = ticket_psk.cipher_suite;
            var age_add_bytes: [4]u8 = undefined;
            entropy.fill(&age_add_bytes);
            const ticket_record = try hs.sendNewSessionTicket(
                &ticket_psk,
                .{
                    .ticket_lifetime = 3600,
                    .ticket_age_add = mem.readInt(u32, &age_add_bytes, .big),
                    .ticket = server_ticket_identity,
                },
                &out,
            );
            try ztls.io.writeAll(testing.io, stream, ticket_record);
            hs.completeWrite();
        },
        .reuse => state.did_resume = hs.isResumed(),
    };
    while (true) {
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out)) {
            .application_data => |data| return sendResponse(stream, &hs, data, &out),
            .write => |w| {
                try ztls.io.writeAll(testing.io, stream, w);
                hs.completeWrite();
            },
            .key_update => |ku| {
                if (ku.response) |w| {
                    try ztls.io.writeAll(testing.io, stream, w);
                    hs.completeWrite();
                }
            },
            .closed => return,
            .none => {},
        };
        const n = try ztls.io.fill(testing.io, stream, &rb);
        if (n == 0) return error.ClientClosed;
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
    try ztls.io.writeAll(testing.io, stream, rec);
    hs.completeWrite();
    const close = try hs.sendAlert(.close_notify, out);
    try ztls.io.writeAll(testing.io, stream, close);
    hs.completeWrite();
}

// RFC 8446 §4.7.2 — ztls server requiring client auth, exercised against an
// `openssl s_client -cert -key` peer. The server uses
// insecure_no_client_chain_anchor so the self-signed openssl client cert is
// accepted without a trust bundle; the CertificateVerify still proves key
// possession. Reuses one cipher suite (AES-128-GCM) for the smoke.
fn runServerClientAuthSuite(
    arena: Allocator,
    client_cert_path: []const u8,
    client_key_path: []const u8,
    port: u16,
) !void {
    var args: ServerAuthArgs = .{ .port = port };
    const thread = try std.Thread.spawn(.{}, serverClientAuthThread, .{&args});

    var child = try startClientWithCert(arena, client_cert_path, client_key_path, port);
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

const ServerAuthArgs = struct {
    port: u16,
};

fn serverClientAuthThread(args: *const ServerAuthArgs) !void {
    const addr: IpAddress = try .parse(host, args.port);
    var server = try addr.listen(testing.io, .{ .reuse_address = true });
    defer server.deinit(testing.io);
    const stream = try server.accept(testing.io);
    defer stream.close(testing.io);
    try serveClientAuth(stream);
}

fn serveClientAuth(stream: Stream) !void {
    const server_keypair: ztls.x25519.KeyPair = .generate();
    var server_random: ztls.Random = .empty;
    entropy.fill(&server_random.data);

    var hs: ztls.ServerHandshake = .init(.{
        .keypairs = try .init(server_keypair),
        .random = server_random,
        .client_auth = .required,
        .insecure_no_client_chain_anchor = true,
    });
    defer hs.deinit();
    hs.supportAlpn(&.{alpn_protocol});
    const supported = [_]ztls.CipherSuite{.aes_128_gcm_sha256};
    hs.supportSuites(&supported);

    var signer = try ztls.signature.PrivateKey.fromP256Scalar(server_scalar[0..32]);
    defer signer.deinit();
    hs.setCredentials(&.{server_cert_der}, signer.signer());

    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);
    var out: [4096]u8 = undefined;
    errdefer |err| sendBestEffortAlert(&hs, stream, err, &out);

    while (!hs.isConnected()) {
        const n = try ztls.io.fill(testing.io, stream, &rb);
        if (n == 0) return error.ClientClosed;
        while (try rb.next()) |record| {
            const ev = try hs.handleRecord(record, &out);
            switch (ev) {
                .write => |w| {
                    try ztls.io.writeAll(testing.io, stream, w);
                    hs.completeWrite();
                    if (try hs.sendPreparedServerFlight(&out)) |flight| {
                        try ztls.io.writeAll(testing.io, stream, flight);
                        hs.completeWrite();
                    }
                },
                .key_update => |ku| {
                    if (ku.response) |w| {
                        try ztls.io.writeAll(testing.io, stream, w);
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
        const n = try ztls.io.fill(testing.io, stream, &rb);
        if (n == 0) return error.ClientClosed;
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out)) {
            .application_data => |data| return sendResponse(stream, &hs, data, &out),
            .write => |w| {
                try ztls.io.writeAll(testing.io, stream, w);
                hs.completeWrite();
            },
            .key_update => |ku| {
                if (ku.response) |w| {
                    try ztls.io.writeAll(testing.io, stream, w);
                    hs.completeWrite();
                }
            },
            .closed => return,
            .none => {},
        };
    }
}

fn startClientWithCert(
    arena: Allocator,
    cert_path: []const u8,
    key_path: []const u8,
    port: u16,
) !Child {
    const port_str = try std.fmt.allocPrint(arena, "{d}", .{port});
    const connect_to = try std.fmt.allocPrint(arena, "{s}:{s}", .{ host, port_str });
    const argv = &.{
        "openssl",                "s_client",
        "-tls1_3",                "-connect",
        connect_to,               "-ciphersuites",
        "TLS_AES_128_GCM_SHA256", "-alpn",
        alpn_protocol,            "-cert",
        cert_path,                "-key",
        key_path,                 "-quiet",
    };
    return std.process.spawn(testing.io, .{
        .argv = argv,
        .stdin = .pipe,
        .stdout = .pipe,
        .stderr = .ignore,
    });
}

// RFC 8446 §4.7.2 — ztls client presenting credentials to `openssl s_server
// -Verify -CAfile`. The client reuses the self-signed ECDSA fixture as its
// client certificate; the CAfile is the fixture cert PEM (self-signed = its
// own CA). The client skips server chain validation (insecure_no_chain_anchor)
// since the openssl s_server uses a generated self-signed cert.
fn runClientAuthClientSuite(
    arena: Allocator,
    server_cert_path: []const u8,
    server_key_path: []const u8,
    client_ca_path: []const u8,
    port: u16,
) !void {
    var child = try startServerVerify(
        arena,
        server_cert_path,
        server_key_path,
        client_ca_path,
        port,
    );
    defer killChild(&child);
    // Give s_server a moment to bind.
    const stream = try connectWithRetry(port);
    defer stream.close(testing.io);
    try clientInteropWithCreds(stream);
}

fn startServerVerify(
    arena: Allocator,
    cert_path: []const u8,
    key_path: []const u8,
    ca_path: []const u8,
    port: u16,
) !Child {
    const port_str = try std.fmt.allocPrint(arena, "{d}", .{port});
    const argv = &.{
        "openssl",                "s_server",
        "-tls1_3",                "-ciphersuites",
        "TLS_AES_128_GCM_SHA256", "-key",
        key_path,                 "-cert",
        cert_path,                "-port",
        port_str,                 "-www",
        "-alpn",                  alpn_protocol,
        "-Verify",                "1",
        "-CAfile",                ca_path,
        "-quiet",
    };
    return std.process.spawn(testing.io, .{
        .argv = argv,
        .stdout = .ignore,
        .stderr = .ignore,
    });
}

fn clientInteropWithCreds(stream: Stream) !void {
    const kp: ztls.x25519.KeyPair = .generate();
    var random: ztls.Random = .empty;
    entropy.fill(&random.data);

    var hs: ztls.ClientHandshake = .init(.{
        .keypairs = try .init(kp),
        .host_name = "localhost",
        .now_sec = 0,
        .random = random,
        .insecure_no_chain_anchor = true,
        .alpn_protocols = &.{alpn_protocol},
    });
    defer hs.deinit();
    // Present the self-signed ECDSA fixture as the client certificate.
    var client_signer = try ztls.signature.PrivateKey.fromP256Scalar(server_scalar[0..32]);
    defer client_signer.deinit();
    hs.setCredentials(&.{server_cert_der}, client_signer.signer());

    var out: [4096]u8 = undefined;
    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);

    try ztls.io.writeAll(testing.io, stream, try hs.start(&out));
    hs.completeWrite();

    while (!hs.isConnected()) {
        const n = try ztls.io.fill(testing.io, stream, &rb);
        if (n == 0) return error.ServerClosed;
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out)) {
            .write => |w| {
                try ztls.io.writeAll(testing.io, stream, w);
                hs.completeWrite();
            },
            .key_update => |ku| {
                if (ku.response) |w| {
                    try ztls.io.writeAll(testing.io, stream, w);
                    hs.completeWrite();
                }
            },
            .application_data,
            .closed,
            .new_session_ticket,
            => return error.UnexpectedDuringHandshake,
            .none => {},
        };
    }
    try testing.expectEqualStrings(alpn_protocol, hs.selectedAlpnProtocol().?);

    const request = try hs.sendApplicationData("GET / HTTP/1.0\r\n\r\n", &out);
    try ztls.io.writeAll(testing.io, stream, request);
    hs.completeWrite();

    while (true) {
        const n = try ztls.io.fill(testing.io, stream, &rb);
        if (n == 0) break;
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out)) {
            .application_data => |data| if (mem.startsWith(u8, data, "HTTP/1.0 200")) return,
            .write => |w| {
                try ztls.io.writeAll(testing.io, stream, w);
                hs.completeWrite();
            },
            .key_update => |ku| {
                if (ku.response) |w| {
                    try ztls.io.writeAll(testing.io, stream, w);
                    hs.completeWrite();
                }
            },
            .new_session_ticket => {},
            .none => {},
            .closed => return error.ServerClosedBeforeResponse,
        };
    }
    return error.NoHttpResponse;
}

/// Write the self-signed ECDSA fixture certificate (fixtures.server_ecdsa_cert_der)
/// as a PEM file so `openssl s_server -Verify -CAfile` trusts the ztls client's
/// client certificate (the fixture is self-signed, so it is its own CA).
fn writeFixtureCertPem(arena: Allocator, pem_path: []const u8) !void {
    // PEM is base64 of the DER wrapped in BEGIN/END CERTIFICATE lines.
    const der = server_cert_der;
    const enc = std.base64.standard.Encoder;
    const b64_len = enc.calcSize(der.len);
    var b64_buf: [4096]u8 = undefined;
    if (b64_len > b64_buf.len) return error.BufferTooShort;
    const encoded = enc.encode(b64_buf[0..b64_len], der);

    const pem = try std.fmt.allocPrint(
        arena,
        "-----BEGIN CERTIFICATE-----\n{s}\n-----END CERTIFICATE-----\n",
        .{encoded},
    );
    try Io.Dir.cwd().writeFile(testing.io, .{ .sub_path = pem_path, .data = pem });
}

fn sendBestEffortAlert(
    hs: *ztls.ServerHandshake,
    stream: Stream,
    err: anyerror,
    out: []u8,
) void {
    const description = ztls.alert.alertForError(err);
    const alert_record = hs.sendAlert(description, out) catch return;
    ztls.io.writeAll(testing.io, stream, alert_record) catch return;
}

fn connectWithRetry(port: u16) !Stream {
    const addr: IpAddress = try .parse("127.0.0.1", port);
    for (0..100) |_| {
        return addr.connect(testing.io, .{ .mode = .stream }) catch {
            sleep20ms();
            continue;
        };
    }
    return error.ServerNeverCameUp;
}

fn tmpDirPath(arena: Allocator, tmp: anytype) ![]const u8 {
    var path_buf: [Io.Dir.max_path_bytes]u8 = undefined;
    const len = try tmp.dir.realPath(testing.io, &path_buf);
    return arena.dupe(u8, path_buf[0..len]);
}

fn killChild(child: *Child) void {
    child.kill(testing.io);
}

fn waitChild(child: *Child) !Child.Term {
    return child.wait(testing.io);
}

fn exitedZero(term: Child.Term) bool {
    return term == .exited and term.exited == 0;
}

fn writeFileAll(file: anytype, bytes: []const u8) !void {
    var writer_buf: [1024]u8 = undefined;
    var writer = file.writer(testing.io, &writer_buf);
    try writer.interface.writeAll(bytes);
    try writer.interface.flush();
}

fn readFileAll(file: anytype, buf: []u8) !usize {
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
    file.close(testing.io);
}

fn sleep20ms() void {
    testing.io.sleep(.fromNanoseconds(20 * std.time.ns_per_ms), .awake) catch return;
}
