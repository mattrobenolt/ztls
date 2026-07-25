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
const Config = @import("Config.zig");

const Error = root.Error;
const State = root.State;
const frame = ztls.frame;
const RecordBuffer = ztls.RecordBuffer;

const Conn = @This();

/// Smallest plaintext destination `read` will accept. A caller passing less than
/// this makes no forward progress worth a syscall.
pub const min_read_buf: usize = 64;

/// Recommended sizes for the three `Buffers` slices. `record` needs room for a
/// full wire record plus a straddling partial one; `out` for one outbound
/// record; `reassembly` for a certificate chain spanning records.
pub const recommended_record_len: usize = RecordBuffer.recommended_storage;
pub const recommended_out_len: usize = frame.max_wire_record_len;
pub const recommended_reassembly_len: usize = ztls.ClientHandshake.recommended_handshake_storage;

/// Caller-owned working storage for one connection. Slices rather than comptime
/// sizes so a server can hand out pooled buffers.
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

/// What the engine is waiting on. `pump` is a function of this plus the
/// handshake state.
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

hs: ztls.ClientHandshake,
storage: []u8,
rb: RecordBuffer,
out: []u8,

/// Decrypted application data not yet handed to the caller. Slices into
/// `storage`, which `rb.next()`/`rb.writable()` invalidate, so the record loop
/// must not run while this is non-empty.
pending: []const u8 = &.{},

/// Wire bytes queued for the transport. Borrowed from `out` (or from the engine,
/// which writes into `out`), valid until fully drained. The async analogue of
/// `ztls.Outbox`, whose synchronous `write(bytes) !usize` writer contract cannot
/// express a completion.
wire: []const u8 = &.{},
/// Set while the engine owes a `completeWrite()` once `wire` drains.
wire_completes_engine_write: bool = false,

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

/// Set while `pump` is running, so a nested call from inside a callback defers
/// to the outer pass instead of arming a completion twice.
in_pump: bool = false,
pump_again: bool = false,

/// Guards against a callback re-entering the connection deeper than the
/// synchronous-completion path can legitimately nest.
callback_depth: u8 = 0,
const callback_depth_max: u8 = 8;

/// Wrap a CONNECTED `xev.TCP` socket. Does not start the handshake — call
/// `handshake` for that, so a caller doing pre-TLS protocol detection has a
/// place to stand.
///
/// `io` is used only to seed the ClientHello random and the certificate validity
/// clock; libxev owns all actual I/O. `host` is SNI plus the name verified
/// against the peer certificate; null disables both.
pub fn init(
    self: *Conn,
    io: std.Io,
    loop: *xev.Loop,
    socket: xev.TCP,
    config: *const Config,
    host: ?[]const u8,
    buffers: Buffers,
) void {
    assert(buffers.record.len >= RecordBuffer.min_storage);
    assert(buffers.out.len >= frame.max_wire_record_len);
    assert(buffers.reassembly.len > 0);

    var keypair: ztls.x25519.KeyPair = .generate();
    defer keypair.secureZero();
    var random: ztls.Random = .empty;
    io.random(&random.data);
    defer random.secureZero();

    self.* = .{
        .loop = loop,
        .socket = socket,
        .config = config,
        .hs = .init(.{
            .keypairs = .init(keypair),
            .host_name = host,
            .now_sec = std.Io.Timestamp.now(io, .real).toSeconds(),
            .random = random,
            .alpn_protocols = config.alpn,
            .offer_pq_key_share = config.offer_pq_key_share,
        }),
        .storage = buffers.record,
        .rb = .init(buffers.record),
        .out = buffers.out,
    };

    self.hs.useHandshakeBuffer(buffers.reassembly);
    self.hs.policy.bundle = config.trustAnchors();
    self.hs.policy.insecure_no_chain_anchor = config.insecureNoChainAnchor();
}

/// Release engine state and zero the buffers this connection was lent.
///
/// The core deliberately does not clear caller-owned storage (#81), and the
/// record buffer held decrypted application plaintext, so somebody has to.
/// Valid only once the connection is `.closed`.
pub fn deinit(self: *Conn) void {
    assert(self.lifecycle == .closed);
    self.hs.deinit();
    std.crypto.secureZero(u8, self.storage);
    std.crypto.secureZero(u8, self.out);
    self.* = undefined;
}

pub fn state(self: *const Conn) State {
    return self.lifecycle;
}

/// ALPN protocol the peer selected, or null. Valid once `.established`.
pub fn selectedAlpn(self: *const Conn) ?[]const u8 {
    return self.hs.selectedAlpnProtocol();
}

