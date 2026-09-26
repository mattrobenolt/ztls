//! Minimal TLS 1.3 HTTPS client with certificate verification.
//!
//! Connects to 127.0.0.1:8443, verifies the server certificate against a
//! caller-owned policy (hostname + validity time + signature chain), then
//! sends an HTTP/1.0 GET request and prints the decrypted response.
//!
//! Run this after starting the server:
//!     zig build example-https_server
//!
//! Or use `example-tcp_loopback` for a single-process client+server proof.
//! If no peer is listening, this example exits non-zero instead of pretending
//! it proved TLS.
const std = @import("std");
const Io = std.Io;
const print = std.debug.print;
const CertificateBundle = std.crypto.Certificate.Bundle;

const fixtures = @import("fixtures");
const ztls = @import("ztls");

const IpAddress = Io.net.IpAddress;

const trust_anchor_der: []const u8 = &fixtures.server_ecdsa_cert_der;
const connect_host = "127.0.0.1";
const server_name = "ztls.server.test";
const port: u16 = 8443;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const gpa = init.gpa;
    const addr: IpAddress = try .parse(connect_host, port);
    const stream = addr.connect(io, .{ .mode = .stream }) catch |err| switch (err) {
        error.ConnectionRefused => {
            print("[https]  could not connect to {s}:{d}\n", .{ connect_host, port });
            print("         Start the server first: zig build example-https_server\n", .{});
            return error.NoPeerAvailable;
        },
        else => return err,
    };
    defer stream.close(io);
    print("[https]  connected to {s}:{d}\n", .{ connect_host, port });

    const client_keypair: ztls.x25519.KeyPair = .generate();
    var random: ztls.Random = .empty;
    io.random(&random.data);

    var hs: ztls.ClientHandshake = .init(.{
        .keypairs = try .init(client_keypair),
        .host_name = server_name,
        .now_sec = Io.Timestamp.now(io, .real).toSeconds(),
        .random = random,
        .alpn_protocols = &.{"http/1.1"},
    });
    defer hs.deinit();

    // Certificate verification policy: pinned trust anchor.
    // This is example-wrapper allocation, not ztls core allocation.
    var bundle: CertificateBundle = .empty;
    defer bundle.deinit(gpa);
    const cert_start: u32 = @intCast(bundle.bytes.items.len);
    try bundle.bytes.appendSlice(gpa, trust_anchor_der);
    try bundle.parseCert(gpa, cert_start, hs.policy.now_sec);
    hs.policy.bundle = &bundle;

    var out: ztls.ClientHandshake.OutBuffer = .empty;
    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);

    try ztls.io.writeAll(io, stream, try hs.start(&out.buffer));
    hs.completeWrite();
    print("[https]  ClientHello sent → state={s}\n", .{@tagName(hs.state)});

    while (!hs.isConnected()) {
        const n = try ztls.io.fill(io, stream, &rb);
        if (n == 0) return error.ServerClosed;
        rb.advance(n);
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out.buffer)) {
            .write => |w| {
                try ztls.io.writeAll(io, stream, w);
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
    print("[https]  handshake complete (ALPN={s})\n", .{hs.selectedAlpnProtocol().?});

    const request = "GET / HTTP/1.0\r\n\r\n";
    try ztls.io.writeAll(io, stream, try hs.sendApplicationData(request, &out.buffer));
    hs.completeWrite();
    print("[https]  sent: {s}", .{request});

    var response_seen = false;
    while (true) {
        const n = try ztls.io.fill(io, stream, &rb);
        if (n == 0) break;
        rb.advance(n);
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out.buffer)) {
            .application_data => |data| {
                print("[https]  received: {s}\n", .{data});
                response_seen = true;
            },
            .write => |w| {
                try ztls.io.writeAll(io, stream, w);
                hs.completeWrite();
            },
            .closed => {
                print("[https]  server sent close_notify\n", .{});
                return;
            },
            .key_update => |ku| {
                if (ku.response) |w| {
                    try ztls.io.writeAll(io, stream, w);
                    hs.completeWrite();
                }
            },
            .new_session_ticket => {},
            .none => {},
        };
    }

    if (!response_seen) {
        print("[https]  no application data received before EOF\n", .{});
        return error.NoApplicationData;
    }
}
