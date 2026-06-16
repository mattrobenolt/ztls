const std = @import("std");
const assert = std.debug.assert;
const mem = std.mem;
const heap = std.heap;

const bench = @import("benchmark");
const txtar = @import("txtar");

const ztls = @import("../root.zig");
const Aead = ztls.aead.Aead;
const Iv = ztls.aead.Iv;
const RecordBuffer = ztls.RecordBuffer;
const RecordLayer = ztls.RecordLayer;
const frame = ztls.frame;
const rfc8448 = @import("rfc8448.zig");

const all_suites = [_]Suite{
    .aes_128_gcm_sha256,
    .aes_256_gcm_sha384,
    .chacha20_poly1305_sha256,
};
const sizes = [_]usize{ 16, 128, 1350, 8192, frame.max_plaintext_len };
const openssl_replay_archive = @embedFile("../test_fixtures/openssl_replay.txtar");
const shared_fixtures = @import("../test_fixtures/shared_fixtures.zig");
const server_cert_der: []const u8 = &shared_fixtures.server_ecdsa_cert_der;
const server_scalar: []const u8 = &shared_fixtures.server_ecdsa_scalar;

const Suite = enum {
    aes_128_gcm_sha256,
    aes_256_gcm_sha384,
    chacha20_poly1305_sha256,

    fn name(self: Suite) []const u8 {
        return switch (self) {
            .aes_128_gcm_sha256 => "TLS_AES_128_GCM_SHA256",
            .aes_256_gcm_sha384 => "TLS_AES_256_GCM_SHA384",
            .chacha20_poly1305_sha256 => "TLS_CHACHA20_POLY1305_SHA256",
        };
    }

    fn fixtureName(self: Suite) []const u8 {
        return switch (self) {
            .aes_128_gcm_sha256 => "aes128.records.b64",
            .aes_256_gcm_sha384 => "aes256.records.b64",
            .chacha20_poly1305_sha256 => "chacha20.records.b64",
        };
    }

    fn aead(self: Suite) Aead {
        return switch (self) {
            .aes_128_gcm_sha256 => .{ .aes_128_gcm_sha256 = .init(@splat(0x11)) },
            .aes_256_gcm_sha384 => .{ .aes_256_gcm_sha384 = .init(@splat(0x22)) },
            .chacha20_poly1305_sha256 => .{ .chacha20_poly1305_sha256 = .init(@splat(0x33)) },
        };
    }

    fn cipherSuite(self: Suite) ztls.CipherSuite {
        return switch (self) {
            .aes_128_gcm_sha256 => .aes_128_gcm_sha256,
            .aes_256_gcm_sha384 => .aes_256_gcm_sha384,
            .chacha20_poly1305_sha256 => .chacha20_poly1305_sha256,
        };
    }
};

fn nameBuf(buf: []u8, suite: Suite, size: usize) ![]const u8 {
    return std.fmt.bufPrint(buf, "{s}/{d}", .{ suite.name(), size });
}

pub fn benchmarkParseHeader(b: *bench.B) !void {
    const record = [_]u8{ 0x17, 0x03, 0x03, 0x00, 0x16 } ++ [_]u8{0} ** 22;
    while (try b.loop()) {
        const header = frame.parseHeader(&record) catch unreachable;
        b.keepAlive(header);
    }
}

pub fn benchmarkRecordBufferNext(b: *bench.B) !void {
    const record = [_]u8{ 0x17, 0x03, 0x03, 0x00, 0x01, 0x00 };
    var storage: [RecordBuffer.min_storage]u8 = undefined;
    while (try b.loop()) {
        var rb: RecordBuffer = .init(&storage);
        @memcpy(rb.writable()[0..record.len], &record);
        rb.advance(record.len);
        const next = (rb.next() catch unreachable).?;
        b.keepAlive(next.ptr);
    }
}

