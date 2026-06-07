//! I/O-agnostic TLS record framing buffer.
//!
//! The engine consumes one complete record at a time, but transports deliver a
//! byte stream where records split and coalesce arbitrarily. RecordBuffer is
//! the seam between the two: the caller reads transport bytes into `writable()`,
//! reports how many with `advance()`, and pulls complete records with `next()`.
//! No allocations, no I/O — the caller owns the storage and the transport.
//!
//! Usage:
//!     var rb: RecordBuffer = .init(&storage);
//!     const n = try stream.read(rb.writable());
//!     rb.advance(n);
//!     while (try rb.next()) |record| {
//!         // record is a mutable slice into storage, valid until the next
//!         // next()/writable() call. Decrypt it in place here.
//!     }
//!
//! `storage` must be at least `min_storage` bytes so any single record fits.
const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;

const array_buffer = @import("array_buffer.zig");
const frame = @import("frame.zig");
/// Smallest storage that guarantees any one record fits: a full-size wire
/// record (header + maximum ciphertext).
pub const min_storage = frame.max_wire_record_len;

const RecordBuffer = @This();

/// A comfortable default: room for a partial record plus a full one, so a read
/// that straddles a record boundary still makes progress without thrashing.
pub const recommended_storage = 2 * min_storage;

pub const MinStorage = array_buffer.ArrayBuffer(u8, min_storage);
pub const Storage = array_buffer.ArrayBuffer(u8, recommended_storage);

storage: []u8,
/// Start of unconsumed data (records before this are handed out and done).
pos: usize = 0,
/// End of valid data in storage.
filled: usize = 0,

pub fn init(storage: []u8) RecordBuffer {
    assert(storage.len >= min_storage);
    return .{ .storage = storage };
}

/// Free space to read transport bytes into. Compacts first, so the returned
/// slice is the largest contiguous region available. Call `advance` afterward
/// with the number of bytes written. Invalidates any record from `next()`.
pub fn writable(self: *RecordBuffer) []u8 {
    self.compact();
    return self.storage[self.filled..];
}

/// Report `n` bytes written into the slice from `writable()`.
pub fn advance(self: *RecordBuffer, n: usize) void {
    assert(self.filled + n <= self.storage.len);
    self.filled += n;
}

/// Return the next complete record as a mutable slice into storage, or null if
/// a full record isn't buffered yet (read more via writable/advance). The slice
/// stays valid until the next `next()` or `writable()` call — decrypt it in
/// place before then. RFC 8446 §5.1.
pub fn next(self: *RecordBuffer) error{RecordTooLarge}!?[]u8 {
    const avail = self.storage[self.pos..self.filled];
    if (avail.len < frame.header_len) return null;
    const hdr = frame.parseHeader(avail) catch |e| switch (e) {
        // BufferTooShort can't happen — we checked header_len above.
        error.BufferTooShort => unreachable,
        error.RecordTooLarge => return error.RecordTooLarge,
    };
    const total = frame.header_len + hdr.length();
    if (avail.len < total) return null;
    self.pos += total;
    return avail[0..total];
}

/// Move unconsumed bytes to the front so `writable()` is maximally contiguous.
fn compact(self: *RecordBuffer) void {
    if (self.pos == 0) return;
    const unconsumed = self.storage[self.pos..self.filled];
    @memmove(self.storage[0..unconsumed.len], unconsumed);
    self.filled -= self.pos;
    self.pos = 0;
}

// RFC 8446 §5.1 — records split and coalesce arbitrarily on the wire.
test "next: two records coalesced in one fill" {
    var storage: [min_storage]u8 = undefined;
    var rb: RecordBuffer = .init(&storage);

    // Two tiny handshake records: header + 1 byte each.
    const data = [_]u8{ 22, 0x03, 0x03, 0x00, 0x01, 0xaa } ++ [_]u8{ 22, 0x03, 0x03, 0x00, 0x01, 0xbb };
    @memcpy(rb.writable()[0..data.len], &data);
    rb.advance(data.len);

    const r1 = (try rb.next()).?;
    try testing.expectEqual(@as(usize, 6), r1.len);
    try testing.expectEqual(@as(u8, 0xaa), r1[5]);
    const r2 = (try rb.next()).?;
    try testing.expectEqual(@as(u8, 0xbb), r2[5]);
    try testing.expectEqual(@as(?[]u8, null), try rb.next());
}

test "next: record split across two fills" {
    var storage: [min_storage]u8 = undefined;
    var rb: RecordBuffer = .init(&storage);

    // First fill: header + 2 of 4 payload bytes — incomplete.
    const part1 = [_]u8{ 23, 0x03, 0x03, 0x00, 0x04, 0x01, 0x02 };
    @memcpy(rb.writable()[0..part1.len], &part1);
    rb.advance(part1.len);
    try testing.expectEqual(@as(?[]u8, null), try rb.next());

    // Second fill: the remaining 2 payload bytes complete it.
    const part2 = [_]u8{ 0x03, 0x04 };
    @memcpy(rb.writable()[0..part2.len], &part2);
    rb.advance(part2.len);

    const r = (try rb.next()).?;
    try testing.expectEqual(@as(usize, 9), r.len);
    try testing.expectEqualSlices(u8, &.{ 0x01, 0x02, 0x03, 0x04 }, r[5..9]);
}

test "next: in-place mutation of a returned record survives across next()" {
    var storage: [min_storage]u8 = undefined;
    var rb: RecordBuffer = .init(&storage);

    const data = [_]u8{ 23, 0x03, 0x03, 0x00, 0x01, 0x11 } ++ [_]u8{ 23, 0x03, 0x03, 0x00, 0x01, 0x22 };
    @memcpy(rb.writable()[0..data.len], &data);
    rb.advance(data.len);

    const r1 = (try rb.next()).?;
    r1[5] = 0xff; // simulate in-place decrypt
    const r2 = (try rb.next()).?;
    // r1's bytes are untouched by next() (no compaction until writable()).
    try testing.expectEqual(@as(u8, 0xff), r1[5]);
    try testing.expectEqual(@as(u8, 0x22), r2[5]);
}

test "next: oversized length is rejected" {
    var storage: [min_storage]u8 = undefined;
    var rb: RecordBuffer = .init(&storage);
    const len: u16 = frame.max_ciphertext_len + 1;
    const hdr = [_]u8{ 23, 0x03, 0x03, @intCast(len >> 8), @intCast(len & 0xff) };
    @memcpy(rb.writable()[0..hdr.len], &hdr);
    rb.advance(hdr.len);
    try testing.expectError(error.RecordTooLarge, rb.next());
}
