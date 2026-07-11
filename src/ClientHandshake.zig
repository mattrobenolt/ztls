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
const fuzz_compat = @import("fuzz_compat.zig");
const mem = std.mem;
const base64 = std.base64.standard.Decoder;

const txtar = @import("txtar");

const aead = @import("aead.zig");
const alert = @import("alert.zig");
const array_buffer = @import("array_buffer.zig");
const ArrayBuffer = array_buffer.ArrayBuffer;
const SliceBuffer = array_buffer.SliceBuffer;
const certificate = @import("certificate.zig");
const certificate_request = @import("certificate_request.zig");
const client_hello = @import("client_hello.zig");
const backend = @import("crypto/backend.zig");
const encrypted_extensions = @import("encrypted_extensions.zig");
const extension_type = @import("extension_type.zig");
const OfferedExtensions = extension_type.OfferedExtensions;
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
const handshake_key_pairs = @import("handshake_key_pairs.zig");
const memx = @import("memx.zig");
const NewSessionTicket = @import("NewSessionTicket.zig");
const p256 = @import("p256.zig");
const p384 = @import("p384.zig");
const PendingWrite = @import("pending_write.zig").PendingWrite;
const RecordLayer = @import("RecordLayer.zig");
const root = @import("root.zig");
const CipherSuite = root.CipherSuite;
const AlpnError = root.AlpnError;
const AlpnProtocols = root.AlpnProtocols;
const Random = root.Random;
const server_hello = @import("server_hello.zig");
const SignatureScheme = @import("signature_scheme.zig").SignatureScheme;
const signature = @import("signature.zig");
pub const Signer = signature.Signer;
const certificate_chain = @import("certificate_chain.zig");
pub const CertificateChain = certificate_chain.CertificateChain;
const suite_state = @import("suite_state.zig");
const HashArm = suite_state.HashArm;
const transcript_util = @import("transcript.zig");
const x25519 = @import("x25519.zig");
const mlkem = @import("mlkem.zig");
const NamedGroup = @import("kex.zig").NamedGroup;

/// Caller-owned resumption ticket material derived from a NewSessionTicket.
/// The caller stores these and offers them later in a pre_shared_key
/// extension to resume a session. RFC 8446 §4.6.1, §4.2.11.
pub const SessionTicket = struct {
    /// Opaque ticket identity bytes (copied from the NewSessionTicket). The
    /// caller owns this storage; ztls copies into the fixed-capacity buffer.
    identity: ArrayBuffer(u8, 256) = .empty,
    /// PSK derived from the resumption_master_secret and the ticket nonce
    /// (HKDF-Expand-Label(resumption_master_secret, "resumption", nonce,
    /// Hash.length)). RFC 8446 §4.6.1, §7.4/§7.5. Capacity covers SHA-384.
    psk: ArrayBuffer(u8, 48) = .empty,
    /// RFC 8446 §4.6.1 — ticket_age_add added to the client's view of ticket
    /// age to obfuscate it in the pre_shared_key extension.
    ticket_age_add: u32 = 0,
    /// RFC 8446 §4.6.1 — ticket lifetime in seconds.
    ticket_lifetime: u32 = 0,
    /// RFC 8446 §4.6.1, §4.2.10 — max_early_data_size from the early_data
    /// extension, if present (for 0-RTT policy; #3).
    max_early_data_size: ?u32 = null,
    /// Cipher suite of the session that issued this ticket. The PSK binder is
    /// computed with this suite's hash (the hash under which the PSK was
    /// derived), so the offering client must use the same hash even before the
    /// new handshake negotiates a suite. RFC 8446 §4.2.11.2, §7.1.
    cipher_suite: CipherSuite = .aes_128_gcm_sha256,
};

const ClientHandshake = @This();

/// Upper bound on a leaf public key we retain across records. Covers RSA-4096
/// (~525-byte DER) with margin; ECDSA P-256/P-384 are far smaller.
const max_leaf_pub_key = 1024;
const LeafPublicKeyBuffer = ArrayBuffer(u8, max_leaf_pub_key);
const LegacySessionIdBuffer = ArrayBuffer(u8, 32);
const OfferedSuitesBuffer = ArrayBuffer(CipherSuite, 8);
// Upper bound on the number of signature schemes a peer may offer in a
// CertificateRequest / ClientHello. OpenSSL s_server offers ~16+ schemes in
// its CertificateRequest, so size generously above the backend's own
// certificate_verify_schemes set. RFC 8446 §4.2.3 has no hard cap; this is a
// defensive bound that maps overflow to HandshakeBufferTooShort rather than
// silent truncation (which would make a valid scheme look unoffered).
const OfferedSignatureSchemesBuffer = ArrayBuffer(SignatureScheme, 64);
const SelectedAlpnBuffer = ArrayBuffer(u8, 255);
const CertificateRequestContextBuffer = ArrayBuffer(u8, 255);
const HandshakeBuffer = SliceBuffer(u8);

/// Caller-owned client certificate chain and signer for client auth.
/// Mirrors ServerHandshake.ServerCredentials. RFC 8446 §4.4.2, §4.4.3.
const ClientCredentials = struct {
    chain: CertificateChain,
    signer: Signer,
};

/// Comfortable default for handshake-message reassembly across records, sized
/// to hold the server's Certificate chain plus margin. Unlike the server's
/// ClientHello bound this is a caller policy budget, not a protocol limit:
/// raise it for unusually large chains, lower it for memory-tight clients.
pub const recommended_handshake_storage = 4 * frame.max_plaintext_len;

/// Caller-owned backing for handshake-message reassembly. Declare one as
/// `.empty` and hand `&storage.buffer` to useHandshakeBuffer() (or pass it
/// via `Config.reassembly`).
pub const Storage = ArrayBuffer(u8, recommended_handshake_storage);

/// Configuration for a client handshake. Required fields have no defaults;
/// optional fields default to values that match the previous `init(keypair)` +
/// post-init policy assignment shape. `host_name` is the single source for
/// both SNI (the server_name extension) and certificate SAN/CN validation.
pub const KeyPairs = handshake_key_pairs.KeyPairs;

