/// TLS 1.3 ClientHello handshake message encoding.
///
/// RFC 8446 §4.1.2
const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;
const mem = std.mem;

const alpn_mod = @import("alpn.zig");
pub const AlpnProtocols = alpn_mod.Protocols;
pub const AlpnError = alpn_mod.Error;
const CompressionMethod = @import("compression_method.zig").CompressionMethod;
const ExtensionType = @import("extension_type.zig").ExtensionType;
const handshake = @import("handshake.zig");
const kex = @import("kex.zig");
const NamedGroup = kex.NamedGroup;
const ProtocolVersion = @import("protocol_version.zig").ProtocolVersion;
const root = @import("root.zig");
const CipherSuite = root.CipherSuite;
pub const Random = root.Random;
const memx = @import("memx.zig");
const SignatureScheme = @import("signature_scheme.zig").SignatureScheme;
const wire = @import("wire.zig");
const x25519 = @import("x25519.zig");

/// RFC 8446 §4.1.2 — legacy_version is frozen at TLS 1.2.
const legacy_version: ProtocolVersion = .tls_1_2;

const cipher_suite_count = std.meta.tags(CipherSuite).len;
const supported_signature_schemes = [_]SignatureScheme{
    .ecdsa_secp256r1_sha256,
    .ecdsa_secp384r1_sha384,
    .rsa_pss_rsae_sha256,
    .rsa_pss_rsae_sha384,
};
const sig_scheme_count = supported_signature_schemes.len;

const handshake_header_len = 4;
const ext_header_len = 2 + 2; // extension type + data length field
const SniNameType = enum(u8) {
    host_name = 0,
    _,
};

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
pub const ParseError = error{
    UnexpectedEof,
    InvalidHandshakeType,
    InvalidHandshakeLength,
    InvalidVectorLength,
    InvalidExtensionLength,
    InvalidEnumTag,
    InvalidCompressionMethod,
    DuplicateExtension,
    DuplicateKeyShare,
    MissingExtension,
    UnsupportedTlsVersion,
    UnsupportedKeyShare,
};

pub const Parsed = struct {
    cipher_suites: []const u8,
    legacy_session_id: []const u8 = &.{},
    server_name: ?[]const u8 = null,
    alpn_protocols: []const u8 = &.{},
    public_key: x25519.PublicKey,

    pub fn offersSuite(self: Parsed, suite: CipherSuite) bool {
        var i: usize = 0;
        while (i < self.cipher_suites.len) : (i += 2) {
            if (memx.readInt(u16, self.cipher_suites[i..][0..2]) == @intFromEnum(suite))
                return true;
        }
        return false;
    }

    /// Return the first server-preferred protocol also present in the client's
    /// ALPN ProtocolNameList. Returned slice points at `server_protocols`, not
    /// the ClientHello buffer, so it is stable for server flight encoding.
    pub fn selectAlpn(self: Parsed, server_protocols: []const []const u8) ?[]const u8 {
        for (server_protocols) |server_protocol| {
            var r: wire.Reader = .init(self.alpn_protocols);
            while (r.pos < self.alpn_protocols.len) {
                const len = r.read(u8) catch return null;
                const client_protocol = r.readSlice(len) catch return null;
                if (mem.eql(u8, server_protocol, client_protocol)) return server_protocol;
            }
        }
        return null;
    }
};

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
    w.append(handshake.Type, .client_hello);
    w.append(u24, @intCast(body_fixed_len + ext_len));

    // ClientHello body (RFC 8446 §4.1.2)
    w.append(ProtocolVersion, legacy_version);
    w.appendSlice(&random.data);
    w.append(u8, 0x00); // legacy_session_id: empty
    w.append(u16, cipher_suite_count * 2);
    inline for (std.meta.tags(CipherSuite)) |cs| w.append(CipherSuite, cs);
    w.append(u8, 0x01); // legacy_compression_methods length
    w.append(CompressionMethod, .no_compression);
    w.append(u16, ext_len);

    // server_name (RFC 8446 §4.2, RFC 6066 §3)
    if (server_name) |name| {
        const name_len: u16 = @intCast(name.len);
        const entry_len: u16 = 1 + 2 + name_len; // NameType + name length field + name
        const list_len: u16 = entry_len;
        const ext_data_len: u16 = 2 + entry_len; // ServerNameList length field + entry
        w.append(ExtensionType, .server_name);
        w.append(u16, ext_data_len);
        w.append(u16, list_len);
        w.append(SniNameType, .host_name);
        w.append(u16, name_len);
        w.appendSlice(name);
    }

    // application_layer_protocol_negotiation (RFC 7301 §3.1)
    if (alpn_protocols.len != 0) {
        const ext_data_len = try alpnExtDataLen(alpn_protocols);
        w.append(ExtensionType, .alpn);
        w.append(u16, ext_data_len);
        w.append(u16, ext_data_len - 2);
        for (alpn_protocols) |protocol| {
            w.append(u8, @intCast(protocol.len));
            w.appendSlice(protocol);
        }
    }

    // supported_versions (RFC 8446 §4.2.1)
    w.append(ExtensionType, .supported_versions);
    w.append(u16, 3);
    w.append(u8, 0x02); // versions list length
    w.append(ProtocolVersion, .tls_1_3);

    // supported_groups (RFC 8446 §4.2.7)
    w.append(ExtensionType, .supported_groups);
    w.append(u16, 4);
    w.append(u16, 2); // named_group_list length
    w.append(NamedGroup, .x25519);

    // signature_algorithms (RFC 8446 §4.2.3)
    w.append(ExtensionType, .signature_algorithms);
    w.append(u16, 2 + sig_scheme_count * 2);
    w.append(u16, sig_scheme_count * 2);
    inline for (supported_signature_schemes) |s| w.append(SignatureScheme, s);

    // key_share (RFC 8446 §4.2.8)
    w.append(ExtensionType, .key_share);
    w.append(u16, 2 + 2 + 2 + 32);
    w.append(u16, 2 + 2 + 32);
    w.append(NamedGroup, .x25519);
    w.append(u16, 32); // key_exchange length
    w.appendSlice(&public_key.data);

    return w.written();
}

