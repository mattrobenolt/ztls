//! Per-connection TLS state machine driven by libxev completions.
//!
//! The whole design problem is that ztls-std's drive loop owns the stack:
//!
//!     while (!hs.isConnected()) { const n = blocking_read(...); ... }
//!
//! There is no stack to own here. `pump` is that loop turned inside out — every
//! local became a field, and each completion callback re-enters `pump` to make
//! whatever progress is now possible. `RecordBuffer` makes this workable because
//! its position is already resumable state: a partially drained buffer just
//! needs `next()` called again.
//!
//! Buffers are caller-owned slices, as everywhere in ztls. Records decrypt in
//! place inside `record` storage, so a decrypted record can outlast one `read`
//! if the caller's destination is smaller; `pending` holds the remainder, and
//! nothing may touch the record buffer while it is non-empty.
const std = @import("std");
const assert = std.debug.assert;
const mem = std.mem;
const testing = std.testing;

const xev = @import("xev");
const ztls = @import("ztls");

const root = @import("root.zig");
const ClientConfig = @import("ClientConfig.zig");
const ServerConfig = @import("ServerConfig.zig");

const Error = root.Error;
const State = root.State;
const frame = ztls.frame;
const RecordBuffer = ztls.RecordBuffer;

/// Type-erased callback slots. The public API takes typed `ctx` + comptime
/// callbacks and erases them through a thunk, so callers never see `anyopaque`.
const HandshakeCb = *const fn (?*anyopaque, root.HandshakeResult) void;
const ReadCb = *const fn (?*anyopaque, root.ReadResult) void;
const WriteCb = *const fn (?*anyopaque, root.WriteResult) void;
const CloseCb = *const fn (?*anyopaque) void;

fn Slot(comptime Cb: type) type {
    return struct {
        cb: ?Cb = null,
        ctx: ?*anyopaque = null,

        const Self = @This();
        pub const Taken = struct { cb: Cb, ctx: ?*anyopaque };

        fn armed(s: *const Self) bool {
            return s.cb != null;
        }

        /// Clear before invoking, so the callback may immediately re-arm the
        /// same slot without tripping the `Concurrent` guard.
        fn take(s: *Self) ?Taken {
            const cb = s.cb orelse return null;
            const ctx = s.ctx;
            s.cb = null;
            s.ctx = null;
            return .{ .cb = cb, .ctx = ctx };
        }
    };
}

