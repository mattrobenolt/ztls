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
const std = @import("std");
const print = std.debug.print;

const ztls = @import("ztls");

const connect_host = "127.0.0.1";
const server_name = "ztls.server.test";
const port: u16 = 8443;
const trust_anchor_pem = "examples/fixtures/server-ecdsa/server.crt";

pub fn main() !void {
    const addr = try std.net.Address.parseIp(connect_host, port);
    const stream = std.net.tcpConnectToAddress(addr) catch |err| switch (err) {
        error.ConnectionRefused => {
            print("[https]  could not connect to {s}:{d}\n", .{ connect_host, port });
            print("         Start the server first: zig build example-https_server\n", .{});
            return;
        },
        else => return err,
    };
    defer stream.close();
    print("[https]  connected to {s}:{d}\n", .{ connect_host, port });

    const client_keypair: ztls.x25519.KeyPair = .generate();
    var hs: ztls.ClientHandshake = .init(client_keypair);
    hs.offerAlpn(&.{"http/1.1"});

    // Certificate verification policy: hostname, validity time, and a pinned
    // trust anchor. This is example-wrapper allocation, not ztls core allocation.
    hs.policy.host_name = server_name;
    hs.policy.now_sec = std.time.timestamp();
    var bundle: std.crypto.Certificate.Bundle = .{};
    defer bundle.deinit(std.heap.page_allocator);
    try bundle.addCertsFromFilePath(std.heap.page_allocator, std.fs.cwd(), trust_anchor_pem);
    hs.policy.bundle = &bundle;

    var random: ztls.client_hello.Random = undefined;
    std.crypto.random.bytes(&random.data);
    var out: ztls.ClientHandshake.OutBuffer = .empty;
    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(storage.fullSlice());

    try stream.writeAll(try hs.start(out.fullSlice(), random, server_name));
    hs.completeWrite();
    print("[https]  ClientHello sent → state={s}\n", .{@tagName(hs.state)});

    while (!hs.isConnected()) {
        const n = try stream.read(rb.writable());
        if (n == 0) return error.ServerClosed;
        rb.advance(n);
        while (try rb.next()) |record| switch (try hs.handleRecord(record, out.fullSlice())) {
            .write => |w| {
                try stream.writeAll(w);
                hs.completeWrite();
            },
            .application_data, .closed => return error.UnexpectedDuringHandshake,
            .none => {},
        };
    }
    print("[https]  handshake complete (ALPN={s})\n", .{hs.selectedAlpnProtocol().?});

    const request = "GET / HTTP/1.0\r\n\r\n";
    try stream.writeAll(try hs.sendApplicationData(request, out.fullSlice()));
    hs.completeWrite();
    print("[https]  sent: {s}", .{request});

    var response_seen = false;
    while (true) {
        const n = try stream.read(rb.writable());
        if (n == 0) break;
        rb.advance(n);
        while (try rb.next()) |record| switch (try hs.handleRecord(record, out.fullSlice())) {
            .application_data => |data| {
                print("[https]  received: {s}\n", .{data});
                response_seen = true;
            },
            .write => |w| {
                try stream.writeAll(w);
                hs.completeWrite();
            },
            .closed => {
                print("[https]  server sent close_notify\n", .{});
                return;
            },
            .none => {},
        };
    }

    if (!response_seen) {
        print("[https]  warning: no application data received before EOF\n", .{});
    }
}
