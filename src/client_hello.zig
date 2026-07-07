//! TLS 1.3 ClientHello handshake message encoding.
//!
//! RFC 8446 §4.1.2
const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;
const fuzz_compat = @import("fuzz_compat.zig");
const mem = std.mem;
const meta = std.meta;

const alpn_mod = @import("alpn.zig");
const AlpnProtocols = alpn_mod.Protocols;
const AlpnError = alpn_mod.Error;
const CompressionMethod = @import("compression_method.zig").CompressionMethod;
const backend = @import("crypto/backend.zig");
const supported_cipher_suites = backend.capabilities.cipher_suites;
const cipher_suite_count = supported_cipher_suites.len;
const supported_signature_schemes = backend.capabilities.certificate_verify_schemes;
const supported_certificate_signature_schemes = backend.capabilities.certificate_signature_schemes;
const sig_scheme_count = supported_signature_schemes.len;
const cert_sig_scheme_count = supported_certificate_signature_schemes.len;
const extension_type = @import("extension_type.zig");
const ExtensionType = extension_type.ExtensionType;
const OfferedExtensions = extension_type.OfferedExtensions;
const handshake = @import("handshake.zig");
const kex = @import("kex.zig");
const NamedGroup = kex.NamedGroup;
const memx = @import("memx.zig");
const p256 = @import("p256.zig");
const p384 = @import("p384.zig");
const ProtocolVersion = @import("protocol_version.zig").ProtocolVersion;
const root = @import("root.zig");
const CipherSuite = root.CipherSuite;
const Random = root.Random;
const SignatureScheme = @import("signature_scheme.zig").SignatureScheme;
const wire = @import("wire.zig");
const server_hello = @import("server_hello.zig");
const x25519 = @import("x25519.zig");

/// RFC 8446 §4.1.2 — legacy_version is frozen at TLS 1.2.
const legacy_version: ProtocolVersion = .tls_1_2;

const handshake_header_len = 4;
const ext_header_len = 2 + 2; // extension type + data length field
const x25519_key_share_len: usize = 2 + 2 + x25519.public_length;
const p256_key_share_len: usize = 2 + 2 + p256.public_length;
const p384_key_share_len: usize = 2 + 2 + p384.public_length;
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
/// psk_key_exchange_modes (RFC 8446 §4.2.9): ext header + 1-byte list len +
/// 1-byte mode (psk_dhe_ke). Always advertised so the client can receive
/// NewSessionTickets.
const ext_psk_kem_len = ext_header_len + 1 + 1;
const ext_sig_algs_len = ext_header_len + 2 + sig_scheme_count * 2;
const ext_sig_algs_cert_len = ext_header_len + 2 + cert_sig_scheme_count * 2;
comptime {
    assert(backend.capabilities.client_x25519);
}

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

fn groupCount(include_p256: bool, include_p384: bool) usize {
    return 1 + @as(usize, @intFromBool(include_p256)) +
        @as(usize, @intFromBool(include_p384));
}

fn keySharesLen(include_p256: bool, include_p384: bool) usize {
    return x25519_key_share_len +
        (if (include_p256) p256_key_share_len else 0) +
        (if (include_p384) p384_key_share_len else 0);
}

fn extensionsLen(
    server_name: ?[]const u8,
    alpn_protocols: AlpnProtocols,
    include_p256: bool,
    include_p384: bool,
) AlpnError!u16 {
    const sni: u16 = if (server_name) |n| sniExtLen(n) else 0;
    const alpn: u16 = if (alpn_protocols.len == 0) 0 else try alpnExtLen(alpn_protocols);
    const total = sni +
        alpn +
        ext_supported_versions_len +
        ext_header_len + 2 + groupCount(include_p256, include_p384) * 2 +
        ext_sig_algs_len +
        ext_sig_algs_cert_len +
        ext_psk_kem_len +
        ext_header_len + 2 + keySharesLen(include_p256, include_p384);
    assert(total <= std.math.maxInt(u16));
    return @intCast(total);
}

pub fn encodedLen(server_name: ?[]const u8, alpn_protocols: AlpnProtocols) AlpnError!usize {
    return handshake_header_len + body_fixed_len +
        try extensionsLen(server_name, alpn_protocols, false, false);
}

pub fn encodedLenWithP256(
    server_name: ?[]const u8,
    alpn_protocols: AlpnProtocols,
) AlpnError!usize {
    return handshake_header_len + body_fixed_len +
        try extensionsLen(server_name, alpn_protocols, true, false);
}

pub fn encodedLenWithP256P384(
    server_name: ?[]const u8,
    alpn_protocols: AlpnProtocols,
) AlpnError!usize {
    return handshake_header_len + body_fixed_len +
        try extensionsLen(server_name, alpn_protocols, true, true);
}

/// Errors from ClientHello2 encoding after a HelloRetryRequest.
pub const RetryEncodeError = error{
    BufferTooShort,
    ServerNameTooLong,
    UnsupportedGroup,
} || AlpnError;

/// Compute the key_share extension body length for a single selected group.
fn singleKeyShareLen(selected_group: NamedGroup) RetryEncodeError!usize {
    return switch (selected_group) {
        .x25519 => 2 + 2 + x25519.public_length,
        .secp256r1 => 2 + 2 + p256.public_length,
        .secp384r1 => 2 + 2 + p384.public_length,
        else => return error.UnsupportedGroup,
    };
}

/// Compute the total extensions length for a ClientHello2 with only the
/// selected group's key_share and an optional cookie.
fn retryExtensionsLen(
    server_name: ?[]const u8,
    alpn_protocols: AlpnProtocols,
    selected_group: NamedGroup,
    cookie: ?[]const u8,
    include_p384: bool,
) RetryEncodeError!u16 {
    const sni: u16 = if (server_name) |n| sniExtLen(n) else 0;
    const alpn: u16 = if (alpn_protocols.len == 0) 0 else try alpnExtLen(alpn_protocols);
    const cookie_len: u16 = if (cookie) |c| ext_header_len + 2 + @as(u16, @intCast(c.len)) else 0;
    const ks = try singleKeyShareLen(selected_group);
    const total = sni +
        alpn +
        ext_supported_versions_len +
        ext_header_len + 2 + groupCount(true, include_p384) * 2 +
        ext_sig_algs_len +
        ext_sig_algs_cert_len +
        ext_header_len + 2 + ks +
        cookie_len;
    assert(total <= std.math.maxInt(u16));
    return @intCast(total);
}

