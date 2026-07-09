//! TLS 1.3 record protection — one direction of a TLS connection (read or write).
//!
//! Composes record framing, nonce construction, and AEAD to implement
//! TLSCiphertext encrypt/decrypt. RFC 8446 §5.2
const std = @import("std");
const mem = std.mem;
const testing = std.testing;
const fuzz_compat = @import("fuzz_compat.zig");
const math = std.math;

const aead_mod = @import("aead.zig");
const Aead = aead_mod.Aead;
const AeadContext = aead_mod.Context;
const AeadError = aead_mod.Error;
const Aes128GcmKey = aead_mod.Aes128GcmKey;
const Iv = aead_mod.Iv;
const Tag = aead_mod.Tag;
const tag_len = aead_mod.tag_len;
const construct = aead_mod.construct;
const backend = @import("crypto/backend.zig");
const frame = @import("frame.zig");
const ContentType = frame.ContentType;
const Header = frame.Header;
const memx = @import("memx.zig");

const RecordLayer = @This();

pub const DecryptedRecord = struct {
    content_type: ContentType,
    /// Subslice of the caller-provided output buffer — no copy.
    content: []u8,
};

/// Linux kTLS cipher type values from include/uapi/linux/tls.h.
/// These are kernel UAPI values, not TLS cipher-suite code points.
pub const KtlsCipherType = enum(u16) {
    aes_gcm_128 = 51,
    aes_gcm_256 = 52,
    chacha20_poly1305 = 54,
};

/// TLS 1.3 traffic-key material packed for a caller that wants to configure
/// Linux kTLS. This is a value type: it copies secret material out of
/// RecordLayer so callers never borrow slices into state that deinit() will
/// secure-zero.
pub const KtlsInfo = struct {
    version: u16 = 0x0304,
    cipher_type: KtlsCipherType,
    key: [32]u8 = @splat(0),
    key_len: u8,
    salt: [4]u8 = @splat(0),
    salt_len: u8,
    iv: [12]u8 = @splat(0),
    iv_len: u8,
    rec_seq: [8]u8,
};

/// Bytes added to plaintext length to produce the encrypted wire record.
/// Accounts for the 5-byte header, content type byte, and 16-byte AEAD tag.
pub const overhead = frame.header_len + 1 + tag_len;

aead: Aead,
iv: Iv,
seq: u64 = 0,
key_limit: u64,
ctx: AeadContext,

pub fn init(aead_: Aead, iv_: Iv) AeadError!RecordLayer {
    return .{
        .aead = aead_,
        .iv = iv_,
        .key_limit = aead_.keyUsageLimit(),
        .ctx = try .init(aead_),
    };
}

// Traffic key material is deliberately left caller-visible as zeroed bytes for audit tests.
// ziglint-ignore: Z030
pub fn deinit(self: *RecordLayer) void {
    self.ctx.deinit();
    std.crypto.secureZero(u8, mem.asBytes(self));
}

pub fn clone(self: *const RecordLayer) AeadError!RecordLayer {
    var copy: RecordLayer = try .init(self.aead, self.iv);
    copy.seq = self.seq;
    return copy;
}

/// Export the current traffic key, base IV, and sequence number for caller-side
/// Linux kTLS setup. RFC 8446 §5.3 constructs the per-record nonce from the
/// 12-byte IV XOR sequence number; Linux kTLS splits AES-GCM IVs into a 4-byte
/// salt and 8-byte IV but uses the same nonce construction.
pub fn ktlsInfo(self: *const RecordLayer) KtlsInfo {
    var info: KtlsInfo = switch (self.aead) {
        .aes_128_gcm_sha256 => |key| .{
            .cipher_type = .aes_gcm_128,
            .key_len = key.data.len,
            .salt_len = 4,
            .iv_len = 8,
            .rec_seq = memx.toBytes(u64, self.seq),
        },
        .aes_256_gcm_sha384 => |key| .{
            .cipher_type = .aes_gcm_256,
            .key_len = key.data.len,
            .salt_len = 4,
            .iv_len = 8,
            .rec_seq = memx.toBytes(u64, self.seq),
        },
        .chacha20_poly1305_sha256 => |key| .{
            .cipher_type = .chacha20_poly1305,
            .key_len = key.data.len,
            .salt_len = 0,
            .iv_len = 12,
            .rec_seq = memx.toBytes(u64, self.seq),
        },
    };

    switch (self.aead) {
        inline else => |key| info.key[0..key.data.len].* = key.data,
    }
    switch (self.aead) {
        .aes_128_gcm_sha256, .aes_256_gcm_sha384 => {
            info.salt = self.iv.data[0..4].*;
            info.iv[0..8].* = self.iv.data[4..12].*;
        },
        .chacha20_poly1305_sha256 => info.iv = self.iv.data,
    }
    return info;
}

