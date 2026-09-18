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
- Key exchange: X25519, P-256, and opt-in P-384 ECDHE, plus the three RFC
  10024 hybrid groups: X25519MLKEM768, SecP256r1MLKEM768, and
  SecP384r1MLKEM1024. Hybrid KEX is provider-backed on OpenSSL, AWS-LC, and
  BoringSSL and disabled by the FIPS backend identities. Plain P-384 and all
  three hybrids have bidirectional OpenSSL 3.6 interop on every non-FIPS
  backend; the hybrids additionally pass the pinned upstream tlsfuzzer matrix.
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
- One fetched root package exposes `ztls`, `ztls_std`, `ztls_xev`, and
  Linux-only `ztls_ktls`; libxev remains an explicit lazy opt-in.
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

### Changed

- Private keys can infer supported TLS 1.3 signature schemes from PEM material, and callers can validate certificate/private-key pairing before starting or rotating a server.
- Encrypted PEM private keys now fail at load instead of prompting for a passphrase: the loaders decline password input, so an unattended startup cannot block on a terminal or eat process stdin. A caller-owned password API is not designed yet.
- Servers can derive and emit allocation-free TLS 1.3 NewSessionTicket records,
  resume them through caller-owned PSK lookup policy, and hand TX ownership to
  kTLS only after ticket writes are flushed.
- Public hybrid capability queries now expose the selected backend, FIPS identity, and role support.
- Hybrid policy validation now returns explicit local configuration errors from core and low-level
  encoder APIs.
- `ztls-xev` client and server configuration constructors are now fallible.
- Public inline keypair, session ticket, and kTLS values now expose `secureZero()` methods.
- Client handshake traffic-key carrier structs without a public lifecycle contract are no longer
  exported.

### Not done yet

- **No C ABI.** ztls is only callable from Zig today. A C-callable surface so
  non-Zig callers exist is tracked by
  [#30](https://github.com/mattrobenolt/ztls/issues/30).
- **No stable API contract.** Function signatures, type names, and module
  layout can and will change without notice.
- **No release tag.** Nothing has been published. Depend on `main` with eyes
  open, or don't depend on it yet.

### Out of scope

- TLS 1.2 and earlier (no downgrade target, by design).
- DTLS.
- Windows (Linux and macOS only).