/// Encode a ClientHello2 handshake message in response to a HelloRetryRequest.
/// RFC 8446 §4.1.2: the second ClientHello is identical to the first except:
///   - key_share contains only a KeyShareEntry for the HRR selected_group
///   - cookie extension is included if the HRR provided one
///   - supported_groups, cipher_suites, and other extensions remain unchanged
///
/// `x25519_public_key` and `p256_public_key` are the client's existing
/// ephemeral keys; the one matching `selected_group` is emitted in key_share.
/// RFC 8446 §4.1.4 does not require generating a fresh key for the selected
/// group — the existing keypair is reused.
// ziglint-ignore: Z015 -- RetryEncodeError is a public error-set alias.
pub fn encodeRetryAfterHrr(
    out: []u8,
    random: Random,
    x25519_public_key: x25519.PublicKey,
    p256_public_key: p256.PublicKey,
    p384_public_key: ?p384.PublicKey,
    selected_group: NamedGroup,
    cookie: ?[]const u8,
    server_name: ?[]const u8,
    alpn_protocols: AlpnProtocols,
) RetryEncodeError![]u8 {
    if (server_name) |name| if (name.len > 253) return error.ServerNameTooLong;
    if (cookie) |c| {
        if (c.len == 0 or c.len > std.math.maxInt(u16)) return error.BufferTooShort;
    }
    if (selected_group == .secp384r1 and p384_public_key == null) return error.UnsupportedGroup;
    const include_p384 = p384_public_key != null;
    const ext_len = try retryExtensionsLen(
        server_name,
        alpn_protocols,
        selected_group,
        cookie,
        include_p384,
    );
    const encoded_len = handshake_header_len + body_fixed_len + ext_len;
    if (out.len < encoded_len) return error.BufferTooShort;

    var w: wire.Writer = .init(out);

    // Handshake header (RFC 8446 §4)
    w.append(handshake.Type, .client_hello);
    w.append(u24, @intCast(body_fixed_len + ext_len));

    // ClientHello body (RFC 8446 §4.1.2) — same as ClientHello1.
    w.append(ProtocolVersion, legacy_version);
    w.appendSlice(&random.data);
    w.append(u8, 0x00); // legacy_session_id: empty
    w.append(u16, cipher_suite_count * 2);
    inline for (supported_cipher_suites) |cs| w.append(CipherSuite, cs);
    w.append(u8, 0x01); // legacy_compression_methods length
    w.append(CompressionMethod, .no_compression);
    w.append(u16, ext_len);

    // server_name (RFC 8446 §4.2, RFC 6066 §3)
    if (server_name) |name| {
        const name_len: u16 = @intCast(name.len);
        const entry_len: u16 = 1 + 2 + name_len;
        const list_len: u16 = entry_len;
        const ext_data_len: u16 = 2 + entry_len;
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

    // supported_groups (RFC 8446 §4.2.7) — unchanged from ClientHello1.
    w.append(ExtensionType, .supported_groups);
    w.append(u16, @intCast(2 + groupCount(true, include_p384) * 2));
    w.append(u16, @intCast(groupCount(true, include_p384) * 2));
    w.append(NamedGroup, .x25519);
    w.append(NamedGroup, .secp256r1);
    if (include_p384) w.append(NamedGroup, .secp384r1);

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

    // key_share (RFC 8446 §4.2.8) — only the selected group's KeyShareEntry.
    const ks_len = try singleKeyShareLen(selected_group);
    w.append(ExtensionType, .key_share);
    w.append(u16, @intCast(2 + ks_len));
    w.append(u16, @intCast(ks_len));
    switch (selected_group) {
        .x25519 => {
            w.append(NamedGroup, .x25519);
            w.append(u16, x25519.public_length);
            w.appendSlice(&x25519_public_key.data);
        },
        .secp256r1 => {
            w.append(NamedGroup, .secp256r1);
            w.append(u16, p256.public_length);
            w.appendSlice(&p256_public_key.data);
        },
        .secp384r1 => {
            const public_key = p384_public_key orelse return error.UnsupportedGroup;
            w.append(NamedGroup, .secp384r1);
            w.append(u16, p384.public_length);
            w.appendSlice(&public_key.data);
        },
        else => return error.UnsupportedGroup,
    }

    // cookie (RFC 8446 §4.2.2) — echoed verbatim from HelloRetryRequest.
    if (cookie) |c| {
        w.append(ExtensionType, .cookie);
        w.append(u16, @intCast(2 + c.len));
        w.append(u16, @intCast(c.len));
        w.appendSlice(c);
    }

    return w.written();
}

/// PskKeyExchangeMode (RFC 8446 §4.2.9).
pub const PskKeyExchangeMode = enum(u8) {
    psk_ke = 0,
    psk_dhe_ke = 1,
};

/// Result of `encodeWithPsk`: the encoded ClientHello plus the offsets the
/// caller needs to compute and patch in the PSK binder. `prefix_len` is the
/// number of bytes from the start of the message that the binder transcript
/// hash covers (up to and including the identities, excluding the binders
/// list). `binder_offset` is where the binder value (of `binder_len` bytes)
/// must be written after the caller computes it. RFC 8446 §4.2.11.2.
pub const PskEncodeResult = struct {
    msg: []u8,
    prefix_len: usize,
    binder_offset: usize,
    binder_len: u8,
};

/// Encode a ClientHello offering a PSK for session resumption. Builds the full
/// message with `psk_key_exchange_modes` and a `pre_shared_key` extension (the
/// LAST extension, per RFC 8446 §4.2.11) carrying one identity. The binder is
/// left zero-filled; the caller computes it over `msg[0..prefix_len]` and
/// writes it at `msg[binder_offset..][0..binder_len]`.
///
/// `identity` is the ticket bytes, `obfuscated_ticket_age` is
/// `(ticket_age + ticket_age_add) mod 2^32`, and `binder_len` is the hash
/// length of the PSK's cipher suite (32 for SHA-256, 48 for SHA-384).
pub fn encodeWithPsk(
    out: []u8,
    random: Random,
    public_key: x25519.PublicKey,
    public_key_p256: ?p256.PublicKey,
    public_key_p384: ?p384.PublicKey,
    server_name: ?[]const u8,
    alpn_protocols: AlpnProtocols,
    psk_mode: PskKeyExchangeMode,
    identity: []const u8,
    obfuscated_ticket_age: u32,
    binder_len: u8,
    offer_early_data: bool,
) (error{ BufferTooShort, ServerNameTooLong, IdentityTooLong } || AlpnError)!PskEncodeResult {
    if (server_name) |name| if (name.len > 253) return error.ServerNameTooLong;
    if (identity.len > 256) return error.IdentityTooLong;
    const include_p256 = public_key_p256 != null;
    const include_p384 = public_key_p384 != null;

    // psk_key_exchange_modes is emitted as part of the base extensions
    // (extensionsLen accounts for it). pre_shared_key ext_data =
    // identities (2-byte list len + per identity: 2 + identity.len + 4) +
    // binders (2-byte list len + per binder: 1-byte entry len + binder).
    // RFC 8446 §4.2.11: PskBinderEntry uses a 1-byte length prefix.
    const identities_len: usize = 2 + 2 + identity.len + 4;
    const binders_len: usize = 2 + 1 + binder_len;
    const psk_ext_data_len: usize = identities_len + binders_len;
    const psk_ext_len: usize = 4 + psk_ext_data_len;

    const base_ext_len = try extensionsLen(server_name, alpn_protocols, include_p256, include_p384);
    // base_ext_len already includes psk_key_exchange_modes (added in slice E).
    // early_data ext (if offered): 4 bytes (ext header + 0-length ext_data).
    const early_data_ext_len: usize = if (offer_early_data) 4 else 0;
    const ext_len = base_ext_len + early_data_ext_len + psk_ext_len;
    const encoded_len = handshake_header_len + body_fixed_len + ext_len;
    if (out.len < encoded_len) return error.BufferTooShort;

    var w: wire.Writer = .init(out);

    // Handshake header — body length includes the full pre_shared_key ext
    // (binders included), per RFC 8446 §4.2.11.2.
    w.append(handshake.Type, .client_hello);
    w.append(u24, @intCast(body_fixed_len + ext_len));

    // ClientHello body
    w.append(ProtocolVersion, legacy_version);
    w.appendSlice(&random.data);
    w.append(u8, 0x00); // legacy_session_id: empty
    w.append(u16, cipher_suite_count * 2);
    inline for (supported_cipher_suites) |cs| w.append(CipherSuite, cs);
    w.append(u8, 0x01); // legacy_compression_methods length
    w.append(CompressionMethod, .no_compression);
    w.append(u16, @intCast(ext_len));

    // The base extensions (server_name, alpn, supported_versions,
    // supported_groups, signature_algorithms, signature_algorithms_cert,
    // key_share) are identical to encodeInternal. Re-emit them in order.
    if (server_name) |name| {
        const name_len: u16 = @intCast(name.len);
        const entry_len: u16 = 1 + 2 + name_len;
        const list_len: u16 = entry_len;
        const ext_data_len: u16 = 2 + entry_len;
        w.append(ExtensionType, .server_name);
        w.append(u16, ext_data_len);
        w.append(u16, list_len);
        w.append(SniNameType, .host_name);
        w.append(u16, name_len);
        w.appendSlice(name);
    }
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
    w.append(ExtensionType, .supported_versions);
    w.append(u16, 3);
    w.append(u8, 0x02);
    w.append(ProtocolVersion, .tls_1_3);

    w.append(ExtensionType, .supported_groups);
    w.append(u16, @intCast(2 + groupCount(include_p256, include_p384) * 2));
    w.append(u16, @intCast(groupCount(include_p256, include_p384) * 2));
    w.append(NamedGroup, .x25519);
    if (include_p256) w.append(NamedGroup, .secp256r1);
    if (include_p384) w.append(NamedGroup, .secp384r1);

    w.append(ExtensionType, .signature_algorithms);
    w.append(u16, 2 + sig_scheme_count * 2);
    w.append(u16, sig_scheme_count * 2);
    inline for (supported_signature_schemes) |s| w.append(SignatureScheme, s);

    w.append(ExtensionType, .signature_algorithms_cert);
    w.append(u16, 2 + cert_sig_scheme_count * 2);
    w.append(u16, cert_sig_scheme_count * 2);
    inline for (supported_certificate_signature_schemes) |s| w.append(SignatureScheme, s);

    const shares_len = keySharesLen(include_p256, include_p384);
    w.append(ExtensionType, .key_share);
    w.append(u16, @intCast(2 + shares_len));
    w.append(u16, @intCast(shares_len));
    w.append(NamedGroup, .x25519);
    w.append(u16, x25519.public_length);
    w.appendSlice(&public_key.data);
    if (public_key_p256) |key| {
        w.append(NamedGroup, .secp256r1);
        w.append(u16, p256.public_length);
        w.appendSlice(&key.data);
    }
    if (public_key_p384) |key| {
        w.append(NamedGroup, .secp384r1);
        w.append(u16, p384.public_length);
        w.appendSlice(&key.data);
    }

    // psk_key_exchange_modes (RFC 8446 §4.2.9). Not the last extension.
    w.append(ExtensionType, .psk_key_exchange_modes);
    w.append(u16, 2); // ext_data len
    w.append(u8, 1); // list len
    w.append(PskKeyExchangeMode, psk_mode);

    // early_data (RFC 8446 §4.2.10) — empty ext_data, offered when the
    // caller opts in to 0-RTT. Must precede pre_shared_key (which is last).
    if (offer_early_data) {
        w.append(ExtensionType, .early_data);
        w.append(u16, 0);
    }

    // pre_shared_key (RFC 8446 §4.2.11) — MUST be the last extension.
    w.append(ExtensionType, .pre_shared_key);
    w.append(u16, @intCast(psk_ext_data_len));
    // identities list
    w.append(u16, @intCast(identities_len - 2));
    w.append(u16, @intCast(identity.len));
    w.appendSlice(identity);
    w.append(u32, obfuscated_ticket_age);
    // The prefix the binder hash covers ends here (after the identities).
    const prefix_len = w.pos;
    // binders list (placeholder zero binder; caller patches it).
    w.append(u16, @intCast(binders_len - 2)); // binders list len
    w.append(u8, binder_len); // binder entry len (1-byte, RFC 8446 §4.2.11)
    const binder_offset = w.pos;
    var binder_buf: [48]u8 = @splat(0);
    w.appendSlice(binder_buf[0..binder_len]);

    return .{
        .msg = w.written(),
        .prefix_len = prefix_len,
        .binder_offset = binder_offset,
        .binder_len = binder_len,
    };
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
    IllegalParameter,
};

pub const Parsed = struct {
    cipher_suites: []const u8,
    legacy_session_id: []const u8 = &.{},
    signature_schemes: []const u8 = &.{},
    server_name: ?[]const u8 = null,
    alpn_protocols: []const u8 = &.{},
    groups: SupportedGroups = .{},
    public_key: ?x25519.PublicKey = null,
    public_key_p256: ?p256.PublicKey = null,
    public_key_p384: ?p384.PublicKey = null,
    /// KEM hybrid key_share from the client (raw bytes). Variable-length.
    /// draft-ietf-tls-ecdhe-mlkem-05 §4.1.
    kem_key_share: ?ParsedKemKeyShare = null,
    /// Offered ClientHello extensions tracked for validating server responses.
    offered_extensions: OfferedExtensions = .initEmpty(),
    /// pre_shared_key extension (RFC 8446 §4.2.11), if present. `psk_ext`
    /// points at the full extension ext_data (identities + binders) in the
    /// ClientHello buffer; `binders_offset` is the byte offset within the
    /// ClientHello message where the binders list begins (the binder hash
    /// covers msg[0..binders_offset]). Null when the client did not offer PSK.
    psk_ext: ?[]const u8 = null,
    binders_offset: usize = 0,
    /// psk_key_exchange_modes (RFC 8446 §4.2.9), if present. Slice into the
    /// ClientHello buffer (the modes list, after the list-length byte).
    psk_key_exchange_modes: ?[]const u8 = null,
    /// Whether the client offered the early_data extension (0-RTT).
    /// RFC 8446 §4.2.10.
    offered_early_data: bool = false,

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
    return encodeInternal(out, random, public_key, null, null, server_name, alpn_protocols);
}

pub fn encodeWithP256(
    out: []u8,
    random: Random,
    public_key: x25519.PublicKey,
    public_key_p256: p256.PublicKey,
    server_name: ?[]const u8,
    alpn_protocols: AlpnProtocols,
) (error{ BufferTooShort, ServerNameTooLong } || AlpnError)![]u8 {
    assert(backend.capabilities.client_p256);
    return encodeInternal(
        out,
        random,
        public_key,
        public_key_p256,
        null,
        server_name,
        alpn_protocols,
    );
}

pub fn encodeWithP256P384(
    out: []u8,
    random: Random,
    public_key: x25519.PublicKey,
    public_key_p256: p256.PublicKey,
    public_key_p384: ?p384.PublicKey,
    server_name: ?[]const u8,
    alpn_protocols: AlpnProtocols,
) (error{ BufferTooShort, ServerNameTooLong } || AlpnError)![]u8 {
    assert(backend.capabilities.client_p256);
    if (public_key_p384 != null) assert(backend.capabilities.client_p384);
    return encodeInternal(
        out,
        random,
        public_key,
        public_key_p256,
        public_key_p384,
        server_name,
        alpn_protocols,
    );
}

fn encodeInternal(
    out: []u8,
    random: Random,
    public_key: x25519.PublicKey,
    public_key_p256: ?p256.PublicKey,
    public_key_p384: ?p384.PublicKey,
    server_name: ?[]const u8,
    alpn_protocols: AlpnProtocols,
) (error{ BufferTooShort, ServerNameTooLong } || AlpnError)![]u8 {
    // RFC 6066 §3: HostName is a DNS name, max 253 octets.
    if (server_name) |name| if (name.len > 253) return error.ServerNameTooLong;
    const include_p256 = public_key_p256 != null;
    const include_p384 = public_key_p384 != null;
    const ext_len = try extensionsLen(server_name, alpn_protocols, include_p256, include_p384);
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
    inline for (supported_cipher_suites) |cs| w.append(CipherSuite, cs);
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
    w.append(u16, @intCast(2 + groupCount(include_p256, include_p384) * 2));
    w.append(u16, @intCast(groupCount(include_p256, include_p384) * 2)); // named_group_list length
    w.append(NamedGroup, .x25519);
    if (include_p256) w.append(NamedGroup, .secp256r1);
    if (include_p384) w.append(NamedGroup, .secp384r1);

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

    // psk_key_exchange_modes (RFC 8446 §4.2.9) — advertise psk_dhe_ke so the
    // server may issue NewSessionTickets for future resumption.
    w.append(ExtensionType, .psk_key_exchange_modes);
    w.append(u16, 2);
    w.append(u8, 1);
    w.append(PskKeyExchangeMode, .psk_dhe_ke);

    // key_share (RFC 8446 §4.2.8)
    const shares_len = keySharesLen(include_p256, include_p384);
    w.append(ExtensionType, .key_share);
    w.append(u16, @intCast(2 + shares_len));
    w.append(u16, @intCast(shares_len));
    w.append(NamedGroup, .x25519);
    w.append(u16, x25519.public_length); // key_exchange length
    w.appendSlice(&public_key.data);
    if (public_key_p256) |key| {
        w.append(NamedGroup, .secp256r1);
        w.append(u16, p256.public_length); // key_exchange length
        w.appendSlice(&key.data);
    }
    if (public_key_p384) |key| {
        w.append(NamedGroup, .secp384r1);
        w.append(u16, p384.public_length); // key_exchange length
        w.appendSlice(&key.data);
    }

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
                parsed.offered_extensions.insert(.server_name);
                got_server_name = true;
            },
            .supported_groups => {
                if (got_supported_groups) return error.DuplicateExtension;
                parsed.groups = try parseSupportedGroups(ext);
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
                parsed.public_key_p384 = shares.p384;
                parsed.kem_key_share = shares.kem;
                got_key_share = true;
            },
            .record_size_limit => {
                // RFC 8449 §4 — record_size_limit is a valid ClientHello
                // extension. Track its presence so EE validation can accept
                // an acknowledged record_size_limit in EncryptedExtensions.
                if (ext.len != 2) return error.InvalidExtensionLength;
                parsed.offered_extensions.insert(.record_size_limit);
            },
            .early_data => {
                // RFC 8446 §4.2.10 — early_data in ClientHello has empty
                // ext_data. Only valid with pre_shared_key.
                if (ext.len != 0) return error.InvalidExtensionLength;
                parsed.offered_early_data = true;
                parsed.offered_extensions.insert(.early_data);
            },
            .psk_key_exchange_modes => {
                // RFC 8446 §4.2.9. ext_data = 1-byte list length + modes.
                if (ext.len < 2) return error.InvalidExtensionLength;
                const list_len = ext[0];
                if (list_len + 1 != ext.len) return error.InvalidExtensionLength;
                parsed.psk_key_exchange_modes = ext[1..];
            },
            .pre_shared_key => {
                // RFC 8446 §4.2.11 — pre_shared_key MUST be the last extension.
                if (r.pos != extensions_end) return error.IllegalParameter;
                if (ext.len < 4) return error.InvalidExtensionLength;
                const identities_len = (@as(usize, ext[0]) << 8) | ext[1];
                if (2 + identities_len + 2 > ext.len) return error.InvalidExtensionLength;
                parsed.psk_ext = ext;
                // Binder transcript hash covers msg up to the binders list
                // (excluding the binders list itself). §4.2.11.2.
                const ext_offset = @intFromPtr(ext.ptr) - @intFromPtr(msg.ptr);
                parsed.binders_offset = ext_offset + 2 + identities_len;
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
    if (parsed.public_key != null and !parsed.groups.contains(.x25519))
        return error.IllegalParameter;
    if (parsed.public_key_p256 != null and !parsed.groups.contains(.secp256r1))
        return error.IllegalParameter;
    if (parsed.public_key_p384 != null and !parsed.groups.contains(.secp384r1))
        return error.IllegalParameter;
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

// Closed mirror of NamedGroup's named tags. EnumSet(NamedGroup) would be 8 KiB
// because NamedGroup is non-exhaustive enum(u16); this keeps the set tiny.
const KnownGroup = enum {
    x25519,
    secp256r1,
    secp384r1,
    secp256r1_mlkem768,
    x25519_mlkem768,
    secp384r1_mlkem1024,

    fn fromNamed(group: NamedGroup) ?KnownGroup {
        return switch (group) {
            .x25519 => .x25519,
            .secp256r1 => .secp256r1,
            .secp384r1 => .secp384r1,
            .secp256r1_mlkem768 => .secp256r1_mlkem768,
            .x25519_mlkem768 => .x25519_mlkem768,
            .secp384r1_mlkem1024 => .secp384r1_mlkem1024,
            else => null,
        };
    }
};

comptime {
    for (meta.fields(NamedGroup)) |named_group| {
        var found = false;
        for (meta.fields(KnownGroup)) |known_group| {
            if (mem.eql(u8, named_group.name, known_group.name)) found = true;
        }
        assert(found);
    }
}

pub const SupportedGroups = struct {
    set: std.EnumSet(KnownGroup) = .initEmpty(),

    pub fn contains(self: SupportedGroups, group: NamedGroup) bool {
        const known = KnownGroup.fromNamed(group) orelse return false;
        return self.set.contains(known);
    }

    pub fn insert(self: *SupportedGroups, group: NamedGroup) void {
        const known = KnownGroup.fromNamed(group) orelse return;
        self.set.insert(known);
    }

    fn hasImplemented(self: SupportedGroups) bool {
        return (backend.supportsServerX25519() and self.contains(.x25519)) or
            (backend.supportsServerP256() and self.contains(.secp256r1)) or
            (backend.supportsServerP384() and self.contains(.secp384r1));
    }
};

comptime {
    assert(@sizeOf(SupportedGroups) <= @sizeOf(usize));
}

fn parseSupportedGroups(ext: []const u8) ParseError!SupportedGroups {
    if (ext.len < 2) return error.InvalidVectorLength;
    var r: wire.Reader = .init(ext);
    const list_len = r.assumeRead(u16);
    if (list_len != ext.len - 2 or list_len % 2 != 0) return error.InvalidVectorLength;
    var groups: SupportedGroups = .{};
    while (r.pos < ext.len) groups.insert(r.assumeRead(NamedGroup));
    if (!groups.hasImplemented()) return error.UnsupportedKeyShare;
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
        if (backend.supportsCertificateVerifyScheme(scheme)) return true;
    }
    return false;
}

const ParsedKeyShares = struct {
    x25519: ?x25519.PublicKey = null,
    p256: ?p256.PublicKey = null,
    p384: ?p384.PublicKey = null,
    /// KEM hybrid key_share (raw bytes, group + data). Variable-length.
    /// draft-ietf-tls-ecdhe-mlkem-05 §4.1.
    kem: ?ParsedKemKeyShare = null,
};

/// KEM key_share stored in both ParsedKeyShares and Parsed.
pub const ParsedKemKeyShare = struct {
    group: NamedGroup,
    data: [server_hello.max_kem_share_len]u8,
    len: u16,
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
                if (key.len != x25519.public_length) return error.MalformedKeyShare;
                shares.x25519 = .init(key[0..x25519.public_length].*);
            },
            .secp256r1 => {
                if (shares.p256 != null) return error.DuplicateKeyShare;
                if (key.len != p256.public_length) return error.MalformedKeyShare;
                if (key[0] != 0x04) return error.MalformedKeyShare;
                shares.p256 = .init(key[0..p256.public_length].*);
            },
            .secp384r1 => {
                if (shares.p384 != null) return error.DuplicateKeyShare;
                if (key.len != p384.public_length) return error.MalformedKeyShare;
                if (key[0] != 0x04) return error.MalformedKeyShare;
                shares.p384 = .init(key[0..p384.public_length].*);
            },
            // KEM hybrid groups — store raw key_share bytes.
            // draft-ietf-tls-ecdhe-mlkem-05 §4.1.
            .x25519_mlkem768, .secp256r1_mlkem768, .secp384r1_mlkem1024 => {
                if (shares.kem != null) return error.DuplicateKeyShare;
                if (key.len > server_hello.max_kem_share_len)
                    return error.MalformedKeyShare;
                var kem: ParsedKemKeyShare = .{
                    .group = group,
                    .data = undefined,
                    .len = @intCast(key.len),
                };
                @memcpy(kem.data[0..key.len], key);
                shares.kem = kem;
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

// RFC 8446 §4.2.11 — pre_shared_key is the last extension; the binder prefix
// ends after the identities; the binder placeholder is zero-filled and at the
// reported offset.
test "encodeWithPsk: pre_shared_key is last, binder prefix and offset are correct" {
    const x_key: x25519.PublicKey = .init(@splat(0x11));
    const identity = [_]u8{ 0xaa, 0xbb, 0xcc };
    var buf: [1024]u8 = undefined;
    const r = try encodeWithPsk(
        &buf,
        .zero,
        x_key,
        null,
        null,
        null,
        &.{},
        .psk_dhe_ke,
        &identity,
        0x11223344,
        32,
        false,
    );
    try testing.expect(r.msg.len > 0);

    // pre_shared_key (0x0029) must be the last extension. Scan extensions and
    // confirm 0x0029 is the final one and psk_key_exchange_modes (0x002d)
    // precedes it.
    var seen_psk_last = false;
    var seen_kem = false;
    var i: usize = 39; // skip header(4)+version(2)+random(32)+sid_len(1)
    i += 0; // sid is empty
    i += 2 + cipher_suite_count * 2 + 1 + 1 + 2; // cipher suites + compression + ext list len
    while (i + 4 <= r.msg.len) {
        const ext_type = (@as(u16, r.msg[i]) << 8) | r.msg[i + 1];
        const ext_data_len = (@as(u16, r.msg[i + 2]) << 8) | r.msg[i + 3];
        if (ext_type == @intFromEnum(ExtensionType.psk_key_exchange_modes)) seen_kem = true;
        if (ext_type == @intFromEnum(ExtensionType.pre_shared_key)) {
            // Must be the last extension: no bytes after its ext_data.
            try testing.expectEqual(i + 4 + ext_data_len, r.msg.len);
            seen_psk_last = true;
        }
        i += 4 + ext_data_len;
    }
    try testing.expect(seen_psk_last);
    try testing.expect(seen_kem);

    // The binder placeholder is zero-filled at the reported offset.
    try testing.expectEqual(@as(usize, r.binder_offset + r.binder_len), r.msg.len);
    for (r.msg[r.binder_offset..][0..r.binder_len]) |b| try testing.expectEqual(@as(u8, 0), b);

    // The prefix ends right after the identities (before the binders list
    // length field). prefix_len + 2 (binders list len) + 1 (binder entry len)
    // + binder_len == msg.len.
    try testing.expectEqual(r.prefix_len + 2 + 1 + r.binder_len, r.msg.len);
}

// RFC 8446 §4.2.11 — parse() extracts the pre_shared_key extension, records
// the binder transcript prefix offset, and validates that pre_shared_key is
// the last extension.
test "parse: ClientHello with pre_shared_key round-trips" {
    const x_key: x25519.PublicKey = .init(@splat(0x11));
    const identity = [_]u8{ 0xaa, 0xbb, 0xcc };
    var buf: [1024]u8 = undefined;
    const r = try encodeWithPsk(
        &buf,
        .zero,
        x_key,
        null,
        null,
        null,
        &.{},
        .psk_dhe_ke,
        &identity,
        0x11223344,
        32,
        false,
    );
    const parsed = try parse(r.msg);
    try testing.expect(parsed.psk_ext != null);
    try testing.expect(parsed.psk_key_exchange_modes != null);
    // binders_offset matches the encoder's prefix_len (both point at the start
    // of the binders list within the message).
    try testing.expectEqual(r.prefix_len, parsed.binders_offset);
    // The identity appears in the parsed ext_data.
    try testing.expect(std.mem.indexOf(u8, parsed.psk_ext.?, &identity) != null);
}

// RFC 8446 §4.2.8 — encodedLenWithP256 accounts for the second key share.
test "encodeWithP256: size matches encodedLenWithP256" {
    const x_key: x25519.PublicKey = .init(@splat(0x11));
    var p_key: p256.PublicKey = .init(@splat(0x22));
    p_key.data[0] = 0x04;
    var buf: [512]u8 = undefined;
    const encoded = try encodeWithP256(&buf, .zero, x_key, p_key, "server", &.{});
    try testing.expectEqual(try encodedLenWithP256("server", &.{}), encoded.len);
}

test "encode: handshake type and legacy version" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    try testing.expectEqual(@as(u8, 0x01), encoded[0]);
    try testing.expectEqual(@as(u8, 0x03), encoded[4]);
    try testing.expectEqual(@as(u8, 0x03), encoded[5]);
}

test "encode: cipher suites match backend capabilities" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    const cs_offset = 39; // header(4) + version(2) + random(32) + session_id(1)
    try testing.expectEqual(
        @as(u16, @intCast(supported_cipher_suites.len * 2)),
        memx.readInt(u16, encoded[cs_offset..][0..2]),
    );
    inline for (supported_cipher_suites, 0..) |suite, i| {
        try testing.expectEqual(
            @intFromEnum(suite),
            memx.readInt(u16, encoded[cs_offset + 2 + i * 2 ..][0..2]),
        );
    }
}

