//! ztls-std: opinionated TLS 1.3 stream wrapper over `std.Io.net` (Zig 0.16).
//!
//! Converts a connected `std.Io.net` stream into a TLS connection so a caller
//! can `connect`/`read`/`write`/`close` without writing a Sans-I/O drive loop.
//! This is the reference integration; ztls-xev and ztls-ktls adapt its
//! handshake-to-completion loop. See #77.
//!
//! Design: eager handshake (connect/accept run the full handshake before
//! returning), honest `Io.Reader`/`Io.Writer` seam (every stdlib reader API
//! works, including the cross-record ones an HTTP parser needs), and
//! comptime-sized caller-visible buffers so the ~200 KB default is a choice
//! rather than a tax.
//!
//! One reader task and one writer task can use a connected Stream concurrently.
//! TX operations share an `Io.Mutex` because record encryption advances the TX
//! sequence before the transport write completes. Reader-side KeyUpdate
//! responses use the same lease, so their wire order matches the TX key epoch.
//! Multiple readers or multiple writers remain unsupported because each
//! `Io.Reader` or `Io.Writer` interface owns mutable staging state.
//!
//! Call `abort()` to wake blocked halves. Join both tasks before `close()` or
//! `deinit()` tears down the socket and secret storage.
const std = @import("std");
const assert = std.debug.assert;
const Io = std.Io;
const net = Io.net;
const testing = std.testing;
const mem = std.mem;
const crypto = std.crypto;
const posix = std.posix;

const ztls = @import("ztls");
/// Re-export ztls so consumers of ztls-std can reach the core if needed.
pub const core = ztls;
const alert = ztls.alert;
const frame = ztls.frame;
// One classification of the ~90 core handshake errors, shared by every
// integration. The public sets below are thin projections of it.
const errors = ztls.errors;
const Class = errors.Class;
const HandshakeError = errors.HandshakeError;
const classify = errors.classify;
const RecordBuffer = ztls.RecordBuffer;

// ───────────────────────────────
// Verification policy (client)
// ───────────────────────────────

/// Client certificate verification policy. Required — there is no default, so
/// no caller can get an unverified connection by omission. See README.
pub const Verify = union(enum) {
    /// Load the OS trust store with `gpa` and verify the server certificate
    /// chain against it. The bundle is freed before `connect` returns, so a
    /// client opening many connections should build one bundle and pass
    /// `.bundle` instead of rescanning the trust store per connection.
    system_bundle: mem.Allocator,
    /// Verify against a caller-owned bundle (pin a root / custom store).
    /// Borrowed for the duration of the handshake.
    bundle: *const crypto.Certificate.Bundle,
    /// Skip chain-anchor verification (sets ztls `insecure_no_chain_anchor`).
    /// Hostname verification still runs unless `host` is null. Demo/test only.
    insecure,
};

// ───────────────────────────────
// Client authentication (mTLS)
// ───────────────────────────────

/// Client credentials for TLS client authentication. `cert_chain` is DER,
/// leaf first; `signer` signs the client CertificateVerify. All borrowed for
/// the handshake: the DER bytes, the slice-of-slices, and the `PrivateKey`
/// backing the signer must outlive `connect`. RFC 8446 §4.4.2, §4.4.3.
pub const ClientCredentials = struct {
    cert_chain: []const []const u8,
    signer: ztls.signature.Signer,
};

/// Trust anchors for verifying a client certificate chain. A server
/// authenticating clients must decide where its anchors come from — there is
/// deliberately no system-bundle mode here, because pinning your own CA is
/// the normal mTLS deployment shape, not a fallback.
pub const ClientTrust = union(enum) {
    /// Verify the client chain against a caller-owned bundle. Borrowed for
    /// the duration of the handshake.
    bundle: *const crypto.Certificate.Bundle,
    /// Skip chain-anchor verification. The client CertificateVerify signature
    /// still proves possession of the private key. Demo/test only.
    insecure,
};

/// Server-side client-certificate policy. RFC 8446 §4.4.2. Default `.none`.
pub const ClientAuth = union(enum) {
    /// Do not request a client certificate.
    none,
    /// Request one; an empty client Certificate is accepted and
    /// `info().client_identity` is null.
    optional: ClientTrust,
    /// Request one; an empty client Certificate aborts the handshake with
    /// `ClientCertificateRejected`.
    required: ClientTrust,
};

// ───────────────────────────────
// Buffer configuration
// ───────────────────────────────

/// Comptime buffer sizing for a `Stream`. ztls core is built on caller-owned
/// buffers; this is where that choice surfaces in the wrapper. The defaults
/// accept anything the core accepts (~148 KB client / ~132 KB server), which is
/// the right trade for a handful of connections and the wrong one for
/// thousands.
pub const Config = struct {
    /// Transport staging for record framing. Must be at least
    /// `ztls.RecordBuffer.min_storage` (one maximum-size wire record); the
    /// default holds a full record plus a straddling partial one.
    record_storage: usize = RecordBuffer.recommended_storage,
    /// Handshake-message reassembly for flights that span records (large
    /// certificate chains, fragmented ClientHello). `null` uses the core's
    /// recommended size for the role. Too small surfaces as
    /// `error.HandshakeBufferTooShort`.
    reassembly_storage: ?usize = null,
    /// Decrypted-plaintext look-ahead for the read side. This is the reader's
    /// buffer capacity, so it bounds `Io.Reader.peek(n)`, `takeInt`, and
    /// `takeDelimiterInclusive` line length: those return
    /// `error.StreamTooLong` (or assert) past it. Must be at least
    /// `ztls.frame.max_plaintext_len` so one whole record always fits.
    read_buffer: usize = frame.max_plaintext_len,
    /// Plaintext staging for the write side. One `flush` of a full buffer is
    /// one TLS record; larger writes split across records.
    write_buffer: usize = frame.max_plaintext_len,
    /// Bytes reserved to retain the verified peer certificate chain for
    /// `info().peer_chain`. `null` (the default) does not retain it:
    /// `peer_chain` is empty and a client Stream is ~64 KB smaller. Set to
    /// `ztls.ClientHandshake.recommended_handshake_storage` to hold any chain
    /// the core will accept. Client-side only.
    peer_chain_storage: ?usize = null,
    /// Bytes reserved to retain the verified client leaf certificate DER for
    /// `info().client_identity` on a server that requested client
    /// authentication. `null` (the default) verifies and discards the leaf:
    /// `client_identity` is null. Server-side only; a client Stream is
    /// unaffected. Too small for the presented leaf surfaces as
    /// `error.HandshakeBufferTooShort` from `accept`.
    client_identity_storage: ?usize = null,
};

// ───────────────────────────────
// Error sets
// ───────────────────────────────

/// Handshake failures, coarsened from the ~90-variant core sets. Each variant
/// says who is at fault and what a caller can do about it; the mapping is
/// `classify` below.
pub const ConnectError = error{
    /// The server certificate chain, hostname, validity window, or
    /// CertificateVerify signature did not authenticate.
    CertificateVerificationFailed,
    /// A Finished MAC or record AEAD tag failed to verify. The peer could not
    /// prove possession of the negotiated keys.
    TlsDecryptError,
    /// The peer aborted the handshake with a fatal alert.
    TlsAlertReceived,
    /// The peer sent a malformed, unexpected, or illegal handshake message.
    HandshakeProtocolError,
    /// The peer sent a record longer than RFC 8446 §5.1 permits.
    RecordOverflow,
    /// This Stream's `Config` buffers cannot hold the peer's handshake. Raise
    /// `record_storage` / `reassembly_storage`.
    HandshakeBufferTooShort,
    /// Caller-supplied `Options` are unusable: ALPN list shape, host length,
    /// an empty `client_credentials.cert_chain`, or a client signer whose
    /// scheme the server's CertificateRequest cannot carry.
    InvalidOptions,
    /// The libcrypto backend failed, a counter overflowed, or a ztls-std
    /// invariant was violated. Not attributable to the peer.
    InternalError,
    /// `verify == .system_bundle` and the trust-store load could not allocate.
    OutOfMemory,
} || net.Stream.Reader.Error || net.Stream.Writer.Error || Io.Cancelable || Io.UnexpectedError;

