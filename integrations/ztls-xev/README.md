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

The API shape follows a proven server-side libxev TLS integration rather than
being invented here; the `ReadResult` split in particular is lifted from it.

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

Client only. `peek`/`consume`/`writeNegotiationPlaintext` for StartTLS-style
protocol detection are absent, which is why the first state is `handshaking`
rather than `negotiating`; `isTls()` is provided for callers doing their own
pre-TLS peeking. Server role, kqueue/IOCP validation, key-update initiation, and
session resumption are all still open under #76.

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
```
