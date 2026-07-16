# ztls-std

Opinionated TLS 1.3 stream wrapper over Zig 0.16 `std.Io.net`.

`ztls` core is Sans-I/O: you feed it bytes and get bytes out. `ztls-std` packages
the proven drive loop with sane defaults so a caller can wrap a connected
`std.Io.net.Stream` and get a TLS connection — `connect`/`read`/`write`/`close` —
without writing a Sans-I/O loop. Zig 0.16 only. This is the reference
integration; `ztls-xev` and `ztls-ktls` adapt its handshake-to-completion loop.

**Status: API spec only.** This document defines the public API. Implementation
lands next, written to match this spec. Tracked by
[#77](https://github.com/mattrobenolt/ztls/issues/77).

The API was shaped by a cross-family design quorum (Opus 4.8 + Kimi K2.7 + GLM
5.2) sourced from `tokio-rustls` and Go `crypto/tls`, then synthesized. Two
load-bearing facts are verified against the released Zig 0.16.0 stdlib
(`std/Io/Reader.zig`):

- `Io.Reader.Error` includes `error.EndOfStream` — the std.Io end-of-stream
  convention. A clean TLS `close_notify` surfaces as `error.EndOfStream`
  (Go `io.EOF` parity).
- The `Io.Reader` `stream` vtable contract permits the impl to "store data in
  `buffer`, modifying `seek` and `end`" (see `Io.Reader.fixed`). So the read
  path can point `interface.buffer` at the decrypted record in place — zero
  copy, no per-record memcpy.

## Design principles

1. **Eager handshake.** `connect`/`accept` run the TLS handshake to completion
   before returning. Handshake errors (cert verification, ALPN no-overlap,
   `illegal_parameter`) surface at call time — their natural home — not leaked
   into the first `read`. The `Io.Reader`/`Io.Writer` vtable contract is "this
   is a byte stream"; a `stream` callback that secretly negotiates a handshake
   mid-read would be surprising and force every vtable method to carry
   handshake-error variants. (Go's lazy auto-handshake is the part of
   `crypto/tls` that bites; `std.Io.net` separates `connect` from I/O, so we
   own the connect step and put the handshake there — matching `tokio-rustls`.)
2. **Drop-in stream interface.** `Stream` exposes `Reader`/`Writer` structs
   embedding `interface: std.Io.Reader`/`std.Io.Writer`, mirroring
   `std.Io.net.Stream.Reader`/`Writer`. A consumer like `http.zig` taking
   `*std.Io.Reader`/`*std.Io.Writer` works unmodified — TLS is invisible.
3. **Consume the underlying stream.** `connect`/`accept` move the
   `std.Io.net.Stream` into the `Stream`. `close()` sends `close_notify` and
   closes the socket — one call, one mental model. No `shutdown`/half-close
   knob in v1 (TLS 1.3 half-close is real but rarely needed; add later without
   breaking the surface).
4. **Per-call `Options`, no `Config`+`Connector`.** A `Config`+`Connector`+
   `TlsStream` triple is more than `connect(stream, Options)` needs. The only
   genuinely reusable, allocation-bearing piece is the cert bundle, and it's
   passed by `*const` pointer in `Options` — reuse is free without a connector
   type. (WWMD: deleted the connector.)
5. **Verification on by default.** A plain `connect` just works against a real
   server: cert verification defaults to the OS trust bundle. `.insecure` is
   the explicit opt-out.
6. **Out-param init.** `Stream` is large (~50 KB: `RecordBuffer.Storage` ~33 KB
   + `OutBuffer` ~16 KB + a `Reader`/`Writer`). `connect`/`accept` take
   `out: *Stream` and return `!void` — no ~50 KB struct returned by value (the
   large-union-variant codegen hazard, see ztls #65). The caller chooses
   placement (stack for one connection, heap/arena for many).

## Public API

### Verification policy (client)

```zig
pub const Verify = union(enum) {
    /// Load the OS trust store and verify the server certificate chain.
    /// Requires an allocator, passed to `Client.connect` (used only for this
    /// mode; freed before connect returns). Hot paths should build a bundle
    /// once and pass `.bundle` instead.
    system_bundle,
    /// Verify against a caller-owned bundle (pin a root / custom store).
    /// Borrowed for the life of the Stream.
    bundle: *const std.crypto.Certificate.Bundle,
    /// Skip chain-anchor verification (sets ztls `insecure_no_chain_anchor`).
    /// Hostname verification still runs unless `host` is null. Demo/test only.
    insecure,
};
```

### Client

```zig
pub const Client = struct {
    pub const Options = struct {
        /// SNI + certificate hostname (SAN/CN) to verify. Required for real
        /// verification; null disables BOTH SNI and hostname verification
        /// (ztls `host_name = null`).
        host: ?[]const u8 = null,
        /// Cert verification. Defaults to the OS trust bundle.
        verify: Verify = .system_bundle,
        /// ALPN protocols to offer (e.g. &.{ "h2", "http/1.1" }). Borrowed.
        alpn: []const []const u8 = &.{},
        /// Offer an X25519MLKEM768 hybrid key share (PQ). False by default.
        offer_pq_key_share: bool = false,
    };

    /// A ready, connected TLS 1.3 stream. Sized ~50 KB; place on the stack for
    /// a single connection or heap/arena for many. Out-param initialized.
    pub const Stream = struct {
        // (fields are internal: owned net.Stream, ztls.ClientHandshake,
        //  RecordBuffer.Storage + RecordBuffer, OutBuffer, Reader, Writer,
        //  rx_closed/tx_closed flags.)

        /// Borrowed `*std.Io.Reader` — drop-in for any `*Io.Reader` consumer.
        pub fn reader(s: *Stream) *std.Io.Reader;
        /// Borrowed `*std.Io.Writer` — drop-in for any `*Io.Writer` consumer.
        pub fn writer(s: *Stream) *std.Io.Writer;

        /// ALPN protocol selected by the server, or null. Valid after connect.
        /// Borrowed from the engine; lives until deinit.
        pub fn selectedAlpn(s: *const Stream) ?[]const u8;

        /// Send close_notify and close the underlying socket. Idempotent.
        /// Does not drain pending peer app data (callers wanting that read
        /// until `error.EndOfStream`, then close).
        pub fn close(s: *Stream, io: std.Io) void;

        /// Always-callable teardown: secure-zeros ztls secrets (delegates to
        /// `ClientHandshake.deinit`). Use after a failed connect too. `close`
        /// calls this internally; call `deinit` directly only if you did NOT
        /// call `close`.
        pub fn deinit(s: *Stream) void;
    };

    /// Wrap a CONNECTED `std.Io.net.Stream` and run the TLS 1.3 handshake to
    /// completion. Moves the socket into `out`. Eager: all handshake errors
    /// surface here. `gpa` is used ONLY when `options.verify == .system_bundle`
    /// (to load the OS trust store); ignored otherwise.
    pub fn connect(
        out: *Stream,
        gpa: std.mem.Allocator,
        io: std.Io,
        stream: std.Io.net.Stream,
        options: Options,
    ) ConnectError!void;
};
```

### Server

```zig
pub const Server = struct {
    pub const Options = struct {
        /// Certificate chain, leaf first, DER. Borrowed for the Stream's life.
        cert_chain: []const []const u8,
        /// Signer for CertificateVerify. Obtained from
        /// `var key: ztls.signature.PrivateKey = try .fromP256Scalar(scalar);
        ///  defer key.deinit(); key.signer()` — the `PrivateKey` must outlive
        /// the handshake (caller-owned). Borrowed.
        signer: ztls.signature.Signer,
        /// ALPN protocols supported. Borrowed.
        alpn: []const []const u8 = &.{},
    };

    pub const Stream = struct {
        // (internal: owned net.Stream, ztls.ServerHandshake, RecordBuffer,
        //  OutBuffer, FlightBuffer, Reader, Writer, flags.)

        pub fn reader(s: *Stream) *std.Io.Reader;
        pub fn writer(s: *Stream) *std.Io.Writer;
        pub fn selectedAlpn(s: *const Stream) ?[]const u8;
        pub fn close(s: *Stream, io: std.Io) void;
        pub fn deinit(s: *Stream) void;
    };

    /// Wrap an ACCEPTED `std.Io.net.Stream` and run the server-side handshake
    /// to completion. Moves the socket into `out`. No allocator: the server
    /// presents, it does not anchor a chain.
    pub fn accept(
        out: *Stream,
        io: std.Io,
        stream: std.Io.net.Stream,
        options: Options,
    ) AcceptError!void;
};
```

### Reader / Writer

`Client.Stream.Reader` and `Server.Stream.Reader` are structs embedding
`interface: std.Io.Reader`; the `Writer` structs embed
`interface: std.Io.Writer`. The vtable implementations recover the `Stream` via
`@fieldParentPtr("interface", io_r)` and drive the ztls record layer against the
owned `net.Stream`. `reader()`/`writer()` return `*std.Io.Reader`/`*std.Io.Writer`
so the TLS stream is a drop-in for any std.Io consumer.

### Error sets

Coarse, curated public sets mapped from the sprawling ztls core sets (the
mapping is documented in the implementation so debugging can trace back):

```zig
pub const ConnectError = error{
    CertificateVerificationFailed, // cert chain / hostname / validity / signature
    TlsAlertReceived,              // peer sent a fatal alert during handshake
    HandshakeProtocolError,        // malformed/unexpected message, illegal params
    NoApplicationProtocol,         // ALPN offered but no overlap
    HandshakeBufferTooShort,       // record/out/reassembly capacity exceeded
    OutOfMemory,                   // verify == .system_bundle trust-store load
} || std.Io.net.Stream.Reader.Error || std.Io.net.Stream.Writer.Error
  || std.Io.Cancelable || std.Io.UnexpectedError;