pub fn parse(msg: []const u8) ParseError!Parsed {
    if (msg.len < handshake_header_len + 2 + 32 + 1 + 2 + 1 + 2) return error.UnexpectedEof;
    var r: wire.Reader = .init(msg);
    const handshake_type = r.assumeRead(handshake.Type);
    if (handshake_type != .client_hello) return error.InvalidHandshakeType;
    const body_len = r.assumeRead(u24);
    if (body_len != msg.len - handshake_header_len) return error.InvalidHandshakeLength;

    r.assumeSkip(2); // legacy_version
    r.assumeSkip(32); // random
    const session_id_len = r.assumeRead(u8);
    if (r.remaining().len < session_id_len + 2) return error.UnexpectedEof;
    const legacy_session_id = r.assumeReadSlice(session_id_len);

    const cipher_suites_len = r.assumeRead(u16);
    if (cipher_suites_len == 0 or cipher_suites_len % 2 != 0) return error.InvalidVectorLength;
    if (r.remaining().len < cipher_suites_len + 1) return error.UnexpectedEof;
    const cipher_suites = r.assumeReadSlice(cipher_suites_len);

    const compression_len = r.assumeRead(u8);
    if (compression_len != 1) return error.InvalidCompressionMethod;
    if (r.remaining().len < compression_len + 2) return error.UnexpectedEof;
    const compression_method = r.assumeRead(CompressionMethod);
    if (compression_method != .no_compression) return error.InvalidCompressionMethod;

    const extensions_len = r.assumeRead(u16);
    if (extensions_len > msg.len - r.pos) return error.InvalidExtensionLength;
    const extensions_end = r.pos + extensions_len;

    var parsed: Parsed = .{
        .cipher_suites = cipher_suites,
        .legacy_session_id = legacy_session_id,
        .public_key = undefined,
    };
    var got_supported_versions = false;
    var got_key_share = false;
    var got_server_name = false;
    var got_alpn = false;
    var got_supported_groups = false;
    var got_signature_algorithms = false;

    while (r.pos < extensions_end) {
        if (extensions_end - r.pos < 4) return error.InvalidExtensionLength;
        const ext_type = r.assumeRead(ExtensionType);
        const ext_len = r.assumeRead(u16);
        if (ext_len > extensions_end - r.pos) return error.InvalidExtensionLength;
        const ext = r.assumeReadSlice(ext_len);

        switch (ext_type) {
            .server_name => {
                if (got_server_name) return error.DuplicateExtension;
                parsed.server_name = try parseSni(ext);
                got_server_name = true;
            },
            .supported_groups => {
                if (got_supported_groups) return error.DuplicateExtension;
                try parseSupportedGroups(ext);
                got_supported_groups = true;
            },
            .alpn => {
                if (got_alpn) return error.DuplicateExtension;
                parsed.alpn_protocols = try parseAlpn(ext);
                got_alpn = true;
            },
            .supported_versions => {
                if (got_supported_versions) return error.DuplicateExtension;
                try parseSupportedVersions(ext);
                got_supported_versions = true;
            },
            .signature_algorithms => {
                if (got_signature_algorithms) return error.DuplicateExtension;
                try parseSignatureAlgorithms(ext);
                got_signature_algorithms = true;
            },
            .key_share => {
                if (got_key_share) return error.DuplicateExtension;
                parsed.public_key = try parseKeyShare(ext);
                got_key_share = true;
            },
            else => {},
        }
    }
    if (r.pos != extensions_end) return error.InvalidExtensionLength;
    if (!got_supported_versions) return error.UnsupportedTlsVersion;
    if (!got_supported_groups or !got_signature_algorithms or !got_key_share)
        return error.MissingExtension;
    return parsed;
}