fn replayHandshake(records: []const u8, out: []u8) !void {
    var hs: ztls.ClientHandshake = .init(rfc8448.client_keypair);
    _ = try hs.start(out, rfc8448.client_random, rfc8448.replay_host_name);
    hs.completeWrite();

    var record_buf: [RecordBuffer.min_storage]u8 = undefined;
    @memcpy(record_buf[0..records.len], records);
    var rb: RecordBuffer = .init(&record_buf);
    rb.advance(records.len);

    while (try rb.next()) |record| {
        switch (try hs.handleRecord(record, out)) {
            .write => hs.completeWrite(),
            .none => {},
            .application_data, .closed => return error.UnexpectedDuringHandshake,
        }
    }
    if (!hs.isConnected()) return error.HandshakeIncomplete;
}

fn benchClientHandshakeReplay(comptime suite: Suite) bench.Function {
    return struct {
        pub fn benchFn(b: *bench.B) !void {
            var fixture_scratch: [8192]u8 = undefined;
            var fba: heap.FixedBufferAllocator = .init(&fixture_scratch);
            var records_buf: [2048]u8 = undefined;
            const records = fixture(
                fba.allocator(),
                suite.fixtureName(),
                &records_buf,
            ) catch unreachable;
            var out: [1024]u8 = undefined;

            replayHandshake(records, &out) catch unreachable;

            while (try b.loop()) {
                replayHandshake(records, &out) catch unreachable;
            }
        }
    }.benchFn;
}

fn fixture(alloc: mem.Allocator, name: []const u8, out: []u8) ![]u8 {
    var archive = try txtar.parse(alloc, openssl_replay_archive);
    defer archive.deinit(alloc);
    for (archive.files) |f| {
        if (!mem.eql(u8, f.name, name)) continue;
        const b64 = mem.trimEnd(u8, f.data, "\n");
        const n = try std.base64.standard.Decoder.calcSizeForSlice(b64);
        try std.base64.standard.Decoder.decode(out[0..n], b64);
        return out[0..n];
    }
    return error.FixtureNotFound;
}

fn deterministicClientKeypair() !ztls.x25519.KeyPair {
    return .generateDeterministic(.init(@splat(0x11)));
}

fn deterministicServerKeypair() !ztls.x25519.KeyPair {
    return .generateDeterministic(.init(@splat(0x22)));
}

fn deterministicClientHandshake() ztls.ClientHandshake {
    var client: ztls.ClientHandshake = .init(deterministicClientKeypair() catch unreachable);
    client.policy.insecure_no_chain_anchor = true;
    return client;
}

fn deterministicServerHandshake() ztls.ServerHandshake {
    return .init(deterministicServerKeypair() catch unreachable);
}

fn connectPair(comptime suite: Suite) !struct {
    client: ztls.ClientHandshake,
    server: ztls.ServerHandshake,
} {
    var client: ztls.ClientHandshake = ztls.ClientHandshake.init(try deterministicClientKeypair());
    client.policy.host_name = "ztls.server.test";
    client.policy.insecure_no_chain_anchor = true;
    var client_out: [4096]u8 = undefined;
    const ch_record = try client.start(&client_out, rfc8448.client_random, "ztls.server.test");
    client.completeWrite();

    var server: ztls.ServerHandshake = ztls.ServerHandshake.init(try deterministicServerKeypair());
    const suites = [_]ztls.CipherSuite{suite.cipherSuite()};
    server.supportSuites(&suites);
    var server_out: [8192]u8 = undefined;
    const sh_record = try server.acceptClientHello(ch_record, rfc8448.client_random, &server_out);
    try client.processServerHello(sh_record[ztls.frame.header_len..]);

    var signer: ztls.signature.PrivateKey = try .fromP256Scalar(server_scalar[0..32]);
    defer signer.deinit();
    const flight_record = try server.sendPreparedAuthenticatedFlight(
        &.{server_cert_der},
        signer.signer(),
        &server_out,
    );
    const ev = try client.handleRecord(server_out[0..flight_record.len], &client_out);
    const client_finished = switch (ev) {
        .write => |w| w,
        else => return error.UnexpectedEvent,
    };
    try server.processClientFinished(client_out[0..client_finished.len]);
    client.completeWrite();
    if (!client.isConnected() or !server.isConnected()) return error.HandshakeIncomplete;
    return .{ .client = client, .server = server };
}

pub fn benchmarkClientHandshakeReplay(b: *bench.B) !void {
    inline for (all_suites) |suite| {
        _ = try b.run(suite.name(), benchClientHandshakeReplay(suite));
    }
}

