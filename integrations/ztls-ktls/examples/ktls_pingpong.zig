const std = @import("std");
const testing = std.testing;
const posix = std.posix;
const Io = std.Io;
const linux = std.os.linux;
const ztls = @import("ztls");
const ztls_ktls = @import("ztls_ktls");
const fixtures = @import("fixtures");

const host = "127.0.0.1";
const server_name = "ztls.server.test";
const cert_der: []const u8 = &fixtures.server_ecdsa_cert_der;
const scalar: []const u8 = &fixtures.server_ecdsa_scalar;

const Outcome = union(enum) {
    running,
    passed,
    ktls_unavailable,
    failed: anyerror,
};

const Capability = enum(u8) {
    unknown,
    supported,
    unsupported,
};

const Scenario = enum {
    full,
    both_ktls,
    client_coalesced_key_update,
    forced_handoff,
    pending_write_guard,
    pending_ticket_guard,
    pending_key_update_response_guard,
    abrupt_client,
    fragmented_key_update,
};

const ServerContext = struct {
    io: Io,
    listener: *Io.net.Server,
    keypair: ztls.x25519.KeyPair,
    suite: ztls.CipherSuite,
    scenario: Scenario,
    capability: std.atomic.Value(u8) = .init(@intFromEnum(Capability.unknown)),
    activation_gate: std.Io.Semaphore = .{},
    outcome: Outcome = .running,
};

/// Run a loopback client and server with both post-handshake data planes owned
/// by Linux kTLS. The same code is exercised by the tests below.
pub fn main(init: std.process.Init) !void {
    try runScenario(init.io, .aes_128_gcm_sha256, .both_ktls);
    std.debug.print("ztls-ktls: loopback handoff, rekey, and closure succeeded\n", .{});
}

// RFC 8446 §4.6.3, §5.3, §6.1 — a real TCP connection crosses the exact
// userspace/kTLS boundary, exercises both live KeyUpdate directions when the
// kernel supports them, and exchanges explicit close_notify alerts.
test "Linux kTLS AES-128-GCM handoff, rekey, and clean closure" {
    try runScenario(testing.io, .aes_128_gcm_sha256, .full);
}

test "Linux kTLS AES-256-GCM handoff, rekey, and clean closure" {
    try runScenario(testing.io, .aes_256_gcm_sha384, .full);
}

test "Linux kTLS ChaCha20-Poly1305 handoff, rekey, and clean closure" {
    try runScenario(testing.io, .chacha20_poly1305_sha256, .full);
}

// RFC 8446 §4.6.3 — both package roles can own their kernel data planes and
// complete crossed live key updates without exposing stale key snapshots.
test "Linux kTLS client and server roles interoperate" {
    try runScenario(testing.io, .aes_128_gcm_sha256, .both_ktls);
}

// RFC 8446 §5.1 — an empty application record is not EOF, and the kernel only
// notices KeyUpdate at byte zero. The client skips the empty record and
// proactively ratchets when a complete NewSessionTicket precedes KeyUpdate.
test "Linux kTLS handles empty data then coalesced ticket and KeyUpdate" {
    try runScenario(testing.io, .aes_128_gcm_sha256, .client_coalesced_key_update);
}

// RFC 8446 §5.1 — Finished and application data are loaded into one
// RecordBuffer fill before either is processed. Handoff drains and delivers the
// application bytes exactly once before installing TLS_RX.
test "Linux kTLS drains forced read-ahead before handoff" {
    try runScenario(testing.io, .aes_128_gcm_sha256, .forced_handoff);
}

// RFC 8446 §5.3 — activation refuses an encrypted userspace record until its
// full transport delivery has been acknowledged.
test "Linux kTLS pending-write handoff drains existing read-ahead" {
    try runScenario(testing.io, .aes_128_gcm_sha256, .pending_write_guard);
}

