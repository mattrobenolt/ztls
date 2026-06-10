//! In-memory TLS 1.3 client/server handshake.
//!
//! Both engines run in the same process, connected by buffer passing (no TCP,
//! no OpenSSL). This is the simplest end-to-end proof: it exercises the full
//! server-authenticated 1-RTT handshake plus an application-data round trip
//! using only stack buffers and existing test fixtures.
const std = @import("std");
const print = std.debug.print;
const mem = std.mem;
const testing = std.testing;
const assert = std.debug.assert;

const ztls = @import("ztls");

const cert_der = @embedFile("test_fixtures/server-ecdsa/server.der");
const scalar = @embedFile("test_fixtures/server-ecdsa/scalar.bin");

pub fn main() !void {
    // Load the server's signing key from a fixture P-256 scalar.
    var signer: ztls.signature.PrivateKey = try .fromP256Scalar(scalar[0..32]);
    defer signer.deinit();
    const signer_api = signer.signer();

    // Fresh ephemeral X25519 keypairs for client and server.
    const client_keypair: ztls.x25519.KeyPair = .generate();
    const server_keypair: ztls.x25519.KeyPair = .generate();

    // ── Client setup ────────────────────────
    var client: ztls.ClientHandshake = .init(client_keypair);
    client.offerAlpn(&.{"h2"});
    client.policy.host_name = "ztls.server.test";

    // ── Server setup ────────────────────────
    var server: ztls.ServerHandshake = .init(server_keypair);
    server.supportAlpn(&.{"h2"});

    // Caller-owned buffers. The engine never allocates; we provide all storage.
    var client_out: ztls.ClientHandshake.OutBuffer = .empty;
    var server_out: ztls.ServerHandshake.OutBuffer = .empty;
    var flight: ztls.ServerHandshake.FlightBuffer = .empty;

    var random: ztls.client_hello.Random = undefined;
    std.crypto.random.bytes(&random.data);

    // 1. ClientHello — client emits its first flight.
    const ch_record = try client.start(&client_out.buffer, random, "ztls.server.test");
    client.completeWrite();
    print("[client] ClientHello sent → state={s}\n", .{@tagName(client.state)});

    // 2. ServerHello — server consumes ClientHello and emits ServerHello.
    const sh_record = try server.acceptClientHello(ch_record, random, &server_out.buffer);
    server.completeWrite();
    print("[server] ServerHello sent → state={s}\n", .{@tagName(server.state)});

    // 3. Client installs handshake keys from ServerHello.
    try client.processServerHello(sh_record[ztls.frame.header_len..]);
    print("[client] handshake keys installed → state={s}\n", .{@tagName(client.state)});

    // 4. Server sends authenticated flight: EE + Cert + CertificateVerify + Finished.
    const flight_record = try server.sendAuthenticatedFlightBuffered(
        &.{cert_der},
        signer_api,
        &flight,
    );
    print("[server] authenticated flight sent → state={s}\n", .{@tagName(server.state)});

    // 5. Client processes the encrypted flight and auto-emits its Finished.
    const client_event = try client.handleRecord(flight_record, &client_out.buffer);
    const client_finished_record = switch (client_event) {
        .write => |w| w,
        else => return error.UnexpectedEvent,
    };
    client_out.resize(@intCast(client_finished_record.len));
    client.completeWrite();
    print("[client] Finished sent → state={s}\n", .{@tagName(client.state)});

    // 6. Server verifies client Finished and reaches connected.
    try server.processClientFinished(client_out.slice());
    print("[server] client Finished verified → state={s}\n", .{@tagName(server.state)});

    // ── Verify handshake completed ───────────────────
    assert(client.isConnected());
    assert(server.isConnected());
    assert(mem.eql(u8, client.selectedAlpnProtocol().?, "h2"));
    assert(mem.eql(u8, server.selectedAlpnProtocol().?, "h2"));
    print("\n=== handshake complete (ALPN={s}) ===\n\n", .{client.selectedAlpnProtocol().?});

    // 7. Application-data round trip.
    const ping = try client.sendApplicationData("ping", &client_out.buffer);
    client_out.resize(@intCast(ping.len));
    client.completeWrite();
    try testing.expectEqualStrings(
        "ping",
        try server.receiveApplicationData(client_out.slice()),
    );
    print("[app]    client → server: ping\n", .{});

    const pong = try server.sendApplicationData("pong", &server_out.buffer);
    server.completeWrite();
    const ev = try client.handleRecord(pong, &client_out.buffer);
    try testing.expectEqualStrings("pong", ev.application_data);
    print("[app]    server → client: pong\n", .{});

    print("\n=== in-memory handshake OK ===\n", .{});
}