pub const AcceptError = error{
    MissingCredentials,            // cert_chain empty / signer invalid
    TlsAlertReceived,
    HandshakeProtocolError,
    UnsupportedCipherSuite,
    NoApplicationProtocol,
    HandshakeBufferTooShort,
} || std.Io.net.Stream.Reader.Error || std.Io.net.Stream.Writer.Error
  || std.Io.Cancelable || std.Io.UnexpectedError;

pub const ReadError = error{
    TlsBadRecord,        // decrypt/auth failure or malformed record post-handshake
    TlsAlertReceived,    // peer sent a fatal alert
    TlsUnexpectedEof,    // socket EOF with NO close_notify (truncation; RFC 8446 §6.1)
} || std.Io.net.Stream.Reader.Error || std.Io.Cancelable || std.Io.UnexpectedError;
// A clean close_notify surfaces as error.EndOfStream (from Io.Reader.Error),
// NOT as a ReadError variant — the natural "stream ended" signal.

pub const WriteError = error{
    TlsClosed,           // write after our close_notify / peer teardown
    TlsAlertReceived,
} || std.Io.net.Stream.Writer.Error || std.Io.Cancelable || std.Io.UnexpectedError;
```

## The byte-stream buffering layer (the one piece of real new code)

TLS records don't align with `read()` calls: one transport read can deliver a
partial record, multiple records, or app data plus a `key_update`/`
new_session_ticket` together. The `Reader` vtable adapts the record-oriented
`Event` loop to a flat byte stream, and the whole event union stays invisible to
the caller:

1. While the current decrypted record window has bytes (`buffer[seek..end]`), the
   generic `Io.Reader` serves them — the vtable isn't even called.
2. On exhaustion, the refill drives the loop: read transport into
   `RecordBuffer.writable()`, `advance(n)`, loop `rb.next()` → `handleRecord`,
   and switch on the `Event`:
   - `.application_data` → point `interface.buffer` at the decrypted bytes
     inside the `RecordBuffer` (zero copy — the record is decrypted in place and
     the 0.16 `Io.Reader` contract permits repointing `buffer`/`seek`/`end`),
     `seek=0`, `end=len`, return.
   - `.key_update` → if `response` non-null, write it + `completeWrite`; loop.
     Never surfaced.
   - `.new_session_ticket` → swallow (a later `onTicket` hook is a non-stub
     future field, not a v1 knob); loop.
   - `.write` (post-handshake control) → write + `completeWrite`; loop.
   - `.none` → loop.
   - `.closed` → return `error.EndOfStream`.
   - Transport returns 0 without `.closed` → `error.TlsUnexpectedEof`.

The `Writer` is `BufWriter`-shaped (matching `tokio-rustls`): `interface.buffer`
is a plaintext staging buffer sized to `ztls.frame.max_plaintext_len` (16384) so
each `drain`/`flush` maps to one TLS record via `sendApplicationData` → write
`out` → `completeWrite`. Writes larger than the buffer loop into multiple
records. Nothing is encrypted until `flush`/`drain`.

## Usage

### Client: connect + write + read + close

```zig
const std = @import("std");
const tls = @import("ztls_std");

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    var gpa_state: std.heap.DebugAllocator(.{}) = .init;
    defer _ = gpa_state.deinit();
    const gpa = gpa_state.allocator();

    // 1. Make the TCP connection yourself (ztls-std does NOT dial).
    const addr: std.Io.net.IpAddress = try .parse("example.com", 443);
    const sock = try addr.connect(io, .{ .mode = .stream });

    // 2. TLS handshake to completion (eager — errors surface here).
    var conn: tls.Client.Stream = undefined; // large struct: out-param init
    try tls.Client.connect(&conn, gpa, io, sock, .{
        .host = "example.com",
        .alpn = &.{"http/1.1"},
        // .verify defaults to .system_bundle
    });
    defer conn.deinit();

    // 3. Write via the Io.Writer.
    const w = conn.writer();
    try w.writeAll(io, "GET / HTTP/1.0\r\nHost: example.com\r\n\r\n");
    try w.flush();

    // 4. Read via the Io.Reader.
    const r = conn.reader();
    var buf: [4096]u8 = undefined;
    while (true) {
        const n = r.read(&buf) catch |err| switch (err) {
            error.EndOfStream => break, // clean close_notify
            else => return err,
        };
        std.debug.print("{s}", .{buf[0..n]});
    }

    // 5. Close: send close_notify + close socket.
    conn.close(io);
}
```

### Server: accept + respond + close

```zig
const std = @import("std");
const ztls = @import("ztls");
const tls = @import("ztls_std");