fn benchZtlsHandshake(comptime suite: Suite) bench.Function {
    return struct {
        pub fn benchFn(b: *bench.B) !void {
            _ = connectPair(suite) catch unreachable;
            while (try b.loop()) {
                var pair = connectPair(suite) catch unreachable;
                pair.client.deinit();
                pair.server.deinit();
                b.keepAlive(&pair.client);
                b.keepAlive(&pair.server);
            }
        }
    }.benchFn;
}

pub fn benchmarkHandshake(b: *bench.B) !void {
    var name_buf: [80]u8 = undefined;
    inline for (all_suites) |suite| {
        const name = try std.fmt.bufPrint(&name_buf, "impl=ztls/suite={s}", .{suite.name()});
        _ = try b.run(name, benchZtlsHandshake(suite));
    }
}

fn benchHandshakeClientStart(comptime suite: Suite) bench.Function {
    _ = suite;
    return struct {
        pub fn benchFn(b: *bench.B) !void {
            while (try b.loop()) {
                var client: ztls.ClientHandshake = deterministicClientHandshake();
                client.policy.host_name = "ztls.server.test";
                client.policy.insecure_no_chain_anchor = true;
                var client_out: [4096]u8 = undefined;
                const ch = client.start(
                    &client_out,
                    rfc8448.client_random,
                    "ztls.server.test",
                ) catch unreachable;
                b.keepAlive(ch.ptr);
                client.deinit();
            }
        }
    }.benchFn;
}

pub fn benchmarkHandshakeClientStart(b: *bench.B) !void {
    inline for (all_suites) |suite| {
        _ = try b.run(suite.name(), benchHandshakeClientStart(suite));
    }
}

fn benchHandshakeServerAccept(comptime suite: Suite) bench.Function {
    return struct {
        pub fn benchFn(b: *bench.B) !void {
            var client: ztls.ClientHandshake = deterministicClientHandshake();
            client.policy.host_name = "ztls.server.test";
            client.policy.insecure_no_chain_anchor = true;
            var client_out: [4096]u8 = undefined;
            const ch_record = client.start(
                &client_out,
                rfc8448.client_random,
                "ztls.server.test",
            ) catch unreachable;
            client.completeWrite();

            while (try b.loop()) {
                var server: ztls.ServerHandshake = deterministicServerHandshake();
                const suites = [_]ztls.CipherSuite{suite.cipherSuite()};
                server.supportSuites(&suites);
                var server_out: [8192]u8 = undefined;
                _ = server.acceptClientHello(
                    ch_record,
                    rfc8448.client_random,
                    &server_out,
                ) catch unreachable;
                b.keepAlive(&server);
                server.deinit();
            }
            client.deinit();
        }
    }.benchFn;
}

pub fn benchmarkHandshakeServerAccept(b: *bench.B) !void {
    inline for (all_suites) |suite| {
        _ = try b.run(suite.name(), benchHandshakeServerAccept(suite));
    }
}

fn benchHandshakeClientServerHello(comptime suite: Suite) bench.Function {
    return struct {
        pub fn benchFn(b: *bench.B) !void {
            var client: ztls.ClientHandshake = deterministicClientHandshake();
            client.policy.host_name = "ztls.server.test";
            client.policy.insecure_no_chain_anchor = true;
            var client_out: [4096]u8 = undefined;
            const ch_record = client.start(
                &client_out,
                rfc8448.client_random,
                "ztls.server.test",
            ) catch unreachable;
            client.completeWrite();

            var server: ztls.ServerHandshake = deterministicServerHandshake();
            const suites = [_]ztls.CipherSuite{suite.cipherSuite()};
            server.supportSuites(&suites);
            var server_out: [8192]u8 = undefined;
            const sh_record = server.acceptClientHello(
                ch_record,
                rfc8448.client_random,
                &server_out,
            ) catch unreachable;

            while (try b.loop()) {
                var c: ztls.ClientHandshake = deterministicClientHandshake();
                c.processServerHello(sh_record[ztls.frame.header_len..]) catch unreachable;
                b.keepAlive(&c);
                c.deinit();
            }
            server.deinit();
            client.deinit();
        }
    }.benchFn;
}

