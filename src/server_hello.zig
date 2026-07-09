//! TLS 1.3 ServerHello handshake message parsing.
//!
//! RFC 8446 §4.1.3
const std = @import("std");
const testing = std.testing;
const fuzz_compat = @import("fuzz_compat.zig");
const mem = std.mem;

const CipherSuite = @import("root.zig").CipherSuite;
const CompressionMethod = @import("compression_method.zig").CompressionMethod;
const extension_type = @import("extension_type.zig");
const ExtensionType = extension_type.ExtensionType;
const handshake = @import("handshake.zig");
const NamedGroup = @import("kex.zig").NamedGroup;
const p256 = @import("p256.zig");
const p384 = @import("p384.zig");
const ProtocolVersion = @import("protocol_version.zig").ProtocolVersion;
const wire = @import("wire.zig");
const array_buffer = @import("array_buffer.zig");
const ArrayBuffer = array_buffer.ArrayBuffer;
const x25519 = @import("x25519.zig");

const ext_header_len = 2 + 2;

pub const ServerHello = struct {
    /// The negotiated cipher suite. Determines which HKDF hash to use.
    cipher_suite: CipherSuite,
    /// Server's ephemeral public key from the key_share extension.
    key_share: KeyShare,
    /// PSK identity index selected by the server (RFC 8446 §4.2.11), or null
    /// when the server did not resume with a PSK.
    selected_identity: ?u16 = null,
};

pub const ParseError = error{
    UnexpectedEof,
    /// Handshake type byte is not server_hello (0x02).
    InvalidHandshakeType,
    /// Handshake length field does not match the supplied message.
    InvalidHandshakeLength,
    /// Extension block or extension length is malformed.
    InvalidExtensionLength,
    /// A singleton extension appeared more than once.
    DuplicateExtension,
    /// A field contained an unrecognised enum value.
    InvalidEnumTag,
    /// Server selected HelloRetryRequest; ztls does not implement the retry path yet.
    HelloRetryRequest,
    /// legacy_version is SSLv3-or-lower, or supported_versions is absent.
    UnsupportedTlsVersion,
    /// Semantic protocol violation requiring illegal_parameter.
    IllegalParameter,
    /// legacy_session_id_echo does not match the ClientHello legacy_session_id.
    InvalidSessionIdEcho,
    /// legacy_compression_method is not null compression.
    InvalidCompressionMethod,
    /// key_share extension uses an unsupported group or wrong key encoding.
    UnsupportedKeyShareGroup,
    /// A recognized extension appeared in a message where TLS 1.3 does not allow it.
    UnexpectedExtension,
    /// Server sent an extension the client did not request (RFC 8446 §4.2).
    UnsupportedExtension,
    /// A required TLS 1.3 ServerHello extension was absent.
    MissingExtension,
};

pub const hello_retry_request_random = [_]u8{
    0xcf, 0x21, 0xad, 0x74, 0xe5, 0x9a, 0x61, 0x11,
    0xbe, 0x1d, 0x8c, 0x02, 0x1e, 0x65, 0xb8, 0x91,
    0xc2, 0xa2, 0x11, 0x16, 0x7a, 0xbb, 0x8c, 0x5e,
    0x07, 0x9e, 0x09, 0xe2, 0xc8, 0xa8, 0x33, 0x9c,
};

const downgrade_tls12 = "DOWNGRD\x01".*;
const downgrade_tls11_or_below = "DOWNGRD\x00".*;

fn hasDowngradeSentinel(random: []const u8) bool {
    if (random.len != 32) return false;
    const tail = random[24..32];
    return mem.eql(u8, tail, &downgrade_tls12) or
        mem.eql(u8, tail, &downgrade_tls11_or_below);
}

/// A parsed HelloRetryRequest message.  RFC 8446 §4.1.4.
///
/// The HRR is wire-encoded identically to a ServerHello (type 0x02) but with
/// a fixed Random value (hello_retry_request_random).  This struct carries the
/// fields that a client needs to construct ClientHello2.
///
/// `cookie` is a slice into the caller-supplied message buffer — it is only
/// valid for the lifetime of that buffer.
pub const HelloRetryRequest = struct {
    /// The cipher suite selected by the server.  Determines the transcript hash.
    cipher_suite: CipherSuite,
    /// The named group the server wants the client to use for its key share.
    /// Null when the HRR contains no key_share extension (unusual but legal).
    selected_group: ?NamedGroup,
    /// The server cookie, if present.  RFC 8446 §4.2.2.  The client MUST echo
    /// this verbatim in the cookie extension of ClientHello2.
    cookie: ?[]const u8,
};

pub const HrrParseError = error{
    UnexpectedEof,
    /// Handshake type byte is not server_hello (0x02).
    InvalidHandshakeType,
    /// Handshake length field does not match the supplied message.
    InvalidHandshakeLength,
    /// The Random field does not match the HelloRetryRequest magic value.
    NotHelloRetryRequest,
    /// Extension block or extension length is malformed.
    InvalidExtensionLength,
    /// A singleton extension appeared more than once.
    DuplicateExtension,
    /// A field contained an unrecognised enum value.
    InvalidEnumTag,
    /// legacy_version is SSLv3-or-lower.
    UnsupportedTlsVersion,
    /// Semantic protocol violation requiring illegal_parameter.
    IllegalParameter,
    /// legacy_session_id_echo does not match the ClientHello legacy_session_id.
    InvalidSessionIdEcho,
    /// legacy_compression_method is not null compression.
    InvalidCompressionMethod,
    /// A recognized extension appeared in a message where TLS 1.3 does not allow it.
    UnexpectedExtension,
    /// Server sent an extension the client did not request (RFC 8446 §4.2).
    UnsupportedExtension,
    /// A required extension was absent or malformed.
    MissingExtension,
};

/// Parse a HelloRetryRequest handshake message.
///
/// `msg` must be the complete handshake message including the 4-byte header
/// (type + 3-byte length).  It is the same wire format as ServerHello — type
/// 0x02, with hello_retry_request_random in the Random field.
///
/// The caller must feed `msg` into the transcript hash *after* calling this
/// function and applying the transcript collapse (see transcript.messageHashSynthetic).
///
/// RFC 8446 §4.1.4, §4.2.2, §4.2.8.
pub fn parseHelloRetryRequest(msg: []const u8) HrrParseError!HelloRetryRequest {
    return parseHelloRetryRequestWithSessionIdEcho(msg, null);
}

