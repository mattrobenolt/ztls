# ztls-ktls

Linux kTLS data-plane integration for ztls, built with Zig 0.16.

ztls performs the TLS 1.3 handshake in userspace. `ztls-ktls` then installs the
negotiated TX and RX traffic epochs on the connected TCP socket. Application
records are encrypted and decrypted by the kernel; ztls remains alive as the
key-schedule owner for later KeyUpdate messages.

The package allocates no memory and supports AES-128-GCM, AES-256-GCM, and
ChaCha20-Poly1305.

## Handoff contract

The transition to `TLS_RX` is one-way. Before activation:

1. Drive the handshake to `isConnected()`.
2. Write every record returned by the engine and call `completeWrite()`.
3. Keep parsing every complete record already read from the socket. Deliver or
   retain any application plaintext encountered after Finished.
4. If the record buffer holds a partial record, read until it is complete and
   process it.
5. Keep the peer from sending another TLS record until activation completes,
   using an application-level barrier or equivalent protocol coordination.
6. Call `activate` with the exact `RecordBuffer` used by that read loop.

`RecordBuffer.isEmpty()` proves only that userspace has drained its read-ahead;
it cannot close a race with ciphertext arriving in the socket receive queue.
The live suite gates peer application writes until the activating endpoint has
installed `TLS_RX`, while its forced-read-ahead scenario drains an application
record already consumed by userspace.

```zig
if (!handshake.isConnected()) return error.NotConnected;
if (!record_buffer.isEmpty()) return error.BufferedCiphertext;

var connection = try ztls_ktls.Server.activate(
    socket_fd,
    &handshake,
    &record_buffer,
);
```

`activate` rejects a pending userspace write, an unanswered peer KeyUpdate
request, or any buffered ciphertext. It exports each `KtlsInfo` immediately
before `setsockopt`, zeroes local copies, and never stores key snapshots. If
activation partially installs kTLS
and then fails, it shuts down the socket; the caller must close the descriptor
rather than falling back to userspace TLS.

The handshake object and socket are borrowed and must outlive `connection`.
The caller still owns the descriptor.

## Data plane

Use the package for every operation after activation. Do not call the borrowed
handshake's record-layer methods directly after ownership crosses to the kernel:

- `read(buf)` always uses `recvmsg` with `TLS_GET_RECORD_TYPE`. The buffer must
  be at least `ztls.frame.max_plaintext_len` bytes so a control-record boundary
  cannot be truncated. It consumes post-handshake records internally and
  returns application bytes. Zero means the peer sent `close_notify`; if the
  local write side remains open, call `closeWrite()` to send the required
  response. A bare FIN is `error.Truncated`.
- `write(bytes)` returns the exact application-byte count consumed by the
  kernel. Handle short writes normally.
- `update(request)` sends KeyUpdate under the old TX epoch, ratchets ztls, and
  immediately installs the new epoch before any later application write.
- `closeWrite()` sends an explicit `close_notify` alert with
  `TLS_SET_RECORD_TYPE`, then shuts down the TCP write half. Closing a kTLS
  socket alone does **not** synthesize a TLS alert.
- `abort()` wakes both directions without claiming a clean TLS close.

`Client` and `Server` have the same data-plane API. Calls are single-threaded:
one task owns the connection and no read, write, update, or close operation may
run concurrently. Use blocking sockets. The read path may send a KeyUpdate
response.

## Kernel support

Initial offload gracefully reports `error.KtlsUnavailable` when the TLS ULP or
negotiated cipher is absent. The test suite skips live kernel cases in that
environment.

Live TLS 1.3 rekey requires the Linux rekey support merged for the 6.14-era
kernel. Activation probes this with an identical TX reinstall before the first
kernel send:

- `.supported`: peer- and locally initiated KeyUpdate are enabled.
- `.unsupported`: `update` returns `error.KtlsRekeyUnsupported`; a peer
  KeyUpdate terminates the offloaded connection because userspace cannot safely
  resume record processing after `TLS_RX` activation.

Do not gate on `uname`; use `rekeySupport()`.

## Deliberate limits

- Kernel receive behavior remains part of the TCB. Affected Linux versions can
  remain inside `recvmsg` while a peer streams legal empty application records.
  Deploy a kernel carrying the
  [upstream zero-length-record receive fixes](https://lore.kernel.org/netdev/20260726-tls-follow-on-v1-0-99bf4cc1c729@kernel.org/)
  where adversarial availability matters. Userspace cannot bound a syscall that
  kernel does not return from.
- A first-record fragment beginning with KeyUpdate is connection-fatal with
  `error.FragmentedKeyUpdate`. Linux pauses RX after seeing byte `0x18` at the
  start of that record and cannot expose the continuation without a risky
  same-key reinstall. The package sends `unexpected_message` and closes rather
  than guessing. Complete coalesced post-handshake messages are parsed by ztls.
- One `read()` consumes at most 64 post-handshake control records before
  returning application data. A larger control-only burst fails closed with
  `error.ControlRecordFlood`.
- kTLS does not enforce RFC 8446 §5.5 AEAD usage limits. This package does not
  yet poll `TLS_TX`/`TLS_RX` sequence numbers to initiate preventive updates.
- Client `NewSessionTicket` messages are consumed but not surfaced; the package
  does not currently support collecting post-handoff resumption tickets.
- Linux may silently select `TLS_HW` on an offload-capable NIC. The package
  neither detects nor disables that path; live-rekey semantics are verified
  only for software kTLS and remain driver-dependent under device offload.
- No `splice`, `sendfile`, `MSG_MORE`, `TLS_RX_EXPECT_NO_PAD`, fork/fd-passing,
  TLS 1.2, anti-replay, or connection-pooling contract.
- No fallback to userspace TLS after activation.

## Development

```sh
nix develop ../..#ztls-ktls
just ci
just flake-check 20
```

The live suite uses loopback TCP, all three cipher suites, both package roles,
bidirectional KeyUpdate, an empty application record before real data,
proactive coalesced-message rekey, explicit close alerts, bare-FIN truncation,
the buffered-handoff and unanswered-KeyUpdate guards, read-ahead draining
between helper calls, and bounded fragmented-KeyUpdate failure. It sets socket
timeouts and skips only when the
kernel TLS ULP/cipher is unavailable.
On a development kernel where the module is present but unloaded, load `tls`
before running the suite.
