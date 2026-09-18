//! Shared TLS 1.3 engine helpers.
//!
//! Handshake wire helpers plus the connected record-path core shared by the
//! handshake engines and the compact `EstablishedSession` extracted at
//! handshake completion: record classification, KeyUpdate reassembly and
//! ratchet discipline, the encrypted alert path, and the connected event
//! shapes. RFC 8446 §4, §4.6.3, §5.1, §6.
const std = @import("std");
const testing = std.testing;

const assert = std.debug.assert;

const alert = @import("alert.zig");
const frame = @import("frame.zig");
const RecordLayer = @import("RecordLayer.zig");
const wire = @import("wire.zig");

pub const max_post_handshake_key_updates = 16;
pub const max_post_handshake_new_session_tickets = 32;
// Retained for the server-side KeyUpdate counter.
pub const max_post_handshake_messages = max_post_handshake_key_updates;
pub const SendError = RecordLayer.EncryptError || error{
    PendingWrite,
    PendingKeyUpdateResponse,
};
pub const KeyUpdateSender = enum { client, server };

/// RFC 8446 §4 — handshake messages use a 1-byte type and 24-bit length.
const handshake_header_len = 4;
/// RFC 8446 §4.6.3 — KeyUpdate is a 4-byte handshake header plus a 1-byte
/// request body, so a fixed 5-byte buffer reassembles one fragmented across
/// records (§5.1).
pub const key_update_body_len = 1;
pub const key_update_total_len = handshake_header_len + key_update_body_len;

/// Connected-state event for the record-entry APIs. `write` is handshake-time
/// only; a connected engine never returns it.
pub const Event = union(enum) {
    application_data: []const u8,
    write: []const u8,
    /// The peer's KeyUpdate ratcheted one or both traffic keys. See
    /// `KeyUpdateEvent` for details. RFC 8446 §4.6.3, §7.2.
    key_update: KeyUpdateEvent,
    none,
    closed,
};

/// Connected-state receive result. This path owns only RX state, so callers can
/// process inbound records while an unrelated TX record remains in flight.
pub const ReceiveEvent = union(enum) {
    application_data: []const u8,
    /// The RX key is already ratcheted. For `update_requested`, the caller MUST
    /// send `update_not_requested` before its next application-data record.
    /// RFC 8446 §4.6.3, §7.2.
    key_update: KeyUpdateRequest,
    none,
    closed,
};

/// Surfaced when a peer KeyUpdate changes one or both traffic-key epochs.
/// RFC 8446 §4.6.3. For kTLS callers: `rx` means the kernel RX path is paused
/// (EKEYEXPIRED) until the new key is installed via `setsockopt(TLS_RX)`;
/// `tx` means the caller must reinstall `TLS_TX` after writing `response` and
/// calling `completeWrite()`.
pub const KeyUpdateEvent = struct {
    /// Record to send first (the KeyUpdate response), or null if the peer sent
    /// `update_not_requested` and no response is needed. The caller MUST write
    /// this to the transport and call `completeWrite()` before reinstalling
    /// `TLS_TX`. The response is encrypted under the OLD TX key — the engine
    /// ratchets TX inside `sendKeyUpdate` after encryption.
    response: ?[]const u8,
    /// RX traffic key was ratcheted — caller must reinstall `TLS_RX`.
    rx: bool,
    /// TX traffic key was ratcheted (we are sending a KeyUpdate response) —
    /// caller must reinstall `TLS_TX` after writing `response` and calling
    /// `completeWrite()`.
    tx: bool,
};

pub const ReceiveError =
    RecordLayer.DecryptError || alert.ParseError ||
    error{ UnexpectedEof, UnexpectedRecord, UnexpectedMessage, IllegalParameter } ||
    error{ TooManyKeyUpdates, PeerAlert };
pub const AlertError = RecordLayer.EncryptError || error{ BufferTooShort, PendingWrite };