pub const DecryptError = frame.ParseError || AeadError || error{
    UnexpectedContentType,
    RecordTooShort,
    SequenceNumberOverflow,
    KeyUpdateRequired,
    InvalidInnerPlaintext,
};

pub const EncryptError = AeadError || error{
    /// `out` is smaller than the resulting record.
    BufferTooShort,
    /// 2^64 records sent on this layer (RFC 8446 §5.5).
    SequenceNumberOverflow,
    /// AEAD usage limit reached for this traffic key (RFC 8446 §5.5).
    KeyUpdateRequired,
    /// `content` exceeds the per-record plaintext limit (RFC 8446 §5.2); the
    /// caller must fragment into multiple records.
    PlaintextTooLarge,
};

/// Decrypt a TLSCiphertext record in place.
///
/// `buf` must contain the full record as received from the wire
/// (header + encrypted payload). Decryption overwrites the ciphertext
/// portion of `buf` with the plaintext. The returned `DecryptedRecord.content`
/// is a subslice of `buf` — no allocation, no copy.
///
/// Sequence number increments only on successful authentication.
///
/// On `error.AuthenticationFailed`, the ciphertext region of `buf` is
/// backend-owned failure output. Some backends leave unauthenticated plaintext;
/// others zero it. Callers must treat `buf` as poisoned after this error and
/// must not inspect, log, or reuse its contents.
///
/// RFC 8446 §5.2
// ziglint-ignore: Z015 -- DecryptError is a public error-set alias.
pub fn decrypt(self: *RecordLayer, buf: []u8) DecryptError!DecryptedRecord {
    try self.checkSequenceLimit();

    const hdr = try frame.parseHeader(buf);
    // RecordLayer is scoped to the post-handshake application data path.
    // All encrypted records on the wire are application_data (RFC 8446 §5.2).
    // The handshake layer handles pre-handshake record types, including
    // silently discarding change_cipher_spec (RFC 8446 §D.4).
    if (hdr.content_type != .application_data) {
        @branchHint(.cold);
        return error.UnexpectedContentType;
    }

    const payload_len = hdr.length();
    if (buf.len - frame.header_len < payload_len) {
        @branchHint(.cold);
        return error.BufferTooShort;
    }
    if (payload_len <= tag_len) {
        @branchHint(.cold);
        return error.RecordTooShort;
    }

    const ct_len = payload_len - tag_len;
    const payload = buf[frame.header_len..][0..payload_len];
    const inner = payload[0..ct_len];
    const tag: Tag = .init(payload[ct_len..][0..tag_len].*);

    const npub = construct(&self.iv, self.seq);
    // Decrypt in place: inner holds ciphertext on entry, plaintext on exit.
    try self.aead.decrypt(&self.ctx, inner, inner, &tag, buf[0..frame.header_len], &npub);

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
// ziglint-ignore: Z015 -- EncryptError is a public error-set alias.
pub fn encrypt(
    self: *RecordLayer,
    content_type: ContentType,
    content: []const u8,
    out: []u8,
) EncryptError![]u8 {
    try self.checkSequenceLimit();
    if (content.len > frame.max_plaintext_len) return error.PlaintextTooLarge;

    const inner_len = content.len + 1; // content + type byte
    const total = frame.header_len + inner_len + tag_len;
    if (out.len < total) return error.BufferTooShort;

    const inner = out[frame.header_len..][0..inner_len];

    // Write TLSInnerPlaintext: content || real ContentType byte.
    @memcpy(inner[0..content.len], content);
    return self.encryptPrepared(content_type, content.len, out);
}

/// Encrypt a TLS record after the caller has already written plaintext into
/// `out[5..][0..content_len]`. This avoids the plaintext copy in `encrypt` for
/// producers that can serialize directly into the record buffer.
// ziglint-ignore: Z015 -- EncryptError is a public error-set alias.
pub fn encryptPrepared(
    self: *RecordLayer,
    content_type: ContentType,
    content_len: usize,
    out: []u8,
) EncryptError![]u8 {
    try self.checkSequenceLimit();
    if (content_len > frame.max_plaintext_len) return error.PlaintextTooLarge;

    const inner_len = content_len + 1;
    const total = frame.header_len + inner_len + tag_len;
    if (out.len < total) return error.BufferTooShort;

    const inner = out[frame.header_len..][0..inner_len];
    var tag: Tag = undefined;

    const header: Header = .init(.application_data, @intCast(inner_len + tag_len));
    const hdr = out[0..frame.header_len];
    hdr.* = mem.toBytes(header);
    inner[content_len] = @intFromEnum(content_type);

    const npub = construct(&self.iv, self.seq);
    try self.aead.encrypt(&self.ctx, inner, &tag, inner, hdr, &npub);
    out[frame.header_len + inner_len ..][0..tag_len].* = tag.data;

    self.seq += 1;
    return out[0..total];
}

fn checkSequenceLimit(
    self: *const RecordLayer,
) (error{ SequenceNumberOverflow, KeyUpdateRequired })!void {
    if (self.seq == math.maxInt(u64)) {
        @branchHint(.cold);
        return error.SequenceNumberOverflow;
    }
    if (self.seq >= self.key_limit) {
        @branchHint(.cold);
        return error.KeyUpdateRequired;
    }
}

// RFC 8446 §5.2 — record protection

test "encrypt: buffer too short" {
    var rl: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = .zero }, .zero);
    defer rl.deinit();
    var buf: [4]u8 = undefined;
    try testing.expectError(error.BufferTooShort, rl.encrypt(.application_data, "hello", &buf));
}

