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

const ArrayBuffer = @import("array_buffer.zig").ArrayBuffer;
const frame = @import("frame.zig");
/// Smallest storage that guarantees any one record fits: a full-size wire
/// record (header + maximum ciphertext).
pub const min_storage = frame.max_wire_record_len;

const RecordBuffer = @This();

/// A comfortable default: room for a partial record plus a full one, so a read
/// that straddles a record boundary still makes progress without thrashing.
pub const recommended_storage = 2 * min_storage;

pub const MinStorage = ArrayBuffer(u8, min_storage);
pub const Storage = ArrayBuffer(u8, recommended_storage);

storage: []u8,
/// Start of unconsumed data (records before this are handed out and done).
pos: usize = 0,
/// End of valid data in storage.
filled: usize = 0,

/// `storage` is caller-owned, and so is clearing it. Records are decrypted in
/// place, so this buffer holds application plaintext; nothing here zeroes it.
/// Zero it where it is declared. See #81.
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

pub const NextError = error{
    /// The header's length exceeds the RFC 8446 §5.2 maximum.
    RecordTooLarge,
    /// The header's content type is none of the four TLS 1.3 defines
    /// (RFC 8446 §5: terminate with `unexpected_message`).
    UnexpectedRecord,
};

/// Return the next complete record as a mutable slice into storage, or null if
/// a full record isn't buffered yet (read more via writable/advance). The slice
/// stays valid until the next `next()` or `writable()` call — decrypt it in
/// place before then. RFC 8446 §5.1.
///
/// A header fails as soon as its 5 bytes arrive, before any wait for the
/// body. A non-TLS peer (an HTTP request, a Postgres StartupMessage) reads
/// as a header with a plausible length and no valid type, so waiting for
/// its body would hold the connection until the peer gives up (#139).
pub fn next(self: *RecordBuffer) NextError!?[]u8 {
    const hdr = try self.header() orelse return null;
    const avail = self.storage[self.pos..self.filled];
    const total = frame.header_len + hdr.length();
    if (avail.len < total) return null;
    self.pos += total;
    return avail[0..total];
}

/// True when the next `next()` call returns without more transport reads:
/// a complete record is buffered, or the buffered header already fails.
/// Poll-style drive loops use this to drain coalesced records, and to reach
/// a header error, without blocking on the transport.
pub fn hasRecord(self: *const RecordBuffer) bool {
    const hdr = (self.header() catch return true) orelse return false;
    const avail = self.storage[self.pos..self.filled];
    return avail.len >= frame.header_len + hdr.length();
}

/// The buffered record header, null before 5 bytes arrive.
fn header(self: *const RecordBuffer) NextError!?frame.Header {
    const avail = self.storage[self.pos..self.filled];
    if (avail.len < frame.header_len) return null;
    const hdr = frame.parseHeader(avail) catch |e| return switch (e) {
        // BufferTooShort can't happen — we checked header_len above.
        error.BufferTooShort => unreachable,
        error.RecordTooLarge => error.RecordTooLarge,
    };
    switch (hdr.content_type) {
        .change_cipher_spec, .alert, .handshake, .application_data => return hdr,
        // legacy_record_version stays unchecked: RFC 8446 §5.1 says it
        // "MUST be ignored for all purposes".
        .invalid, _ => {
            @branchHint(.cold);
            return error.UnexpectedRecord;
        },
    }
}

