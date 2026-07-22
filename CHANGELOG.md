# Changelog

All notable changes to ztls are recorded here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

ztls is pre-alpha and has never been released. There are no version tags yet,
and there is deliberately no stable API. The only artifact is `main`. See the
"Roadmap to v0.1.0" section of the [README](README.md) for the gates that stand
between here and a first tagged release.

## [Unreleased]

This section describes what exists on `main` today. It is not a release.
`PRODUCTION_READINESS.md` is the authority behind every claim below.

### Working today

- TLS 1.3 client and server handshakes over caller-owned buffers, with no I/O
  of ztls's own — you feed it wire bytes and it hands back bytes to send.
- The ztls engine (parsing, framing, transcript, record sequencing) allocates
  nothing on its own. The libcrypto backend allocates during setup and inside
  its own primitives; that caveat is stated plainly and not hidden.
- Three interchangeable, interop-proven crypto backends selected at build time:
  OpenSSL (default), AWS-LC, and BoringSSL. Each compiles, passes the full test
  suite, and has clean TLS-Anvil captures.
- Cipher suites: AES-128-GCM, AES-256-GCM, ChaCha20-Poly1305.
- Key exchange: X25519 and P-256 ECDHE.
- Server certificate authentication (hostname verification, chain validation,
  leaf policy) and client certificate authentication (both roles, EKU/KU
  enforcement, OpenSSL interop). Chain validation anchors at the highest
  presented certificate whose issuer is a trust anchor (trusted-first), so
  chains terminating in a cross-signed root verify like OpenSSL's.
- Session resumption (PSK / NewSessionTicket) and 0-RTT early data, with
  replay-safety policy left to the caller.
- HelloRetryRequest, KeyUpdate (both directions), application data, alerts, and
  `close_notify`.
- Linux kTLS offload: userspace handshake, kernel data plane.
- Client and server examples across `std.net.Stream`, epoll, io_uring, and an
  in-memory pipe, all exercised in CI.
- Benchmarked against OpenSSL libssl and rustls with n=10 captures on x86_64
  (`c7i.2xlarge`), aarch64 (`c7g.2xlarge`), and macOS (Apple M1 Max), with
  formal confidence intervals and a committed regression gate. The measured
  wins, the one measured loss (small ChaCha20 records on x86_64), and the
  methodology are all in the repo.
- An internal adversarial security review (recon → hunt → validate) that found
  and fixed three vulnerabilities, with regression tests. This is not an
  external audit.

### Not done yet

- **No C ABI.** ztls is only callable from Zig today. A C-callable surface so
  non-Zig callers exist is tracked by
  [#30](https://github.com/mattrobenolt/ztls/issues/30).
- **No post-quantum or broader named groups locked in.** P-384 and the
  X25519MLKEM768 hybrid exist but are not yet validated against an external
  conformance peer; wider named-group and PQ/hybrid work is tracked by
  [#6](https://github.com/mattrobenolt/ztls/issues/6).
- **No stable API contract.** Function signatures, type names, and module
  layout can and will change without notice.
- **No release tag.** Nothing has been published. Depend on `main` with eyes
  open, or don't depend on it yet.

### Out of scope

- TLS 1.2 and earlier (no downgrade target, by design).
- DTLS.
- Windows (Linux and macOS only).
