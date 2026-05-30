/// TLS 1.3 client handshake state machine.
///
/// Owns the running transcript hash and drives the handshake message sequence.
/// Does no I/O: the caller feeds in decrypted record bytes and receives bytes
/// to send. RFC 8446 §4, Appendix A.
const std = @import("std");
const assert = std.debug.assert;
const Sha256 = std.crypto.hash.sha2.Sha256;
const testing = std.testing;

const certificate = @import("certificate.zig");
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
    server_hello = 0x02,
    encrypted_extensions = 0x08,
    certificate = 0x0b,
    certificate_verify = 0x0f,
    finished = 0x14,
    _,
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
const Suite = union(enum) {
    sha256: struct {
        transcript: Sha256,
        handshake_secret: hkdf.HkdfSha256.Prk = undefined,
        client_finished_key: hkdf.HkdfSha256.Prk = undefined,
        server_finished_key: hkdf.HkdfSha256.Prk = undefined,
    },

    /// Feed one handshake message (4-byte header + body, no record framing)
    /// into the running transcript hash. RFC 8446 §4.4.1.
    fn update(self: *Suite, msg: []const u8) void {
        switch (self.*) {
            .sha256 => |*s| s.transcript.update(msg),
        }
    }

    /// Snapshot the transcript without disturbing the running hash. peek()
    /// copies the hasher by value and finalizes the copy, so the live hash
    /// keeps absorbing.
    ///
    /// Returns a concrete digest for now so chunk-1 tests can check it against
    /// RFC 8448. Once key-schedule derivation moves into the arm, the digest
    /// stops escaping and this becomes internal.
    fn transcriptHash(self: *const Suite) [Sha256.digest_length]u8 {
        return switch (self.*) {
            .sha256 => |*s| s.transcript.peek(),
        };
    }

    /// RFC 8446 §4.4.3 — authenticate the server's Certificate and
    /// CertificateVerify. Snapshots the transcript through Certificate (the
    /// state before CV is absorbed) and verifies the CV signature against it.
    /// The digest stays inside the arm.
    fn authenticateCertificate(
        self: *const Suite,
        cert_msg: []const u8,
        cv_msg: []const u8,
        policy: certificate.Policy,
    ) certificate.AuthError!void {
        switch (self.*) {
            .sha256 => |*s| {
                const th = s.transcript.peek();
                try certificate.authenticate(cert_msg, cv_msg, &th, policy);
            },
        }
    }

    /// RFC 8446 §4.4.4 — verify the server's Finished MAC. Snapshots the
    /// transcript through CertificateVerify (the state before Finished is
    /// absorbed) and checks the MAC with the retained server finished key.
    fn verifyServerFinished(self: *const Suite, finished_msg: []const u8) finished.VerifyError!void {
        switch (self.*) {
            .sha256 => |*s| {
                const th = s.transcript.peek();
                try finished.verify(finished_msg, &s.server_finished_key.data, &th);
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
            .sha256 => |*s| {
                const H = hkdf.HkdfSha256;
                const th = s.transcript.peek(); // through server Finished
                const fin = try finished.encode(out, &s.client_finished_key.data, &th);

                const master = H.masterSecret(s.handshake_secret);
                const client_ap = H.clientApplicationTrafficSecret(master, &.init(th));
                const server_ap = H.serverApplicationTrafficSecret(master, &.init(th));

                s.transcript.update(fin); // client Finished now part of the transcript

                return .{
                    .finished = fin,
                    .tx = H.makeRecordLayer(.aes128_gcm, client_ap),
                    .rx = H.makeRecordLayer(.aes128_gcm, server_ap),
                };
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
            .sha256 => |*s| {
                const H = hkdf.HkdfSha256;
                s.handshake_secret = H.handshakeSecret(H.early_secret, dhe);

                const th = s.transcript.peek();
                const client_secret = H.clientHandshakeTrafficSecret(s.handshake_secret, &.init(th));
                const server_secret = H.serverHandshakeTrafficSecret(s.handshake_secret, &.init(th));

                s.client_finished_key = H.finishedKey(client_secret);
                s.server_finished_key = H.finishedKey(server_secret);

                return .{
                    .rx = H.makeRecordLayer(.aes128_gcm, server_secret),
                    .tx = H.makeRecordLayer(.aes128_gcm, client_secret),
                };
            },
        }
    }
};

state: State,
suite: Suite,
/// Our ephemeral X25519 private key, used to compute the DHE shared secret
/// once ServerHello reveals the server's public key.
client_secret_key: [32]u8,
/// Handshake-traffic RecordLayers, installed by processServerHello.
rx: RecordLayer = undefined,
tx: RecordLayer = undefined,
/// Certificate validation policy, applied during the server flight. Defaults
/// to no chain anchoring (signature-only). Set before driving the handshake.
policy: certificate.Policy = .{},

/// Start a client handshake with our ephemeral X25519 private key. The
/// negotiated suite is hardcoded to SHA-256 for now; true suite selection
/// (and re-hashing ClientHello under SHA-384) is deferred.
pub fn init(client_secret_key: [32]u8) ClientHandshake {
    return .{
        .state = .start,
        .suite = .{ .sha256 = .{ .transcript = .init(.{}) } },
        .client_secret_key = client_secret_key,
    };
}

/// Record the ClientHello we sent: absorb it into the transcript and advance
/// start -> wait_sh. The caller encodes ClientHello (via client_hello.encode)
/// using the keypair whose secret was passed to init.
pub fn start(self: *ClientHandshake, client_hello_msg: []const u8) void {
    assert(self.state == .start);
    self.suite.update(client_hello_msg);
    self.state = .wait_sh;
}

/// What the caller should do after feeding a record to processRecord.
pub const Progress = struct {
    /// Bytes to write to the transport. Empty unless a record was produced.
    to_send: []const u8 = &.{},
    /// True once the handshake completes and application keys are installed.
    done: bool = false,
};

pub const ProcessError = frame.ParseError || RecordLayer.DecryptError ||
    ServerHelloError || FlightError || ClientFinishedError ||
    error{ IncompleteRecord, UnexpectedRecord };

/// Drive the handshake with one complete TLS record. `record` is the full
/// wire record (header + fragment) and is decrypted in place when encrypted;
/// `out` receives any record we need to send back (the client Finished).
///
/// Returns the bytes to send and whether the handshake is complete. When the
/// server's flight finishes, the client Finished is emitted automatically and
/// rx/tx are promoted to application keys. After done, do not call again —
/// use rx/tx directly for application data. RFC 8446 §5.
pub fn processRecord(self: *ClientHandshake, record: []u8, out: []u8) ProcessError!Progress {
    const hdr = try frame.parseHeader(record);
    if (record.len < frame.header_len + hdr.length()) return error.IncompleteRecord;

    switch (hdr.content_type) {
        // RFC 8446 §D.4 — middlebox-compat ChangeCipherSpec, silently dropped.
        .change_cipher_spec => return .{},
        // ServerHello is the only handshake message that arrives unencrypted.
        .handshake => {
            if (self.state != .wait_sh) return error.UnexpectedRecord;
            try self.processServerHello(record[frame.header_len..][0..hdr.length()]);
            return .{};
        },
        // Encrypted records: decrypt with rx, then feed the server flight.
        .application_data => {
            const dec = try self.rx.decrypt(record);
            if (dec.content_type != .handshake) return error.UnexpectedRecord;
            try self.processFlight(dec.content, self.policy);
            if (self.state == .send_finished) {
                return .{ .to_send = try self.clientFinished(out), .done = true };
            }
            return .{};
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
    if (sh.cipher_suite != .aes_128_gcm_sha256) return error.UnsupportedCipherSuite;

    self.suite.update(msg); // transcript now covers ClientHello || ServerHello
    const dhe = try x25519.sharedSecret(self.client_secret_key, sh.server_public_key);
    const keys = self.suite.deriveHandshakeKeys(&dhe);
    self.rx = keys.rx;
    self.tx = keys.tx;
    self.state = .wait_ee;
}

pub const FlightError = error{ UnexpectedMessage, UnexpectedEof } ||
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
/// Cross-record reassembly is not yet supported: the whole flight must arrive
/// in one payload.
pub fn processFlight(
    self: *ClientHandshake,
    payload: []const u8,
    policy: certificate.Policy,
) FlightError!void {
    var cert_msg: ?[]const u8 = null;
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
            self.suite.update(msg.raw);
            cert_msg = msg.raw; // held until CertificateVerify arrives
            self.state = .wait_cv;
            continue :flight self.state;
        },
        .wait_cv => {
            const msg = try hr.next() orelse return;
            if (msg.type != .certificate_verify) return error.UnexpectedMessage;
            // Non-null guaranteed: wait_cv is only reachable after wait_cert
            // stored the Certificate message.
            try self.suite.authenticateCertificate(cert_msg.?, msg.raw, policy);
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

pub const ClientFinishedError = error{ BufferTooShort, SequenceNumberOverflow };

/// Produce the client Finished as a wire-ready (encrypted) record and promote
/// to application traffic keys. RFC 8446 §4.4.4, §7.1. Advances
/// send_finished -> connected.
///
/// The Finished is encrypted under the still-active handshake-traffic key, then
/// rx/tx are swapped to application-traffic keys. After this returns, both
/// directions carry application data. `out` receives the encrypted record and
/// the returned slice is the bytes to send.
pub fn clientFinished(self: *ClientHandshake, out: []u8) ClientFinishedError![]const u8 {
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
    var hs: ClientHandshake = .init(@splat(0));
    hs.suite.update(&rfc8448_client_hello);
    hs.suite.update(&rfc8448_server_hello);

    try testing.expectEqualSlices(u8, &.{
        0x86, 0x0c, 0x06, 0xed, 0xc0, 0x78, 0x58, 0xee,
        0x8e, 0x78, 0xf0, 0xe7, 0x42, 0x8c, 0x58, 0xed,
        0xd6, 0xb4, 0x3f, 0x2c, 0xa3, 0xe6, 0xe9, 0x5f,
        0x02, 0xed, 0x06, 0x3c, 0xf0, 0xe1, 0xca, 0xd8,
    }, &hs.suite.transcriptHash());
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

    var hs: ClientHandshake = .init(@splat(0));
    hs.suite.update(&rfc8448_client_hello);
    hs.suite.update(&rfc8448_server_hello);

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

// RFC 8448 §3 client ephemeral X25519 private key.
const rfc8448_client_secret_key = [_]u8{
    0x49, 0xaf, 0x42, 0xba, 0x7f, 0x79, 0x94, 0x85,
    0x2d, 0x71, 0x3e, 0xf2, 0x78, 0x4b, 0xcb, 0xca,
    0xa7, 0x91, 0x1d, 0xe2, 0x6a, 0xdc, 0x56, 0x42,
    0xcb, 0x63, 0x45, 0x40, 0xe7, 0xea, 0x50, 0x05,
};

// RFC 8446 §4.1.3, §7.1 — ServerHello processing end to end: parse, absorb,
// X25519 DHE, key schedule. The installed rx RecordLayer must carry the
// RFC 8448 §3 server handshake write key, proving the X25519 + key-schedule
// integration (not just isolated derivation from a literal shared secret).
test "processServerHello: RFC 8448 §3 installs server handshake keys" {
    var hs: ClientHandshake = .init(rfc8448_client_secret_key);
    hs.start(&rfc8448_client_hello);

    try hs.processServerHello(&rfc8448_server_hello);

    try testing.expectEqual(.wait_ee, hs.state);
    try testing.expectEqualSlices(u8, &.{
        0x3f, 0xce, 0x51, 0x60, 0x09, 0xc2, 0x17, 0x27,
        0xd0, 0xf2, 0xe4, 0xe8, 0x6e, 0xe4, 0x03, 0xbc,
    }, &hs.rx.aead.aes128_gcm.data);
}

// RFC 8448 §3 server flight: EncryptedExtensions || Certificate ||
// CertificateVerify || Finished, decrypted plaintext, extracted from the trace.
const rfc8448_server_flight = @embedFile("test_fixtures/rfc8448_server_flight.bin");

// RFC 8446 §4.3-§4.4 — the full encrypted flight driven by the live transcript.
// One call exercises EncryptedExtensions parsing, RSA-PSS CertificateVerify
// over the through-Certificate transcript, and the server Finished MAC over the
// through-CertificateVerify transcript — all against genuine RFC 8448 §3 bytes.
// The default policy (.{}) skips chain anchoring; the CV signature check still
// runs and passes because §3's cert and CV are internally consistent.
test "processFlight: RFC 8448 §3 full server flight to connected" {
    var hs: ClientHandshake = .init(rfc8448_client_secret_key);
    hs.start(&rfc8448_client_hello);
    try hs.processServerHello(&rfc8448_server_hello);

    try hs.processFlight(rfc8448_server_flight, .{});
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
    var hs: ClientHandshake = .init(rfc8448_client_secret_key);
    hs.start(&rfc8448_client_hello);
    try hs.processServerHello(&rfc8448_server_hello);
    try hs.processFlight(rfc8448_server_flight, .{});

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

// RFC 8448 §3 encrypted server flight as a complete wire record (TLSCiphertext).
const rfc8448_server_flight_record = @embedFile("test_fixtures/rfc8448_server_flight_record.bin");

// RFC 8446 §5 — the full driver path: pump real wire records through
// processRecord (plaintext ServerHello, a ChangeCipherSpec to discard, then the
// encrypted flight) and confirm it auto-emits the client Finished and reports
// done. The emitted record decrypts to the RFC 8448 §3 client Finished.
test "processRecord: drives RFC 8448 §3 handshake to done" {
    var hs: ClientHandshake = .init(rfc8448_client_secret_key);
    hs.start(&rfc8448_client_hello);

    var out: [256]u8 = undefined;

    // ServerHello as a plaintext handshake record (header + 90-byte body).
    var sh_record = [_]u8{ 0x16, 0x03, 0x03, 0x00, 0x5a } ++ rfc8448_server_hello;
    const p_sh = try hs.processRecord(&sh_record, &out);
    try testing.expect(!p_sh.done);
    try testing.expectEqual(@as(usize, 0), p_sh.to_send.len);
    try testing.expectEqual(.wait_ee, hs.state);

    // Mirror of the client handshake-traffic encryptor (seq 0), captured before
    // clientFinished swaps tx to the application key.
    var peer = hs.tx;

    // ChangeCipherSpec — middlebox compat, discarded (RFC 8446 §D.4).
    var ccs = [_]u8{ 0x14, 0x03, 0x03, 0x00, 0x01, 0x01 };
    const p_ccs = try hs.processRecord(&ccs, &out);
    try testing.expect(!p_ccs.done);
    try testing.expectEqual(.wait_ee, hs.state);

    // Encrypted server flight: completes the handshake and emits client Finished.
    var flight = rfc8448_server_flight_record.*;
    const p_fin = try hs.processRecord(flight[0..], &out);
    try testing.expect(p_fin.done);
    try testing.expectEqual(.connected, hs.state);

    var dec_buf: [128]u8 = undefined;
    @memcpy(dec_buf[0..p_fin.to_send.len], p_fin.to_send);
    const dec = try peer.decrypt(dec_buf[0..p_fin.to_send.len]);
    try testing.expectEqual(.handshake, dec.content_type);
    try testing.expectEqualSlices(u8, &rfc8448_client_finished, dec.content);
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
