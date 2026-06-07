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
const ArrayBuffer = @import("array_buffer.zig").ArrayBuffer;
const certificate = @import("certificate.zig");
const CertificateChain = @import("certificate_chain.zig").CertificateChain;
const CipherSuite = @import("root.zig").CipherSuite;
const client_hello = @import("client_hello.zig");
const ClientHandshake = @import("ClientHandshake.zig");
const HandshakeReader = ClientHandshake.HandshakeReader;
const HandshakeType = ClientHandshake.HandshakeType;
const KeyUpdateRequest = ClientHandshake.KeyUpdateRequest;
const encrypted_extensions = @import("encrypted_extensions.zig");
const finished = @import("finished.zig");
const frame = @import("frame.zig");
pub const max_out_len = frame.max_wire_record_len;
const hkdf = @import("hkdf.zig");
const PendingWrite = @import("pending_write.zig").PendingWrite;
const RecordLayer = @import("RecordLayer.zig");
const server_hello = @import("server_hello.zig");
const signature = @import("signature.zig");
pub const SignError = signature.SignError;
pub const Signer = signature.Signer;
const x25519 = @import("x25519.zig");

const ServerHandshake = @This();

pub const OutBuffer = ArrayBuffer(u8, max_out_len);
/// Single caller-owned buffer for prepared authenticated server flights. The
/// handshake plaintext is staged inside the TLS record payload region, then
/// encrypted in place into the same backing storage.
pub const FlightBuffer = OutBuffer;

pub const State = enum {
    wait_ch,
    wait_client_finished,
    connected,
};

fn HashArm(comptime Hkdf_: type, comptime Hash: type) type {
    return struct {
        const Self = @This();
        const Hkdf = Hkdf_;

        transcript: Hash,
        aead: aead.Keys,
        handshake_secret: Hkdf.Prk,
        client_finished_key: Hkdf.Prk,
        server_finished_key: Hkdf.Prk,
        client_app_secret: Hkdf.Prk = undefined,
        server_app_secret: Hkdf.Prk = undefined,

        fn secureZero(self: *Self) void {
            std.crypto.secureZero(u8, mem.asBytes(self));
        }
    };
}

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

    fn ratchetClientKey(self: *Suite) aead.Error!RecordLayer {
        switch (self.*) {
            inline .sha256, .sha384 => |*s| {
                const H = @TypeOf(s.*).Hkdf;
                s.client_app_secret = H.nextTrafficSecret(s.client_app_secret);
                return H.makeRecordLayer(s.aead, s.client_app_secret);
            },
        }
    }

    fn ratchetServerKey(self: *Suite) aead.Error!RecordLayer {
        switch (self.*) {
            inline .sha256, .sha384 => |*s| {
                const H = @TypeOf(s.*).Hkdf;
                s.server_app_secret = H.nextTrafficSecret(s.server_app_secret);
                return H.makeRecordLayer(s.aead, s.server_app_secret);
            },
        }
    }
};

const default_supported_suites = [_]CipherSuite{
    .aes_128_gcm_sha256,
    .aes_256_gcm_sha384,
    .chacha20_poly1305_sha256,
};

state: State = .wait_ch,
keypair: x25519.KeyPair,
suite: CipherSuite = .aes_128_gcm_sha256,
suite_state: Suite = undefined,
supported_suites: []const CipherSuite = &default_supported_suites,
alpn_protocols: client_hello.AlpnProtocols = &.{},
selected_alpn: ?[]const u8 = null,
/// SNI hostname sent by the client in the server_name extension (RFC 6066 §3).
/// Populated after acceptClientHello / handleRecord returns the first write event.
/// Points into the caller-owned record buffer; copy if needed beyond the next call.
client_server_name: ?[]const u8 = null,
rx: RecordLayer = undefined,
tx: RecordLayer = undefined,
/// Set when an engine call hands the caller bytes that must be written before
/// more input can be safely processed. Prevents dropped ServerHello/flight/app
/// data from silently desynchronizing traffic keys.
pending_write: PendingWrite = .idle,
post_handshake_count: u8 = 0,

pub fn init(keypair: x25519.KeyPair) ServerHandshake {
    return .{ .keypair = keypair };
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
    self.keypair.secret_key.secureZero();
    self.* = undefined;
}

pub fn supportSuites(self: *ServerHandshake, suites: []const CipherSuite) void {
    assert(self.state == .wait_ch);
    self.supported_suites = suites;
}

