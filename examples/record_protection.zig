/// Demonstrates record-layer encrypt/decrypt using RecordLayer.
///
/// Shows the minimum setup to protect and unprotect TLS 1.3 records:
/// two parties sharing a key and IV, sending application data back
/// and forth across a simulated channel.
const std = @import("std");
const ztls = @import("ztls");

const RecordLayer = ztls.RecordLayer;
const record = ztls.record;

pub fn main() !void {
    // In a real TLS connection, key and IV are derived from the handshake
    // key schedule. Here we just pick fixed values for demonstration.
    const key: ztls.aead.Aes128GcmKey = @splat(0xab);
    const iv: ztls.aead.Iv = @splat(0xcd);

    var sender: RecordLayer = .{ .aead = .initAes128Gcm(key), .iv = iv };
    var receiver: RecordLayer = .{ .aead = .initAes128Gcm(key), .iv = iv };

    const messages = [_][]const u8{
        "hello from ztls",
        "TLS 1.3 record protection",
        "no allocations, no I/O",
    };

    for (messages) |msg| {
        // Sender: encrypt into a stack-allocated output buffer.
        var out: [record.header_len + 256 + 1 + ztls.aead.tag_len]u8 = undefined;
        const wire = try sender.encrypt(.application_data, msg, &out);

        std.debug.print("encrypted {} bytes -> {} wire bytes\n", .{ msg.len, wire.len });

        // Receiver: decrypt in place. `wire` is modified; result points into it.
        const received = try receiver.decrypt(wire);

        std.debug.print("  content_type: {s}\n", .{@tagName(received.content_type)});
        std.debug.print("  content:      {s}\n", .{received.content});
    }

    std.debug.print("\nsender seq: {d}  receiver seq: {d}\n", .{ sender.seq, receiver.seq });
}
