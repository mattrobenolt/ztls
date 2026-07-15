//! TLS 1.3 EncryptedExtensions handshake message parsing.
//!
//! RFC 8446 §4.3.1
const std = @import("std");
const mem = std.mem;
const testing = std.testing;

const extension_type = @import("extension_type.zig");
const ExtensionType = extension_type.ExtensionType;
const OfferedExtensions = extension_type.OfferedExtensions;
const handshake = @import("handshake.zig");
const wire = @import("wire.zig");

/// Caller-offered extensions used by `parse` to validate EncryptedExtensions
/// responses. Defaults to empty (no tracked extensions offered).
pub const Options = struct {
    offered_extensions: OfferedExtensions = .initEmpty(),
};

pub const ParseError = error{
    UnexpectedEof,
    InvalidHandshakeType,
    InvalidHandshakeLength,
    InvalidExtensionLength,
    UnexpectedExtension,
    UnsupportedExtension,
    DuplicateExtension,
    EmptyAlpnProtocol,
    TooManyAlpnProtocols,
    UnofferedAlpnProtocol,
};

pub const Parsed = struct {
    alpn_protocol: ?[]const u8 = null,
    /// RFC 8446 §4.2.10 — true when the server included early_data in EE,
    /// signaling 0-RTT acceptance. The client uses this to decide whether
    /// to send EndOfEarlyData (§4.5).
    early_data_accepted: bool = false,
};

pub const EncodeError = error{ BufferTooShort, EmptyAlpnProtocol, AlpnProtocolTooLong };

/// RFC 8446 §4.3.1, §4.2.10 — `early_data_accepted` emits the empty
/// early_data extension when the server accepted 0-RTT.
pub fn encodedLen(alpn_protocol: ?[]const u8, early_data_accepted: bool) usize {
    const alpn_len: usize = if (alpn_protocol) |p| 4 + 2 + 1 + p.len else 0;
    const early_len: usize = if (early_data_accepted) 4 else 0;
    return 4 + 2 + alpn_len + early_len;
}

/// Encode EncryptedExtensions. Currently only ALPN and early_data are
/// supported as server output. RFC 8446 §4.3.1, §4.2.10, RFC 7301 §3.2.
pub fn encode(
    out: []u8,
    alpn_protocol: ?[]const u8,
    early_data_accepted: bool,
) EncodeError![]const u8 {
    if (alpn_protocol) |p| {
        if (p.len == 0) return error.EmptyAlpnProtocol;
        if (p.len > 255) return error.AlpnProtocolTooLong;
    }
    const len = encodedLen(alpn_protocol, early_data_accepted);
    if (out.len < len) return error.BufferTooShort;

    var w: wire.Writer = .init(out);
    w.append(handshake.Type, .encrypted_extensions);
    w.append(u24, @intCast(len - 4));
    w.append(u16, @intCast(len - 6));
    if (alpn_protocol) |p| {
        w.append(ExtensionType, .alpn);
        w.append(u16, @intCast(2 + 1 + p.len));
        w.append(u16, @intCast(1 + p.len));
        w.append(u8, @intCast(p.len));
        w.appendSlice(p);
    }
    // RFC 8446 §4.2.10 — empty early_data extension signals 0-RTT acceptance.
    if (early_data_accepted) {
        w.append(ExtensionType, .early_data);
        w.append(u16, 0);
    }
    return w.written();
}

