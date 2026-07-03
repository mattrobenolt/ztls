# ztls Production Readiness

**This document is the single authoritative answer to "what is the state of this
project, and what does done mean?"** If the state of ztls is written down
anywhere, it is written down here. Other documents may explain *how* something
works; only this one says *whether it is done and how we know*.

## How this document works

- **One source of truth.** Status lives here and nowhere else. Roadmap and
  design docs describe mechanism; they must not re-assert status. If you catch
  another doc claiming "X is done / not done," that line is a bug — delete it
  and point to this file.
- **Living document.** It is expected to change every time a claim's evidence
  changes. A stale readiness doc is worse than none.
- **Work items live in GitHub Issues.** This doc references canonical issue
  numbers. It does not duplicate their bodies. Each gap below points at the
  issue that tracks closing it.
- **Consistency is enforced, not hoped for.** Cited issue numbers must resolve,
  and active work cited from committed files must point at open issues.

## Status vocabulary

| Token | Meaning |
|---|---|
| `PROVEN` | Claim is backed by reproducible, CI-gated evidence. |
| `PARTIAL` | Some evidence exists; known gaps remain, enumerated below. |
| `UNPROVEN` | Believed true, but no systematic evidence. The dangerous state. |
| `NONE` | Not implemented / not started. |
| `AUDIT NEEDED` | Not yet assessed in this document — recon pending. |

---

## Definition of Done

ztls is production-ready when all six pillars are `PROVEN`:

1. **Correctness** — provably conformant to TLS 1.3. Every normative MUST in
   RFC 8446 is mapped to a passing test or an explicit, documented out-of-scope
   decision. "We have test suites" is not proof; a claims-to-evidence matrix is.
2. **Ergonomics** — the Sans-I/O API is demonstrably pleasant to use, proven by
   complete, working client *and* server examples across io_uring, epoll, and
   `std.net.Stream`. "Works everywhere" is shown, not asserted.
3. **Performance** — ztls is measurably competitive with (ideally faster than)
   OpenSSL libssl and rustls, with reproducible benchmarks across a hardware
   matrix, and a documented methodology proving the comparisons are
   apples-to-apples. This pillar is the project's reason for existing.
4. **Providers** — aws-lc, BoringSSL, and bring-your-own libcrypto are
   supported behind a clean provider seam, each validated through the same
   correctness and interop gates as the default backend.
5. **Marketing flair** — the positioning story (why ztls over libssl) is told
   clearly, backed by the Pillar 3 numbers.
6. **User docs** — external users can adopt ztls from getting-started through
   API reference and integration guides without reading the source.

---

## Readiness Dashboard

| Pillar | Status | One-line |
|---|---|---|
| 1. Correctness | `PARTIAL` | Strong layered evidence; the RFC 8446 MUST matrix has no `GAP`/`PARTIAL` rows for the current supported surface, but external conformance runners are not fully CI-gated. |
| 2. Ergonomics | `PARTIAL` | CI-gated deterministic examples cover both client and server roles for `std.net.Stream`, epoll, and io_uring; driver ergonomics remain rough. |
| 3. Performance | `PARTIAL` | Rich bench harness exists; equivalence methodology and reproducible hardware-matrix results are missing. |
| 4. Providers | `PARTIAL` | OpenSSL primitives are live and AWS-LC selection is explicit, but the primitive facade and capability table remain incomplete. |
| 5. Marketing | `NONE` | Not started. |
| 6. User docs | `PROVEN` | Root on-ramp plus `docs/USAGE.md` cover fresh-project setup, supported surface, drive loops, API reference, and CI-gated integration examples. |

---

## Pillar 1 — Correctness

**Target:** every RFC 8446 MUST is mapped to evidence or an explicit
out-of-scope decision; the things that must *fail* are enumerated and tested as
rigorously as the things that must succeed.

**Supported surface today** (per `CORRECTNESS.md`): TLS 1.3 full handshake over
X25519, three mandatory cipher suites, certificate-authenticated server flight
with client verification gates, application data, alerts, `close_notify`,
post-handshake KeyUpdate (both directions, flood-bounded, record-boundary
enforced). NewSessionTicket is parsed for structural validity and discarded —
consumption-for-rejection, not resumption.