// RFC 8446 §4.1.2 — without compatibility mode, legacy_session_id is empty.
test "encode: legacy_session_id is empty" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    const session_id_len_offset = 38; // header(4) + legacy_version(2) + random(32)
    try testing.expectEqual(@as(u8, 0), encoded[session_id_len_offset]);
}

// RFC 8446 §4.2.7 — the default test helper ClientHello advertises X25519 only.
test "encode: supported_groups contains X25519" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    const ext = try findExtension(encoded, .supported_groups);
    try testing.expectEqual(@as(u16, 2), memx.readInt(u16, ext[0..2]));
    try testing.expectEqual(@intFromEnum(NamedGroup.x25519), memx.readInt(u16, ext[2..][0..2]));
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

// RFC 8446 §4.2.7, §4.2.8 — client P-256 support advertises secp256r1
// and sends a matching uncompressed key share in the first ClientHello.
test "encodeWithP256: includes X25519 and secp256r1 key shares" {
    const x_key: x25519.PublicKey = .init(@splat(0x11));
    var p_key: p256.PublicKey = .init(@splat(0x22));
    p_key.data[0] = 0x04;

    var buf: [512]u8 = undefined;
    const encoded = try encodeWithP256(&buf, .zero, x_key, p_key, null, &.{});
    const parsed = try parse(encoded);

    try testing.expect(parsed.groups.contains(.x25519));
    try testing.expect(parsed.groups.contains(.secp256r1));
    try testing.expectEqualSlices(u8, &x_key.data, &parsed.public_key.?.data);
    try testing.expectEqualSlices(u8, &p_key.data, &parsed.public_key_p256.?.data);
}

