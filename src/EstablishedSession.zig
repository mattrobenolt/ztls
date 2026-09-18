//! The compact established-session engine: what a connected TLS 1.3 server
//! connection needs for the rest of its life, and nothing else.
//!
//! Constructed only by `ServerHandshake.extractEstablished` at handshake
//! completion; there is no other way to make one. 736 bytes against
//! ServerHandshake's 19,408 (26x smaller, Zig 0.15.2 aarch64-linux, OpenSSL
//! lane), so a connection pool keeps one handshake engine per worker and one
//! of these per live connection. The record layers embed backend AEAD
//! contexts, so the absolute size is lane-dependent (larger with the inline
//! EVP_AEAD_CTXs of AWS-LC and BoringSSL); see the compactness test.
//!
//! The connected record paths are the same code the handshake engine runs
//! (shared in handshake.zig): record classification, KeyUpdate reassembly and
//! ratchet discipline, the KeyUpdate response obligation, the TX latch, and
//! the consecutive-KeyUpdate flood cap. RFC 8446 §4.6.3, §5.1, §6.1, §6.2.
//!
//! The retained `suite` still carries the (now inert) handshake transcript
//! state and the resumption master secret inside its arms — the KeyUpdate
//! ratchet needs the same traffic-secret state. Ticket issuance is not
//! available here: issue NewSessionTickets before extracting. kTLS callers
//! keep using ServerHandshake.

const alert = @import("alert.zig");
const handshake = @import("handshake.zig");
const ArrayBuffer = @import("array_buffer.zig").ArrayBuffer;
const PendingWrite = @import("pending_write.zig").PendingWrite;
const RecordLayer = @import("RecordLayer.zig");
const Suite = @import("suite_state.zig").Suite;

// Private on purpose: a pub self-alias is a self-referential declaration, and
// test.zig's refAllDeclsRecursive follows it as an unbounded runtime
// recursion (root.EstablishedSession.EstablishedSession.EstablishedSession…).
// Callers reach this type through the root export of this file, like
// ServerHandshake and ClientHandshake.
const EstablishedSession = @This();

const KeyUpdateFragmentBuffer = ArrayBuffer(u8, handshake.key_update_total_len);

/// Connected-state event shapes shared with the handshake engines.
pub const Event = handshake.Event;
pub const ReceiveEvent = handshake.ReceiveEvent;
pub const KeyUpdateRequest = handshake.KeyUpdateRequest;

pub const ReceiveError = handshake.ReceiveError;
pub const SendError = handshake.SendError;
pub const AlertError = handshake.AlertError;
pub const HandleError = ReceiveError || SendError;

/// Receive record layer: traffic key, AEAD context, sequence number.
rx: RecordLayer,
/// Send record layer.
tx: RecordLayer,
/// Application-traffic secrets — the KeyUpdate ratchet derives fresh
/// RecordLayers from these (RFC 8446 §4.6.3, §7.2).
suite: Suite,
/// Reassembles a post-handshake KeyUpdate fragmented across records
/// (RFC 8446 §5.1). KeyUpdate is a 4-byte header plus a 1-byte body.
ku_frag: KeyUpdateFragmentBuffer = .empty,
/// Consecutive post-handshake KeyUpdates without intervening application
/// data — the flood cap. A malicious peer cannot ratchet us forever.
post_handshake_count: u8 = 0,
/// Most recent non-close_notify peer alert (RFC 8446 §6.2); close_notify
/// (§6.1) never sets it.
last_peer_alert: ?alert.Alert = null,
/// An inbound update_requested KeyUpdate must be answered before any
/// application data is sent (RFC 8446 §4.6.3).
key_update_obligation: handshake.KeyUpdateObligation = .none,
/// TX latch: set when a call hands the caller bytes that must be written
/// before more engine output is safe. Mirrors ServerHandshake's.
pending_write: PendingWrite = .idle,

/// Release the backend AEAD contexts and zero every secret this engine owns.
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

/// RFC 8446 §4.6.3 — true after receiving update_requested until the required
/// update_not_requested response has been generated.
pub fn hasPendingKeyUpdateResponse(self: *const EstablishedSession) bool {
    return self.key_update_obligation == .response_owed;
}

/// Most recent non-close_notify peer alert, or null.
pub fn lastPeerAlert(self: *const EstablishedSession) ?alert.Alert {
    return self.last_peer_alert;
}

/// Process one complete encrypted record: decrypt, classify, and — for an
/// inbound update_requested KeyUpdate — produce the response record in `out`
/// encrypted under the old TX key (RFC 8446 §4.6.3). The same connected
/// handleRecord path the handshake engine runs.
// ziglint-ignore: Z015 -- HandleError is composed of public error-set aliases.
pub fn handle(self: *EstablishedSession, record: []u8, out: []u8) HandleError!Event {
    if (self.pending_write.isPending()) return error.PendingWrite;
    return handshake.serverHandleConnected(self, record, out);
}

/// Decrypt and classify one complete record. RX-only: safe while an unrelated
/// TX record is in flight. A received update_requested KeyUpdate sets the
/// response obligation (`hasPendingKeyUpdateResponse`) without producing the
/// response — the caller serializes it against its own TX.
// ziglint-ignore: Z015 -- ReceiveError is a public error-set alias.
pub fn receive(self: *EstablishedSession, record: []u8) ReceiveError!ReceiveEvent {
    return handshake.serverReceiveRecord(self, record);
}

/// Serialize and encrypt one application-data record under the current TX
/// key. Refuses while a KeyUpdate response is owed (RFC 8446 §4.6.3).
// ziglint-ignore: Z015 -- SendError is a public error-set alias.
pub fn sendApplicationData(
    self: *EstablishedSession,
    plaintext: []const u8,
    out: []u8,
) SendError![]u8 {
    return handshake.sendApplicationData(self, plaintext, out);
}

/// Send an alert through the established record path (encrypted).
/// close_notify is a warning-level alert; everything else is fatal
/// (RFC 8446 §6.1, §6.2).
// ziglint-ignore: Z015 -- AlertError is a public error-set alias.
pub fn sendAlert(
    self: *EstablishedSession,
    description: alert.Description,
    out: []u8,
) AlertError![]const u8 {
    return handshake.sendEstablishedAlert(self, description, out);
}

/// Serialize, encrypt, and send a KeyUpdate; then ratchet the TX key so the
/// update takes effect for subsequent records (RFC 8446 §4.6.3).
// ziglint-ignore: Z015 -- SendError is a public error-set alias.
pub fn sendKeyUpdate(
    self: *EstablishedSession,
    out: []u8,
    request: KeyUpdateRequest,
) SendError![]const u8 {
    return handshake.sendKeyUpdate(.server, self, out, request);
}

/// Derive and install the next TX traffic key after an external record layer
/// has sent a KeyUpdate under the old key. `request` must match that record;
/// update_not_requested also satisfies any owed response.
// ziglint-ignore: Z015 -- SendError is a public error-set alias.
pub fn ratchetTx(self: *EstablishedSession, request: KeyUpdateRequest) SendError!void {
    return handshake.ratchetKtlsTx(.server, self, request);
}
