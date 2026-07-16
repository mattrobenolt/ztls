//! ztls-std: opinionated TLS 1.3 stream wrapper over `std.Io.net` (Zig 0.16).
//!
//! Converts a connected `std.Io.net` stream into a TLS connection so a caller
//! can `connect`/`read`/`write`/`close` without writing a Sans-I/O drive loop.
//! This is the reference integration; ztls-xev and ztls-ktls adapt its
//! handshake-to-completion loop. See #77.
//!
//! Design: eager handshake (connect/accept run the full handshake before
//! returning), drop-in Io.Reader/Io.Writer seam (TLS is invisible to
//! consumers), and zero-copy reads (the Reader vtable repoints its buffer at
//! the decrypted record in place — the 0.16 Io.Reader contract permits this).
const std = @import("std");
const assert = std.debug.assert;
const Io = std.Io;
const net = Io.net;
const testing = std.testing;
const ztls = @import("ztls");

/// Re-export ztls so consumers of ztls-std can reach the core if needed.
pub const core = ztls;

const frame = ztls.frame;
const RecordBuffer = ztls.RecordBuffer;

// ───────────────────────────────
// Verification policy (client)
// ───────────────────────────────

/// Client certificate verification policy. See README.
pub const Verify = union(enum) {
    /// Load the OS trust store and verify the server certificate chain.
    /// Requires an allocator, passed to `Client.connect` (used only for this
    /// mode; freed before connect returns).
    system_bundle,
    /// Verify against a caller-owned bundle (pin a root / custom store).
    /// Borrowed for the life of the Stream.
    bundle: *const std.crypto.Certificate.Bundle,
    /// Skip chain-anchor verification (sets ztls `insecure_no_chain_anchor`).
    /// Hostname verification still runs unless `host` is null. Demo/test only.
    insecure,
};

// ───────────────────────────────
// Error sets
// ───────────────────────────────

pub const ConnectError = error{
    CertificateVerificationFailed,
    TlsAlertReceived,
    HandshakeProtocolError,
    NoApplicationProtocol,
    HandshakeBufferTooShort,
    OutOfMemory,
} || net.Stream.Reader.Error || net.Stream.Writer.Error || Io.Cancelable || Io.UnexpectedError;

pub const AcceptError = error{
    MissingCredentials,
    TlsAlertReceived,
    HandshakeProtocolError,
    UnsupportedCipherSuite,
    NoApplicationProtocol,
    HandshakeBufferTooShort,
} || net.Stream.Reader.Error || net.Stream.Writer.Error || Io.Cancelable || Io.UnexpectedError;

pub const ReadError = error{
    TlsBadRecord,
    TlsAlertReceived,
    TlsUnexpectedEof,
} || net.Stream.Reader.Error || Io.Cancelable || Io.UnexpectedError;

pub const WriteError = error{
    TlsClosed,
    TlsAlertReceived,
} || net.Stream.Writer.Error || Io.Cancelable || Io.UnexpectedError;

// ───────────────────────────────
// Transport helpers
// ───────────────────────────────

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
// Handshake drive loops
// ───────────────────────────────

/// Map sprawling ztls client handshake errors to the coarse ConnectError set.
fn mapClientHandshakeError(err: anyerror) ConnectError {
    return switch (err) {
        error.CertificateIssuerNotFound,
        error.CertificateSignatureAlgorithmRejected,
        error.CertificateKeyUsageRejected,
        error.CertificateExtendedKeyUsageRejected,
        error.UnsupportedCertificateVersion,
        error.CertificateVerifyFailed,
        error.HostnameMismatch,
        => error.CertificateVerificationFailed,

        error.PeerAlert => error.TlsAlertReceived,

        error.UnexpectedRecord,
        error.UnexpectedMessage,
        error.IllegalParameter,
        error.IncompleteRecord,
        error.UnexpectedEof,
        error.BufferTooShort,
        error.ServerNameTooLong,
        error.IdentityTooLong,
        error.IdentityElement,
        error.UnsupportedKeyShareGroup,
        error.HelloRetryRequestMismatch,
        => error.HandshakeProtocolError,

        error.NoApplicationProtocol => error.NoApplicationProtocol,

        error.RecordTooLarge => error.HandshakeBufferTooShort,

        else => @panic("unmapped ztls client handshake error"),
    };
}

