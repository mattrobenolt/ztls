//! TLS 1.3 record layer.
//!
//! Implements wire format parsing and encoding for TLS records per RFC 8446 §5.
//! No crypto here — just framing. AEAD encrypt/decrypt is a separate layer.
//!
//! Record layout on the wire:
//!
//!   ContentType     (1 byte)
//!   ProtocolVersion (2 bytes, always 0x0303 in TLS 1.3)
//!   length          (2 bytes, big-endian)
//!   fragment        (length bytes)
//!
//! After the handshake, all records are TLSCiphertext: the ContentType byte is
//! always application_data (23), and the real type is smuggled inside the AEAD
//! plaintext as TLSInnerPlaintext.
const std = @import("std");
const mem = std.mem;
const testing = std.testing;
const assert = std.debug.assert;

const ArrayBuffer = @import("array_buffer.zig").ArrayBuffer;
const memx = @import("memx.zig");
const ProtocolVersion = @import("protocol_version.zig").ProtocolVersion;

/// RFC 8446 §5.1 — maximum plaintext fragment length.
pub const max_plaintext_len = 1 << 14; // 16384

/// RFC 8446 §5.2 — maximum ciphertext length (plaintext + AEAD overhead).
/// "MUST NOT exceed 2^14 + 256 bytes."
pub const max_ciphertext_len = max_plaintext_len + 256; // 16640

/// Wire size of a record header.
pub const header_len = 5;

/// Largest a single record can be on the wire: header + maximum ciphertext.
/// An output buffer of this size always holds any one record we emit.
pub const max_wire_record_len = header_len + max_ciphertext_len;
pub const OutBuffer = ArrayBuffer(u8, max_wire_record_len);

/// RFC 8446 §5.1 — legacy_record_version is fixed at TLS 1.2 for all TLS 1.3
/// records after the initial ClientHello.
const legacy_record_version: ProtocolVersion = .tls_1_2;

/// RFC 8446 Appendix B.1
pub const ContentType = enum(u8) {
    invalid = 0,
    change_cipher_spec = 20,
    alert = 21,
    handshake = 22,
    application_data = 23,
    /// Unknown values are valid on the wire; ignore or alert as appropriate.
    _,
};

/// A TLS record header — exactly the 5-byte wire layout.
///
/// Uses extern struct with [2]u8 for big-endian u16 fields so the in-memory
/// layout matches the wire byte-for-byte. Use legacyVersion() and length()
/// to read the u16 fields in native byte order.
pub const Header = extern struct {
    content_type: ContentType,
    /// Always 0x0303 on the wire for TLS 1.3. Frozen for middlebox compatibility;
    /// actual version negotiation happens in the supported_versions extension.
    /// Not exposed — no caller should branch on this.
    legacy_version_be: [2]u8 = memx.toBytes(u16, @intFromEnum(legacy_record_version)),
    /// Big-endian payload length. Use length() to read as native u16.
    length_be: [2]u8,

    comptime {
        assert(@sizeOf(Header) == header_len);
        assert(@alignOf(Header) == 1);
    }

    pub inline fn length(self: Header) u16 {
        return memx.readInt(u16, &self.length_be);
    }

    pub inline fn write(self: Header, out: *[header_len]u8) void {
        out.* = mem.toBytes(self);
    }

    pub fn init(content_type: ContentType, len: u16) Header {
        var h: Header = .{
            .content_type = content_type,
            .length_be = undefined,
        };
        memx.writeInt(u16, &h.length_be, len);
        return h;
    }
};

pub const ParseError = error{
    /// Fewer than 5 bytes available.
    BufferTooShort,
    /// length field exceeds the RFC 8446 §5.2 maximum.
    RecordTooLarge,
};

/// Parse the 5-byte record header from the front of `buf`.
///
/// Returns the parsed header value. The fragment begins at `buf[header_len..]`
/// and is `header.length()` bytes long — caller ensures that many bytes are
/// available.
///
/// RFC 8446 §5.1, §5.2
pub fn parseHeader(buf: []const u8) ParseError!Header {
    if (buf.len < header_len) return error.BufferTooShort;
    const length = (@as(u16, buf[3]) << 8) | buf[4];
    if (length > max_ciphertext_len) {
        @branchHint(.cold);
        return error.RecordTooLarge;
    }
    return .init(@enumFromInt(buf[0]), length);
}