/// Negotiated cipher suite. Valid once `.established`.
pub fn cipherSuite(self: *const Conn) ztls.CipherSuite {
    return self.hs.cipherSuite();
}

// ───────────────────────────────
// Callback plumbing
// ───────────────────────────────

inline fn enterCallback(self: *Conn) void {
    assert(self.callback_depth < callback_depth_max);
    self.callback_depth += 1;
}

inline fn leaveCallback(self: *Conn) void {
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

fn deliverHandshake(self: *Conn, result: root.HandshakeResult) void {
    const slot = self.handshake_slot.take() orelse return;
    self.enterCallback();
    defer self.leaveCallback();
    slot.cb(slot.ctx, result);
}

fn deliverRead(self: *Conn, result: root.ReadResult) void {
    const slot = self.read_slot.take() orelse return;
    self.read_buf = &.{};
    self.enterCallback();
    defer self.leaveCallback();
    slot.cb(slot.ctx, result);
}

fn deliverWrite(self: *Conn, result: root.WriteResult) void {
    const slot = self.write_slot.take() orelse return;
    self.write_plaintext = &.{};
    self.write_accepted = 0;
    self.enterCallback();
    defer self.leaveCallback();
    slot.cb(slot.ctx, result);
}

fn deliverClose(self: *Conn) void {
    const slot = self.close_slot.take() orelse return;
    self.enterCallback();
    defer self.leaveCallback();
    slot.cb(slot.ctx);
}

// ───────────────────────────────
// Operations
// ───────────────────────────────

/// Run the TLS 1.3 handshake to completion, then invoke `cb` once. On failure
/// the peer is sent the fatal alert its failure warrants (RFC 8446 §6.2) and the
/// connection moves to `.closing`.
pub fn handshake(
    self: *Conn,
    ctx: anytype,
    // ziglint-ignore: Z023 -- comptime callback keeps anyopaque out of the API.
    comptime cb: fn (@TypeOf(ctx), root.HandshakeResult) void,
) void {
    const T = Thunk(@TypeOf(ctx), root.HandshakeResult, cb);

    if (self.lifecycle == .closing or self.lifecycle == .closed)
        return self.failHandshakeNow(T.invoke, ctx, error.Closed);
    if (self.lifecycle != .handshaking)
        return self.failHandshakeNow(T.invoke, ctx, error.InvalidState);
    if (self.handshake_slot.armed())
        return self.failHandshakeNow(T.invoke, ctx, error.Concurrent);

    self.handshake_slot = .{ .cb = T.invoke, .ctx = @ptrCast(ctx) };

    const hello = self.hs.start(self.out) catch |err|
        return self.abortHandshake(root.fromCore(err));
    self.queueWire(hello, true);
    self.pump();
}

fn failHandshakeNow(self: *Conn, cb: HandshakeCb, ctx: anytype, err: Error) void {
    self.enterCallback();
    defer self.leaveCallback();
    cb(@ptrCast(ctx), .{ .result = err });
}

/// Read decrypted application data into `buf`. Delivers exactly one
/// `ReadResult`. Only one read may be in flight; a write may overlap it.
pub fn read(
    self: *Conn,
    buf: []u8,
    ctx: anytype,
    // ziglint-ignore: Z023 -- comptime callback keeps anyopaque out of the API.
    comptime cb: fn (@TypeOf(ctx), root.ReadResult) void,
) void {
    const T = Thunk(@TypeOf(ctx), root.ReadResult, cb);

    if (self.lifecycle == .closing or self.lifecycle == .closed)
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

fn failReadNow(self: *Conn, cb: ReadCb, ctx: anytype, err: Error) void {
    self.enterCallback();
    defer self.leaveCallback();
    cb(@ptrCast(ctx), .{ .err = err });
}

/// Encrypt and send `plaintext`. Delivers exactly one `WriteResult` carrying
/// either the full length or an error — partial socket writes are driven to
/// completion internally. Zero-length writes complete synchronously.
pub fn write(
    self: *Conn,
    plaintext: []const u8,
    ctx: anytype,
    // ziglint-ignore: Z023 -- comptime callback keeps anyopaque out of the API.
    comptime cb: fn (@TypeOf(ctx), root.WriteResult) void,
) void {
    const T = Thunk(@TypeOf(ctx), root.WriteResult, cb);

    if (self.lifecycle == .closing or self.lifecycle == .closed)
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

fn failWriteNow(self: *Conn, cb: WriteCb, ctx: anytype, err: Error) void {
    self.enterCallback();
    defer self.leaveCallback();
    cb(@ptrCast(ctx), .{ .written = err });
}

/// Send `close_notify`, then close the socket. Any operation still in flight has
/// its callback fired once with `Error.Canceled` first, then `cb` runs. RFC 8446
/// §6.1.
pub fn close(
    self: *Conn,
    ctx: anytype,
    // ziglint-ignore: Z023 -- comptime callback keeps anyopaque out of the API.
    comptime cb: fn (@TypeOf(ctx)) void,
) void {
    self.beginClose(Thunk(@TypeOf(ctx), void, cb).invokeVoid, @ptrCast(ctx), true);
}

/// Close abortively: no `close_notify`, just cancel and close. The peer sees a
/// truncated stream, which is what you want when the connection is already
/// suspect.
pub fn closeReset(
    self: *Conn,
    ctx: anytype,
    // ziglint-ignore: Z023 -- comptime callback keeps anyopaque out of the API.
    comptime cb: fn (@TypeOf(ctx)) void,
) void {
    self.beginClose(Thunk(@TypeOf(ctx), void, cb).invokeVoid, @ptrCast(ctx), false);
}

fn beginClose(self: *Conn, cb: CloseCb, ctx: ?*anyopaque, orderly: bool) void {
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

    if (orderly and was_established) {
        // Best effort: a close_notify that cannot be encoded or sent changes
        // nothing about the outcome.
        if (self.hs.sendAlert(.close_notify, self.out)) |record| {
            self.wire = record;
            self.wire_completes_engine_write = true;
            self.issueWrite();
            return;
        } else |_| {}
    }
    self.issueSocketClose();
}

fn cancelInFlight(self: *Conn) void {
    self.pending = &.{};
    if (self.handshake_slot.armed()) self.deliverHandshake(.{ .result = error.Canceled });
    if (self.read_slot.armed()) self.deliverRead(.{ .err = error.Canceled });
    if (self.write_slot.armed()) self.deliverWrite(.{ .written = error.Canceled });
}

// ───────────────────────────────
// The pump: ztls-std's blocking drive loop, inverted
// ───────────────────────────────

/// Make whatever progress is currently possible, then return, having either
/// delivered a result or armed a completion that will call back into here.
///
/// Non-reentrant by construction. Delivering a result runs caller code, and
/// callers routinely issue the next operation from inside a callback, which
/// re-enters here — so a nested call just records that another pass is needed
/// and returns. Without that guard the outer pass would keep going after the
/// nested one already armed a completion, and arm the same `xev.Completion`
/// twice.
fn pump(self: *Conn) void {
    if (self.in_pump) {
        self.pump_again = true;
        return;
    }
    self.in_pump = true;
    defer self.in_pump = false;

    while (true) {
        self.pump_again = false;
        self.pumpOnce();
        if (!self.pump_again) break;
    }
}

/// One pass: take at most one action, then return. Ordering matters. Wire bytes
/// go out first because the engine is write-blocked until they drain; then a
/// completed handshake is reported; then buffered records are drained; and only
/// if something is still waiting do we ask the transport for more.
fn pumpOnce(self: *Conn) void {
    if (self.lifecycle == .closing or self.lifecycle == .closed) return;
    if (self.wait != .idle) return;

    if (self.wire.len > 0) return self.issueWrite();

    // Observable as soon as the last flight drained. Checked here rather than
    // inside the record loop because the loop returns early to send the client
    // Finished, so the connection becomes established between passes.
    if (self.handshake_slot.armed() and self.hs.isConnected()) {
        self.lifecycle = .established;
        self.deliverHandshake(.{ .result = {} });
        return;
    }

    // An in-flight application write turns into wire bytes here, once the
    // engine is no longer blocked on a previous record.
    if (self.write_slot.armed() and self.encryptNextChunk()) return;

    if (self.drainRecords()) return;

    // Anything still waiting needs more bytes from the peer.
    if (self.handshake_slot.armed() or self.read_slot.armed()) return self.issueRead();
}

/// Encrypt the next chunk of the caller's plaintext into `out` and queue it.
/// Returns true when this pass took an action — either a record went out or the
/// write's result was delivered. Both end the pass.
fn encryptNextChunk(self: *Conn) bool {
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
    self.queueWire(record, true);
    self.issueWrite();
    return true;
}

/// Consume buffered records until one produces something a caller is waiting
/// for, or the buffer runs dry. Returns true when a completion was armed or a
/// result delivered, meaning the caller of `pump` must not continue.
fn drainRecords(self: *Conn) bool {
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

        switch (ev) {
            .none, .new_session_ticket => {},
            .write => |bytes| {
                self.queueWire(bytes, true);
                self.issueWrite();
                return true;
            },
            .key_update => |update| {
                if (update.response) |bytes| {
                    self.queueWire(bytes, true);
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
fn deliverPending(self: *Conn) bool {
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

fn queueWire(self: *Conn, bytes: []const u8, completes_engine_write: bool) void {
    assert(self.wire.len == 0);
    self.wire = bytes;
    self.wire_completes_engine_write = completes_engine_write;
}

fn abortWith(self: *Conn, err: Error) void {
    self.failure = err;
    if (self.handshake_slot.armed()) return self.abortHandshake(err);
    if (self.read_slot.armed()) self.deliverRead(.{ .err = err });
    if (self.write_slot.armed()) self.deliverWrite(.{ .written = err });
}

/// RFC 8446 §6.2 — tell the peer why before closing, so it logs a reason rather
/// than a bare FIN.
fn abortHandshake(self: *Conn, err: Error) void {
    const description = alertFor(err);
    self.lifecycle = .closing;
    self.deliverHandshake(.{ .result = err });
    if (description) |d| {
        if (self.hs.sendAlert(d, self.out)) |record| {
            self.wire = record;
            self.wire_completes_engine_write = true;
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

// ───────────────────────────────
// libxev completions
// ───────────────────────────────

fn issueWrite(self: *Conn) void {
    assert(self.wire.len > 0);
    self.wait = .writing;
    self.socket.write(
        self.loop,
        &self.write_c,
        .{ .slice = self.wire },
        Conn,
        self,
        onWriteComplete,
    );
}

fn onWriteComplete(
    self_opt: ?*Conn,
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

    if (self.wire_completes_engine_write) {
        self.wire_completes_engine_write = false;
        self.hs.completeWrite();
    }

    if (self.lifecycle == .closing) {
        // The close_notify (or a fatal alert) just drained.
        self.issueSocketClose();
        return .disarm;
    }

    self.pump();
    return .disarm;
}

fn issueRead(self: *Conn) void {
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
        Conn,
        self,
        onReadComplete,
    );
}

fn onReadComplete(
    self_opt: ?*Conn,
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

fn onTransportEof(self: *Conn) void {
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

fn onTransportFailure(self: *Conn) void {
    // A failed close_notify (BrokenPipe, because the peer closed first) must
    // still complete the teardown.
    if (self.lifecycle == .closing) return self.issueSocketClose();
    if (self.handshake_slot.armed()) return self.abortHandshake(error.IoError);
    if (self.read_slot.armed()) self.deliverRead(.{ .err = error.IoError });
    if (self.write_slot.armed()) self.deliverWrite(.{ .written = error.IoError });
}

fn issueSocketClose(self: *Conn) void {
    self.lifecycle = .closing;
    self.socket.close(self.loop, &self.close_c, Conn, self, onSocketClosed);
}

fn onSocketClosed(
    self_opt: ?*Conn,
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

// ───────────────────────────────
// Tests
// ───────────────────────────────
//
// End-to-end coverage needs a peer and a running loop, and lives in
// src/tests.zig. These pin the contracts that are checkable without I/O.

test "Buffers: documented minimums match what init asserts" {
    try testing.expect(recommended_record_len >= RecordBuffer.min_storage);
    try testing.expect(recommended_out_len >= frame.max_wire_record_len);
    try testing.expect(recommended_reassembly_len > 0);
}

// Every failure a caller can be handed must map to a peer-visible reason or an
// explicit decision not to send one. A new Error variant fails this switch.
test "alertFor: every error is classified, and peer-fault errors get an alert" {
    const D = ztls.alert.Description;
    try testing.expectEqual(D.bad_certificate, alertFor(error.CertificateVerificationFailed).?);
    try testing.expectEqual(D.decrypt_error, alertFor(error.DecryptError).?);
    try testing.expectEqual(D.illegal_parameter, alertFor(error.ProtocolError).?);
    try testing.expectEqual(D.no_application_protocol, alertFor(error.AlpnRejected).?);
    // The peer already told us; RFC 8446 §6.2 says close without replying.
    try testing.expectEqual(@as(?D, null), alertFor(error.AlertReceived));
    // Local bookkeeping failures never reach the wire.
    try testing.expectEqual(@as(?D, null), alertFor(error.Concurrent));
    try testing.expectEqual(@as(?D, null), alertFor(error.Closed));
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