pub fn supportAlpn(self: *ServerHandshake, protocols: client_hello.AlpnProtocols) void {
    assert(self.state == .wait_ch);
    self.alpn_protocols = protocols;
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
        LibcryptoFailed,
    };

pub const FlightError =
    encrypted_extensions.EncodeError ||
    certificate.EncodeError ||
    certificate.CertificateVerifyEncodeError ||
    RecordLayer.EncryptError ||
    SignError;

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

/// Consume a plaintext ClientHello record and emit a plaintext ServerHello
/// record. The returned bytes must be written before continuing the handshake.
/// Installs handshake traffic keys for the encrypted server flight.
/// RFC 8446 §4.1.2, §4.1.3, §5.1, §7.1.
pub fn acceptClientHello(
    self: *ServerHandshake,
    record: []const u8,
    random: client_hello.Random,
    out: []u8,
) AcceptError![]const u8 {
    assert(self.state == .wait_ch);
    const hdr = try frame.parseHeader(record);
    if (hdr.content_type != .handshake) return error.UnexpectedRecord;
    if (record.len < frame.header_len + hdr.length()) return error.IncompleteRecord;

    const ch_msg = record[frame.header_len..][0..hdr.length()];
    const ch = try client_hello.parse(ch_msg);
    const suite = self.chooseSuite(ch) orelse return error.UnsupportedCipherSuite;
    self.suite = suite;
    self.selected_alpn = ch.selectAlpn(self.alpn_protocols);
    if (ch.alpn_protocols.len != 0 and self.alpn_protocols.len != 0 and self.selected_alpn == null)
        return error.NoApplicationProtocol;
    self.client_server_name = ch.server_name;

    const sh = try server_hello.encode(
        out[frame.header_len..],
        random.data,
        ch.legacy_session_id,
        suite,
        self.keypair.public_key,
    );
    out[0..frame.header_len].* = mem.toBytes(frame.Header.init(.handshake, @intCast(sh.len)));

    try self.installHandshakeKeys(suite, ch_msg, sh, ch.public_key);
    self.state = .wait_client_finished;
    return out[0 .. frame.header_len + sh.len];
}