/// Map sprawling ztls server handshake errors to the coarse AcceptError set.
fn mapServerHandshakeError(err: anyerror) AcceptError {
    return switch (err) {
        error.MissingServerCredentials => error.MissingCredentials,

        error.PeerAlert => error.TlsAlertReceived,

        error.UnexpectedRecord,
        error.UnexpectedMessage,
        error.IllegalParameter,
        error.IncompleteRecord,
        error.UnexpectedEof,
        error.IdentityElement,
        error.UnsupportedKeyShare,
        => error.HandshakeProtocolError,

        error.UnsupportedCipherSuite => error.UnsupportedCipherSuite,
        error.NoApplicationProtocol => error.NoApplicationProtocol,
        error.RecordTooLarge => error.HandshakeBufferTooShort,

        else => @panic("unmapped ztls server handshake error"),
    };
}

// ───────────────────────────────
// Generic Stream (parameterized by handshake engine type)
// ───────────────────────────────

/// The Reader vtable Error maps all TLS-specific failures to ReadFailed and
/// clean close_notify to EndOfStream, matching the Io.Reader contract.
const ReaderError = error{ ReadFailed, EndOfStream };
const WriterError = error{WriteFailed};

/// Comptime check: does the handshake Event type have a .new_session_ticket
/// variant? ClientHandshake.Event does, ServerHandshake.Event does not.
fn eventHasNst(comptime Event: type) bool {
    inline for (@typeInfo(Event).@"union".fields) |f| {
        if (std.mem.eql(u8, f.name, "new_session_ticket")) return true;
    }
    return false;
}