test "encrypt: sequence number overflow" {
    var rl: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = .zero }, .zero);
    defer rl.deinit();
    rl.key_limit = math.maxInt(u64);
    rl.seq = math.maxInt(u64);
    var buf: [64]u8 = undefined;
    try testing.expectError(
        error.SequenceNumberOverflow,
        rl.encrypt(.application_data, "hello", &buf),
    );
}

// RFC 8446 §5.5 — endpoints cannot protect more records than the AEAD usage limit permits.
// RFC 8446 §7.1 — traffic keys are secret keying material and are cleared on teardown.
test "deinit: clears caller-visible traffic key material" {
    const key: Aes128GcmKey = .init(@splat(0xab));
    const iv: Iv = .init(@splat(0xcd));
    var rl: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = key }, iv);
    rl.deinit();
    try testing.expectEqualSlices(u8, &([_]u8{0} ** @sizeOf(Aead)), mem.asBytes(&rl.aead));
    try testing.expectEqualSlices(u8, &Iv.zero.data, &rl.iv.data);
    try testing.expectEqual(@as(u64, 0), rl.seq);
    try testing.expectEqual(@as(u64, 0), rl.key_limit);
}

// RFC 8446 §5.3 — Linux kTLS AES-GCM salt/IV split reconstructs the TLS 1.3 nonce.
test "ktlsInfo: AES-GCM salt and IV reconstruct RFC 8446 nonce" {
    const key: Aes128GcmKey = .init(@splat(0xab));
    const iv: Iv = .init(.{
        0x00, 0x01, 0x02, 0x03,
        0x04, 0x05, 0x06, 0x07,
        0x08, 0x09, 0x0a, 0x0b,
    });
    var rl: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = key }, iv);
    defer rl.deinit();
    rl.seq = 0x0102030405060708;

    const info = rl.ktlsInfo();
    try testing.expectEqual(@as(u16, 0x0304), info.version);
    try testing.expectEqual(KtlsCipherType.aes_gcm_128, info.cipher_type);
    try testing.expectEqual(@as(u8, 16), info.key_len);
    try testing.expectEqual(@as(u8, 4), info.salt_len);
    try testing.expectEqual(@as(u8, 8), info.iv_len);
    try testing.expectEqualSlices(u8, &key.data, info.key[0..info.key_len]);
    try testing.expectEqualSlices(u8, iv.data[0..4], &info.salt);
    try testing.expectEqualSlices(u8, iv.data[4..12], info.iv[0..info.iv_len]);
    try testing.expectEqualSlices(u8, &memx.toBytes(u64, rl.seq), &info.rec_seq);

    var kernel_nonce: [12]u8 = undefined;
    kernel_nonce[0..4].* = info.salt;
    kernel_nonce[4..12].* = info.iv[0..8].*;
    for (kernel_nonce[4..12], info.rec_seq) |*byte, seq_byte| byte.* ^= seq_byte;

    const expected = construct(&iv, rl.seq);
    try testing.expectEqualSlices(u8, &expected.data, &kernel_nonce);
}

