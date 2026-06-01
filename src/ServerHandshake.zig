/// TLS 1.3 server handshake state machine skeleton.
///
/// This is intentionally narrow: parse ClientHello, choose parameters, emit
/// plaintext ServerHello, and install handshake traffic keys. Encrypted flight
/// and Finished processing come next. No allocations, no I/O.
const std = @import("std");
const assert = std.debug.assert;
const Sha256 = std.crypto.hash.sha2.Sha256;
const Sha384 = std.crypto.hash.sha2.Sha384;
const mem = std.mem;

const aead = @import("aead.zig");
const client_hello = @import("client_hello.zig");
const certificate = @import("certificate.zig");
const encrypted_extensions = @import("encrypted_extensions.zig");
const finished = @import("finished.zig");
const frame = @import("frame.zig");
const hkdf = @import("hkdf.zig");
const RecordLayer = @import("RecordLayer.zig");
const server_hello = @import("server_hello.zig");
const x25519 = @import("x25519.zig");
const CipherSuite = @import("root.zig").CipherSuite;

const ServerHandshake = @This();

pub const State = enum {
    wait_ch,
    wait_client_finished,
    connected,
};

fn HashArm(comptime Hkdf_: type, comptime Hash: type) type {
    return struct {
        transcript: Hash,
        aead: aead.Keys,
        handshake_secret: Hkdf_.Prk,
        client_finished_key: Hkdf_.Prk,
        server_finished_key: Hkdf_.Prk,

        const Hkdf = Hkdf_;
    };
}

const Suite = union(enum) {
    sha256: HashArm(hkdf.HkdfSha256, Sha256),
    sha384: HashArm(hkdf.HkdfSha384, Sha384),

    fn update(self: *Suite, msg: []const u8) void {
        switch (self.*) {
            inline .sha256, .sha384 => |*s| s.transcript.update(msg),
        }
    }
};

state: State = .wait_ch,
keypair: x25519.KeyPair,
suite: CipherSuite = .aes_128_gcm_sha256,
suite_state: Suite = undefined,
alpn_protocols: client_hello.AlpnProtocols = &.{},
selected_alpn: ?[]const u8 = null,
rx: RecordLayer = undefined,
tx: RecordLayer = undefined,

pub fn init(keypair: x25519.KeyPair) ServerHandshake {
    return .{ .keypair = keypair };
}

pub fn supportAlpn(self: *ServerHandshake, protocols: client_hello.AlpnProtocols) void {
    assert(self.state == .wait_ch);
    self.alpn_protocols = protocols;
}

pub fn selectedAlpnProtocol(self: *const ServerHandshake) ?[]const u8 {
    return self.selected_alpn;
}

pub const AcceptError = frame.ParseError || client_hello.ParseError || server_hello.EncodeError || error{
    IncompleteRecord,
    UnexpectedRecord,
    UnsupportedCipherSuite,
    IdentityElement,
};

pub const SignError = error{ BufferTooShort, IdentityElement, NonCanonical };

pub const Signer = struct {
    scheme: std.crypto.tls.SignatureScheme,
    context: *anyopaque,
    sign: *const fn (context: *anyopaque, msg: []const u8, out: []u8) SignError![]const u8,
};

pub const FlightError = encrypted_extensions.EncodeError || certificate.EncodeError || certificate.CertificateVerifyEncodeError || RecordLayer.EncryptError || SignError;

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
    const suite = chooseSuite(ch) orelse return error.UnsupportedCipherSuite;
    self.suite = suite;
    self.selected_alpn = ch.selectAlpn(self.alpn_protocols);

    const sh = try server_hello.encode(out[frame.header_len..], random.data, &.{}, suite, .init(self.keypair.public_key));
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
) error{IdentityElement}!void {
    const dhe = try x25519.sharedSecret(self.keypair.secret_key, client_public_key);
    switch (suite) {
        .aes_128_gcm_sha256, .chacha20_poly1305_sha256 => {
            var transcript: Sha256 = .init(.{});
            transcript.update(ch_msg);
            transcript.update(sh_msg);
            self.suite_state = .{ .sha256 = makeHandshakeArm(hkdf.HkdfSha256, Sha256, transcript, suiteAead(suite), &dhe) };
        },
        .aes_256_gcm_sha384 => {
            var transcript: Sha384 = .init(.{});
            transcript.update(ch_msg);
            transcript.update(sh_msg);
            self.suite_state = .{ .sha384 = makeHandshakeArm(hkdf.HkdfSha384, Sha384, transcript, suiteAead(suite), &dhe) };
        },
    }

    switch (self.suite_state) {
        inline .sha256, .sha384 => |s| {
            const H = @TypeOf(s).Hkdf;
            const th = s.transcript.peek();
            const client_secret = H.clientHandshakeTrafficSecret(s.handshake_secret, &.init(th));
            const server_secret = H.serverHandshakeTrafficSecret(s.handshake_secret, &.init(th));
            self.rx = H.makeRecordLayer(s.aead, client_secret);
            self.tx = H.makeRecordLayer(s.aead, server_secret);
        },
    }
}

