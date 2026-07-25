//! ztls-xev: non-blocking TLS 1.3 over [libxev](https://github.com/mitchellh/libxev).
//!
//! libxev is a callback-completion event loop with its own API — it does not
//! implement `std.Io` — so unlike a `std.Io` runtime this genuinely needs an
//! adapter rather than working through `ztls-std` unchanged. See #76.
//!
//! The shape is deliberately NOT ztls-std's. ztls-std is a blocking wrapper:
//! `connect` owns the stack and drives the handshake to completion in a loop,
//! and reads/writes present `std.Io.Reader`/`std.Io.Writer`. Neither survives
//! here. In a completion world the callback *is* the loop body and every local
//! becomes connection state; and `Io.Reader.stream` is a synchronous contract
//! that must produce bytes or fail, with no way to say "call me back", so there
//! is no byte-stream seam to offer. Callers get explicit operations with
//! callbacks instead.
//!
//! What ztls-std does share: `ztls.errors.classify` for the coarse failure
//! buckets, so both integrations project from one exhaustive table.
//!
//! API contract, in one place:
//!
//! - Every operation returns `void` and invokes its callback **exactly once**,
//!   including for failures detected synchronously. A caller never handles the
//!   same failure in two places.
//! - Callbacks take a typed `ctx` — no `anyopaque`, no `xev.Completion`. The
//!   `Conn` owns its completions, one per direction plus teardown, which is what
//!   lets a read and a write be in flight together.
//! - Reads and writes may overlap each other. Two reads may not, and neither may
//!   two writes: the second is rejected with `Error.Concurrent` delivered to its
//!   callback.
//! - Operations are state-gated. Issuing one past `.established` fails with
//!   `Error.Closed` rather than asserting, because a late read is a plausible
//!   caller race rather than a memory-safety bug.
//!
//! Shape and vocabulary follow a proven server-side libxev TLS integration; the
//! `ReadResult` split in particular is lifted from it.
const std = @import("std");
const testing = std.testing;

pub const Config = @import("Config.zig");
pub const Conn = @import("Conn.zig");

const ztls = @import("ztls");
/// Re-export ztls so consumers can reach the core if needed.
pub const core = ztls;

/// True iff `bytes` starts with the TLS Handshake ContentType (0x16), the only
/// legal first byte of a fresh TLS connection. RFC 8446 §5.1. For callers doing
/// pre-handshake protocol routing (StartTLS-style) on bytes they peeked
/// themselves — ztls-xev does not offer `peek`/`consume` yet.
pub fn isTls(bytes: []const u8) bool {
    return bytes.len >= 1 and bytes[0] == 0x16;
}

/// Lifecycle of a `Conn`. Methods are state-gated; callers inspect via
/// `Conn.state()` and never mutate it.
pub const State = enum {
    /// Between `init` and a completed `handshake`. Valid ops: `handshake`,
    /// `close`, `closeReset`.
    handshaking,
    /// Handshake completed. Valid ops: `read`, `write`, `close`, `closeReset`.
    established,
    /// A close is in flight. New ops fail with `Error.Closed`.
    closing,
    /// Terminal. The socket is released; the caller destroys the `Conn` via
    /// `deinit`.
    closed,
};

/// Failure surface for every callback. Coarse on purpose: specific enough to
/// branch on, narrow enough that libxev, kernel, and ztls-core error sets do not
/// leak into caller code. Projected from `ztls.errors.classify` where the cause
/// is a TLS failure.
pub const Error = error{
    /// A close was initiated while this operation was in flight. The operation's
    /// callback fires once with this, before the close callback.
    Canceled,
    /// The operation was issued when the connection was already `.closing` or
    /// `.closed`.
    Closed,
    /// A second operation of the same direction was issued while the first was
    /// still in flight. Reads and writes may overlap each other; two reads or
    /// two writes may not.
    Concurrent,
    /// The operation is not valid in the current state — a `read` before the
    /// handshake completed, or a second `handshake`.
    InvalidState,
    /// The peer's certificate chain, hostname, validity window, or
    /// CertificateVerify signature did not authenticate.
    CertificateVerificationFailed,
    /// A Finished MAC or record AEAD tag failed to verify.
    DecryptError,
    /// The peer aborted with a fatal alert.
    AlertReceived,
    /// The peer sent a malformed, unexpected, or illegal message.
    ProtocolError,
    /// ALPN was offered by both sides with no overlap.
    AlpnRejected,
    /// The peer sent a record longer than RFC 8446 §5.1 permits.
    RecordOverflow,
    /// The buffers handed to `Conn.init` cannot hold this peer's handshake.
    /// Raise `Buffers.reassembly` or `Buffers.record`.
    BufferTooSmall,
    /// The socket failed: reset, EPIPE, and similar.
    IoError,
    /// Backend failure, counter overflow, or a broken invariant on our side.
    /// Not attributable to the peer.
    InternalError,
};