// Linux kTLS UAPI values are not TLS cipher-suite code points.
test "ktlsInfo: cipher type uses Linux UAPI values" {
    var aes256: RecordLayer = try .init(.{ .aes_256_gcm_sha384 = .init(@splat(0x22)) }, .zero);
    defer aes256.deinit();
    var chacha: RecordLayer = try .init(
        .{ .chacha20_poly1305_sha256 = .init(@splat(0x33)) },
        .zero,
    );
    defer chacha.deinit();

    const aes_info = aes256.ktlsInfo();
    const chacha_info = chacha.ktlsInfo();
    try testing.expectEqual(KtlsCipherType.aes_gcm_256, aes_info.cipher_type);
    try testing.expectEqual(@as(u16, 52), @intFromEnum(aes_info.cipher_type));
    try testing.expectEqual(KtlsCipherType.chacha20_poly1305, chacha_info.cipher_type);
    try testing.expectEqual(@as(u16, 54), @intFromEnum(chacha_info.cipher_type));
    try testing.expectEqual(@as(u8, 0), chacha_info.salt_len);
    try testing.expectEqual(@as(u8, 12), chacha_info.iv_len);
}

// RFC 8446 §7.1 — exported kTLS key material is copied before RecordLayer zeroes itself.
test "ktlsInfo: exported key material survives RecordLayer deinit" {
    const key: Aes128GcmKey = .init(@splat(0xab));
    var rl: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = key }, .zero);
    const info = rl.ktlsInfo();
    rl.deinit();
    try testing.expectEqualSlices(u8, &key.data, info.key[0..info.key_len]);
}

test "encrypt/decrypt: key update required at AEAD usage limit" {
    var tx: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = .zero }, .zero);
    defer tx.deinit();
    tx.key_limit = 0;
    var buf: [64]u8 = undefined;
    try testing.expectError(error.KeyUpdateRequired, tx.encrypt(.application_data, "hello", &buf));

    var rx: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = .zero }, .zero);
    defer rx.deinit();
    rx.key_limit = 0;
    try testing.expectError(error.KeyUpdateRequired, rx.decrypt(&buf));
}

test "encryptPrepared/decrypt: round-trip" {
    const key: Aes128GcmKey = .init(@splat(0xab));
    const iv: Iv = .init(@splat(0xcd));
    var tx: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = key }, iv);
    defer tx.deinit();
    var rx: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = key }, iv);
    defer rx.deinit();

    const plaintext = "hello, ztls";
    var buf: [frame.header_len + plaintext.len + 1 + tag_len]u8 = undefined;
    @memcpy(buf[frame.header_len..][0..plaintext.len], plaintext);

    const record_buf = try tx.encryptPrepared(.application_data, plaintext.len, &buf);
    const result = try rx.decrypt(record_buf);

    try testing.expectEqual(.application_data, result.content_type);
    try testing.expectEqualSlices(u8, plaintext, result.content);
}

test "encrypt/decrypt: round-trip" {
    const key: Aes128GcmKey = .init(@splat(0xab));
    const iv: Iv = .init(@splat(0xcd));
    var tx: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = key }, iv);
    defer tx.deinit();
    var rx: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = key }, iv);
    defer rx.deinit();

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
    var tx: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = key }, iv);
    defer tx.deinit();
    var rx: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = key }, iv);
    defer rx.deinit();

    var buf: [frame.header_len + 5 + 1 + tag_len]u8 = undefined;

    for (0..3) |_| {
        const encrypted = try tx.encrypt(.application_data, "hello", &buf);
        _ = try rx.decrypt(encrypted);
    }
    try testing.expectEqual(@as(u64, 3), tx.seq);
    try testing.expectEqual(@as(u64, 3), rx.seq);
}

