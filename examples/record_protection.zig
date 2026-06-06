/// Demonstrates record-layer encrypt/decrypt using RecordLayer.
///
/// Shows the minimum setup to protect and unprotect TLS 1.3 records:
/// two parties sharing a key and IV, sending application data back
/// and forth across a simulated channel.
const std = @import("std");
const print = std.debug.print;

const ztls = @import("ztls");

pub fn main() !void {
    // In a real TLS connection, key and IV are derived from the handshake
    // key schedule. Here we just pick fixed values for demonstration.
    var sender: ztls.RecordLayer = try .init(.{ .aes128_gcm = .init(@splat(0xab)) }, .init(@splat(0xcd)));
    defer sender.deinit();
    var receiver: ztls.RecordLayer = try .init(.{ .aes128_gcm = .init(@splat(0xab)) }, .init(@splat(0xcd)));
    defer receiver.deinit();

    const messages = [_][]const u8{
        "hello from ztls",
        "TLS 1.3 record protection",
        "no allocations, no I/O",
    };

    for (messages) |msg| {
        // Sender: encrypt into a stack-allocated output buffer.
        var out: [256 + ztls.RecordLayer.overhead]u8 = undefined;
        const wire = try sender.encrypt(.application_data, msg, &out);

        print("encrypted {} bytes -> {} wire bytes\n", .{ msg.len, wire.len });

        // Receiver: decrypt in place. `wire` is modified; result points into it.
        const received = try receiver.decrypt(wire);

        print("  content_type: {s}\n", .{@tagName(received.content_type)});
        print("  content:      {s}\n", .{received.content});
    }

    print("\nsender seq: {d}  receiver seq: {d}\n", .{ sender.seq, receiver.seq });
}