pub fn parseHelloRetryRequestWithSessionIdEcho(
    msg: []const u8,
    expected_session_id: ?[]const u8,
) HrrParseError!HelloRetryRequest {
    if (msg.len < 4) return error.UnexpectedEof;
    var r: wire.Reader = .init(msg);

    const handshake_type = r.assumeRead(handshake.Type);
    if (handshake_type != .server_hello) return error.InvalidHandshakeType;
    const body_len = r.assumeRead(u24);
    if (body_len != msg.len - 4) return error.InvalidHandshakeLength;
    if (body_len < 2 + 32 + 1 + 2 + 1 + 2) return error.UnexpectedEof;

    // RFC 8446 §4.2.1: clients MUST ignore legacy_version when supported_versions
    // selects TLS 1.3. Reject SSLv3-or-lower unconditionally (Appendix D.5); any
    // value above 0x0300 is otherwise accepted.
    const legacy_version = r.assumeRead(ProtocolVersion);
    if (@intFromEnum(legacy_version) <= 0x0300) return error.UnsupportedTlsVersion;
    const random = r.assumeReadSlice(32);
    if (!mem.eql(u8, random, &hello_retry_request_random)) return error.NotHelloRetryRequest;

    const session_id_len = r.assumeRead(u8);
    if (r.remaining().len < session_id_len + 2 + 1 + 2) return error.UnexpectedEof;
    const session_id_echo = r.assumeReadSlice(session_id_len);
    if (expected_session_id) |expected| {
        if (!mem.eql(u8, session_id_echo, expected)) return error.InvalidSessionIdEcho;
    }

    const cipher_suite = CipherSuite.fromWire(r.assumeRead(u16)) orelse return error.InvalidEnumTag;
    const compression_method = r.assumeRead(CompressionMethod);
    if (compression_method != .no_compression) return error.InvalidCompressionMethod;

    const extensions_len = r.assumeRead(u16);
    if (extensions_len != msg.len - r.pos) return error.InvalidExtensionLength;
    const extensions_end = r.pos + extensions_len;
    try extension_type.rejectDuplicateExtensions(msg[r.pos..extensions_end]);

    var selected_group: ?NamedGroup = null;
    var cookie: ?[]const u8 = null;
    var got_supported_versions = false;
    var got_key_share = false;
    var got_cookie = false;

    while (r.pos < extensions_end) {
        if (extensions_end - r.pos < 4) return error.InvalidExtensionLength;
        const ext_type = r.assumeRead(ExtensionType);
        const ext_len = r.assumeRead(u16);
        if (ext_len > extensions_end - r.pos) return error.InvalidExtensionLength;

        switch (ext_type) {
            // supported_versions (RFC 8446 §4.2.1)
            .supported_versions => {
                if (got_supported_versions) return error.DuplicateExtension;
                if (ext_len != 2) return error.InvalidExtensionLength;
                const version = r.assumeRead(ProtocolVersion);
                // RFC 8446 §4.2.1: HRR supported_versions MUST select TLS 1.3;
                // any other value is a protocol violation.
                if (version != .tls_1_3) return error.IllegalParameter;
                got_supported_versions = true;
            },
            // key_share: in HRR carries a single NamedGroup (selected_group).
            // RFC 8446 §4.2.8 KeyShareHelloRetryRequest.
            .key_share => {
                if (got_key_share) return error.DuplicateExtension;
                if (ext_len != 2) return error.InvalidExtensionLength;
                selected_group = try r.read(NamedGroup);
                got_key_share = true;
            },
            // cookie (RFC 8446 §4.2.2) — opaque<1..2^16-1>.
            .cookie => {
                if (got_cookie) return error.DuplicateExtension;
                if (ext_len < 2) return error.InvalidExtensionLength;
                const cookie_len = r.assumeRead(u16);
                if (cookie_len == 0 or cookie_len != ext_len - 2)
                    return error.InvalidExtensionLength;
                cookie = r.assumeReadSlice(cookie_len);
                got_cookie = true;
            },
            else => {
                if (ext_type.isGrease()) return error.UnexpectedExtension;
                switch (ext_type) {
                    .server_name,
                    .status_request,
                    .supported_groups,
                    .signature_algorithms,
                    .heartbeat,
                    .alpn,
                    .status_request_v2,
                    .signed_certificate_timestamp,
                    .padding,
                    .pre_shared_key,
                    .early_data,
                    .psk_key_exchange_modes,
                    .certificate_authorities,
                    .oid_filters,
                    .post_handshake_auth,
                    .signature_algorithms_cert,
                    .record_size_limit,
                    => return error.UnexpectedExtension,
                    // RFC 8446 §4.2 — the server MUST NOT send extensions the
                    // client did not offer; abort with unsupported_extension.
                    else => return error.UnsupportedExtension,
                }
            },
        }
    }

    if (r.pos != extensions_end) return error.InvalidExtensionLength;
    if (!got_supported_versions) return error.MissingExtension;

    return .{
        .cipher_suite = cipher_suite,
        .selected_group = selected_group,
        .cookie = cookie,
    };
}

pub const encoded_len = 4 + 2 + 32 + 1 + 2 + 1 + 2 + (4 + 2 + 2 + 32) + (4 + 2);

/// Maximum KEM key_share size (client or server) across all hybrid groups.
/// SecP384r1MLKEM1024 client share = 1665, server share = 1665.
/// draft-ietf-tls-ecdhe-mlkem-05 §4.
pub const max_kem_share_len = 1665;

pub const KeyShare = union(enum) {
    x25519: x25519.PublicKey,
    secp256r1: p256.PublicKey,
    secp384r1: p384.PublicKey,
    /// KEM hybrid key_share (server side: the ciphertext from encapsulate).
    /// draft-ietf-tls-ecdhe-mlkem-05 §4.2. The bytes are the concatenation
    /// of the ML-KEM ciphertext and the server's ECDHE share, in the order
    /// specified by the group.
    kem: struct {
        group: NamedGroup,
        data: ArrayBuffer(u8, max_kem_share_len),
    },

    pub fn group(self: KeyShare) NamedGroup {
        return switch (self) {
            .x25519 => .x25519,
            .secp256r1 => .secp256r1,
            .secp384r1 => .secp384r1,
            .kem => |k| k.group,
        };
    }

    fn bytes(self: *const KeyShare) []const u8 {
        return switch (self.*) {
            inline .x25519, .secp256r1, .secp384r1 => |*key| &key.data,
            .kem => |k| k.data.constSlice(),
        };
    }
};

pub const EncodeError = error{BufferTooShort};

/// Encode a TLS 1.3 HelloRetryRequest handshake message. The caller supplies
/// the legacy_session_id_echo from ClientHello1. RFC 8446 §4.1.4, Appendix D.4.
pub fn encodeHelloRetryRequest(
    out: []u8,
    legacy_session_id_echo: []const u8,
    cipher_suite: CipherSuite,
    selected_group: NamedGroup,
) EncodeError![]const u8 {
    const extensions_len = 12; // key_share(selected_group) + supported_versions
    const body_len: usize = 2 + 32 + 1 + legacy_session_id_echo.len + 2 + 1 + 2 + extensions_len;
    const total = 4 + body_len;
    if (out.len < total) return error.BufferTooShort;

    var w: wire.Writer = .init(out);
    w.append(handshake.Type, .server_hello);
    w.append(u24, @intCast(body_len));
    w.append(ProtocolVersion, .tls_1_2);
    w.appendSlice(&hello_retry_request_random);
    w.append(u8, @intCast(legacy_session_id_echo.len));
    w.appendSlice(legacy_session_id_echo);
    w.append(CipherSuite, cipher_suite);
    w.append(CompressionMethod, .no_compression);

    w.append(u16, extensions_len);
    w.append(ExtensionType, .key_share);
    w.append(u16, 2);
    w.append(NamedGroup, selected_group);
    w.append(ExtensionType, .supported_versions);
    w.append(u16, 2);
    w.append(ProtocolVersion, .tls_1_3);
    return w.written();
}

/// Encode a TLS 1.3 ServerHello handshake message. The caller supplies the
/// legacy_session_id_echo from ClientHello; ztls' client currently sends an
/// empty one, but the server path needs to echo arbitrary caller-owned bytes.
/// RFC 8446 §4.1.3.
pub fn encode(
    out: []u8,
    random: [32]u8,
    session_id_echo: []const u8,
    cipher_suite: CipherSuite,
    public_key: x25519.PublicKey,
) EncodeError![]const u8 {
    return encodeWithKeyShare(
        out,
        random,
        session_id_echo,
        cipher_suite,
        .{ .x25519 = public_key },
    );
}