// RFC 8446 §4.2.7, §4.2.8 — client P-384 support advertises secp384r1
// and sends a matching uncompressed 97-byte key share in the first ClientHello.
test "encodeWithP256P384: includes X25519, secp256r1, and secp384r1 key shares" {
    const x_key: x25519.PublicKey = .init(@splat(0x11));
    var p_key: p256.PublicKey = .init(@splat(0x22));
    p_key.data[0] = 0x04;
    var p384_key: p384.PublicKey = .init(@splat(0x33));
    p384_key.data[0] = 0x04;

    var buf: [768]u8 = undefined;
    const encoded = try encodeWithP256P384(&buf, .zero, x_key, p_key, p384_key, null, &.{});
    const parsed = try parse(encoded);

    try testing.expect(parsed.groups.contains(.x25519));
    try testing.expect(parsed.groups.contains(.secp256r1));
    try testing.expect(parsed.groups.contains(.secp384r1));
    try testing.expectEqualSlices(u8, &x_key.data, &parsed.public_key.?.data);
    try testing.expectEqualSlices(u8, &p_key.data, &parsed.public_key_p256.?.data);
    try testing.expectEqualSlices(u8, &p384_key.data, &parsed.public_key_p384.?.data);
}

// RFC 8446 §4.2.8.2 — P-384 key shares use uncompressed SEC1 points (97 bytes).
test "encodeWithP256P384: size matches encodedLenWithP256P384" {
    const x_key: x25519.PublicKey = .init(@splat(0x11));
    var p_key: p256.PublicKey = .init(@splat(0x22));
    p_key.data[0] = 0x04;
    var p384_key: p384.PublicKey = .init(@splat(0x33));
    p384_key.data[0] = 0x04;
    var buf: [768]u8 = undefined;
    const encoded = try encodeWithP256P384(&buf, .zero, x_key, p_key, p384_key, "server", &.{});
    try testing.expectEqual(try encodedLenWithP256P384("server", &.{}), encoded.len);
}

