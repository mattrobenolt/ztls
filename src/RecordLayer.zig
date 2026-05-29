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
const frame = @import("frame.zig");
const ContentType = frame.ContentType;
const DecryptedRecord = frame.DecryptedRecord;
const Header = frame.Header;
const Iv = @import("aead.zig").Iv;
const memx = @import("memx.zig");
const Tag = @import("aead.zig").Tag;
const tag_len = @import("aead.zig").tag_len;

const RecordLayer = @This();

/// Bytes added to plaintext length to produce the encrypted wire record.
/// Accounts for the 5-byte header, content type byte, and 16-byte AEAD tag.
pub const overhead = frame.header_len + 1 + tag_len;

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

    const hdr = try frame.parseHeader(buf);
    // RecordLayer is scoped to the post-handshake application data path.
    // All encrypted records on the wire are application_data (RFC 8446 §5.2).
    // The handshake layer handles pre-handshake record types, including
    // silently discarding change_cipher_spec (RFC 8446 §D.4).
    if (hdr.content_type != .application_data) return error.UnexpectedContentType;

    const payload_len = hdr.length();
    if (payload_len <= tag_len) return error.RecordTooShort;

    const ct_len = payload_len - tag_len;
    const payload = buf[frame.header_len..][0..payload_len];
    const inner = payload[0..ct_len];
    const tag: Tag = .init(payload[ct_len..][0..tag_len].*);

    const npub = construct(&self.iv, self.seq);
    // Decrypt in place: inner holds ciphertext on entry, plaintext on exit.
    try self.aead.decrypt(inner, inner, &tag, buf[0..frame.header_len], &npub);

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
/// `frame.header_len + content.len + 1 + tag_len` bytes.
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
    const total = frame.header_len + inner_len + tag_len;
    if (out.len < total) return error.BufferTooShort;

    const inner = out[frame.header_len..][0..inner_len];
    var tag: Tag = undefined;

    // Write the record header: application_data, length = inner_len + tag_len.
    const header: Header = .init(.application_data, @intCast(inner_len + tag_len));
    const hdr = out[0..frame.header_len];
    hdr.* = std.mem.toBytes(header);

    // Write TLSInnerPlaintext: content || real ContentType byte.
    @memcpy(inner[0..content.len], content);
    inner[content.len] = @intFromEnum(content_type);

    // Encrypt the inner plaintext in place, append the tag.
    const npub = construct(&self.iv, self.seq);
    self.aead.encrypt(inner, &tag, inner, hdr, &npub);
    out[frame.header_len + inner_len ..][0..tag_len].* = tag.data;

    self.seq += 1;
    return out[0..total];
}

// RFC 8446 §5.2 — record protection

test "encrypt: buffer too short" {
    var rl: RecordLayer = .{
        .aead = .{ .aes128_gcm = .zero },
        .iv = .zero,
    };
    var buf: [4]u8 = undefined;
    try testing.expectError(error.BufferTooShort, rl.encrypt(.application_data, "hello", &buf));
}

test "encrypt: sequence number overflow" {
    var rl: RecordLayer = .{
        .aead = .{ .aes128_gcm = .zero },
        .iv = .zero,
        .seq = std.math.maxInt(u64),
    };
    var buf: [64]u8 = undefined;
    try testing.expectError(error.SequenceNumberOverflow, rl.encrypt(.application_data, "hello", &buf));
}

test "encrypt/decrypt: round-trip" {
    const key: Aes128GcmKey = .init(@splat(0xab));
    const iv: Iv = .init(@splat(0xcd));
    var tx: RecordLayer = .{ .aead = .{ .aes128_gcm = key }, .iv = iv };
    var rx: RecordLayer = .{ .aead = .{ .aes128_gcm = key }, .iv = iv };

    const plaintext = "hello, ztls";
    var buf: [frame.header_len + plaintext.len + 1 + tag_len]u8 = undefined;

    const record_buf = try tx.encrypt(.application_data, plaintext, &buf);
    const result = try rx.decrypt(record_buf);

    try testing.expectEqual(.application_data, result.content_type);
    try testing.expectEqualSlices(u8, plaintext, result.content);
}

test "encrypt/decrypt: sequence numbers advance" {
    const key: Aes128GcmKey = .init(@splat(0x01));
    const iv: Iv = .init(@splat(0x02));
    var tx: RecordLayer = .{ .aead = .{ .aes128_gcm = key }, .iv = iv };
    var rx: RecordLayer = .{ .aead = .{ .aes128_gcm = key }, .iv = iv };

    var buf: [frame.header_len + 5 + 1 + tag_len]u8 = undefined;

    for (0..3) |_| {
        const encrypted = try tx.encrypt(.application_data, "hello", &buf);
        _ = try rx.decrypt(encrypted);
    }
    try testing.expectEqual(@as(u64, 3), tx.seq);
    try testing.expectEqual(@as(u64, 3), rx.seq);
}

test "decrypt: wrong content type" {
    var rl: RecordLayer = .{
        .aead = .{ .aes128_gcm = .zero },
        .iv = .zero,
    };
    var buf = [_]u8{ 22, 0x03, 0x03, 0x00, 0x10 } ++ [_]u8{0} ** 16;
    try testing.expectError(error.UnexpectedContentType, rl.decrypt(&buf));
}

test "decrypt: payload shorter than tag" {
    var rl: RecordLayer = .{
        .aead = .{ .aes128_gcm = .zero },
        .iv = .zero,
    };
    var buf = [_]u8{ 23, 0x03, 0x03, 0x00, 0x04 } ++ [_]u8{0} ** 4;
    try testing.expectError(error.RecordTooShort, rl.decrypt(&buf));
}

test "decrypt: sequence number overflow" {
    var rl: RecordLayer = .{
        .aead = .{ .aes128_gcm = .zero },
        .iv = .zero,
        .seq = std.math.maxInt(u64),
    };
    var buf = [_]u8{ 23, 0x03, 0x03, 0x00, 0x14 } ++ [_]u8{0} ** 20;
    try testing.expectError(error.SequenceNumberOverflow, rl.decrypt(&buf));
}
