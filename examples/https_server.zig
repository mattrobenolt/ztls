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
const net = @import("net_compat.zig");
const Address = net.Address;

const ztls = @import("ztls");

const shared_fixtures = @import("test_fixtures/shared_fixtures.zig");

const host = "127.0.0.1";
const port: u16 = 8443;

// Self-signed ECDSA P-256 test fixture. In a real deployment, load a
// proper certificate chain and keep the signing key offline.
const cert_der: []const u8 = &shared_fixtures.server_ecdsa_cert_der;
const scalar: []const u8 = &shared_fixtures.server_ecdsa_scalar;

const response = "HTTP/1.0 200 OK\r\nContent-Length: 18\r\n\r\nHello from ztls!";

pub fn main() !void {
    const addr: Address = try net.parseIp(host, port);
    var server = try net.listen(addr, .{ .reuse_address = true });
    defer net.deinitServer(&server);
    print("[https]  server listening on https://{s}:{d}/\n", .{ host, port });

    // Wait up to 5 seconds for a client connection so the build step
    // does not hang forever when run without a client.
    var pollfd = [1]std.posix.pollfd{.{
        .fd = net.serverFd(server),
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

    const stream = try net.accept(&server);
    defer net.close(stream);
    print("[https]  client connected\n", .{});

    const server_keypair: ztls.x25519.KeyPair = .generate();
    var random: ztls.Random = undefined;
    net.fillRandom(&random.data);
    var hs: ztls.ServerHandshake = .init(.{
        .keypairs = .init(server_keypair),
        .random = random,
        .alpn_protocols = &.{"http/1.1"},
    });
    defer hs.deinit();

    var signer = try ztls.signature.PrivateKey.fromP256Scalar(scalar[0..32]);
    defer signer.deinit();
    hs.setCredentials(&.{cert_der}, signer.signer());

    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);
    var out: ztls.ServerHandshake.OutBuffer = .empty;
    var flight: ztls.ServerHandshake.FlightBuffer = .empty;

    while (!hs.isConnected()) {
        const n = try net.read(stream, rb.writable());
        if (n == 0) return error.ClientClosed;
        rb.advance(n);
        while (try rb.next()) |record| {
            const ev = try hs.handleRecord(record, &out.buffer);
            switch (ev) {
                .write => |w| {
                    try net.writeAll(stream, w);
                    hs.completeWrite();
                    if (try hs.sendServerFlightBuffered(&flight)) |flight_bytes| {
                        try net.writeAll(stream, flight_bytes);
                        hs.completeWrite();
                    }
                },
                .none => {},
                .application_data, .closed, .key_update => return error.UnexpectedDuringHandshake,
            }
        }
    }
    print("[https]  handshake complete (ALPN={s})\n", .{hs.selectedAlpnProtocol().?});

    // Handle one request, send response, close gracefully.
    while (true) {
        const n = try net.read(stream, rb.writable());
        if (n == 0) return error.ClientClosed;
        rb.advance(n);
        while (try rb.next()) |record| {
            const ev = try hs.handleRecord(record, &out.buffer);
            switch (ev) {
                .application_data => |data| {
                    if (std.mem.startsWith(u8, data, "GET ")) {
                        const rec = try hs.sendApplicationData(response, &out.buffer);
                        try net.writeAll(stream, rec);
                        hs.completeWrite();
                    }
                    const close = try hs.sendAlert(.close_notify, &out.buffer);
                    try net.writeAll(stream, close);
                    hs.completeWrite();
                    return;
                },
                .write => |w| {
                    try net.writeAll(stream, w);
                    hs.completeWrite();
                },
                .closed => return,
                .key_update => |ku| {
                    if (ku.response) |w| {
                        try net.writeAll(stream, w);
                        hs.completeWrite();
                    }
                },
                .none => {},
            }
        }
    }
}
