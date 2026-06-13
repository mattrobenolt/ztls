/// TLS 1.3 client handshake state machine.
///
/// Owns the running transcript hash and drives the handshake message sequence.
/// Does no I/O: the caller feeds in decrypted record bytes and receives bytes
/// to send. RFC 8446 §4, Appendix A.
const std = @import("std");
const assert = std.debug.assert;
const crypto = std.crypto;
const Sha256 = crypto.hash.sha2.Sha256;
const Sha384 = crypto.hash.sha2.Sha384;
const testing = std.testing;
const mem = std.mem;
const base64 = std.base64.standard.Decoder;

const txtar = @import("txtar");

const aead = @import("aead.zig");
const alert = @import("alert.zig");
const array_buffer = @import("array_buffer.zig");
const ArrayBuffer = array_buffer.ArrayBuffer;
const SliceBuffer = array_buffer.SliceBuffer;
const certificate = @import("certificate.zig");
const CipherSuite = @import("root.zig").CipherSuite;
const client_hello = @import("client_hello.zig");
const encrypted_extensions = @import("encrypted_extensions.zig");
const finished = @import("finished.zig");
const frame = @import("frame.zig");
pub const max_out_len = frame.max_wire_record_len;
pub const OutBuffer = frame.OutBuffer;
const handshake = @import("handshake.zig");
pub const HandshakeReader = handshake.Reader;
pub const HandshakeType = handshake.Type;
pub const KeyUpdateRequest = handshake.KeyUpdateRequest;
/// Max consecutive post-handshake messages with no intervening application
/// data before we treat the peer as flooding us (RFC 8446 §4.6.3 allows
/// either side to force updates; an unbounded stream is a DoS). Mirrors Go's
/// maxUselessRecords. Reset by application data.
const max_post_handshake_messages = handshake.max_post_handshake_messages;
const hkdf = @import("hkdf.zig");
const memx = @import("memx.zig");
const NewSessionTicket = @import("NewSessionTicket.zig");
const PendingWrite = @import("pending_write.zig").PendingWrite;
const RecordLayer = @import("RecordLayer.zig");
const server_hello = @import("server_hello.zig");
const SignatureScheme = @import("signature_scheme.zig").SignatureScheme;
const suite_state = @import("suite_state.zig");
const HashArm = suite_state.HashArm;
const x25519 = @import("x25519.zig");

const ClientHandshake = @This();

/// Upper bound on a leaf public key we retain across records. Covers RSA-4096
/// (~525-byte DER) with margin; ECDSA P-256/P-384 are far smaller.
const max_leaf_pub_key = 1024;
const LeafPublicKeyBuffer = ArrayBuffer(u8, max_leaf_pub_key);
const LegacySessionIdBuffer = ArrayBuffer(u8, 32);
const OfferedSuitesBuffer = ArrayBuffer(CipherSuite, 8);
const OfferedSignatureSchemesBuffer = ArrayBuffer(SignatureScheme, 16);
const SelectedAlpnBuffer = ArrayBuffer(u8, 255);
const HandshakeBuffer = SliceBuffer(u8);