pub fn serveOne(io: std.Io, listener: *std.Io.net.Server,
                cert_der: []const u8, scalar: *const [32]u8) !void {
    const sock = try listener.accept(io);

    var key: ztls.signature.PrivateKey = try .fromP256Scalar(scalar);
    defer key.deinit();

    var conn: tls.Server.Stream = undefined;
    try tls.Server.accept(&conn, io, sock, .{
        .cert_chain = &.{cert_der}, // leaf-first DER
        .signer = key.signer(),     // key must outlive this accept() call
        .alpn = &.{"http/1.1"},
    });
    defer conn.deinit();

    const r = conn.reader();
    var buf: [1024]u8 = undefined;
    const n = try r.read(&buf);
    if (!std.mem.startsWith(u8, buf[0..n], "GET ")) return error.BadRequest;

    const w = conn.writer();
    try w.writeAll(io, "HTTP/1.0 200 OK\r\nContent-Length: 5\r\n\r\nhello");
    try w.flush();
    conn.close(io);
}
```

### Composing with a hypothetical `http.zig`

```zig
// http.zig takes *std.Io.Reader / *std.Io.Writer — it knows nothing about TLS.
var conn: tls.Client.Stream = undefined;
try tls.Client.connect(&conn, gpa, io, sock, .{ .host = "example.com", .alpn = &.{"http/1.1"} });
defer conn.deinit();

