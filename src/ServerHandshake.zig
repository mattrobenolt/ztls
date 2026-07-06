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
const array_buffer = @import("array_buffer.zig");
const ArrayBuffer = array_buffer.ArrayBuffer;
const SliceBuffer = array_buffer.SliceBuffer;
const certificate = @import("certificate.zig");
const CertificateChain = @import("certificate_chain.zig").CertificateChain;
const client_hello = @import("client_hello.zig");
const ClientHandshake = @import("ClientHandshake.zig");
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
const KeyUpdateRequest = handshake.KeyUpdateRequest;
const max_post_handshake_messages = handshake.max_post_handshake_messages;
const HashArm = @import("suite_state.zig").HashArm;
const hkdf = @import("hkdf.zig");
const memx = @import("memx.zig");
const NamedGroup = @import("kex.zig").NamedGroup;
const p256 = @import("p256.zig");
const handshake_key_pairs = @import("handshake_key_pairs.zig");
const p384 = @import("p384.zig");
const PendingWrite = @import("pending_write.zig").PendingWrite;
const RecordLayer = @import("RecordLayer.zig");
const root = @import("root.zig");
const CipherSuite = root.CipherSuite;
const Random = root.Random;
const server_hello = @import("server_hello.zig");
const signature = @import("signature.zig");
pub const SignError = signature.SignError;
pub const Signer = signature.Signer;
const shared_fixtures = @import("test_fixtures/shared_fixtures.zig");
const transcript_util = @import("transcript.zig");
const x25519 = @import("x25519.zig");

const HandshakeBuffer = SliceBuffer(u8);
const FinishedFragmentBuffer = ArrayBuffer(u8, handshake_header_len + 48);
const key_update_body_len = 1;
const key_update_total_len = handshake_header_len + key_update_body_len;
const KeyUpdateFragmentBuffer = ArrayBuffer(u8, key_update_total_len);
const ServerHandshake = @This();

pub const State = enum {
    wait_ch,
    wait_client_finished,
    connected,
};

const RetryTranscript = union(enum) {
    sha256: Sha256,
    sha384: Sha384,
};

const Suite = union(enum) {
    sha256: HashArm(hkdf.HkdfSha256, Sha256),
    sha384: HashArm(hkdf.HkdfSha384, Sha384),

    fn secureZero(self: *Suite) void {
        switch (self.*) {
            inline .sha256, .sha384 => |*s| s.secureZero(),
        }
    }

    fn update(self: *Suite, msg: []const u8) void {
        switch (self.*) {
            inline .sha256, .sha384 => |*s| s.transcript.update(msg),
        }
    }

    pub fn ratchetClientKey(self: *Suite) aead.Error!RecordLayer {
        return switch (self.*) {
            inline .sha256, .sha384 => |*s| s.ratchetClientKey(),
        };
    }

    pub fn ratchetServerKey(self: *Suite) aead.Error!RecordLayer {
        return switch (self.*) {
            inline .sha256, .sha384 => |*s| s.ratchetServerKey(),
        };
    }
};

const ClientKeyShare = union(enum) {
    x25519: x25519.PublicKey,
    secp256r1: p256.PublicKey,
    secp384r1: p384.PublicKey,
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

pub const Config = struct {
    /// Ephemeral keypairs used for ServerHello key_share entries. X25519 and
    /// P-256 are present by default; P-384 is opt-in.
    keypairs: KeyPairs,
    /// ServerHello random field (RFC 8446 §4.1.3). Stored and used once.
    random: Random,
    /// Cipher suites offered by this server, in server preference order.
    supported_suites: []const CipherSuite = default_supported_suites,
    /// ALPN protocols supported by this server. Caller-owned.
    alpn_protocols: root.AlpnProtocols = &.{},
    /// Optional caller-owned ClientHello reassembly storage.
    reassembly: ?[]u8 = null,
};

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
alpn_protocols: root.AlpnProtocols = &.{},
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
post_handshake_count: u8 = 0,
retry_transcript: ?RetryTranscript = null,
retry_selected_group: ?NamedGroup = null,
/// Caller-owned certificate DER slices and signer used for the authenticated
/// server flight. The DER bytes, slice-of-slices, and PrivateKey backing the
/// Signer must outlive this handshake. ztls stores references and does not copy
/// or own credential memory.
server_credentials: ?ServerCredentials = null,
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
        .alpn_protocols = config.alpn_protocols,
        .ch_buf = if (config.reassembly) |buf| .init(buf) else .empty,
    };
}