pub fn benchmarkHandshakeClientServerHello(b: *bench.B) !void {
    inline for (all_suites) |suite| {
        _ = try b.run(suite.name(), benchHandshakeClientServerHello(suite));
    }
}

fn benchHandshakeServerFlight(comptime suite: Suite) bench.Function {
    return struct {
        pub fn benchFn(b: *bench.B) !void {
            var client: ztls.ClientHandshake = deterministicClientHandshake();
            client.policy.host_name = "ztls.server.test";
            client.policy.insecure_no_chain_anchor = true;
            var client_out: [4096]u8 = undefined;
            const ch_record = client.start(
                &client_out,
                rfc8448.client_random,
                "ztls.server.test",
            ) catch unreachable;
            client.completeWrite();

            var server: ztls.ServerHandshake = deterministicServerHandshake();
            const suites = [_]ztls.CipherSuite{suite.cipherSuite()};
            server.supportSuites(&suites);
            var server_out: [8192]u8 = undefined;
            const sh_record = server.acceptClientHello(
                ch_record,
                rfc8448.client_random,
                &server_out,
            ) catch unreachable;

            var client2: ztls.ClientHandshake = deterministicClientHandshake();
            client2.processServerHello(sh_record[ztls.frame.header_len..]) catch unreachable;

            var signer: ztls.signature.PrivateKey = ztls.signature.PrivateKey.fromP256Scalar(
                server_scalar[0..32],
            ) catch unreachable;
            defer signer.deinit();

            while (try b.loop()) {
                var s: ztls.ServerHandshake = deterministicServerHandshake();
                s.supportSuites(&suites);
                var so: [8192]u8 = undefined;
                _ = s.sendPreparedAuthenticatedFlight(
                    &.{server_cert_der},
                    signer.signer(),
                    &so,
                ) catch unreachable;
                b.keepAlive(&s);
                s.deinit();
            }
            client2.deinit();
            server.deinit();
            client.deinit();
        }
    }.benchFn;
}

pub fn benchmarkHandshakeServerFlight(b: *bench.B) !void {
    inline for (all_suites) |suite| {
        _ = try b.run(suite.name(), benchHandshakeServerFlight(suite));
    }
}

fn benchHandshakeClientFlight(comptime suite: Suite) bench.Function {
    return struct {
        pub fn benchFn(b: *bench.B) !void {
            var client: ztls.ClientHandshake = deterministicClientHandshake();
            client.policy.host_name = "ztls.server.test";
            client.policy.insecure_no_chain_anchor = true;
            var client_out: [4096]u8 = undefined;
            const ch_record = client.start(
                &client_out,
                rfc8448.client_random,
                "ztls.server.test",
            ) catch unreachable;
            client.completeWrite();

            var server: ztls.ServerHandshake = deterministicServerHandshake();
            const suites = [_]ztls.CipherSuite{suite.cipherSuite()};
            server.supportSuites(&suites);
            var server_out: [8192]u8 = undefined;
            const sh_record = server.acceptClientHello(
                ch_record,
                rfc8448.client_random,
                &server_out,
            ) catch unreachable;

            var client2: ztls.ClientHandshake = deterministicClientHandshake();
            client2.processServerHello(sh_record[ztls.frame.header_len..]) catch unreachable;

            var signer: ztls.signature.PrivateKey = ztls.signature.PrivateKey.fromP256Scalar(
                server_scalar[0..32],
            ) catch unreachable;
            defer signer.deinit();
            const flight_record = server.sendPreparedAuthenticatedFlight(
                &.{server_cert_der},
                signer.signer(),
                &server_out,
            ) catch unreachable;

            while (try b.loop()) {
                var c: ztls.ClientHandshake = deterministicClientHandshake();
                c.processServerHello(sh_record[ztls.frame.header_len..]) catch unreachable;
                var co: [4096]u8 = undefined;
                const ev = c.handleRecord(server_out[0..flight_record.len], &co) catch unreachable;
                const cf = switch (ev) {
                    .write => |w| w,
                    else => continue,
                };
                b.keepAlive(cf.ptr);
                c.deinit();
            }
            server.deinit();
            client.deinit();
        }
    }.benchFn;
}