pub fn encodeWithKeyShare(
    out: []u8,
    random: [32]u8,
    session_id_echo: []const u8,
    cipher_suite: CipherSuite,
    key_share: KeyShare,
) EncodeError![]const u8 {
    if (session_id_echo.len > 32) return error.BufferTooShort;
    const key = key_share.bytes();
    const key_share_ext_len: u16 = @intCast(2 + 2 + key.len);
    const extensions_len: u16 = (ext_header_len + key_share_ext_len) + (ext_header_len + 2);
    const len = 4 + 2 + 32 + 1 + session_id_echo.len + 2 + 1 + 2 + extensions_len;
    if (out.len < len) return error.BufferTooShort;

    var w: wire.Writer = .init(out);
    w.append(handshake.Type, .server_hello);
    w.append(u24, @intCast(len - 4));
    w.append(ProtocolVersion, .tls_1_2);
    w.appendSlice(&random);
    w.append(u8, @intCast(session_id_echo.len));
    w.appendSlice(session_id_echo);
    w.append(CipherSuite, cipher_suite);
    w.append(CompressionMethod, .no_compression);

    w.append(u16, extensions_len);
    w.append(ExtensionType, .key_share);
    w.append(u16, key_share_ext_len);
    w.append(NamedGroup, key_share.group());
    w.append(u16, @intCast(key.len));
    w.appendSlice(key);
    w.append(ExtensionType, .supported_versions);
    w.append(u16, 0x0002);
    w.append(ProtocolVersion, .tls_1_3);
    return w.written();
}

/// Encode a ServerHello that selects a PSK identity (RFC 8446 §4.1.3, §4.2.11).
/// Adds a pre_shared_key extension carrying the selected_identity index after
/// supported_versions. Used for psk_dhe_ke resumption (key_share is still
/// present) or psk_ke (key_share omitted by the caller via an empty key_share —
/// not currently used, ztls only does psk_dhe_ke).
pub fn encodeWithKeyShareAndPsk(
    out: []u8,
    random: [32]u8,
    session_id_echo: []const u8,
    cipher_suite: CipherSuite,
    key_share: KeyShare,
    selected_identity: u16,
) EncodeError![]const u8 {
    if (session_id_echo.len > 32) return error.BufferTooShort;
    const key = key_share.bytes();
    const key_share_ext_len: u16 = @intCast(2 + 2 + key.len);
    const psk_ext_len: u16 = @intCast(ext_header_len + 2); // ext header + u16 index
    const extensions_len: u16 = (ext_header_len + key_share_ext_len) +
        (ext_header_len + 2) + psk_ext_len;
    const len = 4 + 2 + 32 + 1 + session_id_echo.len + 2 + 1 + 2 + extensions_len;
    if (out.len < len) return error.BufferTooShort;

    var w: wire.Writer = .init(out);
    w.append(handshake.Type, .server_hello);
    w.append(u24, @intCast(len - 4));
    w.append(ProtocolVersion, .tls_1_2);
    w.appendSlice(&random);
    w.append(u8, @intCast(session_id_echo.len));
    w.appendSlice(session_id_echo);
    w.append(CipherSuite, cipher_suite);
    w.append(CompressionMethod, .no_compression);

    w.append(u16, extensions_len);
    w.append(ExtensionType, .key_share);
    w.append(u16, key_share_ext_len);
    w.append(NamedGroup, key_share.group());
    w.append(u16, @intCast(key.len));
    w.appendSlice(key);
    w.append(ExtensionType, .supported_versions);
    w.append(u16, 0x0002);
    w.append(ProtocolVersion, .tls_1_3);
    // pre_shared_key (RFC 8446 §4.2.11): ext_data is a single u16
    // selected_identity.
    w.append(ExtensionType, .pre_shared_key);
    w.append(u16, 2);
    w.append(u16, selected_identity);
    return w.written();
}
///
/// `msg` must be the complete handshake message including the 4-byte header
/// (type + 3-byte length). Feed it into the transcript hash before calling.
///
/// RFC 8446 §4.1.3
pub fn parse(msg: []const u8) ParseError!ServerHello {
    return parseWithSessionIdEcho(msg, null);
}

