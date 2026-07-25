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
//! NOT reentrant across concurrent tasks — including cooperatively scheduled
//! ones on a single thread. `reader()` and `writer()` share the handshake engine
//! and one outbound record buffer, and both yield to the runtime mid-operation
//! while that buffer holds a half-written record, so a second task entering the
//! other half corrupts it. "Not thread-safe" understates this: on a
//! green-thread runtime like zio a single-threaded scheduler still interleaves
//! at every I/O point, so it looks safe and is not. Debug and ReleaseSafe builds
//! assert on reentry rather than corrupting silently.
//!
//! Drive both directions from one task (see `hasBuffered` and `socketHandle`),
//! or serialize access yourself.
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
const alertForClass = errors.alertForClass;
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
    /// the core will accept. Client-side only; server-side client-certificate
    /// retention is not wired yet.
    peer_chain_storage: ?usize = null,
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
    /// Caller-supplied `Options` are unusable (ALPN list shape, host length).
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
    /// The client presented a certificate that was required, unsupported, or
    /// too large. Client authentication is not a supported surface yet.
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
pub const WriteError = error{
    /// The write side is already closed by `closeWrite` or `close`.
    TlsClosed,
    /// The peer sent a malformed record, or application data was written
    /// before the handshake completed.
    TlsProtocolError,
    /// Backend failure, counter overflow, or a broken invariant on our side.
    InternalError,
} || net.Stream.Writer.Error || Io.Cancelable || Io.UnexpectedError;

