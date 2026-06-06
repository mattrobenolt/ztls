const std = @import("std");
const assert = std.debug.assert;
const mem = std.mem;
const doNotOptimizeAway = mem.doNotOptimizeAway;
const builtin = @import("builtin");

const txtar = @import("txtar");
const ztls = @import("ztls");
const Aead = ztls.aead.Aead;
const Iv = ztls.aead.Iv;
const RecordBuffer = ztls.RecordBuffer;
const RecordLayer = ztls.RecordLayer;
const frame = ztls.frame;

const rfc8448 = @import("rfc8448.zig");

const sizes = [_]usize{ 16, 128, 1350, 8192, frame.max_plaintext_len };
const target_bytes: usize = 16 * 1024 * 1024;
const handshake_iterations = 256;
const ztls_handshake_iterations = 64;
const openssl_replay_archive = @embedFile("test_fixtures/openssl_replay.txtar");
const server_cert_der = @embedFile("test_fixtures/server-ecdsa/server.der");
const server_scalar = @embedFile("test_fixtures/server-ecdsa/scalar.bin");
const EcdsaP256Sha256 = std.crypto.sign.ecdsa.EcdsaP256Sha256;

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
            .aes_128_gcm_sha256 => .{ .aes128_gcm = .init(@splat(0x11)) },
            .aes_256_gcm_sha384 => .{ .aes256_gcm = .init(@splat(0x22)) },
            .chacha20_poly1305_sha256 => .{ .chacha20_poly1305 = .init(@splat(0x33)) },
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

const Args = struct {
    filter: ?[]const u8 = null,
    list: bool = false,
};

const Result = struct {
    bytes: usize,
    iterations: usize,
    ns: u64,

    fn mbPerSec(self: Result) f64 {
        const mib = @as(f64, @floatFromInt(self.bytes)) / (1024.0 * 1024.0);
        const sec = @as(f64, @floatFromInt(self.ns)) / std.time.ns_per_s;
        return mib / sec;
    }

    fn opsPerSec(self: Result) f64 {
        const sec = @as(f64, @floatFromInt(self.ns)) / std.time.ns_per_s;
        return @as(f64, @floatFromInt(self.iterations)) / sec;
    }
};

