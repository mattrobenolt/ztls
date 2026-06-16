//! TLS 1.3 ClientHello handshake message encoding.
//!
//! RFC 8446 §4.1.2
const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;
const mem = std.mem;

const alpn_mod = @import("alpn.zig");
pub const AlpnProtocols = alpn_mod.Protocols;
pub const AlpnError = alpn_mod.Error;
const CompressionMethod = @import("compression_method.zig").CompressionMethod;
const extension_type = @import("extension_type.zig");
const ExtensionType = extension_type.ExtensionType;
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
const p256 = @import("p256.zig");
const x25519 = @import("x25519.zig");

/// RFC 8446 §4.1.2 — legacy_version is frozen at TLS 1.2.
const legacy_version: ProtocolVersion = .tls_1_2;

const cipher_suite_count = std.meta.tags(CipherSuite).len;
const supported_signature_schemes = SignatureScheme.supported_handshake;
const supported_certificate_signature_schemes = SignatureScheme.supported_certificate;
const sig_scheme_count = supported_signature_schemes.len;
const cert_sig_scheme_count = supported_certificate_signature_schemes.len;

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
const ext_sig_algs_cert_len = ext_header_len + 2 + cert_sig_scheme_count * 2;
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
        ext_sig_algs_cert_len +
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
    MalformedKeyShare,
    UnsupportedSignatureScheme,
};

pub const Parsed = struct {
    cipher_suites: []const u8,
    legacy_session_id: []const u8 = &.{},
    signature_schemes: []const u8 = &.{},
    server_name: ?[]const u8 = null,
    alpn_protocols: []const u8 = &.{},
    supports_x25519: bool = false,
    supports_p256: bool = false,
    public_key: ?x25519.PublicKey = null,
    public_key_p256: ?p256.PublicKey = null,

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

    // signature_algorithms_cert (RFC 8446 §4.2.3)
    w.append(ExtensionType, .signature_algorithms_cert);
    w.append(u16, 2 + cert_sig_scheme_count * 2);
    w.append(u16, cert_sig_scheme_count * 2);
    inline for (supported_certificate_signature_schemes) |s| w.append(SignatureScheme, s);

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

    const client_legacy_version = r.assumeRead(ProtocolVersion);
    if (@intFromEnum(client_legacy_version) <= 0x0300) return error.UnsupportedTlsVersion;
    r.assumeSkip(32); // random
    const session_id_len = r.assumeRead(u8);
    if (session_id_len > 32) return error.InvalidVectorLength;
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
    try extension_type.rejectDuplicateExtensions(msg[r.pos..extensions_end]);

    var parsed: Parsed = .{
        .cipher_suites = cipher_suites,
        .legacy_session_id = legacy_session_id,
        .public_key = null,
    };
    var got_supported_versions = false;
    var got_key_share = false;
    var got_server_name = false;
    var got_alpn = false;
    var got_supported_groups = false;
    var got_signature_algorithms = false;
    var got_signature_algorithms_cert = false;

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
                const groups = try parseSupportedGroups(ext);
                parsed.supports_x25519 = groups.x25519;
                parsed.supports_p256 = groups.p256;
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
                parsed.signature_schemes = try parseSignatureAlgorithms(ext);
                got_signature_algorithms = true;
            },
            .signature_algorithms_cert => {
                if (got_signature_algorithms_cert) return error.DuplicateExtension;
                _ = try parseSignatureAlgorithms(ext);
                got_signature_algorithms_cert = true;
            },
            .key_share => {
                if (got_key_share) return error.DuplicateExtension;
                const shares = try parseKeyShare(ext);
                parsed.public_key = shares.x25519;
                parsed.public_key_p256 = shares.p256;
                got_key_share = true;
            },
            else => {},
        }
    }
    if (r.pos != extensions_end) return error.InvalidExtensionLength;
    if (!got_supported_versions) return error.UnsupportedTlsVersion;
    if (!got_supported_groups or !got_signature_algorithms or !got_key_share)
        return error.MissingExtension;
    if (!hasSupportedHandshakeSignatureScheme(parsed.signature_schemes))
        return error.UnsupportedSignatureScheme;
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

