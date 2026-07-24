# ztls-std

Opinionated TLS 1.3 stream wrapper over Zig 0.16 `std.Io.net`.

`ztls` core is Sans-I/O: you feed it bytes and get bytes out. `ztls-std` packages
the proven drive loop with sane defaults so a caller can wrap a connected
`std.Io.net.Stream` and get a TLS connection — `connect`/`read`/`write`/`close` —
without writing a Sans-I/O loop. Zig 0.16 only. This is the reference
integration; `ztls-xev` and `ztls-ktls` adapt its handshake-to-completion loop.

Readiness status for this integration lives in
[`PRODUCTION_READINESS.md`](../../PRODUCTION_READINESS.md), not here. Work is
tracked by [#77](https://github.com/mattrobenolt/ztls/issues/77).

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
2. **Honest stream interface.** `Stream` exposes `Reader`/`Writer` structs
   embedding `interface: std.Io.Reader`/`std.Io.Writer`, mirroring
   `std.Io.net.Stream.Reader`/`Writer`. Every stdlib reader API works, including
   the cross-record ones a line-oriented parser needs (`peek`, `takeInt`,
   `takeDelimiterInclusive`). A consumer taking `*std.Io.Reader`/`*std.Io.Writer`
   works unmodified — TLS is invisible. See the buffering-layer section for why
   this rules out a zero-copy read path.
3. **Consume the underlying stream.** `connect`/`accept` move the
   `std.Io.net.Stream` into the `Stream`. `close()` flushes, sends
   `close_notify`, and closes the socket. `closeWrite()` does the same without
   the close, which matters for request/response clients after stdin EOF.
   `socketHandle()` exposes the fd for readiness multiplexing and kTLS.
4. **Per-call `Options`, no `Config`+`Connector`.** A `Config`+`Connector`+
   `TlsStream` triple is more than `connect(stream, Options)` needs. The only
   genuinely reusable, allocation-bearing piece is the cert bundle, and it's
   passed by `*const` pointer in `Options` — reuse is free without a connector
   type.
5. **Verification is a required decision.** `Options.verify` has no default, so
   no caller gets an unverified connection by omission. `.system_bundle` carries
   the allocator it needs, `.bundle` pins your own store, and `.insecure` is an
   explicit, greppable opt-out.
6. **Comptime-sized buffers.** ztls core is built on caller-owned buffers, and
   `Config` is where that surfaces in the wrapper. Defaults accept anything the
   core accepts (~148 KB client / ~132 KB server); a caller opening thousands of
   connections trades look-ahead and reassembly headroom for footprint. Nothing
   is hidden and nothing is mandatory.
7. **In-place init.** `Client`/`Server` are large and self-referential — the
   record buffer, handshake reassembly buffer, and both `Io` interfaces point
   into the struct. Declare `undefined`, `connect`/`accept` in place, never move
   the value afterward (the `std.Thread.Pool` pattern). A moved Stream trips an
   assert in Debug/ReleaseSafe instead of corrupting memory silently. The caller
   chooses placement (stack for one connection, heap/arena for many).
8. **Fatal errors reach the peer.** RFC 8446 §6.2 says a fatal error SHOULD be
   reported with an alert. A failed `connect` sends `bad_certificate` /
   `illegal_parameter` / `no_application_protocol` as appropriate, then closes,
   so the peer logs a reason instead of a bare FIN.

## Not thread-safe

`reader()` and `writer()` share the handshake engine and one outbound record
buffer. The two halves cannot be driven from different threads the way
`tokio-rustls` split halves can. Multiplex both directions from one thread
(`socketHandle()` + `hasBuffered()`, as `examples/tls_client.zig` does) or
serialize access yourself.

## Public API

### Verification policy (client)

```zig
pub const Verify = union(enum) {
    /// Load the OS trust store with `gpa` and verify the server certificate
    /// chain against it. The bundle is freed before `connect` returns, so a
    /// client opening many connections should build one bundle and pass
    /// `.bundle` instead of rescanning the trust store per connection.
    system_bundle: std.mem.Allocator,
    /// Verify against a caller-owned bundle (pin a root / custom store).
    bundle: *const std.crypto.Certificate.Bundle,
    /// Skip chain-anchor verification (sets ztls `insecure_no_chain_anchor`).
    /// Hostname verification still runs unless `host` is null. Demo/test only.
    insecure,
};
```

The allocator lives in the `.system_bundle` payload rather than in `connect`'s
signature, because that is the only mode that needs one. `connect` is therefore
`connect(io, sock, options)` with no phantom parameter and no "ignored otherwise"
caveat.

### Buffer configuration

```zig
pub const Config = struct {
    record_storage: usize = ztls.RecordBuffer.recommended_storage,
    reassembly_storage: ?usize = null, // null = the core's recommendation
    read_buffer: usize = ztls.frame.max_plaintext_len,
    write_buffer: usize = ztls.frame.max_plaintext_len,
    peer_chain_storage: ?usize = null, // null = do not retain the chain
};

pub fn ClientWith(comptime config: Config) type;
pub fn ServerWith(comptime config: Config) type;
pub const Client = ClientWith(.{});
pub const Server = ServerWith(.{});
```

`read_buffer` is the reader's look-ahead, so it bounds `peek(n)`, `takeInt`, and
`takeDelimiterInclusive` line length; past it those report
`error.StreamTooLong`. It must be at least one record payload
(`ztls.frame.max_plaintext_len`).

`peer_chain_storage` is `null` by default because retaining the verified chain
for `info().peer_chain` costs one handshake-sized (64 KiB) buffer, and most
callers never look at it. Opt in when you do:

```zig
const IntrospectingClient = tls.ClientWith(.{
    .peer_chain_storage = ztls.ClientHandshake.recommended_handshake_storage,
});
```

`test "Config: buffer sizing is the whole story of the Stream footprint"` pins
each knob to an exact `@sizeOf` delta, so the numbers above are gated rather
than aspirational.

### Client / Server

`Client` and `Server` ARE the connection types — not namespaces around one.
They share an implementation (`StreamImpl(Hs, role, config)`), so
`reader`/`writer`/`socketHandle`/`hasBuffered`/`selectedAlpn`/`info`/
`closeWrite`/`close`/`deinit` exist on both; `connect` is client-only and
`accept` is server-only (calling the wrong one is a compile error, not a runtime
surprise).

```zig
pub const Client = /* ClientWith(.{}) */ struct {
    pub const Options = struct {
        /// SNI + certificate hostname (SAN/CN) to verify. Required for real
        /// verification; null disables BOTH SNI and hostname verification.
        host: ?[]const u8 = null,
        /// No default: a TLS client should not skip this by omission.
        verify: Verify,
        /// ALPN protocols to offer (e.g. &.{ "h2", "http/1.1" }). Borrowed.
        alpn: []const []const u8 = &.{},
        /// Offer an X25519MLKEM768 hybrid key share (PQ). False by default.
        offer_pq_key_share: bool = false,
    };

    /// Wrap a CONNECTED `std.Io.net.Stream` and run the TLS 1.3 handshake to
    /// completion. Moves the socket into `s`. Eager: all handshake errors
    /// surface here. On failure the peer gets a fatal alert where one is
    /// warranted, the socket is closed, and buffers are zeroed — a later
    /// `deinit` is harmless but unnecessary.
    pub fn connect(
        s: *Client,
        io: std.Io,
        stream: std.Io.net.Stream,
        options: Options,
    ) ConnectError!void;

    pub fn reader(s: *Client) *std.Io.Reader;
    pub fn writer(s: *Client) *std.Io.Writer;

    /// The underlying socket handle, for readiness multiplexing (`poll`,
    /// `epoll`, `kqueue`) or kTLS setup. Reading or writing it directly
    /// desynchronizes the record layer.
    pub fn socketHandle(s: *const Client) std.Io.net.Socket.Handle;

    /// True when a read can return data without touching the transport
    /// (decrypted bytes pending, or a complete record already framed).
    pub fn hasBuffered(s: *Client) bool;

    /// ALPN protocol selected by the server, or null. Valid after connect.
    pub fn selectedAlpn(s: *const Client) ?[]const u8;

    /// Cipher suite, ALPN, and (if configured) the verified peer DER chain.
    pub fn info(s: *const Client) Info;

    /// Flush, send close_notify, keep the read side open for the peer's
    /// response. Idempotent.
    pub fn closeWrite(s: *Client) void;

    /// Flush, send close_notify, close the socket. Idempotent. Does not drain
    /// pending peer app data (callers wanting that read until
    /// `error.EndOfStream`, then close).
    pub fn close(s: *Client) void;

    /// Always-callable teardown: closes the socket (no alert) and secure-zeros
    /// every wrapper-owned buffer. Idempotent, and a no-op after a failed
    /// connect.
    pub fn deinit(s: *Client) void;
};
```

`Server.Options` carries credentials instead of a verification policy:

```zig
pub const Options = struct {
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
```

`info()` exposes negotiated metadata without making callers spelunk through
handshake state:

```zig
pub const Info = struct {
    cipher_suite: ztls.CipherSuite,
    alpn: ?[]const u8,
    peer_chain: []const []const u8, // verified DER, leaf first; see Config
};
```

### Error sets

Curated public sets projected from the ~90-variant core sets. Each variant says
who is at fault and what a caller can do about it:

```zig
pub const ConnectError = error{
    CertificateVerificationFailed, // chain / hostname / validity / CertificateVerify
    TlsDecryptError,               // Finished MAC or record AEAD tag failed
    TlsAlertReceived,              // peer aborted with a fatal alert
    HandshakeProtocolError,        // malformed, unexpected, or illegal peer message
    RecordOverflow,                // peer record exceeded RFC 8446 §5.1
    HandshakeBufferTooShort,       // raise Config.record_storage / reassembly_storage
    InvalidOptions,                // caller-supplied ALPN list or host length
    InternalError,                 // libcrypto failure, counter overflow, broken invariant
    OutOfMemory,                   // verify == .system_bundle trust-store load
} || std.Io.net.Stream.Reader.Error || std.Io.net.Stream.Writer.Error
  || std.Io.Cancelable || std.Io.UnexpectedError;

pub const AcceptError = error{
    MissingCredentials, ClientCertificateRejected, CertificateVerificationFailed,
    TlsDecryptError, TlsAlertReceived, HandshakeProtocolError,
    UnsupportedCipherSuite, NoApplicationProtocol, RecordOverflow,
    HandshakeBufferTooShort, InvalidOptions, InternalError,
} || /* same transport tail */;
```

The mapping goes through one `classify` table over the union of every core
handshake error set, projected per role. The table is **exhaustive on purpose —
no `else` arm**: adding a variant to a core error set is a compile error here
until someone decides which coarse class it belongs to. Silently degrading a new
certificate failure into a generic protocol error is exactly the bug that shape
prevents. The same core error can legitimately mean different things per role —
`UnsupportedCipherSuite` is a real negotiation outcome for a server and an
`illegal_parameter` violation for a client — and the projections say so.

Post-handshake reads and writes go through the `Io.Reader`/`Io.Writer` vtable,
whose `Error` sets are narrow by design — `error{ReadFailed, EndOfStream}` for
Reader and `error{WriteFailed}` for Writer. All TLS-specific failures
(decrypt/auth errors, alert received) collapse to `ReadFailed` on the read path
and `WriteFailed` on the write path. Both a clean `close_notify` and a transport
EOF without one surface as `error.EndOfStream` — RFC 8446 §6.1 requires
`close_notify`, but hard-closing the transport is ubiquitous on the real internet
and the reader cannot distinguish truncation from a rude close anyway; callers
that care about truncation must frame their own protocol (Content-Length,
chunked, etc.).

## The byte-stream buffering layer (the one piece of real new code)

TLS records don't align with `read()` calls: one transport read can deliver a
partial record, multiple records, or app data plus a `key_update` /
`new_session_ticket` together. The `Reader` vtable adapts the record-oriented
`Event` loop to a flat byte stream, and the whole event union stays invisible to
the caller:

1. While the reader's buffer holds bytes, the generic `Io.Reader` serves them —
   the vtable isn't even called.
2. On exhaustion, `stream` copies from the pending decrypted record into the
   destination the generic layer supplied. When nothing is pending it drives the
   record loop: read transport into `RecordBuffer.writable()`, `advance(n)`,
   loop `rb.next()` → `handleRecord`, and switch on the `Event`:
   - `.application_data` → becomes the pending plaintext window and is copied
     out (zero-length fragments are skipped; RFC 8446 §5.1 allows them).
   - `.key_update` → if `response` non-null, write it + `completeWrite`; loop.
     Never surfaced.
   - `.new_session_ticket` → swallow (a later `onTicket` hook is a non-stub
     future field, not a v1 knob); loop.
   - `.write` (post-handshake control) → write + `completeWrite`; loop.
   - `.none` → loop.
   - `.closed` → return `error.EndOfStream`.
   - Transport returns 0 without `.closed` → `error.EndOfStream` (abrupt
     close; see the error-set section above for why this isn't ReadFailed).

### Why there is no zero-copy read path

An earlier revision repointed `interface.buffer` at the decrypted record inside
the `RecordBuffer` — genuinely zero copy, and permitted by the `Io.Reader`
`stream` contract ("store data in `buffer`, modifying `seek` and `end`"). It is
also unusable, because it makes the reader's *capacity* equal to the current
record's length. Every stdlib path that buffers across records then breaks:

- `peek(n)` past the current record: `fill` rebases the unconsumed tail to the
  front of the record window and asks the vtable for more, which either asserts
  or discards the tail.
- `takeDelimiterInclusive('\n')` — HTTP header parsing — bails out of its fill
  loop as soon as `buffer.len - content_len == 0`, which is always true for a
  partially consumed record, and then hits the same path.

Both are covered by tests now (`reader: peek past the current record keeps the
unconsumed tail`, `reader: takeDelimiterInclusive spans a record boundary`). The
current `stream` honors the vtable contract instead: one copy into the caller's
destination, which is a copy the caller needed anyway. `streamRemaining` and
friends still move record bytes straight to the sink with no intermediate copy,
which is where zero-copy actually pays.

### Bounded control-record work

A refill gives up with `error.ReadFailed` after 64 records that produce no
application data. RFC 8446 §5.1 puts no rate limit on zero-length
`application_data` fragments, so an uncooperative peer could otherwise keep a
`read` call from ever returning. The core already caps KeyUpdate and
NewSessionTicket floods (`TooManyKeyUpdates`, `TooManyNewSessionTickets`); this
covers what it does not count.

### Reader idioms

`readSliceShort()` tries to fill its entire destination buffer, so it blocks on a
keep-alive peer after a short response. For record-at-a-time reads, call
`fillMore()`, consume `buffered()`, then `toss()` that length. Use `hasBuffered()`
with poll loops to drain coalesced records without another transport read.

The `Writer` is `BufWriter`-shaped (matching `tokio-rustls`): `interface.buffer`
is a plaintext staging buffer sized to `Config.write_buffer` so each
`drain`/`flush` maps to one TLS record via `sendApplicationData` → write `out` →
`completeWrite`. Writes larger than the buffer loop into multiple records.
Nothing is encrypted until `flush`/`drain` — or until `close`/`closeWrite`, which
flush for you rather than zeroing bytes the caller believes it wrote.

## Usage

### Client: connect + write + read + close

```zig
const std = @import("std");
const tls = @import("ztls_std");

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    // 1. Make the TCP connection yourself (ztls-std does NOT dial).
    const host_name = try std.Io.net.HostName.init("example.com");
    const sock = try host_name.connect(io, 443, .{ .mode = .stream });

    // 2. TLS handshake to completion (eager — errors surface here).
    var conn: tls.Client = undefined; // large + self-referential: init in place
    try conn.connect(io, sock, .{
        .host = "example.com",
        .verify = .{ .system_bundle = init.gpa },
        .alpn = &.{"http/1.1"},
    });
    defer conn.deinit();

    // 3. Write via the Io.Writer.
    const w = conn.writer();
    try w.writeAll("GET / HTTP/1.0\r\nHost: example.com\r\n\r\n");
    try w.flush();

    // 4. Read via the Io.Reader. Line-oriented parsing works: the reader
    // buffers across TLS record boundaries.
    const r = conn.reader();
    while (r.takeDelimiterInclusive('\n')) |line| {
        std.debug.print("{s}", .{line});
    } else |err| switch (err) {
        error.EndOfStream => {},   // clean close_notify
        error.ReadFailed => {},    // transport closed / TLS error
        error.StreamTooLong => {}, // line longer than Config.read_buffer
    }

    // 5. Close: flush + close_notify + close socket.
    conn.close();
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

    var conn: tls.Server = undefined;
    try conn.accept(io, sock, .{
        .cert_chain = &.{cert_der}, // leaf-first DER
        .signer = key.signer(),     // key must outlive this accept() call
        .alpn = &.{"http/1.1"},
    });
    defer conn.deinit();

    const r = conn.reader();
    const request_line = try r.takeDelimiterInclusive('\n');
    if (!std.mem.startsWith(u8, request_line, "GET ")) return error.BadRequest;

    const w = conn.writer();
    try w.writeAll("HTTP/1.0 200 OK\r\nContent-Length: 5\r\n\r\nhello");
    conn.close(); // flushes for you
}
```

### Composing with a hypothetical `http.zig`

```zig
// http.zig takes *std.Io.Reader / *std.Io.Writer — it knows nothing about TLS.
var conn: tls.Client = undefined;
try conn.connect(io, sock, .{
    .host = "example.com",
    .verify = .{ .system_bundle = gpa },
    .alpn = &.{"http/1.1"},
});
defer conn.deinit();

const resp = try http.get(io, conn.reader(), conn.writer(), "/");
// key_update, new_session_ticket, and record reassembly are handled inside
// the TLS reader/writer vtables; http.zig is unmodified.
```

That third example is the whole point of the drop-in `Io.Reader`/`Io.Writer`
seam, and it is the reason the zero-copy read path had to go.

## Out of scope for v1

- **`std.http` integration** — `std.http` is not the target; community HTTP
  libs compose via the `*Io.Reader`/`*Io.Writer` seam instead.
- **Client-auth** — the ztls core marks full client-cert verification as a
  later slice; exposing a non-functional knob now would be dishonest.
  `AcceptError.ClientCertificateRejected` exists because the core can produce
  those errors, not because the surface is supported.
- **Session resumption / 0-RTT surface** — cut from v1.
- **Concurrent split halves** — see the thread-safety note above.
- **Handshake timeouts** — a slow peer can stall `connect`. `std.Io`
  cancellation (`Io.Cancelable` is already in the error sets) is the intended
  mechanism; nothing here imposes a deadline for you.
- **0.15 support** — 0.16 only.
- **Distribution as an independently `zig fetch`-able package** — tracked by #79.

## Build

In-tree, depends on the ztls core via a path dep (`../..`), the same pattern
`conformance/` uses. Devshell: `nix develop .#ztls-std` (Zig 0.16 + OpenSSL
backend), or just `cd` into this directory — direnv loads it via `.envrc`.

```
just build             # smoke executable
just test              # unit + round-trip + example tests
just build-examples    # compile every example (no peer required)
just lint              # zig fmt, ziglint, workspace std-alias rules
just ci                # everything above
```

The root workspace delegates to this subproject through `just integrations-ci`,
which is wired into `just ci-0_16` (the Zig 0.16 CI lane). The 0.15 lane cannot
build a 0.16-only integration, so it does not pretend to.

Run the example client against a real server:

```
printf 'GET / HTTP/1.0\r\nHost: example.com\r\nConnection: close\r\n\r\n' | \
    zig build example-tls_client -- --host example.com
```