pub fn parseWithSessionIdEcho(
    msg: []const u8,
    expected_session_id: ?[]const u8,
) ParseError!ServerHello {
    if (msg.len < 4) return error.UnexpectedEof;
    var r: wire.Reader = .init(msg);

    // Handshake header (RFC 8446 §4)
    const handshake_type = r.assumeRead(handshake.Type);
    if (handshake_type != .server_hello) return error.InvalidHandshakeType;
    const body_len = r.assumeRead(u24);
    if (body_len != msg.len - 4) return error.InvalidHandshakeLength;
    if (body_len < 2 + 32 + 1 + 2 + 1 + 2) return error.UnexpectedEof;

    // ServerHello body (RFC 8446 §4.1.3). Reject SSLv3-or-lower unconditionally
    // (Appendix D.5). RFC 8446 §4.2.1 requires clients to ignore legacy_version
    // when supported_versions selects TLS 1.3; the version field is validated
    // after extensions are parsed.
    const legacy_version = r.assumeRead(ProtocolVersion);
    if (@intFromEnum(legacy_version) <= 0x0300) return error.UnsupportedTlsVersion;
    const random = r.assumeReadSlice(32);
    if (mem.eql(u8, random, &hello_retry_request_random)) return error.HelloRetryRequest;

    const session_id_len = r.assumeRead(u8);
    if (r.remaining().len < session_id_len + 2 + 1 + 2) return error.UnexpectedEof;
    const session_id_echo = r.assumeReadSlice(session_id_len);
    if (expected_session_id) |expected| {
        if (!mem.eql(u8, session_id_echo, expected)) return error.InvalidSessionIdEcho;
    }

    const cipher_suite = CipherSuite.fromWire(r.assumeRead(u16)) orelse return error.InvalidEnumTag;
    const compression_method = r.assumeRead(CompressionMethod);
    if (compression_method != .no_compression) return error.InvalidCompressionMethod;

    // Extensions
    const extensions_len = r.assumeRead(u16);
    if (extensions_len > msg.len - r.pos) return error.InvalidExtensionLength;
    const extensions_end = r.pos + extensions_len;
    try extension_type.rejectDuplicateExtensions(msg[r.pos..extensions_end]);

    var got_supported_versions = false;
    var key_share: KeyShare = undefined;
    var got_key_share = false;
    var selected_identity: ?u16 = null;

    while (r.pos < extensions_end) {
        if (extensions_end - r.pos < 4) return error.InvalidExtensionLength;
        const ext_type = r.assumeRead(ExtensionType);
        const ext_len = r.assumeRead(u16);
        if (ext_len > extensions_end - r.pos) return error.InvalidExtensionLength;

        switch (ext_type) {
            // supported_versions (RFC 8446 §4.2.1)
            .supported_versions => {
                if (got_supported_versions) return error.DuplicateExtension;
                if (ext_len != 2) return error.InvalidExtensionLength;
                const version = r.assumeRead(ProtocolVersion);
                // RFC 8446 §4.2.1: ServerHello supported_versions MUST select
                // TLS 1.3; any other value is a protocol violation.
                if (version != .tls_1_3) return error.IllegalParameter;
                got_supported_versions = true;
            },
            // key_share (RFC 8446 §4.2.8)
            .key_share => {
                if (got_key_share) return error.DuplicateExtension;
                const ext_end = r.pos + ext_len;
                if (ext_len < 4) return error.InvalidExtensionLength;
                const group = r.assumeRead(NamedGroup);
                const key_len = r.assumeRead(u16);
                switch (group) {
                    .x25519 => {
                        if (key_len != x25519.public_length) return error.UnsupportedKeyShareGroup;
                        if (ext_end - r.pos < x25519.public_length)
                            return error.InvalidExtensionLength;
                        const key = r.assumeReadSlice(x25519.public_length);
                        key_share = .{ .x25519 = .init(key[0..x25519.public_length].*) };
                    },
                    .secp256r1 => {
                        if (key_len != p256.public_length) return error.UnsupportedKeyShareGroup;
                        if (ext_end - r.pos < p256.public_length)
                            return error.InvalidExtensionLength;
                        const key = r.assumeReadSlice(p256.public_length);
                        if (key[0] != 0x04) return error.UnsupportedKeyShareGroup;
                        key_share = .{ .secp256r1 = .init(key[0..p256.public_length].*) };
                    },
                    .secp384r1 => {
                        if (key_len != p384.public_length) return error.UnsupportedKeyShareGroup;
                        if (ext_end - r.pos < p384.public_length)
                            return error.InvalidExtensionLength;
                        const key = r.assumeReadSlice(p384.public_length);
                        if (key[0] != 0x04) return error.UnsupportedKeyShareGroup;
                        key_share = .{ .secp384r1 = .init(key[0..p384.public_length].*) };
                    },
                    // KEM hybrid groups — variable-length key_share.
                    // draft-ietf-tls-ecdhe-mlkem-05 §4.2.
                    .x25519_mlkem768, .secp256r1_mlkem768, .secp384r1_mlkem1024 => {
                        if (key_len > max_kem_share_len) return error.UnsupportedKeyShareGroup;
                        if (ext_end - r.pos < key_len) return error.InvalidExtensionLength;
                        const key = r.assumeReadSlice(key_len);
                        var kem_data: ArrayBuffer(u8, max_kem_share_len) = .empty;
                        kem_data.appendSliceAssumeCapacity(key);
                        key_share = .{ .kem = .{
                            .group = group,
                            .data = kem_data,
                        } };
                    },
                    else => return error.UnsupportedKeyShareGroup,
                }
                if (r.pos != ext_end) return error.InvalidExtensionLength;
                got_key_share = true;
            },
            // pre_shared_key (RFC 8446 §4.2.11): server selects a PSK identity.
            // ext_data is a single u16 selected_identity. MUST be the last
            // extension.
            .pre_shared_key => {
                if (selected_identity != null) return error.DuplicateExtension;
                if (r.pos + ext_len != extensions_end) return error.IllegalParameter;
                if (ext_len != 2) return error.InvalidExtensionLength;
                selected_identity = r.assumeRead(u16);
            },
            else => {
                if (ext_type.isGrease()) return error.UnexpectedExtension;
                switch (ext_type) {
                    .server_name,
                    .status_request,
                    .supported_groups,
                    .signature_algorithms,
                    .heartbeat,
                    .alpn,
                    .status_request_v2,
                    .signed_certificate_timestamp,
                    .padding,
                    .early_data,
                    .cookie,
                    .psk_key_exchange_modes,
                    .certificate_authorities,
                    .oid_filters,
                    .post_handshake_auth,
                    .signature_algorithms_cert,
                    // RFC 8449 §4 — record_size_limit belongs in ClientHello
                    // and EncryptedExtensions, not ServerHello; treat it as a
                    // recognized wrong-message extension (illegal_parameter).
                    .record_size_limit,
                    => return error.UnexpectedExtension,
                    // RFC 8446 §4.2 — the server MUST NOT send extensions the
                    // client did not offer; abort with unsupported_extension.
                    else => return error.UnsupportedExtension,
                }
            },
        }
    }
    if (r.pos != extensions_end) return error.InvalidExtensionLength;

    if (!got_supported_versions) {
        // RFC 8446 §4.1.3: without supported_versions this is a legacy ServerHello
        // (TLS 1.2 or below) — we refuse it. Check the downgrade sentinel first:
        // a TLS 1.3-capable server downgrades by setting it, and RFC 8446 §4.1.3
        // requires clients to abort with illegal_parameter in that case, not
        // protocol_version.
        if (hasDowngradeSentinel(random)) return error.IllegalParameter;
        return error.UnsupportedTlsVersion;
    }
    // RFC 8446 §4.1.3: reject downgrade sentinel even when TLS 1.3 is
    // negotiated via supported_versions.
    if (hasDowngradeSentinel(random)) return error.IllegalParameter;
    if (!got_key_share) return error.MissingExtension;

    return .{
        .cipher_suite = cipher_suite,
        .key_share = key_share,
        .selected_identity = selected_identity,
    };
}

// RFC 8446 §4.1.3
// Test vectors from RFC 8448 §3.

const server_hello_rfc8448: []const u8 = &.{
    0x02, 0x00, 0x00, 0x56, 0x03, 0x03, 0xa6, 0xaf, 0x06, 0xa4, 0x12, 0x18, 0x60,
    0xdc, 0x5e, 0x6e, 0x60, 0x24, 0x9c, 0xd3, 0x4c, 0x95, 0x93, 0x0c, 0x8a, 0xc5,
    0xcb, 0x14, 0x34, 0xda, 0xc1, 0x55, 0x77, 0x2e, 0xd3, 0xe2, 0x69, 0x28, 0x00,
    0x13, 0x01, 0x00, 0x00, 0x2e, 0x00, 0x33, 0x00, 0x24, 0x00, 0x1d, 0x00, 0x20,
    0xc9, 0x82, 0x88, 0x76, 0x11, 0x20, 0x95, 0xfe, 0x66, 0x76, 0x2b, 0xdb, 0xf7,
    0xc6, 0x72, 0xe1, 0x56, 0xd6, 0xcc, 0x25, 0x3b, 0x83, 0x3d, 0xf1, 0xdd, 0x69,
    0xb1, 0xb0, 0x4e, 0x75, 0x1f, 0x0f, 0x00, 0x2b, 0x00, 0x02, 0x03, 0x04,
};

test "encode: round trips through parse" {
    const key: x25519.PublicKey = .init(.{
        0xc9, 0x82, 0x88, 0x76, 0x11, 0x20, 0x95, 0xfe,
        0x66, 0x76, 0x2b, 0xdb, 0xf7, 0xc6, 0x72, 0xe1,
        0x56, 0xd6, 0xcc, 0x25, 0x3b, 0x83, 0x3d, 0xf1,
        0xdd, 0x69, 0xb1, 0xb0, 0x4e, 0x75, 0x1f, 0x0f,
    });
    var out: [128]u8 = undefined;
    const msg = try encode(&out, @splat(0xab), &.{}, .aes_128_gcm_sha256, key);
    try testing.expectEqual(@as(usize, encoded_len), msg.len);
    const parsed = try parse(msg);
    try testing.expectEqual(.aes_128_gcm_sha256, parsed.cipher_suite);
    try testing.expectEqualSlices(u8, &key.data, &parsed.key_share.x25519.data);
}

// RFC 8446 §4.2.8.2 — P-256 key shares use uncompressed SEC1 points.
test "parse: accepts secp256r1 key_share" {
    var key: p256.PublicKey = .init(@splat(0x11));
    key.data[0] = 0x04;
    var out: [192]u8 = undefined;
    const msg = try encodeWithKeyShare(
        &out,
        @splat(0xab),
        &.{},
        .aes_128_gcm_sha256,
        .{ .secp256r1 = key },
    );
    const parsed = try parse(msg);
    try testing.expectEqual(.secp256r1, parsed.key_share.group());
    try testing.expectEqualSlices(u8, &key.data, &parsed.key_share.secp256r1.data);
}