const SupportedGroups = struct {
    x25519: bool = false,
    p256: bool = false,
};

fn parseSupportedGroups(ext: []const u8) ParseError!SupportedGroups {
    if (ext.len < 2) return error.InvalidVectorLength;
    var r: wire.Reader = .init(ext);
    const list_len = r.assumeRead(u16);
    if (list_len != ext.len - 2 or list_len % 2 != 0) return error.InvalidVectorLength;
    var groups: SupportedGroups = .{};
    while (r.pos < ext.len) {
        switch (r.assumeRead(NamedGroup)) {
            .x25519 => groups.x25519 = true,
            .secp256r1 => groups.p256 = true,
            else => {},
        }
    }
    if (!groups.x25519 and !groups.p256) return error.UnsupportedKeyShare;
    return groups;
}

fn parseSignatureAlgorithms(ext: []const u8) ParseError![]const u8 {
    if (ext.len < 2) return error.InvalidVectorLength;
    var r: wire.Reader = .init(ext);
    const list_len = r.assumeRead(u16);
    if (list_len == 0 or list_len != ext.len - 2 or list_len % 2 != 0)
        return error.InvalidVectorLength;
    return r.assumeReadSlice(list_len);
}

fn hasSupportedHandshakeSignatureScheme(schemes: []const u8) bool {
    var i: usize = 0;
    while (i < schemes.len) : (i += 2) {
        const wire_scheme = memx.readInt(u16, schemes[i..][0..2]);
        const scheme: SignatureScheme = @enumFromInt(wire_scheme);
        if (scheme.supportsHandshake()) return true;
    }
    return false;
}

const ParsedKeyShares = struct {
    x25519: ?x25519.PublicKey = null,
    p256: ?p256.PublicKey = null,
};

fn parseKeyShare(ext: []const u8) ParseError!ParsedKeyShares {
    if (ext.len < 2) return error.InvalidVectorLength;
    var r: wire.Reader = .init(ext);
    const client_shares_len = r.assumeRead(u16);
    if (client_shares_len != ext.len - 2) return error.InvalidVectorLength;
    var shares: ParsedKeyShares = .{};
    while (r.pos < ext.len) {
        if (r.remaining().len < 4) return error.InvalidVectorLength;
        const group = r.assumeRead(NamedGroup);
        const key_len = r.assumeRead(u16);
        if (r.remaining().len < key_len) return error.InvalidVectorLength;
        const key = r.assumeReadSlice(key_len);
        switch (group) {
            .x25519 => {
                if (shares.x25519 != null) return error.DuplicateKeyShare;
                if (key.len != x25519.public_length) return error.UnsupportedKeyShare;
                shares.x25519 = .init(key[0..x25519.public_length].*);
            },
            .secp256r1 => {
                if (shares.p256 != null) return error.DuplicateKeyShare;
                if (key.len != p256.public_length) return error.MalformedKeyShare;
                if (key[0] != 0x04) return error.MalformedKeyShare;
                shares.p256 = .init(key[0..p256.public_length].*);
            },
            else => {},
        }
    }
    return shares;
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

// RFC 8446 §4.2.7 — the current client surface advertises X25519 as its
// supported ECDHE group.
test "encode: supported_groups contains X25519" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    const ext = try findExtension(encoded, .supported_groups);
    try testing.expectEqualSlices(u8, &.{ 0x00, 0x02, 0x00, 0x1d }, ext);
}

// RFC 8446 §4.2.8 — the current client surface sends one X25519 KeyShareEntry.
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

