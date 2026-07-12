# Examples

Runnable programs that drive the ztls Sans-I/O API. Run any of them with
`zig build example-<name>` (the name is the file stem, e.g.
`zig build example-tcp_loopback`).

Three groups, by what they're for.

## Adoption examples — start here

These show ztls composed into real I/O. They run in CI, so they stay working.
If you're wiring ztls into something, read these first.

- **`in_memory_handshake`** — client and server in one process, connected by
  buffer passing. No sockets. The simplest end-to-end proof.
- **`tcp_loopback`** — the same handshake over a real `net.Stream` on loopback,
  proving the Sans-I/O API composes with actual sockets.
- **`epoll_pingpong`** — two threads, each with its own epoll loop and
  non-blocking socket, handshake and exchange messages. No blocking I/O.
- **`iouring_pingpong`** — deterministic io_uring client/server in one process;
  all socket reads/writes go through io_uring, TLS stays Sans-I/O.
- **`ktls_server`** — userspace handshake, then hand the keys to the kernel
  (kTLS) and let the kernel move the data plane.

## Educational demos — protocol and crypto walkthroughs

Fixed RFC 8448 test vectors, no I/O. These exist to show the pipeline, not to
be copied into production.

- **`full_handshake`** — the client driver (init → start → processRecord)
  against the RFC 8448 §3 server flight.
- **`handshake_keys`** — the key-exchange pipeline end to end: X25519 →
  ClientHello/ServerHello → DHE secret → HKDF schedule → traffic secrets.
- **`key_schedule`** — the key schedule and record-layer composition from a DHE
  shared secret through to a `RecordLayer`.
- **`record_protection`** — the minimum setup to protect and unprotect records:
  two parties, a shared key and IV, data back and forth.

## Manual demos — need a real peer

Not CI-gated. They talk to an external process (a browser, `openssl`, a real
server) and exit non-zero if the peer isn't there.

- **`https_client`** — TLS 1.3 HTTPS client with certificate verification; GETs
  `127.0.0.1:8443` and prints the decrypted response.
- **`https_server`** — server-authenticated handshake over `std.net`, answers
  one HTTP/1.0 GET on `127.0.0.1:8443`.
- **`iouring_client`** — io_uring HTTPS client proof; io_uring drives the socket
  edge only, TLS records still move through ztls.