pub fn deinit(self: *ServerHandshake) void {
    switch (self.state) {
        .wait_client_finished, .connected => {
            self.rx.deinit();
            self.tx.deinit();
        },
        .wait_ch => {},
    }
    switch (self.state) {
        .wait_client_finished, .connected => self.suite_state.secureZero(),
        .wait_ch => {},
    }
    self.keypairs.secureZero();
    self.fin_frag.secureZero();
    self.ku_frag.secureZero();
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
pub fn useHandshakeBuffer(self: *ServerHandshake, storage: []u8) void {
    assert(self.state == .wait_ch);
    assert(self.ch_buf.len == 0);
    self.ch_buf = .init(storage);
}

pub fn selectedAlpnProtocol(self: *const ServerHandshake) ?[]const u8 {
    return self.selected_alpn;
}

/// Return the SNI hostname from the ClientHello server_name extension, or null
/// if the client did not send one. Available after the first handleRecord/
/// acceptClientHello call returns. Points into the caller's record buffer —
/// copy before the next call if you need it longer.
///
/// RFC 6066 §3 — server_name extension.
pub fn clientServerName(self: *const ServerHandshake) ?[]const u8 {
    return self.client_server_name;
}

pub fn completeWrite(self: *ServerHandshake) void {
    self.pending_write.clear();
}

pub fn isConnected(self: *const ServerHandshake) bool {
    return self.state == .connected;
}

pub fn needsServerFlight(self: *const ServerHandshake) bool {
    return self.state == .wait_client_finished;
}

pub const Event = union(enum) {
    application_data: []const u8,
    write: []const u8,
    none,
    closed,
};

pub const AcceptError =
    frame.ParseError || client_hello.ParseError || server_hello.EncodeError || aead.Error || error{
        IncompleteRecord,
        UnexpectedRecord,
        UnsupportedCipherSuite,
        NoApplicationProtocol,
        IdentityElement,
        IllegalParameter,
        LibcryptoFailed,
    };

pub const FlightError =
    encrypted_extensions.EncodeError ||
    certificate.EncodeError ||
    RecordLayer.EncryptError ||
    SignError ||
    error{ MissingServerCredentials, PendingWrite };

pub const ClientFinishedError =
    RecordLayer.DecryptError || finished.VerifyError || frame.ParseError || error{
        UnexpectedRecord,
        UnexpectedMessage,
    };

pub const SendError = RecordLayer.EncryptError || error{PendingWrite};
pub const ReceiveError =
    RecordLayer.DecryptError || SendError || alert.ParseError ||
    error{ UnexpectedEof, UnexpectedRecord, UnexpectedMessage, IllegalParameter } ||
    error{ TooManyKeyUpdates, PeerAlert };
pub const HandleError =
    AcceptError || FlightError || ClientFinishedError ||
    ReceiveError || alert.ParseError || error{PendingWrite};
pub const AlertError = RecordLayer.EncryptError || error{ BufferTooShort, PendingWrite };

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
        error.MissingExtension,
        error.MissingSignatureAlgorithmsExtension,
        => .missing_extension,
        error.UnsupportedExtension => .unsupported_extension,
        error.UnsupportedTlsVersion => .protocol_version,
        error.UnsupportedCipherSuite,
        error.UnsupportedKeyShare,
        => .handshake_failure,
        error.NoApplicationProtocol => .no_application_protocol,
        error.DuplicateExtension,
        error.DuplicateKeyShare,
        error.InvalidCompressionMethod,
        error.UnexpectedCertificateRequestContext,
        error.UnexpectedExtension,
        error.IllegalParameter,
        error.IdentityElement,
        error.MalformedKeyShare,
        error.UnofferedAlpnProtocol,
        error.UnsupportedSignatureScheme,
        => .illegal_parameter,
        error.InvalidHandshakeType,
        error.UnexpectedRecord,
        error.UnexpectedMessage,
        => .unexpected_message,
        else => .internal_error,
    };
}

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
fn processClientHelloMessage(
    self: *ServerHandshake,
    ch_msg: []const u8,
    out: []u8,
) AcceptError![]const u8 {
    assert(self.state == .wait_ch);
    const ch = try client_hello.parse(ch_msg);
    const suite = if (self.retry_transcript == null)
        self.chooseSuite(ch) orelse return error.UnsupportedCipherSuite
    else
        self.suite;
    self.suite = suite;
    self.selected_alpn = ch.selectAlpn(self.alpn_protocols);
    if (ch.alpn_protocols.len != 0 and self.alpn_protocols.len != 0 and self.selected_alpn == null)
        return error.NoApplicationProtocol;
    self.client_server_name = ch.server_name;

    const client_key_share: ClientKeyShare = if (self.retry_selected_group) |selected_group|
        switch (selected_group) {
            .x25519 => if (backend.supportsServerX25519()) blk: {
                if (ch.public_key) |public_key| {
                    if (ch.public_key_p256 != null) return error.IllegalParameter;
                    if (ch.public_key_p384 != null) return error.IllegalParameter;
                    break :blk .{ .x25519 = public_key };
                }
                return error.IllegalParameter;
            } else return error.IllegalParameter,
            .secp256r1 => if (backend.supportsServerP256()) blk: {
                if (ch.public_key_p256) |public_key| {
                    if (ch.public_key != null) return error.IllegalParameter;
                    if (ch.public_key_p384 != null) return error.IllegalParameter;
                    break :blk .{ .secp256r1 = public_key };
                }
                return error.IllegalParameter;
            } else return error.IllegalParameter,
            .secp384r1 => if ((backend.supportsServerP384() and self.keypairs.p384 != null)) blk: {
                if (ch.public_key_p384) |public_key| {
                    if (ch.public_key != null) return error.IllegalParameter;
                    if (ch.public_key_p256 != null) return error.IllegalParameter;
                    break :blk .{ .secp384r1 = public_key };
                }
                return error.IllegalParameter;
            } else return error.IllegalParameter,
            else => return error.IllegalParameter,
        }
    else if (ch.public_key != null and backend.supportsServerX25519())
        .{ .x25519 = ch.public_key.? }
    else if (ch.public_key_p256 != null and backend.supportsServerP256())
        .{ .secp256r1 = ch.public_key_p256.? }
    else if (ch.public_key_p384 != null and
        (backend.supportsServerP384() and self.keypairs.p384 != null))
        .{ .secp384r1 = ch.public_key_p384.? }
    else if (ch.groups.contains(.x25519) and backend.supportsServerX25519()) {
        const hrr = try self.encodeHelloRetryRequest(
            ch_msg,
            ch.legacy_session_id,
            suite,
            .x25519,
            out,
        );
        self.state = .wait_ch;
        return hrr;
    } else if (ch.groups.contains(.secp256r1) and backend.supportsServerP256()) {
        const hrr = try self.encodeHelloRetryRequest(
            ch_msg,
            ch.legacy_session_id,
            suite,
            .secp256r1,
            out,
        );
        self.state = .wait_ch;
        return hrr;
    } else if (ch.groups.contains(.secp384r1) and
        (backend.supportsServerP384() and self.keypairs.p384 != null))
    {
        const hrr = try self.encodeHelloRetryRequest(
            ch_msg,
            ch.legacy_session_id,
            suite,
            .secp384r1,
            out,
        );
        self.state = .wait_ch;
        return hrr;
    } else return error.UnsupportedKeyShare;

    self.negotiated_group = switch (client_key_share) {
        .x25519 => .x25519,
        .secp256r1 => .secp256r1,
        .secp384r1 => .secp384r1,
    };
    const server_key_share: server_hello.KeyShare = switch (client_key_share) {
        .x25519 => .{ .x25519 = self.keypairs.x25519.public_key },
        .secp256r1 => .{ .secp256r1 = self.keypairs.p256.public_key },
        .secp384r1 => .{ .secp384r1 = (self.keypairs.p384 orelse unreachable).public_key },
    };

    const sh = try server_hello.encodeWithKeyShare(
        out[frame.header_len..],
        self.random.data,
        ch.legacy_session_id,
        suite,
        server_key_share,
    );
    const header: frame.Header = .init(.handshake, @intCast(sh.len));
    header.write(out[0..frame.header_len]);

    var out_len = frame.header_len + sh.len;
    if (ch.legacy_session_id.len != 0) {
        out_len += try appendCompatibilityChangeCipherSpec(out[out_len..]);
    }

    try self.installHandshakeKeys(suite, ch_msg, sh, client_key_share);
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
    legacy_session_id: []const u8,
    suite: CipherSuite,
    selected_group: NamedGroup,
    out: []u8,
) server_hello.EncodeError![]const u8 {
    const hrr = try server_hello.encodeHelloRetryRequest(
        out[frame.header_len..],
        legacy_session_id,
        suite,
        selected_group,
    );
    const header: frame.Header = .init(.handshake, @intCast(hrr.len));
    header.write(out[0..frame.header_len]);
    self.retry_transcript = makeRetryTranscript(suite, ch_msg, hrr);
    self.retry_selected_group = selected_group;
    var out_len = frame.header_len + hrr.len;
    if (legacy_session_id.len != 0) {
        out_len += try appendCompatibilityChangeCipherSpec(out[out_len..]);
    }
    return out[0..out_len];
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
    client_key_share: ClientKeyShare,
) (error{ IdentityElement, LibcryptoFailed } || aead.Error)!void {
    var dhe: [48]u8 = undefined;
    const dhe_len: usize = switch (client_key_share) {
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
            self.suite_state = .{ .sha256 = makeHandshakeArm(
                hkdf.HkdfSha256,
                Sha256,
                transcript,
                suite,
                dhe[0..dhe_len],
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
            ) };
        },
    }
    self.retry_transcript = null;
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
) HashArm(H, Hash) {
    var handshake_secret = H.handshakeSecret(H.early_secret, dhe);
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
    var plaintext: [256]u8 = undefined;
    var pos: usize = 0;
    const ee = try encrypted_extensions.encode(plaintext[pos..], self.selected_alpn);
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
            pos += fin.len;
        },
    }
    return self.tx.encrypt(.handshake, plaintext[0..pos], out);
}