// RFC 8446 §4.2.3 — signature_algorithms_cert advertises certificate-specific
// signature algorithms separately from CertificateVerify algorithms.
test "encode: signature_algorithms_cert contains certificate schemes" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    const ext = try findExtension(encoded, .signature_algorithms_cert);
    try testing.expectEqualSlices(
        u8,
        &.{
            0x00, 0x0c,
            0x04, 0x01,
            0x05, 0x01,
            0x06, 0x01,
            0x04, 0x03,
            0x05, 0x03,
            0x08, 0x07,
        },
        ext,
    );
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

fn rewriteClientHelloForP256(buf: []u8, encoded_len: usize, public_key: p256.PublicKey) !usize {
    const groups = try findExtension(buf[0..encoded_len], .supported_groups);
    groups[2] = 0x00;
    groups[3] = @intFromEnum(NamedGroup.secp256r1);

    const key_share_offset = try findExtensionOffset(buf[0..encoded_len], .key_share);
    const key_share_old_len = memx.readInt(u16, buf[key_share_offset + 2 ..][0..2]);
    const key_share_old_total = ext_header_len + key_share_old_len;
    const key_share_new_len = 2 + 2 + 2 + p256.public_length;
    const key_share_new_total = ext_header_len + key_share_new_len;
    const delta = key_share_new_total - key_share_old_total;
    const tail_src = key_share_offset + key_share_old_total;
    @memmove(buf[tail_src + delta .. encoded_len + delta], buf[tail_src..encoded_len]);

    buf[key_share_offset..][0..10].* = .{
        0x00, 0x33,
        0x00, @intCast(key_share_new_len),
        0x00, @intCast(2 + 2 + p256.public_length),
        0x00, @intFromEnum(NamedGroup.secp256r1),
        0x00, @intCast(p256.public_length),
    };
    @memcpy(buf[key_share_offset + 10 ..][0..p256.public_length], &public_key.data);

    const new_len = encoded_len + delta;
    const body_len: u24 = @intCast(new_len - handshake_header_len);
    buf[1] = @intCast(body_len >> 16);
    buf[2] = @intCast((body_len >> 8) & 0xff);
    buf[3] = @intCast(body_len & 0xff);
    const old_ext_len = memx.readInt(u16, buf[extensions_len_offset..][0..2]);
    memx.writeInt(u16, buf[extensions_len_offset..][0..2], old_ext_len + @as(u16, @intCast(delta)));
    return new_len;
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
    try testing.expectEqualSlices(u8, &key.data, &parsed.public_key.?.data);
    const alpn_wire = [_]u8{ 0x02, 'h', '2', 0x08, 'h', 't', 't', 'p', '/', '1', '.', '1' };
    try testing.expectEqualSlices(u8, &alpn_wire, parsed.alpn_protocols);
    try testing.expectEqualStrings("http/1.1", parsed.selectAlpn(&.{ "http/1.1", "h2" }).?);
    try testing.expectEqualStrings("h2", parsed.selectAlpn(&.{"h2"}).?);
    try testing.expectEqual(@as(?[]const u8, null), parsed.selectAlpn(&.{"bogus"}));
}

// RFC 8446 §4.1.2 — legacy_session_id is bounded to 0..32 bytes.
// RFC 8446 §4.2.7, §4.2.8 — server-side parser accepts P-256-only peers.
test "parse: accepts secp256r1 supported group and key share" {
    const seed = memx.hex(32, "000102030405060708090a0b0c0d0e0f" ++
        "101112131415161718191a1b1c1d1e1f");
    const p256_keypair = try p256.KeyPair.generateDeterministic(.init(seed));
    var buf: [768]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    const p256_len = try rewriteClientHelloForP256(&buf, encoded.len, p256_keypair.public_key);

    const parsed = try parse(buf[0..p256_len]);
    try testing.expect(!parsed.supports_x25519);
    try testing.expect(parsed.supports_p256);
    try testing.expectEqual(@as(?x25519.PublicKey, null), parsed.public_key);
    try testing.expectEqualSlices(
        u8,
        &p256_keypair.public_key.data,
        &parsed.public_key_p256.?.data,
    );
}

