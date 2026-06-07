//! Linux io_uring TLS 1.3 HTTPS client proof.
//!
//! This example keeps ztls Sans-I/O: io_uring only drives the socket edge.
//! TLS records still move through RecordBuffer and ClientHandshake, and every
//! emitted TLS record calls completeWrite() after the io_uring send completes.
const std = @import("std");
const IoUring = std.os.linux.IoUring;
const print = std.debug.print;
const builtin = @import("builtin");

const ztls = @import("ztls");

comptime {
    if (builtin.os.tag != .linux) @compileError("iouring_client is Linux-only");
}

const connect_host = "127.0.0.1";
const server_name = "ztls.server.test";
const port: u16 = 8443;
const trust_anchor_pem = "tests/fixtures/server-ecdsa/server.crt";

const IoError = error{ IoUringFailed, PeerClosed };

var debug_allocator: std.heap.DebugAllocator(.{}) = .init;

pub fn main() !void {
    const gpa = debug_allocator.allocator();
    defer _ = debug_allocator.deinit();
    var ring = IoUring.init(8, 0) catch |err| switch (err) {
        error.PermissionDenied, error.SystemOutdated => {
            print("[iouring] io_uring unavailable: {}\n", .{err});
            return;
        },
        else => return err,
    };
    defer ring.deinit();

    const addr = try std.net.Address.parseIp(connect_host, port);
    const stream = std.net.tcpConnectToAddress(addr) catch |err| switch (err) {
        error.ConnectionRefused => {
            print("[iouring] could not connect to {s}:{d}\n", .{ connect_host, port });
            print("           Start the server first: zig build example-https_server\n", .{});
            return;
        },
        else => return err,
    };
    defer stream.close();
    print("[iouring] connected to {s}:{d}\n", .{ connect_host, port });

    const client_keypair: ztls.x25519.KeyPair = .generate();
    var hs: ztls.ClientHandshake = .init(client_keypair);
    hs.offerAlpn(&.{"http/1.1"});

    hs.policy.host_name = server_name;
    hs.policy.now_sec = std.time.timestamp();
    var bundle: std.crypto.Certificate.Bundle = .{};
    defer bundle.deinit(gpa);
    try bundle.addCertsFromFilePath(gpa, std.fs.cwd(), trust_anchor_pem);
    hs.policy.bundle = &bundle;

    var random: ztls.client_hello.Random = undefined;
    std.crypto.random.bytes(&random.data);
    var out: ztls.ClientHandshake.OutBuffer = .empty;
    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);

    try sendAll(&ring, stream.handle, try hs.start(&out.buffer, random, server_name));
    hs.completeWrite();
    print("[iouring] ClientHello sent → state={s}\n", .{@tagName(hs.state)});

    while (!hs.isConnected()) {
        const n = try recvIntoRecordBuffer(&ring, stream.handle, &rb);
        if (n == 0) return error.PeerClosed;
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out.buffer)) {
            .write => |w| {
                try sendAll(&ring, stream.handle, w);
                hs.completeWrite();
            },
            .application_data, .closed => return error.UnexpectedDuringHandshake,
            .none => {},
        };
    }
    print("[iouring] handshake complete (ALPN={s})\n", .{hs.selectedAlpnProtocol().?});

    const request = "GET / HTTP/1.0\r\n\r\n";
    try sendAll(&ring, stream.handle, try hs.sendApplicationData(request, &out.buffer));
    hs.completeWrite();
    print("[iouring] sent: {s}", .{request});

    var response_seen = false;
    while (true) {
        const n = try recvIntoRecordBuffer(&ring, stream.handle, &rb);
        if (n == 0) break;
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out.buffer)) {
            .application_data => |data| {
                print("[iouring] received: {s}\n", .{data});
                response_seen = true;
            },
            .write => |w| {
                try sendAll(&ring, stream.handle, w);
                hs.completeWrite();
            },
            .closed => {
                print("[iouring] server sent close_notify\n", .{});
                return;
            },
            .none => {},
        };
    }

    if (!response_seen) print("[iouring] warning: no application data before EOF\n", .{});
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
