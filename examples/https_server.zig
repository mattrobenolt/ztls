//! Minimal TLS 1.3 HTTPS server using `std.net` and `ServerHandshake`.
//!
//! Binds to 127.0.0.1:8443, accepts one connection, completes a server-
//! authenticated handshake, and responds to a single HTTP/1.0 GET request.
//!
//! Run manually:
//!     zig build example-https_server
//!
//! Or from another terminal:
//!     zig build example-https_client
//!
//! The server exits successfully only after handling one request. A 5-second
//! idle timeout exits non-zero so CI cannot mistake "no client" for TLS proof.
const std = @import("std");
const print = std.debug.print;

const ztls = @import("ztls");

const host = "127.0.0.1";
const port: u16 = 8443;

// Self-signed ECDSA P-256 test fixture. In a real deployment, load a
// proper certificate chain and keep the signing key offline.
const shared_fixtures = @import("test_fixtures/shared_fixtures.zig");
const cert_der: []const u8 = &shared_fixtures.server_ecdsa_cert_der;
const scalar: []const u8 = &shared_fixtures.server_ecdsa_scalar;

const response = "HTTP/1.0 200 OK\r\nContent-Length: 18\r\n\r\nHello from ztls!";

pub fn main() !void {
    const addr = try std.net.Address.parseIp(host, port);
    var server = try addr.listen(.{ .reuse_address = true });
    defer server.deinit();
    print("[https]  server listening on https://{s}:{d}/\n", .{ host, port });

    // Wait up to 5 seconds for a client connection so the build step
    // does not hang forever when run without a client.
    var pollfd = [1]std.posix.pollfd{.{
        .fd = server.stream.handle,
        .events = std.posix.POLL.IN,
        .revents = 0,
    }};
    const ready = std.posix.poll(&pollfd, 5000) catch |err| {
        print("[https]  poll error: {}\n", .{err});
        return err;
    };
    if (ready == 0) {
        print("[https]  no client connected within 5s; exiting.\n", .{});
        print("         Run `zig build example-https_client` in another terminal.\n", .{});
        return error.NoClientConnected;
    }

    const conn = try server.accept();
    defer conn.stream.close();
    print("[https]  client connected\n", .{});

    const server_keypair: ztls.x25519.KeyPair = .generate();
    var hs: ztls.ServerHandshake = .init(server_keypair);
    defer hs.deinit();
    hs.supportAlpn(&.{"http/1.1"});

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
    print("[https]  handshake complete (ALPN={s})\n", .{hs.selectedAlpnProtocol().?});

    // Handle one request, send response, close gracefully.
    while (true) {
        const n = try conn.stream.read(rb.writable());
        if (n == 0) return error.ClientClosed;
        rb.advance(n);
        while (try rb.next()) |record| {
            const ev = try hs.handleRecord(record, random, &out.buffer);
            switch (ev) {
                .application_data => |data| {
                    if (std.mem.startsWith(u8, data, "GET ")) {
                        const rec = try hs.sendApplicationData(response, &out.buffer);
                        try conn.stream.writeAll(rec);
                        hs.completeWrite();
                    }
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