// RFC 8446 §4.2.8.2 — compressed P-256 points are not valid TLS key shares.
test "parse: rejects compressed secp256r1 key_share" {
    var key: p256.PublicKey = .init(@splat(0x11));
    key.data[0] = 0x02;
    var out: [192]u8 = undefined;
    const msg = try encodeWithKeyShare(
        &out,
        @splat(0xab),
        &.{},
        .aes_128_gcm_sha256,
        .{ .secp256r1 = key },
    );
    try testing.expectError(error.UnsupportedKeyShareGroup, parse(msg));
}

// RFC 8446 §4.2.8.2 — P-384 key shares use uncompressed SEC1 points (97 bytes).
test "parse: accepts secp384r1 key_share" {
    var key: p384.PublicKey = .init(@splat(0x11));
    key.data[0] = 0x04;
    var out: [256]u8 = undefined;
    const msg = try encodeWithKeyShare(
        &out,
        @splat(0xab),
        &.{},
        .aes_128_gcm_sha256,
        .{ .secp384r1 = key },
    );
    const parsed = try parse(msg);
    try testing.expectEqual(.secp384r1, parsed.key_share.group());
    try testing.expectEqualSlices(u8, &key.data, &parsed.key_share.secp384r1.data);
}

// RFC 8446 §4.2.8.2 — compressed P-384 points are not valid TLS key shares.
test "parse: rejects compressed secp384r1 key_share" {
    var key: p384.PublicKey = .init(@splat(0x11));
    key.data[0] = 0x02;
    var out: [256]u8 = undefined;
    const msg = try encodeWithKeyShare(
        &out,
        @splat(0xab),
        &.{},
        .aes_128_gcm_sha256,
        .{ .secp384r1 = key },
    );
    try testing.expectError(error.UnsupportedKeyShareGroup, parse(msg));
}

test "encode: echoes session id" {
    var out: [128]u8 = undefined;
    const sid = [_]u8{ 1, 2, 3, 4 };
    const msg = try encode(&out, @splat(0xab), &sid, .aes_256_gcm_sha384, .zero);
    try testing.expectEqual(@as(u8, sid.len), msg[38]);
    try testing.expectEqualSlices(u8, &sid, msg[39..][0..sid.len]);
    const parsed = try parse(msg);
    try testing.expectEqual(.aes_256_gcm_sha384, parsed.cipher_suite);
}

test "parse: RFC 8448 §3 ServerHello" {
    const sh = try parse(server_hello_rfc8448);
    try testing.expectEqual(.aes_128_gcm_sha256, sh.cipher_suite);
    try testing.expectEqualSlices(u8, &.{
        0xc9, 0x82, 0x88, 0x76, 0x11, 0x20, 0x95, 0xfe,
        0x66, 0x76, 0x2b, 0xdb, 0xf7, 0xc6, 0x72, 0xe1,
        0x56, 0xd6, 0xcc, 0x25, 0x3b, 0x83, 0x3d, 0xf1,
        0xdd, 0x69, 0xb1, 0xb0, 0x4e, 0x75, 0x1f, 0x0f,
    }, &sh.key_share.x25519.data);
}

test "parse: wrong handshake type" {
    var msg = server_hello_rfc8448[0..server_hello_rfc8448.len].*;
    msg[0] = 0x01; // client_hello
    try testing.expectError(error.InvalidHandshakeType, parse(&msg));
}

test "parse: truncated message" {
    try testing.expectError(error.InvalidHandshakeLength, parse(server_hello_rfc8448[0..43]));
}

test "parse: rejects HelloRetryRequest" {
    var msg = server_hello_rfc8448[0..server_hello_rfc8448.len].*;
    @memcpy(msg[6..][0..32], &hello_retry_request_random);
    try testing.expectError(error.HelloRetryRequest, parse(&msg));
}

// RFC 8446 §4.2.1 — without supported_versions the ServerHello is a legacy
// TLS 1.2 (or below) message; ztls only speaks TLS 1.3.
test "parse: missing extensions / no supported_versions yields UnsupportedTlsVersion" {
    // Minimal ServerHello with empty extensions block — no supported_versions.
    const msg = [_]u8{
        0x02, 0x00, 0x00, 0x28, // type + body length = 40
        0x03, 0x03, // legacy_version
    } ++ @as([32]u8, @splat(0)) ++ // random
        [_]u8{
            0x00, // session_id: empty
            0x13, 0x01, // cipher_suite
            0x00, // compression
            0x00, 0x00, // extensions: empty
        };
    try testing.expectError(error.UnsupportedTlsVersion, parse(&msg));
}

test "parse: rejects mismatched handshake length" {
    var msg = server_hello_rfc8448[0..server_hello_rfc8448.len].*;
    msg[3] -= 1;
    try testing.expectError(error.InvalidHandshakeLength, parse(&msg));
}

// RFC 8446 Appendix B.4 — unknown cipher-suite code points are rejected, not
// treated as enum-unreachable input.
test "parse: rejects unknown cipher suite" {
    var msg = server_hello_rfc8448[0..server_hello_rfc8448.len].*;
    msg[39] = 0x13;
    msg[40] = 0x04;
    try testing.expectError(error.InvalidEnumTag, parse(&msg));
}

test "parse: rejects oversized extensions block" {
    var msg = server_hello_rfc8448[0..server_hello_rfc8448.len].*;
    msg[42] = 0xff;
    msg[43] = 0xff;
    try testing.expectError(error.InvalidExtensionLength, parse(&msg));
}

test "parse: rejects duplicate supported_versions" {
    const msg = server_hello_rfc8448 ++ [_]u8{ 0x00, 0x2b, 0x00, 0x02, 0x03, 0x04 };
    var dup = msg[0..msg.len].*;
    dup[3] += 6;
    dup[43] += 6;
    try testing.expectError(error.DuplicateExtension, parse(&dup));
}

test "parse: rejects duplicate key_share" {
    const key_share = server_hello_rfc8448[44..84];
    const msg = server_hello_rfc8448 ++ key_share.*;
    var dup = msg[0..msg.len].*;
    dup[3] += key_share.len;
    dup[43] += key_share.len;
    try testing.expectError(error.DuplicateExtension, parse(&dup));
}

// RFC 8446 §4.2 — the server MUST NOT respond with an extension the client did
// not offer; an unknown extension type in ServerHello must be rejected.
test "parse: rejects unknown unsolicited extension" {
    // Extension type 0x5a5b is not a GREASE value and not a recognized
    // ServerHello extension; it should be rejected with UnsupportedExtension.
    const unknown = [_]u8{ 0x5a, 0x5b, 0x00, 0x01, 0x00 };
    const msg = server_hello_rfc8448 ++ unknown;
    var with_unknown = msg[0..msg.len].*;
    with_unknown[3] += unknown.len;
    with_unknown[43] += unknown.len;
    try testing.expectError(error.UnsupportedExtension, parse(&with_unknown));
}

// RFC 8701 §3.1 — clients reject GREASE values negotiated by a server.
test "parse: rejects GREASE ServerHello extension" {
    const grease = [_]u8{ 0x0a, 0x0a, 0x00, 0x00 };
    const msg = server_hello_rfc8448 ++ grease;
    var with_grease = msg[0..msg.len].*;
    with_grease[3] += grease.len;
    with_grease[43] += grease.len;
    try testing.expectError(error.UnexpectedExtension, parse(&with_grease));
}

// RFC 8446 §4.2 — recognized extensions in the wrong message are illegal.
test "parse: rejects forbidden signature_algorithms extension" {
    const sig_algs = [_]u8{ 0x00, 0x0d, 0x00, 0x02, 0x00, 0x00 };
    const msg = server_hello_rfc8448 ++ sig_algs;
    var forbidden = msg[0..msg.len].*;
    forbidden[3] += sig_algs.len;
    forbidden[43] += sig_algs.len;
    try testing.expectError(error.UnexpectedExtension, parse(&forbidden));
}