fn installHandshakeKeys(
    self: *ServerHandshake,
    suite: CipherSuite,
    ch_msg: []const u8,
    sh_msg: []const u8,
    client_public_key: x25519.PublicKey,
) (error{ IdentityElement, LibcryptoFailed } || aead.Error)!void {
    const dhe = try x25519.sharedSecret(self.keypair.secret_key, client_public_key);
    switch (suite) {
        .aes_128_gcm_sha256, .chacha20_poly1305_sha256 => {
            var transcript: Sha256 = .init(.{});
            transcript.update(ch_msg);
            transcript.update(sh_msg);
            self.suite_state = .{ .sha256 = makeHandshakeArm(
                hkdf.HkdfSha256,
                Sha256,
                transcript,
                suiteAead(suite),
                &dhe,
            ) };
        },
        .aes_256_gcm_sha384 => {
            var transcript: Sha384 = .init(.{});
            transcript.update(ch_msg);
            transcript.update(sh_msg);
            self.suite_state = .{ .sha384 = makeHandshakeArm(
                hkdf.HkdfSha384,
                Sha384,
                transcript,
                suiteAead(suite),
                &dhe,
            ) };
        },
    }

    switch (self.suite_state) {
        inline .sha256, .sha384 => |s| {
            const H = @TypeOf(s).Hkdf;
            const th = s.transcript.peek();
            const client_secret = H.clientHandshakeTrafficSecret(s.handshake_secret, &.init(th));
            const server_secret = H.serverHandshakeTrafficSecret(s.handshake_secret, &.init(th));
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
    aead_key: aead.Keys,
    dhe: []const u8,
) HashArm(H, Hash) {
    const handshake_secret = H.handshakeSecret(H.early_secret, dhe);
    const th = transcript.peek();
    const client_secret = H.clientHandshakeTrafficSecret(handshake_secret, &.init(th));
    const server_secret = H.serverHandshakeTrafficSecret(handshake_secret, &.init(th));
    return .{
        .transcript = transcript,
        .aead = aead_key,
        .handshake_secret = handshake_secret,
        .client_finished_key = H.finishedKey(client_secret),
        .server_finished_key = H.finishedKey(server_secret),
    };
}

fn suiteAead(suite: CipherSuite) aead.Keys {
    return switch (suite) {
        .aes_128_gcm_sha256 => .aes128_gcm,
        .chacha20_poly1305_sha256 => .chacha20_poly1305,
        .aes_256_gcm_sha384 => .aes256_gcm,
    };
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
pub fn sendAuthenticatedFlight(
    self: *ServerHandshake,
    certs_der: []const []const u8,
    signer: Signer,
    plaintext: []u8,
    out: []u8,
) FlightError![]const u8 {
    return self.sendCertificateChainFlight(.init(certs_der), signer, plaintext, out);
}

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

pub fn sendPreparedAuthenticatedFlight(
    self: *ServerHandshake,
    certs_der: []const []const u8,
    signer: Signer,
    out: []u8,
) FlightError![]const u8 {
    return self.sendPreparedCertificateChainFlight(.init(certs_der), signer, out);
}

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

pub fn sendAuthenticatedFlightBuffered(
    self: *ServerHandshake,
    certs_der: []const []const u8,
    signer: Signer,
    out: *FlightBuffer,
) FlightError![]u8 {
    const record = try self.sendPreparedCertificateChainFlight(
        .init(certs_der),
        signer,
        out.fullSlice(),
    );
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
pub fn processClientFinished(self: *ServerHandshake, record: []u8) ClientFinishedError!void {
    assert(self.state == .wait_client_finished);
    const dec = try self.rx.decrypt(record);
    if (dec.content_type != .handshake) return error.UnexpectedRecord;
    return self.processClientFinishedPlaintext(dec.content);
}

fn processClientFinishedPlaintext(
    self: *ServerHandshake,
    plaintext: []const u8,
) ClientFinishedError!void {
    assert(self.state == .wait_client_finished);
    var hr: ClientHandshake.HandshakeReader = .init(plaintext);
    const msg = (try hr.next()) orelse return error.UnexpectedMessage;
    if (msg.type != .finished) return error.UnexpectedMessage;
    if (try hr.next() != null) return error.UnexpectedMessage;

    switch (self.suite_state) {
        inline .sha256, .sha384 => |*s| {
            const H = @TypeOf(s.*).Hkdf;
            const th = s.transcript.peek();
            try finished.verify(@TypeOf(s.transcript), msg.raw, &s.client_finished_key.data, &th);
            const master = H.masterSecret(s.handshake_secret);
            s.client_app_secret = H.clientApplicationTrafficSecret(master, &.init(th));
            s.server_app_secret = H.serverApplicationTrafficSecret(master, &.init(th));
            var next_rx = try H.makeRecordLayer(s.aead, s.client_app_secret);
            errdefer next_rx.deinit();
            const next_tx = try H.makeRecordLayer(s.aead, s.server_app_secret);
            self.rx.deinit();
            self.tx.deinit();
            self.rx = next_rx;
            self.tx = next_tx;
            s.transcript.update(msg.raw);
        },
    }
    self.state = .connected;
}

pub fn handleRecord(
    self: *ServerHandshake,
    record: []u8,
    random: client_hello.Random,
    out: []u8,
) HandleError!Event {
    if (self.pending_write.isPending()) return error.PendingWrite;
    const ev: Event = switch (self.state) {
        .wait_ch => try self.handleWaitClientHello(record, random, out),
        .wait_client_finished => try self.handleWaitClientFinished(record),
        .connected => try self.handleConnected(record, out),
    };
    if (ev == .write) self.pending_write.mark();
    return ev;
}

fn handleWaitClientHello(
    self: *ServerHandshake,
    record: []u8,
    random: client_hello.Random,
    out: []u8,
) HandleError!Event {
    const hdr = try frame.parseHeader(record);
    if (record.len < frame.header_len + hdr.length()) return error.IncompleteRecord;
    return switch (hdr.content_type) {
        .change_cipher_spec => .none, // RFC 8446 §D.4 — middlebox compat, silently discarded.
        .alert => blk: {
            const a = try alert.parse(record[frame.header_len..][0..hdr.length()]);
            break :blk if (a.isCloseNotify()) .closed else error.PeerAlert;
        },
        .handshake => .{ .write = try self.acceptClientHello(record, random, out) },
        else => error.UnexpectedRecord,
    };
}

fn handleWaitClientFinished(self: *ServerHandshake, record: []u8) HandleError!Event {
    const hdr = try frame.parseHeader(record);
    if (record.len < frame.header_len + hdr.length()) return error.IncompleteRecord;
    switch (hdr.content_type) {
        // RFC 8446 §D.4 — middlebox compat, silently discarded.
        .change_cipher_spec => return .none,
        .alert => {
            const a = try alert.parse(record[frame.header_len..][0..hdr.length()]);
            if (a.isCloseNotify()) return .closed;
            return error.PeerAlert;
        },
        .application_data => {},
        else => return error.UnexpectedRecord,
    }

    const dec = try self.rx.decrypt(record);
    return switch (dec.content_type) {
        .handshake => blk: {
            try self.processClientFinishedPlaintext(dec.content);
            break :blk .none;
        },
        .alert => blk: {
            const a = try alert.parse(dec.content);
            break :blk if (a.isCloseNotify()) .closed else error.PeerAlert;
        },
        else => error.UnexpectedRecord,
    };
}

const max_post_handshake_messages = 16;

fn handleConnected(self: *ServerHandshake, record: []u8, out: []u8) ReceiveError!Event {
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
                if (self.post_handshake_count > max_post_handshake_messages)
                    return error.TooManyKeyUpdates;
                if (msg.type != .key_update) return error.UnexpectedMessage;
                if (hr.r.remaining().len != 0) return error.UnexpectedMessage;
                if (try parseKeyUpdate(msg.raw) == .update_requested) respond = true;
                const next_rx = try self.suite_state.ratchetClientKey();
                self.rx.deinit();
                self.rx = next_rx;
            }
            if (respond) return .{ .write = try self.sendKeyUpdate(out, .update_not_requested) };
            return .none;
        },
        .alert => {
            const a = try alert.parse(dec.content);
            return if (a.isCloseNotify()) .closed else error.PeerAlert;
        },
        else => return error.UnexpectedRecord,
    }
}

pub fn sendKeyUpdate(
    self: *ServerHandshake,
    out: []u8,
    request: KeyUpdateRequest,
) SendError![]const u8 {
    assert(self.state == .connected);
    if (self.pending_write.isPending()) return error.PendingWrite;
    const msg = [_]u8{
        @intFromEnum(HandshakeType.key_update), 0x00, 0x00, 0x01, @intFromEnum(request),
    };
    const record = try self.tx.encrypt(.handshake, &msg, out);
    const next_tx = try self.suite_state.ratchetServerKey();
    self.tx.deinit();
    self.tx = next_tx;
    self.pending_write.mark();
    return record;
}

fn parseKeyUpdate(msg: []const u8) error{ UnexpectedEof, IllegalParameter }!KeyUpdateRequest {
    if (msg.len != 5) return error.UnexpectedEof;
    return std.enums.fromInt(KeyUpdateRequest, msg[4]) orelse error.IllegalParameter;
}

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
        .wait_ch => plaintextAlert(&msg, out),
        else => self.tx.encrypt(.alert, &msg, out),
    };
    self.pending_write.mark();
    return record;
}

