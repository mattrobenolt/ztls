//! Linux io_uring TLS 1.3 HTTPS client proof.
//!
//! This example keeps ztls Sans-I/O: io_uring only drives the socket edge.
//! TLS records still move through RecordBuffer and ClientHandshake, and every
//! emitted TLS record calls completeWrite() after the io_uring send completes.
//! If io_uring or the peer is unavailable, this example exits non-zero instead
//! of pretending it proved TLS.
const std = @import("std");
const Io = std.Io;
const IoUring = std.os.linux.IoUring;
const print = std.debug.print;
const posix = std.posix;
const crypto = std.crypto;
const builtin = @import("builtin");

const IpAddress = Io.net.IpAddress;

const ztls = @import("ztls");

const fixtures = @import("fixtures");

const trust_anchor_der: []const u8 = &fixtures.server_ecdsa_cert_der;

comptime {
    if (builtin.os.tag != .linux) @compileError("iouring_client is Linux-only");
}

const connect_host = "127.0.0.1";
const server_name = "ztls.server.test";
const port: u16 = 8443;

const IoError = error{ IoUringFailed, PeerClosed };

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const gpa = init.gpa;
    var ring = IoUring.init(8, 0) catch |err| switch (err) {
        error.PermissionDenied, error.SystemOutdated => {
            print("[iouring] io_uring unavailable: {}\n", .{err});
            return error.IoUringUnavailable;
        },
        else => return err,
    };
    defer ring.deinit();

    const addr: IpAddress = try .parse(connect_host, port);
    const stream = addr.connect(io, .{ .mode = .stream }) catch |err| switch (err) {
        error.ConnectionRefused => {
            print("[iouring] could not connect to {s}:{d}\n", .{ connect_host, port });
            print("           Start the server first: zig build example-https_server\n", .{});
            return error.NoPeerAvailable;
        },
        else => return err,
    };
    defer stream.close(io);
    print("[iouring] connected to {s}:{d}\n", .{ connect_host, port });

    const client_keypair: ztls.x25519.KeyPair = .generate();
    var random: ztls.Random = undefined;
    io.random(&random.data);

    var hs: ztls.ClientHandshake = .init(.{
        .keypairs = try .init(client_keypair),
        .host_name = server_name,
        .now_sec = Io.Timestamp.now(io, .real).toSeconds(),
        .random = random,
        .alpn_protocols = &.{"http/1.1"},
    });
    defer hs.deinit();

    // Certificate verification: pinned trust anchor for the test server.
    // This is example-wrapper allocation, not ztls core allocation.
    var bundle: crypto.Certificate.Bundle = .empty;
    defer bundle.deinit(gpa);
    const cert_start: u32 = @intCast(bundle.bytes.items.len);
    try bundle.bytes.appendSlice(gpa, trust_anchor_der);
    try bundle.parseCert(gpa, cert_start, hs.policy.now_sec);
    hs.policy.bundle = &bundle;

    var out: ztls.ClientHandshake.OutBuffer = .empty;
    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);

    try sendAll(&ring, stream.socket.handle, try hs.start(&out.buffer));
    hs.completeWrite();
    print("[iouring] ClientHello sent → state={s}\n", .{@tagName(hs.state)});

    while (!hs.isConnected()) {
        const n = try recvIntoRecordBuffer(&ring, stream.socket.handle, &rb);
        if (n == 0) return error.PeerClosed;
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out.buffer)) {
            .write => |w| {
                try sendAll(&ring, stream.socket.handle, w);
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
    print("[iouring] handshake complete (ALPN={s})\n", .{hs.selectedAlpnProtocol().?});

    const request = "GET / HTTP/1.0\r\n\r\n";
    try sendAll(&ring, stream.socket.handle, try hs.sendApplicationData(request, &out.buffer));
    hs.completeWrite();
    print("[iouring] sent: {s}", .{request});

    var response_seen = false;
    while (true) {
        const n = try recvIntoRecordBuffer(&ring, stream.socket.handle, &rb);
        if (n == 0) break;
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out.buffer)) {
            .application_data => |data| {
                print("[iouring] received: {s}\n", .{data});
                response_seen = true;
            },
            .write => |w| {
                try sendAll(&ring, stream.socket.handle, w);
                hs.completeWrite();
            },
            .closed => {
                print("[iouring] server sent close_notify\n", .{});
                return;
            },
            .key_update => |ku| {
                if (ku.response) |w| {
                    try sendAll(&ring, stream.socket.handle, w);
                    hs.completeWrite();
                }
            },
            .new_session_ticket => {},
            .none => {},
        };
    }

    if (!response_seen) {
        print("[iouring] no application data before EOF\n", .{});
        return error.NoApplicationData;
    }
}

fn sendAll(ring: *IoUring, fd: posix.fd_t, bytes: []const u8) !void {
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

fn recvIntoRecordBuffer(ring: *IoUring, fd: posix.fd_t, rb: *ztls.RecordBuffer) !usize {
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
