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
| 2. Ergonomics | `PROVEN` | CI-gated deterministic examples cover client and server roles across io_uring, epoll, and `std.net.Stream`; Config setup, server credentials, and `Outbox` cover the supported core ergonomics boundary. |
| 3. Performance | `PARTIAL` | Rich bench harness exists; equivalence methodology and reproducible hardware-matrix results are missing. |
| 4. Providers | `PARTIAL` | OpenSSL primitives are live and AWS-LC selection is explicit; X25519 has an AWS-LC-specific path, while broader provider matrix evidence remains incomplete. |
| 5. Marketing | `NONE` | Not started. |
| 6. User docs | `PROVEN` | Root on-ramp plus `docs/USAGE.md` cover fresh-project setup, supported surface, drive loops, API reference, and CI-gated integration examples. |

---

## Pillar 1 — Correctness

**Target:** every RFC 8446 MUST is mapped to evidence or an explicit
out-of-scope decision; the things that must *fail* are enumerated and tested as
rigorously as the things that must succeed.

**Supported surface today** (per `CORRECTNESS.md`): TLS 1.3 full handshake over
X25519 and P-256 ECDHE, three mandatory cipher suites, certificate-authenticated
server flight with client verification gates, application data, alerts,
`close_notify`,
post-handshake KeyUpdate (both directions, flood-bounded, record-boundary
enforced). NewSessionTicket is parsed for structural validity and discarded —
consumption-for-rejection, not resumption.

**Current evidence (real, and good):**

