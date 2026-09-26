//! Blocking socket adapter for the Sans-I/O drive loop.
//!
//! The engine consumes and produces byte slices; the caller owns the
//! transport. Every caller driving a TLS connection over a blocking TCP
//! socket writes the same two loops, so they live here. The engine itself
//! never names std.Io — this module is a leaf that consumers opt into, and
//! Zig's lazy compilation keeps it out of builds that don't.
//!
//! Reads go through io.vtable.netRead, not Io.Reader: readSliceShort loops
//! until the destination is full, and peek/take hand out slices of the
//! Reader's internal buffer, which forces a copy into the caller-owned
//! RecordBuffer. One netRead lands bytes directly in `rb.writable()` — zero
//! copies, one syscall. Writes loop on short writev counts directly for the
//! same reason: Io.Writer exists to batch small writes, and a TLS record
//! should reach the socket immediately. If std.Io.net.Stream regains direct
//! read/write methods, this module collapses to one-liners and can die.
const std = @import("std");
const Io = std.Io;
const testing = std.testing;

const RecordBuffer = @import("RecordBuffer.zig");

/// Read once into the buffer's writable region and report the bytes to it.
/// Returns the byte count; 0 means the peer closed the transport.
pub fn fill(io: Io, stream: Io.net.Stream, rb: *RecordBuffer) !usize {
    var data: [1][]u8 = .{rb.writable()};
    const n = try io.vtable.netRead(io.userdata, stream.socket.handle, &data);
    rb.advance(n);
    return n;
}

/// Write all bytes, looping on short writes.
pub fn writeAll(io: Io, stream: Io.net.Stream, bytes: []const u8) !void {
    var rest = bytes;
    while (rest.len != 0) {
        const data: [1][]const u8 = .{rest};
        const n = try io.vtable.netWrite(io.userdata, stream.socket.handle, "", &data, 1);
        rest = rest[n..];
    }
}

// Not a protocol assertion: the adapter contract is that fill/writeAll move
// bytes between a loopback socket and a RecordBuffer unchanged.
test "fill and writeAll round trip over loopback" {
    const io = testing.io;
    const listen_addr: Io.net.IpAddress = try .parse("127.0.0.1", 0);
    var listener = try listen_addr.listen(io, .{ .reuse_address = false });
    defer listener.deinit(io);

    const port = listener.socket.address.getPort();
    const client_addr: Io.net.IpAddress = try .parse("127.0.0.1", port);
    const client = try client_addr.connect(io, .{ .mode = .stream });
    defer client.close(io);
    const server = try listener.accept(io);
    defer server.close(io);

    // Two tiny handshake records, coalesced into one write.
    const wire = [_]u8{ 22, 0x03, 0x03, 0x00, 0x01, 0xaa } ++
        [_]u8{ 22, 0x03, 0x03, 0x00, 0x01, 0xbb };
    try writeAll(io, client, &wire);

    var storage: [RecordBuffer.min_storage]u8 = undefined;
    var rb: RecordBuffer = .init(&storage);
    try testing.expectEqual(wire.len, fill(io, server, &rb));
    try testing.expectEqualSlices(u8, wire[0..6], (try rb.next()).?);
    try testing.expectEqualSlices(u8, wire[6..], (try rb.next()).?);
    try testing.expectEqual(@as(?[]u8, null), try rb.next());
}