/// Parse an EncryptedExtensions handshake message.
///
/// `offered_alpn` is the slice of ALPN protocols the client advertised; pass
/// `&.{}` if ALPN was not offered. `opts` carries the offered-extension set;
/// see `Options`.
///
/// All recognised extensions that do not belong in EncryptedExtensions map to
/// `UnexpectedExtension`.  Unknown extension types and recognised-but-unoffered
/// extensions (ALPN without offered protocols, server_name without an offered
/// SNI extension, record_size_limit without an offered record_size_limit) map to
/// `UnsupportedExtension`.  GREASE values map to `UnexpectedExtension` per
/// RFC 8701 §3.1.
///
/// RFC 8446 §4.3.1, RFC 7301 §3.2, RFC 6066 §3, RFC 8449 §4, RFC 8701 §3.1.
pub fn parse(msg: []const u8, offered_alpn: []const []const u8, opts: Options) ParseError!Parsed {
    if (msg.len < 6) return error.UnexpectedEof;

    var r: wire.Reader = .init(msg);
    const handshake_type = r.assumeRead(handshake.Type);
    if (handshake_type != .encrypted_extensions) return error.InvalidHandshakeType;
    const body_len = r.assumeRead(u24);
    if (body_len != msg.len - 4) return error.InvalidHandshakeLength;

    if (body_len < 2) return error.InvalidHandshakeLength;
    const extensions_len = r.assumeRead(u16);
    if (extensions_len != body_len - 2) return error.InvalidExtensionLength;
    const extensions_end = r.pos + extensions_len;
    try extension_type.rejectDuplicateExtensions(msg[r.pos..extensions_end]);

    var result: Parsed = .{};
    while (r.pos < extensions_end) {
        if (extensions_end - r.pos < 4) return error.InvalidExtensionLength;
        const ext_type = r.assumeRead(ExtensionType);
        const ext_len = r.assumeRead(u16);
        if (r.pos + ext_len > extensions_end) return error.InvalidExtensionLength;
        const ext = r.assumeReadSlice(ext_len);

        if (ext_type.isGrease()) return error.UnexpectedExtension;
        switch (ext_type) {
            .alpn => {
                if (result.alpn_protocol != null) return error.DuplicateExtension;
                result.alpn_protocol = try parseAlpn(ext, offered_alpn);
            },
            // RFC 6066 §3 — server_name is permitted in EncryptedExtensions
            // only when the client offered SNI; the acknowledgment MUST carry
            // empty extension_data (zero-length server_name_list).
            .server_name => {
                if (!opts.offered_extensions.contains(.server_name))
                    return error.UnsupportedExtension;
                // RFC 6066 §3: "extension_data" of the server acknowledgment
                // SHALL be empty (ext.len == 0 means zero-byte extension_data).
                if (ext.len != 0) return error.InvalidExtensionLength;
            },
            // RFC 8446 §4.2.7 — supported_groups is explicitly permitted in
            // EncryptedExtensions; the client MUST NOT act on it until after
            // the handshake completes (it is advisory for future sessions).
            .supported_groups => {},
            // RFC 8449 §4 — record_size_limit is permitted in EncryptedExtensions
            // only when the client offered it; reject otherwise per RFC 8446 §4.2.
            .record_size_limit => {
                if (!opts.offered_extensions.contains(.record_size_limit))
                    return error.UnsupportedExtension;
                if (ext.len != 2) return error.InvalidExtensionLength;
            },
            // RFC 8446 §4.2.10 — early_data in EncryptedExtensions signals the
            // server accepts 0-RTT. Empty ext_data. Only valid when the client
            // offered early_data.
            .early_data => {
                if (!opts.offered_extensions.contains(.early_data))
                    return error.UnsupportedExtension;
                if (ext.len != 0) return error.InvalidExtensionLength;
                result.early_data_accepted = true;
            },
            // RFC 8446 §4.2 — recognized extensions sent in a message where
            // they are not specified are semantic errors, not ignorable grease.
            .status_request,
            .signature_algorithms,
            .heartbeat,
            .padding,
            .pre_shared_key,
            .status_request_v2,
            .signed_certificate_timestamp,
            .supported_versions,
            .cookie,
            .psk_key_exchange_modes,
            .certificate_authorities,
            .oid_filters,
            .post_handshake_auth,
            .signature_algorithms_cert,
            .key_share,
            => return error.UnexpectedExtension,
            // RFC 8446 §4.2 — the server MUST NOT send extensions the client
            // did not offer; abort with unsupported_extension.
            else => return error.UnsupportedExtension,
        }
    }
    if (r.pos != extensions_end) return error.InvalidExtensionLength;
    return result;
}

