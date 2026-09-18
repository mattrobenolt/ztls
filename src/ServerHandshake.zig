//! TLS 1.3 server handshake state machine.
//!
//! Parses ClientHello, emits ServerHello, sends an authenticated encrypted
//! flight (EncryptedExtensions / Certificate / CertificateVerify / Finished),
//! verifies the client Finished, and handles application data and post-handshake
//! KeyUpdate. No allocations, no I/O.
const std = @import("std");
const assert = std.debug.assert;
const Sha256 = std.crypto.hash.sha2.Sha256;
const Sha384 = std.crypto.hash.sha2.Sha384;
const mem = std.mem;
const testing = std.testing;

const aead = @import("aead.zig");
const alert = @import("alert.zig");
const wiremod = @import("wire.zig");
const array_buffer = @import("array_buffer.zig");
const ArrayBuffer = array_buffer.ArrayBuffer;
const SliceBuffer = array_buffer.SliceBuffer;
const certificate = @import("certificate.zig");
const Certificate = @import("certificate_parser.zig");
const CertificateChain = @import("certificate_chain.zig").CertificateChain;
const certificate_request = @import("certificate_request.zig");
const client_hello = @import("client_hello.zig");
const ClientHandshake = @import("ClientHandshake.zig");
const capabilities = @import("capabilities.zig");
const backend = @import("crypto/backend.zig");
const default_supported_suites = backend.capabilities.cipher_suites;
const encrypted_extensions = @import("encrypted_extensions.zig");
const finished = @import("finished.zig");
const frame = @import("frame.zig");
pub const max_out_len = frame.max_wire_record_len;
pub const OutBuffer = frame.OutBuffer;
/// Single caller-owned buffer for prepared authenticated server flights. The
/// handshake plaintext is staged inside the TLS record payload region, then
/// encrypted in place into the same backing storage.
pub const FlightBuffer = OutBuffer;
const fuzz_compat = @import("fuzz_compat.zig");
const handshake = @import("handshake.zig");
const HandshakeReader = handshake.Reader;
const HandshakeType = handshake.Type;
pub const KeyUpdateRequest = handshake.KeyUpdateRequest;
const max_post_handshake_messages = handshake.max_post_handshake_messages;
const HashArm = @import("suite_state.zig").HashArm;
const hkdf = @import("hkdf.zig");
const memx = @import("memx.zig");
const NewSessionTicket = @import("NewSessionTicket.zig");
const NamedGroup = @import("kex.zig").NamedGroup;
const p256 = @import("p256.zig");
const handshake_key_pairs = @import("handshake_key_pairs.zig");
const p384 = @import("p384.zig");
const PendingWrite = @import("pending_write.zig").PendingWrite;
const RecordLayer = @import("RecordLayer.zig");
const EstablishedSession = @import("EstablishedSession.zig");
const root = @import("root.zig");
const CipherSuite = root.CipherSuite;
const Random = root.Random;
const server_hello = @import("server_hello.zig");
const signature = @import("signature.zig");
pub const SignError = signature.SignError;
pub const Signer = signature.Signer;

/// Caller-provided PSK lookup for session resumption (RFC 8446 §4.2.11). The
/// server calls `lookup` for each offered identity; a non-null result carries
/// the PSK and the cipher suite under which it was derived (the binder hash
/// uses that suite's hash). Caller-owned: ztls stores no heap state.
///
/// `lookup` may be called repeatedly for the same identity within one
/// handshake: once during ClientHello PSK selection, again when a
/// HelloRetryRequest must retain the offered identities for §4.1.2
/// continuity, and once more for ClientHello2 selection. Implementations
/// must be side-effect-free and return a consistent entry (or consistent
/// null) for the same identity.
pub const PskEntry = struct {
    psk: []const u8,
    cipher_suite: CipherSuite,
    /// max_early_data_size from the ticket's early_data extension, or null if
    /// the ticket does not permit 0-RTT. The server rejects early data
    /// exceeding this limit. RFC 8446 §4.2.10, §4.6.1.
    max_early_data_size: ?u32 = null,
};
pub const PskLookup = struct {
    context: *anyopaque,
    lookup: *const fn (context: *anyopaque, identity: []const u8) ?PskEntry,
};

/// Prepared caller-owned PSK material for one NewSessionTicket. Use it to build
/// the opaque identity, commit stateful storage after the record is written,
/// then erase it with `secureZero`. Only one ticket may be prepared at a time.
pub const TicketPsk = struct {
    /// HKDF-Expand-Label output. Capacity covers SHA-384.
    psk: ArrayBuffer(u8, 48) = .empty,
    /// Cipher suite whose hash derived this PSK. Preserve it in `PskEntry`.
    cipher_suite: CipherSuite,
    /// Engine-assigned per-connection nonce. Pass this object unchanged to
    /// `sendNewSessionTicket`; the wire method serializes the nonce itself.
    ticket_nonce: [1]u8,

    pub fn secureZero(self: *TicketPsk) void {
        std.crypto.secureZero(u8, mem.asBytes(self));
    }
};

/// Caller-owned NewSessionTicket policy and opaque identity.
pub const TicketParams = struct {
    /// Lifetime in seconds. RFC 8446 caps this at seven days; zero is valid.
    ticket_lifetime: u32,
    /// A fresh, securely generated random value for this ticket.
    ticket_age_add: u32,
    /// Database lookup key or caller-encrypted/authenticated stateless value.
    /// Must be non-empty and no longer than `max_ticket_identity_len`.
    ticket: []const u8,
};

/// Default decline-skip budget: the RFC 8446 §5.2 maximum TLSCiphertext
/// payload (2^14 + 256), which covers one full maximum-size early-data
/// record's wire payload (2^14 plaintext + 1 content-type byte + 16 tag
/// bytes = 16401).
const default_early_data_skip_limit: u32 = frame.max_ciphertext_len;

const PskSelection = struct {
    entry: PskEntry,
    identity_index: usize,
};
const transcript_util = @import("transcript.zig");
const x25519 = @import("x25519.zig");
const hybrid_kex = @import("hybrid_kex.zig");

const HandshakeBuffer = SliceBuffer(u8);
// Bounds a reassembled client-flight plaintext (Certificate [+ CertificateVerify]
// + Finished) during wait_client_finished. The no-client-auth flight is just
// Finished (52 bytes), but with client auth the flight carries the client
// certificate chain and CertificateVerify too, so size for a full record
// plaintext. RFC 8446 §5.2.
const FinishedFragmentBuffer = ArrayBuffer(u8, frame.max_plaintext_len);
const KeyUpdateFragmentBuffer = ArrayBuffer(u8, handshake.key_update_total_len);

/// Upper bound on a client leaf public key we retain for CertificateVerify
/// verification. Covers RSA-4096 (~525-byte DER) with margin.
const max_client_leaf_pub_key = 1024;
const ClientLeafPubKeyBuffer = ArrayBuffer(u8, max_client_leaf_pub_key);
const ServerHandshake = @This();

pub const State = enum {
    wait_ch,
    wait_client_finished,
    connected,
    /// Consumed by `extractEstablished`: the extracted EstablishedSession owns
    /// the traffic record layers and their backend contexts. This engine must
    /// not use them again; `deinit` remains safe and wipes the duplicated
    /// secret bytes still stored here.
    extracted,
};

/// RFC 8446 §4.2.10 — disposition of records arriving after this server
/// declined the client's early_data offer. 0-RTT records already in flight
/// are protected under the client_early_traffic_secret, which a declining
/// server does not hold, so they are skipped, bounded by
/// `early_data_skip_limit`:
pub const EarlyDataSkip = enum {
    /// Not skipping: the client offered no early_data, 0-RTT was accepted
    /// (early_rx installed), or the skip window has already closed.
    off,
    /// 1-RTT decline (regular response): the client's second flight is
    /// pending in wait_client_finished. Trial-deprotect each
    /// application_data record with the handshake traffic key, discard
    /// failures, and treat the first success as the start of the second
    /// flight.
    trial_decrypt,
    /// HelloRetryRequest decline: ClientHello2 is pending in wait_ch. The
    /// server holds no key that can deprotect in-flight 0-RTT records, so
    /// skip records with an outer content type of application_data. The
    /// first ClientHello record (ClientHello2) closes the window.
    await_client_hello2,
};

const TicketNonceState = union(enum) {
    next: u8,
    prepared: u8,
};

const TicketCompatibility = enum {
    unavailable,
    psk_dhe_ke,
};

const TxOwner = enum {
    userspace,
    kernel,
};

const max_new_session_tickets = handshake.max_post_handshake_new_session_tickets;
pub const max_ticket_identity_len = 256;

const RetryClientHelloDigest = [Sha256.digest_length]u8;

/// Fixed capacity of ClientHello1 PSK identities retained across a
/// HelloRetryRequest. Real clients offer a handful of tickets; a
/// ClientHello1 that needs a retry but offers more identities than this is
/// rejected up front with TooManyPskIdentities — an explicit, documented
/// admission bound rather than a silent claim of support beyond it.
const max_retry_psk_identities = 8;

/// 128-bit fingerprint of a ClientHello1 PSK identity (truncated SHA-256).
/// Fingerprints, not identity bytes, are retained: identities are
/// peer-controlled and may reach 64 KiB each, while the engine holds no heap
/// state. A 128-bit truncation keeps a substitution that survives continuity
/// matching a 2^64 birthday search, and a forged identity still has to pass
/// its own binder to be selected.
const RetryPskFingerprint = [16]u8;

/// Whether ClientHello2 may drop a ClientHello1 PSK identity, decided at
/// HelloRetryRequest time from what the server can prove. RFC 8446 §4.1.2
/// permits removing only PSKs incompatible with the cipher suite the server
/// indicated, and the server can determine a PSK's hash two ways: an
/// identity its own PskLookup resolves carries the hash of the entry's
/// cipher suite, and any identity's binder length is the hash output of its
/// PSK's cipher suite (§4.2.11.2: the binder is an HMAC over the transcript
/// hash, Finished-style). An identity whose binder length does not match the
/// HRR suite's hash length claims a different hash family and may be
/// dropped; one that matches claims compatibility and must be retained.
const RetryPskRetention = enum {
    /// The lookup resolved the identity to a suite-hash-compatible PSK, or
    /// the identity is unknown but its binder length matches the HRR
    /// suite's hash output: ClientHello2 must retain it.
    must_retain,
    /// The lookup resolved the identity to a PSK hash-incompatible with the
    /// HRR cipher suite, or the binder length claims a different hash
    /// family (no binder of that length can verify under the HRR suite
    /// anyway): ClientHello2 may drop it.
    may_remove,
};

const RetryPskIdentity = struct {
    fingerprint: RetryPskFingerprint,
    retention: RetryPskRetention,
};

/// ClientHello1 pre_shared_key continuity metadata retained across a
/// HelloRetryRequest (RFC 8446 §4.1.2). Fixed capacity; no allocation.
const RetryPskCapture = union(enum) {
    /// ClientHello1 offered no pre_shared_key extension: ClientHello2 must
    /// not add one (§4.1.2 forbids extensions not present in ClientHello1).
    none,
    /// Per-identity fingerprints in offer order. ClientHello2's identities
    /// must match these in order, minus `may_remove` entries.
    identities: ArrayBuffer(RetryPskIdentity, max_retry_psk_identities),
};

const RetryTranscript = union(enum) {
    sha256: Sha256,
    sha384: Sha384,
};

/// Negotiated traffic-secret state (see suite_state.zig). The KeyUpdate
/// ratchet derives each next traffic key from the active arm's application
/// secrets (RFC 8446 §4.6.3, §7.2).
const Suite = @import("suite_state.zig").Suite;

const ClientKeyShare = union(enum) {
    x25519: x25519.PublicKey,
    secp256r1: p256.PublicKey,
    secp384r1: p384.PublicKey,
    /// RFC 10024 §4.1 hybrid key_share selected from the ClientHello.
    kem: client_hello.ParsedKemKeyShare,
};

const compatibility_ccs_len = frame.header_len + 1;
const handshake_header_len = 4;

/// Maximum handshake message body the server will reassemble from record
/// fragments. Two full TLS record payloads covers any realistic ClientHello.
/// RFC 8446 §5.1 permits fragmenting handshake messages across multiple records.
const ch_reassembly_body_max = frame.max_plaintext_len * 2;
/// Full handshake message (4-byte header + body). Callers provide storage
/// of at least this size via useHandshakeBuffer() for ClientHello reassembly.
pub const ch_reassembly_buffer_size = handshake_header_len + ch_reassembly_body_max;

/// Caller-owned backing for ClientHello reassembly, sized to the documented
/// minimum. Declare one as `.empty` and hand `&storage.buffer` to
/// useHandshakeBuffer().
pub const Storage = ArrayBuffer(u8, ch_reassembly_buffer_size);

/// Configuration for a server handshake. Required fields have no defaults.
/// Borrowed suite and ALPN slices are read during ClientHello processing;
/// reassembly storage must live until the handshake reaches wait_client_finished.
pub const KeyPairs = handshake_key_pairs.KeyPairs;

pub const ClientAuthPolicy = enum {
    none,
    optional,
    required,
};

pub const Config = struct {
    pub const ValidationError = capabilities.HybridPolicyError || error{MissingP384KeyPair};

    /// Ephemeral keypairs used for ServerHello key_share entries. X25519 and
    /// P-256 are present by default; P-384 is opt-in.
    keypairs: KeyPairs,
    /// ServerHello random field (RFC 8446 §4.1.3). Stored and used once.
    random: Random,
    /// Cipher suites offered by this server, in server preference order.
    supported_suites: []const CipherSuite = default_supported_suites,
    /// ALPN protocols supported by this server. Caller-owned.
    alpn_protocols: root.AlpnProtocols = &.{},
    /// Server-side handshake-time client certificate policy.
    client_auth: ClientAuthPolicy = .none,
    /// Trust anchors for client certificate chain validation. Required when
    /// client_auth is .optional or .required and the client sends a non-empty
    /// certificate. If null, the server rejects non-empty client certificates
    /// unless insecure_no_client_chain_anchor is set.
    client_auth_bundle: ?*const std.crypto.Certificate.Bundle = null,
    /// Test/demo opt-out from trust-anchor verification for client certs.
    /// Production servers should leave this false and provide
    /// client_auth_bundle.
    insecure_no_client_chain_anchor: bool = false,
    /// Current time in seconds since the Unix epoch for client certificate
    /// validity checks. Required when client_auth is non-none.
    client_auth_now_sec: i64 = 0,
    /// Optional caller-owned ClientHello reassembly storage.
    reassembly: ?[]u8 = null,
    /// Optional caller-owned storage for retaining the verified client leaf
    /// certificate DER. The storage must outlive the handshake.
    client_cert_buffer: ?[]u8 = null,
    /// Optional caller-owned PSK lookup for session resumption (RFC 8446
    /// §4.2.11). When set, the server verifies offered PSK binders and, if one
    /// verifies, resumes with that PSK (psk_dhe_ke) instead of a full
    /// handshake. Caller-owned: ztls stores no heap state.
    psk_lookup: ?PskLookup = null,
    /// RFC 10024 hybrid groups accepted by this server, in preference order.
    /// Empty keeps hybrid negotiation disabled. A listed group with no client
    /// key_share may be selected through HelloRetryRequest. Caller-owned; the
    /// slice must remain valid through any ClientHello2 processing.
    hybrid_groups: []const NamedGroup = &.{},
    /// RFC 8446 §4.2.10 — wire-byte budget for skipping already-in-flight
    /// 0-RTT records after this server declines an early_data offer, on both
    /// decline paths: the regular 1-RTT response (trial-deprotection with the
    /// handshake key while the second flight is pending) and the
    /// HelloRetryRequest response (skipping outer application_data records
    /// while ClientHello2 is pending). Each skipped record consumes its wire
    /// payload length — ciphertext plus AEAD tag, excluding the 5-byte record
    /// header — so one maximum-size early-data record consumes 16401 of the
    /// default 16640. Exhausting the budget aborts the handshake with
    /// `EarlyDataSkipLimitExceeded` (bad_record_mac). Size it above the
    /// largest total early data your tickets can put in flight; zero restores
    /// abort-on-first-failure.
    early_data_skip_limit: u32 = default_early_data_skip_limit,

    /// Validate local hybrid policy before handshake construction or wire I/O.
    pub fn validate(self: *const Config) ValidationError!void {
        try validateHybridPolicy(self.hybrid_groups, &self.keypairs);
    }
};

pub const ConfigError = Config.ValidationError;

test "Config.validate reports invalid lists and missing P-384 material" {
    var keypairs: KeyPairs = try .init(.generate());
    defer keypairs.secureZero();
    var config: Config = .{
        .keypairs = keypairs,
        .random = .zero,
        .hybrid_groups = &.{ .x25519_mlkem768, .x25519_mlkem768 },
    };
    try testing.expectError(error.InvalidHybridPolicy, config.validate());

    config.hybrid_groups = &.{.secp384r1_mlkem1024};
    if (capabilities.supportsHybridGroup(.server, .secp384r1_mlkem1024)) {
        try testing.expectError(error.MissingP384KeyPair, config.validate());
    } else {
        try testing.expectError(error.HybridGroupUnavailable, config.validate());
    }
}

const ServerCredentials = struct {
    chain: CertificateChain,
    signer: Signer,
};

state: State = .wait_ch,
keypairs: KeyPairs,
random: Random,
negotiated_group: NamedGroup = .x25519,
suite: CipherSuite = .aes_128_gcm_sha256,
suite_state: Suite = undefined,
supported_suites: []const CipherSuite = default_supported_suites,
hybrid_groups: []const NamedGroup = &.{},
alpn_protocols: root.AlpnProtocols = &.{},
client_auth: ClientAuthPolicy = .none,
/// Policy for verifying client certificate chains. Initialized from Config.
client_cert_policy: certificate.Policy = .{ .leaf_usage = .client_auth },
/// Leaf public key extracted from the client Certificate, retained until
/// CertificateVerify verification. Copied so it survives across records.
client_leaf_pub_key: ClientLeafPubKeyBuffer = .empty,
/// Caller-owned storage containing the verified client leaf certificate DER.
client_cert: HandshakeBuffer = .empty,
/// Transcript hash through the server Finished, snapshotted when the server
/// flight is emitted. RFC 8446 §7.1: application traffic secrets are derived
/// from the transcript through the server Finished, independent of any client
/// Certificate/CertificateVerify that follows. Without this snapshot the
/// client-auth path would derive app secrets from the wrong transcript.
server_finished_hash: [48]u8 = @splat(0),
server_finished_hash_len: u8 = 0,
selected_alpn: ?[]const u8 = null,
/// SNI hostname sent by the client in the server_name extension (RFC 6066 §3).
/// Populated after acceptClientHello / handleRecord returns the first write event.
/// Points into the ClientHello message buffer (the caller-owned record
/// buffer or the handshake reassembly buffer). Copy if needed beyond the
/// next handleRecord call.
client_server_name: ?[]const u8 = null,
rx: RecordLayer = undefined,
tx: RecordLayer = undefined,
/// Set when an engine call hands the caller bytes that must be written before
/// more input can be safely processed. Prevents dropped ServerHello/flight/app
/// data from silently desynchronizing traffic keys.
pending_write: PendingWrite = .idle,
/// Monotonic one-byte nonces structurally enforce uniqueness for the bounded
/// ticket burst accepted by ztls clients. At most one PSK may be prepared ahead.
ticket_nonce_state: TicketNonceState = .{ .next = 0 },
ticket_compatibility: TicketCompatibility = .unavailable,
tx_owner: TxOwner = .userspace,
/// Most recent non-close_notify peer alert (RFC 8446 §6.2); close_notify (§6.1)
/// never sets it.
last_peer_alert: ?alert.Alert = null,
post_handshake_count: u8 = 0,
/// An inbound KeyUpdate request must be answered before kTLS handoff.
key_update_obligation: handshake.KeyUpdateObligation = .none,
retry_transcript: ?RetryTranscript = null,
retry_ch1_digest: ?RetryClientHelloDigest = null,
/// ClientHello1 PSK identity continuity metadata (RFC 8446 §4.1.2),
/// captured when the server sends a HelloRetryRequest and consumed when
/// processing ClientHello2. See RetryPskCapture.
retry_psk: RetryPskCapture = .none,
retry_selected_group: ?NamedGroup = null,
/// PSK selected from the client's pre_shared_key offer (RFC 8446 §4.2.11),
/// set when the server resumes. `selected_psk_index` is echoed in the
/// ServerHello pre_shared_key extension. The PSK bytes are caller-owned (the
/// PskLookup outlives the handshake).
selected_psk: ?PskEntry = null,
selected_psk_index: u16 = 0,
/// Early traffic (0-RTT) receive RecordLayer, installed when the client
/// offers early_data and a PSK is selected. RFC 8446 §4.2.10, §7.1.
early_rx: ?RecordLayer = null,
/// max_early_data_size from the selected PSK's ticket policy. The server
/// rejects early data exceeding this limit.
early_data_limit: ?u32 = null,
early_data_received: u32 = 0,
/// RFC 8446 §4.5 — set when the client's EndOfEarlyData has been received
/// and verified under the early traffic key. The server expects this before
/// the client Finished when it accepted 0-RTT (early_rx != null).
end_of_early_data_received: bool = false,
/// RFC 8446 §4.2.10 — skip mode for 0-RTT records already in flight after
/// this server declined the client's early_data offer. See `EarlyDataSkip`.
early_data_skip: EarlyDataSkip = .off,
/// Wire payload bytes discarded so far in a skip window, bounded by
/// `early_data_skip_limit` (copied from Config; the engine keeps it because
/// Config is not retained).
early_data_skip_bytes: u32 = 0,
early_data_skip_limit: u32 = default_early_data_skip_limit,
/// Caller-configured PSK lookup (from Config.psk_lookup). Carried on state
/// so processClientHelloMessage can use it.
psk_lookup: ?PskLookup = null,
/// Caller-owned certificate DER slices and signer used for the authenticated
/// server flight. The DER bytes, slice-of-slices, and PrivateKey backing the
/// Signer must outlive this handshake. ztls stores references and does not copy
/// or own credential memory.
server_credentials: ?ServerCredentials = null,
/// Set before server-flight assembly mutates the transcript, so a terminal
/// failure cannot be retried into a duplicate Finished or key/nonce reuse.
server_flight_sent: bool = false,

/// Caller-owned storage for reassembling a fragmented plaintext
/// ClientHello/ClientHello2 across records. Set via useHandshakeBuffer().
/// Empty means fragmented messages are rejected with IncompleteRecord.
/// Capacity is caller-determined; ch_reassembly_buffer_size is the
/// recommended minimum (two record payloads + handshake header).
/// RFC 8446 §5.1.
ch_buf: HandshakeBuffer = .empty,
/// Total handshake message length expected (4 + body_len from the handshake
/// header in the first fragment). Valid only when ch_buf.len > 0.
ch_expected: usize = 0,

/// Fixed-size buffer for reassembling a fragmented client Finished message
/// across encrypted records (application_data → inner handshake).
/// Verify data is at most 48 bytes (SHA-384 output length) plus the 4-byte
/// handshake header, so a small fixed buffer is sufficient. RFC 8446 §5.1.
fin_frag: FinishedFragmentBuffer = .empty,

/// Fixed-size buffer for reassembling fragmented post-handshake KeyUpdate
/// messages across encrypted records. KeyUpdate is always a 4-byte handshake
/// header plus a 1-byte request body. RFC 8446 §5.1, §4.6.3.
ku_frag: KeyUpdateFragmentBuffer = .empty,

pub fn init(config: Config) ServerHandshake {
    return .{
        .keypairs = config.keypairs,
        .random = config.random,
        .supported_suites = config.supported_suites,
        .hybrid_groups = config.hybrid_groups,
        .alpn_protocols = config.alpn_protocols,
        .client_auth = config.client_auth,
        .client_cert_policy = .{
            .bundle = config.client_auth_bundle,
            .insecure_no_chain_anchor = config.insecure_no_client_chain_anchor,
            .now_sec = config.client_auth_now_sec,
            .leaf_usage = .client_auth,
        },
        .ch_buf = if (config.reassembly) |buf| .init(buf) else .empty,
        .client_cert = if (config.client_cert_buffer) |buf| .init(buf) else .empty,
        .psk_lookup = config.psk_lookup,
        .early_data_skip_limit = config.early_data_skip_limit,
    };
}

/// Release backend handles and zero every secret this engine owns inline.
///
/// Does NOT touch caller-owned storage. The ClientHello reassembly buffer from
/// `useHandshakeBuffer`, the credential chain from `setCredentials`, and the
/// `RecordBuffer` storage are lent to the engine, so zeroing them is the
/// caller's call at the point they are declared. `self.* = undefined` is not a
/// wipe either: it is a no-op in ReleaseFast, which is why the secrets below
/// are cleared explicitly with volatile stores. See #81.
pub fn deinit(self: *ServerHandshake) void {
    switch (self.state) {
        .wait_client_finished, .connected => {
            self.rx.deinit();
            self.tx.deinit();
            if (self.early_rx) |*early_rx| early_rx.deinit();
            self.suite_state.secureZero();
        },
        // rx/tx and their backend contexts moved to the extracted
        // EstablishedSession and were already wiped at extraction
        // (secureZeroMovedFrom); never deinit them here. suite_state is this
        // engine's own duplicate of the secret bytes, so it is still wiped.
        .extracted => self.suite_state.secureZero(),
        .wait_ch => {},
    }
    self.keypairs.secureZero();
    self.fin_frag.secureZero();
    self.ku_frag.secureZero();
    self.client_leaf_pub_key.secureZero();
    self.* = undefined;
}

pub fn supportSuites(self: *ServerHandshake, suites: []const CipherSuite) void {
    assert(self.state == .wait_ch);
    self.supported_suites = suites;
}

pub fn supportAlpn(self: *ServerHandshake, protocols: root.AlpnProtocols) void {
    assert(self.state == .wait_ch);
    self.alpn_protocols = protocols;
}

/// Select and verify a PSK identity from a parsed ClientHello (RFC 8446
/// §4.2.11). For each offered identity, look up the PSK via `lookup`, derive
/// the binder key, compute the binder transcript hash over `msg[0..
/// parsed.binders_offset]`, and compare to the offered binder. Returns the
/// first verifying entry plus its index, or null if the client offered no PSK
/// or no identity verified. Malformed binders return an error.
pub fn selectPsk(
    parsed: client_hello.Parsed,
    msg: []const u8,
    lookup: PskLookup,
    negotiated_suite: CipherSuite,
) error{ InvalidExtensionLength, InvalidVectorLength, UnexpectedEof }!?struct {
    entry: PskEntry,
    identity_index: usize,
} {
    const selection = try selectPskWithTranscript(parsed, msg, lookup, negotiated_suite, null);
    return if (selection) |selected| .{
        .entry = selected.entry,
        .identity_index = selected.identity_index,
    } else null;
}

fn selectPskWithTranscript(
    parsed: client_hello.Parsed,
    msg: []const u8,
    lookup: PskLookup,
    negotiated_suite: CipherSuite,
    retry_transcript: ?*const RetryTranscript,
) error{ InvalidExtensionLength, InvalidVectorLength, UnexpectedEof }!?PskSelection {
    const psk_ext = parsed.psk_ext orelse return null;
    // PskOfferIter bounds both readers to their own vectors: a truncated or
    // slack-padded identities vector is a clean error, never the usize
    // underflow the unbounded inline walk had on `vector_end - pos`
    // (#103 review P1).
    var iter = try client_hello.PskOfferIter.init(psk_ext);

    const prefix = msg[0..parsed.binders_offset];
    var idx: usize = 0;
    while (try iter.next()) |offer| {
        if (lookup.lookup(lookup.context, offer.identity)) |entry| {
            if (entry.cipher_suite.hash() != negotiated_suite.hash()) {
                idx += 1;
                continue;
            }
            const ok = switch (entry.cipher_suite) {
                .aes_128_gcm_sha256, .chacha20_poly1305_sha256 => verifyBinderSha(
                    hkdf.HkdfSha256,
                    Sha256,
                    entry.psk,
                    prefix,
                    offer.binder,
                    if (retry_transcript) |rt| switch (rt.*) {
                        .sha256 => |*transcript| transcript,
                        .sha384 => unreachable,
                    } else null,
                ),
                .aes_256_gcm_sha384 => verifyBinderSha(
                    hkdf.HkdfSha384,
                    Sha384,
                    entry.psk,
                    prefix,
                    offer.binder,
                    if (retry_transcript) |rt| switch (rt.*) {
                        .sha256 => unreachable,
                        .sha384 => |*transcript| transcript,
                    } else null,
                ),
            };
            if (ok) return .{ .entry = entry, .identity_index = idx };
        }
        idx += 1;
    }
    return null;
}

fn verifyBinderSha(
    comptime H: type,
    comptime Hash: type,
    psk: []const u8,
    prefix: []const u8,
    offered_binder: []const u8,
    initial_transcript: ?*const Hash,
) bool {
    if (offered_binder.len != H.prk_len) return false;
    const early = H.pskEarlySecret(psk);
    const binder_key = H.resumptionBinderKey(early);
    const fin_key = H.finishedKey(.{ .data = binder_key.data });
    var transcript: Hash = if (initial_transcript) |initial| initial.* else .init(.{});
    transcript.update(prefix);
    const digest = transcript.peek();
    var th: H.TranscriptHash = undefined;
    @memcpy(th.data[0..], digest[0..]);
    const expected = H.binder(fin_key, &th);
    const Binder = [H.prk_len]u8;
    return std.crypto.timing_safe.eql(Binder, offered_binder[0..H.prk_len].*, expected);
}

/// Store caller-owned credentials for the authenticated server flight.
/// The certificate DER slices and the PrivateKey backing `signer` must outlive
/// this handshake. ztls keeps references; it does not copy or own credentials.
pub fn setCredentials(
    self: *ServerHandshake,
    certs_der: []const []const u8,
    signer: Signer,
) void {
    self.setCertificateChain(.init(certs_der), signer);
}

/// Store a caller-owned certificate chain and signer for the authenticated
/// server flight. See setCredentials for lifetime requirements.
pub fn setCertificateChain(self: *ServerHandshake, chain: CertificateChain, signer: Signer) void {
    assert(self.state == .wait_ch);
    self.server_credentials = .{ .chain = chain, .signer = signer };
}

/// Provide caller-owned storage for reassembling a fragmented plaintext
/// ClientHello/ClientHello2 across records. Without this, a fragmented
/// ClientHello is rejected with IncompleteRecord (maps to decode_error alert).
/// The storage must live at least until the handshake reaches
/// wait_client_finished. ch_reassembly_buffer_size is the recommended minimum.
///
/// The caller owns clearing it. Reassembled handshake plaintext stays in this
/// buffer after `deinit`, which never writes to memory it was lent; zero it
/// where it is declared if that matters to you. See #81.
pub fn useHandshakeBuffer(self: *ServerHandshake, storage: []u8) void {
    assert(self.state == .wait_ch);
    assert(self.ch_buf.len == 0);
    self.ch_buf = .init(storage);
}

/// Provide caller-owned storage for retaining the verified client leaf
/// certificate DER (see `clientCertificateDer`). Without it the leaf is
/// verified and discarded: `clientCertificateDer` returns null after the
/// handshake. Equivalent to `Config.client_cert_buffer`, for callers that
/// construct the engine before they own the storage. Must be called before
/// the handshake starts; the storage must outlive the engine. The caller owns
/// clearing it (#81): the retained DER survives `deinit` untouched.
///
/// RFC 8446 §4.4.2, §4.4.3.
pub fn useClientCertificateBuffer(self: *ServerHandshake, storage: []u8) void {
    assert(self.state == .wait_ch);
    assert(self.client_cert.buffer.len == 0);
    self.client_cert = .init(storage);
}

/// Return the selected ALPN protocol after the first ClientHello is processed.
/// After HelloRetryRequest, the value reflects ClientHello1 until ClientHello2
/// arrives; ClientHello2's offer is validated to match before this is updated.
/// A caller that continues after ignoring a rejected ClientHello2 must not treat
/// its changed offer as selected.
pub fn selectedAlpnProtocol(self: *const ServerHandshake) ?[]const u8 {
    return self.selected_alpn;
}

/// Return the cipher suite selected for this connection. Valid after the
/// ClientHello is accepted.
pub fn cipherSuite(self: *const ServerHandshake) CipherSuite {
    assert(self.state != .wait_ch);
    return self.suite;
}

/// Return the SNI hostname from the ClientHello server_name extension, or null
/// if the client did not send one. Available after the first handleRecord/
/// acceptClientHello call returns. After HelloRetryRequest, this reflects
/// ClientHello1 until ClientHello2 arrives; ClientHello2's SNI is validated to
/// match before this is updated. A caller that ignores a rejected ClientHello2
/// must not route using its changed SNI. Points into the caller's record buffer
/// — copy before the next call if you need it longer.
///
/// RFC 6066 §3 — server_name extension.
pub fn clientServerName(self: *const ServerHandshake) ?[]const u8 {
    return self.client_server_name;
}

/// Return the retained, verified client leaf certificate DER. Available only
/// after the handshake reaches the authenticated connected state. Null means
/// no client certificate was presented or no retention buffer was configured.
///
/// RFC 8446 §4.4.2, §4.4.3.
pub fn clientCertificateDer(self: *const ServerHandshake) ?[]const u8 {
    if (self.state != .connected) return null;
    if (self.client_cert.len == 0) return null;
    return self.client_cert.constSlice();
}

/// Parse the retained, verified client leaf certificate. See
/// `clientCertificateDer` for availability and absence semantics.
///
/// RFC 8446 §4.4.2, §4.4.3.
pub fn clientCertificate(self: *const ServerHandshake) ?Certificate.Parsed {
    const der = self.clientCertificateDer() orelse return null;
    const cert: Certificate = .{ .buffer = der, .index = 0 };
    return cert.parse() catch return null;
}

pub fn completeWrite(self: *ServerHandshake) void {
    self.pending_write.clear();
}

/// Most recent non-close_notify peer alert (RFC 8446 §6.2), or null if none.
/// A later peer alert replaces an earlier one; close_notify (§6.1) and
/// malformed records leave it unchanged. If another task owns RX through
/// `receiveRecord`, read this only after that task joins.
pub fn lastPeerAlert(self: *const ServerHandshake) ?alert.Alert {
    return self.last_peer_alert;
}

/// Extract the compact established-session engine at handshake completion.
/// Call exactly once, while `isConnected()`: the returned session owns the
/// traffic record layers, their sequences, and their backend contexts from
/// here on, plus the application traffic secrets, the KeyUpdate reassembly
/// fragment, the consecutive-KeyUpdate counter, the last peer alert, any owed
/// KeyUpdate response, and the pending-write latch. A KeyUpdate response owed
/// at the completion boundary, or a KeyUpdate fragment reassembled across the
/// extraction point, carries over exactly.
///
/// Everything only needed during the handshake stays here and is NOT carried
/// over: flight staging, ClientHello reassembly, the transcript, key exchange,
/// PSK/early-data state, and ticket machinery. Issue NewSessionTickets (and
/// discard any prepared one) BEFORE extracting — the established session can
/// neither prepare nor send tickets.
///
/// Both record directions must be userspace when extracting. TX ownership is
/// tracked and asserted (`tx_owner`); RX ownership is not, so it is a caller
/// contract: a kernel-installed RX leaves this session's userspace RX sequence
/// stale, and misuse fails loudly (AuthenticationFailed). kTLS callers keep
/// using this engine in both directions.
///
/// `self` transitions to `.extracted` and must not be used again except to
/// `deinit` it. Extraction wipes the moved-from record layers; deinit wipes
/// the remaining duplicated traffic secrets and handshake keypairs without
/// releasing the session's contexts. Deinit before re-initializing a pooled
/// handshake engine.
pub fn extractEstablished(self: *ServerHandshake) EstablishedSession {
    assert(self.state == .connected);
    assert(self.tx_owner == .userspace);
    assert(self.early_rx == null);
    assert(!self.hasPendingTicket());
    const established: EstablishedSession = .{
        .rx = self.rx,
        .tx = self.tx,
        .suite = self.suite_state,
        .ku_frag = self.ku_frag,
        .post_handshake_count = self.post_handshake_count,
        .last_peer_alert = self.last_peer_alert,
        .key_update_obligation = self.key_update_obligation,
        .pending_write = self.pending_write,
    };
    // Ownership of the backend AEAD contexts in rx/tx moves with the copy;
    // this engine must never deinit or use them again. Wipe the bytes left
    // behind immediately — without freeing the moved contexts — so no
    // duplicate traffic-key material survives in the pooled engine: on the
    // inline-context backends (AWS-LC, BoringSSL) those bytes ARE the live
    // keys, and on OpenSSL they are the key/IV duplicates plus stale context
    // pointers. This covers the pool that never deinits the slot, too.
    self.rx.secureZeroMovedFrom();
    self.tx.secureZeroMovedFrom();
    self.state = .extracted;
    return established;
}

pub fn isConnected(self: *const ServerHandshake) bool {
    return self.state == .connected;
}

/// True when this connection authenticated with a caller-provided PSK.
/// Ticket policy can use this to bound chains of resumed sessions.
pub fn isResumed(self: *const ServerHandshake) bool {
    assert(self.state == .connected);
    return self.selected_psk != null;
}

/// Prepare caller-owned key material for one NewSessionTicket. ztls assigns a
/// unique nonce from a bounded 32-ticket sequence and derives the matching PSK;
/// the caller uses the PSK to stage a stateful lookup row or build an
/// authenticated stateless identity, then passes this object unchanged to
/// `sendNewSessionTicket`.
///
/// Ticket storage, expiration, rotation, replay handling, chain lifetime, and
/// any client-auth identity carried across resumption remain caller policy.
/// RFC 8446 §4.6.1.
pub fn deriveTicketPsk(self: *ServerHandshake) PrepareTicketError!TicketPsk {
    assert(self.state == .connected);
    if (self.tx_owner == .kernel) return error.KtlsTxActive;
    if (self.ticket_compatibility != .psk_dhe_ke)
        return error.IncompatiblePskModes;
    const nonce = switch (self.ticket_nonce_state) {
        .next => |next| next,
        .prepared => return error.PendingTicket,
    };
    if (nonce >= max_new_session_tickets) return error.TooManyNewSessionTickets;

    var ticket: TicketPsk = .{
        .cipher_suite = self.suite,
        .ticket_nonce = .{nonce},
    };
    switch (self.suite_state) {
        inline .sha256, .sha384 => |*s| {
            if (!s.resumption_master_valid) return error.NoResumptionSecret;
            var psk = @TypeOf(s.*).Hkdf.resumptionPsk(
                s.resumption_master,
                &ticket.ticket_nonce,
            );
            defer psk.secureZero();
            ticket.psk.appendSliceAssumeCapacity(&psk.data);
        },
    }
    self.ticket_nonce_state = .{ .prepared = nonce };
    return ticket;
}

/// Abandon one prepared ticket without sending it. Its nonce is burned, so a
/// later ticket cannot reuse the derived PSK. The supplied key material is erased.
pub fn discardTicketPsk(
    self: *ServerHandshake,
    ticket: *TicketPsk,
) error{InvalidTicketPsk}!void {
    const nonce = switch (self.ticket_nonce_state) {
        .prepared => |prepared| prepared,
        .next => return error.InvalidTicketPsk,
    };
    if (ticket.ticket_nonce[0] != nonce) return error.InvalidTicketPsk;
    self.ticket_nonce_state = .{ .next = nonce + 1 };
    ticket.secureZero();
}

/// True while wire bytes returned by the engine still await transport
/// acknowledgement through `completeWrite()`.
pub fn hasPendingWrite(self: *const ServerHandshake) bool {
    return self.pending_write.isPending();
}

/// True after ticket key material has been prepared but before the ticket is
/// emitted or explicitly discarded.
pub fn hasPendingTicket(self: *const ServerHandshake) bool {
    return self.ticket_nonce_state == .prepared;
}

/// RFC 8446 §4.6.3 — true after receiving update_requested until the required
/// update_not_requested response has been generated.
pub fn hasPendingKeyUpdateResponse(self: *const ServerHandshake) bool {
    return self.key_update_obligation == .response_owed;
}

pub fn needsServerFlight(self: *const ServerHandshake) bool {
    return self.state == .wait_client_finished;
}

/// Connected-state event shape, shared with the extracted EstablishedSession
/// (see handshake.zig).
pub const Event = handshake.Event;

/// Connected-state receive result. This path owns only RX state, so callers can
/// process inbound records while an unrelated TX record remains in flight.
pub const ReceiveEvent = handshake.ReceiveEvent;

/// Surfaced when a peer KeyUpdate changes one or both traffic-key epochs.
pub const KeyUpdateEvent = handshake.KeyUpdateEvent;

pub const AcceptError =
    frame.ParseError || client_hello.ParseError || server_hello.EncodeError || aead.Error ||
    hybrid_kex.Error || ConfigError || error{
        IncompleteRecord,
        UnexpectedRecord,
        UnsupportedCipherSuite,
        NoApplicationProtocol,
        IdentityElement,
        IllegalParameter,
        LibcryptoFailed,
        TooManyPskIdentities,
    };

pub const FlightError =
    encrypted_extensions.EncodeError ||
    certificate_request.EncodeError ||
    certificate.EncodeError ||
    RecordLayer.EncryptError ||
    SignError ||
    error{ MissingServerCredentials, PendingWrite };

pub const ClientFinishedError =
    RecordLayer.DecryptError ||
    finished.VerifyError ||
    frame.ParseError ||
    certificate.ParseError ||
    certificate.VerifyError ||
    error{
        UnexpectedRecord,
        UnexpectedMessage,
        ClientCertificateRequired,
        UnsupportedClientCertificate,
        CertificateKeyTooLarge,
        ClientCertificateTooLarge,
    };

pub const SendError = handshake.SendError;
pub const PrepareTicketError = error{
    NoResumptionSecret,
    IncompatiblePskModes,
    PendingTicket,
    TooManyNewSessionTickets,
    KtlsTxActive,
};
pub const TicketSendError = SendError || NewSessionTicket.EncodeError || error{
    InvalidTicketPsk,
    IncompatiblePskModes,
    KtlsTxActive,
};
pub const KtlsTxTransferError = error{
    PendingWrite,
    PendingKeyUpdateResponse,
    PendingTicket,
};
pub const ReceiveError = handshake.ReceiveError;
pub const HandleError =
    AcceptError || FlightError || ClientFinishedError ||
    ReceiveError || SendError || alert.ParseError ||
    error{ PendingWrite, EarlyDataSkipLimitExceeded };
pub const AlertError = handshake.AlertError;

/// Consume a plaintext ClientHello record and emit a plaintext ServerHello
/// record. The returned bytes must be written before continuing the handshake.
/// Installs handshake traffic keys for the encrypted server flight.
/// RFC 8446 §4.1.2, §4.1.3, §5.1, §7.1.
// ziglint-ignore: Z015 -- AcceptError is a public error-set alias.
pub fn acceptClientHello(
    self: *ServerHandshake,
    record: []const u8,
    out: []u8,
) AcceptError![]const u8 {
    assert(self.state == .wait_ch);
    assert(self.ch_buf.len == 0); // no reassembly in progress
    const hdr = try frame.parseHeader(record);
    if (hdr.content_type != .handshake) return error.UnexpectedRecord;
    if (record.len < frame.header_len + hdr.length()) return error.IncompleteRecord;
    return self.processClientHelloMessage(record[frame.header_len..][0..hdr.length()], out);
}

/// Parse and process a complete ClientHello handshake message (4-byte header +
/// body). Called by acceptClientHello (fast path from a single record) and by
/// handleClientHelloRecord (after fragment reassembly).
/// Clear 0-RTT/PSK selection state installed while inspecting a ClientHello
/// and arm the §4.2.10 HRR early-data skip window when that ClientHello
/// offered early_data. RFC 8446 §4.1.2/§4.2.10 — 0-RTT does not survive
/// HelloRetryRequest: a retained PSK must be selected again from ClientHello2
/// after its binder is recomputed over the retry transcript, and the client's
/// already-in-flight 0-RTT records must be skipped while ClientHello2 is
/// pending. Without this reset, a ClientHello2 that offers no acceptable PSK
/// could inherit stale selection or early_rx state from ClientHello1.
fn resetEarlyDataStateForRetry(self: *ServerHandshake, offered_early_data: bool) void {
    if (self.early_rx) |*early_rx| early_rx.deinit();
    self.early_rx = null;
    self.early_data_limit = null;
    self.early_data_received = 0;
    self.end_of_early_data_received = false;
    self.early_data_skip = if (offered_early_data) .await_client_hello2 else .off;
    self.early_data_skip_bytes = 0;
    self.selected_psk = null;
    self.selected_psk_index = 0;
}

fn supportsHybridGroup(self: *const ServerHandshake, group: NamedGroup) bool {
    const spec = group.hybridSpec() orelse return false;
    if (!backend.supportsServerHybridGroup(group)) return false;
    if (spec.classical_group == .secp384r1 and self.keypairs.p384 == null)
        return false;
    return mem.indexOfScalar(NamedGroup, self.hybrid_groups, group) != null;
}

fn validateHybridGroups(self: *const ServerHandshake) ConfigError!void {
    try validateHybridPolicy(self.hybrid_groups, &self.keypairs);
}

fn validateHybridPolicy(groups: []const NamedGroup, keypairs: *const KeyPairs) ConfigError!void {
    try capabilities.validateHybridGroups(.server, groups);
    if (capabilities.requiresP384(groups) and keypairs.p384 == null)
        return error.MissingP384KeyPair;
}

fn preferredHybridGroup(
    self: *const ServerHandshake,
    groups: client_hello.SupportedGroups,
) ?NamedGroup {
    for (self.hybrid_groups) |group| {
        if (groups.contains(group) and self.supportsHybridGroup(group)) return group;
    }
    return null;
}

fn preferredHybridShare(
    self: *const ServerHandshake,
    shares: []const client_hello.ParsedKemKeyShare,
) ?*const client_hello.ParsedKemKeyShare {
    for (self.hybrid_groups) |group| {
        for (shares) |*share| {
            if (share.group == group and self.supportsHybridGroup(group)) return share;
        }
    }
    return null;
}

fn encapsulateHybrid(
    self: *const ServerHandshake,
    share: *const client_hello.ParsedKemKeyShare,
    server_share: *ArrayBuffer(u8, hybrid_kex.max_server_share_len),
    shared_secret: *ArrayBuffer(u8, hybrid_kex.max_shared_secret_len),
) hybrid_kex.Error!void {
    assert(server_share.len == 0);
    assert(shared_secret.len == 0);
    const result = try hybrid_kex.encapsulate(
        share.group,
        share.data,
        &self.keypairs,
        server_share.unusedCapacitySlice(),
        shared_secret.unusedCapacitySlice(),
    );
    server_share.resize(@intCast(result.server_share.len));
    shared_secret.resize(@intCast(result.shared_secret.len));
}

fn selectHybridShare(
    self: *const ServerHandshake,
    share: *const client_hello.ParsedKemKeyShare,
    server_share: *ArrayBuffer(u8, hybrid_kex.max_server_share_len),
    shared_secret: *ArrayBuffer(u8, hybrid_kex.max_shared_secret_len),
) hybrid_kex.Error!ClientKeyShare {
    // Once a configured hybrid share is selected, malformed key material or
    // provider failure aborts. There is no classical fallback after selection.
    try self.encapsulateHybrid(share, server_share, shared_secret);
    return .{ .kem = share.* };
}

fn processClientHelloMessage(
    self: *ServerHandshake,
    ch_msg: []const u8,
    out: []u8,
) AcceptError![]const u8 {
    assert(self.state == .wait_ch);
    assert((self.retry_transcript == null) == (self.retry_ch1_digest == null));
    // RFC 8446 §4.2.10 — ClientHello2 closes the HRR early-data skip window.
    // The window is armed only by the HelloRetryRequest response to
    // ClientHello1, so any ClientHello processed while it is open is
    // ClientHello2 (or an impostor the §4.1.2 retry validation below rejects
    // either way); application_data is no longer skippable afterwards.
    if (self.early_data_skip == .await_client_hello2) {
        self.early_data_skip = .off;
        self.early_data_skip_bytes = 0;
    }
    try self.validateHybridGroups();
    const ch = try client_hello.parse(ch_msg);
    if (self.retry_ch1_digest) |ch1_digest| {
        const ch2_digest = retryClientHelloDigest(&ch);
        if (!mem.eql(u8, &ch1_digest, &ch2_digest)) return error.IllegalParameter;
        // RFC 8446 §4.1.2 — the pre_shared_key identities are the one field
        // the stable-field digest cannot cover: ages and binders may be
        // recomputed and hash-incompatible identities may be dropped (by
        // lookup entry or binder length, see retryPskRetention), while
        // added, replaced, reordered, or retained-but-dropped identities
        // are illegal.
        try self.enforceRetryPskContinuity(&ch);
    }
    // RFC 8446 §4.1.2, §4.2.10 — early_data MUST be removed in ClientHello2;
    // 0-RTT is not compatible with HelloRetryRequest.
    if (self.retry_ch1_digest != null and ch.offered_early_data)
        return error.IllegalParameter;
    const suite = if (self.retry_transcript == null)
        self.chooseSuite(ch) orelse return error.UnsupportedCipherSuite
    else
        self.suite;
    self.suite = suite;
    self.selected_alpn = ch.selectAlpn(self.alpn_protocols);
    if (ch.alpn_protocols.len != 0 and self.alpn_protocols.len != 0 and self.selected_alpn == null)
        return error.NoApplicationProtocol;
    self.client_server_name = ch.server_name;

    // RFC 8446 §4.2.9 — issue and accept tickets only for the forward-secret
    // psk_dhe_ke mode ztls implements. Preserve the offer through the handshake
    // so post-handshake emission cannot create an unusable ticket.
    const offers_psk_dhe_ke = if (ch.psk_key_exchange_modes) |modes|
        mem.indexOfScalar(
            u8,
            modes,
            @intFromEnum(client_hello.PskKeyExchangeMode.psk_dhe_ke),
        ) != null
    else
        false;
    self.ticket_compatibility = if (offers_psk_dhe_ke) .psk_dhe_ke else .unavailable;

    // RFC 8446 §4.2.9 — pre_shared_key requires psk_key_exchange_modes.
    if (ch.psk_ext != null) {
        if (ch.psk_key_exchange_modes == null) return error.MissingExtension;
        // A PSK does not implicitly carry a client-certificate identity. When
        // fresh client authentication is configured, decline resumption and run
        // the authenticated handshake instead.
        if (offers_psk_dhe_ke and self.client_auth == .none) {
            if (self.psk_lookup) |lookup| {
                const retry_transcript: ?*const RetryTranscript =
                    if (self.retry_transcript) |*transcript| transcript else null;
                const selection = try selectPskWithTranscript(
                    ch,
                    ch_msg,
                    lookup,
                    suite,
                    retry_transcript,
                );
                if (selection) |sel| {
                    self.selected_psk = sel.entry;
                    self.selected_psk_index = @intCast(sel.identity_index);
                    // 0-RTT (RFC 8446 §4.2.10): if the client offered early_data,
                    // install the early traffic RX key for decrypting 0-RTT records.
                    // The early traffic secret uses Hash(ClientHello) as the
                    // transcript hash (the full CH, including the binder).
                    if (ch.offered_early_data and sel.entry.max_early_data_size != null) {
                        self.early_data_limit = sel.entry.max_early_data_size;
                        switch (sel.entry.cipher_suite) {
                            .aes_128_gcm_sha256, .chacha20_poly1305_sha256 => {
                                const H = hkdf.HkdfSha256;
                                const early = H.pskEarlySecret(sel.entry.psk);
                                var th: H.TranscriptHash = undefined;
                                Sha256.hash(ch_msg, &th.data, .{});
                                const early_traffic = H.clientEarlyTrafficSecret(early, &th);
                                self.early_rx = try H.makeRecordLayer(
                                    sel.entry.cipher_suite,
                                    early_traffic,
                                );
                            },
                            .aes_256_gcm_sha384 => {
                                const H = hkdf.HkdfSha384;
                                const early = H.pskEarlySecret(sel.entry.psk);
                                var th: H.TranscriptHash = undefined;
                                Sha384.hash(ch_msg, &th.data, .{});
                                const early_traffic = H.clientEarlyTrafficSecret(early, &th);
                                self.early_rx = try H.makeRecordLayer(
                                    sel.entry.cipher_suite,
                                    early_traffic,
                                );
                            },
                        }
                    }
                }
            }
        }
    }

    // RFC 10024 hybrid outputs remain in fixed-capacity stack storage. The
    // secret is zeroed after the key schedule consumes it.
    var hybrid_server_share: ArrayBuffer(u8, hybrid_kex.max_server_share_len) = .empty;
    var hybrid_secret: ArrayBuffer(u8, hybrid_kex.max_shared_secret_len) = .empty;
    defer hybrid_secret.secureZero();

    const client_key_share: ClientKeyShare = if (self.retry_selected_group) |selected_group|
        switch (selected_group) {
            .x25519 => if (backend.supportsServerX25519()) blk: {
                if (ch.public_key) |public_key| {
                    if (ch.public_key_p256 != null or ch.public_key_p384 != null or
                        ch.hybrid_key_shares.len != 0)
                    {
                        return error.IllegalParameter;
                    }
                    break :blk .{ .x25519 = public_key };
                }
                return error.IllegalParameter;
            } else return error.IllegalParameter,
            .secp256r1 => if (backend.supportsServerP256()) blk: {
                if (ch.public_key_p256) |public_key| {
                    if (ch.public_key != null or ch.public_key_p384 != null or
                        ch.hybrid_key_shares.len != 0)
                    {
                        return error.IllegalParameter;
                    }
                    break :blk .{ .secp256r1 = public_key };
                }
                return error.IllegalParameter;
            } else return error.IllegalParameter,
            .secp384r1 => if ((backend.supportsServerP384() and self.keypairs.p384 != null)) blk: {
                if (ch.public_key_p384) |public_key| {
                    if (ch.public_key != null or ch.public_key_p256 != null or
                        ch.hybrid_key_shares.len != 0)
                    {
                        return error.IllegalParameter;
                    }
                    break :blk .{ .secp384r1 = public_key };
                }
                return error.IllegalParameter;
            } else return error.IllegalParameter,
            .x25519_mlkem768,
            .secp256r1_mlkem768,
            .secp384r1_mlkem1024,
            => blk: {
                if (!self.supportsHybridGroup(selected_group)) return error.IllegalParameter;
                if (ch.public_key != null or ch.public_key_p256 != null or
                    ch.public_key_p384 != null)
                {
                    return error.IllegalParameter;
                }
                if (ch.hybrid_key_shares.len != 1) return error.IllegalParameter;
                const share = &ch.hybrid_key_shares.constSlice()[0];
                if (share.group != selected_group) return error.IllegalParameter;
                try self.encapsulateHybrid(share, &hybrid_server_share, &hybrid_secret);
                break :blk .{ .kem = share.* };
            },
            else => return error.IllegalParameter,
        }
    else if (self.preferredHybridShare(ch.hybrid_key_shares.constSlice())) |share|
        try self.selectHybridShare(share, &hybrid_server_share, &hybrid_secret)
    else if (self.preferredHybridGroup(ch.groups)) |group| {
        const hrr = try self.encodeHelloRetryRequest(
            ch_msg,
            &ch,
            ch.legacy_session_id,
            suite,
            group,
            out,
        );
        self.resetEarlyDataStateForRetry(ch.offered_early_data);
        self.state = .wait_ch;
        return hrr;
    } else if (ch.public_key != null and backend.supportsServerX25519())
        .{ .x25519 = ch.public_key.? }
    else if (ch.public_key_p256 != null and backend.supportsServerP256())
        .{ .secp256r1 = ch.public_key_p256.? }
    else if (ch.public_key_p384 != null and
        (backend.supportsServerP384() and self.keypairs.p384 != null))
        .{ .secp384r1 = ch.public_key_p384.? }
    else if (ch.groups.contains(.x25519) and backend.supportsServerX25519()) {
        const hrr = try self.encodeHelloRetryRequest(
            ch_msg,
            &ch,
            ch.legacy_session_id,
            suite,
            .x25519,
            out,
        );
        self.resetEarlyDataStateForRetry(ch.offered_early_data);
        self.state = .wait_ch;
        return hrr;
    } else if (ch.groups.contains(.secp256r1) and backend.supportsServerP256()) {
        const hrr = try self.encodeHelloRetryRequest(
            ch_msg,
            &ch,
            ch.legacy_session_id,
            suite,
            .secp256r1,
            out,
        );
        self.resetEarlyDataStateForRetry(ch.offered_early_data);
        self.state = .wait_ch;
        return hrr;
    } else if (ch.groups.contains(.secp384r1) and
        (backend.supportsServerP384() and self.keypairs.p384 != null))
    {
        const hrr = try self.encodeHelloRetryRequest(
            ch_msg,
            &ch,
            ch.legacy_session_id,
            suite,
            .secp384r1,
            out,
        );
        self.resetEarlyDataStateForRetry(ch.offered_early_data);
        self.state = .wait_ch;
        return hrr;
    } else return error.UnsupportedKeyShare;

    self.negotiated_group = switch (client_key_share) {
        .x25519 => .x25519,
        .secp256r1 => .secp256r1,
        .secp384r1 => .secp384r1,
        .kem => |*share| share.group,
    };

    const server_key_share: server_hello.KeyShare = switch (client_key_share) {
        .x25519 => .{ .x25519 = self.keypairs.x25519.public_key },
        .secp256r1 => .{ .secp256r1 = self.keypairs.p256.public_key },
        .secp384r1 => .{ .secp384r1 = (self.keypairs.p384 orelse unreachable).public_key },
        .kem => |*share| .{ .kem = .{
            .group = share.group,
            .data = hybrid_server_share,
        } },
    };

    const sh = if (self.selected_psk != null)
        try server_hello.encodeWithKeyShareAndPsk(
            out[frame.header_len..],
            self.random.data,
            ch.legacy_session_id,
            suite,
            &server_key_share,
            self.selected_psk_index,
        )
    else
        try server_hello.encodeWithKeyShare(
            out[frame.header_len..],
            self.random.data,
            ch.legacy_session_id,
            suite,
            &server_key_share,
        );
    const header: frame.Header = .init(.handshake, @intCast(sh.len));
    header.write(out[0..frame.header_len]);

    var out_len = frame.header_len + sh.len;
    // RFC 8446 Appendix D.4 — send at most one compatibility CCS. The HRR
    // path already sent it after ClientHello1.
    if (ch.legacy_session_id.len != 0 and self.retry_selected_group == null) {
        out_len += try appendCompatibilityChangeCipherSpec(out[out_len..]);
    }

    try self.installHandshakeKeys(
        suite,
        ch_msg,
        sh,
        &client_key_share,
        &hybrid_secret,
    );
    // RFC 8446 §4.2.10 — the client may already have 0-RTT records in flight
    // under the early traffic key even though this server declined its
    // early_data offer (no PSK selected, or the selected ticket permits no
    // early data). Skip them by trial-deprotection with the handshake key
    // until the second flight begins. The HelloRetryRequest decline variant
    // (skip all outer application_data records while waiting for ClientHello2)
    // is armed by resetEarlyDataStateForRetry at the HRR branches.
    if (ch.offered_early_data and self.early_rx == null) {
        self.early_data_skip = .trial_decrypt;
        self.early_data_skip_bytes = 0;
    }
    self.state = .wait_client_finished;
    return out[0..out_len];
}

fn appendCompatibilityChangeCipherSpec(out: []u8) server_hello.EncodeError!usize {
    if (out.len < compatibility_ccs_len) return error.BufferTooShort;
    const header: frame.Header = .init(.change_cipher_spec, 1);
    header.write(out[0..frame.header_len]);
    out[frame.header_len] = 0x01;
    return compatibility_ccs_len;
}

fn encodeHelloRetryRequest(
    self: *ServerHandshake,
    ch_msg: []const u8,
    ch: *const client_hello.Parsed,
    legacy_session_id: []const u8,
    suite: CipherSuite,
    selected_group: NamedGroup,
    out: []u8,
) (server_hello.EncodeError || RetryPskCaptureError)![]const u8 {
    const hrr = try server_hello.encodeHelloRetryRequest(
        out[frame.header_len..],
        legacy_session_id,
        suite,
        selected_group,
    );
    const header: frame.Header = .init(.handshake, @intCast(hrr.len));
    header.write(out[0..frame.header_len]);
    self.retry_transcript = makeRetryTranscript(suite, ch_msg, hrr);
    self.retry_ch1_digest = retryClientHelloDigest(ch);
    self.retry_psk = try captureRetryPskIdentities(ch.psk_ext, self.psk_lookup, suite);
    self.retry_selected_group = selected_group;
    var out_len = frame.header_len + hrr.len;
    if (legacy_session_id.len != 0) {
        out_len += try appendCompatibilityChangeCipherSpec(out[out_len..]);
    }
    return out[0..out_len];
}

fn retryClientHelloDigest(ch: *const client_hello.Parsed) RetryClientHelloDigest {
    var hash: Sha256 = .init(.{});
    retryClientHelloDigestUpdateOptional(&hash, ch.server_name);
    retryClientHelloDigestUpdate(&hash, ch.alpn_protocols);
    retryClientHelloDigestUpdate(&hash, ch.cipher_suites);
    retryClientHelloDigestUpdate(&hash, ch.signature_schemes);
    retryClientHelloDigestUpdateOptional(&hash, ch.psk_key_exchange_modes);

    const group_fields = std.meta.fields(NamedGroup);
    var groups: [group_fields.len]u8 = undefined;
    inline for (group_fields, 0..) |field, index| {
        const group: NamedGroup = @enumFromInt(field.value);
        groups[index] = @intFromBool(ch.groups.contains(group));
    }
    retryClientHelloDigestUpdate(&hash, &groups);
    retryClientHelloDigestUpdate(&hash, ch.legacy_session_id);

    var digest: RetryClientHelloDigest = undefined;
    hash.final(&digest);
    return digest;
}

fn retryClientHelloDigestUpdate(hash: *Sha256, bytes: []const u8) void {
    assert(bytes.len <= std.math.maxInt(u16));
    var length: [2]u8 = undefined;
    memx.writeInt(u16, &length, @intCast(bytes.len));
    hash.update(&length);
    hash.update(bytes);
}

fn retryClientHelloDigestUpdateOptional(hash: *Sha256, bytes: ?[]const u8) void {
    const presence: [1]u8 = .{@intFromBool(bytes != null)};
    hash.update(&presence);
    retryClientHelloDigestUpdate(hash, bytes orelse &.{});
}

/// Errors from walking a pre_shared_key offer list. Explicit rather
/// than composed from `client_hello.PskOfferIter.Error` so a new iterator
/// error surfaces as a compile error here, not a silent gap (ziglint Z015
/// does not follow composed public aliases).
const RetryPskCaptureError = error{
    InvalidExtensionLength,
    InvalidVectorLength,
    UnexpectedEof,
    /// ClientHello1 offers more PSK identities than
    /// max_retry_psk_identities and the server must retain them across a
    /// HelloRetryRequest (RFC 8446 §4.1.2). Bounded admission: the engine's
    /// retention is fixed-capacity and allocation-free, so the handshake is
    /// refused rather than silently degrading. Maps to handshake_failure.
    TooManyPskIdentities,
};
const RetryPskContinuityError = RetryPskCaptureError || error{IllegalParameter};

fn retryPskFingerprint(identity: []const u8) RetryPskFingerprint {
    var digest: [Sha256.digest_length]u8 = undefined;
    Sha256.hash(identity, &digest, .{});
    return digest[0..16].*; // truncated SHA-256, see RetryPskFingerprint
}

/// Retain ClientHello1's PSK identity continuity metadata for ClientHello2
/// validation (RFC 8446 §4.1.2). `hrr_suite` is the cipher suite carried in
/// the HelloRetryRequest; the client may drop only identities whose PSK
/// hash conflicts with it. See RetryPskRetention for how the hash is
/// determined for lookup-resolved and unknown identities.
///
/// `lookup` is called here for every offered identity even though
/// selectPskWithTranscript already called it during ClientHello1 PSK
/// selection (and will call it again for ClientHello2): PskLookup
/// implementations must tolerate repeated calls for the same identity
/// within a handshake and stay side-effect-free.
fn captureRetryPskIdentities(
    psk_ext: ?[]const u8,
    lookup: ?PskLookup,
    hrr_suite: CipherSuite,
) RetryPskCaptureError!RetryPskCapture {
    const ext = psk_ext orelse return .none;
    var identities: ArrayBuffer(RetryPskIdentity, max_retry_psk_identities) = .empty;
    var iter = try client_hello.PskOfferIter.init(ext);
    while (try iter.next()) |offer| {
        const entry: RetryPskIdentity = .{
            .fingerprint = retryPskFingerprint(offer.identity),
            .retention = retryPskRetention(offer, lookup, hrr_suite),
        };
        // Bounded admission: exceeding the fixed capacity refuses the
        // ClientHello1 instead of degrading the §4.1.2 continuity rule.
        identities.append(entry) catch return error.TooManyPskIdentities;
    }
    return .{ .identities = identities };
}

/// Removal rule for one ClientHello1 identity under the HelloRetryRequest
/// cipher suite. Lookup-resolved identities carry the hash of the entry's
/// cipher suite. For identities the lookup cannot resolve, the binder
/// length is the hash output of the PSK's cipher suite (RFC 8446
/// §4.2.11.2: the binder is an HMAC over the transcript hash,
/// Finished-style), so a binder matching the HRR suite's hash length claims
/// a compatible hash and the identity must be retained; any other length
/// claims a different hash family — no binder of that length can verify
/// under the HRR suite anyway — so the identity may be dropped.
fn retryPskRetention(
    offer: client_hello.PskOffer,
    lookup: ?PskLookup,
    hrr_suite: CipherSuite,
) RetryPskRetention {
    if (lookup) |l| {
        if (l.lookup(l.context, offer.identity)) |psk| {
            return if (psk.cipher_suite.hash() == hrr_suite.hash())
                .must_retain
            else
                .may_remove;
        }
    }
    const hrr_hash_len: usize = switch (hrr_suite.hash()) {
        .sha256 => Sha256.digest_length,
        .sha384 => Sha384.digest_length,
    };
    return if (offer.binder.len == hrr_hash_len) .must_retain else .may_remove;
}

/// RFC 8446 §4.1.2 — validate ClientHello2's pre_shared_key identities
/// against the ClientHello1 metadata captured at HelloRetryRequest time.
/// The identity list must be ClientHello1's, in offer order, minus identities
/// the server proved droppable (hash-incompatible per lookup entry or
/// binder length). Ages and binders are not compared: §4.1.2 permits
/// recomputing them. Addition, replacement, reordering, and dropping a
/// must-retain identity are all illegal_parameter.
fn enforceRetryPskContinuity(
    self: *const ServerHandshake,
    ch: *const client_hello.Parsed,
) RetryPskContinuityError!void {
    switch (self.retry_psk) {
        .none => if (ch.psk_ext != null) return error.IllegalParameter,
        .identities => |identities| {
            const retained = identities.constSlice();
            var next_index: usize = 0;
            if (ch.psk_ext) |ext| {
                var iter = try client_hello.PskOfferIter.init(ext);
                while (try iter.next()) |offer| {
                    const fingerprint = retryPskFingerprint(offer.identity);
                    // Advance past ClientHello1 identities this offer skips:
                    // each skipped identity was dropped and must be droppable.
                    while (next_index < retained.len and
                        !mem.eql(u8, &retained[next_index].fingerprint, &fingerprint))
                    {
                        if (retained[next_index].retention == .must_retain)
                            return error.IllegalParameter;
                        next_index += 1;
                    }
                    // No remaining ClientHello1 identity matches: this
                    // identity was added or substituted.
                    if (next_index == retained.len) return error.IllegalParameter;
                    next_index += 1;
                }
            }
            // Identities left over after the last match were dropped.
            while (next_index < retained.len) : (next_index += 1) {
                if (retained[next_index].retention == .must_retain)
                    return error.IllegalParameter;
            }
        },
    }
}

fn makeRetryTranscript(
    suite: CipherSuite,
    ch_msg: []const u8,
    hrr_msg: []const u8,
) RetryTranscript {
    return switch (suite) {
        .aes_128_gcm_sha256, .chacha20_poly1305_sha256 => blk: {
            var ch1_hash: [Sha256.digest_length]u8 = undefined;
            Sha256.hash(ch_msg, &ch1_hash, .{});
            const synthetic = transcript_util.messageHashSynthetic(Sha256.digest_length, ch1_hash);
            var transcript: Sha256 = .init(.{});
            transcript.update(&synthetic);
            transcript.update(hrr_msg);
            break :blk .{ .sha256 = transcript };
        },
        .aes_256_gcm_sha384 => blk: {
            var ch1_hash: [Sha384.digest_length]u8 = undefined;
            Sha384.hash(ch_msg, &ch1_hash, .{});
            const synthetic = transcript_util.messageHashSynthetic(Sha384.digest_length, ch1_hash);
            var transcript: Sha384 = .init(.{});
            transcript.update(&synthetic);
            transcript.update(hrr_msg);
            break :blk .{ .sha384 = transcript };
        },
    };
}

fn installHandshakeKeys(
    self: *ServerHandshake,
    suite: CipherSuite,
    ch_msg: []const u8,
    sh_msg: []const u8,
    client_key_share: *const ClientKeyShare,
    hybrid_secret: *const ArrayBuffer(u8, hybrid_kex.max_shared_secret_len),
) (error{ IdentityElement, LibcryptoFailed } || aead.Error)!void {
    var dhe: [80]u8 = undefined;
    const dhe_len: usize = switch (client_key_share.*) {
        .x25519 => |public_key| blk: {
            const secret = try x25519.sharedSecret(self.keypairs.x25519.secret_key, public_key);
            @memcpy(dhe[0..32], &secret);
            break :blk @as(usize, 32);
        },
        .secp256r1 => |public_key| blk: {
            const secret = try p256.sharedSecret(self.keypairs.p256.secret_key, public_key);
            @memcpy(dhe[0..32], &secret);
            break :blk @as(usize, 32);
        },
        .secp384r1 => |public_key| blk: {
            const keypair = self.keypairs.p384 orelse unreachable;
            const secret = try p384.sharedSecret(keypair.secret_key, public_key);
            @memcpy(dhe[0..48], &secret);
            break :blk @as(usize, 48);
        },
        // RFC 10024 §4.3 — use the precomputed combined shared secret.
        .kem => blk: {
            const secret = hybrid_secret.constSlice();
            if (secret.len == 0) return error.LibcryptoFailed;
            @memcpy(dhe[0..secret.len], secret);
            break :blk secret.len;
        },
    };
    defer std.crypto.secureZero(u8, dhe[0..dhe_len]);
    switch (suite) {
        .aes_128_gcm_sha256, .chacha20_poly1305_sha256 => {
            var transcript: Sha256 = if (self.retry_transcript) |rt| switch (rt) {
                .sha256 => |t| t,
                .sha384 => unreachable,
            } else .init(.{});
            transcript.update(ch_msg);
            transcript.update(sh_msg);
            const early = if (self.selected_psk) |sp|
                hkdf.HkdfSha256.pskEarlySecret(sp.psk)
            else
                hkdf.HkdfSha256.early_secret;
            self.suite_state = .{ .sha256 = makeHandshakeArm(
                hkdf.HkdfSha256,
                Sha256,
                transcript,
                suite,
                dhe[0..dhe_len],
                early,
            ) };
        },
        .aes_256_gcm_sha384 => {
            var transcript: Sha384 = if (self.retry_transcript) |rt| switch (rt) {
                .sha256 => unreachable,
                .sha384 => |t| t,
            } else .init(.{});
            transcript.update(ch_msg);
            transcript.update(sh_msg);
            self.suite_state = .{ .sha384 = makeHandshakeArm(
                hkdf.HkdfSha384,
                Sha384,
                transcript,
                suite,
                dhe[0..dhe_len],
                if (self.selected_psk) |sp|
                    hkdf.HkdfSha384.pskEarlySecret(sp.psk)
                else
                    hkdf.HkdfSha384.early_secret,
            ) };
        },
    }
    self.retry_transcript = null;
    self.retry_ch1_digest = null;
    self.retry_psk = .none;
    self.retry_selected_group = null;

    switch (self.suite_state) {
        inline .sha256, .sha384 => |s| {
            const H = @TypeOf(s).Hkdf;
            const th = s.transcript.peek();
            var client_secret = H.clientHandshakeTrafficSecret(s.handshake_secret, &.init(th));
            defer client_secret.secureZero();
            var server_secret = H.serverHandshakeTrafficSecret(s.handshake_secret, &.init(th));
            defer server_secret.secureZero();
            var rx = try H.makeRecordLayer(s.aead, client_secret);
            errdefer rx.deinit();
            const tx = try H.makeRecordLayer(s.aead, server_secret);
            self.rx = rx;
            self.tx = tx;
        },
    }
}

fn makeHandshakeArm(
    comptime H: type,
    comptime Hash: type,
    transcript: Hash,
    aead_key: CipherSuite,
    dhe: []const u8,
    early: H.Prk,
) HashArm(H, Hash) {
    var handshake_secret = H.handshakeSecret(early, dhe);
    const th = transcript.peek();
    var client_secret = H.clientHandshakeTrafficSecret(handshake_secret, &.init(th));
    var server_secret = H.serverHandshakeTrafficSecret(handshake_secret, &.init(th));
    const arm: HashArm(H, Hash) = .{
        .transcript = transcript,
        .aead = aead_key,
        .handshake_secret = handshake_secret,
        .client_finished_key = H.finishedKey(client_secret),
        .server_finished_key = H.finishedKey(server_secret),
    };
    handshake_secret.secureZero();
    client_secret.secureZero();
    server_secret.secureZero();
    return arm;
}

// Test-only helper for anonymous handshakes. Keep private: TLS server callers
// must use sendAuthenticatedFlight() so CertificateVerify binds the server's
// identity into the transcript. RFC 8446 §4.3.1, §4.4.4.
fn sendAnonymousFlightForTest(self: *ServerHandshake, out: []u8) FlightError![]const u8 {
    assert(self.state == .wait_client_finished);
    assert(!self.server_flight_sent);
    self.server_flight_sent = true;
    var plaintext: [256]u8 = undefined;
    const flight = try self.encodeEncryptedExtensionsFinished(&plaintext);
    return self.encryptServerFlight(flight, out);
}

// RFC 8446 §4.4.2 — when the server selected a PSK, its authentication
// messages are omitted. The resumed flight is EncryptedExtensions, Finished.
fn encodeEncryptedExtensionsFinished(
    self: *ServerHandshake,
    plaintext: []u8,
) FlightError![]const u8 {
    var pos: usize = 0;
    const ee = try encrypted_extensions.encode(
        plaintext[pos..],
        self.selected_alpn,
        self.early_rx != null,
    );
    self.suite_state.update(ee);
    pos += ee.len;

    switch (self.suite_state) {
        inline .sha256, .sha384 => |*s| {
            const th = s.transcript.peek();
            const fin = try finished.encode(
                @TypeOf(s.transcript),
                plaintext[pos..],
                &s.server_finished_key.data,
                &th,
            );
            s.transcript.update(fin);
            const fin_th = s.transcript.peek();
            self.server_finished_hash[0..fin_th.len].* = fin_th;
            self.server_finished_hash_len = @intCast(fin_th.len);
            pos += fin.len;
        },
    }
    return plaintext[0..pos];
}

/// Emit the encrypted server flight. A full handshake sends
/// EncryptedExtensions, Certificate, CertificateVerify, Finished; a selected
/// PSK omits Certificate and CertificateVerify as required by RFC 8446 §4.4.2.
/// The signer receives the exact TLS 1.3 CertificateVerify input
/// (`64*SP || context || 0 || transcript_hash`) for a full handshake.
/// Any error is terminal for this handshake because flight assembly advances
/// the transcript; send an alert when possible, then deinit.
// ziglint-ignore: Z015 -- FlightError is a public error-set alias.
pub fn sendAuthenticatedFlight(
    self: *ServerHandshake,
    certs_der: []const []const u8,
    signer: Signer,
    plaintext: []u8,
    out: []u8,
) FlightError![]const u8 {
    return self.sendCertificateChainFlight(.init(certs_der), signer, plaintext, out);
}

// ziglint-ignore: Z015 -- FlightError is a public error-set alias.
pub fn sendCertificateChainFlight(
    self: *ServerHandshake,
    chain: CertificateChain,
    signer: Signer,
    plaintext: []u8,
    out: []u8,
) FlightError![]const u8 {
    assert(self.state == .wait_client_finished);
    assert(!self.server_flight_sent);
    self.server_flight_sent = true;
    const flight = if (self.selected_psk != null)
        try self.encodeEncryptedExtensionsFinished(plaintext)
    else
        try self.encodeAuthenticatedFlight(chain, signer, plaintext);
    return self.encryptServerFlight(flight, out);
}

// ziglint-ignore: Z015 -- FlightError is a public error-set alias.
pub fn sendPreparedAuthenticatedFlight(
    self: *ServerHandshake,
    certs_der: []const []const u8,
    signer: Signer,
    out: []u8,
) FlightError![]const u8 {
    return self.sendPreparedCertificateChainFlight(.init(certs_der), signer, out);
}

// ziglint-ignore: Z015 -- FlightError is a public error-set alias.
pub fn sendPreparedCertificateChainFlight(
    self: *ServerHandshake,
    chain: CertificateChain,
    signer: Signer,
    out: []u8,
) FlightError![]const u8 {
    assert(self.state == .wait_client_finished);
    assert(!self.server_flight_sent);
    if (out.len < frame.header_len) return error.BufferTooShort;
    self.server_flight_sent = true;
    const flight = if (self.selected_psk != null)
        try self.encodeEncryptedExtensionsFinished(out[frame.header_len..])
    else
        try self.encodeAuthenticatedFlight(chain, signer, out[frame.header_len..]);
    return self.encryptPreparedServerFlight(flight.len, out);
}

// ziglint-ignore: Z015 -- FlightError is a public error-set alias.
pub fn sendAuthenticatedFlightBuffered(
    self: *ServerHandshake,
    certs_der: []const []const u8,
    signer: Signer,
    out: *FlightBuffer,
) FlightError![]u8 {
    const record = try self.sendPreparedCertificateChainFlight(
        .init(certs_der),
        signer,
        &out.buffer,
    );
    out.resize(@intCast(record.len));
    return out.slice();
}

/// Emit the configured server flight once it is ready. A selected PSK emits
/// EncryptedExtensions + Finished; otherwise the configured certificate and
/// signer produce the authenticated flight. Returns null before ServerHello has
/// installed handshake keys, or after the flight has already been emitted. A
/// non-null result sets the pending-write
/// latch; callers must write the returned bytes and then call completeWrite().
/// Any error is terminal for this handshake because flight assembly advances
/// the transcript; send an alert when possible, then deinit.
// ziglint-ignore: Z015 -- FlightError is a public error-set alias.
pub fn sendPreparedServerFlight(self: *ServerHandshake, out: []u8) FlightError!?[]const u8 {
    if (self.pending_write.isPending()) return error.PendingWrite;
    if (self.state != .wait_client_finished or self.server_flight_sent) return null;
    const credentials = if (self.selected_psk == null)
        self.server_credentials orelse return error.MissingServerCredentials
    else
        null;
    if (out.len < frame.header_len) return error.BufferTooShort;
    self.server_flight_sent = true;
    const flight = if (self.selected_psk != null)
        try self.encodeEncryptedExtensionsFinished(out[frame.header_len..])
    else
        try self.encodeAuthenticatedFlight(
            credentials.?.chain,
            credentials.?.signer,
            out[frame.header_len..],
        );
    const record = try self.encryptPreparedServerFlight(flight.len, out);
    self.pending_write.mark();
    return record;
}

/// Buffered variant of sendPreparedServerFlight for callers using FlightBuffer.
// ziglint-ignore: Z015 -- FlightError is a public error-set alias.
pub fn sendServerFlightBuffered(self: *ServerHandshake, out: *FlightBuffer) FlightError!?[]u8 {
    const record = (try self.sendPreparedServerFlight(&out.buffer)) orelse return null;
    out.resize(@intCast(record.len));
    return out.slice();
}

fn encodeAuthenticatedFlight(
    self: *ServerHandshake,
    chain: CertificateChain,
    signer: Signer,
    plaintext: []u8,
) FlightError![]const u8 {
    assert(self.state == .wait_client_finished);
    var pos: usize = 0;

    const ee = try encrypted_extensions.encode(
        plaintext[pos..],
        self.selected_alpn,
        self.early_rx != null,
    );
    self.suite_state.update(ee);
    pos += ee.len;

    if (self.client_auth != .none) {
        const cr = try certificate_request.encode(
            plaintext[pos..],
            backend.capabilities.certificate_verify_schemes,
        );
        self.suite_state.update(cr);
        pos += cr.len;
    }

    const cert = try chain.encode(plaintext[pos..]);
    self.suite_state.update(cert);
    pos += cert.len;

    const cv_ctx_len = certificate.server_certificate_verify_context.len;
    var cv_input: [cv_ctx_len + 64]u8 = undefined;
    cv_input[0..cv_ctx_len].* = certificate.server_certificate_verify_context.*;
    const transcript_hash_len: usize = switch (self.suite_state) {
        inline .sha256, .sha384 => |*s| blk: {
            const th = s.transcript.peek();
            @memcpy(cv_input[cv_ctx_len..][0..th.len], &th);
            break :blk th.len;
        },
    };
    var sig_buf: [512]u8 = undefined;
    const sig = try signer.sign(
        signer.context,
        cv_input[0 .. cv_ctx_len + transcript_hash_len],
        &sig_buf,
    );
    const cv = try certificate.encodeCertificateVerify(plaintext[pos..], signer.scheme, sig);
    self.suite_state.update(cv);
    pos += cv.len;

    switch (self.suite_state) {
        inline .sha256, .sha384 => |*s| {
            const th = s.transcript.peek();
            const fin = try finished.encode(
                @TypeOf(s.transcript),
                plaintext[pos..],
                &s.server_finished_key.data,
                &th,
            );
            s.transcript.update(fin);
            // Snapshot the transcript through the server Finished for app-
            // secret derivation (RFC 8446 §7.1). The client flight that
            // follows must not perturb this hash.
            const fin_th = s.transcript.peek();
            self.server_finished_hash[0..fin_th.len].* = fin_th;
            self.server_finished_hash_len = @intCast(fin_th.len);
            pos += fin.len;
        },
    }
    return plaintext[0..pos];
}

/// Encrypt the server flight with the handshake write key, then advance only
/// the write direction to application traffic keys. RFC 8446 §4.4.4 requires
/// every subsequent server record — specifically including client-auth
/// rejection alerts — to use application keys, while the client flight that
/// follows is still received under handshake keys.
fn encryptServerFlight(
    self: *ServerHandshake,
    plaintext: []const u8,
    out: []u8,
) FlightError![]const u8 {
    var next_tx = try self.prepareServerApplicationWriteKey();
    errdefer {
        next_tx.deinit();
        self.clearServerApplicationWriteSecret();
    }
    const record = try self.tx.encrypt(.handshake, plaintext, out);
    self.tx.deinit();
    self.tx = next_tx;
    return record;
}

fn encryptPreparedServerFlight(
    self: *ServerHandshake,
    plaintext_len: usize,
    out: []u8,
) FlightError![]const u8 {
    var next_tx = try self.prepareServerApplicationWriteKey();
    errdefer {
        next_tx.deinit();
        self.clearServerApplicationWriteSecret();
    }
    const record = try self.tx.encryptPrepared(.handshake, plaintext_len, out);
    self.tx.deinit();
    self.tx = next_tx;
    return record;
}

fn prepareServerApplicationWriteKey(self: *ServerHandshake) aead.Error!RecordLayer {
    assert(self.server_finished_hash_len != 0);
    return switch (self.suite_state) {
        inline .sha256, .sha384 => |*s| blk: {
            const H = @TypeOf(s.*).Hkdf;
            var app_th: H.TranscriptHash = undefined;
            @memcpy(app_th.data[0..], self.server_finished_hash[0..self.server_finished_hash_len]);
            var master = H.masterSecret(s.handshake_secret);
            defer master.secureZero();
            s.server_app_secret = H.serverApplicationTrafficSecret(master, &app_th);
            errdefer s.server_app_secret.secureZero();
            break :blk try H.makeRecordLayer(s.aead, s.server_app_secret);
        },
    };
}

fn clearServerApplicationWriteSecret(self: *ServerHandshake) void {
    switch (self.suite_state) {
        inline .sha256, .sha384 => |*s| s.server_app_secret.secureZero(),
    }
}

/// Consume the client's encrypted Finished, verify it against the transcript
/// through server Finished, then install application traffic keys. RFC 8446
/// §4.4.4, §7.1.
// ziglint-ignore: Z015 -- ClientFinishedError is a public error-set alias.
pub fn processClientFinished(self: *ServerHandshake, record: []u8) ClientFinishedError!void {
    assert(self.state == .wait_client_finished);
    // RFC 8446 §4.5 — if the server accepted 0-RTT, the client MUST send
    // EndOfEarlyData (decrypted with early_rx) before the Finished. The
    // handleRecord path enforces this in handleWaitClientFinished; this
    // direct entry point must enforce the same gate so a caller using the
    // public API cannot accept a Finished that skips EndOfEarlyData.
    if (self.early_rx != null and !self.end_of_early_data_received)
        return error.UnexpectedMessage;
    const dec = try handshake.decryptProtected(&self.rx, record);
    if (dec.content_type != .handshake) return error.UnexpectedRecord;
    return self.processClientFinishedPlaintext(dec.content);
}

fn processClientFinishedPlaintext(
    self: *ServerHandshake,
    plaintext: []const u8,
) ClientFinishedError!void {
    assert(self.state == .wait_client_finished);
    var authenticated_leaf_der: ?[]const u8 = null;
    var hr: HandshakeReader = .init(plaintext);
    var msg = (try hr.next()) orelse return error.UnexpectedMessage;

    if (self.client_auth != .none) {
        self.client_leaf_pub_key.clear();
        self.client_cert.clear();
        if (msg.type != .certificate) return error.UnexpectedMessage;
        // The handshake-time CertificateRequest context is empty; the client
        // echoes it. RFC 8446 §4.4.2.
        const status = try certificate.parseClientCertificate(msg.raw, &.{});
        switch (status) {
            .empty => {
                if (self.client_auth == .required) return error.ClientCertificateRequired;
                self.suite_state.update(msg.raw);
                msg = (try hr.next()) orelse return error.UnexpectedMessage;
            },
            .present => {
                // Parse the chain and extract the leaf public key. The leaf
                // key is retained for CertificateVerify verification, which
                // may arrive in this same record or a later one. RFC 8446
                // §4.4.2, §4.4.3.
                const verified = try certificate.parseClientChain(
                    msg.raw,
                    &.{},
                    self.client_cert_policy,
                );
                self.client_leaf_pub_key.appendSlice(verified.pub_key) catch
                    return error.CertificateKeyTooLarge;
                authenticated_leaf_der = verified.leaf_der;
                self.suite_state.update(msg.raw);
                // Next message must be CertificateVerify.
                msg = (try hr.next()) orelse return error.UnexpectedMessage;
                if (msg.type != .certificate_verify) return error.UnexpectedMessage;
                // RFC 8446 §4.4.3 — verify the signature against the client
                // leaf public key over client_context || transcript_hash
                // (through the client Certificate, snapshotted here before CV
                // is absorbed). The scheme MUST be one the server offered in
                // the CertificateRequest (backend.capabilities.certificate_
                // verify_schemes).
                switch (self.suite_state) {
                    inline .sha256, .sha384 => |*s| {
                        const th = s.transcript.peek();
                        try certificate.verifyClientSignatureWithSchemes(
                            msg.raw,
                            self.client_leaf_pub_key.constSlice(),
                            &th,
                            backend.capabilities.certificate_verify_schemes,
                        );
                    },
                }
                self.suite_state.update(msg.raw);
                msg = (try hr.next()) orelse return error.UnexpectedMessage;
            },
        }
    }

    if (msg.type != .finished) return error.UnexpectedMessage;
    if (try hr.next() != null) return error.UnexpectedMessage;
    if (authenticated_leaf_der) |der| {
        if (self.client_cert.buffer.len != 0 and der.len > self.client_cert.buffer.len)
            return error.ClientCertificateTooLarge;
    }
    try self.verifyClientFinished(msg.raw);
    if (authenticated_leaf_der) |der| {
        if (self.client_cert.buffer.len != 0)
            self.client_cert.retainFrom(der) catch unreachable;
    }
}

/// Verify a complete client Finished message, install application traffic
/// keys, and transition to the connected state. Called by both the normal
/// complete-Finished path and the fragmented-Finished reassembly path.
/// RFC 8446 §4.4.4, §7.1.
fn verifyClientFinished(
    self: *ServerHandshake,
    msg_raw: []const u8,
) ClientFinishedError!void {
    assert(self.state == .wait_client_finished);
    switch (self.suite_state) {
        inline .sha256, .sha384 => |*s| {
            const H = @TypeOf(s.*).Hkdf;
            const th = s.transcript.peek();
            try finished.verify(@TypeOf(s.transcript), msg_raw, &s.client_finished_key.data, &th);
            // RFC 8446 §7.1: application traffic secrets are derived from the
            // transcript through the server Finished (snapshotted when the
            // server flight was emitted), not the live transcript which now
            // includes the client flight.
            if (self.server_finished_hash_len == 0) return error.UnexpectedMessage;
            var app_th: H.TranscriptHash = undefined;
            @memcpy(app_th.data[0..], self.server_finished_hash[0..self.server_finished_hash_len]);
            var master = H.masterSecret(s.handshake_secret);
            defer master.secureZero();
            s.client_app_secret = H.clientApplicationTrafficSecret(master, &app_th);
            errdefer s.client_app_secret.secureZero();
            const next_rx = try H.makeRecordLayer(s.aead, s.client_app_secret);
            self.rx.deinit();
            self.rx = next_rx;
            s.transcript.update(msg_raw);
            const res_th_raw = s.transcript.peek();
            var res_th: H.TranscriptHash = undefined;
            @memcpy(res_th.data[0..], res_th_raw[0..]);
            s.resumption_master = H.resumptionMasterSecret(master, &res_th);
            s.resumption_master_valid = true;
            s.forgetHandshakeSecrets();
        },
    }
    self.state = .connected;
}

// ziglint-ignore: Z015 -- HandleError is a public error-set alias.
pub fn handleRecord(
    self: *ServerHandshake,
    record: []u8,
    out: []u8,
) HandleError!Event {
    if (self.pending_write.isPending()) return error.PendingWrite;
    const ev: Event = switch (self.state) {
        .wait_ch => try self.handleWaitClientHello(record, out),
        .wait_client_finished => try self.handleWaitClientFinished(record),
        .connected => try handshake.serverHandleConnected(self, record, out),
        // The engine was consumed by extractEstablished. Reuse is a
        // programming error, not a protocol input.
        .extracted => unreachable,
    };
    if (ev == .write) self.pending_write.mark();
    if (ev == .key_update and ev.key_update.response != null) self.pending_write.mark();
    return ev;
}

fn handleWaitClientHello(
    self: *ServerHandshake,
    record: []u8,
    out: []u8,
) HandleError!Event {
    // If a mid-fragment error escapes (e.g. malformed record header),
    // reset reassembly state so the caller can retry with a fresh CH.
    errdefer if (self.ch_buf.len > 0) {
        self.ch_buf.clear();
        self.ch_expected = 0;
    };

    const hdr = try frame.parseHeader(record);
    if (record.len < frame.header_len + hdr.length()) return error.IncompleteRecord;

    // RFC 8446 §5.1 — non-handshake records while a ClientHello fragment is
    // pending: alerts abort the connection regardless, everything else
    // (including CCS, which would otherwise pass the HRR compatibility check)
    // is illegal mid-fragment. Reset reassembly state on every exit.
    if (self.ch_buf.len > 0 and hdr.content_type != .handshake) {
        self.ch_buf.clear();
        self.ch_expected = 0;
        if (hdr.content_type == .alert) {
            const a = try alert.parse(record[frame.header_len..][0..hdr.length()]);
            if (a.isCloseNotify()) return .closed;
            self.last_peer_alert = a;
            return error.PeerAlert;
        }
        return error.UnexpectedRecord;
    }

    return switch (hdr.content_type) {
        // RFC 8446 §5, Appendix D.4 — after HRR, clients may send a dummy CCS
        // immediately before ClientHello2; before any ClientHello it is invalid.
        .change_cipher_spec => {
            if (self.retry_transcript == null) return error.UnexpectedRecord;
            try handshake.validateChangeCipherSpec(record[frame.header_len..][0..hdr.length()]);
            return .none;
        },
        .alert => blk: {
            const a = try alert.parse(record[frame.header_len..][0..hdr.length()]);
            if (a.isCloseNotify()) break :blk .closed;
            self.last_peer_alert = a;
            break :blk error.PeerAlert;
        },
        .handshake => {
            if (hdr.length() == 0) return error.UnexpectedRecord;
            return self.handleClientHelloRecord(record, out);
        },
        // RFC 8446 §4.2.10 — after this server answered an early_data
        // ClientHello with HelloRetryRequest, 0-RTT records already in
        // flight arrive with an outer content type of application_data while
        // ClientHello2 is pending. The declining server holds no key that
        // could deprotect them, so the HRR strategy skips by outer content
        // type, bounded by the same wire-byte budget as the 1-RTT decline
        // path. ClientHello2 (the first handshake record) closes the window.
        .application_data => {
            if (self.early_data_skip != .await_client_hello2) return error.UnexpectedRecord;
            // An outer application_data payload of one AEAD tag or less
            // cannot be an encrypted TLS 1.3 record (§5.2 needs tag + inner
            // content type): malformed input, not skippable early data, so a
            // zero-length record stream cannot burn skips for free.
            if (hdr.length() <= aead.tag_len) return error.RecordTooShort;
            const skipped: u32 = @intCast(hdr.length());
            if (skipped > self.early_data_skip_limit - self.early_data_skip_bytes)
                return error.EarlyDataSkipLimitExceeded;
            self.early_data_skip_bytes += skipped;
            return .none;
        },
        else => error.UnexpectedRecord,
    };
}

/// Handle a handshake record in wait_ch state. Three paths:
/// - Fast path (common case): the record body contains the complete ClientHello
///   handshake message. Delegates to processClientHelloMessage directly.
/// - Buffering path: the record body starts a ClientHello that will span
///   multiple records. Copies bytes into ch_buf and returns .none
///   until the full message is assembled.
/// - Rejection: no caller-owned buffer was provided and the ClientHello is
///   fragmented. Returns IncompleteRecord (maps to decode_error).
/// RFC 8446 §5.1.
fn handleClientHelloRecord(
    self: *ServerHandshake,
    record: []u8,
    out: []u8,
) HandleError!Event {
    // If a mid-fragment error escapes (e.g. malformed record header),
    // reset reassembly state so the caller can retry with a fresh CH.
    errdefer if (self.ch_buf.len > 0) {
        self.ch_buf.clear();
        self.ch_expected = 0;
    };

    const hdr = try frame.parseHeader(record);
    const body = record[frame.header_len..][0..hdr.length()];

    if (self.ch_buf.len > 0) {
        if (self.ch_expected == 0) {
            // Still assembling the handshake header across records.
            // RFC 8446 §5.1 — handshake messages may be fragmented; the
            // 4-byte header itself can span records.
            const needed_header = handshake_header_len - self.ch_buf.len;
            const take_header = @min(body.len, needed_header);
            self.ch_buf.appendSlice(body[0..take_header]) catch return error.IncompleteRecord;

            if (self.ch_buf.len < handshake_header_len) return .none;

            // Header is now complete: validate type and compute expected total.
            if (self.ch_buf.constSlice()[0] != @intFromEnum(HandshakeType.client_hello))
                return error.UnexpectedMessage;
            const body_len_assembled = (@as(u24, self.ch_buf.constSlice()[1]) << 16) |
                (@as(u24, self.ch_buf.constSlice()[2]) << 8) |
                self.ch_buf.constSlice()[3];
            self.ch_expected = @as(usize, handshake_header_len) + @as(usize, body_len_assembled);
            if (self.ch_expected > self.ch_buf.buffer.len) return error.IncompleteRecord;

            // Buffer any remaining body bytes from this record.
            const remaining = body.len - take_header;
            const take_extra = @min(remaining, self.ch_expected - self.ch_buf.len);
            if (take_extra > 0)
                self.ch_buf.appendSliceAssumeCapacity(body[take_header..][0..take_extra]);
            if (remaining > take_extra) return error.UnexpectedMessage;
        } else {
            // Fragment in progress with known header: append continuation body.
            const needed = self.ch_expected - self.ch_buf.len;
            const take = @min(body.len, needed);
            self.ch_buf.appendSliceAssumeCapacity(body[0..take]);
            if (body.len > take) return error.UnexpectedMessage;
        }

        if (self.ch_buf.len >= self.ch_expected) {
            // Complete: process, then reset reassembly state regardless of
            // success or failure so the caller can retry with a fresh CH.
            const result = self.processClientHelloMessage(
                self.ch_buf.constSlice()[0..self.ch_expected],
                out,
            );
            self.ch_buf.clear();
            self.ch_expected = 0;
            return .{ .write = try result };
        }
        // Still need more fragments.
        return .none;
    }

    // No fragment in progress. Sniff the handshake header.
    // RFC 8446 §4 — the handshake type must be client_hello (also covers
    // ClientHello2 after HelloRetryRequest).
    if (body.len < handshake_header_len) {
        if (self.ch_buf.buffer.len == 0) return error.IncompleteRecord;
        self.ch_buf.appendSlice(body) catch return error.IncompleteRecord;
        self.ch_expected = 0; // sentinel: handshake header not yet complete
        return .none;
    }
    if (body[0] != @intFromEnum(HandshakeType.client_hello)) return error.UnexpectedMessage;

    const body_len = (@as(u24, body[1]) << 16) | (@as(u24, body[2]) << 8) | body[3];
    const total = @as(usize, handshake_header_len) + @as(usize, body_len);

    if (total <= body.len) {
        // Complete in one record: fast path (common case).
        return .{ .write = try self.processClientHelloMessage(body, out) };
    }

    // Fragmented ClientHello: require caller-owned storage.
    if (self.ch_buf.buffer.len == 0) return error.IncompleteRecord;
    if (total > self.ch_buf.buffer.len) return error.IncompleteRecord;

    // Start buffering for cross-record reassembly.
    self.ch_buf.appendSliceAssumeCapacity(body);
    self.ch_expected = total;
    return .none;
}

fn handleWaitClientFinished(self: *ServerHandshake, record: []u8) HandleError!Event {
    const hdr = try frame.parseHeader(record);
    if (record.len < frame.header_len + hdr.length()) return error.IncompleteRecord;
    if (self.fin_frag.len > 0 and hdr.content_type != .application_data) {
        self.fin_frag.clear();
        return error.UnexpectedMessage;
    }
    switch (hdr.content_type) {
        // RFC 8446 §D.4 — middlebox-compat ChangeCipherSpec is silently dropped
        // only after ClientHello and before the peer Finished.
        .change_cipher_spec => {
            try handshake.validateChangeCipherSpec(record[frame.header_len..][0..hdr.length()]);
            return .none;
        },
        .alert => return error.UnexpectedMessage,
        .application_data => {},
        .handshake => return error.UnexpectedMessage,
        else => return error.UnexpectedRecord,
    }

    // 0-RTT early data (RFC 8446 §4.2.10, §4.5): if the server accepted
    // 0-RTT (early_rx installed) and has not yet received EndOfEarlyData,
    // records MUST be under the early traffic key. Once EndOfEarlyData is
    // received, all subsequent records are under the handshake key.
    // We do NOT fall through to the handshake key on early_rx failure: that
    // would corrupt the record buffer (decrypt is in-place) and the client
    // is required to send EndOfEarlyData before any handshake-key record.
    if (self.early_rx) |*early_rx| {
        if (!self.end_of_early_data_received) {
            const early_dec = try handshake.decryptProtected(early_rx, record);
            switch (early_dec.content_type) {
                .application_data => {
                    // RFC 8446 §4.2.10: reject early data exceeding the
                    // ticket's max_early_data_size.
                    if (self.early_data_limit) |limit| {
                        const content_len: u32 = @intCast(early_dec.content.len);
                        if (content_len > limit - self.early_data_received)
                            return error.UnexpectedMessage;
                        self.early_data_received += content_len;
                    }
                    self.post_handshake_count = 0;
                    return .{ .application_data = early_dec.content };
                },
                // RFC 8446 §4.5 — EndOfEarlyData is a handshake message
                // encrypted under the client_early_traffic_secret. The
                // server MUST receive it before the client Finished when it
                // accepted 0-RTT. Servers MUST NOT send this message.
                .handshake => {
                    if (early_dec.content.len != 4) return error.UnexpectedMessage;
                    if (early_dec.content[0] != @intFromEnum(HandshakeType.end_of_early_data))
                        return error.UnexpectedMessage;
                    // Body is empty: the 3-byte length field MUST be zero.
                    if (early_dec.content[1] != 0 or
                        early_dec.content[2] != 0 or
                        early_dec.content[3] != 0) return error.UnexpectedMessage;
                    // Absorb EndOfEarlyData into the transcript (§4.5).
                    self.suite_state.update(early_dec.content);
                    self.end_of_early_data_received = true;
                    // RFC 8446 §7.1 — the client_early_traffic_secret is
                    // only valid until EndOfEarlyData is received. Zero and
                    // drop the early receive key at the key-change boundary
                    // so the cryptographically-dead key does not linger.
                    early_rx.deinit();
                    self.early_rx = null;
                    return .none;
                },
                else => return error.UnexpectedMessage,
            }
        }
    }

    // RFC 8446 §4.2.10 — when this server declined the client's early_data
    // offer, 0-RTT records already in flight fail deprotection under the
    // handshake traffic key. Trial-deprotect each application_data record:
    // discard failures up to the configured ciphertext-byte budget; the first
    // record that deprotects is the start of the client's second flight and
    // ends skip mode for good. A failed trial does not advance the receive
    // sequence (§5.2) or disturb the AEAD context, so later records
    // deprotect with the same sequence number. The failed record's buffer is
    // backend-owned failure output and is discarded unread.
    if (self.early_data_skip == .trial_decrypt) {
        const dec = handshake.decryptProtected(&self.rx, record) catch |err| switch (err) {
            error.AuthenticationFailed => {
                const skipped: u32 = @intCast(hdr.length());
                if (skipped > self.early_data_skip_limit - self.early_data_skip_bytes)
                    return error.EarlyDataSkipLimitExceeded;
                self.early_data_skip_bytes += skipped;
                return .none;
            },
            else => {
                if (self.fin_frag.len > 0) self.fin_frag.clear();
                return err;
            },
        };
        self.early_data_skip = .off;
        return self.handleClientFlightRecord(dec);
    }

    const dec = handshake.decryptProtected(&self.rx, record) catch |err| {
        if (self.fin_frag.len > 0) self.fin_frag.clear();
        return err;
    };
    return self.handleClientFlightRecord(dec);
}

/// Dispatch one deprotected client-flight record (wait_client_finished).
/// Shared by the plain handshake-key path and the §4.2.10 skip-mode trial
/// path so both enforce identical flight framing and transcript rules.
fn handleClientFlightRecord(
    self: *ServerHandshake,
    dec: RecordLayer.DecryptedRecord,
) HandleError!Event {

    // RFC 8446 §5.1 — if a Finished fragment is pending and the inner
    // content type is not handshake, reject with UnexpectedMessage.
    // This catches interleaved alerts and application data.
    if (self.fin_frag.len > 0 and dec.content_type != .handshake) {
        self.fin_frag.clear();
        return error.UnexpectedMessage;
    }

    return switch (dec.content_type) {
        .handshake => blk: {
            if (dec.content.len == 0) {
                self.fin_frag.clear();
                return error.UnexpectedMessage;
            }
            // Buffer the plaintext and reassemble the client flight
            // (Certificate [+ CertificateVerify] + Finished, or just Finished
            // when client auth is off). RFC 8446 §4.4, §5.1.
            self.fin_frag.appendSlice(dec.content) catch {
                self.fin_frag.clear();
                return error.UnexpectedMessage;
            };

            const fragment = self.fin_frag.constSlice();
            if (fragment.len < handshake_header_len) break :blk .none;

            // Walk complete handshake messages; stop at the first partial or
            // trailing byte after the last complete message.
            var hr: HandshakeReader = .init(fragment);
            var saw_finished = false;
            while (true) {
                const maybe_msg = hr.next() catch |err| switch (err) {
                    // Partial message: more fragments needed. If we already saw
                    // a Finished, a trailing partial is illegal.
                    error.UnexpectedEof => {
                        if (saw_finished) {
                            self.fin_frag.clear();
                            return error.UnexpectedMessage;
                        }
                        break :blk .none;
                    },
                };
                const msg = maybe_msg orelse {
                    // Buffer fully drained. If no Finished yet, wait for more.
                    if (!saw_finished) break :blk .none;
                    break;
                };
                // Only the client-flight messages are valid here. A KeyUpdate
                // or any other handshake message during wait_client_finished
                // is rejected. RFC 8446 Appendix A.2.
                switch (msg.type) {
                    .certificate, .certificate_verify => {},
                    .finished => saw_finished = true,
                    else => {
                        self.fin_frag.clear();
                        return error.UnexpectedMessage;
                    },
                }
                // After a Finished, nothing else may follow in the flight.
                if (saw_finished) {
                    const extra = hr.next() catch {
                        self.fin_frag.clear();
                        return error.UnexpectedMessage;
                    };
                    if (extra != null) {
                        self.fin_frag.clear();
                        return error.UnexpectedMessage;
                    }
                    break;
                }
            }
            if (!saw_finished) break :blk .none; // still partial: wait for more

            // Complete client flight: validate Certificate [+ CV] + Finished.
            const flight = fragment;
            self.fin_frag.clear();
            try self.processClientFinishedPlaintext(flight);
            break :blk .none;
        },
        .alert => blk: {
            const a = try alert.parse(dec.content);
            if (a.isCloseNotify()) break :blk .closed;
            self.last_peer_alert = a;
            break :blk error.PeerAlert;
        },
        else => error.UnexpectedRecord,
    };
}

/// Process one connected-state record without touching TX state or the
/// pending-write latch. The caller owns any KeyUpdate response. This permits a
/// full-duplex driver to continue RX while a TX record drains. RFC 8446 §4.6.3.
// ziglint-ignore: Z015 -- ReceiveError is a public error-set alias.
pub fn receiveRecord(self: *ServerHandshake, record: []u8) ReceiveError!ReceiveEvent {
    assert(self.state == .connected);
    return handshake.serverReceiveRecord(self, record);
}

/// Process one complete record already decrypted by Linux kTLS. Call exactly
/// once per `TLS_GET_RECORD_TYPE` result; the record boundary is security-
/// relevant for KeyUpdate. The kernel owns record sequence advancement.
// ziglint-ignore: Z015 -- ReceiveError is a public error-set alias.
pub fn receiveKtlsRecord(
    self: *ServerHandshake,
    content_type: frame.ContentType,
    content: []u8,
) ReceiveError!ReceiveEvent {
    assert(self.state == .connected);
    return handshake.serverReceivePlaintext(self, content_type, content);
}

// ziglint-ignore: Z015 -- SendError is a public error-set alias.
pub fn sendKeyUpdate(
    self: *ServerHandshake,
    out: []u8,
    request: KeyUpdateRequest,
) SendError![]const u8 {
    return handshake.sendKeyUpdate(.server, self, out, request);
}

/// Advance server TX after Linux kTLS has accepted a KeyUpdate control record
/// under the old key. `request` must match that record; a not-requested update
/// satisfies any owed response. Install `txKtlsInfo()` before any later send.
// ziglint-ignore: Z015 -- SendError is a public error-set alias.
pub fn ratchetKtlsTx(
    self: *ServerHandshake,
    request: KeyUpdateRequest,
) SendError!void {
    return handshake.ratchetKtlsTx(.server, self, request);
}

// ziglint-ignore: Z015 -- AlertError is a public error-set alias.
pub fn sendAlert(
    self: *ServerHandshake,
    description: alert.Description,
    out: []u8,
) AlertError![]const u8 {
    if (self.pending_write.isPending()) return error.PendingWrite;
    const record: []const u8 = switch (self.state) {
        // RFC 8446 §6 — alerts before handshake protection are plaintext.
        .wait_ch => blk: {
            var msg: [2]u8 = undefined;
            const level: alert.Level = if (description == .close_notify) .warning else .fatal;
            _ = alert.encode(&msg, level, description) catch unreachable;
            break :blk try alert.plaintextRecord(&msg, out);
        },
        .wait_client_finished, .connected => try handshake.sendEstablishedAlert(
            self,
            description,
            out,
        ),
        // The engine was consumed by extractEstablished.
        .extracted => unreachable,
    };
    self.pending_write.mark();
    return record;
}

/// Serialize and encrypt one prepared NewSessionTicket under the current
/// application traffic keys. The caller must write the returned record and call
/// `completeWrite()` before sending another record or transferring TX to kTLS.
/// Tickets emitted here never advertise 0-RTT: the current acceptance API cannot
/// validate all RFC 8446 §4.2.10 age, exact-suite, and ALPN obligations.
///
/// The caller owns the opaque identity and all storage, expiration, rotation,
/// replay, random `ticket_age_add`, resumption-chain, and client-auth continuity
/// policy. `params.ticket` must not alias `out`. RFC 8446 §4.6.1.
// ziglint-ignore: Z015 -- TicketSendError is a public error-set alias.
pub fn sendNewSessionTicket(
    self: *ServerHandshake,
    prepared: *const TicketPsk,
    params: TicketParams,
    out: []u8,
) TicketSendError![]const u8 {
    assert(self.state == .connected);
    if (self.tx_owner == .kernel) return error.KtlsTxActive;
    if (self.ticket_compatibility != .psk_dhe_ke)
        return error.IncompatiblePskModes;
    if (self.pending_write.isPending()) return error.PendingWrite;
    if (self.key_update_obligation == .response_owed)
        return error.PendingKeyUpdateResponse;
    const nonce = switch (self.ticket_nonce_state) {
        .prepared => |ticket_nonce| ticket_nonce,
        .next => return error.InvalidTicketPsk,
    };
    if (prepared.ticket_nonce[0] != nonce) return error.InvalidTicketPsk;
    if (params.ticket.len > max_ticket_identity_len) return error.TicketTooLong;
    if (out.len < RecordLayer.overhead) return error.BufferTooShort;

    const plaintext_capacity = out.len - RecordLayer.overhead;
    const msg = try NewSessionTicket.encode(
        out[frame.header_len..][0..plaintext_capacity],
        .{
            .ticket_lifetime = params.ticket_lifetime,
            .ticket_age_add = params.ticket_age_add,
            .ticket_nonce = &prepared.ticket_nonce,
            .ticket = params.ticket,
        },
    );
    const record = try self.tx.encryptPrepared(.handshake, msg.len, out);
    self.ticket_nonce_state = .{ .next = nonce + 1 };
    self.pending_write.mark();
    return record;
}

// ziglint-ignore: Z015 -- SendError is a public error-set alias.
pub fn sendApplicationData(
    self: *ServerHandshake,
    plaintext: []const u8,
    out: []u8,
) SendError![]u8 {
    return handshake.sendApplicationData(self, plaintext, out);
}

// ziglint-ignore: Z015 -- SendError is a public error-set alias.
pub fn sendPreparedApplicationData(
    self: *ServerHandshake,
    plaintext_len: usize,
    out: []u8,
) SendError![]u8 {
    return handshake.sendPreparedApplicationData(self, plaintext_len, out);
}

/// Export the current server-write traffic key epoch for caller-owned kTLS TX
/// setup. Every userspace-encrypted record, including each NewSessionTicket,
/// must be written and completed before this snapshot is taken.
pub fn txKtlsInfo(self: *const ServerHandshake) RecordLayer.KtlsInfo {
    assert(self.state == .connected);
    return self.tx.ktlsInfo();
}

/// Record that kTLS owns the TX record layer. Call only after successful TLS_TX
/// installation; NewSessionTicket emission then fails with `error.KtlsTxActive`.
pub fn markKtlsTxInstalled(self: *ServerHandshake) KtlsTxTransferError!void {
    assert(self.state == .connected);
    if (self.pending_write.isPending()) return error.PendingWrite;
    if (self.key_update_obligation == .response_owed)
        return error.PendingKeyUpdateResponse;
    if (self.ticket_nonce_state == .prepared) return error.PendingTicket;
    self.tx_owner = .kernel;
}

/// Export the current client-write traffic key epoch for caller-owned kTLS RX setup.
pub fn rxKtlsInfo(self: *const ServerHandshake) RecordLayer.KtlsInfo {
    assert(self.state == .connected);
    return self.rx.ktlsInfo();
}

// ziglint-ignore: Z015 -- ReceiveError is a public error-set alias.
pub fn receiveApplicationData(self: *ServerHandshake, record: []u8) ReceiveError![]const u8 {
    assert(self.state == .connected);
    if (self.ku_frag.len != 0) return error.UnexpectedRecord;
    const dec = try handshake.decryptProtected(&self.rx, record);
    if (dec.content_type != .application_data) return error.UnexpectedRecord;
    return dec.content;
}

fn chooseSuite(self: *const ServerHandshake, ch: client_hello.Parsed) ?CipherSuite {
    for (self.supported_suites) |suite| {
        if (backend.supportsCipherSuite(suite) and ch.offersSuite(suite)) return suite;
    }
    return null;
}

// Test fixture accessors. Wrapped in functions so the @import of
// fixtures is never analyzed unless a test actually calls these —
// the published tarball doesn't include the fixtures module.
// Issue #66.
fn testCertDer() []const u8 {
    // ziglint-ignore: Z028, Z007
    const f = @import("fixtures");
    return &f.server_cert_der;
}
fn serverEcdsaCertDer() []const u8 {
    // ziglint-ignore: Z028, Z007
    const f = @import("fixtures");
    return &f.server_ecdsa_cert_der;
}
fn serverEcdsaScalar() []const u8 {
    // ziglint-ignore: Z028, Z007
    const f = @import("fixtures");
    return &f.server_ecdsa_scalar;
}
fn clientEcdsaCertDer() []const u8 {
    // ziglint-ignore: Z028, Z007
    const f = @import("fixtures");
    return &f.client_ecdsa_cert_der;
}
fn clientEcdsaScalar() []const u8 {
    // ziglint-ignore: Z028, Z007
    const f = @import("fixtures");
    return &f.client_ecdsa_scalar;
}

/// First hybrid group this backend supports that can force a HelloRetryRequest
/// (advertised in supported_groups without an initial client key_share). Used
/// by the §4.2.10 HRR decline tests; the classical groups cannot force HRR
/// from the real client engine because it always sends shares for them.
fn firstSupportedHrrTriggerGroup() ?NamedGroup {
    const candidates = [_]NamedGroup{ .x25519_mlkem768, .secp256r1_mlkem768 };
    for (candidates) |group| {
        if (backend.supportsServerHybridGroup(group)) return group;
    }
    return null;
}
const test_p256_seed_a = memx.hex(32, "000102030405060708090a0b0c0d0e0f" ++
    "101112131415161718191a1b1c1d1e1f");
const test_p256_seed_b = memx.hex(32, "202122232425262728292a2b2c2d2e2f" ++
    "303132333435363738393a3b3c3d3e3f");
const test_p384_seed_a = memx.hex(48, "000102030405060708090a0b0c0d0e0f" ++
    "101112131415161718191a1b1c1d1e1f" ++
    "202122232425262728292a2b2c2d2e2f");
const test_p384_seed_b = memx.hex(48, "303132333435363738393a3b3c3d3e3f" ++
    "404142434445464748494a4b4c4d4e4f" ++
    "505152535455565758595a5b5c5d5e5f");

fn clientHelloWithKeyShareGroup(
    out: []u8,
    client_hello_msg: []const u8,
    group: u16,
) []const u8 {
    @memcpy(out[0..client_hello_msg.len], client_hello_msg);
    var i: usize = 0;
    while (i + 9 < client_hello_msg.len) : (i += 1) {
        if (out[i] == 0x00 and out[i + 1] == 0x33 and out[i + 2] == 0x00 and out[i + 3] == 0x26) {
            out[i + 6] = @truncate(group >> 8);
            out[i + 7] = @truncate(group);
            return out[0..client_hello_msg.len];
        }
    }
    unreachable;
}

fn clientHelloWithP256KeyShare(
    out: []u8,
    client_hello_msg: []const u8,
    public_key: p256.PublicKey,
) []const u8 {
    @memcpy(out[0..client_hello_msg.len], client_hello_msg);
    var i: usize = 0;
    while (i + 4 < client_hello_msg.len) : (i += 1) {
        if (out[i] == 0x00 and out[i + 1] == 0x0a and out[i + 2] == 0x00 and out[i + 3] == 0x04) {
            out[i + 6] = 0x00;
            out[i + 7] = @intFromEnum(NamedGroup.secp256r1);
            break;
        }
    } else unreachable;

    i = 0;
    while (i + 4 < client_hello_msg.len) : (i += 1) {
        if (out[i] == 0x00 and out[i + 1] == 0x33 and
            out[i + 2] == 0x00 and out[i + 3] == 0x26) break;
    } else unreachable;

    const old_total: usize = 4 + 0x26;
    const new_ext_len: u16 = 2 + 2 + 2 + p256.public_length;
    const new_total: usize = 4 + new_ext_len;
    const delta = new_total - old_total;
    const tail_src = i + old_total;
    @memmove(
        out[tail_src + delta .. client_hello_msg.len + delta],
        out[tail_src..client_hello_msg.len],
    );
    out[i..][0..10].* = .{
        0x00, 0x33,
        0x00, @intCast(new_ext_len),
        0x00, @intCast(2 + 2 + p256.public_length),
        0x00, @intFromEnum(NamedGroup.secp256r1),
        0x00, @intCast(p256.public_length),
    };
    @memcpy(out[i + 10 ..][0..p256.public_length], &public_key.data);

    const new_len = client_hello_msg.len + delta;
    const body_len: u24 = @intCast(new_len - handshake_header_len);
    out[1] = @truncate(body_len >> 16);
    out[2] = @truncate(body_len >> 8);
    out[3] = @truncate(body_len);
    const extensions_len_offset = clientHelloExtensionsLenOffset(out[0..new_len]);
    const ext_len = memx.readInt(u16, out[extensions_len_offset..][0..2]);
    memx.writeInt(u16, out[extensions_len_offset..][0..2], ext_len + @as(u16, @intCast(delta)));
    return out[0..new_len];
}

fn clientHelloWithP384KeyShare(
    out: []u8,
    client_hello_msg: []const u8,
    public_key: p384.PublicKey,
) []const u8 {
    @memcpy(out[0..client_hello_msg.len], client_hello_msg);
    var i: usize = 0;
    while (i + 4 < client_hello_msg.len) : (i += 1) {
        if (out[i] == 0x00 and out[i + 1] == 0x0a and out[i + 2] == 0x00 and out[i + 3] == 0x04) {
            out[i + 6] = 0x00;
            out[i + 7] = @intFromEnum(NamedGroup.secp384r1);
            break;
        }
    } else unreachable;

    i = 0;
    while (i + 4 < client_hello_msg.len) : (i += 1) {
        if (out[i] == 0x00 and out[i + 1] == 0x33 and
            out[i + 2] == 0x00 and out[i + 3] == 0x26) break;
    } else unreachable;

    const old_total: usize = 4 + 0x26;
    const new_ext_len: u16 = 2 + 2 + 2 + p384.public_length;
    const new_total: usize = 4 + new_ext_len;
    const delta = new_total - old_total;
    const tail_src = i + old_total;
    @memmove(
        out[tail_src + delta .. client_hello_msg.len + delta],
        out[tail_src..client_hello_msg.len],
    );
    out[i..][0..10].* = .{
        0x00, 0x33,
        0x00, @intCast(new_ext_len),
        0x00, @intCast(2 + 2 + p384.public_length),
        0x00, @intFromEnum(NamedGroup.secp384r1),
        0x00, @intCast(p384.public_length),
    };
    @memcpy(out[i + 10 ..][0..p384.public_length], &public_key.data);

    const new_len = client_hello_msg.len + delta;
    const body_len: u24 = @intCast(new_len - handshake_header_len);
    memx.writeInt(u24, out[1..4], body_len);
    const extensions_len_offset = clientHelloExtensionsLenOffset(out[0..new_len]);
    const ext_len = memx.readInt(u16, out[extensions_len_offset..][0..2]);
    memx.writeInt(u16, out[extensions_len_offset..][0..2], ext_len + @as(u16, @intCast(delta)));
    return out[0..new_len];
}

fn clientHelloWithBothKeyShares(
    out: []u8,
    client_hello_msg: []const u8,
    p256_public_key: p256.PublicKey,
) []const u8 {
    @memcpy(out[0..client_hello_msg.len], client_hello_msg);
    var len = client_hello_msg.len;
    const extensions_len_offset = clientHelloExtensionsLenOffset(client_hello_msg);

    var i: usize = 0;
    while (i + 8 <= len) : (i += 1) {
        if (out[i] == 0x00 and out[i + 1] == 0x0a and
            out[i + 2] == 0x00 and out[i + 3] == 0x04) break;
    } else unreachable;

    const groups_delta = 2;
    const groups_old_total = 4 + 4;
    @memmove(
        out[i + groups_old_total + groups_delta .. len + groups_delta],
        out[i + groups_old_total .. len],
    );
    out[i..][0..10].* = .{
        0x00, 0x0a,
        0x00, 0x06,
        0x00, 0x04,
        0x00, @intFromEnum(NamedGroup.x25519),
        0x00, @intFromEnum(NamedGroup.secp256r1),
    };
    len += groups_delta;

    i = 0;
    while (i + 10 <= len) : (i += 1) {
        if (out[i] == 0x00 and out[i + 1] == 0x33 and
            out[i + 2] == 0x00 and out[i + 3] == 0x26) break;
    } else unreachable;

    var x25519_public_key: [x25519.public_length]u8 = undefined;
    @memcpy(&x25519_public_key, out[i + 10 ..][0..x25519.public_length]);

    const old_total: usize = 4 + 0x26;
    const new_ext_len: u16 = 2 + 2 + 2 + x25519.public_length + 2 + 2 + p256.public_length;
    const new_total: usize = 4 + new_ext_len;
    const key_share_delta = new_total - old_total;
    const tail_src = i + old_total;
    @memmove(out[tail_src + key_share_delta .. len + key_share_delta], out[tail_src..len]);
    out[i..][0..10].* = .{
        0x00, 0x33,
        0x00, @intCast(new_ext_len),
        0x00, @intCast(new_ext_len - 2),
        0x00, @intFromEnum(NamedGroup.x25519),
        0x00, @intCast(x25519.public_length),
    };
    @memcpy(out[i + 10 ..][0..x25519.public_length], &x25519_public_key);
    const p256_offset = i + 10 + x25519.public_length;
    out[p256_offset..][0..4].* = .{
        0x00, @intFromEnum(NamedGroup.secp256r1),
        0x00, @intCast(p256.public_length),
    };
    @memcpy(out[p256_offset + 4 ..][0..p256.public_length], &p256_public_key.data);
    len += key_share_delta;

    const delta: u16 = @intCast(groups_delta + key_share_delta);
    const body_len: u24 = @intCast(len - handshake_header_len);
    memx.writeInt(u24, out[1..4], body_len);
    const ext_len = memx.readInt(u16, out[extensions_len_offset..][0..2]);
    memx.writeInt(u16, out[extensions_len_offset..][0..2], ext_len + delta);
    return out[0..len];
}

fn clientHelloExtensionsLenOffset(client_hello_msg: []const u8) usize {
    var offset: usize = handshake_header_len + 2 + 32;
    offset += 1 + client_hello_msg[offset];
    const suites_len = memx.readInt(u16, client_hello_msg[offset..][0..2]);
    offset += 2 + suites_len;
    offset += 1 + client_hello_msg[offset];
    return offset;
}

fn patchClientHelloKeyShareGroup(client_hello_msg: []u8, group: u16) void {
    var i: usize = 0;
    while (i + 9 < client_hello_msg.len) : (i += 1) {
        if (client_hello_msg[i] == 0x00 and client_hello_msg[i + 1] == 0x33) {
            client_hello_msg[i + 6] = @truncate(group >> 8);
            client_hello_msg[i + 7] = @truncate(group);
            return;
        }
    }
    unreachable;
}

fn compatibilityClientHello(
    out: []u8,
    client_hello_msg: []const u8,
    session_id: []const u8,
) []const u8 {
    assert(session_id.len <= 32);
    const session_id_len_offset = 38; // header(4) + legacy_version(2) + random(32)
    const session_id_offset = session_id_len_offset + 1;
    const compat_len = client_hello_msg.len + session_id.len;
    @memcpy(out[0..session_id_offset], client_hello_msg[0..session_id_offset]);
    @memcpy(out[session_id_offset..][0..session_id.len], session_id);
    @memcpy(
        out[session_id_offset + session_id.len .. compat_len],
        client_hello_msg[session_id_offset..],
    );
    out[session_id_len_offset] = @intCast(session_id.len);
    const body_len: u24 = @intCast(compat_len - handshake_header_len);
    out[1] = @truncate(body_len >> 16);
    out[2] = @truncate(body_len >> 8);
    out[3] = @truncate(body_len);
    return out[0..compat_len];
}

fn testConfig(keypair: x25519.KeyPair) !Config {
    return .{
        .keypairs = try .init(keypair),
        .random = .zero,
    };
}

// RFC 8446 §6 — alerts before handshake protection are plaintext records.
test "sendAlert: plaintext fatal alert before ClientHello" {
    var hs: ServerHandshake = .init(try testConfig(.generate()));
    var out: [16]u8 = undefined;
    const rec = try hs.sendAlert(.decode_error, &out);
    try testing.expectEqualSlices(u8, &.{ 0x15, 0x03, 0x03, 0x00, 0x02, 0x02, 0x32 }, rec);
    try testing.expectError(error.PendingWrite, hs.sendAlert(.decode_error, &out));
}

// RFC 8446 §6.1 — close_notify is sent as a warning-level alert.
test "sendAlert: encrypted close_notify after handshake" {
    var server = try connectedTestServer();
    var peer = try server.tx.clone();
    defer peer.deinit();
    var out: [64]u8 = undefined;
    const rec = try server.sendAlert(.close_notify, &out);

    var rec_buf: [64]u8 = undefined;
    @memcpy(rec_buf[0..rec.len], rec);
    const dec = try peer.decrypt(rec_buf[0..rec.len]);
    try testing.expectEqual(.alert, dec.content_type);
    try testing.expectEqualSlices(u8, &.{ 0x01, 0x00 }, dec.content);
}

// RFC 8446 §D.4 — CCS before ClientHello is outside the compatibility window.
test "handleRecord: rejects ChangeCipherSpec before ClientHello" {
    var hs: ServerHandshake = .init(try testConfig(.generate()));
    var ccs = [_]u8{ 0x14, 0x03, 0x03, 0x00, 0x01, 0x01 };
    var out: [64]u8 = undefined;
    try testing.expectError(error.UnexpectedRecord, hs.handleRecord(&ccs, &out));
}

// RFC 8446 §D.4 — a compatibility CCS with exactly payload 0x01 is ignored
// after ClientHello and before the peer Finished.
test "handleRecord: drops valid ChangeCipherSpec while waiting for client Finished" {
    const client_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    var record: [1024]u8 = undefined;
    const header: frame.Header = .init(.handshake, @intCast(ch.len));
    header.write(record[0..frame.header_len]);
    @memcpy(record[frame.header_len..][0..ch.len], ch);

    var hs: ServerHandshake = .init(try testConfig(.generate()));
    var out: [256]u8 = undefined;
    _ = try hs.handleRecord(record[0 .. frame.header_len + ch.len], &out);
    hs.completeWrite();

    var ccs = [_]u8{ 0x14, 0x03, 0x03, 0x00, 0x01, 0x01 };
    try testing.expectEqual(Event.none, try hs.handleRecord(&ccs, &out));
}

// RFC 8446 §D.4 — any CCS payload other than exactly byte 0x01 is invalid.
test "handleRecord: rejects malformed ChangeCipherSpec payload" {
    const client_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    var record: [1024]u8 = undefined;
    const header: frame.Header = .init(.handshake, @intCast(ch.len));
    header.write(record[0..frame.header_len]);
    @memcpy(record[frame.header_len..][0..ch.len], ch);

    var hs: ServerHandshake = .init(try testConfig(.generate()));
    var out: [256]u8 = undefined;
    _ = try hs.handleRecord(record[0 .. frame.header_len + ch.len], &out);
    hs.completeWrite();

    var ccs = [_]u8{ 0x14, 0x03, 0x03, 0x00, 0x01, 0x02 };
    try testing.expectError(error.UnexpectedRecord, hs.handleRecord(&ccs, &out));
}

// RFC 8446 §5 — server handleRecord emits ServerHello and blocks until written.
test "handleRecord: ClientHello returns ServerHello write and enforces pending write" {
    const client_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    var record: [1024]u8 = undefined;
    const header: frame.Header = .init(.handshake, @intCast(ch.len));
    header.write(record[0..frame.header_len]);
    @memcpy(record[frame.header_len..][0..ch.len], ch);

    var hs: ServerHandshake = .init(try testConfig(.generate()));
    var out: [256]u8 = undefined;
    const ev = try hs.handleRecord(record[0 .. frame.header_len + ch.len], &out);
    try testing.expectEqual(.wait_client_finished, hs.state);
    const written = ev.write;
    const hdr = try frame.parseHeader(written);
    try testing.expectEqual(.handshake, hdr.content_type);
    try testing.expectError(
        error.PendingWrite,
        hs.handleRecord(record[0 .. frame.header_len + ch.len], &out),
    );
    hs.completeWrite();
}

// RFC 8446 §5.1 — handshake records cannot carry zero-length fragments.
test "handleRecord: zero-length plaintext handshake is rejected" {
    var hs: ServerHandshake = .init(try testConfig(.generate()));
    var rec = [_]u8{ 0x16, 0x03, 0x03, 0x00, 0x00 };
    var out: [64]u8 = undefined;
    try testing.expectError(error.UnexpectedRecord, hs.handleRecord(&rec, &out));
}

// RFC 8446 §5.1 — application_data is invalid before the handshake completes.
test "handleRecord: rejects application_data before connected" {
    var hs: ServerHandshake = .init(try testConfig(.generate()));
    var rec = [_]u8{ 0x17, 0x03, 0x03, 0x00, 0x05 } ++ [_]u8{0} ** 5;
    var out: [64]u8 = undefined;
    try testing.expectError(error.UnexpectedRecord, hs.handleRecord(&rec, &out));
}

test "acceptClientHello: emits ServerHello and installs handshake keys" {
    const client_keypair: x25519.KeyPair = .generate();
    const server_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(
        &ch_buf,
        .zero,
        client_keypair.public_key,
        "example.com",
        &.{ "h2", "http/1.1" },
    );
    var record: [1024]u8 = undefined;
    const header: frame.Header = .init(.handshake, @intCast(ch.len));
    header.write(record[0..frame.header_len]);
    @memcpy(record[frame.header_len..][0..ch.len], ch);

    var hs: ServerHandshake = .init(try testConfig(server_keypair));
    hs.supportAlpn(&.{"http/1.1"});
    var out: [256]u8 = undefined;
    const sh_record = try hs.acceptClientHello(record[0 .. frame.header_len + ch.len], &out);
    try testing.expectEqual(.wait_client_finished, hs.state);
    try testing.expectEqualStrings("http/1.1", hs.selectedAlpnProtocol().?);

    const hdr = try frame.parseHeader(sh_record);
    try testing.expectEqual(.handshake, hdr.content_type);
    try testing.expectEqual(frame.header_len + @as(usize, hdr.length()), sh_record.len);
    const sh = try server_hello.parse(sh_record[frame.header_len..][0..hdr.length()]);
    try testing.expectEqual(.aes_128_gcm_sha256, sh.cipher_suite);
    try testing.expectEqualSlices(u8, &server_keypair.public_key.data, &sh.key_share.x25519.data);

    var client_hs: ClientHandshake = .init(.{
        .keypairs = try .init(client_keypair),
        .host_name = "ztls.server.test",
        .now_sec = 0,
        .random = .zero,
    });
    client_hs.injectClientHello(ch);
    try client_hs.processServerHello(sh_record[frame.header_len..][0..hdr.length()]);
    try testing.expectEqualSlices(u8, &client_hs.rx.iv.data, &hs.tx.iv.data);
    try testing.expectEqualSlices(u8, &client_hs.tx.iv.data, &hs.rx.iv.data);
}

// RFC 8446 Appendix D.4 — if the client sends a non-empty legacy_session_id,
// the server sends a compatibility ChangeCipherSpec after ServerHello and
// before the encrypted handshake flight.
// RFC 8446 §4.1.4 — when ClientHello offers X25519 in supported_groups but no
// X25519 KeyShareEntry, the server sends HRR requesting X25519.
// RFC 8446 §4.2.7, §4.2.8 — a server that supports secp256r1 may select a
// P-256 key share when the client offers only that implemented group.
test "acceptClientHello: negotiates secp256r1 key share" {
    const client_x25519: x25519.KeyPair = .generate();
    const server_x25519: x25519.KeyPair = .generate();
    const client_p256 = try p256.KeyPair.generateDeterministic(.init(test_p256_seed_a));
    const server_p256 = try p256.KeyPair.generateDeterministic(.init(test_p256_seed_b));

    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_x25519.public_key, null, &.{});
    var p256_ch_buf: [768]u8 = undefined;
    const p256_ch = clientHelloWithP256KeyShare(&p256_ch_buf, ch, client_p256.public_key);
    var record: [1024]u8 = undefined;
    const header: frame.Header = .init(.handshake, @intCast(p256_ch.len));
    header.write(record[0..frame.header_len]);
    @memcpy(record[frame.header_len..][0..p256_ch.len], p256_ch);

    var hs: ServerHandshake = .init(.{
        .keypairs = .initWithP256(server_x25519, server_p256),
        .random = .zero,
    });
    var out: [512]u8 = undefined;
    const sh_record = try hs.acceptClientHello(
        record[0 .. frame.header_len + p256_ch.len],
        &out,
    );

    const hdr = try frame.parseHeader(sh_record);
    const sh = sh_record[frame.header_len..][0..hdr.length()];
    var found_p256_key_share = false;
    var i: usize = 0;
    while (i + 4 < sh.len) : (i += 1) {
        if (sh[i] == 0x00 and sh[i + 1] == 0x33) {
            try testing.expectEqualSlices(
                u8,
                &.{ 0x00, 0x45, 0x00, 0x17, 0x00, 0x41 },
                sh[i + 2 ..][0..6],
            );
            try testing.expectEqualSlices(
                u8,
                &server_p256.public_key.data,
                sh[i + 8 ..][0..p256.public_length],
            );
            found_p256_key_share = true;
            break;
        }
    }
    try testing.expect(found_p256_key_share);
    try testing.expectEqual(NamedGroup.secp256r1, hs.negotiated_group);
    try testing.expectEqual(.wait_client_finished, hs.state);
}

// RFC 8446 §4.2.8.2, §7.1 — client and server derive matching handshake keys
// when the only offered key share is secp384r1.
test "acceptClientHello: negotiates secp384r1 key share" {
    const client_x25519: x25519.KeyPair = .generate();
    const server_x25519: x25519.KeyPair = .generate();
    const client_p256 = try p256.KeyPair.generateDeterministic(.init(test_p256_seed_a));
    const server_p256 = try p256.KeyPair.generateDeterministic(.init(test_p256_seed_b));
    const client_p384 = try p384.KeyPair.generateDeterministic(.init(test_p384_seed_a));
    const server_p384 = try p384.KeyPair.generateDeterministic(.init(test_p384_seed_b));

    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_x25519.public_key, null, &.{});
    var p384_ch_buf: [768]u8 = undefined;
    const p384_ch = clientHelloWithP384KeyShare(&p384_ch_buf, ch, client_p384.public_key);
    var record: [1024]u8 = undefined;
    const header: frame.Header = .init(.handshake, @intCast(p384_ch.len));
    header.write(record[0..frame.header_len]);
    @memcpy(record[frame.header_len..][0..p384_ch.len], p384_ch);

    var hs: ServerHandshake = .init(.{
        .keypairs = .initWithP256P384(server_x25519, server_p256, server_p384),
        .random = .zero,
    });
    var out: [512]u8 = undefined;
    const sh_record = try hs.acceptClientHello(
        record[0 .. frame.header_len + p384_ch.len],
        &out,
    );
    try testing.expectEqual(NamedGroup.secp384r1, hs.negotiated_group);

    const hdr = try frame.parseHeader(sh_record);
    const sh = try server_hello.parse(sh_record[frame.header_len..][0..hdr.length()]);
    try testing.expectEqualSlices(u8, &server_p384.public_key.data, &sh.key_share.secp384r1.data);

    var client_hs: ClientHandshake = .init(.{
        .keypairs = .initWithP256P384(client_x25519, client_p256, client_p384),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    client_hs.injectClientHello(p384_ch);
    try client_hs.processServerHello(sh_record[frame.header_len..][0..hdr.length()]);
    try testing.expectEqualSlices(u8, &client_hs.rx.iv.data, &hs.tx.iv.data);
    try testing.expectEqualSlices(u8, &client_hs.tx.iv.data, &hs.rx.iv.data);
}

// RFC 8446 §4.1.4 — if the server selects P-256 and the ClientHello omitted a
// matching share, the retry request names secp256r1.
test "acceptClientHello: emits HelloRetryRequest for missing secp256r1 key share" {
    const client_x25519: x25519.KeyPair = .generate();
    const client_p256 = try p256.KeyPair.generateDeterministic(.init(test_p256_seed_a));
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_x25519.public_key, null, &.{});
    var p256_ch_buf: [768]u8 = undefined;
    const p256_ch = clientHelloWithP256KeyShare(&p256_ch_buf, ch, client_p256.public_key);
    patchClientHelloKeyShareGroup(p256_ch_buf[0..p256_ch.len], 0x6a6a);

    var record: [1024]u8 = undefined;
    const header: frame.Header = .init(.handshake, @intCast(p256_ch.len));
    header.write(record[0..frame.header_len]);
    @memcpy(record[frame.header_len..][0..p256_ch.len], p256_ch);

    var server: ServerHandshake = .init(try testConfig(.generate()));
    var out: [256]u8 = undefined;
    const hrr_record = try server.acceptClientHello(
        record[0 .. frame.header_len + p256_ch.len],
        &out,
    );
    const hrr_hdr = try frame.parseHeader(hrr_record);
    const hrr = try server_hello.parseHelloRetryRequest(
        hrr_record[frame.header_len..][0..hrr_hdr.length()],
    );
    try testing.expectEqual(NamedGroup.secp256r1, hrr.selected_group.?);
}

// RFC 8446 §4.1.2 — after HelloRetryRequest, ClientHello2 may differ from
// ClientHello1 only in the explicitly permitted fields. SNI and ALPN are not
// among them, so either change is rejected with illegal_parameter.
test "acceptClientHello: rejects ClientHello2 with changed SNI or ALPN after HRR" {
    const Case = struct {
        ch1_sni: []const u8,
        ch2_sni: []const u8,
        ch1_alpn: root.AlpnProtocols,
        ch2_alpn: root.AlpnProtocols,
    };
    const cases = [_]Case{
        .{
            .ch1_sni = "one.example",
            .ch2_sni = "two.example",
            .ch1_alpn = &.{"h2"},
            .ch2_alpn = &.{"h2"},
        },
        .{
            .ch1_sni = "one.example",
            .ch2_sni = "one.example",
            .ch1_alpn = &.{"h2"},
            .ch2_alpn = &.{"http/1.1"},
        },
    };

    for (cases) |case| {
        const client_keypair: x25519.KeyPair = .generate();
        var ch1_buf: [512]u8 = undefined;
        const ch1 = try client_hello.encode(
            &ch1_buf,
            .zero,
            client_keypair.public_key,
            case.ch1_sni,
            case.ch1_alpn,
        );
        patchClientHelloKeyShareGroup(@constCast(ch1), 0x6a6a);

        var ch1_record: [1024]u8 = undefined;
        const ch1_header: frame.Header = .init(.handshake, @intCast(ch1.len));
        ch1_header.write(ch1_record[0..frame.header_len]);
        @memcpy(ch1_record[frame.header_len..][0..ch1.len], ch1);

        var server: ServerHandshake = .init(try testConfig(.generate()));
        server.supportAlpn(&.{ "h2", "http/1.1" });
        var out: [512]u8 = undefined;
        _ = try server.acceptClientHello(ch1_record[0 .. frame.header_len + ch1.len], &out);
        try testing.expectEqualStrings("one.example", server.clientServerName().?);
        try testing.expectEqualStrings("h2", server.selectedAlpnProtocol().?);

        var ch2_buf: [512]u8 = undefined;
        const ch2 = try client_hello.encode(
            &ch2_buf,
            .zero,
            client_keypair.public_key,
            case.ch2_sni,
            case.ch2_alpn,
        );
        var ch2_record: [1024]u8 = undefined;
        const ch2_header: frame.Header = .init(.handshake, @intCast(ch2.len));
        ch2_header.write(ch2_record[0..frame.header_len]);
        @memcpy(ch2_record[frame.header_len..][0..ch2.len], ch2);

        try testing.expectError(
            error.IllegalParameter,
            server.acceptClientHello(ch2_record[0 .. frame.header_len + ch2.len], &out),
        );
        try testing.expectEqualStrings("one.example", server.clientServerName().?);
        try testing.expectEqualStrings("h2", server.selectedAlpnProtocol().?);
    }
}

// RFC 8446 §4.1.2, §4.2.10 — ClientHello2 MUST remove early_data because
// 0-RTT is not compatible with HelloRetryRequest.
test "acceptClientHello: rejects early_data in ClientHello2 after HRR" {
    const psk: [32]u8 = @splat(0x5a);
    const identity = [_]u8{ 0x2c, 0x03, 0x5d, 0x82 };
    const Lookup = struct {
        fn lookup(_: *anyopaque, offered_identity: []const u8) ?PskEntry {
            if (!mem.eql(u8, offered_identity, &identity)) return null;
            return .{
                .psk = &psk,
                .cipher_suite = .aes_128_gcm_sha256,
                .max_early_data_size = 16384,
            };
        }
    };

    const client_keypair: x25519.KeyPair = .generate();
    var ch1_buf: [512]u8 = undefined;
    const ch1 = try client_hello.encode(&ch1_buf, .zero, client_keypair.public_key, null, &.{});
    patchClientHelloKeyShareGroup(ch1, 0x6a6a);
    var ch1_record: [1024]u8 = undefined;
    const ch1_header: frame.Header = .init(.handshake, @intCast(ch1.len));
    ch1_header.write(ch1_record[0..frame.header_len]);
    @memcpy(ch1_record[frame.header_len..][0..ch1.len], ch1);

    var lookup_context: u8 = 0;
    var server: ServerHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .random = .zero,
        .psk_lookup = .{ .context = &lookup_context, .lookup = Lookup.lookup },
    });
    var out: [1024]u8 = undefined;
    _ = try server.acceptClientHello(ch1_record[0 .. frame.header_len + ch1.len], &out);
    try testing.expect(server.early_rx == null);

    var ch2_buf: [1024]u8 = undefined;
    const ch2_result = try client_hello.encodeWithPsk(
        &ch2_buf,
        .zero,
        client_keypair.public_key,
        null,
        null,
        null,
        &.{},
        .psk_dhe_ke,
        &identity,
        0,
        Sha256.digest_length,
        true,
    );
    const early = hkdf.HkdfSha256.pskEarlySecret(&psk);
    const binder_key = hkdf.HkdfSha256.resumptionBinderKey(early);
    const finished_key = hkdf.HkdfSha256.finishedKey(binder_key);
    var transcript_hash: hkdf.HkdfSha256.TranscriptHash = undefined;
    Sha256.hash(ch2_result.msg[0..ch2_result.prefix_len], &transcript_hash.data, .{});
    const binder = hkdf.HkdfSha256.binder(finished_key, &transcript_hash);
    @memcpy(ch2_result.msg[ch2_result.binder_offset..][0..binder.len], &binder);

    var ch2_record: [1536]u8 = undefined;
    const ch2_header: frame.Header = .init(.handshake, @intCast(ch2_result.msg.len));
    ch2_header.write(ch2_record[0..frame.header_len]);
    @memcpy(ch2_record[frame.header_len..][0..ch2_result.msg.len], ch2_result.msg);
    const ch2_record_slice = ch2_record[0 .. frame.header_len + ch2_result.msg.len];
    try testing.expectError(
        error.IllegalParameter,
        server.acceptClientHello(ch2_record_slice, &out),
    );
    try testing.expect(server.early_rx == null);
}

/// Test-only fixed-buffer harness for the RFC 8446 §4.1.2 PSK identity
/// continuity tests. Owns the ClientHello1 and HelloRetryRequest bytes so
/// ClientHello2 binders can be computed over the exact retry transcript
/// (§4.2.11.2: message_hash(ClientHello1) || HRR || Truncate(ClientHello2)).
const RetryPskHarness = struct {
    base: [4096]u8 = undefined,
    ch2_base: [4096]u8 = undefined,
    ch1_msg: [4096]u8 = undefined,
    ch2_msg: [4096]u8 = undefined,
    ch1_record: [4096]u8 = undefined,
    ch2_record: [4096]u8 = undefined,
    hrr_record: [512]u8 = undefined,
    out: [1024]u8 = undefined,
    ch1_len: usize = 0,
    hrr_len: usize = 0,

    fn encodeBase(buf: []u8, keypair: x25519.KeyPair) !client_hello.PskEncodeResult {
        // Identity "x" is a placeholder: clientHelloWithPskIdentities
        // replaces the whole pre_shared_key extension.
        return client_hello.encodeWithPsk(
            buf,
            .zero,
            keypair.public_key,
            null,
            null,
            null,
            &.{},
            .psk_dhe_ke,
            "x",
            0,
            Sha256.digest_length,
            false,
        );
    }

    /// Build a framed ClientHello1 whose pre_shared_key extension carries
    /// `offers` (plus `identities_slack` trailing bytes inside the identities
    /// vector, for malformed-input regressions) and whose key_share group is
    /// patched to `share_group` (0x6a6a GREASE forces HelloRetryRequest; the
    /// real group leaves a usable share). Retains the message for
    /// `ch1Msg()`.
    fn buildCh1Record(
        self: *RetryPskHarness,
        keypair: x25519.KeyPair,
        offers: []const TestPskOffer,
        identities_slack: usize,
        share_group: u16,
    ) ![]u8 {
        const base = try encodeBase(&self.base, keypair);
        const multi = try clientHelloWithPskIdentities(
            &self.ch1_msg,
            base.msg,
            offers,
            identities_slack,
        );
        patchClientHelloKeyShareGroup(self.ch1_msg[0..multi.msg.len], share_group);
        self.ch1_len = multi.msg.len;
        return handshakeRecord(&self.ch1_record, self.ch1_msg[0..self.ch1_len]);
    }

    /// Feed `server` a ClientHello1 with no usable key_share (GREASE group,
    /// so the server must HelloRetryRequest) and `offers` as its
    /// pre_shared_key identity list. Binders stay zero-filled: after an HRR
    /// the binder must be recomputed anyway (§4.1.2), so CH1 binder validity
    /// is irrelevant on this path.
    fn sendCh1(
        self: *RetryPskHarness,
        server: *ServerHandshake,
        keypair: x25519.KeyPair,
        offers: []const TestPskOffer,
    ) !void {
        const record = try self.buildCh1Record(keypair, offers, 0, 0x6a6a);
        const hrr = try server.acceptClientHello(record, &self.out);
        try testing.expectEqual(.wait_ch, server.state);
        const hrr_hdr = try frame.parseHeader(hrr);
        try testing.expectEqual(.handshake, hrr_hdr.content_type);
        self.hrr_len = hrr.len;
        @memcpy(self.hrr_record[0..hrr.len], hrr);
    }

    /// Build an unframed ClientHello2 with the same non-PSK fields as the
    /// harness ClientHello1, `offers` as its pre_shared_key identity list,
    /// and optionally `identities_slack` trailing bytes inside the
    /// identities vector (malformed-input regressions).
    fn buildCh2(
        self: *RetryPskHarness,
        keypair: x25519.KeyPair,
        offers: []const TestPskOffer,
        identities_slack: usize,
    ) !MultiPskClientHello {
        const base = try encodeBase(&self.ch2_base, keypair);
        const multi = try clientHelloWithPskIdentities(
            &self.ch2_msg,
            base.msg,
            offers,
            identities_slack,
        );
        return multi;
    }

    fn frameCh2(self: *RetryPskHarness, msg: []const u8) []u8 {
        return handshakeRecord(&self.ch2_record, msg);
    }

    fn ch1Msg(self: *const RetryPskHarness) []const u8 {
        return self.ch1_msg[0..self.ch1_len];
    }

    /// The HelloRetryRequest handshake message (record header stripped).
    fn hrrMsg(self: *const RetryPskHarness) []const u8 {
        return self.hrr_record[frame.header_len..self.hrr_len];
    }
};

fn handshakeRecord(out: []u8, msg: []const u8) []u8 {
    const header: frame.Header = .init(.handshake, @intCast(msg.len));
    header.write(out[0..frame.header_len]);
    @memcpy(out[frame.header_len..][0..msg.len], msg);
    return out[0 .. frame.header_len + msg.len];
}

const TestPskOffer = struct {
    identity: []const u8,
    obfuscated_ticket_age: u32 = 0,
    /// Binder entry length emitted for this offer. RFC 8446 §4.2.11.2: the
    /// binder is an HMAC over the transcript hash, so its length is the hash
    /// output of the PSK's cipher suite (32 SHA-256, 48 SHA-384).
    binder_len: u8 = Sha256.digest_length,
};

const MultiPskClientHello = struct {
    msg: []u8,
    /// Offset where the binders list begins: the binder transcript prefix
    /// is msg[0..binder_list_offset]. RFC 8446 §4.2.11.2.
    binder_list_offset: usize,
};

/// Test-only ClientHello builder for pre_shared_key offers carrying an
/// arbitrary identity list (the production encoder offers one identity).
/// Replaces the trailing pre_shared_key extension of a single-identity
/// `encodeWithPsk` message and patches the enclosing length fields
/// (handshake header u24, extensions block u16, ext_data u16). RFC 8446
/// §4.2.11: pre_shared_key is the last extension, so nothing after it moves.
/// Binders are emitted zero-filled with each offer's `binder_len`; the
/// caller patches them via `multiPskBinderOffset`. `identities_slack` appends
/// trailing bytes inside the identities vector (counted in its length, not
/// part of any entry) for malformed-input regressions.
fn clientHelloWithPskIdentities(
    out: []u8,
    base: []const u8,
    offers: []const TestPskOffer,
    identities_slack: usize,
) (error{ BufferTooShort, NoPskExtension } || client_hello.ParseError)!MultiPskClientHello {
    const parsed = try client_hello.parse(base);
    const psk_ext = parsed.psk_ext orelse return error.NoPskExtension;
    // psk_ext points at ext_data; the 4-byte extension header precedes it.
    const ext_start = (@intFromPtr(psk_ext.ptr) - @intFromPtr(base.ptr)) - 4;

    var identities_len: usize = identities_slack;
    var binders_len: usize = 2;
    for (offers) |offer| {
        identities_len += 2 + offer.identity.len + 4;
        binders_len += 1 + offer.binder_len;
    }
    const ext_data_len: usize = 2 + identities_len + binders_len;
    const total: usize = ext_start + 4 + ext_data_len;
    if (out.len < total) return error.BufferTooShort;

    @memcpy(out[0..ext_start], base[0..ext_start]);
    var w: wiremod.Writer = .init(out[ext_start..]);
    w.append(u16, 0x0029); // ExtensionType.pre_shared_key
    w.append(u16, @intCast(ext_data_len));
    w.append(u16, @intCast(identities_len));
    for (offers) |offer| {
        w.append(u16, @intCast(offer.identity.len));
        w.appendSlice(offer.identity);
        w.append(u32, offer.obfuscated_ticket_age);
    }
    const slack: [8]u8 = @splat(0);
    var slack_left = identities_slack;
    while (slack_left >= slack.len) : (slack_left -= slack.len) w.appendSlice(&slack);
    if (slack_left > 0) w.appendSlice(slack[0..slack_left]);
    const binder_list_offset = ext_start + w.pos;
    w.append(u16, @intCast(binders_len - 2));
    for (offers) |offer| {
        w.append(u8, offer.binder_len);
        var binder: [48]u8 = @splat(0); // max binder length covers SHA-384
        w.appendSlice(binder[0..offer.binder_len]);
    }
    assert(w.pos + ext_start == total);

    // Patch the enclosing lengths: pre_shared_key is the last extension.
    memx.writeInt(u24, out[1..4], @intCast(total - handshake_header_len));
    const ext_len_offset = clientHelloExtensionsLenOffset(out[0..total]);
    const ext_block_len = ext_start - (ext_len_offset + 2) + 4 + ext_data_len;
    memx.writeInt(u16, out[ext_len_offset..][0..2], @intCast(ext_block_len));
    return .{ .msg = out[0..total], .binder_list_offset = binder_list_offset };
}

/// Offset of offer `index`'s binder bytes in a MultiPskClientHello: the
/// binders list is a 2-byte list length, then per binder a 1-byte entry
/// length followed by the binder. RFC 8446 §4.2.11.
fn multiPskBinderOffset(
    hello: MultiPskClientHello,
    offers: []const TestPskOffer,
    index: usize,
) usize {
    var offset = hello.binder_list_offset + 2 + 1;
    for (offers[0..index]) |offer| offset += 1 + offer.binder_len;
    return offset;
}

/// SHA-256 PSK binder over the retry transcript: message_hash(ClientHello1)
/// || HelloRetryRequest || Truncate(ClientHello2). RFC 8446 §4.2.11.2,
/// §4.4.1. Mirrors verifyBinderSha's psk_dhe_ke/SHA-256 path.
fn retryTestBinderSha256(
    psk: []const u8,
    ch1_msg: []const u8,
    hrr_msg: []const u8,
    ch2_prefix: []const u8,
) [hkdf.HkdfSha256.prk_len]u8 {
    var ch1_hash: [Sha256.digest_length]u8 = undefined;
    Sha256.hash(ch1_msg, &ch1_hash, .{});
    const synthetic = transcript_util.messageHashSynthetic(Sha256.digest_length, ch1_hash);
    var transcript: Sha256 = .init(.{});
    transcript.update(&synthetic);
    transcript.update(hrr_msg);
    transcript.update(ch2_prefix);
    const digest = transcript.peek();
    var th: hkdf.HkdfSha256.TranscriptHash = undefined;
    @memcpy(&th.data, &digest);
    const early = hkdf.HkdfSha256.pskEarlySecret(psk);
    const binder_key = hkdf.HkdfSha256.resumptionBinderKey(early);
    const fin_key = hkdf.HkdfSha256.finishedKey(binder_key);
    return hkdf.HkdfSha256.binder(fin_key, &th);
}

const RetryPskLookupEntry = struct {
    identity: []const u8,
    psk: []const u8,
    cipher_suite: CipherSuite,
};

const RetryPskTable = struct {
    entries: []const RetryPskLookupEntry,

    fn lookup(context: *anyopaque, identity: []const u8) ?PskEntry {
        const self: *RetryPskTable = @ptrCast(@alignCast(context));
        for (self.entries) |entry| {
            if (mem.eql(u8, entry.identity, identity))
                return .{ .psk = entry.psk, .cipher_suite = entry.cipher_suite };
        }
        return null;
    }
};

// RFC 8446 §4.1.2 — after HelloRetryRequest, ClientHello2 may update PSK
// ages and binders and drop hash-incompatible identities, but MUST NOT
// replace an offered identity. The replacement identity here is known to
// the server and its binder is valid over the retry transcript, so without
// identity-continuity enforcement the server would accept and resume with
// the substituted PSK. Regression for #103.
test "acceptClientHello: rejects replaced PSK identity in ClientHello2 despite valid binder" {
    const psk_a: [32]u8 = @splat(0xa5);
    const psk_b: [32]u8 = @splat(0x5a);
    const identity_a = [_]u8{0x11};
    const identity_b = [_]u8{0x22};
    var table: RetryPskTable = .{ .entries = &.{
        .{
            .identity = &identity_a,
            .psk = &psk_a,
            .cipher_suite = .aes_128_gcm_sha256,
        },
        .{
            .identity = &identity_b,
            .psk = &psk_b,
            .cipher_suite = .aes_128_gcm_sha256,
        },
    } };
    const client_keypair: x25519.KeyPair = .generate();

    var server: ServerHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .random = .zero,
        .psk_lookup = .{ .context = &table, .lookup = RetryPskTable.lookup },
    });
    server.supportSuites(&.{.aes_128_gcm_sha256});

    var harness: RetryPskHarness = .{};
    try harness.sendCh1(&server, client_keypair, &.{.{ .identity = &identity_a }});

    // ClientHello2 substitutes identity_b for identity_a, with a binder
    // psk_b computes correctly over the retry transcript.
    const offers = [_]TestPskOffer{.{ .identity = &identity_b }};
    const ch2 = try harness.buildCh2(client_keypair, &offers, 0);
    const binder = retryTestBinderSha256(
        &psk_b,
        harness.ch1Msg(),
        harness.hrrMsg(),
        ch2.msg[0..ch2.binder_list_offset],
    );
    @memcpy(harness.ch2_msg[multiPskBinderOffset(ch2, &offers, 0)..][0..binder.len], &binder);

    try testing.expectError(
        error.IllegalParameter,
        server.acceptClientHello(harness.frameCh2(ch2.msg), &harness.out),
    );
    try testing.expectEqual(.wait_ch, server.state);
    try testing.expect(server.selected_psk == null);
}

// RFC 8446 §4.1.2 — ClientHello2's pre_shared_key identity list must be
// ClientHello1's in offer order: identities may not be added, reordered, or
// (for identities the server knows are hash-compatible with the HRR cipher
// suite) dropped. Binders are zero: the continuity check runs before binder
// verification, so these rejections are its own.
test "acceptClientHello: rejects added, reordered, or dropped PSK identities in CH2" {
    const psk_a: [32]u8 = @splat(0xa5);
    const psk_b: [32]u8 = @splat(0x5a);
    const identity_a = [_]u8{0x11};
    const identity_b = [_]u8{0x22};
    var table: RetryPskTable = .{ .entries = &.{
        .{
            .identity = &identity_a,
            .psk = &psk_a,
            .cipher_suite = .aes_128_gcm_sha256,
        },
        .{
            .identity = &identity_b,
            .psk = &psk_b,
            .cipher_suite = .aes_128_gcm_sha256,
        },
    } };
    const client_keypair: x25519.KeyPair = .generate();

    const Case = struct {
        ch1: []const TestPskOffer,
        ch2: []const TestPskOffer,
    };
    const cases = [_]Case{
        // Addition: identity_b was never offered in ClientHello1.
        .{ .ch1 = &.{.{ .identity = &identity_a }}, .ch2 = &.{
            .{ .identity = &identity_a },
            .{ .identity = &identity_b },
        } },
        // Reorder: both identities retained, but out of offer order.
        .{ .ch1 = &.{
            .{ .identity = &identity_a },
            .{ .identity = &identity_b },
        }, .ch2 = &.{
            .{ .identity = &identity_b },
            .{ .identity = &identity_a },
        } },
        // Removal of a known hash-compatible identity: only incompatible
        // (or unresolvable) identities may be dropped.
        .{ .ch1 = &.{
            .{ .identity = &identity_a },
            .{ .identity = &identity_b },
        }, .ch2 = &.{.{ .identity = &identity_b }} },
    };

    for (cases) |case| {
        var server: ServerHandshake = .init(.{
            .keypairs = try .init(.generate()),
            .random = .zero,
            .psk_lookup = .{ .context = &table, .lookup = RetryPskTable.lookup },
        });
        server.supportSuites(&.{.aes_128_gcm_sha256});

        var harness: RetryPskHarness = .{};
        try harness.sendCh1(&server, client_keypair, case.ch1);
        const ch2 = try harness.buildCh2(client_keypair, case.ch2, 0);
        try testing.expectError(
            error.IllegalParameter,
            server.acceptClientHello(harness.frameCh2(ch2.msg), &harness.out),
        );
    }
}

// RFC 8446 §4.1.2 — the permitted ClientHello2 pre_shared_key updates: the
// client may recompute obfuscated_ticket_age and binders, and may drop
// identities hash-incompatible with the HRR cipher suite — established by
// the lookup entry for known PSKs or by the binder length (§4.2.11.2: the
// binder length is the PSK's hash output) for unknown ones. Each case must
// still resume with the retained PSK.
test "acceptClientHello: accepts permitted ClientHello2 PSK updates after HRR" {
    const psk_compatible: [32]u8 = @splat(0x33);
    const psk_incompatible: [48]u8 = @splat(0x66);
    const identity_compatible = [_]u8{0x33};
    const identity_incompatible = [_]u8{0x66};
    const identity_unknown = [_]u8{0x99};
    var table: RetryPskTable = .{ .entries = &.{
        .{
            .identity = &identity_compatible,
            .psk = &psk_compatible,
            .cipher_suite = .aes_128_gcm_sha256,
        },
        .{
            .identity = &identity_incompatible,
            .psk = &psk_incompatible,
            .cipher_suite = .aes_256_gcm_sha384,
        },
    } };
    const client_keypair: x25519.KeyPair = .generate();

    const Case = struct {
        ch1: []const TestPskOffer,
        ch2: []const TestPskOffer,
    };
    const cases = [_]Case{
        // Age/binder recomputation only: same identity, new age, binder
        // recomputed over the retry transcript.
        .{ .ch1 = &.{.{ .identity = &identity_compatible }}, .ch2 = &.{
            .{ .identity = &identity_compatible, .obfuscated_ticket_age = 0x11223344 },
        } },
        // Permitted removal: identity_incompatible resolves to a SHA-384
        // PSK (48-byte binder), incompatible with the HRR's AES-128/SHA-256
        // suite — the one removal §4.1.2 permits.
        .{ .ch1 = &.{
            .{ .identity = &identity_incompatible, .binder_len = 48 },
            .{ .identity = &identity_compatible },
        }, .ch2 = &.{.{ .identity = &identity_compatible }} },
        // Permitted removal: identity_unknown does not resolve in the
        // lookup, and its 48-byte binder (§4.2.11.2: binder length = the
        // PSK's hash output) claims a SHA-384 PSK — incompatible with the
        // HRR suite, so it may be dropped.
        .{ .ch1 = &.{
            .{ .identity = &identity_unknown, .binder_len = 48 },
            .{ .identity = &identity_compatible },
        }, .ch2 = &.{.{ .identity = &identity_compatible }} },
    };

    for (cases) |case| {
        var server: ServerHandshake = .init(.{
            .keypairs = try .init(.generate()),
            .random = .zero,
            .psk_lookup = .{ .context = &table, .lookup = RetryPskTable.lookup },
        });
        server.supportSuites(&.{.aes_128_gcm_sha256});

        var harness: RetryPskHarness = .{};
        try harness.sendCh1(&server, client_keypair, case.ch1);
        const ch2 = try harness.buildCh2(client_keypair, case.ch2, 0);
        const binder = retryTestBinderSha256(
            &psk_compatible,
            harness.ch1Msg(),
            harness.hrrMsg(),
            ch2.msg[0..ch2.binder_list_offset],
        );
        @memcpy(harness.ch2_msg[multiPskBinderOffset(ch2, case.ch2, 0)..][0..binder.len], &binder);

        _ = try server.acceptClientHello(harness.frameCh2(ch2.msg), &harness.out);
        try testing.expectEqual(.wait_client_finished, server.state);
        try testing.expect(server.selected_psk != null);
        // The retained identity is index 0 in ClientHello2's offer list.
        try testing.expectEqual(@as(u16, 0), server.selected_psk_index);
        try testing.expectEqualSlices(u8, &psk_compatible, server.selected_psk.?.psk);
    }
}

// RFC 8446 §4.1.2 — identity continuity across a HelloRetryRequest requires
// retaining ClientHello1's offered identities, and the engine's retention is
// a fixed-capacity, allocation-free structure. A ClientHello1 offering more
// identities than `max_retry_psk_identities` is therefore rejected with
// TooManyPskIdentities before the HelloRetryRequest is emitted — an explicit
// documented admission bound, not a silent claim of support beyond it. The
// bound applies only when a retry is actually needed: with a usable key_share
// the server never retains CH1 identities and any count is fine.
test "acceptClientHello: bounded PSK identity admission before HelloRetryRequest" {
    const client_keypair: x25519.KeyPair = .generate();
    var identities: [max_retry_psk_identities + 1]TestPskOffer = undefined;
    for (&identities, 0..) |*offer, i| {
        // One-byte distinct opaque identities, all unknown to this server
        // (no psk_lookup configured).
        offer.* = .{ .identity = &([_]u8{@intCast(i + 1)}) };
    }

    // No usable key_share: the server would have to retain all 9 identities
    // across the retry, exceeding the fixed capacity — reject before the HRR.
    var server: ServerHandshake = .init(try testConfig(.generate()));
    var harness: RetryPskHarness = .{};
    const ch1_record = try harness.buildCh1Record(client_keypair, &identities, 0, 0x6a6a);
    try testing.expectError(
        error.TooManyPskIdentities,
        server.acceptClientHello(ch1_record, &harness.out),
    );
    try testing.expectEqual(.wait_ch, server.state);

    // Usable key_share: no retry, no retention — the same offer count is
    // fine and the handshake proceeds (no PSK selected, full DHE).
    var server2: ServerHandshake = .init(try testConfig(.generate()));
    const ch1_usable = try harness.buildCh1Record(
        client_keypair,
        &identities,
        0,
        @intFromEnum(NamedGroup.x25519),
    );
    _ = try server2.acceptClientHello(ch1_usable, &harness.out);
    try testing.expectEqual(.wait_client_finished, server2.state);
    try testing.expect(server2.selected_psk == null);
}

// RFC 8446 §4.1.2, §4.2.11.2 — an identity the server's PskLookup cannot
// resolve is not automatically removable: the offered binder length is the
// hash output of the PSK's cipher suite, so an unknown identity whose binder
// length matches the HelloRetryRequest suite's hash claims compatibility and
// must be retained in ClientHello2 just like a lookup-resolved one.
test "acceptClientHello: rejects removal of an unknown identity whose binder claims the HRR hash" {
    const psk_compatible: [32]u8 = @splat(0x33);
    const identity_compatible = [_]u8{0x33};
    const identity_unknown = [_]u8{0x99};
    // The lookup resolves only identity_compatible; identity_unknown is
    // offered with a 32-byte binder, i.e. claiming a SHA-256 PSK.
    var table: RetryPskTable = .{ .entries = &.{
        .{
            .identity = &identity_compatible,
            .psk = &psk_compatible,
            .cipher_suite = .aes_128_gcm_sha256,
        },
    } };
    const client_keypair: x25519.KeyPair = .generate();

    var server: ServerHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .random = .zero,
        .psk_lookup = .{ .context = &table, .lookup = RetryPskTable.lookup },
    });
    server.supportSuites(&.{.aes_128_gcm_sha256});

    var harness: RetryPskHarness = .{};
    try harness.sendCh1(&server, client_keypair, &.{
        .{ .identity = &identity_unknown },
        .{ .identity = &identity_compatible },
    });
    const offers = [_]TestPskOffer{.{ .identity = &identity_compatible }};
    const ch2 = try harness.buildCh2(client_keypair, &offers, 0);
    try testing.expectError(
        error.IllegalParameter,
        server.acceptClientHello(harness.frameCh2(ch2.msg), &harness.out),
    );
}

// RFC 8446 §4.2.11 — the identities vector must contain whole PskIdentity
// entries. A trailing slack byte is malformed, and the regression it guards
// is the #103-review P0/P1 usize-underflow: the entry-header read was
// bounds-checked against the whole ext_data (binders included), so the slack
// byte let it read past the identities-vector end and the
// `vector_end - pos` bounds check underflowed. Wire-reachable from both new
// call sites (HRR-time identity capture) — red run: integer-overflow panic.
test "acceptClientHello: HRR path rejects a slack-byte identities vector in CH1" {
    const client_keypair: x25519.KeyPair = .generate();
    // No psk_lookup: PSK selection is skipped, so the malformed vector first
    // reaches the HRR-time identity capture.
    var server: ServerHandshake = .init(try testConfig(.generate()));
    var harness: RetryPskHarness = .{};
    const ch1_record = try harness.buildCh1Record(
        client_keypair,
        &.{.{ .identity = "a" }},
        1,
        0x6a6a,
    );
    try testing.expectError(
        error.UnexpectedEof,
        server.acceptClientHello(ch1_record, &harness.out),
    );
    try testing.expectEqual(.wait_ch, server.state);
}

// RFC 8446 §4.2.11 — same slack-byte malformation, but in ClientHello2,
// where the identity-continuity check is the first consumer of the
// identities vector. Red run: integer-overflow panic in the continuity
// iterator.
test "acceptClientHello: HRR path rejects a slack-byte identities vector in CH2" {
    const client_keypair: x25519.KeyPair = .generate();
    var server: ServerHandshake = .init(try testConfig(.generate()));
    var harness: RetryPskHarness = .{};
    try harness.sendCh1(&server, client_keypair, &.{.{ .identity = "a" }});
    const offers = [_]TestPskOffer{.{ .identity = "a" }};
    const ch2 = try harness.buildCh2(client_keypair, &offers, 1);
    try testing.expectError(
        error.UnexpectedEof,
        server.acceptClientHello(harness.frameCh2(ch2.msg), &harness.out),
    );
}

// RFC 8446 §4.2.11 — same slack-byte malformation on the ordinary (no-HRR)
// PSK selection path: selectPskWithTranscript walks the identities vector on
// every ClientHello offering pre_shared_key when a psk_lookup is configured.
// The identity is unknown to the lookup so iteration continues into the
// slack byte. Red run: integer-overflow panic (the #103-review P1 sibling
// underflow, pre-existing on the default resumption path).
test "acceptClientHello: PSK selection rejects a slack-byte identities vector" {
    const client_keypair: x25519.KeyPair = .generate();
    // Empty table: the lookup resolves nothing, so the walk reaches the
    // slack byte instead of returning on a verified binder.
    var table: RetryPskTable = .{ .entries = &.{} };
    var server: ServerHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .random = .zero,
        .psk_lookup = .{ .context = &table, .lookup = RetryPskTable.lookup },
    });
    var harness: RetryPskHarness = .{};
    const ch1_record = try harness.buildCh1Record(
        client_keypair,
        &.{.{ .identity = "a" }},
        1,
        @intFromEnum(NamedGroup.x25519),
    );
    try testing.expectError(
        error.UnexpectedEof,
        server.acceptClientHello(ch1_record, &harness.out),
    );
}

// RFC 8446 §4.1.4 — ClientHello2 must contain a key share for the group named
// by the HelloRetryRequest.
test "acceptClientHello: rejects ClientHello2 that ignores HRR selected group" {
    const client_keypair: x25519.KeyPair = .generate();
    var ch1_buf: [512]u8 = undefined;
    const ch1 = try client_hello.encode(&ch1_buf, .zero, client_keypair.public_key, null, &.{});
    var hrr_ch1_buf: [512]u8 = undefined;
    const hrr_ch1 = clientHelloWithKeyShareGroup(
        &hrr_ch1_buf,
        ch1,
        0x6a6a,
    );
    var ch1_record: [1024]u8 = undefined;
    const ch1_header: frame.Header = .init(.handshake, @intCast(hrr_ch1.len));
    ch1_header.write(ch1_record[0..frame.header_len]);
    @memcpy(ch1_record[frame.header_len..][0..hrr_ch1.len], hrr_ch1);

    var server: ServerHandshake = .init(try testConfig(.generate()));
    var out: [512]u8 = undefined;
    _ = try server.acceptClientHello(ch1_record[0 .. frame.header_len + hrr_ch1.len], &out);

    const client_p256 = try p256.KeyPair.generateDeterministic(.init(test_p256_seed_a));
    var p256_ch2_buf: [768]u8 = undefined;
    const p256_ch2 = clientHelloWithP256KeyShare(&p256_ch2_buf, ch1, client_p256.public_key);
    var ch2_record: [1024]u8 = undefined;
    const ch2_header: frame.Header = .init(.handshake, @intCast(p256_ch2.len));
    ch2_header.write(ch2_record[0..frame.header_len]);
    @memcpy(ch2_record[frame.header_len..][0..p256_ch2.len], p256_ch2);

    try testing.expectError(
        error.IllegalParameter,
        server.acceptClientHello(ch2_record[0 .. frame.header_len + p256_ch2.len], &out),
    );
}

// RFC 8446 §4.1.4 — ClientHello2 key_share must contain exactly one
// KeyShareEntry matching the group selected by HelloRetryRequest.
test "acceptClientHello: rejects ClientHello2 with extra key share" {
    const client_keypair: x25519.KeyPair = .generate();
    var ch1_buf: [512]u8 = undefined;
    const ch1 = try client_hello.encode(&ch1_buf, .zero, client_keypair.public_key, null, &.{});
    var hrr_ch1_buf: [512]u8 = undefined;
    const hrr_ch1 = clientHelloWithKeyShareGroup(
        &hrr_ch1_buf,
        ch1,
        0x6a6a,
    );
    var ch1_record: [1024]u8 = undefined;
    const ch1_header: frame.Header = .init(.handshake, @intCast(hrr_ch1.len));
    ch1_header.write(ch1_record[0..frame.header_len]);
    @memcpy(ch1_record[frame.header_len..][0..hrr_ch1.len], hrr_ch1);

    var server: ServerHandshake = .init(try testConfig(.generate()));
    var out: [512]u8 = undefined;
    _ = try server.acceptClientHello(ch1_record[0 .. frame.header_len + hrr_ch1.len], &out);

    const client_p256 = try p256.KeyPair.generateDeterministic(.init(test_p256_seed_a));
    var ch2_buf: [1024]u8 = undefined;
    const ch2 = clientHelloWithBothKeyShares(&ch2_buf, ch1, client_p256.public_key);
    var ch2_record: [1536]u8 = undefined;
    const ch2_header: frame.Header = .init(.handshake, @intCast(ch2.len));
    ch2_header.write(ch2_record[0..frame.header_len]);
    @memcpy(ch2_record[frame.header_len..][0..ch2.len], ch2);

    try testing.expectError(
        error.IllegalParameter,
        server.acceptClientHello(ch2_record[0 .. frame.header_len + ch2.len], &out),
    );
}

test "acceptClientHello: HRR sends at most one compatibility ChangeCipherSpec" {
    const client_keypair: x25519.KeyPair = .generate();
    const session_id: [4]u8 = .{ 0xa0, 0xa1, 0xa2, 0xa3 };
    var ch1_buf: [512]u8 = undefined;
    const ch1 = try client_hello.encode(&ch1_buf, .zero, client_keypair.public_key, null, &.{});
    var compat_ch1_buf: [544]u8 = undefined;
    const compat_ch1 = compatibilityClientHello(&compat_ch1_buf, ch1, &session_id);
    var hrr_ch1_buf: [544]u8 = undefined;
    const hrr_ch1 = clientHelloWithKeyShareGroup(
        &hrr_ch1_buf,
        compat_ch1,
        0x6a6a,
    );
    var ch1_record: [1024]u8 = undefined;
    const ch1_header: frame.Header = .init(.handshake, @intCast(hrr_ch1.len));
    ch1_header.write(ch1_record[0..frame.header_len]);
    @memcpy(ch1_record[frame.header_len..][0..hrr_ch1.len], hrr_ch1);

    var server: ServerHandshake = .init(try testConfig(.generate()));
    var hrr_out: [256]u8 = undefined;
    const hrr_record = try server.acceptClientHello(
        ch1_record[0 .. frame.header_len + hrr_ch1.len],
        &hrr_out,
    );
    try testing.expectEqual(.wait_ch, server.state);
    try testing.expect(!server.needsServerFlight());

    const hrr_hdr = try frame.parseHeader(hrr_record);
    try testing.expectEqual(.handshake, hrr_hdr.content_type);
    const hrr = try server_hello.parseHelloRetryRequestWithSessionIdEcho(
        hrr_record[frame.header_len..][0..hrr_hdr.length()],
        &session_id,
    );
    try testing.expectEqual(NamedGroup.x25519, hrr.selected_group.?);
    const hrr_ccs_offset = frame.header_len + @as(usize, hrr_hdr.length());
    try testing.expectEqual(hrr_ccs_offset + compatibility_ccs_len, hrr_record.len);

    var ccs = [_]u8{ 0x14, 0x03, 0x03, 0x00, 0x01, 0x01 };
    try testing.expectEqual(Event.none, try server.handleRecord(&ccs, &hrr_out));

    var ch2_record: [1024]u8 = undefined;
    const ch2_header: frame.Header = .init(.handshake, @intCast(compat_ch1.len));
    ch2_header.write(ch2_record[0..frame.header_len]);
    @memcpy(ch2_record[frame.header_len..][0..compat_ch1.len], compat_ch1);
    var sh_out: [256]u8 = undefined;
    const sh_record = try server.acceptClientHello(
        ch2_record[0 .. frame.header_len + compat_ch1.len],
        &sh_out,
    );
    try testing.expectEqual(.wait_client_finished, server.state);
    try testing.expect(server.needsServerFlight());
    const sh_hdr = try frame.parseHeader(sh_record);
    try testing.expectEqual(.handshake, sh_hdr.content_type);
    var sh: server_hello.ServerHello = undefined;
    _ = try server_hello.parseWithSessionIdEcho(
        sh_record[frame.header_len..][0..sh_hdr.length()],
        &session_id,
        &sh,
    );
    // RFC 8446 Appendix D.4 — the server sends at most one compatibility CCS;
    // this path sent it after HRR, so ServerHello carries no second CCS.
    try testing.expectEqual(frame.header_len + @as(usize, sh_hdr.length()), sh_record.len);
}

test "acceptClientHello: emits compatibility ChangeCipherSpec for non-empty legacy_session_id" {
    const client_keypair: x25519.KeyPair = .generate();
    const session_id: [4]u8 = .{ 0xa0, 0xa1, 0xa2, 0xa3 };
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    var compat_ch_buf: [544]u8 = undefined;
    const compat_ch = compatibilityClientHello(&compat_ch_buf, ch, &session_id);

    var record: [1024]u8 = undefined;
    const record_header: frame.Header = .init(.handshake, @intCast(compat_ch.len));
    record_header.write(record[0..frame.header_len]);
    @memcpy(record[frame.header_len..][0..compat_ch.len], compat_ch);

    var hs: ServerHandshake = .init(try testConfig(.generate()));
    var out: [256]u8 = undefined;
    const written = try hs.acceptClientHello(
        record[0 .. frame.header_len + compat_ch.len],
        &out,
    );

    const sh_hdr = try frame.parseHeader(written);
    try testing.expectEqual(.handshake, sh_hdr.content_type);
    const ccs_offset = frame.header_len + @as(usize, sh_hdr.length());
    try testing.expectEqual(ccs_offset + compatibility_ccs_len, written.len);
    var sh_result: server_hello.ServerHello = undefined;
    _ = try server_hello.parseWithSessionIdEcho(
        written[frame.header_len..][0..sh_hdr.length()],
        &session_id,
        &sh_result,
    );

    const ccs = written[ccs_offset..];
    const ccs_hdr = try frame.parseHeader(ccs);
    try testing.expectEqual(.change_cipher_spec, ccs_hdr.content_type);
    try testing.expectEqual(@as(u16, 1), ccs_hdr.length());
    try testing.expectEqual(@as(u8, 0x01), ccs[frame.header_len]);
}

test "sendAnonymousFlightForTest: client decrypts EncryptedExtensions and Finished" {
    const client_keypair: x25519.KeyPair = .generate();
    const server_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(
        &ch_buf,
        .zero,
        client_keypair.public_key,
        "example.com",
        &.{"h2"},
    );
    var ch_record: [1024]u8 = undefined;
    const header: frame.Header = .init(.handshake, @intCast(ch.len));
    header.write(ch_record[0..frame.header_len]);
    @memcpy(ch_record[frame.header_len..][0..ch.len], ch);

    var server: ServerHandshake = .init(try testConfig(server_keypair));
    server.supportAlpn(&.{"h2"});
    var sh_out: [256]u8 = undefined;
    const sh_record = try server.acceptClientHello(
        ch_record[0 .. frame.header_len + ch.len],
        &sh_out,
    );

    var client: ClientHandshake = .init(.{
        .keypairs = try .init(client_keypair),
        .host_name = "ztls.server.test",
        .now_sec = 0,
        .random = .zero,
    });
    client.offerAlpn(&.{"h2"});
    client.injectClientHello(ch);
    try client.processServerHello(sh_record[frame.header_len..]);

    var flight_out: [512]u8 = undefined;
    const flight_record = try server.sendAnonymousFlightForTest(&flight_out);
    const dec = try client.rx.decrypt(flight_out[0..flight_record.len]);
    try testing.expectEqual(.handshake, dec.content_type);

    var hr: HandshakeReader = .init(dec.content);
    const ee = (try hr.next()).?;
    try testing.expectEqual(.encrypted_extensions, ee.type);
    const parsed_ee = try encrypted_extensions.parse(ee.raw, &.{"h2"}, .{});
    try testing.expectEqualStrings("h2", parsed_ee.alpn_protocol.?);
    var transcript: Sha256 = .init(.{});
    transcript.update(ch);
    transcript.update(sh_record[frame.header_len..]);
    transcript.update(ee.raw);

    const fin = (try hr.next()).?;
    try testing.expectEqual(.finished, fin.type);
    const th = transcript.peek();
    switch (server.suite_state) {
        .sha256 => |s| try finished.verify(Sha256, fin.raw, &s.server_finished_key.data, &th),
        .sha384 => unreachable,
    }
}

// RFC 8446 §4.3-§4.4 — configured server flight is emitted exactly once and
// remains protected by the pending-write latch.
test "sendPreparedServerFlight: credentials and pending write are enforced" {
    const client_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(
        &ch_buf,
        .zero,
        client_keypair.public_key,
        "example.com",
        &.{},
    );
    var ch_record: [1024]u8 = undefined;
    const header: frame.Header = .init(.handshake, @intCast(ch.len));
    header.write(ch_record[0..frame.header_len]);
    @memcpy(ch_record[frame.header_len..][0..ch.len], ch);

    var server_without_credentials: ServerHandshake = .init(try testConfig(.generate()));
    var sh_out: [256]u8 = undefined;
    _ = try server_without_credentials.acceptClientHello(
        ch_record[0 .. frame.header_len + ch.len],
        &sh_out,
    );

    var flight_out: [4096]u8 = undefined;
    try testing.expectError(
        error.MissingServerCredentials,
        server_without_credentials.sendPreparedServerFlight(&flight_out),
    );

    var signer: signature.PrivateKey = try .fromP256Scalar(serverEcdsaScalar()[0..32]);
    defer signer.deinit();
    var server: ServerHandshake = .init(try testConfig(.generate()));
    server.setCredentials(&.{serverEcdsaCertDer()}, signer.signer());
    _ = try server.acceptClientHello(ch_record[0 .. frame.header_len + ch.len], &sh_out);
    server.pending_write.mark();
    try testing.expectError(error.PendingWrite, server.sendPreparedServerFlight(&flight_out));
    server.completeWrite();

    const flight_record = (try server.sendPreparedServerFlight(&flight_out)).?;
    try testing.expect(flight_record.len > frame.header_len);
    try testing.expectError(error.PendingWrite, server.sendPreparedServerFlight(&flight_out));
    server.completeWrite();
    try testing.expectEqual(
        @as(?[]const u8, null),
        try server.sendPreparedServerFlight(&flight_out),
    );
}

// RFC 8446 §4.4.4 — if server-flight record encryption fails, the peer never
// observes Finished, so the server must retain its handshake write key and
// clear the uncommitted application secret. A subsequent fatal alert remains
// decryptable by the client in its pre-Finished epoch.
test "sendPreparedServerFlight: encryption failure preserves handshake write epoch" {
    const client_keypair: x25519.KeyPair = .generate();
    const server_keypair: x25519.KeyPair = .generate();

    var client: ClientHandshake = .init(.{
        .keypairs = try .init(client_keypair),
        .host_name = "ztls.server.test",
        .now_sec = 0,
        .random = .zero,
    });
    defer client.deinit();
    var client_out: [1024]u8 = undefined;
    const ch_record = try client.start(&client_out);
    client.completeWrite();

    var signer: signature.PrivateKey = try .fromP256Scalar(serverEcdsaScalar()[0..32]);
    defer signer.deinit();
    const signer_api = signer.signer();

    var server: ServerHandshake = .init(try testConfig(server_keypair));
    defer server.deinit();
    server.setCredentials(&.{serverEcdsaCertDer()}, signer_api);
    var server_sh: [256]u8 = undefined;
    const sh_record = try server.acceptClientHello(ch_record, &server_sh);
    try client.processServerHello(sh_record[frame.header_len..]);

    // The certificate makes the encoded flight larger than one record header,
    // so encryption cannot fit while flight assembly itself still succeeds.
    var plaintext: [4096]u8 = undefined;
    var full_out: [4096]u8 = undefined;
    try testing.expectError(
        error.BufferTooShort,
        server.sendCertificateChainFlight(
            .init(&.{serverEcdsaCertDer()}),
            signer_api,
            &plaintext,
            full_out[0..frame.header_len],
        ),
    );
    // Flight assembly advanced the transcript. Retrying would emit a duplicate
    // Finished and reuse the handshake write nonce, so every public path is
    // one-shot after assembly begins even when no record was produced.
    try testing.expect(server.server_flight_sent);
    try testing.expectEqual(
        @as(?[]const u8, null),
        try server.sendPreparedServerFlight(&full_out),
    );
    try testing.expectEqual(Suite.sha256, std.meta.activeTag(server.suite_state));
    try testing.expectEqualSlices(
        u8,
        &([_]u8{0} ** hkdf.HkdfSha256.prk_len),
        &server.suite_state.sha256.server_app_secret.data,
    );

    const alert_record = try server.sendAlert(.internal_error, &full_out);
    try testing.expectError(
        error.PeerAlert,
        client.handleRecord(full_out[0..alert_record.len], &client_out),
    );
    try testing.expectEqual(
        @as(?alert.Alert, .{ .level = .fatal, .description = .internal_error }),
        client.lastPeerAlert(),
    );
}

test "sendAuthenticatedFlight: client decrypts authenticated server flight" {
    const client_keypair: x25519.KeyPair = .generate();
    const server_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(
        &ch_buf,
        .zero,
        client_keypair.public_key,
        "example.com",
        &.{"h2"},
    );
    var ch_record: [1024]u8 = undefined;
    const header: frame.Header = .init(.handshake, @intCast(ch.len));
    header.write(ch_record[0..frame.header_len]);
    @memcpy(ch_record[frame.header_len..][0..ch.len], ch);

    var server: ServerHandshake = .init(try testConfig(server_keypair));
    server.supportAlpn(&.{"h2"});
    var sh_out: [256]u8 = undefined;
    const sh_record = try server.acceptClientHello(
        ch_record[0 .. frame.header_len + ch.len],
        &sh_out,
    );

    var signer: signature.PrivateKey = try .fromP256Scalar(serverEcdsaScalar()[0..32]);
    defer signer.deinit();
    const signer_api = signer.signer();
    var plaintext: [4096]u8 = undefined;
    var flight_out: [4096]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(
        &.{testCertDer()},
        signer_api,
        &plaintext,
        &flight_out,
    );
    try testing.expect(server.server_flight_sent);
    try testing.expectEqual(
        @as(?[]const u8, null),
        try server.sendPreparedServerFlight(&flight_out),
    );

    var client: ClientHandshake = .init(.{
        .keypairs = try .init(client_keypair),
        .host_name = "ztls.server.test",
        .now_sec = 0,
        .random = .zero,
    });
    client.offerAlpn(&.{"h2"});
    client.injectClientHello(ch);
    try client.processServerHello(sh_record[frame.header_len..]);
    const dec = try client.rx.decrypt(flight_out[0..flight_record.len]);
    try testing.expectEqual(.handshake, dec.content_type);

    var hr: HandshakeReader = .init(dec.content);
    try testing.expectEqual(.encrypted_extensions, (try hr.next()).?.type);
    try testing.expectEqual(.certificate, (try hr.next()).?.type);
    try testing.expectEqual(.certificate_verify, (try hr.next()).?.type);
    try testing.expectEqual(.finished, (try hr.next()).?.type);
    try testing.expectEqual(@as(?HandshakeReader.Message, null), try hr.next());
}

// RFC 8446 §4.3.2 — when client authentication is configured, the server's
// authenticated flight sends CertificateRequest between EncryptedExtensions
// and Certificate.
test "sendAuthenticatedFlight: optional client auth sends CertificateRequest" {
    const client_keypair: x25519.KeyPair = .generate();
    const server_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    var ch_record: [1024]u8 = undefined;
    const header: frame.Header = .init(.handshake, @intCast(ch.len));
    header.write(ch_record[0..frame.header_len]);
    @memcpy(ch_record[frame.header_len..][0..ch.len], ch);

    var server: ServerHandshake = .init(.{
        .keypairs = try .init(server_keypair),
        .random = .zero,
        .client_auth = .optional,
    });
    var sh_out: [256]u8 = undefined;
    const sh_record = try server.acceptClientHello(
        ch_record[0 .. frame.header_len + ch.len],
        &sh_out,
    );

    var signer: signature.PrivateKey = try .fromP256Scalar(serverEcdsaScalar()[0..32]);
    defer signer.deinit();
    var plaintext: [4096]u8 = undefined;
    var flight_out: [4096]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(
        &.{testCertDer()},
        signer.signer(),
        &plaintext,
        &flight_out,
    );

    var client: ClientHandshake = .init(.{
        .keypairs = try .init(client_keypair),
        .host_name = "ztls.server.test",
        .now_sec = 0,
        .random = .zero,
    });
    client.policy.insecure_no_chain_anchor = true;
    client.injectClientHello(ch);
    try client.processServerHello(sh_record[frame.header_len..]);
    const dec = try client.rx.decrypt(flight_out[0..flight_record.len]);

    var hr: HandshakeReader = .init(dec.content);
    try testing.expectEqual(.encrypted_extensions, (try hr.next()).?.type);
    const cr = (try hr.next()).?;
    try testing.expectEqual(.certificate_request, cr.type);
    _ = try certificate_request.parse(cr.raw);
    try testing.expectEqual(.certificate, (try hr.next()).?.type);
    try testing.expectEqual(.certificate_verify, (try hr.next()).?.type);
    try testing.expectEqual(.finished, (try hr.next()).?.type);
    try testing.expectEqual(@as(?HandshakeReader.Message, null), try hr.next());
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

fn expectHandshakeSecretsZero(server: *const ServerHandshake) !void {
    switch (server.suite_state) {
        inline .sha256, .sha384 => |*s| {
            try testing.expect(mem.allEqual(u8, mem.asBytes(&s.handshake_secret), 0));
            try testing.expect(mem.allEqual(u8, mem.asBytes(&s.client_finished_key), 0));
            try testing.expect(mem.allEqual(u8, mem.asBytes(&s.server_finished_key), 0));
        },
    }
}

fn connectedTestServer() !ServerHandshake {
    return connectedTestServerConfigure(null);
}

/// `suites_patch`, when set, overwrites the ClientHello cipher-suite vector
/// (fixed 6-byte, three-suite layout) before acceptance.
fn connectedTestServerConfigure(suites_patch: ?[6]u8) !ServerHandshake {
    const client_keypair: x25519.KeyPair = try .generateDeterministic(.init(@splat(0x11)));
    const server_keypair: x25519.KeyPair = try .generateDeterministic(.init(@splat(0x22)));
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    if (suites_patch) |patch| ch_buf[41..47].* = patch;
    var ch_record: [1024]u8 = undefined;
    const header: frame.Header = .init(.handshake, @intCast(ch.len));
    header.write(ch_record[0..frame.header_len]);
    @memcpy(ch_record[frame.header_len..][0..ch.len], ch);

    var server: ServerHandshake = .init(try testConfig(server_keypair));
    var sh_out: [256]u8 = undefined;
    _ = try server.acceptClientHello(ch_record[0 .. frame.header_len + ch.len], &sh_out);
    var flight_out: [512]u8 = undefined;
    _ = try server.sendAnonymousFlightForTest(&flight_out);

    var fin_plain: [64]u8 = undefined;
    const fin = switch (server.suite_state) {
        inline .sha256, .sha384 => |*s| blk: {
            const th = s.transcript.peek();
            break :blk try finished.encode(
                @TypeOf(s.transcript),
                &fin_plain,
                &s.client_finished_key.data,
                &th,
            );
        },
    };
    var client_tx = try server.rx.clone();
    defer client_tx.deinit();
    var fin_wire: [128]u8 = undefined;
    const fin_record = try client_tx.encrypt(.handshake, fin, &fin_wire);
    try server.processClientFinished(fin_wire[0..fin_record.len]);
    try expectHandshakeSecretsZero(&server);
    return server;
}

/// Same as connectedTestServer, but negotiating TLS_AES_256_GCM_SHA384: the
/// offered vector keeps its length and carries one recognized SHA-384 suite
/// plus unknown code points the server ignores (RFC 8446 §4.1.2, §9.3).
fn connectedTestServerSha384() !ServerHandshake {
    return connectedTestServerConfigure(.{ 0x12, 0x34, 0x13, 0x02, 0x56, 0x78 });
}

const ConnectedTestPair = struct {
    client: ClientHandshake,
    server: ServerHandshake,
};

fn connectedTestPair() !ConnectedTestPair {
    const client_keypair: x25519.KeyPair = .generate();
    const server_keypair: x25519.KeyPair = .generate();

    var client: ClientHandshake = .init(.{
        .keypairs = try .init(client_keypair),
        .host_name = "ztls.server.test",
        .now_sec = 0,
        .random = .zero,
    });
    client.policy.insecure_no_chain_anchor = true;
    var client_out: [1024]u8 = undefined;
    const ch_record = try client.start(&client_out);
    client.completeWrite();

    var server: ServerHandshake = .init(try testConfig(server_keypair));
    var server_out: [4096]u8 = undefined;
    const sh_record = try server.acceptClientHello(ch_record, &server_out);
    try client.processServerHello(sh_record[frame.header_len..]);

    var signer = try signature.PrivateKey.fromP256Scalar(serverEcdsaScalar()[0..32]);
    defer signer.deinit();
    const signer_api = signer.signer();
    var plaintext: [4096]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(
        &.{serverEcdsaCertDer()},
        signer_api,
        &plaintext,
        &server_out,
    );
    const client_event = try client.handleRecord(server_out[0..flight_record.len], &client_out);
    const client_finished_record = switch (client_event) {
        .write => |w| w,
        else => return error.UnexpectedEvent,
    };
    client.completeWrite();
    try server.processClientFinished(client_out[0..client_finished_record.len]);
    try expectHandshakeSecretsZero(&server);

    return .{ .client = client, .server = server };
}

// RFC 8446 §4.6.1, §7.1 — the server derives the ticket PSK from the transcript
// through client Finished, emits one encrypted post-handshake record, and the
// client independently derives the same caller-storable PSK from that record.
test "NewSessionTicket emission derives matching client and server PSKs" {
    var pair = try connectedTestPair();
    defer pair.client.deinit();
    defer pair.server.deinit();

    var prepared = try pair.server.deriveTicketPsk();
    defer prepared.secureZero();
    try testing.expectEqualSlices(u8, &.{0}, &prepared.ticket_nonce);

    const tx_before = pair.server.txKtlsInfo();
    var server_out: [512]u8 = undefined;
    const record = try pair.server.sendNewSessionTicket(
        &prepared,
        .{
            .ticket_lifetime = 3600,
            .ticket_age_add = 0x12345678,
            .ticket = "opaque-ticket",
        },
        &server_out,
    );
    try testing.expect(pair.server.hasPendingWrite());
    const tx_after = pair.server.txKtlsInfo();
    try testing.expectEqual(
        std.mem.readInt(u64, &tx_before.rec_seq, .big) + 1,
        std.mem.readInt(u64, &tx_after.rec_seq, .big),
    );

    var client_out: [128]u8 = undefined;
    const event = try pair.client.handleRecord(server_out[0..record.len], &client_out);
    const nst = switch (event) {
        .new_session_ticket => |ticket| ticket,
        else => return error.UnexpectedEvent,
    };
    try testing.expectEqual(@as(u32, 3600), nst.ticket_lifetime);
    try testing.expectEqual(@as(u32, 0x12345678), nst.ticket_age_add);
    try testing.expectEqualSlices(u8, &prepared.ticket_nonce, nst.ticket_nonce);
    try testing.expectEqualStrings("opaque-ticket", nst.ticket);
    try testing.expectEqual(@as(?u32, null), nst.max_early_data_size);

    var session = try pair.client.deriveSessionTicket(nst);
    defer session.secureZero();
    try testing.expectEqual(prepared.cipher_suite, session.cipher_suite);
    try testing.expectEqualSlices(u8, prepared.psk.constSlice(), session.psk.constSlice());
    pair.server.completeWrite();
}

// RFC 8446 §4.6.1 — a prepared PSK belongs to exactly one pending nonce. A
// stale object cannot emit or discard the current ticket obligation.
test "NewSessionTicket emission rejects stale prepared PSK objects" {
    var pair = try connectedTestPair();
    defer pair.client.deinit();
    defer pair.server.deinit();

    var prepared = try pair.server.deriveTicketPsk();
    defer prepared.secureZero();
    var stale = prepared;
    defer stale.secureZero();
    stale.ticket_nonce[0] += 1;

    var out: [256]u8 = @splat(0xaa);
    try testing.expectError(
        error.InvalidTicketPsk,
        pair.server.sendNewSessionTicket(
            &stale,
            .{
                .ticket_lifetime = 3600,
                .ticket_age_add = 0x12345678,
                .ticket = "opaque-ticket",
            },
            &out,
        ),
    );
    try testing.expect(mem.allEqual(u8, &out, 0xaa));
    try testing.expect(pair.server.hasPendingTicket());
    try testing.expectError(error.InvalidTicketPsk, pair.server.discardTicketPsk(&stale));
    try pair.server.discardTicketPsk(&prepared);
}

// RFC 8446 §4.2.11, §4.6.1, §7.1 — a ztls-issued ticket resumes against a
// ztls server, and the resumed connection can derive and emit a fresh ticket.
test "server-issued NewSessionTicket resumes and can be renewed" {
    var initial = try connectedTestPair();
    defer initial.client.deinit();
    defer initial.server.deinit();

    var first_psk = try initial.server.deriveTicketPsk();
    defer first_psk.secureZero();
    var initial_server_out: [256]u8 = undefined;
    const first_record = try initial.server.sendNewSessionTicket(
        &first_psk,
        .{
            .ticket_lifetime = 3600,
            .ticket_age_add = 0x12345678,
            .ticket = "issued-by-ztls",
        },
        &initial_server_out,
    );
    var initial_client_out: [64]u8 = undefined;
    const first_event = try initial.client.handleRecord(
        initial_server_out[0..first_record.len],
        &initial_client_out,
    );
    const first_nst = switch (first_event) {
        .new_session_ticket => |ticket| ticket,
        else => return error.UnexpectedEvent,
    };
    var session = try initial.client.deriveSessionTicket(first_nst);
    defer session.secureZero();
    initial.server.completeWrite();

    var client: ClientHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .host_name = "ztls.server.test",
        .now_sec = 0,
        .random = .zero,
    });
    defer client.deinit();
    client.policy.insecure_no_chain_anchor = true;
    var client_out: [4096]u8 = undefined;
    const ch_record = try client.startWithPsk(&session, &client_out, false);
    client.completeWrite();

    const Lookup = struct {
        const Context = struct {
            identity: []const u8,
            psk: []const u8,
            cipher_suite: CipherSuite,
        };
        fn lookup(context: *anyopaque, identity: []const u8) ?PskEntry {
            const ctx: *Context = @ptrCast(@alignCast(context));
            if (!mem.eql(u8, identity, ctx.identity)) return null;
            return .{ .psk = ctx.psk, .cipher_suite = ctx.cipher_suite };
        }
    };
    var lookup_context: Lookup.Context = .{
        .identity = session.identity.constSlice(),
        .psk = session.psk.constSlice(),
        .cipher_suite = session.cipher_suite,
    };
    var server: ServerHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .random = .zero,
        .psk_lookup = .{ .context = &lookup_context, .lookup = Lookup.lookup },
    });
    defer server.deinit();
    server.supportSuites(&.{session.cipher_suite});

    var server_out: [4096]u8 = undefined;
    const sh_record = try server.acceptClientHello(ch_record, &server_out);
    try testing.expect(server.selected_psk != null);
    try client.processServerHello(sh_record[frame.header_len..]);

    var signer = try signature.PrivateKey.fromP256Scalar(serverEcdsaScalar()[0..32]);
    defer signer.deinit();
    var plaintext: [4096]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(
        &.{serverEcdsaCertDer()},
        signer.signer(),
        &plaintext,
        &server_out,
    );
    const handshake_event = try client.handleRecord(
        server_out[0..flight_record.len],
        &client_out,
    );
    const client_finished = switch (handshake_event) {
        .write => |record| record,
        else => return error.UnexpectedEvent,
    };
    client.completeWrite();
    try server.processClientFinished(client_out[0..client_finished.len]);
    try testing.expect(client.isConnected());
    try testing.expect(server.isConnected());
    try testing.expect(server.isResumed());

    var renewed_psk = try server.deriveTicketPsk();
    defer renewed_psk.secureZero();
    try testing.expect(!mem.eql(
        u8,
        first_psk.psk.constSlice(),
        renewed_psk.psk.constSlice(),
    ));
    const renewed_record = try server.sendNewSessionTicket(
        &renewed_psk,
        .{
            .ticket_lifetime = 3600,
            .ticket_age_add = 0x87654321,
            .ticket = "renewed-by-ztls",
        },
        &server_out,
    );
    const renewed_event = try client.handleRecord(
        server_out[0..renewed_record.len],
        &client_out,
    );
    const renewed_nst = switch (renewed_event) {
        .new_session_ticket => |ticket| ticket,
        else => return error.UnexpectedEvent,
    };
    var renewed_session = try client.deriveSessionTicket(renewed_nst);
    defer renewed_session.secureZero();
    try testing.expectEqualSlices(
        u8,
        renewed_psk.psk.constSlice(),
        renewed_session.psk.constSlice(),
    );
}

// RFC 8446 §4.6.1 — ticket nonces and derived PSKs are unique per connection,
// and server emission is bounded to the 32-ticket receive limit ztls enforces.
test "NewSessionTicket emission owns unique bounded nonces" {
    var pair = try connectedTestPair();
    defer pair.client.deinit();
    defer pair.server.deinit();

    var previous_psk: [48]u8 = undefined;
    var previous_psk_len: usize = 0;
    var server_out: [256]u8 = undefined;
    var client_out: [64]u8 = undefined;
    for (0..max_new_session_tickets) |i| {
        var prepared = try pair.server.deriveTicketPsk();
        defer prepared.secureZero();
        try testing.expectEqual(@as(u8, @intCast(i)), prepared.ticket_nonce[0]);
        if (i != 0) {
            try testing.expect(!mem.eql(
                u8,
                previous_psk[0..previous_psk_len],
                prepared.psk.constSlice(),
            ));
        }
        previous_psk_len = prepared.psk.len;
        @memcpy(previous_psk[0..previous_psk_len], prepared.psk.constSlice());

        const identity = [_]u8{@intCast(i)};
        const record = try pair.server.sendNewSessionTicket(
            &prepared,
            .{
                .ticket_lifetime = 60,
                .ticket_age_add = @intCast(i),
                .ticket = &identity,
            },
            &server_out,
        );
        pair.server.completeWrite();
        const event = try pair.client.handleRecord(server_out[0..record.len], &client_out);
        const nst = switch (event) {
            .new_session_ticket => |ticket| ticket,
            else => return error.UnexpectedEvent,
        };
        try testing.expectEqual(@as(u32, @intCast(i)), nst.ticket_age_add);
    }
    try testing.expectError(
        error.TooManyNewSessionTickets,
        pair.server.deriveTicketPsk(),
    );
}

// RFC 8446 §4.6.1, §4.6.3 — a prepared ticket obeys the common write latch,
// waits behind an owed KeyUpdate response, and cannot cross the kTLS TX boundary.
test "NewSessionTicket emission enforces write and kTLS ordering" {
    var pair = try connectedTestPair();
    defer pair.client.deinit();
    defer pair.server.deinit();

    var prepared = try pair.server.deriveTicketPsk();
    defer prepared.secureZero();
    const params: TicketParams = .{
        .ticket_lifetime = 60,
        .ticket_age_add = 1,
        .ticket = "ticket",
    };
    var out: [128]u8 = undefined;

    pair.server.pending_write.mark();
    try testing.expectError(
        error.PendingWrite,
        pair.server.sendNewSessionTicket(&prepared, params, &out),
    );
    pair.server.completeWrite();

    pair.server.key_update_obligation = .response_owed;
    try testing.expectError(
        error.PendingKeyUpdateResponse,
        pair.server.sendNewSessionTicket(&prepared, params, &out),
    );
    pair.server.key_update_obligation = .none;

    try testing.expectError(error.PendingTicket, pair.server.markKtlsTxInstalled());
    try pair.server.discardTicketPsk(&prepared);
    try pair.server.markKtlsTxInstalled();
    try testing.expectError(error.KtlsTxActive, pair.server.deriveTicketPsk());
    try testing.expectError(
        error.KtlsTxActive,
        pair.server.sendNewSessionTicket(&prepared, params, &out),
    );
}

// RFC 8446 §4.6.1 — encoding failures neither consume the prepared ticket nor
// advance the application write sequence, so the caller may correct and retry.
test "NewSessionTicket emission preserves state on encoding failure" {
    var pair = try connectedTestPair();
    defer pair.client.deinit();
    defer pair.server.deinit();

    var prepared = try pair.server.deriveTicketPsk();
    defer prepared.secureZero();
    const tx_before = pair.server.txKtlsInfo();

    var short_out: [RecordLayer.overhead]u8 = @splat(0xa5);
    const short_before = short_out;
    try testing.expectError(
        error.BufferTooShort,
        pair.server.sendNewSessionTicket(
            &prepared,
            .{
                .ticket_lifetime = 60,
                .ticket_age_add = 1,
                .ticket = "retry",
            },
            &short_out,
        ),
    );
    try testing.expectEqualSlices(u8, &short_before, &short_out);
    try testing.expect(pair.server.hasPendingTicket());
    try testing.expect(!pair.server.hasPendingWrite());
    try testing.expectEqual(tx_before, pair.server.txKtlsInfo());

    var too_large: [max_ticket_identity_len + 1]u8 = @splat(0);
    var out: [max_out_len]u8 = undefined;
    try testing.expectError(
        error.TicketTooLong,
        pair.server.sendNewSessionTicket(
            &prepared,
            .{
                .ticket_lifetime = 60,
                .ticket_age_add = 1,
                .ticket = &too_large,
            },
            &out,
        ),
    );
    try testing.expect(pair.server.hasPendingTicket());
    try testing.expect(!pair.server.hasPendingWrite());
    try testing.expectEqual(tx_before, pair.server.txKtlsInfo());

    const record = try pair.server.sendNewSessionTicket(
        &prepared,
        .{
            .ticket_lifetime = 60,
            .ticket_age_add = 2,
            .ticket = "retry",
        },
        &out,
    );
    try testing.expect(record.len > RecordLayer.overhead);
}

// RFC 8446 §4.6.1 — abandoning a prepared ticket burns its nonce and erases
// its PSK so a later ticket cannot accidentally reuse that key material.
test "discardTicketPsk burns nonce and erases key material" {
    var pair = try connectedTestPair();
    defer pair.client.deinit();
    defer pair.server.deinit();

    var discarded = try pair.server.deriveTicketPsk();
    try pair.server.discardTicketPsk(&discarded);
    try testing.expect(mem.allEqual(u8, mem.asBytes(&discarded), 0));

    var next = try pair.server.deriveTicketPsk();
    defer next.secureZero();
    try testing.expectEqual(@as(u8, 1), next.ticket_nonce[0]);
}

// RFC 8446 §4.4.2, §4.4.4 — when the server requests client authentication
// and the client has no credentials, optional client auth accepts an empty
// Certificate followed by Finished.
test "processClientFinished: optional client auth accepts empty Certificate" {
    const client_keypair: x25519.KeyPair = .generate();
    const server_keypair: x25519.KeyPair = .generate();

    var client: ClientHandshake = .init(.{
        .keypairs = try .init(client_keypair),
        .host_name = "ztls.server.test",
        .now_sec = 0,
        .random = .zero,
    });
    client.policy.insecure_no_chain_anchor = true;
    var client_out: [1024]u8 = undefined;
    const ch_record = try client.start(&client_out);
    client.completeWrite();

    var client_cert_storage: [1024]u8 = undefined;
    var server: ServerHandshake = .init(.{
        .keypairs = try .init(server_keypair),
        .random = .zero,
        .client_auth = .optional,
        .client_cert_buffer = &client_cert_storage,
    });
    var server_out: [4096]u8 = undefined;
    const sh_record = try server.acceptClientHello(ch_record, &server_out);
    try client.processServerHello(sh_record[frame.header_len..]);

    var signer = try signature.PrivateKey.fromP256Scalar(serverEcdsaScalar()[0..32]);
    defer signer.deinit();
    var plaintext: [4096]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(
        &.{serverEcdsaCertDer()},
        signer.signer(),
        &plaintext,
        &server_out,
    );
    const client_event = try client.handleRecord(server_out[0..flight_record.len], &client_out);
    const client_finished_record = switch (client_event) {
        .write => |w| w,
        else => return error.UnexpectedEvent,
    };

    var inspect_rx = try server.rx.clone();
    defer inspect_rx.deinit();
    var inspect_buf: [1024]u8 = undefined;
    @memcpy(inspect_buf[0..client_finished_record.len], client_finished_record);
    const dec = try inspect_rx.decrypt(inspect_buf[0..client_finished_record.len]);
    var hr: HandshakeReader = .init(dec.content);
    const cert = (try hr.next()).?;
    try testing.expectEqual(.certificate, cert.type);
    try testing.expectEqual(.empty, try certificate.parseClientCertificate(cert.raw, &.{}));
    try testing.expectEqual(.finished, (try hr.next()).?.type);
    try testing.expectEqual(@as(?HandshakeReader.Message, null), try hr.next());

    client.completeWrite();
    try server.processClientFinished(client_out[0..client_finished_record.len]);
    try testing.expectEqual(.connected, server.state);
    try testing.expectEqual(@as(?[]const u8, null), server.clientCertificateDer());
    try testing.expectEqual(@as(?Certificate.Parsed, null), server.clientCertificate());
}

// RFC 8446 §4.4.2 — a server that requires client authentication rejects an
// empty client Certificate with certificate_required.
test "processClientFinished: required client auth rejects empty Certificate" {
    const client_keypair: x25519.KeyPair = .generate();
    const server_keypair: x25519.KeyPair = .generate();

    var client: ClientHandshake = .init(.{
        .keypairs = try .init(client_keypair),
        .host_name = "ztls.server.test",
        .now_sec = 0,
        .random = .zero,
    });
    client.policy.insecure_no_chain_anchor = true;
    var client_out: [1024]u8 = undefined;
    const ch_record = try client.start(&client_out);
    client.completeWrite();

    var server: ServerHandshake = .init(.{
        .keypairs = try .init(server_keypair),
        .random = .zero,
        .client_auth = .required,
    });
    var server_out: [4096]u8 = undefined;
    const sh_record = try server.acceptClientHello(ch_record, &server_out);
    try client.processServerHello(sh_record[frame.header_len..]);

    var signer = try signature.PrivateKey.fromP256Scalar(serverEcdsaScalar()[0..32]);
    defer signer.deinit();
    var handshake_tx = try server.tx.clone();
    defer handshake_tx.deinit();
    var plaintext: [4096]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(
        &.{serverEcdsaCertDer()},
        signer.signer(),
        &plaintext,
        &server_out,
    );
    const client_event = try client.handleRecord(server_out[0..flight_record.len], &client_out);
    const client_finished_record = switch (client_event) {
        .write => |w| w,
        else => return error.UnexpectedEvent,
    };
    client.completeWrite();

    try testing.expectError(
        error.ClientCertificateRequired,
        server.processClientFinished(client_out[0..client_finished_record.len]),
    );
    try testing.expectEqual(.wait_client_finished, server.state);

    // RFC 8446 §4.4.4 — records after the server Finished, including alerts
    // rejecting client authentication, use application traffic keys even
    // though the client flight was received with the handshake read key.
    const alert_record = try server.sendAlert(.certificate_required, &server_out);
    var handshake_copy: [64]u8 = undefined;
    @memcpy(handshake_copy[0..alert_record.len], alert_record);
    try testing.expectError(
        error.AuthenticationFailed,
        handshake_tx.decrypt(handshake_copy[0..alert_record.len]),
    );
    try testing.expectError(
        error.PeerAlert,
        client.handleRecord(server_out[0..alert_record.len], &client_out),
    );
    try testing.expectEqual(
        @as(?alert.Alert, .{ .level = .fatal, .description = .certificate_required }),
        client.lastPeerAlert(),
    );
}

// RFC 8446 §4.4.2, §4.4.3, §4.4.4 — required client auth with real client
// credentials: the client sends Certificate (chain) + CertificateVerify, the
// server verifies the CertificateVerify against the client leaf public key and
// accepts the handshake. insecure_no_client_chain_anchor is set so the
// self-signed fixture chain is accepted without a trust bundle; the
// CertificateVerify still proves possession of the private key. This exercises
// the client sign path through the real handleRecord drive loop.
test "processClientFinished: required client auth verifies real client Certificate + CV" {
    const client_keypair: x25519.KeyPair = .generate();
    const server_keypair: x25519.KeyPair = .generate();

    var client: ClientHandshake = .init(.{
        .keypairs = try .init(client_keypair),
        .host_name = "ztls.server.test",
        .now_sec = 0,
        .random = .zero,
    });
    client.policy.insecure_no_chain_anchor = true;
    // Client credentials: the client fixture has clientAuth EKU so the
    // server's leaf EKU/KU enforcement (leaf_usage=.client_auth) accepts it.
    var client_signer = try signature.PrivateKey.fromP256Scalar(clientEcdsaScalar()[0..32]);
    defer client_signer.deinit();
    client.setCredentials(&.{clientEcdsaCertDer()}, client_signer.signer());
    var client_out: [4096]u8 = undefined;
    const ch_record = try client.start(&client_out);
    client.completeWrite();

    var client_cert_storage: [1024]u8 = undefined;
    var server: ServerHandshake = .init(.{
        .keypairs = try .init(server_keypair),
        .random = .zero,
        .client_auth = .required,
        .insecure_no_client_chain_anchor = true,
        .client_cert_buffer = &client_cert_storage,
    });
    try testing.expectEqual(@as(?[]const u8, null), server.clientCertificateDer());
    try testing.expectEqual(@as(?Certificate.Parsed, null), server.clientCertificate());
    var server_out: [4096]u8 = undefined;
    const sh_record = try server.acceptClientHello(ch_record, &server_out);
    try client.processServerHello(sh_record[frame.header_len..]);

    var signer = try signature.PrivateKey.fromP256Scalar(serverEcdsaScalar()[0..32]);
    defer signer.deinit();
    var plaintext: [4096]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(
        &.{serverEcdsaCertDer()},
        signer.signer(),
        &plaintext,
        &server_out,
    );
    // The server flight includes a CertificateRequest; the client now has
    // credentials, so its Finished carries Certificate + CertificateVerify.
    const client_event = try client.handleRecord(server_out[0..flight_record.len], &client_out);
    const client_finished_record = switch (client_event) {
        .write => |w| w,
        else => return error.UnexpectedEvent,
    };

    // Inspect the client flight: Certificate (non-empty) + CertificateVerify +
    // Finished, in that order. RFC 8446 §4.4.2, §4.4.3, §4.4.4.
    var inspect_rx = try server.rx.clone();
    defer inspect_rx.deinit();
    var inspect_buf: [4096]u8 = undefined;
    @memcpy(inspect_buf[0..client_finished_record.len], client_finished_record);
    const dec = try inspect_rx.decrypt(inspect_buf[0..client_finished_record.len]);
    var hr: HandshakeReader = .init(dec.content);
    const cert_msg = (try hr.next()).?;
    try testing.expectEqual(.certificate, cert_msg.type);
    try testing.expectEqual(.present, try certificate.parseClientCertificate(cert_msg.raw, &.{}));
    const cv_msg = (try hr.next()).?;
    try testing.expectEqual(.certificate_verify, cv_msg.type);
    try testing.expectEqual(.finished, (try hr.next()).?.type);
    try testing.expectEqual(@as(?HandshakeReader.Message, null), try hr.next());

    client.completeWrite();
    try server.processClientFinished(client_out[0..client_finished_record.len]);
    try testing.expectEqual(.connected, server.state);

    const retained_der = server.clientCertificateDer().?;
    try testing.expectEqualSlices(u8, clientEcdsaCertDer(), retained_der);
    const retained = server.clientCertificate().?;
    const presented: Certificate = .{ .buffer = clientEcdsaCertDer(), .index = 0 };
    const parsed_presented = try presented.parse();
    try testing.expectEqualSlices(u8, parsed_presented.subject(), retained.subject());
    const expected_san = parsed_presented.subject_alt_name_slice;
    const actual_san = retained.subject_alt_name_slice;
    try testing.expectEqualSlices(
        u8,
        parsed_presented.certificate.buffer[expected_san.start..expected_san.end],
        retained.certificate.buffer[actual_san.start..actual_san.end],
    );

    // RFC 8446 §7.1 — the ticket PSK binds the complete client-auth flight,
    // including Certificate, CertificateVerify, and client Finished.
    var ticket_psk = try server.deriveTicketPsk();
    defer ticket_psk.secureZero();
    const ticket_record = try server.sendNewSessionTicket(
        &ticket_psk,
        .{
            .ticket_lifetime = 60,
            .ticket_age_add = 0x12345678,
            .ticket = "client-auth-ticket",
        },
        &server_out,
    );
    var nst_out: [64]u8 = undefined;
    const ticket_event = try client.handleRecord(
        server_out[0..ticket_record.len],
        &nst_out,
    );
    const nst = switch (ticket_event) {
        .new_session_ticket => |ticket| ticket,
        else => return error.UnexpectedEvent,
    };
    var session = try client.deriveSessionTicket(nst);
    defer session.secureZero();
    try testing.expectEqualSlices(
        u8,
        ticket_psk.psk.constSlice(),
        session.psk.constSlice(),
    );
    server.completeWrite();
}

// RFC 8446 §4.4.3, §4.4.4 — a chain-valid client identity is not retained
// unless CertificateVerify and Finished both authenticate the client.
test "processClientFinished: bad client Finished does not retain identity" {
    const client_keypair: x25519.KeyPair = .generate();
    const server_keypair: x25519.KeyPair = .generate();

    var client: ClientHandshake = .init(.{
        .keypairs = try .init(client_keypair),
        .host_name = "ztls.server.test",
        .now_sec = 0,
        .random = .zero,
    });
    client.policy.insecure_no_chain_anchor = true;
    var client_signer = try signature.PrivateKey.fromP256Scalar(clientEcdsaScalar()[0..32]);
    defer client_signer.deinit();
    client.setCredentials(&.{clientEcdsaCertDer()}, client_signer.signer());
    var client_out: [4096]u8 = undefined;
    const ch_record = try client.start(&client_out);
    client.completeWrite();

    var client_cert_storage: [1024]u8 = undefined;
    var server: ServerHandshake = .init(.{
        .keypairs = try .init(server_keypair),
        .random = .zero,
        .client_auth = .required,
        .insecure_no_client_chain_anchor = true,
        .client_cert_buffer = &client_cert_storage,
    });
    var server_out: [4096]u8 = undefined;
    const sh_record = try server.acceptClientHello(ch_record, &server_out);
    try client.processServerHello(sh_record[frame.header_len..]);

    var signer = try signature.PrivateKey.fromP256Scalar(serverEcdsaScalar()[0..32]);
    defer signer.deinit();
    var plaintext: [4096]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(
        &.{serverEcdsaCertDer()},
        signer.signer(),
        &plaintext,
        &server_out,
    );
    const client_event = try client.handleRecord(server_out[0..flight_record.len], &client_out);
    const client_finished_record = switch (client_event) {
        .write => |w| w,
        else => return error.UnexpectedEvent,
    };

    var inspect_rx = try server.rx.clone();
    defer inspect_rx.deinit();
    var inspect_buf: [4096]u8 = undefined;
    @memcpy(inspect_buf[0..client_finished_record.len], client_finished_record);
    const dec = try inspect_rx.decrypt(inspect_buf[0..client_finished_record.len]);
    dec.content[dec.content.len - 1] ^= 0xff;

    var tampered_tx = try server.rx.clone();
    defer tampered_tx.deinit();
    var tampered_wire: [4096]u8 = undefined;
    const tampered_record = try tampered_tx.encrypt(.handshake, dec.content, &tampered_wire);
    client.completeWrite();
    try testing.expectError(
        error.InvalidVerifyData,
        server.processClientFinished(tampered_wire[0..tampered_record.len]),
    );
    try testing.expectEqual(.wait_client_finished, server.state);
    try testing.expectEqual(@as(usize, 0), server.client_cert.len);
    try testing.expectEqual(@as(?[]const u8, null), server.clientCertificateDer());
}

// RFC 8446 §4.4.2, §4.4.3 — omitting caller-owned retention storage does not
// prevent successful client authentication; the verified identity is null.
test "processClientFinished: client identity requires caller-owned storage" {
    const client_keypair: x25519.KeyPair = .generate();
    const server_keypair: x25519.KeyPair = .generate();

    var client: ClientHandshake = .init(.{
        .keypairs = try .init(client_keypair),
        .host_name = "ztls.server.test",
        .now_sec = 0,
        .random = .zero,
    });
    client.policy.insecure_no_chain_anchor = true;
    var client_signer = try signature.PrivateKey.fromP256Scalar(clientEcdsaScalar()[0..32]);
    defer client_signer.deinit();
    client.setCredentials(&.{clientEcdsaCertDer()}, client_signer.signer());
    var client_out: [4096]u8 = undefined;
    const ch_record = try client.start(&client_out);
    client.completeWrite();

    var server: ServerHandshake = .init(.{
        .keypairs = try .init(server_keypair),
        .random = .zero,
        .client_auth = .required,
        .insecure_no_client_chain_anchor = true,
    });
    var server_out: [4096]u8 = undefined;
    const sh_record = try server.acceptClientHello(ch_record, &server_out);
    try client.processServerHello(sh_record[frame.header_len..]);

    var signer = try signature.PrivateKey.fromP256Scalar(serverEcdsaScalar()[0..32]);
    defer signer.deinit();
    var plaintext: [4096]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(
        &.{serverEcdsaCertDer()},
        signer.signer(),
        &plaintext,
        &server_out,
    );
    const client_event = try client.handleRecord(server_out[0..flight_record.len], &client_out);
    const client_finished_record = switch (client_event) {
        .write => |w| w,
        else => return error.UnexpectedEvent,
    };
    client.completeWrite();
    try server.processClientFinished(client_out[0..client_finished_record.len]);

    try testing.expectEqual(.connected, server.state);
    try testing.expectEqual(@as(?[]const u8, null), server.clientCertificateDer());
    try testing.expectEqual(@as(?Certificate.Parsed, null), server.clientCertificate());
}

// RFC 8446 §4.4.3 — a client CertificateVerify whose signature does not match
// the leaf certificate public key is rejected (decrypt_error). The client
// presents the fixture cert but signs with a different private key.
test "processClientFinished: required client auth rejects forged CertificateVerify" {
    const client_keypair: x25519.KeyPair = .generate();
    const server_keypair: x25519.KeyPair = .generate();

    var client: ClientHandshake = .init(.{
        .keypairs = try .init(client_keypair),
        .host_name = "ztls.server.test",
        .now_sec = 0,
        .random = .zero,
    });
    client.policy.insecure_no_chain_anchor = true;
    // Present the client fixture cert (clientAuth EKU) but sign with a DISTINCT
    // private key (all-zeros scalar is invalid for P-256; use a deterministic
    // non-fixture scalar).
    const wrong_scalar = [_]u8{0x42} ** 32;
    var client_signer = try signature.PrivateKey.fromP256Scalar(&wrong_scalar);
    defer client_signer.deinit();
    client.setCredentials(&.{clientEcdsaCertDer()}, client_signer.signer());
    var client_out: [4096]u8 = undefined;
    const ch_record = try client.start(&client_out);
    client.completeWrite();

    var server: ServerHandshake = .init(.{
        .keypairs = try .init(server_keypair),
        .random = .zero,
        .client_auth = .required,
        .insecure_no_client_chain_anchor = true,
    });
    var server_out: [4096]u8 = undefined;
    const sh_record = try server.acceptClientHello(ch_record, &server_out);
    try client.processServerHello(sh_record[frame.header_len..]);

    var signer = try signature.PrivateKey.fromP256Scalar(serverEcdsaScalar()[0..32]);
    defer signer.deinit();
    var plaintext: [4096]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(
        &.{serverEcdsaCertDer()},
        signer.signer(),
        &plaintext,
        &server_out,
    );
    const client_event = try client.handleRecord(server_out[0..flight_record.len], &client_out);
    const client_finished_record = switch (client_event) {
        .write => |w| w,
        else => return error.UnexpectedEvent,
    };
    client.completeWrite();

    // The server verifies the CertificateVerify against the fixture cert's
    // public key, but the signature was made with a different key.
    try testing.expectError(
        error.SignatureVerificationFailed,
        server.processClientFinished(client_out[0..client_finished_record.len]),
    );
}

test "sendAuthenticatedFlight: client processes CertificateVerify and Finished" {
    const client_keypair: x25519.KeyPair = .generate();
    const server_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(
        &ch_buf,
        .zero,
        client_keypair.public_key,
        "ztls.server.test",
        &.{"h2"},
    );
    var ch_record: [1024]u8 = undefined;
    const header: frame.Header = .init(.handshake, @intCast(ch.len));
    header.write(ch_record[0..frame.header_len]);
    @memcpy(ch_record[frame.header_len..][0..ch.len], ch);

    var server: ServerHandshake = .init(try testConfig(server_keypair));
    server.supportAlpn(&.{"h2"});
    var sh_out: [256]u8 = undefined;
    const sh_record = try server.acceptClientHello(
        ch_record[0 .. frame.header_len + ch.len],
        &sh_out,
    );

    var signer: signature.PrivateKey = try .fromP256Scalar(serverEcdsaScalar()[0..32]);
    defer signer.deinit();
    const signer_api = signer.signer();
    var plaintext: [4096]u8 = undefined;
    var flight_out: [4096]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(
        &.{serverEcdsaCertDer()},
        signer_api,
        &plaintext,
        &flight_out,
    );

    var client: ClientHandshake = .init(.{
        .keypairs = try .init(client_keypair),
        .host_name = "ztls.server.test",
        .now_sec = 0,
        .random = .zero,
    });
    client.offerAlpn(&.{"h2"});
    client.policy.insecure_no_chain_anchor = true;
    client.injectClientHello(ch);
    try client.processServerHello(sh_record[frame.header_len..]);
    const dec = try client.rx.decrypt(flight_out[0..flight_record.len]);
    try client.processFlight(dec.content, client.policy);
    try testing.expectEqual(.send_finished, client.state);
    try testing.expectEqualStrings("h2", client.selectedAlpnProtocol().?);
}

test "processClientFinished: verifies Finished and installs app keys" {
    const client_keypair: x25519.KeyPair = .generate();
    const server_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    var ch_record: [1024]u8 = undefined;
    const header: frame.Header = .init(.handshake, @intCast(ch.len));
    header.write(ch_record[0..frame.header_len]);
    @memcpy(ch_record[frame.header_len..][0..ch.len], ch);

    var server: ServerHandshake = .init(try testConfig(server_keypair));
    var sh_out: [256]u8 = undefined;
    _ = try server.acceptClientHello(ch_record[0 .. frame.header_len + ch.len], &sh_out);
    var flight_out: [512]u8 = undefined;
    _ = try server.sendAnonymousFlightForTest(&flight_out);

    var fin_plain: [64]u8 = undefined;
    const fin = switch (server.suite_state) {
        inline .sha256, .sha384 => |*s| blk: {
            const th = s.transcript.peek();
            break :blk try finished.encode(
                @TypeOf(s.transcript),
                &fin_plain,
                &s.client_finished_key.data,
                &th,
            );
        },
    };
    var client_tx = try server.rx.clone();
    defer client_tx.deinit();
    var fin_wire: [128]u8 = undefined;
    const fin_record = try client_tx.encrypt(.handshake, fin, &fin_wire);
    try server.processClientFinished(fin_wire[0..fin_record.len]);
    try testing.expectEqual(.connected, server.state);
    try testing.expectEqual(@as(u64, 0), server.rx.seq);
    try testing.expectEqual(@as(u64, 0), server.tx.seq);
}

// RFC 8446 §4.4.4 — the server must reject a client Finished with a bad
// verify_data MAC. Regression for the NEGATIVE_SPACE gap: bad-ClientFinished
// negative tests were partial.
test "processClientFinished: rejects bad verify_data" {
    const client_keypair: x25519.KeyPair = .generate();
    const server_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    var ch_record: [1024]u8 = undefined;
    const header: frame.Header = .init(.handshake, @intCast(ch.len));
    header.write(ch_record[0..frame.header_len]);
    @memcpy(ch_record[frame.header_len..][0..ch.len], ch);

    var server: ServerHandshake = .init(try testConfig(server_keypair));
    var sh_out: [256]u8 = undefined;
    _ = try server.acceptClientHello(ch_record[0 .. frame.header_len + ch.len], &sh_out);
    var flight_out: [512]u8 = undefined;
    _ = try server.sendAnonymousFlightForTest(&flight_out);

    var fin_plain: [64]u8 = undefined;
    const fin = switch (server.suite_state) {
        inline .sha256, .sha384 => |*s| blk: {
            const th = s.transcript.peek();
            break :blk try finished.encode(
                @TypeOf(s.transcript),
                &fin_plain,
                &s.client_finished_key.data,
                &th,
            );
        },
    };
    // Tamper one byte of the verify_data (after the 4-byte handshake header).
    var tampered: [64]u8 = undefined;
    @memcpy(tampered[0..fin.len], fin);
    tampered[5] ^= 0xff;

    var client_tx = try server.rx.clone();
    defer client_tx.deinit();
    var fin_wire: [128]u8 = undefined;
    const fin_record = try client_tx.encrypt(.handshake, tampered[0..fin.len], &fin_wire);
    try testing.expectError(
        error.InvalidVerifyData,
        server.processClientFinished(fin_wire[0..fin_record.len]),
    );
    try testing.expectEqual(.wait_client_finished, server.state);
}

// RFC 8446 §4.5 — if the server declined 0-RTT (or no 0-RTT was offered),
// the client MUST NOT send EndOfEarlyData. The server must reject an
// unexpected EOED. Regression for the H5b Q3 coverage gap: the server's
// flight-walk rejects any non-Finished handshake type when no client auth is
// configured.
test "processClientFinished: rejects EndOfEarlyData when 0-RTT was not accepted" {
    const client_keypair: x25519.KeyPair = .generate();
    const server_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    var ch_record: [1024]u8 = undefined;
    const header: frame.Header = .init(.handshake, @intCast(ch.len));
    header.write(ch_record[0..frame.header_len]);
    @memcpy(ch_record[frame.header_len..][0..ch.len], ch);

    var server: ServerHandshake = .init(try testConfig(server_keypair));
    var sh_out: [256]u8 = undefined;
    _ = try server.acceptClientHello(ch_record[0 .. frame.header_len + ch.len], &sh_out);
    var flight_out: [512]u8 = undefined;
    _ = try server.sendAnonymousFlightForTest(&flight_out);
    try testing.expect(server.early_rx == null);

    // Craft an EndOfEarlyData handshake message (type 0x05, 3-byte zero length).
    const eoed = [_]u8{ 0x05, 0x00, 0x00, 0x00 };
    var client_tx = try server.rx.clone();
    defer client_tx.deinit();
    var eoed_wire: [128]u8 = undefined;
    const eoed_record = try client_tx.encrypt(.handshake, &eoed, &eoed_wire);
    try testing.expectError(
        error.UnexpectedMessage,
        server.processClientFinished(eoed_wire[0..eoed_record.len]),
    );
    try testing.expectEqual(.wait_client_finished, server.state);
}

// RFC 8446 §4.1.2 — TLS 1.3 has no renegotiation; a second ClientHello is an
// unexpected_message after the first ClientHello.
test "handleRecord: rejects second plaintext ClientHello before Finished" {
    const client_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    var ch_record: [1024]u8 = undefined;
    const header: frame.Header = .init(.handshake, @intCast(ch.len));
    header.write(ch_record[0..frame.header_len]);
    @memcpy(ch_record[frame.header_len..][0..ch.len], ch);

    var server: ServerHandshake = .init(try testConfig(.generate()));
    var sh_out: [256]u8 = undefined;
    _ = try server.acceptClientHello(ch_record[0 .. frame.header_len + ch.len], &sh_out);
    var flight_out: [512]u8 = undefined;
    _ = try server.sendAnonymousFlightForTest(&flight_out);

    try testing.expectError(
        error.UnexpectedMessage,
        server.handleRecord(ch_record[0 .. frame.header_len + ch.len], &sh_out),
    );

    var peer = try server.tx.clone();
    defer peer.deinit();
    const rec = try server.sendAlert(.unexpected_message, &sh_out);
    var rec_buf: [64]u8 = undefined;
    @memcpy(rec_buf[0..rec.len], rec);
    const dec = try peer.decrypt(rec_buf[0..rec.len]);
    try testing.expectEqual(.alert, dec.content_type);
    const a = try alert.parse(dec.content);
    try testing.expectEqual(.unexpected_message, a.description);
}

// RFC 8446 §4.1.2 — a protected ClientHello after connection establishment is
// still renegotiation and must be rejected.
test "handleRecord: rejects protected ClientHello after connected" {
    var server = try connectedTestServer();
    var client_tx = try server.rx.clone();
    defer client_tx.deinit();

    const client_hello_type = @intFromEnum(HandshakeType.client_hello);
    const renegotiate = [_]u8{ client_hello_type, 0x00, 0x00, 0x00 };
    var wire_buf: [64]u8 = undefined;
    const wire_rec = try client_tx.encrypt(.handshake, &renegotiate, &wire_buf);
    var rx_buf: [64]u8 = undefined;
    @memcpy(rx_buf[0..wire_rec.len], wire_rec);
    var out: [64]u8 = undefined;
    try testing.expectError(
        error.UnexpectedMessage,
        server.handleRecord(rx_buf[0..wire_rec.len], &out),
    );

    var peer = try server.tx.clone();
    defer peer.deinit();
    const rec = try server.sendAlert(.unexpected_message, &out);
    var rec_buf: [64]u8 = undefined;
    @memcpy(rec_buf[0..rec.len], rec);
    const dec = try peer.decrypt(rec_buf[0..rec.len]);
    try testing.expectEqual(.alert, dec.content_type);
    const a = try alert.parse(dec.content);
    try testing.expectEqual(.unexpected_message, a.description);
}

// RFC 8446 §4.6.3 — KeyUpdate is post-handshake only.
test "handleRecord: rejects client KeyUpdate before Finished" {
    const client_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    var ch_record: [1024]u8 = undefined;
    const header: frame.Header = .init(.handshake, @intCast(ch.len));
    header.write(ch_record[0..frame.header_len]);
    @memcpy(ch_record[frame.header_len..][0..ch.len], ch);

    var server: ServerHandshake = .init(try testConfig(.generate()));
    var sh_out: [256]u8 = undefined;
    _ = try server.acceptClientHello(ch_record[0 .. frame.header_len + ch.len], &sh_out);
    var flight_out: [512]u8 = undefined;
    _ = try server.sendAnonymousFlightForTest(&flight_out);

    var client_tx = try server.rx.clone();
    defer client_tx.deinit();
    const ku = [_]u8{
        @intFromEnum(HandshakeType.key_update),              0x00, 0x00, 0x01,
        @intFromEnum(KeyUpdateRequest.update_not_requested),
    };
    var wire_buf: [64]u8 = undefined;
    const wire_rec = try client_tx.encrypt(.handshake, &ku, &wire_buf);
    var rx_buf: [64]u8 = undefined;
    @memcpy(rx_buf[0..wire_rec.len], wire_rec);
    var out: [64]u8 = undefined;
    try testing.expectError(
        error.UnexpectedMessage,
        server.handleRecord(rx_buf[0..wire_rec.len], &out),
    );
    try testing.expectEqual(.wait_client_finished, server.state);
}

// RFC 8446 §4.6.3, §5.2 — RX state is independent from an outstanding TX
// record; a KeyUpdate request ratchets RX without changing TX.
test "receiveRecord: RX progresses while a server TX record is pending" {
    var server = try connectedTestServer();
    defer server.deinit();

    var client_tx = try server.rx.clone();
    defer client_tx.deinit();

    var server_out: [64]u8 = undefined;
    _ = try server.sendApplicationData("blocked", &server_out);
    const tx_before = server.txKtlsInfo();

    var peer_out: [128]u8 = undefined;
    const app = try client_tx.encrypt(.application_data, "ping", &peer_out);
    var app_record: [64]u8 = undefined;
    @memcpy(app_record[0..app.len], app);
    const app_event = try server.receiveRecord(app_record[0..app.len]);
    try testing.expectEqualSlices(u8, "ping", app_event.application_data);

    const ku = [_]u8{
        @intFromEnum(HandshakeType.key_update),          0x00, 0x00, 0x01,
        @intFromEnum(KeyUpdateRequest.update_requested),
    };
    const update = try client_tx.encrypt(.handshake, &ku, &peer_out);
    var update_record: [64]u8 = undefined;
    @memcpy(update_record[0..update.len], update);
    const update_event = try server.receiveRecord(update_record[0..update.len]);
    try testing.expectEqual(KeyUpdateRequest.update_requested, update_event.key_update);
    try testing.expectEqual(tx_before, server.txKtlsInfo());

    try testing.expectError(
        error.PendingWrite,
        server.handleRecord(update_record[0..update.len], &server_out),
    );
}

// RFC 8446 §4.6.3, §5.3 — Linux kTLS supplies one decrypted record and owns
// its sequence number. The server still validates KeyUpdate and ratchets RX.
test "receiveKtlsRecord: server processes kernel-decrypted records" {
    var server = try connectedTestServer();
    defer server.deinit();

    const rx_before = server.rxKtlsInfo();
    const tx_before = server.txKtlsInfo();
    var app = "ping".*;
    const app_event = try server.receiveKtlsRecord(.application_data, &app);
    try testing.expectEqualSlices(u8, "ping", app_event.application_data);
    try testing.expectEqual(rx_before, server.rxKtlsInfo());

    var update = [_]u8{
        @intFromEnum(HandshakeType.key_update),          0x00, 0x00, 0x01,
        @intFromEnum(KeyUpdateRequest.update_requested),
    };
    const update_event = try server.receiveKtlsRecord(.handshake, &update);
    try testing.expectEqual(KeyUpdateRequest.update_requested, update_event.key_update);
    try testing.expectEqual(tx_before, server.txKtlsInfo());
    const rx_after = server.rxKtlsInfo();
    try testing.expect(!mem.eql(
        u8,
        rx_before.key[0..rx_before.key_len],
        rx_after.key[0..rx_after.key_len],
    ));
    try testing.expectEqualSlices(u8, &([_]u8{0} ** 8), &rx_after.rec_seq);
    try testing.expect(server.hasPendingKeyUpdateResponse());
    var blocked_out: [frame.max_wire_record_len]u8 = undefined;
    try testing.expectError(
        error.PendingKeyUpdateResponse,
        server.sendPreparedApplicationData("blocked".len, &blocked_out),
    );
    try server.ratchetKtlsTx(.update_not_requested);
    try testing.expect(!server.hasPendingKeyUpdateResponse());
}

// RFC 8446 §4.6.3 — an external record layer sends KeyUpdate under the old TX
// key, then asks the engine to derive the next epoch before later records.
test "ratchetKtlsTx: server advances only an idle TX epoch" {
    var server = try connectedTestServer();
    defer server.deinit();

    const tx_before = server.txKtlsInfo();
    const rx_before = server.rxKtlsInfo();
    try server.ratchetKtlsTx(.update_requested);
    const tx_after = server.txKtlsInfo();
    try testing.expect(!mem.eql(
        u8,
        tx_before.key[0..tx_before.key_len],
        tx_after.key[0..tx_after.key_len],
    ));
    try testing.expectEqualSlices(u8, &([_]u8{0} ** 8), &tx_after.rec_seq);
    try testing.expectEqual(rx_before, server.rxKtlsInfo());

    try testing.expect(!server.hasPendingWrite());
    var out: [64]u8 = undefined;
    _ = try server.sendApplicationData("pending", &out);
    try testing.expect(server.hasPendingWrite());
    try testing.expectError(error.PendingWrite, server.ratchetKtlsTx(.update_not_requested));
    server.completeWrite();
    try testing.expect(!server.hasPendingWrite());
}

// RFC 8446 §4.6.3 — a client KeyUpdate(update_requested) ratchets the
// server receive key and elicits a server KeyUpdate(update_not_requested),
// encrypted under the old send key. The event surfaces as `.key_update`
// carrying both epoch changes and the response record.
test "handleRecord: client KeyUpdate(update_requested) ratchets rx and responds" {
    var server = try connectedTestServer();
    const rx_ktls_0 = server.rxKtlsInfo();
    const tx_ktls_0 = server.txKtlsInfo();
    var client_tx = try server.rx.clone();
    defer client_tx.deinit();
    var server_tx_old = try server.tx.clone();
    defer server_tx_old.deinit();

    const ku = [_]u8{
        @intFromEnum(HandshakeType.key_update),          0x00, 0x00, 0x01,
        @intFromEnum(KeyUpdateRequest.update_requested),
    };
    var ku_buf: [64]u8 = undefined;
    const ku_wire = try client_tx.encrypt(.handshake, &ku, &ku_buf);
    var rx_buf: [64]u8 = undefined;
    @memcpy(rx_buf[0..ku_wire.len], ku_wire);
    var out: [64]u8 = undefined;
    const ev = try server.handleRecord(rx_buf[0..ku_wire.len], &out);

    try testing.expect(ev == .key_update);
    try testing.expectEqual(true, ev.key_update.rx);
    try testing.expectEqual(true, ev.key_update.tx);
    const resp = ev.key_update.response.?;
    var resp_buf: [64]u8 = undefined;
    @memcpy(resp_buf[0..resp.len], resp);
    const dec = try server_tx_old.decrypt(resp_buf[0..resp.len]);
    try testing.expectEqual(.handshake, dec.content_type);
    try testing.expectEqualSlices(u8, &.{
        @intFromEnum(HandshakeType.key_update),              0x00, 0x00, 0x01,
        @intFromEnum(KeyUpdateRequest.update_not_requested),
    }, dec.content);
    server.completeWrite();
    const rx_ktls_1 = server.rxKtlsInfo();
    const tx_ktls_1 = server.txKtlsInfo();
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

    var client_tx_1 = try server.rx.clone();
    defer client_tx_1.deinit();
    var app_buf: [64]u8 = undefined;
    const app_wire = try client_tx_1.encrypt(.application_data, "after", &app_buf);
    var app_rx: [64]u8 = undefined;
    @memcpy(app_rx[0..app_wire.len], app_wire);
    const ev_after = try server.handleRecord(app_rx[0..app_wire.len], &out);
    try testing.expectEqualSlices(u8, "after", ev_after.application_data);
}

// RFC 8446 §4.6.3 — update_not_requested only ratchets the receive key.
// The event surfaces as `.key_update` with rx=true, tx=false, response=null.
test "handleRecord: client KeyUpdate(update_not_requested) ratchets rx only" {
    var server = try connectedTestServer();
    const rx_ktls_0 = server.rxKtlsInfo();
    const tx_ktls_0 = server.txKtlsInfo();
    var client_tx = try server.rx.clone();
    defer client_tx.deinit();

    const ku = [_]u8{
        @intFromEnum(HandshakeType.key_update),              0x00, 0x00, 0x01,
        @intFromEnum(KeyUpdateRequest.update_not_requested),
    };
    var ku_buf: [64]u8 = undefined;
    const ku_wire = try client_tx.encrypt(.handshake, &ku, &ku_buf);
    var rx_buf: [64]u8 = undefined;
    @memcpy(rx_buf[0..ku_wire.len], ku_wire);
    var out: [64]u8 = undefined;
    const ev = try server.handleRecord(rx_buf[0..ku_wire.len], &out);

    try testing.expect(ev == .key_update);
    try testing.expectEqual(true, ev.key_update.rx);
    try testing.expectEqual(false, ev.key_update.tx);
    try testing.expectEqual(@as(?[]const u8, null), ev.key_update.response);

    // RX material changed; TX material unchanged.
    const rx_ktls_1 = server.rxKtlsInfo();
    const tx_ktls_1 = server.txKtlsInfo();
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

    var client_tx_1 = try server.rx.clone();
    defer client_tx_1.deinit();
    var app_buf: [64]u8 = undefined;
    const app_wire = try client_tx_1.encrypt(.application_data, "after", &app_buf);
    var app_rx: [64]u8 = undefined;
    @memcpy(app_rx[0..app_wire.len], app_wire);
    const ev_after2 = try server.handleRecord(app_rx[0..app_wire.len], &out);
    try testing.expectEqualSlices(u8, "after", ev_after2.application_data);
}

// RFC 8446 §4.6.3 — server KeyUpdate is encrypted under the old send key, then ratchets.
test "sendKeyUpdate: server-initiated KeyUpdate encrypts under old key then ratchets tx" {
    var server = try connectedTestServer();
    const tx_ktls_0 = server.txKtlsInfo();
    var peer_rx_old = try server.tx.clone();
    defer peer_rx_old.deinit();
    var out: [64]u8 = undefined;
    const rec = try server.sendKeyUpdate(&out, .update_requested);
    var rec_buf: [64]u8 = undefined;
    @memcpy(rec_buf[0..rec.len], rec);
    const dec = try peer_rx_old.decrypt(rec_buf[0..rec.len]);
    try testing.expectEqual(.handshake, dec.content_type);
    try testing.expectEqualSlices(u8, &.{
        @intFromEnum(HandshakeType.key_update),          0x00, 0x00, 0x01,
        @intFromEnum(KeyUpdateRequest.update_requested),
    }, dec.content);
    const tx_ktls_1 = server.txKtlsInfo();
    try testing.expect(!mem.eql(
        u8,
        tx_ktls_0.key[0..tx_ktls_0.key_len],
        tx_ktls_1.key[0..tx_ktls_1.key_len],
    ));
    try testing.expectEqualSlices(u8, &([_]u8{0} ** 8), &tx_ktls_1.rec_seq);
    try testing.expectError(error.PendingWrite, server.sendKeyUpdate(&out, .update_requested));
    server.completeWrite();
}

// RFC 8446 §4.6.3, §7.2 — after a self-initiated sendKeyUpdate(.update_requested),
// TX ratchets inside that call. When the peer's response KeyUpdate(update_not_requested)
// arrives, the event surfaces rx=true, tx=false, response=null.
test "handleRecord: self-initiated sendKeyUpdate response surfaces rx only" {
    var server = try connectedTestServer();
    const tx_ktls_0 = server.txKtlsInfo();

    // Self-initiated KeyUpdate: TX ratchets inside the call.
    var out: [64]u8 = undefined;
    _ = try server.sendKeyUpdate(&out, .update_requested);
    server.completeWrite();
    const tx_ktls_1 = server.txKtlsInfo();
    try testing.expect(!mem.eql(
        u8,
        tx_ktls_0.key[0..tx_ktls_0.key_len],
        tx_ktls_1.key[0..tx_ktls_1.key_len],
    ));

    // Peer responds with KeyUpdate(update_not_requested) under the peer's
    // next TX key (which mirrors our next RX key). Build a mirror of our
    // pre-ratchet RX, then ratchet it to produce the peer's response.
    var peer_tx = try server.rx.clone();
    defer peer_tx.deinit();
    const ku_nr = [_]u8{
        @intFromEnum(HandshakeType.key_update),              0x00, 0x00, 0x01,
        @intFromEnum(KeyUpdateRequest.update_not_requested),
    };
    var ku_buf: [64]u8 = undefined;
    const ku_wire = try peer_tx.encrypt(.handshake, &ku_nr, &ku_buf);
    var rx_buf: [64]u8 = undefined;
    @memcpy(rx_buf[0..ku_wire.len], ku_wire);

    const ev = try server.handleRecord(rx_buf[0..ku_wire.len], &out);
    try testing.expect(ev == .key_update);
    try testing.expectEqual(true, ev.key_update.rx);
    try testing.expectEqual(false, ev.key_update.tx);
    try testing.expectEqual(@as(?[]const u8, null), ev.key_update.response);

    // RX material changed again (second ratchet).
    const rx_ktls_1 = server.rxKtlsInfo();
    try testing.expectEqualSlices(u8, &([_]u8{0} ** 8), &rx_ktls_1.rec_seq);
}

// RFC 8446 §5.1 — a KeyUpdate must align with a record boundary.
test "handleRecord: KeyUpdate not at record boundary is rejected" {
    var server = try connectedTestServer();
    var client_tx = try server.rx.clone();
    defer client_tx.deinit();
    const ku_t = @intFromEnum(HandshakeType.key_update);
    const ku_nr = @intFromEnum(KeyUpdateRequest.update_not_requested);
    const two = [_]u8{
        ku_t, 0x00, 0x00, 0x01, ku_nr,
        ku_t, 0x00, 0x00, 0x01, ku_nr,
    };
    var wire_buf: [64]u8 = undefined;
    const wire_rec = try client_tx.encrypt(.handshake, &two, &wire_buf);
    var rx_buf: [64]u8 = undefined;
    @memcpy(rx_buf[0..wire_rec.len], wire_rec);
    var out: [64]u8 = undefined;
    try testing.expectError(
        error.UnexpectedMessage,
        server.handleRecord(rx_buf[0..wire_rec.len], &out),
    );
}

// RFC 8446 §4.6.3 — KeyUpdateRequest only defines values 0 and 1.
test "handleRecord: invalid client KeyUpdate request is rejected" {
    var server = try connectedTestServer();
    var client_tx = try server.rx.clone();
    defer client_tx.deinit();

    const invalid_ku = [_]u8{ @intFromEnum(HandshakeType.key_update), 0x00, 0x00, 0x01, 0x02 };
    var wire_buf: [64]u8 = undefined;
    const wire_rec = try client_tx.encrypt(.handshake, &invalid_ku, &wire_buf);
    var rx_buf: [64]u8 = undefined;
    @memcpy(rx_buf[0..wire_rec.len], wire_rec);
    var out: [64]u8 = undefined;
    try testing.expectError(
        error.IllegalParameter,
        server.handleRecord(rx_buf[0..wire_rec.len], &out),
    );
}

// RFC 8446 §5.1 — an encrypted handshake record still must contain a handshake message.
test "handleRecord: zero-length encrypted handshake is rejected" {
    var server = try connectedTestServer();
    var client_tx = try server.rx.clone();
    defer client_tx.deinit();

    var wire_buf: [64]u8 = undefined;
    const wire_rec = try client_tx.encrypt(.handshake, "", &wire_buf);
    var rx_buf: [64]u8 = undefined;
    @memcpy(rx_buf[0..wire_rec.len], wire_rec);
    var out: [64]u8 = undefined;
    try testing.expectError(
        error.UnexpectedMessage,
        server.handleRecord(rx_buf[0..wire_rec.len], &out),
    );
}

// RFC 8446 §5.4 — all-zero TLSInnerPlaintext has no content type and maps to
// unexpected_message.
test "handleRecord: all-zero inner plaintext maps to unexpected_message" {
    var server = try connectedTestServer();
    var client_tx = try server.rx.clone();
    defer client_tx.deinit();

    var wire_buf: [64]u8 = undefined;
    const wire_rec = try encryptAllZeroInnerForTest(&client_tx, 3, &wire_buf);
    var rx_buf: [64]u8 = undefined;
    @memcpy(rx_buf[0..wire_rec.len], wire_rec);
    var out: [64]u8 = undefined;
    try testing.expectError(
        error.UnexpectedMessage,
        server.handleRecord(rx_buf[0..wire_rec.len], &out),
    );

    var peer = try server.tx.clone();
    defer peer.deinit();
    const alert_record = try server.sendAlert(.unexpected_message, &out);
    var alert_buf: [64]u8 = undefined;
    @memcpy(alert_buf[0..alert_record.len], alert_record);
    const dec = try peer.decrypt(alert_buf[0..alert_record.len]);
    try testing.expectEqual(.alert, dec.content_type);
    const a = try alert.parse(dec.content);
    try testing.expectEqual(.unexpected_message, a.description);
}

// RFC 8446 §5.2, Appendix A — connected endpoints accept application data,
// KeyUpdate, and alerts; other protected content types are unexpected records.
test "handleRecord: illegal post-handshake inner content type is rejected" {
    var server = try connectedTestServer();
    var client_tx = try server.rx.clone();
    defer client_tx.deinit();

    var wire_buf: [64]u8 = undefined;
    const wire_rec = try client_tx.encrypt(.change_cipher_spec, "", &wire_buf);
    var rx_buf: [64]u8 = undefined;
    @memcpy(rx_buf[0..wire_rec.len], wire_rec);
    var out: [64]u8 = undefined;
    try testing.expectError(
        error.UnexpectedRecord,
        server.handleRecord(rx_buf[0..wire_rec.len], &out),
    );
}

// RFC 8446 §5.1 — empty application-data records must not reset the
// KeyUpdate flood counter; otherwise an attacker can interleave empty
// records to bypass the cap.
test "handleRecord: empty application data does not reset post-handshake flood counter" {
    var server = try connectedTestServer();
    server.post_handshake_count = 7;

    var client_tx = try server.rx.clone();
    defer client_tx.deinit();
    var rec_buf: [64]u8 = undefined;
    const app_record = try client_tx.encrypt(.application_data, "", &rec_buf);

    var rx_buf: [64]u8 = undefined;
    @memcpy(rx_buf[0..app_record.len], app_record);
    var out: [64]u8 = undefined;
    const ev = try server.handleRecord(rx_buf[0..app_record.len], &out);
    try testing.expectEqualSlices(u8, "", ev.application_data);
    try testing.expectEqual(@as(u8, 7), server.post_handshake_count);
}

// RFC 8446 §4.6.3 — the KeyUpdate flood cap fires after more than
// max_post_handshake_messages consecutive post-handshake messages.
test "handleRecord: KeyUpdate flood is rejected" {
    var server = try connectedTestServer();
    var out: [64]u8 = undefined;

    const H = hkdf.HkdfSha256;
    var client_secret: H.TrafficSecret = switch (server.suite_state) {
        .sha256 => |s| s.client_app_secret,
        .sha384 => unreachable,
    };

    var i: usize = 0;
    const result = while (i < max_post_handshake_messages + 1) : (i += 1) {
        var client_tx = try H.makeRecordLayer(.aes_128_gcm_sha256, client_secret);
        defer client_tx.deinit();
        const ku = [_]u8{
            @intFromEnum(HandshakeType.key_update),              0x00, 0x00, 0x01,
            @intFromEnum(KeyUpdateRequest.update_not_requested),
        };
        var ku_buf: [64]u8 = undefined;
        const ku_wire = try client_tx.encrypt(.handshake, &ku, &ku_buf);
        var rx_buf: [64]u8 = undefined;
        @memcpy(rx_buf[0..ku_wire.len], ku_wire);
        client_secret = H.nextTrafficSecret(client_secret);
        _ = server.handleRecord(rx_buf[0..ku_wire.len], &out) catch |e| break e;
    } else error.NoError;
    try testing.expectEqual(error.TooManyKeyUpdates, result);
}

// RFC 8446 §4.6.3, §5.1 — the KeyUpdate flood cap must fire even when
// empty application-data records are interleaved between KeyUpdates.
test "handleRecord: KeyUpdate flood cap fires despite empty app-data interleaving" {
    var server = try connectedTestServer();
    var out: [64]u8 = undefined;

    var peer_tx = try server.rx.clone();

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

        _ = server.handleRecord(rx_buf[0..ku_wire.len], &out) catch |e| break e;

        peer_tx.deinit();
        peer_tx = try server.rx.clone();
        var app_buf: [32]u8 = undefined;
        const app_wire = try peer_tx.encrypt(.application_data, "", &app_buf);
        @memcpy(rx_buf[0..app_wire.len], app_wire);
        _ = server.handleRecord(rx_buf[0..app_wire.len], &out) catch |e| break e;

        const cloned = try peer_tx.clone();
        peer_tx.deinit();
        peer_tx = cloned;
    } else error.NoError;
    try testing.expectEqual(error.TooManyKeyUpdates, result);
}

// ---------------------------------------------------------------------------
// EstablishedSession extraction (#115)
// ---------------------------------------------------------------------------

// #115 — the established session must stay compact: pool users keep one
// ServerHandshake per worker and one EstablishedSession per live connection.
// Measured Zig 0.15.2 aarch64-linux: 736 bytes on the OpenSSL lane against
// ServerHandshake's 19,408. The record layers embed backend AEAD contexts,
// so the absolute number shifts by lane (inline EVP_AEAD_CTXs on AWS-LC and
// BoringSSL make it larger); the 2 KiB bound and the 10x ratio hold on
// OpenSSL, AWS-LC, and BoringSSL.
test "EstablishedSession: struct stays compact against the handshake engine" {
    try testing.expect(@sizeOf(EstablishedSession) < 2 * 1024);
    try testing.expect(@sizeOf(EstablishedSession) * 10 < @sizeOf(ServerHandshake));
}

fn expectSameEstablishedEvent(expected: Event, actual: Event) !void {
    try testing.expectEqual(std.meta.activeTag(expected), std.meta.activeTag(actual));
    switch (expected) {
        .application_data => |data| {
            try testing.expectEqualSlices(u8, data, actual.application_data);
        },
        .key_update => |update| {
            try testing.expectEqual(update.rx, actual.key_update.rx);
            try testing.expectEqual(update.tx, actual.key_update.tx);
            if (update.response) |response| {
                try testing.expectEqualSlices(u8, response, actual.key_update.response.?);
            } else try testing.expect(actual.key_update.response == null);
        },
        .none, .closed, .write => {},
    }
}

// RFC 8446 §4.6.3, §5.1, §6.1 — the extracted session runs the same connected
// code paths as the handshake engine. connectedTestServer is deterministic
// (fixed keypairs, zero random), so one scripted record sequence drives a
// kept-connected control engine and an extracted session in parallel; every
// event — including the KeyUpdate response record bytes, which pin the TX key
// and sequence continuity — must match exactly.
test "extractEstablished: connected events match the handshake engine" {
    var control = try connectedTestServer();
    defer control.deinit();
    var source = try connectedTestServer();
    var client_tx = try source.rx.clone();
    defer client_tx.deinit();
    var session = source.extractEstablished();
    defer session.deinit();
    source.deinit();

    var wire_buf: [128]u8 = undefined;
    var rx_buf: [128]u8 = undefined;
    var control_out: [128]u8 = undefined;
    var session_out: [128]u8 = undefined;

    // Inbound application data classifies identically.
    const app_wire = try client_tx.encrypt(.application_data, "ping", &wire_buf);
    @memcpy(rx_buf[0..app_wire.len], app_wire);
    const control_ev = try control.handleRecord(rx_buf[0..app_wire.len], &control_out);
    @memcpy(rx_buf[0..app_wire.len], app_wire);
    const session_ev = try session.handle(rx_buf[0..app_wire.len], &session_out);
    try expectSameEstablishedEvent(control_ev, session_ev);

    // An update_requested KeyUpdate ratchets RX and elicits the same response
    // record under the same old TX key and sequence (§4.6.3).
    const ku = [_]u8{
        @intFromEnum(HandshakeType.key_update),          0x00, 0x00, 0x01,
        @intFromEnum(KeyUpdateRequest.update_requested),
    };
    const ku_wire = try client_tx.encrypt(.handshake, &ku, &wire_buf);
    @memcpy(rx_buf[0..ku_wire.len], ku_wire);
    const control_ku = try control.handleRecord(rx_buf[0..ku_wire.len], &control_out);
    @memcpy(rx_buf[0..ku_wire.len], ku_wire);
    const session_ku = try session.handle(rx_buf[0..ku_wire.len], &session_out);
    try expectSameEstablishedEvent(control_ku, session_ku);
    control.completeWrite();
    session.completeWrite();

    // The ratcheted epochs stay aligned: the peer's next record decrypts on
    // both engines.
    var client_tx_next = try control.rx.clone();
    defer client_tx_next.deinit();
    const after_wire = try client_tx_next.encrypt(.application_data, "after", &wire_buf);
    @memcpy(rx_buf[0..after_wire.len], after_wire);
    const control_after = try control.handleRecord(rx_buf[0..after_wire.len], &control_out);
    @memcpy(rx_buf[0..after_wire.len], after_wire);
    const session_after = try session.handle(rx_buf[0..after_wire.len], &session_out);
    try expectSameEstablishedEvent(control_after, session_after);

    // close_notify closes both cleanly (§6.1).
    const close_notify = [_]u8{ 0x01, 0x00 };
    const close_wire = try client_tx_next.encrypt(.alert, &close_notify, &wire_buf);
    @memcpy(rx_buf[0..close_wire.len], close_wire);
    const control_close = try control.handleRecord(rx_buf[0..close_wire.len], &control_out);
    @memcpy(rx_buf[0..close_wire.len], close_wire);
    const session_close = try session.handle(rx_buf[0..close_wire.len], &session_out);
    try expectSameEstablishedEvent(control_close, session_close);
}

// RFC 8446 §4.6.3 — the extracted session owns the traffic record layers and
// their backend contexts; the pooled handshake engine can be deinit'd
// immediately without double-freeing them, and the session stays fully live.
test "extractEstablished: engine is consumed and immediate deinit is safe" {
    var server = try connectedTestServer();
    try testing.expect(server.isConnected());
    var session = server.extractEstablished();
    defer session.deinit();
    try testing.expect(!server.isConnected());
    server.deinit();

    var client_tx = try session.rx.clone();
    defer client_tx.deinit();
    var wire_buf: [64]u8 = undefined;
    var rx_buf: [64]u8 = undefined;
    const app_wire = try client_tx.encrypt(.application_data, "live", &wire_buf);
    @memcpy(rx_buf[0..app_wire.len], app_wire);
    const ev = try session.receive(rx_buf[0..app_wire.len]);
    try testing.expectEqualSlices(u8, "live", ev.application_data);

    var out: [64]u8 = undefined;
    _ = try session.sendApplicationData("ack", &out);
    try testing.expect(session.hasPendingWrite());
    session.completeWrite();
}

// #81/#115 — extraction wipes the record-layer bytes left behind in the
// consumed engine immediately, without freeing the moved contexts: on the
// inline-context backends (AWS-LC, BoringSSL) those bytes are the live
// traffic keys, and on OpenSSL they are the key/IV duplicates plus stale
// context pointers. The session's moved copies stay live. The all-zero
// assertion is deliberately exact so it also fails under Debug
// `= undefined` poison (0xaa) and under ReleaseFast, where `= undefined`
// is a no-op — see the ReleaseFast mutation record in PRODUCTION_READINESS.
test "extractEstablished: moved-from rx/tx are wiped, the session's copies stay live" {
    var server = try connectedTestServer();
    var client_tx = try server.rx.clone();
    defer client_tx.deinit();
    try testing.expect(!mem.allEqual(u8, mem.asBytes(&server.rx), 0));
    try testing.expect(!mem.allEqual(u8, mem.asBytes(&server.tx), 0));

    var session = server.extractEstablished();
    defer session.deinit();

    // Assert before deinit: deinit's `self.* = undefined` would overwrite
    // the very bytes under test.
    try testing.expect(mem.allEqual(u8, mem.asBytes(&server.rx), 0));
    try testing.expect(mem.allEqual(u8, mem.asBytes(&server.tx), 0));
    try testing.expect(!mem.allEqual(u8, mem.asBytes(&session.rx), 0));
    try testing.expect(!mem.allEqual(u8, mem.asBytes(&session.tx), 0));
    server.deinit();

    // The moved copies are the live ones: application data still flows
    // through the session after the source was wiped.
    var wire_buf: [64]u8 = undefined;
    var rx_buf: [64]u8 = undefined;
    const app_wire = try client_tx.encrypt(.application_data, "live", &wire_buf);
    @memcpy(rx_buf[0..app_wire.len], app_wire);
    const ev = try session.receive(rx_buf[0..app_wire.len]);
    try testing.expectEqualSlices(u8, "live", ev.application_data);
}

// RFC 8446 §4.6.3 — receive() defers the update_requested response: the
// obligation carries into the session and blocks application writes until the
// caller serializes its own response.
test "extractEstablished: deferred KeyUpdate obligation blocks application writes" {
    var server = try connectedTestServer();
    var client_tx = try server.rx.clone();
    defer client_tx.deinit();

    // The client's update_requested KeyUpdate is received by the handshake
    // engine before extraction, deferring the response (§4.6.3)…
    const ku = [_]u8{
        @intFromEnum(HandshakeType.key_update),          0x00, 0x00, 0x01,
        @intFromEnum(KeyUpdateRequest.update_requested),
    };
    var wire_buf: [64]u8 = undefined;
    const ku_wire = try client_tx.encrypt(.handshake, &ku, &wire_buf);
    var rx_buf: [64]u8 = undefined;
    @memcpy(rx_buf[0..ku_wire.len], ku_wire);
    const ev = try server.receiveRecord(rx_buf[0..ku_wire.len]);
    try testing.expectEqual(KeyUpdateRequest.update_requested, ev.key_update);
    try testing.expect(server.hasPendingKeyUpdateResponse());

    // …and the obligation must carry into the extracted session.
    var session = server.extractEstablished();
    defer session.deinit();
    server.deinit();
    try testing.expect(session.hasPendingKeyUpdateResponse());

    var out: [64]u8 = undefined;
    try testing.expectError(
        error.PendingKeyUpdateResponse,
        session.sendApplicationData("blocked", &out),
    );
    _ = try session.sendKeyUpdate(&out, .update_not_requested);
    session.completeWrite();
    try testing.expect(!session.hasPendingKeyUpdateResponse());
    _ = try session.sendApplicationData("resumed", &out);
    session.completeWrite();
}

// RFC 8446 §4.6.3 — the consecutive-KeyUpdate flood cap carries into the
// extracted session, and non-empty application data resets it.
test "extractEstablished: KeyUpdate flood cap survives extraction and resets on app data" {
    var server = try connectedTestServer();
    var session = server.extractEstablished();
    defer session.deinit();
    server.deinit();

    var peer_tx = try session.rx.clone();
    defer peer_tx.deinit();
    var wire_buf: [64]u8 = undefined;
    var rx_buf: [64]u8 = undefined;
    const ku = [_]u8{
        @intFromEnum(HandshakeType.key_update),              0x00, 0x00, 0x01,
        @intFromEnum(KeyUpdateRequest.update_not_requested),
    };

    var i: usize = 0;
    const result = while (i < max_post_handshake_messages + 1) : (i += 1) {
        const ku_wire = try peer_tx.encrypt(.handshake, &ku, &wire_buf);
        @memcpy(rx_buf[0..ku_wire.len], ku_wire);
        _ = session.receive(rx_buf[0..ku_wire.len]) catch |e| break e;
        const next = try session.rx.clone();
        peer_tx.deinit();
        peer_tx = next;
    } else error.NoError;
    try testing.expectEqual(error.TooManyKeyUpdates, result);

    // The rejected KeyUpdate did not ratchet RX, so the peer is still on the
    // live epoch. Non-empty application data resets the cap (§4.6.3)…
    const app_wire = try peer_tx.encrypt(.application_data, "reset", &wire_buf);
    @memcpy(rx_buf[0..app_wire.len], app_wire);
    const app_ev = try session.receive(rx_buf[0..app_wire.len]);
    try testing.expectEqualSlices(u8, "reset", app_ev.application_data);

    // …and the next KeyUpdate is accepted again.
    const ku_wire = try peer_tx.encrypt(.handshake, &ku, &wire_buf);
    @memcpy(rx_buf[0..ku_wire.len], ku_wire);
    const ku_ev = try session.receive(rx_buf[0..ku_wire.len]);
    try testing.expectEqual(KeyUpdateRequest.update_not_requested, ku_ev.key_update);
}

// RFC 8446 §5.1 — a KeyUpdate fragmented across records may straddle the
// extraction point: the reassembly fragment carries into the session and the
// completed message ratchets RX exactly as before extraction.
test "extractEstablished: KeyUpdate fragment carries across extraction" {
    var server = try connectedTestServer();
    var client_tx = try server.rx.clone();
    defer client_tx.deinit();
    var wire_buf: [64]u8 = undefined;
    var rx_buf: [64]u8 = undefined;

    const ku = [_]u8{
        @intFromEnum(HandshakeType.key_update),          0x00, 0x00, 0x01,
        @intFromEnum(KeyUpdateRequest.update_requested),
    };
    const part1 = try client_tx.encrypt(.handshake, ku[0..2], &wire_buf);
    @memcpy(rx_buf[0..part1.len], part1);
    try testing.expectEqual(ReceiveEvent.none, try server.receiveRecord(rx_buf[0..part1.len]));
    try testing.expectEqual(@as(usize, 2), server.ku_frag.len);

    var session = server.extractEstablished();
    defer session.deinit();
    server.deinit();

    const part2 = try client_tx.encrypt(.handshake, ku[2..5], &wire_buf);
    @memcpy(rx_buf[0..part2.len], part2);
    const ev = try session.receive(rx_buf[0..part2.len]);
    try testing.expectEqual(KeyUpdateRequest.update_requested, ev.key_update);
    try testing.expect(session.hasPendingKeyUpdateResponse());
}

// RFC 8446 §5.1 — the record-boundary and fragment rules hold after
// extraction: a KeyUpdate must be the last message in its record, and
// application data cannot interleave into a pending KeyUpdate fragment.
test "extractEstablished: KeyUpdate record-boundary and fragment rules hold" {
    var server = try connectedTestServer();
    var client_tx = try server.rx.clone();
    defer client_tx.deinit();
    var session = server.extractEstablished();
    defer session.deinit();
    server.deinit();

    var wire_buf: [64]u8 = undefined;
    var rx_buf: [64]u8 = undefined;
    const ku_type = @intFromEnum(HandshakeType.key_update);
    const ku_requested = @intFromEnum(KeyUpdateRequest.update_requested);

    // A trailing byte after a complete KeyUpdate in the same record.
    const trailing = [_]u8{ ku_type, 0x00, 0x00, 0x01, ku_requested, 0xff };
    const trailing_wire = try client_tx.encrypt(.handshake, &trailing, &wire_buf);
    @memcpy(rx_buf[0..trailing_wire.len], trailing_wire);
    try testing.expectError(error.UnexpectedMessage, session.receive(rx_buf[0..trailing_wire.len]));

    // A zero-length handshake record.
    const empty_wire = try client_tx.encrypt(.handshake, "", &wire_buf);
    @memcpy(rx_buf[0..empty_wire.len], empty_wire);
    try testing.expectError(error.UnexpectedMessage, session.receive(rx_buf[0..empty_wire.len]));

    // Application data interleaved into a pending fragment.
    const part_wire = try client_tx.encrypt(.handshake, &[_]u8{ku_type}, &wire_buf);
    @memcpy(rx_buf[0..part_wire.len], part_wire);
    try testing.expectEqual(ReceiveEvent.none, try session.receive(rx_buf[0..part_wire.len]));
    const app_wire = try client_tx.encrypt(.application_data, "mid", &wire_buf);
    @memcpy(rx_buf[0..app_wire.len], app_wire);
    try testing.expectError(error.UnexpectedMessage, session.receive(rx_buf[0..app_wire.len]));
}

// RFC 8446 §6.1, §6.2 — close_notify closes cleanly and never replaces the
// recorded peer alert; a fatal alert surfaces as PeerAlert with the alert
// retained for diagnostics.
test "extractEstablished: close_notify and fatal alerts keep server semantics" {
    var server = try connectedTestServer();
    var client_tx = try server.rx.clone();
    defer client_tx.deinit();
    var session = server.extractEstablished();
    defer session.deinit();
    server.deinit();

    try testing.expect(session.lastPeerAlert() == null);
    var wire_buf: [64]u8 = undefined;
    var rx_buf: [64]u8 = undefined;

    const fatal = [_]u8{ 0x02, 0x0a }; // fatal, unexpected_message
    const fatal_wire = try client_tx.encrypt(.alert, &fatal, &wire_buf);
    @memcpy(rx_buf[0..fatal_wire.len], fatal_wire);
    try testing.expectError(error.PeerAlert, session.receive(rx_buf[0..fatal_wire.len]));
    try testing.expectEqual(
        @as(?alert.Alert, .{ .level = .fatal, .description = .unexpected_message }),
        session.lastPeerAlert(),
    );

    const close_notify = [_]u8{ 0x01, 0x00 };
    const close_wire = try client_tx.encrypt(.alert, &close_notify, &wire_buf);
    @memcpy(rx_buf[0..close_wire.len], close_wire);
    try testing.expectEqual(ReceiveEvent.closed, try session.receive(rx_buf[0..close_wire.len]));
    try testing.expectEqual(
        @as(?alert.Alert, .{ .level = .fatal, .description = .unexpected_message }),
        session.lastPeerAlert(),
    );
}

// RFC 8446 §4.6.3, §6.1 — the session's own TX paths: alert emission rides the
// pending-write latch, and ratchetTx advances the epoch after an externally
// sent KeyUpdate.
test "extractEstablished: sendAlert latches and ratchetTx advances the TX epoch" {
    var server = try connectedTestServer();
    var client_rx = try server.tx.clone();
    defer client_rx.deinit();
    var session = server.extractEstablished();
    defer session.deinit();
    server.deinit();

    var out: [128]u8 = undefined;
    var rec_buf: [128]u8 = undefined;
    const alert_record = try session.sendAlert(.close_notify, &out);
    try testing.expect(session.hasPendingWrite());
    try testing.expectError(error.PendingWrite, session.sendAlert(.close_notify, &out));
    try testing.expectError(error.PendingWrite, session.ratchetTx(.update_not_requested));
    @memcpy(rec_buf[0..alert_record.len], alert_record);
    const dec = try client_rx.decrypt(rec_buf[0..alert_record.len]);
    try testing.expectEqual(.alert, dec.content_type);
    try testing.expectEqualSlices(u8, &.{ 0x01, 0x00 }, dec.content);
    session.completeWrite();

    // ratchetTx after an externally sent KeyUpdate: the next record is under
    // the new epoch — undecryptable by the old peer key, decryptable by a
    // fresh clone taken before the send (§4.6.3, §5.3).
    try session.ratchetTx(.update_requested);
    var client_rx_next = try session.tx.clone();
    defer client_rx_next.deinit();
    const app_record = try session.sendApplicationData("next epoch", &out);
    session.completeWrite();
    @memcpy(rec_buf[0..app_record.len], app_record);
    try testing.expectError(
        error.AuthenticationFailed,
        client_rx.decrypt(rec_buf[0..app_record.len]),
    );
    @memcpy(rec_buf[0..app_record.len], app_record);
    const dec_next = try client_rx_next.decrypt(rec_buf[0..app_record.len]);
    try testing.expectEqualSlices(u8, "next epoch", dec_next.content);
}

// RFC 8446 §4.6.3, §7.2 — the SHA-384 arm ratchets through the extracted
// session exactly like the SHA-256 default.
test "extractEstablished: SHA-384 suite ratchets and exchanges app data" {
    var server = try connectedTestServerSha384();
    try testing.expect(server.suite_state == .sha384);
    var client_tx = try server.rx.clone();
    defer client_tx.deinit();
    var session = server.extractEstablished();
    defer session.deinit();
    server.deinit();
    try testing.expect(session.suite == .sha384);

    const ku = [_]u8{
        @intFromEnum(HandshakeType.key_update),          0x00, 0x00, 0x01,
        @intFromEnum(KeyUpdateRequest.update_requested),
    };
    var wire_buf: [64]u8 = undefined;
    var rx_buf: [64]u8 = undefined;
    const ku_wire = try client_tx.encrypt(.handshake, &ku, &wire_buf);
    @memcpy(rx_buf[0..ku_wire.len], ku_wire);
    const ku_ev = try session.receive(rx_buf[0..ku_wire.len]);
    try testing.expectEqual(KeyUpdateRequest.update_requested, ku_ev.key_update);
    try testing.expect(session.hasPendingKeyUpdateResponse());

    // The ratcheted SHA-384 RX epoch accepts the peer's next record.
    var client_tx_next = try session.rx.clone();
    defer client_tx_next.deinit();
    const app_wire = try client_tx_next.encrypt(.application_data, "sha384", &wire_buf);
    @memcpy(rx_buf[0..app_wire.len], app_wire);
    const app_ev = try session.receive(rx_buf[0..app_wire.len]);
    try testing.expectEqualSlices(u8, "sha384", app_ev.application_data);

    var out: [64]u8 = undefined;
    _ = try session.sendKeyUpdate(&out, .update_not_requested);
    session.completeWrite();
    try testing.expect(!session.hasPendingKeyUpdateResponse());
}

// RFC 8446 §4.6.1 — ticket issuance happens before extraction: the handshake
// engine prepares and sends the ticket, the client accepts it, and the
// extracted session keeps serving application data on the same connection.
test "extractEstablished: NewSessionTicket is issued before extraction" {
    var pair = try connectedTestPair();
    var prepared = try pair.server.deriveTicketPsk();
    defer prepared.secureZero();
    var server_out: [512]u8 = undefined;
    const record = try pair.server.sendNewSessionTicket(
        &prepared,
        .{
            .ticket_lifetime = 3600,
            .ticket_age_add = 0x12345678,
            .ticket = "opaque-ticket",
        },
        &server_out,
    );
    pair.server.completeWrite();
    var client_out: [128]u8 = undefined;
    const event = try pair.client.handleRecord(server_out[0..record.len], &client_out);
    switch (event) {
        .new_session_ticket => {},
        else => return error.UnexpectedEvent,
    }

    var session = pair.server.extractEstablished();
    defer session.deinit();
    pair.server.deinit();
    defer pair.client.deinit();

    var wire_buf: [64]u8 = undefined;
    const app_wire = try pair.client.sendApplicationData("after ticket", &wire_buf);
    pair.client.completeWrite();
    var rx_buf: [64]u8 = undefined;
    @memcpy(rx_buf[0..app_wire.len], app_wire);
    const ev = try session.receive(rx_buf[0..app_wire.len]);
    try testing.expectEqualSlices(u8, "after ticket", ev.application_data);
}

// RFC 8446 §4.6.3 — simultaneous KeyUpdate messages are legal; each side
// ratchets independent send/receive traffic keys and remains connected.
test "key update: simultaneous update_requested remains connected" {
    var pair = try connectedTestPair();
    try testing.expect(pair.client.isConnected());
    try testing.expect(pair.server.isConnected());

    var client_update_buf: [64]u8 = undefined;
    const client_update = try pair.client.sendKeyUpdate(&client_update_buf, .update_requested);
    var client_update_wire: [64]u8 = undefined;
    @memcpy(client_update_wire[0..client_update.len], client_update);
    pair.client.completeWrite();

    var server_update_buf: [64]u8 = undefined;
    const server_update = try pair.server.sendKeyUpdate(&server_update_buf, .update_requested);
    var server_update_wire: [64]u8 = undefined;
    @memcpy(server_update_wire[0..server_update.len], server_update);
    pair.server.completeWrite();

    var server_out: [64]u8 = undefined;
    const server_event = try pair.server.handleRecord(
        client_update_wire[0..client_update.len],
        &server_out,
    );
    const server_response = switch (server_event) {
        .key_update => |ku| ku.response.?,
        else => return error.UnexpectedEvent,
    };
    var server_response_wire: [64]u8 = undefined;
    @memcpy(server_response_wire[0..server_response.len], server_response);
    pair.server.completeWrite();

    var client_out: [64]u8 = undefined;
    const client_event = try pair.client.handleRecord(
        server_update_wire[0..server_update.len],
        &client_out,
    );
    const client_response = switch (client_event) {
        .key_update => |ku| ku.response.?,
        else => return error.UnexpectedEvent,
    };
    var client_response_wire: [64]u8 = undefined;
    @memcpy(client_response_wire[0..client_response.len], client_response);
    pair.client.completeWrite();

    // The peer's response KeyUpdate(update_not_requested) surfaces as
    // key_update with rx=true, tx=false, response=null.
    const client_final = try pair.client.handleRecord(
        server_response_wire[0..server_response.len],
        &client_out,
    );
    try testing.expect(client_final == .key_update);
    try testing.expectEqual(true, client_final.key_update.rx);
    try testing.expectEqual(false, client_final.key_update.tx);
    try testing.expectEqual(@as(?[]const u8, null), client_final.key_update.response);

    const server_final = try pair.server.handleRecord(
        client_response_wire[0..client_response.len],
        &server_out,
    );
    try testing.expect(server_final == .key_update);
    try testing.expectEqual(true, server_final.key_update.rx);
    try testing.expectEqual(false, server_final.key_update.tx);
    try testing.expectEqual(@as(?[]const u8, null), server_final.key_update.response);

    var client_app_buf: [64]u8 = undefined;
    const client_app = try pair.client.sendApplicationData("client pong", &client_app_buf);
    var client_app_wire: [64]u8 = undefined;
    @memcpy(client_app_wire[0..client_app.len], client_app);
    pair.client.completeWrite();
    try testing.expectEqualStrings(
        "client pong",
        try pair.server.receiveApplicationData(client_app_wire[0..client_app.len]),
    );

    var server_app_buf: [64]u8 = undefined;
    const server_app = try pair.server.sendApplicationData("server pong", &server_app_buf);
    var server_app_wire: [64]u8 = undefined;
    @memcpy(server_app_wire[0..server_app.len], server_app);
    pair.server.completeWrite();
    const app_event = try pair.client.handleRecord(server_app_wire[0..server_app.len], &client_out);
    try testing.expectEqualStrings("server pong", app_event.application_data);
}

// RFC 8446 Appendix A — server state machine must reject arbitrary inbound
// records without panics.
fn fuzzHandleRecord(_: void, input: []const u8) anyerror!void {
    const key_seed: [32]u8 = @splat(0x42);
    const keypair = x25519.KeyPair.generateDeterministic(.init(key_seed)) catch unreachable;
    var server: ServerHandshake = .init(try testConfig(keypair));
    defer server.deinit();

    var record_buf: [frame.max_wire_record_len + 64]u8 = undefined;
    const n = @min(input.len, record_buf.len);
    @memcpy(record_buf[0..n], input[0..n]);
    var out: [4096]u8 = undefined;
    _ = server.handleRecord(record_buf[0..n], &out) catch return;
}

// RFC 8446 Appendix A — malformed server inputs are covered by fuzzing.
test "fuzz: ServerHandshake.handleRecord rejects arbitrary input" {
    try fuzz_compat.fuzzBytes(fuzzHandleRecord, {}, .{});
}

// RFC 8446 Appendix A — connected-state encrypted dispatch must reject
// arbitrary post-auth records without panics.
fn fuzzConnectedHandleRecord(_: void, input: []const u8) anyerror!void {
    var server = try connectedTestServer();
    defer server.deinit();

    var record_buf: [frame.max_wire_record_len + 64]u8 = undefined;
    const n = @min(input.len, record_buf.len);
    @memcpy(record_buf[0..n], input[0..n]);
    var out: [4096]u8 = undefined;
    _ = server.handleRecord(record_buf[0..n], &out) catch return;
}

test "fuzz: connected ServerHandshake.handleRecord rejects arbitrary input" {
    var server = try connectedTestServer();
    defer server.deinit();

    var app_tx = try server.rx.clone();
    defer app_tx.deinit();
    var app_buf: [64]u8 = undefined;
    const app = try app_tx.encrypt(.application_data, "fuzz", &app_buf);

    var ku_tx = try server.rx.clone();
    defer ku_tx.deinit();
    var ku_buf: [64]u8 = undefined;
    const ku_msg = [_]u8{
        @intFromEnum(HandshakeType.key_update),          0x00, 0x00, 0x01,
        @intFromEnum(KeyUpdateRequest.update_requested),
    };
    const ku = try ku_tx.encrypt(.handshake, &ku_msg, &ku_buf);

    const corpus: []const []const u8 = &.{
        app,
        ku,
        &.{},
        &.{ 23, 0x03, 0x03, 0x00, 0x04 },
    };
    try fuzz_compat.fuzzBytes(fuzzConnectedHandleRecord, {}, .{ .corpus = corpus });
}

test "application data: server sends and receives" {
    var server = try connectedTestServer();
    try testing.expect(server.isConnected());

    var server_wire: [128]u8 = undefined;
    var server_rx = try server.tx.clone();
    defer server_rx.deinit();
    const sent = try server.sendApplicationData("hello", &server_wire);
    const dec_sent = try server_rx.decrypt(server_wire[0..sent.len]);
    try testing.expectEqual(.application_data, dec_sent.content_type);
    try testing.expectEqualStrings("hello", dec_sent.content);

    var client_tx = try server.rx.clone();
    defer client_tx.deinit();
    var client_wire: [128]u8 = undefined;
    const incoming = try client_tx.encrypt(.application_data, "world", &client_wire);
    try testing.expectEqualStrings(
        "world",
        try server.receiveApplicationData(client_wire[0..incoming.len]),
    );
}

fn expectInMemoryAuthenticatedHandshake(suite: CipherSuite) !void {
    const client_keypair: x25519.KeyPair = .generate();
    const server_keypair: x25519.KeyPair = .generate();

    var client: ClientHandshake = .init(.{
        .keypairs = try .init(client_keypair),
        .host_name = "ztls.server.test",
        .now_sec = 0,
        .random = .zero,
    });
    client.offerAlpn(&.{"h2"});
    client.policy.insecure_no_chain_anchor = true;
    var client_out: [1024]u8 = undefined;
    const ch_record = try client.start(&client_out);
    client.completeWrite();

    var server: ServerHandshake = .init(try testConfig(server_keypair));
    server.supportAlpn(&.{"h2"});
    const suites = [_]CipherSuite{suite};
    server.supportSuites(&suites);
    var server_out: [4096]u8 = undefined;
    const sh_record = try server.acceptClientHello(ch_record, &server_out);
    try testing.expectEqual(suite, server.suite);
    try client.processServerHello(sh_record[frame.header_len..]);

    var signer = try signature.PrivateKey.fromP256Scalar(serverEcdsaScalar()[0..32]);
    defer signer.deinit();
    const signer_api = signer.signer();
    var plaintext: [4096]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(
        &.{serverEcdsaCertDer()},
        signer_api,
        &plaintext,
        &server_out,
    );
    const client_event = try client.handleRecord(server_out[0..flight_record.len], &client_out);
    const client_finished_record = switch (client_event) {
        .write => |w| w,
        else => return error.UnexpectedEvent,
    };
    client.completeWrite();
    try testing.expect(client.isConnected());

    try server.processClientFinished(client_out[0..client_finished_record.len]);
    try testing.expect(server.isConnected());
    try testing.expectEqualStrings("h2", client.selectedAlpnProtocol().?);
    try testing.expectEqualStrings("h2", server.selectedAlpnProtocol().?);

    const client_app = try client.sendApplicationData("ping", &client_out);
    client.completeWrite();
    try testing.expectEqualStrings(
        "ping",
        try server.receiveApplicationData(client_out[0..client_app.len]),
    );

    const server_app = try server.sendApplicationData("pong", &server_out);
    var server_app_mut: [128]u8 = undefined;
    @memcpy(server_app_mut[0..server_app.len], server_app);
    const ev = try client.handleRecord(server_app_mut[0..server_app.len], &client_out);
    try testing.expectEqualStrings("pong", ev.application_data);
}

// RFC 8446 §4.6.3, §7.2 — full KeyUpdate round trip over an in-memory
// connection. The server initiates KeyUpdate(update_requested); the client
// responds with KeyUpdate(update_not_requested); both sides ratchet both
// traffic keys; application data flows under the new keys.
fn expectInMemoryKeyUpdateRoundTrip(suite: CipherSuite) !void {
    const client_keypair: x25519.KeyPair = .generate();
    const server_keypair: x25519.KeyPair = .generate();

    var client: ClientHandshake = .init(.{
        .keypairs = try .init(client_keypair),
        .host_name = "ztls.server.test",
        .now_sec = 0,
        .random = .zero,
    });
    client.policy.insecure_no_chain_anchor = true;
    var client_out: [4096]u8 = undefined;
    const ch_record = try client.start(&client_out);
    client.completeWrite();

    var server: ServerHandshake = .init(try testConfig(server_keypair));
    const suites = [_]CipherSuite{suite};
    server.supportSuites(&suites);
    var server_out: [4096]u8 = undefined;
    const sh_record = try server.acceptClientHello(ch_record, &server_out);
    try client.processServerHello(sh_record[frame.header_len..]);

    var signer = try signature.PrivateKey.fromP256Scalar(serverEcdsaScalar()[0..32]);
    defer signer.deinit();
    var plaintext: [4096]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(
        &.{serverEcdsaCertDer()},
        signer.signer(),
        &plaintext,
        &server_out,
    );
    const client_event = try client.handleRecord(server_out[0..flight_record.len], &client_out);
    const client_finished_record = switch (client_event) {
        .write => |w| w,
        else => return error.UnexpectedEvent,
    };
    client.completeWrite();
    try server.processClientFinished(client_out[0..client_finished_record.len]);
    try testing.expect(client.isConnected());
    try testing.expect(server.isConnected());

    // Server initiates KeyUpdate(update_requested) — encrypted under the
    // current server TX key, then server TX ratchets.
    const ku_record = try server.sendKeyUpdate(&server_out, .update_requested);
    server.completeWrite();

    // Client receives the KeyUpdate, ratchets RX, responds with its own
    // KeyUpdate(update_not_requested) under the old client TX key, then
    // client TX ratchets.
    var ku_mut: [128]u8 = undefined;
    @memcpy(ku_mut[0..ku_record.len], ku_record);
    const ku_ev = try client.handleRecord(ku_mut[0..ku_record.len], &client_out);
    try testing.expect(ku_ev == .key_update);
    try testing.expectEqual(true, ku_ev.key_update.rx);
    try testing.expectEqual(true, ku_ev.key_update.tx);
    const ku_resp = ku_ev.key_update.response.?;
    client.completeWrite();

    // Server receives the client's KeyUpdate response — ratchets RX.
    var ku_resp_mut: [128]u8 = undefined;
    @memcpy(ku_resp_mut[0..ku_resp.len], ku_resp);
    const ku_resp_ev = try server.handleRecord(ku_resp_mut[0..ku_resp.len], &server_out);
    try testing.expect(ku_resp_ev == .key_update);
    try testing.expectEqual(true, ku_resp_ev.key_update.rx);
    try testing.expectEqual(false, ku_resp_ev.key_update.tx);

    // Application data under the new keys: client → server.
    const app1 = try client.sendApplicationData("after-ku", &client_out);
    client.completeWrite();
    try testing.expectEqualStrings(
        "after-ku",
        try server.receiveApplicationData(client_out[0..app1.len]),
    );

    // Application data under the new keys: server → client.
    const app2 = try server.sendApplicationData("pong-ku", &server_out);
    var app2_mut: [128]u8 = undefined;
    @memcpy(app2_mut[0..app2.len], app2);
    const app2_ev = try client.handleRecord(app2_mut[0..app2.len], &client_out);
    try testing.expectEqualStrings("pong-ku", app2_ev.application_data);
}
test "in-memory authenticated client-server handshake reaches app data" {
    try expectInMemoryAuthenticatedHandshake(.aes_128_gcm_sha256);
}

// RFC 8446 §9.1 — all mandatory TLS 1.3 cipher suites complete the full handshake.
test "in-memory authenticated client-server handshake suite matrix" {
    try expectInMemoryAuthenticatedHandshake(.aes_128_gcm_sha256);
    try expectInMemoryAuthenticatedHandshake(.aes_256_gcm_sha384);
    try expectInMemoryAuthenticatedHandshake(.chacha20_poly1305_sha256);
}

// RFC 8446 §4.6.3, §7.2 — server-initiated KeyUpdate(update_requested) over a
// real in-memory connection: the client must respond with its own
// KeyUpdate(update_not_requested), both sides ratchet TX and RX keys, and
// application data flows under the new keys. Tested across all three
// mandatory cipher suites — the ChaCha20-Poly1305 case is specifically
// included because TLS-Anvil's respondsWithValidKeyUpdate found a
// BoringSSL-specific failure under ChaCha20 that the AES-only unit tests
// missed (#71).
test "in-memory KeyUpdate round trip across all cipher suites" {
    try expectInMemoryKeyUpdateRoundTrip(.aes_128_gcm_sha256);
    try expectInMemoryKeyUpdateRoundTrip(.aes_256_gcm_sha384);
    try expectInMemoryKeyUpdateRoundTrip(.chacha20_poly1305_sha256);
}

// RFC 8446 §4.2.11 — selectPsk parses a PSK ClientHello, looks up the PSK,
// and verifies the binder over the truncated prefix.
test "selectPsk: verifies the binder for a matching PSK identity" {
    const resumption_master: hkdf.HkdfSha256.Prk = .init(.{
        0x7d, 0xf2, 0x35, 0xf2, 0x03, 0x1d, 0x2a, 0x05,
        0x12, 0x87, 0xd0, 0x2b, 0x02, 0x41, 0xb0, 0xbf,
        0xda, 0xf8, 0x6c, 0xc8, 0x56, 0x23, 0x1f, 0x2d,
        0x5a, 0xba, 0x46, 0xc4, 0x34, 0xec, 0x19, 0x6c,
    });
    const psk = hkdf.HkdfSha256.resumptionPsk(resumption_master, &.{ 0x00, 0x00 });
    const identity = [_]u8{ 0x2c, 0x03, 0x5d, 0x82, 0x93, 0x59 };

    var client: ClientHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    var ticket: ClientHandshake.SessionTicket = .{
        .ticket_age_add = 0x262a6494,
        .cipher_suite = .aes_128_gcm_sha256,
    };
    ticket.identity.appendSliceAssumeCapacity(&identity);
    ticket.psk.appendSliceAssumeCapacity(&psk.data);

    var out: [1024]u8 = undefined;
    const record = try client.startWithPsk(&ticket, &out, false);
    const ch_msg = record[frame.header_len..];
    const parsed = try client_hello.parse(ch_msg);

    const Lookup = struct {
        const Self = @This();
        psk: []const u8,
        identity: []const u8,
        fn l(ctx: *anyopaque, id: []const u8) ?PskEntry {
            const self: *Self = @ptrCast(@alignCast(ctx));
            if (std.mem.eql(u8, id, self.identity))
                return .{ .psk = self.psk, .cipher_suite = .aes_128_gcm_sha256 };
            return null;
        }
    };
    var lookup_ctx: Lookup = .{ .psk = &psk.data, .identity = &identity };
    const lookup: PskLookup = .{ .context = &lookup_ctx, .lookup = Lookup.l };

    const sel = try selectPsk(parsed, ch_msg, lookup, .aes_128_gcm_sha256);
    try testing.expect(sel != null);
    try testing.expectEqual(@as(usize, 0), sel.?.identity_index);
}

test "selectPsk: returns null when the PSK binder does not verify" {
    const identity = [_]u8{ 0x2c, 0x03, 0x5d, 0x82, 0x93, 0x59 };
    const wrong_psk = [_]u8{0x42} ** 32;

    var client: ClientHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    var ticket: ClientHandshake.SessionTicket = .{
        .ticket_age_add = 0,
        .cipher_suite = .aes_128_gcm_sha256,
    };
    ticket.identity.appendSliceAssumeCapacity(&identity);
    ticket.psk.appendSliceAssumeCapacity(&wrong_psk);
    var out: [1024]u8 = undefined;
    const record = try client.startWithPsk(&ticket, &out, false);
    const ch_msg = record[frame.header_len..];
    const parsed = try client_hello.parse(ch_msg);

    const right_psk = blk: {
        const rm: hkdf.HkdfSha256.Prk = .init(.{
            0x7d, 0xf2, 0x35, 0xf2, 0x03, 0x1d, 0x2a, 0x05,
            0x12, 0x87, 0xd0, 0x2b, 0x02, 0x41, 0xb0, 0xbf,
            0xda, 0xf8, 0x6c, 0xc8, 0x56, 0x23, 0x1f, 0x2d,
            0x5a, 0xba, 0x46, 0xc4, 0x34, 0xec, 0x19, 0x6c,
        });
        break :blk hkdf.HkdfSha256.resumptionPsk(rm, &.{ 0x00, 0x00 });
    };
    const Lookup = struct {
        const Self = @This();
        psk: []const u8,
        identity: []const u8,
        fn l(ctx: *anyopaque, id: []const u8) ?PskEntry {
            const self: *Self = @ptrCast(@alignCast(ctx));
            if (std.mem.eql(u8, id, self.identity))
                return .{ .psk = self.psk, .cipher_suite = .aes_128_gcm_sha256 };
            return null;
        }
    };
    var lookup_ctx: Lookup = .{ .psk = &right_psk.data, .identity = &identity };
    const lookup: PskLookup = .{ .context = &lookup_ctx, .lookup = Lookup.l };

    const sel = try selectPsk(parsed, ch_msg, lookup, .aes_128_gcm_sha256);
    try testing.expectEqual(@as(?@TypeOf(sel.?), null), sel);
}

// RFC 8446 §4.2.11 — the binders list-length field is attacker-controlled.
// A binders_len near u16 max must not overflow the bounds-check arithmetic
// in selectPsk. Regression for the #72 class bug found by the H5 hunt: line
// 369 evaluated `2 + identities_len + 2 + binders_len` in u16 before widening.
test "selectPsk: oversized binders_len does not overflow" {
    const resumption_master: hkdf.HkdfSha256.Prk = .init(.{
        0x7d, 0xf2, 0x35, 0xf2, 0x03, 0x1d, 0x2a, 0x05,
        0x12, 0x87, 0xd0, 0x2b, 0x02, 0x41, 0xb0, 0xbf,
        0xda, 0xf8, 0x6c, 0xc8, 0x56, 0x23, 0x1f, 0x2d,
        0x5a, 0xba, 0x46, 0xc4, 0x34, 0xec, 0x19, 0x6c,
    });
    const psk = hkdf.HkdfSha256.resumptionPsk(resumption_master, &.{ 0x00, 0x00 });
    const identity = [_]u8{ 0x2c, 0x03, 0x5d, 0x82, 0x93, 0x59 };

    var client: ClientHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    var ticket: ClientHandshake.SessionTicket = .{
        .ticket_age_add = 0x262a6494,
        .cipher_suite = .aes_128_gcm_sha256,
    };
    ticket.identity.appendSliceAssumeCapacity(&identity);
    ticket.psk.appendSliceAssumeCapacity(&psk.data);

    var out: [1024]u8 = undefined;
    const record = try client.startWithPsk(&ticket, &out, false);
    // Work on a mutable copy of the ClientHello body (skip the record header).
    var ch_msg: [1024]u8 = undefined;
    @memcpy(ch_msg[0 .. record.len - frame.header_len], record[frame.header_len..]);
    const ch_body = ch_msg[0 .. record.len - frame.header_len];
    const parsed = try client_hello.parse(ch_body);

    // Overwrite the binders_len field (2 bytes at binders_offset) with 0xFFFF.
    ch_body[parsed.binders_offset] = 0xff;
    ch_body[parsed.binders_offset + 1] = 0xff;

    const Lookup = struct {
        const Self = @This();
        psk: []const u8,
        identity: []const u8,
        fn l(ctx: *anyopaque, id: []const u8) ?PskEntry {
            const self: *Self = @ptrCast(@alignCast(ctx));
            if (std.mem.eql(u8, id, self.identity))
                return .{ .psk = self.psk, .cipher_suite = .aes_128_gcm_sha256 };
            return null;
        }
    };
    var lookup_ctx: Lookup = .{ .psk = &psk.data, .identity = &identity };
    const lookup: PskLookup = .{ .context = &lookup_ctx, .lookup = Lookup.l };

    // Must return an error, not panic.
    _ = selectPsk(parsed, ch_body, lookup, .aes_128_gcm_sha256) catch return;
    return error.TestExpectedError;
}

// RFC 8446 §4.2.9 — a ClientHello with pre_shared_key but without
// psk_key_exchange_modes is invalid, and the server MUST abort.
test "PSK offer without psk_key_exchange_modes aborts" {
    const psk: [32]u8 = @splat(0x42);
    const identity = [_]u8{ 0x2c, 0x03, 0x5d, 0x82, 0x93, 0x59 };
    var client: ClientHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    var ticket: ClientHandshake.SessionTicket = .{
        .ticket_age_add = 0,
        .cipher_suite = .aes_128_gcm_sha256,
    };
    ticket.identity.appendSliceAssumeCapacity(&identity);
    ticket.psk.appendSliceAssumeCapacity(&psk);

    var client_out: [1024]u8 = undefined;
    const record = try client.startWithPsk(&ticket, &client_out, false);
    const mode_extension = mem.indexOf(
        u8,
        record,
        &.{ 0x00, 0x2d, 0x00, 0x02, 0x01, 0x01 },
    ) orelse return error.TestUnexpectedResult;
    client_out[mode_extension + 1] = 0x15; // padding extension

    var server: ServerHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .random = .zero,
    });
    var server_out: [1024]u8 = undefined;
    try testing.expectError(
        error.MissingExtension,
        server.acceptClientHello(record, &server_out),
    );
}

// RFC 8446 §4.2.9, §4.6.1 — ztls implements psk_dhe_ke only. A valid PSK
// offer with only psk_ke falls back to a full handshake and cannot receive a
// ticket for a mode it did not advertise.
test "PSK offer with only psk_ke disables resumption and ticket issuance" {
    const psk: [32]u8 = @splat(0x42);
    const identity = [_]u8{ 0x2c, 0x03, 0x5d, 0x82, 0x93, 0x59 };
    var client: ClientHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    var ticket: ClientHandshake.SessionTicket = .{
        .ticket_age_add = 0,
        .cipher_suite = .aes_128_gcm_sha256,
    };
    ticket.identity.appendSliceAssumeCapacity(&identity);
    ticket.psk.appendSliceAssumeCapacity(&psk);

    var client_out: [1024]u8 = undefined;
    const record = try client.startWithPsk(&ticket, &client_out, false);
    const mode_extension = mem.indexOf(
        u8,
        record,
        &.{ 0x00, 0x2d, 0x00, 0x02, 0x01, 0x01 },
    ) orelse return error.TestUnexpectedResult;
    client_out[mode_extension + 5] = @intFromEnum(client_hello.PskKeyExchangeMode.psk_ke);
    const ch_msg = record[frame.header_len..];
    const parsed = try client_hello.parse(ch_msg);
    const early = hkdf.HkdfSha256.pskEarlySecret(&psk);
    const binder_key = hkdf.HkdfSha256.resumptionBinderKey(early);
    const fin_key = hkdf.HkdfSha256.finishedKey(.{ .data = binder_key.data });
    var th: hkdf.HkdfSha256.TranscriptHash = undefined;
    Sha256.hash(ch_msg[0..parsed.binders_offset], &th.data, .{});
    const binder = hkdf.HkdfSha256.binder(fin_key, &th);
    @memcpy(client_out[frame.header_len + parsed.binders_offset + 3 ..][0..binder.len], &binder);

    const Lookup = struct {
        const Context = struct {
            psk: []const u8,
            identity: []const u8,
        };
        fn lookup(context: *anyopaque, offered_identity: []const u8) ?PskEntry {
            const ctx: *Context = @ptrCast(@alignCast(context));
            if (!mem.eql(u8, offered_identity, ctx.identity)) return null;
            return .{ .psk = ctx.psk, .cipher_suite = .aes_128_gcm_sha256 };
        }
    };
    var lookup_context: Lookup.Context = .{ .psk = &psk, .identity = &identity };
    var server: ServerHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .random = .zero,
        .psk_lookup = .{ .context = &lookup_context, .lookup = Lookup.lookup },
    });
    var server_out: [1024]u8 = undefined;
    _ = try server.acceptClientHello(record, &server_out);
    try testing.expect(server.selected_psk == null);

    // Isolate the post-handshake issuance guard from the rest of the full
    // handshake: removing the compatibility check must make this assertion red.
    server.state = .connected;
    switch (server.suite_state) {
        inline .sha256, .sha384 => |*s| {
            s.resumption_master = .init(@splat(0x42));
            s.resumption_master_valid = true;
        },
    }
    try testing.expectError(error.IncompatiblePskModes, server.deriveTicketPsk());
}

// RFC 8446 §4.4.2 — selecting a PSK does not implicitly preserve a client
// certificate identity. A server requiring fresh client authentication declines
// the PSK and completes the full certificate-authenticated handshake.
test "client authentication policy declines PSK resumption" {
    const psk: [32]u8 = @splat(0x42);
    const identity = "client-auth-ticket";
    var client: ClientHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .host_name = "ztls.server.test",
        .now_sec = 0,
        .random = .zero,
    });
    defer client.deinit();
    client.policy.insecure_no_chain_anchor = true;
    var client_signer = try signature.PrivateKey.fromP256Scalar(clientEcdsaScalar()[0..32]);
    defer client_signer.deinit();
    client.setCredentials(&.{clientEcdsaCertDer()}, client_signer.signer());
    var ticket: ClientHandshake.SessionTicket = .{
        .ticket_age_add = 0,
        .cipher_suite = .aes_128_gcm_sha256,
    };
    ticket.identity.appendSliceAssumeCapacity(identity);
    ticket.psk.appendSliceAssumeCapacity(&psk);

    var client_out: [4096]u8 = undefined;
    const record = try client.startWithPsk(&ticket, &client_out, false);
    client.completeWrite();

    const Lookup = struct {
        const Context = struct {
            identity: []const u8,
            psk: []const u8,
        };
        fn lookup(context: *anyopaque, offered_identity: []const u8) ?PskEntry {
            const ctx: *Context = @ptrCast(@alignCast(context));
            if (!mem.eql(u8, offered_identity, ctx.identity)) return null;
            return .{ .psk = ctx.psk, .cipher_suite = .aes_128_gcm_sha256 };
        }
    };
    var lookup_context: Lookup.Context = .{ .identity = identity, .psk = &psk };
    var client_cert_storage: [1024]u8 = undefined;
    var server: ServerHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .random = .zero,
        .psk_lookup = .{ .context = &lookup_context, .lookup = Lookup.lookup },
        .client_auth = .required,
        .insecure_no_client_chain_anchor = true,
        .client_cert_buffer = &client_cert_storage,
    });
    defer server.deinit();
    var server_out: [4096]u8 = undefined;
    const server_hello_record = try server.acceptClientHello(record, &server_out);
    try testing.expect(server.selected_psk == null);
    try client.processServerHello(server_hello_record[frame.header_len..]);

    var server_signer = try signature.PrivateKey.fromP256Scalar(serverEcdsaScalar()[0..32]);
    defer server_signer.deinit();
    var plaintext: [4096]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(
        &.{serverEcdsaCertDer()},
        server_signer.signer(),
        &plaintext,
        &server_out,
    );
    const client_event = try client.handleRecord(server_out[0..flight_record.len], &client_out);
    const client_finished_record = switch (client_event) {
        .write => |write| write,
        else => return error.UnexpectedEvent,
    };
    client.completeWrite();
    try server.processClientFinished(client_out[0..client_finished_record.len]);
    try testing.expect(server.isConnected());
    try testing.expect(!server.isResumed());
    try testing.expect(server.clientCertificate() != null);
}

fn expectIncompatiblePskNotSelected(
    ticket_suite: CipherSuite,
    negotiated_suite: CipherSuite,
) !void {
    const psk: [48]u8 = @splat(0x42);
    const psk_len: usize = switch (ticket_suite) {
        .aes_128_gcm_sha256, .chacha20_poly1305_sha256 => 32,
        .aes_256_gcm_sha384 => 48,
    };
    const identity = [_]u8{ 0x2c, 0x03, 0x5d, 0x82, 0x93, 0x59 };
    var client: ClientHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    var ticket: ClientHandshake.SessionTicket = .{
        .ticket_age_add = 0,
        .cipher_suite = ticket_suite,
    };
    ticket.identity.appendSliceAssumeCapacity(&identity);
    ticket.psk.appendSliceAssumeCapacity(psk[0..psk_len]);
    var client_out: [1024]u8 = undefined;
    const record = try client.startWithPsk(&ticket, &client_out, false);

    const Lookup = struct {
        const Context = struct {
            psk: []const u8,
            identity: []const u8,
            suite: CipherSuite,
        };
        fn lookup(context: *anyopaque, offered_identity: []const u8) ?PskEntry {
            const ctx: *Context = @ptrCast(@alignCast(context));
            if (!mem.eql(u8, offered_identity, ctx.identity)) return null;
            return .{ .psk = ctx.psk, .cipher_suite = ctx.suite };
        }
    };
    var lookup_context: Lookup.Context = .{
        .psk = psk[0..psk_len],
        .identity = &identity,
        .suite = ticket_suite,
    };
    var server: ServerHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .random = .zero,
        .psk_lookup = .{ .context = &lookup_context, .lookup = Lookup.lookup },
    });
    server.supportSuites(&.{negotiated_suite});
    var server_out: [1024]u8 = undefined;
    _ = try server.acceptClientHello(record, &server_out);
    try testing.expect(server.selected_psk == null);
}

// RFC 8446 §4.2.11.2 — the selected PSK and negotiated cipher suite MUST use
// the same hash. Incompatible SHA-256/SHA-384 combinations are not selected.
test "PSK selection skips cipher suites with an incompatible hash" {
    try expectIncompatiblePskNotSelected(.aes_256_gcm_sha384, .aes_128_gcm_sha256);
    try expectIncompatiblePskNotSelected(.aes_128_gcm_sha256, .aes_256_gcm_sha384);
}

// RFC 8446 §4.2.11, §7.1 — in-memory PSK resumption (psk_dhe_ke): the client
// offers a PSK, the server verifies the binder and selects it, and the
// handshake completes to connected with matching keys and application data.
test "in-memory PSK resumption reaches app data" {
    try expectInMemoryPskResumption(null, .direct, .aes_128_gcm_sha256);
}

// RFC 8446 §4.2.11, §7.1 and RFC 10024 §4 — PSK authentication composes with
// every standardized hybrid shared secret under psk_dhe_ke.
test "in-memory RFC 10024 PSK resumption matrix reaches app data" {
    const groups = [_]NamedGroup{
        .x25519_mlkem768,
        .secp256r1_mlkem768,
        .secp384r1_mlkem1024,
    };
    var tested = false;
    for (groups) |group| {
        if (!backend.supportsServerHybridGroup(group)) continue;
        tested = true;
        try expectInMemoryPskResumption(group, .direct, .aes_128_gcm_sha256);
    }
    if (!tested) return error.SkipZigTest;
}

// RFC 8446 §4.1.2, §4.2.11.2 and RFC 10024 §4 — ClientHello2 preserves the
// PSK offer and recomputes its binder over the retry transcript while each
// standardized hybrid group supplies the fresh psk_dhe_ke shared secret.
test "in-memory RFC 10024 PSK resumption survives HRR" {
    const groups = [_]NamedGroup{
        .x25519_mlkem768,
        .secp256r1_mlkem768,
        .secp384r1_mlkem1024,
    };
    var tested = false;
    for (groups) |group| {
        if (!backend.supportsServerHybridGroup(group)) continue;
        tested = true;
        try expectInMemoryPskResumption(
            group,
            .hello_retry_request,
            .aes_128_gcm_sha256,
        );
    }
    if (!tested) return error.SkipZigTest;
}

// RFC 8446 §4.1.2 and §4.2.11.2 — the retry binder uses the selected cipher
// suite's transcript hash. Exercise the compatible 48-byte SHA-384 path.
test "in-memory RFC 10024 SHA-384 PSK resumption survives HRR" {
    const groups = [_]NamedGroup{
        .x25519_mlkem768,
        .secp256r1_mlkem768,
        .secp384r1_mlkem1024,
    };
    var tested = false;
    for (groups) |group| {
        if (!backend.supportsServerHybridGroup(group)) continue;
        tested = true;
        try expectInMemoryPskResumption(
            group,
            .hello_retry_request,
            .aes_256_gcm_sha384,
        );
    }
    if (!tested) return error.SkipZigTest;
}

const PskHandshakePath = enum {
    direct,
    hello_retry_request,
};

fn firstObfuscatedTicketAge(parsed: client_hello.Parsed) !u32 {
    var reader: wiremod.Reader = .init(parsed.psk_ext.?);
    _ = try reader.read(u16);
    const identity_len = try reader.read(u16);
    _ = try reader.readSlice(@as(usize, identity_len));
    return reader.read(u32);
}

fn expectInMemoryPskResumption(
    hybrid_group: ?NamedGroup,
    path: PskHandshakePath,
    cipher_suite: CipherSuite,
) !void {
    var psk_storage: [48]u8 = undefined;
    const psk: []const u8 = switch (cipher_suite) {
        .aes_128_gcm_sha256, .chacha20_poly1305_sha256 => blk: {
            const master: hkdf.HkdfSha256.Prk = .init(@splat(0x7d));
            const derived = hkdf.HkdfSha256.resumptionPsk(master, &.{ 0x00, 0x00 });
            @memcpy(psk_storage[0..hkdf.HkdfSha256.prk_len], &derived.data);
            break :blk psk_storage[0..hkdf.HkdfSha256.prk_len];
        },
        .aes_256_gcm_sha384 => blk: {
            const master: hkdf.HkdfSha384.Prk = .init(@splat(0x7d));
            const derived = hkdf.HkdfSha384.resumptionPsk(master, &.{ 0x00, 0x00 });
            @memcpy(psk_storage[0..hkdf.HkdfSha384.prk_len], &derived.data);
            break :blk psk_storage[0..hkdf.HkdfSha384.prk_len];
        },
    };
    const identity = [_]u8{ 0x2c, 0x03, 0x5d, 0x82, 0x93, 0x59 };

    var group_storage: [1]NamedGroup = undefined;
    const hybrid_groups: []const NamedGroup = if (hybrid_group) |group| blk: {
        group_storage[0] = group;
        break :blk &group_storage;
    } else &.{};

    var client_keypairs: KeyPairs = try .init(.generate());
    if (hybrid_group == .secp384r1_mlkem1024) client_keypairs.p384 = try .generate();
    var client: ClientHandshake = .init(.{
        .keypairs = client_keypairs,
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
        .hybrid = .{
            .supported_groups = hybrid_groups,
            .initial_key_share = switch (path) {
                .direct => hybrid_group,
                .hello_retry_request => null,
            },
        },
    });
    defer client.deinit();
    client.policy.insecure_no_chain_anchor = true;

    var ticket: ClientHandshake.SessionTicket = .{
        .ticket_age_add = 0x262a6494,
        .cipher_suite = cipher_suite,
    };
    ticket.identity.appendSliceAssumeCapacity(&identity);
    ticket.psk.appendSliceAssumeCapacity(psk);
    var client_out: [4096]u8 = undefined;
    const ch_record = try client.startWithPsk(&ticket, &client_out, false);
    client.completeWrite();
    const parsed_ch1 = try client_hello.parse(ch_record[frame.header_len..]);
    const offered_ticket_age = try firstObfuscatedTicketAge(parsed_ch1);
    try testing.expectEqual(ticket.ticket_age_add, offered_ticket_age);

    const Lookup = struct {
        const Self = @This();
        psk: []const u8,
        identity: []const u8,
        cipher_suite: CipherSuite,
        fn l(ctx: *anyopaque, id: []const u8) ?PskEntry {
            const self: *Self = @ptrCast(@alignCast(ctx));
            if (std.mem.eql(u8, id, self.identity))
                return .{ .psk = self.psk, .cipher_suite = self.cipher_suite };
            return null;
        }
    };
    var lookup_ctx: Lookup = .{
        .psk = psk,
        .identity = &identity,
        .cipher_suite = cipher_suite,
    };

    var server_keypairs: KeyPairs = try .init(.generate());
    if (hybrid_group == .secp384r1_mlkem1024) server_keypairs.p384 = try .generate();
    var server: ServerHandshake = .init(.{
        .keypairs = server_keypairs,
        .random = .zero,
        .psk_lookup = .{ .context = &lookup_ctx, .lookup = Lookup.l },
        .hybrid_groups = hybrid_groups,
    });
    defer server.deinit();
    server.supportSuites(&.{cipher_suite});
    try testing.expect(server.selected_psk == null);

    var server_out: [4096]u8 = undefined;
    const first_server_record = try server.acceptClientHello(ch_record, &server_out);
    const sh_record = switch (path) {
        .direct => first_server_record,
        .hello_retry_request => blk: {
            try testing.expect(server.selected_psk == null);
            var hrr_record: [4096]u8 = undefined;
            @memcpy(hrr_record[0..first_server_record.len], first_server_record);
            const event = try client.handleRecord(
                hrr_record[0..first_server_record.len],
                &client_out,
            );
            const ch2_record = switch (event) {
                .write => |record| record,
                else => return error.UnexpectedEvent,
            };
            client.completeWrite();
            const parsed_ch2 = try client_hello.parse(ch2_record[frame.header_len..]);
            try testing.expect(parsed_ch2.psk_ext != null);
            try testing.expectEqual(offered_ticket_age, try firstObfuscatedTicketAge(parsed_ch2));
            try testing.expect(!parsed_ch2.offered_early_data);
            break :blk try server.acceptClientHello(ch2_record, &server_out);
        },
    };
    try testing.expect(server.selected_psk != null);
    try testing.expectEqual(@as(u16, 0), server.selected_psk_index);
    if (hybrid_group) |group| try testing.expectEqual(group, server.negotiated_group);

    try client.processServerHello(sh_record[frame.header_len..]);
    try testing.expect(client.server_selected_psk);

    var signer = try signature.PrivateKey.fromP256Scalar(serverEcdsaScalar()[0..32]);
    defer signer.deinit();
    var plaintext: [4096]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(
        &.{serverEcdsaCertDer()},
        signer.signer(),
        &plaintext,
        &server_out,
    );
    const ev = try client.handleRecord(server_out[0..flight_record.len], &client_out);
    const client_finished = switch (ev) {
        .write => |w| w,
        else => return error.UnexpectedEvent,
    };
    client.completeWrite();
    try testing.expect(client.isConnected());

    try server.processClientFinished(client_out[0..client_finished.len]);
    try testing.expect(server.isConnected());

    const client_app = try client.sendApplicationData("ping", &client_out);
    client.completeWrite();
    try testing.expectEqualStrings(
        "ping",
        try server.receiveApplicationData(client_out[0..client_app.len]),
    );
    const server_app = try server.sendApplicationData("pong", &server_out);
    var server_app_mut: [128]u8 = undefined;
    @memcpy(server_app_mut[0..server_app.len], server_app);
    const app_ev = try client.handleRecord(server_app_mut[0..server_app.len], &client_out);
    try testing.expectEqualStrings("pong", app_ev.application_data);
}

// RFC 8446 §4.1.3, §2.2 — PSK fast-path authentication gate. A client that
// offered a resumption ticket but whose server did NOT select it gets pure-
// DHE handshake keys and must receive a full authenticated flight
// (Certificate + CertificateVerify + Finished). The bare-Finished fast path
// (no cert) is only legal when the server actually selected the PSK.
// Regression for the server-authentication-bypass found by the Glasswing H4
// hunt: the old guard checked `offered_psk` (client offered) instead of
// `server_selected_psk` (server selected), letting an active MITM forge a
// bare Finished and skip server authentication entirely.
test "PSK fast-path rejects bare Finished when server did NOT select PSK" {
    const psk_bytes: [32]u8 = @splat(0x42);
    const identity_bytes = [_]u8{ 0x2c, 0x03, 0x5d, 0x82, 0x93, 0x59 };

    var client: ClientHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    client.policy.insecure_no_chain_anchor = true;
    defer client.deinit();
    var ticket: ClientHandshake.SessionTicket = .{
        .ticket_age_add = 0x262a6494,
        .cipher_suite = .aes_128_gcm_sha256,
    };
    ticket.identity.appendSliceAssumeCapacity(&identity_bytes);
    ticket.psk.appendSliceAssumeCapacity(&psk_bytes);

    var client_out: [4096]u8 = undefined;
    const ch_record = try client.startWithPsk(&ticket, &client_out, false);
    client.completeWrite();

    // Server with NO psk_lookup: it ignores the PSK offer, selects no identity,
    // and does a full ephemeral (EC)DHE handshake. This models both a benign
    // server that declined resumption and an active MITM without the PSK.
    var server: ServerHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .random = .zero,
    });
    var server_out: [4096]u8 = undefined;
    const sh_record = try server.acceptClientHello(ch_record, &server_out);
    try client.processServerHello(sh_record[frame.header_len..]);

    // The server did NOT select the PSK.
    try testing.expect(!client.server_selected_psk);
    try testing.expect(client.offered_psk != null); // client offered, but...

    // Empty EncryptedExtensions handshake plaintext (as processHandshakeRecord
    // would feed after record decryption).
    const empty_ee = [_]u8{ 0x08, 0x00, 0x00, 0x02, 0x00, 0x00 };
    try client.processFlight(&empty_ee, client.policy);
    try testing.expectEqual(ClientHandshake.State.wait_cert_or_cr, client.state);

    // A bare Finished must be rejected — the server must send a full
    // authenticated flight since it declined the PSK.
    const bad_finished: [4 + 32]u8 = .{ 0x14, 0x00, 0x00, 0x20 } ++ @as([32]u8, @splat(0xaa));
    try testing.expectError(
        error.UnexpectedMessage,
        client.processFlight(&bad_finished, client.policy),
    );
    try testing.expectEqual(ClientHandshake.State.wait_cert_or_cr, client.state);
    try testing.expectEqual(@as(usize, 0), client.leaf_pub_key.len);
}

// RFC 8446 §4.2.10, §7.1 — in-memory 0-RTT: the client offers early_data
// with a PSK and sends 0-RTT data encrypted under the client_early_traffic_
// secret; the server decrypts it with the early traffic key, then the handshake
// completes normally. Exercises the early traffic key derivation + record flow.
test "in-memory 0-RTT early data is decrypted by the server" {
    const resumption_master: hkdf.HkdfSha256.Prk = .init(.{
        0x7d, 0xf2, 0x35, 0xf2, 0x03, 0x1d, 0x2a, 0x05,
        0x12, 0x87, 0xd0, 0x2b, 0x02, 0x41, 0xb0, 0xbf,
        0xda, 0xf8, 0x6c, 0xc8, 0x56, 0x23, 0x1f, 0x2d,
        0x5a, 0xba, 0x46, 0xc4, 0x34, 0xec, 0x19, 0x6c,
    });
    const psk = hkdf.HkdfSha256.resumptionPsk(resumption_master, &.{ 0x00, 0x00 });
    const identity = [_]u8{ 0x2c, 0x03, 0x5d, 0x82, 0x93, 0x59 };

    var client: ClientHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    client.policy.insecure_no_chain_anchor = true;
    var ticket: ClientHandshake.SessionTicket = .{
        .ticket_age_add = 0x262a6494,
        .cipher_suite = .aes_128_gcm_sha256,
        .max_early_data_size = 16384,
    };
    ticket.identity.appendSliceAssumeCapacity(&identity);
    ticket.psk.appendSliceAssumeCapacity(&psk.data);

    var client_out: [4096]u8 = undefined;
    const ch_record = try client.startWithPsk(&ticket, &client_out, true);
    client.completeWrite();

    // Send 0-RTT data encrypted under the early traffic key.
    var early_buf: [256]u8 = undefined;
    const early_record = try client.sendEarlyData("hello 0-rtt", &early_buf);
    client.completeWrite();

    const Lookup = struct {
        const Self = @This();
        psk: []const u8,
        identity: []const u8,
        fn l(ctx: *anyopaque, id: []const u8) ?PskEntry {
            const self: *Self = @ptrCast(@alignCast(ctx));
            if (std.mem.eql(u8, id, self.identity))
                return .{
                    .psk = self.psk,
                    .cipher_suite = .aes_128_gcm_sha256,
                    .max_early_data_size = 16384,
                };
            return null;
        }
    };
    var lookup_ctx: Lookup = .{ .psk = &psk.data, .identity = &identity };

    var server: ServerHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .random = .zero,
        .psk_lookup = .{ .context = &lookup_ctx, .lookup = Lookup.l },
    });
    var server_out: [4096]u8 = undefined;
    const sh_record = try server.acceptClientHello(ch_record, &server_out);
    try testing.expect(server.selected_psk != null);
    try testing.expect(server.early_rx != null);

    // The server decrypts the 0-RTT data with the early traffic key.
    var early_rx_buf: [256]u8 = undefined;
    @memcpy(early_rx_buf[0..early_record.len], early_record);
    const early_ev = try server.handleRecord(early_rx_buf[0..early_record.len], &server_out);
    try testing.expectEqualStrings("hello 0-rtt", early_ev.application_data);

    // The server sends its flight (EE + Finished for PSK resumption).
    // Process the ServerHello via handleRecord (plaintext handshake record).
    const sh_ev = try client.handleRecord(server_out[0..sh_record.len], &client_out);
    _ = sh_ev; // ServerHello is processed, handshake keys installed.

    // Send the authenticated flight.
    var signer = try signature.PrivateKey.fromP256Scalar(serverEcdsaScalar()[0..32]);
    defer signer.deinit();
    var plaintext: [4096]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(
        &.{serverEcdsaCertDer()},
        signer.signer(),
        &plaintext,
        &server_out,
    );
    const client_flight_ev = try client.handleRecord(server_out[0..flight_record.len], &client_out);
    const client_finished = switch (client_flight_ev) {
        .write => |w| w,
        else => return error.UnexpectedEvent,
    };
    client.completeWrite();
    try testing.expect(client.isConnected());

    // RFC 8446 §4.5 — the client sends EndOfEarlyData (under early_tx) then
    // Finished (under handshake tx) as two coalesced records. Feed them to
    // the server one at a time via handleRecord so the server routes the
    // EndOfEarlyData through early_rx and the Finished through the handshake
    // key.
    var client_out_mut: [4096]u8 = undefined;
    @memcpy(client_out_mut[0..client_finished.len], client_out[0..client_finished.len]);
    var feed_pos: usize = 0;
    // First record: EndOfEarlyData (encrypted under early traffic key).
    {
        const hdr = try frame.parseHeader(client_out_mut[feed_pos..]);
        const rec_len = frame.header_len + hdr.length();
        const eoe_ev = try server.handleRecord(
            client_out_mut[feed_pos..][0..rec_len],
            &server_out,
        );
        try testing.expectEqual(ServerHandshake.Event.none, eoe_ev);
        feed_pos += rec_len;
    }
    // Second record: client Finished (encrypted under handshake traffic key).
    {
        const hdr = try frame.parseHeader(client_out_mut[feed_pos..]);
        const rec_len = frame.header_len + hdr.length();
        const fin_ev = try server.handleRecord(
            client_out_mut[feed_pos..][0..rec_len],
            &server_out,
        );
        try testing.expectEqual(ServerHandshake.Event.none, fin_ev);
        feed_pos += rec_len;
    }
    try testing.expect(feed_pos == client_finished.len);
    try testing.expect(server.isConnected());
    try testing.expect(server.end_of_early_data_received);
    // RFC 8446 §7.1 — the early receive key is cryptographically dead after
    // EndOfEarlyData; it must be dropped at the key-change boundary.
    try testing.expect(server.early_rx == null);

    // Post-handshake app data round-trip.
    const client_app = try client.sendApplicationData("ping", &client_out);
    client.completeWrite();
    try testing.expectEqualStrings(
        "ping",
        try server.receiveApplicationData(client_out[0..client_app.len]),
    );
}

// RFC 8446 §4.2.10, §4.5, §5.2 — accepted early-data authentication failures
// require bad_record_mac. Authenticated malformed EndOfEarlyData stays unexpected_message.
test "0-RTT: accepted early data distinguishes authentication and handshake errors" {
    const Lookup = struct {
        fn lookup(_: *anyopaque, identity: []const u8) ?PskEntry {
            if (!std.mem.eql(u8, identity, "early-ticket")) return null;
            return .{
                .psk = &([_]u8{0x42} ** 32),
                .cipher_suite = .aes_128_gcm_sha256,
                .max_early_data_size = 1024,
            };
        }
    };
    const Fault = enum { corrupt_tag, malformed_handshake };
    for ([_]Fault{ .corrupt_tag, .malformed_handshake }) |fault| {
        var client: ClientHandshake = .init(.{
            .keypairs = try .init(.generate()),
            .host_name = null,
            .now_sec = 0,
            .random = .zero,
        });
        defer client.deinit();
        client.policy.insecure_no_chain_anchor = true;
        var ticket: ClientHandshake.SessionTicket = .{
            .cipher_suite = .aes_128_gcm_sha256,
            .max_early_data_size = 1024,
        };
        ticket.identity.appendSliceAssumeCapacity("early-ticket");
        ticket.psk.appendSliceAssumeCapacity(&([_]u8{0x42} ** 32));
        var client_out: [4096]u8 = undefined;
        const ch = try client.startWithPsk(&ticket, &client_out, true);
        client.completeWrite();
        var context: u8 = 0;
        var server: ServerHandshake = .init(.{
            .keypairs = try .init(.generate()),
            .random = .zero,
            .psk_lookup = .{ .context = &context, .lookup = Lookup.lookup },
        });
        defer server.deinit();
        var server_out: [4096]u8 = undefined;
        const sh = try server.acceptClientHello(ch, &server_out);
        server.completeWrite();
        try testing.expect(server.early_rx != null);
        _ = try client.handleRecord(server_out[0..sh.len], &client_out);
        var wire_buf: [128]u8 = undefined;
        const wire = switch (fault) {
            .corrupt_tag => try client.sendEarlyData("early payload", &wire_buf),
            .malformed_handshake => try client.early_tx.?.encrypt(
                .handshake,
                &.{ @intFromEnum(HandshakeType.end_of_early_data), 0, 0, 1 },
                &wire_buf,
            ),
        };
        client.completeWrite();
        if (fault == .corrupt_tag) wire_buf[wire.len - 1] ^= 1;
        var signer = try signature.PrivateKey.fromP256Scalar(serverEcdsaScalar()[0..32]);
        defer signer.deinit();
        var plaintext: [4096]u8 = undefined;
        const flight = try server.sendAuthenticatedFlight(
            &.{serverEcdsaCertDer()},
            signer.signer(),
            &plaintext,
            &server_out,
        );
        server.completeWrite();
        _ = try client.handleRecord(server_out[0..flight.len], &client_out);
        try testing.expect(client.server_accepted_early_data);
        const failure = if (server.handleRecord(wire_buf[0..wire.len], &server_out)) |_|
            return error.ExpectedFailure
        else |err|
            err;
        const description: alert.Description = switch (fault) {
            .corrupt_tag => .bad_record_mac,
            .malformed_handshake => .unexpected_message,
        };
        try testing.expectEqual(description, alert.alertForError(failure));
        try testing.expectEqual(switch (fault) {
            .corrupt_tag => error.AuthenticationFailed,
            .malformed_handshake => error.UnexpectedMessage,
        }, failure);
    }
}

// RFC 8446 §4.2.10 — server rejects 0-RTT early data exceeding
// max_early_data_size with unexpected_message.
test "0-RTT: server rejects early data exceeding max_early_data_size" {
    const resumption_master: hkdf.HkdfSha256.Prk = .init(.{
        0x7d, 0xf2, 0x35, 0xf2, 0x03, 0x1d, 0x2a, 0x05,
        0x12, 0x87, 0xd0, 0x2b, 0x02, 0x41, 0xb0, 0xbf,
        0xda, 0xf8, 0x6c, 0xc8, 0x56, 0x23, 0x1f, 0x2d,
        0x5a, 0xba, 0x46, 0xc4, 0x34, 0xec, 0x19, 0x6c,
    });
    const psk = hkdf.HkdfSha256.resumptionPsk(resumption_master, &.{ 0x00, 0x00 });
    const identity = [_]u8{ 0x2c, 0x03, 0x5d, 0x82, 0x93, 0x59 };

    var client: ClientHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    client.policy.insecure_no_chain_anchor = true;
    var ticket: ClientHandshake.SessionTicket = .{
        .ticket_age_add = 0x262a6494,
        .cipher_suite = .aes_128_gcm_sha256,
        .max_early_data_size = 10,
    };
    ticket.identity.appendSliceAssumeCapacity(&identity);
    ticket.psk.appendSliceAssumeCapacity(&psk.data);

    var client_out: [4096]u8 = undefined;
    const ch_record = try client.startWithPsk(&ticket, &client_out, true);
    client.completeWrite();

    const Lookup = struct {
        const Self = @This();
        psk: []const u8,
        identity: []const u8,
        fn l(ctx: *anyopaque, id: []const u8) ?PskEntry {
            const self: *Self = @ptrCast(@alignCast(ctx));
            if (std.mem.eql(u8, id, self.identity))
                return .{
                    .psk = self.psk,
                    .cipher_suite = .aes_128_gcm_sha256,
                    .max_early_data_size = 10,
                };
            return null;
        }
    };
    var lookup_ctx: Lookup = .{ .psk = &psk.data, .identity = &identity };

    var server: ServerHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .random = .zero,
        .psk_lookup = .{ .context = &lookup_ctx, .lookup = Lookup.l },
    });
    var server_out: [4096]u8 = undefined;
    _ = try server.acceptClientHello(ch_record, &server_out);
    try testing.expect(server.early_rx != null);

    // Send 20 bytes of early data, exceeding the 10-byte limit.
    var early_buf: [256]u8 = undefined;
    const early_record = try client.sendEarlyData("01234567890123456789", &early_buf);

    var early_rx_buf: [256]u8 = undefined;
    @memcpy(early_rx_buf[0..early_record.len], early_record);
    try testing.expectError(
        error.UnexpectedMessage,
        server.handleRecord(early_rx_buf[0..early_record.len], &early_rx_buf),
    );
}

// RFC 8446 §4.2.10 — max_early_data_size is an absolute byte limit even when
// the configured limit is maxInt(u32); accounting must not saturate and accept
// bytes beyond the remaining budget.
test "0-RTT: max u32 early-data limit rejects bytes beyond remaining budget" {
    const key: aead.Aes128GcmKey = .zero;
    const iv: aead.Iv = .zero;

    var server: ServerHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .random = .zero,
    });
    server.state = .wait_client_finished;
    server.early_rx = try .init(.{ .aes_128_gcm_sha256 = key }, iv);
    server.early_data_limit = std.math.maxInt(u32);
    server.early_data_received = std.math.maxInt(u32) - 1;

    var client_early_tx: RecordLayer = try .init(.{ .aes_128_gcm_sha256 = key }, iv);
    defer client_early_tx.deinit();

    var wire_buf: [frame.max_wire_record_len]u8 = undefined;
    const wire = try client_early_tx.encrypt(.application_data, "xx", &wire_buf);
    var out: [64]u8 = undefined;
    try testing.expectError(error.UnexpectedMessage, server.handleRecord(wire, &out));
    try testing.expectEqual(std.math.maxInt(u32) - 1, server.early_data_received);
}

// RFC 8446 §4.2.10 — when no PSK is selected (psk_lookup returns null),
// early_rx is not installed and the server declines the early_data offer.
// 0-RTT records already in flight fail deprotection under the handshake
// traffic key; the server skips them (bounded) until the first record
// deprotects successfully, so the ordinary 1-RTT handshake still completes.
test "0-RTT: no PSK selected means early data is skipped and 1-RTT completes" {
    const resumption_master: hkdf.HkdfSha256.Prk = .init(.{
        0x7d, 0xf2, 0x35, 0xf2, 0x03, 0x1d, 0x2a, 0x05,
        0x12, 0x87, 0xd0, 0x2b, 0x02, 0x41, 0xb0, 0xbf,
        0xda, 0xf8, 0x6c, 0xc8, 0x56, 0x23, 0x1f, 0x2d,
        0x5a, 0xba, 0x46, 0xc4, 0x34, 0xec, 0x19, 0x6c,
    });
    const psk = hkdf.HkdfSha256.resumptionPsk(resumption_master, &.{ 0x00, 0x00 });
    const identity = [_]u8{ 0x2c, 0x03, 0x5d, 0x82, 0x93, 0x59 };

    var client: ClientHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    client.policy.insecure_no_chain_anchor = true;
    var ticket: ClientHandshake.SessionTicket = .{
        .ticket_age_add = 0x262a6494,
        .cipher_suite = .aes_128_gcm_sha256,
        .max_early_data_size = 16384,
    };
    ticket.identity.appendSliceAssumeCapacity(&identity);
    ticket.psk.appendSliceAssumeCapacity(&psk.data);

    var client_out: [4096]u8 = undefined;
    const ch_record = try client.startWithPsk(&ticket, &client_out, true);
    client.completeWrite();

    // Server with a PSK lookup that never matches — no PSK selected.
    const NoMatch = struct {
        fn l(_: *anyopaque, _: []const u8) ?PskEntry {
            return null;
        }
    };
    var no_match: NoMatch = .{};
    var server: ServerHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .random = .zero,
        .psk_lookup = .{ .context = &no_match, .lookup = NoMatch.l },
    });
    var server_out: [4096]u8 = undefined;
    const sh_record = try server.acceptClientHello(ch_record, &server_out);
    try testing.expect(server.early_rx == null);
    try testing.expect(server.selected_psk == null);
    // The offer was declined with records already in flight: skip mode on.
    try testing.expect(server.early_data_skip == .trial_decrypt);

    // Send 0-RTT data — the server holds no early key, so the record fails
    // deprotection under the handshake key and is discarded, not aborted.
    var early_buf: [256]u8 = undefined;
    const early_record = try client.sendEarlyData("hello 0-rtt", &early_buf);
    client.completeWrite();
    var early_rx_buf: [256]u8 = undefined;
    @memcpy(early_rx_buf[0..early_record.len], early_record);
    try testing.expectEqual(
        ServerHandshake.Event.none,
        try server.handleRecord(early_rx_buf[0..early_record.len], &server_out),
    );
    // The failed trial counts its wire payload and advances nothing: the
    // handshake-key receive sequence stays at 0 for the real second flight.
    try testing.expectEqual(
        @as(u32, @intCast(early_record.len - frame.header_len)),
        server.early_data_skip_bytes,
    );
    try testing.expectEqual(@as(u64, 0), server.rx.seq);
    try testing.expect(server.early_data_skip == .trial_decrypt);

    // The client processes the ServerHello and the authenticated flight,
    // then emits its Finished under the handshake traffic key.
    _ = try client.handleRecord(server_out[0..sh_record.len], &client_out);
    var signer = try signature.PrivateKey.fromP256Scalar(serverEcdsaScalar()[0..32]);
    defer signer.deinit();
    var plaintext: [4096]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(
        &.{serverEcdsaCertDer()},
        signer.signer(),
        &plaintext,
        &server_out,
    );
    const client_flight_ev = try client.handleRecord(
        server_out[0..flight_record.len],
        &client_out,
    );
    const client_finished = switch (client_flight_ev) {
        .write => |w| w,
        else => return error.UnexpectedEvent,
    };
    client.completeWrite();

    // The first record that deprotects under the handshake key is the start
    // of the client's second flight: the Finished verifies and the server
    // completes the 1-RTT handshake despite the skipped early record.
    var client_out_mut: [4096]u8 = undefined;
    @memcpy(client_out_mut[0..client_finished.len], client_out[0..client_finished.len]);
    try testing.expectEqual(
        ServerHandshake.Event.none,
        try server.handleRecord(client_out_mut[0..client_finished.len], &server_out),
    );
    try testing.expect(server.isConnected());
    // Skip mode ended for good at the first successful deprotection.
    try testing.expect(server.early_data_skip == .off);
}

// RFC 8446 §4.2.10 — ordinary policy decline: the PSK is selected but its
// ticket entry permits no early data, so early_rx is never installed while
// the client (whose own ticket copy advertised 0-RTT) already has records in
// flight under the early traffic key. The server skips each one by
// trial-deprotection with the handshake key and the 1-RTT resumption
// handshake completes. The two failed trials prove the receive sequence and
// AEAD context survive discarded records: the real Finished still
// deprotects at sequence 0.
test "0-RTT: declined early records in flight are skipped and 1-RTT completes" {
    const resumption_master: hkdf.HkdfSha256.Prk = .init(.{
        0x7d, 0xf2, 0x35, 0xf2, 0x03, 0x1d, 0x2a, 0x05,
        0x12, 0x87, 0xd0, 0x2b, 0x02, 0x41, 0xb0, 0xbf,
        0xda, 0xf8, 0x6c, 0xc8, 0x56, 0x23, 0x1f, 0x2d,
        0x5a, 0xba, 0x46, 0xc4, 0x34, 0xec, 0x19, 0x6c,
    });
    const psk = hkdf.HkdfSha256.resumptionPsk(resumption_master, &.{ 0x00, 0x00 });
    const identity = [_]u8{ 0x2c, 0x03, 0x5d, 0x82, 0x93, 0x59 };

    var client: ClientHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    client.policy.insecure_no_chain_anchor = true;
    // The client's ticket copy permits 0-RTT, so it offers early_data and
    // installs early_tx; the server's lookup entry has max_early_data_size
    // null, so the offer is declined.
    var ticket: ClientHandshake.SessionTicket = .{
        .ticket_age_add = 0x262a6494,
        .cipher_suite = .aes_128_gcm_sha256,
        .max_early_data_size = 16384,
    };
    ticket.identity.appendSliceAssumeCapacity(&identity);
    ticket.psk.appendSliceAssumeCapacity(&psk.data);

    var client_out: [4096]u8 = undefined;
    const ch_record = try client.startWithPsk(&ticket, &client_out, true);
    client.completeWrite();
    try testing.expect(client.early_tx != null);

    // Two 0-RTT records are already in flight when the decline happens.
    var early_buf: [256]u8 = undefined;
    const early_one = try client.sendEarlyData("early one", &early_buf);
    client.completeWrite();
    var early_two_buf: [256]u8 = undefined;
    const early_two = try client.sendEarlyData("early two", &early_two_buf);
    client.completeWrite();

    const Lookup = struct {
        const Self = @This();
        psk: []const u8,
        identity: []const u8,
        fn l(ctx: *anyopaque, id: []const u8) ?PskEntry {
            const self: *Self = @ptrCast(@alignCast(ctx));
            if (std.mem.eql(u8, id, self.identity))
                return .{ .psk = self.psk, .cipher_suite = .aes_128_gcm_sha256 };
            return null;
        }
    };
    var lookup_ctx: Lookup = .{ .psk = &psk.data, .identity = &identity };

    var server: ServerHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .random = .zero,
        .psk_lookup = .{ .context = &lookup_ctx, .lookup = Lookup.l },
    });
    var server_out: [4096]u8 = undefined;
    const sh_record = try server.acceptClientHello(ch_record, &server_out);
    try testing.expect(server.selected_psk != null);
    try testing.expect(server.early_rx == null);
    try testing.expect(server.early_data_skip == .trial_decrypt);

    // Both early records fail handshake-key deprotection and are discarded.
    var early_rx_buf: [256]u8 = undefined;
    @memcpy(early_rx_buf[0..early_one.len], early_one);
    try testing.expectEqual(
        ServerHandshake.Event.none,
        try server.handleRecord(early_rx_buf[0..early_one.len], &server_out),
    );
    @memcpy(early_rx_buf[0..early_two.len], early_two);
    try testing.expectEqual(
        ServerHandshake.Event.none,
        try server.handleRecord(early_rx_buf[0..early_two.len], &server_out),
    );
    try testing.expectEqual(
        @as(u32, @intCast(early_one.len + early_two.len - 2 * frame.header_len)),
        server.early_data_skip_bytes,
    );
    try testing.expectEqual(@as(u64, 0), server.rx.seq);

    // Server flight: EE without early_data + Finished (PSK resumption).
    _ = try client.handleRecord(server_out[0..sh_record.len], &client_out);
    var signer = try signature.PrivateKey.fromP256Scalar(serverEcdsaScalar()[0..32]);
    defer signer.deinit();
    var plaintext: [4096]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(
        &.{serverEcdsaCertDer()},
        signer.signer(),
        &plaintext,
        &server_out,
    );
    const client_flight_ev = try client.handleRecord(
        server_out[0..flight_record.len],
        &client_out,
    );
    const client_finished = switch (client_flight_ev) {
        .write => |w| w,
        else => return error.UnexpectedEvent,
    };
    client.completeWrite();
    try testing.expect(client.isConnected());
    // The client saw the decline and cleared its early key.
    try testing.expect(client.early_tx == null);
    try testing.expect(!client.server_accepted_early_data);

    // The Finished is the first handshake-key record: it deprotects at
    // sequence 0 (both trials left the counter alone) and completes the
    // handshake with no EndOfEarlyData expected.
    var client_out_mut: [4096]u8 = undefined;
    @memcpy(client_out_mut[0..client_finished.len], client_out[0..client_finished.len]);
    try testing.expectEqual(
        ServerHandshake.Event.none,
        try server.handleRecord(client_out_mut[0..client_finished.len], &server_out),
    );
    try testing.expect(server.isConnected());
    try testing.expect(server.early_data_skip == .off);
    try testing.expect(!server.end_of_early_data_received);

    // Post-handshake application data round-trips on the 1-RTT keys.
    const client_app = try client.sendApplicationData("ping", &client_out);
    client.completeWrite();
    try testing.expectEqualStrings(
        "ping",
        try server.receiveApplicationData(client_out[0..client_app.len]),
    );
}

// RFC 8446 §4.2.10 — a server that requires fresh client authentication
// declines the PSK (no early key is installed) and runs the full certificate
// handshake. The client's already-in-flight 0-RTT record is skipped and the
// authenticated 1-RTT flight (client Certificate + CertificateVerify +
// Finished) completes normally.
test "0-RTT: required client auth declines PSK, skips early data, completes 1-RTT" {
    const psk: [32]u8 = @splat(0x42);
    const identity = "client-auth-ticket";
    var client: ClientHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .host_name = "ztls.server.test",
        .now_sec = 0,
        .random = .zero,
    });
    defer client.deinit();
    client.policy.insecure_no_chain_anchor = true;
    var client_signer = try signature.PrivateKey.fromP256Scalar(clientEcdsaScalar()[0..32]);
    defer client_signer.deinit();
    client.setCredentials(&.{clientEcdsaCertDer()}, client_signer.signer());
    var ticket: ClientHandshake.SessionTicket = .{
        .ticket_age_add = 0,
        .cipher_suite = .aes_128_gcm_sha256,
        .max_early_data_size = 16384,
    };
    ticket.identity.appendSliceAssumeCapacity(identity);
    ticket.psk.appendSliceAssumeCapacity(&psk);

    var client_out: [4096]u8 = undefined;
    const ch_record = try client.startWithPsk(&ticket, &client_out, true);
    client.completeWrite();

    // 0-RTT record already in flight when the server declines the PSK.
    var early_buf: [256]u8 = undefined;
    const early_record = try client.sendEarlyData("hello 0-rtt", &early_buf);
    client.completeWrite();

    const Lookup = struct {
        const Context = struct {
            identity: []const u8,
            psk: []const u8,
        };
        fn lookup(context: *anyopaque, offered_identity: []const u8) ?PskEntry {
            const ctx: *Context = @ptrCast(@alignCast(context));
            if (!mem.eql(u8, offered_identity, ctx.identity)) return null;
            return .{ .psk = ctx.psk, .cipher_suite = .aes_128_gcm_sha256 };
        }
    };
    var lookup_context: Lookup.Context = .{ .identity = identity, .psk = &psk };
    var client_cert_storage: [1024]u8 = undefined;
    var server: ServerHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .random = .zero,
        .psk_lookup = .{ .context = &lookup_context, .lookup = Lookup.lookup },
        .client_auth = .required,
        .insecure_no_client_chain_anchor = true,
        .client_cert_buffer = &client_cert_storage,
    });
    defer server.deinit();
    var server_out: [4096]u8 = undefined;
    const sh_record = try server.acceptClientHello(ch_record, &server_out);
    // The required-auth policy declined the PSK: no resumption, no early key,
    // skip mode armed for the in-flight 0-RTT record.
    try testing.expect(server.selected_psk == null);
    try testing.expect(server.early_rx == null);
    try testing.expect(server.early_data_skip == .trial_decrypt);

    var early_rx_buf: [256]u8 = undefined;
    @memcpy(early_rx_buf[0..early_record.len], early_record);
    try testing.expectEqual(
        ServerHandshake.Event.none,
        try server.handleRecord(early_rx_buf[0..early_record.len], &server_out),
    );
    try testing.expectEqual(@as(u64, 0), server.rx.seq);

    // Full certificate-authenticated server flight (with CertificateRequest).
    _ = try client.handleRecord(server_out[0..sh_record.len], &client_out);
    var server_signer = try signature.PrivateKey.fromP256Scalar(serverEcdsaScalar()[0..32]);
    defer server_signer.deinit();
    var plaintext: [4096]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(
        &.{serverEcdsaCertDer()},
        server_signer.signer(),
        &plaintext,
        &server_out,
    );
    const client_event = try client.handleRecord(server_out[0..flight_record.len], &client_out);
    const client_flight = switch (client_event) {
        .write => |write| write,
        else => return error.UnexpectedEvent,
    };
    client.completeWrite();

    // The client flight record (Certificate + CertificateVerify + Finished
    // under the handshake key) deprotects, ends skip mode, and completes the
    // authenticated 1-RTT handshake.
    var client_out_mut: [4096]u8 = undefined;
    @memcpy(client_out_mut[0..client_flight.len], client_out[0..client_flight.len]);
    try testing.expectEqual(
        ServerHandshake.Event.none,
        try server.handleRecord(client_out_mut[0..client_flight.len], &server_out),
    );
    try testing.expect(server.isConnected());
    try testing.expect(!server.isResumed());
    try testing.expect(server.clientCertificate() != null);
    try testing.expect(server.early_data_skip == .off);
}

// RFC 8446 §4.2.10 — the decline-skip budget is bounded: records that fail
// handshake-key deprotection are discarded only up to the configured
// ciphertext-byte limit (inclusive); one byte beyond the remaining budget
// aborts the handshake instead of letting a peer stream undecryptable records
// forever. The abort maps to bad_record_mac (§5.2).
test "0-RTT: decline skip budget exhaustion aborts the handshake" {
    const psk: [32]u8 = @splat(0x42);
    const identity = "budget-ticket";
    var client: ClientHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    defer client.deinit();
    client.policy.insecure_no_chain_anchor = true;
    var ticket: ClientHandshake.SessionTicket = .{
        .ticket_age_add = 0,
        .cipher_suite = .aes_128_gcm_sha256,
        .max_early_data_size = 16384,
    };
    ticket.identity.appendSliceAssumeCapacity(identity);
    ticket.psk.appendSliceAssumeCapacity(&psk);

    var client_out: [4096]u8 = undefined;
    const ch_record = try client.startWithPsk(&ticket, &client_out, true);
    client.completeWrite();

    var early_buf: [256]u8 = undefined;
    const early_one = try client.sendEarlyData("hello 0-rtt", &early_buf);
    client.completeWrite();
    var early_two_buf: [256]u8 = undefined;
    const early_two = try client.sendEarlyData("hello 0-rtt", &early_two_buf);
    client.completeWrite();
    // Budget sized to exactly one early record's wire payload: the first
    // record fits, the second does not.
    const skip_limit: u32 = @intCast(early_one.len - frame.header_len);

    // Server with no PSK lookup: the offer is declined with no early key.
    var server: ServerHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .random = .zero,
        .early_data_skip_limit = skip_limit,
    });
    defer server.deinit();
    var server_out: [4096]u8 = undefined;
    _ = try server.acceptClientHello(ch_record, &server_out);
    try testing.expect(server.early_data_skip == .trial_decrypt);

    var early_rx_buf: [256]u8 = undefined;
    @memcpy(early_rx_buf[0..early_one.len], early_one);
    try testing.expectEqual(
        ServerHandshake.Event.none,
        try server.handleRecord(early_rx_buf[0..early_one.len], &server_out),
    );
    try testing.expectEqual(skip_limit, server.early_data_skip_bytes);

    // Second record: same wire payload, zero budget remaining.
    @memcpy(early_rx_buf[0..early_two.len], early_two);
    try testing.expectError(
        error.EarlyDataSkipLimitExceeded,
        server.handleRecord(early_rx_buf[0..early_two.len], &server_out),
    );
    // The aborted record is not counted and the sequence never moved.
    try testing.expectEqual(skip_limit, server.early_data_skip_bytes);
    try testing.expectEqual(@as(u64, 0), server.rx.seq);
}

// RFC 8446 §4.2.10 — the skip window ends at the first record that
// deprotects under the handshake key; after that, corrupted records are
// ordinary §5.2 authentication failures again, not silently skipped early
// data. A partial handshake message opens the flight (fragment reassembly
// pending), then a corrupted follow-up record must abort.
test "0-RTT: corrupted record after the skip window aborts" {
    const psk: [32]u8 = @splat(0x42);
    const identity = "skip-window-ticket";
    var client: ClientHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    defer client.deinit();
    client.policy.insecure_no_chain_anchor = true;
    var ticket: ClientHandshake.SessionTicket = .{
        .ticket_age_add = 0,
        .cipher_suite = .aes_128_gcm_sha256,
        .max_early_data_size = 16384,
    };
    ticket.identity.appendSliceAssumeCapacity(identity);
    ticket.psk.appendSliceAssumeCapacity(&psk);

    var client_out: [4096]u8 = undefined;
    const ch_record = try client.startWithPsk(&ticket, &client_out, true);
    client.completeWrite();

    var early_buf: [256]u8 = undefined;
    const early_record = try client.sendEarlyData("hello 0-rtt", &early_buf);
    client.completeWrite();

    // Server with no PSK lookup: declined, no early key, skip mode armed.
    var server: ServerHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .random = .zero,
    });
    defer server.deinit();
    var server_out: [4096]u8 = undefined;
    const sh_record = try server.acceptClientHello(ch_record, &server_out);
    try testing.expect(server.early_data_skip == .trial_decrypt);

    // The 0-RTT record is skipped.
    var early_rx_buf: [256]u8 = undefined;
    @memcpy(early_rx_buf[0..early_record.len], early_record);
    try testing.expectEqual(
        ServerHandshake.Event.none,
        try server.handleRecord(early_rx_buf[0..early_record.len], &server_out),
    );

    // The client processes the ServerHello; snapshot its handshake traffic
    // key so the test can craft second-flight records record-by-record.
    _ = try client.handleRecord(server_out[0..sh_record.len], &client_out);
    var client_hs_tx = try client.tx.clone();
    defer client_hs_tx.deinit();

    // First flight record: a partial Certificate handshake message (4-byte
    // header declaring 100 body bytes plus the first 10). It deprotects, ends
    // skip mode, and parks in the fragment reassembly buffer.
    const partial = [_]u8{
        @intFromEnum(HandshakeType.certificate),
        0,
        0,
        100,
    } ++ [_]u8{0xaa} ** 10;
    var frag_buf: [256]u8 = undefined;
    const frag_record = try client_hs_tx.encrypt(.handshake, &partial, &frag_buf);
    var frag_rx_buf: [256]u8 = undefined;
    @memcpy(frag_rx_buf[0..frag_record.len], frag_record);
    try testing.expectEqual(
        ServerHandshake.Event.none,
        try server.handleRecord(frag_rx_buf[0..frag_record.len], &server_out),
    );
    try testing.expect(server.early_data_skip == .off);
    try testing.expectEqual(partial.len, server.fin_frag.len);
    const skipped_before: u32 = server.early_data_skip_bytes;

    // Second flight record, corrupted: an authentication failure past the
    // skip window aborts and drops the pending fragment instead of being
    // discarded as early data.
    var rest_buf: [256]u8 = undefined;
    const rest_record = try client_hs_tx.encrypt(
        .handshake,
        &([_]u8{0xbb} ** 90),
        &rest_buf,
    );
    rest_buf[frame.header_len] ^= 0xff;
    try testing.expectError(
        error.AuthenticationFailed,
        server.handleRecord(rest_buf[0..rest_record.len], &server_out),
    );
    try testing.expectEqual(@as(usize, 0), server.fin_frag.len);
    try testing.expectEqual(skipped_before, server.early_data_skip_bytes);
}

// RFC 8446 §4.2.10 — HelloRetryRequest decline: a client whose ClientHello1
// offered early_data may already have 0-RTT records in flight when the
// server answers with HRR. The server holds no key that can deprotect them,
// so it skips records with an outer content type of application_data while
// ClientHello2 is pending, and the retry handshake completes normally.
test "0-RTT: HRR decline skips in-flight early data and the retry handshake completes" {
    const group = firstSupportedHrrTriggerGroup() orelse return error.SkipZigTest;
    var group_storage = [1]NamedGroup{group};
    const hybrid_groups: []const NamedGroup = &group_storage;

    const master: hkdf.HkdfSha256.Prk = .init(@splat(0x7d));
    const psk = hkdf.HkdfSha256.resumptionPsk(master, &.{ 0x00, 0x00 });
    const identity = [_]u8{ 0x2c, 0x03, 0x5d, 0x82, 0x93, 0x59 };

    var client: ClientHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
        .hybrid = .{ .supported_groups = hybrid_groups, .initial_key_share = null },
    });
    defer client.deinit();
    client.policy.insecure_no_chain_anchor = true;
    var ticket: ClientHandshake.SessionTicket = .{
        .ticket_age_add = 0x262a6494,
        .cipher_suite = .aes_128_gcm_sha256,
        .max_early_data_size = 16384,
    };
    ticket.identity.appendSliceAssumeCapacity(&identity);
    ticket.psk.appendSliceAssumeCapacity(&psk.data);

    var client_out: [4096]u8 = undefined;
    const ch_record = try client.startWithPsk(&ticket, &client_out, true);
    client.completeWrite();
    try testing.expect(client.early_tx != null);

    // 0-RTT record already in flight when the HRR is sent.
    var early_buf: [256]u8 = undefined;
    const early_record = try client.sendEarlyData("hello 0-rtt", &early_buf);
    client.completeWrite();

    const Lookup = struct {
        const Self = @This();
        psk: []const u8,
        identity: []const u8,
        fn l(ctx: *anyopaque, id: []const u8) ?PskEntry {
            const self: *Self = @ptrCast(@alignCast(ctx));
            if (std.mem.eql(u8, id, self.identity))
                return .{ .psk = self.psk, .cipher_suite = .aes_128_gcm_sha256 };
            return null;
        }
    };
    var lookup_ctx: Lookup = .{ .psk = &psk.data, .identity = &identity };

    var server: ServerHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .random = .zero,
        .psk_lookup = .{ .context = &lookup_ctx, .lookup = Lookup.l },
        .hybrid_groups = hybrid_groups,
    });
    defer server.deinit();
    server.supportSuites(&.{.aes_128_gcm_sha256});
    var server_out: [4096]u8 = undefined;
    const hrr_record = try server.acceptClientHello(ch_record, &server_out);
    try testing.expectEqual(.wait_ch, server.state);
    // The HRR declined the early_data offer with records in flight: the
    // outer-content-type skip window is armed while ClientHello2 is pending.
    try testing.expect(server.early_data_skip == .await_client_hello2);

    // The in-flight 0-RTT record arrives while ClientHello2 is pending: it is
    // skipped by outer content type, never decrypted.
    var early_rx_buf: [256]u8 = undefined;
    @memcpy(early_rx_buf[0..early_record.len], early_record);
    try testing.expectEqual(
        ServerHandshake.Event.none,
        try server.handleRecord(early_rx_buf[0..early_record.len], &server_out),
    );
    try testing.expectEqual(
        @as(u32, @intCast(early_record.len - frame.header_len)),
        server.early_data_skip_bytes,
    );

    // The client consumes the HRR, invalidates its early key (§4.1.4), and
    // emits ClientHello2 without early_data.
    var hrr_rx: [4096]u8 = undefined;
    @memcpy(hrr_rx[0..hrr_record.len], hrr_record);
    const ch2_event = try client.handleRecord(hrr_rx[0..hrr_record.len], &client_out);
    const ch2_record = switch (ch2_event) {
        .write => |w| w,
        else => return error.UnexpectedEvent,
    };
    client.completeWrite();
    try testing.expect(client.early_tx == null);
    const parsed_ch2 = try client_hello.parse(ch2_record[frame.header_len..]);
    try testing.expect(!parsed_ch2.offered_early_data);

    // ClientHello2 is accepted: the PSK is re-selected over the retry
    // transcript and the skip window is closed for good.
    const sh_record = try server.acceptClientHello(ch2_record, &server_out);
    try testing.expect(server.selected_psk != null);
    try testing.expectEqual(.wait_client_finished, server.state);
    try testing.expect(server.early_data_skip == .off);
    try testing.expectEqual(@as(u32, 0), server.early_data_skip_bytes);

    // The resumption handshake completes despite the skipped early record.
    try client.processServerHello(sh_record[frame.header_len..]);
    var signer = try signature.PrivateKey.fromP256Scalar(serverEcdsaScalar()[0..32]);
    defer signer.deinit();
    var plaintext: [4096]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(
        &.{serverEcdsaCertDer()},
        signer.signer(),
        &plaintext,
        &server_out,
    );
    const flight_event = try client.handleRecord(server_out[0..flight_record.len], &client_out);
    const client_finished = switch (flight_event) {
        .write => |w| w,
        else => return error.UnexpectedEvent,
    };
    client.completeWrite();
    try testing.expect(client.isConnected());

    var client_out_mut: [4096]u8 = undefined;
    @memcpy(client_out_mut[0..client_finished.len], client_out[0..client_finished.len]);
    try server.processClientFinished(client_out_mut[0..client_finished.len]);
    try testing.expect(server.isConnected());

    // Application-data round trip under the post-retry keys.
    const client_app = try client.sendApplicationData("ping", &client_out);
    client.completeWrite();
    try testing.expectEqualStrings(
        "ping",
        try server.receiveApplicationData(client_out[0..client_app.len]),
    );
}

// RFC 8446 §4.2.10, §5.2 — the decline-skip budget must cover one full
// maximum-size early-data record: 2^14 plaintext + 1 inner content-type
// byte + 16 AEAD tag bytes = 16401 wire payload bytes.
test "0-RTT: default decline-skip budget covers a full max-size early record" {
    const psk: [32]u8 = @splat(0x42);
    const identity = "max-size-ticket";
    var client: ClientHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    defer client.deinit();
    client.policy.insecure_no_chain_anchor = true;
    var ticket: ClientHandshake.SessionTicket = .{
        .ticket_age_add = 0,
        .cipher_suite = .aes_128_gcm_sha256,
        .max_early_data_size = 16384,
    };
    ticket.identity.appendSliceAssumeCapacity(identity);
    ticket.psk.appendSliceAssumeCapacity(&psk);

    var client_out: [4096]u8 = undefined;
    const ch_record = try client.startWithPsk(&ticket, &client_out, true);
    client.completeWrite();

    // A full maximum-size 0-RTT record is already in flight when the
    // server (no psk_lookup: offer declined) responds.
    var early_plain: [frame.max_plaintext_len]u8 = @splat(0xaa);
    var early_buf: [frame.max_wire_record_len]u8 = undefined;
    const early_record = try client.sendEarlyData(&early_plain, &early_buf);
    client.completeWrite();
    try testing.expectEqual(
        @as(usize, frame.header_len + frame.max_plaintext_len + 1 + 16),
        early_record.len,
    );

    var server: ServerHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .random = .zero,
    });
    defer server.deinit();
    var server_out: [4096]u8 = undefined;
    const sh_record = try server.acceptClientHello(ch_record, &server_out);
    try testing.expect(server.early_rx == null);

    // The max-size record fits inside the default budget and is skipped.
    var early_rx_buf: [frame.max_wire_record_len]u8 = undefined;
    @memcpy(early_rx_buf[0..early_record.len], early_record);
    try testing.expectEqual(
        ServerHandshake.Event.none,
        try server.handleRecord(early_rx_buf[0..early_record.len], &server_out),
    );
    try testing.expectEqual(
        @as(u32, frame.max_plaintext_len + 1 + 16),
        server.early_data_skip_bytes,
    );

    // The 1-RTT handshake still completes after the skipped record.
    _ = try client.handleRecord(server_out[0..sh_record.len], &client_out);
    var signer = try signature.PrivateKey.fromP256Scalar(serverEcdsaScalar()[0..32]);
    defer signer.deinit();
    var plaintext: [4096]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(
        &.{serverEcdsaCertDer()},
        signer.signer(),
        &plaintext,
        &server_out,
    );
    const flight_event = try client.handleRecord(server_out[0..flight_record.len], &client_out);
    const client_finished = switch (flight_event) {
        .write => |w| w,
        else => return error.UnexpectedEvent,
    };
    client.completeWrite();
    var client_out_mut: [4096]u8 = undefined;
    @memcpy(client_out_mut[0..client_finished.len], client_out[0..client_finished.len]);
    try server.processClientFinished(client_out_mut[0..client_finished.len]);
    try testing.expect(server.isConnected());
}

const hrr_decline_identity = [_]u8{ 0x3a, 0x5e, 0x11, 0x97, 0x64, 0x2f };
const hrr_decline_psk: [32]u8 = @splat(0x5c);

const HrrDeclineSetup = struct {
    /// One in-flight 0-RTT record from the client (borrows `early_buf`).
    early_record: []const u8,
    /// The HelloRetryRequest record the server emitted (borrows `hrr_buf`).
    hrr_record: []const u8,
};

/// RFC 8446 §4.2.10 — drive a ClientHello1 that offers early_data into a
/// HelloRetryRequest decline. The engines must already be configured as a
/// hybrid-HRR pair (the client advertises `groups` without an initial
/// key_share, the server lists the same group) with no server psk_lookup, so
/// the offer is declined outright and the server answers with HRR. Afterwards
/// the server waits for ClientHello2 with the early-data skip window armed.
fn setupHrrEarlyDataDecline(
    ticket: *ClientHandshake.SessionTicket,
    client: *ClientHandshake,
    server: *ServerHandshake,
    client_out: []u8,
    server_out: []u8,
    early_buf: []u8,
    hrr_buf: []u8,
) !HrrDeclineSetup {
    // The client borrows this storage through ClientHello2 and Finished.
    ticket.* = .{
        .ticket_age_add = 0x262a6494,
        .cipher_suite = .aes_128_gcm_sha256,
        .max_early_data_size = 16384,
    };
    ticket.identity.appendSliceAssumeCapacity(&hrr_decline_identity);
    ticket.psk.appendSliceAssumeCapacity(&hrr_decline_psk);
    const ch_record = try client.startWithPsk(ticket, client_out, true);
    client.completeWrite();
    const early_record = try client.sendEarlyData("hello 0-rtt", early_buf);
    client.completeWrite();
    const hrr_record = try server.acceptClientHello(ch_record, server_out);
    @memcpy(hrr_buf[0..hrr_record.len], hrr_record);
    return .{
        .early_record = early_buf[0..early_record.len],
        .hrr_record = hrr_buf[0..hrr_record.len],
    };
}

// RFC 8446 §4.2.10 — the HRR decline-skip budget is bounded exactly like the
// 1-RTT path: outer application_data records are discarded only up to the
// configured wire-byte budget (inclusive), and the first record that does
// not fit aborts with EarlyDataSkipLimitExceeded (bad_record_mac) instead of
// letting a peer stream undecryptable records forever.
test "0-RTT: HRR decline skip budget exhaustion aborts the handshake" {
    const group = firstSupportedHrrTriggerGroup() orelse return error.SkipZigTest;
    var group_storage = [1]NamedGroup{group};
    var client: ClientHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
        .hybrid = .{ .supported_groups = &group_storage, .initial_key_share = null },
    });
    defer client.deinit();
    client.policy.insecure_no_chain_anchor = true;
    // Budget sized to exactly one "hello 0-rtt" record's wire payload:
    // plaintext + inner content type + AEAD tag.
    const skip_limit: u32 = @intCast("hello 0-rtt".len + 1 + aead.tag_len);
    var server: ServerHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .random = .zero,
        .hybrid_groups = &group_storage,
        .early_data_skip_limit = skip_limit,
    });
    defer server.deinit();
    var client_out: [4096]u8 = undefined;
    var server_out: [4096]u8 = undefined;
    var early_buf: [256]u8 = undefined;
    var hrr_buf: [4096]u8 = undefined;
    var ticket: ClientHandshake.SessionTicket = undefined;
    const setup = try setupHrrEarlyDataDecline(
        &ticket,
        &client,
        &server,
        &client_out,
        &server_out,
        &early_buf,
        &hrr_buf,
    );
    try testing.expect(server.early_data_skip == .await_client_hello2);

    // The first record fits the budget exactly (inclusive boundary).
    var early_rx_buf: [256]u8 = undefined;
    @memcpy(early_rx_buf[0..setup.early_record.len], setup.early_record);
    try testing.expectEqual(
        ServerHandshake.Event.none,
        try server.handleRecord(early_rx_buf[0..setup.early_record.len], &server_out),
    );
    try testing.expectEqual(skip_limit, server.early_data_skip_bytes);

    // A second same-size record does not: the window is exhausted.
    var early_two_buf: [256]u8 = undefined;
    const early_two = try client.sendEarlyData("hello 0-rtt", &early_two_buf);
    client.completeWrite();
    @memcpy(early_rx_buf[0..early_two.len], early_two);
    try testing.expectError(
        error.EarlyDataSkipLimitExceeded,
        server.handleRecord(early_rx_buf[0..early_two.len], &server_out),
    );
    // The aborted record is not counted.
    try testing.expectEqual(skip_limit, server.early_data_skip_bytes);
}

// RFC 8446 §4.2.10, §5.2 — while the HRR skip window is open, an outer
// application_data record whose payload cannot be an encrypted TLS 1.3
// record (zero length, or one AEAD tag or less) is malformed input, not
// skippable early data: it aborts with RecordTooShort, consumes no budget,
// and does not close the window, so a zero-length record stream cannot burn
// skips (or force a window exit) for free.
test "0-RTT: HRR decline skip rejects malformed application_data records" {
    const group = firstSupportedHrrTriggerGroup() orelse return error.SkipZigTest;
    var group_storage = [1]NamedGroup{group};
    var client: ClientHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
        .hybrid = .{ .supported_groups = &group_storage, .initial_key_share = null },
    });
    defer client.deinit();
    client.policy.insecure_no_chain_anchor = true;
    var server: ServerHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .random = .zero,
        .hybrid_groups = &group_storage,
    });
    defer server.deinit();
    var client_out: [4096]u8 = undefined;
    var server_out: [4096]u8 = undefined;
    var early_buf: [256]u8 = undefined;
    var hrr_buf: [4096]u8 = undefined;
    var ticket: ClientHandshake.SessionTicket = undefined;
    const setup = try setupHrrEarlyDataDecline(
        &ticket,
        &client,
        &server,
        &client_out,
        &server_out,
        &early_buf,
        &hrr_buf,
    );

    // Zero-length application_data: five header bytes, no payload.
    var zero_len = [_]u8{
        @intFromEnum(frame.ContentType.application_data),
        0x03,
        0x03,
        0x00,
        0x00,
    };
    try testing.expectError(error.RecordTooShort, server.handleRecord(&zero_len, &server_out));

    // Tag-only payload: 16 bytes cannot hold an AEAD tag plus the inner
    // content-type byte a valid encrypted record needs.
    const tag_zeros: [aead.tag_len]u8 = @splat(0);
    var tag_only = [_]u8{
        @intFromEnum(frame.ContentType.application_data),
        0x03,
        0x03,
        0x00,
        aead.tag_len,
    } ++ tag_zeros;
    try testing.expectError(error.RecordTooShort, server.handleRecord(&tag_only, &server_out));

    // Neither malformed record consumed budget nor closed the window: the
    // real early record is still skipped afterwards.
    try testing.expectEqual(@as(u32, 0), server.early_data_skip_bytes);
    try testing.expect(server.early_data_skip == .await_client_hello2);
    var early_rx_buf: [256]u8 = undefined;
    @memcpy(early_rx_buf[0..setup.early_record.len], setup.early_record);
    try testing.expectEqual(
        ServerHandshake.Event.none,
        try server.handleRecord(early_rx_buf[0..setup.early_record.len], &server_out),
    );
    try testing.expectEqual(
        @as(u32, @intCast(setup.early_record.len - frame.header_len)),
        server.early_data_skip_bytes,
    );
}

// RFC 8446 §4.2.10 — ClientHello2 closes the HRR skip window for good:
// afterwards application_data is no longer skippable early data, and a record
// that fails deprotection under the handshake key is an ordinary §5.2
// authentication failure.
test "0-RTT: HRR skip window closes at ClientHello2" {
    const group = firstSupportedHrrTriggerGroup() orelse return error.SkipZigTest;
    var group_storage = [1]NamedGroup{group};
    var client: ClientHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
        .hybrid = .{ .supported_groups = &group_storage, .initial_key_share = null },
    });
    defer client.deinit();
    client.policy.insecure_no_chain_anchor = true;
    var server: ServerHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .random = .zero,
        .hybrid_groups = &group_storage,
    });
    defer server.deinit();
    var client_out: [4096]u8 = undefined;
    var server_out: [4096]u8 = undefined;
    var early_buf: [256]u8 = undefined;
    var hrr_buf: [4096]u8 = undefined;
    var ticket: ClientHandshake.SessionTicket = undefined;
    const setup = try setupHrrEarlyDataDecline(
        &ticket,
        &client,
        &server,
        &client_out,
        &server_out,
        &early_buf,
        &hrr_buf,
    );

    // One early record is skipped while the window is open.
    var early_rx_buf: [256]u8 = undefined;
    @memcpy(early_rx_buf[0..setup.early_record.len], setup.early_record);
    try testing.expectEqual(
        ServerHandshake.Event.none,
        try server.handleRecord(early_rx_buf[0..setup.early_record.len], &server_out),
    );
    try testing.expect(server.early_data_skip == .await_client_hello2);

    // The client consumes the HRR and emits ClientHello2 (no early_data,
    // §4.1.2/§4.2.10).
    var hrr_rx: [4096]u8 = undefined;
    @memcpy(hrr_rx[0..setup.hrr_record.len], setup.hrr_record);
    const ch2_event = try client.handleRecord(hrr_rx[0..setup.hrr_record.len], &client_out);
    const ch2_record = switch (ch2_event) {
        .write => |w| w,
        else => return error.UnexpectedEvent,
    };
    client.completeWrite();
    const parsed_ch2 = try client_hello.parse(ch2_record[frame.header_len..]);
    try testing.expect(!parsed_ch2.offered_early_data);

    // ClientHello2 closes the window and resets the accounting.
    _ = try server.acceptClientHello(ch2_record, &server_out);
    try testing.expectEqual(.wait_client_finished, server.state);
    try testing.expect(server.early_data_skip == .off);
    try testing.expectEqual(@as(u32, 0), server.early_data_skip_bytes);

    // A subsequent application_data record is not skipped: garbage fails
    // deprotection under the handshake key and aborts.
    var garbage_buf: [64]u8 = @splat(0xcc);
    const garbage_header: frame.Header = .init(.application_data, 29);
    garbage_header.write(garbage_buf[0..frame.header_len]);
    try testing.expectError(
        error.AuthenticationFailed,
        server.handleRecord(&garbage_buf, &server_out),
    );
    try testing.expectEqual(@as(u32, 0), server.early_data_skip_bytes);
}

// RFC 8446 §4.2.10, §4.5 — server declines 0-RTT (PSK selected but
// max_early_data_size=null so early_rx not installed). EE omits early_data.
// The client detects the absence, clears early_tx, and sends no EndOfEarlyData.
test "0-RTT: server declines, client sends no EndOfEarlyData" {
    const resumption_master: hkdf.HkdfSha256.Prk = .init(.{
        0x7d, 0xf2, 0x35, 0xf2, 0x03, 0x1d, 0x2a, 0x05,
        0x12, 0x87, 0xd0, 0x2b, 0x02, 0x41, 0xb0, 0xbf,
        0xda, 0xf8, 0x6c, 0xc8, 0x56, 0x23, 0x1f, 0x2d,
        0x5a, 0xba, 0x46, 0xc4, 0x34, 0xec, 0x19, 0x6c,
    });
    const psk = hkdf.HkdfSha256.resumptionPsk(resumption_master, &.{ 0x00, 0x00 });
    const identity = [_]u8{ 0x2c, 0x03, 0x5d, 0x82, 0x93, 0x59 };

    var client: ClientHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    client.policy.insecure_no_chain_anchor = true;
    // Ticket has max_early_data_size so the client installs early_tx and
    // offers early_data. The server's PSK lookup will return
    // max_early_data_size=null, declining 0-RTT.
    var ticket: ClientHandshake.SessionTicket = .{
        .ticket_age_add = 0x262a6494,
        .cipher_suite = .aes_128_gcm_sha256,
        .max_early_data_size = 16384,
    };
    ticket.identity.appendSliceAssumeCapacity(&identity);
    ticket.psk.appendSliceAssumeCapacity(&psk.data);

    var client_out: [4096]u8 = undefined;
    const ch_record = try client.startWithPsk(&ticket, &client_out, true);
    client.completeWrite();
    try testing.expect(client.early_tx != null);

    const Lookup = struct {
        const Self = @This();
        psk: []const u8,
        identity: []const u8,
        fn l(ctx: *anyopaque, id: []const u8) ?PskEntry {
            const self: *Self = @ptrCast(@alignCast(ctx));
            if (std.mem.eql(u8, id, self.identity))
                return .{ .psk = self.psk, .cipher_suite = .aes_128_gcm_sha256 };
            return null;
        }
    };
    var lookup_ctx: Lookup = .{ .psk = &psk.data, .identity = &identity };

    var server: ServerHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .random = .zero,
        .psk_lookup = .{ .context = &lookup_ctx, .lookup = Lookup.l },
    });
    var server_out: [4096]u8 = undefined;
    const sh_record = try server.acceptClientHello(ch_record, &server_out);
    try testing.expect(server.selected_psk != null);
    try testing.expect(server.early_rx == null);

    // Process ServerHello on the client.
    _ = try client.handleRecord(server_out[0..sh_record.len], &client_out);

    // Send the authenticated flight (EE without early_data + cert + CV + Fin).
    var signer = try signature.PrivateKey.fromP256Scalar(serverEcdsaScalar()[0..32]);
    defer signer.deinit();
    var plaintext: [4096]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(
        &.{serverEcdsaCertDer()},
        signer.signer(),
        &plaintext,
        &server_out,
    );
    const client_flight_ev = try client.handleRecord(
        server_out[0..flight_record.len],
        &client_out,
    );
    const client_finished = switch (client_flight_ev) {
        .write => |w| w,
        else => return error.UnexpectedEvent,
    };
    client.completeWrite();
    try testing.expect(client.isConnected());

    // The client should have cleared early_tx (server declined 0-RTT).
    try testing.expect(client.early_tx == null);
    try testing.expect(!client.server_accepted_early_data);

    // The server should NOT expect EndOfEarlyData (early_rx was never
    // installed). Feed the client Finished directly — no EndOfEarlyData.
    var client_out_mut: [4096]u8 = undefined;
    @memcpy(client_out_mut[0..client_finished.len], client_out[0..client_finished.len]);
    try server.processClientFinished(client_out_mut[0..client_finished.len]);
    try testing.expect(server.isConnected());
    try testing.expect(!server.end_of_early_data_received);
}

// RFC 8446 §4.5 — servers MUST NOT send EndOfEarlyData. The client rejects
// a server-sent EndOfEarlyData with unexpected_message.
test "0-RTT: client rejects server-sent EndOfEarlyData" {
    // Construct a fake EE flight with an end_of_early_data message appended.
    // After EE is processed the client advances to wait_cert_or_cr, which
    // rejects any handshake type other than certificate/certificate_request/
    // finished (RFC 8446 §4.5: servers MUST NOT send EndOfEarlyData).
    var ee_buf: [256]u8 = undefined;
    const ee_msg = try encrypted_extensions.encode(&ee_buf, null, false);

    var flight_buf: [512]u8 = undefined;
    @memcpy(flight_buf[0..ee_msg.len], ee_msg);
    flight_buf[ee_msg.len] = @intFromEnum(HandshakeType.end_of_early_data);
    flight_buf[ee_msg.len + 1] = 0;
    flight_buf[ee_msg.len + 2] = 0;
    flight_buf[ee_msg.len + 3] = 0;
    const flight = flight_buf[0 .. ee_msg.len + 4];

    // Set up a client in wait_ee state via processFlight.
    var client: ClientHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    client.policy.insecure_no_chain_anchor = true;
    var out: [4096]u8 = undefined;
    _ = try client.start(&out);
    client.completeWrite();

    // The client state machine rejects end_of_early_data in the server flight
    // because, after EE, the wait_cert_or_cr state does not accept it.
    try testing.expectError(
        error.UnexpectedMessage,
        client.processFlight(flight, client.policy),
    );
}

// RFC 8446 §4.5 — if the server accepted 0-RTT, the public processClientFinished
// entry point MUST reject a Finished that arrives before EndOfEarlyData, the
// same gate handleWaitClientFinished enforces. A caller using the direct API
// must not be able to accept a non-compliant 0-RTT client flight.
test "0-RTT: processClientFinished rejects Finished before EndOfEarlyData" {
    const resumption_master: hkdf.HkdfSha256.Prk = .init(.{
        0x7d, 0xf2, 0x35, 0xf2, 0x03, 0x1d, 0x2a, 0x05,
        0x12, 0x87, 0xd0, 0x2b, 0x02, 0x41, 0xb0, 0xbf,
        0xda, 0xf8, 0x6c, 0xc8, 0x56, 0x23, 0x1f, 0x2d,
        0x5a, 0xba, 0x46, 0xc4, 0x34, 0xec, 0x19, 0x6c,
    });
    const psk = hkdf.HkdfSha256.resumptionPsk(resumption_master, &.{ 0x00, 0x00 });
    const identity = [_]u8{ 0x2c, 0x03, 0x5d, 0x82, 0x93, 0x59 };

    var client: ClientHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    client.policy.insecure_no_chain_anchor = true;
    var ticket: ClientHandshake.SessionTicket = .{
        .ticket_age_add = 0x262a6494,
        .cipher_suite = .aes_128_gcm_sha256,
        .max_early_data_size = 16384,
    };
    ticket.identity.appendSliceAssumeCapacity(&identity);
    ticket.psk.appendSliceAssumeCapacity(&psk.data);

    var client_out: [4096]u8 = undefined;
    const ch_record = try client.startWithPsk(&ticket, &client_out, true);
    client.completeWrite();

    const Lookup = struct {
        const Self = @This();
        psk: []const u8,
        identity: []const u8,
        fn l(ctx: *anyopaque, id: []const u8) ?PskEntry {
            const self: *Self = @ptrCast(@alignCast(ctx));
            if (std.mem.eql(u8, id, self.identity))
                return .{
                    .psk = self.psk,
                    .cipher_suite = .aes_128_gcm_sha256,
                    .max_early_data_size = 16384,
                };
            return null;
        }
    };
    var lookup_ctx: Lookup = .{ .psk = &psk.data, .identity = &identity };

    var server: ServerHandshake = .init(.{
        .keypairs = try .init(.generate()),
        .random = .zero,
        .psk_lookup = .{ .context = &lookup_ctx, .lookup = Lookup.l },
    });
    var server_out: [4096]u8 = undefined;
    _ = try server.acceptClientHello(ch_record, &server_out);
    try testing.expect(server.early_rx != null);
    try testing.expect(!server.end_of_early_data_received);

    // Send the server flight to reach wait_client_finished with early_rx still
    // installed (EndOfEarlyData not yet received).
    var signer = try signature.PrivateKey.fromP256Scalar(serverEcdsaScalar()[0..32]);
    defer signer.deinit();
    var plaintext: [4096]u8 = undefined;
    _ = try server.sendAuthenticatedFlight(
        &.{serverEcdsaCertDer()},
        signer.signer(),
        &plaintext,
        &server_out,
    );
    try testing.expect(server.early_rx != null);
    try testing.expect(!server.end_of_early_data_received);

    // A direct Finished via the public API is rejected before decryption:
    // EndOfEarlyData was not received. The record bytes are irrelevant
    // because the guard fires before decryptProtected.
    var dummy: [64]u8 = undefined;
    try testing.expectError(
        error.UnexpectedMessage,
        server.processClientFinished(&dummy),
    );
    try testing.expect(!server.isConnected());
}

// RFC 8446 §4.2.8 / RFC 10024 §4.1 — when a client sends multiple hybrid
// shares, the server chooses in its configured preference order.
test "preferredHybridShare follows server preference" {
    if (!backend.supportsServerHybridGroup(.x25519_mlkem768) or
        !backend.supportsServerHybridGroup(.secp256r1_mlkem768))
    {
        return error.SkipZigTest;
    }

    const preference = [_]NamedGroup{
        .secp256r1_mlkem768,
        .x25519_mlkem768,
    };
    var config = try testConfig(.generate());
    config.hybrid_groups = &preference;
    var server: ServerHandshake = .init(config);
    defer server.deinit();

    var x25519_share: [1216]u8 = undefined;
    var p256_share: [1249]u8 = undefined;
    const offered = [_]client_hello.ParsedKemKeyShare{
        .{ .group = .x25519_mlkem768, .data = &x25519_share },
        .{ .group = .secp256r1_mlkem768, .data = &p256_share },
    };
    const selected = server.preferredHybridShare(&offered);
    try testing.expect(selected != null);
    try testing.expectEqual(NamedGroup.secp256r1_mlkem768, selected.?.group);
}

// RFC 10024 §4 — every standardized hybrid group completes an in-memory
// authenticated handshake and protects application data with the composed
// ECDHE + ML-KEM shared secret.
test "in-memory RFC 10024 hybrid group matrix reaches app data" {
    const groups = [_]NamedGroup{
        .x25519_mlkem768,
        .secp256r1_mlkem768,
        .secp384r1_mlkem1024,
    };
    var tested = false;

    for (groups) |group| {
        if (!backend.supportsServerHybridGroup(group)) continue;
        tested = true;

        const enabled_groups = [_]NamedGroup{group};
        var client_keys: KeyPairs = try .init(.generate());
        if (group == .secp384r1_mlkem1024) client_keys.p384 = try .generate();
        var client: ClientHandshake = .init(.{
            .keypairs = client_keys,
            .host_name = null,
            .now_sec = 0,
            .random = .zero,
            .hybrid = .{
                .supported_groups = &enabled_groups,
                .initial_key_share = group,
            },
        });
        client.policy.insecure_no_chain_anchor = true;
        defer client.deinit();

        var client_out: [4096]u8 = undefined;
        const ch_record = try client.start(&client_out);
        client.completeWrite();

        var server_config = try testConfig(.generate());
        if (group == .secp384r1_mlkem1024)
            server_config.keypairs.p384 = try .generate();
        server_config.hybrid_groups = &enabled_groups;
        var server: ServerHandshake = .init(server_config);
        defer server.deinit();

        var server_out: [4096]u8 = undefined;
        const sh_record = try server.acceptClientHello(ch_record, &server_out);
        try testing.expectEqual(group, server.negotiated_group);

        _ = try client.handleRecord(server_out[0..sh_record.len], &client_out);

        var signer = try signature.PrivateKey.fromP256Scalar(serverEcdsaScalar()[0..32]);
        defer signer.deinit();
        var plaintext: [4096]u8 = undefined;
        const flight_record = try server.sendAuthenticatedFlight(
            &.{serverEcdsaCertDer()},
            signer.signer(),
            &plaintext,
            &server_out,
        );
        const flight_ev = try client.handleRecord(
            server_out[0..flight_record.len],
            &client_out,
        );
        const client_finished = switch (flight_ev) {
            .write => |w| w,
            else => return error.UnexpectedEvent,
        };
        client.completeWrite();
        try testing.expect(client.isConnected());

        try server.processClientFinished(client_out[0..client_finished.len]);
        try testing.expect(server.isConnected());

        const client_app = try client.sendApplicationData("ping", &client_out);
        client.completeWrite();
        try testing.expectEqualStrings(
            "ping",
            try server.receiveApplicationData(client_out[0..client_app.len]),
        );
        const server_app = try server.sendApplicationData("pong", &server_out);
        var server_app_mut: [128]u8 = undefined;
        @memcpy(server_app_mut[0..server_app.len], server_app);
        const app_ev = try client.handleRecord(
            server_app_mut[0..server_app.len],
            &client_out,
        );
        try testing.expectEqualStrings("pong", app_ev.application_data);
    }

    if (!tested) return error.SkipZigTest;
}

// RFC 8446 §4.1.4, RFC 10024 §4.1 — advertising a hybrid group without an
// initial share lets the server select it through HRR; ClientHello2 then
// carries exactly that group's full hybrid share.
test "RFC 10024 hybrid group matrix negotiates through HRR" {
    const groups = [_]NamedGroup{
        .x25519_mlkem768,
        .secp256r1_mlkem768,
        .secp384r1_mlkem1024,
    };
    var tested = false;

    for (groups) |group| {
        if (!backend.supportsServerHybridGroup(group)) continue;
        tested = true;

        const enabled_groups = [_]NamedGroup{group};
        var client_keys: KeyPairs = try .init(.generate());
        if (group == .secp384r1_mlkem1024) client_keys.p384 = try .generate();
        var client: ClientHandshake = .init(.{
            .keypairs = client_keys,
            .host_name = null,
            .now_sec = 0,
            .random = .zero,
            .hybrid = .{ .supported_groups = &enabled_groups },
        });
        defer client.deinit();

        var client_out: [4096]u8 = undefined;
        const ch1_record = try client.start(&client_out);
        client.completeWrite();

        var server_config = try testConfig(.generate());
        if (group == .secp384r1_mlkem1024)
            server_config.keypairs.p384 = try .generate();
        server_config.hybrid_groups = &enabled_groups;
        var server: ServerHandshake = .init(server_config);
        defer server.deinit();

        var server_out: [4096]u8 = undefined;
        const hrr_record = try server.acceptClientHello(ch1_record, &server_out);
        const hrr_header = try frame.parseHeader(hrr_record);
        const hrr = try server_hello.parseHelloRetryRequest(
            hrr_record[frame.header_len..][0..hrr_header.length()],
        );
        try testing.expectEqual(group, hrr.selected_group.?);

        var hrr_rx: [4096]u8 = undefined;
        @memcpy(hrr_rx[0..hrr_record.len], hrr_record);
        const ch2_event = try client.handleRecord(hrr_rx[0..hrr_record.len], &client_out);
        const ch2_record = switch (ch2_event) {
            .write => |record| record,
            else => return error.UnexpectedEvent,
        };
        client.completeWrite();

        const ch2_header = try frame.parseHeader(ch2_record);
        const ch2 = try client_hello.parse(
            ch2_record[frame.header_len..][0..ch2_header.length()],
        );
        try testing.expectEqual(group, ch2.hybrid_key_shares.get(0).group);
        try testing.expect(ch2.public_key == null);
        try testing.expect(ch2.public_key_p256 == null);
        try testing.expect(ch2.public_key_p384 == null);

        const sh_record = try server.acceptClientHello(ch2_record, &server_out);
        try testing.expectEqual(group, server.negotiated_group);
        _ = try client.handleRecord(server_out[0..sh_record.len], &client_out);
        try testing.expectEqual(group, client.retry_selected_group.?);
    }

    if (!tested) return error.SkipZigTest;
}

// RFC 8446 §4.2.7, RFC 10024 §4 — a server that has not enabled hybrid
// groups may ignore a valid hybrid share and select an offered classical share.
test "hybrid share requires explicit server policy" {
    if (!backend.supportsClientHybridGroup(.secp256r1_mlkem768))
        return error.SkipZigTest;

    var client_keys: handshake_key_pairs.KeyPairs = .initWithP256(
        .generate(),
        try .generateDeterministic(.init(test_p256_seed_a)),
    );
    defer client_keys.secureZero();
    var hybrid_key = try hybrid_kex.ClientKeyPair.generate(.secp256r1_mlkem768);
    defer hybrid_key.deinit();
    var hybrid_public: [hybrid_kex.max_client_share_len]u8 = undefined;
    const public_key = try hybrid_key.publicKey(&client_keys, &hybrid_public);
    const share: client_hello.KemShare = .{
        .group = .secp256r1_mlkem768,
        .data = public_key,
    };
    var ch_buf: [4096]u8 = undefined;
    const ch = try client_hello.encodeWithKem(
        &ch_buf,
        .zero,
        client_keys.x25519.public_key,
        client_keys.p256.public_key,
        null,
        null,
        &.{},
        share,
    );
    var ch_record: [4096]u8 = undefined;
    const ch_header: frame.Header = .init(.handshake, @intCast(ch.len));
    ch_header.write(ch_record[0..frame.header_len]);
    @memcpy(ch_record[frame.header_len..][0..ch.len], ch);

    var server: ServerHandshake = .init(try testConfig(.generate()));
    var server_out: [4096]u8 = undefined;
    _ = try server.acceptClientHello(
        ch_record[0 .. frame.header_len + ch.len],
        &server_out,
    );
    try testing.expectEqual(NamedGroup.x25519, server.negotiated_group);
}

// RFC 8446 §4.1.4 — full HelloRetryRequest round trip in memory: the client
// advertises secp256r1 in supported_groups but sends only an X25519 key_share,
// the server emits an HRR selecting secp256r1, the client sends ClientHello2
// with a secp256r1 key_share, and the handshake completes to connected with a
// working application-data round trip. Exercises both state machines and the
// §4.4.1 transcript collapse end-to-end.
test "in-memory HRR round trip reaches app data" {
    const client_keypair: x25519.KeyPair = .generate();
    const server_keypair: x25519.KeyPair = .generate();

    var client: ClientHandshake = .init(.{
        .keypairs = try .init(client_keypair),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    client.policy.insecure_no_chain_anchor = true;

    // ClientHello1: advertise x25519 + secp256r1 in supported_groups but send
    // a GREASE key_share (patch the X25519 key_share group to 0x6a6a) so the
    // server has no matching key_share and must HRR. The client still has its
    // real x25519/p256 keypairs for ClientHello2.
    var ch1_buf: [512]u8 = undefined;
    const ch1 = try client_hello.encodeRetryAfterHrr(
        &ch1_buf,
        .zero,
        client.keypairs.x25519.public_key,
        client.keypairs.p256.public_key,
        null,
        .x25519,
        null,
        null,
        &.{},
    );
    patchClientHelloKeyShareGroup(@constCast(ch1), 0x6a6a);
    var ch1_record: [1024]u8 = undefined;
    const ch1_header: frame.Header = .init(.handshake, @intCast(ch1.len));
    ch1_header.write(ch1_record[0..frame.header_len]);
    @memcpy(ch1_record[frame.header_len..][0..ch1.len], ch1);
    client.injectClientHello(ch1);
    client.pending_write.mark();
    client.completeWrite();

    var server: ServerHandshake = .init(try testConfig(server_keypair));
    var server_out: [4096]u8 = undefined;
    const hrr_record = try server.acceptClientHello(
        ch1_record[0 .. frame.header_len + ch1.len],
        &server_out,
    );
    // The server must have emitted an HRR selecting a supported group (x25519,
    // the first in the client's supported_groups that the server supports).
    const hrr_hdr = try frame.parseHeader(hrr_record);
    const hrr = try server_hello.parseHelloRetryRequest(
        hrr_record[frame.header_len..][0..hrr_hdr.length()],
    );
    try testing.expect(hrr.selected_group != null);
    try testing.expectEqual(.wait_ch, server.state);

    // Client consumes the HRR and emits ClientHello2 as a framed .write event.
    var client_out: [1024]u8 = undefined;
    var hrr_rx: [128]u8 = undefined;
    @memcpy(hrr_rx[0..hrr_record.len], hrr_record);
    const ch2_event = try client.handleRecord(hrr_rx[0..hrr_record.len], &client_out);
    const ch2_msg = switch (ch2_event) {
        .write => |w| w,
        else => return error.UnexpectedEvent,
    };
    client.completeWrite();
    try testing.expect(client.retry_selected_group != null);
    try testing.expectEqual(hrr.selected_group.?, client.retry_selected_group.?);

    var ch2_record: [1024]u8 = undefined;
    @memcpy(ch2_record[0..ch2_msg.len], ch2_msg);
    const ch2_header = try frame.parseHeader(ch2_record[0..ch2_msg.len]);
    try testing.expectEqual(frame.ContentType.handshake, ch2_header.content_type);
    try testing.expectEqual(ch2_msg.len - frame.header_len, ch2_header.length());

    // Server accepts ClientHello2 and emits ServerHello.
    const sh_record = try server.acceptClientHello(ch2_record[0..ch2_msg.len], &server_out);
    try testing.expectEqual(.wait_client_finished, server.state);
    // Client processes the real ServerHello (post-HRR).
    try client.processServerHello(sh_record[frame.header_len..]);

    // Server sends the authenticated flight.
    var signer = try signature.PrivateKey.fromP256Scalar(serverEcdsaScalar()[0..32]);
    defer signer.deinit();
    var plaintext: [4096]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(
        &.{serverEcdsaCertDer()},
        signer.signer(),
        &plaintext,
        &server_out,
    );
    const flight_event = try client.handleRecord(server_out[0..flight_record.len], &client_out);
    const client_finished_record = switch (flight_event) {
        .write => |w| w,
        else => return error.UnexpectedEvent,
    };
    client.completeWrite();
    try testing.expect(client.isConnected());

    try server.processClientFinished(client_out[0..client_finished_record.len]);
    try testing.expect(server.isConnected());

    // Application-data round trip under the post-HRR keys.
    const client_app = try client.sendApplicationData("ping", &client_out);
    client.completeWrite();
    try testing.expectEqualStrings(
        "ping",
        try server.receiveApplicationData(client_out[0..client_app.len]),
    );

    const server_app = try server.sendApplicationData("pong", &server_out);
    var server_app_mut: [128]u8 = undefined;
    @memcpy(server_app_mut[0..server_app.len], server_app);
    const ev = try client.handleRecord(server_app_mut[0..server_app.len], &client_out);
    try testing.expectEqualStrings("pong", ev.application_data);
}

test "acceptClientHello: server suite preference" {
    const client_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    var record: [1024]u8 = undefined;
    const header: frame.Header = .init(.handshake, @intCast(ch.len));
    header.write(record[0..frame.header_len]);
    @memcpy(record[frame.header_len..][0..ch.len], ch);

    var hs: ServerHandshake = .init(try testConfig(.generate()));
    const suites = [_]CipherSuite{.chacha20_poly1305_sha256};
    hs.supportSuites(&suites);
    var out: [256]u8 = undefined;
    const sh_record = try hs.acceptClientHello(record[0 .. frame.header_len + ch.len], &out);
    const hdr = try frame.parseHeader(sh_record);
    const sh = try server_hello.parse(sh_record[frame.header_len..][0..hdr.length()]);
    try testing.expectEqual(.chacha20_poly1305_sha256, sh.cipher_suite);
}

// RFC 6066 §3 — server_name extension: server must be able to read the
// requested hostname to select the appropriate certificate.
test "acceptClientHello: exposes SNI via clientServerName" {
    const client_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(
        &ch_buf,
        .zero,
        client_keypair.public_key,
        "example.com",
        &.{},
    );
    var record: [1024]u8 = undefined;
    const header: frame.Header = .init(.handshake, @intCast(ch.len));
    header.write(record[0..frame.header_len]);
    @memcpy(record[frame.header_len..][0..ch.len], ch);

    var hs: ServerHandshake = .init(try testConfig(.generate()));
    var out: [256]u8 = undefined;
    _ = try hs.acceptClientHello(record[0 .. frame.header_len + ch.len], &out);
    try testing.expectEqualStrings("example.com", hs.clientServerName().?);
}

// RFC 6066 §3 — SNI is optional; no server_name extension means null.
test "acceptClientHello: clientServerName is null when SNI absent" {
    const client_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    var record: [1024]u8 = undefined;
    const header: frame.Header = .init(.handshake, @intCast(ch.len));
    header.write(record[0..frame.header_len]);
    @memcpy(record[frame.header_len..][0..ch.len], ch);

    var hs: ServerHandshake = .init(try testConfig(.generate()));
    var out: [256]u8 = undefined;
    _ = try hs.acceptClientHello(record[0 .. frame.header_len + ch.len], &out);
    try testing.expectEqual(null, hs.clientServerName());
}

test "acceptClientHello: rejects unsupported suite" {
    const client_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    // Patch offered suites to unknown values. Offsets are fixed by
    // ClientHello's fixed prefix: header(4)+version(2)+random(32)+sid_len(1).
    ch_buf[41..47].* = .{ 0x12, 0x34, 0x12, 0x35, 0x12, 0x36 };
    var record: [1024]u8 = undefined;
    const header: frame.Header = .init(.handshake, @intCast(ch.len));
    header.write(record[0..frame.header_len]);
    @memcpy(record[frame.header_len..][0..ch.len], ch);
    var hs: ServerHandshake = .init(try testConfig(.generate()));
    var out: [256]u8 = undefined;
    try testing.expectError(
        error.UnsupportedCipherSuite,
        hs.acceptClientHello(record[0 .. frame.header_len + ch.len], &out),
    );
}

// RFC 8446 §4.1.2, §9.3 — servers ignore unknown cipher-suite code points and
// negotiate a recognized alternative from the same ClientHello vector.
test "acceptClientHello: ignores unknown cipher suites in mixed list" {
    const client_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    // unknown, TLS_AES_256_GCM_SHA384, unknown
    ch_buf[41..47].* = .{ 0x12, 0x34, 0x13, 0x02, 0x56, 0x78 };

    var record: [1024]u8 = undefined;
    const header: frame.Header = .init(.handshake, @intCast(ch.len));
    header.write(record[0..frame.header_len]);
    @memcpy(record[frame.header_len..][0..ch.len], ch);

    var hs: ServerHandshake = .init(try testConfig(.generate()));
    var out: [256]u8 = undefined;
    const sh_record = try hs.acceptClientHello(record[0 .. frame.header_len + ch.len], &out);
    const sh_hdr = try frame.parseHeader(sh_record);
    const sh = try server_hello.parse(sh_record[frame.header_len..][0..sh_hdr.length()]);
    try testing.expectEqual(.aes_256_gcm_sha384, sh.cipher_suite);
}

// RFC 8446 §2 — the server must not emit an ephemeral share for a group not
// offered by the client.
test "acceptClientHello: rejects ClientHello with no shared group" {
    const client_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    var i: usize = 0;
    while (i + 1 < ch.len) : (i += 1) {
        if (ch_buf[i] == 0x00 and ch_buf[i + 1] == 0x1d) ch_buf[i..][0..2].* = .{ 0x6a, 0x6a };
    }

    var record: [1024]u8 = undefined;
    const header: frame.Header = .init(.handshake, @intCast(ch.len));
    header.write(record[0..frame.header_len]);
    @memcpy(record[frame.header_len..][0..ch.len], ch);

    var hs: ServerHandshake = .init(try testConfig(.generate()));
    var out: [256]u8 = undefined;
    try testing.expectError(
        error.UnsupportedKeyShare,
        hs.acceptClientHello(record[0 .. frame.header_len + ch.len], &out),
    );
}

// RFC 8446 §5.1 — server reassembles a ClientHello whose handshake body is
// split across two TLS records and responds with a ServerHello.
test "handleRecord: reassembles ClientHello split across records" {
    const client_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch_msg = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});

    // Split the handshake message body after the 4-byte header.
    const split_at = handshake_header_len + (ch_msg.len - handshake_header_len) / 2;

    var rec1: [1024]u8 = undefined;
    const hdr1: frame.Header = .init(.handshake, @intCast(split_at));
    hdr1.write(rec1[0..frame.header_len]);
    @memcpy(rec1[frame.header_len..][0..split_at], ch_msg[0..split_at]);

    var hs: ServerHandshake = .init(try testConfig(.generate()));
    var reassembly: [1024]u8 = undefined;
    hs.useHandshakeBuffer(&reassembly);
    var out: [256]u8 = undefined;
    const ev1 = try hs.handleRecord(rec1[0 .. frame.header_len + split_at], &out);
    try testing.expectEqual(Event.none, ev1);
    try testing.expectEqual(.wait_ch, hs.state);

    const remaining = ch_msg.len - split_at;
    var rec2: [1024]u8 = undefined;
    const hdr2: frame.Header = .init(.handshake, @intCast(remaining));
    hdr2.write(rec2[0..frame.header_len]);
    @memcpy(rec2[frame.header_len..][0..remaining], ch_msg[split_at..]);

    const ev2 = try hs.handleRecord(rec2[0 .. frame.header_len + remaining], &out);
    try testing.expectEqual(.wait_client_finished, hs.state);
    const sh_hdr = try frame.parseHeader(ev2.write);
    try testing.expectEqual(frame.ContentType.handshake, sh_hdr.content_type);
}

// RFC 8446 §5.1 — server reassembles a ClientHello whose 4-byte handshake
// header is in one record and the entire body is in a second record.
test "handleRecord: reassembles ClientHello with header and body in separate records" {
    const client_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch_msg = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});

    // Split immediately after the 4-byte handshake header.
    const split_at: usize = handshake_header_len;

    var rec1: [1024]u8 = undefined;
    const hdr1: frame.Header = .init(.handshake, @intCast(split_at));
    hdr1.write(rec1[0..frame.header_len]);
    @memcpy(rec1[frame.header_len..][0..split_at], ch_msg[0..split_at]);

    var hs: ServerHandshake = .init(try testConfig(.generate()));
    var reassembly: [1024]u8 = undefined;
    hs.useHandshakeBuffer(&reassembly);
    var out: [256]u8 = undefined;
    const ev1 = try hs.handleRecord(rec1[0 .. frame.header_len + split_at], &out);
    try testing.expectEqual(Event.none, ev1);

    const remaining = ch_msg.len - split_at;
    var rec2: [1024]u8 = undefined;
    const hdr2: frame.Header = .init(.handshake, @intCast(remaining));
    hdr2.write(rec2[0..frame.header_len]);
    @memcpy(rec2[frame.header_len..][0..remaining], ch_msg[split_at..]);

    const ev2 = try hs.handleRecord(rec2[0 .. frame.header_len + remaining], &out);
    try testing.expectEqual(.wait_client_finished, hs.state);
    _ = ev2.write;
}

// RFC 8446 §5.1 — a ChangeCipherSpec record arriving while a ClientHello
// fragment is pending is illegal (short of any valid CCS compatibility window).
test "handleRecord: rejects CCS while ClientHello fragment pending" {
    const client_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch_msg = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    const split_at = handshake_header_len + (ch_msg.len - handshake_header_len) / 2;

    var rec1: [1024]u8 = undefined;
    const hdr1: frame.Header = .init(.handshake, @intCast(split_at));
    hdr1.write(rec1[0..frame.header_len]);
    @memcpy(rec1[frame.header_len..][0..split_at], ch_msg[0..split_at]);

    var hs: ServerHandshake = .init(try testConfig(.generate()));
    var reassembly: [1024]u8 = undefined;
    hs.useHandshakeBuffer(&reassembly);
    var out: [256]u8 = undefined;
    const ev1 = try hs.handleRecord(rec1[0 .. frame.header_len + split_at], &out);
    try testing.expectEqual(Event.none, ev1);

    // CCS is illegal mid-fragment regardless of HRR state.
    var ccs = [_]u8{ 0x14, 0x03, 0x03, 0x00, 0x01, 0x01 };
    try testing.expectError(error.UnexpectedRecord, hs.handleRecord(&ccs, &out));
}

// RFC 8446 §5.1 — an alert record while a ClientHello fragment is pending
// terminates the connection; the partial ClientHello is discarded.
test "handleRecord: processes alert while ClientHello fragment pending" {
    const client_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch_msg = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    const split_at = handshake_header_len + (ch_msg.len - handshake_header_len) / 2;

    var rec1: [1024]u8 = undefined;
    const hdr1: frame.Header = .init(.handshake, @intCast(split_at));
    hdr1.write(rec1[0..frame.header_len]);
    @memcpy(rec1[frame.header_len..][0..split_at], ch_msg[0..split_at]);

    var hs: ServerHandshake = .init(try testConfig(.generate()));
    var reassembly: [1024]u8 = undefined;
    hs.useHandshakeBuffer(&reassembly);
    var out: [256]u8 = undefined;
    const ev1 = try hs.handleRecord(rec1[0 .. frame.header_len + split_at], &out);
    try testing.expectEqual(Event.none, ev1);

    // A fatal alert terminates the connection mid-fragment.
    var alert_rec = [_]u8{ 0x15, 0x03, 0x03, 0x00, 0x02, 0x02, 0x28 };
    try testing.expectError(error.PeerAlert, hs.handleRecord(&alert_rec, &out));
    // RFC 8446 §6.2 — the peer's exact level/description is retained (#85).
    try testing.expectEqual(
        @as(?alert.Alert, .{ .level = .fatal, .description = .handshake_failure }),
        hs.lastPeerAlert(),
    );
}

// RFC 8446 §6 — a plaintext fatal alert before the ClientHello aborts and
// records the peer's exact level/description; reinitialization starts null (#85).
test "handleRecord: plaintext fatal alert in wait_ch records detail" {
    var hs: ServerHandshake = .init(try testConfig(.generate()));
    defer hs.deinit();
    var out: [64]u8 = undefined;
    try testing.expect(hs.lastPeerAlert() == null);

    var alert_rec = [_]u8{ 0x15, 0x03, 0x03, 0x00, 0x02, 0x02, 0x0a };
    try testing.expectError(error.PeerAlert, hs.handleRecord(&alert_rec, &out));
    try testing.expectEqual(
        @as(?alert.Alert, .{ .level = .fatal, .description = .unexpected_message }),
        hs.lastPeerAlert(),
    );

    // Deinit + reinitialization of the same engine starts null (#85).
    hs.deinit();
    hs = .init(try testConfig(.generate()));
    try testing.expect(hs.lastPeerAlert() == null);
}

// RFC 8446 §6 — AlertLevel and AlertDescription are non-exhaustive; unknown
// codes are legal on the wire and must be preserved verbatim for diagnostics.
test "handleRecord: unknown alert codes are preserved" {
    var hs: ServerHandshake = .init(try testConfig(.generate()));
    defer hs.deinit();
    var out: [64]u8 = undefined;

    var unknown = [_]u8{ 0x15, 0x03, 0x03, 0x00, 0x02, 0x05, 0xee };
    try testing.expectError(error.PeerAlert, hs.handleRecord(&unknown, &out));
    try testing.expect(hs.lastPeerAlert() != null);
    const got = hs.lastPeerAlert().?;
    try testing.expectEqual(@as(u8, 5), @intFromEnum(got.level));
    try testing.expectEqual(@as(u8, 0xee), @intFromEnum(got.description));
}

// RFC 8446 §6 — a later non-close_notify alert replaces an earlier one;
// close_notify (§6.1) and malformed records leave the stored detail unchanged.
test "handleRecord: lastPeerAlert replaced by later alert, preserved by close/malformed" {
    var hs: ServerHandshake = .init(try testConfig(.generate()));
    defer hs.deinit();
    var out: [64]u8 = undefined;

    var first = [_]u8{ 0x15, 0x03, 0x03, 0x00, 0x02, 0x02, 0x28 }; // fatal handshake_failure
    try testing.expectError(error.PeerAlert, hs.handleRecord(&first, &out));
    // user_canceled is warning-level but not close_notify (§6.1).
    var second = [_]u8{ 0x15, 0x03, 0x03, 0x00, 0x02, 0x01, 0x5a };
    try testing.expectError(error.PeerAlert, hs.handleRecord(&second, &out));
    try testing.expectEqual(
        @as(?alert.Alert, .{ .level = .warning, .description = .user_canceled }),
        hs.lastPeerAlert(),
    );

    var close = [_]u8{ 0x15, 0x03, 0x03, 0x00, 0x02, 0x01, 0x00 };
    try testing.expectEqual(Event.closed, try hs.handleRecord(&close, &out));
    var bad = [_]u8{ 0x15, 0x03, 0x03, 0x00, 0x03, 0x02, 0x28, 0x00 };
    try testing.expectError(error.InvalidAlertLength, hs.handleRecord(&bad, &out));
    try testing.expectEqual(
        @as(?alert.Alert, .{ .level = .warning, .description = .user_canceled }),
        hs.lastPeerAlert(),
    );
}

// RFC 8446 §5.1 — a fragmented ClientHello without a caller-provided
// reassembly buffer is rejected with IncompleteRecord (maps to decode_error).
test "handleRecord: rejects fragmented ClientHello without reassembly buffer" {
    const client_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch_msg = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});

    // Split after the 4-byte handshake header so the record is shorter
    // than the handshake message.
    const split_at: usize = handshake_header_len;

    var rec1: [1024]u8 = undefined;
    const hdr1: frame.Header = .init(.handshake, @intCast(split_at));
    hdr1.write(rec1[0..frame.header_len]);
    @memcpy(rec1[frame.header_len..][0..split_at], ch_msg[0..split_at]);

    var hs: ServerHandshake = .init(try testConfig(.generate()));
    var out: [256]u8 = undefined;
    // No useHandshakeBuffer call — fragmentation must be rejected.
    try testing.expectError(
        error.IncompleteRecord,
        hs.handleRecord(rec1[0 .. frame.header_len + split_at], &out),
    );
}

// RFC 8446 §5.1 — a reassembled ClientHello whose content fails parsing resets
// reassembly state so the caller can retry with a fresh ClientHello.
test "handleRecord: state reset after invalid fragmented ClientHello" {
    const client_keypair: x25519.KeyPair = .generate();
    const server_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch_msg = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});

    // Split halfway through the body.
    const split_at = handshake_header_len + (ch_msg.len - handshake_header_len) / 2;

    var rec1: [1024]u8 = undefined;
    const hdr1: frame.Header = .init(.handshake, @intCast(split_at));
    hdr1.write(rec1[0..frame.header_len]);
    @memcpy(rec1[frame.header_len..][0..split_at], ch_msg[0..split_at]);

    var hs: ServerHandshake = .init(try testConfig(server_keypair));
    var reassembly: [1024]u8 = undefined;
    hs.useHandshakeBuffer(&reassembly);
    var out: [256]u8 = undefined;
    _ = try hs.handleRecord(rec1[0 .. frame.header_len + split_at], &out);

    // Fill the rest with garbage — assembles into an invalid CH.
    const remaining = ch_msg.len - split_at;
    var rec2: [1024]u8 = undefined;
    const hdr2: frame.Header = .init(.handshake, @intCast(remaining));
    hdr2.write(rec2[0..frame.header_len]);
    @memset(rec2[frame.header_len..][0..remaining], 0x00);

    // A parse error is expected; state must be reset regardless of which
    // malformed-extension check catches the all-zero tail first.
    if (hs.handleRecord(rec2[0 .. frame.header_len + remaining], &out)) |_| {
        return error.TestExpectedError;
    } else |err| switch (err) {
        error.DuplicateExtension, error.InvalidExtensionLength => {},
        else => return err,
    }

    // State reset verified: a fresh complete ClientHello should succeed.
    var record: [1024]u8 = undefined;
    const record_hdr: frame.Header = .init(.handshake, @intCast(ch_msg.len));
    record_hdr.write(record[0..frame.header_len]);
    @memcpy(record[frame.header_len..][0..ch_msg.len], ch_msg);
    _ = try hs.handleRecord(record[0 .. frame.header_len + ch_msg.len], &out);
}

// RFC 8446 §5.1 — extra handshake bytes after the completed fragmented
// ClientHello are not part of the ClientHello and must not be silently dropped.
test "handleRecord: rejects trailing bytes after fragmented ClientHello" {
    const client_keypair: x25519.KeyPair = .generate();
    const server_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch_msg = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    const split_at = handshake_header_len + (ch_msg.len - handshake_header_len) / 2;

    var rec1: [1024]u8 = undefined;
    const hdr1: frame.Header = .init(.handshake, @intCast(split_at));
    hdr1.write(rec1[0..frame.header_len]);
    @memcpy(rec1[frame.header_len..][0..split_at], ch_msg[0..split_at]);

    var hs: ServerHandshake = .init(try testConfig(server_keypair));
    var reassembly: [1024]u8 = undefined;
    hs.useHandshakeBuffer(&reassembly);
    var out: [256]u8 = undefined;
    _ = try hs.handleRecord(rec1[0 .. frame.header_len + split_at], &out);

    const remaining = ch_msg.len - split_at;
    const trailing = [_]u8{ @intFromEnum(HandshakeType.finished), 0, 0, 0 };
    var rec2: [1024]u8 = undefined;
    const hdr2: frame.Header = .init(.handshake, @intCast(remaining + trailing.len));
    hdr2.write(rec2[0..frame.header_len]);
    @memcpy(rec2[frame.header_len..][0..remaining], ch_msg[split_at..]);
    @memcpy(rec2[frame.header_len + remaining ..][0..trailing.len], &trailing);

    try testing.expectError(
        error.UnexpectedMessage,
        hs.handleRecord(rec2[0 .. frame.header_len + remaining + trailing.len], &out),
    );

    var record: [1024]u8 = undefined;
    const record_hdr: frame.Header = .init(.handshake, @intCast(ch_msg.len));
    record_hdr.write(record[0..frame.header_len]);
    @memcpy(record[frame.header_len..][0..ch_msg.len], ch_msg);
    _ = try hs.handleRecord(record[0 .. frame.header_len + ch_msg.len], &out);
}

// RFC 8446 §5.1 — after HelloRetryRequest, a ClientHello2 split across
// multiple records is reassembled and processed.
test "handleRecord: reassembles ClientHello2 split across records after HRR" {
    const client_keypair: x25519.KeyPair = .generate();
    const server_keypair: x25519.KeyPair = .generate();

    // CH1 with a non-X25519 key share triggers HRR.
    var ch1_buf: [512]u8 = undefined;
    const ch1 = try client_hello.encode(&ch1_buf, .zero, client_keypair.public_key, null, &.{});
    var hrr_ch1_buf: [512]u8 = undefined;
    const hrr_ch1 = clientHelloWithKeyShareGroup(
        &hrr_ch1_buf,
        ch1,
        0x6a6a,
    );
    var ch1_record: [1024]u8 = undefined;
    const ch1_header: frame.Header = .init(.handshake, @intCast(hrr_ch1.len));
    ch1_header.write(ch1_record[0..frame.header_len]);
    @memcpy(ch1_record[frame.header_len..][0..hrr_ch1.len], hrr_ch1);

    var hs: ServerHandshake = .init(try testConfig(server_keypair));
    var reassembly: [1024]u8 = undefined;
    hs.useHandshakeBuffer(&reassembly);
    var out: [256]u8 = undefined;
    _ = try hs.acceptClientHello(
        ch1_record[0 .. frame.header_len + hrr_ch1.len],
        &out,
    );
    try testing.expectEqual(.wait_ch, hs.state);

    // Dummy CCS after HRR.
    var ccs = [_]u8{ 0x14, 0x03, 0x03, 0x00, 0x01, 0x01 };
    try testing.expectEqual(Event.none, try hs.handleRecord(&ccs, &out));

    // CH2 with X25519 key share, split across records.
    var ch2_buf: [512]u8 = undefined;
    const ch2 = try client_hello.encode(&ch2_buf, .zero, client_keypair.public_key, null, &.{});
    const split_at = handshake_header_len + (ch2.len - handshake_header_len) / 2;

    var rec1: [1024]u8 = undefined;
    const hdr1: frame.Header = .init(.handshake, @intCast(split_at));
    hdr1.write(rec1[0..frame.header_len]);
    @memcpy(rec1[frame.header_len..][0..split_at], ch2[0..split_at]);

    const ev1 = try hs.handleRecord(rec1[0 .. frame.header_len + split_at], &out);
    try testing.expectEqual(Event.none, ev1);

    const remaining = ch2.len - split_at;
    var rec2: [1024]u8 = undefined;
    const hdr2: frame.Header = .init(.handshake, @intCast(remaining));
    hdr2.write(rec2[0..frame.header_len]);
    @memcpy(rec2[frame.header_len..][0..remaining], ch2[split_at..]);

    const ev2 = try hs.handleRecord(rec2[0 .. frame.header_len + remaining], &out);
    try testing.expectEqual(.wait_client_finished, hs.state);
    _ = ev2.write;
}

// RFC 8446 §5.1 — a client Finished handshake message fragmented across two
// encrypted records is reassembled and verified.
test "handleRecord: reassembles fragmented client Finished across encrypted records" {
    const client_keypair: x25519.KeyPair = try .generateDeterministic(.init(@splat(0x11)));
    const server_keypair: x25519.KeyPair = try .generateDeterministic(.init(@splat(0x22)));
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    var ch_record: [1024]u8 = undefined;
    const ch_header: frame.Header = .init(.handshake, @intCast(ch.len));
    ch_header.write(ch_record[0..frame.header_len]);
    @memcpy(ch_record[frame.header_len..][0..ch.len], ch);

    var server: ServerHandshake = .init(try testConfig(server_keypair));
    var sh_out: [256]u8 = undefined;
    _ = try server.acceptClientHello(ch_record[0 .. frame.header_len + ch.len], &sh_out);
    var flight_out: [512]u8 = undefined;
    _ = try server.sendAnonymousFlightForTest(&flight_out);

    // Encode the client Finished handshake message.
    var fin_plain: [64]u8 = undefined;
    const fin = switch (server.suite_state) {
        inline .sha256, .sha384 => |*s| blk: {
            const th = s.transcript.peek();
            break :blk try finished.encode(
                @TypeOf(s.transcript),
                &fin_plain,
                &s.client_finished_key.data,
                &th,
            );
        },
    };

    // Split the Finished after the 4-byte handshake header.
    // Record 1: handshake header (type + 3-byte length).
    // Record 2: verify_data body.
    const split_at: usize = handshake_header_len;

    var client_tx = try server.rx.clone();
    defer client_tx.deinit();
    var wire1: [128]u8 = undefined;
    const rec1 = try client_tx.encrypt(.handshake, fin[0..split_at], &wire1);
    var wire2: [128]u8 = undefined;
    const rec2 = try client_tx.encrypt(.handshake, fin[split_at..], &wire2);

    var out: [64]u8 = undefined;
    const ev1 = try server.handleRecord(wire1[0..rec1.len], &out);
    try testing.expectEqual(Event.none, ev1);
    try testing.expectEqual(.wait_client_finished, server.state);

    const ev2 = try server.handleRecord(wire2[0..rec2.len], &out);
    try testing.expectEqual(Event.none, ev2);
    try testing.expectEqual(.connected, server.state);
}

// RFC 8446 §5.1 — an interleaved non-handshake encrypted record while a
// Finished fragment is pending is rejected with UnexpectedMessage, which
// maps to a fatal unexpected_message alert.
test "handleRecord: rejects interleaved alert during Finished fragment reassembly" {
    const client_keypair: x25519.KeyPair = try .generateDeterministic(.init(@splat(0x11)));
    const server_keypair: x25519.KeyPair = try .generateDeterministic(.init(@splat(0x22)));
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    var ch_record: [1024]u8 = undefined;
    const ch_header: frame.Header = .init(.handshake, @intCast(ch.len));
    ch_header.write(ch_record[0..frame.header_len]);
    @memcpy(ch_record[frame.header_len..][0..ch.len], ch);

    var server: ServerHandshake = .init(try testConfig(server_keypair));
    var sh_out: [256]u8 = undefined;
    _ = try server.acceptClientHello(ch_record[0 .. frame.header_len + ch.len], &sh_out);
    var flight_out: [512]u8 = undefined;
    _ = try server.sendAnonymousFlightForTest(&flight_out);

    // Encode the client Finished and take the first 4 bytes (header only).
    var fin_plain: [64]u8 = undefined;
    const fin = switch (server.suite_state) {
        inline .sha256, .sha384 => |*s| blk: {
            const th = s.transcript.peek();
            break :blk try finished.encode(
                @TypeOf(s.transcript),
                &fin_plain,
                &s.client_finished_key.data,
                &th,
            );
        },
    };

    // First fragment: 4-byte handshake header only.
    var client_tx = try server.rx.clone();
    defer client_tx.deinit();
    var wire1: [128]u8 = undefined;
    const rec1 = try client_tx.encrypt(.handshake, fin[0..handshake_header_len], &wire1);

    // Encrypt a fatal interleaved alert with seq=1.
    var alert_msg: [2]u8 = undefined;
    _ = alert.encode(&alert_msg, .fatal, .unexpected_message) catch unreachable;
    var alert_wire: [64]u8 = undefined;
    const alert_rec = try client_tx.encrypt(.alert, &alert_msg, &alert_wire);

    var out: [64]u8 = undefined;
    const ev1 = try server.handleRecord(wire1[0..rec1.len], &out);
    try testing.expectEqual(Event.none, ev1);

    // The interleaved alert must be rejected with UnexpectedMessage.
    try testing.expectError(
        error.UnexpectedMessage,
        server.handleRecord(alert_wire[0..alert_rec.len], &out),
    );
    try testing.expectEqual(.wait_client_finished, server.state);
}

// RFC 8446 §5.1 — a plaintext outer record interleaved while a Finished
// fragment is pending is also rejected before normal CCS/alert handling.
test "handleRecord: rejects plaintext alert during Finished fragment reassembly" {
    const client_keypair: x25519.KeyPair = try .generateDeterministic(.init(@splat(0x11)));
    const server_keypair: x25519.KeyPair = try .generateDeterministic(.init(@splat(0x22)));
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    var ch_record: [1024]u8 = undefined;
    const ch_header: frame.Header = .init(.handshake, @intCast(ch.len));
    ch_header.write(ch_record[0..frame.header_len]);
    @memcpy(ch_record[frame.header_len..][0..ch.len], ch);

    var server: ServerHandshake = .init(try testConfig(server_keypair));
    var sh_out: [256]u8 = undefined;
    _ = try server.acceptClientHello(ch_record[0 .. frame.header_len + ch.len], &sh_out);
    var flight_out: [512]u8 = undefined;
    _ = try server.sendAnonymousFlightForTest(&flight_out);

    var fin_plain: [64]u8 = undefined;
    const fin = switch (server.suite_state) {
        inline .sha256, .sha384 => |*s| blk: {
            const th = s.transcript.peek();
            break :blk try finished.encode(
                @TypeOf(s.transcript),
                &fin_plain,
                &s.client_finished_key.data,
                &th,
            );
        },
    };

    var client_tx = try server.rx.clone();
    defer client_tx.deinit();
    var wire1: [128]u8 = undefined;
    const rec1 = try client_tx.encrypt(.handshake, fin[0..handshake_header_len], &wire1);
    var out: [64]u8 = undefined;
    try testing.expectEqual(Event.none, try server.handleRecord(wire1[0..rec1.len], &out));

    var alert_rec = [_]u8{ 0x15, 0x03, 0x03, 0x00, 0x02, 0x01, 0x00 };
    try testing.expectError(error.UnexpectedMessage, server.handleRecord(&alert_rec, &out));
}

// RFC 8446 §6.2 — an encrypted fatal alert while waiting for the client
// Finished aborts and records the peer's exact level/description (#85).
test "handleRecord: encrypted fatal alert while waiting for Finished records detail" {
    const client_keypair: x25519.KeyPair = try .generateDeterministic(.init(@splat(0x11)));
    const server_keypair: x25519.KeyPair = try .generateDeterministic(.init(@splat(0x22)));
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    var ch_record: [1024]u8 = undefined;
    const ch_header: frame.Header = .init(.handshake, @intCast(ch.len));
    ch_header.write(ch_record[0..frame.header_len]);
    @memcpy(ch_record[frame.header_len..][0..ch.len], ch);

    var server: ServerHandshake = .init(try testConfig(server_keypair));
    defer server.deinit();
    var sh_out: [256]u8 = undefined;
    _ = try server.acceptClientHello(ch_record[0 .. frame.header_len + ch.len], &sh_out);
    var flight_out: [512]u8 = undefined;
    _ = try server.sendAnonymousFlightForTest(&flight_out);

    var client_tx = try server.rx.clone();
    defer client_tx.deinit();
    var wire: [64]u8 = undefined;
    const fatal = [_]u8{ 0x02, 0x28 }; // fatal, handshake_failure
    const rec = try client_tx.encrypt(.alert, &fatal, &wire);

    var out: [64]u8 = undefined;
    try testing.expect(server.lastPeerAlert() == null);
    try testing.expectError(error.PeerAlert, server.handleRecord(wire[0..rec.len], &out));
    try testing.expectEqual(.wait_client_finished, server.state);
    try testing.expectEqual(
        @as(?alert.Alert, .{ .level = .fatal, .description = .handshake_failure }),
        server.lastPeerAlert(),
    );
}

// RFC 8446 §6 — once handshake traffic keys are installed, alerts are protected;
// a plaintext outer alert while waiting for client Finished is unexpected.
test "handleRecord: rejects plaintext alert while waiting for Finished" {
    const client_keypair: x25519.KeyPair = try .generateDeterministic(.init(@splat(0x11)));
    const server_keypair: x25519.KeyPair = try .generateDeterministic(.init(@splat(0x22)));
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    var ch_record: [1024]u8 = undefined;
    const ch_header: frame.Header = .init(.handshake, @intCast(ch.len));
    ch_header.write(ch_record[0..frame.header_len]);
    @memcpy(ch_record[frame.header_len..][0..ch.len], ch);

    var server: ServerHandshake = .init(try testConfig(server_keypair));
    var sh_out: [256]u8 = undefined;
    _ = try server.acceptClientHello(ch_record[0 .. frame.header_len + ch.len], &sh_out);
    var flight_out: [512]u8 = undefined;
    _ = try server.sendAnonymousFlightForTest(&flight_out);

    var alert_rec = [_]u8{ 0x15, 0x03, 0x03, 0x00, 0x02, 0x01, 0x00 };
    var out: [64]u8 = undefined;
    try testing.expectError(error.UnexpectedMessage, server.handleRecord(&alert_rec, &out));
}

// RFC 8446 §5.1 — encrypted handshake records must carry a non-empty
// handshake fragment while waiting for client Finished.
test "handleRecord: rejects zero-length encrypted handshake while waiting for Finished" {
    const client_keypair: x25519.KeyPair = try .generateDeterministic(.init(@splat(0x11)));
    const server_keypair: x25519.KeyPair = try .generateDeterministic(.init(@splat(0x22)));
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    var ch_record: [1024]u8 = undefined;
    const ch_header: frame.Header = .init(.handshake, @intCast(ch.len));
    ch_header.write(ch_record[0..frame.header_len]);
    @memcpy(ch_record[frame.header_len..][0..ch.len], ch);

    var server: ServerHandshake = .init(try testConfig(server_keypair));
    var sh_out: [256]u8 = undefined;
    _ = try server.acceptClientHello(ch_record[0 .. frame.header_len + ch.len], &sh_out);
    var flight_out: [512]u8 = undefined;
    _ = try server.sendAnonymousFlightForTest(&flight_out);

    var client_tx = try server.rx.clone();
    defer client_tx.deinit();
    var wire: [64]u8 = undefined;
    const rec = try client_tx.encrypt(.handshake, "", &wire);

    var out: [64]u8 = undefined;
    try testing.expectError(
        error.UnexpectedMessage,
        server.handleRecord(wire[0..rec.len], &out),
    );
}

// RFC 8446 §5.1 — handshake header (first 4 bytes of the handshake message)
// may itself be split across TLS records. The server buffers partial header
// bytes until enough have arrived to validate the handshake type and compute
// the expected total message length.
test "handleRecord: reassembles ClientHello when handshake header is split after 1 byte" {
    const client_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch_msg = try client_hello.encode(
        &ch_buf,
        .zero,
        client_keypair.public_key,
        "example.com",
        &.{"h2"},
    );

    var hs: ServerHandshake = .init(try testConfig(.generate()));
    var reassembly: [1024]u8 = undefined;
    hs.useHandshakeBuffer(&reassembly);
    var out: [256]u8 = undefined;

    // Record 1: just the first byte of the handshake header (handshake type = 0x01).
    var rec1: [1024]u8 = undefined;
    const hdr1: frame.Header = .init(.handshake, 1);
    hdr1.write(rec1[0..frame.header_len]);
    rec1[frame.header_len] = ch_msg[0]; // handshake type byte
    const ev1 = try hs.handleRecord(rec1[0 .. frame.header_len + 1], &out);
    try testing.expectEqual(Event.none, ev1);

    // Record 2: remaining 3 bytes of handshake header plus the full body.
    const remaining = ch_msg.len - 1;
    var rec2: [1024]u8 = undefined;
    const hdr2: frame.Header = .init(.handshake, @intCast(remaining));
    hdr2.write(rec2[0..frame.header_len]);
    @memcpy(rec2[frame.header_len..][0..remaining], ch_msg[1..]);
    const ev2 = try hs.handleRecord(rec2[0 .. frame.header_len + remaining], &out);
    try testing.expectEqual(.wait_client_finished, hs.state);
    _ = ev2.write;
}

// RFC 8446 §5.1 — a fragmented KeyUpdate (RECORD_LENGTH=1 style) is
// reassembled across handshake records and processed correctly.
test "handleRecord: server reassembles 1-byte fragmented KeyUpdate(update_requested)" {
    var server = try connectedTestServer();
    var client_tx = try server.rx.clone();
    defer client_tx.deinit();
    var server_tx_old = try server.tx.clone();
    defer server_tx_old.deinit();

    const ku_type = @intFromEnum(HandshakeType.key_update);
    const ku_req = @intFromEnum(KeyUpdateRequest.update_requested);
    const ku_parts = [_][]const u8{
        &[_]u8{ku_type},
        &[_]u8{0x00},
        &[_]u8{0x00},
        &[_]u8{0x01},
        &[_]u8{ku_req},
    };

    var out: [256]u8 = undefined;
    var rx_buf: [512]u8 = undefined;

    // Feed first 4 bytes — server accumulates in ku_frag, returns .none.
    for (ku_parts[0..4]) |part| {
        var wire_buf: [64]u8 = undefined;
        const wire = try client_tx.encrypt(.handshake, part, &wire_buf);
        @memcpy(rx_buf[0..wire.len], wire);
        const ev = try server.handleRecord(rx_buf[0..wire.len], &out);
        try testing.expectEqual(Event.none, ev);
    }

    // Feed final byte — server completes reassembly and responds.
    {
        var wire_buf: [64]u8 = undefined;
        const wire = try client_tx.encrypt(.handshake, ku_parts[4], &wire_buf);
        @memcpy(rx_buf[0..wire.len], wire);
        const ev = try server.handleRecord(rx_buf[0..wire.len], &out);
        try testing.expect(ev == .key_update);
        try testing.expectEqual(true, ev.key_update.rx);
        try testing.expectEqual(true, ev.key_update.tx);
        const resp = ev.key_update.response.?;
        var resp_buf: [64]u8 = undefined;
        @memcpy(resp_buf[0..resp.len], resp);

        // Response: KeyUpdate(update_not_requested), encrypted under OLD tx key.
        const dec = try server_tx_old.decrypt(resp_buf[0..resp.len]);
        try testing.expectEqual(.handshake, dec.content_type);
        try testing.expectEqualSlices(u8, &.{
            @intFromEnum(HandshakeType.key_update),              0x00, 0x00, 0x01,
            @intFromEnum(KeyUpdateRequest.update_not_requested),
        }, dec.content);
        server.completeWrite();
    }

    // Server rx keys ratcheted; app data under new client key must decrypt.
    var client_tx_1 = try server.rx.clone();
    defer client_tx_1.deinit();
    var app_buf: [64]u8 = undefined;
    const app_wire = try client_tx_1.encrypt(.application_data, "after", &app_buf);
    var app_rx: [64]u8 = undefined;
    @memcpy(app_rx[0..app_wire.len], app_wire);
    const ev_after = try server.handleRecord(app_rx[0..app_wire.len], &out);
    try testing.expectEqualSlices(u8, "after", ev_after.application_data);
}

// RFC 8446 §4.6.3 — fragmented KeyUpdate(update_not_requested) ratchets only
// the receive key with no response.
test "handleRecord: fragmented KeyUpdate(update_not_requested) works" {
    var server = try connectedTestServer();
    var client_tx = try server.rx.clone();
    defer client_tx.deinit();

    const ku_type = @intFromEnum(HandshakeType.key_update);
    const ku_nr = @intFromEnum(KeyUpdateRequest.update_not_requested);
    const ku_parts = [_][]const u8{
        &[_]u8{ku_type},
        &[_]u8{0x00},
        &[_]u8{0x00},
        &[_]u8{0x01},
        &[_]u8{ku_nr},
    };

    var out: [256]u8 = undefined;
    var rx_buf: [512]u8 = undefined;

    for (ku_parts[0..]) |part| {
        var wire_buf: [64]u8 = undefined;
        const wire = try client_tx.encrypt(.handshake, part, &wire_buf);
        @memcpy(rx_buf[0..wire.len], wire);
        const ev = try server.handleRecord(rx_buf[0..wire.len], &out);
        // The final fragment completes the KeyUpdate and surfaces as
        // key_update with rx=true, tx=false, response=null. Earlier
        // fragments return .none while reassembly is in progress.
        if (ev == .key_update) {
            try testing.expectEqual(true, ev.key_update.rx);
            try testing.expectEqual(false, ev.key_update.tx);
            try testing.expectEqual(@as(?[]const u8, null), ev.key_update.response);
        } else {
            try testing.expectEqual(Event.none, ev);
        }
    }

    // Server rx ratcheted; app data under new key works.
    var client_tx_1 = try server.rx.clone();
    defer client_tx_1.deinit();
    var app_buf: [64]u8 = undefined;
    const app_wire = try client_tx_1.encrypt(.application_data, "data", &app_buf);
    var app_rx: [64]u8 = undefined;
    @memcpy(app_rx[0..app_wire.len], app_wire);
    const ev_after = try server.handleRecord(app_rx[0..app_wire.len], &out);
    try testing.expectEqualSlices(u8, "data", ev_after.application_data);
}

// RFC 8446 §5.1 — a non-KeyUpdate handshake fragment must be rejected.
test "handleRecord: non-KeyUpdate fragment starts are rejected" {
    var server = try connectedTestServer();
    var client_tx = try server.rx.clone();
    defer client_tx.deinit();

    const bad_type: u8 = @intFromEnum(HandshakeType.finished);
    var wire_buf: [64]u8 = undefined;
    const wire = try client_tx.encrypt(.handshake, &[_]u8{bad_type}, &wire_buf);

    var out: [256]u8 = undefined;
    const result = server.handleRecord(wire, &out);
    try testing.expectError(error.UnexpectedMessage, result);
}

// RFC 8446 §5.1 — a KeyUpdate immediately preceding a key change must align
// with a record boundary and is rejected before ratcheting if trailing bytes
// share its record.
test "handleRecord: KeyUpdate with trailing record bytes is rejected before ratchet" {
    var server = try connectedTestServer();
    var client_tx = try server.rx.clone();
    defer client_tx.deinit();

    const ku_type = @intFromEnum(HandshakeType.key_update);
    const ku_nr = @intFromEnum(KeyUpdateRequest.update_not_requested);
    const bad = [_]u8{ ku_type, 0x00, 0x00, 0x01, ku_nr, 0xff };

    var wire_buf: [128]u8 = undefined;
    const wire = try client_tx.encrypt(.handshake, &bad, &wire_buf);
    var rx_buf: [128]u8 = undefined;
    @memcpy(rx_buf[0..wire.len], wire);
    var out: [256]u8 = undefined;
    try testing.expectError(
        error.UnexpectedMessage,
        server.handleRecord(rx_buf[0..wire.len], &out),
    );
    try testing.expectEqual(@as(usize, 0), server.ku_frag.len);

    const app_wire = try client_tx.encrypt(.application_data, "old epoch", &wire_buf);
    @memcpy(rx_buf[0..app_wire.len], app_wire);
    const ev = try server.handleRecord(rx_buf[0..app_wire.len], &out);
    try testing.expectEqualSlices(u8, "old epoch", ev.application_data);
}

// RFC 8446 §5.1 — interleaving application data during fragment reassembly
// is rejected and clears the fragment state.
test "handleRecord: app-data interleaving during KeyUpdate reassembly is rejected" {
    var server = try connectedTestServer();
    var client_tx = try server.rx.clone();
    defer client_tx.deinit();

    const ku_type = @intFromEnum(HandshakeType.key_update);
    var wire_buf: [64]u8 = undefined;
    const wire = try client_tx.encrypt(.handshake, &[_]u8{ku_type}, &wire_buf);
    var out: [256]u8 = undefined;
    var rx_buf: [512]u8 = undefined;
    @memcpy(rx_buf[0..wire.len], wire);
    _ = try server.handleRecord(rx_buf[0..wire.len], &out);
    try testing.expectEqual(@as(usize, 1), server.ku_frag.len);

    const app_wire = try client_tx.encrypt(.application_data, "nope", &wire_buf);
    @memcpy(rx_buf[0..app_wire.len], app_wire);
    try testing.expectError(
        error.UnexpectedMessage,
        server.handleRecord(rx_buf[0..app_wire.len], &out),
    );
    try testing.expectEqual(@as(usize, 0), server.ku_frag.len);
}

// RFC 8446 §5.1 — direct application-data receive must preserve the same
// fragmented-KeyUpdate record interlock as handleRecord.
test "receiveApplicationData: app-data interleaving during KeyUpdate reassembly is rejected" {
    var server = try connectedTestServer();
    var client_tx = try server.rx.clone();
    defer client_tx.deinit();

    const ku_type = @intFromEnum(HandshakeType.key_update);
    var wire_buf: [64]u8 = undefined;
    const wire = try client_tx.encrypt(.handshake, &[_]u8{ku_type}, &wire_buf);
    var out: [256]u8 = undefined;
    _ = try server.handleRecord(wire, &out);
    try testing.expectEqual(@as(usize, 1), server.ku_frag.len);

    const app_wire = try client_tx.encrypt(.application_data, "nope", &wire_buf);
    try testing.expectError(error.UnexpectedRecord, server.receiveApplicationData(app_wire));
    try testing.expectEqual(@as(usize, 1), server.ku_frag.len);
}

// RFC 8446 §5.1 — interleaving an alert during fragment reassembly is rejected
// before alert handling and clears the fragment state.
test "handleRecord: alert interleaving during KeyUpdate reassembly is rejected" {
    var server = try connectedTestServer();
    var client_tx = try server.rx.clone();
    defer client_tx.deinit();

    const ku_type = @intFromEnum(HandshakeType.key_update);
    var wire_buf: [64]u8 = undefined;
    const wire = try client_tx.encrypt(.handshake, &[_]u8{ku_type}, &wire_buf);
    var out: [256]u8 = undefined;
    var rx_buf: [512]u8 = undefined;
    @memcpy(rx_buf[0..wire.len], wire);
    _ = try server.handleRecord(rx_buf[0..wire.len], &out);
    try testing.expectEqual(@as(usize, 1), server.ku_frag.len);

    var alert_msg: [2]u8 = undefined;
    _ = alert.encode(&alert_msg, .fatal, .unexpected_message) catch unreachable;
    const alert_wire = try client_tx.encrypt(.alert, &alert_msg, &wire_buf);
    @memcpy(rx_buf[0..alert_wire.len], alert_wire);
    try testing.expectError(
        error.UnexpectedMessage,
        server.handleRecord(rx_buf[0..alert_wire.len], &out),
    );
    try testing.expectEqual(@as(usize, 0), server.ku_frag.len);
}

// RFC 8446 §6.1/§6.2 — connected close_notify is a clean close and never sets
// lastPeerAlert; a connected fatal alert records its exact level/description
// for the caller to log after error.PeerAlert (#85).
test "handleRecord: connected close_notify is clean, fatal alert records detail" {
    var server = try connectedTestServer();
    defer server.deinit();
    var client_tx = try server.rx.clone();
    defer client_tx.deinit();
    var out: [64]u8 = undefined;
    var rx_buf: [64]u8 = undefined;
    var wire_buf: [64]u8 = undefined;

    try testing.expect(server.lastPeerAlert() == null);
    const close_notify = [_]u8{ 0x01, 0x00 }; // warning, close_notify
    const close_rec = try client_tx.encrypt(.alert, &close_notify, &wire_buf);
    @memcpy(rx_buf[0..close_rec.len], close_rec);
    try testing.expectEqual(
        Event.closed,
        try server.handleRecord(rx_buf[0..close_rec.len], &out),
    );
    try testing.expect(server.lastPeerAlert() == null);

    const fatal = [_]u8{ 0x02, 0x0a }; // fatal, unexpected_message
    const fatal_rec = try client_tx.encrypt(.alert, &fatal, &wire_buf);
    @memcpy(rx_buf[0..fatal_rec.len], fatal_rec);
    try testing.expectError(error.PeerAlert, server.handleRecord(rx_buf[0..fatal_rec.len], &out));
    try testing.expectEqual(
        @as(?alert.Alert, .{ .level = .fatal, .description = .unexpected_message }),
        server.lastPeerAlert(),
    );
}

// RFC 8446 §5.1 — a zero-length encrypted handshake record during fragment
// reassembly is rejected and clears the fragment state.
test "handleRecord: zero-length handshake during KeyUpdate reassembly is rejected" {
    var server = try connectedTestServer();
    var client_tx = try server.rx.clone();
    defer client_tx.deinit();

    const ku_type = @intFromEnum(HandshakeType.key_update);
    var wire_buf: [64]u8 = undefined;
    const wire = try client_tx.encrypt(.handshake, &[_]u8{ku_type}, &wire_buf);
    var out: [256]u8 = undefined;
    var rx_buf: [512]u8 = undefined;
    @memcpy(rx_buf[0..wire.len], wire);
    _ = try server.handleRecord(rx_buf[0..wire.len], &out);
    try testing.expectEqual(@as(usize, 1), server.ku_frag.len);

    const empty_wire = try client_tx.encrypt(.handshake, "", &wire_buf);
    @memcpy(rx_buf[0..empty_wire.len], empty_wire);
    try testing.expectError(
        error.UnexpectedMessage,
        server.handleRecord(rx_buf[0..empty_wire.len], &out),
    );
    try testing.expectEqual(@as(usize, 0), server.ku_frag.len);
}

// RFC 8446 §4.1.2 — the 3-byte handshake message body-length field is
// attacker-controlled. A body_len of 0xFFFFFF must be rejected by the
// `total > buffer.len` bounds check, not overflow u24 arithmetic before it.
// Regression for the #72 narrow-arithmetic class (audit S6, site 1):
// line ~1467 evaluated `handshake_header_len + body_len` in u24.
test "handleRecord: ClientHello body_len 0xFFFFFF rejected without overflow (fast path)" {
    var hs: ServerHandshake = .init(try testConfig(.generate()));
    var out: [64]u8 = undefined;
    // 16 03 03 00 04 = handshake record, 4-byte body.
    // 01 FF FF FF = ClientHello, body length 0xFFFFFF (overflows u24 when
    // added to the 4-byte header before the bounds check).
    var rec = [_]u8{ 0x16, 0x03, 0x03, 0x00, 0x04, 0x01, 0xFF, 0xFF, 0xFF };
    try testing.expectError(error.IncompleteRecord, hs.handleRecord(&rec, &out));
}

// RFC 8446 §4.1.2, §5.1 — the split-header reassembly path assembles the
// 4-byte handshake header across records, then computes the expected total
// from the assembled body_len. A body_len of 0xFFFFFF must be rejected by
// the `ch_expected > buffer.len` check, not overflow u24 at the addition.
// Regression for the #72 narrow-arithmetic class (audit S6, site 2):
// line ~1423 evaluated `handshake_header_len + body_len_assembled` in u24.
test "handleRecord: split-header reassembly body_len 0xFFFFFF rejected without overflow" {
    var hs: ServerHandshake = .init(try testConfig(.generate()));
    var reassembly: [1024]u8 = undefined;
    hs.useHandshakeBuffer(&reassembly);
    var out: [256]u8 = undefined;

    // Record 1: 3 bytes of the handshake header (type + first 2 len bytes).
    // body.len < handshake_header_len → buffered, ch_expected stays 0.
    var rec1 = [_]u8{ 0x16, 0x03, 0x03, 0x00, 0x03, 0x01, 0xFF, 0xFF };
    try testing.expectEqual(Event.none, try hs.handleRecord(&rec1, &out));
    try testing.expectEqual(@as(usize, 0), hs.ch_expected);

    // Record 2: final header byte 0xFF → assembled header 01 FF FF FF,
    // body_len_assembled = 0xFFFFFF. The addition must not overflow u24.
    var rec2 = [_]u8{ 0x16, 0x03, 0x03, 0x00, 0x01, 0xFF };
    try testing.expectError(error.IncompleteRecord, hs.handleRecord(&rec2, &out));
}

// #81 — same contract as the client: the ClientHello reassembly buffer is lent,
// so `deinit` zeroes its own inline secrets and leaves this alone.
test "deinit leaves caller-owned buffers to the caller" {
    var reassembly: [ch_reassembly_buffer_size]u8 = @splat(0xc7);

    var hs: ServerHandshake = .init(try testConfig(.generate()));
    hs.useHandshakeBuffer(&reassembly);
    hs.deinit();

    try testing.expect(std.mem.allEqual(u8, &reassembly, 0xc7));
}
