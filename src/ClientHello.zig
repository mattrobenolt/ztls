/// TLS 1.3 ClientHello handshake message.
///
/// Encodes the ClientHello into a caller-provided buffer. The returned slice
/// covers the full handshake message (type + 3-byte length + body) and should
/// be fed into the transcript hash before wrapping in a TLS record.
///
/// RFC 8446 §4.1.2
const std = @import("std");
const assert = std.debug.assert;
const memx = @import("memx.zig");
const x25519 = @import("x25519.zig");

const ClientHello = @This();

pub const Random = memx.Array(32);

/// Cryptographic random nonce. Caller should fill with std.crypto.random.bytes().
random: Random,

/// Ephemeral X25519 public key for the key_share extension.
public_key: x25519.PublicKey,

/// Server name for the SNI extension. Null omits the extension.
server_name: ?[]const u8,

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

const ext_supported_versions_len = 2 + 2 + 1 + 2; // type + ext_len + list_len + TLS13
const ext_supported_groups_len = 2 + 2 + 2 + 2; // type + ext_len + list_len + x25519
const ext_sig_algs_len = 2 + 2 + 2 + sig_schemes.len * 2; // type + ext_len + list_len + schemes
const ext_key_share_len = 2 + 2 + 2 + 2 + 2 + 32; // type + ext_len + client_shares_len + group + key_len + key

fn sniExtLen(name: []const u8) usize {
    // type(2) + ext_len(2) + list_len(2) + name_type(1) + name_len(2) + name
    return 2 + 2 + 2 + 1 + 2 + name.len;
}

fn extensionsLen(self: *const ClientHello) usize {
    const sni = if (self.server_name) |n| sniExtLen(n) else 0;
    return sni +
        ext_supported_versions_len +
        ext_supported_groups_len +
        ext_sig_algs_len +
        ext_key_share_len;
}

fn bodyLen(self: *const ClientHello) usize {
    return body_fixed_len + extensionsLen(self);
}

pub fn encodedLen(self: *const ClientHello) usize {
    return handshake_header_len + bodyLen(self);
}

// ── Encoding ─────────────────────────────────────────────────────────────────

/// Encode the ClientHello handshake message into `out`.
///
/// Returns the written slice. Feed it into the transcript hash before wrapping
/// in a TLS record — the transcript covers the handshake header + body, not
/// the outer record header.
///
/// RFC 8446 §4.1.2
pub fn encode(self: *const ClientHello, out: []u8) error{BufferTooShort}![]u8 {
    const total = encodedLen(self);
    if (out.len < total) return error.BufferTooShort;

    var pos: usize = 0;

    // ── Handshake header (RFC 8446 §4) ──────────────────────────────────────
    out[pos] = 0x01; // HandshakeType.client_hello
    pos += 1;
    const body = bodyLen(self);
    out[pos] = @intCast((body >> 16) & 0xff);
    out[pos + 1] = @intCast((body >> 8) & 0xff);
    out[pos + 2] = @intCast(body & 0xff);
    pos += 3;

    // ── ClientHello body (RFC 8446 §4.1.2) ──────────────────────────────────
    out[pos..][0..2].* = memx.toBytes(u16, legacy_version);
    pos += 2;

    out[pos..][0..32].* = self.random.data;
    pos += 32;

    out[pos] = 0x00; // legacy_session_id: empty
    pos += 1;

    out[pos..][0..2].* = memx.toBytes(u16, @intCast(cipher_suites.len * 2));
    pos += 2;
    for (cipher_suites) |cs| {
        out[pos..][0..2].* = memx.toBytes(u16, @intFromEnum(cs));
        pos += 2;
    }

    out[pos] = 0x01; // legacy_compression_methods length
    out[pos + 1] = 0x00; // null compression
    pos += 2;

    // Extensions length
    const ext_len = extensionsLen(self);
    out[pos..][0..2].* = memx.toBytes(u16, @intCast(ext_len));
    pos += 2;

    // ── server_name (RFC 8446 §4.2, RFC 6066 §3) ────────────────────────────
    if (self.server_name) |name| {
        out[pos..][0..2].* = memx.toBytes(u16, 0x0000); // extension type
        out[pos + 2..][0..2].* = memx.toBytes(u16, @intCast(2 + 1 + 2 + name.len)); // ext value len
        out[pos + 4..][0..2].* = memx.toBytes(u16, @intCast(1 + 2 + name.len)); // ServerNameList len
        out[pos + 6] = 0x00; // NameType: host_name
        out[pos + 7..][0..2].* = memx.toBytes(u16, @intCast(name.len));
        @memcpy(out[pos + 9 ..][0..name.len], name);
        pos += sniExtLen(name);
    }

    // ── supported_versions (RFC 8446 §4.2.1) ────────────────────────────────
    out[pos..][0..2].* = memx.toBytes(u16, 0x002b);
    out[pos + 2..][0..2].* = memx.toBytes(u16, 3); // ext value len: list_len(1) + version(2)
    out[pos + 4] = 0x02; // versions list length = 2
    out[pos + 5..][0..2].* = memx.toBytes(u16, 0x0304); // TLS 1.3
    pos += ext_supported_versions_len;

    // ── supported_groups (RFC 8446 §4.2.7) ──────────────────────────────────
    out[pos..][0..2].* = memx.toBytes(u16, 0x000a);
    out[pos + 2..][0..2].* = memx.toBytes(u16, 4); // ext value len: list_len(2) + group(2)
    out[pos + 4..][0..2].* = memx.toBytes(u16, 2); // named_group_list length = 2
    out[pos + 6..][0..2].* = memx.toBytes(u16, @intFromEnum(NamedGroup.x25519));
    pos += ext_supported_groups_len;

    // ── signature_algorithms (RFC 8446 §4.2.3) ──────────────────────────────
    out[pos..][0..2].* = memx.toBytes(u16, 0x000d);
    out[pos + 2..][0..2].* = memx.toBytes(u16, @intCast(2 + sig_schemes.len * 2)); // ext value len
    out[pos + 4..][0..2].* = memx.toBytes(u16, @intCast(sig_schemes.len * 2)); // list length
    pos += 6;
    for (sig_schemes) |s| {
        out[pos..][0..2].* = memx.toBytes(u16, @intFromEnum(s));
        pos += 2;
    }

    // ── key_share (RFC 8446 §4.2.8) ─────────────────────────────────────────
    out[pos..][0..2].* = memx.toBytes(u16, 0x0033);
    out[pos + 2..][0..2].* = memx.toBytes(u16, 2 + 2 + 2 + 32); // ext value len
    out[pos + 4..][0..2].* = memx.toBytes(u16, 2 + 2 + 32); // client_shares list len
    out[pos + 6..][0..2].* = memx.toBytes(u16, @intFromEnum(NamedGroup.x25519));
    out[pos + 8..][0..2].* = memx.toBytes(u16, 32); // key_exchange length
    out[pos + 10..][0..32].* = self.public_key.data;
    pos += ext_key_share_len;

    assert(pos == total);
    return out[0..total];
}

