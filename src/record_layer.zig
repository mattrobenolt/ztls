/// TLS 1.3 record protection layer.
///
/// Composes record framing, nonce construction, and AEAD to implement
/// TLSCiphertext encrypt/decrypt. RFC 8446 §5.2
const std = @import("std");
const testing = std.testing;
const Aes128Gcm = std.crypto.aead.aes_gcm.Aes128Gcm;

const Aead = @import("aead.zig").Aead;
const construct = @import("nonce.zig").construct;
const Iv = @import("aead.zig").Iv;
const record = @import("record.zig");
const Tag = @import("aead.zig").Tag;
const tag_len = @import("aead.zig").tag_len;



/// Protection state for one direction of a TLS connection (read or write).
///
/// The caller maintains two of these — one for each direction.
pub const RecordLayer = struct {
    aead: Aead,
    iv: Iv,
    seq: u64 = 0,

    /// Decrypt a TLSCiphertext record from `buf` into `out`.
    ///
    /// `buf` is the full record as received from the wire (header + encrypted payload).
    /// `out` must be at least `buf.len - header_len - tag_len` bytes.
    /// Sequence number increments only on successful authentication.
    ///
    /// RFC 8446 §5.2
    pub fn decrypt(self: *RecordLayer, buf: []const u8, out: []u8) !record.DecryptedRecord {
        if (self.seq == std.math.maxInt(u64)) {
            @branchHint(.cold);
            return error.SequenceNumberOverflow;
        }

        const hdr = try record.parseHeader(buf);
        if (hdr.content_type != .application_data) return error.UnexpectedContentType;

        const payload_len = hdr.length();
        if (payload_len < tag_len) return error.RecordTooShort;

        const ct_len = payload_len - tag_len;
        if (out.len < ct_len) return error.BufferTooShort;

        const payload = buf[record.header_len..][0..payload_len];
        const ciphertext = payload[0..ct_len];
        const tag: *const Tag = payload[ct_len..][0..tag_len];

        const npub = construct(&self.iv, self.seq);
        try self.aead.decrypt(out[0..ct_len], ciphertext, tag, buf[0..record.header_len], &npub);

        self.seq += 1;

        // RFC 8446 §5.2: scan back for last non-zero byte — that's the real ContentType.
        var i = ct_len;
        while (i > 0) {
            i -= 1;
            if (out[i] != 0) return .{
                .content_type = @enumFromInt(out[i]),
                .content = out[0..i],
            };
        }
        return error.InvalidInnerPlaintext;
    }
};

// RFC 8446 §5.2 — record protection

test "decrypt: wrong content type" {
    var rl: RecordLayer = .{
        .aead = .initAes128Gcm(@splat(0)),
        .iv = @splat(0),
    };
    // handshake record, not application_data
    const buf = [_]u8{ 22, 0x03, 0x03, 0x00, 0x10 } ++ [_]u8{0} ** 16;
    var out: [16]u8 = undefined;
    try testing.expectError(error.UnexpectedContentType, rl.decrypt(&buf, &out));
}

test "decrypt: payload shorter than tag" {
    var rl: RecordLayer = .{
        .aead = .initAes128Gcm(@splat(0)),
        .iv = @splat(0),
    };
    // application_data but only 4 bytes payload — less than tag_len (16)
    const buf = [_]u8{ 23, 0x03, 0x03, 0x00, 0x04 } ++ [_]u8{0} ** 4;
    var out: [4]u8 = undefined;
    try testing.expectError(error.RecordTooShort, rl.decrypt(&buf, &out));
}

test "decrypt: output buffer too small" {
    var rl: RecordLayer = .{
        .aead = .initAes128Gcm(@splat(0)),
        .iv = @splat(0),
    };
    // 20 bytes payload = 4 bytes ciphertext + 16 bytes tag
    const buf = [_]u8{ 23, 0x03, 0x03, 0x00, 0x14 } ++ [_]u8{0} ** 20;
    var out: [3]u8 = undefined; // needs 4
    try testing.expectError(error.BufferTooShort, rl.decrypt(&buf, &out));
}

test "decrypt: sequence number overflow" {
    var rl: RecordLayer = .{
        .aead = .initAes128Gcm(@splat(0)),
        .iv = @splat(0),
        .seq = std.math.maxInt(u64),
    };
    const buf = [_]u8{ 23, 0x03, 0x03, 0x00, 0x14 } ++ [_]u8{0} ** 20;
    var out: [4]u8 = undefined;
    try testing.expectError(error.SequenceNumberOverflow, rl.decrypt(&buf, &out));
}