// RFC 8446 §5.2 — on AEAD authentication failure the caller buffer contents are
// backend-owned. OpenSSL EVP writes unauthenticated plaintext before tag
// verification; AWS-LC EVP_AEAD zeroes the output on failure. This is not a ztls
// correctness assertion, but the test pins the per-backend behavior explicitly.
test "decrypt: failed auth exposes backend failure buffer behavior" {
    const key: Aes128GcmKey = .init(@splat(0xab));
    const iv: Iv = .init(@splat(0xcd));
    var tx: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = key }, iv);
    defer tx.deinit();
    var rx: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = key }, iv);
    defer rx.deinit();

    const plaintext = "CENSORED_AFTER_AUTH_FAIL";
    const record_len = frame.header_len + plaintext.len + 1 + tag_len;
    var wire: [record_len]u8 = undefined;
    const record = try tx.encrypt(.application_data, plaintext, &wire);

    const tag_offset = record.len - tag_len;
    const inner_len = record.len - frame.header_len - tag_len;

    // Tamper with one byte of the tag in a copy of the wire record.
    var tampered: [record_len]u8 = undefined;
    @memcpy(&tampered, record);
    tampered[tag_offset] ^= 0xff;

    // Auth failure: seq must not advance.
    try testing.expectError(error.AuthenticationFailed, rx.decrypt(&tampered));
    try testing.expectEqual(@as(u64, 0), rx.seq);

    const inner = tampered[frame.header_len..][0..inner_len];
    switch (backend.active) {
        .openssl, .@"openssl-fips" => {
            // OpenSSL EVP decrypt-before-verify writes real plaintext into the
            // caller buffer before the tag check fails.
            try testing.expectEqualSlices(u8, plaintext, inner[0..plaintext.len]);
            try testing.expectEqual(
                @as(u8, @intFromEnum(ContentType.application_data)),
                inner[plaintext.len],
            );
        },
        .@"aws-lc", .@"aws-lc-fips" => {
            // AWS-LC EVP_AEAD promises to zero output on authentication failure.
            for (inner) |byte| try testing.expectEqual(@as(u8, 0), byte);
        },
        .boringssl => unreachable,
    }

    // Prove only the tampered record's buffer is poisoned, not context state:
    // a subsequent valid record (same sequence, fresh buffer) still decrypts.
    var fresh: [record_len]u8 = undefined;
    @memcpy(&fresh, record);
    const result = try rx.decrypt(&fresh);
    try testing.expectEqualSlices(u8, plaintext, result.content);
}

// RFC 8446 §5.2, §5.3 — replaying ciphertext under a later sequence number
// fails AEAD authentication and does not advance the receive sequence again.
test "decrypt: replayed record is rejected" {
    const key: Aes128GcmKey = .init(@splat(0x01));
    const iv: Iv = .init(@splat(0x02));
    var tx: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = key }, iv);
    defer tx.deinit();
    var rx: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = key }, iv);
    defer rx.deinit();

    var wire: [frame.header_len + 5 + 1 + tag_len]u8 = undefined;
    const record = try tx.encrypt(.application_data, "hello", &wire);
    var replay: [wire.len]u8 = undefined;
    @memcpy(replay[0..record.len], record);

    _ = try rx.decrypt(record);
    try testing.expectEqual(@as(u64, 1), rx.seq);
    try testing.expectError(error.AuthenticationFailed, rx.decrypt(replay[0..record.len]));
    try testing.expectEqual(@as(u64, 1), rx.seq);
}

// RFC 8446 §5.2 — zero-length application data is protected as an inner
// plaintext containing only the real content type byte.
test "encrypt/decrypt: zero-length application data" {
    const key: Aes128GcmKey = .init(@splat(0xab));
    const iv: Iv = .init(@splat(0xcd));
    var tx: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = key }, iv);
    defer tx.deinit();
    var rx: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = key }, iv);
    defer rx.deinit();

    var buf: [frame.header_len + 1 + tag_len]u8 = undefined;
    const record = try tx.encrypt(.application_data, "", &buf);
    const dec = try rx.decrypt(record);

    try testing.expectEqual(.application_data, dec.content_type);
    try testing.expectEqual(@as(usize, 0), dec.content.len);
}