/// A TLS connection for one role.
///
/// Client and server share the pump, the wire queue, the read and write paths,
/// and teardown. They differ in three places only: which engine they drive, how
/// the handshake starts, and whether a server flight is owed. Parameterising
/// beats duplicating eight hundred lines to change three of them.
pub fn Conn(comptime role: root.Role) type {
    return struct {
        const Self = @This();

        /// The core engine for this role.
        const Handshake = if (role == .client)
            ztls.ClientHandshake
        else
            ztls.ServerHandshake;

        /// Shared across connections: one trust-store load for a client, one
        /// certificate and signer for a server.
        pub const Config = if (role == .client) ClientConfig else ServerConfig;

        /// Smallest plaintext destination `read` will accept. A caller passing less than
        /// this makes no forward progress worth a syscall.
        pub const min_read_buf: usize = 64;

        /// Recommended sizes for the three `Buffers` slices. `record` needs room for a
        /// full wire record plus a straddling partial one; `out` for one outbound
        /// record; `reassembly` for a certificate chain spanning records.
        pub const recommended_record_len: usize = RecordBuffer.recommended_storage;
        pub const recommended_out_len: usize = frame.max_wire_record_len;
        pub const recommended_reassembly_len: usize = if (role == .client)
            ztls.ClientHandshake.recommended_handshake_storage
        else
            ztls.ServerHandshake.ch_reassembly_buffer_size;

        /// Recommended storage for one connection, sized to the defaults above.
        ///
        /// The owner declares this, hands `buffers()` to `init`, and calls `secureZero`
        /// once the connection is `.closed`. ztls-xev never writes to memory it was
        /// lent — the same contract the core keeps with its callers (#81) — so clearing
        /// it is the owner's call, and `ztls.Array` is what makes that one line.
        ///
        /// Callers with a buffer pool skip this and build `Buffers` from their own
        /// slices.
        pub const Storage = struct {
            record: ztls.Array(recommended_record_len) = .empty,
            out: ztls.Array(recommended_out_len) = .empty,
            reassembly: ztls.Array(recommended_reassembly_len) = .empty,

            pub fn buffers(s: *Storage) Buffers {
                return .{
                    .record = &s.record.data,
                    .out = &s.out.data,
                    .reassembly = &s.reassembly.data,
                };
            }

            /// Zero every buffer. The record buffer held decrypted application
            /// plaintext and the reassembly buffer held handshake plaintext, so this is
            /// the counterpart to `Conn.deinit` rather than an optional extra.
            ///
            /// One pass over the whole struct rather than per field: it is a single
            /// volatile memset instead of three, it covers any padding, and a field
            /// added later is zeroed without anyone remembering to update this. Safe
            /// only because every field is an inline byte array — `asBytes` on a struct
            /// holding a slice would zero the header and leave the secret (#81), which
            /// the test below rules out.
            pub fn secureZero(s: *Storage) void {
                std.crypto.secureZero(u8, mem.asBytes(s));
            }
        };

        /// Caller-owned working storage for one connection. Slices rather than comptime
        /// sizes so a server can hand out pooled buffers; see `Storage` for the
        /// batteries-included version.
        pub const Buffers = struct {
            /// Ciphertext staging; records are framed and decrypted in place here.
            /// At least `ztls.RecordBuffer.min_storage`.
            record: []u8,
            /// Outbound record staging. At least `ztls.frame.max_wire_record_len`.
            out: []u8,
            /// Handshake-message reassembly for flights spanning records. Too small
            /// surfaces as `Error.BufferTooSmall`.
            reassembly: []u8,
        };

        /// What the engine is waiting on. `pump` is a function of this plus the
        /// handshake state.
        /// How a close terminates the TLS session. Named tags rather than a bool, so a
        /// call site reads `.abortive` instead of `false`.
        pub const Shutdown = enum {
            /// Send `close_notify` first, so the peer sees an authenticated shutdown.
            /// RFC 8446 §6.1.
            orderly,
            /// Skip `close_notify`: cancel and close. The peer sees a truncated stream,
            /// which is what you want when the connection is already suspect.
            abortive,
        };

        /// See `Conn.pump_state`.
        const PumpState = enum {
            /// Not running; a call will start a pass.
            idle,
            /// A pass is in progress.
            running,
            /// A nested call arrived mid-pass; the outer loop owes another pass.
            rerun_requested,
        };

        const Wait = enum {
            /// Nothing outstanding; `pump` may make progress.
            idle,
            /// A socket write is in flight; resume when it completes.
            writing,
            /// A socket read is in flight; resume when it completes.
            reading,
        };

        loop: *xev.Loop,
        socket: xev.TCP,
        config: *const Config,

        hs: Handshake,
        storage: []u8,
        rb: RecordBuffer,
        out: []u8,

        /// Decrypted application data not yet handed to the caller. Slices into
        /// `storage`, which `rb.next()`/`rb.writable()` invalidate, so the record loop
        /// must not run while this is non-empty.
        pending: []const u8 = &.{},

        /// Wire bytes queued for the transport. Borrowed from `out`, valid until fully
        /// drained. The async analogue of `ztls.Outbox`, whose synchronous
        /// `write(bytes) !usize` writer contract cannot express a completion.
        ///
        /// Every queued buffer came out of the engine, so draining one always owes a
        /// `completeWrite()` — that is an invariant, not a flag to carry around.
        wire: []const u8 = &.{},

        lifecycle: State = .handshaking,
        wait: Wait = .idle,
        /// Failure captured mid-flight, delivered when the operation unwinds.
        failure: ?Error = null,

        handshake_slot: Slot(HandshakeCb) = .{},
        read_slot: Slot(ReadCb) = .{},
        write_slot: Slot(WriteCb) = .{},
        close_slot: Slot(CloseCb) = .{},

        /// Plaintext the caller handed to `write`, still being encrypted and sent.
        write_plaintext: []const u8 = &.{},
        write_accepted: usize = 0,

        /// Destination for the in-flight `read`.
        read_buf: []u8 = &.{},

        read_c: xev.Completion = .{},
        write_c: xev.Completion = .{},
        close_c: xev.Completion = .{},

        /// Reentrancy state of `pump`. One enum rather than `in_pump` + `pump_again`
        /// bools, which between them permit "another pass requested while not running"
        /// — a combination with no meaning. RFC-free bookkeeping, but the illegal state
        /// should still be unrepresentable.
        pump_state: PumpState = .idle,

        /// Guards against a callback re-entering the connection deeper than the
        /// synchronous-completion path can legitimately nest.
        callback_depth: u8 = 0,
        const callback_depth_max: u8 = 8;

        /// Wrap a CONNECTED `xev.TCP` socket. Does not start the handshake — call
        /// `handshake` for that, so a caller doing pre-TLS protocol detection has a
        /// place to stand.
        ///
        /// `io` is used only to seed the handshake random and, client-side, the
        /// certificate validity clock; libxev owns all actual I/O. `host` is SNI plus
        /// the name verified against the peer certificate, and is ignored by a server —
        /// which learns the name from the client instead, via `serverName()`.
        ///
        /// `buffers` stays borrowed for the connection's life and is never written to by
        /// `deinit`. Clearing it afterwards is the owner's job — `Storage.secureZero`
        /// does it — because the record buffer ends up holding decrypted application
        /// plaintext and the reassembly buffer holds handshake plaintext.
        pub fn init(
            self: *Self,
            io: std.Io,
            loop: *xev.Loop,
            socket: xev.TCP,
            config: *const Config,
            host: ?[]const u8,
            buffers: Buffers,
        ) void {
            requireThreadPool(loop);
            assert(buffers.record.len >= RecordBuffer.min_storage);
            assert(buffers.out.len >= frame.max_wire_record_len);
            assert(buffers.reassembly.len > 0);

            var keypair: ztls.x25519.KeyPair = .generate();
            defer keypair.secureZero();
            var random: ztls.Random = .empty;
            io.random(&random.data);
            defer random.secureZero();

            const engine: Handshake = if (role == .client) .init(.{
                .keypairs = .init(keypair),
                .host_name = host,
                .now_sec = std.Io.Timestamp.now(io, .real).toSeconds(),
                .random = random,
                .alpn_protocols = config.alpn,
                .offer_pq_key_share = config.offer_pq_key_share,
            }) else .init(.{
                .keypairs = .init(keypair),
                .random = random,
                .alpn_protocols = config.alpn,
            });

            self.* = .{
                .loop = loop,
                .socket = socket,
                .config = config,
                .hs = engine,
                .storage = buffers.record,
                .rb = .init(buffers.record),
                .out = buffers.out,
            };

            self.hs.useHandshakeBuffer(buffers.reassembly);
            if (role == .client) {
                self.hs.policy.bundle = config.trustAnchors();
                self.hs.policy.insecure_no_chain_anchor = config.insecureNoChainAnchor();
            } else {
                self.hs.setCredentials(config.cert_chain, config.signer);
            }
        }

        /// libxev routes socket close through a thread pool on the readiness
        /// backends (kqueue, epoll) but not on io_uring. With no pool the close
        /// fails `ThreadPoolRequired` and **the fd is never closed**, so the
        /// peer never sees EOF and both sides wait forever. io_uring hides this
        /// completely, which is how it reached macOS unnoticed.
        ///
        /// Asserted at init rather than discovered as a hang. Measured, epoll:
        ///
        ///     pool=false: close_cb=true read_cb=false   (fd still open)
        ///     pool=true:  close_cb=true read_cb=true read_err=error.EOF
        fn requireThreadPool(loop: *xev.Loop) void {
            if (!@hasField(xev.Loop, "thread_pool")) return; // io_uring
            assert(loop.thread_pool != null);
        }

        /// Release engine state. Valid only once the connection is `.closed`.
        ///
        /// Does NOT touch the buffers handed to `init`. They are caller-owned, and
        /// reaching into memory we were lent is exactly what the core refuses to do to
        /// us (#81): the owner may be pooling those buffers, and a per-teardown memset
        /// of a hundred-odd KB is real cost to impose on a server that did not ask for
        /// it. The record buffer held decrypted application plaintext and the
        /// reassembly buffer held handshake plaintext, so the owner should clear them —
        /// `Storage.secureZero` for the common case.
        pub fn deinit(self: *Self) void {
            assert(self.lifecycle == .closed);
            self.hs.deinit();
            self.* = undefined;
        }

        pub fn state(self: *const Self) State {
            return self.lifecycle;
        }

        /// ALPN protocol the peer selected, or null. Valid once `.established`.
        ///
        /// Borrowed from the engine and invalidated by `deinit`. Copy it if you
        /// need it after teardown — holding the slice across `deinit` reads
        /// freed state, and in Debug you will see 0xaa rather than a crash.
        pub fn selectedAlpn(self: *const Self) ?[]const u8 {
            return self.hs.selectedAlpnProtocol();
        }

        /// Negotiated cipher suite. Valid once `.established`. A value, not a
        /// borrow, so unlike `selectedAlpn` it survives `deinit`.
        pub fn cipherSuite(self: *const Self) ztls.CipherSuite {
            return self.hs.cipherSuite();
        }

        // ───────────────
        // Callback plumbing
        // ───────────────

        inline fn enterCallback(self: *Self) void {
            assert(self.callback_depth < callback_depth_max);
            self.callback_depth += 1;
        }

        inline fn leaveCallback(self: *Self) void {
            assert(self.callback_depth > 0);
            self.callback_depth -= 1;
        }

        /// Build the type-erasing thunk for one typed callback. Keeps `anyopaque` out of
        /// the public signatures.
        fn Thunk(comptime Ctx: type, comptime Result: type, comptime cb: anytype) type {
            return struct {
                fn invoke(erased: ?*anyopaque, result: Result) void {
                    cb(@as(Ctx, @ptrCast(@alignCast(erased))), result);
                }
                fn invokeVoid(erased: ?*anyopaque) void {
                    cb(@as(Ctx, @ptrCast(@alignCast(erased))));
                }
            };
        }

        fn deliverHandshake(self: *Self, result: root.HandshakeResult) void {
            const slot = self.handshake_slot.take() orelse return;
            self.enterCallback();
            defer self.leaveCallback();
            slot.cb(slot.ctx, result);
        }

        fn deliverRead(self: *Self, result: root.ReadResult) void {
            const slot = self.read_slot.take() orelse return;
            self.read_buf = &.{};
            self.enterCallback();
            defer self.leaveCallback();
            slot.cb(slot.ctx, result);
        }

        fn deliverWrite(self: *Self, result: root.WriteResult) void {
            const slot = self.write_slot.take() orelse return;
            self.write_plaintext = &.{};
            self.write_accepted = 0;
            self.enterCallback();
            defer self.leaveCallback();
            slot.cb(slot.ctx, result);
        }

        fn deliverClose(self: *Self) void {
            const slot = self.close_slot.take() orelse return;
            self.enterCallback();
            defer self.leaveCallback();
            slot.cb(slot.ctx);
        }

        // ───────────────
        // Operations
        // ───────────────

        /// Run the TLS 1.3 handshake to completion, then invoke `cb` once. On failure
        /// the peer is sent the fatal alert its failure warrants (RFC 8446 §6.2) and the
        /// connection moves to `.closing`.
        pub fn handshake(
            self: *Self,
            ctx: anytype,
            // ziglint-ignore: Z023 -- comptime callback keeps anyopaque out of the API.
            comptime cb: fn (@TypeOf(ctx), root.HandshakeResult) void,
        ) void {
            const T = Thunk(@TypeOf(ctx), root.HandshakeResult, cb);

            if (self.lifecycle.isShuttingDown())
                return self.failHandshakeNow(T.invoke, ctx, error.Closed);
            if (self.lifecycle != .handshaking)
                return self.failHandshakeNow(T.invoke, ctx, error.InvalidState);
            if (self.handshake_slot.armed())
                return self.failHandshakeNow(T.invoke, ctx, error.Concurrent);

            self.handshake_slot = .{ .cb = T.invoke, .ctx = @ptrCast(ctx) };

            // Only a client opens the conversation. A server has nothing to say until
            // it has seen a ClientHello, so it goes straight to pumping, which issues
            // the first read.
            if (role == .client) {
                const hello = self.hs.start(self.out) catch |err|
                    return self.abortHandshake(root.fromCore(err));
                self.queueWire(hello);
            }
            self.pump();
        }

        fn failHandshakeNow(self: *Self, cb: HandshakeCb, ctx: anytype, err: Error) void {
            self.enterCallback();
            defer self.leaveCallback();
            cb(@ptrCast(ctx), .{ .result = err });
        }

        /// Read decrypted application data into `buf`. Delivers exactly one
        /// `ReadResult`. Only one read may be in flight; a write may overlap it.
        pub fn read(
            self: *Self,
            buf: []u8,
            ctx: anytype,
            // ziglint-ignore: Z023 -- comptime callback keeps anyopaque out of the API.
            comptime cb: fn (@TypeOf(ctx), root.ReadResult) void,
        ) void {
            const T = Thunk(@TypeOf(ctx), root.ReadResult, cb);

            if (self.lifecycle.isShuttingDown())
                return self.failReadNow(T.invoke, ctx, error.Closed);
            if (self.lifecycle != .established)
                return self.failReadNow(T.invoke, ctx, error.InvalidState);
            if (self.read_slot.armed())
                return self.failReadNow(T.invoke, ctx, error.Concurrent);
            assert(buf.len >= min_read_buf);

            self.read_slot = .{ .cb = T.invoke, .ctx = @ptrCast(ctx) };
            self.read_buf = buf;
            self.pump();
        }

        fn failReadNow(self: *Self, cb: ReadCb, ctx: anytype, err: Error) void {
            self.enterCallback();
            defer self.leaveCallback();
            cb(@ptrCast(ctx), .{ .err = err });
        }

        /// Encrypt and send `plaintext`. Delivers exactly one `WriteResult` carrying
        /// either the full length or an error — partial socket writes are driven to
        /// completion internally. Zero-length writes complete synchronously.
        pub fn write(
            self: *Self,
            plaintext: []const u8,
            ctx: anytype,
            // ziglint-ignore: Z023 -- comptime callback keeps anyopaque out of the API.
            comptime cb: fn (@TypeOf(ctx), root.WriteResult) void,
        ) void {
            const T = Thunk(@TypeOf(ctx), root.WriteResult, cb);

            if (self.lifecycle.isShuttingDown())
                return self.failWriteNow(T.invoke, ctx, error.Closed);
            if (self.lifecycle != .established)
                return self.failWriteNow(T.invoke, ctx, error.InvalidState);
            if (self.write_slot.armed())
                return self.failWriteNow(T.invoke, ctx, error.Concurrent);

            // Generic forwarding code calls write(&.{}) routinely; a no-op is cheaper
            // than making every caller remember the precondition.
            if (plaintext.len == 0) {
                self.enterCallback();
                defer self.leaveCallback();
                T.invoke(@ptrCast(ctx), .{ .written = 0 });
                return;
            }

            self.write_slot = .{ .cb = T.invoke, .ctx = @ptrCast(ctx) };
            self.write_plaintext = plaintext;
            self.write_accepted = 0;
            self.pump();
        }

        fn failWriteNow(self: *Self, cb: WriteCb, ctx: anytype, err: Error) void {
            self.enterCallback();
            defer self.leaveCallback();
            cb(@ptrCast(ctx), .{ .written = err });
        }

        /// Send `close_notify`, then close the socket. Any operation still in flight has
        /// its callback fired once with `Error.Canceled` first, then `cb` runs. RFC 8446
        /// §6.1.
        pub fn close(
            self: *Self,
            ctx: anytype,
            // ziglint-ignore: Z023 -- comptime callback keeps anyopaque out of the API.
            comptime cb: fn (@TypeOf(ctx)) void,
        ) void {
            self.beginClose(Thunk(@TypeOf(ctx), void, cb).invokeVoid, @ptrCast(ctx), .orderly);
        }

        /// Close abortively: no `close_notify`, just cancel and close. The peer sees a
        /// truncated stream, which is what you want when the connection is already
        /// suspect.
        pub fn closeReset(
            self: *Self,
            ctx: anytype,
            // ziglint-ignore: Z023 -- comptime callback keeps anyopaque out of the API.
            comptime cb: fn (@TypeOf(ctx)) void,
        ) void {
            self.beginClose(Thunk(@TypeOf(ctx), void, cb).invokeVoid, @ptrCast(ctx), .abortive);
        }

        fn beginClose(self: *Self, cb: CloseCb, ctx: ?*anyopaque, shutdown: Shutdown) void {
            if (self.lifecycle == .closed) {
                self.enterCallback();
                defer self.leaveCallback();
                cb(ctx);
                return;
            }
            if (self.lifecycle == .closing) {
                // A close is already unwinding; chain onto it rather than racing.
                self.close_slot = .{ .cb = cb, .ctx = ctx };
                return;
            }

            const was_established = self.lifecycle == .established;
            self.lifecycle = .closing;
            self.close_slot = .{ .cb = cb, .ctx = ctx };

            // Cancel in-flight work first: each callback fires exactly once with
            // Canceled, before the close callback.
            self.cancelInFlight();

            if (shutdown == .orderly and was_established) {
                // Best effort: a close_notify that cannot be encoded or sent changes
                // nothing about the outcome.
                if (self.hs.sendAlert(.close_notify, self.out)) |record| {
                    self.queueWire(record);
                    self.issueWrite();
                    return;
                } else |_| {}
            }
            self.issueSocketClose();
        }

        fn cancelInFlight(self: *Self) void {
            self.pending = &.{};
            if (self.handshake_slot.armed()) self.deliverHandshake(.{ .result = error.Canceled });
            if (self.read_slot.armed()) self.deliverRead(.{ .err = error.Canceled });
            if (self.write_slot.armed()) self.deliverWrite(.{ .written = error.Canceled });
        }

        // ───────────────
        // The pump: ztls-std's blocking drive loop, inverted
        // ───────────────

        /// Make whatever progress is currently possible, then return, having either
        /// delivered a result or armed a completion that will call back into here.
        ///
        /// Non-reentrant by construction. Delivering a result runs caller code, and
        /// callers routinely issue the next operation from inside a callback, which
        /// re-enters here — so a nested call just records that another pass is needed
        /// and returns. Without that guard the outer pass would keep going after the
        /// nested one already armed a completion, and arm the same `xev.Completion`
        /// twice.
        fn pump(self: *Self) void {
            if (self.pump_state != .idle) {
                self.pump_state = .rerun_requested;
                return;
            }
            self.pump_state = .running;
            defer self.pump_state = .idle;

            while (true) {
                self.pumpOnce();
                if (self.pump_state != .rerun_requested) break;
                self.pump_state = .running;
            }
        }

        /// One pass: take at most one action, then return. Ordering matters. Wire bytes
        /// go out first because the engine is write-blocked until they drain; then a
        /// completed handshake is reported; then buffered records are drained; and only
        /// if something is still waiting do we ask the transport for more.
        fn pumpOnce(self: *Self) void {
            if (self.lifecycle.isShuttingDown()) return;
            if (self.wait != .idle) return;

            if (self.wire.len > 0) return self.issueWrite();

            // RFC 8446 §4.3-§4.4 — once ServerHello has installed handshake keys, the
            // server owes EncryptedExtensions/Certificate/CertificateVerify/Finished.
            // `sendPreparedServerFlight` self-guards: it returns null before the keys
            // exist and after the flight has gone, so calling it every pass needs no
            // extra state of our own.
            if (role == .server) {
                if (self.hs.sendPreparedServerFlight(self.out)) |maybe_flight| {
                    if (maybe_flight) |flight| {
                        self.queueWire(flight);
                        return self.issueWrite();
                    }
                } else |err| {
                    self.abortWith(root.fromCore(err));
                    return;
                }
            }

            // A client's last handshake step is sending Finished, so completion
            // becomes observable when that write drains and re-enters here.
            if (self.reportHandshakeIfConnected()) return;

            // An in-flight application write turns into wire bytes here, once the
            // engine is no longer blocked on a previous record.
            if (self.write_slot.armed() and self.encryptNextChunk()) return;

            if (self.drainRecords()) return;

            // Checked again after draining: a server's last handshake step is
            // *receiving* Finished, which produces no write to bounce off, so
            // the connection can become established inside a single pass. Miss
            // this and the server issues a read while still nominally
            // handshaking, and the peer's next event — commonly EOF, for a
            // client that says its piece and hangs up — is misreported as a
            // failed handshake.
            if (self.reportHandshakeIfConnected()) return;

            // Anything still waiting needs more bytes from the peer.
            if (self.handshake_slot.armed() or self.read_slot.armed()) return self.issueRead();
        }

        /// Move to `.established` and report it, once. Returns true when the
        /// callback ran, which ends the current pump pass.
        fn reportHandshakeIfConnected(self: *Self) bool {
            if (!self.handshake_slot.armed() or !self.hs.isConnected()) return false;
            self.lifecycle = .established;
            self.deliverHandshake(.{ .result = {} });
            return true;
        }

        /// Encrypt the next chunk of the caller's plaintext into `out` and queue it.
        /// Returns true when this pass took an action — either a record went out or the
        /// write's result was delivered. Both end the pass.
        fn encryptNextChunk(self: *Self) bool {
            const rest = self.write_plaintext[self.write_accepted..];
            if (rest.len == 0) {
                // Every chunk is on the wire; RFC 8446 §5.2 splitting is invisible to
                // the caller, which sees one all-or-nothing result.
                self.deliverWrite(.{ .written = self.write_accepted });
                return true;
            }
            const chunk_len = @min(rest.len, frame.max_plaintext_len);
            const record = self.hs.sendApplicationData(rest[0..chunk_len], self.out) catch |err| {
                self.deliverWrite(.{ .written = root.fromCore(err) });
                return true;
            };
            self.write_accepted += chunk_len;
            self.queueWire(record);
            self.issueWrite();
            return true;
        }

        /// The two engines' event unions differ by exactly one tag: only a client
        /// receives NewSessionTicket. Normalising at the boundary keeps the record loop
        /// to a single switch instead of two near-identical ones.
        ///
        /// Session tickets are swallowed. Resumption is not a supported surface, and
        /// surfacing an event a caller can do nothing with is worse than dropping it.
        fn normalizeEvent(ev: Handshake.Event) Normalized {
            return if (role == .client) switch (ev) {
                .application_data => |data| .{ .application_data = data },
                .write => |bytes| .{ .write = bytes },
                .key_update => |update| .{ .key_update = update.response },
                .new_session_ticket, .none => .none,
                .closed => .closed,
            } else switch (ev) {
                .application_data => |data| .{ .application_data = data },
                .write => |bytes| .{ .write = bytes },
                .key_update => |update| .{ .key_update = update.response },
                .none => .none,
                .closed => .closed,
            };
        }

        const Normalized = union(enum) {
            application_data: []const u8,
            write: []const u8,
            key_update: ?[]const u8,
            none,
            closed,
        };

        /// Consume buffered records until one produces something a caller is waiting
        /// for, or the buffer runs dry. Returns true when a completion was armed or a
        /// result delivered, meaning the caller of `pump` must not continue.
        fn drainRecords(self: *Self) bool {
            // A partially consumed record must be finished before touching the buffer.
            if (self.pending.len > 0) return self.deliverPending();

            var idle: usize = 0;
            while (true) {
                const record = (self.rb.next() catch |err| {
                    self.abortWith(root.fromCore(err));
                    return true;
                }) orelse return false;

                if (idle == max_idle_records) {
                    self.abortWith(error.ProtocolError);
                    return true;
                }
                idle += 1;

                const ev = self.hs.handleRecord(record, self.out) catch |err| {
                    self.abortWith(root.fromCore(err));
                    return true;
                };

                switch (normalizeEvent(ev)) {
                    .none => {},
                    .write => |bytes| {
                        self.queueWire(bytes);
                        self.issueWrite();
                        return true;
                    },
                    .key_update => |response| {
                        if (response) |bytes| {
                            self.queueWire(bytes);
                            self.issueWrite();
                            return true;
                        }
                    },
                    .closed => {
                        self.deliverRead(.close_notify);
                        return true;
                    },
                    .application_data => |data| {
                        // RFC 8446 §5.1 permits zero-length fragments; they carry
                        // nothing, so skip rather than surface an empty read.
                        if (data.len == 0) continue;
                        self.pending = data;
                        return self.deliverPending();
                    },
                }

                // Handshake completion is reported by `pumpOnce`, not here: the loop
                // exits early to send the client Finished, so `isConnected` only becomes
                // true after that write drains.
                if (self.hs.isConnected()) return false;
            }
        }

        /// Hand as much pending plaintext as the caller's buffer takes. Returns true
        /// when something was delivered.
        fn deliverPending(self: *Self) bool {
            if (!self.read_slot.armed()) return false;
            const n = @min(self.read_buf.len, self.pending.len);
            @memcpy(self.read_buf[0..n], self.pending[0..n]);
            const delivered = self.read_buf[0..n];
            self.pending = self.pending[n..];
            self.deliverRead(.{ .data = delivered });
            return true;
        }

        /// Records a peer may spend without producing progress. RFC 8446 §5.1
        /// rate-limits zero-length fragments nowhere; the core caps KeyUpdate and
        /// NewSessionTicket floods itself.
        const max_idle_records: usize = 64;

        fn queueWire(self: *Self, bytes: []const u8) void {
            assert(self.wire.len == 0);
            self.wire = bytes;
        }

        fn abortWith(self: *Self, err: Error) void {
            self.failure = err;
            if (self.handshake_slot.armed()) return self.abortHandshake(err);
            if (self.read_slot.armed()) self.deliverRead(.{ .err = err });
            if (self.write_slot.armed()) self.deliverWrite(.{ .written = err });
        }

        /// RFC 8446 §6.2 — tell the peer why before closing, so it logs a reason rather
        /// than a bare FIN.
        fn abortHandshake(self: *Self, err: Error) void {
            const description = alertFor(err);
            self.lifecycle = .closing;
            self.deliverHandshake(.{ .result = err });
            if (description) |d| {
                if (self.hs.sendAlert(d, self.out)) |record| {
                    self.queueWire(record);
                    self.issueWrite();
                    return;
                } else |_| {}
            }
            self.issueSocketClose();
        }

        fn alertFor(err: Error) ?ztls.alert.Description {
            return switch (err) {
                error.CertificateVerificationFailed => .bad_certificate,
                error.DecryptError => .decrypt_error,
                error.ProtocolError => .illegal_parameter,
                error.RecordOverflow => .record_overflow,
                error.AlpnRejected => .no_application_protocol,
                error.BufferTooSmall, error.InternalError => .internal_error,
                // The peer already aborted, or nothing was negotiated to alert about.
                error.AlertReceived, error.Canceled, error.Closed => null,
                error.Concurrent, error.InvalidState, error.IoError => null,
            };
        }

        // ───────────────
        // libxev completions
        // ───────────────

        fn issueWrite(self: *Self) void {
            assert(self.wire.len > 0);
            self.wait = .writing;
            self.socket.write(
                self.loop,
                &self.write_c,
                .{ .slice = self.wire },
                Self,
                self,
                onWriteComplete,
            );
        }

        fn onWriteComplete(
            self_opt: ?*Self,
            _: *xev.Loop,
            _: *xev.Completion,
            _: xev.TCP,
            _: xev.WriteBuffer,
            r: xev.WriteError!usize,
        ) xev.CallbackAction {
            const self = self_opt.?;
            self.wait = .idle;

            const n = r catch {
                self.onTransportFailure();
                return .disarm;
            };
            assert(n <= self.wire.len);
            self.wire = self.wire[n..];

            if (self.wire.len > 0) {
                // Partial write: keep going without telling the caller.
                self.issueWrite();
                return .disarm;
            }

            // Every queued buffer came from the engine, so a fully drained one always
            // settles the pending-write latch.
            self.hs.completeWrite();

            if (self.lifecycle == .closing) {
                // The close_notify (or a fatal alert) just drained.
                self.issueSocketClose();
                return .disarm;
            }

            self.pump();
            return .disarm;
        }

        fn issueRead(self: *Self) void {
            const writable = self.rb.writable();
            if (writable.len == 0) {
                // Cannot happen with a correctly sized record buffer: a complete record
                // always fits, so the buffer cannot be full with nothing to drain.
                self.abortWith(error.BufferTooSmall);
                return;
            }
            self.wait = .reading;
            self.socket.read(
                self.loop,
                &self.read_c,
                .{ .slice = writable },
                Self,
                self,
                onReadComplete,
            );
        }

        fn onReadComplete(
            self_opt: ?*Self,
            _: *xev.Loop,
            _: *xev.Completion,
            _: xev.TCP,
            _: xev.ReadBuffer,
            r: xev.ReadError!usize,
        ) xev.CallbackAction {
            const self = self_opt.?;
            self.wait = .idle;

            const n = r catch |err| switch (err) {
                // RFC 8446 §6.1 requires close_notify; a bare EOF is a truncated
                // stream, which is a distinct outcome from an orderly shutdown.
                error.EOF => {
                    self.onTransportEof();
                    return .disarm;
                },
                else => {
                    self.onTransportFailure();
                    return .disarm;
                },
            };
            if (n == 0) {
                self.onTransportEof();
                return .disarm;
            }

            self.rb.advance(n);
            self.pump();
            return .disarm;
        }

        fn onTransportEof(self: *Self) void {
            // Already tearing down: the peer hanging up mid-close is the normal case,
            // not something to report. Finish the teardown or the close callback never
            // fires and the caller waits forever.
            if (self.lifecycle == .closing) return self.issueSocketClose();
            if (self.handshake_slot.armed()) {
                // A handshake cut short is a failure, not an EOF a caller can act on.
                return self.abortHandshake(error.ProtocolError);
            }
            if (self.read_slot.armed()) self.deliverRead(.eof);
            if (self.write_slot.armed()) self.deliverWrite(.{ .written = error.IoError });
        }

        fn onTransportFailure(self: *Self) void {
            // A failed close_notify (BrokenPipe, because the peer closed first) must
            // still complete the teardown.
            if (self.lifecycle == .closing) return self.issueSocketClose();
            if (self.handshake_slot.armed()) return self.abortHandshake(error.IoError);
            if (self.read_slot.armed()) self.deliverRead(.{ .err = error.IoError });
            if (self.write_slot.armed()) self.deliverWrite(.{ .written = error.IoError });
        }

        fn issueSocketClose(self: *Self) void {
            self.lifecycle = .closing;
            self.socket.close(self.loop, &self.close_c, Self, self, onSocketClosed);
        }

        fn onSocketClosed(
            self_opt: ?*Self,
            _: *xev.Loop,
            _: *xev.Completion,
            _: xev.TCP,
            _: xev.CloseError!void,
        ) xev.CallbackAction {
            const self = self_opt.?;
            self.wait = .idle;
            self.lifecycle = .closed;
            self.deliverClose();
            return .disarm;
        }
    };
}

