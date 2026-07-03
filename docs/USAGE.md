# ztls — Sans-I/O

ztls is a pure TLS 1.3 state machine: you feed it bytes, it gives you bytes back. It does not open sockets, allocate memory, or spawn threads. This document shows how to drive a handshake and exchange application data using the public API.

## Mental model

```
     Network bytes (TLS records)
           |         ^
     feed  |         | drain
           v         |
     +-----+---------+-----+
     |                     |
     |    Engine (ztls)    |
     |    state machine    |
     |                     |
     +-----+---------+-----+
           |         ^
    read   |         | write
           v         |
     Plaintext application data
```

The engine owns the TLS protocol: framing, encryption, transcript hashing, alerts, and key ratcheting. The caller owns all buffers, all transport I/O, and the drive loop that moves bytes between the two.

## Walkthrough: start with these examples

`docs/USAGE.md` is the reference. If you want executable adoption paths first, read the CI-gated examples:

- `examples/in_memory_handshake.zig` — both engines in one process, no sockets. Read this first: it shows the full 1-RTT handshake and application data in both directions.
- `examples/tcp_loopback.zig` — ztls client plus ztls server over `std.net.Stream` on loopback.
- `examples/epoll_pingpong.zig` — non-blocking Linux epoll client/server ping-pong.
- `examples/iouring_pingpong.zig` — Linux io_uring client/server ping-pong.

`just examples-ci` builds and runs those paths. If a drive-loop shape here diverges from those examples, this document is the stale side.

## Supported surface for adopters

ztls is TLS 1.3 only. The supported user-facing path is server-authenticated 1-RTT over caller-owned buffers.

| Area | Supported today | Not covered here |
|---|---|---|
| TLS versions | TLS 1.3 | TLS 1.2 and DTLS are out of scope. |
| Cipher suites | `TLS_AES_128_GCM_SHA256`, `TLS_AES_256_GCM_SHA384`, `TLS_CHACHA20_POLY1305_SHA256` | Suite expansion is provider work. |
| Key exchange | X25519 in the examples; server-side P-256 ECDHE exists for conformance work | Client-side non-X25519, P-384, and PQ/hybrid groups are tracked by #6. |
| Authentication | Server certificate authentication | Client certificate auth is tracked by #4. |
| Resumption | None | PSK/session resumption is tracked by #2; 0-RTT is tracked by #3. |
| HRR | Not in the adoption path | HelloRetryRequest retry support is tracked by #1. |

## Buffer ownership

- **Caller owns every buffer.** The engine holds no heap state and never allocates.
- **`out`** — caller-provided scratch for records the engine emits (ClientHello, Finished, app data, alerts).
- **`storage`** — caller-provided backing for `RecordBuffer`, which turns a byte stream into whole records.
- **Records are decrypted in place.** `RecordBuffer.next()` returns a mutable slice into `storage`. Hand it to `handleRecord`, which may mutate it during decryption. The slice is valid only until the next `next()` or `writable()` call.
- **Application data** returned in `Event.application_data` is a slice into that same record buffer. Copy it before the next engine call if you need it longer.

## RecordBuffer: stream to record framing

Transports deliver bytes; the engine consumes complete TLS records. `RecordBuffer` bridges the gap.

```zig
var storage: [ztls.RecordBuffer.recommended_storage]u8 = undefined;
var rb: ztls.RecordBuffer = .init(&storage);

// Read transport bytes into the free region.
const n = try stream.read(rb.writable());
if (n == 0) return error.PeerClosed;
rb.advance(n);

// Pull whole records and feed them to the engine.
while (try rb.next()) |record| {
    const ev = try hs.handleRecord(record, &out);
    // ... handle event
}
```

- `writable()` compacts unconsumed bytes to the front, then returns the largest contiguous free region.
- `advance(n)` reports how many bytes were written.
- `next()` returns `null` until a full record is buffered. No partial record is ever handed out.
- `recommended_storage = 2 * min_storage` (about 33 KiB). This fits a partial record plus a full one, so a read that straddles a boundary still makes progress.

## The drive loop

Every connection follows the same pattern, whether client or server:

1. **Emit** — call an engine method that produces bytes (`start`, `handleRecord`, `sendApplicationData`).
2. **Write** — send those bytes to the transport.
3. **Acknowledge** — call `completeWrite()` to tell the engine the bytes were sent.
4. **Read** — pull more bytes from the transport into `RecordBuffer`.
5. **Repeat** until connected, then keep repeating for application data.