fn StreamImpl(comptime Hs: type) type {
    const has_nst = eventHasNst(Hs.Event);
    return struct {
        const Self = @This();
        pub const Handshake = Hs;

        sock: net.Stream,
        io: Io,
        hs: Hs,
        storage: RecordBuffer.Storage,
        rb: RecordBuffer,
        out: Hs.OutBuffer,
        reassembly: Hs.Storage = .empty,
        write_buffer: [frame.max_plaintext_len]u8 = undefined,
        reader_impl: Reader,
        writer_impl: Writer,
        rx_closed: bool = false,
        tx_closed: bool = false,
        closed: bool = false,

        pub const Reader = struct {
            interface: Io.Reader,

            pub fn init(_: *Self) Reader {
                return .{
                    .interface = .{
                        .vtable = &.{
                            .stream = streamImpl,
                        },
                        .buffer = &.{},
                        .seek = 0,
                        .end = 0,
                    },
                };
            }

            /// Refill the reader: drive the record loop until application_data is
            /// available, then repoint `io_r.buffer` at the decrypted record
            /// (zero-copy) and return 0 (data in buffer). EndOfStream = clean
            /// close_notify. `readVec` uses the stdlib default, which delegates
            /// here via `stream`.
            fn streamImpl(
                io_r: *Io.Reader,
                io_w: *Io.Writer,
                limit: Io.Limit,
            ) Io.Reader.StreamError!usize {
                // Zero-copy: refill repoints io_r.buffer at the decrypted record
                // (in place in the RecordBuffer) and returns 0, instead of copying
                // bytes into io_w. The Io.Reader.stream contract permits storing data
                // in buffer + returning 0 ("including zero, does not indicate end of
                // stream"); the generic reader meters data out of buffer respecting
                // the caller's limit, so limit is unused here. io_w/limit are
                // vestigial to the vtable signature.
                _ = io_w;
                _ = limit;
                const r: *Reader = @alignCast(@fieldParentPtr("interface", io_r));
                const s: *Self = @alignCast(@fieldParentPtr("reader_impl", r));
                assert(io_r.seek == io_r.end);

                return refill(s, io_r);
            }

            /// Drive the record loop until application_data is available, then
            /// repoint the buffer at the decrypted record (zero-copy).
            /// Returns 0 (data in buffer). EndOfStream = clean close_notify.
            fn refill(s: *Self, io_r: *Io.Reader) ReaderError!usize {
                // RFC 8446 §6.1 — after close_notify or close(), reads return EndOfStream.
                if (s.closed or s.rx_closed) return error.EndOfStream;
                while (true) {
                    while (true) {
                        const record = (s.rb.next() catch return error.ReadFailed) orelse break;
                        const ev = s.hs.handleRecord(record, &s.out.buffer) catch {
                            return error.ReadFailed;
                        };
                        // Comptime-segregated exhaustive switch: ClientHandshake.Event
                        // has .new_session_ticket, ServerHandshake.Event does not. Each
                        // branch is exhaustive so adding a variant is a compile error.
                        if (has_nst) {
                            switch (ev) {
                                .new_session_ticket => continue,
                                .none => continue,
                                .write => |w| {
                                    transportWriteAll(
                                        s.io,
                                        s.sock.socket.handle,
                                        w,
                                    ) catch return error.ReadFailed;
                                    s.hs.completeWrite();
                                    continue;
                                },
                                .key_update => |ku| {
                                    if (ku.response) |resp| {
                                        transportWriteAll(
                                            s.io,
                                            s.sock.socket.handle,
                                            resp,
                                        ) catch return error.ReadFailed;
                                        s.hs.completeWrite();
                                    }
                                    continue;
                                },
                                .closed => {
                                    s.rx_closed = true;
                                    return error.EndOfStream;
                                },
                                .application_data => |app_data| {
                                    io_r.buffer = @constCast(app_data);
                                    io_r.seek = 0;
                                    io_r.end = app_data.len;
                                    return 0;
                                },
                            }
                        } else {
                            switch (ev) {
                                .none => continue,
                                .write => |w| {
                                    transportWriteAll(
                                        s.io,
                                        s.sock.socket.handle,
                                        w,
                                    ) catch return error.ReadFailed;
                                    s.hs.completeWrite();
                                    continue;
                                },
                                .key_update => |ku| {
                                    if (ku.response) |resp| {
                                        transportWriteAll(
                                            s.io,
                                            s.sock.socket.handle,
                                            resp,
                                        ) catch return error.ReadFailed;
                                        s.hs.completeWrite();
                                    }
                                    continue;
                                },
                                .closed => {
                                    s.rx_closed = true;
                                    return error.EndOfStream;
                                },
                                .application_data => |app_data| {
                                    io_r.buffer = @constCast(app_data);
                                    io_r.seek = 0;
                                    io_r.end = app_data.len;
                                    return 0;
                                },
                            }
                        }
                    }

                    const n = transportRead(s.io, s.sock.socket.handle, s.rb.writable()) catch {
                        return error.ReadFailed;
                    };
                    if (n == 0) return error.ReadFailed;
                    s.rb.advance(n);
                }
            }
        };

        pub const Writer = struct {
            interface: Io.Writer,

            pub fn init(s: *Self) Writer {
                return .{
                    .interface = .{
                        .vtable = &.{
                            .drain = drainImpl,
                        },
                        .buffer = &s.write_buffer,
                    },
                };
            }
        };

        /// Borrowed `*Io.Reader` — drop-in for any `*Io.Reader` consumer.
        pub fn reader(s: *Self) *Io.Reader {
            return &s.reader_impl.interface;
        }

        /// Borrowed `*Io.Writer` — drop-in for any `*Io.Writer` consumer.
        pub fn writer(s: *Self) *Io.Writer {
            return &s.writer_impl.interface;
        }

        /// ALPN protocol selected by the peer, or null. Valid after handshake.
        pub fn selectedAlpn(s: *const Self) ?[]const u8 {
            return s.hs.selectedAlpnProtocol();
        }

        /// Send close_notify and close the underlying socket. Idempotent.
        pub fn close(s: *Self, io: Io) void {
            if (s.closed) return;
            s.closed = true;

            if (!s.tx_closed) {
                s.tx_closed = true;
                if (s.hs.sendAlert(.close_notify, &s.out.buffer)) |alert_record| {
                    transportWriteAll(io, s.sock.socket.handle, alert_record) catch {};
                    s.hs.completeWrite();
                } else |_| {}
            }

            s.sock.close(io);
            s.zeroWrapperBuffers();
            s.hs.deinit();
        }

        /// Always-callable teardown: closes the socket (no alert) and
        /// secure-zeros all buffers. Idempotent. Use after a failed connect
        /// too — the socket may be open even if the handshake failed.
        pub fn deinit(s: *Self) void {
            if (s.closed) return;
            s.closed = true;
            s.sock.close(s.io);
            s.zeroWrapperBuffers();
            s.hs.deinit();
        }

        fn zeroWrapperBuffers(s: *Self) void {
            s.storage.secureZero();
            s.out.secureZero();
            s.reassembly.secureZero();
            std.crypto.secureZero(u8, &s.write_buffer);
        }

        // ── Writer drain ──────────────

        fn drainImpl(io_w: *Io.Writer, data: []const []const u8, splat: usize) WriterError!usize {
            const w: *Writer = @alignCast(@fieldParentPtr("interface", io_w));
            const s: *Self = @alignCast(@fieldParentPtr("writer_impl", w));

            if (s.closed or s.tx_closed) return error.WriteFailed;

            var total_written: usize = 0;

            // 1. Send buffered plaintext as one record
            const buffered = io_w.buffered();
            if (buffered.len > 0) {
                sendPlaintext(s, buffered) catch return error.WriteFailed;
                total_written += buffered.len;
            }

            // 2. Send data slices (last one repeated splat times)
            if (data.len > 0) {
                for (data[0 .. data.len - 1]) |slice| {
                    sendPlaintextChunked(s, slice) catch return error.WriteFailed;
                    total_written += slice.len;
                }
                const last = data[data.len - 1];
                var i: usize = 0;
                while (i < splat) : (i += 1) {
                    sendPlaintextChunked(s, last) catch return error.WriteFailed;
                    total_written += last.len;
                }
            }

            return io_w.consume(total_written);
        }

        /// Send one plaintext chunk (must be <= max_plaintext_len) as a TLS record.
        fn sendPlaintext(s: *Self, plaintext: []const u8) WriterError!void {
            assert(plaintext.len <= frame.max_plaintext_len);
            const record = s.hs.sendApplicationData(
                plaintext,
                &s.out.buffer,
            ) catch return error.WriteFailed;
            defer s.hs.completeWrite();
            transportWriteAll(s.io, s.sock.socket.handle, record) catch {
                return error.WriteFailed;
            };
        }

        /// Send plaintext that may exceed max_plaintext_len, splitting into
        /// multiple TLS records.
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

        fn finishInit(s: *Self) void {
            s.rb = .init(&s.storage.buffer);
            s.hs.useHandshakeBuffer(&s.reassembly.buffer);
            s.reader_impl = Reader.init(s);
            s.writer_impl = Writer.init(s);
        }
    };
}