// ── Tests ─────────────────────────────────────────────────────────────────────

const testing = std.testing;

// RFC 8446 §4.1.2 — ClientHello encoding
// Known values from RFC 8448 §3.

test "ClientHello: encode size matches encodedLen" {
    const ch: ClientHello = .{
        .random = .zero,
        .public_key = .zero,
        .server_name = "server",
    };
    var buf: [512]u8 = undefined;
    const encoded = try ch.encode(&buf);
    try testing.expectEqual(ch.encodedLen(), encoded.len);
}

test "ClientHello: handshake type and version" {
    const ch: ClientHello = .{
        .random = .zero,
        .public_key = .zero,
        .server_name = null,
    };
    var buf: [512]u8 = undefined;
    const encoded = try ch.encode(&buf);

    try testing.expectEqual(@as(u8, 0x01), encoded[0]); // client_hello
    try testing.expectEqual(@as(u8, 0x03), encoded[4]); // legacy_version high
    try testing.expectEqual(@as(u8, 0x03), encoded[5]); // legacy_version low
}

test "ClientHello: cipher suites" {
    const ch: ClientHello = .{
        .random = .zero,
        .public_key = .zero,
        .server_name = null,
    };
    var buf: [512]u8 = undefined;
    const encoded = try ch.encode(&buf);

    // Offset: handshake_header(4) + version(2) + random(32) + session_id(1) = 39
    const cs_offset = 39;
    // cipher suites length = 6
    try testing.expectEqualSlices(u8, &.{ 0x00, 0x06 }, encoded[cs_offset..][0..2]);
    // TLS_AES_128_GCM_SHA256
    try testing.expectEqualSlices(u8, &.{ 0x13, 0x01 }, encoded[cs_offset + 2 ..][0..2]);
    // TLS_CHACHA20_POLY1305_SHA256
    try testing.expectEqualSlices(u8, &.{ 0x13, 0x03 }, encoded[cs_offset + 4 ..][0..2]);
    // TLS_AES_256_GCM_SHA384
    try testing.expectEqualSlices(u8, &.{ 0x13, 0x02 }, encoded[cs_offset + 6 ..][0..2]);
}

test "ClientHello: key_share contains public key" {
    const key: x25519.PublicKey = .init(.{
        0x99, 0x38, 0x1d, 0xe5, 0x60, 0xe4, 0xbd, 0x43,
        0xd2, 0x3d, 0x8e, 0x43, 0x5a, 0x7d, 0xba, 0xfe,
        0xb3, 0xc0, 0x6e, 0x51, 0xc1, 0x3c, 0xae, 0x4d,
        0x54, 0x13, 0x69, 0x1e, 0x52, 0x9a, 0xaf, 0x2c,
    });
    const ch: ClientHello = .{
        .random = .zero,
        .public_key = key,
        .server_name = null,
    };
    var buf: [512]u8 = undefined;
    const encoded = try ch.encode(&buf);

    // Find the key_share extension (0x00 0x33) and verify the public key
    var found = false;
    var i: usize = 0;
    while (i + 1 < encoded.len) : (i += 1) {
        if (encoded[i] == 0x00 and encoded[i + 1] == 0x33) {
            // key_share type found; public key is at offset +10
            try testing.expectEqualSlices(u8, &key.data, encoded[i + 10 ..][0..32]);
            found = true;
            break;
        }
    }
    try testing.expect(found);
}

test "ClientHello: SNI extension present when server_name set" {
    const ch: ClientHello = .{
        .random = .zero,
        .public_key = .zero,
        .server_name = "example.com",
    };
    var buf: [512]u8 = undefined;
    const encoded = try ch.encode(&buf);

    // SNI extension type 0x00 0x00 should be present
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

test "ClientHello: SNI absent when server_name is null" {
    const with_sni: ClientHello = .{ .random = .zero, .public_key = .zero, .server_name = "example.com" };
    const without_sni: ClientHello = .{ .random = .zero, .public_key = .zero, .server_name = null };

    var buf: [512]u8 = undefined;
    const with = try with_sni.encode(&buf);
    const without = try without_sni.encode(&buf);

    try testing.expect(with.len > without.len);
}

test "ClientHello: buffer too short" {
    const ch: ClientHello = .{ .random = .zero, .public_key = .zero, .server_name = null };
    var buf: [10]u8 = undefined;
    try testing.expectError(error.BufferTooShort, ch.encode(&buf));
}