pub const AcceptError = error{
    /// `Options.cert_chain` is empty, or the core rejected the credentials.
    MissingCredentials,
    /// The client sent no certificate when one was required, or one the
    /// policy cannot accept. A verified certificate that does not fit
    /// `Config.client_identity_storage` is `HandshakeBufferTooShort`, not
    /// this.
    ClientCertificateRejected,
    /// The client certificate chain did not authenticate.
    CertificateVerificationFailed,
    TlsDecryptError,
    TlsAlertReceived,
    HandshakeProtocolError,
    /// No overlap between the client's cipher suites and ours.
    UnsupportedCipherSuite,
    /// ALPN was offered by both sides with no overlap.
    NoApplicationProtocol,
    RecordOverflow,
    HandshakeBufferTooShort,
    InvalidOptions,
    InternalError,
} || net.Stream.Reader.Error || net.Stream.Writer.Error || Io.Cancelable || Io.UnexpectedError;

/// The real cause behind an `error.ReadFailed` from `reader()`. The
/// `Io.Reader` vtable can only carry `ReadFailed`, so cancellation, transport
/// failures, and TLS failures are indistinguishable through it; recover which
/// one happened with `Stream.readError()`. Same convention as
/// `std.Io.net.Stream.Reader.err`.
pub const ReadError = error{
    /// `abort` stopped the connection before the peer closed it.
    TlsAborted,
    /// The TX epoch is unusable after an encrypted record failed to reach the
    /// transport completely. This can surface while RX answers KeyUpdate.
    TxPoisoned,
    /// The peer sent a fatal alert.
    TlsAlertReceived,
    /// A record failed to authenticate: AEAD tag or MAC mismatch.
    TlsDecryptError,
    /// The peer sent a malformed, unexpected, or illegal record.
    TlsProtocolError,
    /// The peer sent a record longer than RFC 8446 §5.1 permits.
    RecordOverflow,
    /// The peer spent `max_idle_records_per_refill` records without producing
    /// application data. RFC 8446 §5.1 rate-limits zero-length fragments
    /// nowhere, so this bound is what keeps a read from never returning.
    IdleRecordFlood,
    /// Backend failure, counter overflow, or a broken invariant on our side.
    InternalError,
    // Writer errors are reachable from the read path: KeyUpdate responses are
    // written while servicing a read. RFC 8446 §4.6.3.
} || net.Stream.Reader.Error || net.Stream.Writer.Error || Io.Cancelable || Io.UnexpectedError;

/// The real cause behind an `error.WriteFailed` from `writer()`. Recover it
/// with `Stream.writeError()`.
const ControlWriteError = error{
    /// `abort` stopped the connection before the write completed.
    TlsAborted,
    /// An encrypted record failed to reach the transport completely. Its
    /// sequence number cannot be reused, so all later TX operations fail.
    TxPoisoned,
    /// The peer sent a malformed record, or application data was written
    /// before the handshake completed.
    TlsProtocolError,
    /// Backend failure, counter overflow, or a broken invariant on our side.
    InternalError,
} || net.Stream.Writer.Error || Io.Cancelable || Io.UnexpectedError;

pub const WriteError = ControlWriteError || error{
    /// The write side is already closed by `closeWrite` or `close`.
    TlsClosed,
};

/// Negotiated connection properties. Slices are borrowed and valid until
/// `deinit`.
pub const Info = struct {
    cipher_suite: ztls.CipherSuite,
    alpn: ?[]const u8,
    /// Verified peer certificates, leaf first. Empty unless
    /// `Config.peer_chain_storage` was set (client-side).
    peer_chain: []const []const u8,
    /// Verified client leaf certificate DER, server-side only, when client
    /// authentication was requested, the client presented a certificate, and
    /// `Config.client_identity_storage` was set. Null otherwise — including
    /// on a client Stream and after an optional client sent no certificate.
    client_identity: ?[]const u8,
};

// ───────────────────────────────
// Transport helpers
// ───────────────────────────────

// `Io` has no unbuffered stream read/write on `net.Stream` itself; the vtable
// hooks below are what `std.Io.net.Stream.Reader`/`Writer` call internally.
// Going straight to them keeps the record buffer as the only staging layer
// instead of copying through a second one.

/// Read from a net.Stream into buf. Returns 0 on transport EOF.
fn transportRead(io: Io, handle: net.Socket.Handle, buf: []u8) net.Stream.Reader.Error!usize {
    var data: [1][]u8 = .{buf};
    return io.vtable.netRead(io.userdata, handle, &data);
}

/// Write all bytes to a net.Stream, looping on partial writes.
fn transportWriteAll(
    io: Io,
    handle: net.Socket.Handle,
    bytes: []const u8,
) net.Stream.Writer.Error!void {
    var rest = bytes;
    while (rest.len != 0) {
        const data: [1][]const u8 = .{rest};
        const n = try io.vtable.netWrite(io.userdata, handle, "", &data, 1);
        rest = rest[n..];
    }
}

// ───────────────────────────────
// Core error classification
// ───────────────────────────────

fn mapClientHandshakeError(err: HandshakeError) ConnectError {
    // Client-credential faults are the caller's configuration, not the peer's
    // and not a buffer-sizing problem: a signer whose scheme the server never
    // offered, a signature larger than its scratch, or a chain that cannot fit
    // one record's plaintext (RFC 8446 §4.3.2, §5.2). `BufferTooShort` is
    // reachable on this path only from the credential flight — the wrapper's
    // own buffers are comptime-sized to the
    // core's needs — so it is pinned here rather than left in the generic
    // `.buffer` bucket, where it would misreport a bad `client_credentials`
    // as `HandshakeBufferTooShort`.
    switch (err) {
        error.SignatureSchemeNotOffered, error.BufferTooShort => return error.InvalidOptions,
        else => {},
    }
    return switch (classify(err)) {
        .certificate => error.CertificateVerificationFailed,
        .decrypt => error.TlsDecryptError,
        .alert => error.TlsAlertReceived,
        .record_overflow => error.RecordOverflow,
        .buffer => error.HandshakeBufferTooShort,
        .options => error.InvalidOptions,
        .internal, .missing_credentials, .client_certificate => error.InternalError,
        // A client that reaches these got them from the server picking
        // something it was never offered — RFC 8446 §4.1.3 makes that
        // illegal_parameter, not a negotiation outcome.
        .protocol, .no_alpn, .unsupported_suite => error.HandshakeProtocolError,
    };
}

/// Post-handshake projection of the same table. Certificate and negotiation
/// classes are unreachable once connected, but they collapse to a peer-fault
/// bucket rather than getting a special case.
fn mapReadError(err: HandshakeError) ReadError {
    return switch (classify(err)) {
        .alert => error.TlsAlertReceived,
        .decrypt => error.TlsDecryptError,
        .record_overflow => error.RecordOverflow,
        .certificate,
        .protocol,
        .no_alpn,
        .unsupported_suite,
        => error.TlsProtocolError,
        .buffer,
        .options,
        .internal,
        .missing_credentials,
        .client_certificate,
        => error.InternalError,
    };
}