// RFC 8446 §4.6.1, §5.3 — ticket preparation and its userspace-encrypted
// record must complete before the kernel can own the server TX record layer.
test "Linux kTLS rejects handoff until NewSessionTicket is flushed" {
    try runScenario(testing.io, .aes_128_gcm_sha256, .pending_ticket_guard);
}

// RFC 8446 §4.6.3 — an update_requested response is sent in userspace before
// activation can permit kernel application data.
test "Linux kTLS rejects handoff with a KeyUpdate response owed" {
    try runScenario(testing.io, .aes_128_gcm_sha256, .pending_key_update_response_guard);
}

// RFC 8446 §6.1 — TCP FIN without close_notify is truncation, never clean EOF.
test "Linux kTLS rejects a bare FIN as truncated TLS" {
    try runScenario(testing.io, .aes_128_gcm_sha256, .abrupt_client);
}

// RFC 8446 §5.1 — Linux pauses after a first-fragment KeyUpdate and cannot
// expose its continuation. The supported policy is a bounded fatal error.
test "Linux kTLS rejects fragmented KeyUpdate without hanging" {
    try runScenario(testing.io, .aes_128_gcm_sha256, .fragmented_key_update);
}

fn runScenario(io: Io, suite: ztls.CipherSuite, scenario: Scenario) !void {
    const client_keypair: ztls.x25519.KeyPair = .generate();
    const server_keypair: ztls.x25519.KeyPair = .generate();

    const address: Io.net.IpAddress = try .parse(host, 0);
    var listener = try address.listen(io, .{ .reuse_address = true });
    defer listener.deinit(io);
    var context: ServerContext = .{
        .io = io,
        .listener = &listener,
        .keypair = server_keypair,
        .suite = suite,
        .scenario = scenario,
    };
    const thread = try std.Thread.spawn(.{}, serverThread, .{&context});

    var client_error: ?anyerror = null;
    runClient(
        client_keypair,
        listener.socket.address.getPort(),
        &context,
        scenario,
    ) catch |err| {
        client_error = err;
    };
    thread.join();

    const server_unavailable = switch (context.outcome) {
        .ktls_unavailable => true,
        else => false,
    };
    const client_unavailable = if (client_error) |err|
        err == error.KtlsUnavailable
    else
        false;
    if (server_unavailable or client_unavailable) {
        return error.SkipZigTest;
    }
    switch (context.outcome) {
        .failed => |err| return err,
        .passed => {},
        .running => return error.ServerDidNotFinish,
        .ktls_unavailable => unreachable,
    }
    if (client_error) |err| return err;
}

fn serverThread(context: *ServerContext) void {
    runServer(context) catch |err| {
        context.outcome = if (err == error.KtlsUnavailable)
            .ktls_unavailable
        else
            .{ .failed = err };
        context.activation_gate.post(context.io);
        return;
    };
    context.outcome = .passed;
}