pub fn benchmarkHandshakeClientFlight(b: *bench.B) !void {
    inline for (all_suites) |suite| {
        _ = try b.run(suite.name(), benchHandshakeClientFlight(suite));
    }
}

const ServerFinishedInput = struct {
    server: ztls.ServerHandshake,
    record_buf: [128]u8,
    record_len: usize,

    fn record(self: *ServerFinishedInput) []u8 {
        return self.record_buf[0..self.record_len];
    }
};

fn serverFinishedInput(comptime suite: Suite) !ServerFinishedInput {
    var client: ztls.ClientHandshake = deterministicClientHandshake();
    defer client.deinit();
    client.policy.host_name = "ztls.server.test";
    client.policy.insecure_no_chain_anchor = true;
    var client_out: [4096]u8 = undefined;
    const ch_record = try client.start(&client_out, rfc8448.client_random, "ztls.server.test");
    client.completeWrite();

    var server: ztls.ServerHandshake = deterministicServerHandshake();
    errdefer server.deinit();
    const suites = [_]ztls.CipherSuite{suite.cipherSuite()};
    server.supportSuites(&suites);
    var server_out: [8192]u8 = undefined;
    const sh_record = try server.acceptClientHello(ch_record, rfc8448.client_random, &server_out);
    try client.processServerHello(sh_record[ztls.frame.header_len..]);

    var signer: ztls.signature.PrivateKey = try .fromP256Scalar(server_scalar[0..32]);
    defer signer.deinit();
    const flight_record = try server.sendPreparedAuthenticatedFlight(
        &.{server_cert_der},
        signer.signer(),
        &server_out,
    );
    const ev = try client.handleRecord(server_out[0..flight_record.len], &client_out);
    const client_finished = switch (ev) {
        .write => |w| w,
        else => return error.UnexpectedEvent,
    };

    var input: ServerFinishedInput = .{
        .server = server,
        .record_buf = undefined,
        .record_len = client_finished.len,
    };
    @memcpy(input.record_buf[0..client_finished.len], client_out[0..client_finished.len]);
    input.server.client_server_name = null;
    return input;
}

fn benchHandshakeServerFinished(comptime suite: Suite) bench.Function {
    return struct {
        pub fn benchFn(b: *bench.B) !void {
            var warm = serverFinishedInput(suite) catch unreachable;
            warm.server.processClientFinished(warm.record()) catch unreachable;
            warm.server.deinit();

            while (try b.loop()) {
                b.stopTimer();
                var input = serverFinishedInput(suite) catch unreachable;
                b.startTimer();

                input.server.processClientFinished(input.record()) catch unreachable;
                b.keepAlive(&input.server);

                b.stopTimer();
                input.server.deinit();
                b.startTimer();
            }
        }
    }.benchFn;
}

pub fn benchmarkHandshakeServerFinished(b: *bench.B) !void {
    inline for (all_suites) |suite| {
        _ = try b.run(suite.name(), benchHandshakeServerFinished(suite));
    }
}

fn benchEncrypt(comptime suite: Suite, comptime size: usize) bench.Function {
    return struct {
        pub fn benchFn(b: *bench.B) !void {
            var plaintext: [size]u8 = @splat(0xab);
            var out: [RecordLayer.overhead + size]u8 = undefined;
            var tx: RecordLayer = RecordLayer.init(suite.aead(), Iv.zero) catch unreachable;
            defer tx.deinit();

            for (0..32) |_| _ = tx.encrypt(.application_data, &plaintext, &out) catch unreachable;

            b.setBytes(size);
            while (try b.loop()) {
                const record = tx.encrypt(.application_data, &plaintext, &out) catch unreachable;
                b.keepAlive(record.ptr);
            }
        }
    }.benchFn;
}

pub fn benchmarkRecordEncrypt(b: *bench.B) !void {
    var name_buf: [80]u8 = undefined;
    inline for (all_suites) |suite| {
        inline for (sizes) |size| {
            const name = try nameBuf(&name_buf, suite, size);
            _ = try b.run(name, benchEncrypt(suite, size));
        }
    }
}