/// True when the engine type has `field`. Asserts the helper was called on a
/// mutable engine pointer.
fn requireEngineField(comptime T: type, comptime field: []const u8) bool {
    const Ptr = switch (@typeInfo(T)) {
        .pointer => |ptr| blk: {
            if (ptr.size != .one or ptr.is_const)
                @compileError("engine helpers expect a mutable engine pointer");
            break :blk ptr;
        },
        else => @compileError("engine helpers expect a mutable engine pointer"),
    };
    return @hasField(Ptr.child, field);
}

fn requireHandshakeShape(comptime T: type) void {
    // `state` is deliberately not required: the handshake engines carry it and
    // each helper asserts they are connected, while EstablishedSession has no
    // state field — it is connected by construction. ClientHandshake stores
    // suite state in `suite`; ServerHandshake stores it in `suite_state`;
    // ratchetKtlsTx keeps that distinction local.
    inline for (&.{ "pending_write", "key_update_obligation", "tx" }) |field| {
        if (!requireEngineField(T, field))
            @compileError("engine helpers expect a " ++ field ++ " field");
    }
}

/// Assert the connected precondition on engines that carry a `state` field.
/// EstablishedSession is connected by construction and carries none.
inline fn assertConnected(self: anytype) void {
    if (@hasField(@TypeOf(self.*), "state")) assert(self.state == .connected);
}

/// The field set every connected record path touches: traffic record layers,
/// KeyUpdate reassembly, the post-handshake flood counter, the latest peer
/// alert, the owed KeyUpdate response, and the TX latch. Suite state is named
/// `suite_state` on ServerHandshake and `suite` on ClientHandshake and
/// EstablishedSession.
fn requireEstablishedShape(comptime T: type) void {
    inline for (&.{
        "rx",                   "tx",              "ku_frag",
        "post_handshake_count", "last_peer_alert", "key_update_obligation",
        "pending_write",
    }) |field| {
        if (!requireEngineField(T, field))
            @compileError("established helpers expect a " ++ field ++ " field");
    }
    if (!requireEngineField(T, "suite_state") and !requireEngineField(T, "suite"))
        @compileError("established helpers expect a suite_state or suite field");
}

pub fn validateChangeCipherSpec(fragment: []const u8) error{UnexpectedRecord}!void {
    if (fragment.len != 1 or fragment[0] != 0x01) return error.UnexpectedRecord;
}

pub fn decryptProtected(
    rx: *RecordLayer,
    record: []u8,
) (RecordLayer.DecryptError || error{UnexpectedMessage})!RecordLayer.DecryptedRecord {
    return rx.decrypt(record) catch |err| switch (err) {
        error.InvalidInnerPlaintext => error.UnexpectedMessage,
        else => err,
    };
}

// ziglint-ignore: Z015 -- SendError is public; ziglint does not follow imported error-set aliases.
pub fn sendApplicationData(self: anytype, plaintext: []const u8, out: []u8) SendError![]u8 {
    comptime requireHandshakeShape(@TypeOf(self));
    assertConnected(self);
    if (self.pending_write.isPending()) return error.PendingWrite;
    if (self.key_update_obligation == .response_owed) {
        return error.PendingKeyUpdateResponse;
    }
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
    comptime requireHandshakeShape(@TypeOf(self));
    assertConnected(self);
    if (self.pending_write.isPending()) return error.PendingWrite;
    if (self.key_update_obligation == .response_owed) {
        return error.PendingKeyUpdateResponse;
    }
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
    comptime requireHandshakeShape(@TypeOf(self));
    assertConnected(self);
    if (self.pending_write.isPending()) return error.PendingWrite;
    var msg: [5]u8 = undefined;
    var writer: wire.Writer = .init(&msg);
    writer.append(Type, .key_update);
    writer.append(u24, 1);
    writer.append(KeyUpdateRequest, request);
    const record = try self.tx.encrypt(.handshake, &msg, out);
    try ratchetKtlsTx(sender, self, request);
    self.pending_write.mark();
    return record;
}