// ───────────────────────────────
// Tests
// ───────────────────────────────
//
// Role-independent behaviour is exercised through the client instantiation;
// anything genuinely role-specific belongs in the round-trip suite, which needs
// a peer and a running loop.

/// Role-independent behaviour is exercised through the client instantiation.
const TestConn = Conn(.client);
//
// End-to-end coverage needs a peer and a running loop, and lives in
// src/tests.zig. These pin the contracts that are checkable without I/O.

// `TestConn.Storage.secureZero` zeroes `asBytes(self)`, which is only correct while every
// field owns its bytes inline. A slice or pointer field would make it zero the
// header and leave the secret exactly where it was — the #81 bug. This fails at
// compile time if someone adds one.
test "TestConn.Storage: every field owns its bytes inline, so a whole-struct wipe is sound" {
    var total: usize = 0;
    inline for (@typeInfo(TestConn.Storage).@"struct".fields) |field| {
        const info = @typeInfo(field.type);
        if (info != .@"struct" or !@hasField(field.type, "data")) @compileError(
            "Storage." ++ field.name ++ " is not a ztls.Array: Storage.secureZero wipes " ++
                "asBytes(self), which only clears bytes the struct owns inline",
        );
        const data_info = @typeInfo(@FieldType(field.type, "data"));
        if (data_info != .array or data_info.array.child != u8) @compileError(
            "Storage." ++ field.name ++ ".data is not a byte array",
        );
        total += @sizeOf(field.type);
    }
    // No padding, so the one-pass wipe covers exactly the buffers and nothing
    // is silently skipped.
    try testing.expectEqual(total, @sizeOf(TestConn.Storage));
}