fn plaintextAlert(msg: *const [2]u8, out: []u8) error{BufferTooShort}![]u8 {
    const total = frame.header_len + msg.len;
    if (out.len < total) return error.BufferTooShort;
    out[0..frame.header_len].* = mem.toBytes(frame.Header.init(.alert, msg.len));
    out[frame.header_len..][0..msg.len].* = msg.*;
    return out[0..total];
}

pub fn sendApplicationData(
    self: *ServerHandshake,
    plaintext: []const u8,
    out: []u8,
) SendError![]u8 {
    assert(self.state == .connected);
    if (self.pending_write.isPending()) return error.PendingWrite;
    const record = try self.tx.encrypt(.application_data, plaintext, out);
    self.pending_write.mark();
    return record;
}

pub fn sendPreparedApplicationData(
    self: *ServerHandshake,
    plaintext_len: usize,
    out: []u8,
) SendError![]u8 {
    assert(self.state == .connected);
    if (self.pending_write.isPending()) return error.PendingWrite;
    const record = try self.tx.encryptPrepared(.application_data, plaintext_len, out);
    self.pending_write.mark();
    return record;
}

pub fn receiveApplicationData(self: *ServerHandshake, record: []u8) ReceiveError![]const u8 {
    assert(self.state == .connected);
    const dec = try self.rx.decrypt(record);
    if (dec.content_type != .application_data) return error.UnexpectedRecord;
    return dec.content;
}

