//! Generate deterministic-ish client replay fixtures from OpenSSL.
//!
//! The client side is deterministic (fixed keypair + random); OpenSSL still
//! chooses fresh server randomness/key_share. The generated records are then
//! frozen into a txtar archive for replay benchmarks.
const std = @import("std");
const fs = std.fs;
const mem = std.mem;
const Child = std.process.Child;
const net = std.net;
const time = std.time;
const heap = std.heap;
const sleep = std.Thread.sleep;
const Allocator = std.mem.Allocator;

const ztls = @import("ztls");

const host = "127.0.0.1";
const replay_host_name = "test.local";
const base_port = 15433;

const Suite = struct {
    name: []const u8,
    file: []const u8,
};

const suites = [_]Suite{
    .{ .name = "TLS_AES_128_GCM_SHA256", .file = "aes128" },
    .{ .name = "TLS_CHACHA20_POLY1305_SHA256", .file = "chacha20" },
    .{ .name = "TLS_AES_256_GCM_SHA384", .file = "aes256" },
};

const client_keypair: ztls.x25519.KeyPair = .{
    .secret_key = .init(.{
        0x49, 0xaf, 0x42, 0xba, 0x7f, 0x79, 0x94, 0x85,
        0x2d, 0x71, 0x3e, 0xf2, 0x78, 0x4b, 0xcb, 0xca,
        0xa7, 0x91, 0x1d, 0xe2, 0x6a, 0xdc, 0x56, 0x42,
        0xcb, 0x63, 0x45, 0x40, 0xe7, 0xea, 0x50, 0x05,
    }),
    .public_key = .init(.{
        0x99, 0x38, 0x1d, 0xe5, 0x60, 0xe4, 0xbd, 0x43,
        0xd2, 0x3d, 0x8e, 0x43, 0x5a, 0x7d, 0xba, 0xfe,
        0xb3, 0xc0, 0x6e, 0x51, 0xc1, 0x3c, 0xae, 0x4d,
        0x54, 0x13, 0x69, 0x1e, 0x52, 0x9a, 0xaf, 0x2c,
    }),
};

const client_random: ztls.Random = .{ .data = .{
    0xcb, 0x34, 0xec, 0xb1, 0xe7, 0x81, 0x63, 0xba,
    0x1c, 0x38, 0xc6, 0xda, 0xcb, 0x19, 0x6a, 0x6d,
    0xff, 0xa2, 0x1a, 0x8d, 0x99, 0x12, 0xec, 0x18,
    0xa2, 0xef, 0x62, 0x83, 0x02, 0x4d, 0xec, 0xe7,
} };

pub fn connectWithRetry(port: u16) !net.Stream {
    const addr: net.Address = try .parseIp("127.0.0.1", port);
    for (0..100) |_| {
        return net.tcpConnectToAddress(addr) catch {
            sleep(20 * time.ns_per_ms);
            continue;
        };
    }
    return error.ServerNeverCameUp;
}

pub fn main() !void {
    var arena_allocator: heap.ArenaAllocator = .init(heap.smp_allocator);
    defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();

    var stdout_buf: [4096]u8 = undefined;
    var stdout_file = fs.File.stdout().writer(&stdout_buf);
    const stdout = &stdout_file.interface;
    defer stdout.flush() catch {};

    // txtar parsers expect the archive to start at file markers; keep metadata
    // in source comments rather than emitting leading prose here.
    for (suites, 0..) |suite, i| {
        const port: u16 = base_port + @as(u16, @intCast(i));
        const records = try captureSuite(arena, suite.name, port);
        try stdout.print("\n-- {s}.records.b64 --\n", .{suite.file});
        var encoder = std.base64.standard.Encoder;
        const n = encoder.calcSize(records.len);
        const encoded = try arena.alloc(u8, n);
        _ = encoder.encode(encoded, records);
        try stdout.print("{s}\n", .{encoded});
    }
}

fn captureSuite(arena: Allocator, suite: []const u8, port: u16) ![]u8 {
    var server = try startServer(arena, suite, port);
    defer _ = server.kill() catch {};

    const stream = try connectWithRetry(port);
    defer stream.close();

    var hs: ztls.ClientHandshake = .init(.{
        .keypairs = .init(client_keypair),
        .host_name = replay_host_name,
        .now_sec = 0,
        .random = client_random,
    });
    var out: [1024]u8 = undefined;
    try stream.writeAll(try hs.start(&out));
    hs.completeWrite();

    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);

    var records: std.ArrayList(u8) = .empty;
    errdefer records.deinit(arena);

    while (!hs.isConnected()) {
        const n = try stream.read(rb.writable());
        if (n == 0) return error.ServerClosed;
        rb.advance(n);
        while (try rb.next()) |record| {
            try records.appendSlice(arena, record);
            switch (try hs.handleRecord(record, &out)) {
                .write => |w| {
                    try stream.writeAll(w);
                    hs.completeWrite();
                },
                .none => {},
                .application_data, .closed => return error.UnexpectedDuringHandshake,
            }
        }
    }

    return records.toOwnedSlice(arena);
}

fn startServer(arena: mem.Allocator, suite: []const u8, port: u16) !Child {
    const port_str = try std.fmt.allocPrint(arena, "{d}", .{port});
    var child = Child.init(&.{
        "openssl",                   "s_server",
        "-tls1_3",                   "-ciphersuites",
        suite,                       "-key",
        "tests/fixtures/server.key", "-cert",
        "tests/fixtures/server.crt", "-port",
        port_str,                    "-www",
        "-quiet",
    }, arena);
    child.stdout_behavior = .Ignore;
    child.stderr_behavior = .Ignore;
    try child.spawn();
    return child;
}