pub fn main() !void {
    const args = try parseArgs();

    var stdout_buf: [4096]u8 = undefined;
    var stdout_file = std.fs.File.stdout().writer(&stdout_buf);
    const stdout = &stdout_file.interface;
    defer stdout.flush() catch {};

    try stdout.print("# ztls record protection benchmark\n", .{});
    try stdout.print("# zig {s}\n", .{builtin.zig_version_string});
    try stdout.print("# arch {s}\n", .{@tagName(builtin.cpu.arch)});
    try stdout.print("# os {s}\n", .{@tagName(builtin.os.tag)});
    try stdout.print("# cpu {s}\n", .{builtin.cpu.model.name});
    try stdout.print("# optimize {s}\n", .{@tagName(builtin.mode)});
    try stdout.print("# crypto {s}\n", .{@tagName(ztls.aead.backend)});
    try stdout.print("benchmark,suite,size,iterations,bytes,elapsed_ns,mib_per_sec\n", .{});
    try stdout.flush();

    if (args.list) return listBenchmarks(stdout);

    var timer = try std.time.Timer.start();

    if (matches(args.filter, "parse_header", "none")) {
        const header = benchParseHeader(&timer);
        try stdout.print("parse_header,none,{d},{d},{d},{d},{d:.2}\n", .{
            frame.header_len,
            header.iterations,
            header.bytes,
            header.ns,
            header.mbPerSec(),
        });
        try stdout.flush();
    }

    if (matches(args.filter, "record_buffer_next", "none")) {
        const records = try benchRecordBuffer(&timer);
        try stdout.print("record_buffer_next,none,{d},{d},{d},{d},{d:.2}\n", .{
            frame.header_len,
            records.iterations,
            records.bytes,
            records.ns,
            records.mbPerSec(),
        });
        try stdout.flush();
    }

    inline for (.{ Suite.aes_128_gcm_sha256, Suite.aes_256_gcm_sha384, Suite.chacha20_poly1305_sha256 }) |suite| {
        if (matches(args.filter, "client_handshake_replay", suite.name())) {
            const replay = try benchClientHandshakeReplay(suite, &timer);
            try stdout.print("client_handshake_replay,{s},{d},{d},{d},{d},{d:.2}\n", .{
                suite.name(),
                replay.bytes / replay.iterations,
                replay.iterations,
                replay.bytes,
                replay.ns,
                replay.opsPerSec(),
            });
            try stdout.flush();
        }

        if (matches(args.filter, "ztls_handshake", suite.name())) {
            const full = try benchZtlsHandshake(suite, &timer);
            try stdout.print("ztls_handshake,{s},{d},{d},{d},{d},{d:.2}\n", .{
                suite.name(),
                full.bytes / full.iterations,
                full.iterations,
                full.bytes,
                full.ns,
                full.opsPerSec(),
            });
            try stdout.flush();
        }
    }

    inline for (.{ Suite.aes_128_gcm_sha256, Suite.aes_256_gcm_sha384, Suite.chacha20_poly1305_sha256 }) |suite| {
        inline for (sizes) |size| {
            if (matches(args.filter, "record_encrypt", suite.name())) {
                const enc = try benchEncrypt(suite, size, &timer);
                try stdout.print("record_encrypt,{s},{d},{d},{d},{d},{d:.2}\n", .{
                    suite.name(),
                    size,
                    enc.iterations,
                    enc.bytes,
                    enc.ns,
                    enc.mbPerSec(),
                });
                try stdout.flush();
            }

            if (matches(args.filter, "record_decrypt", suite.name())) {
                const dec = try benchDecrypt(suite, size, &timer);
                try stdout.print("record_decrypt,{s},{d},{d},{d},{d},{d:.2}\n", .{
                    suite.name(),
                    size,
                    dec.iterations,
                    dec.bytes,
                    dec.ns,
                    dec.mbPerSec(),
                });
                try stdout.flush();
            }

            if (matches(args.filter, "ztls_app_client_to_server", suite.name())) {
                const c2s = try benchZtlsAppData(suite, size, .client_to_server, &timer);
                try stdout.print("ztls_app_client_to_server,{s},{d},{d},{d},{d},{d:.2}\n", .{
                    suite.name(),
                    size,
                    c2s.iterations,
                    c2s.bytes,
                    c2s.ns,
                    c2s.mbPerSec(),
                });
                try stdout.flush();
            }

            if (matches(args.filter, "ztls_app_server_to_client", suite.name())) {
                const s2c = try benchZtlsAppData(suite, size, .server_to_client, &timer);
                try stdout.print("ztls_app_server_to_client,{s},{d},{d},{d},{d},{d:.2}\n", .{
                    suite.name(),
                    size,
                    s2c.iterations,
                    s2c.bytes,
                    s2c.ns,
                    s2c.mbPerSec(),
                });
                try stdout.flush();
            }

            if (matches(args.filter, "ztls_app_ping_pong", suite.name())) {
                const ping_pong = try benchZtlsPingPong(suite, size, &timer);
                try stdout.print("ztls_app_ping_pong,{s},{d},{d},{d},{d},{d:.2}\n", .{
                    suite.name(),
                    size,
                    ping_pong.iterations,
                    ping_pong.bytes,
                    ping_pong.ns,
                    ping_pong.mbPerSec(),
                });
                try stdout.flush();
            }
        }
    }
}

fn parseArgs() !Args {
    var result: Args = .{};
    var it = std.process.args();
    _ = it.next();
    while (it.next()) |arg| {
        if (mem.eql(u8, arg, "--list")) {
            result.list = true;
        } else if (mem.eql(u8, arg, "--filter")) {
            result.filter = it.next() orelse return error.MissingFilter;
        } else if (mem.startsWith(u8, arg, "--filter=")) {
            result.filter = arg["--filter=".len..];
        } else {
            return error.UnknownArgument;
        }
    }
    return result;
}