/// Emit an authenticated encrypted server flight: EncryptedExtensions,
/// Certificate, CertificateVerify, Finished. The signer receives the exact TLS
/// 1.3 CertificateVerify input (`64*SP || context || 0 || transcript_hash`) and
/// writes a DER signature into caller-provided scratch. RFC 8446 §4.3-§4.4.
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
    const flight = try self.encodeAuthenticatedFlight(chain, signer, plaintext);
    return self.tx.encrypt(.handshake, flight, out);
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
    if (out.len < frame.header_len) return error.BufferTooShort;
    const flight = try self.encodeAuthenticatedFlight(chain, signer, out[frame.header_len..]);
    return self.tx.encryptPrepared(.handshake, flight.len, out);
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

/// Emit the configured authenticated server flight once it is ready.
/// Returns null before ServerHello has installed handshake keys, or after the
/// flight has already been emitted. A non-null result sets the pending-write
/// latch; callers must write the returned bytes and then call completeWrite().
// ziglint-ignore: Z015 -- FlightError is a public error-set alias.
pub fn sendPreparedServerFlight(self: *ServerHandshake, out: []u8) FlightError!?[]const u8 {
    if (self.pending_write.isPending()) return error.PendingWrite;
    if (self.state != .wait_client_finished or self.server_flight_sent) return null;
    const credentials = self.server_credentials orelse return error.MissingServerCredentials;
    if (out.len < frame.header_len) return error.BufferTooShort;
    const flight = try self.encodeAuthenticatedFlight(
        credentials.chain,
        credentials.signer,
        out[frame.header_len..],
    );
    const record = try self.tx.encryptPrepared(.handshake, flight.len, out);
    self.server_flight_sent = true;
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

    const ee = try encrypted_extensions.encode(plaintext[pos..], self.selected_alpn);
    self.suite_state.update(ee);
    pos += ee.len;

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
            pos += fin.len;
        },
    }
    return plaintext[0..pos];
}