fn parseAlpn(ext: []const u8, offered: []const []const u8) ParseError![]const u8 {
    if (offered.len == 0) return error.UnsupportedExtension;
    if (ext.len < 3) return error.InvalidExtensionLength;
    var r: wire.Reader = .init(ext);
    const list_len = r.assumeRead(u16);
    if (list_len != ext.len - 2) return error.InvalidExtensionLength;
    const protocol_len = r.assumeRead(u8);
    if (protocol_len == 0) return error.EmptyAlpnProtocol;
    if (r.remaining().len < protocol_len) return error.InvalidExtensionLength;
    const protocol = r.assumeReadSlice(protocol_len);
    if (r.pos != ext.len) return error.TooManyAlpnProtocols;
    for (offered) |candidate| {
        if (mem.eql(u8, candidate, protocol)) return protocol;
    }
    return error.UnofferedAlpnProtocol;
}

test "encode: empty EncryptedExtensions" {
    var out: [32]u8 = undefined;
    const msg = try encode(&out, null, false);
    try testing.expectEqualSlices(u8, &.{ 0x08, 0x00, 0x00, 0x02, 0x00, 0x00 }, msg);
    _ = try parse(msg, &.{}, .{});
}

test "encode: ALPN EncryptedExtensions" {
    var out: [32]u8 = undefined;
    const msg = try encode(&out, "h2", false);
    const result = try parse(msg, &.{ "h2", "http/1.1" }, .{});
    try testing.expectEqualStrings("h2", result.alpn_protocol.?);
}

// RFC 8446 §4.2.10 — server emits empty early_data extension in EE when
// accepting 0-RTT; the client reads early_data_accepted from the parsed EE.
test "encode: early_data accepted in EncryptedExtensions" {
    var out: [32]u8 = undefined;
    const msg = try encode(&out, null, true);
    // type(1) + length(3) + extensions_len(2) + early_data ext(4) = 10
    try testing.expectEqualSlices(u8, &.{
        0x08, 0x00, 0x00, 0x06, 0x00, 0x04, 0x00, 0x2a, 0x00, 0x00,
    }, msg);
    const result = try parse(msg, &.{}, .{ .offered_extensions = .initOne(.early_data) });
    try testing.expect(result.early_data_accepted);
}

// RFC 8446 §4.2.10 — early_data NOT included when the server declines 0-RTT.
test "encode: early_data omitted when not accepted" {
    var out: [32]u8 = undefined;
    const msg = try encode(&out, null, false);
    const result = try parse(msg, &.{}, .{ .offered_extensions = .initOne(.early_data) });
    try testing.expect(!result.early_data_accepted);
}

test "parse: valid EncryptedExtensions" {
    // type(1) + length(3) + extensions_len(2) + no extensions
    const msg = [_]u8{ 0x08, 0x00, 0x00, 0x02, 0x00, 0x00 };
    _ = try parse(&msg, &.{}, .{});
}

test "parse: ALPN selection" {
    const msg = [_]u8{
        0x08, 0x00, 0x00, 0x0b,
        0x00, 0x09, 0x00, 0x10,
        0x00, 0x05, 0x00, 0x03,
        0x02, 'h',  '2',
    };
    const result = try parse(&msg, &.{ "h2", "http/1.1" }, .{});
    try testing.expectEqualStrings("h2", result.alpn_protocol.?);
}

test "parse: rejects unsolicited ALPN" {
    const msg = [_]u8{
        0x08, 0x00, 0x00, 0x0b,
        0x00, 0x09, 0x00, 0x10,
        0x00, 0x05, 0x00, 0x03,
        0x02, 'h',  '2',
    };
    try testing.expectError(error.UnsupportedExtension, parse(&msg, &.{}, .{}));
}

