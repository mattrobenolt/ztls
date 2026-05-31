const std = @import("std");
const builtin = @import("builtin");
const ztls = @import("ztls");

const Aead = ztls.aead.Aead;
const Iv = ztls.aead.Iv;
const RecordLayer = ztls.RecordLayer;
const frame = ztls.frame;

const sizes = [_]usize{ 16, 1350, 8192, frame.max_plaintext_len };
const target_bytes: usize = 128 * 1024 * 1024;

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

    fn aead(self: Suite) Aead {
        return switch (self) {
            .aes_128_gcm_sha256 => .{ .aes128_gcm = .init(@splat(0x11)) },
            .aes_256_gcm_sha384 => .{ .aes256_gcm = .init(@splat(0x22)) },
            .chacha20_poly1305_sha256 => .{ .chacha20_poly1305 = .init(@splat(0x33)) },
        };
    }
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
};

pub fn main() !void {
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
    try stdout.print("benchmark,suite,size,iterations,bytes,elapsed_ns,mib_per_sec\n", .{});

    inline for (.{ Suite.aes_128_gcm_sha256, Suite.aes_256_gcm_sha384, Suite.chacha20_poly1305_sha256 }) |suite| {
        inline for (sizes) |size| {
            const enc = try benchEncrypt(suite, size);
            try stdout.print("record_encrypt,{s},{d},{d},{d},{d},{d:.2}\n", .{
                suite.name(),
                size,
                enc.iterations,
                enc.bytes,
                enc.ns,
                enc.mbPerSec(),
            });

            const dec = try benchDecrypt(suite, size);
            try stdout.print("record_decrypt,{s},{d},{d},{d},{d},{d:.2}\n", .{
                suite.name(),
                size,
                dec.iterations,
                dec.bytes,
                dec.ns,
                dec.mbPerSec(),
            });
        }
    }
}

fn benchEncrypt(comptime suite: Suite, comptime size: usize) !Result {
    const iterations = @max(256, target_bytes / size);
    var plaintext: [size]u8 = undefined;
    @memset(&plaintext, 0xab);
    var out: [RecordLayer.overhead + size]u8 = undefined;
    var tx: RecordLayer = .{ .aead = suite.aead(), .iv = Iv.zero };

    // Warm up without measuring first-use effects.
    for (0..32) |_| _ = try tx.encrypt(.application_data, &plaintext, &out);

    var timer = try std.time.Timer.start();
    for (0..iterations) |_| {
        const record = try tx.encrypt(.application_data, &plaintext, &out);
        std.mem.doNotOptimizeAway(record.ptr);
    }
    const ns = timer.read();

    return .{ .bytes = iterations * size, .iterations = iterations, .ns = ns };
}

fn benchDecrypt(comptime suite: Suite, comptime size: usize) !Result {
    const iterations = @max(256, target_bytes / size);
    const record_len = RecordLayer.overhead + size;
    const allocator = std.heap.page_allocator;
    const records = try allocator.alloc(u8, iterations * record_len);
    defer allocator.free(records);

    var plaintext: [size]u8 = undefined;
    @memset(&plaintext, 0xcd);

    var tx: RecordLayer = .{ .aead = suite.aead(), .iv = Iv.zero };
    for (0..iterations) |i| {
        const record = try tx.encrypt(.application_data, &plaintext, records[i * record_len ..][0..record_len]);
        std.debug.assert(record.len == record_len);
    }

    var rx: RecordLayer = .{ .aead = suite.aead(), .iv = Iv.zero };

    // Warm up using a separate one-record layer so the measured sequence stays aligned.
    var warm_record: [record_len]u8 = undefined;
    var warm_tx: RecordLayer = .{ .aead = suite.aead(), .iv = Iv.zero };
    var warm_rx: RecordLayer = .{ .aead = suite.aead(), .iv = Iv.zero };
    const warm = try warm_tx.encrypt(.application_data, &plaintext, &warm_record);
    _ = try warm_rx.decrypt(warm);

    var timer = try std.time.Timer.start();
    for (0..iterations) |i| {
        const decrypted = try rx.decrypt(records[i * record_len ..][0..record_len]);
        std.mem.doNotOptimizeAway(decrypted.content.ptr);
    }
    const ns = timer.read();

    return .{ .bytes = iterations * size, .iterations = iterations, .ns = ns };
}