fn parseSni(ext: []const u8) ParseError!?[]const u8 {
    if (ext.len < 2) return error.InvalidExtensionLength;
    var r: wire.Reader = .init(ext);
    const list_len = r.assumeRead(u16);
    if (list_len != ext.len - 2) return error.InvalidExtensionLength;
    if (list_len == 0) return null;
    if (r.remaining().len < 1 + 2) return error.InvalidVectorLength;
    const name_type = r.assumeRead(SniNameType);
    const name_len = r.assumeRead(u16);
    if (r.remaining().len < name_len) return error.InvalidVectorLength;
    const name = r.assumeReadSlice(name_len);
    if (r.pos != ext.len) return error.InvalidVectorLength;
    if (name_type != .host_name) return null;
    return name;
}

fn parseAlpn(ext: []const u8) ParseError![]const u8 {
    if (ext.len < 2) return error.InvalidExtensionLength;
    var r: wire.Reader = .init(ext);
    const list_len = r.assumeRead(u16);
    if (list_len != ext.len - 2) return error.InvalidExtensionLength;
    return r.assumeReadSlice(list_len);
}

fn parseSupportedVersions(ext: []const u8) ParseError!void {
    if (ext.len < 1) return error.InvalidVectorLength;
    var r: wire.Reader = .init(ext);
    const list_len = r.assumeRead(u8);
    if (list_len != ext.len - 1 or list_len % 2 != 0) return error.InvalidVectorLength;
    while (r.pos < ext.len) {
        if (r.assumeRead(ProtocolVersion) == .tls_1_3) return;
    }
    return error.UnsupportedTlsVersion;
}

fn parseSupportedGroups(ext: []const u8) ParseError!void {
    if (ext.len < 2) return error.InvalidVectorLength;
    var r: wire.Reader = .init(ext);
    const list_len = r.assumeRead(u16);
    if (list_len != ext.len - 2 or list_len % 2 != 0) return error.InvalidVectorLength;
    while (r.pos < ext.len) {
        if (r.assumeRead(u16) == @intFromEnum(NamedGroup.x25519)) return;
    }
    return error.UnsupportedKeyShare;
}

fn parseSignatureAlgorithms(ext: []const u8) ParseError!void {
    if (ext.len < 2) return error.InvalidVectorLength;
    var r: wire.Reader = .init(ext);
    const list_len = r.assumeRead(u16);
    if (list_len == 0 or list_len != ext.len - 2 or list_len % 2 != 0)
        return error.InvalidVectorLength;
}

fn parseKeyShare(ext: []const u8) ParseError!x25519.PublicKey {
    if (ext.len < 2) return error.InvalidVectorLength;
    var r: wire.Reader = .init(ext);
    const client_shares_len = r.assumeRead(u16);
    if (client_shares_len != ext.len - 2) return error.InvalidVectorLength;
    var public_key: ?x25519.PublicKey = null;
    while (r.pos < ext.len) {
        if (r.remaining().len < 4) return error.InvalidVectorLength;
        const group = r.assumeRead(u16);
        const key_len = r.assumeRead(u16);
        if (r.remaining().len < key_len) return error.InvalidVectorLength;
        const key = r.assumeReadSlice(key_len);
        if (group == @intFromEnum(NamedGroup.x25519)) {
            if (public_key != null) return error.DuplicateKeyShare;
            if (key.len != 32) return error.UnsupportedKeyShare;
            public_key = .init(key[0..32].*);
        }
    }
    return public_key orelse error.UnsupportedKeyShare;
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

// RFC 8446 §4.1.2 — without compatibility mode, legacy_session_id is empty.
test "encode: legacy_session_id is empty" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    const session_id_len_offset = 38; // header(4) + legacy_version(2) + random(32)
    try testing.expectEqual(@as(u8, 0), encoded[session_id_len_offset]);
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

test "encode: supported_versions contains TLS 1.3" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    const ext = try findExtension(encoded, .supported_versions);
    try testing.expectEqualSlices(u8, &.{ 0x02, 0x03, 0x04 }, ext);
}

