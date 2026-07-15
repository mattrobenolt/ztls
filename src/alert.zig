//! TLS Alert protocol.
//!
//! RFC 8446 §6
const std = @import("std");
const testing = std.testing;
const fuzz_compat = @import("fuzz_compat.zig");

const frame = @import("frame.zig");

pub const Level = enum(u8) {
    warning = 1,
    fatal = 2,
    _,
};

pub const Description = enum(u8) {
    close_notify = 0,
    unexpected_message = 10,
    bad_record_mac = 20,
    record_overflow = 22,
    handshake_failure = 40,
    bad_certificate = 42,
    unsupported_certificate = 43,
    certificate_revoked = 44,
    certificate_expired = 45,
    certificate_unknown = 46,
    illegal_parameter = 47,
    unknown_ca = 48,
    access_denied = 49,
    decode_error = 50,
    decrypt_error = 51,
    protocol_version = 70,
    insufficient_security = 71,
    internal_error = 80,
    inappropriate_fallback = 86,
    user_canceled = 90,
    missing_extension = 109,
    unsupported_extension = 110,
    unrecognized_name = 112,
    bad_certificate_status_response = 113,
    unknown_psk_identity = 115,
    certificate_required = 116,
    no_application_protocol = 120,
    _,
};

pub const Alert = struct {
    level: Level,
    description: Description,

    pub inline fn isCloseNotify(self: Alert) bool {
        return self.description == .close_notify;
    }

    pub inline fn isFatal(self: Alert) bool {
        return switch (self.description) {
            .close_notify, .user_canceled => false,
            else => true,
        };
    }
};

pub const ParseError = error{ UnexpectedEof, InvalidAlertLength };

pub fn parse(msg: []const u8) ParseError!Alert {
    if (msg.len < 2) return error.UnexpectedEof;
    if (msg.len != 2) return error.InvalidAlertLength;
    return .{
        .level = @enumFromInt(msg[0]),
        .description = @enumFromInt(msg[1]),
    };
}

pub fn encode(out: []u8, level: Level, description: Description) error{BufferTooShort}![]u8 {
    if (out.len < 2) return error.BufferTooShort;
    out[0] = @intFromEnum(level);
    out[1] = @intFromEnum(description);
    return out[0..2];
}

pub fn plaintextRecord(msg: *const [2]u8, out: []u8) error{BufferTooShort}![]u8 {
    const total = frame.header_len + msg.len;
    if (out.len < total) return error.BufferTooShort;
    const header: frame.Header = .init(.alert, msg.len);
    header.write(out[0..frame.header_len]);
    out[frame.header_len..][0..msg.len].* = msg.*;
    return out[0..total];
}

/// Map a TLS engine error to the appropriate alert description.
/// RFC 8446 §6.2 — error alerts should be as specific as the protocol defines;
/// unknown errors fall through to `internal_error`.
pub fn alertForError(err: anyerror) Description {
    return switch (err) {
        error.AuthenticationFailed => .bad_record_mac,
        error.SignatureVerificationFailed,
        error.InvalidVerifyData,
        => .decrypt_error,
        error.EmptyCertificateList,
        error.EmptyTicket,
        error.InvalidAlertLength,
        error.InvalidEncoding,
        error.InvalidEnumTag,
        error.InvalidExtensionLength,
        error.InvalidHandshakeLength,
        error.InvalidVectorLength,
        error.UnexpectedEof,
        error.IncompleteRecord,
        error.RecordTooShort,
        error.InvalidInnerPlaintext,
        => .decode_error,
        error.MissingTrustAnchor,
        error.CertificateIssuerNotFound,
        => .unknown_ca,
        error.CertificateExpired,
        error.CertificateNotYetValid,
        => .certificate_expired,
        error.CertificateKeyUsageRejected,
        error.CertificateExtendedKeyUsageRejected,
        error.CertificateSignatureAlgorithmRejected,
        error.CertificateSignatureAlgorithmUnsupported,
        error.UnsupportedCertificateVersion,
        error.UnsupportedClientCertificate,
        error.CertificateKeyTooLarge,
        => .unsupported_certificate,
        error.CertificateHostMismatch,
        error.CertificateNameConstraintViolation,
        error.CertificateNameConstraintUnsupported,
        => .certificate_unknown,
        error.CertificateFieldHasInvalidLength,
        error.CertificateFieldHasWrongDataType,
        error.CertificateHasInvalidBitString,
        error.CertificateTimeInvalid,
        error.CertificateHasUnrecognizedObjectId,
        error.CertificateIssuerMismatch,
        error.CertificatePublicKeyInvalid,
        error.CertificateSignatureAlgorithmMismatch,
        error.CertificateSignatureInvalidLength,
        error.InvalidSignature,
        => .bad_certificate,
        error.MissingExtension,
        error.MissingSignatureAlgorithmsExtension,
        => .missing_extension,
        error.UnsupportedExtension => .unsupported_extension,
        error.UnsupportedTlsVersion => .protocol_version,
        error.UnsupportedCipherSuite,
        error.UnsupportedKeyShare,
        => .handshake_failure,
        error.NoApplicationProtocol => .no_application_protocol,
        error.ClientCertificateRequired => .certificate_required,
        error.DuplicateExtension,
        error.DuplicateKeyShare,
        error.InvalidCompressionMethod,
        error.InvalidSessionIdEcho,
        error.UnexpectedCertificateRequestContext,
        error.UnexpectedExtension,
        error.IllegalParameter,
        error.IdentityElement,
        error.MalformedKeyShare,
        error.UnofferedAlpnProtocol,
        error.UnsupportedKeyShareGroup,
        error.UnsupportedSignatureScheme,
        error.SignatureSchemeNotOffered,
        => .illegal_parameter,
        error.InvalidHandshakeType,
        error.UnexpectedRecord,
        error.UnexpectedMessage,
        => .unexpected_message,
        else => .internal_error,
    };
}

