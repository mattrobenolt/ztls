/// TLS 1.3 record protection — one direction of a TLS connection (read or write).
///
/// Composes record framing, nonce construction, and AEAD to implement
/// TLSCiphertext encrypt/decrypt. RFC 8446 §5.2
const std = @import("std");
const testing = std.testing;
const Aes128Gcm = std.crypto.aead.aes_gcm.Aes128Gcm;

const Aead = @import("aead.zig").Aead;
const construct = @import("nonce.zig").construct;
const Iv = @import("aead.zig").Iv;
const memx = @import("memx.zig");
const record = @import("record.zig");
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
pub fn decrypt(self: *RecordLayer, buf: []u8) !record.DecryptedRecord {
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
    const ciphertext = payload[0..ct_len];
    const tag: *const Tag = payload[ct_len..][0..tag_len];

    const npub = construct(&self.iv, self.seq);
    // Decrypt in place: ciphertext and plaintext occupy the same slice.
    try self.aead.decrypt(ciphertext, ciphertext, tag, buf[0..record.header_len], &npub);

    self.seq += 1;

    // RFC 8446 §5.2: last non-zero byte is the real ContentType.
    const i = memx.lastIndexOfNonZero(ciphertext) orelse return error.InvalidInnerPlaintext;
    return .{
        .content_type = @enumFromInt(ciphertext[i]),
        .content = ciphertext[0..i],
    };
}

// RFC 8446 §5.2 — record protection

test "decrypt: wrong content type" {
    var rl: RecordLayer = .{ .aead = .initAes128Gcm(@splat(0)), .iv = @splat(0) };
    var buf = [_]u8{ 22, 0x03, 0x03, 0x00, 0x10 } ++ [_]u8{0} ** 16;
    try testing.expectError(error.UnexpectedContentType, rl.decrypt(&buf));
}

test "decrypt: payload shorter than tag" {
    var rl: RecordLayer = .{ .aead = .initAes128Gcm(@splat(0)), .iv = @splat(0) };
    var buf = [_]u8{ 23, 0x03, 0x03, 0x00, 0x04 } ++ [_]u8{0} ** 4;
    try testing.expectError(error.RecordTooShort, rl.decrypt(&buf));
}

test "decrypt: sequence number overflow" {
    var rl: RecordLayer = .{ .aead = .initAes128Gcm(@splat(0)), .iv = @splat(0), .seq = std.math.maxInt(u64) };
    var buf = [_]u8{ 23, 0x03, 0x03, 0x00, 0x14 } ++ [_]u8{0} ** 20;
    try testing.expectError(error.SequenceNumberOverflow, rl.decrypt(&buf));
}