test "encode: ALPN present when protocols set" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{ "h2", "http/1.1" });
    var found = false;
    var i: usize = 0;
    while (i + 1 < encoded.len) : (i += 1) {
        if (encoded[i] == 0x00 and encoded[i + 1] == 0x10) {
            const alpn_prefix = [_]u8{ 0x00, 0x0e, 0x00, 0x0c, 0x02, 'h', '2', 0x08 };
            try testing.expectEqualSlices(u8, &alpn_prefix, encoded[i + 2 ..][0..8]);
            found = true;
            break;
        }
    }
    try testing.expect(found);
}

test "encode: rejects invalid ALPN protocols" {
    var buf: [512]u8 = undefined;
    try testing.expectError(error.EmptyAlpnProtocol, encode(&buf, .zero, .zero, null, &.{""}));
    try testing.expectError(
        error.AlpnProtocolTooLong,
        encode(&buf, .zero, .zero, null, &.{"a" ** 256}),
    );
}

test "parse: encoded ClientHello" {
    const key: x25519.PublicKey = .init(.{
        0x99, 0x38, 0x1d, 0xe5, 0x60, 0xe4, 0xbd, 0x43,
        0xd2, 0x3d, 0x8e, 0x43, 0x5a, 0x7d, 0xba, 0xfe,
        0xb3, 0xc0, 0x6e, 0x51, 0xc1, 0x3c, 0xae, 0x4d,
        0x54, 0x13, 0x69, 0x1e, 0x52, 0x9a, 0xaf, 0x2c,
    });
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, key, "example.com", &.{ "h2", "http/1.1" });
    const parsed = try parse(encoded);
    try testing.expect(parsed.offersSuite(.aes_128_gcm_sha256));
    try testing.expect(parsed.offersSuite(.aes_256_gcm_sha384));
    try testing.expect(parsed.offersSuite(.chacha20_poly1305_sha256));
    try testing.expectEqualStrings("example.com", parsed.server_name.?);
    try testing.expectEqualSlices(u8, &key.data, &parsed.public_key.data);
    const alpn_wire = [_]u8{ 0x02, 'h', '2', 0x08, 'h', 't', 't', 'p', '/', '1', '.', '1' };
    try testing.expectEqualSlices(u8, &alpn_wire, parsed.alpn_protocols);
    try testing.expectEqualStrings("http/1.1", parsed.selectAlpn(&.{ "http/1.1", "h2" }).?);
    try testing.expectEqualStrings("h2", parsed.selectAlpn(&.{"h2"}).?);
    try testing.expectEqual(@as(?[]const u8, null), parsed.selectAlpn(&.{"bogus"}));
}

test "parse: ignores legacy_version" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    buf[4] = 0x03;
    buf[5] = 0x01;
    _ = try parse(buf[0..encoded.len]);
}

test "parse: rejects missing supported_versions" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    const offset = try findExtensionOffset(encoded, .supported_versions);
    buf[offset + 1] = @intFromEnum(ExtensionType.padding);
    try testing.expectError(error.UnsupportedTlsVersion, parse(buf[0..encoded.len]));
}

test "parse: rejects supported_versions without TLS 1.3" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    const ext = try findExtension(buf[0..encoded.len], .supported_versions);
    ext[1] = 0x03;
    ext[2] = 0x03;
    try testing.expectError(error.UnsupportedTlsVersion, parse(buf[0..encoded.len]));
}

// RFC 8446 §9.2 — certificate-authenticated ECDHE ClientHello requires
// supported_groups, signature_algorithms, and key_share.
test "parse: rejects missing supported_groups" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    const offset = try findExtensionOffset(encoded, .supported_groups);
    buf[offset + 1] = @intFromEnum(ExtensionType.padding);
    try testing.expectError(error.MissingExtension, parse(buf[0..encoded.len]));
}

test "parse: rejects missing signature_algorithms" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    const offset = try findExtensionOffset(encoded, .signature_algorithms);
    buf[offset + 1] = @intFromEnum(ExtensionType.padding);
    try testing.expectError(error.MissingExtension, parse(buf[0..encoded.len]));
}

