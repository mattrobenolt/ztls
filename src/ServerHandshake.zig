/// TLS 1.3 server handshake state machine skeleton.
///
/// This is intentionally narrow: parse ClientHello, choose parameters, and emit
/// plaintext ServerHello. Encrypted flight and Finished processing come next.
/// No allocations, no I/O.
const std = @import("std");
const assert = std.debug.assert;
const mem = std.mem;

const client_hello = @import("client_hello.zig");
const frame = @import("frame.zig");
const server_hello = @import("server_hello.zig");
const x25519 = @import("x25519.zig");
const CipherSuite = @import("root.zig").CipherSuite;

const ServerHandshake = @This();

pub const State = enum {
    wait_ch,
    wait_client_finished,
    connected,
};

state: State = .wait_ch,
keypair: x25519.KeyPair,
suite: CipherSuite = .aes_128_gcm_sha256,
alpn_protocols: client_hello.AlpnProtocols = &.{},
selected_alpn: ?[]const u8 = null,

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
};

/// Consume a plaintext ClientHello record and emit a plaintext ServerHello
/// record. The returned bytes must be written before continuing the handshake.
/// RFC 8446 §4.1.2, §4.1.3, §5.1.
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

    const ch = try client_hello.parse(record[frame.header_len..][0..hdr.length()]);
    const suite = chooseSuite(ch) orelse return error.UnsupportedCipherSuite;
    self.suite = suite;
    self.selected_alpn = ch.selectAlpn(self.alpn_protocols);

    const sh = try server_hello.encode(out[frame.header_len..], random.data, &.{}, suite, .init(self.keypair.public_key));
    out[0..frame.header_len].* = mem.toBytes(frame.Header.init(.handshake, @intCast(sh.len)));
    self.state = .wait_client_finished;
    return out[0 .. frame.header_len + sh.len];
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

test "acceptClientHello: emits ServerHello" {
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