// RFC 8446 §5.4 — an all-zero TLSInnerPlaintext has no content type and must
// be rejected after AEAD authentication succeeds.
test "decrypt: rejects all-zero inner plaintext" {
    const key: Aes128GcmKey = .init(@splat(0xab));
    const iv: Iv = .init(@splat(0xcd));
    var tx: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = key }, iv);
    defer tx.deinit();
    var rx: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = key }, iv);
    defer rx.deinit();

    const inner_len = 3;
    var buf: [frame.header_len + inner_len + tag_len]u8 = undefined;
    const header: Header = .init(.application_data, inner_len + tag_len);
    buf[0..frame.header_len].* = mem.toBytes(header);
    @memset(buf[frame.header_len..][0..inner_len], 0);

    var tag: Tag = undefined;
    const npub = construct(&tx.iv, tx.seq);
    try tx.aead.encrypt(
        &tx.ctx,
        buf[frame.header_len..][0..inner_len],
        &tag,
        buf[frame.header_len..][0..inner_len],
        buf[0..frame.header_len],
        &npub,
    );
    buf[frame.header_len + inner_len ..][0..tag_len].* = tag.data;

    try testing.expectError(error.InvalidInnerPlaintext, rx.decrypt(&buf));
}

// RFC 8446 §5.2 — TLSInnerPlaintext length is the application fragment plus
// the inner content type, and the encrypted record carries the AEAD tag.
test "encrypt/decrypt: maximum plaintext fragment length" {
    var tx: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = .zero }, .zero);
    defer tx.deinit();
    var rx: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = .zero }, .zero);
    defer rx.deinit();

    var plaintext: [frame.max_plaintext_len]u8 = @splat(0xaa);
    var buf: [frame.header_len + frame.max_plaintext_len + 1 + tag_len]u8 = undefined;
    const record = try tx.encrypt(.application_data, &plaintext, &buf);
    const dec = try rx.decrypt(record);

    try testing.expectEqual(@as(usize, buf.len), record.len);
    try testing.expectEqual(.application_data, dec.content_type);
    try testing.expectEqualSlices(u8, &plaintext, dec.content);
}

// RFC 8446 §5.2 — encrypted records carry outer content type application_data.
test "decrypt: wrong content type" {
    var rl: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = .zero }, .zero);
    defer rl.deinit();
    var buf = [_]u8{ 22, 0x03, 0x03, 0x00, 0x10 } ++ [_]u8{0} ** 16;
    try testing.expectError(error.UnexpectedContentType, rl.decrypt(&buf));
}

// RFC 8446 §5.2 — TLSCiphertext must carry an AEAD tag plus inner content type.
test "decrypt: payload shorter than tag" {
    var rl: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = .zero }, .zero);
    defer rl.deinit();
    var buf = [_]u8{ 23, 0x03, 0x03, 0x00, 0x04 } ++ [_]u8{0} ** 4;
    try testing.expectError(error.RecordTooShort, rl.decrypt(&buf));
}

// RFC 8446 §5.2 — the record length field must fit in the received buffer.
test "decrypt: truncated ciphertext record" {
    var rl: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = .zero }, .zero);
    defer rl.deinit();
    var buf = [_]u8{ 23, 0x03, 0x03, 0x00, 0x20 } ++ [_]u8{0} ** 8;
    try testing.expectError(error.BufferTooShort, rl.decrypt(&buf));
}

// RFC 8446 §5.3 — sequence numbers cannot wrap within one traffic key.
test "decrypt: sequence number overflow" {
    var rl: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = .zero }, .zero);
    defer rl.deinit();
    rl.seq = math.maxInt(u64);
    var buf = [_]u8{ 23, 0x03, 0x03, 0x00, 0x14 } ++ [_]u8{0} ** 20;
    try testing.expectError(error.SequenceNumberOverflow, rl.decrypt(&buf));
}

// RFC 8446 §5.2 — record decryption must reject arbitrary TLSCiphertext bytes
// without panics, out-of-bounds access, or sequence desynchronization.
fn fuzzDecrypt(_: void, input: []const u8) anyerror!void {
    var rl: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = .zero }, .zero);
    defer rl.deinit();

    var buf: [frame.max_wire_record_len + 64]u8 = undefined;
    const n = @min(input.len, buf.len);
    @memcpy(buf[0..n], input[0..n]);
    _ = rl.decrypt(buf[0..n]) catch return;
}

// RFC 8446 §5.2 — malformed encrypted records are covered by fuzzing.
test "fuzz: decrypt handles arbitrary input" {
    const tag_only = [_]u8{ 23, 0x03, 0x03, 0x00, 0x10 } ++ @as([16]u8, @splat(0));
    const corpus: []const []const u8 = &.{
        &.{},
        &.{ 23, 0x03, 0x03, 0x00, 0x04 },
        &tag_only,
    };
    try fuzz_compat.fuzzBytes(fuzzDecrypt, {}, .{ .corpus = corpus });
}