fn mapWriteError(err: HandshakeError) error{ TlsProtocolError, InternalError } {
    return switch (classify(err)) {
        .certificate,
        .protocol,
        .no_alpn,
        .unsupported_suite,
        .alert,
        .decrypt,
        .record_overflow,
        => error.TlsProtocolError,
        .buffer,
        .options,
        .internal,
        .missing_credentials,
        .client_certificate,
        => error.InternalError,
    };
}

/// The peer-visible reason for a handshake failure, or null when nothing
/// should be sent: the peer already aborted, and RFC 8446 §6.2 says close
/// without more data. Goes through the canonical per-error ztls table rather
/// than the coarse `classify` bucket, so the peer receives the specific alert
/// TLS defines — `unknown_ca` for an untrusted chain, `certificate_expired`
/// for an expired one, `decrypt_error` for a failed CertificateVerify —
/// instead of a generic `bad_certificate`.
fn alertForHandshakeError(err: HandshakeError) ?alert.Description {
    return switch (err) {
        error.PeerAlert => null,
        else => alert.alertForError(err),
    };
}

fn mapServerHandshakeError(err: HandshakeError) AcceptError {
    return switch (classify(err)) {
        .certificate => error.CertificateVerificationFailed,
        .decrypt => error.TlsDecryptError,
        .alert => error.TlsAlertReceived,
        .protocol => error.HandshakeProtocolError,
        .record_overflow => error.RecordOverflow,
        .buffer => error.HandshakeBufferTooShort,
        .options => error.InvalidOptions,
        .internal => error.InternalError,
        .no_alpn => error.NoApplicationProtocol,
        .unsupported_suite => error.UnsupportedCipherSuite,
        .missing_credentials => error.MissingCredentials,
        .client_certificate => error.ClientCertificateRejected,
    };
}

// ───────────────────────────────
// Generic Stream
// ───────────────────────────────

/// The Reader vtable Error maps all TLS-specific failures to ReadFailed and
/// clean close_notify to EndOfStream, matching the Io.Reader contract.
const ReaderError = error{ ReadFailed, EndOfStream };
const WriterError = error{WriteFailed};

const Role = enum { client, server };

/// Records a peer may spend in one refill without producing application data.
///
/// RFC 8446 §5.1 permits zero-length `application_data` fragments as a
/// traffic-analysis countermeasure and puts no rate limit on them, so a peer
/// can otherwise keep a `read` call from ever returning. The core already caps
/// KeyUpdate and NewSessionTicket floods (`TooManyKeyUpdates`,
/// `TooManyNewSessionTickets`); this covers what it does not count.
const max_idle_records_per_refill = 64;

/// Client connection options. See `Client.connect`.
const ClientOptions = struct {
    /// SNI + certificate hostname (SAN/CN) to verify. Required for real
    /// verification; null disables BOTH SNI and hostname verification
    /// (ztls `host_name = null`).
    host: ?[]const u8 = null,
    /// Certificate verification policy. No default: a TLS client should not be
    /// able to skip this decision by omission.
    verify: Verify,
    /// ALPN protocols to offer (e.g. &.{ "h2", "http/1.1" }). Borrowed.
    alpn: []const []const u8 = &.{},
    /// Offer an X25519MLKEM768 hybrid key share (PQ). False by default.
    offer_pq_key_share: bool = false,
    /// Present this certificate chain (DER, leaf first) and sign
    /// CertificateVerify when the server sends a CertificateRequest. Without
    /// credentials the client sends an empty Certificate instead. An empty
    /// chain is rejected as `InvalidOptions` before any wire I/O. Borrowed
    /// for the handshake. RFC 8446 §4.4.2, §4.4.3.
    client_credentials: ?ClientCredentials = null,
};

/// Server connection options. See `Server.accept`.
const ServerOptions = struct {
    /// Certificate chain, leaf first, DER. Borrowed for the connection's life.
    cert_chain: []const []const u8,
    /// Signer for CertificateVerify. Obtained from
    /// `var key: ztls.signature.PrivateKey = try .fromP256Scalar(scalar);
    ///  defer key.deinit(); key.signer()` — the `PrivateKey` must outlive
    /// the handshake (caller-owned). Borrowed.
    signer: ztls.signature.Signer,
    /// ALPN protocols supported. Borrowed.
    alpn: []const []const u8 = &.{},
    /// Client-certificate authentication policy. Default `.none`. A non-none
    /// mode requires a `ClientTrust` decision — no system-bundle path, no
    /// separate insecure flag. RFC 8446 §4.4.2.
    client_auth: ClientAuth = .none,
};