// RFC 8446 §4.2.8 — ClientHello parse accepts secp384r1 key share with the
// correct 97-byte uncompressed point.
test "parse: accepts secp384r1 key share" {
    const seed = memx.hex(48, "000102030405060708090a0b0c0d0e0f" ++
        "101112131415161718191a1b1c1d1e1f" ++
        "202122232425262728292a2b2c2d2e2f");
    const p384_keypair = try p384.KeyPair.generateDeterministic(.init(seed));

    var buf: [768]u8 = undefined;
    const encoded = try encodeWithP256P384(
        &buf,
        .zero,
        .init(@splat(0)),
        blk: {
            var k: p256.PublicKey = .init(@splat(0));
            k.data[0] = 0x04;
            break :blk k;
        },
        p384_keypair.public_key,
        null,
        &.{},
    );
    const parsed = try parse(encoded);
    try testing.expect(parsed.groups.contains(.secp384r1));
    try testing.expectEqualSlices(
        u8,
        &p384_keypair.public_key.data,
        &parsed.public_key_p384.?.data,
    );
}

// RFC 8446 §4.2.8.2 — compressed P-384 points are not valid TLS key shares.
test "parse: rejects compressed secp384r1 key share" {
    var p384_key: p384.PublicKey = .init(@splat(0x33));
    p384_key.data[0] = 0x02; // compressed prefix
    var buf: [768]u8 = undefined;
    const encoded = try encodeWithP256P384(
        &buf,
        .zero,
        .init(@splat(0)),
        blk: {
            var k: p256.PublicKey = .init(@splat(0));
            k.data[0] = 0x04;
            break :blk k;
        },
        p384_key,
        null,
        &.{},
    );
    try testing.expectError(error.MalformedKeyShare, parse(encoded));
}

