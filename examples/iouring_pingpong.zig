//! TLS 1.3 io_uring client/server ping-pong over TCP loopback.
//!
//! This is the deterministic counterpart to `iouring_client.zig`: both peers
//! live in one process, the server binds an ephemeral loopback port, and all TLS
//! socket reads/writes use io_uring. Blocking `listen`/`accept`/`connect` setup
//! is intentionally boring; the point is proving ztls's Sans-I/O record driver
//! composes with io_uring for the TLS data path.
const std = @import("std");
const IoUring = std.os.linux.IoUring;
const print = std.debug.print;
const net = @import("net_compat.zig");
const Address = net.Address;
const builtin = @import("builtin");

const ztls = @import("ztls");

const shared_fixtures = @import("test_fixtures/shared_fixtures.zig");

comptime {
    if (builtin.os.tag != .linux) @compileError("iouring_pingpong is Linux-only");
}

// Test fixtures: ECDSA P-256 server certificate and signing scalar.
const cert_der: []const u8 = &shared_fixtures.server_ecdsa_cert_der;
const scalar: []const u8 = &shared_fixtures.server_ecdsa_scalar;

const host = "127.0.0.1";
const server_name = "ztls.server.test";
const port: u16 = 0;
const alpn = "pingpong";
const rounds = 4;

const IoError = error{ IoUringFailed, PeerClosed };

const ServerCtx = struct {
    listener: *net.Server,
    keypair: ztls.x25519.KeyPair,
};

pub fn main() !void {
    const client_keypair: ztls.x25519.KeyPair = .generate();
    const server_keypair: ztls.x25519.KeyPair = .generate();

    const addr: Address = try net.parseIp(host, port);
    // Loopback-only convenience so repeated CI/dev runs do not trip over
    // TIME_WAIT; don't cargo-cult this into public listener code.
    var server_listener = try net.listen(addr, .{ .reuse_address = true });
    defer net.deinitServer(&server_listener);
    const actual_port = net.serverPort(server_listener);
    print("[iouring] server listening on {s}:{d}\n", .{ host, actual_port });

    var sctx: ServerCtx = .{ .listener = &server_listener, .keypair = server_keypair };
    const server_thread: std.Thread = try .spawn(.{}, serverRun, .{&sctx});

    try clientRun(client_keypair, actual_port);

    server_thread.join();
    print("\n=== io_uring ping-pong OK ===\n", .{});
}

fn serverRun(ctx: *ServerCtx) !void {
    var ring: IoUring = try .init(8, 0);
    defer ring.deinit();

    const stream = try net.accept(ctx.listener);
    defer net.close(stream);
    print("[server] accepted connection\n", .{});

    var random: ztls.Random = undefined;
    net.fillRandom(&random.data);

    var hs: ztls.ServerHandshake = .init(.{
        .keypair = ctx.keypair,
        .random = random,
        .alpn_protocols = &.{alpn},
    });
    defer hs.deinit();

    var signer: ztls.signature.PrivateKey = try .fromP256Scalar(scalar[0..32]);
    defer signer.deinit();
    hs.setCredentials(&.{cert_der}, signer.signer());

    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);
    var out: ztls.ServerHandshake.OutBuffer = .empty;
    var flight: ztls.ServerHandshake.FlightBuffer = .empty;

    while (!hs.isConnected()) {
        const n = try recvIntoRecordBuffer(&ring, net.fd(stream), &rb);
        if (n == 0) return error.ClientClosed;
        while (try rb.next()) |record| {
            const ev = try hs.handleRecord(record, &out.buffer);
            switch (ev) {
                .write => |w| {
                    try sendAll(&ring, net.fd(stream), w);
                    hs.completeWrite();
                    if (try hs.sendServerFlightBuffered(&flight)) |flight_bytes| {
                        try sendAll(&ring, net.fd(stream), flight_bytes);
                        hs.completeWrite();
                    }
                },
                .none => {},
                .application_data, .closed => return error.UnexpectedDuringHandshake,
            }
        }
    }
    print("[server] handshake complete (ALPN={s})\n", .{hs.selectedAlpnProtocol().?});

    var round: usize = 1;
    var msg_buf: [64]u8 = undefined;
    while (true) {
        const n = try recvIntoRecordBuffer(&ring, net.fd(stream), &rb);
        if (n == 0) return error.ClientClosed;
        while (try rb.next()) |record| {
            const ev = try hs.handleRecord(record, &out.buffer);
            switch (ev) {
                .application_data => |data| {
                    if (!std.mem.eql(u8, data, ping(&msg_buf, round))) {
                        return error.UnexpectedPing;
                    }
                    const rec = try hs.sendApplicationData(pong(&msg_buf, round), &out.buffer);
                    try sendAll(&ring, net.fd(stream), rec);
                    hs.completeWrite();
                    round += 1;
                },
                .write => |w| {
                    try sendAll(&ring, net.fd(stream), w);
                    hs.completeWrite();
                },
                .closed => {
                    const close = try hs.sendAlert(.close_notify, &out.buffer);
                    try sendAll(&ring, net.fd(stream), close);
                    hs.completeWrite();
                    return;
                },
                .none => {},
            }
        }
    }
}

