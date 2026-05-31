/// TLS 1.3 ClientHello handshake message encoding.
///
/// RFC 8446 §4.1.2
const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;

const CipherSuite = @import("root.zig").CipherSuite;
const memx = @import("memx.zig");
const wire = @import("wire.zig");
const x25519 = @import("x25519.zig");

pub const Random = memx.Array(32);

/// RFC 8446 §4.1.2 — legacy_version is frozen at 0x0303.
const legacy_version: u16 = 0x0303;

/// RFC 8446 §4.2.7
const NamedGroup = enum(u16) { x25519 = 0x001d };

/// RFC 8446 §4.2.3
const SignatureScheme = enum(u16) {
    ecdsa_secp256r1_sha256 = 0x0403,
    ecdsa_secp384r1_sha384 = 0x0503,
    rsa_pss_rsae_sha256 = 0x0804,
    rsa_pss_rsae_sha384 = 0x0805,
};

const cipher_suite_count = std.meta.tags(CipherSuite).len;
const sig_scheme_count = std.meta.tags(SignatureScheme).len;

const handshake_header_len = 4;
const ext_header_len = 2 + 2; // extension type + data length field
const sni_overhead = 2 + 1 + 2; // ServerNameList length + NameType + name length field

const body_fixed_len =
    2 + // legacy_version
    32 + // random
    1 + // legacy_session_id length
    2 + cipher_suite_count * 2 + // cipher_suites
    2 + // legacy_compression_methods
    2; // extensions length

const ext_supported_versions_len = ext_header_len + 1 + 2;
const ext_supported_groups_len = ext_header_len + 2 + 2;
const ext_sig_algs_len = ext_header_len + 2 + sig_scheme_count * 2;
const ext_key_share_len = ext_header_len + 2 + 2 + 2 + 32;

pub const AlpnProtocols = []const []const u8;

pub const AlpnError = error{ TooManyAlpnBytes, EmptyAlpnProtocol, AlpnProtocolTooLong };

fn alpnExtDataLen(protocols: AlpnProtocols) AlpnError!u16 {
    var list_len: usize = 0;
    for (protocols) |protocol| {
        if (protocol.len == 0) return error.EmptyAlpnProtocol;
        if (protocol.len > 255) return error.AlpnProtocolTooLong;
        list_len += 1 + protocol.len;
    }
    if (list_len > std.math.maxInt(u16) - 2) return error.TooManyAlpnBytes;
    return @intCast(2 + list_len);
}

fn alpnExtLen(protocols: AlpnProtocols) AlpnError!u16 {
    const data_len = try alpnExtDataLen(protocols);
    return ext_header_len + data_len;
}

fn sniExtLen(name: []const u8) u16 {
    return ext_header_len + sni_overhead + @as(u16, @intCast(name.len));
}

fn extensionsLen(server_name: ?[]const u8, alpn_protocols: AlpnProtocols) AlpnError!u16 {
    const sni: u16 = if (server_name) |n| sniExtLen(n) else 0;
    const alpn: u16 = if (alpn_protocols.len == 0) 0 else try alpnExtLen(alpn_protocols);
    const total = sni +
        alpn +
        ext_supported_versions_len +
        ext_supported_groups_len +
        ext_sig_algs_len +
        ext_key_share_len;
    assert(total <= std.math.maxInt(u16));
    return @intCast(total);
}

pub fn encodedLen(server_name: ?[]const u8, alpn_protocols: AlpnProtocols) AlpnError!usize {
    return handshake_header_len + body_fixed_len + try extensionsLen(server_name, alpn_protocols);
}

/// Encode a ClientHello handshake message into `out`.
///
/// Returns the written slice. Feed it into the transcript hash before wrapping
/// in a TLS record — the transcript covers the handshake header + body, not
/// the outer record header.
///
/// RFC 8446 §4.1.2
pub fn encode(
    out: []u8,
    random: Random,
    public_key: x25519.PublicKey,
    server_name: ?[]const u8,
    alpn_protocols: AlpnProtocols,
) (error{ BufferTooShort, ServerNameTooLong } || AlpnError)![]u8 {
    // RFC 6066 §3: HostName is a DNS name, max 253 octets.
    if (server_name) |name| if (name.len > 253) return error.ServerNameTooLong;
    const ext_len = try extensionsLen(server_name, alpn_protocols);
    const encoded_len = handshake_header_len + body_fixed_len + ext_len;
    if (out.len < encoded_len) return error.BufferTooShort;

    var w: wire.Writer = .init(out);

    // Handshake header (RFC 8446 §4)
    w.append(u8, 0x01); // client_hello
    w.append(u24, @intCast(body_fixed_len + ext_len));

    // ClientHello body (RFC 8446 §4.1.2)
    w.append(u16, legacy_version);
    w.appendSlice(&random.data);
    w.append(u8, 0x00); // legacy_session_id: empty
    w.append(u16, cipher_suite_count * 2);
    inline for (std.meta.tags(CipherSuite)) |cs| w.append(CipherSuite, cs);
    w.append(u8, 0x01); // legacy_compression_methods length
    w.append(u8, 0x00); // no compression
    w.append(u16, ext_len);

    // server_name (RFC 8446 §4.2, RFC 6066 §3)
    if (server_name) |name| {
        const name_len: u16 = @intCast(name.len);
        const entry_len: u16 = 1 + 2 + name_len; // NameType + name length field + name
        const list_len: u16 = entry_len;
        const ext_data_len: u16 = 2 + entry_len; // ServerNameList length field + entry
        w.append(u16, 0x0000);
        w.append(u16, ext_data_len);
        w.append(u16, list_len);
        w.append(u8, 0x00); // NameType: host_name
        w.append(u16, name_len);
        w.appendSlice(name);
    }

    // application_layer_protocol_negotiation (RFC 7301 §3.1)
    if (alpn_protocols.len != 0) {
        const ext_data_len = try alpnExtDataLen(alpn_protocols);
        w.append(u16, 0x0010);
        w.append(u16, ext_data_len);
        w.append(u16, ext_data_len - 2);
        for (alpn_protocols) |protocol| {
            w.append(u8, @intCast(protocol.len));
            w.appendSlice(protocol);
        }
    }

    // supported_versions (RFC 8446 §4.2.1)
    w.append(u16, 0x002b);
    w.append(u16, 3);
    w.append(u8, 0x02); // versions list length
    w.append(u16, 0x0304); // TLS 1.3

    // supported_groups (RFC 8446 §4.2.7)
    w.append(u16, 0x000a);
    w.append(u16, 4);
    w.append(u16, 2); // named_group_list length
    w.append(NamedGroup, .x25519);

    // signature_algorithms (RFC 8446 §4.2.3)
    w.append(u16, 0x000d);
    w.append(u16, 2 + sig_scheme_count * 2);
    w.append(u16, sig_scheme_count * 2);
    inline for (std.meta.tags(SignatureScheme)) |s| w.append(SignatureScheme, s);

    // key_share (RFC 8446 §4.2.8)
    w.append(u16, 0x0033);
    w.append(u16, 2 + 2 + 2 + 32);
    w.append(u16, 2 + 2 + 32);
    w.append(NamedGroup, .x25519);
    w.append(u16, 32); // key_exchange length
    w.appendSlice(&public_key.data);

    return w.written();
}