fn benchDecrypt(comptime suite: Suite, comptime size: usize) bench.Function {
    return struct {
        pub fn benchFn(b: *bench.B) !void {
            const record_len = RecordLayer.overhead + size;
            const allocator = heap.smp_allocator;
            const records = allocator.alloc(u8, 4096 * record_len) catch unreachable;
            defer allocator.free(records);

            var plaintext: [size]u8 = @splat(0xcd);
            var tx: RecordLayer = RecordLayer.init(suite.aead(), .zero) catch unreachable;
            defer tx.deinit();
            for (0..4096) |i| {
                const record = tx.encrypt(
                    .application_data,
                    &plaintext,
                    records[i * record_len ..][0..record_len],
                ) catch unreachable;
                assert(record.len == record_len);
            }

            var rx: RecordLayer = RecordLayer.init(suite.aead(), .zero) catch unreachable;
            defer rx.deinit();

            var warm_record: [record_len]u8 = undefined;
            var warm_tx: RecordLayer = RecordLayer.init(suite.aead(), .zero) catch unreachable;
            defer warm_tx.deinit();
            var warm_rx: RecordLayer = RecordLayer.init(suite.aead(), .zero) catch unreachable;
            defer warm_rx.deinit();
            const warm = warm_tx.encrypt(
                .application_data,
                &plaintext,
                &warm_record,
            ) catch unreachable;
            _ = warm_rx.decrypt(warm) catch unreachable;

            b.setBytes(size);
            var idx: usize = 0;
            while (try b.loop()) {
                const decrypted = rx.decrypt(
                    records[idx * record_len ..][0..record_len],
                ) catch unreachable;
                b.keepAlive(decrypted.content.ptr);
                idx = (idx + 1) % 4096;
            }
        }
    }.benchFn;
}

pub fn benchmarkRecordDecrypt(b: *bench.B) !void {
    var name_buf: [80]u8 = undefined;
    inline for (all_suites) |suite| {
        inline for (sizes) |size| {
            const name = try nameBuf(&name_buf, suite, size);
            _ = try b.run(name, benchDecrypt(suite, size));
        }
    }
}

fn benchEncryptPrepared(comptime suite: Suite, comptime size: usize) bench.Function {
    return struct {
        pub fn benchFn(b: *bench.B) !void {
            var out: [RecordLayer.overhead + size]u8 = undefined;
            var tx: RecordLayer = RecordLayer.init(suite.aead(), Iv.zero) catch unreachable;
            defer tx.deinit();
            out[frame.header_len..][0..size].* = @splat(0xab);

            for (0..32) |_| _ = tx.encryptPrepared(.application_data, size, &out) catch unreachable;

            b.setBytes(size);
            while (try b.loop()) {
                const record = tx.encryptPrepared(.application_data, size, &out) catch unreachable;
                b.keepAlive(record.ptr);
            }
        }
    }.benchFn;
}

pub fn benchmarkRecordEncryptPrepared(b: *bench.B) !void {
    var name_buf: [80]u8 = undefined;
    inline for (all_suites) |suite| {
        inline for (sizes) |size| {
            const name = try nameBuf(&name_buf, suite, size);
            _ = try b.run(name, benchEncryptPrepared(suite, size));
        }
    }
}

const Direction = enum { client_to_server, server_to_client };

fn benchZtlsAppData(
    comptime suite: Suite,
    comptime size: usize,
    comptime direction: Direction,
) bench.Function {
    return struct {
        pub fn benchFn(b: *bench.B) !void {
            var pair = connectPair(suite) catch unreachable;
            defer pair.client.deinit();
            defer pair.server.deinit();
            var payload: [size]u8 = @splat(0xa5);
            var wire: [RecordLayer.overhead + size]u8 = undefined;
            var out: [RecordLayer.overhead + size]u8 = undefined;

            b.setBytes(size);
            while (try b.loop()) switch (direction) {
                .client_to_server => {
                    const record = pair.client.sendApplicationData(
                        &payload,
                        &wire,
                    ) catch unreachable;
                    pair.client.completeWrite();
                    const plain = pair.server.receiveApplicationData(
                        wire[0..record.len],
                    ) catch unreachable;
                    b.keepAlive(plain.ptr);
                },
                .server_to_client => {
                    const record = pair.server.sendApplicationData(
                        &payload,
                        &wire,
                    ) catch unreachable;
                    pair.server.completeWrite();
                    const ev = pair.client.handleRecord(
                        wire[0..record.len],
                        &out,
                    ) catch unreachable;
                    b.keepAlive(ev.application_data.ptr);
                },
            };
        }
    }.benchFn;
}