fn runServer(context: *ServerContext) !void {
    const stream = try context.listener.accept(context.io);
    defer stream.close(context.io);
    try setTimeouts(stream.socket.handle);

    var random: ztls.Random = undefined;
    context.io.random(&random.data);
    const supported_suites = [_]ztls.CipherSuite{context.suite};
    var handshake: ztls.ServerHandshake = .init(.{
        .keypairs = try .init(context.keypair),
        .random = random,
        .supported_suites = &supported_suites,
        .alpn_protocols = &.{"h2"},
    });
    defer handshake.deinit();
    var signer: ztls.signature.PrivateKey = try .fromP256Scalar(scalar[0..32]);
    defer signer.deinit();
    handshake.setCredentials(&.{cert_der}, signer.signer());

    var storage: ztls.RecordBuffer.Storage = .empty;
    var buffered: ztls.RecordBuffer = .init(&storage.buffer);
    var out: ztls.ServerHandshake.OutBuffer = .empty;
    var flight: ztls.ServerHandshake.FlightBuffer = .empty;
    var pending_app: [16]u8 = undefined;
    var pending_len: usize = 0;
    var force_two_records = false;

    while (true) {
        if (force_two_records) {
            while (try completeRecordCount(&buffered) < 2) {
                const n = try readSocket(stream, buffered.writable());
                if (n == 0) return error.TruncatedHandshake;
                buffered.advance(n);
            }
        } else {
            const n = try readSocket(stream, buffered.writable());
            if (n == 0) return error.TruncatedHandshake;
            buffered.advance(n);
        }
        while (try buffered.next()) |record| {
            if (!handshake.isConnected()) {
                const event = try handshake.handleRecord(record, &out.buffer);
                switch (event) {
                    .write => |wire| {
                        try writeSocketAll(stream, wire);
                        handshake.completeWrite();
                        if (try handshake.sendServerFlightBuffered(&flight)) |wire_flight| {
                            try writeSocketAll(stream, wire_flight);
                            handshake.completeWrite();
                            force_two_records = context.scenario == .forced_handoff;
                        }
                    },
                    .none => {},
                    .application_data, .closed, .key_update => {
                        return error.UnexpectedDuringHandshake;
                    },
                }
            } else {
                const event = try handshake.receiveRecord(record);
                switch (event) {
                    .application_data => |data| {
                        if (pending_len + data.len > pending_app.len) {
                            return error.PendingApplicationDataTooLarge;
                        }
                        @memcpy(pending_app[pending_len..][0..data.len], data);
                        pending_len += data.len;
                    },
                    .key_update => |request| {
                        if (request == .update_requested) {
                            const wire = try handshake.sendKeyUpdate(
                                &out.buffer,
                                .update_not_requested,
                            );
                            try writeSocketAll(stream, wire);
                            handshake.completeWrite();
                        }
                    },
                    .closed => return error.ClosedDuringHandoff,
                    .none => {},
                }
            }
        }
        if (handshake.isConnected() and buffered.isEmpty()) break;
        if (handshake.isConnected()) force_two_records = false;
    }

    if (context.scenario == .pending_key_update_response_guard) {
        const request = try readServerKeyUpdate(stream, &handshake, &buffered);
        try testing.expectEqual(ztls.ServerHandshake.KeyUpdateRequest.update_requested, request);
        try testing.expectError(
            error.PendingKeyUpdateResponse,
            ztls_ktls.Server.activate(stream.socket.handle, &handshake, &buffered),
        );
        const response = try handshake.sendKeyUpdate(
            &out.buffer,
            .update_not_requested,
        );
        try writeSocketAll(stream, response);
        handshake.completeWrite();
    }

    if (context.scenario == .client_coalesced_key_update) {
        if (pending_len == 0) {
            try readServerApplication(stream, &handshake, &buffered, "ping");
        } else {
            try testing.expectEqualSlices(u8, "ping", pending_app[0..pending_len]);
        }
        try sendServerApplication(stream, &handshake, &out, "");
        try sendServerApplication(stream, &handshake, &out, "pong");
        const client_capability: Capability = @enumFromInt(
            context.capability.load(.acquire),
        );
        if (client_capability == .unsupported) {
            const close_notify = try handshake.sendAlert(.close_notify, &out.buffer);
            try writeSocketAll(stream, close_notify);
            handshake.completeWrite();
            try readServerClose(stream, &handshake, &buffered);
            return;
        }
        if (client_capability != .supported) return error.MissingCapabilitySignal;

        const messages = [_]u8{
            0x04, 0x00, 0x00, 0x11,
            0x00, 0x00, 0x0e, 0x10,
            0x12, 0x34, 0x56, 0x78,
            0x02, 0xaa, 0xbb, 0x00,
            0x02, 0xcc, 0xdd, 0x00,
            0x00, 0x18, 0x00, 0x00,
            0x01, 0x00,
        };
        const wire = try handshake.tx.encrypt(.handshake, &messages, &out.buffer);
        try writeSocketAll(stream, wire);
        try handshake.ratchetKtlsTx(.update_not_requested);
        try sendServerApplication(stream, &handshake, &out, "after");

        try readServerClose(stream, &handshake, &buffered);
        const close_notify = try handshake.sendAlert(.close_notify, &out.buffer);
        try writeSocketAll(stream, close_notify);
        handshake.completeWrite();
        return;
    }

    var partial_storage: ztls.RecordBuffer.Storage = .empty;
    var partial: ztls.RecordBuffer = .init(&partial_storage.buffer);
    partial.advance(1);
    try testing.expectError(
        error.BufferedCiphertext,
        ztls_ktls.Server.activate(stream.socket.handle, &handshake, &partial),
    );

    if (context.scenario == .pending_write_guard) {
        const guard = try handshake.sendApplicationData("guard", &out.buffer);
        try testing.expectError(
            error.PendingWrite,
            ztls_ktls.Server.activate(stream.socket.handle, &handshake, &buffered),
        );

        try writeSocketAll(stream, guard);
        handshake.completeWrite();
        try sendServerApplication(stream, &handshake, &out, "pong");
    }

    if (context.scenario == .pending_ticket_guard) {
        var ticket_psk = try handshake.deriveTicketPsk();
        defer ticket_psk.secureZero();
        try testing.expectError(
            error.PendingTicket,
            ztls_ktls.Server.activate(stream.socket.handle, &handshake, &buffered),
        );
        const ticket = try handshake.sendNewSessionTicket(
            &ticket_psk,
            .{
                .ticket_lifetime = 60,
                .ticket_age_add = 0x12345678,
                .ticket = "ktls-handoff-ticket",
            },
            &out.buffer,
        );
        try testing.expectError(
            error.PendingWrite,
            ztls_ktls.Server.activate(stream.socket.handle, &handshake, &buffered),
        );
        try writeSocketAll(stream, ticket);
        handshake.completeWrite();
        try sendServerApplication(stream, &handshake, &out, "pong");
    }

    var connection = try ztls_ktls.Server.activate(
        stream.socket.handle,
        &handshake,
        &buffered,
    );
    const capability: Capability = switch (connection.rekeySupport()) {
        .supported => .supported,
        .unsupported => .unsupported,
    };
    context.capability.store(@intFromEnum(capability), .release);
    context.activation_gate.post(context.io);

    var short_read_buffer: [ztls.frame.max_plaintext_len - 1]u8 = undefined;
    try testing.expectError(error.BufferTooShort, connection.read(&short_read_buffer));

    var receive_buf: [ztls.frame.max_plaintext_len]u8 = undefined;
    if (pending_len != 0) {
        try testing.expectEqualSlices(u8, "ping", pending_app[0..pending_len]);
    } else {
        try readExact(&connection, receive_buf[0..4]);
        try testing.expectEqualSlices(u8, "ping", receive_buf[0..4]);
    }
    if (context.scenario != .pending_write_guard and
        context.scenario != .pending_ticket_guard)
    {
        try writeAll(&connection, "pong");
    }

    if (context.scenario == .abrupt_client) {
        try testing.expectError(error.Truncated, connection.read(&receive_buf));
        return;
    }
    if (context.scenario == .fragmented_key_update) {
        try testing.expectError(error.FragmentedKeyUpdate, connection.read(&receive_buf));
        return;
    }

    if (capability == .unsupported) {
        try connection.closeWrite();
        try testing.expectEqual(@as(usize, 0), try connection.read(&receive_buf));
        return;
    }

    try readExact(&connection, receive_buf[0..5]);
    try testing.expectEqualSlices(u8, "after", receive_buf[0..5]);

    try connection.update(.update_requested);
    try writeAll(&connection, "again");

    try readExact(&connection, receive_buf[0..5]);
    try testing.expectEqualSlices(u8, "final", receive_buf[0..5]);

    try connection.closeWrite();
    try testing.expectEqual(@as(usize, 0), try connection.read(&receive_buf));
}