test "encode: size matches encodedLen" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, "server", &.{});
    try testing.expectEqual(try encodedLen("server", &.{}), encoded.len);
}

test "encode: handshake type and legacy version" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    try testing.expectEqual(@as(u8, 0x01), encoded[0]);
    try testing.expectEqual(@as(u8, 0x03), encoded[4]);
    try testing.expectEqual(@as(u8, 0x03), encoded[5]);
}

test "encode: cipher suites" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    const cs_offset = 39; // header(4) + version(2) + random(32) + session_id(1)
    try testing.expectEqualSlices(u8, &.{ 0x00, 0x06 }, encoded[cs_offset..][0..2]);
    try testing.expectEqualSlices(u8, &.{ 0x13, 0x01 }, encoded[cs_offset + 2 ..][0..2]);
    try testing.expectEqualSlices(u8, &.{ 0x13, 0x03 }, encoded[cs_offset + 4 ..][0..2]);
    try testing.expectEqualSlices(u8, &.{ 0x13, 0x02 }, encoded[cs_offset + 6 ..][0..2]);
}

test "encode: key_share contains public key" {
    const key: x25519.PublicKey = .init(.{
        0x99, 0x38, 0x1d, 0xe5, 0x60, 0xe4, 0xbd, 0x43,
        0xd2, 0x3d, 0x8e, 0x43, 0x5a, 0x7d, 0xba, 0xfe,
        0xb3, 0xc0, 0x6e, 0x51, 0xc1, 0x3c, 0xae, 0x4d,
        0x54, 0x13, 0x69, 0x1e, 0x52, 0x9a, 0xaf, 0x2c,
    });
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, key, null, &.{});
    var found = false;
    var i: usize = 0;
    while (i + 1 < encoded.len) : (i += 1) {
        if (encoded[i] == 0x00 and encoded[i + 1] == 0x33) {
            try testing.expectEqualSlices(u8, &key.data, encoded[i + 10 ..][0..32]);
            found = true;
            break;
        }
    }
    try testing.expect(found);
}

test "encode: SNI present when server_name set" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, "example.com", &.{});
    var found = false;
    var i: usize = 0;
    while (i + 1 < encoded.len) : (i += 1) {
        if (encoded[i] == 0x00 and encoded[i + 1] == 0x00) {
            found = true;
            break;
        }
    }
    try testing.expect(found);
}

test "encode: SNI absent when server_name is null" {
    var buf: [512]u8 = undefined;
    const with = try encode(&buf, .zero, .zero, "example.com", &.{});
    const without = try encode(&buf, .zero, .zero, null, &.{});
    try testing.expect(with.len > without.len);
}

test "encode: ALPN present when protocols set" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{ "h2", "http/1.1" });
    var found = false;
    var i: usize = 0;
    while (i + 1 < encoded.len) : (i += 1) {
        if (encoded[i] == 0x00 and encoded[i + 1] == 0x10) {
            try testing.expectEqualSlices(u8, &.{ 0x00, 0x0e, 0x00, 0x0c, 0x02, 'h', '2', 0x08 }, encoded[i + 2 ..][0..8]);
            found = true;
            break;
        }
    }
    try testing.expect(found);
}

test "encode: rejects invalid ALPN protocols" {
    var buf: [512]u8 = undefined;
    try testing.expectError(error.EmptyAlpnProtocol, encode(&buf, .zero, .zero, null, &.{""}));
    try testing.expectError(error.AlpnProtocolTooLong, encode(&buf, .zero, .zero, null, &.{"a" ** 256}));
}

test "encode: buffer too short" {
    var buf: [10]u8 = undefined;
    try testing.expectError(error.BufferTooShort, encode(&buf, .zero, .zero, null, &.{}));
}

test "encode: server_name too long" {
    var buf: [512]u8 = undefined;
    const long_name = "a" ** 254;
    try testing.expectError(error.ServerNameTooLong, encode(&buf, .zero, .zero, long_name, &.{}));
}
