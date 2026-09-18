//! The compact established-session engine: what a connected TLS 1.3
//! connection needs for the rest of its life, and nothing else.
//!
//! Extracted from ServerHandshake at handshake completion
//! (`ServerHandshake.extractEstablished`). The full handshake state —
//! flight staging, ClientHello reassembly, transcript, key exchange,
//! ticket machinery — is the caller's to pool and return; only this
//! survives per connection. ~1.4 KiB against ServerHandshake's ~21 KiB.
//!
//! Semantics mirror ServerHandshake's connected paths exactly: the record
//! classification (application_data / KeyUpdate reassembly / alert), the
//! KeyUpdate response + ratchet discipline, the TX latch, and the
//! consecutive-KeyUpdate flood cap. RFC 8446 §4.6.3, §6.1, §6.2.

const std = @import("std");
const crypto = std.crypto;
const mem = std.mem;

const RecordLayer = @import("RecordLayer.zig");
const ServerHandshake = @import("ServerHandshake.zig");
const frame = @import("frame.zig");
const alert = @import("alert.zig");
const handshake = @import("handshake.zig");
const ArrayBuffer = @import("array_buffer.zig").ArrayBuffer;
const PendingWrite = @import("pending_write.zig").PendingWrite;

pub const EstablishedSession = @This();

const handshake_header_len = 4;
const key_update_body_len = 1;
const key_update_total_len = handshake_header_len + key_update_body_len;
const KeyUpdateFragmentBuffer = ArrayBuffer(u8, key_update_total_len);

const max_post_handshake_messages = handshake.max_post_handshake_messages;

/// Connected-state handle result: the same shapes ServerHandshake's
/// handleRecord produces, so callers dispatch identically before and
/// after extraction.
pub const Event = ServerHandshake.Event;

pub const ReceiveError = ServerHandshake.ReceiveError;
pub const SendError = ServerHandshake.SendError;
pub const AlertError = ServerHandshake.AlertError;
pub const HandleError = ReceiveError || SendError;

pub const KeyUpdateRequest = handshake.KeyUpdateRequest;

/// Receive record layer: traffic keys, AEAD, sequence numbers.
rx: RecordLayer,
/// Send record layer.
tx: RecordLayer,
/// Application-traffic secrets — the KeyUpdate ratchet derives fresh
/// RecordLayers from these (ratchetClientKey / ratchetServerKey).
suite: ServerHandshake.Suite,
/// Reassembles a post-handshake KeyUpdate fragmented across records
/// (RFC 8446 §5.1). KeyUpdate is a 4-byte header plus a 1-byte body.
ku_frag: KeyUpdateFragmentBuffer = .empty,
/// Consecutive post-handshake KeyUpdates without intervening app data —
/// the flood cap (a malicious peer cannot ratchet us forever).
post_handshake_count: u8 = 0,
/// Most recent non-close_notify peer alert; close_notify never sets it.
last_peer_alert: ?alert.Alert = null,
/// An inbound update_requested KeyUpdate must be answered before any
/// application data is sent (RFC 8446 §4.6.3).
key_update_obligation: handshake.KeyUpdateObligation = .none,
/// TX latch: set when a call hands the caller bytes that must be written
/// before more engine output is safe. Mirrors ServerHandshake's.
pending_write: PendingWrite = .idle,

pub fn deinit(self: *EstablishedSession) void {
    self.rx.deinit();
    self.tx.deinit();
    self.suite.secureZero();
    self.ku_frag.secureZero();
    self.* = undefined;
}

pub fn hasPendingWrite(self: *const EstablishedSession) bool {
    return self.pending_write.isPending();
}

pub fn completeWrite(self: *EstablishedSession) void {
    self.pending_write.clear();
}

pub fn hasPendingKeyUpdateResponse(self: *const EstablishedSession) bool {
    return self.key_update_obligation == .response_owed;
}

/// Most recent non-close_notify peer alert, or null.
pub fn lastPeerAlert(self: *const EstablishedSession) ?alert.Alert {
    return self.last_peer_alert;
}

/// Process one complete encrypted record: decrypt, classify, and — for an
/// inbound update_requested KeyUpdate — produce the response record in
/// `out`. Mirrors ServerHandshake's connected handleRecord path.
pub fn handle(self: *EstablishedSession, record: []u8, out: []u8) HandleError!Event {
    if (self.pending_write.isPending()) return error.PendingWrite;
    const ev: Event = switch (try self.receive(record)) {
        .application_data => |data| .{ .application_data = data },
        .key_update => |request| if (request == .update_requested) blk: {
            const response = try self.sendKeyUpdate(out, .update_not_requested);
            break :blk .{ .key_update = .{ .response = response, .rx = true, .tx = true } };
        } else .{ .key_update = .{ .response = null, .rx = true, .tx = false } },
        .none => .none,
        .closed => .closed,
    };
    return ev;
}