/// True when no transport bytes remain buffered, including a partial record.
/// A kTLS handoff must satisfy this before the kernel takes ownership of RX.
pub fn isEmpty(self: *const RecordBuffer) bool {
    assert(self.pos <= self.filled);
    return self.pos == self.filled;
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
    const data =
        [_]u8{ 22, 0x03, 0x03, 0x00, 0x01, 0xaa } ++
        [_]u8{ 22, 0x03, 0x03, 0x00, 0x01, 0xbb };
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

fn expectIncomplete(data: []const u8) !void {
    var storage: [min_storage]u8 = undefined;
    var rb: RecordBuffer = .init(&storage);
    @memcpy(rb.writable()[0..data.len], data);
    rb.advance(data.len);
    try testing.expectEqual(@as(?[]u8, null), try rb.next());
}

// RFC 8446 §5.1 — a TLS record is unavailable until the complete header and
// declared fragment bytes have arrived.
test "next: truncated records return null" {
    try expectIncomplete(&.{ 23, 0x03, 0x03, 0x00 });
    try expectIncomplete(&.{ 23, 0x03, 0x03, 0x00, 0x01 });
    try expectIncomplete(&.{ 23, 0x03, 0x03, 0x00, 0x04, 0x01, 0x02, 0x03 });
}

test "next: in-place mutation of a returned record survives across next()" {
    var storage: [min_storage]u8 = undefined;
    var rb: RecordBuffer = .init(&storage);

    const data =
        [_]u8{ 23, 0x03, 0x03, 0x00, 0x01, 0x11 } ++
        [_]u8{ 23, 0x03, 0x03, 0x00, 0x01, 0x22 };
    @memcpy(rb.writable()[0..data.len], &data);
    rb.advance(data.len);

    const r1 = (try rb.next()).?;
    r1[5] = 0xff; // simulate in-place decrypt
    const r2 = (try rb.next()).?;
    // r1's bytes are untouched by next() (no compaction until writable()).
    try testing.expectEqual(@as(u8, 0xff), r1[5]);
    try testing.expectEqual(@as(u8, 0x22), r2[5]);
}

fn expectUnexpected(data: []const u8) !void {
    var storage: [min_storage]u8 = undefined;
    var rb: RecordBuffer = .init(&storage);
    @memcpy(rb.writable()[0..data.len], data);
    rb.advance(data.len);
    // The verdict is ready without the body: a poll loop reaches it.
    try testing.expect(rb.hasRecord());
    try testing.expectError(error.UnexpectedRecord, rb.next());
}

// RFC 8446 §5 — an unexpected record type terminates the connection. A
// non-TLS peer's first flight fails at its 5th byte instead of waiting for a
// body it will never send (#139).
test "next: a header with an invalid content type fails before its body" {
    // `GET / HTTP/1.1` reads as type 0x47, length 0x202f (8,239).
    try expectUnexpected("GET /");
    try expectUnexpected("GET / HTTP/1.1\r\n");
    // A Postgres StartupMessage (protocol 3.0) reads as type 0, length 0x2900.
    try expectUnexpected(&.{ 0x00, 0x00, 0x00, 0x29, 0x00, 0x00, 0x03, 0x00, 0x00 });
    // Every type outside the four TLS 1.3 defines, including heartbeat (24),
    // which TLS 1.3 does not use.
    for ([_]u8{ 0, 1, 19, 24, 25, 0x80, 0xff }) |t| {
        try expectUnexpected(&.{ t, 0x03, 0x03, 0x00, 0x10 });
    }
    // Fewer than 5 bytes is no verdict yet.
    try expectIncomplete("GET ");
}

test "next: each valid content type still waits for its body" {
    for ([_]u8{ 20, 21, 22, 23 }) |t| {
        var storage: [min_storage]u8 = undefined;
        var rb: RecordBuffer = .init(&storage);
        // legacy_record_version is ignored, so a 0x0301 initial ClientHello
        // and a nonsense version both frame.
        const hdr = [_]u8{ t, 0x03, 0x01, 0x00, 0x02 };
        @memcpy(rb.writable()[0..hdr.len], &hdr);
        rb.advance(hdr.len);
        try testing.expect(!rb.hasRecord());
        try testing.expectEqual(@as(?[]u8, null), try rb.next());
        const body = [_]u8{ 0xaa, 0xbb };
        @memcpy(rb.writable()[0..body.len], &body);
        rb.advance(body.len);
        try testing.expect(rb.hasRecord());
        try testing.expectEqual(@as(usize, 7), (try rb.next()).?.len);
    }
}

test "hasRecord: an oversized header is ready, so a poll loop reaches the error" {
    var storage: [min_storage]u8 = undefined;
    var rb: RecordBuffer = .init(&storage);
    const len: u16 = frame.max_ciphertext_len + 1;
    const hdr = [_]u8{ 23, 0x03, 0x03, @intCast(len >> 8), @intCast(len & 0xff) };
    @memcpy(rb.writable()[0..hdr.len], &hdr);
    rb.advance(hdr.len);
    try testing.expect(rb.hasRecord());
    try testing.expectError(error.RecordTooLarge, rb.next());
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

// RFC 8446 §5.1 — kTLS RX handoff requires no userspace-owned transport byte,
// including a partial header or body.
test "isEmpty distinguishes drained, partial, and complete records" {
    var storage: [min_storage]u8 = undefined;
    var rb: RecordBuffer = .init(&storage);
    try testing.expect(rb.isEmpty());

    rb.writable()[0] = 23;
    rb.advance(1);
    try testing.expect(!rb.isEmpty());
    try testing.expectEqual(@as(?[]u8, null), try rb.next());

    const rest = [_]u8{ 0x03, 0x03, 0x00, 0x01, 0xaa };
    @memcpy(rb.writable()[0..rest.len], &rest);
    rb.advance(rest.len);
    _ = (try rb.next()).?;
    try testing.expect(rb.isEmpty());
}