fn runClient(
    keypair: ztls.x25519.KeyPair,
    port: u16,
    context: *ServerContext,
    scenario: Scenario,
) !void {
    const client_addr: Io.net.IpAddress = try .parse(host, port);
    const stream = try client_addr.connect(context.io, .{ .mode = .stream });
    defer stream.close(context.io);
    try setTimeouts(stream.socket.handle);

    var random: ztls.Random = undefined;
    context.io.random(&random.data);
    var handshake: ztls.ClientHandshake = .init(.{
        .keypairs = try .init(keypair),
        .host_name = server_name,
        .now_sec = Io.Timestamp.now(context.io, .real).toSeconds(),
        .random = random,
        .insecure_no_chain_anchor = true,
        .alpn_protocols = &.{"h2"},
    });
    defer handshake.deinit();

    var out: ztls.ClientHandshake.OutBuffer = .empty;
    var storage: ztls.RecordBuffer.Storage = .empty;
    var buffered: ztls.RecordBuffer = .init(&storage.buffer);
    var sent_ping = false;

    try writeSocketAll(stream, try handshake.start(&out.buffer));
    handshake.completeWrite();
    while (!handshake.isConnected()) {
        const n = try readSocket(stream, buffered.writable());
        if (n == 0) return error.TruncatedHandshake;
        buffered.advance(n);
        while (try buffered.next()) |record| {
            const event = try handshake.handleRecord(record, &out.buffer);
            switch (event) {
                .write => |wire| {
                    if (scenario == .forced_handoff and handshake.isConnected()) {
                        var combined: [ztls.frame.max_wire_record_len * 2]u8 = undefined;
                        @memcpy(combined[0..wire.len], wire);
                        handshake.completeWrite();
                        const app = try handshake.sendApplicationData("ping", &out.buffer);
                        @memcpy(combined[wire.len..][0..app.len], app);
                        handshake.completeWrite();
                        try writeSocketAll(stream, combined[0 .. wire.len + app.len]);
                        sent_ping = true;
                    } else {
                        try writeSocketAll(stream, wire);
                        handshake.completeWrite();
                    }
                },
                .key_update => |update| if (update.response) |wire| {
                    try writeSocketAll(stream, wire);
                    handshake.completeWrite();
                },
                .none => {},
                .application_data, .closed, .new_session_ticket => {
                    return error.UnexpectedDuringHandshake;
                },
            }
        }
    }

    if (scenario == .pending_key_update_response_guard) {
        const update = try handshake.sendKeyUpdate(&out.buffer, .update_requested);
        try writeSocketAll(stream, update);
        handshake.completeWrite();
        try readClientKeyUpdate(stream, &handshake, &buffered, .update_not_requested);
    }

    if (scenario == .both_ktls or scenario == .client_coalesced_key_update) {
        var connection = try ztls_ktls.Client.activate(
            stream.socket.handle,
            &handshake,
            &buffered,
        );
        if (scenario != .client_coalesced_key_update) {
            context.activation_gate.waitUncancelable(context.io);
        }
        try writeAll(&connection, "ping");
        if (scenario == .client_coalesced_key_update) {
            const capability_value: Capability = switch (connection.rekeySupport()) {
                .supported => .supported,
                .unsupported => .unsupported,
            };
            context.capability.store(@intFromEnum(capability_value), .release);
        }
        var receive_buf: [ztls.frame.max_plaintext_len]u8 = undefined;
        try readExact(&connection, receive_buf[0..4]);
        try testing.expectEqualSlices(u8, "pong", receive_buf[0..4]);

        if (scenario == .client_coalesced_key_update) {
            if (connection.rekeySupport() == .unsupported) {
                try testing.expectEqual(@as(usize, 0), try connection.read(&receive_buf));
                try connection.closeWrite();
                return;
            }
            try readExact(&connection, receive_buf[0..5]);
            try testing.expectEqualSlices(u8, "after", receive_buf[0..5]);
            try connection.closeWrite();
            try testing.expectEqual(@as(usize, 0), try connection.read(&receive_buf));
            return;
        }

        if (connection.rekeySupport() == .unsupported) {
            try testing.expectEqual(@as(usize, 0), try connection.read(&receive_buf));
            try connection.closeWrite();
            return;
        }

        try connection.update(.update_requested);
        try writeAll(&connection, "after");
        try readExact(&connection, receive_buf[0..5]);
        try testing.expectEqualSlices(u8, "again", receive_buf[0..5]);
        try writeAll(&connection, "final");
        try testing.expectEqual(@as(usize, 0), try connection.read(&receive_buf));
        try connection.closeWrite();
        return;
    }

    if (!sent_ping) {
        context.activation_gate.waitUncancelable(context.io);
        try sendApplicationData(stream, &handshake, &out, "ping");
    }
    if (scenario == .pending_write_guard) {
        while (try completeRecordCount(&buffered) < 2) {
            const n = try readSocket(stream, buffered.writable());
            if (n == 0) return error.TruncatedConnection;
            buffered.advance(n);
        }
        try readClientApplication(stream, &handshake, &buffered, &out, "guard", null);
    }
    try readClientApplication(stream, &handshake, &buffered, &out, "pong", null);
    if (scenario == .abrupt_client) return;
    if (scenario == .fragmented_key_update) {
        const fragment = [_]u8{
            @intFromEnum(ztls.ClientHandshake.HandshakeType.key_update),
            0,
        };
        const wire = try handshake.tx.encrypt(.handshake, &fragment, &out.buffer);
        try writeSocketAll(stream, wire);
        try readClientFatal(stream, &handshake, &buffered, &out);
        return;
    }

    const active_capability: Capability = @enumFromInt(
        context.capability.load(.acquire),
    );
    if (active_capability == .unknown) return error.MissingCapabilitySignal;
    if (active_capability == .unsupported) {
        try readClientClose(stream, &handshake, &buffered, &out);
        try sendClientClose(stream, &handshake, &out);
        return;
    }

    const key_update = try handshake.sendKeyUpdate(&out.buffer, .update_requested);
    try writeSocketAll(stream, key_update);
    handshake.completeWrite();
    try sendApplicationData(stream, &handshake, &out, "after");

    var key_updates: u8 = 0;
    try readClientApplication(
        stream,
        &handshake,
        &buffered,
        &out,
        "again",
        &key_updates,
    );
    try testing.expectEqual(@as(u8, 2), key_updates);

    try sendApplicationData(stream, &handshake, &out, "final");
    try readClientClose(stream, &handshake, &buffered, &out);
    try sendClientClose(stream, &handshake, &out);
}