/// Advance the send traffic secret after an external TLS record layer has sent
/// a KeyUpdate under the old key. `request` describes the record already sent.
/// The caller must serialize the send and subsequent key installation around
/// this call. RFC 8446 §4.6.3.
// ziglint-ignore: Z015 -- SendError is public; ziglint does not follow imported error-set aliases.
pub fn ratchetKtlsTx(
    comptime sender: KeyUpdateSender,
    self: anytype,
    request: KeyUpdateRequest,
) SendError!void {
    comptime requireHandshakeShape(@TypeOf(self));
    assertConnected(self);
    if (self.pending_write.isPending()) return error.PendingWrite;
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
    if (request == .update_not_requested) self.key_update_obligation = .none;
}

/// Reassemble one post-handshake KeyUpdate from `content`, which may be a
/// fragment continuing `ku_frag` (RFC 8446 §5.1). Returns null while the
/// message is still incomplete. On completion: enforces the
/// consecutive-KeyUpdate flood cap, ratchets RX, and records an owed response
/// for update_requested (§4.6.3). Server role — an inbound KeyUpdate ratchets
/// the client (peer) application traffic secret.
fn reassembleServerKeyUpdate(self: anytype, content: []u8) ReceiveError!?KeyUpdateRequest {
    comptime requireEstablishedShape(@TypeOf(self));
    for (content, 0..) |byte, i| {
        if (self.ku_frag.len == 0 and byte != @intFromEnum(Type.key_update)) {
            self.ku_frag.clear();
            return error.UnexpectedMessage;
        }
        if (self.ku_frag.remainingCapacity() == 0) {
            self.ku_frag.clear();
            return error.UnexpectedMessage;
        }
        self.ku_frag.appendAssumeCapacity(byte);

        if (self.ku_frag.len < handshake_header_len) continue;

        const frag = self.ku_frag.constSlice();
        const body_len = (@as(usize, frag[1]) << 16) |
            (@as(usize, frag[2]) << 8) |
            (@as(usize, frag[3]));
        if (body_len != key_update_body_len) {
            self.ku_frag.clear();
            return error.UnexpectedEof;
        }
        if (self.ku_frag.len < key_update_total_len) continue;

        // RFC 8446 §5.1: a message immediately preceding a key change must
        // align with a record boundary. Reject before ratcheting if this
        // record contains anything after the KeyUpdate.
        if (self.ku_frag.len != key_update_total_len) unreachable;
        if (i + 1 != content.len) {
            self.ku_frag.clear();
            return error.UnexpectedMessage;
        }

        const request = parseKeyUpdate(frag) catch |err| {
            self.ku_frag.clear();
            return err;
        };
        self.post_handshake_count +|= 1;
        if (self.post_handshake_count > max_post_handshake_messages) {
            self.ku_frag.clear();
            return error.TooManyKeyUpdates;
        }
        const suite = if (@hasField(@TypeOf(self.*), "suite_state"))
            &self.suite_state
        else
            &self.suite;
        const next_rx = suite.ratchetClientKey() catch |err| {
            self.ku_frag.clear();
            return err;
        };
        self.rx.deinit();
        self.rx = next_rx;
        self.ku_frag.clear();
        if (request == .update_requested) {
            self.key_update_obligation = .response_owed;
        }

        return request;
    }
    return null;
}

/// Classify one decrypted connected-state record payload. Server role: the
/// connected receive path shared by ServerHandshake and the extracted
/// EstablishedSession. Application data resets the consecutive-KeyUpdate
/// counter (the flood cap); handshake content must be exactly one KeyUpdate
/// aligned to the record boundary (§5.1); alerts either close (close_notify,
/// §6.1) or surface as PeerAlert (§6.2).
// ziglint-ignore: Z015 -- ReceiveError is a public error-set alias.
pub fn serverReceivePlaintext(
    self: anytype,
    content_type: frame.ContentType,
    content: []u8,
) ReceiveError!ReceiveEvent {
    comptime requireEstablishedShape(@TypeOf(self));
    switch (content_type) {
        .application_data => {
            if (self.ku_frag.len != 0) {
                self.ku_frag.clear();
                return error.UnexpectedMessage;
            }
            if (content.len > 0) self.post_handshake_count = 0;
            return .{ .application_data = content };
        },
        .handshake => {
            if (content.len == 0) {
                self.ku_frag.clear();
                return error.UnexpectedMessage;
            }
            const request = (try reassembleServerKeyUpdate(self, content)) orelse return .none;
            return .{ .key_update = request };
        },
        .alert => {
            if (self.ku_frag.len != 0) {
                self.ku_frag.clear();
                return error.UnexpectedMessage;
            }
            const a = try alert.parse(content);
            if (a.isCloseNotify()) return .closed;
            self.last_peer_alert = a;
            return error.PeerAlert;
        },
        else => return error.UnexpectedRecord,
    }
}

