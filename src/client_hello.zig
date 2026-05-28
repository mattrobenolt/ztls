/// TLS 1.3 ClientHello handshake message encoding.
///
/// Writes the ClientHello handshake message into a caller-provided buffer.
/// The returned slice covers the full handshake message (type + 3-byte length
/// + body) and should be fed into the transcript hash before wrapping in a
/// TLS record.
///
/// RFC 8446 §4.1.2
const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;

const memx = @import("memx.zig");
const wire = @import("wire.zig");
const x25519 = @import("x25519.zig");

pub const Random = memx.Array(32);

// ── Wire format constants ────────────────────────────────────────────────────

/// RFC 8446 §4.1.2 — legacy_version is frozen at 0x0303.
const legacy_version: u16 = 0x0303;

/// RFC 8446 §4.2.7 — NamedGroup values.
const NamedGroup = enum(u16) { x25519 = 0x001d };

/// RFC 8446 §4.2.3 — SignatureScheme values.
const SignatureScheme = enum(u16) {
    ecdsa_secp256r1_sha256 = 0x0403,
    ecdsa_secp384r1_sha384 = 0x0503,
    rsa_pss_rsae_sha256 = 0x0804,
    rsa_pss_rsae_sha384 = 0x0805,
};

/// RFC 8446 Appendix B.4 — CipherSuite values.
const CipherSuite = enum(u16) {
    aes_128_gcm_sha256 = 0x1301,
    aes_256_gcm_sha384 = 0x1302,
    chacha20_poly1305_sha256 = 0x1303,
};

const cipher_suites = [_]CipherSuite{
    .aes_128_gcm_sha256,
    .chacha20_poly1305_sha256,
    .aes_256_gcm_sha384,
};

const sig_schemes = [_]SignatureScheme{
    .ecdsa_secp256r1_sha256,
    .ecdsa_secp384r1_sha384,
    .rsa_pss_rsae_sha256,
    .rsa_pss_rsae_sha384,
};

// ── Size calculations ────────────────────────────────────────────────────────

const handshake_header_len = 4; // type(1) + length(3)
const body_fixed_len =
    2 + // legacy_version
    32 + // random
    1 + // legacy_session_id length (always 0x00)
    2 + cipher_suites.len * 2 + // cipher_suites length + suites
    2 + // legacy_compression_methods: length(1) + null(1)
    2; // extensions length field

const ext_supported_versions_len = 2 + 2 + 1 + 2;
const ext_supported_groups_len = 2 + 2 + 2 + 2;
const ext_sig_algs_len = 2 + 2 + 2 + sig_schemes.len * 2;
const ext_key_share_len = 2 + 2 + 2 + 2 + 2 + 32;

fn sniExtLen(name: []const u8) u16 {
    return 2 + 2 + 2 + 1 + 2 + @as(u16, @intCast(name.len));
}

fn extensionsLen(server_name: ?[]const u8) u16 {
    const sni: u16 = if (server_name) |n| sniExtLen(n) else 0;
    const total = sni +
        ext_supported_versions_len +
        ext_supported_groups_len +
        ext_sig_algs_len +
        ext_key_share_len;
    assert(total <= std.math.maxInt(u16));
    return @intCast(total);
}

/// Returns the total encoded length for the given parameters.
pub fn encodedLen(server_name: ?[]const u8) usize {
    return handshake_header_len + body_fixed_len + extensionsLen(server_name);
}

// ── Encoding ─────────────────────────────────────────────────────────────────

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
) error{ BufferTooShort, ServerNameTooLong }![]u8 {
    // RFC 6066 §3: HostName is a DNS name, max 253 octets.
    if (server_name) |name| if (name.len > 253) return error.ServerNameTooLong;

    if (out.len < encodedLen(server_name)) return error.BufferTooShort;
    var w: wire.Writer = .init(out);

    // Handshake header (RFC 8446 §4)
    w.append(u8, 0x01); // HandshakeType.client_hello
    w.append(u24, @intCast(body_fixed_len + extensionsLen(server_name)));

    // ClientHello body (RFC 8446 §4.1.2)
    w.append(u16, legacy_version);
    w.appendSlice(&random.data);
    w.append(u8, 0x00); // legacy_session_id: empty

    // cipher_suites
    w.append(u16, cipher_suites.len * 2);
    for (cipher_suites) |cs| w.append(CipherSuite, cs);

    // legacy_compression_methods: null only
    w.append(u8, 0x01);
    w.append(u8, 0x00);

    // extensions
    w.append(u16, extensionsLen(server_name));

    // server_name (RFC 8446 §4.2, RFC 6066 §3)
    if (server_name) |name| {
        const name_len: u16 = @intCast(name.len);
        const entry_len: u16 = 1 + 2 + name_len; // name_type + name_len field + name
        const list_len: u16 = entry_len; // one entry in the ServerNameList
        const ext_data_len: u16 = 2 + entry_len; // list_len field + entry
        w.append(u16, 0x0000); // extension type: server_name
        w.append(u16, ext_data_len);
        w.append(u16, list_len);
        w.append(u8, 0x00); // NameType: host_name
        w.append(u16, name_len);
        w.appendSlice(name);
    }

    // supported_versions (RFC 8446 §4.2.1)
    w.append(u16, 0x002b);
    w.append(u16, 3); // extension data length: list_len(1) + version(2)
    w.append(u8, 0x02); // versions list length = 2
    w.append(u16, 0x0304); // TLS 1.3

    // supported_groups (RFC 8446 §4.2.7)
    w.append(u16, 0x000a);
    w.append(u16, 4); // extension data length: list_len(2) + group(2)
    w.append(u16, 2); // named_group_list length = 2
    w.append(NamedGroup, .x25519);

    // signature_algorithms (RFC 8446 §4.2.3)
    w.append(u16, 0x000d);
    w.append(u16, 2 + sig_schemes.len * 2); // extension data length
    w.append(u16, sig_schemes.len * 2); // list length
    for (sig_schemes) |s| w.append(SignatureScheme, s);

    // key_share (RFC 8446 §4.2.8)
    w.append(u16, 0x0033);
    w.append(u16, 2 + 2 + 2 + 32); // extension data length
    w.append(u16, 2 + 2 + 32); // client_shares list length
    w.append(NamedGroup, .x25519);
    w.append(u16, 32); // key_exchange length
    w.appendSlice(&public_key.data);

    return w.written();
}

// ── Tests ─────────────────────────────────────────────────────────────────────

test "encode: size matches encodedLen" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, "server");
    try testing.expectEqual(encodedLen("server"), encoded.len);
}

test "encode: handshake type and legacy version" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null);
    try testing.expectEqual(@as(u8, 0x01), encoded[0]);
    try testing.expectEqual(@as(u8, 0x03), encoded[4]);
    try testing.expectEqual(@as(u8, 0x03), encoded[5]);
}

test "encode: cipher suites" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null);
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
    const encoded = try encode(&buf, .zero, key, null);
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
    const encoded = try encode(&buf, .zero, .zero, "example.com");
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
    const with = try encode(&buf, .zero, .zero, "example.com");
    const without = try encode(&buf, .zero, .zero, null);
    try testing.expect(with.len > without.len);
}

test "encode: buffer too short" {
    var buf: [10]u8 = undefined;
    try testing.expectError(error.BufferTooShort, encode(&buf, .zero, .zero, null));
}

test "encode: server_name too long" {
    var buf: [512]u8 = undefined;
    const long_name = "a" ** 254;
    try testing.expectError(error.ServerNameTooLong, encode(&buf, .zero, .zero, long_name));
}