test "parse: rejects unoffered ALPN" {
    const msg = [_]u8{
        0x08, 0x00, 0x00, 0x0b,
        0x00, 0x09, 0x00, 0x10,
        0x00, 0x05, 0x00, 0x03,
        0x02, 'h',  '2',
    };
    try testing.expectError(error.UnofferedAlpnProtocol, parse(&msg, &.{"http/1.1"}, .{}));
}

test "parse: rejects duplicate ALPN extension" {
    const msg = [_]u8{
        0x08, 0x00, 0x00, 0x14,
        0x00, 0x12, 0x00, 0x10,
        0x00, 0x05, 0x00, 0x03,
        0x02, 'h',  '2',  0x00,
        0x10, 0x00, 0x05, 0x00,
        0x03, 0x02, 'h',  '2',
    };
    try testing.expectError(error.DuplicateExtension, parse(&msg, &.{"h2"}, .{}));
}

test "parse: rejects multiple ALPN protocols" {
    const msg = [_]u8{
        0x08, 0x00, 0x00, 0x12,
        0x00, 0x10, 0x00, 0x10,
        0x00, 0x0c, 0x00, 0x0a,
        0x02, 'h',  '2',  0x06,
        's',  'p',  'd',  'y',
        '/',  '3',
    };
    try testing.expectError(error.TooManyAlpnProtocols, parse(&msg, &.{ "h2", "spdy/3" }, .{}));
}

// RFC 8446 §4.2 — extensions recognized for other handshake messages are
// forbidden in EncryptedExtensions.
test "parse: rejects forbidden supported_versions extension" {
    const msg = [_]u8{
        0x08, 0x00, 0x00, 0x08,
        0x00, 0x06, 0x00, 0x2b,
        0x00, 0x02, 0x03, 0x04,
    };
    try testing.expectError(error.UnexpectedExtension, parse(&msg, &.{}, .{}));
}

// RFC 8446 §4.2 — key_share belongs in ClientHello, ServerHello, and HRR, not
// EncryptedExtensions.
test "parse: rejects forbidden key_share extension" {
    const msg = [_]u8{
        0x08, 0x00, 0x00, 0x08,
        0x00, 0x06, 0x00, 0x33,
        0x00, 0x02, 0x00, 0x1d,
    };
    try testing.expectError(error.UnexpectedExtension, parse(&msg, &.{}, .{}));
}

// RFC 8446 §4.2 — recognized extensions in the wrong message are illegal.
test "parse: rejects forbidden heartbeat extension" {
    const msg = [_]u8{
        0x08, 0x00, 0x00, 0x06,
        0x00, 0x04, 0x00, 0x0f,
        0x00, 0x00,
    };
    try testing.expectError(error.UnexpectedExtension, parse(&msg, &.{}, .{}));
}

// RFC 8701 §3.1 — clients reject GREASE values negotiated by a server.
test "parse: rejects GREASE EncryptedExtensions extension" {
    const msg = [_]u8{
        0x08, 0x00, 0x00, 0x06,
        0x00, 0x04, 0x0a, 0x0a,
        0x00, 0x00,
    };
    try testing.expectError(error.UnexpectedExtension, parse(&msg, &.{}, .{}));
}

// RFC 8446 §4.2 — the server MUST NOT respond with an extension the client did
// not offer; an unknown extension type in EncryptedExtensions must be rejected.
test "parse: rejects unknown unsolicited extension" {
    // Extension type 0x5a5b is not a GREASE value and is not a recognized
    // EncryptedExtensions extension; it should be rejected with UnsupportedExtension.
    const msg = [_]u8{
        0x08, 0x00, 0x00, 0x08,
        0x00, 0x06, 0x5a, 0x5b,
        0x00, 0x02, 0x00, 0x00,
    };
    try testing.expectError(error.UnsupportedExtension, parse(&msg, &.{}, .{}));
}

// RFC 6066 §3 — server_name in EncryptedExtensions is a zero-length
// acknowledgment of the client's SNI offer; accepted only when offered.
test "parse: accepts server_name acknowledgment when SNI offered" {
    // server_name extension (type 0x0000) with empty extension_data (ext_len=0).
    const msg = [_]u8{
        0x08, 0x00, 0x00, 0x06,
        0x00, 0x04, 0x00, 0x00,
        0x00, 0x00,
    };
    _ = try parse(&msg, &.{}, .{ .offered_extensions = .initOne(.server_name) });
}