fn sendServerApplication(
    stream: Io.net.Stream,
    handshake: *ztls.ServerHandshake,
    out: *ztls.ServerHandshake.OutBuffer,
    data: []const u8,
) !void {
    try writeSocketAll(stream, try handshake.sendApplicationData(data, &out.buffer));
    handshake.completeWrite();
}

fn readServerKeyUpdate(
    stream: Io.net.Stream,
    handshake: *ztls.ServerHandshake,
    buffered: *ztls.RecordBuffer,
) !ztls.ServerHandshake.KeyUpdateRequest {
    while (true) {
        while (try buffered.next()) |record| {
            switch (try handshake.receiveRecord(record)) {
                .key_update => |request| return request,
                .none => {},
                .application_data, .closed => return error.UnexpectedServerEvent,
            }
        }
        const n = try readSocket(stream, buffered.writable());
        if (n == 0) return error.TruncatedConnection;
        buffered.advance(n);
    }
}

fn readServerApplication(
    stream: Io.net.Stream,
    handshake: *ztls.ServerHandshake,
    buffered: *ztls.RecordBuffer,
    expected: []const u8,
) !void {
    while (true) {
        while (try buffered.next()) |record| {
            switch (try handshake.receiveRecord(record)) {
                .application_data => |data| {
                    try testing.expectEqualSlices(u8, expected, data);
                    return;
                },
                .none => {},
                .closed, .key_update => return error.UnexpectedServerEvent,
            }
        }
        const n = try readSocket(stream, buffered.writable());
        if (n == 0) return error.TruncatedConnection;
        buffered.advance(n);
    }
}