// RFC 8446 §4.1.4, §4.2.8 — ClientHello2 key_share uses the HRR selected group.
test "encodeRetryAfterHrr: secp384r1 selected, no cookie" {
    const x_key: x25519.PublicKey = .init(@splat(0x11));
    var p_key: p256.PublicKey = .init(@splat(0x22));
    p_key.data[0] = 0x04;
    var p384_key: p384.PublicKey = .init(@splat(0x33));
    p384_key.data[0] = 0x04;

    var buf: [512]u8 = undefined;
    const encoded = try encodeRetryAfterHrr(
        &buf,
        .zero,
        x_key,
        p_key,
        p384_key,
        .secp384r1,
        null,
        null,
        &.{},
    );
    const parsed = try parse(encoded);

    // key_share must contain only secp384r1.
    try testing.expectEqual(@as(?x25519.PublicKey, null), parsed.public_key);
    try testing.expectEqual(@as(?p256.PublicKey, null), parsed.public_key_p256);
    try testing.expectEqualSlices(u8, &p384_key.data, &parsed.public_key_p384.?.data);

    // supported_groups must still advertise all three groups.
    try testing.expect(parsed.groups.contains(.x25519));
    try testing.expect(parsed.groups.contains(.secp256r1));
    try testing.expect(parsed.groups.contains(.secp384r1));
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

// RFC 8446 §4.2.3 — signature_algorithms advertises CertificateVerify
// schemes the active backend supports.
test "encode: signature_algorithms match backend capabilities" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    const ext = try findExtension(encoded, .signature_algorithms);
    try expectSignatureSchemeList(ext, supported_signature_schemes);
}