**Current evidence (real, and good):**

- RFC-cited unit tests; every test names its spec section (AGENTS.md mandate).
- RFC 8448 known-answer vectors for the key schedule and transcript.
- OpenSSL interop in both directions, covered by `zig build test`.
- tlsfuzzer conformance, CI-gated (`just conformance/tlsfuzzer`).
- TLS-Anvil wrapper/report helper tests are CI-gated under `just conformance/ci`:
  synthetic skip-list normalization, synthetic real-output adapter coverage,
  per-run metadata/provenance capture, and per-run tool-log capture helpers.
  Manual TLS-Anvil runs capture the command and stdout/stderr under the run dir;
  unfinished raw TLS-Anvil reports are rejected by default and partial captures
  are local audit/debug only. A completed server run on `496750d`
  (`conformance/zig-out/anvil/server/20260616-074609`) strict-normalized from a
  clean tree with launch metadata, `Running: false`, `FinishedTests: 437`,
  `TotalTests: 437`, and normalized counts of `passed: 105`, `failed: 0`,
  `expected_skipped: 175`, `unexpected_skipped: 0`, and `not_attempted: 157`.
  `docs/research/TLS_ANVIL_NOT_ATTEMPTED.md` classifies that bucket as `89`
  in-scope client/both-endpoint runner debt and `68` explicit TLS 1.2/DTLS
  out-of-scope rows. The attempted server-side TLS-Anvil surface is clean
  (`105/105` attempted passed), including `KeyUpdate: passed=4` and
  `ComplianceRequirements: passed=2`.
  The real server suite is wired in `.github/workflows/tls-anvil-server.yml` for
  weekly and manually-triggered runs; client execution and BoGo remain open.
- Wycheproof boundary vectors at the libcrypto seam.
- Fuzzing on the major parsers plus record decrypt and server `handleRecord`
  pre-auth/post-auth dispatch.
- Targeted client-side bad-server tests for malformed ServerHello, unexpected
  flight messages, bad CertificateVerify and Finished checks, corrupted
  encrypted records, client-emitted alert descriptions, peer fatal alerts,
  illegal pre-handshake application data, unexpected post-handshake inner content
  types, and truncated-record framing robustness.
- `docs/research/RFC8446_MUST_MATRIX.md` maps TLS 1.3 normative requirements
  to tests, caller-boundary decisions, or explicit out-of-scope feature issues;
  no supported-surface row remains `GAP` or `PARTIAL`.
- `docs/research/NEGATIVE_SPACE.md` inventories supported-surface malformed and
  malicious peer inputs, mapping each to ztls's response and evidence or an
  explicit gap.
- `docs/research/THREAT_MODEL.md` defines the in-scope attacker, defended
  attack classes, non-goals, caller responsibilities, and threat-relevant gaps.
- Explicit verification gates (client must verify Certificate / CertificateVerify
  / Finished before promoting to app keys; server must verify client Finished).
- RFC 5280 name constraints are enforced in the certificate path for DNS, IP,
  rfc822Name, and URI GeneralName forms, including permitted/excluded subtree
  tests, critical unsupported-subtree rejection, and real chain fixtures for DNS
  permitted/excluded behavior.

**Status:** `PARTIAL`

**Gaps (this is the punch-list that converts dread into work):**