fn readServerClose(
    stream: Io.net.Stream,
    handshake: *ztls.ServerHandshake,
    buffered: *ztls.RecordBuffer,
) !void {
    while (true) {
        while (try buffered.next()) |record| {
            switch (try handshake.receiveRecord(record)) {
                .closed => return,
                .none => {},
                .application_data, .key_update => return error.UnexpectedServerEvent,
            }
        }
        const n = try readSocket(stream, buffered.writable());
        if (n == 0) return error.MissingCloseNotify;
        buffered.advance(n);
    }
}

fn readClientKeyUpdate(
    stream: Io.net.Stream,
    handshake: *ztls.ClientHandshake,
    buffered: *ztls.RecordBuffer,
    expected: ztls.ClientHandshake.KeyUpdateRequest,
) !void {
    while (true) {
        while (try buffered.next()) |record| {
            switch (try handshake.receiveRecord(record)) {
                .key_update => |request| {
                    try testing.expectEqual(expected, request);
                    return;
                },
                .none, .new_session_ticket => {},
                .application_data, .closed => return error.UnexpectedClientEvent,
            }
        }
        const n = try readSocket(stream, buffered.writable());
        if (n == 0) return error.TruncatedConnection;
        buffered.advance(n);
    }
}

fn sendApplicationData(
    stream: Io.net.Stream,
    handshake: *ztls.ClientHandshake,
    out: *ztls.ClientHandshake.OutBuffer,
    data: []const u8,
) !void {
    try writeSocketAll(stream, try handshake.sendApplicationData(data, &out.buffer));
    handshake.completeWrite();
}