/// Consume the client's encrypted Finished, verify it against the transcript
/// through server Finished, then install application traffic keys. RFC 8446
/// §4.4.4, §7.1.
// ziglint-ignore: Z015 -- ClientFinishedError is a public error-set alias.
pub fn processClientFinished(self: *ServerHandshake, record: []u8) ClientFinishedError!void {
    assert(self.state == .wait_client_finished);
    const dec = try handshake.decryptProtected(&self.rx, record);
    if (dec.content_type != .handshake) return error.UnexpectedRecord;
    return self.processClientFinishedPlaintext(dec.content);
}

fn processClientFinishedPlaintext(
    self: *ServerHandshake,
    plaintext: []const u8,
) ClientFinishedError!void {
    assert(self.state == .wait_client_finished);
    var hr: HandshakeReader = .init(plaintext);
    const msg = (try hr.next()) orelse return error.UnexpectedMessage;
    if (msg.type != .finished) return error.UnexpectedMessage;
    if (try hr.next() != null) return error.UnexpectedMessage;
    try self.verifyClientFinished(msg.raw);
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
            var master = H.masterSecret(s.handshake_secret);
            defer master.secureZero();
            s.client_app_secret = H.clientApplicationTrafficSecret(master, &.init(th));
            s.server_app_secret = H.serverApplicationTrafficSecret(master, &.init(th));
            var next_rx = try H.makeRecordLayer(s.aead, s.client_app_secret);
            errdefer next_rx.deinit();
            const next_tx = try H.makeRecordLayer(s.aead, s.server_app_secret);
            self.rx.deinit();
            self.tx.deinit();
            self.rx = next_rx;
            self.tx = next_tx;
            s.transcript.update(msg_raw);
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
        .connected => try self.handleConnected(record, out),
    };
    if (ev == .write) self.pending_write.mark();
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
            return if (a.isCloseNotify()) .closed else error.PeerAlert;
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
            break :blk if (a.isCloseNotify()) .closed else error.PeerAlert;
        },
        .handshake => {
            if (hdr.length() == 0) return error.UnexpectedRecord;
            return self.handleClientHelloRecord(record, out);
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
            self.ch_expected = handshake_header_len + body_len_assembled;
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
    const total = handshake_header_len + body_len;

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

    const dec = handshake.decryptProtected(&self.rx, record) catch |err| {
        if (self.fin_frag.len > 0) self.fin_frag.clear();
        return err;
    };

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
            // Buffer the plaintext and try to reassemble a complete Finished.
            self.fin_frag.appendSlice(dec.content) catch {
                self.fin_frag.clear();
                return error.UnexpectedMessage;
            };

            const fragment = self.fin_frag.constSlice();
            if (fragment.len >= handshake_header_len) {
                if (fragment[0] != @intFromEnum(HandshakeType.finished)) {
                    self.fin_frag.clear();
                    return error.UnexpectedMessage;
                }
                const finished_len = (@as(u24, fragment[1]) << 16) |
                    (@as(u24, fragment[2]) << 8) |
                    fragment[3];
                if (finished_len > 48) {
                    self.fin_frag.clear();
                    return error.UnexpectedMessage;
                }
            }

            var hr: HandshakeReader = .init(fragment);
            const maybe_msg = hr.next() catch {
                // Still partial: wait for more fragments.
                break :blk .none;
            };
            const msg = maybe_msg orelse break :blk .none;
            if (msg.type != .finished) {
                self.fin_frag.clear();
                return error.UnexpectedMessage;
            }
            // Check no trailing data after the Finished message.
            const maybe_extra = hr.next() catch {
                self.fin_frag.clear();
                return error.UnexpectedMessage;
            };
            if (maybe_extra != null) {
                self.fin_frag.clear();
                return error.UnexpectedMessage;
            }

            // Complete Finished: verify and install application traffic keys.
            const finished_msg = msg.raw;
            self.fin_frag.clear();
            try self.verifyClientFinished(finished_msg);
            break :blk .none;
        },
        .alert => blk: {
            const a = try alert.parse(dec.content);
            break :blk if (a.isCloseNotify()) .closed else error.PeerAlert;
        },
        else => error.UnexpectedRecord,
    };
}