// RFC 8446 §4.2 — recognized extensions in the wrong message are illegal.
test "parse: rejects forbidden heartbeat extension" {
    const heartbeat = [_]u8{ 0x00, 0x0f, 0x00, 0x00 };
    const msg = server_hello_rfc8448 ++ heartbeat;
    var forbidden = msg[0..msg.len].*;
    forbidden[3] += heartbeat.len;
    forbidden[43] += heartbeat.len;
    try testing.expectError(error.UnexpectedExtension, parse(&forbidden));
}

// RFC 8449 §4 — record_size_limit belongs in ClientHello and EncryptedExtensions,
// not ServerHello; treat it as a recognized wrong-message extension requiring
// illegal_parameter (UnexpectedExtension here).
test "parse: rejects record_size_limit in ServerHello" {
    const rsl = [_]u8{ 0x00, 0x1c, 0x00, 0x02, 0x04, 0x00 };
    const msg = server_hello_rfc8448 ++ rsl;
    var with_rsl = msg[0..msg.len].*;
    with_rsl[3] += rsl.len;
    with_rsl[43] += rsl.len;
    try testing.expectError(error.UnexpectedExtension, parse(&with_rsl));
}

// RFC 8446 §4.2.8 — ServerHello carries exactly the selected group. ztls's
// current supported surface accepts only X25519.
test "parse: rejects key_share for unsupported group" {
    var msg = server_hello_rfc8448[0..server_hello_rfc8448.len].*;
    msg[48] = 0x00;
    msg[49] = 0x17;
    try testing.expectError(error.UnsupportedKeyShareGroup, parse(&msg));
}

// RFC 8446 §4.2.1 — supported_versions must select TLS 1.3; any other value is
// a protocol violation requiring illegal_parameter.
test "parse: unsupported TLS version in supported_versions is illegal_parameter" {
    var msg = server_hello_rfc8448[0..server_hello_rfc8448.len].*;
    msg[msg.len - 2] = 0x03;
    msg[msg.len - 1] = 0x03; // supported_versions = TLS 1.2 (0x0303)
    try testing.expectError(error.IllegalParameter, parse(&msg));
}

// RFC 8446 §4.1.3 — TLS 1.3 clients abort if a TLS 1.2-or-below ServerHello
// carries the downgrade sentinel in Random.
test "parse: rejects TLS 1.2 downgrade sentinel" {
    var msg = server_hello_rfc8448[0..server_hello_rfc8448.len].*;
    msg[msg.len - 2] = 0x03;
    msg[msg.len - 1] = 0x03;
    msg[30..38].* = downgrade_tls12;
    try testing.expectError(error.IllegalParameter, parse(&msg));
}

// RFC 8446 §4.1.3 — the alternate sentinel covers TLS 1.1 and below.
test "parse: rejects TLS 1.1 downgrade sentinel" {
    var msg = server_hello_rfc8448[0..server_hello_rfc8448.len].*;
    msg[msg.len - 2] = 0x03;
    msg[msg.len - 1] = 0x02;
    msg[30..38].* = downgrade_tls11_or_below;
    try testing.expectError(error.IllegalParameter, parse(&msg));
}

// RFC 8446 §4.1.3 — TLS 1.3 clients must reject the downgrade sentinel even
// when supported_versions selects TLS 1.3, guarding against a MITM stripping
// the supported_versions extension on the wire.
test "parse: rejects downgrade sentinel when supported_versions selects TLS 1.3" {
    var msg = server_hello_rfc8448[0..server_hello_rfc8448.len].*;
    // supported_versions remains TLS 1.3 (0x0304); inject tls12 downgrade sentinel.
    msg[30..38].* = downgrade_tls12;
    try testing.expectError(error.IllegalParameter, parse(&msg));
}

// RFC 8446 §4.2.1 — when supported_versions selects TLS 1.3, clients MUST
// ignore legacy_version; any value above SSLv3 (0x0300) is acceptable.
test "parse: accepts non-0x0303 legacy_version when supported_versions selects TLS 1.3" {
    var msg = server_hello_rfc8448[0..server_hello_rfc8448.len].*;
    msg[4] = 0x03;
    msg[5] = 0x01; // legacy_version = TLS 1.0 (0x0301)
    const sh = try parse(&msg);
    try testing.expectEqual(.aes_128_gcm_sha256, sh.cipher_suite);
}

// RFC 8446 §4.1.3 — when supported_versions is absent and the Random carries
// a downgrade sentinel, abort with illegal_parameter (not protocol_version),
// because a TLS 1.3-capable server signalled the downgrade.
test "parse: no supported_versions + downgrade sentinel yields IllegalParameter" {
    var msg: [84]u8 = undefined;
    @memcpy(&msg, server_hello_rfc8448[0..84]);
    msg[3] = 0x50; // body_len: 86 → 80 (strip 6-byte supported_versions)
    msg[42] = 0x00;
    msg[43] = 0x28; // extensions_len: 46 → 40
    msg[30..38].* = downgrade_tls12; // inject TLS 1.2 downgrade sentinel into Random tail
    try testing.expectError(error.IllegalParameter, parse(&msg));
}

// RFC 8446 §4.2.1 — a ServerHello that omits supported_versions is a legacy
// TLS 1.2 (or below) message; clients that speak only TLS 1.3 must abort with
// protocol_version (UnsupportedTlsVersion here).
test "parse: rejects ServerHello without supported_versions as legacy" {
    // Strip the supported_versions extension from server_hello_rfc8448 by
    // copying only the first 84 bytes (omits the last 6 = supported_versions)
    // and adjusting body_len and extensions_len accordingly.
    var msg: [84]u8 = undefined;
    @memcpy(&msg, server_hello_rfc8448[0..84]);
    msg[3] = 0x50; // body_len: 86 → 80 (6 bytes trimmed)
    msg[42] = 0x00;
    msg[43] = 0x28; // extensions_len: 46 → 40 (6 bytes trimmed)
    try testing.expectError(error.UnsupportedTlsVersion, parse(&msg));
}

// RFC 8446 Appendix D.5 — Hello legacy_version values at or below SSLv3 abort
// with protocol_version, represented here as UnsupportedTlsVersion.
test "parse: rejects SSLv3-or-lower legacy version" {
    var msg = server_hello_rfc8448[0..server_hello_rfc8448.len].*;
    msg[4] = 0x03;
    msg[5] = 0x00;
    try testing.expectError(error.UnsupportedTlsVersion, parse(&msg));

    msg[4] = 0x02;
    msg[5] = 0x00;
    try testing.expectError(error.UnsupportedTlsVersion, parse(&msg));
}

// RFC 8446 §4.1.3 — legacy_session_id_echo must match the ClientHello value.
test "parse: rejects mismatched session id echo" {
    var out: [128]u8 = undefined;
    const msg = try encode(&out, @splat(0xab), &.{ 1, 2 }, .aes_128_gcm_sha256, .zero);
    try testing.expectError(error.InvalidSessionIdEcho, parseWithSessionIdEcho(msg, &.{ 1, 3 }));
}

// RFC 8446 §4.1.3 — TLS 1.3 ServerHello legacy_compression_method is zero.
test "parse: rejects non-zero compression method" {
    var msg = server_hello_rfc8448[0..server_hello_rfc8448.len].*;
    msg[41] = 0x01;
    try testing.expectError(error.InvalidCompressionMethod, parse(&msg));
}