pub const Config = struct {
    /// Ephemeral keypairs used for offered ClientHello key_share entries.
    /// X25519 and P-256 are present by default; P-384 is opt-in to avoid
    /// unconditional extra scalar generation and ClientHello bloat.
    keypairs: KeyPairs,
    /// DNS name sent as SNI and checked against the leaf certificate SAN/CN.
    /// null disables both SNI and hostname verification.
    host_name: ?[]const u8,
    /// Current time in seconds since the Unix epoch for certificate validity.
    /// Required — callers that do not care must pass 0 explicitly.
    now_sec: i64,
    /// ClientHello random field (RFC 8446 §4.1.2). Stored and used by start().
    random: Random,
    /// Trust anchors for chain validation. null rejects the server Certificate
    /// unless `insecure_no_chain_anchor` is set.
    bundle: ?*const crypto.Certificate.Bundle = null,
    /// Test/demo opt-out from trust-anchor verification. Production clients
    /// should leave this false and provide `bundle`.
    insecure_no_chain_anchor: bool = false,
    /// ALPN protocols offered in ClientHello. Caller-owned; must live until
    /// start() encodes them.
    alpn_protocols: AlpnProtocols = &.{},
    /// Offer an X25519MLKEM768 (PQ hybrid) key_share in the ClientHello.
    /// Requires a large enough `out` buffer for start() (the ClientHello grows
    /// by ~1216 bytes). draft-ietf-tls-ecdhe-mlkem-05 §4.1.
    offer_pq_key_share: bool = false,
    /// Optional caller-owned storage for handshake-message reassembly. When
    /// non-null, the engine reassembles flight messages that span records.
    reassembly: ?[]u8 = null,
};

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
/// support (full 1-RTT handshake, no PSK, no client credentials). HRR is
/// handled inline in wait_sh without a separate state.
pub const State = enum {
    start,
    wait_sh,
    wait_ee,
    wait_cert_or_cr,
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

    fn writeTranscriptHash(self: *const Suite, out: *[48]u8) u8 {
        switch (self.*) {
            .buffering => unreachable,
            inline .sha256, .sha384 => |*s| {
                const th = s.transcript.peek();
                @memcpy(out[0..th.len], th[0..]);
                return th.len;
            },
        }
    }

    /// RFC 8446 §4.4.4, §7.1 — encode the client Finished and derive the
    /// application-traffic RecordLayers. Client authentication splits the two
    /// transcript contexts: Finished covers any client Certificate/Verify,
    /// while application secrets are still derived through the server Finished.
    /// The plaintext Finished is written to `out`; rx/tx are application-keyed.
    fn finishHandshake(
        self: *Suite,
        out: []u8,
        app_transcript_hash: []const u8,
    ) (error{BufferTooShort} || aead.Error)!HandshakeKeys.WithFinished {
        switch (self.*) {
            .buffering => unreachable,
            inline .sha256, .sha384 => |*s| {
                const H = @TypeOf(s.*).Hkdf;
                const th = s.transcript.peek();
                const fin = try finished.encode(
                    @TypeOf(s.transcript),
                    out,
                    &s.client_finished_key.data,
                    &th,
                );

                assert(app_transcript_hash.len == H.prk_len);
                var app_th: H.TranscriptHash = undefined;
                @memcpy(app_th.data[0..], app_transcript_hash);

                var master = H.masterSecret(s.handshake_secret);
                defer master.secureZero();
                s.client_app_secret = H.clientApplicationTrafficSecret(master, &app_th);
                s.server_app_secret = H.serverApplicationTrafficSecret(master, &app_th);

                s.transcript.update(fin); // client Finished now part of the transcript

                // RFC 8446 §7.5 — resumption_master_secret over the transcript
                // through the client Finished. Derived before
                // forgetHandshakeSecrets wipes the handshake_secret (which feeds
                // the master secret).
                const res_th_raw = s.transcript.peek();
                var res_th: H.TranscriptHash = undefined;
                @memcpy(res_th.data[0..], res_th_raw[0..]);
                s.resumption_master = H.resumptionMasterSecret(master, &res_th);
                s.resumption_master_valid = true;

                var tx = try H.makeRecordLayer(s.aead, s.client_app_secret);
                errdefer tx.deinit();
                const rx = try H.makeRecordLayer(s.aead, s.server_app_secret);
                s.forgetHandshakeSecrets();

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
    fn deriveHandshakeKeys(
        self: *Suite,
        dhe: []const u8,
        psk: ?[]const u8,
    ) aead.Error!HandshakeKeys {
        switch (self.*) {
            .buffering => unreachable,
            inline .sha256, .sha384 => |*s| {
                const H = @TypeOf(s.*).Hkdf;
                const early = if (psk) |p| H.pskEarlySecret(p) else H.early_secret;
                s.handshake_secret = H.handshakeSecret(early, dhe);

                const th = s.transcript.peek();
                var client_secret =
                    H.clientHandshakeTrafficSecret(s.handshake_secret, &.init(th));
                defer client_secret.secureZero();
                var server_secret =
                    H.serverHandshakeTrafficSecret(s.handshake_secret, &.init(th));
                defer server_secret.secureZero();

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
/// Ephemeral keypairs for the offered key shares.
keypairs: KeyPairs,
/// ClientHello random (RFC 8446 §4.1.2), stored from Config for start().
random: Random = .zero,
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
/// Offered ClientHello extensions tracked for validating server responses.
offered_extensions: OfferedExtensions = .initEmpty(),
offered_groups: client_hello.SupportedGroups = .{},
/// Groups that had KeyShareEntry values in ClientHello1. HRR selected_group
/// must not be one of these groups. RFC 8446 §4.2.8.
offered_key_shares: client_hello.SupportedGroups = .{},
/// ALPN protocols offered in ClientHello. Caller-owned, must live until start().
alpn_protocols: AlpnProtocols = &.{},
selected_alpn: SelectedAlpnBuffer = .empty,
/// CertificateRequest context echoed in the client Certificate when the server
/// asks for client authentication. Empty context is valid, so the bool carries
/// presence separately.
certificate_request_context: CertificateRequestContextBuffer = .empty,
/// Signature schemes the server offered in CertificateRequest, captured so
/// the client CertificateVerify scheme can be checked against them at
/// clientFinished time (RFC 8446 §4.4.3: the scheme MUST be one the server
/// offered). Slices into the record buffer would not survive across records.
offered_cr_signature_schemes: OfferedSignatureSchemesBuffer = .empty,
received_certificate_request: bool = false,
/// Caller-owned client certificate chain + signer for client authentication.
/// null sends an empty Certificate when the server sends CertificateRequest
/// (existing behavior). When set, the client emits a real Certificate chain
/// and a CertificateVerify signed with the client private key before Finished.
/// RFC 8446 §4.4.2, §4.4.3. Caller-owned: ztls stores references and does not
/// copy; the chain and signer must outlive the handshake.
client_credentials: ?ClientCredentials = null,
/// PSK offered for resumption via startWithPsk (RFC 8446 §4.2.11), retained
/// so processServerHello can use it as the early secret when the server
/// selects it. Caller-owned: the PSK bytes live in the SessionTicket the
/// caller passed to startWithPsk, which must outlive the handshake.
offered_psk: ?[]const u8 = null,
offered_psk_cipher_suite: CipherSuite = .aes_128_gcm_sha256,
/// Early traffic (0-RTT) RecordLayer for sending data before the server
/// Finished, derived from the PSK early secret + the ClientHello transcript.
/// null when 0-RTT is not offered. RFC 8446 §4.2.10, §7.1.
early_tx: ?RecordLayer = null,
/// RFC 8446 §4.2.10, §4.5 — set from the EncryptedExtensions early_data
/// extension. When true, the client MUST send EndOfEarlyData (under the
/// early traffic key) after the server Finished and before its own Finished.
/// When false (server declined), the client MUST NOT send EndOfEarlyData and
/// clears early_tx.
server_accepted_early_data: bool = false,
/// Whether to offer an X25519MLKEM768 PQ hybrid key_share. From Config.
offer_pq_key_share: bool = false,
/// KEM hybrid key handle (X25519MLKEM768 etc.) for PQ key exchange.
/// Set by start() when the backend supports the group; the client sends the
/// KEM public key as part of its key_share and decapsulates the server's
/// ciphertext. Backend-owned allocation (EVP_PKEY*); must be freed via
/// deinit. draft-ietf-tls-ecdhe-mlkem-05 §4.
kem_key: ?mlkem.KeyHandle = null,
/// The cipher suite field is needed to pick the right HKDF hash for the early
/// secret; it must match the negotiated suite for resumption.
/// Transcript hash through the server Finished. Client-auth messages are sent
/// after that point, but application traffic secrets are still derived here.
server_finished_hash: [48]u8 = @splat(0),
server_finished_hash_len: u8 = 0,
/// The named group selected by HelloRetryRequest, or null if no HRR was
/// received. Set during HRR processing; the real ServerHello must use the
/// same group. RFC 8446 §4.1.4.
retry_selected_group: ?NamedGroup = null,

/// Start a client handshake from a Config. The Config's `host_name` is the
/// single source for SNI and certificate validation; `now_sec` is required.
/// `policy` remains public for advanced overrides (e.g. leaf_usage) after init.
pub fn init(config: Config) ClientHandshake {
    return .{
        .state = .start,
        // Hash unknown until ServerHello: run both candidate transcripts.
        .suite = .init,
        .keypairs = config.keypairs,
        .random = config.random,
        .policy = .{
            .bundle = config.bundle,
            .insecure_no_chain_anchor = config.insecure_no_chain_anchor,
            .now_sec = config.now_sec,
            .host_name = config.host_name,
        },
        .alpn_protocols = config.alpn_protocols,
        .offer_pq_key_share = config.offer_pq_key_share,
        .handshake_buf = if (config.reassembly) |buf| .init(buf) else .empty,
    };
}

pub fn deinit(self: *ClientHandshake) void {
    switch (self.state) {
        .wait_ee,
        .wait_cert_or_cr,
        .wait_cert,
        .wait_cv,
        .wait_finished,
        .send_finished,
        .connected,
        => {
            self.rx.deinit();
            self.tx.deinit();
            if (self.early_tx) |*early_tx| early_tx.deinit();
        },
        .start, .wait_sh => {},
    }
    // Free the backend-owned KEM private key handle if one was allocated
    // during start(). draft-ietf-tls-ecdhe-mlkem-05 §4.1.
    if (self.kem_key) |k| mlkem.freeKey(k);
    self.suite.secureZero();
    self.keypairs.secureZero();
    self.* = undefined;
}

/// Acknowledge that the bytes from the last engine call were written to the
/// transport, clearing the pending-write block. Call after writing any
/// `.write` event or send-method result.
pub fn completeWrite(self: *ClientHandshake) void {
    self.pending_write.clear();
}

// ziglint-ignore: Z024, Z015
pub const StartError = error{ BufferTooShort, ServerNameTooLong, IdentityTooLong } ||
    AlpnError || aead.Error;

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
/// ziglint-ignore: Z012
pub fn offerAlpn(self: *ClientHandshake, protocols: AlpnProtocols) void {
    assert(self.state == .start);
    self.alpn_protocols = protocols;
}

/// The ALPN protocol selected by the server, if any. Stable after the
/// EncryptedExtensions message is processed.
pub fn selectedAlpnProtocol(self: *const ClientHandshake) ?[]const u8 {
    if (self.selected_alpn.len == 0) return null;
    return self.selected_alpn.constSlice();
}

/// Store caller-owned client certificate credentials for client authentication.
/// `certs_der` is a list of DER certificates (leaf first) and `signer` signs
/// the client CertificateVerify. Both must outlive the handshake; ztls stores
/// references and does not copy. Call before start(). RFC 8446 §4.4.2, §4.4.3.
pub fn setCredentials(self: *ClientHandshake, certs_der: []const []const u8, signer: Signer) void {
    self.setCertificateChain(.init(certs_der), signer);
}

/// Store a caller-owned certificate chain + signer for client auth. See
/// setCredentials for lifetime requirements.
pub fn setCertificateChain(self: *ClientHandshake, chain: CertificateChain, signer: Signer) void {
    assert(self.state == .start);
    self.client_credentials = .{ .chain = chain, .signer = signer };
}

/// Begin the handshake: encode a ClientHello using the Config's `host_name`
/// (for SNI) and `random`, frame it as a plaintext record into `out`, absorb
/// it into the transcript, and advance start -> wait_sh. Returns the wire-ready
/// record to send (then completeWrite() once sent). RFC 8446 §4.1.2, §5.1.
// ziglint-ignore: Z015 -- StartError is a public error-set alias.
pub fn start(self: *ClientHandshake, out: []u8) StartError![]const u8 {
    assert(self.state == .start);
    if (out.len < frame.header_len) return error.BufferTooShort;

    // Generate a KEM keypair if the backend supports X25519MLKEM768 AND the
    // caller opted in via Config. The public key is extracted into a buffer
    // that lives until encodeWithKem copies it into the ClientHello.
    // draft-ietf-tls-ecdhe-mlkem-05 §4.1.
    var kem_pub_buf: [mlkem.x25519_mlkem768_public_length]u8 = undefined;
    var kem_share: ?client_hello.KemShare = null;
    if (self.offer_pq_key_share and
        backend.capabilities.client_x25519_mlkem768 and
        out.len >= 2048)
    {
        const kem_key = mlkem.generateX25519Mlkem768() catch null;
        if (kem_key) |k| {
            self.kem_key = k;
            const pub_key = mlkem.publicKey(k, &kem_pub_buf) catch null;
            if (pub_key) |pk| {
                kem_share = .{ .group = .x25519_mlkem768, .data = pk };
            }
        }
    }

    const ch = try client_hello.encodeWithKem(
        out[frame.header_len..],
        self.random,
        self.keypairs.x25519.public_key,
        self.keypairs.p256.public_key,
        if (self.keypairs.p384) |keypair| keypair.public_key else null,
        self.policy.host_name,
        self.alpn_protocols,
        kem_share,
    );
    const header: frame.Header = .init(.handshake, @intCast(ch.len));
    header.write(out[0..frame.header_len]);
    self.injectClientHello(ch);
    self.pending_write.mark();
    return out[0 .. frame.header_len + ch.len];
}

/// Begin a PSK resumption handshake: encode a ClientHello offering `ticket` in
/// a pre_shared_key extension (the last extension, RFC 8446 §4.2.11) with a
/// psk_dhe_ke key exchange mode, compute the PSK binder over the truncated
/// ClientHello prefix (§4.2.11.2), and patch it in. The full ClientHello is
/// absorbed into the transcript. `out` receives the wire-ready record. RFC
/// 8446 §4.1.3, §4.2.11.
// ziglint-ignore: Z015 -- StartError is a public error-set alias.
pub fn startWithPsk(
    self: *ClientHandshake,
    ticket: *const SessionTicket,
    out: []u8,
    offer_early_data: bool,
) StartError![]const u8 {
    assert(self.state == .start);
    if (out.len < frame.header_len) return error.BufferTooShort;
    const identity = ticket.identity.constSlice();
    // binder hash length is the PSK's original cipher suite hash length.
    const binder_len: u8 = switch (ticket.cipher_suite) {
        .aes_128_gcm_sha256, .chacha20_poly1305_sha256 => 32,
        .aes_256_gcm_sha384 => 48,
    };
    const r = try client_hello.encodeWithPsk(
        out[frame.header_len..],
        self.random,
        self.keypairs.x25519.public_key,
        self.keypairs.p256.public_key,
        if (self.keypairs.p384) |keypair| keypair.public_key else null,
        self.policy.host_name,
        self.alpn_protocols,
        .psk_dhe_ke,
        identity,
        // obfuscated_ticket_age = (ticket_age + ticket_age_add) mod 2^32;
        // the caller adds the real age. For a fresh offer at age 0 this is
        // just ticket_age_add.
        ticket.ticket_age_add,
        binder_len,
        offer_early_data,
    );
    const ch = r.msg;

    // Compute the binder over the truncated prefix. RFC 8446 §4.2.11.2:
    // binder = HMAC(finished_key, Hash(prefix)), where the binder key chain is
    // pskEarlySecret(psk) -> resumptionBinderKey -> finishedKey.
    const psk = ticket.psk.constSlice();
    switch (ticket.cipher_suite) {
        .aes_128_gcm_sha256, .chacha20_poly1305_sha256 => {
            const H = hkdf.HkdfSha256;
            const early = H.pskEarlySecret(psk);
            const binder_key = H.resumptionBinderKey(early);
            const fin_key = H.finishedKey(.{ .data = binder_key.data });
            var th: H.TranscriptHash = undefined;
            Sha256.hash(ch[0..r.prefix_len], &th.data, .{});
            const binder = H.binder(fin_key, &th);
            @memcpy(ch[r.binder_offset..][0..binder_len], &binder);
        },
        .aes_256_gcm_sha384 => {
            const H = hkdf.HkdfSha384;
            const early = H.pskEarlySecret(psk);
            const binder_key = H.resumptionBinderKey(early);
            const fin_key = H.finishedKey(.{ .data = binder_key.data });
            var th: H.TranscriptHash = undefined;
            Sha384.hash(ch[0..r.prefix_len], &th.data, .{});
            const binder = H.binder(fin_key, &th);
            @memcpy(ch[r.binder_offset..][0..binder_len], &binder);
        },
    }

    const header: frame.Header = .init(.handshake, @intCast(ch.len));
    header.write(out[0..frame.header_len]);
    // Retain the offered PSK so processServerHello can use it as the early
    // secret if the server selects it. The PSK bytes live in the caller's
    // SessionTicket, which must outlive the handshake.
    self.offered_psk = psk;
    self.offered_psk_cipher_suite = ticket.cipher_suite;

    // 0-RTT (RFC 8446 §4.2.10, §7.1): if the caller opted in and the ticket
    // permits early data, derive the client_early_traffic_secret over the
    // FULL ClientHello transcript and install an early-traffic RecordLayer.
    // The caller uses sendEarlyData() to send 0-RTT data before the server
    // Finished. Replay risk: 0-RTT data is replayable; the caller is
    // responsible for replay-safe policy (disabled by default).
    if (offer_early_data and ticket.max_early_data_size != null) {
        switch (ticket.cipher_suite) {
            .aes_128_gcm_sha256, .chacha20_poly1305_sha256 => {
                const H = hkdf.HkdfSha256;
                const early = H.pskEarlySecret(psk);
                var th: H.TranscriptHash = undefined;
                Sha256.hash(ch, &th.data, .{});
                const early_traffic = H.clientEarlyTrafficSecret(early, &th);
                self.early_tx = try H.makeRecordLayer(ticket.cipher_suite, early_traffic);
            },
            .aes_256_gcm_sha384 => {
                const H = hkdf.HkdfSha384;
                const early = H.pskEarlySecret(psk);
                var th: H.TranscriptHash = undefined;
                Sha384.hash(ch, &th.data, .{});
                const early_traffic = H.clientEarlyTrafficSecret(early, &th);
                self.early_tx = try H.makeRecordLayer(ticket.cipher_suite, early_traffic);
            },
        }
    }

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
    self.offered_extensions = .initEmpty();
    self.offered_groups = .{};
    self.offered_key_shares = .{};
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
        self.offered_extensions = ch.offered_extensions;
        self.offered_groups = ch.groups;
        if (ch.public_key != null) self.offered_key_shares.insert(.x25519);
        if (ch.public_key_p256 != null) self.offered_key_shares.insert(.secp256r1);
        if (ch.public_key_p384 != null) self.offered_key_shares.insert(.secp384r1);
        while (i < ch.signature_schemes.len) : (i += 2) {
            const wire_scheme = memx.readInt(u16, ch.signature_schemes[i..][0..2]);
            const scheme: SignatureScheme = @enumFromInt(wire_scheme);
            if (!backend.supportsCertificateVerifyScheme(scheme)) continue;
            if (mem.indexOfScalar(
                SignatureScheme,
                self.offered_signature_schemes.constSlice(),
                scheme,
            ) != null) continue;
            self.offered_signature_schemes.append(scheme) catch unreachable;
        }
    } else {
        self.offered_signature_schemes.appendSlice(
            backend.capabilities.certificate_verify_schemes,
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
    /// The peer's KeyUpdate ratcheted one or both traffic keys. The caller
    /// must reinstall kTLS keys (or otherwise rotate) before sending or
    /// receiving more application data. RFC 8446 §4.6.3, §7.2.
    key_update: KeyUpdateEvent,
    /// The server sent a NewSessionTicket post-handshake. The caller may call
    /// `deriveSessionTicket` to obtain a storable `SessionTicket` (identity +
    /// PSK + age/lifetime). The parsed fields borrow the caller's record
    /// buffer; copy what you need before the next `handleRecord`. RFC 8446
    /// §4.6.1.
    new_session_ticket: NewSessionTicket,
    /// Handled internally; nothing for the caller to do.
    none,
    /// The peer sent close_notify.
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
/// (KeyUpdate), and surfaces a KeyUpdate response as `.key_update`. `record` is
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
    if (ev == .key_update and ev.key_update.response != null) self.pending_write.mark();
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
        error.EmptyTicket,
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
        error.InvalidSessionIdEcho,
        error.UnexpectedCertificateRequestContext,
        error.UnexpectedExtension,
        error.IllegalParameter,
        error.IdentityElement,
        error.UnofferedAlpnProtocol,
        error.UnsupportedKeyShareGroup,
        error.UnsupportedSignatureScheme,
        error.SignatureSchemeNotOffered,
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

/// Send 0-RTT early data, encrypted under the client_early_traffic_secret.
/// Only valid after startWithPsk(..., offer_early_data=true) and before the
/// server Finished is verified. The caller MUST ensure 0-RTT is replay-safe;
/// 0-RTT data is not forward-secret and can be replayed by a network attacker.
/// RFC 8446 §4.2.10, §7.1. Returns the encrypted record (then completeWrite).
pub fn sendEarlyData(
    self: *ClientHandshake,
    plaintext: []const u8,
    out: []u8,
) RecordLayer.EncryptError![]const u8 {
    if (self.early_tx == null) return error.BufferTooShort; // no early data offered
    return self.early_tx.?.encrypt(.application_data, plaintext, out);
}

// ziglint-ignore: Z015 -- SendError is a public error-set alias.
pub fn sendPreparedApplicationData(
    self: *ClientHandshake,
    plaintext_len: usize,
    out: []u8,
) SendError![]const u8 {
    return handshake.sendPreparedApplicationData(self, plaintext_len, out);
}

/// Export the current client-write traffic key epoch for caller-owned kTLS TX setup.
pub fn txKtlsInfo(self: *const ClientHandshake) RecordLayer.KtlsInfo {
    assert(self.state == .connected);
    return self.tx.ktlsInfo();
}

/// Export the current server-write traffic key epoch for caller-owned kTLS RX setup.
pub fn rxKtlsInfo(self: *const ClientHandshake) RecordLayer.KtlsInfo {
    assert(self.state == .connected);
    return self.rx.ktlsInfo();
}

/// Derive a caller-storable `SessionTicket` (identity + PSK + age/lifetime
/// metadata) from a parsed NewSessionTicket received post-handshake. The PSK is
/// HKDF-Expand-Label(resumption_master_secret, "resumption", ticket_nonce,
/// Hash.length). RFC 8446 §4.6.1, §7.4/§7.5. Returns an error if the
/// handshake has not completed (no resumption_master_secret yet).
pub fn deriveSessionTicket(
    self: *const ClientHandshake,
    nst: NewSessionTicket,
) error{ NoResumptionSecret, TicketIdentityTooLong }!SessionTicket {
    assert(self.state == .connected);
    if (nst.ticket.len > 256) return error.TicketIdentityTooLong;
    var ticket: SessionTicket = .{
        .ticket_age_add = nst.ticket_age_add,
        .ticket_lifetime = nst.ticket_lifetime,
        .max_early_data_size = nst.max_early_data_size,
    };
    ticket.identity.appendSliceAssumeCapacity(nst.ticket);
    switch (self.suite) {
        .buffering => return error.NoResumptionSecret,
        inline .sha256, .sha384 => |*s| {
            if (!s.resumption_master_valid) return error.NoResumptionSecret;
            const psk = @TypeOf(s.*).Hkdf.resumptionPsk(s.resumption_master, nst.ticket_nonce);
            ticket.psk.appendSliceAssumeCapacity(&psk.data);
            ticket.cipher_suite = s.aead;
        },
    }
    return ticket;
}

pub const ProcessError = frame.ParseError || RecordLayer.DecryptError ||
    ServerHelloError || HelloRetryRequestError || FlightError || SendError ||
    ClientFinishedError ||
    alert.ParseError ||
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
        // RFC 8446 §4.1.4: a HelloRetryRequest has the same wire type (0x02)
        // but a fixed Random value. Detect HRR before normal ServerHello
        // processing; if it is an HRR, generate ClientHello2 and stay in
        // wait_sh for the real ServerHello.
        .handshake => {
            if (self.state != .wait_sh) return error.UnexpectedRecord;
            if (hdr.length() == 0) return error.UnexpectedRecord;
            const msg = record[frame.header_len..][0..hdr.length()];
            if (try self.processHelloRetryRequest(msg, out)) |ch2| return ch2;
            try self.processServerHello(msg);
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

pub const ServerHelloError = server_hello.ParseError || aead.Error ||
    mlkem.Error ||
    error{
        UnsupportedCipherSuite,
        IdentityElement,
        LibcryptoFailed,
        UnexpectedMessage,
    };

/// Errors from HelloRetryRequest processing and ClientHello2 generation.
pub const HelloRetryRequestError = server_hello.HrrParseError ||
    client_hello.RetryEncodeError ||
    error{
        UnsupportedCipherSuite,
        UnsupportedKeyShareGroup,
        IllegalParameter,
        UnexpectedMessage,
        BufferTooShort,
    };

fn offeredSuite(self: *const ClientHandshake, suite: CipherSuite) bool {
    for (self.offered_suites.constSlice()) |offered| {
        if (offered == suite) return true;
    }
    return false;
}

/// Check if `msg` is a HelloRetryRequest and, if so, process it: validate the
/// selected group and cipher suite, perform the RFC 8446 §4.4.1 transcript
/// collapse, generate ClientHello2 with only the selected group's key_share
/// (and cookie if present), and absorb it into the transcript. Returns the
/// ClientHello2 handshake message bytes (to be framed and sent by the caller)
/// or null if `msg` is not an HRR. Stays in wait_sh for the real ServerHello.
///
/// RFC 8446 §4.1.4, §4.4.1.
// ziglint-ignore: Z015 -- HelloRetryRequestError is a public error-set alias.
pub fn processHelloRetryRequest(
    self: *ClientHandshake,
    msg: []const u8,
    out: []u8,
) HelloRetryRequestError!?[]const u8 {
    assert(self.state == .wait_sh);
    // Fast path: if the Random field doesn't match the HRR sentinel, this is
    // a normal ServerHello. The Random is at offset 6 (after the 4-byte
    // handshake header + 2-byte legacy_version), but bounds-check first.
    if (msg.len < 6 + 32) return null;
    if (!mem.eql(u8, msg[6..][0..32], &server_hello.hello_retry_request_random))
        return null;

    // RFC 8446 §4.1.4: a second HelloRetryRequest is illegal. The client must
    // abort with unexpected_message.
    if (self.retry_selected_group != null) return error.UnexpectedMessage;

    const hrr = try server_hello.parseHelloRetryRequestWithSessionIdEcho(
        msg,
        self.legacy_session_id.constSlice(),
    );

    // Validate the cipher suite was offered in ClientHello1.
    if (!self.offeredSuite(hrr.cipher_suite)) return error.UnsupportedCipherSuite;

    // Validate the selected group is one we offered and support, but did not
    // already include as a KeyShareEntry in ClientHello1. RFC 8446 §4.2.8.
    const group = hrr.selected_group orelse return error.IllegalParameter;
    if (!self.offered_groups.contains(group)) return error.UnsupportedKeyShareGroup;
    if (self.offered_key_shares.contains(group)) return error.IllegalParameter;
    switch (group) {
        .x25519, .secp256r1, .secp384r1 => {},
        else => return error.UnsupportedKeyShareGroup,
    }

    // Collapse the dual transcript to the negotiated hash's arm, carrying over
    // the hasher that already absorbed ClientHello1. RFC 8446 §4.4.1.
    const b = self.suite.buffering;
    self.suite = switch (hrr.cipher_suite) {
        .aes_128_gcm_sha256, .chacha20_poly1305_sha256 => .{
            .sha256 = .{ .transcript = b.sha256, .aead = hrr.cipher_suite },
        },
        .aes_256_gcm_sha384 => .{
            .sha384 = .{ .transcript = b.sha384, .aead = hrr.cipher_suite },
        },
    };

    // RFC 8446 §4.4.1 transcript collapse:
    //   Transcript-Hash(ClientHello1, HelloRetryRequest, ... Mn) =
    //     Hash(message_hash || 00 00 Hash.length || Hash(ClientHello1) ||
    //          HelloRetryRequest || ... || Mn)
    // Reset the running hash, feed the synthetic message_hash, then feed HRR.
    switch (self.suite) {
        .sha256 => |*s| {
            const ch1_hash = s.transcript.peek();
            s.transcript = .init(.{});
            const synthetic = transcript_util.messageHashSynthetic(32, ch1_hash);
            s.transcript.update(&synthetic);
            s.transcript.update(msg);
        },
        .sha384 => |*s| {
            const ch1_hash = s.transcript.peek();
            s.transcript = .init(.{});
            const synthetic = transcript_util.messageHashSynthetic(48, ch1_hash);
            s.transcript.update(&synthetic);
            s.transcript.update(msg);
        },
        .buffering => unreachable,
    }

    // Generate ClientHello2 with only the selected group's key_share.
    const ch2 = try client_hello.encodeRetryAfterHrr(
        out,
        self.random,
        self.keypairs.x25519.public_key,
        self.keypairs.p256.public_key,
        if (self.keypairs.p384) |keypair| keypair.public_key else null,
        group,
        hrr.cookie,
        self.policy.host_name,
        self.alpn_protocols,
    );

    // Absorb ClientHello2 into the transcript. RFC 8446 §4.4.1.
    self.suite.update(ch2);

    self.retry_selected_group = group;
    // Stay in wait_sh for the real ServerHello.
    return ch2;
}

/// Process the server's ServerHello: parse it, absorb it into the transcript,
/// compute the DHE shared secret, and install the handshake-traffic keys.
/// RFC 8446 §4.1.3, §7.1. Advances wait_sh -> wait_ee.
// ziglint-ignore: Z015 -- ServerHelloError is a public error-set alias.
pub fn processServerHello(self: *ClientHandshake, msg: []const u8) ServerHelloError!void {
    assert(self.state == .wait_sh);
    var sh: server_hello.ServerHello = undefined;
    try server_hello.parseWithSessionIdEcho(msg, self.legacy_session_id.constSlice(), &sh);
    if (!self.offeredSuite(sh.cipher_suite)) return error.UnsupportedCipherSuite;
    if (!self.offered_groups.contains(sh.key_share.group())) return error.UnsupportedKeyShareGroup;

    if (self.retry_selected_group) |hrr_group| {
        // Post-HRR ServerHello: the suite is already collapsed, and the
        // cipher suite and key_share group must match the HRR.
        // RFC 8446 §4.1.3: the server MUST select the same cipher suite in
        // the HelloRetryRequest and the ServerHello.
        const hrr_suite = switch (self.suite) {
            .sha256 => |s| s.aead,
            .sha384 => |s| s.aead,
            .buffering => unreachable,
        };
        if (sh.cipher_suite != hrr_suite) return error.IllegalParameter;
        if (sh.key_share.group() != hrr_group) return error.IllegalParameter;
    } else {
        // First (and only) ServerHello with no prior HRR: collapse the dual
        // transcript to the negotiated hash's arm.
        const b = self.suite.buffering;
        self.suite = switch (sh.cipher_suite) {
            .aes_128_gcm_sha256, .chacha20_poly1305_sha256 => .{
                .sha256 = .{ .transcript = b.sha256, .aead = sh.cipher_suite },
            },
            .aes_256_gcm_sha384 => .{
                .sha384 = .{ .transcript = b.sha384, .aead = sh.cipher_suite },
            },
        };
    }

    self.suite.update(msg); // transcript now covers ... || ServerHello
    var dhe: [80]u8 = undefined;
    const dhe_len: usize = switch (sh.key_share) {
        .x25519 => |key| blk: {
            const secret = try x25519.sharedSecret(self.keypairs.x25519.secret_key, key);
            @memcpy(dhe[0..32], &secret);
            break :blk @as(usize, 32);
        },
        .secp256r1 => |key| blk: {
            const secret = try p256.sharedSecret(self.keypairs.p256.secret_key, key);
            @memcpy(dhe[0..32], &secret);
            break :blk @as(usize, 32);
        },
        .secp384r1 => |key| blk: {
            const keypair = self.keypairs.p384 orelse unreachable;
            const secret = try p384.sharedSecret(keypair.secret_key, key);
            @memcpy(dhe[0..48], &secret);
            break :blk @as(usize, 48);
        },
        // KEM hybrid: decapsulate using our private key + the server's
        // ciphertext. draft-ietf-tls-ecdhe-mlkem-05 §4.2.
        // Capture by pointer to avoid copying the 1670-byte KEM payload,
        // which triggers an x86_64 codegen field-offset bug (issue #65).
        .kem => |*k| blk: {
            if (self.kem_key == null) return error.UnexpectedMessage;
            var sec: [80]u8 = undefined;
            const shared = try mlkem.decapsulate(
                self.kem_key.?,
                k.data.constSlice(),
                &sec,
            );
            @memcpy(dhe[0..shared.len], shared);
            break :blk shared.len;
        },
    };
    defer crypto.secureZero(u8, dhe[0..dhe_len]);
    // PSK resumption (RFC 8446 §4.2.11): if the server selected our offered
    // PSK, use it as the early secret. ztls offers a single identity, so the
    // selected index must be 0.
    const psk: ?[]const u8 = if (sh.selected_identity) |idx| blk: {
        if (idx != 0) return error.IllegalParameter;
        if (self.offered_psk == null) return error.UnexpectedExtension;
        break :blk self.offered_psk;
    } else null;
    const keys = try self.suite.deriveHandshakeKeys(dhe[0..dhe_len], psk);
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
    certificate_request.ParseError ||
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

fn processServerCertificate(
    self: *ClientHandshake,
    msg: HandshakeReader.Message,
    policy: certificate.Policy,
) FlightError!void {
    if (msg.type != .certificate) return error.UnexpectedMessage;
    // Extract and copy the leaf public key now; it must survive until
    // CertificateVerify, which may arrive in a later record.
    const pk = try certificate.parse(msg.raw, policy);
    self.leaf_pub_key.clear();
    self.leaf_pub_key.appendSlice(pk) catch return error.CertificateKeyTooLarge;
    self.server_flight_progress = .certificate_verified;
    self.suite.update(msg.raw);
    self.state = .wait_cv;
}

fn saveServerFinishedHash(self: *ClientHandshake) void {
    self.server_finished_hash_len = self.suite.writeTranscriptHash(&self.server_finished_hash);
}

fn processFlightMessage(
    self: *ClientHandshake,
    msg: HandshakeReader.Message,
    policy: certificate.Policy,
) FlightError!void {
    switch (self.state) {
        .wait_ee => {
            if (msg.type != .encrypted_extensions) return error.UnexpectedMessage;
            const ee = try encrypted_extensions.parse(msg.raw, self.alpn_protocols, .{
                .offered_extensions = self.offered_extensions,
            });
            if (ee.alpn_protocol) |protocol| {
                self.selected_alpn.clear();
                self.selected_alpn.appendSliceAssumeCapacity(protocol);
            }
            // RFC 8446 §4.2.10, §4.5 — record whether the server accepted
            // 0-RTT from the EE early_data extension. If the client offered
            // early data but the server declined (EE omitted early_data),
            // clear early_tx and proceed without EndOfEarlyData.
            self.server_accepted_early_data = ee.early_data_accepted;
            if (!ee.early_data_accepted and self.early_tx != null) {
                self.early_tx.?.deinit();
                self.early_tx = null;
            }
            self.suite.update(msg.raw);
            self.state = .wait_cert_or_cr;
        },
        .wait_cert_or_cr => switch (msg.type) {
            .certificate_request => {
                const cr = try certificate_request.parse(msg.raw);
                if (cr.request_context.len != 0) return error.UnexpectedCertificateRequestContext;
                self.certificate_request_context.clear();
                self.certificate_request_context.appendSlice(cr.request_context) catch unreachable;
                // Capture the server-offered signature schemes so clientFinished
                // can reject a signer whose scheme the server did not offer
                // (RFC 8446 §4.4.3).
                self.offered_cr_signature_schemes.clear();
                var it = cr.schemeIterator();
                while (try it.next()) |scheme| {
                    self.offered_cr_signature_schemes.append(scheme) catch
                        return error.HandshakeBufferTooShort;
                }
                self.received_certificate_request = true;
                self.suite.update(msg.raw);
                self.state = .wait_cert;
            },
            .certificate => try self.processServerCertificate(msg, policy),
            // PSK resumption (psk_dhe_ke without server Certificate): the
            // server sends Finished directly after EncryptedExtensions.
            // RFC 8446 §4.1.3, §2.2.
            .finished => {
                if (self.offered_psk == null) return error.UnexpectedMessage;
                self.suite.verifyServerFinished(msg.raw) catch return error.InvalidVerifyData;
                self.server_flight_progress = .finished_verified;
                self.suite.update(msg.raw);
                self.saveServerFinishedHash();
                self.state = .send_finished;
            },
            else => return error.UnexpectedMessage,
        },
        .wait_cert => try self.processServerCertificate(msg, policy),
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
            self.saveServerFinishedHash();
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
pub const ClientFinishedError = SendError || signature.SignError || aead.Error || error{
    UnexpectedMessage,
    SignatureSchemeNotOffered,
    BufferTooShort,
};

/// Produce the client Finished as a wire-ready (encrypted) record and promote
/// to application traffic keys. RFC 8446 §4.4.4, §7.1. Advances
/// send_finished -> connected.
///
/// The plaintext flight is [Certificate] [CertificateVerify] Finished, all
/// encrypted under the still-active handshake-traffic key, then rx/tx are
/// promoted to application-traffic keys. The optional Certificate +
/// CertificateVerify carry client authentication when the server sent
/// CertificateRequest and the client has credentials (RFC 8446 §4.4.2,
/// §4.4.3). A client with no credentials sends an empty Certificate, matching
/// the pre-client-auth behavior. `out` receives the encrypted record.
// ziglint-ignore: Z015 -- ClientFinishedError is a public error-set alias.
pub fn clientFinished(self: *ClientHandshake, out: []u8) ClientFinishedError![]const u8 {
    assert(self.state == .send_finished);
    if (self.server_flight_progress != .finished_verified) return error.UnexpectedMessage;
    if (self.server_finished_hash_len == 0) return error.UnexpectedMessage;

    // RFC 8446 §4.5 — if the server accepted 0-RTT (EE included early_data),
    // the client MUST send EndOfEarlyData after the server Finished and before
    // its own Finished. EndOfEarlyData is encrypted under the
    // client_early_traffic_secret (early_tx) and is the last record under the
    // early traffic key. The Finished is then encrypted under the handshake
    // traffic key. Both records are coalesced in the output buffer.
    var out_pos: usize = 0;
    if (self.server_accepted_early_data) {
        if (self.early_tx) |*early_tx| {
            // EndOfEarlyData: handshake type 0x05, empty body (4 bytes total).
            const eoe_msg: [4]u8 = .{
                @intFromEnum(HandshakeType.end_of_early_data),
                0,
                0,
                0,
            };
            // Absorb EndOfEarlyData into the transcript before the Finished
            // is computed (RFC 8446 §4.5).
            self.suite.update(&eoe_msg);
            const eoe_record = early_tx.encrypt(
                .handshake,
                &eoe_msg,
                out[out_pos..],
            ) catch return error.BufferTooShort;
            out_pos += eoe_record.len;
            early_tx.deinit();
            self.early_tx = null;
        }
    } else if (self.early_tx != null) {
        // Server declined 0-RTT: early_tx was already cleared in wait_ee, but
        // clean up defensively if it's still set.
        self.early_tx.?.deinit();
        self.early_tx = null;
    }

    // The whole client flight (Certificate [+ CertificateVerify] + Finished)
    // is encrypted into one record, so the plaintext is bounded by the record
    // plaintext limit. RFC 8446 §5.2.
    var plain_buf: [frame.max_plaintext_len]u8 = undefined;
    defer crypto.secureZero(u8, &plain_buf);
    var plain_len: usize = 0;

    if (self.received_certificate_request) {
        const creds = self.client_credentials;
        const ctx = self.certificate_request_context.constSlice();

        // Certificate: real chain when credentials are configured, empty
        // otherwise (existing behavior). RFC 8446 §4.4.2.
        const cert = if (creds) |c|
            c.chain.encodeWithRequestContext(plain_buf[plain_len..], ctx) catch
                return error.BufferTooShort
        else
            certificate.encodeWithRequestContext(
                plain_buf[plain_len..],
                ctx,
                &.{},
            ) catch unreachable;
        self.suite.update(cert);
        plain_len += cert.len;

        // CertificateVerify only when the client has a signer. RFC 8446 §4.4.3:
        // the signature scheme MUST be one the server offered in the
        // CertificateRequest, and the signature is over
        // client_context || transcript_hash (through Certificate).
        if (creds) |c| {
            if (std.mem.indexOfScalar(
                SignatureScheme,
                self.offered_cr_signature_schemes.constSlice(),
                c.signer.scheme,
            ) == null) return error.SignatureSchemeNotOffered;

            const cv_ctx_len = certificate.client_certificate_verify_context.len;
            var cv_input: [cv_ctx_len + 48]u8 = undefined;
            cv_input[0..cv_ctx_len].* = certificate.client_certificate_verify_context.*;
            const th_len: usize = switch (self.suite) {
                .buffering => unreachable,
                inline .sha256, .sha384 => |*s| blk: {
                    const th = s.transcript.peek();
                    @memcpy(cv_input[cv_ctx_len..][0..th.len], &th);
                    break :blk th.len;
                },
            };
            var sig_buf: [512]u8 = undefined;
            const sig = c.signer.sign(
                c.signer.context,
                cv_input[0 .. cv_ctx_len + th_len],
                &sig_buf,
            ) catch |err| switch (err) {
                error.BufferTooShort => return error.BufferTooShort,
                else => |e| return e,
            };
            const cv = certificate.encodeCertificateVerify(
                plain_buf[plain_len..],
                c.signer.scheme,
                sig,
            ) catch return error.BufferTooShort;
            self.suite.update(cv);
            plain_len += cv.len;
        }
    }

    const keys = self.suite.finishHandshake(
        plain_buf[plain_len..],
        self.server_finished_hash[0..self.server_finished_hash_len],
    ) catch |err| switch (err) {
        error.BufferTooShort => return error.BufferTooShort,
        else => |e| return e,
    };
    plain_len += keys.finished.len;

    // Encrypt under the handshake-traffic key that is still installed, then
    // promote: the Finished is the last handshake-protected message.
    const record = self.tx.encrypt(
        .handshake,
        plain_buf[0..plain_len],
        out[out_pos..],
    ) catch return error.BufferTooShort;
    self.tx.deinit();
    self.rx.deinit();
    self.tx = keys.tx;
    self.rx = keys.rx;
    self.state = .connected;
    return out[0 .. out_pos + record.len];
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
            if (dec.content.len > 0) self.post_handshake_count = 0;
            return .{ .application_data = dec.content };
        },
        .handshake => {
            if (dec.content.len == 0) return error.UnexpectedMessage;
            var respond = false;
            var saw_key_update = false;
            var nst_event: ?NewSessionTicket = null;
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
                        saw_key_update = true;
                    },
                    .new_session_ticket => {
                        // Parse and surface to the caller; the caller calls
                        // deriveSessionTicket to store resumption material.
                        // RFC 8446 §4.6.1. If multiple tickets are coalesced in
                        // one record, the last one is surfaced.
                        nst_event = try NewSessionTicket.parse(msg.raw);
                    },
                    else => return error.UnexpectedMessage,
                }
            }
            // One response covers any number of update_requested KeyUpdates.
            // RFC 8446 §4.6.3, §7.2 — surface the epoch changes so kTLS callers
            // can reinstall kernel keys. The response record is encrypted
            // under the OLD TX key inside sendKeyUpdate (which then ratchets
            // TX), so the caller must write it before reinstalling TLS_TX.
            // A KeyUpdate must be the last message in its record (§5.1), so a
            // NewSessionTicket in the same record would precede it; the key
            // epoch change takes priority over surfacing the ticket.
            if (saw_key_update) {
                if (respond) {
                    const resp = try self.sendKeyUpdate(out, .update_not_requested);
                    return .{ .key_update = .{ .response = resp, .rx = true, .tx = true } };
                }
                return .{ .key_update = .{ .response = null, .rx = true, .tx = false } };
            }
            if (nst_event) |nst| return .{ .new_session_ticket = nst };
            return .none;
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
    var hs: ClientHandshake = .init(testConfig(.{ .secret_key = .zero, .public_key = .zero }));
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

    var hs: ClientHandshake = .init(testConfig(.{ .secret_key = .zero, .public_key = .zero }));
    hs.suite.update(&rfc8448_client_hello);
    hs.suite.update(&rfc8448_server_hello);
    // Collapse to the SHA-256 arm (as processServerHello would for this suite).
    const b = hs.suite.buffering;
    hs.suite = .{ .sha256 = .{ .transcript = b.sha256, .aead = .aes_128_gcm_sha256 } };

    const keys = try hs.suite.deriveHandshakeKeys(&dhe, null);

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
fn testConfig(keypair: x25519.KeyPair) Config {
    return .{
        .keypairs = .init(keypair),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    };
}

const p256_client_seed: p256.SecretKey = .init(.{
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
    0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
    0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
    0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
});

const p256_server_seed: p256.SecretKey = .init(.{
    0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27,
    0x28, 0x29, 0x2a, 0x2b, 0x2c, 0x2d, 0x2e, 0x2f,
    0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,
    0x38, 0x39, 0x3a, 0x3b, 0x3c, 0x3d, 0x3e, 0x3f,
});

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
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
    hs.injectClientHello(&rfc8448_client_hello);

    try hs.processServerHello(&rfc8448_server_hello);

    try testing.expectEqual(.wait_ee, hs.state);
    try testing.expectEqualSlices(u8, &.{
        0x3f, 0xce, 0x51, 0x60, 0x09, 0xc2, 0x17, 0x27,
        0xd0, 0xf2, 0xe4, 0xe8, 0x6e, 0xe4, 0x03, 0xbc,
    }, &hs.rx.aead.aes_128_gcm_sha256.data);
}

// RFC 8446 §4.2.8.2, §7.4.2 — the client accepts a secp256r1 ServerHello
// key_share it offered in ClientHello and derives handshake traffic keys.
test "processServerHello: accepts secp256r1 key_share" {
    const client_p256 = try p256.KeyPair.generateDeterministic(p256_client_seed);
    const server_p256 = try p256.KeyPair.generateDeterministic(p256_server_seed);
    var hs: ClientHandshake = .init(.{
        .keypairs = .initWithP256(rfc8448_client_keypair, client_p256),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encodeWithP256(
        &ch_buf,
        .zero,
        hs.keypairs.x25519.public_key,
        hs.keypairs.p256.public_key,
        null,
        &.{},
    );
    hs.injectClientHello(ch);

    var sh_buf: [192]u8 = undefined;
    const server_ks: server_hello.KeyShare = .{ .secp256r1 = server_p256.public_key };
    const sh = try server_hello.encodeWithKeyShare(
        &sh_buf,
        @splat(0xab),
        &.{},
        .aes_128_gcm_sha256,
        &server_ks,
    );
    try hs.processServerHello(sh);
    try testing.expectEqual(.wait_ee, hs.state);
}

// RFC 8446 §4.2.8.2, §6.2 — malformed P-256 key_exchange is illegal_parameter.
test "processServerHello: rejects invalid secp256r1 point" {
    const client_p256 = try p256.KeyPair.generateDeterministic(p256_client_seed);
    var bad_p256: p256.PublicKey = .init(@splat(0));
    bad_p256.data[0] = 0x04;
    var hs: ClientHandshake = .init(.{
        .keypairs = .initWithP256(rfc8448_client_keypair, client_p256),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encodeWithP256(
        &ch_buf,
        .zero,
        hs.keypairs.x25519.public_key,
        hs.keypairs.p256.public_key,
        null,
        &.{},
    );
    hs.injectClientHello(ch);

    var sh_buf: [192]u8 = undefined;
    const bad_ks: server_hello.KeyShare = .{ .secp256r1 = bad_p256 };
    const sh = try server_hello.encodeWithKeyShare(
        &sh_buf,
        @splat(0xab),
        &.{},
        .aes_128_gcm_sha256,
        &bad_ks,
    );
    try testing.expectError(error.IdentityElement, hs.processServerHello(sh));
    try testing.expectEqual(.illegal_parameter, alertForError(error.IdentityElement));
}

// RFC 8446 §4.1.3 — ServerHello key_share must select an offered group.
test "processServerHello: rejects unoffered secp256r1 key_share" {
    const server_p256 = try p256.KeyPair.generateDeterministic(p256_server_seed);
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, hs.keypairs.x25519.public_key, null, &.{});
    hs.injectClientHello(ch);

    var sh_buf: [192]u8 = undefined;
    const server_ks: server_hello.KeyShare = .{ .secp256r1 = server_p256.public_key };
    const sh = try server_hello.encodeWithKeyShare(
        &sh_buf,
        @splat(0xab),
        &.{},
        .aes_128_gcm_sha256,
        &server_ks,
    );
    try testing.expectError(error.UnsupportedKeyShareGroup, hs.processServerHello(sh));
}

// RFC 8446 §4.1.3 — ServerHello legacy_session_id_echo must match ClientHello.
test "processServerHello: rejects mismatched session id echo" {
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
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
    var hs: ClientHandshake = .init(testConfig(.generate()));
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, hs.keypairs.x25519.public_key, null, &.{});
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
//
// The fixture imports live inside the function so the public ztls module
// never requires the fixtures module (which is test-only and not included
// in the published tarball). Issue #66.

// Decode a base64 entry from the embedded RFC 8448 archive into `out`.
// Test-only — the txtar import lives inside the function so the public ztls
// module never requires the dependency.
fn rfc8448Fixture(name: []const u8, out: []u8) []u8 {
    // ziglint-ignore: Z028
    const rfc8448_archive = @import("fixtures").rfc8448_txtar;
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
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
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
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
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
    try testing.expectEqual(.wait_cert_or_cr, hs.state);
}

test "processFlight: rejects unoffered ALPN" {
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
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
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
    hs.injectClientHello(&rfc8448_client_hello);
    try hs.processServerHello(&rfc8448_server_hello);

    var flight_buf: [1024]u8 = undefined;
    try testing.expectError(
        error.MissingTrustAnchor,
        hs.processFlight(rfc8448Fixture("server_flight.b64", &flight_buf), hs.policy),
    );
    try testing.expectEqual(.wait_cert_or_cr, hs.state);

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
        .{ .err = error.EmptyTicket, .description = .decode_error },
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
        .{ .err = error.InvalidSessionIdEcho, .description = .illegal_parameter },
        .{ .err = error.IdentityElement, .description = .illegal_parameter },
        .{ .err = error.UnexpectedExtension, .description = .illegal_parameter },
        .{ .err = error.UnofferedAlpnProtocol, .description = .illegal_parameter },
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
    try testing.expectEqual(.wait_cert_or_cr, hs.state);

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
    try testing.expectEqual(.wait_cert_or_cr, hs.state);

    var peer = try hs.tx.clone();
    defer peer.deinit();
    var out: [64]u8 = undefined;
    const rec = try hs.sendAlert(.decode_error, &out);
    try expectEncryptedAlert(&peer, rec, .decode_error);
}

// RFC 8446 §4.2 — extension responses not offered in ClientHello abort with
// unsupported_extension.
test "processFlight: rejects unsolicited EncryptedExtensions ALPN" {
    var hs = try flightReadyClient();
    defer hs.deinit();

    const bad_ee = [_]u8{
        @intFromEnum(HandshakeType.encrypted_extensions), 0x00, 0x00, 0x0b,
        0x00,                                             0x09, 0x00, 0x10,
        0x00,                                             0x05, 0x00, 0x03,
        0x02,                                             'h',  '2',
    };
    try testing.expectError(error.UnsupportedExtension, hs.processFlight(&bad_ee, hs.policy));
    try testing.expectEqual(.wait_ee, hs.state);

    var peer = try hs.tx.clone();
    defer peer.deinit();
    var out: [64]u8 = undefined;
    const rec = try hs.sendAlert(alertForError(error.UnsupportedExtension), &out);
    try expectEncryptedAlert(&peer, rec, .unsupported_extension);
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
    try testing.expectEqual(.wait_cert_or_cr, hs.state);

    var peer = try hs.tx.clone();
    defer peer.deinit();
    var out: [64]u8 = undefined;
    const rec = try hs.sendAlert(.unsupported_extension, &out);
    try expectEncryptedAlert(&peer, rec, .unsupported_extension);
}

test "processFlight: RFC 8448 §3 full server flight to connected" {
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
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
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
    hs.injectClientHello(&rfc8448_client_hello);
    try hs.processServerHello(&rfc8448_server_hello);

    var flight_buf: [1024]u8 = undefined;
    const flight = rfc8448Fixture("server_flight.b64", &flight_buf);
    try testing.expectError(error.UnexpectedEof, hs.processFlight(flight[0..2], hs.policy));
}

// RFC 8446 §5.1 — handshake messages MAY be split across records. Caller-owned
// reassembly storage keeps ztls allocation-free while supporting large flights.
test "processFlight: reassembles handshake message split across records" {
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
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
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
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
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
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
    try testing.expectEqual(.wait_cert_or_cr, hs.state);

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
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
    defer hs.deinit();
    hs.injectClientHello(&rfc8448_client_hello);

    var alert_record = [_]u8{ 0x15, 0x03, 0x03, 0x00, 0x02, 0x02, 0x28 };
    var out: [64]u8 = undefined;
    try testing.expectError(error.PeerAlert, hs.handleRecord(&alert_record, &out));
    try testing.expectEqual(.wait_sh, hs.state);
}

// RFC 8446 §D.4 — CCS before the first ClientHello is outside the compatibility window.
test "handleRecord: rejects ChangeCipherSpec before ClientHello" {
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
    defer hs.deinit();

    var ccs = [_]u8{ 0x14, 0x03, 0x03, 0x00, 0x01, 0x01 };
    var out: [64]u8 = undefined;
    try testing.expectError(error.UnexpectedRecord, hs.handleRecord(&ccs, &out));
}

// RFC 8446 §D.4 — a valid compatibility CCS is ignored after ClientHello and
// before the peer Finished.
test "handleRecord: drops valid ChangeCipherSpec after ClientHello" {
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
    defer hs.deinit();
    hs.injectClientHello(&rfc8448_client_hello);

    var ccs = [_]u8{ 0x14, 0x03, 0x03, 0x00, 0x01, 0x01 };
    var out: [64]u8 = undefined;
    try testing.expectEqual(Event.none, try hs.handleRecord(&ccs, &out));
    try testing.expectEqual(.wait_sh, hs.state);
}

// RFC 8446 §D.4 — a compatibility CCS must carry exactly byte 0x01.
test "handleRecord: rejects malformed ChangeCipherSpec payload" {
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
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
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
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

// RFC 8446 §4.3.2 — CertificateRequest is allowed after EncryptedExtensions;
// with no client credentials configured, the client records the context so it
// can echo it in an empty Certificate before Finished.
test "processFlight: accepts CertificateRequest before server Certificate" {
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
    hs.injectClientHello(&rfc8448_client_hello);
    try hs.processServerHello(&rfc8448_server_hello);

    var flight_buf: [1024]u8 = undefined;
    var hr: HandshakeReader = .init(rfc8448Fixture("server_flight.b64", &flight_buf));
    const ee = (try hr.next()).?;
    try hs.processFlight(ee.raw, hs.policy);
    try testing.expectEqual(.wait_cert_or_cr, hs.state);

    const schemes = [_]SignatureScheme{.ecdsa_secp256r1_sha256};
    var cr_buf: [64]u8 = undefined;
    const cr = try certificate_request.encode(&cr_buf, &schemes);
    try hs.processFlight(cr, hs.policy);

    try testing.expectEqual(.wait_cert, hs.state);
    try testing.expect(hs.received_certificate_request);
    try testing.expectEqualSlices(u8, &.{}, hs.certificate_request_context.constSlice());
}

// RFC 8446 §4.3.2 — handshake-time CertificateRequest request_context MUST be empty.
test "processFlight: rejects non-empty handshake CertificateRequest context" {
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
    hs.injectClientHello(&rfc8448_client_hello);
    try hs.processServerHello(&rfc8448_server_hello);

    var flight_buf: [1024]u8 = undefined;
    var hr: HandshakeReader = .init(rfc8448Fixture("server_flight.b64", &flight_buf));
    const ee = (try hr.next()).?;
    try hs.processFlight(ee.raw, hs.policy);

    const cr = [_]u8{
        0x0d, 0x00, 0x00, 0x0c,
        0x01, 0xaa, 0x00, 0x08,
        0x00, 0x0d, 0x00, 0x04,
        0x00, 0x02, 0x04, 0x03,
    };
    try testing.expectError(
        error.UnexpectedCertificateRequestContext,
        hs.processFlight(&cr, hs.policy),
    );
    try testing.expectEqual(.wait_cert_or_cr, hs.state);
}

// RFC 8446 §4.4.2, §4.4.4, §7.1 — when the server requests client auth and
// no credentials are configured, the client sends Certificate(empty) then
// Finished while keeping app secrets derived through the server Finished.
test "clientFinished: sends empty Certificate before Finished for CertificateRequest" {
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
    hs.policy.insecure_no_chain_anchor = true;
    hs.injectClientHello(&rfc8448_client_hello);
    try hs.processServerHello(&rfc8448_server_hello);
    var flight_buf: [1024]u8 = undefined;
    try hs.processFlight(rfc8448Fixture("server_flight.b64", &flight_buf), hs.policy);
    hs.received_certificate_request = true;
    hs.certificate_request_context.clear();

    var peer = try hs.tx.clone();
    defer peer.deinit();

    var out: [256]u8 = undefined;
    const record = try hs.clientFinished(&out);
    try testing.expectEqual(.connected, hs.state);

    var dec_buf: [256]u8 = undefined;
    @memcpy(dec_buf[0..record.len], record);
    const dec = try peer.decrypt(dec_buf[0..record.len]);
    try testing.expectEqual(.handshake, dec.content_type);
    try testing.expectEqualSlices(u8, &.{
        0x0b, 0x00, 0x00, 0x04,
        0x00, 0x00, 0x00, 0x00,
    }, dec.content[0..8]);
    try testing.expectEqual(
        HandshakeType.finished,
        @as(HandshakeType, @enumFromInt(dec.content[8])),
    );

    try testing.expectEqualSlices(u8, &.{
        0x9f, 0x02, 0x28, 0x3b, 0x6c, 0x9c, 0x07, 0xef,
        0xc2, 0x6b, 0xb9, 0xf2, 0xac, 0x92, 0xe3, 0x56,
    }, &hs.rx.aead.aes_128_gcm_sha256.data);
}

// RFC 8446 §4.4.2 — a client with no credentials sends an empty Certificate
// (request_context echoed) before Finished when the server sent
// CertificateRequest. No CertificateVerify is sent.
test "clientFinished: empty CertificateRequest with no credentials still finishes" {
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
    hs.policy.insecure_no_chain_anchor = true;
    hs.injectClientHello(&rfc8448_client_hello);
    try hs.processServerHello(&rfc8448_server_hello);
    var flight_buf: [1024]u8 = undefined;
    try hs.processFlight(rfc8448Fixture("server_flight.b64", &flight_buf), hs.policy);

    // No credentials, but simulate a CertificateRequest: clientFinished must
    // still emit the empty-Certificate + Finished path without hanging.
    hs.received_certificate_request = true;
    hs.certificate_request_context.clear();
    hs.offered_cr_signature_schemes.clear();

    var out: [4096]u8 = undefined;
    const record = try hs.clientFinished(&out);
    try testing.expect(record.len > 0);
}

// Isolate: fromP256Scalar + setCredentials alone (no clientFinished sign path).
test "client auth: setCredentials stores client credentials" {
    const shared_fixtures = @import("fixtures").shared;
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
    var signer: signature.PrivateKey = try .fromP256Scalar(
        shared_fixtures.client_ecdsa_scalar[0..32],
    );
    defer signer.deinit();
    hs.setCredentials(&.{&shared_fixtures.client_ecdsa_cert_der}, signer.signer());
    try testing.expect(hs.client_credentials != null);
}

// RFC 8446 §7.2 — KeyUpdate key ratchet. After the handshake, ratchet the
// client (sending) application key one generation and check the re-derived
// write key against the independently-computed next key (see the
// nextTrafficSecret vector in hkdf.zig).
test "ratchetClientKey: RFC 8446 §7.2 next application write key" {
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
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

fn expectHandshakeSecretsZero(suite: *const Suite) !void {
    switch (suite.*) {
        .buffering => unreachable,
        inline .sha256, .sha384 => |*s| {
            try testing.expect(mem.allEqual(u8, mem.asBytes(&s.handshake_secret), 0));
            try testing.expect(mem.allEqual(u8, mem.asBytes(&s.client_finished_key), 0));
            try testing.expect(mem.allEqual(u8, mem.asBytes(&s.server_finished_key), 0));
        },
    }
}

// Drive the RFC 8448 §3 handshake to connected; rx/tx carry application keys.
fn connectedTestClient() !ClientHandshake {
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
    hs.policy.insecure_no_chain_anchor = true;
    hs.injectClientHello(&rfc8448_client_hello);
    try hs.processServerHello(&rfc8448_server_hello);
    var flight_buf: [1024]u8 = undefined;
    try hs.processFlight(rfc8448Fixture("server_flight.b64", &flight_buf), hs.policy);
    var out: [128]u8 = undefined;
    _ = try hs.clientFinished(&out);
    try expectHandshakeSecretsZero(&hs.suite);
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
// under the old send key. The event surfaces as `.key_update` carrying both
// epoch changes and the response record.
test "handleRecord: server KeyUpdate(update_requested) ratchets rx and responds" {
    var hs = try connectedTestClient();

    // Server's sending layer (mirrors our rx at seq 0) and our pre-ratchet
    // send-key mirror to decrypt the response. Capture the server's secret_0
    // before receive() ratchets our rx, so we can advance it independently.
    const server_secret_0 = hs.suite.sha256.server_app_secret;
    const rx_ktls_0 = hs.rxKtlsInfo();
    const tx_ktls_0 = hs.txKtlsInfo();
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

    // The event carries both epoch changes and the response record.
    try testing.expect(ev == .key_update);
    try testing.expectEqual(true, ev.key_update.rx);
    try testing.expectEqual(true, ev.key_update.tx);
    const resp = ev.key_update.response.?;
    var resp_buf: [64]u8 = undefined;
    @memcpy(resp_buf[0..resp.len], resp);
    const dec = try client_send_mirror.decrypt(resp_buf[0..resp.len]);
    try testing.expectEqual(.handshake, dec.content_type);
    try testing.expectEqualSlices(u8, &.{ 0x18, 0x00, 0x00, 0x01, 0x00 }, dec.content);
    hs.completeWrite(); // acknowledge the response was sent
    const rx_ktls_1 = hs.rxKtlsInfo();
    const tx_ktls_1 = hs.txKtlsInfo();
    try testing.expect(!mem.eql(
        u8,
        rx_ktls_0.key[0..rx_ktls_0.key_len],
        rx_ktls_1.key[0..rx_ktls_1.key_len],
    ));
    try testing.expect(!mem.eql(
        u8,
        tx_ktls_0.key[0..tx_ktls_0.key_len],
        tx_ktls_1.key[0..tx_ktls_1.key_len],
    ));
    try testing.expectEqualSlices(u8, &([_]u8{0} ** 8), &rx_ktls_1.rec_seq);
    try testing.expectEqualSlices(u8, &([_]u8{0} ** 8), &tx_ktls_1.rec_seq);

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

// RFC 8446 §4.6.3 — a server KeyUpdate(update_not_requested) ratchets only
// the receive key; no response is needed. The event surfaces as
// `.key_update` with rx=true, tx=false, response=null.
test "handleRecord: server KeyUpdate(update_not_requested) surfaces key_update rx only" {
    var hs = try connectedTestClient();
    const rx_ktls_0 = hs.rxKtlsInfo();
    const tx_ktls_0 = hs.txKtlsInfo();
    var server_tx = try hs.rx.clone();
    defer server_tx.deinit();

    const ku = [_]u8{
        @intFromEnum(HandshakeType.key_update),              0x00, 0x00, 0x01,
        @intFromEnum(KeyUpdateRequest.update_not_requested),
    };
    var ku_buf: [64]u8 = undefined;
    const ku_wire = try server_tx.encrypt(.handshake, &ku, &ku_buf);
    var rx_buf: [64]u8 = undefined;
    @memcpy(rx_buf[0..ku_wire.len], ku_wire);
    var out: [64]u8 = undefined;
    const ev = try hs.handleRecord(rx_buf[0..ku_wire.len], &out);

    try testing.expect(ev == .key_update);
    try testing.expectEqual(true, ev.key_update.rx);
    try testing.expectEqual(false, ev.key_update.tx);
    try testing.expectEqual(@as(?[]const u8, null), ev.key_update.response);

    // RX material changed; TX material unchanged.
    const rx_ktls_1 = hs.rxKtlsInfo();
    const tx_ktls_1 = hs.txKtlsInfo();
    try testing.expect(!mem.eql(
        u8,
        rx_ktls_0.key[0..rx_ktls_0.key_len],
        rx_ktls_1.key[0..rx_ktls_1.key_len],
    ));
    try testing.expect(mem.eql(
        u8,
        tx_ktls_0.key[0..tx_ktls_0.key_len],
        tx_ktls_1.key[0..tx_ktls_1.key_len],
    ));
    try testing.expectEqualSlices(u8, &([_]u8{0} ** 8), &rx_ktls_1.rec_seq);
}

// RFC 8446 §4.6.3, §7.2 — after a self-initiated sendKeyUpdate(.update_requested),
// TX ratchets inside that call. When the peer's response KeyUpdate(update_not_requested)
// arrives, the event surfaces rx=true, tx=false, response=null.
test "handleRecord: self-initiated sendKeyUpdate response surfaces rx only" {
    var hs = try connectedTestClient();
    const tx_ktls_0 = hs.txKtlsInfo();

    // Self-initiated KeyUpdate: TX ratchets inside the call.
    var out: [64]u8 = undefined;
    const ku_resp = try hs.sendKeyUpdate(&out, .update_requested);
    _ = ku_resp;
    hs.completeWrite();
    const tx_ktls_1 = hs.txKtlsInfo();
    try testing.expect(!mem.eql(
        u8,
        tx_ktls_0.key[0..tx_ktls_0.key_len],
        tx_ktls_1.key[0..tx_ktls_1.key_len],
    ));

    // Peer responds with KeyUpdate(update_not_requested) under the peer's
    // next TX key (which mirrors our next RX key). Build a mirror of our
    // pre-ratchet RX, then ratchet it to produce the peer's response.
    var peer_tx = try hs.rx.clone();
    defer peer_tx.deinit();
    const ku_nr = [_]u8{
        @intFromEnum(HandshakeType.key_update),              0x00, 0x00, 0x01,
        @intFromEnum(KeyUpdateRequest.update_not_requested),
    };
    var ku_buf: [64]u8 = undefined;
    const ku_wire = try peer_tx.encrypt(.handshake, &ku_nr, &ku_buf);
    var rx_buf: [64]u8 = undefined;
    @memcpy(rx_buf[0..ku_wire.len], ku_wire);

    const ev = try hs.handleRecord(rx_buf[0..ku_wire.len], &out);
    try testing.expect(ev == .key_update);
    try testing.expectEqual(true, ev.key_update.rx);
    try testing.expectEqual(false, ev.key_update.tx);
    try testing.expectEqual(@as(?[]const u8, null), ev.key_update.response);

    // RX material changed again (second ratchet).
    const rx_ktls_1 = hs.rxKtlsInfo();
    try testing.expectEqualSlices(u8, &([_]u8{0} ** 8), &rx_ktls_1.rec_seq);
}

// RFC 8446 §6.1 — close_notify is the only alert that cleanly closes.
// RFC 8446 §6 — alerts before handshake protection are plaintext records.
test "sendAlert: plaintext fatal alert before ServerHello" {
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
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

// RFC 8446 §4.6.1 — a post-handshake NewSessionTicket is parsed and surfaced
// to the caller as a .new_session_ticket event (the caller calls
// deriveSessionTicket to store resumption material).
test "handleRecord: NewSessionTicket is surfaced as an event" {
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
    const ev = try hs.handleRecord(record, &out);
    try testing.expect(ev == .new_session_ticket);
    const nst = ev.new_session_ticket;
    try testing.expectEqual(@as(u32, 0x00000e10), nst.ticket_lifetime);
    try testing.expectEqual(@as(u32, 0x12345678), nst.ticket_age_add);
    try testing.expectEqualSlices(u8, &.{0xaa}, nst.ticket_nonce);
    try testing.expectEqualSlices(u8, &.{0xbb}, nst.ticket);
    try testing.expectEqual(@as(?u32, null), nst.max_early_data_size);

    // The caller can derive a storable SessionTicket (PSK over the
    // resumption_master_secret + nonce).
    const session = try hs.deriveSessionTicket(nst);
    try testing.expectEqual(@as(usize, 1), session.identity.len);
    try testing.expectEqual(@as(u8, 0xbb), session.identity.constSlice()[0]);
    try testing.expectEqual(@as(u32, 0x12345678), session.ticket_age_add);
    try testing.expect(session.psk.len > 0);
}

// RFC 8448 §3/§4 — the live 1-RTT handshake (§3) must derive the
// resumption_master_secret that §4 uses to derive the ticket PSK. The vector
// matches hkdf.zig's standalone HkdfSha256 test, but here it is proven through
// the real clientFinished transcript path.
test "clientFinished: RFC 8448 §4 resumption_master_secret over the live transcript" {
    var hs = try connectedTestClient();
    switch (hs.suite) {
        .sha256 => |*s| {
            try testing.expect(s.resumption_master_valid);
            try testing.expectEqualSlices(u8, &.{
                0x7d, 0xf2, 0x35, 0xf2, 0x03, 0x1d, 0x2a, 0x05,
                0x12, 0x87, 0xd0, 0x2b, 0x02, 0x41, 0xb0, 0xbf,
                0xda, 0xf8, 0x6c, 0xc8, 0x56, 0x23, 0x1f, 0x2d,
                0x5a, 0xba, 0x46, 0xc4, 0x34, 0xec, 0x19, 0x6c,
            }, &s.resumption_master.data);
            // RFC 8448 §4 ticket nonce is 00 00 -> the PSK used by the resumed
            // handshake.
            const psk = hkdf.HkdfSha256.resumptionPsk(s.resumption_master, &.{ 0x00, 0x00 });
            try testing.expectEqualSlices(u8, &.{
                0x4e, 0xcd, 0x0e, 0xb6, 0xec, 0x3b, 0x4d, 0x87,
                0xf5, 0xd6, 0x02, 0x8f, 0x92, 0x2c, 0xa4, 0xc5,
                0x85, 0x1a, 0x27, 0x7f, 0xd4, 0x13, 0x11, 0xc9,
                0xe6, 0x2d, 0x2c, 0x94, 0x92, 0xe1, 0xc4, 0xf3,
            }, &psk.data);
        },
        else => return error.UnexpectedSuite,
    }
}

// RFC 8446 §4.2.11.2 — startWithPsk encodes a ClientHello offering a PSK
// with the binder computed over the truncated prefix and patched in. Verify
// the binder matches an independent HMAC over the same prefix.
test "startWithPsk: binder matches an independent HMAC over the prefix" {
    var hs: ClientHandshake = .init(.{
        .keypairs = .init(.generate()),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    // Use the RFC 8448 §4 PSK (nonce 00 00 from the §3 resumption master) so
    // the binder key chain is the vector-tested one.
    const resumption_master: hkdf.HkdfSha256.Prk = .init(.{
        0x7d, 0xf2, 0x35, 0xf2, 0x03, 0x1d, 0x2a, 0x05,
        0x12, 0x87, 0xd0, 0x2b, 0x02, 0x41, 0xb0, 0xbf,
        0xda, 0xf8, 0x6c, 0xc8, 0x56, 0x23, 0x1f, 0x2d,
        0x5a, 0xba, 0x46, 0xc4, 0x34, 0xec, 0x19, 0x6c,
    });
    const psk = hkdf.HkdfSha256.resumptionPsk(resumption_master, &.{ 0x00, 0x00 });
    const identity = [_]u8{ 0x2c, 0x03, 0x5d, 0x82, 0x93, 0x59 };
    var ticket: SessionTicket = .{
        .ticket_age_add = 0x262a6494,
        .cipher_suite = .aes_128_gcm_sha256,
    };
    ticket.identity.appendSliceAssumeCapacity(&identity);
    ticket.psk.appendSliceAssumeCapacity(&psk.data);

    var out: [1024]u8 = undefined;
    const record = try hs.startWithPsk(&ticket, &out, false);
    const ch = record[frame.header_len..];

    // Re-derive the binder independently over the prefix (everything before
    // the binders list). The prefix length = ch.len - 2 (binders list len) - 2
    // (binder entry len) - 32 (binder).
    const prefix_len = ch.len - 2 - 1 - 32;
    const early = hkdf.HkdfSha256.pskEarlySecret(&psk.data);
    const binder_key = hkdf.HkdfSha256.resumptionBinderKey(early);
    const fin_key = hkdf.HkdfSha256.finishedKey(.{ .data = binder_key.data });
    var th: hkdf.HkdfSha256.TranscriptHash = undefined;
    Sha256.hash(ch[0..prefix_len], &th.data, .{});
    const expected = hkdf.HkdfSha256.binder(fin_key, &th);

    // The binder is at the end of the CH (last 32 bytes).
    try testing.expectEqualSlices(u8, &expected, ch[ch.len - 32 ..][0..32]);

    // The offered identity appears in the pre_shared_key extension.
    try testing.expect(std.mem.indexOf(u8, ch, &identity) != null);
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

// RFC 8446 §5.1 — empty application-data records are valid TLS 1.3 but
// carry no user data. They must not reset the KeyUpdate flood counter;
// otherwise an attacker can interleave empty records to bypass the cap.
test "handleRecord: empty application data does not reset flood counter" {
    var hs = try connectedTestClient();
    hs.post_handshake_count = 7;

    var server_tx = try hs.rx.clone();
    defer server_tx.deinit();
    var rec_buf: [64]u8 = undefined;
    const app_record = try server_tx.encrypt(.application_data, "", &rec_buf);

    var rx_buf: [64]u8 = undefined;
    @memcpy(rx_buf[0..app_record.len], app_record);
    var out: [64]u8 = undefined;
    const ev = try hs.handleRecord(rx_buf[0..app_record.len], &out);
    try testing.expectEqualSlices(u8, "", ev.application_data);
    try testing.expectEqual(@as(u8, 7), hs.post_handshake_count);
}

// RFC 8446 §4.6.3, §5.1 — the KeyUpdate flood cap must fire even when
// empty application-data records are interleaved between KeyUpdates.
test "handleRecord: KeyUpdate flood cap fires despite empty app-data interleaving" {
    var hs = try connectedTestClient();
    var out: [64]u8 = undefined;

    const H = hkdf.HkdfSha256;
    var server_secret = hs.suite.sha256.server_app_secret;
    var peer_tx = try H.makeRecordLayer(.aes_128_gcm_sha256, server_secret);

    var i: usize = 0;
    const result = while (i < max_post_handshake_messages + 1) : (i += 1) {
        const ku = [_]u8{
            @intFromEnum(HandshakeType.key_update),              0x00, 0x00, 0x01,
            @intFromEnum(KeyUpdateRequest.update_not_requested),
        };
        var ku_buf: [64]u8 = undefined;
        const ku_wire = try peer_tx.encrypt(.handshake, &ku, &ku_buf);
        var rx_buf: [64]u8 = undefined;
        @memcpy(rx_buf[0..ku_wire.len], ku_wire);

        peer_tx.deinit();
        server_secret = H.nextTrafficSecret(server_secret);

        _ = hs.handleRecord(rx_buf[0..ku_wire.len], &out) catch |e| break e;

        peer_tx = try H.makeRecordLayer(.aes_128_gcm_sha256, server_secret);
        var app_buf: [32]u8 = undefined;
        const app_wire = try peer_tx.encrypt(.application_data, "", &app_buf);
        @memcpy(rx_buf[0..app_wire.len], app_wire);
        _ = hs.handleRecord(rx_buf[0..app_wire.len], &out) catch |e| break e;

        const cloned = try peer_tx.clone();
        peer_tx.deinit();
        peer_tx = cloned;
    } else error.NoError;
    try testing.expectEqual(error.TooManyKeyUpdates, result);
}

// RFC 8446 §4.1.2, §4.4.2.2 — Config.host_name is the single source for SNI
// (server_name extension) and certificate SAN/CN validation.
test "start: uses Config host_name for SNI and policy" {
    var hs: ClientHandshake = .init(.{
        .keypairs = .init(rfc8448_client_keypair),
        .host_name = "example.com",
        .now_sec = 0,
        .random = .{ .data = @splat(0xaa) },
    });
    var out: [256]u8 = undefined;
    _ = try hs.start(&out);
    try testing.expectEqualStrings("example.com", hs.policy.host_name.?);
}

// RFC 8446 §5 — the full driver path: pump real wire records through
// handleRecord (plaintext ServerHello, a ChangeCipherSpec to discard, then the
// encrypted flight) and confirm it auto-emits the client Finished as .write and
// reaches connected. The emitted record decrypts to the RFC 8448 §3 client
// Finished.
test "handleRecord: drives RFC 8448 §3 handshake to connected" {
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
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
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
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
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
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
    try fuzz_compat.fuzzBytes(fuzzHandshakeReader, {}, .{});
}

// Drive an arbitrary decrypted flight through the state machine from wait_ee.
fn fuzzProcessFlight(_: void, input: []const u8) anyerror!void {
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
    hs.injectClientHello(&rfc8448_client_hello);
    hs.processServerHello(&rfc8448_server_hello) catch return;
    _ = hs.processFlight(input, hs.policy) catch return;
}

test "fuzz: processFlight handles arbitrary decrypted bytes" {
    try fuzz_compat.fuzzBytes(fuzzProcessFlight, {}, .{});
}

// ----------------------------------------------------------------------------
// HelloRetryRequest client-side tests — RFC 8446 §4.1.4, §4.4.1
// ----------------------------------------------------------------------------

// Helper: encode an HRR handshake message for testing.
fn encodeHrrForTest(
    out: []u8,
    session_id: []const u8,
    suite: CipherSuite,
    group: NamedGroup,
) ![]const u8 {
    return server_hello.encodeHelloRetryRequest(out, session_id, suite, group);
}

const ExtensionInfoForTest = struct {
    offset: usize,
    extensions_len_offset: usize,
};

fn findClientHelloExtensionForTest(msg: []const u8, ext_type: u16) !ExtensionInfoForTest {
    var pos: usize = 4 + 2 + 32;
    const sid_len = msg[pos];
    pos += 1 + sid_len;
    const cipher_suites_len = memx.readInt(u16, msg[pos..][0..2]);
    pos += 2 + cipher_suites_len;
    const compression_methods_len = msg[pos];
    pos += 1 + compression_methods_len;
    const extensions_len_offset = pos;
    const extensions_len = memx.readInt(u16, msg[pos..][0..2]);
    pos += 2;
    const extensions_end = pos + extensions_len;
    while (pos < extensions_end) {
        const found_type = memx.readInt(u16, msg[pos..][0..2]);
        const ext_len = memx.readInt(u16, msg[pos + 2 ..][0..2]);
        if (found_type == ext_type) return .{
            .offset = pos,
            .extensions_len_offset = extensions_len_offset,
        };
        pos += 4 + ext_len;
    }
    return error.MissingExtension;
}

fn removeP256KeyShareForTest(buf: []u8, len: usize) ![]u8 {
    const key_share = try findClientHelloExtensionForTest(buf[0..len], 0x0033);
    const offset = key_share.offset;
    const p256_entry_len = 2 + 2 + p256.public_length;
    const x25519_entry_len = 2 + 2 + x25519.public_length;
    const p256_offset = offset + 4 + 2 + x25519_entry_len;

    @memmove(buf[p256_offset .. len - p256_entry_len], buf[p256_offset + p256_entry_len .. len]);
    const new_len = len - p256_entry_len;

    const body_len = memx.readInt(u24, buf[1..4]);
    memx.writeInt(u24, buf[1..4], body_len - p256_entry_len);
    const extensions_len = memx.readInt(u16, buf[key_share.extensions_len_offset..][0..2]);
    memx.writeInt(
        u16,
        buf[key_share.extensions_len_offset..][0..2],
        extensions_len - p256_entry_len,
    );
    const key_share_ext_len = memx.readInt(u16, buf[offset + 2 ..][0..2]);
    memx.writeInt(u16, buf[offset + 2 ..][0..2], key_share_ext_len - p256_entry_len);
    const shares_len = memx.readInt(u16, buf[offset + 4 ..][0..2]);
    memx.writeInt(u16, buf[offset + 4 ..][0..2], shares_len - p256_entry_len);
    return buf[0..new_len];
}

fn encodeClientHelloMissingP256ShareForTest(out: []u8, hs: *const ClientHandshake) ![]u8 {
    const full = try client_hello.encodeWithP256(
        out,
        hs.random,
        hs.keypairs.x25519.public_key,
        hs.keypairs.p256.public_key,
        null,
        &.{},
    );
    return removeP256KeyShareForTest(out, full.len);
}

fn hrrTestKeyPairs() !KeyPairs {
    return .initWithP256(
        rfc8448_client_keypair,
        try p256.KeyPair.generateDeterministic(p256_client_seed),
    );
}

// RFC 8446 §4.2.8 — HRR selected_group must not be a group that already had a
// KeyShareEntry in ClientHello1.
test "processHelloRetryRequest: rejects already-offered key_share group" {
    var hs: ClientHandshake = .init(.{
        .keypairs = try hrrTestKeyPairs(),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encodeWithP256(
        &ch_buf,
        .zero,
        hs.keypairs.x25519.public_key,
        hs.keypairs.p256.public_key,
        null,
        &.{},
    );
    hs.injectClientHello(ch);

    var hrr_buf: [128]u8 = undefined;
    const hrr = try encodeHrrForTest(&hrr_buf, &.{}, .aes_128_gcm_sha256, .x25519);

    var out: [512]u8 = undefined;
    try testing.expectError(error.IllegalParameter, hs.processHelloRetryRequest(hrr, &out));
}

// RFC 8446 §4.1.4 — a valid HRR for secp256r1 produces ClientHello2 with only
// the secp256r1 key_share.
test "processHelloRetryRequest: secp256r1 selected produces ClientHello2" {
    const client_p256 = try p256.KeyPair.generateDeterministic(p256_client_seed);
    var hs: ClientHandshake = .init(.{
        .keypairs = .initWithP256(rfc8448_client_keypair, client_p256),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    var ch_buf: [512]u8 = undefined;
    const ch = try encodeClientHelloMissingP256ShareForTest(&ch_buf, &hs);
    hs.injectClientHello(ch);

    var hrr_buf: [128]u8 = undefined;
    const hrr = try encodeHrrForTest(&hrr_buf, &.{}, .aes_128_gcm_sha256, .secp256r1);

    var out: [512]u8 = undefined;
    const ch2 = try hs.processHelloRetryRequest(hrr, &out);
    try testing.expect(ch2 != null);
    try testing.expectEqual(.wait_sh, hs.state);
    try testing.expectEqual(NamedGroup.secp256r1, hs.retry_selected_group.?);

    const parsed = try client_hello.parse(ch2.?);
    try testing.expectEqual(@as(?x25519.PublicKey, null), parsed.public_key);
    try testing.expectEqualSlices(u8, &client_p256.public_key.data, &parsed.public_key_p256.?.data);
}

// RFC 8446 §4.4.1 — the transcript after HRR is:
//   Hash(message_hash || 00 00 Hash.length || Hash(ClientHello1) || HRR || CH2)
// Verify the collapse by computing the expected transcript independently.
test "processHelloRetryRequest: transcript collapse matches §4.4.1" {
    var hs: ClientHandshake = .init(.{
        .keypairs = try hrrTestKeyPairs(),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    var ch_buf: [512]u8 = undefined;
    const ch = try encodeClientHelloMissingP256ShareForTest(&ch_buf, &hs);
    hs.injectClientHello(ch);

    // Compute Hash(ClientHello1) independently for comparison.
    var ch1_hash: [32]u8 = undefined;
    Sha256.hash(ch, &ch1_hash, .{});

    var hrr_buf: [128]u8 = undefined;
    const hrr = try encodeHrrForTest(&hrr_buf, &.{}, .aes_128_gcm_sha256, .secp256r1);

    var out: [512]u8 = undefined;
    const ch2 = try hs.processHelloRetryRequest(hrr, &out);

    // Independently compute the expected transcript: synthetic || HRR || CH2.
    var expected: Sha256 = .init(.{});
    const synthetic = transcript_util.messageHashSynthetic(32, ch1_hash);
    expected.update(&synthetic);
    expected.update(hrr);
    expected.update(ch2.?);

    const actual = hs.suite.sha256.transcript.peek();
    const expected_hash = expected.peek();
    try testing.expectEqualSlices(u8, &expected_hash, &actual);
}

// RFC 8446 §4.1.4 — a second HelloRetryRequest is illegal; the client must
// abort with unexpected_message.
test "processHelloRetryRequest: rejects second HRR" {
    var hs: ClientHandshake = .init(.{
        .keypairs = try hrrTestKeyPairs(),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    var ch_buf: [512]u8 = undefined;
    const ch = try encodeClientHelloMissingP256ShareForTest(&ch_buf, &hs);
    hs.injectClientHello(ch);

    var hrr_buf: [128]u8 = undefined;
    const hrr = try encodeHrrForTest(&hrr_buf, &.{}, .aes_128_gcm_sha256, .secp256r1);

    var out: [512]u8 = undefined;
    _ = try hs.processHelloRetryRequest(hrr, &out);

    // Feed a second HRR — must be rejected.
    try testing.expectError(
        error.UnexpectedMessage,
        hs.processHelloRetryRequest(hrr, &out),
    );
}

// RFC 8446 §4.1.4 — HRR selected_group must be one the client offered.
test "processHelloRetryRequest: rejects unoffered selected_group" {
    var hs: ClientHandshake = .init(.{
        .keypairs = try hrrTestKeyPairs(),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    var ch_buf: [512]u8 = undefined;
    const ch = try encodeClientHelloMissingP256ShareForTest(&ch_buf, &hs);
    hs.injectClientHello(ch);

    // secp384r1 is not offered by the client (only X25519 and secp256r1).
    var hrr_buf: [128]u8 = undefined;
    const hrr = try encodeHrrForTest(&hrr_buf, &.{}, .aes_128_gcm_sha256, .secp384r1);

    var out: [512]u8 = undefined;
    try testing.expectError(
        error.UnsupportedKeyShareGroup,
        hs.processHelloRetryRequest(hrr, &out),
    );
}

// RFC 8446 §4.1.3 — after HRR, the ServerHello cipher suite must match the HRR.
test "processServerHello: post-HRR rejects mismatched cipher suite" {
    var hs: ClientHandshake = .init(.{
        .keypairs = try hrrTestKeyPairs(),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    var ch_buf: [512]u8 = undefined;
    const ch = try encodeClientHelloMissingP256ShareForTest(&ch_buf, &hs);
    hs.injectClientHello(ch);

    var hrr_buf: [128]u8 = undefined;
    const hrr = try encodeHrrForTest(&hrr_buf, &.{}, .aes_128_gcm_sha256, .secp256r1);

    var out: [512]u8 = undefined;
    _ = try hs.processHelloRetryRequest(hrr, &out);

    // ServerHello with a different cipher suite (SHA-384) must be rejected.
    var sh_buf: [192]u8 = undefined;
    const sh = try server_hello.encode(
        &sh_buf,
        @splat(0xab),
        &.{},
        .aes_256_gcm_sha384,
        .zero,
    );
    try testing.expectError(error.IllegalParameter, hs.processServerHello(sh));
}

// RFC 8446 §4.1.3 — after HRR, the ServerHello key_share group must match the
// HRR selected_group.
test "processServerHello: post-HRR rejects mismatched key_share group" {
    var hs: ClientHandshake = .init(.{
        .keypairs = try hrrTestKeyPairs(),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    var ch_buf: [512]u8 = undefined;
    const ch = try encodeClientHelloMissingP256ShareForTest(&ch_buf, &hs);
    hs.injectClientHello(ch);

    // HRR selects secp256r1.
    var hrr_buf: [128]u8 = undefined;
    const hrr = try encodeHrrForTest(&hrr_buf, &.{}, .aes_128_gcm_sha256, .secp256r1);

    var out: [512]u8 = undefined;
    _ = try hs.processHelloRetryRequest(hrr, &out);

    // ServerHello with X25519 key_share (mismatched group) must be rejected.
    var sh_buf: [128]u8 = undefined;
    const sh = try server_hello.encode(
        &sh_buf,
        @splat(0xab),
        &.{},
        .aes_128_gcm_sha256,
        .init(@splat(0xcd)),
    );
    try testing.expectError(error.IllegalParameter, hs.processServerHello(sh));
}

// RFC 8446 §4.1.3, §4.1.4 — after HRR for secp256r1, the real ServerHello with
// matching cipher suite and secp256r1 key_share is accepted and derives keys.
test "processServerHello: post-HRR accepts matching ServerHello" {
    const server_p256 = try p256.KeyPair.generateDeterministic(p256_server_seed);
    var hs: ClientHandshake = .init(.{
        .keypairs = try hrrTestKeyPairs(),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    var ch_buf: [512]u8 = undefined;
    const ch = try encodeClientHelloMissingP256ShareForTest(&ch_buf, &hs);
    hs.injectClientHello(ch);

    var hrr_buf: [128]u8 = undefined;
    const hrr = try encodeHrrForTest(&hrr_buf, &.{}, .aes_128_gcm_sha256, .secp256r1);

    var out: [512]u8 = undefined;
    _ = try hs.processHelloRetryRequest(hrr, &out);

    // Real ServerHello with secp256r1 key_share and the same cipher suite.
    var sh_buf: [192]u8 = undefined;
    const server_ks: server_hello.KeyShare = .{ .secp256r1 = server_p256.public_key };
    const sh = try server_hello.encodeWithKeyShare(
        &sh_buf,
        @splat(0xab),
        &.{},
        .aes_128_gcm_sha256,
        &server_ks,
    );
    try hs.processServerHello(sh);
    try testing.expectEqual(.wait_ee, hs.state);
}

// RFC 8446 §4.1.4 — handleRecord with an HRR record returns ClientHello2 as
// a .write event, and the client stays in wait_sh.
test "handleRecord: HRR returns ClientHello2 as write event" {
    var hs: ClientHandshake = .init(.{
        .keypairs = try hrrTestKeyPairs(),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    var ch_buf: [512]u8 = undefined;
    const ch = try encodeClientHelloMissingP256ShareForTest(&ch_buf, &hs);
    hs.injectClientHello(ch);

    var hrr_buf: [128]u8 = undefined;
    const hrr = try encodeHrrForTest(&hrr_buf, &.{}, .aes_128_gcm_sha256, .secp256r1);
    // Wrap HRR in a plaintext handshake record.
    var hrr_record: [192]u8 = undefined;
    const header: frame.Header = .init(.handshake, @intCast(hrr.len));
    header.write(hrr_record[0..frame.header_len]);
    @memcpy(hrr_record[frame.header_len..][0..hrr.len], hrr);

    var out: [512]u8 = undefined;
    const ev = try hs.handleRecord(hrr_record[0 .. frame.header_len + hrr.len], &out);
    switch (ev) {
        .write => {},
        else => try testing.expectEqual(.write, @as(std.meta.Tag(Event), ev)),
    }
    try testing.expectEqual(.wait_sh, hs.state);
    try testing.expectEqual(NamedGroup.secp256r1, hs.retry_selected_group.?);
}

// RFC 8446 §4.1.4 — a normal ServerHello (non-HRR) is not affected by the HRR
// fast-path check. processHelloRetryRequest returns null for non-HRR messages.
test "processHelloRetryRequest: returns null for normal ServerHello" {
    var hs: ClientHandshake = .init(testConfig(rfc8448_client_keypair));
    hs.injectClientHello(&rfc8448_client_hello);

    var out: [512]u8 = undefined;
    const result = try hs.processHelloRetryRequest(&rfc8448_server_hello, &out);
    try testing.expectEqual(@as(?[]const u8, null), result);
    try testing.expectEqual(@as(?NamedGroup, null), hs.retry_selected_group);
}

// RFC 8446 §4.2.2 — HRR with a cookie produces ClientHello2 that echoes the
// cookie verbatim in the cookie extension.
test "processHelloRetryRequest: HRR with cookie echoes cookie in CH2" {
    var hs: ClientHandshake = .init(.{
        .keypairs = try hrrTestKeyPairs(),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    var ch_buf: [512]u8 = undefined;
    const ch = try encodeClientHelloMissingP256ShareForTest(&ch_buf, &hs);
    hs.injectClientHello(ch);

    // Build an HRR with a cookie by hand: encode a normal HRR then inject a
    // cookie extension into the extensions block.
    var hrr_buf: [256]u8 = undefined;
    const hrr_base = try server_hello.encodeHelloRetryRequest(
        &hrr_buf,
        &.{},
        .aes_128_gcm_sha256,
        .secp256r1,
    );
    // The HRR extensions are: key_share (6 bytes) + supported_versions (6 bytes) = 12.
    // Append a cookie extension (4-byte header + 2-byte cookie_len + cookie bytes).
    const cookie = [_]u8{ 0xde, 0xad, 0xbe, 0xef };
    const cookie_ext = [_]u8{ 0x00, 0x2c } ++ // cookie extension type
        [_]u8{ 0x00, @intCast(2 + cookie.len) } ++ // extension_data length
        [_]u8{ 0x00, @intCast(cookie.len) } ++ // cookie vector length
        cookie;

    // We need to rewrite the HRR to include the cookie extension. The easiest
    // way is to rebuild it: copy the base HRR, insert the cookie ext before the
    // last 6 bytes (supported_versions), and fix the lengths.
    var hrr_with_cookie: [256]u8 = undefined;
    const base_len = hrr_base.len;
    const cookie_ext_len = cookie_ext.len;
    // The last 6 bytes are supported_versions; insert cookie before them.
    const sv_offset = base_len - 6;
    @memcpy(hrr_with_cookie[0..sv_offset], hrr_base[0..sv_offset]);
    @memcpy(hrr_with_cookie[sv_offset..][0..cookie_ext_len], &cookie_ext);
    @memcpy(hrr_with_cookie[sv_offset + cookie_ext_len ..][0..6], hrr_base[sv_offset..base_len]);
    const new_total = base_len + cookie_ext_len;
    // Fix the handshake body length (bytes 1..4, u24).
    const new_body_len: u24 = @intCast(new_total - 4);
    hrr_with_cookie[1] = @intCast(new_body_len >> 16);
    hrr_with_cookie[2] = @intCast((new_body_len >> 8) & 0xff);
    hrr_with_cookie[3] = @intCast(new_body_len & 0xff);
    // Fix the extensions_len (u16 at offset 42: 4+2+32+1+2+1 = 42).
    const old_ext_len = memx.readInt(u16, hrr_with_cookie[42..][0..2]);
    memx.writeInt(
        u16,
        hrr_with_cookie[42..][0..2],
        old_ext_len + @as(u16, @intCast(cookie_ext_len)),
    );

    var out: [512]u8 = undefined;
    const ch2 = try hs.processHelloRetryRequest(hrr_with_cookie[0..new_total], &out);
    try testing.expect(ch2 != null);
    try testing.expectEqual(.wait_sh, hs.state);

    // Verify CH2 contains the cookie extension by searching for the cookie
    // extension type (0x002c) followed by the cookie bytes.
    var found_cookie = false;
    var i: usize = 0;
    while (i + 6 < ch2.?.len) : (i += 1) {
        if (ch2.?[i] == 0x00 and ch2.?[i + 1] == 0x2c) {
            const ext_data_len = memx.readInt(u16, ch2.?[i + 2 ..][0..2]);
            if (ext_data_len == 2 + cookie.len) {
                const cookie_len = memx.readInt(u16, ch2.?[i + 4 ..][0..2]);
                if (cookie_len == cookie.len and
                    mem.eql(u8, ch2.?[i + 6 ..][0..cookie.len], &cookie))
                {
                    found_cookie = true;
                    break;
                }
            }
        }
    }
    try testing.expect(found_cookie);
}