- RFC-cited unit tests; every test names its spec section (AGENTS.md mandate).
- RFC 8448 known-answer vectors for the key schedule and transcript.
- OpenSSL interop in both directions, covered by `zig build test`.
- tlsfuzzer conformance, CI-gated (`just conformance/tlsfuzzer`).
- The TLS-Anvil/tlsfuzzer Zig shims build under both Zig 0.15.2 and real Zig
  0.16 (`cd conformance && zig build --summary all`; `cd conformance &&
  zig_0_16 build --summary all` locally on 2026-07-05), so the external
  conformance harness is no longer tied to the removed `std.net` APIs. *(#58)*
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
  `docs/research/TLS_ANVIL_NOT_ATTEMPTED.md` now accounts for the server and
  client `not_attempted` buckets together: role-mismatched TLS 1.3 rows are
  exercised by the opposite strict capture, including the seven TLS 1.3
  `EncryptedExtensions`/`CertificateVerify`/`Certificate` length-field rows that
  pass in the strict client capture; TLS 1.2/DTLS rows remain explicit
  out-of-scope rows. The attempted
  server-side TLS-Anvil surface is clean
  (`105/105` attempted passed), including `KeyUpdate: passed=4` and
  `ComplianceRequirements: passed=2`.
  The real server suite is wired in `.github/workflows/tls-anvil-server.yml` for
  weekly and manually-triggered runs. A client-mode TLS-Anvil runner and
  `.github/workflows/tls-anvil-client.yml` are wired with the same provenance
  shape. The latest strict-normalized client parent report on `b6aee2c`
  (`ci-28722850517`) is strict-complete (`Running: false`, `FinishedTests: 437`,
  `TotalTests: 437`) with normalized counts of `passed: 91`, `failed: 6`,
  `expected_skipped: 135`, `unexpected_skipped: 0`, and `not_attempted: 205`;
  the workflow conclusion is `failure` because the strict-normalize step
  intentionally exits nonzero while unexpected failures remain. `ComplianceRequirements`
  reports `passed=2`, clearing the #6 `supportsSecp256r1` client row;
  `KeyShare` reports `passed=5` with zero failures; and the previous
  `RecordProtocol.checkMinimumRecordProtocolVersions` AES-256/TCP-fragmentation
  failure no longer appears. `Extensions.sendAdditionalExtension`
  now passes after the #48 unsolicited extension slice. A #4 precursor now
  accepts handshake-time `CertificateRequest` and emits an empty client
  `Certificate` before `Finished` when no client credentials are configured;
  `ClientAuthentication.clientSendsCertificateAndFinMessage` is now
  `STRICTLY_SUCCEEDED`, and the stale `*ClientAuth*` expected-skip entry has
  been removed. Full client-certificate authentication remains deferred. All six
  remaining unexpected failures align with TLS-Anvil `DSA_WITH_SHA256`
  certificate parameter combinations that ztls correctly rejects during server
  Certificate processing; closed #52 classifies those DSA-root TLS-Anvil
  parameter combinations without accepting DSA or hiding non-DSA coverage. The
  `anvil_report.py` normalizer now classifies the six #52 rows as
  `expected_failed` (a visible bucket distinct from `expected_skipped`) when
  per-case `failure_combinations` evidence proves every failed case is a
  DSA-root RSA-leaf (`ROOT=DSA`, `LEAF keyType=RSA`, `keySize` in
  `{1024, 2048, 4096}`) combination; non-DSA cases in the same rows stay
  visible and unrelated failures stay unexpected. The gate is narrow to the
  six exact test ids and requires structured per-case evidence, not broad
  skip-listing. The classifier is covered by synthetic tests, locally replayed
  by re-adapting the raw per-test `_testRun.json` files from the `ci-28722850517`
  artifact, and confirmed by strict client workflow `ci-28725543965` on
  `6ba72b3`: `passed: 91`, `failed: 6`, `expected_failed: 6`,
  `unexpected_skipped: 0`, `not_attempted: 205`, clean tree, and workflow
  conclusion `success`. The `expected_failed` count is the #52 visibility
  mechanism, not a conformance pass. The #48 client-runner scope is now
  strict-clean under that visible #52 classification; remaining external
  conformance breadth is feature-specific (#1/#2/#3/#4/#6) plus the BoGo
  re-entry path in #50. A skip-list narrowing landed during #48
  surfaces the strict-complete f50fcd8
  client capture's `sendEndOfEarlyDataAsServer` STRICTLY_SUCCEEDED row rather
  than the broader `*EarlyData*` skip pattern masking it as `unexpected_pass`;
  server EarlyData disabled rows remain expected-skipped under #3, and this is
  evidence visibility from #48 rather than accepted client execution. BoGo is
  explicitly deferred in
  `docs/research/BOGO_DEFERRED.md` with re-entry criteria tracked by #50.
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

- **External runner coverage is still partial.** Full TLS-Anvil execution is
  not in PR `just ci`, and BoGo is explicitly deferred per
  `docs/research/BOGO_DEFERRED.md`. The completed strict server/client captures
  account for endpoint-mode `not_attempted` rows, including the `tests.both.*`
  length-field rows that are role-specific despite their package name. TLS-Anvil
  normalization and wrapper-helper tests are gated, the real TLS-Anvil server
  suite runs in a separate scheduled/manual workflow, and the TLS-Anvil client
  runner/workflow has strict-clean evidence under the visible #52 `expected_failed`
  classification. Completed TLS-Anvil server and client evidence now have no
  unexpected attempted failures; remaining named-group scope beyond the proven
  server-side P-256 path
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
  and fragmented KeyUpdate handling *(#41)*.
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

**Current evidence:**

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
  `example-epoll_pingpong`, and `example-iouring_pingpong`. The same four
  deterministic examples also run under real Zig 0.16 locally, covering the
  `std.Io.net` transport boundary for TCP loopback plus the raw-fd epoll and
  io_uring examples. *(#58)*
- CI still does not execute manual peer-dependent demos such as `https_client`,
  `https_server`, or `iouring_client`; those demos now compile on both Zig
  0.15.2 and Zig 0.16 and exit non-zero when the peer or io_uring support is
  unavailable, so they cannot be mistaken for proof if wired into a gate later.

**Status:** `PROVEN`

**Gaps:** none for the supported adoption path.

The caller-owned drive loop around `RecordBuffer`, the explicit `OutBuffer` /
`FlightBuffer` storage, and event-switch dispatch are accepted Sans-I/O trade-offs,
not unfinished core work. `docs/research/DESIGN.md` keeps higher-level wrappers
separate from the engine, and `docs/research/API_ROADMAP.md` puts wrapper proof in
examples or wrapper packages. The #47 design decision rejects a reusable connection
driver in `src/`: blocking, epoll, io_uring, and in-memory flows differ enough that
a shared driver would either own transport I/O or add callback/framework glue. The
reusable core boundary is the handshake types plus `RecordBuffer` and `ztls.Outbox`;
CI-gated examples remain canonical for transport drive-loop glue.

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
  It now includes per-row timed-work inventories for the four comparable TLS
  row groups (`Handshake`, `AppClientToServer`, `AppServerToClient`,
  `AppPingPong`) documenting the exact work each harness performs inside the
  timed loop, including the auth-policy asymmetry: ztls performs
  CertificateVerify signature verification, hostname verification, and leaf
  policy checks while rustls's `NoVerifier` does not, and libssl's
  `SSL_VERIFY_NONE` internal CertificateVerify behavior is opaque. The
  `Handshake` row is labeled "usable with caveats" rather than equivalent.
- `docs/research/perf/EXPLANATION_TEMPLATE.md` provides a per-row writeup
  template with timed-work inventory, raw timing table, normalized perf counter
  summary, hot symbols/disassembly notes, copy/allocation behavior, conclusion, and
  caveats. This is methodology tooling, not committed perf evidence.
- `justfile` has useful local recipes: `bench` for ztls rows,
  `bench-capture` / `bench-capture-default` for full-comparison captures,
  `bench-analyze` for `benchstat` comparison of captures,
  `bench-remote-capture` for EC2 provision/deploy/run/pullback/analyze,
  profiling helpers `bench-disasm`, `bench-disasm-libcrypto`, and `bench-perf`,
  and row-oriented perf/disassembly tooling `bench-perf-row` and
  `bench-disasm-row` that capture per-implementation, per-row artifacts with
  stable output paths and metadata under `zig-out/perf/<timestamp>/`.
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
  too few samples. The analyzer now warns when a comparable TLS row group has a
  missing implementation or mismatched sample counts across implementations.
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
- **Benchmark equivalence methodology and row-oriented perf/disassembly
  tooling are methodology progress, not committed perf evidence.** The per-row
  timed-work inventories, the benchmark explanation template, and the
  `bench-perf-row` / `bench-disasm-row` scripts define how wall-time deltas
  will be explained with instruction/branch/cache evidence, but no committed
  perf or disassembly artifacts exist yet. Producing durable Linux x86_64
  perf/disassembly evidence requires the EC2 workflow (#11) or equivalent
  bare-metal access. The `Handshake` row auth-policy asymmetry (ztls performs
  CertificateVerify signature verification, hostname verification, and leaf
  policy checks; rustls does not; libssl is partly opaque) remains an open
  equivalence gap that harness alignment or explicit non-equivalence
  documentation must resolve before the `Handshake` row can be claimed
  equivalent. *(#31)*

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
  AEAD, CertificateVerify signing/verification, certificate public-key
  construction for CertificateVerify, and X25519/P-256 ECDHE dispatch through
  `src/crypto/backend.zig`.
- `src/crypto/backend.zig` exposes a `Backend` enum, an `active` selector
  resolved from the build option, and compile-time capability declarations for
  cipher suites, client/server key-share groups, CertificateVerify schemes, and
  certificate-signature advertisement. `src/x25519.zig` dispatches X25519
  primitives through `src/crypto/backend.zig`; OpenSSL uses EVP_PKEY, while the
  AWS-LC backend uses the flat `openssl/curve25519.h` X25519 API with value
  handles and no EVP_PKEY allocation for X25519.
- `src/aead.zig` is the strongest seam: `RecordLayer` owns TLS nonce/AAD/sequence
  work and calls `Aead.encrypt` / `Aead.decrypt`; the module reuses
  `EVP_CIPHER_CTX` values rather than allocating them per record.
- `src/x25519.zig` (via the dispatch facade) exposes only a hard-coded X25519
  keypair/secret shape to the handshake.
- `src/signature.zig` keeps the caller-facing `Signer` vtable for server
  signing, and its concrete `PrivateKey` helper now routes PEM/DER/scalar key
  loading and signing through `src/crypto/backend.zig`.
- `src/certificate.zig` routes CertificateVerify public-key construction and
  signature verification through `src/crypto/backend.zig`; certificate parsing,
  chain signature verification, and path policy remain ztls/std-derived code.
- `just check-backend-aws-lc` builds, tests, produces the benchmark binary, and
  builds the conformance shims with AWS-LC libcrypto linked; the recipe pins
  `PKG_CONFIG_PATH` to the AWS-LC derivation and checks the resolved include and
  library paths in the combined build log. `zig build test` inside `.#openssl`
  and `.#aws-lc` follows the shell-selected backend by default, while explicit
  `-Dcrypto-backend=...` still wins. `conformance/build.zig` accepts the same
  `-Dcrypto-backend=aws-lc` option, so `anvil_client` and `tlsfuzzer_server` can
  now be built as AWS-LC-linked harness binaries. This is build evidence only,
  not a strict TLS-Anvil/tlsfuzzer provider capture.
- HKDF/HMAC/SHA transcript hashing remain on `std.crypto`, matching the roadmap
  policy unless a concrete provider/FIPS requirement appears.
- `src/crypto/backend_primitive_tests.zig` exercises the backend facade
  directly for X25519 (RFC 7748 known vectors plus low-order/all-zero public-key
  rejection), P-256 ECDH (mutual key agreement with fixed scalars, non-04 SEC1
  prefix rejection, and off-curve point rejection), AEAD (round-trip,
  tag-corruption, and ciphertext-corruption rejection for every
  `backend.capabilities.cipher_suites` entry, plus an RFC 8439 ChaCha20-Poly1305
  known-answer vector), and signatures (RSA-PSS and ECDSA P-256 sign/verify
  round-trip, tampered-signature rejection, `BufferTooShort`, and key/scheme
  mismatch). These tests run in the normal `zig build test` lane and under
  `just check-backend-aws-lc`, so the same primitive vectors pass through both
  the OpenSSL- and AWS-LC-linked build lanes. X25519 and AEAD are
  backend-divergent in the AWS-LC lane; P-256 ECDH and signature paths still
  delegate through OpenSSL-compatible wrappers while linking AWS-LC libcrypto. This is a
  per-primitive smoke contract, not a Wycheproof matrix or divergent capability
  proof.

**Status:** `PARTIAL`

**Gaps:**

- **The provider abstraction is partly real but not exercised end-to-end.**
  `src/crypto/backend.zig` exists, `-Dcrypto-backend=aws-lc` is a recognized
  value, and X25519, P-256, AEAD, and CertificateVerify signing/verification
  dispatch through the facade. Certificate-chain signature verification and path
  validation are still ztls/std-derived rather than backend-backed, and the
  facade still lacks divergent-backend matrix evidence. *(#22)*
- **aws-lc has a real test lane but not a full backend matrix.** The
  `-Dcrypto-backend=aws-lc` build links AWS-LC libcrypto and runs the unit suite;
  X25519 uses AWS-LC's flat `curve25519.h` API, and AEAD uses AWS-LC's
  BoringSSL-style `EVP_AEAD` one-shot API. P-256 ECDH and signature paths
  intentionally remain proven OpenSSL-compatible wrappers until measured
  backend-specific implementations exist. Wycheproof, interop,
  conformance run captures, benchmark measurements/evidence, and provider/FIPS/
  version capability proof remain open. The conformance shims now build under the
  AWS-LC backend, and the TLS 1.3 tlsfuzzer smoke tests pass when those shims are
  built with `ZTLS_CRYPTO_BACKEND=aws-lc`, but no strict TLS-Anvil/tlsfuzzer
  AWS-LC report has been captured yet. *(#22)*
- **OpenSSL-compatible API choices still need measured backend-specific paths.**
  X25519 and AEAD now have AWS-LC-specific primitive paths; EC/RSA key
  construction and signatures still delegate to the OpenSSL-compatible
  implementation. A scratch measurement on OpenSSL 3.6.2 showed the current EC/RSA construction
  path is faster than naive `EVP_PKEY_fromdata`/decoder replacements, so
  portability must come through backend-specific fast paths, not an unmeasured
  lowest-common API. *(#22)*
- **Capability gating exists but is shallow.** ClientHello cipher-suite,
  supported-group, `signature_algorithms`, and `signature_algorithms_cert`
  advertisement now comes from the active backend capability declaration; server
  default suite selection and X25519/P-256 HRR/key-share selection consult the
  same facade. The current OpenSSL and AWS-LC capability sets are intentionally
  identical but backend-owned rather than aliases, the ztls client has local
  X25519/P-256 first-flight key-share plumbing, and no FIPS/provider-version
  divergent capability matrix exists yet.
  The strict-complete `b6aee2c` client TLS-Anvil capture (`ci-28722850517`)
  closes the remote P-256 evidence gap with `ComplianceRequirements: passed=2`
  and `KeyShare: passed=5`. *(#22)*
- **Named-group/key-exchange shape is only partly generalized.** X25519 and
  P-256 ECDHE are provider-backed on the server side, and the client can now
  advertise both groups and process either ServerHello key_share locally; P-384,
  PQ, and hybrid groups still need real backend math, variable-length key-share/
  shared-secret plumbing, and provider capability tests before aws-lc differences
  can be claimed honestly. *(#22)*
- **The facade contract is partly enforced by primitive tests, not a full
  matrix.** `src/crypto/backend_primitive_tests.zig` runs the same X25519,
  P-256 ECDH, AEAD, and signature primitive vectors through the backend facade
  under both the OpenSSL and AWS-LC lanes in `zig build test` and
  `just check-backend-aws-lc`. Wrapper-level Wycheproof boundary tests for
  X25519 and AEAD already run in both lanes via `zig build test`, but
  facade-direct Wycheproof coverage and a full provider matrix remain open. This
  is a narrow primitive smoke contract — it does not cover Wycheproof boundary
  vectors per provider through the facade, divergent capability matrices, or
  strict TLS-Anvil/tlsfuzzer captures per provider. The full backend matrix
  remains open. *(#22)*

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
`RecordBuffer`, `Outbox`, the `pending_write` / `completeWrite()` interlock,
server credential flow (`setCredentials` plus `sendServerFlightBuffered`), ALPN
error behavior, supported-surface boundaries, fresh-project dependency wiring,
an API reference for the exported handshake/buffer/signing/key-exchange types,
runtime
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
5. **DONE — Unify the conformance façade.** `just conformance/<recipe>` delegates
   to the conformance subproject, and TLS-Anvil/tlsfuzzer normalized result
   formats are CI-tested under `just conformance/ci`.