// ───────────────────────────────
// Client
// ───────────────────────────────

pub const Client = struct {
    pub const Options = struct {
        host: ?[]const u8 = null,
        verify: Verify = .system_bundle,
        alpn: []const []const u8 = &.{},
        offer_pq_key_share: bool = false,
    };

    pub const Stream = StreamImpl(ztls.ClientHandshake);

    /// Wrap a CONNECTED `std.Io.net.Stream` and run the TLS 1.3 handshake to
    /// completion. Moves the socket into `out`. Eager: all handshake errors
    /// surface here. `gpa` is used ONLY when `options.verify == .system_bundle`.
    pub fn connect(
        out: *Stream,
        gpa: std.mem.Allocator,
        io: Io,
        sock: net.Stream,
        options: Options,
    ) ConnectError!void {
        var client_keypair: ztls.x25519.KeyPair = .generate();
        defer std.crypto.secureZero(u8, std.mem.asBytes(&client_keypair));
        var random: ztls.Random = undefined;
        io.random(&random.data);
        defer std.crypto.secureZero(u8, std.mem.asBytes(&random));

        const now_sec: i64 = Io.Timestamp.now(io, .real).toSeconds();

        var hs: ztls.ClientHandshake = .init(.{
            .keypairs = .init(client_keypair),
            .host_name = options.host,
            .now_sec = now_sec,
            .random = random,
            .alpn_protocols = options.alpn,
            .offer_pq_key_share = options.offer_pq_key_share,
        });

        var bundle: std.crypto.Certificate.Bundle = undefined;
        var bundle_loaded = false;
        defer if (bundle_loaded) bundle.deinit(gpa);

        switch (options.verify) {
            .system_bundle => {
                bundle = .empty;
                const bundle_now = Io.Timestamp.now(io, .real);
                bundle.rescan(gpa, io, bundle_now) catch |err| switch (err) {
                    error.OutOfMemory => return error.OutOfMemory,
                    else => return error.CertificateVerificationFailed,
                };
                bundle_loaded = true;
                hs.policy.bundle = &bundle;
            },
            .bundle => |b| {
                hs.policy.bundle = b;
            },
            .insecure => {
                hs.policy.insecure_no_chain_anchor = true;
            },
        }

        out.* = Stream.init(io, sock, hs);
        out.finishInit();

        try clientHandshakeDrive(out);

        // TLS 1.3 only needs the bundle during the handshake.
        out.hs.policy.bundle = null;
    }
};