fn readClientApplication(
    stream: Io.net.Stream,
    handshake: *ztls.ClientHandshake,
    buffered: *ztls.RecordBuffer,
    out: *ztls.ClientHandshake.OutBuffer,
    expected: []const u8,
    key_updates: ?*u8,
) !void {
    while (true) {
        while (try buffered.next()) |record| {
            const event = try handshake.handleRecord(record, &out.buffer);
            switch (event) {
                .application_data => |data| {
                    try testing.expectEqualSlices(u8, expected, data);
                    return;
                },
                .key_update => |update| {
                    if (key_updates) |count| count.* +|= 1;
                    if (update.response) |wire| {
                        try writeSocketAll(stream, wire);
                        handshake.completeWrite();
                    }
                },
                .write => |wire| {
                    try writeSocketAll(stream, wire);
                    handshake.completeWrite();
                },
                .new_session_ticket, .none => {},
                .closed => return error.ClosedBeforeApplicationData,
            }
        }
        const n = try readSocket(stream, buffered.writable());
        if (n == 0) return error.TruncatedConnection;
        buffered.advance(n);
    }
}

fn readClientClose(
    stream: Io.net.Stream,
    handshake: *ztls.ClientHandshake,
    buffered: *ztls.RecordBuffer,
    out: *ztls.ClientHandshake.OutBuffer,
) !void {
    while (true) {
        while (try buffered.next()) |record| {
            const event = try handshake.handleRecord(record, &out.buffer);
            switch (event) {
                .closed => return,
                .key_update => |update| if (update.response) |wire| {
                    try writeSocketAll(stream, wire);
                    handshake.completeWrite();
                },
                .new_session_ticket, .none => {},
                .write, .application_data => return error.UnexpectedBeforeClose,
            }
        }
        const n = try readSocket(stream, buffered.writable());
        if (n == 0) return error.MissingCloseNotify;
        buffered.advance(n);
    }
}

fn sendClientClose(
    stream: Io.net.Stream,
    handshake: *ztls.ClientHandshake,
    out: *ztls.ClientHandshake.OutBuffer,
) !void {
    try writeSocketAll(stream, try handshake.sendAlert(.close_notify, &out.buffer));
    handshake.completeWrite();
}