### Client drive loop

```zig
var out: ztls.ClientHandshake.OutBuffer = .empty;
var storage: ztls.RecordBuffer.Storage = .empty;
var rb: ztls.RecordBuffer = .init(&storage.buffer);

var hs: ztls.ClientHandshake = .init(keypair);

try stream.writeAll(try hs.start(&out.buffer, random, "example.com"));
hs.completeWrite();

while (!hs.isConnected()) {
    const n = try stream.read(rb.writable());
    if (n == 0) return error.ServerClosed;
    rb.advance(n);
    while (try rb.next()) |record| switch (try hs.handleRecord(record, &out.buffer)) {
        .write => |w| {
            try stream.writeAll(w);
            hs.completeWrite();
        },
        .application_data, .closed => return error.UnexpectedDuringHandshake,
        .none => {},
    };
}
```

### Server drive loop

The server loop is identical in shape, with two differences:

1. `ServerHandshake.handleRecord` takes an extra `random` argument for the ServerHello random.
2. Server credentials are configured before the ClientHello arrives, and `sendServerFlightBuffered` sends the authenticated server flight after ServerHello is written.

```zig
var hs: ztls.ServerHandshake = .init(server_keypair);
var signer = try ztls.signature.PrivateKey.fromP256Scalar(scalar[0..32]);
defer signer.deinit();
hs.setCredentials(&.{cert_der}, signer.signer());

var random: ztls.client_hello.Random = undefined;
std.crypto.random.bytes(&random.data);

var out: ztls.ServerHandshake.OutBuffer = .empty;
var flight: ztls.ServerHandshake.FlightBuffer = .empty;
var storage: ztls.RecordBuffer.Storage = .empty;
var rb: ztls.RecordBuffer = .init(&storage.buffer);

while (!hs.isConnected()) {
    const n = try stream.read(rb.writable());
    if (n == 0) return error.ClientClosed;
    rb.advance(n);
    while (try rb.next()) |record| switch (try hs.handleRecord(record, random, &out.buffer)) {
        .write => |w| {
            try stream.writeAll(w);
            hs.completeWrite();
            if (try hs.sendServerFlightBuffered(&flight)) |flight_bytes| {
                try stream.writeAll(flight_bytes);
                hs.completeWrite();
            }
        },
        .none => {},
        .application_data, .closed => return error.UnexpectedDuringHandshake,
    };
}
```

## The `pending_write` interlock

Every engine method that produces bytes sets an internal `pending_write` flag. The next engine call returns `error.PendingWrite` until `completeWrite()` clears the flag.

This prevents a silent desync: if the caller drops a write (kernel buffer full, async task cancelled, early return), the engine would otherwise advance its sequence numbers while the peer never saw the record. `pending_write` forces the caller to acknowledge every emitted record before the state machine moves on.

Rules:
- Call `completeWrite()` **immediately after** the bytes are written to the transport.
- Never call two engine send-methods in a row without `completeWrite()` between them.
- In async code, `completeWrite()` belongs in the write-completion callback.

## Event union

`handleRecord` returns an `Event`:

| Variant             | Meaning                                      | When it occurs                              |
|---------------------|----------------------------------------------|---------------------------------------------|
| `.write: []const u8` | A record that must be sent to the peer       | Client Finished, KeyUpdate response         |
| `.application_data`  | Decrypted plaintext from the peer            | Connected phase only                        |
| `.none`              | Nothing to send; state advanced internally   | ChangeCipherSpec discarded, flight partial  |
| `.closed`            | Peer sent `close_notify`                     | Any phase                                   |

`.application_data` during the handshake is an error (`UnexpectedDuringHandshake`) because application data must not arrive before the handshake completes.

## Server credentials

Unlike the client, which only needs a certificate policy, the server must send a certificate chain and sign the `CertificateVerify` message. Configure that before processing the ClientHello:

```zig
var signer = try ztls.signature.PrivateKey.fromP256Scalar(scalar[0..32]);
defer signer.deinit();
server.setCredentials(&.{leaf_cert_der}, signer.signer());
```

The certificate chain is a DER slice list in leaf-first order. `sendServerFlightBuffered` uses the configured credentials, owns the authenticated-flight one-shot latch, and returns `null` if there is no server flight to send.