/// Drive the client handshake to completion.
fn clientHandshakeDrive(s: *Client.Stream) ConnectError!void {
    const io = s.io;
    const handle = s.sock.socket.handle;

    // Send ClientHello
    const ch = s.hs.start(&s.out.buffer) catch |err| return mapClientHandshakeError(err);
    try transportWriteAll(io, handle, ch);
    s.hs.completeWrite();

    while (!s.hs.isConnected()) {
        const n = try transportRead(io, handle, s.rb.writable());
        if (n == 0) return error.HandshakeProtocolError;
        s.rb.advance(n);

        while (true) {
            // Stop processing records once connected — remaining records
            // (app data, NST, etc.) are left for the Reader to consume.
            if (s.hs.isConnected()) break;
            const record = (s.rb.next() catch return error.HandshakeBufferTooShort) orelse break;
            const ev = s.hs.handleRecord(record, &s.out.buffer) catch |err|
                return mapClientHandshakeError(err);
            switch (ev) {
                .write => |w| {
                    try transportWriteAll(io, handle, w);
                    s.hs.completeWrite();
                },
                .none => {},
                .application_data,
                .closed,
                .key_update,
                .new_session_ticket,
                => return error.HandshakeProtocolError,
            }
        }
    }
}

// ───────────────────────────────
// Server
// ───────────────────────────────

pub const Server = struct {
    pub const Options = struct {
        cert_chain: []const []const u8,
        signer: ztls.signature.Signer,
        alpn: []const []const u8 = &.{},
    };

    pub const Stream = StreamImpl(ztls.ServerHandshake);

    /// Wrap an ACCEPTED `std.Io.net.Stream` and run the server-side handshake
    /// to completion. Moves the socket into `out`. No allocator.
    pub fn accept(
        out: *Stream,
        io: Io,
        sock: net.Stream,
        options: Options,
    ) AcceptError!void {
        if (options.cert_chain.len == 0) return error.MissingCredentials;

        var server_keypair: ztls.x25519.KeyPair = .generate();
        defer std.crypto.secureZero(u8, std.mem.asBytes(&server_keypair));
        var random: ztls.Random = undefined;
        io.random(&random.data);
        defer std.crypto.secureZero(u8, std.mem.asBytes(&random));

        var hs: ztls.ServerHandshake = .init(.{
            .keypairs = .init(server_keypair),
            .random = random,
            .alpn_protocols = options.alpn,
        });
        hs.setCredentials(options.cert_chain, options.signer);

        out.* = Stream.init(io, sock, hs);
        out.finishInit();

        try serverHandshakeDrive(out);
    }
};

/// Drive the server handshake to completion.
fn serverHandshakeDrive(s: *Server.Stream) AcceptError!void {
    const io = s.io;
    const handle = s.sock.socket.handle;

    while (!s.hs.isConnected()) {
        const n = try transportRead(io, handle, s.rb.writable());
        if (n == 0) return error.TlsAlertReceived;
        s.rb.advance(n);

        while (true) {
            // Stop processing records once connected — remaining records
            // (app data sent immediately after Finished) are left in the
            // RecordBuffer for the Reader to consume.
            if (s.hs.isConnected()) break;
            const record = (s.rb.next() catch return error.HandshakeBufferTooShort) orelse break;
            const ev = s.hs.handleRecord(record, &s.out.buffer) catch |err|
                return mapServerHandshakeError(err);
            switch (ev) {
                .write => |w_bytes| {
                    try transportWriteAll(io, handle, w_bytes);
                    s.hs.completeWrite();
                    // After ServerHello, send the encrypted flight.
                    if (s.hs.sendServerFlightBuffered(&s.out)) |maybe_flight| {
                        if (maybe_flight) |flight| {
                            try transportWriteAll(io, handle, flight);
                            s.hs.completeWrite();
                        }
                    } else |err| return mapServerHandshakeError(err);
                },
                .none => {},
                .application_data, .closed, .key_update => return error.HandshakeProtocolError,
            }
        }
    }
}

// ───────────────────────────────
// Tests
// ───────────────────────────────

const fixtures = @import("fixtures");

const test_cert_der: []const u8 = &fixtures.server_ecdsa_cert_der;
const test_scalar: []const u8 = &fixtures.server_ecdsa_scalar;

fn testIo() Io {
    return Io.Threaded.global_single_threaded.io();
}

