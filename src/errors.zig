//! Coarse classification of the handshake engines' error sets.
//!
//! The engines return ~90 distinct errors between them. Integrations need a
//! handful of buckets a caller can act on, and every integration needs the same
//! ones, so the table lives here rather than being copied per wrapper: one
//! exhaustive switch, one compile-time gate, N thin projections.
//!
//! This is pure logic over `ClientHandshake`/`ServerHandshake` error sets plus
//! the RFC 8446 §6.2 alert each failure warrants. No allocation, no I/O.
const std = @import("std");
const testing = std.testing;

const alert = @import("alert.zig");
const ClientHandshake = @import("ClientHandshake.zig");
const ServerHandshake = @import("ServerHandshake.zig");

/// Every error either handshake role can produce. Used as one classification
/// domain so the table below is written once instead of per role.
pub const HandshakeError = ClientHandshake.StartError ||
    ClientHandshake.HandleError ||
    ServerHandshake.HandleError ||
    ServerFlightError;

pub const ServerFlightError = switch (@typeInfo(
    @typeInfo(@TypeOf(ServerHandshake.sendServerFlightBuffered)).@"fn".return_type.?,
)) {
    .error_union => |u| u.error_set,
    else => @compileError("sendServerFlightBuffered no longer returns an error union"),
};

/// Coarse failure class. Public error sets are thin projections of this.
pub const Class = enum {
    /// Peer certificate chain / hostname / signature did not authenticate.
    certificate,
    /// AEAD tag or Finished MAC mismatch.
    decrypt,
    /// Peer sent a fatal alert.
    alert,
    /// Peer sent something malformed, unexpected, or forbidden.
    protocol,
    /// Peer record exceeded the RFC 8446 §5.1 limit.
    record_overflow,
    /// Our configured buffers were too small.
    buffer,
    /// Caller-supplied options were unusable.
    options,
    /// Our fault: backend failure, counter overflow, broken invariant.
    internal,
    /// ALPN offered by both sides with no overlap (server only).
    no_alpn,
    /// No cipher suite overlap (server only).
    unsupported_suite,
    /// Server credentials missing or unusable (server only).
    missing_credentials,
    /// Client certificate required, unsupported, or oversized (server only).
    client_certificate,
};

/// Classify one core handshake error.
///
/// Deliberately exhaustive: no `else`. Adding a variant to any core handshake
/// error set is a compile error here until someone decides which coarse class
/// the new failure belongs to. That decision is security-relevant — silently
/// reporting a certificate failure as a generic protocol error is exactly the
/// bug this shape prevents — so it does not get a default.
// ziglint-ignore: Z012 -- HandshakeError is a public error-set alias.
pub fn classify(err: HandshakeError) Class {
    return switch (err) {
        // ── Peer certificate did not authenticate ──
        error.CertificateChainTooLong,
        error.CertificateExpired,
        error.CertificateExtendedKeyUsageRejected,
        error.CertificateFieldHasInvalidLength,
        error.CertificateFieldHasWrongDataType,
        error.CertificateHasDuplicateExtension,
        error.CertificateHasInvalidBitString,
        error.CertificateHasUnrecognizedObjectId,
        error.CertificateHostMismatch,
        error.CertificateIssuerMismatch,
        error.CertificateIssuerNotCa,
        error.CertificateIssuerNotFound,
        error.CertificateKeyTooLarge,
        error.CertificateKeyUsageRejected,
        error.CertificateNameConstraintUnsupported,
        error.CertificateNameConstraintViolation,
        error.CertificateNotYetValid,
        error.CertificatePublicKeyInvalid,
        error.CertificateSignatureAlgorithmMismatch,
        error.CertificateSignatureAlgorithmRejected,
        error.CertificateSignatureAlgorithmUnsupported,
        error.CertificateSignatureInvalid,
        error.CertificateSignatureInvalidLength,
        error.CertificateSignatureNamedCurveUnsupported,
        error.CertificateSignatureUnsupportedBitCount,
        error.CertificateTimeInvalid,
        error.CertificateUnsupportedCriticalExtension,
        error.EmptyCertificateList,
        error.InvalidEncoding,
        error.MissingTrustAnchor,
        error.SignatureVerificationFailed,
        error.UnsupportedCertificateVersion,
        error.UnsupportedSignatureScheme,
        => .certificate,

        // ── Cryptographic proof failed ──
        // RFC 8446 §4.4.4 (Finished) and §5.2 (record AEAD).
        error.AuthenticationFailed,
        error.InvalidVerifyData,
        => .decrypt,

        error.PeerAlert => .alert,

        // ── Peer protocol violations ──
        error.DuplicateExtension,
        error.DuplicateKeyShare,
        error.EmptyTicket,
        error.HelloRetryRequest,
        error.IdentityElement,
        error.IllegalParameter,
        error.IncompleteRecord,
        error.InvalidAlertLength,
        error.InvalidCompressionMethod,
        error.InvalidEnumTag,
        error.InvalidExtensionLength,
        error.InvalidHandshakeLength,
        error.InvalidHandshakeType,
        error.InvalidInnerPlaintext,
        error.InvalidSessionIdEcho,
        error.InvalidVectorLength,
        error.MalformedKeyShare,
        error.MissingExtension,
        error.MissingSignatureAlgorithmsExtension,
        error.NotHelloRetryRequest,
        error.RecordTooShort,
        error.SignatureSchemeNotOffered,
        error.TooManyKeyUpdates,
        error.TooManyNewSessionTickets,
        error.UnexpectedCertificateRequestContext,
        error.UnexpectedContentType,
        error.UnexpectedEof,
        error.UnexpectedExtension,
        error.UnexpectedMessage,
        error.UnexpectedRecord,
        error.UnofferedAlpnProtocol,
        error.UnsupportedExtension,
        error.UnsupportedGroup,
        error.UnsupportedKeyShare,
        error.UnsupportedKeyShareGroup,
        error.UnsupportedTlsVersion,
        => .protocol,

        error.RecordTooLarge => .record_overflow,

        error.BufferTooShort,
        error.HandshakeBufferTooShort,
        => .buffer,

        // ── Caller-supplied options ──
        error.AlpnProtocolTooLong,
        error.EmptyAlpnProtocol,
        error.IdentityTooLong,
        error.ServerNameTooLong,
        error.TooManyAlpnBytes,
        error.TooManyAlpnProtocols,
        => .options,

        // ── Our side ──
        error.AeadEncryptFailed,
        error.AeadSetupFailed,
        error.KeyUpdateRequired,
        error.LibcryptoFailed,
        error.PendingWrite,
        error.PlaintextTooLarge,
        error.RequestContextTooLong,
        error.SequenceNumberOverflow,
        error.SliceLengthMismatch,
        => .internal,

        error.NoApplicationProtocol => .no_alpn,
        error.UnsupportedCipherSuite => .unsupported_suite,
        error.MissingServerCredentials => .missing_credentials,

        error.ClientCertificateRequired,
        error.ClientCertificateTooLarge,
        error.UnsupportedClientCertificate,
        => .client_certificate,
    };
}