test "parse: rejects malformed signature_algorithms" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    const ext = try findExtension(buf[0..encoded.len], .signature_algorithms);
    ext[1] = 0;
    try testing.expectError(error.InvalidVectorLength, parse(buf[0..encoded.len]));
}

test "parse: rejects malformed ClientHello" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});

    var bad_type: [512]u8 = undefined;
    @memcpy(bad_type[0..encoded.len], encoded);
    bad_type[0] = 0x02;
    try testing.expectError(error.InvalidHandshakeType, parse(bad_type[0..encoded.len]));

    var bad_len: [512]u8 = undefined;
    @memcpy(bad_len[0..encoded.len], encoded);
    bad_len[3] -= 1;
    try testing.expectError(error.InvalidHandshakeLength, parse(bad_len[0..encoded.len]));

    var no_key_share: [512]u8 = undefined;
    @memcpy(no_key_share[0..encoded.len], encoded);
    var i: usize = 0;
    while (i + 1 < encoded.len) : (i += 1) {
        if (no_key_share[i] == 0x00 and no_key_share[i + 1] == 0x33) {
            no_key_share[i + 1] = 0x34;
            break;
        }
    }
    try testing.expect(i + 1 < encoded.len);
    try testing.expectError(error.MissingExtension, parse(no_key_share[0..encoded.len]));
}

// RFC 8446 §4.1.2 — legacy_compression_methods must contain exactly one zero.
test "parse: rejects malformed compression methods" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});

    var empty_methods: [512]u8 = undefined;
    @memcpy(empty_methods[0..encoded.len], encoded);
    empty_methods[compression_len_offset] = 0;
    try testing.expectError(error.InvalidCompressionMethod, parse(empty_methods[0..encoded.len]));

    var extra_method: [512]u8 = undefined;
    @memcpy(extra_method[0..encoded.len], encoded);
    extra_method[compression_len_offset] = 2;
    try testing.expectError(error.InvalidCompressionMethod, parse(extra_method[0..encoded.len]));

    var non_zero_method: [512]u8 = undefined;
    @memcpy(non_zero_method[0..encoded.len], encoded);
    non_zero_method[compression_method_offset] = 1;
    try testing.expectError(error.InvalidCompressionMethod, parse(non_zero_method[0..encoded.len]));
}

// RFC 8446 §4.1.4 — when the client offers no key_share for a group the server
// supports, a conformant server sends HelloRetryRequest. ztls does not implement
// the HRR path (see docs/research/CONFORMANCE_ROADMAP.md, #1); instead
// it rejects the ClientHello with error.UnsupportedKeyShare. This test pins that
// honest current behavior so it cannot silently change without a roadmap update.
test "parse: no shared group is rejected (HRR not implemented)" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    const msg = buf[0..encoded.len];

    // Rewrite every x25519 group id (0x001d) to secp384r1 (0x0018). With .zero
    // public key bytes the only 0x001d occurrences are the supported_groups and
    // key_share group identifiers.
    var i: usize = 0;
    while (i + 1 < msg.len) : (i += 1) {
        if (msg[i] == 0x00 and msg[i + 1] == 0x1d) msg[i + 1] = 0x18;
    }
    try testing.expectError(error.UnsupportedKeyShare, parse(msg));
}