const ServerFlightProgress = enum {
    none,
    certificate_verified,
    certificate_verify_verified,
    finished_verified,
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

const Suite = union(enum) {
    /// Pre-ServerHello: the negotiated hash isn't known yet, so run both
    /// transcript hashes and keep the one the chosen suite uses. RFC 8446
    /// §4.4.1 permits deferring the transcript until the hash is selected.
    const Buffering = struct {
        sha256: Sha256,
        sha384: Sha384,

        const init: Buffering = .{ .sha256 = .init(.{}), .sha384 = .init(.{}) };
    };

    buffering: Buffering,
    sha256: HashArm(hkdf.HkdfSha256, Sha256),
    sha384: HashArm(hkdf.HkdfSha384, Sha384),

    pub const init: Suite = .{ .buffering = .init };

    fn secureZero(self: *Suite) void {
        switch (self.*) {
            .buffering => {},
            inline .sha256, .sha384 => |*s| s.secureZero(),
        }
    }

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
        offered_schemes: []const SignatureScheme,
    ) certificate.VerifyError!void {
        switch (self.*) {
            .buffering => unreachable,
            inline .sha256, .sha384 => |*s| {
                const th = s.transcript.peek();
                try certificate.verifyServerSignatureWithSchemes(
                    cv_msg,
                    pub_key,
                    &th,
                    offered_schemes,
                );
            },
        }
    }

    /// RFC 8446 §4.4.4 — verify the server's Finished MAC. Snapshots the
    /// transcript through CertificateVerify (the state before Finished is
    /// absorbed) and checks the MAC with the retained server finished key.
    fn verifyServerFinished(
        self: *const Suite,
        finished_msg: []const u8,
    ) finished.VerifyError!void {
        switch (self.*) {
            .buffering => unreachable,
            inline .sha256, .sha384 => |*s| {
                const th = s.transcript.peek();
                try finished.verify(
                    @TypeOf(s.transcript),
                    finished_msg,
                    &s.server_finished_key.data,
                    &th,
                );
            },
        }
    }

    /// RFC 8446 §4.4.4, §7.1 — encode the client Finished and derive the
    /// application-traffic RecordLayers. Both use one transcript snapshot taken
    /// through the server Finished (the Master Secret point); the client
    /// Finished is absorbed afterward. The plaintext Finished is written to
    /// `out`; rx/tx are application-keyed.
    fn finishHandshake(
        self: *Suite,
        out: []u8,
    ) (error{BufferTooShort} || aead.Error)!HandshakeKeys.WithFinished {
        switch (self.*) {
            .buffering => unreachable,
            inline .sha256, .sha384 => |*s| {
                const H = @TypeOf(s.*).Hkdf;
                const th = s.transcript.peek(); // through server Finished
                const fin = try finished.encode(
                    @TypeOf(s.transcript),
                    out,
                    &s.client_finished_key.data,
                    &th,
                );

                const master = H.masterSecret(s.handshake_secret);
                s.client_app_secret = H.clientApplicationTrafficSecret(master, &.init(th));
                s.server_app_secret = H.serverApplicationTrafficSecret(master, &.init(th));

                s.transcript.update(fin); // client Finished now part of the transcript

                var tx = try H.makeRecordLayer(s.aead, s.client_app_secret);
                errdefer tx.deinit();
                const rx = try H.makeRecordLayer(s.aead, s.server_app_secret);

                return .{
                    .finished = fin,
                    .tx = tx,
                    .rx = rx,
                };
            },
        }
    }

    /// RFC 8446 §7.2 — ratchet our sending (client) application key and return
    /// the fresh RecordLayer (sequence number reset to 0).
    pub fn ratchetClientKey(self: *Suite) aead.Error!RecordLayer {
        switch (self.*) {
            .buffering => unreachable,
            inline .sha256, .sha384 => |*s| return s.ratchetClientKey(),
        }
    }

    /// RFC 8446 §7.2 — ratchet the peer's sending (server) application key and
    /// return the fresh RecordLayer (sequence number reset to 0).
    pub fn ratchetServerKey(self: *Suite) aead.Error!RecordLayer {
        switch (self.*) {
            .buffering => unreachable,
            inline .sha256, .sha384 => |*s| return s.ratchetServerKey(),
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
    fn deriveHandshakeKeys(self: *Suite, dhe: []const u8) aead.Error!HandshakeKeys {
        switch (self.*) {
            .buffering => unreachable,
            inline .sha256, .sha384 => |*s| {
                const H = @TypeOf(s.*).Hkdf;
                s.handshake_secret = H.handshakeSecret(H.early_secret, dhe);

                const th = s.transcript.peek();
                const client_secret =
                    H.clientHandshakeTrafficSecret(s.handshake_secret, &.init(th));
                const server_secret =
                    H.serverHandshakeTrafficSecret(s.handshake_secret, &.init(th));

                s.client_finished_key = H.finishedKey(client_secret);
                s.server_finished_key = H.finishedKey(server_secret);

                var rx = try H.makeRecordLayer(s.aead, server_secret);
                errdefer rx.deinit();
                const tx = try H.makeRecordLayer(s.aead, client_secret);

                return .{ .rx = rx, .tx = tx };
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
pending_write: PendingWrite = .idle,
/// Certificate validation policy, applied during the server flight. Set a trust
/// bundle or the explicit insecure_no_chain_anchor test/demo opt-in before
/// processing the server Certificate.
policy: certificate.Policy = .{},
/// Leaf public key extracted from the Certificate message, copied here so it
/// survives until CertificateVerify (which may arrive in a later record —
/// openssl sends each flight message in its own record). Sized for RSA-4096.
leaf_pub_key: LeafPublicKeyBuffer = .empty,
/// Optional caller-owned storage for a handshake message that spans encrypted
/// records. Empty means spanning messages are rejected with UnexpectedEof.
handshake_buf: HandshakeBuffer = .empty,
/// Consecutive post-handshake messages seen with no intervening application
/// data; reset by application data. Bounds KeyUpdate-flood DoS.
post_handshake_count: u8 = 0,
/// Ordered verification progress through the server flight. Finished emission
/// requires Certificate, CertificateVerify, and Finished to verify in sequence.
server_flight_progress: ServerFlightProgress = .none,
/// ClientHello legacy_session_id expected back in ServerHello.
legacy_session_id: LegacySessionIdBuffer = .empty,
/// Recognized cipher suites offered in ClientHello.
offered_suites: OfferedSuitesBuffer = .empty,
/// Recognized signature schemes offered in ClientHello.signature_algorithms.
offered_signature_schemes: OfferedSignatureSchemesBuffer = .empty,
/// ALPN protocols offered in ClientHello. Caller-owned, must live until start().
alpn_protocols: client_hello.AlpnProtocols = &.{},
selected_alpn: SelectedAlpnBuffer = .empty,

/// Start a client handshake with our ephemeral X25519 keypair. The negotiated
/// suite is hardcoded to SHA-256 for now; true suite selection (and re-hashing
/// ClientHello under SHA-384) is deferred.
pub fn init(keypair: x25519.KeyPair) ClientHandshake {
    return .{
        .state = .start,
        // Hash unknown until ServerHello: run both candidate transcripts.
        .suite = .init,
        .keypair = keypair,
    };
}

pub fn deinit(self: *ClientHandshake) void {
    switch (self.state) {
        .wait_ee, .wait_cert, .wait_cv, .wait_finished, .send_finished, .connected => {
            self.rx.deinit();
            self.tx.deinit();
        },
        .start, .wait_sh => {},
    }
    self.suite.secureZero();
    self.keypair.secret_key.secureZero();
    self.* = undefined;
}

/// Acknowledge that the bytes from the last engine call were written to the
/// transport, clearing the pending-write block. Call after writing any
/// `.write` event or send-method result.
pub fn completeWrite(self: *ClientHandshake) void {
    self.pending_write.clear();
}

pub const StartError = error{ BufferTooShort, ServerNameTooLong } || client_hello.AlpnError;

/// Provide caller-owned storage for reassembling handshake messages that span
/// encrypted records (large certificate chains, fragmented flights). Without
/// this, a spanning message is rejected with UnexpectedEof. The storage must
/// live at least until the handshake completes.
pub fn useHandshakeBuffer(self: *ClientHandshake, storage: []u8) void {
    assert(self.handshake_buf.len == 0);
    self.handshake_buf = .init(storage);
}

/// Offer ALPN protocols in ClientHello. Each protocol must be 1..255 bytes.
/// The slice is caller-owned and only needs to live until start() encodes it.
pub fn offerAlpn(self: *ClientHandshake, protocols: client_hello.AlpnProtocols) void {
    assert(self.state == .start);
    self.alpn_protocols = protocols;
}

/// The ALPN protocol selected by the server, if any. Stable after the
/// EncryptedExtensions message is processed.
pub fn selectedAlpnProtocol(self: *const ClientHandshake) ?[]const u8 {
    if (self.selected_alpn.len == 0) return null;
    return self.selected_alpn.constSlice();
}

/// Begin the handshake: encode a ClientHello (from the init keypair's public
/// key), frame it as a plaintext record into `out`, absorb it into the
/// transcript, and advance start -> wait_sh. Returns the wire-ready record to
/// send (then completeWrite() once sent). RFC 8446 §4.1.2, §5.1.
// ziglint-ignore: Z015 -- StartError is a public error-set alias.
pub fn start(
    self: *ClientHandshake,
    out: []u8,
    random: client_hello.Random,
    server_name: ?[]const u8,
) StartError![]const u8 {
    assert(self.state == .start);
    if (out.len < frame.header_len) return error.BufferTooShort;
    if (self.policy.host_name == null) self.policy.host_name = server_name;
    const ch = try client_hello.encode(
        out[frame.header_len..],
        random,
        self.keypair.public_key,
        server_name,
        self.alpn_protocols,
    );
    const header: frame.Header = .init(.handshake, @intCast(ch.len));
    header.write(out[0..frame.header_len]);
    self.injectClientHello(ch);
    self.pending_write.mark();
    return out[0 .. frame.header_len + ch.len];
}

/// Low-level: absorb a pre-built ClientHello handshake message into the
/// transcript and advance start -> wait_sh. For callers that build their own
/// ClientHello (and tests driving fixed vectors); most use start() instead.
pub fn injectClientHello(self: *ClientHandshake, client_hello_msg: []const u8) void {
    assert(self.state == .start);
    self.legacy_session_id.clear();
    self.offered_suites.clear();
    self.offered_signature_schemes.clear();
    const parsed = client_hello.parse(client_hello_msg) catch null;
    if (parsed) |ch| {
        self.legacy_session_id.appendSlice(ch.legacy_session_id) catch
            self.legacy_session_id.clear();
        var i: usize = 0;
        while (i < ch.cipher_suites.len) : (i += 2) {
            const wire_suite = memx.readInt(u16, ch.cipher_suites[i..][0..2]);
            const suite = CipherSuite.fromWire(wire_suite) orelse continue;
            self.offered_suites.append(suite) catch break;
        }
        i = 0;
        while (i < ch.signature_schemes.len) : (i += 2) {
            const wire_scheme = memx.readInt(u16, ch.signature_schemes[i..][0..2]);
            const scheme: SignatureScheme = @enumFromInt(wire_scheme);
            if (!scheme.supportsHandshake()) continue;
            if (mem.indexOfScalar(
                SignatureScheme,
                self.offered_signature_schemes.constSlice(),
                scheme,
            ) != null) continue;
            self.offered_signature_schemes.append(scheme) catch unreachable;
        }
    } else {
        self.offered_signature_schemes.appendSlice(
            SignatureScheme.supported_handshake,
        ) catch unreachable;
    }
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
    /// The peer sent close_notify.
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
// ziglint-ignore: Z015 -- HandleError is a public error-set alias.
pub fn handleRecord(self: *ClientHandshake, record: []u8, out: []u8) HandleError!Event {
    if (self.pending_write.isPending()) return error.PendingWrite;
    const ev: Event = if (self.state == .connected)
        try self.receiveConnected(record, out)
    else if (try self.processHandshakeRecord(record, out)) |bytes|
        .{ .write = bytes }
    else
        .none;
    if (ev == .write) self.pending_write.mark();
    return ev;
}

pub const AlertError = RecordLayer.EncryptError || error{PendingWrite};

pub fn alertForError(err: anyerror) alert.Description {
    return switch (err) {
        error.AuthenticationFailed => .bad_record_mac,
        error.SignatureVerificationFailed,
        error.InvalidVerifyData,
        => .decrypt_error,
        error.EmptyCertificateList,
        error.InvalidAlertLength,
        error.InvalidEncoding,
        error.InvalidEnumTag,
        error.InvalidExtensionLength,
        error.InvalidHandshakeLength,
        error.InvalidVectorLength,
        error.UnexpectedEof,
        error.IncompleteRecord,
        error.RecordTooShort,
        error.InvalidInnerPlaintext,
        => .decode_error,
        error.MissingTrustAnchor,
        error.CertificateIssuerNotFound,
        => .unknown_ca,
        error.CertificateExpired,
        error.CertificateNotYetValid,
        => .certificate_expired,
        error.CertificateKeyUsageRejected,
        error.CertificateExtendedKeyUsageRejected,
        error.CertificateSignatureAlgorithmRejected,
        error.CertificateSignatureAlgorithmUnsupported,
        error.UnsupportedCertificateVersion,
        => .unsupported_certificate,
        error.CertificateHostMismatch,
        error.CertificateNameConstraintViolation,
        error.CertificateNameConstraintUnsupported,
        => .certificate_unknown,
        error.CertificateFieldHasInvalidLength,
        error.CertificateFieldHasWrongDataType,
        error.CertificateHasInvalidBitString,
        error.CertificateTimeInvalid,
        error.CertificateHasUnrecognizedObjectId,
        error.CertificateIssuerMismatch,
        error.CertificatePublicKeyInvalid,
        error.CertificateSignatureAlgorithmMismatch,
        error.CertificateSignatureInvalidLength,
        error.InvalidSignature,
        => .bad_certificate,
        error.MissingExtension,
        error.MissingSignatureAlgorithmsExtension,
        => .missing_extension,
        error.UnsupportedExtension => .unsupported_extension,
        error.UnsupportedTlsVersion => .protocol_version,
        error.UnsupportedCipherSuite => .handshake_failure,
        error.NoApplicationProtocol => .no_application_protocol,
        error.DuplicateExtension,
        error.DuplicateKeyShare,
        error.InvalidCompressionMethod,
        error.InvalidLegacyVersion,
        error.InvalidSessionIdEcho,
        error.UnexpectedCertificateRequestContext,
        error.UnexpectedExtension,
        error.IllegalParameter,
        error.UnsupportedKeyShareGroup,
        error.UnsupportedSignatureScheme,
        => .illegal_parameter,
        error.InvalidHandshakeType,
        error.UnexpectedRecord,
        error.UnexpectedMessage,
        => .unexpected_message,
        else => .internal_error,
    };
}

/// Encode a TLS alert record (then completeWrite() once sent). Before handshake
/// keys exist this emits a plaintext alert record; after ServerHello it encrypts
/// the alert under the current send traffic key. RFC 8446 §6.
// ziglint-ignore: Z015 -- AlertError is a public error-set alias.
pub fn sendAlert(
    self: *ClientHandshake,
    description: alert.Description,
    out: []u8,
) AlertError![]const u8 {
    if (self.pending_write.isPending()) return error.PendingWrite;
    var msg: [2]u8 = undefined;
    const level: alert.Level = if (description == .close_notify) .warning else .fatal;
    _ = alert.encode(&msg, level, description) catch unreachable;

    const record = switch (self.state) {
        .start, .wait_sh => alert.plaintextRecord(&msg, out),
        else => try self.tx.encrypt(.alert, &msg, out),
    };
    self.pending_write.mark();
    return record;
}

/// Encrypt application data into a wire-ready record (then completeWrite() once
/// sent). RFC 8446 §5.2.
// ziglint-ignore: Z015 -- SendError is a public error-set alias.
pub fn sendApplicationData(
    self: *ClientHandshake,
    plaintext: []const u8,
    out: []u8,
) SendError![]const u8 {
    return handshake.sendApplicationData(self, plaintext, out);
}

// ziglint-ignore: Z015 -- SendError is a public error-set alias.
pub fn sendPreparedApplicationData(
    self: *ClientHandshake,
    plaintext_len: usize,
    out: []u8,
) SendError![]const u8 {
    return handshake.sendPreparedApplicationData(self, plaintext_len, out);
}

pub const ProcessError = frame.ParseError || RecordLayer.DecryptError ||
    ServerHelloError || FlightError || SendError || alert.ParseError ||
    error{ IncompleteRecord, UnexpectedRecord, UnexpectedMessage, PeerAlert };

// Handshake-phase inbound: drive the flight from one record, returning the
// client Finished to send when the flight completes, else null.
fn processHandshakeRecord(
    self: *ClientHandshake,
    record: []u8,
    out: []u8,
) ProcessError!?[]const u8 {
    const hdr = try frame.parseHeader(record);
    if (record.len < frame.header_len + hdr.length()) return error.IncompleteRecord;

    switch (hdr.content_type) {
        // RFC 8446 §D.4 — middlebox-compat ChangeCipherSpec is silently
        // dropped only after our first ClientHello and before the peer Finished.
        .change_cipher_spec => {
            if (self.state == .start or self.state == .send_finished) return error.UnexpectedRecord;
            try handshake.validateChangeCipherSpec(record[frame.header_len..][0..hdr.length()]);
            return null;
        },
        // ServerHello is the only handshake message that arrives unencrypted.
        .handshake => {
            if (self.state != .wait_sh) return error.UnexpectedRecord;
            if (hdr.length() == 0) return error.UnexpectedRecord;
            try self.processServerHello(record[frame.header_len..][0..hdr.length()]);
            return null;
        },
        // Encrypted records: decrypt with rx, then feed the server flight. rx
        // isn't installed until ServerHello, so reject app-data before wait_ee.
        .application_data => {
            if (self.state == .start or self.state == .wait_sh) return error.UnexpectedRecord;
            const dec = try handshake.decryptProtected(&self.rx, record);
            switch (dec.content_type) {
                .handshake => {
                    if (dec.content.len == 0) return error.UnexpectedMessage;
                    try self.processFlight(dec.content, self.policy);
                    return if (self.state == .send_finished) try self.clientFinished(out) else null;
                },
                .alert => {
                    const a = try alert.parse(dec.content);
                    return if (a.isCloseNotify()) null else error.PeerAlert;
                },
                else => return error.UnexpectedRecord,
            }
        },
        .alert => {
            const a = try alert.parse(record[frame.header_len..][0..hdr.length()]);
            return if (a.isCloseNotify()) null else error.PeerAlert;
        },
        else => return error.UnexpectedRecord,
    }
}

pub const ServerHelloError = server_hello.ParseError || aead.Error || error{
    UnsupportedCipherSuite,
    IdentityElement,
    LibcryptoFailed,
};

fn offeredSuite(self: *const ClientHandshake, suite: CipherSuite) bool {
    for (self.offered_suites.constSlice()) |offered| {
        if (offered == suite) return true;
    }
    return false;
}

/// Process the server's ServerHello: parse it, absorb it into the transcript,
/// compute the DHE shared secret, and install the handshake-traffic keys.
/// RFC 8446 §4.1.3, §7.1. Advances wait_sh -> wait_ee.
// ziglint-ignore: Z015 -- ServerHelloError is a public error-set alias.
pub fn processServerHello(self: *ClientHandshake, msg: []const u8) ServerHelloError!void {
    assert(self.state == .wait_sh);
    const sh = try server_hello.parseWithSessionIdEcho(msg, self.legacy_session_id.constSlice());
    if (!self.offeredSuite(sh.cipher_suite)) return error.UnsupportedCipherSuite;
    // Collapse the dual transcript to the negotiated hash's arm, carrying over
    // the hasher that already absorbed ClientHello.
    const b = self.suite.buffering;
    self.suite = switch (sh.cipher_suite) {
        .aes_128_gcm_sha256, .chacha20_poly1305_sha256 => .{
            .sha256 = .{ .transcript = b.sha256, .aead = sh.cipher_suite },
        },
        .aes_256_gcm_sha384 => .{
            .sha384 = .{ .transcript = b.sha384, .aead = sh.cipher_suite },
        },
    };

    self.suite.update(msg); // transcript now covers ClientHello || ServerHello
    const dhe = try x25519.sharedSecret(self.keypair.secret_key, sh.server_public_key);
    const keys = try self.suite.deriveHandshakeKeys(&dhe);
    self.rx = keys.rx;
    self.tx = keys.tx;
    self.state = .wait_ee;
}

pub const FlightError = error{
    UnexpectedMessage,
    UnexpectedEof,
    CertificateKeyTooLarge,
    HandshakeBufferTooShort,
} ||
    encrypted_extensions.ParseError ||
    certificate.ParseError ||
    certificate.VerifyError ||
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
// ziglint-ignore: Z015 -- FlightError is a public error-set alias.
pub fn processFlight(
    self: *ClientHandshake,
    payload: []const u8,
    policy: certificate.Policy,
) FlightError!void {
    if (self.handshake_buf.len != 0) {
        try self.appendHandshakeFragment(payload);
        return self.processFlightBuffer(policy);
    }
    return self.processFlightBytes(payload, policy);
}

fn processFlightBytes(
    self: *ClientHandshake,
    payload: []const u8,
    policy: certificate.Policy,
) FlightError!void {
    if (payload.len == 0) return error.UnexpectedMessage;
    var hr: HandshakeReader = .init(payload);
    while (true) {
        const msg = hr.next() catch |err| switch (err) {
            error.UnexpectedEof => {
                try self.stashHandshakeFragment(payload[hr.r.pos..]);
                return;
            },
        } orelse return;
        try self.processFlightMessage(msg, policy);
        if (self.state == .send_finished) return;
    }
}

fn processFlightBuffer(self: *ClientHandshake, policy: certificate.Policy) FlightError!void {
    var hr: HandshakeReader = .init(self.handshake_buf.constSlice());
    while (true) {
        const msg = hr.next() catch |err| switch (err) {
            error.UnexpectedEof => {
                const partial = self.handshake_buf.constSlice()[hr.r.pos..];
                self.handshake_buf.retainFrom(partial) catch unreachable;
                return;
            },
        } orelse {
            self.handshake_buf.clear();
            return;
        };
        try self.processFlightMessage(msg, policy);
        if (self.state == .send_finished) {
            self.handshake_buf.clear();
            return;
        }
    }
}

fn processFlightMessage(
    self: *ClientHandshake,
    msg: HandshakeReader.Message,
    policy: certificate.Policy,
) FlightError!void {
    switch (self.state) {
        .wait_ee => {
            if (msg.type != .encrypted_extensions) return error.UnexpectedMessage;
            const ee = try encrypted_extensions.parse(msg.raw, self.alpn_protocols);
            if (ee.alpn_protocol) |protocol| {
                self.selected_alpn.clear();
                self.selected_alpn.appendSliceAssumeCapacity(protocol);
            }
            self.suite.update(msg.raw);
            self.state = .wait_cert;
        },
        .wait_cert => {
            if (msg.type != .certificate) return error.UnexpectedMessage;
            // Extract and copy the leaf public key now; it must survive until
            // CertificateVerify, which may arrive in a later record.
            const pk = try certificate.parse(msg.raw, policy);
            self.leaf_pub_key.clear();
            self.leaf_pub_key.appendSlice(pk) catch return error.CertificateKeyTooLarge;
            self.server_flight_progress = .certificate_verified;
            self.suite.update(msg.raw);
            self.state = .wait_cv;
        },
        .wait_cv => {
            if (msg.type != .certificate_verify) return error.UnexpectedMessage;
            if (self.server_flight_progress != .certificate_verified)
                return error.UnexpectedMessage;
            try self.suite.verifyCertificate(
                msg.raw,
                self.leaf_pub_key.constSlice(),
                self.offered_signature_schemes.constSlice(),
            );
            self.server_flight_progress = .certificate_verify_verified;
            self.suite.update(msg.raw);
            self.state = .wait_finished;
        },
        .wait_finished => {
            if (msg.type != .finished) return error.UnexpectedMessage;
            if (self.server_flight_progress != .certificate_verify_verified)
                return error.UnexpectedMessage;
            try self.suite.verifyServerFinished(msg.raw);
            self.server_flight_progress = .finished_verified;
            self.suite.update(msg.raw);
            self.state = .send_finished;
        },
        else => return error.UnexpectedMessage,
    }
}

fn appendHandshakeFragment(self: *ClientHandshake, payload: []const u8) FlightError!void {
    self.handshake_buf.appendSlice(payload) catch return error.HandshakeBufferTooShort;
}

fn stashHandshakeFragment(self: *ClientHandshake, fragment: []const u8) FlightError!void {
    if (self.handshake_buf.buffer.len == 0) return error.UnexpectedEof;
    self.handshake_buf.clear();
    self.handshake_buf.appendSlice(fragment) catch return error.HandshakeBufferTooShort;
}

/// Errors from encrypting an outbound record into the caller's buffer.
pub const SendError = RecordLayer.EncryptError || error{ PendingWrite, UnexpectedMessage };

/// Produce the client Finished as a wire-ready (encrypted) record and promote
/// to application traffic keys. RFC 8446 §4.4.4, §7.1. Advances
/// send_finished -> connected.
///
/// The Finished is encrypted under the still-active handshake-traffic key, then
/// rx/tx are swapped to application-traffic keys. After this returns, both
/// directions carry application data. `out` receives the encrypted record and
/// the returned slice is the bytes to send.
// ziglint-ignore: Z015 -- SendError is a public error-set alias.
pub fn clientFinished(self: *ClientHandshake, out: []u8) SendError![]const u8 {
    assert(self.state == .send_finished);
    if (self.server_flight_progress != .finished_verified) return error.UnexpectedMessage;

    // Plaintext Finished: 4-byte handshake header + verify_data. verify_data
    // is one hash digest: 32 bytes (SHA-256) or 48 (SHA-384).
    var fin_buf: [4 + 48]u8 = undefined;
    const keys = try self.suite.finishHandshake(&fin_buf);

    // Encrypt under the handshake-traffic key that is still installed, then
    // promote: the Finished is the last handshake-protected message.
    const record = try self.tx.encrypt(.handshake, keys.finished, out);
    self.tx.deinit();
    self.rx.deinit();
    self.tx = keys.tx;
    self.rx = keys.rx;
    self.state = .connected;
    return record;
}

pub const ReceiveError = RecordLayer.DecryptError || SendError || alert.ParseError ||
    NewSessionTicket.ParseError ||
    error{
        UnexpectedEof,
        UnexpectedRecord,
        UnexpectedMessage,
        IllegalParameter,
        TooManyKeyUpdates,
        PeerAlert,
    };

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
    const dec = try handshake.decryptProtected(&self.rx, record);
    switch (dec.content_type) {
        .application_data => {
            self.post_handshake_count = 0;
            return .{ .application_data = dec.content };
        },
        .handshake => {
            if (dec.content.len == 0) return error.UnexpectedMessage;
            var respond = false;
            var hr: HandshakeReader = .init(dec.content);
            while (try hr.next()) |msg| {
                self.post_handshake_count +|= 1;
                if (self.post_handshake_count > max_post_handshake_messages)
                    return error.TooManyKeyUpdates;
                switch (msg.type) {
                    .key_update => {
                        // RFC 8446 §5.1: a message immediately preceding a key
                        // change MUST align with a record boundary. A KeyUpdate
                        // sharing its record with anything that follows would be
                        // protected under a different key epoch than it implies.
                        // Reject before ratcheting (cf. Go CVE-2026-32283).
                        if (hr.r.remaining().len != 0) return error.UnexpectedMessage;
                        if (try handshake.parseKeyUpdate(msg.raw) == .update_requested) {
                            respond = true;
                        }
                        // Ratchet the receive key only after consuming the
                        // KeyUpdate (RFC 8446 §4.6.3).
                        const next_rx = try self.suite.ratchetServerKey();
                        self.rx.deinit();
                        self.rx = next_rx;
                    },
                    .new_session_ticket => {
                        // parsed and ignored until PSK resumption
                        _ = try NewSessionTicket.parse(msg.raw);
                    },
                    else => return error.UnexpectedMessage,
                }
            }
            // One response covers any number of update_requested KeyUpdates.
            return if (respond)
                return .{ .write = try self.sendKeyUpdate(out, .update_not_requested) }
            else
                .none;
        },
        .alert => {
            const a = try alert.parse(dec.content);
            return if (a.isCloseNotify()) .closed else error.PeerAlert;
        },
        else => return error.UnexpectedRecord,
    }
}

/// Send a KeyUpdate. Encrypts the message under the current (old) send key,
/// then ratchets our send key so subsequent records use the next generation
/// (RFC 8446 §4.6.3, §7.2). `request` asks the peer to update in return.
// ziglint-ignore: Z015 -- SendError is a public error-set alias.
pub fn sendKeyUpdate(
    self: *ClientHandshake,
    out: []u8,
    request: KeyUpdateRequest,
) SendError![]const u8 {
    return handshake.sendKeyUpdate(.client, self, out, request);
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
    var hs: ClientHandshake = .init(.{ .secret_key = .zero, .public_key = .zero });
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
    const dhe = [_]u8{
        0x8b, 0xd4, 0x05, 0x4f, 0xb5, 0x5b, 0x9d, 0x63,
        0xfd, 0xfb, 0xac, 0xf9, 0xf0, 0x4b, 0x9f, 0x0d,
        0x35, 0xe6, 0xd6, 0x3f, 0x53, 0x75, 0x63, 0xef,
        0xd4, 0x62, 0x72, 0x90, 0x0f, 0x89, 0x49, 0x2d,
    };

    var hs: ClientHandshake = .init(.{ .secret_key = .zero, .public_key = .zero });
    hs.suite.update(&rfc8448_client_hello);
    hs.suite.update(&rfc8448_server_hello);
    // Collapse to the SHA-256 arm (as processServerHello would for this suite).
    const b = hs.suite.buffering;
    hs.suite = .{ .sha256 = .{ .transcript = b.sha256, .aead = .aes_128_gcm_sha256 } };

    const keys = try hs.suite.deriveHandshakeKeys(&dhe);

    // server_write_key
    try testing.expectEqualSlices(u8, &.{
        0x3f, 0xce, 0x51, 0x60, 0x09, 0xc2, 0x17, 0x27,
        0xd0, 0xf2, 0xe4, 0xe8, 0x6e, 0xe4, 0x03, 0xbc,
    }, &keys.rx.aead.aes_128_gcm_sha256.data);
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
    .secret_key = .init(.{
        0x49, 0xaf, 0x42, 0xba, 0x7f, 0x79, 0x94, 0x85,
        0x2d, 0x71, 0x3e, 0xf2, 0x78, 0x4b, 0xcb, 0xca,
        0xa7, 0x91, 0x1d, 0xe2, 0x6a, 0xdc, 0x56, 0x42,
        0xcb, 0x63, 0x45, 0x40, 0xe7, 0xea, 0x50, 0x05,
    }),
    .public_key = .init(.{
        0x99, 0x38, 0x1d, 0xe5, 0x60, 0xe4, 0xbd, 0x43,
        0xd2, 0x3d, 0x8e, 0x43, 0x5a, 0x7d, 0xba, 0xfe,
        0xb3, 0xc0, 0x6e, 0x51, 0xc1, 0x3c, 0xae, 0x4d,
        0x54, 0x13, 0x69, 0x1e, 0x52, 0x9a, 0xaf, 0x2c,
    }),
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
    }, &hs.rx.aead.aes_128_gcm_sha256.data);
}

// RFC 8446 §4.1.3 — ServerHello legacy_session_id_echo must match ClientHello.
test "processServerHello: rejects mismatched session id echo" {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    hs.injectClientHello(&rfc8448_client_hello);

    var sh_buf: [128]u8 = undefined;
    const sh = try server_hello.encode(
        &sh_buf,
        @splat(0xab),
        &.{0x01},
        .aes_128_gcm_sha256,
        .zero,
    );
    try testing.expectError(error.InvalidSessionIdEcho, hs.processServerHello(sh));
}

// RFC 8446 §4.1.3 — ServerHello must select a cipher suite offered by ClientHello.
test "processServerHello: rejects unoffered cipher suite" {
    var hs: ClientHandshake = .init(.generate());
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, hs.keypair.public_key, null, &.{});
    // Keep TLS_AES_128_GCM_SHA256 and replace the other recognized suites with unknowns.
    ch_buf[43..47].* = .{ 0x12, 0x34, 0x56, 0x78 };
    hs.injectClientHello(ch);

    var sh_buf: [128]u8 = undefined;
    const sh = try server_hello.encode(&sh_buf, @splat(0xab), &.{}, .aes_256_gcm_sha384, .zero);
    try testing.expectError(error.UnsupportedCipherSuite, hs.processServerHello(sh));

    var out: [64]u8 = undefined;
    const rec = try hs.sendAlert(.illegal_parameter, &out);
    try expectPlaintextAlert(rec, .illegal_parameter);
}

// RFC 8448 §3 vectors, base64-encoded inside a txtar archive (decoded at test
// time): server_flight.b64 = EE||Cert||CV||Finished plaintext;
// server_flight_record.b64 = the same flight as an encrypted wire record.
const rfc8448_archive = @embedFile("test_fixtures/rfc8448.txtar");

// Decode a base64 entry from the embedded RFC 8448 archive into `out`.
// Test-only — the txtar import lives inside the function so the public ztls
// module never requires the dependency.
fn rfc8448Fixture(name: []const u8, out: []u8) []u8 {
    var archive = txtar.parse(testing.allocator, rfc8448_archive) catch unreachable;
    defer archive.deinit(testing.allocator);
    for (archive.files) |f| {
        if (!mem.eql(u8, f.name, name)) continue;
        const b64 = mem.trimEnd(u8, f.data, "\n");
        const n = base64.calcSizeForSlice(b64) catch unreachable;
        base64.decode(out[0..n], b64) catch unreachable;
        return out[0..n];
    }
    unreachable;
}

fn flightReadyClient() !ClientHandshake {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    hs.policy.insecure_no_chain_anchor = true;
    hs.injectClientHello(&rfc8448_client_hello);
    try hs.processServerHello(&rfc8448_server_hello);
    return hs;
}

fn expectEncryptedAlert(
    peer: *RecordLayer,
    record: []const u8,
    description: alert.Description,
) !void {
    var buf: [128]u8 = undefined;
    @memcpy(buf[0..record.len], record);
    const dec = try peer.decrypt(buf[0..record.len]);
    try testing.expectEqual(frame.ContentType.alert, dec.content_type);
    const a = try alert.parse(dec.content);
    try testing.expectEqual(alert.Level.fatal, a.level);
    try testing.expectEqual(description, a.description);
}

fn expectPlaintextAlert(record: []const u8, description: alert.Description) !void {
    const hdr = try frame.parseHeader(record);
    try testing.expectEqual(frame.ContentType.alert, hdr.content_type);
    try testing.expectEqual(@as(u16, 2), hdr.length());
    const a = try alert.parse(record[frame.header_len..][0..hdr.length()]);
    try testing.expectEqual(alert.Level.fatal, a.level);
    try testing.expectEqual(description, a.description);
}

fn incrementU24(field: *[3]u8, n: u24) void {
    const value: u24 = (@as(u24, field[0]) << 16) |
        (@as(u24, field[1]) << 8) |
        field[2];
    const updated = value + n;
    field[0] = @intCast(updated >> 16);
    field[1] = @intCast((updated >> 8) & 0xff);
    field[2] = @intCast(updated & 0xff);
}

fn appendLeafCertificateExtensions(msg: []u8, msg_len: usize, extensions: []const u8) []const u8 {
    const ext_len_pos = msg_len - 2;
    @memcpy(msg[msg_len..][0..extensions.len], extensions);
    const ext_len: u16 = @intCast(extensions.len);
    msg[ext_len_pos..][0..2].* = .{ @intCast(ext_len >> 8), @intCast(ext_len & 0xff) };
    incrementU24(msg[1..4], @intCast(extensions.len));
    incrementU24(msg[5..8], @intCast(extensions.len));
    return msg[0 .. msg_len + extensions.len];
}

fn encryptAllZeroInnerForTest(tx: *RecordLayer, inner_len: usize, out: []u8) ![]u8 {
    const total = frame.header_len + inner_len + aead.tag_len;
    const header: frame.Header = .init(.application_data, @intCast(inner_len + aead.tag_len));
    out[0..frame.header_len].* = mem.toBytes(header);
    const inner = out[frame.header_len..][0..inner_len];
    @memset(inner, 0);
    var tag: aead.Tag = undefined;
    const npub = aead.construct(&tx.iv, tx.seq);
    try tx.aead.encrypt(&tx.ctx, inner, &tag, inner, out[0..frame.header_len], &npub);
    out[frame.header_len + inner_len ..][0..aead.tag_len].* = tag.data;
    tx.seq += 1;
    return out[0..total];
}

// RFC 8446 §4.3-§4.4 — the full encrypted flight driven by the live transcript.
// One call exercises EncryptedExtensions parsing, RSA-PSS CertificateVerify
// over the through-Certificate transcript, and the server Finished MAC over the
// through-CertificateVerify transcript — all against genuine RFC 8448 §3 bytes.
// RFC 8448 uses self-contained test certificates; tests that drive the full
// Certificate message opt into signature-only chain handling explicitly.
test "processFlight: stores selected ALPN" {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    hs.offerAlpn(&.{ "h2", "http/1.1" });
    hs.injectClientHello(&rfc8448_client_hello);
    try hs.processServerHello(&rfc8448_server_hello);

    const ee = [_]u8{
        0x08, 0x00, 0x00, 0x0b,
        0x00, 0x09, 0x00, 0x10,
        0x00, 0x05, 0x00, 0x03,
        0x02, 'h',  '2',
    };
    try hs.processFlight(&ee, hs.policy);
    try testing.expectEqualStrings("h2", hs.selectedAlpnProtocol().?);
    try testing.expectEqual(.wait_cert, hs.state);
}

test "processFlight: rejects unoffered ALPN" {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    hs.offerAlpn(&.{"http/1.1"});
    hs.injectClientHello(&rfc8448_client_hello);
    try hs.processServerHello(&rfc8448_server_hello);

    const ee = [_]u8{
        0x08, 0x00, 0x00, 0x0b,
        0x00, 0x09, 0x00, 0x10,
        0x00, 0x05, 0x00, 0x03,
        0x02, 'h',  '2',
    };
    try testing.expectError(error.UnofferedAlpnProtocol, hs.processFlight(&ee, hs.policy));
}

test "processFlight: rejects unanchored Certificate by default" {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    hs.injectClientHello(&rfc8448_client_hello);
    try hs.processServerHello(&rfc8448_server_hello);

    var flight_buf: [1024]u8 = undefined;
    try testing.expectError(
        error.MissingTrustAnchor,
        hs.processFlight(rfc8448Fixture("server_flight.b64", &flight_buf), hs.policy),
    );
    try testing.expectEqual(.wait_cert, hs.state);

    var peer = try hs.tx.clone();
    defer peer.deinit();
    var out: [64]u8 = undefined;
    const rec = try hs.sendAlert(alertForError(error.MissingTrustAnchor), &out);
    try expectEncryptedAlert(&peer, rec, .unknown_ca);
}

// RFC 8446 §4.4.2.2, §6.2 — certificate-processing failures are mapped to
// certificate-related alerts for callers to send through the Sans-I/O API.
test "alertForError: certificate failures map to certificate alerts" {
    const cases = [_]struct {
        err: anyerror,
        description: alert.Description,
    }{
        .{ .err = error.MissingTrustAnchor, .description = .unknown_ca },
        .{ .err = error.CertificateIssuerNotFound, .description = .unknown_ca },
        .{ .err = error.CertificateExpired, .description = .certificate_expired },
        .{ .err = error.CertificateNotYetValid, .description = .certificate_expired },
        .{
            .err = error.CertificateKeyUsageRejected,
            .description = .unsupported_certificate,
        },
        .{
            .err = error.CertificateExtendedKeyUsageRejected,
            .description = .unsupported_certificate,
        },
        .{
            .err = error.CertificateSignatureAlgorithmRejected,
            .description = .unsupported_certificate,
        },
        .{ .err = error.CertificateHostMismatch, .description = .certificate_unknown },
        .{ .err = error.CertificateNameConstraintViolation, .description = .certificate_unknown },
        .{ .err = error.CertificateFieldHasInvalidLength, .description = .bad_certificate },
        .{ .err = error.InvalidSignature, .description = .bad_certificate },
        .{ .err = error.UnsupportedSignatureScheme, .description = .illegal_parameter },
    };
    for (cases) |case| try testing.expectEqual(case.description, alertForError(case.err));
}

// RFC 8446 §6.2 — decode failures use decode_error, malformed handshake
// sequencing uses unexpected_message, and semantic protocol violations use the
// more specific alert when TLS 1.3 defines one.
test "alertForError: parser and semantic failures map to protocol alerts" {
    const cases = [_]struct {
        err: anyerror,
        description: alert.Description,
    }{
        .{ .err = error.UnexpectedEof, .description = .decode_error },
        .{ .err = error.InvalidAlertLength, .description = .decode_error },
        .{ .err = error.InvalidHandshakeLength, .description = .decode_error },
        .{ .err = error.InvalidVectorLength, .description = .decode_error },
        .{ .err = error.InvalidEnumTag, .description = .decode_error },
        .{ .err = error.InvalidHandshakeType, .description = .unexpected_message },
        .{ .err = error.UnexpectedMessage, .description = .unexpected_message },
        .{ .err = error.MissingExtension, .description = .missing_extension },
        .{ .err = error.UnsupportedExtension, .description = .unsupported_extension },
        .{ .err = error.UnsupportedTlsVersion, .description = .protocol_version },
        .{ .err = error.UnsupportedCipherSuite, .description = .handshake_failure },
        .{ .err = error.NoApplicationProtocol, .description = .no_application_protocol },
        .{ .err = error.DuplicateExtension, .description = .illegal_parameter },
        .{ .err = error.DuplicateKeyShare, .description = .illegal_parameter },
        .{ .err = error.InvalidCompressionMethod, .description = .illegal_parameter },
        .{ .err = error.InvalidLegacyVersion, .description = .illegal_parameter },
        .{ .err = error.InvalidSessionIdEcho, .description = .illegal_parameter },
        .{ .err = error.UnexpectedExtension, .description = .illegal_parameter },
    };
    for (cases) |case| try testing.expectEqual(case.description, alertForError(case.err));
}

// RFC 8446 §4.4.2 — server Certificate request_context is always empty.
test "processFlight: rejects non-empty server Certificate request context" {
    var hs = try flightReadyClient();
    defer hs.deinit();

    var flight_buf: [1024]u8 = undefined;
    var hr: HandshakeReader = .init(rfc8448Fixture("server_flight.b64", &flight_buf));
    const ee = (try hr.next()).?;
    try hs.processFlight(ee.raw, hs.policy);
    const cert = (try hr.next()).?;

    var bad_cert: [2048]u8 = undefined;
    @memcpy(bad_cert[0..cert.raw.len], cert.raw);
    @memmove(bad_cert[6 .. cert.raw.len + 1], bad_cert[5..cert.raw.len]);
    bad_cert[4] = 1;
    bad_cert[5] = 0xaa;
    incrementU24(bad_cert[1..4], 1);

    try testing.expectError(
        error.UnexpectedCertificateRequestContext,
        hs.processFlight(bad_cert[0 .. cert.raw.len + 1], hs.policy),
    );
    try testing.expectEqual(.wait_cert, hs.state);

    var peer = try hs.tx.clone();
    defer peer.deinit();
    var out: [64]u8 = undefined;
    const rec = try hs.sendAlert(.illegal_parameter, &out);
    try expectEncryptedAlert(&peer, rec, .illegal_parameter);
}

// RFC 8446 §4.4.2.4 — an empty server Certificate maps to decode_error.
test "processFlight: rejects empty server Certificate list" {
    var hs = try flightReadyClient();
    defer hs.deinit();

    var flight_buf: [1024]u8 = undefined;
    var hr: HandshakeReader = .init(rfc8448Fixture("server_flight.b64", &flight_buf));
    const ee = (try hr.next()).?;
    try hs.processFlight(ee.raw, hs.policy);

    const empty_cert = [_]u8{
        @intFromEnum(HandshakeType.certificate), 0x00, 0x00, 0x04,
        0x00,                                    0x00, 0x00, 0x00,
    };
    try testing.expectError(error.EmptyCertificateList, hs.processFlight(&empty_cert, hs.policy));
    try testing.expectEqual(.wait_cert, hs.state);

    var peer = try hs.tx.clone();
    defer peer.deinit();
    var out: [64]u8 = undefined;
    const rec = try hs.sendAlert(.decode_error, &out);
    try expectEncryptedAlert(&peer, rec, .decode_error);
}

// RFC 8446 §4.4.2.1 — unrequested CertificateEntry response extensions are
// unsupported_extension failures for the current client policy.
test "processFlight: rejects unrequested server CertificateEntry status_request" {
    var hs = try flightReadyClient();
    defer hs.deinit();

    var flight_buf: [1024]u8 = undefined;
    var hr: HandshakeReader = .init(rfc8448Fixture("server_flight.b64", &flight_buf));
    const ee = (try hr.next()).?;
    try hs.processFlight(ee.raw, hs.policy);
    const cert = (try hr.next()).?;

    var bad_cert: [2048]u8 = undefined;
    @memcpy(bad_cert[0..cert.raw.len], cert.raw);
    const ext = [_]u8{ 0x00, 0x05, 0x00, 0x00 };
    const with_ext = appendLeafCertificateExtensions(&bad_cert, cert.raw.len, &ext);

    try testing.expectError(error.UnsupportedExtension, hs.processFlight(with_ext, hs.policy));
    try testing.expectEqual(.wait_cert, hs.state);

    var peer = try hs.tx.clone();
    defer peer.deinit();
    var out: [64]u8 = undefined;
    const rec = try hs.sendAlert(.unsupported_extension, &out);
    try expectEncryptedAlert(&peer, rec, .unsupported_extension);
}

test "processFlight: RFC 8448 §3 full server flight to connected" {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    hs.policy.insecure_no_chain_anchor = true;
    hs.injectClientHello(&rfc8448_client_hello);
    try hs.processServerHello(&rfc8448_server_hello);

    var flight_buf: [1024]u8 = undefined;
    try hs.processFlight(rfc8448Fixture("server_flight.b64", &flight_buf), hs.policy);
    try testing.expectEqual(.send_finished, hs.state);
    try testing.expectEqual(.finished_verified, hs.server_flight_progress);
}

// openssl s_server sends each flight message in its own record, so processFlight
// is called once per message with state persisting across calls. The leaf
// public key extracted at Certificate must survive to CertificateVerify.
test "processFlight: handshake message spanning records needs buffer" {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    hs.injectClientHello(&rfc8448_client_hello);
    try hs.processServerHello(&rfc8448_server_hello);

    var flight_buf: [1024]u8 = undefined;
    const flight = rfc8448Fixture("server_flight.b64", &flight_buf);
    try testing.expectError(error.UnexpectedEof, hs.processFlight(flight[0..2], hs.policy));
}

// RFC 8446 §5.1 — handshake messages MAY be split across records. Caller-owned
// reassembly storage keeps ztls allocation-free while supporting large flights.
test "processFlight: reassembles handshake message split across records" {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    hs.policy.insecure_no_chain_anchor = true;
    var reassembly: [1024]u8 = undefined;
    hs.useHandshakeBuffer(&reassembly);
    hs.injectClientHello(&rfc8448_client_hello);
    try hs.processServerHello(&rfc8448_server_hello);

    var flight_buf: [1024]u8 = undefined;
    const flight = rfc8448Fixture("server_flight.b64", &flight_buf);
    try hs.processFlight(flight[0..2], hs.policy);
    try testing.expectEqual(@as(usize, 2), hs.handshake_buf.len);
    try hs.processFlight(flight[2..], hs.policy);
    try testing.expectEqual(@as(usize, 0), hs.handshake_buf.len);
    try testing.expectEqual(.send_finished, hs.state);
}

test "processFlight: RFC 8448 §3 flight split one message per record" {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    hs.policy.insecure_no_chain_anchor = true;
    hs.injectClientHello(&rfc8448_client_hello);
    try hs.processServerHello(&rfc8448_server_hello);

    var flight_buf: [1024]u8 = undefined;
    var hr: HandshakeReader = .init(rfc8448Fixture("server_flight.b64", &flight_buf));
    while (try hr.next()) |msg| {
        try hs.processFlight(msg.raw, hs.policy);
    }
    try testing.expectEqual(.send_finished, hs.state);
}

// RFC 8446 §4.1.3 — a malformed ServerHello is a decode_error failure.
test "handleRecord: malformed ServerHello is rejected" {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    defer hs.deinit();
    hs.injectClientHello(&rfc8448_client_hello);

    var sh_record = [_]u8{ 0x16, 0x03, 0x03, 0x00, 0x04 } ++ rfc8448_server_hello[0..4].*;
    var out: [64]u8 = undefined;
    try testing.expectError(error.InvalidHandshakeLength, hs.handleRecord(&sh_record, &out));
    try testing.expectEqual(.wait_sh, hs.state);

    const rec = try hs.sendAlert(.decode_error, &out);
    try expectPlaintextAlert(rec, .decode_error);
}

// RFC 8446 §4 — EncryptedExtensions is the first encrypted server flight
// message; Finished in wait_ee is an unexpected_message failure.
test "processFlight: rejects Finished before EncryptedExtensions" {
    var hs = try flightReadyClient();
    defer hs.deinit();

    const bad_finished: [4 + 32]u8 = .{
        @intFromEnum(HandshakeType.finished), 0x00, 0x00, 0x20,
    } ++ @as([32]u8, @splat(0xaa));
    try testing.expectError(error.UnexpectedMessage, hs.processFlight(&bad_finished, hs.policy));
    try testing.expectEqual(.wait_ee, hs.state);

    var peer = try hs.tx.clone();
    defer peer.deinit();
    var out: [64]u8 = undefined;
    const rec = try hs.sendAlert(.unexpected_message, &out);
    try expectEncryptedAlert(&peer, rec, .unexpected_message);
}

// RFC 8446 §4.4.3 — CertificateVerify must appear after Certificate.
test "processFlight: rejects CertificateVerify before Certificate" {
    var hs = try flightReadyClient();
    defer hs.deinit();

    var flight_buf: [1024]u8 = undefined;
    var hr: HandshakeReader = .init(rfc8448Fixture("server_flight.b64", &flight_buf));
    const ee = (try hr.next()).?;
    try hs.processFlight(ee.raw, hs.policy);
    _ = (try hr.next()).?; // Certificate
    const cv = (try hr.next()).?;

    try testing.expectError(error.UnexpectedMessage, hs.processFlight(cv.raw, hs.policy));
    try testing.expectEqual(.wait_cert, hs.state);

    var peer = try hs.tx.clone();
    defer peer.deinit();
    var out: [64]u8 = undefined;
    const rec = try hs.sendAlert(.unexpected_message, &out);
    try expectEncryptedAlert(&peer, rec, .unexpected_message);
}

// RFC 8446 §4.4.3 — Finished must not appear before CertificateVerify.
test "processFlight: rejects Finished before CertificateVerify" {
    var hs = try flightReadyClient();
    defer hs.deinit();

    var flight_buf: [1024]u8 = undefined;
    var hr: HandshakeReader = .init(rfc8448Fixture("server_flight.b64", &flight_buf));
    const ee = (try hr.next()).?;
    try hs.processFlight(ee.raw, hs.policy);
    const cert = (try hr.next()).?;
    try hs.processFlight(cert.raw, hs.policy);
    _ = (try hr.next()).?; // CertificateVerify
    const fin = (try hr.next()).?;

    try testing.expectError(error.UnexpectedMessage, hs.processFlight(fin.raw, hs.policy));
    try testing.expectEqual(.wait_cv, hs.state);

    var peer = try hs.tx.clone();
    defer peer.deinit();
    var out: [64]u8 = undefined;
    const rec = try hs.sendAlert(.unexpected_message, &out);
    try expectEncryptedAlert(&peer, rec, .unexpected_message);
}

// RFC 8446 §4.4.3 — CertificateVerify must use a SignatureScheme offered by
// the client in signature_algorithms.
test "processFlight: rejects unoffered CertificateVerify scheme" {
    var hs = try flightReadyClient();
    defer hs.deinit();
    hs.offered_signature_schemes.clear();
    try hs.offered_signature_schemes.append(.ecdsa_secp256r1_sha256);

    var flight_buf: [1024]u8 = undefined;
    var hr: HandshakeReader = .init(rfc8448Fixture("server_flight.b64", &flight_buf));
    const ee = (try hr.next()).?;
    try hs.processFlight(ee.raw, hs.policy);
    const cert = (try hr.next()).?;
    try hs.processFlight(cert.raw, hs.policy);
    const cv = (try hr.next()).?;

    try testing.expectError(error.UnsupportedSignatureScheme, hs.processFlight(cv.raw, hs.policy));
    try testing.expectEqual(.wait_cv, hs.state);

    var peer = try hs.tx.clone();
    defer peer.deinit();
    var out: [64]u8 = undefined;
    const description = ClientHandshake.alertForError(error.UnsupportedSignatureScheme);
    const rec = try hs.sendAlert(description, &out);
    try expectEncryptedAlert(&peer, rec, .illegal_parameter);
}

// RFC 8446 §4.4.3 — a bad CertificateVerify signature is a decrypt_error alert.
test "processFlight: rejects wrong CertificateVerify signature" {
    var hs = try flightReadyClient();
    defer hs.deinit();

    var flight_buf: [1024]u8 = undefined;
    var hr: HandshakeReader = .init(rfc8448Fixture("server_flight.b64", &flight_buf));
    const ee = (try hr.next()).?;
    try hs.processFlight(ee.raw, hs.policy);
    const cert = (try hr.next()).?;
    try hs.processFlight(cert.raw, hs.policy);
    const cv = (try hr.next()).?;

    var bad_cv: [512]u8 = undefined;
    @memcpy(bad_cv[0..cv.raw.len], cv.raw);
    bad_cv[cv.raw.len - 1] ^= 0xff;
    try testing.expectError(
        error.SignatureVerificationFailed,
        hs.processFlight(bad_cv[0..cv.raw.len], hs.policy),
    );
    try testing.expectEqual(.wait_cv, hs.state);

    var peer = try hs.tx.clone();
    defer peer.deinit();
    var out: [64]u8 = undefined;
    const rec = try hs.sendAlert(.decrypt_error, &out);
    try expectEncryptedAlert(&peer, rec, .decrypt_error);
}

// RFC 8446 §4.4.4 — a bad server Finished MAC is a decrypt_error alert.
test "processFlight: rejects wrong server Finished verify_data" {
    var hs = try flightReadyClient();
    defer hs.deinit();

    var flight_buf: [1024]u8 = undefined;
    var hr: HandshakeReader = .init(rfc8448Fixture("server_flight.b64", &flight_buf));
    const ee = (try hr.next()).?;
    try hs.processFlight(ee.raw, hs.policy);
    const cert = (try hr.next()).?;
    try hs.processFlight(cert.raw, hs.policy);
    const cv = (try hr.next()).?;
    try hs.processFlight(cv.raw, hs.policy);
    const fin = (try hr.next()).?;

    var bad_fin: [64]u8 = undefined;
    @memcpy(bad_fin[0..fin.raw.len], fin.raw);
    bad_fin[4] ^= 0xff;
    try testing.expectError(
        error.InvalidVerifyData,
        hs.processFlight(bad_fin[0..fin.raw.len], hs.policy),
    );
    try testing.expectEqual(.wait_finished, hs.state);

    var peer = try hs.tx.clone();
    defer peer.deinit();
    var out: [64]u8 = undefined;
    const rec = try hs.sendAlert(.decrypt_error, &out);
    try expectEncryptedAlert(&peer, rec, .decrypt_error);
}

// RFC 8446 §6 — a fatal plaintext alert during wait_sh aborts the handshake.
test "handleRecord: plaintext fatal alert in wait_sh" {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    defer hs.deinit();
    hs.injectClientHello(&rfc8448_client_hello);

    var alert_record = [_]u8{ 0x15, 0x03, 0x03, 0x00, 0x02, 0x02, 0x28 };
    var out: [64]u8 = undefined;
    try testing.expectError(error.PeerAlert, hs.handleRecord(&alert_record, &out));
    try testing.expectEqual(.wait_sh, hs.state);
}

// RFC 8446 §D.4 — CCS before the first ClientHello is outside the compatibility window.
test "handleRecord: rejects ChangeCipherSpec before ClientHello" {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    defer hs.deinit();

    var ccs = [_]u8{ 0x14, 0x03, 0x03, 0x00, 0x01, 0x01 };
    var out: [64]u8 = undefined;
    try testing.expectError(error.UnexpectedRecord, hs.handleRecord(&ccs, &out));
}

// RFC 8446 §D.4 — a valid compatibility CCS is ignored after ClientHello and
// before the peer Finished.
test "handleRecord: drops valid ChangeCipherSpec after ClientHello" {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    defer hs.deinit();
    hs.injectClientHello(&rfc8448_client_hello);

    var ccs = [_]u8{ 0x14, 0x03, 0x03, 0x00, 0x01, 0x01 };
    var out: [64]u8 = undefined;
    try testing.expectEqual(Event.none, try hs.handleRecord(&ccs, &out));
    try testing.expectEqual(.wait_sh, hs.state);
}

// RFC 8446 §D.4 — a compatibility CCS must carry exactly byte 0x01.
test "handleRecord: rejects malformed ChangeCipherSpec payload" {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    defer hs.deinit();
    hs.injectClientHello(&rfc8448_client_hello);

    var ccs = [_]u8{ 0x14, 0x03, 0x03, 0x00, 0x01, 0x02 };
    var out: [64]u8 = undefined;
    try testing.expectError(error.UnexpectedRecord, hs.handleRecord(&ccs, &out));
}

// RFC 8446 §6.2 — encrypted fatal alerts during the server flight abort.
test "handleRecord: encrypted fatal alert during server flight" {
    var hs = try flightReadyClient();
    defer hs.deinit();

    var server_tx = try hs.rx.clone();
    defer server_tx.deinit();
    const fatal = [_]u8{ 0x02, 0x28 }; // fatal, handshake_failure
    var rec_buf: [64]u8 = undefined;
    const rec = try server_tx.encrypt(.alert, &fatal, &rec_buf);

    var wire: [64]u8 = undefined;
    @memcpy(wire[0..rec.len], rec);
    var out: [64]u8 = undefined;
    try testing.expectError(error.PeerAlert, hs.handleRecord(wire[0..rec.len], &out));
    try testing.expectEqual(.wait_ee, hs.state);
}

// RFC 8446 §4.6.3 — KeyUpdate is post-handshake only.
test "handleRecord: rejects server KeyUpdate before Finished" {
    var hs = try flightReadyClient();
    defer hs.deinit();

    var server_tx = try hs.rx.clone();
    defer server_tx.deinit();
    const ku = [_]u8{
        @intFromEnum(HandshakeType.key_update),              0x00, 0x00, 0x01,
        @intFromEnum(KeyUpdateRequest.update_not_requested),
    };
    var rec_buf: [64]u8 = undefined;
    const rec = try server_tx.encrypt(.handshake, &ku, &rec_buf);

    var wire: [64]u8 = undefined;
    @memcpy(wire[0..rec.len], rec);
    var out: [64]u8 = undefined;
    try testing.expectError(error.UnexpectedMessage, hs.handleRecord(wire[0..rec.len], &out));
    try testing.expectEqual(.wait_ee, hs.state);
}

// RFC 8446 §5 — a record length that exceeds the supplied bytes is incomplete.
test "handleRecord: truncated encrypted flight is rejected" {
    var hs = try flightReadyClient();
    defer hs.deinit();

    var flight_buf: [1024]u8 = undefined;
    const flight = rfc8448Fixture("server_flight_record.b64", &flight_buf);
    var out: [128]u8 = undefined;
    try testing.expectError(
        error.IncompleteRecord,
        hs.handleRecord(flight[0 .. flight.len - 1], &out),
    );
    try testing.expectEqual(.wait_ee, hs.state);
}

// RFC 8446 §5.2 — AEAD authentication failure maps to bad_record_mac.
test "handleRecord: corrupted encrypted flight is rejected" {
    var hs = try flightReadyClient();
    defer hs.deinit();

    var flight_buf: [1024]u8 = undefined;
    const flight = rfc8448Fixture("server_flight_record.b64", &flight_buf);
    flight[flight.len - 1] ^= 0xff;

    var out: [128]u8 = undefined;
    try testing.expectError(error.AuthenticationFailed, hs.handleRecord(flight, &out));
    try testing.expectEqual(.wait_ee, hs.state);

    var peer = try hs.tx.clone();
    defer peer.deinit();
    const rec = try hs.sendAlert(.bad_record_mac, &out);
    try expectEncryptedAlert(&peer, rec, .bad_record_mac);
}

// RFC 8446 §5.2 — unexpected inner content types are rejected after the handshake.
test "handleRecord: post-handshake unexpected inner content type is rejected" {
    var hs = try connectedTestClient();
    defer hs.deinit();

    var server_tx = try hs.rx.clone();
    defer server_tx.deinit();
    var rec_buf: [64]u8 = undefined;
    const rec = try server_tx.encrypt(.change_cipher_spec, "bad", &rec_buf);

    var wire: [64]u8 = undefined;
    @memcpy(wire[0..rec.len], rec);
    var out: [64]u8 = undefined;
    try testing.expectError(error.UnexpectedRecord, hs.handleRecord(wire[0..rec.len], &out));
    try testing.expectEqual(.connected, hs.state);

    var peer = try hs.tx.clone();
    defer peer.deinit();
    const alert_rec = try hs.sendAlert(.unexpected_message, &out);
    try expectEncryptedAlert(&peer, alert_rec, .unexpected_message);
}

// RFC 8446 §4.3 — application data is illegal before the handshake completes.
test "handleRecord: encrypted application data during server flight is rejected" {
    var hs = try flightReadyClient();
    defer hs.deinit();

    var server_tx = try hs.rx.clone();
    defer server_tx.deinit();
    var rec_buf: [64]u8 = undefined;
    const rec = try server_tx.encrypt(.application_data, "early", &rec_buf);

    var wire: [64]u8 = undefined;
    @memcpy(wire[0..rec.len], rec);
    var out: [64]u8 = undefined;
    try testing.expectError(error.UnexpectedRecord, hs.handleRecord(wire[0..rec.len], &out));
    try testing.expectEqual(.wait_ee, hs.state);

    var peer = try hs.tx.clone();
    defer peer.deinit();
    const alert_rec = try hs.sendAlert(.unexpected_message, &out);
    try expectEncryptedAlert(&peer, alert_rec, .unexpected_message);
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
    hs.policy.insecure_no_chain_anchor = true;
    hs.injectClientHello(&rfc8448_client_hello);
    try hs.processServerHello(&rfc8448_server_hello);
    var flight_buf: [1024]u8 = undefined;
    try hs.processFlight(rfc8448Fixture("server_flight.b64", &flight_buf), hs.policy);

    // Mirror of the encryptor: client handshake-traffic key at seq 0.
    var peer = try hs.tx.clone();
    defer peer.deinit();

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
    }, &hs.rx.aead.aes_128_gcm_sha256.data);
}

// RFC 8446 §7.2 — KeyUpdate key ratchet. After the handshake, ratchet the
// client (sending) application key one generation and check the re-derived
// write key against the independently-computed next key (see the
// nextTrafficSecret vector in hkdf.zig).
test "ratchetClientKey: RFC 8446 §7.2 next application write key" {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    hs.policy.insecure_no_chain_anchor = true;
    hs.injectClientHello(&rfc8448_client_hello);
    try hs.processServerHello(&rfc8448_server_hello);
    var flight_buf: [1024]u8 = undefined;
    try hs.processFlight(rfc8448Fixture("server_flight.b64", &flight_buf), hs.policy);
    var out: [128]u8 = undefined;
    _ = try hs.clientFinished(&out);

    var rl = try hs.suite.ratchetClientKey();
    defer rl.deinit();
    try testing.expectEqualSlices(u8, &.{
        0x38, 0x79, 0xd8, 0x2f, 0x5f, 0x14, 0x05, 0x6e,
        0x62, 0x3f, 0x2c, 0xe5, 0xbf, 0xc6, 0x6f, 0xce,
    }, &rl.aead.aes_128_gcm_sha256.data);
}

// Drive the RFC 8448 §3 handshake to connected; rx/tx carry application keys.
fn connectedTestClient() !ClientHandshake {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    hs.policy.insecure_no_chain_anchor = true;
    hs.injectClientHello(&rfc8448_client_hello);
    try hs.processServerHello(&rfc8448_server_hello);
    var flight_buf: [1024]u8 = undefined;
    try hs.processFlight(rfc8448Fixture("server_flight.b64", &flight_buf), hs.policy);
    var out: [128]u8 = undefined;
    _ = try hs.clientFinished(&out);
    return hs;
}

test "handleRecord: application data returns plaintext and resets the flood counter" {
    var hs = try connectedTestClient();
    hs.post_handshake_count = 5; // pretend we saw some control messages

    // The server's sending layer mirrors our rx (server app key, seq 0).
    var server_tx = try hs.rx.clone();
    defer server_tx.deinit();
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
    var hs = try connectedTestClient();

    // Server's sending layer (mirrors our rx at seq 0) and our pre-ratchet
    // send-key mirror to decrypt the response. Capture the server's secret_0
    // before receive() ratchets our rx, so we can advance it independently.
    const server_secret_0 = hs.suite.sha256.server_app_secret;
    var server_tx = try hs.rx.clone();
    defer server_tx.deinit();
    var client_send_mirror = try hs.tx.clone();
    defer client_send_mirror.deinit();

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
    var server_tx_1 = try H.makeRecordLayer(.aes_128_gcm_sha256, server_secret_1);
    defer server_tx_1.deinit();
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
    var hs = try connectedTestClient();
    var server_tx = try hs.rx.clone();
    defer server_tx.deinit();

    const ku_t = @intFromEnum(HandshakeType.key_update);
    const ku_nr = @intFromEnum(KeyUpdateRequest.update_not_requested);
    const two_kus = [_]u8{
        ku_t, 0x00, 0x00, 0x01, ku_nr,
        ku_t, 0x00, 0x00, 0x01, ku_nr,
    };
    var buf: [64]u8 = undefined;
    const wire_rec = try server_tx.encrypt(.handshake, &two_kus, &buf);

    var rx_buf: [64]u8 = undefined;
    @memcpy(rx_buf[0..wire_rec.len], wire_rec);
    var out: [64]u8 = undefined;
    try testing.expectError(
        error.UnexpectedMessage,
        hs.handleRecord(rx_buf[0..wire_rec.len], &out),
    );
}

// RFC 8446 §4.6.3 — KeyUpdateRequest only defines values 0 and 1.
test "handleRecord: invalid server KeyUpdate request is rejected" {
    var hs = try connectedTestClient();
    var server_tx = try hs.rx.clone();
    defer server_tx.deinit();

    const invalid_ku = [_]u8{ @intFromEnum(HandshakeType.key_update), 0x00, 0x00, 0x01, 0x02 };
    var buf: [64]u8 = undefined;
    const wire_rec = try server_tx.encrypt(.handshake, &invalid_ku, &buf);

    var rx_buf: [64]u8 = undefined;
    @memcpy(rx_buf[0..wire_rec.len], wire_rec);
    var out: [64]u8 = undefined;
    try testing.expectError(error.IllegalParameter, hs.handleRecord(rx_buf[0..wire_rec.len], &out));
}

// RFC 8446 §6.1 — close_notify is the only alert that cleanly closes.
// RFC 8446 §6 — alerts before handshake protection are plaintext records.
test "sendAlert: plaintext fatal alert before ServerHello" {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    var out: [16]u8 = undefined;
    const rec = try hs.sendAlert(.decode_error, &out);
    try testing.expectEqualSlices(u8, &.{ 0x15, 0x03, 0x03, 0x00, 0x02, 0x02, 0x32 }, rec);
    try testing.expectError(error.PendingWrite, hs.sendAlert(.decode_error, &out));
}

// RFC 8446 §6.1 — close_notify is sent as a warning-level alert.
test "sendAlert: encrypted close_notify after handshake" {
    var hs = try connectedTestClient();
    var peer = try hs.tx.clone();
    defer peer.deinit();

    var out: [64]u8 = undefined;
    const rec = try hs.sendAlert(.close_notify, &out);

    var rec_buf: [64]u8 = undefined;
    @memcpy(rec_buf[0..rec.len], rec);
    const dec = try peer.decrypt(rec_buf[0..rec.len]);
    try testing.expectEqual(frame.ContentType.alert, dec.content_type);
    try testing.expectEqualSlices(u8, &.{ 0x01, 0x00 }, dec.content);
}

test "handleRecord: close_notify returns closed" {
    var hs = try connectedTestClient();
    var server_tx = try hs.rx.clone();
    defer server_tx.deinit();

    const close_notify = [_]u8{ 0x01, 0x00 }; // warning, close_notify
    var buf: [64]u8 = undefined;
    const wire_rec = try server_tx.encrypt(.alert, &close_notify, &buf);

    var rx_buf: [64]u8 = undefined;
    @memcpy(rx_buf[0..wire_rec.len], wire_rec);
    var out: [64]u8 = undefined;
    try testing.expectEqual(Event.closed, try hs.handleRecord(rx_buf[0..wire_rec.len], &out));
}

// RFC 8446 §6.2 — fatal alerts abort; they are not clean close_notify.
test "handleRecord: fatal alert returns PeerAlert" {
    var hs = try connectedTestClient();
    var server_tx = try hs.rx.clone();
    defer server_tx.deinit();

    const fatal = [_]u8{ 0x02, 0x0a }; // fatal, unexpected_message
    var buf: [64]u8 = undefined;
    const wire_rec = try server_tx.encrypt(.alert, &fatal, &buf);

    var rx_buf: [64]u8 = undefined;
    @memcpy(rx_buf[0..wire_rec.len], wire_rec);
    var out: [64]u8 = undefined;
    try testing.expectError(error.PeerAlert, hs.handleRecord(rx_buf[0..wire_rec.len], &out));
}

test "handleRecord: NewSessionTicket is parsed and ignored" {
    var hs = try connectedTestClient();
    const next_rx = try hs.suite.ratchetServerKey();
    hs.rx.deinit();
    hs.rx = next_rx;
    var out: [128]u8 = undefined;
    const ticket = [_]u8{
        0x04, 0x00, 0x00, 0x0f,
        0x00, 0x00, 0x0e, 0x10,
        0x12, 0x34, 0x56, 0x78,
        0x01, 0xaa, 0x00, 0x01,
        0xbb, 0x00, 0x00,
    };
    var wire_buf: [128]u8 = undefined;
    var server_tx = try hs.rx.clone();
    defer server_tx.deinit();
    const record = try server_tx.encrypt(.handshake, &ticket, &wire_buf);
    try testing.expectEqual(Event.none, try hs.handleRecord(record, &out));
}

test "handleRecord: malformed NewSessionTicket is rejected" {
    var hs = try connectedTestClient();
    const next_rx = try hs.suite.ratchetServerKey();
    hs.rx.deinit();
    hs.rx = next_rx;
    var out: [128]u8 = undefined;
    const bad_ticket = [_]u8{ 0x04, 0x00, 0x00, 0x00 };
    var wire_buf: [128]u8 = undefined;
    var server_tx = try hs.rx.clone();
    defer server_tx.deinit();
    const record = try server_tx.encrypt(.handshake, &bad_ticket, &wire_buf);
    try testing.expectError(error.UnexpectedEof, hs.handleRecord(record, &out));
}

test "handleRecord: KeyUpdate flood is rejected" {
    var hs = try connectedTestClient();
    var out: [64]u8 = undefined;

    // Each iteration sends one KeyUpdate(update_not_requested) record. The
    // server advances its send key after each, in lockstep with our rx ratchet;
    // track the server's secret independently of hs.
    const H = hkdf.HkdfSha256;
    var server_secret = hs.suite.sha256.server_app_secret;
    var i: usize = 0;
    const result = while (i < max_post_handshake_messages + 1) : (i += 1) {
        var server_tx = try H.makeRecordLayer(.aes_128_gcm_sha256, server_secret);
        defer server_tx.deinit();
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

test "start: defaults hostname policy from server_name" {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    var out: [256]u8 = undefined;
    const random: client_hello.Random = .{ .data = @splat(0xaa) };
    _ = try hs.start(&out, random, "example.com");
    try testing.expectEqualStrings("example.com", hs.policy.host_name.?);
}

test "start: explicit hostname policy overrides server_name" {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    hs.policy.host_name = "expected.example";
    var out: [256]u8 = undefined;
    const random: client_hello.Random = .{ .data = @splat(0xaa) };
    _ = try hs.start(&out, random, "sni.example");
    try testing.expectEqualStrings("expected.example", hs.policy.host_name.?);
}

// RFC 8446 §5 — the full driver path: pump real wire records through
// handleRecord (plaintext ServerHello, a ChangeCipherSpec to discard, then the
// encrypted flight) and confirm it auto-emits the client Finished as .write and
// reaches connected. The emitted record decrypts to the RFC 8448 §3 client
// Finished.
test "handleRecord: drives RFC 8448 §3 handshake to connected" {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    hs.policy.insecure_no_chain_anchor = true;
    hs.injectClientHello(&rfc8448_client_hello);

    var out: [256]u8 = undefined;

    // ServerHello as a plaintext handshake record (header + 90-byte body).
    var sh_record = [_]u8{ 0x16, 0x03, 0x03, 0x00, 0x5a } ++ rfc8448_server_hello;
    try testing.expectEqual(Event.none, try hs.handleRecord(&sh_record, &out));
    try testing.expectEqual(.wait_ee, hs.state);

    // Mirror of the client handshake-traffic encryptor (seq 0), captured before
    // the flight completes and swaps tx to the application key.
    var peer = try hs.tx.clone();
    defer peer.deinit();

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
    var hs = try connectedTestClient();
    var out: [128]u8 = undefined;
    _ = try hs.sendApplicationData("one", &out); // sets pending_write
    try testing.expectError(error.PendingWrite, hs.sendApplicationData("two", &out));
    hs.completeWrite();
    _ = try hs.sendApplicationData("three", &out); // unblocked
}

// RFC 8446 §5.1 — handshake records cannot carry zero-length fragments.
test "handleRecord: zero-length plaintext handshake is rejected" {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    defer hs.deinit();
    hs.injectClientHello(&rfc8448_client_hello);

    var rec = [_]u8{ 0x16, 0x03, 0x03, 0x00, 0x00 };
    var out: [64]u8 = undefined;
    try testing.expectError(error.UnexpectedRecord, hs.handleRecord(&rec, &out));
}

// RFC 8446 §5.1 — an encrypted handshake record still must contain a handshake message.
test "handleRecord: zero-length encrypted handshake is rejected" {
    var hs = try flightReadyClient();
    defer hs.deinit();

    var server_tx = try hs.rx.clone();
    defer server_tx.deinit();
    var rec_buf: [64]u8 = undefined;
    const rec = try server_tx.encrypt(.handshake, "", &rec_buf);

    var wire: [64]u8 = undefined;
    @memcpy(wire[0..rec.len], rec);
    var out: [64]u8 = undefined;
    try testing.expectError(error.UnexpectedMessage, hs.handleRecord(wire[0..rec.len], &out));
}

// RFC 8446 §5.4 — all-zero TLSInnerPlaintext has no content type and maps to
// unexpected_message.
test "handleRecord: all-zero inner plaintext maps to unexpected_message" {
    var hs = try connectedTestClient();
    defer hs.deinit();

    var server_tx = try hs.rx.clone();
    defer server_tx.deinit();
    var rec_buf: [64]u8 = undefined;
    const rec = try encryptAllZeroInnerForTest(&server_tx, 3, &rec_buf);

    var wire: [64]u8 = undefined;
    @memcpy(wire[0..rec.len], rec);
    var out: [64]u8 = undefined;
    try testing.expectError(error.UnexpectedMessage, hs.handleRecord(wire[0..rec.len], &out));

    var peer = try hs.tx.clone();
    defer peer.deinit();
    const alert_record = try hs.sendAlert(.unexpected_message, &out);
    try expectEncryptedAlert(&peer, alert_record, .unexpected_message);
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

// Fuzz targets (run with `zig build test --fuzz`): the inbound parsers must
// reject arbitrary bytes with an error, never crash.

fn fuzzHandshakeReader(_: void, input: []const u8) anyerror!void {
    var hr: HandshakeReader = .init(input);
    while (hr.next() catch return) |_| {}
}

test "fuzz: HandshakeReader handles arbitrary input" {
    try testing.fuzz({}, fuzzHandshakeReader, .{});
}

// Drive an arbitrary decrypted flight through the state machine from wait_ee.
fn fuzzProcessFlight(_: void, input: []const u8) anyerror!void {
    var hs: ClientHandshake = .init(rfc8448_client_keypair);
    hs.injectClientHello(&rfc8448_client_hello);
    hs.processServerHello(&rfc8448_server_hello) catch return;
    _ = hs.processFlight(input, hs.policy) catch return;
}

test "fuzz: processFlight handles arbitrary decrypted bytes" {
    try testing.fuzz({}, fuzzProcessFlight, .{});
}