fn readClientFatal(
    stream: Io.net.Stream,
    handshake: *ztls.ClientHandshake,
    buffered: *ztls.RecordBuffer,
    out: *ztls.ClientHandshake.OutBuffer,
) !void {
    while (true) {
        while (try buffered.next()) |record| {
            _ = handshake.handleRecord(record, &out.buffer) catch |err| {
                if (err != error.PeerAlert) return err;
                const peer_alert = handshake.lastPeerAlert() orelse {
                    return error.MissingFatalAlert;
                };
                try testing.expectEqual(
                    ztls.alert.Description.unexpected_message,
                    peer_alert.description,
                );
                return;
            };
        }
        const n = try readSocket(stream, buffered.writable());
        if (n == 0) return error.MissingFatalAlert;
        buffered.advance(n);
    }
}

fn completeRecordCount(buffered: *const ztls.RecordBuffer) !usize {
    var probe = buffered.*;
    var count: usize = 0;
    while (try probe.next()) |_| count += 1;
    return count;
}

fn readExact(connection: anytype, bytes: []u8) !void {
    var scratch: [ztls.frame.max_plaintext_len]u8 = undefined;
    var offset: usize = 0;
    while (offset < bytes.len) {
        const n = try connection.read(&scratch);
        if (n == 0) return error.ClosedBeforeApplicationData;
        if (n > bytes.len - offset) return error.UnexpectedApplicationData;
        @memcpy(bytes[offset..][0..n], scratch[0..n]);
        offset += n;
    }
}

fn writeAll(connection: anytype, bytes: []const u8) !void {
    var offset: usize = 0;
    while (offset < bytes.len) {
        const n = try connection.write(bytes[offset..]);
        if (n == 0) return error.WriteZero;
        offset += n;
    }
}

fn writeSocketAll(stream: Io.net.Stream, bytes: []const u8) !void {
    var rest = bytes;
    var attempts: u8 = 0;
    while (rest.len != 0 and attempts < 128) : (attempts += 1) {
        const rc = linux.sendto(
            stream.socket.handle,
            rest.ptr,
            rest.len,
            linux.MSG.NOSIGNAL,
            null,
            0,
        );
        switch (linux.errno(rc)) {
            .SUCCESS => {
                const sent: usize = @intCast(@as(isize, @bitCast(rc)));
                if (sent == 0) return error.WriteZero;
                rest = rest[sent..];
            },
            .INTR => continue,
            .AGAIN => return error.WriteTimedOut,
            .PIPE, .CONNRESET, .NOTCONN => return error.ConnectionClosed,
            else => return error.UnexpectedWriteError,
        }
    }
    if (rest.len != 0) return error.TooManyWrites;
}

fn readSocket(stream: Io.net.Stream, bytes: []u8) !usize {
    var interruptions: u8 = 0;
    while (interruptions < 16) : (interruptions += 1) {
        const rc = linux.recvfrom(stream.socket.handle, bytes.ptr, bytes.len, 0, null, null);
        switch (linux.errno(rc)) {
            .SUCCESS => return @intCast(@as(isize, @bitCast(rc))),
            .INTR => continue,
            .AGAIN => return error.ReadTimedOut,
            .CONNRESET, .NOTCONN => return error.ConnectionClosed,
            else => return error.UnexpectedReadError,
        }
    }
    return error.InterruptedTooOften;
}

fn setTimeouts(fd: posix.socket_t) !void {
    const timeout: posix.timeval = .{ .sec = 5, .usec = 0 };
    try posix.setsockopt(
        fd,
        posix.SOL.SOCKET,
        posix.SO.RCVTIMEO,
        std.mem.asBytes(&timeout),
    );
    try posix.setsockopt(
        fd,
        posix.SOL.SOCKET,
        posix.SO.SNDTIMEO,
        std.mem.asBytes(&timeout),
    );
}