fn makeHandshakeArm(
    comptime H: type,
    comptime Hash: type,
    transcript: Hash,
    aead_key: aead.Keys,
    dhe: *const hkdf.SharedSecret,
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

/// Emit the encrypted part of the server flight for the current skeleton:
/// EncryptedExtensions followed by Finished. Certificate/CertificateVerify are
/// intentionally still absent, so this only models anonymous test handshakes;
/// the real authenticated flight is the next step. RFC 8446 §4.3.1, §4.4.4.
pub fn sendAnonymousFlight(self: *ServerHandshake, out: []u8) FlightError![]const u8 {
    assert(self.state == .wait_client_finished);
    var plaintext: [256]u8 = undefined;
    var pos: usize = 0;
    const ee = try encrypted_extensions.encode(plaintext[pos..], self.selected_alpn);
    self.suite_state.update(ee);
    pos += ee.len;

    switch (self.suite_state) {
        inline .sha256, .sha384 => |*s| {
            const th = s.transcript.peek();
            const fin = try finished.encode(@TypeOf(s.transcript), plaintext[pos..], &s.server_finished_key.data, &th);
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
    assert(self.state == .wait_client_finished);
    var pos: usize = 0;

    const ee = try encrypted_extensions.encode(plaintext[pos..], self.selected_alpn);
    self.suite_state.update(ee);
    pos += ee.len;

    const cert = try certificate.encode(plaintext[pos..], certs_der);
    self.suite_state.update(cert);
    pos += cert.len;

    var cv_input: [certificate.server_certificate_verify_context.len + 64]u8 = undefined;
    cv_input[0..certificate.server_certificate_verify_context.len].* = certificate.server_certificate_verify_context.*;
    const transcript_hash_len: usize = switch (self.suite_state) {
        inline .sha256, .sha384 => |*s| blk: {
            const th = s.transcript.peek();
            @memcpy(cv_input[certificate.server_certificate_verify_context.len..][0..th.len], &th);
            break :blk th.len;
        },
    };
    var sig_buf: [std.crypto.sign.ecdsa.EcdsaP384Sha384.Signature.der_encoded_length_max]u8 = undefined;
    const sig = try signer.sign(signer.context, cv_input[0 .. certificate.server_certificate_verify_context.len + transcript_hash_len], &sig_buf);
    const cv = try certificate.encodeCertificateVerify(plaintext[pos..], signer.scheme, sig);
    self.suite_state.update(cv);
    pos += cv.len;

    switch (self.suite_state) {
        inline .sha256, .sha384 => |*s| {
            const th = s.transcript.peek();
            const fin = try finished.encode(@TypeOf(s.transcript), plaintext[pos..], &s.server_finished_key.data, &th);
            s.transcript.update(fin);
            pos += fin.len;
        },
    }
    return self.tx.encrypt(.handshake, plaintext[0..pos], out);
}

fn chooseSuite(ch: client_hello.Parsed) ?CipherSuite {
    // Server preference order: AES-128 first for the cheap/default path, then
    // AES-256, then ChaCha. We can revisit once benchmarks say otherwise.
    inline for (.{ CipherSuite.aes_128_gcm_sha256, .aes_256_gcm_sha384, .chacha20_poly1305_sha256 }) |suite| {
        if (ch.offersSuite(suite)) return suite;
    }
    return null;
}

const testing = std.testing;

const test_cert_der = @embedFile("test_fixtures/server.crt.der");

const EcdsaP256Sha256 = std.crypto.sign.ecdsa.EcdsaP256Sha256;

const TestSigner = struct {
    keypair: EcdsaP256Sha256.KeyPair,

    fn sign(context: *anyopaque, msg: []const u8, out: []u8) SignError![]const u8 {
        const self: *TestSigner = @ptrCast(@alignCast(context));
        const sig = self.keypair.sign(msg, null) catch |err| switch (err) {
            error.IdentityElement => return error.IdentityElement,
            error.NonCanonical => return error.NonCanonical,
        };
        var der: [EcdsaP256Sha256.Signature.der_encoded_length_max]u8 = undefined;
        const encoded = sig.toDer(&der);
        if (out.len < encoded.len) return error.BufferTooShort;
        @memcpy(out[0..encoded.len], encoded);
        return out[0..encoded.len];
    }
};

test "acceptClientHello: emits ServerHello and installs handshake keys" {
    const client_keypair: x25519.KeyPair = .generate();
    const server_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, .init(client_keypair.public_key), "example.com", &.{ "h2", "http/1.1" });
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
    try testing.expectEqualSlices(u8, &server_keypair.public_key, &sh.server_public_key.data);

    var client_hs = @import("ClientHandshake.zig").init(client_keypair);
    client_hs.injectClientHello(ch);
    try client_hs.processServerHello(sh_record[frame.header_len..][0..hdr.length()]);
    try testing.expectEqualSlices(u8, &client_hs.rx.iv.data, &hs.tx.iv.data);
    try testing.expectEqualSlices(u8, &client_hs.tx.iv.data, &hs.rx.iv.data);
}

test "sendAnonymousFlight: client decrypts EncryptedExtensions and Finished" {
    const client_keypair: x25519.KeyPair = .generate();
    const server_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, .init(client_keypair.public_key), "example.com", &.{"h2"});
    var ch_record: [1024]u8 = undefined;
    ch_record[0..frame.header_len].* = mem.toBytes(frame.Header.init(.handshake, @intCast(ch.len)));
    @memcpy(ch_record[frame.header_len..][0..ch.len], ch);

    var server: ServerHandshake = .init(server_keypair);
    server.supportAlpn(&.{"h2"});
    var sh_out: [256]u8 = undefined;
    const sh_record = try server.acceptClientHello(ch_record[0 .. frame.header_len + ch.len], .zero, &sh_out);

    var client = @import("ClientHandshake.zig").init(client_keypair);
    client.offerAlpn(&.{"h2"});
    client.injectClientHello(ch);
    try client.processServerHello(sh_record[frame.header_len..]);

    var flight_out: [512]u8 = undefined;
    const flight_record = try server.sendAnonymousFlight(&flight_out);
    const dec = try client.rx.decrypt(flight_out[0..flight_record.len]);
    try testing.expectEqual(.handshake, dec.content_type);

    var hr: @import("ClientHandshake.zig").HandshakeReader = .init(dec.content);
    const ee = (try hr.next()).?;
    try testing.expectEqual(@import("ClientHandshake.zig").HandshakeType.encrypted_extensions, ee.type);
    const parsed_ee = try encrypted_extensions.parse(ee.raw, &.{"h2"});
    try testing.expectEqualStrings("h2", parsed_ee.alpn_protocol.?);
    var transcript: Sha256 = .init(.{});
    transcript.update(ch);
    transcript.update(sh_record[frame.header_len..]);
    transcript.update(ee.raw);

    const fin = (try hr.next()).?;
    try testing.expectEqual(@import("ClientHandshake.zig").HandshakeType.finished, fin.type);
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
    const ch = try client_hello.encode(&ch_buf, .zero, .init(client_keypair.public_key), "example.com", &.{"h2"});
    var ch_record: [1024]u8 = undefined;
    ch_record[0..frame.header_len].* = mem.toBytes(frame.Header.init(.handshake, @intCast(ch.len)));
    @memcpy(ch_record[frame.header_len..][0..ch.len], ch);

    var server: ServerHandshake = .init(server_keypair);
    server.supportAlpn(&.{"h2"});
    var sh_out: [256]u8 = undefined;
    const sh_record = try server.acceptClientHello(ch_record[0 .. frame.header_len + ch.len], .zero, &sh_out);

    var signer: TestSigner = .{ .keypair = EcdsaP256Sha256.KeyPair.generate() };
    const signer_api: Signer = .{ .scheme = .ecdsa_secp256r1_sha256, .context = &signer, .sign = TestSigner.sign };
    var plaintext: [4096]u8 = undefined;
    var flight_out: [4096]u8 = undefined;
    const flight_record = try server.sendAuthenticatedFlight(&.{test_cert_der}, signer_api, &plaintext, &flight_out);

    var client = @import("ClientHandshake.zig").init(client_keypair);
    client.offerAlpn(&.{"h2"});
    client.injectClientHello(ch);
    try client.processServerHello(sh_record[frame.header_len..]);
    const dec = try client.rx.decrypt(flight_out[0..flight_record.len]);
    try testing.expectEqual(.handshake, dec.content_type);

    var hr: @import("ClientHandshake.zig").HandshakeReader = .init(dec.content);
    try testing.expectEqual(@import("ClientHandshake.zig").HandshakeType.encrypted_extensions, (try hr.next()).?.type);
    try testing.expectEqual(@import("ClientHandshake.zig").HandshakeType.certificate, (try hr.next()).?.type);
    try testing.expectEqual(@import("ClientHandshake.zig").HandshakeType.certificate_verify, (try hr.next()).?.type);
    try testing.expectEqual(@import("ClientHandshake.zig").HandshakeType.finished, (try hr.next()).?.type);
    try testing.expectEqual(@as(?@import("ClientHandshake.zig").HandshakeReader.Message, null), try hr.next());
}

test "acceptClientHello: rejects unsupported suite" {
    const client_keypair: x25519.KeyPair = .generate();
    var ch_buf: [512]u8 = undefined;
    const ch = try client_hello.encode(&ch_buf, .zero, .init(client_keypair.public_key), null, &.{});
    // Patch offered suites to unknown values. Offsets are fixed by
    // ClientHello's fixed prefix: header(4)+version(2)+random(32)+sid_len(1).
    ch_buf[41..47].* = .{ 0x12, 0x34, 0x12, 0x35, 0x12, 0x36 };
    var record: [1024]u8 = undefined;
    record[0..frame.header_len].* = mem.toBytes(frame.Header.init(.handshake, @intCast(ch.len)));
    @memcpy(record[frame.header_len..][0..ch.len], ch);
    var hs: ServerHandshake = .init(.generate());
    var out: [256]u8 = undefined;
    try testing.expectError(error.UnsupportedCipherSuite, hs.acceptClientHello(record[0 .. frame.header_len + ch.len], .zero, &out));
}
