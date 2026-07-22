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
const print = std.debug.print;
const CertificateBundle = std.crypto.Certificate.Bundle;

const fixtures = @import("fixtures");
const net = @import("net_compat");
const Address = net.Address;
const ztls = @import("ztls");

const trust_anchor_der: []const u8 = &fixtures.server_ecdsa_cert_der;
const connect_host = "127.0.0.1";
const server_name = "ztls.server.test";
const port: u16 = 8443;

var debug_allocator: std.heap.DebugAllocator(.{}) = .init;

pub fn main() !void {
    const gpa = debug_allocator.allocator();
    defer _ = debug_allocator.deinit();
    const addr: Address = try net.parseIp(connect_host, port);
    const stream = net.connect(addr) catch |err| switch (err) {
        error.ConnectionRefused => {
            print("[https]  could not connect to {s}:{d}\n", .{ connect_host, port });
            print("         Start the server first: zig build example-https_server\n", .{});
            return error.NoPeerAvailable;
        },
        else => return err,
    };
    defer net.close(stream);
    print("[https]  connected to {s}:{d}\n", .{ connect_host, port });

    const client_keypair: ztls.x25519.KeyPair = .generate();
    var random: ztls.Random = .empty;
    net.fillRandom(&random.data);

    var hs: ztls.ClientHandshake = .init(.{
        .keypairs = .init(client_keypair),
        .host_name = server_name,
        .now_sec = net.timestamp(),
        .random = random,
        .alpn_protocols = &.{"http/1.1"},
    });
    defer hs.deinit();

    // Certificate verification policy: pinned trust anchor.
    // This is example-wrapper allocation, not ztls core allocation.
    var bundle: CertificateBundle = if (@hasDecl(CertificateBundle, "empty"))
        .empty
    else
        .{};
    defer bundle.deinit(gpa);
    const cert_start: u32 = @intCast(bundle.bytes.items.len);
    try bundle.bytes.appendSlice(gpa, trust_anchor_der);
    try bundle.parseCert(gpa, cert_start, hs.policy.now_sec);
    hs.policy.bundle = &bundle;

    var out: ztls.ClientHandshake.OutBuffer = .empty;
    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);

    try net.writeAll(stream, try hs.start(&out.buffer));
    hs.completeWrite();
    print("[https]  ClientHello sent → state={s}\n", .{@tagName(hs.state)});

    while (!hs.isConnected()) {
        const n = try net.read(stream, rb.writable());
        if (n == 0) return error.ServerClosed;
        rb.advance(n);
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out.buffer)) {
            .write => |w| {
                try net.writeAll(stream, w);
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
    try net.writeAll(stream, try hs.sendApplicationData(request, &out.buffer));
    hs.completeWrite();
    print("[https]  sent: {s}", .{request});

    var response_seen = false;
    while (true) {
        const n = try net.read(stream, rb.writable());
        if (n == 0) break;
        rb.advance(n);
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out.buffer)) {
            .application_data => |data| {
                print("[https]  received: {s}\n", .{data});
                response_seen = true;
            },
            .write => |w| {
                try net.writeAll(stream, w);
                hs.completeWrite();
            },
            .closed => {
                print("[https]  server sent close_notify\n", .{});
                return;
            },
            .key_update => |ku| {
                if (ku.response) |w| {
                    try net.writeAll(stream, w);
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