// RFC 8446 §6.1 — closure alerts
test "parse: close_notify" {
    const a = try parse(&.{ 1, 0 });
    try testing.expectEqual(.warning, a.level);
    try testing.expectEqual(.close_notify, a.description);
    try testing.expect(a.isCloseNotify());
}

// RFC 8446 §6.2 — error alerts are treated as fatal regardless of the legacy
// AlertLevel byte.
test "parse: warning-level error alert is fatal" {
    const a = try parse(&.{ 1, 10 });
    try testing.expectEqual(.warning, a.level);
    try testing.expectEqual(.unexpected_message, a.description);
    try testing.expect(a.isFatal());
}

// RFC 8446 §6.2 — unknown alert descriptions are error alerts in TLS 1.3.
test "parse: unknown alert description is fatal" {
    const a = try parse(&.{ 1, 222 });
    try testing.expectEqual(@as(u8, 222), @intFromEnum(a.description));
    try testing.expect(a.isFatal());
}

// RFC 8446 §6.1 — user_canceled is a closure alert, not a §6.2 fatal alert.
test "parse: user_canceled is not fatal" {
    const a = try parse(&.{ 1, 90 });
    try testing.expectEqual(.warning, a.level);
    try testing.expectEqual(.user_canceled, a.description);
    try testing.expect(!a.isFatal());
}

test "parse: truncated" {
    try testing.expectError(error.UnexpectedEof, parse(&.{1}));
}

// RFC 8446 §5.1 — Alert messages must not be coalesced in one record.
test "parse: rejects coalesced alert bytes" {
    try testing.expectError(error.InvalidAlertLength, parse(&.{ 1, 0, 1, 0 }));
}

test "encode" {
    var buf: [2]u8 = undefined;
    try testing.expectEqualSlices(u8, &.{ 2, 50 }, try encode(&buf, .fatal, .decode_error));
}

// RFC 8446 §6 — Alert messages are exactly two bytes; fuzz arbitrary inputs to
// ensure parse rejects truncation and never crashes. Run with `zig build test --fuzz`.
fn fuzzParse(_: void, input: []const u8) anyerror!void {
    _ = parse(input) catch return;
}

test "fuzz: parse handles arbitrary input" {
    try fuzz_compat.fuzzBytes(fuzzParse, {}, .{ .corpus = &.{ &.{ 1, 0 }, &.{ 2, 10 } } });
}

// RFC 8446 §6.2 — certificate-processing failures are mapped to
// certificate-related alerts for callers to send through the Sans-I/O API.
test "alertForError: certificate failures map to certificate alerts" {
    const cases = [_]struct {
        err: anyerror,
        description: Description,
    }{
        .{ .err = error.MissingTrustAnchor, .description = .unknown_ca },
        .{ .err = error.CertificateIssuerNotFound, .description = .unknown_ca },
        .{ .err = error.CertificateExpired, .description = .certificate_expired },
        .{ .err = error.CertificateNotYetValid, .description = .certificate_expired },
        .{
            .err = error.CertificateKeyUsageRejected,
            .description = .unsupported_certificate,
        },
        .{
            .err = error.CertificateExtendedKeyUsageRejected,
            .description = .unsupported_certificate,
        },
        .{
            .err = error.CertificateSignatureAlgorithmRejected,
            .description = .unsupported_certificate,
        },
        .{
            .err = error.CertificateSignatureAlgorithmUnsupported,
            .description = .unsupported_certificate,
        },
        .{ .err = error.UnsupportedCertificateVersion, .description = .unsupported_certificate },
        .{ .err = error.UnsupportedClientCertificate, .description = .unsupported_certificate },
        .{ .err = error.CertificateKeyTooLarge, .description = .unsupported_certificate },
        .{ .err = error.CertificateHostMismatch, .description = .certificate_unknown },
        .{ .err = error.CertificateNameConstraintViolation, .description = .certificate_unknown },
        .{ .err = error.CertificateNameConstraintUnsupported, .description = .certificate_unknown },
        .{ .err = error.CertificateFieldHasInvalidLength, .description = .bad_certificate },
        .{ .err = error.CertificateFieldHasWrongDataType, .description = .bad_certificate },
        .{ .err = error.CertificateHasInvalidBitString, .description = .bad_certificate },
        .{ .err = error.CertificateTimeInvalid, .description = .bad_certificate },
        .{ .err = error.CertificateHasUnrecognizedObjectId, .description = .bad_certificate },
        .{ .err = error.CertificateIssuerMismatch, .description = .bad_certificate },
        .{ .err = error.CertificatePublicKeyInvalid, .description = .bad_certificate },
        .{ .err = error.CertificateSignatureAlgorithmMismatch, .description = .bad_certificate },
        .{ .err = error.CertificateSignatureInvalidLength, .description = .bad_certificate },
        .{ .err = error.InvalidSignature, .description = .bad_certificate },
        .{ .err = error.ClientCertificateRequired, .description = .certificate_required },
    };
    for (cases) |case| try testing.expectEqual(case.description, alertForError(case.err));
}