/// Decrypt and classify one complete record. RX-only: safe while an
/// unrelated TX record is in flight. Mirrors ServerHandshake.receiveRecord.
pub fn receive(self: *EstablishedSession, record: []u8) ReceiveError!ServerHandshake.ReceiveEvent {
    const dec = try handshake.decryptProtected(&self.rx, record);
    return self.receivePlaintext(dec.content_type, dec.content);
}

/// Serialize and encrypt one application-data record under the current TX
/// key. Refuses while a KeyUpdate response is owed (RFC 8446 §4.6.3).
pub fn sendApplicationData(
    self: *EstablishedSession,
    plaintext: []const u8,
    out: []u8,
) SendError![]u8 {
    if (self.pending_write.isPending()) return error.PendingWrite;
    if (self.key_update_obligation == .response_owed) {
        return error.PendingKeyUpdateResponse;
    }
    const record = try self.tx.encrypt(.application_data, plaintext, out);
    self.pending_write.mark();
    return record;
}

/// Send an alert through the established record path (encrypted).
/// close_notify is a warning-level alert; everything else is fatal.
pub fn sendAlert(
    self: *EstablishedSession,
    description: alert.Description,
    out: []u8,
) AlertError![]const u8 {
    if (self.pending_write.isPending()) return error.PendingWrite;
    var msg: [2]u8 = undefined;
    const level: alert.Level = if (description == .close_notify) .warning else .fatal;
    _ = alert.encode(&msg, level, description) catch unreachable;
    const record = try self.tx.encrypt(.alert, &msg, out);
    self.pending_write.mark();
    return record;
}

/// Serialize, encrypt, and send a KeyUpdate; then ratchet the TX key so
/// the update takes effect for subsequent records. Mirrors
/// handshake.sendKeyUpdate for the server role.
pub fn sendKeyUpdate(
    self: *EstablishedSession,
    out: []u8,
    request: KeyUpdateRequest,
) SendError![]const u8 {
    if (self.pending_write.isPending()) return error.PendingWrite;
    var msg: [5]u8 = undefined;
    msg[0] = @intFromEnum(handshake.Type.key_update);
    msg[1] = 0;
    msg[2] = 0;
    msg[3] = key_update_body_len;
    msg[4] = @intFromEnum(request);
    const record = try self.tx.encrypt(.handshake, &msg, out);
    try self.ratchetTx(request);
    self.pending_write.mark();
    return record;
}

/// Derive and install the next TX traffic key. `request` must match the
/// KeyUpdate record the caller just wrote (it went out under the old
/// key); update_not_requested also clears a owed response.
pub fn ratchetTx(self: *EstablishedSession, request: KeyUpdateRequest) SendError!void {
    const next_tx = try self.suite.ratchetServerKey();
    self.tx.deinit();
    self.tx = next_tx;
    if (request == .update_not_requested) self.key_update_obligation = .none;
}

/// Classify decrypted plaintext. Mirrors ServerHandshake's private
/// receivePlaintextRecord: application data resets the flood counter;
/// handshake content must be exactly one KeyUpdate aligned to the record
/// boundary; alerts either close (close_notify) or surface as PeerAlert.
fn receivePlaintext(
    self: *EstablishedSession,
    content_type: frame.ContentType,
    content: []u8,
) ReceiveError!ServerHandshake.ReceiveEvent {
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

            for (content, 0..) |byte, i| {
                if (self.ku_frag.len == 0 and byte != @intFromEnum(handshake.Type.key_update)) {
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

                // RFC 8446 §5.1: a message immediately preceding a key
                // change must align with a record boundary. Reject before
                // ratcheting if this record contains anything after the
                // KeyUpdate.
                if (self.ku_frag.len != key_update_total_len) unreachable;
                if (i + 1 != content.len) {
                    self.ku_frag.clear();
                    return error.UnexpectedMessage;
                }

                const request = handshake.parseKeyUpdate(frag) catch |err| {
                    self.ku_frag.clear();
                    return err;
                };
                self.post_handshake_count +|= 1;
                if (self.post_handshake_count > max_post_handshake_messages) {
                    self.ku_frag.clear();
                    return error.TooManyKeyUpdates;
                }
                const next_rx = self.suite.ratchetClientKey() catch |err| {
                    self.ku_frag.clear();
                    return err;
                };
                self.rx.deinit();
                self.rx = next_rx;
                self.ku_frag.clear();
                if (request == .update_requested) {
                    self.key_update_obligation = .response_owed;
                }

                return .{ .key_update = request };
            }
            return .none;
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

test "size: compact against the full handshake" {
    try std.testing.expect(@sizeOf(EstablishedSession) < 2 * 1024);
    try std.testing.expect(@sizeOf(EstablishedSession) * 10 < @sizeOf(ServerHandshake));
}