fn matches(filter: ?[]const u8, benchmark: []const u8, suite: []const u8) bool {
    const f = filter orelse return true;
    return std.ascii.indexOfIgnoreCase(benchmark, f) != null or std.ascii.indexOfIgnoreCase(suite, f) != null;
}

fn listBenchmarks(stdout: *std.Io.Writer) !void {
    try stdout.print("parse_header,none\n", .{});
    try stdout.print("record_buffer_next,none\n", .{});
    inline for (.{ Suite.aes_128_gcm_sha256, Suite.aes_256_gcm_sha384, Suite.chacha20_poly1305_sha256 }) |suite| {
        try stdout.print("client_handshake_replay,{s}\n", .{suite.name()});
        try stdout.print("ztls_handshake,{s}\n", .{suite.name()});
    }
    inline for (.{ Suite.aes_128_gcm_sha256, Suite.aes_256_gcm_sha384, Suite.chacha20_poly1305_sha256 }) |suite| {
        try stdout.print("record_encrypt,{s}\n", .{suite.name()});
        try stdout.print("record_decrypt,{s}\n", .{suite.name()});
        try stdout.print("ztls_app_client_to_server,{s}\n", .{suite.name()});
        try stdout.print("ztls_app_server_to_client,{s}\n", .{suite.name()});
        try stdout.print("ztls_app_ping_pong,{s}\n", .{suite.name()});
    }
}

fn benchParseHeader(timer: *std.time.Timer) Result {
    const iterations = 64 * 1024 * 1024;
    const record = [_]u8{ 0x17, 0x03, 0x03, 0x00, 0x16 } ++ [_]u8{0} ** 22;

    timer.reset();
    for (0..iterations) |_| {
        const header = frame.parseHeader(&record) catch unreachable;
        doNotOptimizeAway(header);
    }
    const ns = timer.read();

    return .{ .bytes = iterations * frame.header_len, .iterations = iterations, .ns = ns };
}

fn benchRecordBuffer(timer: *std.time.Timer) !Result {
    const iterations = 8 * 1024 * 1024;
    const record = [_]u8{ 0x17, 0x03, 0x03, 0x00, 0x01, 0x00 };
    var storage: [RecordBuffer.min_storage]u8 = undefined;

    timer.reset();
    for (0..iterations) |_| {
        var rb: RecordBuffer = .init(&storage);
        @memcpy(rb.writable()[0..record.len], &record);
        rb.advance(record.len);
        const next = (try rb.next()).?;
        doNotOptimizeAway(next.ptr);
    }
    const ns = timer.read();

    return .{ .bytes = iterations * record.len, .iterations = iterations, .ns = ns };
}