// RFC 8446 §4.2.8 — ClientHello must not contain duplicate KeyShareEntry groups.
test "parse: rejects duplicate x25519 key share entries" {
    const key_shares = [_]u8{ 0x00, 0x48 } ++
        [_]u8{ 0x00, 0x1d, 0x00, 0x20 } ++ [_]u8{0xaa} ** 32 ++
        [_]u8{ 0x00, 0x1d, 0x00, 0x20 } ++ [_]u8{0xbb} ** 32;
    try testing.expectError(error.DuplicateKeyShare, parseKeyShare(&key_shares));
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

// Offsets into an encoded ClientHello with an empty session_id and the three
// fixed cipher suites: handshake_header(4) + legacy_version(2) + random(32) +
// session_id_len(1) + cipher_suites_len(2) + cipher_suites(6) = 47.
const compression_len_offset = 47;
const compression_method_offset = 48;
const extensions_len_offset = 49;
const extensions_offset = extensions_len_offset + 2;

fn findExtensionOffset(msg: []const u8, ext_type: ExtensionType) !usize {
    var r: wire.Reader = .init(msg);
    r.assumeSkip(1 + 3 + 2 + 32);
    const session_id_len = r.assumeRead(u8);
    r.assumeSkip(session_id_len);
    const cipher_suites_len = r.assumeRead(u16);
    r.assumeSkip(cipher_suites_len);
    const compression_len = r.assumeRead(u8);
    r.assumeSkip(compression_len);
    const extensions_len = r.assumeRead(u16);
    const extensions_end = r.pos + extensions_len;
    while (r.pos < extensions_end) {
        const offset = r.pos;
        const current = r.assumeRead(ExtensionType);
        const ext_len = r.assumeRead(u16);
        if (current == ext_type) return offset;
        r.assumeSkip(ext_len);
    }
    return error.MissingExtension;
}

fn findExtension(msg: []u8, ext_type: ExtensionType) ![]u8 {
    const offset = try findExtensionOffset(msg, ext_type);
    const ext_len = memx.readInt(u16, msg[offset + 2 ..][0..2]);
    return msg[offset + 4 ..][0..ext_len];
}

// Append `ext` to the extension block of an encoded ClientHello, fixing the
// handshake body length (u24 at [1..4]) and extensions_len (u16) fields.
fn appendExtension(buf: []u8, encoded_len: usize, ext: []const u8) usize {
    @memcpy(buf[encoded_len..][0..ext.len], ext);
    const new_len = encoded_len + ext.len;
    const body_len = memx.readInt(u24, buf[1..4]) + @as(u24, @intCast(ext.len));
    memx.writeInt(u24, buf[1..4], body_len);
    const old_ext_len = memx.readInt(u16, buf[extensions_len_offset..][0..2]);
    const ext_len = old_ext_len + @as(u16, @intCast(ext.len));
    memx.writeInt(u16, buf[extensions_len_offset..][0..2], ext_len);
    return new_len;
}

// RFC 8446 §4.2 — "There MUST NOT be more than one extension of the same type in
// a given extension block." A duplicate supported_groups must be rejected, the
// same as the other recognized extensions.
test "parse: rejects duplicate supported_groups" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    const dup_supported_groups = [_]u8{ 0x00, 0x0a, 0x00, 0x04, 0x00, 0x02, 0x00, 0x1d };
    const new_len = appendExtension(&buf, encoded.len, &dup_supported_groups);
    try testing.expectError(error.DuplicateExtension, parse(buf[0..new_len]));
}

// RFC 8446 §4.2 — duplicate recognized extensions are rejected.
test "parse: rejects duplicate signature_algorithms" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    const dup_sig_algs = [_]u8{ 0x00, 0x0d, 0x00, 0x02, 0x00, 0x02 };
    const new_len = appendExtension(&buf, encoded.len, &dup_sig_algs);
    try testing.expectError(error.DuplicateExtension, parse(buf[0..new_len]));
}

// RFC 8446 §4.1.2 — a server MUST ignore unrecognized extensions in ClientHello.
// ztls skips them; this pins that current behavior so a regression that started
// rejecting unknown extensions would be caught.
test "parse: ignores unknown extension" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    // GREASE-style unknown extension type 0x5a5a with a 3-byte body.
    const unknown_ext = [_]u8{ 0x5a, 0x5a, 0x00, 0x03, 0xde, 0xad, 0xbe };
    const new_len = appendExtension(&buf, encoded.len, &unknown_ext);
    const parsed = try parse(buf[0..new_len]);
    try testing.expect(parsed.offersSuite(.aes_128_gcm_sha256));
}

// RFC 8446 §9.3 — endpoints ignore unrecognized parameters while still using
// recognized alternatives from the same vector.
test "parse: ignores unknown supported_groups entries" {
    const groups = [_]u8{ 0x00, 0x04, 0x6a, 0x6a, 0x00, 0x1d };
    try parseSupportedGroups(&groups);
}

// RFC 8446 §4.1.2 — ClientHello parse must never crash or panic on arbitrary
// wire input. Errors are expected; panics, OOB, or integer overflow are not.
fn fuzzParse(_: void, input: []const u8) anyerror!void {
    _ = parse(input) catch return;
}

test "fuzz: parse handles arbitrary input" {
    // Seed with a valid encoded ClientHello so the fuzzer starts from a
    // structurally plausible baseline and can explore truncation / mutation.
    var seed_buf: [512]u8 = undefined;
    const seed = encode(&seed_buf, .zero, .zero, null, &.{}) catch &seed_buf;
    try testing.fuzz({}, fuzzParse, .{ .corpus = &.{seed} });
}