/// Delivered to a `read` callback. Four outcomes rather than a byte count and an
/// error, so an orderly TLS shutdown is distinguishable from a truncated
/// transport (RFC 8446 §6.1).
///
/// ztls-std cannot draw this distinction — `std.Io.Reader` has one
/// `error.EndOfStream` for both — and its README argues that is acceptable
/// because a byte-stream reader cannot tell them apart anyway. That argument
/// does not apply to a callback API, so this one tells you.
pub const ReadResult = union(enum) {
    /// Decrypted application data, a slice into the buffer the caller passed to
    /// `read`, length 1..buf.len. Never zero-length: RFC 8446 §5.1 permits
    /// zero-length fragments and they are skipped internally.
    data: []const u8,
    /// The peer sent an authenticated `close_notify`. Orderly shutdown; treat
    /// the stream as cleanly finished.
    close_notify,
    /// The transport returned EOF with no preceding `close_notify`. The stream
    /// was truncated — an abort, not a graceful close. Ubiquitous on the real
    /// internet, so not automatically an error, but the caller decides.
    eof,
    err: Error,
};

/// Delivered to a `write` callback. `written` equals the input length on
/// success: partial socket writes are driven to completion internally rather
/// than surfaced. There is no short-write success case — all bytes or none.
///
/// Zero-length writes complete synchronously with `written = 0` and touch
/// neither the engine nor the socket.
pub const WriteResult = struct {
    written: Error!usize,
};

/// Delivered to a `handshake` callback. Success moves the `Conn` to
/// `.established`; failure moves it to `.closing`, and the peer is sent the
/// fatal alert its failure warrants (RFC 8446 §6.2) before the socket closes.
pub const HandshakeResult = struct {
    result: Error!void,
};

/// Map a core handshake/record failure onto the public surface. One projection
/// of `ztls.errors.classify`, so ztls-xev and ztls-std agree on what a given
/// core error means even though their public sets differ.
pub fn fromCore(err: ztls.errors.HandshakeError) Error {
    return switch (ztls.errors.classify(err)) {
        .certificate => error.CertificateVerificationFailed,
        .decrypt => error.DecryptError,
        .alert => error.AlertReceived,
        .protocol, .unsupported_suite => error.ProtocolError,
        .no_alpn => error.AlpnRejected,
        .record_overflow => error.RecordOverflow,
        .buffer => error.BufferTooSmall,
        .options, .internal, .missing_credentials, .client_certificate => error.InternalError,
    };
}

test "isTls: only the TLS Handshake ContentType qualifies" {
    try testing.expect(isTls(&.{0x16}));
    try testing.expect(isTls(&.{ 0x16, 0x03, 0x01 }));
    try testing.expect(!isTls(&.{0x17}));
    // Postgres SSLRequest, the case this helper exists to rule out.
    try testing.expect(!isTls(&.{ 0x00, 0x00, 0x00, 0x08 }));
    try testing.expect(!isTls(&.{}));
}

// Certificate failures must not degrade into a generic protocol error, the same
// property ztls-std pins for its own projection.
test "fromCore: projections that matter" {
    const cert_failed = Error.CertificateVerificationFailed;
    try testing.expectEqual(cert_failed, fromCore(error.CertificateExpired));
    try testing.expectEqual(cert_failed, fromCore(error.CertificateHostMismatch));
    try testing.expectEqual(Error.DecryptError, fromCore(error.InvalidVerifyData));
    try testing.expectEqual(Error.AlertReceived, fromCore(error.PeerAlert));
    try testing.expectEqual(Error.ProtocolError, fromCore(error.IllegalParameter));
    try testing.expectEqual(Error.AlpnRejected, fromCore(error.NoApplicationProtocol));
    try testing.expectEqual(Error.RecordOverflow, fromCore(error.RecordTooLarge));
    try testing.expectEqual(Error.BufferTooSmall, fromCore(error.HandshakeBufferTooShort));
    try testing.expectEqual(Error.InternalError, fromCore(error.LibcryptoFailed));
}

test {
    // 0.16 dropped refAllDeclsRecursive; name the modules explicitly so their
    // tests run.
    _ = Config;
    _ = Conn;
}