/// Negotiated connection properties. Slices are borrowed and valid until
/// `deinit`.
pub const Info = struct {
    cipher_suite: ztls.CipherSuite,
    alpn: ?[]const u8,
    /// Verified peer certificates, leaf first. Empty unless
    /// `Config.peer_chain_storage` was set (and, server-side, always empty
    /// until client-certificate retention is wired).
    peer_chain: []const []const u8,
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

fn mapWriteError(err: HandshakeError) WriteError {
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

    const Flag = enum { rx_closed, tx_closed, closed };
    const Flags = std.EnumSet(Flag);

    const RecordStorage = ztls.Array(config.record_storage);
    const Reassembly = ztls.Array(config.reassembly_storage orelse Hs.Storage.capacity);
    const ReadStorage = ztls.Array(config.read_buffer);
    const WriteStorage = ztls.Array(config.write_buffer);

    const retain_peer_chain = role == .client and config.peer_chain_storage != null;
    const PeerChainStorage = if (retain_peer_chain)
        ztls.Array(config.peer_chain_storage.?)
    else
        void;

    return struct {
        const Self = @This();
        const ReaderEvent = union(enum) {
            application_data: []const u8,
            write: []const u8,
            key_update: ?[]const u8,
            none,
            closed,
        };

        // The client alone receives NewSessionTicket. Normalize that difference
        // at the engine boundary so the record loop has one event switch.
        fn normalizeReaderEvent(event: Hs.Event) ReaderEvent {
            return if (role == .client) switch (event) {
                .application_data => |data| .{ .application_data = data },
                .write => |data| .{ .write = data },
                .key_update => |update| .{ .key_update = update.response },
                .new_session_ticket, .none => .none,
                .closed => .closed,
            } else switch (event) {
                .application_data => |data| .{ .application_data = data },
                .write => |data| .{ .write = data },
                .key_update => |update| .{ .key_update = update.response },
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
        /// Decrypted application data from the current record that has not been
        /// handed to the caller yet. Slices into `storage`, which `rb.next()`
        /// and `rb.writable()` invalidate — so the record loop must not run
        /// while this is non-empty.
        pending: []const u8 = &.{},
        reader_impl: Reader,
        writer_impl: Writer,
        flags: Flags = .initEmpty(),
        /// Set by `finishInit` to catch a moved or copied Stream. `rb`, the
        /// reassembly buffer, and both `Io` interfaces point into this struct,
        /// so relocating the value silently corrupts memory. Checked with
        /// `assert`, so it costs nothing in ReleaseFast.
        pinned: *const Self = undefined,
        /// True while a read or write is in flight. Both paths share `out` and
        /// the engine, and both yield to the runtime while that buffer holds a
        /// half-written record, so a second task entering the other half is a
        /// data race even on a single-threaded green-thread scheduler. Asserted
        /// rather than locked: serializing here would hide the caller's bug and
        /// deadlock the moment a reader blocks while a writer waits.
        busy: bool = false,

        fn assertPinned(s: *const Self) void {
            assert(s.pinned == s);
        }

        /// Claim exclusive use of the engine for one read or write. Pair with
        /// `release`.
        fn acquire(s: *Self) void {
            assert(!s.busy); // concurrent use of one Stream; see the module docs
            s.busy = true;
        }

        fn release(s: *Self) void {
            assert(s.busy);
            s.busy = false;
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
                s.acquire();
                defer s.release();

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
                if (s.flags.contains(.closed) or s.flags.contains(.rx_closed))
                    return error.EndOfStream;

                var idle: usize = 0;
                while (true) {
                    while (true) {
                        const record = (s.rb.next() catch |err|
                            return s.failRead(mapReadError(err))) orelse break;
                        if (idle == max_idle_records_per_refill)
                            return s.failRead(error.IdleRecordFlood);
                        idle += 1;
                        const ev = s.hs.handleRecord(record, &s.out.buffer) catch |err| {
                            return s.failRead(mapReadError(err));
                        };
                        switch (normalizeReaderEvent(ev)) {
                            .none => continue,
                            .write => |bytes| {
                                s.writeControlRecord(bytes) catch |err|
                                    return s.failRead(err);
                                continue;
                            },
                            .key_update => |response| {
                                if (response) |bytes| {
                                    s.writeControlRecord(bytes) catch |err|
                                        return s.failRead(err);
                                }
                                continue;
                            },
                            .closed => {
                                s.flags.insert(.rx_closed);
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
                    ) catch |err| return s.failRead(err);
                    if (n == 0) {
                        s.flags.insert(.rx_closed);
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

        /// Borrowed `*Io.Reader` — drop-in for any `*Io.Reader` consumer.
        pub fn reader(s: *Self) *Io.Reader {
            s.assertPinned();
            return &s.reader_impl.interface;
        }

        /// Borrowed `*Io.Writer` — drop-in for any `*Io.Writer` consumer.
        pub fn writer(s: *Self) *Io.Writer {
            s.assertPinned();
            return &s.writer_impl.interface;
        }

        /// Why the last read failed. `Io.Reader` collapses every failure into
        /// `error.ReadFailed`, so cancellation (`error.Canceled`), a dead
        /// transport, and a TLS failure are otherwise indistinguishable. Call
        /// this after `ReadFailed`; the value is stale at any other time.
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

        /// Why the last write failed. Same contract as `readError`.
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
            };
        }

        /// True when a read can return data without touching the transport:
        /// decrypted bytes are pending, or a complete record is already
        /// buffered. Poll-style loops use this to drain coalesced records
        /// without blocking.
        pub fn hasBuffered(s: *Self) bool {
            s.assertPinned();
            return s.pending.len > 0 or
                s.reader_impl.interface.bufferedLen() > 0 or
                s.rb.hasRecord();
        }

        /// Flush staged plaintext, send `close_notify`, and keep the read side
        /// open for the peer's response. Idempotent.
        ///
        /// The flush is a safety net, not a substitute for flushing: teardown
        /// is infallible by contract, so a caller who must know that staged
        /// bytes reached the peer flushes explicitly first and checks.
        ///
        /// RFC 8446 §6.1 permits each direction to close independently.
        pub fn closeWrite(s: *Self) void {
            s.assertPinned();
            if (s.flags.contains(.closed) or s.flags.contains(.tx_closed)) return;

            // Staged plaintext goes out before close_notify. Discarding bytes
            // the caller already handed to the Writer would be silent data
            // loss, and close_notify must be the last record we send.
            // ziglint-ignore: Z026 -- teardown is infallible; a failed flush
            // has nowhere to go and the socket is about to close regardless.
            s.writer_impl.interface.flush() catch {};
            s.flags.insert(.tx_closed);

            // The alert goes through the same shared `out` buffer as a write.
            s.acquire();
            defer s.release();

            if (s.hs.sendAlert(.close_notify, &s.out.buffer)) |alert_record| {
                transportWriteAll(s.io, s.sock.socket.handle, alert_record) catch return;
                s.hs.completeWrite();
            } else |_| return;
        }

        /// Flush, send `close_notify`, and close the underlying socket.
        /// Idempotent. Does not drain application data the peer may still be
        /// sending; callers who want that read to `error.EndOfStream` first.
        pub fn close(s: *Self) void {
            s.assertPinned();
            if (s.flags.contains(.closed)) return;
            s.closeWrite();
            s.teardown();
        }

        /// Always-callable teardown: closes the socket without an alert and
        /// secure-zeros every wrapper-owned buffer — record storage, read and
        /// write staging, reassembly, and the retained chain. Idempotent, and
        /// safe (a no-op) after a failed `connect`/`accept`, which cleans up
        /// after itself.
        pub fn deinit(s: *Self) void {
            if (s.flags.contains(.closed)) return;
            s.teardown();
        }

        /// Zeroing the buffers is this type's job, not the engine's: ztls hands
        /// lent storage back untouched by design (#81), and every buffer here is
        /// declared by the Stream. The record and read buffers held decrypted
        /// application plaintext, so nobody else is going to do it.
        fn teardown(s: *Self) void {
            s.flags.insert(.closed);
            s.pending = &.{};
            s.sock.close(s.io);
            s.storage.secureZero();
            s.out.secureZero();
            s.reassembly.secureZero();
            s.read_storage.secureZero();
            s.write_storage.secureZero();
            if (retain_peer_chain) s.peer_chain_storage.secureZero();
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

        /// Send an engine-produced control record (client Finished, KeyUpdate
        /// response) and settle the engine's pending-write latch.
        fn writeControlRecord(s: *Self, bytes: []const u8) net.Stream.Writer.Error!void {
            defer s.hs.completeWrite();
            try transportWriteAll(s.io, s.sock.socket.handle, bytes);
        }

        /// RFC 8446 §6.2 — best effort. A failed alert write cannot change the
        /// outcome, and a latched pending write means the engine cannot encode
        /// one at all.
        fn sendFatalAlert(s: *Self, description: alert.Description) void {
            if (s.hs.sendAlert(description, &s.out.buffer)) |record| {
                // ziglint-ignore: Z026 -- the handshake already failed; a
                // failed courtesy alert cannot change the reported error.
                s.writeControlRecord(record) catch {};
            } else |_| {}
        }

        /// Handshake failures for this role. Transport failures do not come
        /// through here: they are already in the public set, and an alert
        /// cannot reach a peer whose socket just failed.
        const HandshakeFailure = if (role == .client) ConnectError else AcceptError;

        /// Report a handshake failure to the peer (RFC 8446 §6.2), then coarsen
        /// it for the caller.
        fn handshakeFailure(s: *Self, err: HandshakeError) HandshakeFailure {
            if (alertForClass(classify(err))) |description| s.sendFatalAlert(description);
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
                    const ev = s.hs.handleRecord(record orelse break, &s.out.buffer) catch |err|
                        return s.handshakeFailure(err);
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
            s.acquire();
            defer s.release();

            if (s.flags.contains(.closed) or s.flags.contains(.tx_closed))
                return s.failWrite(error.TlsClosed);

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
            const record = s.hs.sendApplicationData(
                plaintext,
                &s.out.buffer,
            ) catch |err| return s.failWrite(mapWriteError(err));
            defer s.hs.completeWrite();
            transportWriteAll(s.io, s.sock.socket.handle, record) catch |err| {
                return s.failWrite(err);
            };
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
            s.reader_impl = .init(s);
            s.writer_impl = .init(s);
        }

        /// Client only. Wrap a CONNECTED `std.Io.net.Stream` and run the TLS
        /// 1.3 handshake to completion. Moves the socket into `s`. Eager: all
        /// handshake errors (cert verification, ALPN no-overlap, alerts)
        /// surface here rather than leaking into the first read.
        ///
        /// On failure the peer gets a fatal alert where one is warranted, the
        /// socket is closed, and buffers are zeroed — a later `deinit` is
        /// harmless but unnecessary.
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

                    const hs: ztls.ClientHandshake = .init(.{
                        .keypairs = .init(client_keypair),
                        .host_name = options.host,
                        .now_sec = Io.Timestamp.now(io, .real).toSeconds(),
                        .random = random,
                        .alpn_protocols = options.alpn,
                        .offer_pq_key_share = options.offer_pq_key_share,
                    });

                    // In-place init before the first fallible step, so no error
                    // path can leave `s` undefined while the caller holds a
                    // pointer to it.
                    s.* = .init(io, sock, hs);
                    s.finishInit();
                    errdefer s.deinit();

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
        /// Same failure contract as `connect`.
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

                    const hs: ztls.ServerHandshake = .init(.{
                        .keypairs = .init(server_keypair),
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

test "Config: buffer sizing is the whole story of the Stream footprint" {
    // Measured on this revision: Client 151_840, Server 134_912. Tight
    // ceilings on purpose — a buffer that grows without a `Config` change is a
    // regression, not a rounding difference.
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

    // So a caller opening thousands of connections can trade look-ahead and
    // reassembly headroom for footprint.
    const Lean = ClientWith(.{
        .record_storage = RecordBuffer.min_storage,
        .reassembly_storage = 2 * frame.max_plaintext_len,
        .write_buffer = 4096,
    });
    try testing.expect(@sizeOf(Lean) < @sizeOf(Client) - 45_000);
}