// TCP loopback round-trip through the ztls-std API.
// RFC 8446 — full TLS 1.3 handshake + application data both directions + clean close_notify.
test "ztls-std: socketpair echo" {
    var fds: [2]std.posix.fd_t = undefined;
    const rc = std.c.socketpair(std.posix.AF.UNIX, std.posix.SOCK.STREAM, 0, &fds);
    try testing.expectEqual(@as(c_int, 0), rc);
    defer _ = std.c.close(fds[0]);
    defer _ = std.c.close(fds[1]);

    const written = std.c.write(fds[0], "ping", 4);
    try testing.expectEqual(@as(isize, 4), written);

    var rbuf: [16]u8 = undefined;
    const n = std.c.read(fds[1], &rbuf, rbuf.len);
    try testing.expectEqual(@as(isize, 4), n);
    try testing.expectEqualStrings("ping", rbuf[0..4]);
}

const ThreadEchoCtx = struct {
    fd: std.posix.fd_t,
    err: ?anyerror = null,
};

fn threadEchoRun(ctx: *ThreadEchoCtx) void {
    var buf: [4]u8 = undefined;
    const n = std.c.read(ctx.fd, &buf, buf.len);
    if (n != 4) {
        ctx.err = error.UnexpectedReadSize;
        return;
    }
    const written = std.c.write(ctx.fd, &buf, 4);
    if (written != 4) {
        ctx.err = error.UnexpectedWriteSize;
        return;
    }
}

test "ztls-std: thread spawn works" {
    // Sanity that std.Thread.spawn works in the test context — the
    // round-trip tests below depend on this.
    var fds: [2]std.posix.fd_t = undefined;
    try testing.expectEqual(
        @as(c_int, 0),
        std.c.socketpair(std.posix.AF.UNIX, std.posix.SOCK.STREAM, 0, &fds),
    );
    defer _ = std.c.close(fds[0]);
    defer _ = std.c.close(fds[1]);

    var ctx: ThreadEchoCtx = .{ .fd = fds[1] };
    const thread = try std.Thread.spawn(.{}, threadEchoRun, .{&ctx});

    _ = std.c.write(fds[0], "ping", 4);
    var buf: [4]u8 = undefined;
    const n = std.c.read(fds[0], &buf, buf.len);
    try testing.expectEqual(@as(isize, 4), n);
    try testing.expectEqualStrings("ping", buf[0..4]);

    thread.join();
    if (ctx.err) |err| return err;
}

/// Context for the server thread in the round-trip test.
const RoundTripServerCtx = struct {
    fd: std.posix.fd_t,
    err: ?anyerror = null,
};

fn roundTripServerRun(ctx: *RoundTripServerCtx) void {
    const io = testIo();
    const server_sock: net.Stream = .{
        .socket = .{ .handle = ctx.fd, .address = .{ .ip4 = undefined } },
    };

    var key: ztls.signature.PrivateKey = ztls.signature.PrivateKey.fromP256Scalar(
        @ptrCast(test_scalar[0..32]),
    ) catch {
        ctx.err = error.TestUnexpectedResult;
        _ = std.c.close(ctx.fd);
        return;
    };
    defer key.deinit();

    var conn: Server.Stream = undefined;
    Server.accept(&conn, io, server_sock, .{
        .cert_chain = &.{test_cert_der},
        .signer = key.signer(),
        .alpn = &.{"h2"},
    }) catch |err| {
        ctx.err = err;
        _ = std.c.close(ctx.fd);
        return;
    };

    // Read request — buffer matches expected request size so readSliceShort
    // returns once the record is consumed.
    const r = conn.reader();
    var buf: [18]u8 = undefined;
    _ = r.readSliceShort(&buf) catch |err| {
        ctx.err = err;
        conn.deinit();
        return;
    };

    // Respond
    const w = conn.writer();
    w.writeAll("hello") catch |err| {
        ctx.err = err;
        conn.deinit();
        return;
    };
    w.flush() catch |err| {
        ctx.err = err;
        conn.deinit();
        return;
    };

    conn.close(io);
}