/// RFC 8446 §6.2 — a fatal error SHOULD be reported to the peer with an alert
/// before the connection closes, so the peer logs `bad_certificate` instead of
/// a bare FIN. `null` means send nothing: either the peer already aborted, or
/// the transport is gone and an alert cannot reach it.
pub fn alertForClass(class: Class) ?alert.Description {
    return switch (class) {
        .certificate => .bad_certificate,
        .decrypt => .decrypt_error,
        // The peer already sent a fatal alert; RFC 8446 §6.2 says close
        // without sending more data.
        .alert => null,
        .protocol => .illegal_parameter,
        .record_overflow => .record_overflow,
        .buffer, .options, .internal, .missing_credentials => .internal_error,
        .no_alpn => .no_application_protocol,
        .unsupported_suite => .handshake_failure,
        .client_certificate => .certificate_required,
    };
}

// The table is exhaustive by construction: adding a variant to any core
// handshake error set fails to compile here until it is classified. These cases
// pin the classifications that are security-relevant to get right.
test "classify: certificate failures never fall into a generic bucket" {
    try testing.expectEqual(Class.certificate, classify(error.CertificateHostMismatch));
    try testing.expectEqual(Class.certificate, classify(error.CertificateExpired));
    try testing.expectEqual(Class.certificate, classify(error.MissingTrustAnchor));
    try testing.expectEqual(Class.certificate, classify(error.SignatureVerificationFailed));
}

// RFC 8446 §4.4.4 (Finished) and §5.2 (record AEAD) failures are the peer
// failing to prove key possession, not malformed input.
test "classify: authentication failures are their own class" {
    try testing.expectEqual(Class.decrypt, classify(error.InvalidVerifyData));
    try testing.expectEqual(Class.decrypt, classify(error.AuthenticationFailed));
}

test "classify: remaining buckets" {
    try testing.expectEqual(Class.alert, classify(error.PeerAlert));
    try testing.expectEqual(Class.protocol, classify(error.IllegalParameter));
    try testing.expectEqual(Class.record_overflow, classify(error.RecordTooLarge));
    try testing.expectEqual(Class.buffer, classify(error.HandshakeBufferTooShort));
    try testing.expectEqual(Class.options, classify(error.AlpnProtocolTooLong));
    try testing.expectEqual(Class.internal, classify(error.LibcryptoFailed));
    try testing.expectEqual(Class.no_alpn, classify(error.NoApplicationProtocol));
    try testing.expectEqual(Class.unsupported_suite, classify(error.UnsupportedCipherSuite));
    try testing.expectEqual(Class.missing_credentials, classify(error.MissingServerCredentials));
    try testing.expectEqual(Class.client_certificate, classify(error.ClientCertificateRequired));
}

// RFC 8446 §6.2 — the peer gets a reason, not a bare FIN.
test "alertForClass: peer-visible reason matches the failure" {
    try testing.expectEqual(alert.Description.bad_certificate, alertForClass(.certificate).?);
    try testing.expectEqual(alert.Description.decrypt_error, alertForClass(.decrypt).?);
    try testing.expectEqual(alert.Description.illegal_parameter, alertForClass(.protocol).?);
    try testing.expectEqual(alert.Description.record_overflow, alertForClass(.record_overflow).?);
    try testing.expectEqual(
        alert.Description.no_application_protocol,
        alertForClass(.no_alpn).?,
    );
    // The peer already aborted; §6.2 says close without replying.
    try testing.expectEqual(@as(?alert.Description, null), alertForClass(.alert));
}
