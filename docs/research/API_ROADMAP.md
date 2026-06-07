# API examples and wrapper roadmap

ztls core stays Sans-I/O: no sockets, no event loop, no allocator-owned TLS buffers. API proof work should therefore live in examples or wrapper packages, not in the TLS engine.

## Implemented proof points

- `examples/full_handshake.zig` drives the public client handshake API against RFC 8448 records and proves application keys are live.
- `examples/in_memory_handshake.zig` drives a ztls client and ztls server through a full authenticated in-memory handshake, ALPN negotiation, and application-data ping/pong.
- `docs/USAGE.md` documents the caller-owned drive loop, `RecordBuffer`, pending-write interlock, events, certificate policy, SNI, ALPN, server signing, and close semantics.

These are the canonical API examples for the current core surface. They deliberately avoid `std.net`, io_uring, HTTP parsing, and runtime-specific adapters.

## HTTPS wrapper acceptance criteria

A basic HTTPS server/client wrapper belongs outside the core or in examples that are clearly wrappers around the Sans-I/O engine. Acceptance for a wrapper example:

- uses `std.net` or a platform runtime only at the edge;
- feeds bytes through `RecordBuffer` and `handleRecord` exactly as in `docs/USAGE.md`;
- sends `close_notify` on clean shutdown;
- verifies server certificates in client examples with `host_name`, `bundle`, and `now_sec` set explicitly;
- keeps TLS buffers caller-owned and does not add allocator use to `src/`;
- has at least one real-socket integration test connecting the wrapper to ztls or OpenSSL.

Until that wrapper exists, `examples/in_memory_handshake.zig` is the supported server API proof, not an HTTPS server claim.

## io_uring client proof

io_uring is Linux-only and should not introduce portability tax into ztls. Acceptance for an io_uring proof:

- Linux-gated build step or separate package; macOS must not try to compile it;
- TLS state machine remains identical to the `RecordBuffer` drive loop;
- write completion calls `completeWrite()` exactly once per emitted record;
- partial reads/writes are handled without copying buffered TLS records unnecessarily;
- certificate verification is wired the same way as any other client wrapper.

Do not fake this with a non-io_uring example. If it cannot be built and tested on Linux in CI, keep it as a documented wrapper milestone.

## Client-auth policy shape

Client certificate authentication is not part of the current advertised API. When implemented, it needs:

- server `CertificateRequest` policy;
- client certificate-chain and signer callback mirroring the server signer pattern;
- server verification policy for client EKU/key-usage semantics;
- explicit alert mapping for missing or invalid certificates;
- OpenSSL interop both directions.

This shape is tracked with the protocol gates in `docs/research/CONFORMANCE_ROADMAP.md`.