fn StreamImpl(comptime Hs: type, comptime role: Role, comptime config: Config) type {
    comptime {
        if (config.record_storage < RecordBuffer.min_storage) @compileError(
            "Config.record_storage must be at least ztls.RecordBuffer.min_storage",
        );
        if (config.read_buffer < frame.max_plaintext_len) @compileError(
            "Config.read_buffer must be at least ztls.frame.max_plaintext_len",
        );
        if (config.write_buffer == 0) @compileError("Config.write_buffer must be nonzero");
    }

    const Flag = enum(u3) {
        /// close_notify received, or the transport hit EOF: reads are done.
        rx_closed,
        /// close_notify sent: writes are done.
        tx_closed,
        /// Socket released and buffers zeroed.
        closed,
        /// `abort` requested transport shutdown.
        aborted,
        /// RX received KeyUpdate(update_requested), but TX has not answered.
        tx_update_pending,
        /// An encrypted record did not reach the transport completely.
        tx_poisoned,
        /// A reader vtable call is active.
        rx_busy,
        /// A writer vtable call is active.
        tx_busy,
    };

    const RecordStorage = ztls.Array(config.record_storage);
    const Reassembly = ztls.Array(config.reassembly_storage orelse Hs.Storage.capacity);
    const ReadStorage = ztls.Array(config.read_buffer);
    const WriteStorage = ztls.Array(config.write_buffer);

    const retain_peer_chain = role == .client and config.peer_chain_storage != null;
    const PeerChainStorage = if (retain_peer_chain)
        ztls.Array(config.peer_chain_storage.?)
    else
        void;

    const retain_client_identity = role == .server and config.client_identity_storage != null;
    const ClientIdentityStorage = if (retain_client_identity)
        ztls.Array(config.client_identity_storage.?)
    else
        void;

    return struct {
        const Self = @This();
        const ReaderEvent = union(enum) {
            application_data: []const u8,
            key_update: Hs.KeyUpdateRequest,
            none,
            closed,
        };

        // The client alone receives NewSessionTicket. Normalize that difference
        // at the engine boundary so the record loop has one event switch.
        fn normalizeReaderEvent(event: Hs.ReceiveEvent) ReaderEvent {
            return if (role == .client) switch (event) {
                .application_data => |data| .{ .application_data = data },
                .key_update => |request| .{ .key_update = request },
                .new_session_ticket, .none => .none,
                .closed => .closed,
            } else switch (event) {
                .application_data => |data| .{ .application_data = data },
                .key_update => |request| .{ .key_update = request },
                .none => .none,
                .closed => .closed,
            };
        }

        pub const Handshake = Hs;
        pub const Options = if (role == .client) ClientOptions else ServerOptions;
        /// The `Config` this Stream type was instantiated with.
        pub const buffers = config;

        sock: net.Stream,
        io: Io,
        hs: Hs,
        storage: RecordStorage,
        rb: RecordBuffer,
        out: Hs.OutBuffer,
        reassembly: Reassembly = .empty,
        read_storage: ReadStorage = .empty,
        write_storage: WriteStorage = .empty,
        peer_chain_storage: PeerChainStorage = if (retain_peer_chain) .empty else {},
        client_identity_storage: ClientIdentityStorage = if (retain_client_identity) .empty else {},
        /// Decrypted application data from the current record that has not been
        /// handed to the caller yet. Slices into `storage`, which `rb.next()`
        /// and `rb.writable()` invalidate — so the record loop must not run
        /// while this is non-empty.
        pending: []const u8 = &.{},
        reader_impl: Reader,
        writer_impl: Writer,
        state: std.atomic.Value(u8) = .init(0),
        tx_mutex: Io.Mutex = .init,
        /// Set by `finishInit` to catch a moved or copied Stream. `rb`, the
        /// reassembly buffer, and both `Io` interfaces point into this struct,
        /// so relocating the value silently corrupts memory. Checked with
        /// `assert`, so it costs nothing in ReleaseFast.
        pinned: *const Self = undefined,
        fn assertPinned(s: *const Self) void {
            assert(s.pinned == s);
        }

        fn flagMask(flag: Flag) u8 {
            return @as(u8, 1) << @intFromEnum(flag);
        }

        fn hasFlag(s: *const Self, flag: Flag) bool {
            return s.state.load(.acquire) & flagMask(flag) != 0;
        }

        fn setFlag(s: *Self, flag: Flag) void {
            _ = s.state.fetchOr(flagMask(flag), .acq_rel);
        }

        fn clearFlag(s: *Self, flag: Flag) void {
            _ = s.state.fetchAnd(~flagMask(flag), .release);
        }

        fn acquireHalf(s: *Self, flag: Flag) void {
            assert(flag == .rx_busy or flag == .tx_busy);
            const previous = s.state.fetchOr(flagMask(flag), .acq_rel);
            assert(previous & flagMask(flag) == 0);
        }

        fn releaseHalf(s: *Self, flag: Flag) void {
            assert(s.hasFlag(flag));
            s.clearFlag(flag);
        }

        /// True once no further application data can be sent: `close_notify`
        /// went out, or the whole connection was torn down. RFC 8446 §6.1 lets
        /// each direction close independently, which is why this is one of two.
        fn writeClosed(s: *const Self) bool {
            return s.hasFlag(.tx_closed) or s.hasFlag(.closed);
        }

        /// True once no further application data can arrive: the peer's
        /// `close_notify` landed, the transport hit EOF, or the connection was
        /// torn down.
        fn readClosed(s: *const Self) bool {
            return s.hasFlag(.rx_closed) or s.hasFlag(.closed);
        }

        pub const Reader = struct {
            interface: Io.Reader,
            /// The cause behind the most recent `error.ReadFailed`. Only
            /// meaningful after the interface returned one; never cleared, like
            /// `std.Io.net.Stream.Reader.err`. Read it via `readError()`.
            err: ?ReadError = null,

            pub fn init(s: *Self) Reader {
                return .{
                    .interface = .{
                        .vtable = &.{ .stream = streamImpl },
                        .buffer = &s.read_storage.data,
                        .seek = 0,
                        .end = 0,
                    },
                };
            }

            /// Copy decrypted application data into `io_w`, driving the record
            /// loop when nothing is pending.
            ///
            /// This honors the `Io.Reader.stream` contract instead of
            /// repointing `io_r.buffer` at the record in place. Repointing is
            /// tempting — it removes the copy — but it makes the reader's
            /// capacity equal to the current record's length, which breaks
            /// every stdlib path that buffers across records: `peek`,
            /// `takeInt`, `takeDelimiterInclusive` and friends either assert or
            /// silently drop the unconsumed tail. Writing through `io_w` keeps
            /// the one copy the caller's destination needs anyway, and
            /// `stream`-to-a-writer still moves record bytes straight to the
            /// sink.
            fn streamImpl(
                io_r: *Io.Reader,
                io_w: *Io.Writer,
                limit: Io.Limit,
            ) Io.Reader.StreamError!usize {
                const r: *Reader = @alignCast(@fieldParentPtr("interface", io_r));
                const s: *Self = @alignCast(@fieldParentPtr("reader_impl", r));
                s.assertPinned();
                s.acquireHalf(.rx_busy);
                defer s.releaseHalf(.rx_busy);

                if (s.hasFlag(.aborted)) return s.failRead(error.TlsAborted);
                if (s.pending.len == 0) s.pending = try nextApplicationData(s);
                // A short or zero-length write leaves the remainder pending for
                // the next call; nothing is dropped on error either, because
                // `pending` only advances by what was accepted.
                const n = io_w.write(limit.sliceConst(s.pending)) catch |err| {
                    // WriteFailed here is the destination's problem, not ours,
                    // so it is passed through without touching `err`.
                    return err;
                };
                s.pending = s.pending[n..];
                return n;
            }

            /// Drive the record loop until the peer sends application data.
            /// Post-handshake control records (KeyUpdate, NewSessionTicket) are
            /// handled here and never surface to the caller. `EndOfStream` is a
            /// clean `close_notify` or a transport EOF without one.
            fn nextApplicationData(s: *Self) ReaderError![]const u8 {
                assert(s.pending.len == 0);
                // RFC 8446 §6.1 — after close_notify or close(), reads end.
                if (s.readClosed()) return error.EndOfStream;

                var idle: usize = 0;
                while (true) {
                    while (true) {
                        const record = (s.rb.next() catch |err|
                            return s.failRead(mapReadError(err))) orelse break;
                        if (idle == max_idle_records_per_refill)
                            return s.failRead(error.IdleRecordFlood);
                        idle += 1;
                        const ev = s.hs.receiveRecord(record) catch |err| {
                            return s.failRead(mapReadError(err));
                        };
                        switch (normalizeReaderEvent(ev)) {
                            .none => continue,
                            .key_update => |request| {
                                if (request == .update_requested) {
                                    // Publish before waiting for the TX lease.
                                    // A writer that owns the lease already is
                                    // the previous record in wire order.
                                    s.setFlag(.tx_update_pending);
                                    s.flushRequestedKeyUpdate() catch |err|
                                        return s.failRead(err);
                                }
                                continue;
                            },
                            .closed => {
                                s.setFlag(.rx_closed);
                                return error.EndOfStream;
                            },
                            .application_data => |app_data| {
                                // RFC 8446 §5.1 — zero-length app-data
                                // fragments are legal and carry no bytes.
                                if (app_data.len == 0) continue;
                                return app_data;
                            },
                        }
                    }

                    const n = transportRead(
                        s.io,
                        s.sock.socket.handle,
                        s.rb.writable(),
                    ) catch |err| {
                        if (s.hasFlag(.aborted)) return s.failRead(error.TlsAborted);
                        return s.failRead(err);
                    };
                    if (n == 0) {
                        if (s.hasFlag(.aborted)) return s.failRead(error.TlsAborted);
                        s.setFlag(.rx_closed);
                        return error.EndOfStream;
                    }
                    s.rb.advance(n);
                }
            }
        };

        pub const Writer = struct {
            interface: Io.Writer,
            /// The cause behind the most recent `error.WriteFailed`. Only
            /// meaningful after the interface returned one; never cleared.
            /// Read it via `writeError()`.
            err: ?WriteError = null,

            pub fn init(s: *Self) Writer {
                return .{
                    .interface = .{
                        .vtable = &.{ .drain = drainImpl },
                        .buffer = &s.write_storage.data,
                    },
                };
            }
        };

        /// Borrowed `*Io.Reader` for one reader task. It can run concurrently
        /// with the single writer task.
        pub fn reader(s: *Self) *Io.Reader {
            s.assertPinned();
            return &s.reader_impl.interface;
        }

        /// Borrowed `*Io.Writer` for one writer task. It can run concurrently
        /// with the single reader task.
        pub fn writer(s: *Self) *Io.Writer {
            s.assertPinned();
            return &s.writer_impl.interface;
        }

        /// Why the last read failed. `Io.Reader` collapses every failure into
        /// `error.ReadFailed`, so cancellation (`error.Canceled`), a dead
        /// transport, and a TLS failure are otherwise indistinguishable. Call
        /// this after `ReadFailed`; the value is stale at any other time. Read
        /// it from the reader task or after that task joins.
        ///
        ///     r.fillMore() catch |err| switch (err) {
        ///         error.EndOfStream => {},           // clean close_notify
        ///         error.ReadFailed => switch (conn.readError().?) {
        ///             error.Canceled => {},           // task was cancelled
        ///             error.TlsDecryptError => {},    // record failed to auth
        ///             else => {},
        ///         },
        ///     };
        pub fn readError(s: *const Self) ?ReadError {
            return s.reader_impl.err;
        }

        /// Why the last write failed. Same contract as `readError`. Read it
        /// from the writer task or after that task joins.
        pub fn writeError(s: *const Self) ?WriteError {
            return s.writer_impl.err;
        }

        /// The underlying socket handle, for readiness multiplexing (`poll`,
        /// `epoll`, `kqueue`) or kTLS setup. Reading or writing it directly
        /// desynchronizes the record layer.
        pub fn socketHandle(s: *const Self) net.Socket.Handle {
            s.assertPinned();
            return s.sock.socket.handle;
        }

        /// ALPN protocol selected by the peer, or null. Valid after handshake.
        pub fn selectedAlpn(s: *const Self) ?[]const u8 {
            s.assertPinned();
            return s.hs.selectedAlpnProtocol();
        }

        /// Negotiated connection properties. Valid after connect or accept.
        pub fn info(s: *const Self) Info {
            s.assertPinned();
            return .{
                .cipher_suite = s.hs.cipherSuite(),
                .alpn = s.hs.selectedAlpnProtocol(),
                .peer_chain = if (retain_peer_chain) s.hs.peerCertificateChain() else &.{},
                // The core only retains the leaf after the authenticated
                // connected state, and only into storage `finishInit` lent it.
                .client_identity = if (retain_client_identity)
                    s.hs.clientCertificateDer()
                else
                    null,
            };
        }

        /// True when a read can return data without touching the transport:
        /// decrypted bytes are pending, or a complete record is already
        /// buffered. The reader task owns this query. Poll-style loops use it
        /// to drain coalesced records without a transport read.
        pub fn hasBuffered(s: *Self) bool {
            s.assertPinned();
            return s.pending.len > 0 or
                s.reader_impl.interface.bufferedLen() > 0 or
                s.rb.hasRecord();
        }

        /// Flush staged plaintext, send `close_notify`, and keep the read side
        /// open for the peer's response. Idempotent.
        ///
        /// The flush is a safety net, not a substitute for flushing. Callers
        /// inspect `writeError()` when delivery matters.
        ///
        /// The writer task owns this operation. RFC 8446 §6.1 permits each
        /// direction to close independently.
        pub fn closeWrite(s: *Self) void {
            s.assertPinned();
            if (s.writeClosed() or s.hasFlag(.aborted)) return;

            // Staged plaintext goes out before close_notify. Discarding bytes
            // the caller already handed to the Writer would be silent data
            // loss, and close_notify must be the last record we send.
            s.writer_impl.interface.flush() catch {
                s.setFlag(.tx_closed);
                return;
            };

            s.tx_mutex.lockUncancelable(s.io);
            defer s.tx_mutex.unlock(s.io);

            if (s.writeClosed() or s.hasFlag(.aborted)) return;
            if (s.hasFlag(.tx_poisoned)) {
                s.writer_impl.err = error.TxPoisoned;
                s.setFlag(.tx_closed);
                return;
            }
            s.flushRequestedKeyUpdateLocked() catch |err| {
                s.writer_impl.err = err;
                s.setFlag(.tx_closed);
                return;
            };

            s.setFlag(.tx_closed);
            const record = s.hs.sendAlert(.close_notify, &s.out.buffer) catch |err| {
                s.writer_impl.err = mapWriteError(err);
                return;
            };
            s.writePreparedRecord(record) catch |err| {
                s.writer_impl.err = err;
            };
        }

        /// Wake blocked read and write operations without destroying their
        /// state. This function is idempotent and safe during either half.
        /// Join both tasks before `close()` or `deinit()`; do not race abort
        /// against either teardown operation.
        pub fn abort(s: *Self) void {
            if (s.hasFlag(.closed)) return;
            s.assertPinned();
            if (s.hasFlag(.aborted)) return;
            s.setFlag(.aborted);
            // ziglint-ignore: Z026 -- the state records abort even if the
            // platform reports that the socket is already down.
            s.sock.shutdown(s.io, .both) catch {};
        }

        /// Flush, send `close_notify`, and close the underlying socket.
        /// Idempotent. Does not drain application data the peer may still be
        /// sending. The caller must join both halves before this call. This
        /// ownership check is an assertion and is absent in ReleaseFast.
        pub fn close(s: *Self) void {
            s.assertPinned();
            if (s.hasFlag(.closed)) return;
            assert(!s.hasFlag(.rx_busy));
            assert(!s.hasFlag(.tx_busy));
            s.closeWrite();
            s.teardown();
        }

        /// Always-callable teardown after both halves join. It closes the
        /// socket and clears every wrapper-owned buffer. It is idempotent after
        /// a failed `connect` or `accept`. The join precondition is checked by
        /// assertions outside ReleaseFast.
        pub fn deinit(s: *Self) void {
            if (s.hasFlag(.closed)) return;
            s.assertPinned();
            assert(!s.hasFlag(.rx_busy));
            assert(!s.hasFlag(.tx_busy));
            s.teardown();
        }

        /// Zeroing the buffers is this type's job, not the engine's: ztls hands
        /// lent storage back untouched by design (#81), and every buffer here is
        /// declared by the Stream. The record and read buffers held decrypted
        /// application plaintext, so nobody else is going to do it.
        fn teardown(s: *Self) void {
            s.setFlag(.closed);
            s.pending = &.{};
            s.sock.close(s.io);
            s.storage.secureZero();
            s.out.secureZero();
            s.reassembly.secureZero();
            s.read_storage.secureZero();
            s.write_storage.secureZero();
            if (retain_peer_chain) s.peer_chain_storage.secureZero();
            if (retain_client_identity) s.client_identity_storage.secureZero();
            s.hs.deinit();
        }

        /// Record why a read failed, then return the only error the `Io.Reader`
        /// vtable can carry. `std.Io.net.Stream.Reader` does the same thing with
        /// its own `err` field.
        fn failRead(s: *Self, cause: ReadError) error{ReadFailed} {
            s.reader_impl.err = cause;
            return error.ReadFailed;
        }

        /// Write-side counterpart of `failRead`.
        fn failWrite(s: *Self, cause: WriteError) error{WriteFailed} {
            s.writer_impl.err = cause;
            return error.WriteFailed;
        }

        /// Send an engine-produced record and settle the pending-write latch
        /// only after every wire byte reaches the transport.
        fn writePreparedRecord(s: *Self, bytes: []const u8) ControlWriteError!void {
            transportWriteAll(s.io, s.sock.socket.handle, bytes) catch |err| {
                s.setFlag(.tx_poisoned);
                if (s.hasFlag(.aborted)) return error.TlsAborted;
                return err;
            };
            s.hs.completeWrite();
        }

        /// Answer a received KeyUpdate request. RFC 8446 §4.6.3, §5.2.
        /// RX publishes before it waits for this mutex. The active lease is
        /// therefore earlier in wire order. Every later TX boundary observes
        /// the flag under this lease before application data or close_notify.
        fn flushRequestedKeyUpdate(s: *Self) ControlWriteError!void {
            s.tx_mutex.lock(s.io) catch |err| {
                if (s.hasFlag(.aborted)) return error.TlsAborted;
                return err;
            };
            defer s.tx_mutex.unlock(s.io);
            return s.flushRequestedKeyUpdateLocked();
        }

        fn flushRequestedKeyUpdateLocked(s: *Self) ControlWriteError!void {
            if (!s.hasFlag(.tx_update_pending)) return;
            if (s.hasFlag(.aborted)) return error.TlsAborted;
            if (s.hasFlag(.tx_poisoned)) return error.TxPoisoned;
            if (s.writeClosed()) {
                // RFC 8446 §4.6.3 requires the response only before the next
                // application record. close_notify was already our last TX.
                s.clearFlag(.tx_update_pending);
                return;
            }

            const record = s.hs.sendKeyUpdate(
                &s.out.buffer,
                .update_not_requested,
            ) catch |err| {
                s.setFlag(.tx_poisoned);
                return mapWriteError(err);
            };
            try s.writePreparedRecord(record);
            s.clearFlag(.tx_update_pending);
        }

        /// RFC 8446 §6.2 — best effort. A failed alert write cannot change the
        /// outcome, and a latched pending write means the engine cannot encode
        /// one at all.
        fn sendFatalAlert(s: *Self, description: alert.Description) void {
            if (s.hs.sendAlert(description, &s.out.buffer)) |record| {
                // ziglint-ignore: Z026 -- the handshake already failed; a
                // failed courtesy alert cannot change the reported error.
                s.writePreparedRecord(record) catch {};
            } else |_| {}
        }

        /// Handshake failures for this role. Transport failures do not come
        /// through here: they are already in the public set, and an alert
        /// cannot reach a peer whose socket just failed.
        const HandshakeFailure = if (role == .client) ConnectError else AcceptError;

        /// Report a handshake failure to the peer (RFC 8446 §6.2), then coarsen
        /// it for the caller.
        fn handshakeFailure(s: *Self, err: HandshakeError) HandshakeFailure {
            if (alertForHandshakeError(err)) |description| s.sendFatalAlert(description);
            return if (role == .client)
                mapClientHandshakeError(err)
            else
                mapServerHandshakeError(err);
        }

        /// Drive the client handshake to completion. RFC 8446 Appendix A.1.
        fn driveClientHandshake(s: *Self) ConnectError!void {
            const io = s.io;
            const handle = s.sock.socket.handle;

            const ch = s.hs.start(&s.out.buffer) catch |err| return s.handshakeFailure(err);
            try transportWriteAll(io, handle, ch);
            s.hs.completeWrite();

            while (!s.hs.isConnected()) {
                const n = try transportRead(io, handle, s.rb.writable());
                // The peer hung up mid-handshake. RFC 8446 §6.1 requires
                // close_notify; a bare FIN here is a truncated handshake, not a
                // clean shutdown.
                if (n == 0) return s.handshakeFailure(error.UnexpectedEof);
                s.rb.advance(n);

                while (true) {
                    // Stop once connected — remaining records (app data,
                    // session tickets) belong to the Reader.
                    if (s.hs.isConnected()) break;
                    const record = s.rb.next() catch |err| return s.handshakeFailure(err);
                    const ev = s.hs.handleRecord(record orelse break, &s.out.buffer) catch |err|
                        return s.handshakeFailure(err);
                    switch (ev) {
                        .write => |bytes| {
                            try transportWriteAll(io, handle, bytes);
                            s.hs.completeWrite();
                        },
                        .none => {},
                        .application_data,
                        .closed,
                        .key_update,
                        .new_session_ticket,
                        => return s.handshakeFailure(error.UnexpectedRecord),
                    }
                }
            }
        }

        /// Drive the server handshake to completion. RFC 8446 Appendix A.2.
        fn driveServerHandshake(s: *Self) AcceptError!void {
            const io = s.io;
            const handle = s.sock.socket.handle;

            while (!s.hs.isConnected()) {
                const n = try transportRead(io, handle, s.rb.writable());
                if (n == 0) return s.handshakeFailure(error.UnexpectedEof);
                s.rb.advance(n);

                while (true) {
                    // Stop once connected — app data sent right after Finished
                    // belongs to the Reader.
                    if (s.hs.isConnected()) break;
                    const record = s.rb.next() catch |err| return s.handshakeFailure(err);
                    const ev = s.hs.handleRecord(record orelse break, &s.out.buffer) catch |err| {
                        // A failed handshake cannot expose connected APIs. In
                        // particular, local client-identity retention failure
                        // must happen before the core commits its state.
                        assert(!s.hs.isConnected());
                        return s.handshakeFailure(err);
                    };
                    switch (ev) {
                        .write => |hello| {
                            try transportWriteAll(io, handle, hello);
                            s.hs.completeWrite();
                            // ServerHello went out in the clear; the rest of
                            // the flight is encrypted under handshake keys.
                            const flight = s.hs.sendServerFlightBuffered(&s.out) catch |err|
                                return s.handshakeFailure(err);
                            if (flight) |bytes| {
                                try transportWriteAll(io, handle, bytes);
                                s.hs.completeWrite();
                            }
                        },
                        .none => {},
                        .application_data,
                        .closed,
                        .key_update,
                        => return s.handshakeFailure(error.UnexpectedRecord),
                    }
                }
            }
        }

        // ── Writer drain ──────────────

        fn drainImpl(io_w: *Io.Writer, data: []const []const u8, splat: usize) WriterError!usize {
            const w: *Writer = @alignCast(@fieldParentPtr("interface", io_w));
            const s: *Self = @alignCast(@fieldParentPtr("writer_impl", w));
            s.assertPinned();
            s.acquireHalf(.tx_busy);
            defer s.releaseHalf(.tx_busy);

            s.tx_mutex.lock(s.io) catch |err| {
                if (s.hasFlag(.aborted)) return s.failWrite(error.TlsAborted);
                return s.failWrite(err);
            };
            defer s.tx_mutex.unlock(s.io);

            if (s.hasFlag(.aborted)) return s.failWrite(error.TlsAborted);
            if (s.hasFlag(.tx_poisoned)) return s.failWrite(error.TxPoisoned);
            if (s.writeClosed()) return s.failWrite(error.TlsClosed);

            var total: usize = 0;

            // Buffered plaintext first, then each data slice, with the last
            // repeated `splat` times. `consume` subtracts the buffered part.
            const buffered = io_w.buffered();
            if (buffered.len > 0) {
                try sendPlaintextChunked(s, buffered);
                total += buffered.len;
            }
            if (data.len > 0) {
                for (data[0 .. data.len - 1]) |slice| {
                    try sendPlaintextChunked(s, slice);
                    total += slice.len;
                }
                const last = data[data.len - 1];
                for (0..splat) |_| {
                    try sendPlaintextChunked(s, last);
                    total += last.len;
                }
            }

            return io_w.consume(total);
        }

        /// Send one plaintext chunk (must be <= max_plaintext_len) as one
        /// TLS record. RFC 8446 §5.2.
        fn sendPlaintext(s: *Self, plaintext: []const u8) WriterError!void {
            assert(plaintext.len <= frame.max_plaintext_len);
            s.flushRequestedKeyUpdateLocked() catch |err| return s.failWrite(err);
            const record = s.hs.sendApplicationData(
                plaintext,
                &s.out.buffer,
            ) catch |err| return s.failWrite(mapWriteError(err));
            s.writePreparedRecord(record) catch |err| return s.failWrite(err);
        }

        /// Split plaintext across records when it exceeds one record payload.
        fn sendPlaintextChunked(s: *Self, plaintext: []const u8) WriterError!void {
            var rest = plaintext;
            while (rest.len > 0) {
                const chunk_len = @min(rest.len, frame.max_plaintext_len);
                try sendPlaintext(s, rest[0..chunk_len]);
                rest = rest[chunk_len..];
            }
        }

        // ── Init helpers ──────────────

        /// Apply one client-auth mode's core wiring: the policy tag, the
        /// trust anchors, and the wall clock client-certificate validity is
        /// checked against. RFC 8446 §4.4.2. Server role only (accept is the
        /// only caller, so a client instantiation never analyzes this).
        fn wireClientAuth(
            s: *Self,
            mode: ztls.ServerHandshake.ClientAuthPolicy,
            trust: ClientTrust,
            io: Io,
        ) void {
            s.hs.client_auth = mode;
            switch (trust) {
                .bundle => |b| s.hs.client_cert_policy.bundle = b,
                .insecure => s.hs.client_cert_policy.insecure_no_chain_anchor = true,
            }
            s.hs.client_cert_policy.now_sec = Io.Timestamp.now(io, .real).toSeconds();
        }

        fn init(io: Io, sock: net.Stream, hs: Hs) Self {
            return .{
                .sock = sock,
                .io = io,
                .hs = hs,
                .storage = .empty,
                .rb = undefined, // patched in finishInit
                .out = .empty,
                .reader_impl = undefined, // patched in finishInit
                .writer_impl = undefined, // patched in finishInit
            };
        }

        /// Wire up everything that points into `s`. After this the value must
        /// not be moved or copied.
        fn finishInit(s: *Self) void {
            s.pinned = s;
            s.rb = .init(&s.storage.data);
            s.hs.useHandshakeBuffer(&s.reassembly.data);
            if (retain_peer_chain) s.hs.usePeerCertificateBuffer(&s.peer_chain_storage.data);
            if (retain_client_identity)
                s.hs.useClientCertificateBuffer(&s.client_identity_storage.data);
            s.reader_impl = .init(s);
            s.writer_impl = .init(s);
        }

        /// The pre-init failure path (`connect`/`accept` keygen, #88): `s.*`
        /// is still the caller's `undefined`, so the flag word — the one
        /// field `deinit` reads — is initialized by hand to keep the
        /// documented failure contract (a later `deinit` is a no-op), and
        /// the owned socket is closed before the error is returned.
        /// Never use on an initialized stream; use `deinit` instead.
        pub fn abortBeforeInit(s: *Self, io: Io, sock: net.Stream) void {
            sock.close(io);
            s.state = .init(flagMask(.closed));
        }

        /// Client only. Wrap a CONNECTED `std.Io.net.Stream` and run the TLS
        /// 1.3 handshake to completion. Moves the socket into `s`. Eager: all
        /// handshake errors (cert verification, ALPN no-overlap, alerts)
        /// surface here rather than leaking into the first read.
        ///
        /// On failure the peer gets a fatal alert where one is warranted, the
        /// socket is closed, and buffers are zeroed — a later `deinit` is
        /// harmless but unnecessary. A local keygen failure (#88) predates
        /// in-place init; `abortBeforeInit` keeps the same contract there,
        /// and no secret has reached the buffers on that path.
        pub fn connect(
            s: *Self,
            io: Io,
            sock: net.Stream,
            options: Options,
        ) ConnectError!void {
            switch (role) {
                .client => {
                    var client_keypair: ztls.x25519.KeyPair = .generate();
                    defer client_keypair.secureZero();
                    var random: ztls.Random = .empty;
                    io.random(&random.data);
                    defer random.secureZero();

                    // Ours, not the peer's (#88): no alert, no protocol
                    // classification.
                    const keypairs: ztls.ClientHandshake.KeyPairs =
                        ztls.ClientHandshake.KeyPairs.init(client_keypair) catch |err| {
                            s.abortBeforeInit(io, sock);
                            return switch (err) {
                                error.LibcryptoFailed, error.IdentityElement => error.InternalError,
                            };
                        };

                    const hs: ztls.ClientHandshake = .init(.{
                        .keypairs = keypairs,
                        .host_name = options.host,
                        .now_sec = Io.Timestamp.now(io, .real).toSeconds(),
                        .random = random,
                        .alpn_protocols = options.alpn,
                        .offer_pq_key_share = options.offer_pq_key_share,
                    });

                    // In-place init before the next fallible step, so no
                    // error path past this point leaves `s` undefined.
                    s.* = .init(io, sock, hs);
                    s.finishInit();
                    errdefer s.deinit();

                    // RFC 8446 §4.4.2, §4.4.3 — credentials before any wire I/O.
                    // An empty chain is not a credential set; rejecting it
                    // here keeps the failure local (the server never sees a
                    // ClientHello) while the errdefer preserves the owned
                    // socket close and the deinit-is-a-no-op contract.
                    if (options.client_credentials) |creds| {
                        if (creds.cert_chain.len == 0) return error.InvalidOptions;
                        s.hs.setCredentials(creds.cert_chain, creds.signer);
                    }

                    // Defers unwind in reverse: policy pointer cleared first,
                    // then the bundle memory it referenced.
                    var bundle: crypto.Certificate.Bundle = .empty;
                    var bundle_gpa: ?mem.Allocator = null;
                    defer if (bundle_gpa) |gpa| bundle.deinit(gpa);
                    // TLS 1.3 only needs trust anchors during the handshake.
                    defer s.hs.policy.bundle = null;

                    switch (options.verify) {
                        .system_bundle => |gpa| {
                            bundle.rescan(gpa, io, Io.Timestamp.now(io, .real)) catch |err| {
                                return switch (err) {
                                    error.OutOfMemory => error.OutOfMemory,
                                    else => error.CertificateVerificationFailed,
                                };
                            };
                            bundle_gpa = gpa;
                            s.hs.policy.bundle = &bundle;
                        },
                        .bundle => |b| s.hs.policy.bundle = b,
                        .insecure => s.hs.policy.insecure_no_chain_anchor = true,
                    }

                    try s.driveClientHandshake();
                },
                .server => @compileError("connect is client-only; use accept on ztls_std.Server"),
            }
        }

        /// Server only. Wrap an ACCEPTED `std.Io.net.Stream` and run the
        /// server-side handshake to completion. Moves the socket into `s`.
        /// No allocator: the server presents a chain, it does not anchor one.
        ///
        /// Same failure contract as `connect`, including the keygen path
        /// (#88).
        pub fn accept(
            s: *Self,
            io: Io,
            sock: net.Stream,
            options: Options,
        ) AcceptError!void {
            switch (role) {
                .server => {
                    var server_keypair: ztls.x25519.KeyPair = .generate();
                    defer server_keypair.secureZero();
                    var random: ztls.Random = .empty;
                    io.random(&random.data);
                    defer random.secureZero();

                    // Ours, not the peer's (#88) — see `connect`.
                    const keypairs: ztls.ServerHandshake.KeyPairs =
                        ztls.ServerHandshake.KeyPairs.init(server_keypair) catch |err| {
                            s.abortBeforeInit(io, sock);
                            return switch (err) {
                                error.LibcryptoFailed, error.IdentityElement => error.InternalError,
                            };
                        };

                    const hs: ztls.ServerHandshake = .init(.{
                        .keypairs = keypairs,
                        .random = random,
                        .alpn_protocols = options.alpn,
                    });

                    s.* = .init(io, sock, hs);
                    s.finishInit();
                    errdefer s.deinit();

                    // Checked after in-place init so this error path is
                    // teardown-safe like every other one.
                    if (options.cert_chain.len == 0) return error.MissingCredentials;
                    s.hs.setCredentials(options.cert_chain, options.signer);

                    // Client trust is borrowed only while accept drives the
                    // handshake; the established connection retains the
                    // verified leaf, not the caller's trust bundle.
                    defer s.hs.client_cert_policy.bundle = null;
                    switch (options.client_auth) {
                        .none => {},
                        .optional => |trust| s.wireClientAuth(.optional, trust, io),
                        .required => |trust| s.wireClientAuth(.required, trust, io),
                    }

                    try s.driveServerHandshake();
                },
                .client => @compileError("accept is server-only; use connect on ztls_std.Client"),
            }
        }
    };
}

