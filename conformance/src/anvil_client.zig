//! TLS-Anvil client TCP wrapper.
//!
//! Thin I/O harness that drives ClientHandshake over a TCP stream. Reads
//! HOST and PORT from environment, completes a TLS 1.3 handshake, then echoes
//! arbitrary application data back to the peer until close_notify.
//!
//! This is test harness code; allocators and I/O are acceptable here.
const std = @import("std");
const net = std.net;
const crypto = std.crypto;

const ztls = @import("ztls");

pub fn main() !void {
    var arena_allocator: std.heap.ArenaAllocator = .init(std.heap.smp_allocator);
    defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();

    const host = std.posix.getenv("HOST") orelse "127.0.0.1";
    const port = blk: {
        const port_str = std.posix.getenv("PORT") orelse "4433";
        break :blk try std.fmt.parseInt(u16, port_str, 10);
    };

    const stream = try net.tcpConnectToHost(arena, host, port);
    defer stream.close();

    const kp: ztls.x25519.KeyPair = .generate();
    var random: ztls.client_hello.Random = undefined;
    crypto.random.bytes(&random.data);

    var hs: ztls.ClientHandshake = .init(kp);
    defer hs.deinit();
    // Accept any ALPN the server selects, or none.
    hs.offerAlpn(&.{ "h2", "http/1.1" });

    var out: [1024]u8 = undefined;
    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);

    // ClientHello.
    try stream.writeAll(try hs.start(&out, random, host));
    hs.completeWrite();

    // Drive handshake.
    while (!hs.isConnected()) {
        const n = try stream.read(rb.writable());
        if (n == 0) return error.ServerClosed;
        rb.advance(n);
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out)) {
            .write => |w| {
                try stream.writeAll(w);
                hs.completeWrite();
            },
            .application_data, .closed => return error.UnexpectedDuringHandshake,
            .none => {},
        };
    }

    // Echo application data until close_notify.
    while (true) {
        const n = try stream.read(rb.writable());
        if (n == 0) break;
        rb.advance(n);
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out)) {
            .application_data => |data| {
                const rec = try hs.sendApplicationData(data, &out);
                try stream.writeAll(rec);
                hs.completeWrite();
            },
            .write => |w| {
                try stream.writeAll(w);
                hs.completeWrite();
            },
            .closed => {
                // RFC 8446 §6.1 — close_notify is bidirectional on orderly shutdown.
                const rec = try hs.sendAlert(.close_notify, &out);
                try stream.writeAll(rec);
                hs.completeWrite();
                return;
            },
            .none => {},
        };
    }
}