test "ztls-std: in-memory client↔server round-trip" {
    // RFC 8446 — full TLS 1.3 handshake + application data both directions
    // + ALPN h2 + clean close_notify. Server runs on a thread over a
    // socketpair; client runs on the main thread. Mirrors tcp_loopback's
    // ServerCtx + serverRun shape.
    const io = testIo();

    var fds: [2]std.posix.fd_t = undefined;
    try testing.expectEqual(
        @as(c_int, 0),
        std.c.socketpair(std.posix.AF.UNIX, std.posix.SOCK.STREAM, 0, &fds),
    );
    // Server thread owns fds[1]; parent owns fds[0]. The parent must not
    // close fds[1] before join — the server thread reads from it.
    defer _ = std.c.close(fds[0]);

    var sctx: RoundTripServerCtx = .{ .fd = fds[1] };
    const server_thread = try std.Thread.spawn(.{}, roundTripServerRun, .{&sctx});

    const client_sock: net.Stream = .{
        .socket = .{ .handle = fds[0], .address = .{ .ip4 = undefined } },
    };

    var gpa_state: std.heap.DebugAllocator(.{}) = .init;
    defer _ = gpa_state.deinit();
    const gpa = gpa_state.allocator();

    var conn: Client.Stream = undefined;
    try Client.connect(&conn, gpa, io, client_sock, .{
        .host = "ztls.server.test",
        .verify = .insecure,
        .alpn = &.{"h2"},
    });
    defer conn.deinit();

    // Verify ALPN
    try testing.expectEqualStrings("h2", conn.selectedAlpn().?);

    // Write to server
    const w = conn.writer();
    try w.writeAll("GET / HTTP/1.0\r\n\r\n");
    try w.flush();

    // Read response — buffer exactly matches "hello".
    const r = conn.reader();
    var buf: [5]u8 = undefined;
    const n = try r.readSliceShort(&buf);
    try testing.expectEqualStrings("hello", buf[0..n]);

    // Close
    conn.close(io);

    server_thread.join();
    if (sctx.err) |err| return err;
}

test "ztls-std: Stream size is reasonable" {
    // Stream includes RecordBuffer.Storage (~33KB), OutBuffer (~16KB),
    // write_buffer (16KB), reassembly (client ~65KB / server ~33KB), plus
    // the handshake engine. Large but not absurd for an inline TLS stream.
    try testing.expect(@sizeOf(Client.Stream) < 200_000);
    try testing.expect(@sizeOf(Server.Stream) < 200_000);
}

const ReadAfterCloseServerCtx = struct {
    fd: std.posix.fd_t,
    err: ?anyerror = null,
};

fn readAfterCloseServerRun(ctx: *ReadAfterCloseServerCtx) void {
    const io = testIo();
    const server_sock: net.Stream = .{
        .socket = .{ .handle = ctx.fd, .address = .{ .ip4 = undefined } },
    };

    var key: ztls.signature.PrivateKey = ztls.signature.PrivateKey.fromP256Scalar(
        @ptrCast(test_scalar[0..32]),
    ) catch {
        ctx.err = error.TestUnexpectedResult;
        _ = std.c.close(ctx.fd);
        return;
    };
    defer key.deinit();

    var conn: Server.Stream = undefined;
    Server.accept(&conn, io, server_sock, .{
        .cert_chain = &.{test_cert_der},
        .signer = key.signer(),
        .alpn = &.{"h2"},
    }) catch |err| {
        ctx.err = err;
        _ = std.c.close(ctx.fd);
        return;
    };

    const r = conn.reader();
    var buf: [4]u8 = undefined;
    _ = r.readSliceShort(&buf) catch |err| {
        ctx.err = err;
        conn.deinit();
        return;
    };

    const w = conn.writer();
    w.writeAll("ok") catch |err| {
        ctx.err = err;
        conn.deinit();
        return;
    };
    w.flush() catch |err| {
        ctx.err = err;
        conn.deinit();
        return;
    };
    conn.close(io);
}

// RFC 8446 §6.1 — after close_notify, reads must return EndOfStream.
test "ztls-std: read after close returns EndOfStream" {
    const io = testIo();

    var fds: [2]std.posix.fd_t = undefined;
    try testing.expectEqual(
        @as(c_int, 0),
        std.c.socketpair(std.posix.AF.UNIX, std.posix.SOCK.STREAM, 0, &fds),
    );
    defer _ = std.c.close(fds[0]);

    var sctx: ReadAfterCloseServerCtx = .{ .fd = fds[1] };
    const server_thread = try std.Thread.spawn(.{}, readAfterCloseServerRun, .{&sctx});

    const client_sock: net.Stream = .{
        .socket = .{ .handle = fds[0], .address = .{ .ip4 = undefined } },
    };

    var gpa_state: std.heap.DebugAllocator(.{}) = .init;
    defer _ = gpa_state.deinit();
    const gpa = gpa_state.allocator();

    var conn: Client.Stream = undefined;
    try Client.connect(&conn, gpa, io, client_sock, .{
        .host = "ztls.server.test",
        .verify = .insecure,
        .alpn = &.{"h2"},
    });
    defer conn.deinit();

    const w = conn.writer();
    try w.writeAll("ping");
    try w.flush();

    const r = conn.reader();
    var buf: [2]u8 = undefined;
    _ = try r.readSliceShort(&buf);

    conn.close(io);

    // After close, reading must return 0 (end-of-stream per RFC 8446 §6.1).
    // readSliceShort maps EndOfStream from the vtable to a 0-length return.
    const n = try r.readSliceShort(&buf);
    try testing.expectEqual(@as(usize, 0), n);

    server_thread.join();
    if (sctx.err) |err| return err;
}

