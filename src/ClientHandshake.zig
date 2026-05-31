/// TLS 1.3 client handshake state machine.
///
/// Owns the running transcript hash and drives the handshake message sequence.
/// Does no I/O: the caller feeds in decrypted record bytes and receives bytes
/// to send. RFC 8446 §4, Appendix A.
const std = @import("std");
const assert = std.debug.assert;
const Sha256 = std.crypto.hash.sha2.Sha256;
const Sha384 = std.crypto.hash.sha2.Sha384;
const testing = std.testing;
const mem = std.mem;
const base64 = std.base64.standard.Decoder;

const aead = @import("aead.zig");
const certificate = @import("certificate.zig");
const client_hello = @import("client_hello.zig");
const encrypted_extensions = @import("encrypted_extensions.zig");
const finished = @import("finished.zig");
const frame = @import("frame.zig");
const hkdf = @import("hkdf.zig");
const SharedSecret = hkdf.SharedSecret;
const RecordLayer = @import("RecordLayer.zig");
const server_hello = @import("server_hello.zig");
const wire = @import("wire.zig");
const x25519 = @import("x25519.zig");

const ClientHandshake = @This();

/// RFC 8446 §4 — handshake message type. Open enum: unrecognized values pass
/// through the reader untouched; the state machine decides what is unexpected.
pub const HandshakeType = enum(u8) {
    new_session_ticket = 0x04,
    server_hello = 0x02,
    encrypted_extensions = 0x08,
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

/// Iterates the handshake messages packed into one (decrypted) record payload.
/// A single flight commonly coalesces EncryptedExtensions, Certificate,
/// CertificateVerify, and Finished into one record. RFC 8446 §5.1.
pub const HandshakeReader = struct {
    r: wire.Reader,

    pub const Message = struct {
        type: HandshakeType,
        /// Full message including the 4-byte handshake header. This is what
        /// feeds the transcript hash.
        raw: []const u8,
    };

    pub fn init(buf: []const u8) HandshakeReader {
        return .{ .r = .init(buf) };
    }

    /// Return the next handshake message, or null when the payload is drained.
    /// Errors if a message header or body runs past the end of the buffer
    /// (cross-record reassembly is not yet supported).
    pub fn next(self: *HandshakeReader) error{UnexpectedEof}!?Message {
        if (self.r.remaining().len == 0) return null;
        const begin = self.r.pos;
        const msg_type = try self.r.read(u8);
        const len = try self.r.read(u24);
        _ = try self.r.readSlice(len);
        return .{ .type = @enumFromInt(msg_type), .raw = self.r.buf[begin..self.r.pos] };
    }
};

/// The handshake-traffic RecordLayers derived once the key exchange completes.
/// `rx` decrypts the server's flight (server handshake traffic secret);
/// `tx` encrypts our Finished (client handshake traffic secret).
pub const HandshakeKeys = struct {
    rx: RecordLayer,
    tx: RecordLayer,

    /// Application-traffic RecordLayers plus the encoded client Finished
    /// plaintext (a slice into the caller's buffer).
    pub const WithFinished = struct {
        finished: []const u8,
        rx: RecordLayer,
        tx: RecordLayer,
    };
};

/// RFC 8446 Appendix A.1 — client state machine, trimmed to the flows we
/// support (full 1-RTT handshake, no PSK, no client auth, no HelloRetryRequest).
pub const State = enum {
    start,
    wait_sh,
    wait_ee,
    wait_cert,
    wait_cv,
    wait_finished,
    /// Server flight verified; client must send its Finished next.
    send_finished,
    connected,
};

/// Hash-parameterized handshake state. Each arm carries every secret whose
/// size depends on the negotiated hash, sealing the size polymorphism inside
/// the union so the rest of ClientHandshake stays hash-agnostic.
///
/// Only the SHA-256 suite exists today. SHA-384 becomes a second arm carrying
/// Sha384 + HkdfSha384.Prk-sized fields; all callers switch in one place.
/// Per-hash handshake state, generic over the HKDF and transcript-hash types.
/// Carries every secret whose size depends on the negotiated hash (Prk is 32
/// bytes for SHA-256, 48 for SHA-384), sealing the size polymorphism in the arm.
fn HashArm(comptime Hkdf_: type, comptime Hash: type) type {
    return struct {
        transcript: Hash,
        // The negotiated AEAD; set from the cipher suite at ServerHello.
        aead: aead.Keys = .aes128_gcm,
        handshake_secret: Hkdf_.Prk = undefined,
        client_finished_key: Hkdf_.Prk = undefined,
        server_finished_key: Hkdf_.Prk = undefined,
        // Application traffic secrets, retained after the handshake so KeyUpdate
        // can ratchet them (RFC 8446 §7.2).
        client_app_secret: Hkdf_.Prk = undefined,
        server_app_secret: Hkdf_.Prk = undefined,

        const Hkdf = Hkdf_;
    };
}

const Suite = union(enum) {
    /// Pre-ServerHello: the negotiated hash isn't known yet, so run both
    /// transcript hashes and keep the one the chosen suite uses. RFC 8446
    /// §4.4.1 permits deferring the transcript until the hash is selected.
    buffering: struct { sha256: Sha256, sha384: Sha384 },
    sha256: HashArm(hkdf.HkdfSha256, Sha256),
    sha384: HashArm(hkdf.HkdfSha384, Sha384),

    /// Feed one handshake message (4-byte header + body, no record framing)
    /// into the running transcript hash. RFC 8446 §4.4.1. While buffering
    /// (before the suite is chosen) both candidate hashes are fed.
    fn update(self: *Suite, msg: []const u8) void {
        switch (self.*) {
            .buffering => |*b| {
                b.sha256.update(msg);
                b.sha384.update(msg);
            },
            inline .sha256, .sha384 => |*s| s.transcript.update(msg),
        }
    }

    /// RFC 8446 §4.4.3 — verify the CertificateVerify signature against the
    /// leaf public key (extracted earlier from the Certificate message) and the
    /// transcript through Certificate (snapshotted here, before CV is
    /// absorbed). The digest stays inside the arm.
    fn verifyCertificate(
        self: *const Suite,
        cv_msg: []const u8,
        pub_key: []const u8,
    ) certificate.VerifyError!void {
        switch (self.*) {
            .buffering => unreachable,
            inline .sha256, .sha384 => |*s| {
                const th = s.transcript.peek();
                try certificate.verifySignature(cv_msg, pub_key, &th);
            },
        }
    }

    /// RFC 8446 §4.4.4 — verify the server's Finished MAC. Snapshots the
    /// transcript through CertificateVerify (the state before Finished is
    /// absorbed) and checks the MAC with the retained server finished key.
    fn verifyServerFinished(self: *const Suite, finished_msg: []const u8) finished.VerifyError!void {
        switch (self.*) {
            .buffering => unreachable,
            inline .sha256, .sha384 => |*s| {
                const th = s.transcript.peek();
                try finished.verify(@TypeOf(s.transcript), finished_msg, &s.server_finished_key.data, &th);
            },
        }
    }

    /// RFC 8446 §4.4.4, §7.1 — encode the client Finished and derive the
    /// application-traffic RecordLayers. Both use one transcript snapshot taken
    /// through the server Finished (the Master Secret point); the client
    /// Finished is absorbed afterward. The plaintext Finished is written to
    /// `out`; rx/tx are application-keyed.
    fn finishHandshake(self: *Suite, out: []u8) error{BufferTooShort}!HandshakeKeys.WithFinished {
        switch (self.*) {
            .buffering => unreachable,
            inline .sha256, .sha384 => |*s| {
                const H = @TypeOf(s.*).Hkdf;
                const th = s.transcript.peek(); // through server Finished
                const fin = try finished.encode(@TypeOf(s.transcript), out, &s.client_finished_key.data, &th);

                const master = H.masterSecret(s.handshake_secret);
                s.client_app_secret = H.clientApplicationTrafficSecret(master, &.init(th));
                s.server_app_secret = H.serverApplicationTrafficSecret(master, &.init(th));

                s.transcript.update(fin); // client Finished now part of the transcript

                return .{
                    .finished = fin,
                    .tx = H.makeRecordLayer(s.aead, s.client_app_secret),
                    .rx = H.makeRecordLayer(s.aead, s.server_app_secret),
                };
            },
        }
    }

    /// RFC 8446 §7.2 — ratchet our sending (client) application key and return
    /// the fresh RecordLayer (sequence number reset to 0).
    fn ratchetClientKey(self: *Suite) RecordLayer {
        switch (self.*) {
            .buffering => unreachable,
            inline .sha256, .sha384 => |*s| {
                const H = @TypeOf(s.*).Hkdf;
                s.client_app_secret = H.nextTrafficSecret(s.client_app_secret);
                return H.makeRecordLayer(s.aead, s.client_app_secret);
            },
        }
    }

    /// RFC 8446 §7.2 — ratchet the peer's sending (server) application key and
    /// return the fresh RecordLayer (sequence number reset to 0).
    fn ratchetServerKey(self: *Suite) RecordLayer {
        switch (self.*) {
            .buffering => unreachable,
            inline .sha256, .sha384 => |*s| {
                const H = @TypeOf(s.*).Hkdf;
                s.server_app_secret = H.nextTrafficSecret(s.server_app_secret);
                return H.makeRecordLayer(s.aead, s.server_app_secret);
            },
        }
    }

    /// RFC 8446 §7.1 — mix the DHE shared secret into the key schedule and
    /// derive the handshake-traffic keys. Call once, after the transcript has
    /// absorbed ClientHello and ServerHello.
    ///
    /// Snapshots the transcript at the ServerHello point and derives every
    /// secret rooted there — traffic keys and both finished keys — because the
    /// running hash moves on and cannot be rewound. The handshake secret and
    /// finished keys are retained in the arm; the RecordLayers are returned.
    fn deriveHandshakeKeys(self: *Suite, dhe: *const SharedSecret) HandshakeKeys {
        switch (self.*) {
            .buffering => unreachable,
            inline .sha256, .sha384 => |*s| {
                const H = @TypeOf(s.*).Hkdf;
                s.handshake_secret = H.handshakeSecret(H.early_secret, dhe);

                const th = s.transcript.peek();
                const client_secret = H.clientHandshakeTrafficSecret(s.handshake_secret, &.init(th));
                const server_secret = H.serverHandshakeTrafficSecret(s.handshake_secret, &.init(th));

                s.client_finished_key = H.finishedKey(client_secret);
                s.server_finished_key = H.finishedKey(server_secret);

                return .{
                    .rx = H.makeRecordLayer(s.aead, server_secret),
                    .tx = H.makeRecordLayer(s.aead, client_secret),
                };
            },
        }
    }
};

state: State,
suite: Suite,
/// Our ephemeral X25519 keypair. The secret computes the DHE shared secret
/// once ServerHello arrives; the public goes into the ClientHello key_share.
keypair: x25519.KeyPair,
/// Handshake-traffic RecordLayers, installed by processServerHello.
rx: RecordLayer = undefined,
tx: RecordLayer = undefined,
/// Set when a method hands the caller bytes that MUST be written to the
/// transport (Finished, KeyUpdate response, application data). Blocks further
/// engine calls until completeWrite() acknowledges the write — so a dropped
/// write can't silently desync the connection.
pending_write: bool = false,
/// Certificate validation policy, applied during the server flight. Defaults
/// to no chain anchoring (signature-only). Set before driving the handshake.
policy: certificate.Policy = .{},
/// Leaf public key extracted from the Certificate message, copied here so it
/// survives until CertificateVerify (which may arrive in a later record —
/// openssl sends each flight message in its own record). Sized for RSA-4096.
leaf_pub_key: [max_leaf_pub_key]u8 = undefined,
leaf_pub_key_len: usize = 0,
/// Consecutive post-handshake messages seen with no intervening application
/// data; reset by application data. Bounds KeyUpdate-flood DoS.
post_handshake_count: u8 = 0,

/// Start a client handshake with our ephemeral X25519 keypair. The negotiated
/// suite is hardcoded to SHA-256 for now; true suite selection (and re-hashing
/// ClientHello under SHA-384) is deferred.
pub fn init(keypair: x25519.KeyPair) ClientHandshake {
    return .{
        .state = .start,
        // Hash unknown until ServerHello: run both candidate transcripts.
        .suite = .{ .buffering = .{ .sha256 = .init(.{}), .sha384 = .init(.{}) } },
        .keypair = keypair,
    };
}

/// Acknowledge that the bytes from the last engine call were written to the
/// transport, clearing the pending-write block. Call after writing any
/// `.write` event or send-method result.
pub fn completeWrite(self: *ClientHandshake) void {
    self.pending_write = false;
}

pub const StartError = error{ BufferTooShort, ServerNameTooLong };

/// Begin the handshake: encode a ClientHello (from the init keypair's public
/// key), frame it as a plaintext record into `out`, absorb it into the
/// transcript, and advance start -> wait_sh. Returns the wire-ready record to
/// send (then completeWrite() once sent). RFC 8446 §4.1.2, §5.1.
pub fn start(
    self: *ClientHandshake,
    out: []u8,
    random: client_hello.Random,
    server_name: ?[]const u8,
) StartError![]const u8 {
    assert(self.state == .start);
    if (out.len < frame.header_len) return error.BufferTooShort;
    const ch = try client_hello.encode(out[frame.header_len..], random, .init(self.keypair.public_key), server_name);
    out[0..frame.header_len].* = mem.toBytes(frame.Header.init(.handshake, @intCast(ch.len)));
    self.injectClientHello(ch);
    self.pending_write = true;
    return out[0 .. frame.header_len + ch.len];
}

/// Low-level: absorb a pre-built ClientHello handshake message into the
/// transcript and advance start -> wait_sh. For callers that build their own
/// ClientHello (and tests driving fixed vectors); most use start() instead.
pub fn injectClientHello(self: *ClientHandshake, client_hello_msg: []const u8) void {
    assert(self.state == .start);
    self.suite.update(client_hello_msg);
    self.state = .wait_sh;
}

/// What a handled inbound record yielded. The same type covers both the
/// handshake and connected phases.
pub const Event = union(enum) {
    /// Decrypted application data (a slice into the caller's record buffer).
    application_data: []const u8,
    /// A record that MUST be written to the transport: the client Finished
    /// during the handshake, or a KeyUpdate response. Written into `out`.
    write: []const u8,
    /// Handled internally; nothing for the caller to do.
    none,
    /// The peer sent an alert (treated as connection close for now).
    closed,
};

pub const HandleError = ProcessError || ReceiveError || error{PendingWrite};

/// True once the handshake completes and application keys are installed.
pub fn isConnected(self: *const ClientHandshake) bool {
    return self.state == .connected;
}

/// Feed one complete TLS record to the engine and get back what to do. This is
/// the single inbound entry point for the whole connection: during the
/// handshake it drives the flight (auto-emitting the client Finished as
/// `.write` when the server's flight completes); once connected it returns
/// decrypted application data, handles post-handshake control messages
/// (KeyUpdate), and surfaces a KeyUpdate response as `.write`. `record` is
/// decrypted in place; `out` receives any record to send. RFC 8446 §5.
pub fn handleRecord(self: *ClientHandshake, record: []u8, out: []u8) HandleError!Event {
    if (self.pending_write) return error.PendingWrite;
    const ev: Event = if (self.state == .connected)
        try self.receiveConnected(record, out)
    else if (try self.processHandshakeRecord(record, out)) |bytes|
        .{ .write = bytes }
    else
        .none;
    if (ev == .write) self.pending_write = true;
    return ev;
}

/// Encrypt application data into a wire-ready record (then completeWrite() once
/// sent). RFC 8446 §5.2.
pub fn sendApplicationData(self: *ClientHandshake, plaintext: []const u8, out: []u8) SendError![]const u8 {
    assert(self.state == .connected);
    if (self.pending_write) return error.PendingWrite;
    const record = try self.tx.encrypt(.application_data, plaintext, out);
    self.pending_write = true;
    return record;
}

pub const ProcessError = frame.ParseError || RecordLayer.DecryptError ||
    ServerHelloError || FlightError || SendError ||
    error{ IncompleteRecord, UnexpectedRecord };

// Handshake-phase inbound: drive the flight from one record, returning the
// client Finished to send when the flight completes, else null.
fn processHandshakeRecord(self: *ClientHandshake, record: []u8, out: []u8) ProcessError!?[]const u8 {
    const hdr = try frame.parseHeader(record);
    if (record.len < frame.header_len + hdr.length()) return error.IncompleteRecord;

    switch (hdr.content_type) {
        // RFC 8446 §D.4 — middlebox-compat ChangeCipherSpec, silently dropped.
        .change_cipher_spec => return null,
        // ServerHello is the only handshake message that arrives unencrypted.
        .handshake => {
            if (self.state != .wait_sh) return error.UnexpectedRecord;
            try self.processServerHello(record[frame.header_len..][0..hdr.length()]);
            return null;
        },
        // Encrypted records: decrypt with rx, then feed the server flight. rx
        // isn't installed until ServerHello, so reject app-data before wait_ee.
        .application_data => {
            if (self.state == .start or self.state == .wait_sh) return error.UnexpectedRecord;
            const dec = try self.rx.decrypt(record);
            if (dec.content_type != .handshake) return error.UnexpectedRecord;
            try self.processFlight(dec.content, self.policy);
            if (self.state == .send_finished) return try self.clientFinished(out);
            return null;
        },
        else => return error.UnexpectedRecord,
    }
}

pub const ServerHelloError = server_hello.ParseError || error{
    UnsupportedCipherSuite,
    IdentityElement,
};

/// Process the server's ServerHello: parse it, absorb it into the transcript,
/// compute the DHE shared secret, and install the handshake-traffic keys.
/// RFC 8446 §4.1.3, §7.1. Advances wait_sh -> wait_ee.
pub fn processServerHello(self: *ClientHandshake, msg: []const u8) ServerHelloError!void {
    assert(self.state == .wait_sh);
    const sh = try server_hello.parse(msg);
    // Collapse the dual transcript to the negotiated hash's arm, carrying over
    // the hasher that already absorbed ClientHello.
    const b = self.suite.buffering;
    self.suite = switch (sh.cipher_suite) {
        .aes_128_gcm_sha256 => .{ .sha256 = .{ .transcript = b.sha256, .aead = .aes128_gcm } },
        .chacha20_poly1305_sha256 => .{ .sha256 = .{ .transcript = b.sha256, .aead = .chacha20_poly1305 } },
        .aes_256_gcm_sha384 => .{ .sha384 = .{ .transcript = b.sha384, .aead = .aes256_gcm } },
    };

    self.suite.update(msg); // transcript now covers ClientHello || ServerHello
    const dhe = try x25519.sharedSecret(self.keypair.secret_key, sh.server_public_key);
    const keys = self.suite.deriveHandshakeKeys(&dhe);
    self.rx = keys.rx;
    self.tx = keys.tx;
    self.state = .wait_ee;
}

/// Upper bound on a leaf public key we retain across records. Covers RSA-4096
/// (~525-byte DER) with margin; ECDSA P-256/P-384 are far smaller.
const max_leaf_pub_key = 1024;

pub const FlightError = error{ UnexpectedMessage, UnexpectedEof, CertificateKeyTooLarge } ||
    encrypted_extensions.ParseError ||
    certificate.AuthError ||
    finished.VerifyError;

/// Process the server's encrypted flight: EncryptedExtensions, Certificate,
/// CertificateVerify, Finished. `payload` is the decrypted handshake content,
/// commonly carrying all four messages coalesced in one record.
///
/// Each message is absorbed into the transcript, and the two verifications run
/// against the transcript snapshotted *before* the message they cover is
/// absorbed (CV signature: through Certificate; Finished MAC: through CV).
/// RFC 8446 §4.3-§4.4. Advances wait_ee -> connected.
///
/// The flight may be split across records at message boundaries (openssl sends
/// one message per record): self.state persists and each call resumes. A
/// single handshake message must still fit within one payload — message-
/// spanning-records reassembly is not yet supported.
pub fn processFlight(
    self: *ClientHandshake,
    payload: []const u8,
    policy: certificate.Policy,
) FlightError!void {
    var hr: HandshakeReader = .init(payload);
    // State drives the loop: each prong consumes one message, advances
    // self.state, and re-enters on it. self.state persists progress for
    // resumption when the payload drains mid-flight (orelse return).
    flight: switch (self.state) {
        .wait_ee => {
            const msg = try hr.next() orelse return;
            if (msg.type != .encrypted_extensions) return error.UnexpectedMessage;
            try encrypted_extensions.parse(msg.raw);
            self.suite.update(msg.raw);
            self.state = .wait_cert;
            continue :flight self.state;
        },
        .wait_cert => {
            const msg = try hr.next() orelse return;
            if (msg.type != .certificate) return error.UnexpectedMessage;
            // Extract and copy the leaf public key now; it must survive until
            // CertificateVerify, which may arrive in a later record.
            const pk = try certificate.parse(msg.raw, policy);
            if (pk.len > self.leaf_pub_key.len) return error.CertificateKeyTooLarge;
            @memcpy(self.leaf_pub_key[0..pk.len], pk);
            self.leaf_pub_key_len = pk.len;
            self.suite.update(msg.raw);
            self.state = .wait_cv;
            continue :flight self.state;
        },
        .wait_cv => {
            const msg = try hr.next() orelse return;
            if (msg.type != .certificate_verify) return error.UnexpectedMessage;
            try self.suite.verifyCertificate(msg.raw, self.leaf_pub_key[0..self.leaf_pub_key_len]);
            self.suite.update(msg.raw);
            self.state = .wait_finished;
            continue :flight self.state;
        },
        .wait_finished => {
            const msg = try hr.next() orelse return;
            if (msg.type != .finished) return error.UnexpectedMessage;
            try self.suite.verifyServerFinished(msg.raw);
            self.suite.update(msg.raw);
            self.state = .send_finished;
            // Server flight is done; the client sends its Finished via
            // clientFinished(). Stop driving the switch.
            return;
        },
        else => return error.UnexpectedMessage,
    }
}

/// Errors from encrypting an outbound record into the caller's buffer.
pub const SendError = RecordLayer.EncryptError || error{PendingWrite};

/// Produce the client Finished as a wire-ready (encrypted) record and promote
/// to application traffic keys. RFC 8446 §4.4.4, §7.1. Advances
/// send_finished -> connected.
///
/// The Finished is encrypted under the still-active handshake-traffic key, then
/// rx/tx are swapped to application-traffic keys. After this returns, both
/// directions carry application data. `out` receives the encrypted record and
/// the returned slice is the bytes to send.
pub fn clientFinished(self: *ClientHandshake, out: []u8) SendError![]const u8 {
    assert(self.state == .send_finished);

    // Plaintext Finished: 4-byte handshake header + verify_data. verify_data
    // is one hash digest: 32 bytes (SHA-256) or 48 (SHA-384).
    var fin_buf: [4 + 48]u8 = undefined;
    const keys = try self.suite.finishHandshake(&fin_buf);

    // Encrypt under the handshake-traffic key that is still installed, then
    // promote: the Finished is the last handshake-protected message.
    const record = try self.tx.encrypt(.handshake, keys.finished, out);
    self.tx = keys.tx;
    self.rx = keys.rx;
    self.state = .connected;
    return record;
}

/// Max consecutive post-handshake messages with no intervening application
/// data before we treat the peer as flooding us (RFC 8446 §4.6.3 allows
/// either side to force updates; an unbounded stream is a DoS). Mirrors Go's
/// maxUselessRecords. Reset by application data.
const max_post_handshake_messages = 16;

pub const ReceiveError = RecordLayer.DecryptError || SendError ||
    error{ UnexpectedEof, UnexpectedRecord, UnexpectedMessage, IllegalParameter, TooManyKeyUpdates };

// Connected-phase inbound: the engine owns the receive path so post-handshake
// control messages (KeyUpdate) are routed and answered correctly and the flood
// counter sees the full record stream. RFC 8446 §4.6.3, §7.2.
//
// Decrypts with rx and dispatches on the inner content type: application data
// is returned to the caller; a requested KeyUpdate is answered with our own
// (encrypted under the old key, then our send key ratchets) and the receive
// key ratchets after the KeyUpdate is consumed.
fn receiveConnected(self: *ClientHandshake, record: []u8, out: []u8) ReceiveError!Event {
    assert(self.state == .connected);
    const dec = try self.rx.decrypt(record);
    switch (dec.content_type) {
        .application_data => {
            self.post_handshake_count = 0;
            return .{ .application_data = dec.content };
        },
        .handshake => {
            var respond = false;
            var hr: HandshakeReader = .init(dec.content);
            while (try hr.next()) |msg| {
                self.post_handshake_count +|= 1;
                if (self.post_handshake_count > max_post_handshake_messages) return error.TooManyKeyUpdates;
                switch (msg.type) {
                    .key_update => {
                        // RFC 8446 §5.1: a message immediately preceding a key
                        // change MUST align with a record boundary. A KeyUpdate
                        // sharing its record with anything that follows would be
                        // protected under a different key epoch than it implies.
                        // Reject before ratcheting (cf. Go CVE-2026-32283).
                        if (hr.r.remaining().len != 0) return error.UnexpectedMessage;
                        if (try parseKeyUpdate(msg.raw) == .update_requested) respond = true;
                        // Ratchet the receive key only after consuming the
                        // KeyUpdate (RFC 8446 §4.6.3).
                        self.rx = self.suite.ratchetServerKey();
                    },
                    .new_session_ticket => {}, // not yet used
                    else => return error.UnexpectedMessage,
                }
            }
            // One response covers any number of update_requested KeyUpdates.
            if (respond) return .{ .write = try self.sendKeyUpdate(out, .update_not_requested) };
            return .none;
        },
        // Minimal: any alert ends the connection. Proper alert parsing (level,
        // description) is deferred.
        .alert => return .closed,
        else => return error.UnexpectedRecord,
    }
}

/// Send a KeyUpdate. Encrypts the message under the current (old) send key,
/// then ratchets our send key so subsequent records use the next generation
/// (RFC 8446 §4.6.3, §7.2). `request` asks the peer to update in return.
pub fn sendKeyUpdate(self: *ClientHandshake, out: []u8, request: KeyUpdateRequest) SendError![]const u8 {
    assert(self.state == .connected);
    if (self.pending_write) return error.PendingWrite;
    const msg = [_]u8{ @intFromEnum(HandshakeType.key_update), 0x00, 0x00, 0x01, @intFromEnum(request) };
    const record = try self.tx.encrypt(.handshake, &msg, out);
    self.tx = self.suite.ratchetClientKey();
    self.pending_write = true;
    return record;
}

/// Parse a KeyUpdate handshake message (4-byte header + 1-byte request).
fn parseKeyUpdate(msg: []const u8) error{ UnexpectedEof, IllegalParameter }!KeyUpdateRequest {
    if (msg.len != 5) return error.UnexpectedEof; // header(4) + request(1)
    return std.enums.fromInt(KeyUpdateRequest, msg[4]) orelse error.IllegalParameter;
}

// RFC 8448 §3 raw handshake messages (4-byte handshake header included, no
// record framing), shared across the transcript and key-schedule tests.
const rfc8448_client_hello = [_]u8{
    0x01, 0x00, 0x00, 0xc0, 0x03, 0x03, 0xcb, 0x34,
    0xec, 0xb1, 0xe7, 0x81, 0x63, 0xba, 0x1c, 0x38,
    0xc6, 0xda, 0xcb, 0x19, 0x6a, 0x6d, 0xff, 0xa2,
    0x1a, 0x8d, 0x99, 0x12, 0xec, 0x18, 0xa2, 0xef,
    0x62, 0x83, 0x02, 0x4d, 0xec, 0xe7, 0x00, 0x00,
    0x06, 0x13, 0x01, 0x13, 0x03, 0x13, 0x02, 0x01,
    0x00, 0x00, 0x91, 0x00, 0x00, 0x00, 0x0b, 0x00,
    0x09, 0x00, 0x00, 0x06, 0x73, 0x65, 0x72, 0x76,
    0x65, 0x72, 0xff, 0x01, 0x00, 0x01, 0x00, 0x00,
    0x0a, 0x00, 0x14, 0x00, 0x12, 0x00, 0x1d, 0x00,
    0x17, 0x00, 0x18, 0x00, 0x19, 0x01, 0x00, 0x01,
    0x01, 0x01, 0x02, 0x01, 0x03, 0x01, 0x04, 0x00,
    0x23, 0x00, 0x00, 0x00, 0x33, 0x00, 0x26, 0x00,
    0x24, 0x00, 0x1d, 0x00, 0x20, 0x99, 0x38, 0x1d,
    0xe5, 0x60, 0xe4, 0xbd, 0x43, 0xd2, 0x3d, 0x8e,
    0x43, 0x5a, 0x7d, 0xba, 0xfe, 0xb3, 0xc0, 0x6e,
    0x51, 0xc1, 0x3c, 0xae, 0x4d, 0x54, 0x13, 0x69,
    0x1e, 0x52, 0x9a, 0xaf, 0x2c, 0x00, 0x2b, 0x00,
    0x03, 0x02, 0x03, 0x04, 0x00, 0x0d, 0x00, 0x20,
    0x00, 0x1e, 0x04, 0x03, 0x05, 0x03, 0x06, 0x03,
    0x02, 0x03, 0x08, 0x04, 0x08, 0x05, 0x08, 0x06,
    0x04, 0x01, 0x05, 0x01, 0x06, 0x01, 0x02, 0x01,
    0x04, 0x02, 0x05, 0x02, 0x06, 0x02, 0x02, 0x02,
    0x00, 0x2d, 0x00, 0x02, 0x01, 0x01, 0x00, 0x1c,
    0x00, 0x02, 0x40, 0x01,
};

const rfc8448_server_hello = [_]u8{
    0x02, 0x00, 0x00, 0x56, 0x03, 0x03, 0xa6, 0xaf,
    0x06, 0xa4, 0x12, 0x18, 0x60, 0xdc, 0x5e, 0x6e,
    0x60, 0x24, 0x9c, 0xd3, 0x4c, 0x95, 0x93, 0x0c,
    0x8a, 0xc5, 0xcb, 0x14, 0x34, 0xda, 0xc1, 0x55,
    0x77, 0x2e, 0xd3, 0xe2, 0x69, 0x28, 0x00, 0x13,
    0x01, 0x00, 0x00, 0x2e, 0x00, 0x33, 0x00, 0x24,
    0x00, 0x1d, 0x00, 0x20, 0xc9, 0x82, 0x88, 0x76,
    0x11, 0x20, 0x95, 0xfe, 0x66, 0x76, 0x2b, 0xdb,
    0xf7, 0xc6, 0x72, 0xe1, 0x56, 0xd6, 0xcc, 0x25,
    0x3b, 0x83, 0x3d, 0xf1, 0xdd, 0x69, 0xb1, 0xb0,
    0x4e, 0x75, 0x1f, 0x0f, 0x00, 0x2b, 0x00, 0x02,
    0x03, 0x04,
};

// RFC 8446 §4.4.1 — Transcript-Hash over handshake messages.
// Vector from RFC 8448 §3 (simple 1-RTT handshake, TLS_AES_128_GCM_SHA256):
// SHA-256(ClientHello || ServerHello) =
//   860c06edc07858ee8e78f0e7428c58edd6b43f2ca3e6e95f02ed063cf0e1cad8
test "transcript hash: RFC 8448 §3 ClientHello || ServerHello" {
    var hs: ClientHandshake = .init(.{ .secret_key = @splat(0), .public_key = @splat(0) });
    hs.suite.update(&rfc8448_client_hello);
    hs.suite.update(&rfc8448_server_hello);

    // Still buffering (no ServerHello processed); check the SHA-256 candidate.
    const th = hs.suite.buffering.sha256.peek();
    try testing.expectEqualSlices(u8, &.{
        0x86, 0x0c, 0x06, 0xed, 0xc0, 0x78, 0x58, 0xee,
        0x8e, 0x78, 0xf0, 0xe7, 0x42, 0x8c, 0x58, 0xed,
        0xd6, 0xb4, 0x3f, 0x2c, 0xa3, 0xe6, 0xe9, 0x5f,
        0x02, 0xed, 0x06, 0x3c, 0xf0, 0xe1, 0xca, 0xd8,
    }, &th);
}

// RFC 8446 §7.1 — handshake key schedule driven by the live transcript.
// Vectors from RFC 8448 §3. The DHE shared secret and the resulting server
// handshake write_key / write_iv and server finished_key are ground truth.
test "deriveHandshakeKeys: RFC 8448 §3 server handshake key/iv/finished" {
    const dhe: SharedSecret = .init(.{
        0x8b, 0xd4, 0x05, 0x4f, 0xb5, 0x5b, 0x9d, 0x63,
        0xfd, 0xfb, 0xac, 0xf9, 0xf0, 0x4b, 0x9f, 0x0d,
        0x35, 0xe6, 0xd6, 0x3f, 0x53, 0x75, 0x63, 0xef,
        0xd4, 0x62, 0x72, 0x90, 0x0f, 0x89, 0x49, 0x2d,
    });

    var hs: ClientHandshake = .init(.{ .secret_key = @splat(0), .public_key = @splat(0) });
    hs.suite.update(&rfc8448_client_hello);
    hs.suite.update(&rfc8448_server_hello);
    // Collapse to the SHA-256 arm (as processServerHello would for this suite).
    const b = hs.suite.buffering;
    hs.suite = .{ .sha256 = .{ .transcript = b.sha256, .aead = .aes128_gcm } };

    const keys = hs.suite.deriveHandshakeKeys(&dhe);

    // server_write_key
    try testing.expectEqualSlices(u8, &.{
        0x3f, 0xce, 0x51, 0x60, 0x09, 0xc2, 0x17, 0x27,
        0xd0, 0xf2, 0xe4, 0xe8, 0x6e, 0xe4, 0x03, 0xbc,
    }, &keys.rx.aead.aes128_gcm.data);
    // server_write_iv
    try testing.expectEqualSlices(u8, &.{
        0x5d, 0x31, 0x3e, 0xb2, 0x67, 0x12, 0x76, 0xee,
        0x13, 0x00, 0x0b, 0x30,
    }, &keys.rx.iv.data);
    // server finished_key (retained in the arm)
    try testing.expectEqualSlices(u8, &.{
        0x00, 0x8d, 0x3b, 0x66, 0xf8, 0x16, 0xea, 0x55,
        0x9f, 0x96, 0xb5, 0x37, 0xe8, 0x85, 0xc3, 0x1f,
        0xc0, 0x68, 0xbf, 0x49, 0x2c, 0x65, 0x2f, 0x01,
        0xf2, 0x88, 0xa1, 0xd8, 0xcd, 0xc1, 0x9f, 0xc8,
    }, &hs.suite.sha256.server_finished_key.data);
}

// RFC 8448 §3 client ephemeral X25519 keypair (secret + the public from the
// ClientHello key_share).
const rfc8448_client_keypair: x25519.KeyPair = .{
    .secret_key = .{
        0x49, 0xaf, 0x42, 0xba, 0x7f, 0x79, 0x94, 0x85,
        0x2d, 0x71, 0x3e, 0xf2, 0x78, 0x4b, 0xcb, 0xca,
        0xa7, 0x91, 0x1d, 0xe2, 0x6a, 0xdc, 0x56, 0x42,
        0xcb, 0x63, 0x45, 0x40, 0xe7, 0xea, 0x50, 0x05,
    },
    .public_key = .{
        0x99, 0x38, 0x1d, 0xe5, 0x60, 0xe4, 0xbd, 0x43,
        0xd2, 0x3d, 0x8e, 0x43, 0x5a, 0x7d, 0xba, 0xfe,
        0xb3, 0xc0, 0x6e, 0x51, 0xc1, 0x3c, 0xae, 0x4d,
        0x54, 0x13, 0x69, 0x1e, 0x52, 0x9a, 0xaf, 0x2c,
    },
};

// RFC 8446 §4.1.3, §7.1 — ServerHello processing end to end: parse, absorb,
// X25519 DHE, key schedule. The installed rx RecordLayer must carry the
// RFC 8448 §3 server handshake write key, proving the X25519 + key-schedule
// integration (not just isolated derivation from a literal shared secret).
test "processServerHello: RFC 8448 §3 installs server handshake keys" {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    hs.injectClientHello(&rfc8448_client_hello);

    try hs.processServerHello(&rfc8448_server_hello);

    try testing.expectEqual(.wait_ee, hs.state);
    try testing.expectEqualSlices(u8, &.{
        0x3f, 0xce, 0x51, 0x60, 0x09, 0xc2, 0x17, 0x27,
        0xd0, 0xf2, 0xe4, 0xe8, 0x6e, 0xe4, 0x03, 0xbc,
    }, &hs.rx.aead.aes128_gcm.data);
}

// RFC 8448 §3 vectors, base64-encoded inside a txtar archive (decoded at test
// time): server_flight.b64 = EE||Cert||CV||Finished plaintext;
// server_flight_record.b64 = the same flight as an encrypted wire record.
const rfc8448_archive = @embedFile("test_fixtures/rfc8448.txtar");

// Decode a base64 entry from the embedded RFC 8448 archive into `out`.
// Test-only — the txtar import lives inside the function so the public ztls
// module never requires the dependency.
fn rfc8448Fixture(name: []const u8, out: []u8) []u8 {
    const txtar = @import("txtar");
    var archive = txtar.parse(testing.allocator, rfc8448_archive) catch unreachable;
    defer archive.deinit(testing.allocator);
    for (archive.files) |f| {
        if (!mem.eql(u8, f.name, name)) continue;
        const b64 = mem.trimRight(u8, f.data, "\n");
        const n = base64.calcSizeForSlice(b64) catch unreachable;
        base64.decode(out[0..n], b64) catch unreachable;
        return out[0..n];
    }
    unreachable;
}

// RFC 8446 §4.3-§4.4 — the full encrypted flight driven by the live transcript.
// One call exercises EncryptedExtensions parsing, RSA-PSS CertificateVerify
// over the through-Certificate transcript, and the server Finished MAC over the
// through-CertificateVerify transcript — all against genuine RFC 8448 §3 bytes.
// The default policy (.{}) skips chain anchoring; the CV signature check still
// runs and passes because §3's cert and CV are internally consistent.
test "processFlight: RFC 8448 §3 full server flight to connected" {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    hs.injectClientHello(&rfc8448_client_hello);
    try hs.processServerHello(&rfc8448_server_hello);

    var flight_buf: [1024]u8 = undefined;
    try hs.processFlight(rfc8448Fixture("server_flight.b64", &flight_buf), .{});
    try testing.expectEqual(.send_finished, hs.state);
}

// openssl s_server sends each flight message in its own record, so processFlight
// is called once per message with state persisting across calls. The leaf
// public key extracted at Certificate must survive to CertificateVerify.
test "processFlight: RFC 8448 §3 flight split one message per record" {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    hs.injectClientHello(&rfc8448_client_hello);
    try hs.processServerHello(&rfc8448_server_hello);

    var flight_buf: [1024]u8 = undefined;
    var hr: HandshakeReader = .init(rfc8448Fixture("server_flight.b64", &flight_buf));
    while (try hr.next()) |msg| {
        try hs.processFlight(msg.raw, .{});
    }
    try testing.expectEqual(.send_finished, hs.state);
}

// RFC 8448 §3 client Finished handshake message (verify_data over the
// transcript through the server Finished).
const rfc8448_client_finished = [_]u8{
    0x14, 0x00, 0x00, 0x20, 0xa8, 0xec, 0x43, 0x6d,
    0x67, 0x76, 0x34, 0xae, 0x52, 0x5a, 0xc1, 0xfc,
    0xeb, 0xe1, 0x1a, 0x03, 0x9e, 0xc1, 0x76, 0x94,
    0xfa, 0xc6, 0xe9, 0x85, 0x27, 0xb6, 0x42, 0xf2,
    0xed, 0xd5, 0xce, 0x61,
};

// RFC 8446 §4.4.4, §7.1 — client Finished + application-key upgrade.
// Capture the client handshake-traffic layer before clientFinished swaps it,
// use it to decrypt the emitted record, and check the plaintext against the
// RFC 8448 §3 client Finished. Also check rx is now the §3 server application
// write key.
test "clientFinished: RFC 8448 §3 emits Finished and upgrades to app keys" {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    hs.injectClientHello(&rfc8448_client_hello);
    try hs.processServerHello(&rfc8448_server_hello);
    var flight_buf: [1024]u8 = undefined;
    try hs.processFlight(rfc8448Fixture("server_flight.b64", &flight_buf), .{});

    // Mirror of the encryptor: client handshake-traffic key at seq 0.
    var peer = hs.tx;

    var out: [128]u8 = undefined;
    const record = try hs.clientFinished(&out);
    try testing.expectEqual(.connected, hs.state);

    var dec_buf: [128]u8 = undefined;
    @memcpy(dec_buf[0..record.len], record);
    const dec = try peer.decrypt(dec_buf[0..record.len]);
    try testing.expectEqual(.handshake, dec.content_type);
    try testing.expectEqualSlices(u8, &rfc8448_client_finished, dec.content);

    // rx is now the server application write key (RFC 8448 §3).
    try testing.expectEqualSlices(u8, &.{
        0x9f, 0x02, 0x28, 0x3b, 0x6c, 0x9c, 0x07, 0xef,
        0xc2, 0x6b, 0xb9, 0xf2, 0xac, 0x92, 0xe3, 0x56,
    }, &hs.rx.aead.aes128_gcm.data);
}

// RFC 8446 §7.2 — KeyUpdate key ratchet. After the handshake, ratchet the
// client (sending) application key one generation and check the re-derived
// write key against the independently-computed next key (see the
// nextTrafficSecret vector in hkdf.zig).
test "ratchetClientKey: RFC 8446 §7.2 next application write key" {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    hs.injectClientHello(&rfc8448_client_hello);
    try hs.processServerHello(&rfc8448_server_hello);
    var flight_buf: [1024]u8 = undefined;
    try hs.processFlight(rfc8448Fixture("server_flight.b64", &flight_buf), .{});
    var out: [128]u8 = undefined;
    _ = try hs.clientFinished(&out);

    const rl = hs.suite.ratchetClientKey();
    try testing.expectEqualSlices(u8, &.{
        0x38, 0x79, 0xd8, 0x2f, 0x5f, 0x14, 0x05, 0x6e,
        0x62, 0x3f, 0x2c, 0xe5, 0xbf, 0xc6, 0x6f, 0xce,
    }, &rl.aead.aes128_gcm.data);
}

// Drive the RFC 8448 §3 handshake to connected; rx/tx carry application keys.
fn rfc8448ConnectedClient() !ClientHandshake {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    hs.injectClientHello(&rfc8448_client_hello);
    try hs.processServerHello(&rfc8448_server_hello);
    var flight_buf: [1024]u8 = undefined;
    try hs.processFlight(rfc8448Fixture("server_flight.b64", &flight_buf), .{});
    var out: [128]u8 = undefined;
    _ = try hs.clientFinished(&out);
    return hs;
}

test "handleRecord: application data returns plaintext and resets the flood counter" {
    var hs = try rfc8448ConnectedClient();
    hs.post_handshake_count = 5; // pretend we saw some control messages

    // The server's sending layer mirrors our rx (server app key, seq 0).
    var server_tx = hs.rx;
    var rec_buf: [128]u8 = undefined;
    const app_record = try server_tx.encrypt(.application_data, "ping", &rec_buf);

    var rx_buf: [128]u8 = undefined;
    @memcpy(rx_buf[0..app_record.len], app_record);
    var out: [64]u8 = undefined;
    const ev = try hs.handleRecord(rx_buf[0..app_record.len], &out);
    try testing.expectEqualSlices(u8, "ping", ev.application_data);
    try testing.expectEqual(@as(u8, 0), hs.post_handshake_count);
}

// RFC 8446 §4.6.3 — a server KeyUpdate(update_requested) must ratchet our
// receive key and elicit our own KeyUpdate(update_not_requested), encrypted
// under the old send key.
test "handleRecord: server KeyUpdate(update_requested) ratchets rx and responds" {
    var hs = try rfc8448ConnectedClient();

    // Server's sending layer (mirrors our rx at seq 0) and our pre-ratchet
    // send-key mirror to decrypt the response. Capture the server's secret_0
    // before receive() ratchets our rx, so we can advance it independently.
    const server_secret_0 = hs.suite.sha256.server_app_secret;
    var server_tx = hs.rx;
    var client_send_mirror = hs.tx;

    const ku = [_]u8{ 0x18, 0x00, 0x00, 0x01, 0x01 }; // KeyUpdate(update_requested)
    var ku_buf: [64]u8 = undefined;
    const ku_wire = try server_tx.encrypt(.handshake, &ku, &ku_buf);

    var rx_buf: [64]u8 = undefined;
    @memcpy(rx_buf[0..ku_wire.len], ku_wire);
    var out: [64]u8 = undefined;
    const ev = try hs.handleRecord(rx_buf[0..ku_wire.len], &out);

    // We responded with our own KeyUpdate, encrypted under the OLD send key.
    const resp = ev.write;
    var resp_buf: [64]u8 = undefined;
    @memcpy(resp_buf[0..resp.len], resp);
    const dec = try client_send_mirror.decrypt(resp_buf[0..resp.len]);
    try testing.expectEqual(.handshake, dec.content_type);
    try testing.expectEqualSlices(u8, &.{ 0x18, 0x00, 0x00, 0x01, 0x00 }, dec.content);
    hs.completeWrite(); // acknowledge the response was sent

    // rx ratcheted: a following server record under the next key decrypts.
    // Advance the server's send secret independently (in lockstep with our rx).
    const H = hkdf.HkdfSha256;
    const server_secret_1 = H.nextTrafficSecret(server_secret_0);
    var server_tx_1 = H.makeRecordLayer(.aes128_gcm, server_secret_1);
    var app_buf: [64]u8 = undefined;
    const app_wire = try server_tx_1.encrypt(.application_data, "after", &app_buf);
    var app_rx: [64]u8 = undefined;
    @memcpy(app_rx[0..app_wire.len], app_wire);
    const ev2 = try hs.handleRecord(app_rx[0..app_wire.len], &out);
    try testing.expectEqualSlices(u8, "after", ev2.application_data);
}

// RFC 8446 §5.1 — a KeyUpdate must end at a record boundary. Two KeyUpdates
// coalesced in one record is illegal (cf. Go CVE-2026-32283).
test "handleRecord: KeyUpdate not at record boundary is rejected" {
    var hs = try rfc8448ConnectedClient();
    var server_tx = hs.rx;

    // [KeyUpdate][KeyUpdate] in one record.
    const two_kus = [_]u8{ 0x18, 0x00, 0x00, 0x01, 0x00 } ++ [_]u8{ 0x18, 0x00, 0x00, 0x01, 0x00 };
    var buf: [64]u8 = undefined;
    const wire_rec = try server_tx.encrypt(.handshake, &two_kus, &buf);

    var rx_buf: [64]u8 = undefined;
    @memcpy(rx_buf[0..wire_rec.len], wire_rec);
    var out: [64]u8 = undefined;
    try testing.expectError(error.UnexpectedMessage, hs.handleRecord(rx_buf[0..wire_rec.len], &out));
}

test "handleRecord: KeyUpdate flood is rejected" {
    var hs = try rfc8448ConnectedClient();
    var out: [64]u8 = undefined;

    // Each iteration sends one KeyUpdate(update_not_requested) record. The
    // server advances its send key after each, in lockstep with our rx ratchet;
    // track the server's secret independently of hs.
    const H = hkdf.HkdfSha256;
    var server_secret = hs.suite.sha256.server_app_secret;
    var i: usize = 0;
    const result = while (i < max_post_handshake_messages + 1) : (i += 1) {
        var server_tx = H.makeRecordLayer(.aes128_gcm, server_secret);
        const ku = [_]u8{ 0x18, 0x00, 0x00, 0x01, 0x00 };
        var ku_buf: [64]u8 = undefined;
        const ku_wire = try server_tx.encrypt(.handshake, &ku, &ku_buf);
        var rx_buf: [64]u8 = undefined;
        @memcpy(rx_buf[0..ku_wire.len], ku_wire);
        server_secret = H.nextTrafficSecret(server_secret);
        _ = hs.handleRecord(rx_buf[0..ku_wire.len], &out) catch |e| break e;
    } else error.NoError;
    try testing.expectEqual(error.TooManyKeyUpdates, result);
}

// RFC 8446 §5 — the full driver path: pump real wire records through
// handleRecord (plaintext ServerHello, a ChangeCipherSpec to discard, then the
// encrypted flight) and confirm it auto-emits the client Finished as .write and
// reaches connected. The emitted record decrypts to the RFC 8448 §3 client
// Finished.
test "handleRecord: drives RFC 8448 §3 handshake to connected" {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    hs.injectClientHello(&rfc8448_client_hello);

    var out: [256]u8 = undefined;

    // ServerHello as a plaintext handshake record (header + 90-byte body).
    var sh_record = [_]u8{ 0x16, 0x03, 0x03, 0x00, 0x5a } ++ rfc8448_server_hello;
    try testing.expectEqual(Event.none, try hs.handleRecord(&sh_record, &out));
    try testing.expectEqual(.wait_ee, hs.state);

    // Mirror of the client handshake-traffic encryptor (seq 0), captured before
    // the flight completes and swaps tx to the application key.
    var peer = hs.tx;

    // ChangeCipherSpec — middlebox compat, discarded (RFC 8446 §D.4).
    var ccs = [_]u8{ 0x14, 0x03, 0x03, 0x00, 0x01, 0x01 };
    try testing.expectEqual(Event.none, try hs.handleRecord(&ccs, &out));
    try testing.expectEqual(.wait_ee, hs.state);

    // Encrypted server flight: completes the handshake and emits client Finished.
    var flight_buf: [1024]u8 = undefined;
    const flight = rfc8448Fixture("server_flight_record.b64", &flight_buf);
    const ev = try hs.handleRecord(flight, &out);
    try testing.expect(hs.isConnected());

    var dec_buf: [128]u8 = undefined;
    @memcpy(dec_buf[0..ev.write.len], ev.write);
    const dec = try peer.decrypt(dec_buf[0..ev.write.len]);
    try testing.expectEqual(.handshake, dec.content_type);
    try testing.expectEqualSlices(u8, &rfc8448_client_finished, dec.content);
}

// A produced .write must be acknowledged (completeWrite) before the engine
// will accept another call — so a dropped write can't silently desync.
test "handleRecord: unacknowledged write blocks further calls" {
    var hs = try rfc8448ConnectedClient();
    var out: [128]u8 = undefined;
    _ = try hs.sendApplicationData("one", &out); // sets pending_write
    try testing.expectError(error.PendingWrite, hs.sendApplicationData("two", &out));
    hs.completeWrite();
    _ = try hs.sendApplicationData("three", &out); // unblocked
}

// rx isn't installed until ServerHello; an encrypted record arriving in wait_sh
// must be rejected rather than decrypted with an undefined key.
test "handleRecord: application_data before ServerHello is rejected" {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    hs.injectClientHello(&rfc8448_client_hello); // state = wait_sh
    var rec = [_]u8{ 0x17, 0x03, 0x03, 0x00, 0x05 } ++ [_]u8{0} ** 5;
    var out: [64]u8 = undefined;
    try testing.expectError(error.UnexpectedRecord, hs.handleRecord(&rec, &out));
}

// Handshake-message iterator over a coalesced payload.
test "HandshakeReader: splits coalesced messages" {
    // Two messages: EncryptedExtensions (0x08, empty) then Finished (0x14, 4-byte body).
    const payload = [_]u8{
        0x08, 0x00, 0x00, 0x02, 0x00, 0x00,
        0x14, 0x00, 0x00, 0x04, 0xde, 0xad,
        0xbe, 0xef,
    };
    var hr: HandshakeReader = .init(&payload);

    const ee = (try hr.next()).?;
    try testing.expectEqual(.encrypted_extensions, ee.type);
    try testing.expectEqualSlices(u8, payload[0..6], ee.raw);

    const fin = (try hr.next()).?;
    try testing.expectEqual(.finished, fin.type);
    try testing.expectEqualSlices(u8, payload[6..14], fin.raw);

    try testing.expectEqual(@as(?HandshakeReader.Message, null), try hr.next());
}

test "HandshakeReader: truncated body is UnexpectedEof" {
    const payload = [_]u8{ 0x14, 0x00, 0x00, 0x04, 0xde, 0xad }; // claims 4, has 2
    var hr: HandshakeReader = .init(&payload);
    try testing.expectError(error.UnexpectedEof, hr.next());
}