- **External runner coverage is still partial.** BoGo and full TLS-Anvil
  execution are not in PR `just ci`. The completed server-mode TLS-Anvil run has
  `89` classified in-scope client/both-endpoint rows that still require client
  or both-endpoint runner execution. TLS-Anvil normalization and wrapper-helper
  tests are gated, and the real TLS-Anvil server suite runs in a separate
  scheduled/manual workflow, but TLS-Anvil client execution and BoGo runner
  wiring remain open. Completed TLS-Anvil server evidence now has no unexpected attempted
  failures; remaining named-group scope beyond the proven server-side P-256 path
  stays tracked under broader provider-backed group work *(#6)*. HelloRetryRequest
  server retry now passes TLS-Anvil, but full client/server HRR
  state-machine support remains broader open work *(#1)*. Record-fragmentation
  capability is probe-positive and locally covered for fragmented ClientHello,
  Finished, and KeyUpdate; TLS-Anvil's `RecordLayer.interleaveRecords` remains a
  sender-restriction expected skip, not a missing-fragmentation result. The
  TLS-Anvil-derived failures fixed and closed by completed-run evidence are
  legacy-only `signature_algorithms` rejection *(#35)*, `close_notify` on
  orderly close *(#36)*, compatibility CCS emission *(#37)*, SSLv3
  `legacy_version` rejection *(#38)*, record-fragmentation capability *(#40)*,
  and fragmented KeyUpdate handling *(#41)*. *(#9)*
- **Correctness remains `PARTIAL` until external conformance is CI-gated.** The
  RFC 8446 MUST matrix is closed for the current supported surface; future
  feature work that changes TLS scope must reopen the relevant rows in the same
  change.

---

## Pillar 2 — Ergonomics

**Target:** complete, working, idiomatic client and server examples proving the
Sans-I/O API is pleasant across every I/O model ztls claims to support.

**The matrix that defines done:**

| | io_uring | epoll | `std.net.Stream` |
|---|---|---|---|
| Client | `PROVEN` — `examples/iouring_pingpong.zig` runs an io_uring client that completes a full TLS 1.3 handshake and exchanges ping/pong application data with a server thread over loopback; it is Linux-gated and runs in `examples-ci`. | `PROVEN` — `examples/epoll_pingpong.zig` runs a non-blocking epoll client thread that completes a full TLS 1.3 handshake and exchanges ping/pong application data with a server thread over loopback; it is gated in `examples-ci`. | `PROVEN` — the client side of `examples/tcp_loopback.zig` completes a full TLS 1.3 handshake, application-data exchange, and `close_notify` over `std.net.Stream`; it is gated in `examples-ci`. |
| Server | `PROVEN` — `examples/iouring_pingpong.zig` runs an io_uring server thread that accepts a loopback connection, completes a full TLS 1.3 handshake, and responds to ping messages with pong; it is Linux-gated and runs in `examples-ci`. | `PROVEN` — `examples/epoll_pingpong.zig` runs a non-blocking epoll server thread that accepts a single loopback connection, completes a full TLS 1.3 handshake, and responds to ping messages with pong; it is gated in `examples-ci`. | `PROVEN` — the server side of `examples/tcp_loopback.zig` completes a full TLS 1.3 handshake, application-data exchange, and `close_notify` over `std.net.Stream`; it is gated in `examples-ci`. |

**Current evidence (useful, but not enough):**

- Complete example inventory: `full_handshake.zig`, `handshake_keys.zig`,
  `https_client.zig`, `https_server.zig`, `in_memory_handshake.zig`,
  `iouring_client.zig`, `iouring_pingpong.zig`, `key_schedule.zig`,
  `record_protection.zig`, `tcp_loopback.zig`, and `epoll_pingpong.zig`.
- Every registered example runner built and exited successfully with
  `zig build example-{name} --summary all` on this host, including
  `example-iouring_client`.
- `examples/tcp_loopback.zig` is the strongest ergonomics proof: real TCP
  loopback, ztls client + server, full handshake, application data, and clean
  `close_notify` in one command; `just ci` now runs it through `examples-ci`.
- `examples/in_memory_handshake.zig` proves the pure Sans-I/O client/server path
  without sockets, including application data both directions, and `just ci` now
  runs it through `examples-ci`.
- `examples/full_handshake.zig`, `handshake_keys.zig`, `key_schedule.zig`, and
  `record_protection.zig` are educational protocol/crypto demos, not I/O-model
  cells.
- `just ci` runs deterministic TLS smoke examples through `examples-ci`:
  `example-tcp_loopback`, `example-in_memory_handshake`,
  `example-epoll_pingpong`, and `example-iouring_pingpong`. CI still does not
  execute manual peer-dependent demos such as `https_client`, `https_server`, or
  `iouring_client`; those demos now exit non-zero when the peer or io_uring
  support is unavailable, so they cannot be mistaken for proof if wired into a
  gate later.

**Status:** `PARTIAL`

**Gaps:**

- **Ergonomics are possible, not yet pleasant.** Real users must hand-roll the
  drive loop around `RecordBuffer`, remember to call `completeWrite()` after
  every emitted record, juggle distinct `OutBuffer` / `FlightBuffer` types, and
  interpret state transitions through event switches. Server credentials are now
  configured up front and `sendServerFlight*` owns the authenticated-flight
  one-shot/pending-write latch, so examples no longer carry a local
  `flight_sent` flag. Client setup is now `Config`-based: `host_name`,
  `now_sec`, `random`, `bundle`, `insecure_no_chain_anchor`, ALPN, and
  reassembly storage are declared in one `Config` literal, and `start(out)` no
  longer takes `random` or `server_name`. A broader transport-agnostic driver
  remains open.
  *(#42)*

---

## Pillar 3 — Performance

**Target:** reproducible benchmarks across a hardware matrix showing ztls vs
OpenSSL libssl vs rustls, with a documented methodology that *proves the
comparisons measure equivalent work*. This is the project's justification.

**Current evidence (real, but not yet decisive):**

- `docs/research/PERFORMANCE.md` lays out the intended layers and row-by-row
  equivalence methodology: record protection, parser/framing throughput,
  deterministic client handshake replay, full in-memory ztls connection rows,
  OpenSSL EVP raw-AEAD rows, OpenSSL/libssl memory-BIO rows, and rustls
  in-memory client/server rows. It defines which rows are comparable across
  ztls/libssl/rustls and which are intentionally ztls-only or raw-crypto rows.
- `justfile` has useful local recipes: `bench` for ztls rows,
  `bench-capture` / `bench-capture-default` for full-comparison captures,
  `bench-analyze` for `benchstat` comparison of captures,
  `bench-remote-capture` for EC2 provision/deploy/run/pullback/analyze, and
  profiling helpers `bench-disasm`, `bench-disasm-libcrypto`, and `bench-perf`.
  `just ci` no longer runs benchmark measurements; benchmarks are not
  correctness evidence on uncontrolled CI runners.
- `just bench-capture-default` writes a timestamped run directory under
  `zig-out/perf/` with metadata plus ztls, EVP, libssl memory-BIO, and rustls
  captures; `just bench-analyze <capture>` compares those captures with
  `benchstat`. Capture metadata records the ztls-linked `libcrypto` and the
  OpenSSL EVP/libssl baseline library paths so backend-specific ztls captures
  cannot silently poison the baseline rows. The rustls harness emits outer
  samples matching `--count`, and the analyzer splits comparable TLS,
  crypto-floor, and ztls-only diagnostic rows while excluding rustls groups with
  too few samples.
- `infra/bench/` is an OpenTofu/NixOS EC2 host recipe with a pinned-ish shape:
  region `us-west-2`, default `c7i.large`, generated ED25519 SSH key,
  public VPC/subnet/security group, Nix flakes enabled, ASLR disabled, and some
  noisy services masked.
- The AWS README documents the one-command remote path: `just
  bench-remote-capture` initializes OpenTofu, provisions/replaces each requested
  instance type, rsyncs the repo including `.git`, runs the capture inside the
  OpenSSL devshell, pulls the timestamped run directory back, writes
  `benchstat.txt`, and destroys EC2 resources by default unless `--keep-instance`
  is passed. The committed default matrix is currently one `c7i.large`; wider
  matrix runs are selected with `--instance-types`.
- `docs/research/perf/20260613-182405-ec2-c7i-large/` is the first committed
  EC2 result set, with raw ztls/EVP/libssl/rustls outputs, `metadata.txt`, and
  `benchstat.txt`. It was captured on a clean `c7i.large` host at git revision
  `c7097426cfad938c609b626c56790ec9e1115952` with `--count=5 --benchtime=500ms`.
- The local benchmark docs require metadata: target, CPU model, Zig version,
  optimization mode, and git revision. AGENTS.md separately requires committed
  benchmark numbers to include machine + flags + date.

**Status:** `PARTIAL`

**Gaps:**

- **Full benchmark workflow has a one-command runner but lacks fresh remote
  proof.** `just bench-remote-capture` owns provisioning, deploy, SSH execution,
  pullback, analysis, dirty-tree rejection, and default cleanup. It still needs a
  fresh committed remote capture proving the runner itself on the target host.
  *(#11)*
- **Hardware matrix is selectable, not yet proven.** `infra/bench/` defaults to
  `c7i.large` and the runner accepts `--instance-types` for broader matrices,
  but there is no committed multi-instance result set, CPU pinning policy,
  repetitions, or acceptance thresholds. *(#11)*
- **Published results are only a first single-host data point.** The repo now
  has one committed EC2 `c7i.large` result set with full provenance, but Pillar 3
  still needs the #11 hardware matrix, one-command remote workflow, repetitions
  policy, acceptance thresholds, and follow-up analysis before performance claims
  become marketing-grade.

---

## Pillar 4 — Providers

**Target:** aws-lc, BoringSSL, and bring-your-own libcrypto behind a clean seam,
each passing the same correctness and interop gates.

**Current evidence (real, but thin):**

- OpenSSL/libcrypto is the default backend and AWS-LC is selectable through
  `nix develop .#aws-lc` / `ZTLS_CRYPTO_BACKEND=aws-lc` or the explicit
  `-Dcrypto-backend=aws-lc` build option. The flake exposes `.#base`,
  `.#openssl`, and `.#aws-lc` devshells; each backend shell makes its selected
  `libcrypto.pc` ambient while preserving the OpenSSL CLI for interop tools.
  The AWS-LC lane rejects non-AWS-LC headers at compile time and verifies the
  AWS-LC include/library paths in Zig's verbose build output.
  OpenSSL-compatible EVP calls still compile directly through
  `src/crypto/c_openssl.zig` from `src/aead.zig`, `src/signature.zig`,
  `src/certificate.zig`, and `src/crypto/openssl_key.zig`.
- `src/crypto/backend.zig` exposes a `Backend` enum and an `active` selector
  resolved from the build option. `src/x25519.zig` now dispatches X25519
  primitives through `src/crypto/backend.zig` rather than calling EVP directly;
  the AWS-LC backend module is a thin compatibility layer over
  `backend_openssl.zig` while the build links AWS-LC libcrypto.
- `src/aead.zig` is the strongest seam: `RecordLayer` owns TLS nonce/AAD/sequence
  work and calls `Aead.encrypt` / `Aead.decrypt`; the module reuses
  `EVP_CIPHER_CTX` values rather than allocating them per record.
- `src/x25519.zig` (via the dispatch facade) exposes only a hard-coded X25519
  keypair/secret shape to the handshake.
- `src/signature.zig` has a useful caller-facing `Signer` vtable for server
  signing, but the concrete `PrivateKey` helper is OpenSSL-specific.
- `src/certificate.zig` performs CertificateVerify verification with OpenSSL EVP
  and delegates public-key construction to `src/crypto/openssl_key.zig`;
  certificate parsing/path policy is still ztls/std-derived code.
- `just check-backend-aws-lc` builds and tests with AWS-LC libcrypto linked;
  the recipe pins `PKG_CONFIG_PATH` to the AWS-LC derivation and checks the
  resolved include and library paths in the build log. `zig build test` inside
  `.#openssl` and `.#aws-lc` follows the shell-selected backend by default,
  while explicit `-Dcrypto-backend=...` still wins.
- HKDF/HMAC/SHA transcript hashing remain on `std.crypto`, matching the roadmap
  policy unless a concrete provider/FIPS requirement appears.

**Status:** `PARTIAL`

**Gaps:**

- **The provider abstraction is partly real but not exercised end-to-end.**
  `src/crypto/backend.zig` exists, `-Dcrypto-backend=aws-lc` is a recognized
  value, and `src/x25519.zig` dispatches through the facade. AEAD, signatures,
  and certificate still compile OpenSSL calls directly through
  `src/crypto/c_openssl.zig` and `src/crypto/openssl_key.zig`, so a real aws-lc
  backend would not provide its own implementation for those primitives even
  with link selection. *(#22)*
- **aws-lc has a real test lane but not a full backend matrix.** The
  `-Dcrypto-backend=aws-lc` build links AWS-LC libcrypto and runs the unit suite
  through OpenSSL-compatible EVP wrappers. Dedicated AEAD/signature/key
  dispatch, Wycheproof, interop, conformance, benchmark evidence, and capability
  gating remain open. *(#22)*
- **OpenSSL-only API choices still need backend dispatch.** The OpenSSL EC/RSA
  key-construction fast paths are isolated in `src/crypto/openssl_key.zig` rather
  than smeared through certificate/signature code, but there is still no selected
  backend interface that lets aws-lc provide its own measured implementation.
  A scratch measurement on OpenSSL 3.6.2 showed the current construction path is
  faster than naive `EVP_PKEY_fromdata`/decoder replacements, so portability must
  come through backend-specific fast paths, not an unmeasured lowest-common API.
  *(#22)*
- **Capability gating does not exist.** Cipher suites are enumerated directly
  from `CipherSuite`; `client_hello.zig` always advertises only X25519 and the
  server accepts X25519/P-256 without going through a backend capability
  table. A backend cannot currently narrow suites/groups/signature schemes for
  missing algorithms, FIPS posture, or provider-version differences. *(#22)*
- **Named-group/key-exchange shape is only partly generalized.** Server-side
  X25519 and P-256 ECDHE are provider-backed and TLS-Anvil-clean, but the ztls
  client remains X25519-only and P-384/PQ/hybrid groups still need real backend
  math, variable-length key-share/shared-secret plumbing, and provider capability
  tests before aws-lc differences can be claimed honestly. *(#22)*
- **The facade contract is not enforced by tests.** Existing tests prove OpenSSL
  behavior, but there is no backend matrix that runs the same primitive vectors,
  interop harnesses, and conformance shims for every enabled provider. *(#22)*

---

## Pillar 5 — Marketing flair

**Target:** the "why ztls over libssl" story, told clearly and backed by Pillar 3
numbers.

**Status:** `NONE`

**Gaps:** positioning narrative; a README that leads with the perf story; a
benchmarks-as-marketing page. Blocked on Pillar 3 producing trustworthy numbers
— do not market numbers you cannot reproduce.

---

## Pillar 6 — User docs

**Target:** external adoption from getting-started → API reference → integration
guides, without reading source.

**Current evidence:** `README.md` gives a root on-ramp and fresh-project module
wiring pointer. `docs/USAGE.md` documents the caller-owned-buffer model,
`RecordBuffer`, the `pending_write` / `completeWrite()` interlock, server
credential flow (`setCredentials` plus `sendServerFlightBuffered`), ALPN error
behavior, supported-surface boundaries, fresh-project dependency wiring, an API
reference for the exported handshake/buffer/signing/key-exchange types, runtime
integration notes for blocking streams, in-memory transport, epoll, and io_uring,
and the CI-gated adoption examples (`in_memory_handshake`, `tcp_loopback`,
`epoll_pingpong`, and `iouring_pingpong`).

**Status:** `PROVEN`

**Gaps:** none for the supported adoption path. Documentation for future
features belongs with the owning feature issues before those features enter the
supported surface.

---

## Immediate cleanup actions (entropy brakes)

These are not feature work; they stop the bleeding and make the rest legible.

1. **DONE — reconcile the five duplicate todo pairs.** Completed via the
   GitHub-issue migration; HelloRetryRequest, PSK/resumption, 0-RTT policy,
   client cert auth, and extension negotiation are now tracked by #1–#5.
2. **DONE — decide the canonical-ID policy and repoint citations.** Committed
   files now cite the canonical GitHub issues (#1–#5), not duplicate pi todos.
3. **DONE — Consolidate `docs/research/`.** The reconciliation kill-list that
   lived in #20 (closed 2026-06-09) was applied: status assertions moved here,
   and `docs/research/*` now keeps mechanism, rationale, acceptance criteria,
   and runbook mechanics. Reopen only if this spine and the research files
   visibly drift again.
4. **DONE — Define workspace ownership for build.zig / just recipes.**
   `src/build/` modules and root `just/` sub-files exist, while domain
   subprojects such as `conformance/` own their local workflows and root
   delegates to them. Benchmark recipes separate ztls development runs from full
   comparison captures, OpenSSL interop runs as normal Zig tests instead of
   standalone build-step binaries, and `tests/fixtures/` is the only real
   fixture source tree.
5. **Unify the conformance façade.** Track the `just conformance/<recipe>` shape
   and normalized result format in #9.