// RFC 8446 §5.1 — record header format
test "parseHeader: valid plaintext record" {
    // handshake record, version 0x0303, 100 bytes of fragment
    const buf = [_]u8{ 22, 0x03, 0x03, 0x00, 0x64 } ++ @as([100]u8, @splat(0));
    const h = try parseHeader(&buf);
    try testing.expectEqual(ContentType.handshake, h.content_type);
    try testing.expectEqual(@as(u16, 100), h.length());
}

test "parseHeader: application_data record (TLSCiphertext)" {
    const buf = [_]u8{ 23, 0x03, 0x03, 0x00, 0x10 } ++ @as([16]u8, @splat(0));
    const h = try parseHeader(&buf);
    try testing.expectEqual(ContentType.application_data, h.content_type);
    try testing.expectEqual(@as(u16, 16), h.length());
}

// RFC 8446 §5.1 — recipients ignore legacy_record_version.
test "parseHeader: ignores legacy_record_version" {
    const buf = [_]u8{ 22, 0x03, 0x01, 0x00, 0x10 } ++ @as([16]u8, @splat(0));
    const h = try parseHeader(&buf);
    try testing.expectEqual(ContentType.handshake, h.content_type);
    try testing.expectEqual(@as(u16, 16), h.length());
}

test "parseHeader: buffer too short" {
    const buf = [_]u8{ 23, 0x03, 0x03, 0x00 }; // only 4 bytes
    try testing.expectError(error.BufferTooShort, parseHeader(&buf));
}

test "parseHeader: exactly 5 bytes (header only, no fragment)" {
    const buf = [_]u8{ 21, 0x03, 0x03, 0x00, 0x00 };
    const h = try parseHeader(&buf);
    try testing.expectEqual(ContentType.alert, h.content_type);
    try testing.expectEqual(@as(u16, 0), h.length());
}

// RFC 8446 §5.2 — max ciphertext length is 2^14 + 256
test "parseHeader: max valid length" {
    const len: u16 = max_ciphertext_len;
    const buf = [_]u8{ 23, 0x03, 0x03, @intCast(len >> 8), @intCast(len & 0xff) };
    const h = try parseHeader(&buf);
    try testing.expectEqual(@as(u16, max_ciphertext_len), h.length());
}

test "parseHeader: length exceeds max" {
    const len: u16 = max_ciphertext_len + 1;
    const buf = [_]u8{ 23, 0x03, 0x03, @intCast(len >> 8), @intCast(len & 0xff) };
    try testing.expectError(error.RecordTooLarge, parseHeader(&buf));
}

test "Header.init round-trips with parseHeader" {
    var buf: [header_len]u8 = undefined;
    Header.init(.handshake, 512).write(&buf);
    const h = try parseHeader(&buf);
    try testing.expectEqual(ContentType.handshake, h.content_type);
    try testing.expectEqual(@as(u16, 512), h.length());
}

// RFC 8446 §5.1 — records ztls emits use TLS 1.2 legacy_record_version.
test "Header.write: emits TLS 1.2 legacy_record_version" {
    var buf: [header_len]u8 = undefined;
    Header.init(.handshake, 512).write(&buf);
    try testing.expectEqual(@as(u8, 0x03), buf[1]);
    try testing.expectEqual(@as(u8, 0x03), buf[2]);
}

// RFC 8446 §5.1 — TLSPlaintext header is 5 bytes: content_type (1) + legacy_version
// (2) + length (2). parseHeader must never panic on arbitrary input.
fn fuzzParseHeader(_: void, input: []const u8) anyerror!void {
    _ = parseHeader(input) catch return;
}

test "fuzz: parseHeader handles arbitrary input" {
    const corpus: []const []const u8 = &.{
        // valid handshake record header
        &.{ 22, 0x03, 0x03, 0x00, 0x10 },
        // valid application_data record header (max length)
        &.{ 23, 0x03, 0x03, 0x40, 0x00 },
        // truncated
        &.{ 23, 0x03 },
        // empty
        &.{},
    };
    try testing.fuzz({}, fuzzParseHeader, .{ .corpus = corpus });
}