const resp = try http.get(io, conn.reader(), conn.writer(), "/");
// key_update, new_session_ticket, and record reassembly are handled inside
// the TLS reader/writer vtables; http.zig is unmodified.
```

That third example is the whole point of the drop-in `Io.Reader`/`Io.Writer`
seam.

## Out of scope for v1

- **`std.http` integration** — `std.http` is not the target; community HTTP
  libs compose via the `*Io.Reader`/`*Io.Writer` seam instead.
- **Client-auth** — the ztls core marks full client-cert verification as a
  later slice; exposing a non-functional knob now would be dishonest. Add when
  the core proves it.
- **Half-close / `shutdown`**, **session resumption / 0-RTT surface**,
  **`socketHandle()` for kTLS** — cut from v1 (WWMD: don't ship knobs without
  proven need). `socketHandle()` returns when `ztls-ktls` lands.
- **0.15 support** — 0.16 only.
- **Distribution as an independently `zig fetch`-able package** — tracked by #79.

## Build

In-tree, depends on the ztls core via a path dep (`../..`), the same pattern
`conformance/` uses:

```
cd integrations/ztls-std
zig build          # smoke executable
zig build test     # scaffold tests
zig build run      # run the smoke executable
```

Devshell: `nix develop .#ztls-std` (Zig 0.16 + OpenSSL backend), or just `cd`
into this directory — direnv loads it via `.envrc`.