const LargeWriteServerCtx = struct {
    fd: std.posix.fd_t,
    payload_len: usize,
    total_read: usize = 0,
    err: ?anyerror = null,
};

fn largeWriteServerRun(ctx: *LargeWriteServerCtx) void {
    const io = testIo();
    const server_sock: net.Stream = .{
        .socket = .{ .handle = ctx.fd, .address = .{ .ip4 = undefined } },
    };

    var key: ztls.signature.PrivateKey = ztls.signature.PrivateKey.fromP256Scalar(
        @ptrCast(test_scalar[0..32]),
    ) catch {
        ctx.err = error.TestUnexpectedResult;
        _ = std.c.close(ctx.fd);
        return;
    };
    defer key.deinit();

    var conn: Server.Stream = undefined;
    Server.accept(&conn, io, server_sock, .{
        .cert_chain = &.{test_cert_der},
        .signer = key.signer(),
        .alpn = &.{"h2"},
    }) catch |err| {
        ctx.err = err;
        _ = std.c.close(ctx.fd);
        return;
    };

    const r = conn.reader();
    var buf: [4096]u8 = undefined;
    while (ctx.total_read < ctx.payload_len) {
        const to_read = @min(buf.len, ctx.payload_len - ctx.total_read);
        const n = r.readSliceShort(buf[0..to_read]) catch |err| {
            ctx.err = err;
            conn.deinit();
            return;
        };
        if (n == 0) break;
        ctx.total_read += n;
    }

    const w = conn.writer();
    w.writeAll("done") catch |err| {
        ctx.err = err;
        conn.deinit();
        return;
    };
    w.flush() catch |err| {
        ctx.err = err;
        conn.deinit();
        return;
    };
    conn.close(io);
}

// RFC 8446 §5.1 — plaintext exceeding max_plaintext_len (16384) is split
// across multiple TLS records. Exercises the Writer chunking path.
test "ztls-std: large write spanning multiple records" {
    const io = testIo();

    var fds: [2]std.posix.fd_t = undefined;
    try testing.expectEqual(
        @as(c_int, 0),
        std.c.socketpair(std.posix.AF.UNIX, std.posix.SOCK.STREAM, 0, &fds),
    );
    defer _ = std.c.close(fds[0]);

    const payload_len = frame.max_plaintext_len * 2 + 137;

    var sctx: LargeWriteServerCtx = .{ .fd = fds[1], .payload_len = payload_len };
    const server_thread = try std.Thread.spawn(.{}, largeWriteServerRun, .{&sctx});

    const client_sock: net.Stream = .{
        .socket = .{ .handle = fds[0], .address = .{ .ip4 = undefined } },
    };

    var gpa_state: std.heap.DebugAllocator(.{}) = .init;
    defer _ = gpa_state.deinit();
    const gpa = gpa_state.allocator();

    var conn: Client.Stream = undefined;
    try Client.connect(&conn, gpa, io, client_sock, .{
        .host = "ztls.server.test",
        .verify = .insecure,
        .alpn = &.{"h2"},
    });
    defer conn.deinit();

    const w = conn.writer();
    var payload: [frame.max_plaintext_len * 2 + 137]u8 = undefined;
    for (&payload, 0..) |*b, i| b.* = @intCast(i & 0xff);
    try w.writeAll(&payload);
    try w.flush();

    const r = conn.reader();
    var buf: [4]u8 = undefined;
    const n = try r.readSliceShort(&buf);
    try testing.expectEqualStrings("done", buf[0..n]);

    conn.close(io);

    server_thread.join();
    if (sctx.err) |err| return err;
    try testing.expectEqual(payload_len, sctx.total_read);
}