// RFC 6066 §3 / RFC 8446 §4.2 — server_name in EncryptedExtensions without a
// prior SNI offer is an unsolicited extension and must be rejected.
test "parse: rejects server_name when SNI not offered" {
    const msg = [_]u8{
        0x08, 0x00, 0x00, 0x06,
        0x00, 0x04, 0x00, 0x00,
        0x00, 0x00,
    };
    try testing.expectError(error.UnsupportedExtension, parse(&msg, &.{}, .{}));
}

// RFC 6066 §3 — the extension_data of an EE server_name acknowledgment MUST be
// empty; non-empty data is malformed.
test "parse: rejects server_name acknowledgment with non-empty extension_data" {
    // server_name (0x0000) with ext_len=2, which violates the "SHALL be empty" rule.
    const msg = [_]u8{
        0x08, 0x00, 0x00, 0x08,
        0x00, 0x06, 0x00, 0x00,
        0x00, 0x02, 0xde, 0xad,
    };
    try testing.expectError(
        error.InvalidExtensionLength,
        parse(&msg, &.{}, .{ .offered_extensions = .initOne(.server_name) }),
    );
}

// RFC 8449 §4 / RFC 8446 §4.2 — record_size_limit is defined for
// EncryptedExtensions; reject it unless the client offered it.
test "parse: rejects unoffered record_size_limit in EncryptedExtensions" {
    // record_size_limit (0x001c) with a 2-byte value (1024).
    const msg = [_]u8{
        0x08, 0x00, 0x00, 0x08,
        0x00, 0x06, 0x00, 0x1c,
        0x00, 0x02, 0x04, 0x00,
    };
    try testing.expectError(error.UnsupportedExtension, parse(&msg, &.{}, .{}));
}

// RFC 8449 §4 — record_size_limit in EncryptedExtensions acknowledges a
// ClientHello offer and carries a two-byte RecordSizeLimit value.
test "parse: accepts offered record_size_limit in EncryptedExtensions" {
    const msg = [_]u8{
        0x08, 0x00, 0x00, 0x08,
        0x00, 0x06, 0x00, 0x1c,
        0x00, 0x02, 0x04, 0x00,
    };
    _ = try parse(&msg, &.{}, .{ .offered_extensions = .initOne(.record_size_limit) });
}

// RFC 8449 §4 — record_size_limit extension_data is exactly two bytes.
test "parse: rejects malformed record_size_limit in EncryptedExtensions" {
    const msg = [_]u8{
        0x08, 0x00, 0x00, 0x07,
        0x00, 0x05, 0x00, 0x1c,
        0x00, 0x01, 0x40,
    };
    try testing.expectError(
        error.InvalidExtensionLength,
        parse(&msg, &.{}, .{ .offered_extensions = .initOne(.record_size_limit) }),
    );
}

// RFC 8446 §4.2.7 — supported_groups is allowed in EncryptedExtensions; the
// client must not act on it until handshake completion.
test "parse: ignores supported_groups extension" {
    const msg = [_]u8{
        0x08, 0x00, 0x00, 0x0a,
        0x00, 0x08, 0x00, 0x0a,
        0x00, 0x04, 0x00, 0x02,
        0x00, 0x1d,
    };
    _ = try parse(&msg, &.{}, .{});
}

test "parse: wrong handshake type" {
    const msg = [_]u8{ 0x01, 0x00, 0x00, 0x02, 0x00, 0x00 };
    try testing.expectError(error.InvalidHandshakeType, parse(&msg, &.{}, .{}));
}

test "parse: truncated" {
    const msg = [_]u8{ 0x08, 0x00, 0x00 };
    try testing.expectError(error.UnexpectedEof, parse(&msg, &.{}, .{}));
}