/// Decrypt and classify one complete connected-state record. Server role;
/// mutates RX only, so an unrelated TX record may still be in flight.
// ziglint-ignore: Z015 -- ReceiveError is a public error-set alias.
pub fn serverReceiveRecord(self: anytype, record: []u8) ReceiveError!ReceiveEvent {
    comptime requireEstablishedShape(@TypeOf(self));
    const dec = try decryptProtected(&self.rx, record);
    return serverReceivePlaintext(self, dec.content_type, dec.content);
}

/// The server's connected handleRecord path: receive one record and, for an
/// inbound update_requested KeyUpdate, produce the response record in `out`
/// (RFC 8446 §4.6.3), encrypted under the old TX key.
pub fn serverHandleConnected(
    self: anytype,
    record: []u8,
    out: []u8,
) (ReceiveError || SendError)!Event {
    comptime requireEstablishedShape(@TypeOf(self));
    return switch (try serverReceiveRecord(self, record)) {
        .application_data => |data| .{ .application_data = data },
        .key_update => |request| if (request == .update_requested) blk: {
            const response = try sendKeyUpdate(.server, self, out, .update_not_requested);
            break :blk .{ .key_update = .{ .response = response, .rx = true, .tx = true } };
        } else .{ .key_update = .{ .response = null, .rx = true, .tx = false } },
        .none => .none,
        .closed => .closed,
    };
}

/// Serialize and encrypt one alert under the current TX key. close_notify is
/// warning-level; every other description is fatal (RFC 8446 §6.1, §6.2).
// ziglint-ignore: Z015 -- AlertError is a public error-set alias.
pub fn sendEstablishedAlert(
    self: anytype,
    description: alert.Description,
    out: []u8,
) AlertError![]const u8 {
    comptime requireHandshakeShape(@TypeOf(self));
    if (self.pending_write.isPending()) return error.PendingWrite;
    var msg: [2]u8 = undefined;
    const level: alert.Level = if (description == .close_notify) .warning else .fatal;
    _ = alert.encode(&msg, level, description) catch unreachable;
    const record = try self.tx.encrypt(.alert, &msg, out);
    self.pending_write.mark();
    return record;
}

/// RFC 8446 §4 — handshake message type. Open enum: unrecognized values pass
/// through the reader untouched; the state machine decides what is unexpected.
pub const Type = enum(u8) {
    client_hello = 0x01,
    server_hello = 0x02,
    end_of_early_data = 0x05,
    new_session_ticket = 0x04,
    encrypted_extensions = 0x08,
    certificate_request = 0x0d,
    certificate = 0x0b,
    certificate_verify = 0x0f,
    finished = 0x14,
    key_update = 0x18,
    message_hash = 0xfe,
    _,
};

/// RFC 8446 §4.6.3 — whether the KeyUpdate recipient must respond with its own.
pub const KeyUpdateRequest = enum(u8) {
    update_not_requested = 0,
    update_requested = 1,
};

pub const KeyUpdateObligation = enum(u8) {
    none,
    response_owed,
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
        const msg_type = self.r.assumeRead(Type);
        const len = self.r.assumeRead(u24);
        if (self.r.remaining().len < len) {
            self.r.pos = begin;
            return error.UnexpectedEof;
        }
        _ = self.r.assumeReadSlice(len);
        return .{ .type = msg_type, .raw = self.r.buf[begin..self.r.pos] };
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