// Fuzz target: parse must reject arbitrary bytes with an error, never crash
// (no panic/overflow/OOB). Run with `zig build test --fuzz`.
fn fuzzParse(_: void, input: []const u8) anyerror!void {
    _ = parse(input) catch return;
}

test "fuzz: parse handles arbitrary input" {
    try fuzz_compat.fuzzBytes(fuzzParse, {}, .{ .corpus = &.{server_hello_rfc8448} });
}

// ----------------------------------------------------------------------------
// parseHelloRetryRequest tests
// ----------------------------------------------------------------------------

// RFC 8448 §5 — HelloRetryRequest (176 octets).
// The server requests P-256 (secp256r1, group 0x0017) and includes a cookie.
const hrr_rfc8448: []const u8 = &.{
    0x02, 0x00, 0x00, 0xac, 0x03, 0x03, 0xcf, 0x21, 0xad, 0x74, 0xe5, 0x9a, 0x61,
    0x11, 0xbe, 0x1d, 0x8c, 0x02, 0x1e, 0x65, 0xb8, 0x91, 0xc2, 0xa2, 0x11, 0x16,
    0x7a, 0xbb, 0x8c, 0x5e, 0x07, 0x9e, 0x09, 0xe2, 0xc8, 0xa8, 0x33, 0x9c, 0x00,
    0x13, 0x01, 0x00, 0x00, 0x84, 0x00, 0x33, 0x00, 0x02, 0x00, 0x17, 0x00, 0x2c,
    0x00, 0x74, 0x00, 0x72, 0x71, 0xdc, 0xd0, 0x4b, 0xb8, 0x8b, 0xc3, 0x18, 0x91,
    0x19, 0x39, 0x8a, 0x00, 0x00, 0x00, 0x00, 0xee, 0xfa, 0xfc, 0x76, 0xc1, 0x46,
    0xb8, 0x23, 0xb0, 0x96, 0xf8, 0xaa, 0xca, 0xd3, 0x65, 0xdd, 0x00, 0x30, 0x95,
    0x3f, 0x4e, 0xdf, 0x62, 0x56, 0x36, 0xe5, 0xf2, 0x1b, 0xb2, 0xe2, 0x3f, 0xcc,
    0x65, 0x4b, 0x1b, 0x5b, 0x40, 0x31, 0x8d, 0x10, 0xd1, 0x37, 0xab, 0xcb, 0xb8,
    0x75, 0x74, 0xe3, 0x6e, 0x8a, 0x1f, 0x02, 0x5f, 0x7d, 0xfa, 0x5d, 0x6e, 0x50,
    0x78, 0x1b, 0x5e, 0xda, 0x4a, 0xa1, 0x5b, 0x0c, 0x8b, 0xe7, 0x78, 0x25, 0x7d,
    0x16, 0xaa, 0x30, 0x30, 0xe9, 0xe7, 0x84, 0x1d, 0xd9, 0xe4, 0xc0, 0x34, 0x22,
    0x67, 0xe8, 0xca, 0x0c, 0xaf, 0x57, 0x1f, 0xb2, 0xb7, 0xcf, 0xf0, 0xf9, 0x34,
    0xb0, 0x00, 0x2b, 0x00, 0x02, 0x03, 0x04,
};

// RFC 8446 §4.1.4 — encoded HRR is a ServerHello-shaped retry request with
// key_share carrying the selected group.
test "encodeHelloRetryRequest: parse round-trip" {
    var out: [128]u8 = undefined;
    const session_id: [3]u8 = .{ 0xaa, 0xbb, 0xcc };
    const msg = try encodeHelloRetryRequest(
        &out,
        &session_id,
        .aes_128_gcm_sha256,
        .x25519,
    );
    const hrr = try parseHelloRetryRequest(msg);
    try testing.expectEqual(.aes_128_gcm_sha256, hrr.cipher_suite);
    try testing.expectEqual(NamedGroup.x25519, hrr.selected_group.?);
    try testing.expectEqual(@as(?[]const u8, null), hrr.cookie);
}

// RFC 8446 §4.1.4 — HRR legacy_session_id_echo must match ClientHello.
test "parseHelloRetryRequest: rejects mismatched session id echo" {
    var out: [128]u8 = undefined;
    const msg = try encodeHelloRetryRequest(
        &out,
        &.{ 0xaa, 0xbb },
        .aes_128_gcm_sha256,
        .x25519,
    );
    try testing.expectError(
        error.InvalidSessionIdEcho,
        parseHelloRetryRequestWithSessionIdEcho(msg, &.{ 0xaa, 0xcc }),
    );
}

// RFC 8446 §4.1.4, RFC 8448 §5 — basic HRR parse.
test "parseHelloRetryRequest: RFC 8448 §5" {
    const hrr = try parseHelloRetryRequest(hrr_rfc8448);
    try testing.expectEqual(.aes_128_gcm_sha256, hrr.cipher_suite);
    try testing.expectEqual(NamedGroup.secp256r1, hrr.selected_group.?);
    // cookie is present and non-empty
    try testing.expect(hrr.cookie != null);
    try testing.expect(hrr.cookie.?.len > 0);
    // cookie inner length (first 2 bytes) should equal remaining bytes
    const cookie = hrr.cookie.?;
    try testing.expectEqual(@as(usize, 0x72), cookie.len);
}

// RFC 8446 §4.1.4 — HRR without cookie (key_share only).
test "parseHelloRetryRequest: no cookie" {
    // Minimal HRR: key_share (selected_group=x25519) + supported_versions.
    const msg: []const u8 = &([_]u8{ 0x02, 0x00, 0x00, 0x34 } // type + body len = 52
        ++ [_]u8{ 0x03, 0x03 } // legacy_version
        ++ hello_retry_request_random // Random
        ++ [_]u8{0x00} // session_id: empty
        ++ [_]u8{ 0x13, 0x01 } // cipher_suite
        ++ [_]u8{0x00} // compression
        ++ [_]u8{ 0x00, 0x0c } // extensions_len = 12
        ++ [_]u8{ 0x00, 0x33, 0x00, 0x02, 0x00, 0x1d } // key_share: x25519
        ++ [_]u8{ 0x00, 0x2b, 0x00, 0x02, 0x03, 0x04 } // supported_versions
    );
    const hrr = try parseHelloRetryRequest(msg);
    try testing.expectEqual(.aes_128_gcm_sha256, hrr.cipher_suite);
    try testing.expectEqual(NamedGroup.x25519, hrr.selected_group.?);
    try testing.expectEqual(@as(?[]const u8, null), hrr.cookie);
}

// RFC 8446 §4.1.4 — rejects message with wrong Random (not an HRR).
test "parseHelloRetryRequest: rejects non-HRR Random" {
    var msg = hrr_rfc8448[0..hrr_rfc8448.len].*;
    // overwrite Random with all-zeros
    @memset(msg[6..][0..32], 0x00);
    try testing.expectError(error.NotHelloRetryRequest, parseHelloRetryRequest(&msg));
}

// RFC 8446 §4.1.4 — rejects wrong handshake type.
test "parseHelloRetryRequest: rejects wrong type" {
    var msg = hrr_rfc8448[0..hrr_rfc8448.len].*;
    msg[0] = 0x01;
    try testing.expectError(error.InvalidHandshakeType, parseHelloRetryRequest(&msg));
}