fn benchClientHandshakeReplay(comptime suite: Suite, timer: *std.time.Timer) !Result {
    var fixture_scratch: [8192]u8 = undefined;
    var fba: std.heap.FixedBufferAllocator = .init(&fixture_scratch);
    var records_buf: [2048]u8 = undefined;
    const records = try fixture(fba.allocator(), suite.fixtureName(), &records_buf);

    var out: [1024]u8 = undefined;

    // Warm up certificate parsing/signature verification and code paths once.
    try replayHandshake(records, &out);

    timer.reset();
    for (0..handshake_iterations) |_| {
        try replayHandshake(records, &out);
    }
    const ns = timer.read();

    const bytes_per_replay = try clientHelloLen() + records.len;
    return .{ .bytes = bytes_per_replay * handshake_iterations, .iterations = handshake_iterations, .ns = ns };
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

fn clientHelloLen() !usize {
    var hs: ztls.ClientHandshake = .init(rfc8448.client_keypair);
    var out: [512]u8 = undefined;
    return (try hs.start(&out, rfc8448.client_random, rfc8448.replay_host_name)).len;
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

fn benchEncrypt(comptime suite: Suite, comptime size: usize, timer: *std.time.Timer) !Result {
    const iterations = @max(256, target_bytes / size);
    var plaintext: [size]u8 = @splat(0xab);
    var out: [RecordLayer.overhead + size]u8 = undefined;
    var tx: RecordLayer = try .init(suite.aead(), Iv.zero);
    defer tx.deinit();

    // Warm up without measuring first-use effects.
    for (0..32) |_| _ = try tx.encrypt(.application_data, &plaintext, &out);

    timer.reset();
    for (0..iterations) |_| {
        const record = try tx.encrypt(.application_data, &plaintext, &out);
        doNotOptimizeAway(record.ptr);
    }
    const ns = timer.read();

    return .{ .bytes = iterations * size, .iterations = iterations, .ns = ns };
}

fn benchDecrypt(comptime suite: Suite, comptime size: usize, timer: *std.time.Timer) !Result {
    const iterations = @max(256, target_bytes / size);
    const record_len = RecordLayer.overhead + size;
    const allocator = std.heap.smp_allocator;
    const records = try allocator.alloc(u8, iterations * record_len);
    defer allocator.free(records);

    var plaintext: [size]u8 = @splat(0xcd);

    var tx: RecordLayer = try .init(suite.aead(), .zero);
    defer tx.deinit();
    for (0..iterations) |i| {
        const record = try tx.encrypt(.application_data, &plaintext, records[i * record_len ..][0..record_len]);
        assert(record.len == record_len);
    }

    var rx: RecordLayer = try .init(suite.aead(), .zero);
    defer rx.deinit();

    // Warm up using a separate one-record layer so the measured sequence stays aligned.
    var warm_record: [record_len]u8 = undefined;
    var warm_tx: RecordLayer = try .init(suite.aead(), .zero);
    defer warm_tx.deinit();
    var warm_rx: RecordLayer = try .init(suite.aead(), .zero);
    defer warm_rx.deinit();
    const warm = try warm_tx.encrypt(.application_data, &plaintext, &warm_record);
    _ = try warm_rx.decrypt(warm);

    timer.reset();
    for (0..iterations) |i| {
        const decrypted = try rx.decrypt(records[i * record_len ..][0..record_len]);
        doNotOptimizeAway(decrypted.content.ptr);
    }
    const ns = timer.read();

    return .{ .bytes = iterations * size, .iterations = iterations, .ns = ns };
}

const Direction = enum { client_to_server, server_to_client };

const BenchSigner = struct {
    keypair: EcdsaP256Sha256.KeyPair,

    fn sign(context: *anyopaque, msg: []const u8, out: []u8) ztls.ServerHandshake.SignError![]const u8 {
        const self: *BenchSigner = @ptrCast(@alignCast(context));
        const sig = self.keypair.sign(msg, null) catch |err| switch (err) {
            error.IdentityElement => return error.IdentityElement,
            error.NonCanonical => return error.NonCanonical,
        };
        var der: [EcdsaP256Sha256.Signature.der_encoded_length_max]u8 = undefined;
        const encoded = sig.toDer(&der);
        if (out.len < encoded.len) return error.BufferTooShort;
        @memcpy(out[0..encoded.len], encoded);
        return out[0..encoded.len];
    }
};

fn deterministicClientKeypair() !ztls.x25519.KeyPair {
    return try ztls.x25519.KeyPair.generateDeterministic([_]u8{0x11} ** 32);
}

fn deterministicServerKeypair() !ztls.x25519.KeyPair {
    return try ztls.x25519.KeyPair.generateDeterministic([_]u8{0x22} ** 32);
}

fn deterministicSigner() !BenchSigner {
    const sk = try EcdsaP256Sha256.SecretKey.fromBytes(server_scalar[0..32].*);
    return .{ .keypair = try EcdsaP256Sha256.KeyPair.fromSecretKey(sk) };
}

fn signerApi(signer: *BenchSigner) ztls.ServerHandshake.Signer {
    return .{ .scheme = .ecdsa_secp256r1_sha256, .context = signer, .sign = BenchSigner.sign };
}

fn connectPair(comptime suite: Suite) !struct { client: ztls.ClientHandshake, server: ztls.ServerHandshake } {
    var client: ztls.ClientHandshake = .init(try deterministicClientKeypair());
    client.policy.host_name = "ztls.server.test";
    var client_out: [4096]u8 = undefined;
    const ch_record = try client.start(&client_out, rfc8448.client_random, "ztls.server.test");
    client.completeWrite();

    var server: ztls.ServerHandshake = .init(try deterministicServerKeypair());
    const suites = [_]ztls.CipherSuite{suite.cipherSuite()};
    server.supportSuites(&suites);
    var server_out: [8192]u8 = undefined;
    const sh_record = try server.acceptClientHello(ch_record, rfc8448.client_random, &server_out);
    try client.processServerHello(sh_record[ztls.frame.header_len..]);

    var signer = try deterministicSigner();
    var plaintext: [8192]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(&.{server_cert_der}, signerApi(&signer), &plaintext, &server_out);
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

fn benchZtlsHandshake(comptime suite: Suite, timer: *std.time.Timer) !Result {
    try doZtlsHandshake(suite);

    timer.reset();
    for (0..ztls_handshake_iterations) |_| try doZtlsHandshake(suite);
    const ns = timer.read();

    return .{ .bytes = ztls_handshake_iterations, .iterations = ztls_handshake_iterations, .ns = ns };
}

fn doZtlsHandshake(comptime suite: Suite) !void {
    var pair = try connectPair(suite);
    defer pair.client.deinit();
    defer pair.server.deinit();
    doNotOptimizeAway(&pair.client);
    doNotOptimizeAway(&pair.server);
}

fn benchZtlsAppData(comptime suite: Suite, comptime size: usize, comptime direction: Direction, timer: *std.time.Timer) !Result {
    const iterations = @max(256, target_bytes / size);
    var pair = try connectPair(suite);
    defer pair.client.deinit();
    defer pair.server.deinit();
    var payload: [size]u8 = @splat(0xa5);
    var wire: [RecordLayer.overhead + size]u8 = undefined;
    var out: [RecordLayer.overhead + size]u8 = undefined;

    timer.reset();
    for (0..iterations) |_| switch (direction) {
        .client_to_server => {
            const record = try pair.client.sendApplicationData(&payload, &wire);
            pair.client.completeWrite();
            const plain = try pair.server.receiveApplicationData(wire[0..record.len]);
            doNotOptimizeAway(plain.ptr);
        },
        .server_to_client => {
            const record = try pair.server.sendApplicationData(&payload, &wire);
            pair.server.completeWrite();
            const ev = try pair.client.handleRecord(wire[0..record.len], &out);
            doNotOptimizeAway(ev.application_data.ptr);
        },
    };
    const ns = timer.read();

    return .{ .bytes = iterations * size, .iterations = iterations, .ns = ns };
}

fn benchZtlsPingPong(comptime suite: Suite, comptime size: usize, timer: *std.time.Timer) !Result {
    const iterations = @max(256, target_bytes / (size * 2));
    var pair = try connectPair(suite);
    defer pair.client.deinit();
    defer pair.server.deinit();
    var payload: [size]u8 = @splat(0x5a);
    var client_wire: [RecordLayer.overhead + size]u8 = undefined;
    var server_wire: [RecordLayer.overhead + size]u8 = undefined;
    var client_out: [RecordLayer.overhead + size]u8 = undefined;

    timer.reset();
    for (0..iterations) |_| {
        const c = try pair.client.sendApplicationData(&payload, &client_wire);
        pair.client.completeWrite();
        const got = try pair.server.receiveApplicationData(client_wire[0..c.len]);
        doNotOptimizeAway(got.ptr);

        const s = try pair.server.sendApplicationData(&payload, &server_wire);
        pair.server.completeWrite();
        const ev = try pair.client.handleRecord(server_wire[0..s.len], &client_out);
        doNotOptimizeAway(ev.application_data.ptr);
    }
    const ns = timer.read();

    return .{ .bytes = iterations * size * 2, .iterations = iterations, .ns = ns };
}