fn chooseSuite(self: *const ServerHandshake, ch: client_hello.Parsed) ?CipherSuite {
    for (self.supported_suites) |suite| {
        if (ch.offersSuite(suite)) return suite;
    }
    return null;
}

const test_cert_der = @embedFile("test_fixtures/server.crt.der");
const server_ecdsa_cert_der = @embedFile("test_fixtures/server-ecdsa/server.der");
const server_ecdsa_scalar = @embedFile("test_fixtures/server-ecdsa/scalar.bin");

// RFC 8446 §6 — alerts before handshake protection are plaintext records.
test "sendAlert: plaintext fatal alert before ClientHello" {
    var hs: ServerHandshake = .init(.generate());
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

// RFC 8446 §D.4 — middlebox-compat ChangeCipherSpec records are ignored.
test "handleRecord: drops ChangeCipherSpec while waiting for ClientHello" {
    var hs: ServerHandshake = .init(.generate());
    var ccs = [_]u8{ 0x14, 0x03, 0x03, 0x00, 0x01, 0x01 };
    var out: [64]u8 = undefined;
    try testing.expectEqual(Event.none, try hs.handleRecord(&ccs, .zero, &out));
}

// RFC 8446 §5 — server handleRecord emits ServerHello and blocks until written.
test "handleRecord: ClientHello returns ServerHello write and enforces pending write" {
    const client_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    var record: [1024]u8 = undefined;
    record[0..frame.header_len].* = mem.toBytes(frame.Header.init(.handshake, @intCast(ch.len)));
    @memcpy(record[frame.header_len..][0..ch.len], ch);

    var hs: ServerHandshake = .init(.generate());
    var out: [256]u8 = undefined;
    const ev = try hs.handleRecord(record[0 .. frame.header_len + ch.len], .zero, &out);
    try testing.expectEqual(.wait_client_finished, hs.state);
    const written = ev.write;
    const hdr = try frame.parseHeader(written);
    try testing.expectEqual(.handshake, hdr.content_type);
    try testing.expectError(
        error.PendingWrite,
        hs.handleRecord(record[0 .. frame.header_len + ch.len], .zero, &out),
    );
    hs.completeWrite();
}

// RFC 8446 §5.1 — application_data is invalid before the handshake completes.
test "handleRecord: rejects application_data before connected" {
    var hs: ServerHandshake = .init(.generate());
    var rec = [_]u8{ 0x17, 0x03, 0x03, 0x00, 0x05 } ++ [_]u8{0} ** 5;
    var out: [64]u8 = undefined;
    try testing.expectError(error.UnexpectedRecord, hs.handleRecord(&rec, .zero, &out));
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
    record[0..frame.header_len].* = mem.toBytes(frame.Header.init(.handshake, @intCast(ch.len)));
    @memcpy(record[frame.header_len..][0..ch.len], ch);

    var hs: ServerHandshake = .init(server_keypair);
    hs.supportAlpn(&.{"http/1.1"});
    var out: [256]u8 = undefined;
    const sh_record = try hs.acceptClientHello(record[0 .. frame.header_len + ch.len], .zero, &out);
    try testing.expectEqual(.wait_client_finished, hs.state);
    try testing.expectEqualStrings("http/1.1", hs.selectedAlpnProtocol().?);

    const hdr = try frame.parseHeader(sh_record);
    try testing.expectEqual(.handshake, hdr.content_type);
    const sh = try server_hello.parse(sh_record[frame.header_len..][0..hdr.length()]);
    try testing.expectEqual(.aes_128_gcm_sha256, sh.cipher_suite);
    try testing.expectEqualSlices(u8, &server_keypair.public_key.data, &sh.server_public_key.data);

    var client_hs: ClientHandshake = .init(client_keypair);
    client_hs.injectClientHello(ch);
    try client_hs.processServerHello(sh_record[frame.header_len..][0..hdr.length()]);
    try testing.expectEqualSlices(u8, &client_hs.rx.iv.data, &hs.tx.iv.data);
    try testing.expectEqualSlices(u8, &client_hs.tx.iv.data, &hs.rx.iv.data);
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
    ch_record[0..frame.header_len].* = mem.toBytes(frame.Header.init(.handshake, @intCast(ch.len)));
    @memcpy(ch_record[frame.header_len..][0..ch.len], ch);

    var server: ServerHandshake = .init(server_keypair);
    server.supportAlpn(&.{"h2"});
    var sh_out: [256]u8 = undefined;
    const sh_record = try server.acceptClientHello(
        ch_record[0 .. frame.header_len + ch.len],
        .zero,
        &sh_out,
    );

    var client: ClientHandshake = .init(client_keypair);
    client.offerAlpn(&.{"h2"});
    client.injectClientHello(ch);
    try client.processServerHello(sh_record[frame.header_len..]);

    var flight_out: [512]u8 = undefined;
    const flight_record = try server.sendAnonymousFlightForTest(&flight_out);
    const dec = try client.rx.decrypt(flight_out[0..flight_record.len]);
    try testing.expectEqual(.handshake, dec.content_type);

    var hr: ClientHandshake.HandshakeReader = .init(dec.content);
    const ee = (try hr.next()).?;
    try testing.expectEqual(.encrypted_extensions, ee.type);
    const parsed_ee = try encrypted_extensions.parse(ee.raw, &.{"h2"});
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
    ch_record[0..frame.header_len].* = mem.toBytes(frame.Header.init(.handshake, @intCast(ch.len)));
    @memcpy(ch_record[frame.header_len..][0..ch.len], ch);

    var server: ServerHandshake = .init(server_keypair);
    server.supportAlpn(&.{"h2"});
    var sh_out: [256]u8 = undefined;
    const sh_record = try server.acceptClientHello(
        ch_record[0 .. frame.header_len + ch.len],
        .zero,
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

    var client: ClientHandshake = .init(client_keypair);
    client.offerAlpn(&.{"h2"});
    client.injectClientHello(ch);
    try client.processServerHello(sh_record[frame.header_len..]);
    const dec = try client.rx.decrypt(flight_out[0..flight_record.len]);
    try testing.expectEqual(.handshake, dec.content_type);

    var hr: ClientHandshake.HandshakeReader = .init(dec.content);
    try testing.expectEqual(.encrypted_extensions, (try hr.next()).?.type);
    try testing.expectEqual(.certificate, (try hr.next()).?.type);
    try testing.expectEqual(.certificate_verify, (try hr.next()).?.type);
    try testing.expectEqual(.finished, (try hr.next()).?.type);
    try testing.expectEqual(@as(?ClientHandshake.HandshakeReader.Message, null), try hr.next());
}

fn connectedTestServer() !ServerHandshake {
    const client_keypair: x25519.KeyPair = .generate();
    const server_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    var ch_record: [1024]u8 = undefined;
    ch_record[0..frame.header_len].* = mem.toBytes(frame.Header.init(.handshake, @intCast(ch.len)));
    @memcpy(ch_record[frame.header_len..][0..ch.len], ch);

    var server: ServerHandshake = .init(server_keypair);
    var sh_out: [256]u8 = undefined;
    _ = try server.acceptClientHello(ch_record[0 .. frame.header_len + ch.len], .zero, &sh_out);
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
    return server;
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
    ch_record[0..frame.header_len].* = mem.toBytes(frame.Header.init(.handshake, @intCast(ch.len)));
    @memcpy(ch_record[frame.header_len..][0..ch.len], ch);

    var server: ServerHandshake = .init(server_keypair);
    server.supportAlpn(&.{"h2"});
    var sh_out: [256]u8 = undefined;
    const sh_record = try server.acceptClientHello(
        ch_record[0 .. frame.header_len + ch.len],
        .zero,
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

    var client: ClientHandshake = .init(client_keypair);
    client.offerAlpn(&.{"h2"});
    client.policy.host_name = "ztls.server.test";
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
    ch_record[0..frame.header_len].* = mem.toBytes(frame.Header.init(.handshake, @intCast(ch.len)));
    @memcpy(ch_record[frame.header_len..][0..ch.len], ch);

    var server: ServerHandshake = .init(server_keypair);
    var sh_out: [256]u8 = undefined;
    _ = try server.acceptClientHello(ch_record[0 .. frame.header_len + ch.len], .zero, &sh_out);
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
    const ev = try server.handleRecord(rx_buf[0..ku_wire.len], .zero, &out);

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
    const ev_after = try server.handleRecord(app_rx[0..app_wire.len], .zero, &out);
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
        try server.handleRecord(rx_buf[0..ku_wire.len], .zero, &out),
    );

    var client_tx_1 = try server.rx.clone();
    defer client_tx_1.deinit();
    var app_buf: [64]u8 = undefined;
    const app_wire = try client_tx_1.encrypt(.application_data, "after", &app_buf);
    var app_rx: [64]u8 = undefined;
    @memcpy(app_rx[0..app_wire.len], app_wire);
    const ev_after2 = try server.handleRecord(app_rx[0..app_wire.len], .zero, &out);
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
        server.handleRecord(rx_buf[0..wire_rec.len], .zero, &out),
    );
}

// RFC 8446 Appendix A — server state machine must reject arbitrary inbound
// records without panics.
fn fuzzHandleRecord(_: void, input: []const u8) anyerror!void {
    const key_seed: [32]u8 = @splat(0x42);
    const keypair = x25519.KeyPair.generateDeterministic(.init(key_seed)) catch unreachable;
    var server: ServerHandshake = .init(keypair);
    defer server.deinit();

    var record_buf: [frame.max_wire_record_len + 64]u8 = undefined;
    const n = @min(input.len, record_buf.len);
    @memcpy(record_buf[0..n], input[0..n]);
    var out: [4096]u8 = undefined;
    const random: client_hello.Random = .init(@splat(0));
    _ = server.handleRecord(record_buf[0..n], random, &out) catch return;
}

// RFC 8446 Appendix A — malformed server inputs are covered by fuzzing.
test "fuzz: ServerHandshake.handleRecord rejects arbitrary input" {
    try testing.fuzz({}, fuzzHandleRecord, .{});
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

    var client: ClientHandshake = .init(client_keypair);
    client.offerAlpn(&.{"h2"});
    client.policy.host_name = "ztls.server.test";
    var client_out: [1024]u8 = undefined;
    const ch_record = try client.start(&client_out, .zero, "ztls.server.test");
    client.completeWrite();

    var server: ServerHandshake = .init(server_keypair);
    server.supportAlpn(&.{"h2"});
    const suites = [_]CipherSuite{suite};
    server.supportSuites(&suites);
    var server_out: [4096]u8 = undefined;
    const sh_record = try server.acceptClientHello(ch_record, .zero, &server_out);
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
    record[0..frame.header_len].* = mem.toBytes(frame.Header.init(.handshake, @intCast(ch.len)));
    @memcpy(record[frame.header_len..][0..ch.len], ch);

    var hs: ServerHandshake = .init(.generate());
    const suites = [_]CipherSuite{.chacha20_poly1305_sha256};
    hs.supportSuites(&suites);
    var out: [256]u8 = undefined;
    const sh_record = try hs.acceptClientHello(record[0 .. frame.header_len + ch.len], .zero, &out);
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
    record[0..frame.header_len].* = mem.toBytes(frame.Header.init(.handshake, @intCast(ch.len)));
    @memcpy(record[frame.header_len..][0..ch.len], ch);

    var hs: ServerHandshake = .init(.generate());
    var out: [256]u8 = undefined;
    _ = try hs.acceptClientHello(record[0 .. frame.header_len + ch.len], .zero, &out);
    try testing.expectEqualStrings("example.com", hs.clientServerName().?);
}

// RFC 6066 §3 — SNI is optional; no server_name extension means null.
test "acceptClientHello: clientServerName is null when SNI absent" {
    const client_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, client_keypair.public_key, null, &.{});
    var record: [1024]u8 = undefined;
    record[0..frame.header_len].* = mem.toBytes(frame.Header.init(.handshake, @intCast(ch.len)));
    @memcpy(record[frame.header_len..][0..ch.len], ch);

    var hs: ServerHandshake = .init(.generate());
    var out: [256]u8 = undefined;
    _ = try hs.acceptClientHello(record[0 .. frame.header_len + ch.len], .zero, &out);
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
    record[0..frame.header_len].* = mem.toBytes(frame.Header.init(.handshake, @intCast(ch.len)));
    @memcpy(record[frame.header_len..][0..ch.len], ch);
    var hs: ServerHandshake = .init(.generate());
    var out: [256]u8 = undefined;
    try testing.expectError(
        error.UnsupportedCipherSuite,
        hs.acceptClientHello(record[0 .. frame.header_len + ch.len], .zero, &out),
    );
}
