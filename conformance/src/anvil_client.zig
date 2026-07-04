//! TLS-Anvil client TCP wrapper.
//!
//! Thin I/O harness that drives ClientHandshake over a TCP stream. Reads
//! HOST and PORT from environment, completes a TLS 1.3 handshake, then echoes
//! arbitrary application data back to the peer until close_notify.
//!
//! This is test harness code; allocators and I/O are acceptable here.
const std = @import("std");
const net = std.net;
const mem = std.mem;
const posix = std.posix;
const crypto = std.crypto;
const ascii = std.ascii;
const heap = std.heap;

const ztls = @import("ztls");

pub fn main() !void {
    var arena_allocator: heap.ArenaAllocator = .init(heap.smp_allocator);
    defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();

    const host = posix.getenv("HOST") orelse "127.0.0.1";
    const port = blk: {
        const port_str = posix.getenv("PORT") orelse "4433";
        break :blk try std.fmt.parseInt(u16, port_str, 10);
    };

    const insecure_no_host_name = if (posix.getenv("ZTLS_INSECURE_NO_HOST_NAME")) |value|
        mem.eql(u8, value, "1") or ascii.eqlIgnoreCase(value, "true")
    else
        false;
    const cert_host_name: ?[]const u8 = if (insecure_no_host_name)
        null
    else if (posix.getenv("ZTLS_HOST_NAME")) |name|
        if (name.len == 0) null else name
    else
        host;
    const insecure_no_chain_anchor = if (posix.getenv("ZTLS_INSECURE_NO_CHAIN_ANCHOR")) |value|
        mem.eql(u8, value, "1") or ascii.eqlIgnoreCase(value, "true")
    else
        false;

    const stream = try net.tcpConnectToHost(arena, host, port);
    defer stream.close();

    const kp: ztls.x25519.KeyPair = .generate();
    var random: ztls.Random = undefined;
    crypto.random.bytes(&random.data);

    var hs: ztls.ClientHandshake = .init(.{
        .keypair = kp,
        .host_name = cert_host_name,
        .now_sec = std.time.timestamp(),
        .random = random,
        .insecure_no_chain_anchor = insecure_no_chain_anchor,
        .alpn_protocols = &.{ "h2", "http/1.1" },
    });
    if (insecure_no_chain_anchor) hs.policy.leaf_usage = .none;
    defer hs.deinit();

    var out: [ztls.ClientHandshake.max_out_len]u8 = undefined;
    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);

    // ClientHello.
    try stream.writeAll(try hs.start(&out));
    hs.completeWrite();

    // Drive handshake.
    while (!hs.isConnected()) {
        const n = try stream.read(rb.writable());
        if (n == 0) return error.ServerClosed;
        rb.advance(n);
        while (true) {
            const record = (rb.next() catch |err| {
                return sendAlertAndReturnError(stream, &hs, err, &out);
            }) orelse break;
            const ev = hs.handleRecord(record, &out) catch |err| {
                return sendAlertAndReturnError(stream, &hs, err, &out);
            };
            switch (ev) {
                .write => |w| {
                    try stream.writeAll(w);
                    hs.completeWrite();
                },
                .application_data, .closed => return error.UnexpectedDuringHandshake,
                .none => {},
            }
        }
    }

    // Echo application data until close_notify.
    while (true) {
        const n = try stream.read(rb.writable());
        // Bare transport EOF is truncation or a transport close, not an
        // orderly TLS close. Do not send close_notify here — only the
        // `.closed` branch below (peer sent close_notify) sends a reciprocal
        // close_notify. RFC 8446 §6.1.
        if (n == 0) break;
        rb.advance(n);
        while (true) {
            const record = (rb.next() catch |err| {
                return sendAlertAndReturnError(stream, &hs, err, &out);
            }) orelse break;
            const ev = hs.handleRecord(record, &out) catch |err| {
                return sendAlertAndReturnError(stream, &hs, err, &out);
            };
            switch (ev) {
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
            }
        }
    }
}

fn sendAlertAndReturnError(
    stream: net.Stream,
    hs: *ztls.ClientHandshake,
    err: anyerror,
    out: []u8,
) anyerror {
    // The peer already sent us a fatal alert; replying with our own alert
    // would be wrong (and would emit a spurious internal_error). Just
    // propagate the original error. RFC 8446 §6.
    if (err == error.PeerAlert) return err;
    const rec = hs.sendAlert(ztls.ClientHandshake.alertForError(err), out) catch return err;
    stream.writeAll(rec) catch return err;
    hs.completeWrite();
    return err;
}