fn handleConnected(self: *ServerHandshake, record: []u8, out: []u8) ReceiveError!Event {
    const dec = try handshake.decryptProtected(&self.rx, record);
    switch (dec.content_type) {
        .application_data => {
            if (self.ku_frag.len != 0) {
                self.ku_frag.clear();
                return error.UnexpectedMessage;
            }
            if (dec.content.len > 0) self.post_handshake_count = 0;
            return .{ .application_data = dec.content };
        },
        .handshake => {
            if (dec.content.len == 0) {
                self.ku_frag.clear();
                return error.UnexpectedMessage;
            }

            for (dec.content, 0..) |byte, i| {
                if (self.ku_frag.len == 0 and byte != @intFromEnum(HandshakeType.key_update)) {
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
                    @as(usize, frag[3]);
                if (body_len != key_update_body_len) {
                    self.ku_frag.clear();
                    return error.UnexpectedEof;
                }
                if (self.ku_frag.len < key_update_total_len) continue;

                // RFC 8446 §5.1: a message immediately preceding a key change
                // must align with a record boundary. Reject before ratcheting
                // if this record contains anything after the KeyUpdate.
                if (self.ku_frag.len != key_update_total_len) unreachable;
                if (i + 1 != dec.content.len) {
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
                const next_rx = self.suite_state.ratchetClientKey() catch |err| {
                    self.ku_frag.clear();
                    return err;
                };
                self.rx.deinit();
                self.rx = next_rx;
                self.ku_frag.clear();

                if (request == .update_requested)
                    return .{ .write = try self.sendKeyUpdate(out, .update_not_requested) };
                return .none;
            }
            return .none;
        },
        .alert => {
            if (self.ku_frag.len != 0) {
                self.ku_frag.clear();
                return error.UnexpectedMessage;
            }
            const a = try alert.parse(dec.content);
            return if (a.isCloseNotify()) .closed else error.PeerAlert;
        },
        else => return error.UnexpectedRecord,
    }
}

// ziglint-ignore: Z015 -- SendError is a public error-set alias.
pub fn sendKeyUpdate(
    self: *ServerHandshake,
    out: []u8,
    request: KeyUpdateRequest,
) SendError![]const u8 {
    return handshake.sendKeyUpdate(.server, self, out, request);
}

// ziglint-ignore: Z015 -- AlertError is a public error-set alias.
pub fn sendAlert(
    self: *ServerHandshake,
    description: alert.Description,
    out: []u8,
) AlertError![]const u8 {
    if (self.pending_write.isPending()) return error.PendingWrite;
    var msg: [2]u8 = undefined;
    const level: alert.Level = if (description == .close_notify) .warning else .fatal;
    _ = alert.encode(&msg, level, description) catch unreachable;
    const record = try switch (self.state) {
        .wait_ch => alert.plaintextRecord(&msg, out),
        else => self.tx.encrypt(.alert, &msg, out),
    };
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

// ziglint-ignore: Z015 -- ReceiveError is a public error-set alias.
pub fn receiveApplicationData(self: *ServerHandshake, record: []u8) ReceiveError![]const u8 {
    assert(self.state == .connected);
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

const test_cert_der: []const u8 = &shared_fixtures.server_cert_der;
const server_ecdsa_cert_der: []const u8 = &shared_fixtures.server_ecdsa_cert_der;
const server_ecdsa_scalar: []const u8 = &shared_fixtures.server_ecdsa_scalar;
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
    const extensions_len_offset = 49;
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
    const extensions_len_offset = 49;
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
    const extensions_len_offset = 49;

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

// RFC 8446 §6.2 — server-side ClientHello parser and negotiation failures map
// to the alert descriptions callers should send through the Sans-I/O API.
test "alertForError: parser and negotiation failures map to protocol alerts" {
    const cases = [_]struct {
        err: anyerror,
        description: alert.Description,
    }{
        .{ .err = error.UnexpectedEof, .description = .decode_error },
        .{ .err = error.InvalidHandshakeLength, .description = .decode_error },
        .{ .err = error.InvalidVectorLength, .description = .decode_error },
        .{ .err = error.InvalidEnumTag, .description = .decode_error },
        .{ .err = error.InvalidHandshakeType, .description = .unexpected_message },
        .{ .err = error.UnexpectedRecord, .description = .unexpected_message },
        .{ .err = error.MissingExtension, .description = .missing_extension },
        .{ .err = error.UnsupportedTlsVersion, .description = .protocol_version },
        .{ .err = error.UnsupportedCipherSuite, .description = .handshake_failure },
        .{ .err = error.UnsupportedKeyShare, .description = .handshake_failure },
        .{ .err = error.UnsupportedSignatureScheme, .description = .illegal_parameter },
        .{ .err = error.NoApplicationProtocol, .description = .no_application_protocol },
        .{ .err = error.DuplicateExtension, .description = .illegal_parameter },
        .{ .err = error.DuplicateKeyShare, .description = .illegal_parameter },
        .{ .err = error.InvalidCompressionMethod, .description = .illegal_parameter },
        .{ .err = error.UnexpectedExtension, .description = .illegal_parameter },
        .{ .err = error.UnofferedAlpnProtocol, .description = .illegal_parameter },
    };
    for (cases) |case| try testing.expectEqual(case.description, alertForError(case.err));
}

fn testConfig(keypair: x25519.KeyPair) Config {
    return .{
        .keypairs = .init(keypair),
        .random = .zero,
    };
}

// RFC 8446 §6 — alerts before handshake protection are plaintext records.
test "sendAlert: plaintext fatal alert before ClientHello" {
    var hs: ServerHandshake = .init(testConfig(.generate()));
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
    var hs: ServerHandshake = .init(testConfig(.generate()));
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

    var hs: ServerHandshake = .init(testConfig(.generate()));
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

    var hs: ServerHandshake = .init(testConfig(.generate()));
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

    var hs: ServerHandshake = .init(testConfig(.generate()));
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
    var hs: ServerHandshake = .init(testConfig(.generate()));
    var rec = [_]u8{ 0x16, 0x03, 0x03, 0x00, 0x00 };
    var out: [64]u8 = undefined;
    try testing.expectError(error.UnexpectedRecord, hs.handleRecord(&rec, &out));
}

// RFC 8446 §5.1 — application_data is invalid before the handshake completes.
test "handleRecord: rejects application_data before connected" {
    var hs: ServerHandshake = .init(testConfig(.generate()));
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

    var hs: ServerHandshake = .init(testConfig(server_keypair));
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
        .keypairs = .init(client_keypair),
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

// RFC 8446 §6, §7.4 — malformed peer key-share material is peer input, not an
// internal server failure.
test "alertForError: invalid key share maps to illegal_parameter" {
    try testing.expectEqual(
        alert.Description.illegal_parameter,
        alertForError(error.IdentityElement),
    );
    try testing.expectEqual(
        alert.Description.illegal_parameter,
        alertForError(error.MalformedKeyShare),
    );
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

    var server: ServerHandshake = .init(testConfig(.generate()));
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

    var server: ServerHandshake = .init(testConfig(.generate()));
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

    var server: ServerHandshake = .init(testConfig(.generate()));
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

test "acceptClientHello: emits HelloRetryRequest for missing X25519 key share" {
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

    var server: ServerHandshake = .init(testConfig(.generate()));
    var hrr_out: [256]u8 = undefined;
    const hrr_record = try server.acceptClientHello(
        ch1_record[0 .. frame.header_len + hrr_ch1.len],
        &hrr_out,
    );
    try testing.expectEqual(.wait_ch, server.state);
    try testing.expect(!server.needsServerFlight());

    const hrr_hdr = try frame.parseHeader(hrr_record);
    try testing.expectEqual(.handshake, hrr_hdr.content_type);
    const hrr = try server_hello.parseHelloRetryRequest(
        hrr_record[frame.header_len..][0..hrr_hdr.length()],
    );
    try testing.expectEqual(NamedGroup.x25519, hrr.selected_group.?);

    var ccs = [_]u8{ 0x14, 0x03, 0x03, 0x00, 0x01, 0x01 };
    try testing.expectEqual(Event.none, try server.handleRecord(&ccs, &hrr_out));

    var ch2_record: [1024]u8 = undefined;
    const ch2_header: frame.Header = .init(.handshake, @intCast(ch1.len));
    ch2_header.write(ch2_record[0..frame.header_len]);
    @memcpy(ch2_record[frame.header_len..][0..ch1.len], ch1);
    var sh_out: [256]u8 = undefined;
    const sh_record = try server.acceptClientHello(
        ch2_record[0 .. frame.header_len + ch1.len],
        &sh_out,
    );
    try testing.expectEqual(.wait_client_finished, server.state);
    try testing.expect(server.needsServerFlight());
    const sh_hdr = try frame.parseHeader(sh_record);
    try testing.expectEqual(.handshake, sh_hdr.content_type);
    _ = try server_hello.parse(sh_record[frame.header_len..][0..sh_hdr.length()]);
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

    var hs: ServerHandshake = .init(testConfig(.generate()));
    var out: [256]u8 = undefined;
    const written = try hs.acceptClientHello(
        record[0 .. frame.header_len + compat_ch.len],
        &out,
    );

    const sh_hdr = try frame.parseHeader(written);
    try testing.expectEqual(.handshake, sh_hdr.content_type);
    const ccs_offset = frame.header_len + @as(usize, sh_hdr.length());
    try testing.expectEqual(ccs_offset + compatibility_ccs_len, written.len);
    _ = try server_hello.parseWithSessionIdEcho(
        written[frame.header_len..][0..sh_hdr.length()],
        &session_id,
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

    var server: ServerHandshake = .init(testConfig(server_keypair));
    server.supportAlpn(&.{"h2"});
    var sh_out: [256]u8 = undefined;
    const sh_record = try server.acceptClientHello(
        ch_record[0 .. frame.header_len + ch.len],
        &sh_out,
    );

    var client: ClientHandshake = .init(.{
        .keypairs = .init(client_keypair),
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

    var server_without_credentials: ServerHandshake = .init(testConfig(.generate()));
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

    var signer: signature.PrivateKey = try .fromP256Scalar(server_ecdsa_scalar[0..32]);
    defer signer.deinit();
    var server: ServerHandshake = .init(testConfig(.generate()));
    server.setCredentials(&.{server_ecdsa_cert_der}, signer.signer());
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

    var server: ServerHandshake = .init(testConfig(server_keypair));
    server.supportAlpn(&.{"h2"});
    var sh_out: [256]u8 = undefined;
    const sh_record = try server.acceptClientHello(
        ch_record[0 .. frame.header_len + ch.len],
        &sh_out,
    );

    var signer: signature.PrivateKey = try .fromP256Scalar(server_ecdsa_scalar[0..32]);
    defer signer.deinit();
    const signer_api = signer.signer();
    var plaintext: [4096]u8 = undefined;
    var flight_out: [4096]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(
        &.{test_cert_der},
        signer_api,
        &plaintext,
        &flight_out,
    );

    var client: ClientHandshake = .init(.{
        .keypairs = .init(client_keypair),
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
    const client_keypair: x25519.KeyPair = try .generateDeterministic(.init(@splat(0x11)));
    const server_keypair: x25519.KeyPair = try .generateDeterministic(.init(@splat(0x22)));
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    var ch_record: [1024]u8 = undefined;
    const header: frame.Header = .init(.handshake, @intCast(ch.len));
    header.write(ch_record[0..frame.header_len]);
    @memcpy(ch_record[frame.header_len..][0..ch.len], ch);

    var server: ServerHandshake = .init(testConfig(server_keypair));
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

const ConnectedTestPair = struct {
    client: ClientHandshake,
    server: ServerHandshake,
};

fn connectedTestPair() !ConnectedTestPair {
    const client_keypair: x25519.KeyPair = .generate();
    const server_keypair: x25519.KeyPair = .generate();

    var client: ClientHandshake = .init(.{
        .keypairs = .init(client_keypair),
        .host_name = "ztls.server.test",
        .now_sec = 0,
        .random = .zero,
    });
    client.policy.insecure_no_chain_anchor = true;
    var client_out: [1024]u8 = undefined;
    const ch_record = try client.start(&client_out);
    client.completeWrite();

    var server: ServerHandshake = .init(testConfig(server_keypair));
    var server_out: [4096]u8 = undefined;
    const sh_record = try server.acceptClientHello(ch_record, &server_out);
    try client.processServerHello(sh_record[frame.header_len..]);

    var signer = try signature.PrivateKey.fromP256Scalar(server_ecdsa_scalar[0..32]);
    defer signer.deinit();
    const signer_api = signer.signer();
    var plaintext: [4096]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(
        &.{server_ecdsa_cert_der},
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

    var server: ServerHandshake = .init(testConfig(server_keypair));
    server.supportAlpn(&.{"h2"});
    var sh_out: [256]u8 = undefined;
    const sh_record = try server.acceptClientHello(
        ch_record[0 .. frame.header_len + ch.len],
        &sh_out,
    );

    var signer: signature.PrivateKey = try .fromP256Scalar(server_ecdsa_scalar[0..32]);
    defer signer.deinit();
    const signer_api = signer.signer();
    var plaintext: [4096]u8 = undefined;
    var flight_out: [4096]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(
        &.{server_ecdsa_cert_der},
        signer_api,
        &plaintext,
        &flight_out,
    );

    var client: ClientHandshake = .init(.{
        .keypairs = .init(client_keypair),
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

    var server: ServerHandshake = .init(testConfig(server_keypair));
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

    var server: ServerHandshake = .init(testConfig(.generate()));
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

    var server: ServerHandshake = .init(testConfig(.generate()));
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

// RFC 8446 §4.6.3 — a client KeyUpdate(update_requested) ratchets the
// server receive key and elicits a server KeyUpdate(update_not_requested),
// encrypted under the old send key.
test "handleRecord: client KeyUpdate(update_requested) ratchets rx and responds" {
    var server = try connectedTestServer();
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

    const resp = ev.write;
    var resp_buf: [64]u8 = undefined;
    @memcpy(resp_buf[0..resp.len], resp);
    const dec = try server_tx_old.decrypt(resp_buf[0..resp.len]);
    try testing.expectEqual(.handshake, dec.content_type);
    try testing.expectEqualSlices(u8, &.{
        @intFromEnum(HandshakeType.key_update),              0x00, 0x00, 0x01,
        @intFromEnum(KeyUpdateRequest.update_not_requested),
    }, dec.content);
    server.completeWrite();

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
test "handleRecord: client KeyUpdate(update_not_requested) ratchets rx only" {
    var server = try connectedTestServer();
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
    try testing.expectEqual(
        Event.none,
        try server.handleRecord(rx_buf[0..ku_wire.len], &out),
    );

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
    try testing.expectError(error.PendingWrite, server.sendKeyUpdate(&out, .update_requested));
    server.completeWrite();
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
        .write => |w| w,
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
        .write => |w| w,
        else => return error.UnexpectedEvent,
    };
    var client_response_wire: [64]u8 = undefined;
    @memcpy(client_response_wire[0..client_response.len], client_response);
    pair.client.completeWrite();

    try testing.expectEqual(
        ClientHandshake.Event.none,
        try pair.client.handleRecord(server_response_wire[0..server_response.len], &client_out),
    );
    try testing.expectEqual(
        Event.none,
        try pair.server.handleRecord(
            client_response_wire[0..client_response.len],
            &server_out,
        ),
    );

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
    var server: ServerHandshake = .init(testConfig(keypair));
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
        .keypairs = .init(client_keypair),
        .host_name = "ztls.server.test",
        .now_sec = 0,
        .random = .zero,
    });
    client.offerAlpn(&.{"h2"});
    client.policy.insecure_no_chain_anchor = true;
    var client_out: [1024]u8 = undefined;
    const ch_record = try client.start(&client_out);
    client.completeWrite();

    var server: ServerHandshake = .init(testConfig(server_keypair));
    server.supportAlpn(&.{"h2"});
    const suites = [_]CipherSuite{suite};
    server.supportSuites(&suites);
    var server_out: [4096]u8 = undefined;
    const sh_record = try server.acceptClientHello(ch_record, &server_out);
    try testing.expectEqual(suite, server.suite);
    try client.processServerHello(sh_record[frame.header_len..]);

    var signer = try signature.PrivateKey.fromP256Scalar(server_ecdsa_scalar[0..32]);
    defer signer.deinit();
    const signer_api = signer.signer();
    var plaintext: [4096]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(
        &.{server_ecdsa_cert_der},
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

// RFC 8446 §9.1 — TLS 1.3 implementations must support all three mandatory suites.
test "in-memory authenticated client-server handshake reaches app data" {
    try expectInMemoryAuthenticatedHandshake(.aes_128_gcm_sha256);
}

// RFC 8446 §9.1 — all mandatory TLS 1.3 cipher suites complete the full handshake.
test "in-memory authenticated client-server handshake suite matrix" {
    try expectInMemoryAuthenticatedHandshake(.aes_128_gcm_sha256);
    try expectInMemoryAuthenticatedHandshake(.aes_256_gcm_sha384);
    try expectInMemoryAuthenticatedHandshake(.chacha20_poly1305_sha256);
}

test "acceptClientHello: server suite preference" {
    const client_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    var record: [1024]u8 = undefined;
    const header: frame.Header = .init(.handshake, @intCast(ch.len));
    header.write(record[0..frame.header_len]);
    @memcpy(record[frame.header_len..][0..ch.len], ch);

    var hs: ServerHandshake = .init(testConfig(.generate()));
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

    var hs: ServerHandshake = .init(testConfig(.generate()));
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

    var hs: ServerHandshake = .init(testConfig(.generate()));
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
    var hs: ServerHandshake = .init(testConfig(.generate()));
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

    var hs: ServerHandshake = .init(testConfig(.generate()));
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

    var hs: ServerHandshake = .init(testConfig(.generate()));
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

    var hs: ServerHandshake = .init(testConfig(.generate()));
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

    var hs: ServerHandshake = .init(testConfig(.generate()));
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

    var hs: ServerHandshake = .init(testConfig(.generate()));
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

    var hs: ServerHandshake = .init(testConfig(.generate()));
    var reassembly: [1024]u8 = undefined;
    hs.useHandshakeBuffer(&reassembly);
    var out: [256]u8 = undefined;
    const ev1 = try hs.handleRecord(rec1[0 .. frame.header_len + split_at], &out);
    try testing.expectEqual(Event.none, ev1);

    // A fatal alert terminates the connection mid-fragment.
    var alert_rec = [_]u8{ 0x15, 0x03, 0x03, 0x00, 0x02, 0x02, 0x28 };
    try testing.expectError(error.PeerAlert, hs.handleRecord(&alert_rec, &out));
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

    var hs: ServerHandshake = .init(testConfig(.generate()));
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

    var hs: ServerHandshake = .init(testConfig(server_keypair));
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

    var hs: ServerHandshake = .init(testConfig(server_keypair));
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

    var hs: ServerHandshake = .init(testConfig(server_keypair));
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

    var server: ServerHandshake = .init(testConfig(server_keypair));
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

    var server: ServerHandshake = .init(testConfig(server_keypair));
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

    var server: ServerHandshake = .init(testConfig(server_keypair));
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

    var server: ServerHandshake = .init(testConfig(server_keypair));
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

    var server: ServerHandshake = .init(testConfig(server_keypair));
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

    var hs: ServerHandshake = .init(testConfig(.generate()));
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
        try testing.expect(ev == .write);
        const resp = ev.write;
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
        try testing.expectEqual(Event.none, ev);
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