// RFC 8446 §6.2 — decode failures use decode_error, malformed handshake
// sequencing uses unexpected_message, and semantic protocol violations use the
// more specific alert when TLS 1.3 defines one.
test "alertForError: parser and semantic failures map to protocol alerts" {
    const cases = [_]struct {
        err: anyerror,
        description: Description,
    }{
        .{ .err = error.AuthenticationFailed, .description = .bad_record_mac },
        .{ .err = error.SignatureVerificationFailed, .description = .decrypt_error },
        .{ .err = error.InvalidVerifyData, .description = .decrypt_error },
        .{ .err = error.UnexpectedEof, .description = .decode_error },
        .{ .err = error.EmptyCertificateList, .description = .decode_error },
        .{ .err = error.EmptyTicket, .description = .decode_error },
        .{ .err = error.InvalidAlertLength, .description = .decode_error },
        .{ .err = error.InvalidEncoding, .description = .decode_error },
        .{ .err = error.InvalidEnumTag, .description = .decode_error },
        .{ .err = error.InvalidExtensionLength, .description = .decode_error },
        .{ .err = error.InvalidHandshakeLength, .description = .decode_error },
        .{ .err = error.InvalidVectorLength, .description = .decode_error },
        .{ .err = error.IncompleteRecord, .description = .decode_error },
        .{ .err = error.RecordTooShort, .description = .decode_error },
        .{ .err = error.InvalidInnerPlaintext, .description = .decode_error },
        .{ .err = error.InvalidHandshakeType, .description = .unexpected_message },
        .{ .err = error.UnexpectedRecord, .description = .unexpected_message },
        .{ .err = error.UnexpectedMessage, .description = .unexpected_message },
        .{ .err = error.MissingExtension, .description = .missing_extension },
        .{ .err = error.MissingSignatureAlgorithmsExtension, .description = .missing_extension },
        .{ .err = error.UnsupportedExtension, .description = .unsupported_extension },
        .{ .err = error.UnsupportedTlsVersion, .description = .protocol_version },
        .{ .err = error.UnsupportedCipherSuite, .description = .handshake_failure },
        .{ .err = error.UnsupportedKeyShare, .description = .handshake_failure },
        .{ .err = error.NoApplicationProtocol, .description = .no_application_protocol },
        .{ .err = error.DuplicateExtension, .description = .illegal_parameter },
        .{ .err = error.DuplicateKeyShare, .description = .illegal_parameter },
        .{ .err = error.InvalidCompressionMethod, .description = .illegal_parameter },
        .{ .err = error.InvalidSessionIdEcho, .description = .illegal_parameter },
        .{ .err = error.UnexpectedCertificateRequestContext, .description = .illegal_parameter },
        .{ .err = error.UnexpectedExtension, .description = .illegal_parameter },
        .{ .err = error.IllegalParameter, .description = .illegal_parameter },
        .{ .err = error.IdentityElement, .description = .illegal_parameter },
        .{ .err = error.MalformedKeyShare, .description = .illegal_parameter },
        .{ .err = error.UnofferedAlpnProtocol, .description = .illegal_parameter },
        .{ .err = error.UnsupportedKeyShareGroup, .description = .illegal_parameter },
        .{ .err = error.UnsupportedSignatureScheme, .description = .illegal_parameter },
        .{ .err = error.SignatureSchemeNotOffered, .description = .illegal_parameter },
    };
    for (cases) |case| try testing.expectEqual(case.description, alertForError(case.err));
}

// RFC 8446 §6 — unknown errors fall through to internal_error.
test "alertForError: unknown error maps to internal_error" {
    try testing.expectEqual(.internal_error, alertForError(error.SomeUnmappedError));
}