// ───────────────────────────────
// Client / Server
// ───────────────────────────────

/// A TLS 1.3 client connection with custom buffer sizing.
pub fn ClientWith(comptime config: Config) type {
    return StreamImpl(ztls.ClientHandshake, .client, config);
}

/// A TLS 1.3 server connection with custom buffer sizing.
pub fn ServerWith(comptime config: Config) type {
    return StreamImpl(ztls.ServerHandshake, .server, config);
}

/// A TLS 1.3 client connection with default buffers (~148 KB). Self-referential
/// and large: declare it `undefined`, initialize in place with `connect`, and
/// never move or copy the value afterward (the `std.Thread.Pool` pattern). A
/// moved Stream trips an assert in Debug/ReleaseSafe rather than corrupting
/// silently. Use `ClientWith` to resize the buffers.
pub const Client = ClientWith(.{});

/// A TLS 1.3 server connection with default buffers (~132 KB). Same placement
/// rules as `Client`.
pub const Server = ServerWith(.{});

// ───────────────────────────────
// Tests
// ───────────────────────────────
//
// Round-trip tests that need certificate fixtures live in `src/tests.zig` so
// the library module itself has no test-fixture dependency.

test "public error mapping: a cert failure never degrades to a protocol error" {
    try testing.expectEqual(
        ConnectError.CertificateVerificationFailed,
        mapClientHandshakeError(error.CertificateExpired),
    );
    try testing.expectEqual(
        ConnectError.TlsAlertReceived,
        mapClientHandshakeError(error.PeerAlert),
    );
    try testing.expectEqual(
        ConnectError.RecordOverflow,
        mapClientHandshakeError(error.RecordTooLarge),
    );
    // A server picking an unoffered suite is illegal_parameter for a client,
    // not a negotiation result.
    try testing.expectEqual(
        ConnectError.HandshakeProtocolError,
        mapClientHandshakeError(error.UnsupportedCipherSuite),
    );
    // The same core error is a real negotiation outcome for a server.
    try testing.expectEqual(
        AcceptError.UnsupportedCipherSuite,
        mapServerHandshakeError(error.UnsupportedCipherSuite),
    );
    try testing.expectEqual(
        AcceptError.MissingCredentials,
        mapServerHandshakeError(error.MissingServerCredentials),
    );
}

