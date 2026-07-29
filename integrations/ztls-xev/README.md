# ztls-xev

Non-blocking TLS 1.3 over [libxev](https://github.com/mitchellh/libxev). Zig 0.16
only.

Readiness status lives in [`PRODUCTION_READINESS.md`](../../PRODUCTION_READINESS.md),
not here. Work is tracked by [#76](https://github.com/mattrobenolt/ztls/issues/76).

## Why this is a package and `ztls-zio` isn't

libxev is a callback-completion event loop with its own API. It does **not**
implement `std.Io` — it borrows `std.Io.net.IpAddress` as a type and nothing
else. So unlike a `std.Io` runtime (zio, `std.Io.Threaded`), which
[`ztls-std`](../ztls-std) already drives unmodified, this genuinely needs an
adapter.

The adapter is not a port of ztls-std. ztls-std's drive loop owns the stack:

```zig
while (!hs.isConnected()) { const n = blocking_read(...); ... }
```

There is no stack to own in a completion world. `Conn.pump` is that loop turned
inside out — every local became a field, and each completion re-enters `pump` to
make whatever progress is now possible. Two consequences that shaped the whole
API:

- **No `Io.Reader`/`Io.Writer`.** Those are synchronous contracts: `stream()` must
  produce bytes or fail, with no way to say "call me back". ztls-std's drop-in
  byte-stream seam has no analogue here, so callers get explicit operations with
  callbacks.
- **No eager `connect`.** The handshake spans many callback invocations, so it is
  `handshake(ctx, cb)` rather than something that returns when done.

What *is* shared is `ztls.errors.classify`, so both integrations project their
coarse failure buckets from one exhaustive table in the core rather than growing
copies that drift.

Client and server are one implementation parameterised by role
(`Conn(.client)` / `Conn(.server)`, exported as `Client` and `Server`). They
share the pump, the wire queue, both I/O paths, and teardown; they differ in
which engine they drive, how the handshake opens, and whether a server flight is
owed. Three differences did not justify eight hundred duplicated lines.

The API shape follows a proven server-side libxev TLS integration rather than
being invented here; the `ReadResult` split in particular is lifted from it.

## The loop needs a thread pool

libxev dispatches socket close to a thread pool on the readiness backends
(kqueue, epoll) but not on io_uring. With no pool the close fails
`ThreadPoolRequired` and **the fd is never closed**, so the peer never sees EOF
and both sides wait forever. Measured on epoll:

```
pool=false: close_cb=true read_cb=false                    (fd still open)
pool=true:  close_cb=true read_cb=true read_err=error.EOF
```

io_uring hides this entirely, which is how it survived a full Linux CI lane and
only surfaced on macOS. `Conn.init` asserts the pool is present on the backends
that need one, so a missing pool is an immediate assert rather than a hang:

```zig
var pool: xev.ThreadPool = .init(.{});
defer { pool.shutdown(); pool.deinit(); }
var loop: xev.Loop = try .init(.{ .thread_pool = &pool });
```

## Contract

- Every operation returns `void` and invokes its callback **exactly once**,
  including for failures detected synchronously. A caller never handles the same
  failure in two places.
- Callbacks take a typed `ctx` — no `anyopaque`, no `xev.Completion`. The `Conn`
  owns its completions (read, write, close), which is what lets a read and a
  write be in flight together.
- Reads and writes may overlap each other. Two reads may not, and neither may two
  writes: the second is rejected with `Error.Concurrent` delivered to its
  callback.
- Operations are state-gated. Issuing one past `.established` fails with
  `Error.Closed` rather than asserting — a late read is a plausible caller race,
  not a memory-safety bug.
- Buffers are caller-owned slices with documented minimums, not comptime sizes,
  so a server can hand out pooled per-connection buffers.

```zig
pub const State = enum { handshaking, established, closing, closed };
```

### `ReadResult` distinguishes a clean close from a truncated one

```zig
pub const ReadResult = union(enum) {
    data: []const u8,   // decrypted plaintext, into the buffer you passed
    close_notify,       // authenticated TLS shutdown (RFC 8446 §6.1)
    eof,                // transport EOF with no close_notify — truncated
    err: Error,
};
```

ztls-std cannot draw this distinction: `std.Io.Reader` has one
`error.EndOfStream` for both, and its README argues that is fine because a
byte-stream reader cannot tell them apart anyway. True for a byte stream, false
for a callback API — so this one tells you. It shows up immediately on real
traffic: `www.cloudflare.com` finishes with `close_notify` after 1.3 MB, while a
peer that drops you mid-request yields `eof` with the bytes-so-far.

## Roles

`Client.Config` is `ClientConfig`: a trust store loaded once and shared. Its
mirror `Server.Config` is `ServerConfig`: one certificate chain and signer,
shared the same way. Both are borrowed for the life of every connection using
them, and neither owns per-connection state.

```zig
const server_config: tls.ServerConfig = .init(.{
    .cert_chain = &.{cert_der},   // leaf first
    .signer = key.signer(),       // the PrivateKey must outlive this
    .alpn = &.{"h2"},
});
```

A server calls the same `handshake()` as a client — the caller has already
accepted the TCP connection, so there is nothing left to accept. There is no
listener abstraction: an accept loop is four lines of libxev, and wrapping it
would only obstruct the protocol-detection patterns a real proxy needs. See
`examples/xev_server.zig`.

## Usage

```zig
const xev = @import("xev");
const tls = @import("ztls_xev");

const App = struct {
    conn: tls.Conn = undefined,
    storage: tls.Conn.Storage = .{},
    read_buf: [16 * 1024]u8 = undefined,

    fn onHandshake(self: *App, r: tls.HandshakeResult) void {
        r.result catch return; // peer already got the matching fatal alert
        self.conn.write("GET / HTTP/1.0\r\n\r\n", self, onWrite);
    }
    fn onWrite(self: *App, r: tls.WriteResult) void {
        _ = r.written catch return self.conn.closeReset(self, onClose);
        self.conn.read(&self.read_buf, self, onRead);
    }
    fn onRead(self: *App, r: tls.ReadResult) void {
        switch (r) {
            .data => self.conn.read(&self.read_buf, self, onRead),
            .close_notify, .eof, .err => self.conn.close(self, onClose),
        }
    }
    fn onClose(self: *App) void {
        self.conn.deinit();
        self.storage.secureZero(); // deinit does not touch lent memory
    }
};

// One Config backs many connections: the OS trust store is parsed once, not
// per connection.
var config = try tls.Config.initSystemBundle(blocking_io, gpa, .{
    .verify = .owned_bundle,
    .alpn = &.{"http/1.1"},
});
defer config.deinit();

app.conn.init(blocking_io, &loop, socket, &config, "example.com", app.storage.buffers());
app.conn.handshake(&app, App.onHandshake);
```

`io` is used only to seed the ClientHello random and the certificate validity
clock; libxev owns every actual I/O operation. DNS also needs a `std.Io` —
libxev has no resolver — which is why `examples/xev_client.zig` resolves once up
front and is completion-driven from there.

`Conn.deinit` releases engine state and **does not touch the buffers it was
lent** — reaching into borrowed memory is exactly what the core refuses to do to
us ([#81](https://github.com/mattrobenolt/ztls/issues/81)), and a per-teardown
memset of a hundred-odd KB is real cost to impose on a server that pools its
buffers. The record buffer ends up holding decrypted application plaintext and
the reassembly buffer holds handshake plaintext, so the owner clears them:
`Storage.secureZero()` for the common case, or your own slices if you brought
them. That ownership split is why `Storage` is built from `ztls.Array` rather
than plain arrays — `secureZero` comes with it.

## Not implemented yet

`peek`/`consume`/`writeNegotiationPlaintext` for StartTLS-style protocol
detection are absent, which is why the first state is `handshaking` rather than
`negotiating`; `isTls()` is provided for callers doing their own pre-TLS
peeking. Client authentication, kqueue/IOCP validation, key-update initiation,
and session resumption are all still open under #76.

In-flight cancellation of both reads and writes is covered for abortive and
orderly close on the default backend and explicitly on epoll (#83).

The epoll path carries a workaround for what looks like an upstream libxev bug.
Its epoll TCP watcher duplicates the fd per operation (`flags.dup`), and the
normal completion path closes that duplicate — but `stop_completion`, the
cancellation path, only does `epoll_ctl(CTL_DEL)` and never closes it. So a
cancelled read **leaks a file descriptor**, and because the duplicate still holds
a reference to the socket, closing the original fd does not make the peer see EOF.
That second effect is what stalled the connection; the fd leak is arguably the
worse half for a long-running server. `Conn` serializes transport completions
(`wait` permits one at a time), so the duplicate buys nothing here and is cleared
before the loop registers it — asserted, so an upstream change fails loudly rather
than silently.

The io_uring write path retires a stuck write with `shutdown(2)` rather than a
cancel: the kernel cannot find a request submitted in the same submission batch,
and a close cancels the write in exactly that batch (armed from inside a
completion callback), so the cancel comes back `NotFound` and retires nothing
— the write outlives the close and the `Conn`. `shutdown` fails the syscall
promptly with EPIPE regardless of request state (proven by
`probe/stuck_write_cancel.zig`).

Reported upstream as [mitchellh/libxev#231](https://github.com/mitchellh/libxev/issues/231)
(the dup leak and endpoint survival), with
[#230](https://github.com/mitchellh/libxev/issues/230) (the cancel branch
testing the cancel's own state instead of the target's) and
[#233](https://github.com/mitchellh/libxev/issues/233) (io_uring cancel
matching reused `user_data`) from the same investigation; the kqueue close
abort is [#232](https://github.com/mitchellh/libxev/issues/232).

kqueue does not use the duplicate at all, and its cancellation path is the one
remaining unproven surface: the abortive close with a read in flight stalls
there for reasons still unestablished, and the write variants share that shape
and are skipped with it. That keeps
[#83](https://github.com/mattrobenolt/ztls/issues/83) open.

Backends: io_uring and macOS/kqueue are CI-gated, IOCP is untouched.

## Build

```
just build             # smoke build
just test              # unit + round-trip tests
just build-examples    # compile every example (no peer required)
just lint
just ci                # everything above
```

Devshell: `nix develop .#ztls-xev`, or `cd` here and let direnv do it. The root
workspace delegates via `just integrations-ci`, wired into `just ci-0_16`.

```
zig build example-xev_client -- --host example.com
zig build example-xev_server -- --port 8443
```

The server example is an echo server with an embedded test certificate. Driven
by real OpenSSL clients:

```
$ printf 'hello openssl\n' | openssl s_client -connect 127.0.0.1:8443 \
      -tls1_3 -alpn echo -no_ign_eof
Negotiated TLS1.3 group: X25519MLKEM768
New, TLSv1.3, Cipher is TLS_AES_128_GCM_SHA256
ALPN protocol: echo
hello openssl

[xev] handshake ok: cipher=aes_128_gcm_sha256 alpn=echo
[xev] client closed cleanly after 14 echoed bytes
```