// RFC 8446 §4.2.3 — signature_algorithms_cert advertises certificate-specific
// signature algorithms separately from CertificateVerify algorithms.
test "encode: signature_algorithms_cert match backend capabilities" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    const ext = try findExtension(encoded, .signature_algorithms_cert);
    try expectSignatureSchemeList(ext, supported_certificate_signature_schemes);
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

fn expectSignatureSchemeList(ext: []const u8, schemes: []const SignatureScheme) !void {
    try testing.expectEqual(@as(u16, @intCast(schemes.len * 2)), memx.readInt(u16, ext[0..2]));
    for (schemes, 0..) |scheme, i| {
        try testing.expectEqual(@intFromEnum(scheme), memx.readInt(u16, ext[2 + i * 2 ..][0..2]));
    }
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

fn truncateX25519KeyShare(buf: []u8, encoded_len: usize) !usize {
    const key_share_offset = try findExtensionOffset(buf[0..encoded_len], .key_share);
    const ext_len = memx.readInt(u16, buf[key_share_offset + 2 ..][0..2]);
    const shares_len = memx.readInt(u16, buf[key_share_offset + 4 ..][0..2]);
    const key_len = memx.readInt(u16, buf[key_share_offset + 8 ..][0..2]);
    assert(key_len == x25519.public_length);

    memx.writeInt(u16, buf[key_share_offset + 2 ..][0..2], ext_len - 1);
    memx.writeInt(u16, buf[key_share_offset + 4 ..][0..2], shares_len - 1);
    memx.writeInt(u16, buf[key_share_offset + 8 ..][0..2], key_len - 1);

    const remove_at = key_share_offset + 10 + key_len - 1;
    @memmove(buf[remove_at .. encoded_len - 1], buf[remove_at + 1 .. encoded_len]);
    const new_len = encoded_len - 1;
    const body_len = memx.readInt(u24, buf[1..4]) - 1;
    memx.writeInt(u24, buf[1..4], body_len);
    const extensions_len = memx.readInt(u16, buf[extensions_len_offset..][0..2]) - 1;
    memx.writeInt(u16, buf[extensions_len_offset..][0..2], extensions_len);
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
    try testing.expect(parsed.offered_extensions.contains(.server_name));
    try testing.expectEqualStrings("example.com", parsed.server_name.?);
    try testing.expectEqualSlices(u8, &key.data, &parsed.public_key.?.data);
    const alpn_wire = [_]u8{ 0x02, 'h', '2', 0x08, 'h', 't', 't', 'p', '/', '1', '.', '1' };
    try testing.expectEqualSlices(u8, &alpn_wire, parsed.alpn_protocols);
    try testing.expectEqualStrings("http/1.1", parsed.selectAlpn(&.{ "http/1.1", "h2" }).?);
    try testing.expectEqualStrings("h2", parsed.selectAlpn(&.{"h2"}).?);
    try testing.expectEqual(@as(?[]const u8, null), parsed.selectAlpn(&.{"bogus"}));
}

// RFC 8446 §4.2 / RFC 6066 §3 — extension presence is separate from whether
// ztls extracted a hostname value from the ServerNameList.
test "parse: tracks offered SNI extension presence" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, "example.com", &.{});
    const sni = try findExtension(encoded, .server_name);
    sni[2] = 1; // unknown ServerName NameType, so Parsed.server_name remains null.

    const parsed = try parse(encoded);
    try testing.expectEqual(@as(?[]const u8, null), parsed.server_name);
    try testing.expect(parsed.offered_extensions.contains(.server_name));
}

// RFC 8449 §4 — record_size_limit ClientHello presence is tracked for later
// EncryptedExtensions validation.
test "parse: tracks offered record_size_limit extension presence" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    const rsl = [_]u8{ 0x00, 0x1c, 0x00, 0x02, 0x04, 0x00 };
    const with_rsl = appendExtension(&buf, encoded.len, &rsl);

    const parsed = try parse(buf[0..with_rsl]);
    try testing.expect(parsed.offered_extensions.contains(.record_size_limit));
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
    try testing.expect(!parsed.groups.contains(.x25519));
    try testing.expect(parsed.groups.contains(.secp256r1));
    try testing.expectEqual(@as(?x25519.PublicKey, null), parsed.public_key);
    try testing.expectEqualSlices(
        u8,
        &p256_keypair.public_key.data,
        &parsed.public_key_p256.?.data,
    );
}

// RFC 8446 §4.2.7 — known future groups are recorded without making them
// negotiable before key-share and provider support exist.
test "parseSupportedGroups: records future groups but requires implemented overlap" {
    try testing.expectError(
        error.UnsupportedKeyShare,
        parseSupportedGroups(&.{ 0x00, 0x02, 0x11, 0xec }),
    );

    const groups = try parseSupportedGroups(&.{
        0x00, 0x04,
        0x00, 0x1d, // x25519
        0x11, 0xec, // x25519_mlkem768
    });
    try testing.expect(groups.contains(.x25519));
    try testing.expect(groups.contains(.x25519_mlkem768));
    try testing.expect(!groups.contains(.secp256r1));
}

// RFC 8446 §4.2.8 — invalid key_exchange length is illegal_parameter input.
test "parse: rejects malformed X25519 key share" {
    var buf: [512]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    const bad_len = try truncateX25519KeyShare(&buf, encoded.len);
    try testing.expectError(error.MalformedKeyShare, parse(buf[0..bad_len]));
}