fn clientRun(client_keypair: ztls.x25519.KeyPair, actual_port: u16) !void {
    var ring: IoUring = try .init(8, 0);
    defer ring.deinit();

    const addr: Address = try net.parseIp(host, actual_port);
    const stream = try net.connect(addr);
    defer net.close(stream);
    print("[client] connected to {s}:{d}\n", .{ host, actual_port });

    var random: ztls.Random = undefined;
    net.fillRandom(&random.data);

    var hs: ztls.ClientHandshake = .init(.{
        .keypair = client_keypair,
        .host_name = server_name,
        .now_sec = net.timestamp(),
        .random = random,
        .insecure_no_chain_anchor = true,
        .alpn_protocols = &.{alpn},
    });
    defer hs.deinit();

    var out: ztls.ClientHandshake.OutBuffer = .empty;
    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);

    try sendAll(&ring, net.fd(stream), try hs.start(&out.buffer));
    hs.completeWrite();
    print("[client] ClientHello sent → state={s}\n", .{@tagName(hs.state)});

    while (!hs.isConnected()) {
        const n = try recvIntoRecordBuffer(&ring, net.fd(stream), &rb);
        if (n == 0) return error.ServerClosed;
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out.buffer)) {
            .write => |w| {
                try sendAll(&ring, net.fd(stream), w);
                hs.completeWrite();
            },
            .application_data, .closed => return error.UnexpectedDuringHandshake,
            .none => {},
        };
    }
    print("[client] handshake complete (ALPN={s})\n", .{hs.selectedAlpnProtocol().?});

    var msg_buf: [64]u8 = undefined;
    var round: usize = 1;
    const first = try hs.sendApplicationData(ping(&msg_buf, round), &out.buffer);
    try sendAll(&ring, net.fd(stream), first);
    hs.completeWrite();

    while (true) {
        const n = try recvIntoRecordBuffer(&ring, net.fd(stream), &rb);
        if (n == 0) return error.ServerClosed;
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out.buffer)) {
            .application_data => |data| {
                if (!std.mem.eql(u8, data, pong(&msg_buf, round))) {
                    return error.UnexpectedPong;
                }
                print("[client] received: {s}", .{data});
                if (round == rounds) {
                    const close = try hs.sendAlert(.close_notify, &out.buffer);
                    try sendAll(&ring, net.fd(stream), close);
                    hs.completeWrite();
                    return;
                }
                round += 1;
                const rec = try hs.sendApplicationData(ping(&msg_buf, round), &out.buffer);
                try sendAll(&ring, net.fd(stream), rec);
                hs.completeWrite();
            },
            .write => |w| {
                try sendAll(&ring, net.fd(stream), w);
                hs.completeWrite();
            },
            .closed => return,
            .none => {},
        };
    }
}

fn sendAll(ring: *IoUring, fd: std.posix.fd_t, bytes: []const u8) !void {
    var sent: usize = 0;
    while (sent < bytes.len) {
        _ = try ring.send(1, fd, bytes[sent..], 0);
        _ = try ring.submit();
        const cqe = try ring.copy_cqe();
        if (cqe.err() != .SUCCESS) return error.IoUringFailed;
        if (cqe.res == 0) return error.PeerClosed;
        sent += @intCast(cqe.res);
    }
}

fn recvIntoRecordBuffer(ring: *IoUring, fd: std.posix.fd_t, rb: *ztls.RecordBuffer) !usize {
    const writable = rb.writable();
    _ = try ring.recv(2, fd, .{ .buffer = writable }, 0);
    _ = try ring.submit();
    const cqe = try ring.copy_cqe();
    if (cqe.err() != .SUCCESS) return error.IoUringFailed;
    if (cqe.res == 0) return 0;
    const n: usize = @intCast(cqe.res);
    rb.advance(n);
    return n;
}

fn ping(buf: []u8, round: usize) []const u8 {
    return std.fmt.bufPrint(buf, "ping {d}\n", .{round}) catch unreachable;
}

fn pong(buf: []u8, round: usize) []const u8 {
    return std.fmt.bufPrint(buf, "pong {d}\n", .{round}) catch unreachable;
}