// RFC 8446 §4.2.1 — supported_versions in HRR must select TLS 1.3; any other
// value is a semantic protocol violation requiring illegal_parameter.
test "parseHelloRetryRequest: rejects TLS 1.2 in supported_versions" {
    var msg = hrr_rfc8448[0..hrr_rfc8448.len].*;
    // Last 2 bytes are the version in supported_versions
    msg[msg.len - 2] = 0x03;
    msg[msg.len - 1] = 0x03; // supported_versions = TLS 1.2 (0x0303)
    try testing.expectError(error.IllegalParameter, parseHelloRetryRequest(&msg));
}

// RFC 8446 §4.2.1 — when supported_versions selects TLS 1.3, clients MUST
// ignore legacy_version; any value above SSLv3 (0x0300) is acceptable in HRR.
test "parseHelloRetryRequest: ignores non-0x0303 legacy_version" {
    var msg = hrr_rfc8448[0..hrr_rfc8448.len].*;
    msg[4] = 0x03;
    msg[5] = 0x01; // legacy_version = TLS 1.0 (0x0301)
    const hrr = try parseHelloRetryRequest(&msg);
    try testing.expectEqual(.aes_128_gcm_sha256, hrr.cipher_suite);
}

// RFC 8446 Appendix D.5 — HRR is encoded as ServerHello, so the same
// legacy_version protocol_version abort applies.
test "parseHelloRetryRequest: rejects SSLv3-or-lower legacy version" {
    var msg = hrr_rfc8448[0..hrr_rfc8448.len].*;
    msg[4] = 0x03;
    msg[5] = 0x00;
    try testing.expectError(error.UnsupportedTlsVersion, parseHelloRetryRequest(&msg));

    msg[4] = 0x02;
    msg[5] = 0x00;
    try testing.expectError(error.UnsupportedTlsVersion, parseHelloRetryRequest(&msg));
}

// RFC 8446 §4.1.4 — HRR uses the ServerHello legacy_compression_method field.
test "parseHelloRetryRequest: rejects non-zero compression method" {
    var msg = hrr_rfc8448[0..hrr_rfc8448.len].*;
    msg[41] = 0x01;
    try testing.expectError(error.InvalidCompressionMethod, parseHelloRetryRequest(&msg));
}

// RFC 8446 Appendix B.4 — unknown HRR cipher-suite code points are rejected.
test "parseHelloRetryRequest: rejects unknown cipher suite" {
    var msg = hrr_rfc8448[0..hrr_rfc8448.len].*;
    msg[39] = 0x13;
    msg[40] = 0x04;
    try testing.expectError(error.InvalidEnumTag, parseHelloRetryRequest(&msg));
}

// RFC 8446 §4.1.4 — extensions vector must consume the whole HRR body.
test "parseHelloRetryRequest: rejects trailing bytes after extensions" {
    var msg: [hrr_rfc8448.len + 1]u8 = undefined;
    @memcpy(msg[0..hrr_rfc8448.len], hrr_rfc8448);
    msg[hrr_rfc8448.len] = 0;
    msg[3] += 1;
    try testing.expectError(error.InvalidExtensionLength, parseHelloRetryRequest(&msg));
}

// RFC 8446 §4.2.2 — cookie extension_data is exactly opaque cookie<1..2^16-1>.
test "parseHelloRetryRequest: rejects cookie extension trailing bytes" {
    var msg = hrr_rfc8448[0..hrr_rfc8448.len].*;
    // RFC 8448 HRR cookie extension_data length is 0x74, cookie vector length
    // is 0x72. Shrink the vector by one while leaving extension length intact.
    msg[54] = 0x71;
    try testing.expectError(error.InvalidExtensionLength, parseHelloRetryRequest(&msg));
}

// RFC 8446 §4.1.4 — rejects HRR with no supported_versions.
test "parseHelloRetryRequest: rejects missing supported_versions" {
    // key_share only, no supported_versions.
    const msg: []const u8 = &([_]u8{ 0x02, 0x00, 0x00, 0x2e } // type + body len = 46
        ++ [_]u8{ 0x03, 0x03 } // legacy_version
        ++ hello_retry_request_random // Random
        ++ [_]u8{0x00} // session_id: empty
        ++ [_]u8{ 0x13, 0x01 } // cipher_suite
        ++ [_]u8{0x00} // compression
        ++ [_]u8{ 0x00, 0x06 } // extensions_len = 6
        ++ [_]u8{ 0x00, 0x33, 0x00, 0x02, 0x00, 0x1d } // key_share only
    );
    try testing.expectError(error.MissingExtension, parseHelloRetryRequest(msg));
}

// RFC 8446 §4.2 — the server MUST NOT respond with an extension the client did
// not offer; an unknown extension type in HRR must be rejected.
test "parseHelloRetryRequest: rejects unknown unsolicited extension" {
    // Extension type 0x5a5b is not a GREASE value and not a recognized
    // HRR extension; it should be rejected with UnsupportedExtension.
    const unknown = [_]u8{ 0x5a, 0x5b, 0x00, 0x01, 0x00 };
    const msg = hrr_rfc8448 ++ unknown;
    var with_unknown = msg[0..msg.len].*;
    with_unknown[3] += unknown.len;
    with_unknown[43] += unknown.len;
    try testing.expectError(error.UnsupportedExtension, parseHelloRetryRequest(&with_unknown));
}

// RFC 8449 §4 — record_size_limit belongs in ClientHello and
// EncryptedExtensions, not HRR; treat it as a recognized wrong-message
// extension requiring illegal_parameter (UnexpectedExtension here).
test "parseHelloRetryRequest: rejects record_size_limit" {
    const rsl = [_]u8{ 0x00, 0x1c, 0x00, 0x02, 0x04, 0x00 };
    const msg = hrr_rfc8448 ++ rsl;
    var with_rsl = msg[0..msg.len].*;
    with_rsl[3] += rsl.len;
    with_rsl[43] += rsl.len;
    try testing.expectError(error.UnexpectedExtension, parseHelloRetryRequest(&with_rsl));
}

// draft-ietf-tls-ecdhe-mlkem-05 §4.2 — KEM ciphertext (1120 bytes for
// X25519MLKEM768) round-trips through encode → parse without corruption.
// This test is pure-Zig (no OpenSSL) and isolates the wire path from the
// backend. It runs on all architectures to catch any struct-return / ArrayBuffer
// issues with large KEM key shares. See issue #65.
test "KEM key_share round-trip: ServerHello encode → parse preserves 1120-byte ciphertext" {
    // Fill with a recognizable pattern so any byte corruption is visible.
    var original: [1120]u8 = undefined;
    for (&original, 0..) |*b, i| b.* = @intCast(i % 256);

    var kem_data: ArrayBuffer(u8, max_kem_share_len) = .empty;
    kem_data.appendSliceAssumeCapacity(&original);
    const ks: KeyShare = .{ .kem = .{ .group = .x25519_mlkem768, .data = kem_data } };

    var out: [2048]u8 = undefined;
    const msg = try encodeWithKeyShare(
        &out,
        @splat(0xab),
        &.{},
        .aes_128_gcm_sha256,
        ks,
    );
    const sh = try parse(msg);
    try testing.expectEqual(.x25519_mlkem768, sh.key_share.group());
    const parsed_data = sh.key_share.kem.data.constSlice();
    try testing.expectEqual(@as(usize, 1120), parsed_data.len);
    try testing.expectEqualSlices(u8, &original, parsed_data);
}

fn fuzzParseHrr(_: void, input: []const u8) anyerror!void {
    _ = parseHelloRetryRequest(input) catch return;
}

test "fuzz: parseHelloRetryRequest handles arbitrary input" {
    try fuzz_compat.fuzzBytes(fuzzParseHrr, {}, .{ .corpus = &.{hrr_rfc8448} });
}
