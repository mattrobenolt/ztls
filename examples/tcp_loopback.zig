//! TLS 1.3 client/server handshake over real TCP loopback.
//!
//! Both engines run in the same process, connected by a real `std.net.Stream`
//! over 127.0.0.1. This is the smallest end-to-end proof that ztls's Sans-I/O
//! API composes with actual sockets: no OpenSSL, no external processes.
const std = @import("std");
const print = std.debug.print;

const ztls = @import("ztls");

// Test fixtures: ECDSA P-256 server certificate and signing scalar.
const shared_fixtures = @import("test_fixtures/shared_fixtures.zig");
const cert_der: []const u8 = &shared_fixtures.server_ecdsa_cert_der;
const scalar: []const u8 = &shared_fixtures.server_ecdsa_scalar;

const host = "127.0.0.1";
const server_name = "ztls.server.test";
const port: u16 = 0; // OS-assigned ephemeral port

const ServerCtx = struct {
    listener: *std.net.Server,
    keypair: ztls.x25519.KeyPair,
};

pub fn main() !void {
    const client_keypair: ztls.x25519.KeyPair = .generate();
    const server_keypair: ztls.x25519.KeyPair = .generate();

    // ── Start TCP server on an ephemeral port ────────────────
    const addr = try std.net.Address.parseIp(host, port);
    var server_listener = try addr.listen(.{ .reuse_address = true });
    defer server_listener.deinit();
    const actual_port = server_listener.listen_address.in.getPort();
    print("[tcp]    server listening on {s}:{d}\n", .{ host, actual_port });

    // ── Spawn server thread (blocks in accept) ───────────────
    var sctx: ServerCtx = .{ .listener = &server_listener, .keypair = server_keypair };
    const server_thread = try std.Thread.spawn(.{}, serverRun, .{&sctx});

    // ── Run client ─────────────────────────
    try clientRun(client_keypair, actual_port);

    server_thread.join();
    print("\n=== TCP loopback OK ===\n", .{});
}

fn serverRun(ctx: *ServerCtx) !void {
    const conn = try ctx.listener.accept();
    defer conn.stream.close();
    print("[server] accepted connection\n", .{});

    var hs: ztls.ServerHandshake = .init(ctx.keypair);
    defer hs.deinit();
    hs.supportAlpn(&.{"h2"});

    var signer = try ztls.signature.PrivateKey.fromP256Scalar(scalar[0..32]);
    defer signer.deinit();
    hs.setCredentials(&.{cert_der}, signer.signer());

    var random: ztls.client_hello.Random = undefined;
    std.crypto.random.bytes(&random.data);

    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);
    var out: ztls.ServerHandshake.OutBuffer = .empty;
    var flight: ztls.ServerHandshake.FlightBuffer = .empty;

    while (!hs.isConnected()) {
        const n = try conn.stream.read(rb.writable());
        if (n == 0) return error.ClientClosed;
        rb.advance(n);
        while (try rb.next()) |record| {
            const ev = try hs.handleRecord(record, random, &out.buffer);
            switch (ev) {
                .write => |w| {
                    try conn.stream.writeAll(w);
                    hs.completeWrite();
                    if (try hs.sendServerFlightBuffered(&flight)) |flight_bytes| {
                        try conn.stream.writeAll(flight_bytes);
                        hs.completeWrite();
                    }
                },
                .none => {},
                .application_data, .closed => return error.UnexpectedDuringHandshake,
            }
        }
    }
    print("[server] handshake complete (ALPN={s})\n", .{hs.selectedAlpnProtocol().?});

    // Read one application-data request and respond.
    while (true) {
        const n = try conn.stream.read(rb.writable());
        if (n == 0) return error.ClientClosed;
        rb.advance(n);
        while (try rb.next()) |record| {
            const ev = try hs.handleRecord(record, random, &out.buffer);
            switch (ev) {
                .application_data => |data| {
                    if (!std.mem.startsWith(u8, data, "GET ")) return error.UnexpectedRequest;
                    const response = "HTTP/1.0 200 OK\r\nContent-Length: 5\r\n\r\nhello";
                    const rec = try hs.sendApplicationData(response, &out.buffer);
                    try conn.stream.writeAll(rec);
                    hs.completeWrite();
                    const close = try hs.sendAlert(.close_notify, &out.buffer);
                    try conn.stream.writeAll(close);
                    hs.completeWrite();
                    return;
                },
                .write => |w| {
                    try conn.stream.writeAll(w);
                    hs.completeWrite();
                },
                .closed => return,
                .none => {},
            }
        }
    }
}

fn clientRun(client_keypair: ztls.x25519.KeyPair, actual_port: u16) !void {
    const addr = try std.net.Address.parseIp(host, actual_port);
    const stream = try std.net.tcpConnectToAddress(addr);
    defer stream.close();
    print("[client] connected to {s}:{d}\n", .{ host, actual_port });

    var random: ztls.client_hello.Random = undefined;
    std.crypto.random.bytes(&random.data);

    var hs: ztls.ClientHandshake = .init(.{
        .keypair = client_keypair,
        .host_name = server_name,
        .now_sec = std.time.timestamp(),
        .random = random,
        .insecure_no_chain_anchor = true,
        .alpn_protocols = &.{"h2"},
    });
    defer hs.deinit();

    // For a real deployment, load the OS trust store or a known root.
    // Here the server uses a self-signed test fixture, so we skip chain
    // anchoring and rely on hostname + signature verification only.

    var out: ztls.ClientHandshake.OutBuffer = .empty;
    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);

    try stream.writeAll(try hs.start(&out.buffer));
    hs.completeWrite();
    print("[client] ClientHello sent → state={s}\n", .{@tagName(hs.state)});

    while (!hs.isConnected()) {
        const n = try stream.read(rb.writable());
        if (n == 0) return error.ServerClosed;
        rb.advance(n);
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out.buffer)) {
            .write => |w| {
                try stream.writeAll(w);
                hs.completeWrite();
            },
            .application_data, .closed => return error.UnexpectedDuringHandshake,
            .none => {},
        };
    }
    print("[client] handshake complete (ALPN={s})\n", .{hs.selectedAlpnProtocol().?});

    const request = "GET / HTTP/1.0\r\n\r\n";
    try stream.writeAll(try hs.sendApplicationData(request, &out.buffer));
    hs.completeWrite();
    print("[client] sent: {s}", .{request});

    while (true) {
        const n = try stream.read(rb.writable());
        if (n == 0) break;
        rb.advance(n);
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out.buffer)) {
            .application_data => |data| {
                print("[client] received: {s}\n", .{data});
            },
            .write => |w| {
                try stream.writeAll(w);
                hs.completeWrite();
            },
            .closed => return,
            .none => {},
        };
    }
}