test "parse: rejects oversized legacy_session_id" {
    inline for (.{ 33, 255 }) |session_id_len| {
        var buf: [512]u8 = undefined;
        const encoded = try encode(&buf, .zero, .zero, null, &.{});
        const session_id_len_offset = 38; // header(4) + legacy_version(2) + random(32)
        const session_id_offset = session_id_len_offset + 1;
        const bad_len = encoded.len + session_id_len;
        const body_len: u24 = @intCast(encoded.len - handshake_header_len + session_id_len);

        @memmove(
            buf[session_id_offset + session_id_len .. bad_len],
            encoded[session_id_offset..encoded.len],
        );
        @memset(buf[session_id_offset..][0..session_id_len], 0xaa);
        buf[session_id_len_offset] = session_id_len;
        buf[1] = @truncate(body_len >> 16);
        buf[2] = @truncate(body_len >> 8);
        buf[3] = @truncate(body_len);

        try testing.expectError(error.InvalidVectorLength, parse(buf[0..bad_len]));
    }
}

// RFC 8446 Appendix D.5 — endpoints receiving Hello legacy_version values at
// or below SSLv3 abort with protocol_version; 0x0301 remains version-negotiated
// by the supported_versions extension.
test "parse: rejects SSLv3-or-lower legacy_version" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    buf[4] = 0x03;
    buf[5] = 0x00;
    try testing.expectError(error.UnsupportedTlsVersion, parse(buf[0..encoded.len]));

    buf[4] = 0x02;
    buf[5] = 0x00;
    try testing.expectError(error.UnsupportedTlsVersion, parse(buf[0..encoded.len]));

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

// RFC 8446 §4.2.3 — TLS 1.3 CertificateVerify signatures cannot use legacy
// SHA-1 or obsolete TLS 1.2 hash/signature pairs.
test "parse: rejects signature_algorithms without TLS 1.3 handshake scheme" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    const ext = try findExtension(buf[0..encoded.len], .signature_algorithms);
    var i: usize = 2;
    while (i < ext.len) : (i += 2) {
        ext[i] = 0x02;
        ext[i + 1] = 0x01;
    }
    try testing.expectError(error.UnsupportedSignatureScheme, parse(buf[0..encoded.len]));
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

// RFC 8446 §4.2.7 — a server cannot negotiate a group absent from
// supported_groups.
test "parse: no shared supported group is rejected" {
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

// RFC 8446 §4.1.4 — a ClientHello that supports X25519 but omits an X25519
// key_share is structurally valid input for server HelloRetryRequest.
test "parse: missing X25519 key share leaves public key null" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    const key_share = try findExtension(buf[0..encoded.len], .key_share);
    // Rewrite key_share group x25519 (0x001d) to secp384r1 (0x0018), while
    // leaving supported_groups unchanged.
    key_share[2] = 0x00;
    key_share[3] = 0x18;

    const parsed = try parse(buf[0..encoded.len]);
    try testing.expectEqual(@as(?x25519.PublicKey, null), parsed.public_key);
}

// RFC 8446 §4.2 — duplicate recognized extensions are rejected.
test "parse: rejects duplicate signature_algorithms" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    const dup_sig_algs = [_]u8{ 0x00, 0x0d, 0x00, 0x02, 0x00, 0x02 };
    const new_len = appendExtension(&buf, encoded.len, &dup_sig_algs);
    try testing.expectError(error.DuplicateExtension, parse(buf[0..new_len]));
}

// RFC 8446 §4.2 — duplicate recognized extensions are rejected.
test "parse: rejects duplicate signature_algorithms_cert" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    const dup_sig_algs_cert = [_]u8{ 0x00, 0x32, 0x00, 0x04, 0x00, 0x02, 0x04, 0x01 };
    const new_len = appendExtension(&buf, encoded.len, &dup_sig_algs_cert);
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
    const parsed = try parseSupportedGroups(&groups);
    try testing.expect(parsed.x25519);
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