// RFC 8446 §4.3.2, §5.2 — client-credential faults are caller configuration:
// a signer scheme the server never offered, or a chain that cannot fit one
// record's plaintext. Reported as InvalidOptions, not blamed on the peer or
// on wrapper buffer sizing.
test "public error mapping: client-credential faults are InvalidOptions" {
    try testing.expectEqual(
        ConnectError.InvalidOptions,
        mapClientHandshakeError(error.SignatureSchemeNotOffered),
    );
    // The credential-flight BufferTooShort: a chain too large for one record.
    try testing.expectEqual(
        ConnectError.InvalidOptions,
        mapClientHandshakeError(error.BufferTooShort),
    );
    // Reassembly shortfalls stay a sizing fault (HandshakeBufferTooShort).
    try testing.expectEqual(
        ConnectError.HandshakeBufferTooShort,
        mapClientHandshakeError(error.HandshakeBufferTooShort),
    );
}

// RFC 8446 §4.4.2 — a verified client leaf that cannot fit the caller's
// retention storage is a sizing fault, not a rejected certificate.
test "public error mapping: undersized client-identity storage is HandshakeBufferTooShort" {
    try testing.expectEqual(
        AcceptError.HandshakeBufferTooShort,
        mapServerHandshakeError(error.ClientCertificateTooLarge),
    );
    // ... while a missing required certificate stays a rejection.
    try testing.expectEqual(
        AcceptError.ClientCertificateRejected,
        mapServerHandshakeError(error.ClientCertificateRequired),
    );
}

