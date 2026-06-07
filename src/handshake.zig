//! Shared TLS 1.3 handshake wire helpers.
//!
//! RFC 8446 §4, §4.6.3
const std = @import("std");
const testing = std.testing;

const assert = std.debug.assert;

const RecordLayer = @import("RecordLayer.zig");
const wire = @import("wire.zig");

pub const max_post_handshake_messages = 16;
pub const SendError = RecordLayer.EncryptError || error{PendingWrite};
pub const KeyUpdateSender = enum { client, server };

// ziglint-ignore: Z015 -- SendError is public; ziglint does not follow imported error-set aliases.
pub fn sendApplicationData(self: anytype, plaintext: []const u8, out: []u8) SendError![]u8 {
    assert(self.state == .connected);
    if (self.pending_write.isPending()) return error.PendingWrite;
    const record = try self.tx.encrypt(.application_data, plaintext, out);
    self.pending_write.mark();
    return record;
}

// ziglint-ignore: Z015 -- SendError is public; ziglint does not follow imported error-set aliases.
pub fn sendPreparedApplicationData(
    self: anytype,
    plaintext_len: usize,
    out: []u8,
) SendError![]u8 {
    assert(self.state == .connected);
    if (self.pending_write.isPending()) return error.PendingWrite;
    const record = try self.tx.encryptPrepared(.application_data, plaintext_len, out);
    self.pending_write.mark();
    return record;
}

// ziglint-ignore: Z015 -- SendError is public; ziglint does not follow imported error-set aliases.
pub fn sendKeyUpdate(
    comptime sender: KeyUpdateSender,
    self: anytype,
    out: []u8,
    request: KeyUpdateRequest,
) SendError![]u8 {
    assert(self.state == .connected);
    if (self.pending_write.isPending()) return error.PendingWrite;
    const msg = [_]u8{
        @intFromEnum(Type.key_update), 0x00, 0x00, 0x01, @intFromEnum(request),
    };
    const record = try self.tx.encrypt(.handshake, &msg, out);
    const suite = if (@hasField(@TypeOf(self.*), "suite_state"))
        &self.suite_state
    else
        &self.suite;
    const next_tx = switch (sender) {
        .client => try suite.ratchetClientKey(),
        .server => try suite.ratchetServerKey(),
    };
    self.tx.deinit();
    self.tx = next_tx;
    self.pending_write.mark();
    return record;
}

/// RFC 8446 §4 — handshake message type. Open enum: unrecognized values pass
/// through the reader untouched; the state machine decides what is unexpected.
pub const Type = enum(u8) {
    new_session_ticket = 0x04,
    server_hello = 0x02,
    encrypted_extensions = 0x08,
    certificate_request = 0x0d,
    certificate = 0x0b,
    certificate_verify = 0x0f,
    finished = 0x14,
    key_update = 0x18,
    _,
};

/// RFC 8446 §4.6.3 — whether the KeyUpdate recipient must respond with its own.
pub const KeyUpdateRequest = enum(u8) {
    update_not_requested = 0,
    update_requested = 1,
};

/// Iterates handshake messages packed into one decrypted record payload.
pub const Reader = struct {
    r: wire.Reader,

    pub const Message = struct {
        type: Type,
        /// Full message including the 4-byte handshake header. This is what
        /// feeds the transcript hash.
        raw: []const u8,
    };

    pub fn init(buf: []const u8) Reader {
        return .{ .r = .init(buf) };
    }

    /// Return the next complete handshake message, or null when the payload is
    /// drained. On UnexpectedEof, `r.pos` is restored to the start of the
    /// partial message so the caller can retain exactly the unfinished suffix
    /// for cross-record reassembly.
    pub fn next(self: *Reader) error{UnexpectedEof}!?Message {
        if (self.r.remaining().len == 0) return null;
        const begin = self.r.pos;
        if (self.r.remaining().len < 4) {
            self.r.pos = begin;
            return error.UnexpectedEof;
        }
        const msg_type = try self.r.read(u8);
        const len = try self.r.read(u24);
        if (self.r.remaining().len < len) {
            self.r.pos = begin;
            return error.UnexpectedEof;
        }
        _ = try self.r.readSlice(len);
        return .{ .type = @enumFromInt(msg_type), .raw = self.r.buf[begin..self.r.pos] };
    }
};

/// Parse a KeyUpdate handshake message (4-byte header + 1-byte request).
pub fn parseKeyUpdate(msg: []const u8) error{ UnexpectedEof, IllegalParameter }!KeyUpdateRequest {
    if (msg.len != 5) return error.UnexpectedEof;
    return std.enums.fromInt(KeyUpdateRequest, msg[4]) orelse error.IllegalParameter;
}

// RFC 8446 §4 — handshake messages use a 1-byte type and 24-bit length.
test "Reader iterates coalesced messages" {
    const buf = [_]u8{
        @intFromEnum(Type.encrypted_extensions), 0, 0, 1, 0xaa,
        @intFromEnum(Type.finished),             0, 0, 1, 0xbb,
    };
    var r: Reader = .init(&buf);
    try testing.expectEqual(Type.encrypted_extensions, (try r.next()).?.type);
    try testing.expectEqual(Type.finished, (try r.next()).?.type);
    try testing.expectEqual(@as(?Reader.Message, null), try r.next());
}

// RFC 8446 §4.6.3 — KeyUpdate request byte is the only body byte.
test "parseKeyUpdate" {
    const msg = [_]u8{ @intFromEnum(Type.key_update), 0, 0, 1, 1 };
    try testing.expectEqual(KeyUpdateRequest.update_requested, try parseKeyUpdate(&msg));
}