pub fn benchmarkAppClientToServer(b: *bench.B) !void {
    var name_buf: [80]u8 = undefined;
    inline for (all_suites) |suite| {
        inline for (sizes) |size| {
            const name = try std.fmt.bufPrint(
                &name_buf,
                "impl=ztls/suite={s}/size={d}",
                .{ suite.name(), size },
            );
            _ = try b.run(name, benchZtlsAppData(suite, size, .client_to_server));
        }
    }
}

pub fn benchmarkAppServerToClient(b: *bench.B) !void {
    var name_buf: [80]u8 = undefined;
    inline for (all_suites) |suite| {
        inline for (sizes) |size| {
            const name = try std.fmt.bufPrint(
                &name_buf,
                "impl=ztls/suite={s}/size={d}",
                .{ suite.name(), size },
            );
            _ = try b.run(name, benchZtlsAppData(suite, size, .server_to_client));
        }
    }
}

fn benchZtlsAppDataPrepared(comptime suite: Suite, comptime size: usize) bench.Function {
    return struct {
        pub fn benchFn(b: *bench.B) !void {
            var pair = connectPair(suite) catch unreachable;
            defer pair.client.deinit();
            defer pair.server.deinit();
            var wire: [RecordLayer.overhead + size]u8 = undefined;
            wire[frame.header_len..][0..size].* = @splat(0xa5);

            b.setBytes(size);
            while (try b.loop()) {
                const record = pair.client.sendPreparedApplicationData(
                    size,
                    &wire,
                ) catch unreachable;
                pair.client.completeWrite();
                const plain = pair.server.receiveApplicationData(
                    wire[0..record.len],
                ) catch unreachable;
                b.keepAlive(plain.ptr);
            }
        }
    }.benchFn;
}

pub fn benchmarkAppPreparedClientToServer(b: *bench.B) !void {
    var name_buf: [80]u8 = undefined;
    inline for (all_suites) |suite| {
        inline for (sizes) |size| {
            const name = try nameBuf(&name_buf, suite, size);
            _ = try b.run(name, benchZtlsAppDataPrepared(suite, size));
        }
    }
}

fn benchZtlsPingPong(comptime suite: Suite, comptime size: usize) bench.Function {
    return struct {
        pub fn benchFn(b: *bench.B) !void {
            var pair = connectPair(suite) catch unreachable;
            defer pair.client.deinit();
            defer pair.server.deinit();
            var payload: [size]u8 = @splat(0x5a);
            var client_wire: [RecordLayer.overhead + size]u8 = undefined;
            var server_wire: [RecordLayer.overhead + size]u8 = undefined;
            var client_out: [RecordLayer.overhead + size]u8 = undefined;

            b.setBytes(size * 2);
            while (try b.loop()) {
                const c = pair.client.sendApplicationData(&payload, &client_wire) catch unreachable;
                pair.client.completeWrite();
                const got = pair.server.receiveApplicationData(
                    client_wire[0..c.len],
                ) catch unreachable;
                b.keepAlive(got.ptr);

                const s = pair.server.sendApplicationData(&payload, &server_wire) catch unreachable;
                pair.server.completeWrite();
                const ev = pair.client.handleRecord(
                    server_wire[0..s.len],
                    &client_out,
                ) catch unreachable;
                b.keepAlive(ev.application_data.ptr);
            }
        }
    }.benchFn;
}

pub fn benchmarkAppPingPong(b: *bench.B) !void {
    var name_buf: [80]u8 = undefined;
    inline for (all_suites) |suite| {
        inline for (sizes) |size| {
            const name = try std.fmt.bufPrint(
                &name_buf,
                "impl=ztls/suite={s}/size={d}",
                .{ suite.name(), size },
            );
            _ = try b.run(name, benchZtlsPingPong(suite, size));
        }
    }
}