// RFC 8446 §6.2 — the peer receives the specific alert TLS defines for the
// failure that occurred, not the coarse class bucket; and a peer that already
// aborted gets silence.
test "alert fidelity: specific descriptions, silence after a peer alert" {
    try testing.expectEqual(
        alert.Description.decrypt_error,
        alertForHandshakeError(error.SignatureVerificationFailed).?,
    );
    try testing.expectEqual(
        alert.Description.bad_record_mac,
        alertForHandshakeError(error.AuthenticationFailed).?,
    );
    try testing.expectEqual(
        alert.Description.unknown_ca,
        alertForHandshakeError(error.MissingTrustAnchor).?,
    );
    try testing.expectEqual(
        alert.Description.certificate_expired,
        alertForHandshakeError(error.CertificateExpired).?,
    );
    // The peer already sent a fatal alert; §6.2 says close without replying.
    try testing.expectEqual(@as(?alert.Description, null), alertForHandshakeError(error.PeerAlert));
}

test "Config: buffer sizing is the whole story of the Stream footprint" {
    // Measured on this revision: Client 151_856, Server 134_928. These are a
    // coarse backstop; the exact-delta assertions below are what actually guard
    // against a buffer growing unnoticed. The ceiling's slack already let these
    // numbers drift 16 bytes stale once, so trust the deltas, not the comment.
    try testing.expect(@sizeOf(Client) <= 152_000);
    try testing.expect(@sizeOf(Server) <= 135_000);

    // Retaining the peer chain for `info()` costs exactly one handshake-sized
    // buffer, which is why it is opt-in.
    const Introspecting = ClientWith(.{
        .peer_chain_storage = ztls.ClientHandshake.recommended_handshake_storage,
    });
    try testing.expectEqual(
        @as(usize, ztls.ClientHandshake.recommended_handshake_storage),
        @sizeOf(Introspecting) - @sizeOf(Client),
    );

    // Every other knob is just as literal.
    const BiggerRead = ClientWith(.{ .read_buffer = 2 * frame.max_plaintext_len });
    try testing.expectEqual(
        @as(usize, frame.max_plaintext_len),
        @sizeOf(BiggerRead) - @sizeOf(Client),
    );

    // Server-side client-identity retention costs exactly its storage, and
    // nothing on the client.
    const Identifying = ServerWith(.{ .client_identity_storage = 2048 });
    try testing.expectEqual(
        @as(usize, 2048),
        @sizeOf(Identifying) - @sizeOf(Server),
    );
    const IdentifyingClient = ClientWith(.{ .client_identity_storage = 2048 });
    try testing.expectEqual(@sizeOf(Client), @sizeOf(IdentifyingClient));

    // So a caller opening thousands of connections can trade look-ahead and
    // reassembly headroom for footprint.
    const Lean = ClientWith(.{
        .record_storage = RecordBuffer.min_storage,
        .reassembly_storage = 2 * frame.max_plaintext_len,
        .write_buffer = 4096,
    });
    try testing.expect(@sizeOf(Lean) < @sizeOf(Client) - 45_000);
}
