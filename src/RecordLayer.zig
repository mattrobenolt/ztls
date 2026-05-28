/// TLS 1.3 record protection — one direction of a TLS connection (read or write).
///
/// Composes record framing, nonce construction, and AEAD to implement
/// TLSCiphertext encrypt/decrypt. RFC 8446 §5.2
const std = @import("std");
const testing = std.testing;
const Aes128Gcm = std.crypto.aead.aes_gcm.Aes128Gcm;

const Aead = @import("aead.zig").Aead;
const Aes128GcmKey = @import("aead.zig").Aes128GcmKey;
const construct = @import("nonce.zig").construct;
const Iv = @import("aead.zig").Iv;
const memx = @import("memx.zig");
const record = @import("record.zig");
const ContentType = record.ContentType;
const DecryptedRecord = record.DecryptedRecord;
const Header = record.Header;
const Tag = @import("aead.zig").Tag;
const tag_len = @import("aead.zig").tag_len;

const RecordLayer = @This();

aead: Aead,
iv: Iv,
seq: u64 = 0,

/// Decrypt a TLSCiphertext record in place.
///
/// `buf` must contain the full record as received from the wire
/// (header + encrypted payload). Decryption overwrites the ciphertext
/// portion of `buf` with the plaintext. The returned `DecryptedRecord.content`
/// is a subslice of `buf` — no allocation, no copy.
///
/// Sequence number increments only on successful authentication.
///
/// RFC 8446 §5.2
pub fn decrypt(self: *RecordLayer, buf: []u8) !DecryptedRecord {
    if (self.seq == std.math.maxInt(u64)) {
        @branchHint(.cold);
        return error.SequenceNumberOverflow;
    }

    const hdr = try record.parseHeader(buf);
    if (hdr.content_type != .application_data) return error.UnexpectedContentType;

    const payload_len = hdr.length();
    if (payload_len <= tag_len) return error.RecordTooShort;

    const ct_len = payload_len - tag_len;
    const payload = buf[record.header_len..][0..payload_len];
    const inner = payload[0..ct_len];
    const tag: *const Tag = payload[ct_len..][0..tag_len];

    const npub = construct(&self.iv, self.seq);
    // Decrypt in place: inner holds ciphertext on entry, plaintext on exit.
    try self.aead.decrypt(inner, inner, tag, buf[0..record.header_len], &npub);

    self.seq += 1;

    // RFC 8446 §5.2: last non-zero byte is the real ContentType.
    const i = memx.lastIndexOfNonZero(inner) orelse return error.InvalidInnerPlaintext;
    return .{
        .content_type = @enumFromInt(inner[i]),
        .content = inner[0..i],
    };
}

/// Encrypt a TLS record in place into `buf`.
///
/// Writes the full TLSCiphertext record into `buf`: 5-byte header, ciphertext,
/// and authentication tag. `buf` must be at least
/// `record.header_len + content.len + 1 + tag_len` bytes.
///
/// Returns the number of bytes written.
///
/// RFC 8446 §5.2
pub fn encrypt(self: *RecordLayer, content_type: ContentType, content: []const u8, out: []u8) ![]u8 {
    if (self.seq == std.math.maxInt(u64)) {
        @branchHint(.cold);
        return error.SequenceNumberOverflow;
    }

    const inner_len = content.len + 1; // content + type byte
    const total = record.header_len + inner_len + tag_len;
    if (out.len < total) return error.BufferTooShort;

    // Write the record header: application_data, length = inner_len + tag_len.
    out[0..record.header_len].* = std.mem.toBytes(Header.init(.application_data, @intCast(inner_len + tag_len)));

    // Write TLSInnerPlaintext: content || real ContentType byte.
    @memcpy(out[record.header_len..][0..content.len], content);
    out[record.header_len + content.len] = @intFromEnum(content_type);

    // Encrypt the inner plaintext in place, append the tag.
    const inner = out[record.header_len..][0..inner_len];
    const npub = construct(&self.iv, self.seq);
    self.aead.encrypt(inner, out[record.header_len + inner_len ..][0..tag_len], inner, out[0..record.header_len], &npub);

    self.seq += 1;
    return out[0..total];
}

// RFC 8446 §5.2 — record protection

test "encrypt: buffer too short" {
    var rl: RecordLayer = .{
        .aead = .initAes128Gcm(@splat(0)),
        .iv = @splat(0),
    };
    var buf: [4]u8 = undefined;
    try testing.expectError(error.BufferTooShort, rl.encrypt(.application_data, "hello", &buf));
}

test "encrypt: sequence number overflow" {
    var rl: RecordLayer = .{
        .aead = .initAes128Gcm(@splat(0)),
        .iv = @splat(0),
        .seq = std.math.maxInt(u64),
    };
    var buf: [64]u8 = undefined;
    try testing.expectError(error.SequenceNumberOverflow, rl.encrypt(.application_data, "hello", &buf));
}

test "encrypt/decrypt: round-trip" {
    const key: Aes128GcmKey = @splat(0xab);
    const iv: Iv = @splat(0xcd);
    var tx: RecordLayer = .{ .aead = .initAes128Gcm(key), .iv = iv };
    var rx: RecordLayer = .{ .aead = .initAes128Gcm(key), .iv = iv };

    const plaintext = "hello, ztls";
    var buf: [record.header_len + plaintext.len + 1 + tag_len]u8 = undefined;

    const record_buf = try tx.encrypt(.application_data, plaintext, &buf);
    const result = try rx.decrypt(record_buf);

    try testing.expectEqual(.application_data, result.content_type);
    try testing.expectEqualSlices(u8, plaintext, result.content);
}

test "encrypt/decrypt: sequence numbers advance" {
    const key: Aes128GcmKey = @splat(0x01);
    const iv: Iv = @splat(0x02);
    var tx: RecordLayer = .{ .aead = .initAes128Gcm(key), .iv = iv };
    var rx: RecordLayer = .{ .aead = .initAes128Gcm(key), .iv = iv };

    var buf: [record.header_len + 5 + 1 + tag_len]u8 = undefined;

    for (0..3) |_| {
        const encrypted = try tx.encrypt(.application_data, "hello", &buf);
        _ = try rx.decrypt(encrypted);
    }
    try testing.expectEqual(@as(u64, 3), tx.seq);
    try testing.expectEqual(@as(u64, 3), rx.seq);
}

test "decrypt: wrong content type" {
    var rl: RecordLayer = .{
        .aead = .initAes128Gcm(@splat(0)),
        .iv = @splat(0),
    };
    var buf = [_]u8{ 22, 0x03, 0x03, 0x00, 0x10 } ++ [_]u8{0} ** 16;
    try testing.expectError(error.UnexpectedContentType, rl.decrypt(&buf));
}

test "decrypt: payload shorter than tag" {
    var rl: RecordLayer = .{
        .aead = .initAes128Gcm(@splat(0)),
        .iv = @splat(0),
    };
    var buf = [_]u8{ 23, 0x03, 0x03, 0x00, 0x04 } ++ [_]u8{0} ** 4;
    try testing.expectError(error.RecordTooShort, rl.decrypt(&buf));
}

test "decrypt: sequence number overflow" {
    var rl: RecordLayer = .{
        .aead = .initAes128Gcm(@splat(0)),
        .iv = @splat(0),
        .seq = std.math.maxInt(u64),
    };
    var buf = [_]u8{ 23, 0x03, 0x03, 0x00, 0x14 } ++ [_]u8{0} ** 20;
    try testing.expectError(error.SequenceNumberOverflow, rl.decrypt(&buf));
}