test "TestConn.Storage: secureZero clears all three buffers in one pass" {
    var storage: TestConn.Storage = .{};
    @memset(&storage.record.data, 0xa5);
    @memset(&storage.out.data, 0xa5);
    @memset(&storage.reassembly.data, 0xa5);

    storage.secureZero();

    try testing.expect(mem.allEqual(u8, mem.asBytes(&storage), 0));
}

test "Buffers: documented minimums match what init asserts" {
    try testing.expect(TestConn.recommended_record_len >= RecordBuffer.min_storage);
    try testing.expect(TestConn.recommended_out_len >= frame.max_wire_record_len);
    try testing.expect(TestConn.recommended_reassembly_len > 0);
}

// Every failure a caller can be handed must map to a peer-visible reason or an
// explicit decision not to send one. A new Error variant fails this switch.
test "TestConn.alertFor: every error is classified, and peer-fault errors get an alert" {
    const D = ztls.alert.Description;
    const cert_failed = error.CertificateVerificationFailed;
    try testing.expectEqual(D.bad_certificate, TestConn.alertFor(cert_failed).?);
    try testing.expectEqual(D.decrypt_error, TestConn.alertFor(error.DecryptError).?);
    try testing.expectEqual(D.illegal_parameter, TestConn.alertFor(error.ProtocolError).?);
    try testing.expectEqual(D.no_application_protocol, TestConn.alertFor(error.AlpnRejected).?);
    // The peer already told us; RFC 8446 §6.2 says close without replying.
    try testing.expectEqual(@as(?D, null), TestConn.alertFor(error.AlertReceived));
    // Local bookkeeping failures never reach the wire.
    try testing.expectEqual(@as(?D, null), TestConn.alertFor(error.Concurrent));
    try testing.expectEqual(@as(?D, null), TestConn.alertFor(error.Closed));
}

test "Slot: take clears before invoking so a callback may re-arm" {
    var slot: Slot(CloseCb) = .{};
    try testing.expect(!slot.armed());

    var sentinel: u8 = 0;
    slot = .{ .cb = struct {
        fn f(_: ?*anyopaque) void {}
    }.f, .ctx = @ptrCast(&sentinel) };
    try testing.expect(slot.armed());

    const taken = slot.take();
    try testing.expect(taken != null);
    // Cleared before the callback runs, which is what lets a read callback issue
    // the next read without tripping the Concurrent guard.
    try testing.expect(!slot.armed());
    try testing.expectEqual(@as(?*anyopaque, @ptrCast(&sentinel)), taken.?.ctx);
    try testing.expectEqual(@as(?Slot(CloseCb).Taken, null), slot.take());
}