```zig
var flight: ztls.ServerHandshake.FlightBuffer = .empty;
if (try server.sendServerFlightBuffered(&flight)) |flight_bytes| {
    try stream.writeAll(flight_bytes);
    server.completeWrite();
}
```

`sendAuthenticatedFlight` remains available as a lower-level escape hatch, but new callers should prefer up-front `setCredentials` plus `sendServerFlightBuffered`. `PrivateKey.deinit()` zeroes key material via libcrypto.

## SNI (server name indication)

After `handleRecord` returns the first `.write` event (the ServerHello), the server can read the hostname the client requested:

```zig
if (server.clientServerName()) |name| {
    // select certificate based on `name`
}
```

`clientServerName()` returns `null` if the client sent no `server_name` extension. The slice points into the caller's record buffer; copy it if you need it past the next `handleRecord` call.

> Virtual hosting pattern: call `handleRecord` for the ClientHello, inspect `clientServerName()`, select the appropriate keypair/cert, call `setCredentials`, then send the authenticated flight with `sendServerFlightBuffered`.

## ALPN

Both sides offer protocol lists before the handshake begins:

```zig
// Client
client.offerAlpn(&.{ "h2", "http/1.1" });

// Server
server.supportAlpn(&.{"h2"});
```

After the handshake, `selectedAlpnProtocol()` returns the negotiated protocol (or `null` if none was agreed). The server picks the first entry from its list that the client also offered; if both sides sent ALPN but no protocol matches, `acceptClientHello` returns `error.NoApplicationProtocol`. The client rejects a server-selected protocol that was not offered (`error.UnofferedAlpnProtocol`).

## Certificate policy

The client validates the server certificate chain against a caller-owned policy:

```zig
client.policy.host_name = "example.com";     // SAN/CN check
client.policy.bundle = &bundle;               // trust-anchor anchoring
client.policy.now_sec = std.time.timestamp(); // validity-period check
```

A client policy without `bundle` rejects the server Certificate unless the caller
explicitly sets `insecure_no_chain_anchor = true` for a test/demo fixture. The
bundle type is Zig's `std.crypto.Certificate.Bundle`; load it from the trust
anchors appropriate for your application and keep it caller-owned for the
connection lifetime. The insecure fixture mode still verifies CertificateVerify
key possession, but it does not authenticate the chain to any trust root.

## Close semantics

A clean close is a bidirectional `close_notify` alert exchange (RFC 8446 §6.1). Send one when you're done:

```zig
const rec = try engine.sendAlert(.close_notify, &out);
try stream.writeAll(rec);
engine.completeWrite();
```

When the peer sends `close_notify`, `handleRecord` returns `.closed`. Receiving `.closed` does not automatically send a `close_notify` back — the caller decides whether to half-close, reply in kind, or simply drop the connection.

Fatal alerts (`decode_error`, `unexpected_message`, etc.) are sent the same way but always at fatal level:

```zig
const rec = try engine.sendAlert(.decode_error, &out);
try stream.writeAll(rec);
// don't call completeWrite; treat the connection as dead
```

Before the handshake is encrypted (`.wait_ch` state), `sendAlert` emits a plaintext alert record. Once handshake keys are installed, all alerts are encrypted.

## Buffer sizing

| Buffer     | Minimum recommended | Why                                      |
|------------|---------------------|------------------------------------------|
| `out`      | 4 KiB               | Fits a full record plus handshake overhead |
| `storage`  | `RecordBuffer.recommended_storage` (~33 KiB) | Fits a partial + full record             |
| `flight`   | `ServerHandshake.FlightBuffer` | Holds the encrypted server authenticated flight |

The engine returns `error.BufferTooShort` if `out` is too small. Use `RecordBuffer.recommended_storage` for `storage`; anything smaller risks stalling on a large record.

## What is not shown here

ztls focuses on TLS 1.3 server-auth 1-RTT. These features are intentionally out of scope for the examples above:

- Client certificate authentication (#4)
- 0-RTT / early data (#3)
- PSK / session resumption (#2)
- HelloRetryRequest retry support (#1)
- Client-side non-X25519, P-384, and PQ/hybrid key shares (#6)

The `RecordBuffer` + `handleRecord` pattern is the same for every supported flow; higher-level wrappers (async runtimes, `std.net.Stream` adapters) belong in separate packages.