// RFC 8446 §4.2.8 — key_share groups must be advertised in supported_groups.
test "parse: rejects key share outside supported_groups" {
    const seed = memx.hex(32, "000102030405060708090a0b0c0d0e0f" ++
        "101112131415161718191a1b1c1d1e1f");
    const p256_keypair = try p256.KeyPair.generateDeterministic(.init(seed));
    var buf: [768]u8 = undefined;
    const encoded = try encode(&buf, .zero, .zero, null, &.{});
    const p256_len = try rewriteClientHelloForP256(&buf, encoded.len, p256_keypair.public_key);
    const groups = try findExtension(buf[0..p256_len], .supported_groups);
    var i: usize = 2;
    while (i < groups.len) : (i += 2) {
        groups[i] = 0x00;
        groups[i + 1] = @intFromEnum(NamedGroup.x25519);
    }

    try testing.expectError(error.IllegalParameter, parse(buf[0..p256_len]));
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

    // Rewrite every implemented group id to x25519_mlkem768 (0x11ec), a named
    // but not-yet-implemented group. With .zero public key bytes these
    // occurrences are supported_groups/key_share ids.
    var i: usize = 0;
    while (i + 1 < msg.len) : (i += 1) {
        if (msg[i] == 0x00 and (msg[i + 1] == 0x1d or msg[i + 1] == 0x17)) {
            msg[i] = 0x11;
            msg[i + 1] = 0xec;
        }
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
    // Rewrite key_share group x25519 (0x001d) to secp521r1 (0x0019), a named
    // but not-yet-implemented group, while leaving supported_groups unchanged.
    key_share[2] = 0x00;
    key_share[3] = 0x19;

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
    try testing.expect(parsed.contains(.x25519));
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
    try fuzz_compat.fuzzBytes(fuzzParse, {}, .{ .corpus = &.{seed} });
}

// RFC 8446 §4.1.2 — ClientHello2 after HelloRetryRequest contains only the
// selected group's key_share and echoes the cookie.
test "encodeRetryAfterHrr: X25519 selected, no cookie" {
    const x_key: x25519.PublicKey = .init(@splat(0x11));
    var p_key: p256.PublicKey = .init(@splat(0x22));
    p_key.data[0] = 0x04;
    var p384_key: p384.PublicKey = .init(@splat(0x33));
    p384_key.data[0] = 0x04;

    var buf: [512]u8 = undefined;
    const encoded = try encodeRetryAfterHrr(
        &buf,
        .zero,
        x_key,
        p_key,
        p384_key,
        .x25519,
        null,
        null,
        &.{},
    );
    const parsed = try parse(encoded);

    // key_share must contain only X25519.
    try testing.expectEqualSlices(u8, &x_key.data, &parsed.public_key.?.data);
    try testing.expectEqual(@as(?p256.PublicKey, null), parsed.public_key_p256);
    try testing.expectEqual(@as(?p384.PublicKey, null), parsed.public_key_p384);

    // supported_groups must still advertise all three groups.
    try testing.expect(parsed.groups.contains(.x25519));
    try testing.expect(parsed.groups.contains(.secp256r1));
    try testing.expect(parsed.groups.contains(.secp384r1));
}

// RFC 8446 §4.1.4, §4.2.8 — ClientHello2 key_share uses the HRR selected group.
test "encodeRetryAfterHrr: secp256r1 selected, no cookie" {
    const x_key: x25519.PublicKey = .init(@splat(0x11));
    var p_key: p256.PublicKey = .init(@splat(0x22));
    p_key.data[0] = 0x04;
    var p384_key: p384.PublicKey = .init(@splat(0x33));
    p384_key.data[0] = 0x04;

    var buf: [512]u8 = undefined;
    const encoded = try encodeRetryAfterHrr(
        &buf,
        .zero,
        x_key,
        p_key,
        p384_key,
        .secp256r1,
        null,
        null,
        &.{},
    );
    const parsed = try parse(encoded);

    // key_share must contain only secp256r1.
    try testing.expectEqual(@as(?x25519.PublicKey, null), parsed.public_key);
    try testing.expectEqualSlices(u8, &p_key.data, &parsed.public_key_p256.?.data);

    // supported_groups must still advertise all three groups.
    try testing.expect(parsed.groups.contains(.x25519));
    try testing.expect(parsed.groups.contains(.secp256r1));
    try testing.expect(parsed.groups.contains(.secp384r1));
}

// RFC 8446 §4.2.2 — the cookie from HelloRetryRequest is echoed in ClientHello2.
test "encodeRetryAfterHrr: includes cookie when provided" {
    const x_key: x25519.PublicKey = .init(@splat(0x11));
    var p_key: p256.PublicKey = .init(@splat(0x22));
    p_key.data[0] = 0x04;
    var p384_key: p384.PublicKey = .init(@splat(0x33));
    p384_key.data[0] = 0x04;
    const cookie = [_]u8{ 0xde, 0xad, 0xbe, 0xef };

    var buf: [512]u8 = undefined;
    const encoded = try encodeRetryAfterHrr(
        &buf,
        .zero,
        x_key,
        p_key,
        p384_key,
        .x25519,
        &cookie,
        null,
        &.{},
    );

    // Verify the cookie extension is present by finding it in the encoded bytes.
    const ext = try findExtension(encoded, .cookie);
    // cookie extension_data = u16 cookie_len || cookie bytes
    try testing.expectEqual(@as(u16, cookie.len), memx.readInt(u16, ext[0..2]));
    try testing.expectEqualSlices(u8, &cookie, ext[2..][0..cookie.len]);
}

// RFC 8446 §4.1.2 — ClientHello2 with SNI and ALPN preserves those extensions.
test "encodeRetryAfterHrr: preserves SNI and ALPN from ClientHello1" {
    const x_key: x25519.PublicKey = .init(@splat(0x11));
    var p_key: p256.PublicKey = .init(@splat(0x22));
    p_key.data[0] = 0x04;
    var p384_key: p384.PublicKey = .init(@splat(0x33));
    p384_key.data[0] = 0x04;

    var buf: [512]u8 = undefined;
    const encoded = try encodeRetryAfterHrr(
        &buf,
        .zero,
        x_key,
        p_key,
        p384_key,
        .x25519,
        null,
        "example.com",
        &.{"h2"},
    );
    const parsed = try parse(encoded);
    try testing.expectEqualStrings("example.com", parsed.server_name.?);
    try testing.expectEqualStrings("h2", parsed.selectAlpn(&.{"h2"}).?);
}

// RFC 8446 §4.2.8 — an unsupported selected group is rejected.
test "encodeRetryAfterHrr: rejects unsupported group" {
    var buf: [512]u8 = undefined;
    try testing.expectError(
        error.UnsupportedGroup,
        encodeRetryAfterHrr(
            &buf,
            .zero,
            .zero,
            .init(@splat(0)),
            .init(@splat(0)),
            .x25519_mlkem768,
            null,
            null,
            &.{},
        ),
    );
}
