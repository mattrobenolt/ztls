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
consumption-for-rejection, not resumption. PSK/resumption key-schedule helpers
are covered by RFC 8448 §3/§4 vectors, but ztls still does not store tickets,
encode PSK binders, or resume handshakes.

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
  the server can now emit handshake-time `CertificateRequest` for optional or
  required client auth, accept the empty-certificate optional path, and reject
  the required-empty path with `certificate_required` in local tests.
  `ClientAuthentication.clientSendsCertificateAndFinMessage` is now
  `STRICTLY_SUCCEEDED`, and the stale `*ClientAuth*` expected-skip entry has
  been removed. Client-auth emission, server-side verification, and OpenSSL
  interop both directions are now implemented: `ClientHandshake` exposes
  `setCredentials`/`setCertificateChain` (caller-owned chain + signer),
  captures the server-offered CertificateRequest signature schemes, and emits a
  real Certificate chain plus a CertificateVerify signed with the client private
  key over `client_context || transcript_hash` (through Certificate) before
  Finished; the scheme is checked against the server-offered set
  (`SignatureSchemeNotOffered` -> `illegal_parameter`). A client with no
  credentials still sends an empty Certificate, preserving the prior behavior.
  `ServerHandshake` verifies a non-empty client Certificate chain
  (`certificate.parseClientChain` with the server's `client_auth_bundle` or
  `insecure_no_client_chain_anchor` opt-in) and the client CertificateVerify
  against the leaf public key (`certificate.verifyClientSignatureWithSchemes`,
  which also checks the scheme against the server offer), accepting the
  handshake only when Certificate + CertificateVerify + Finished all verify;
  a forged CertificateVerify is rejected with `SignatureVerificationFailed`
  (`decrypt_error`). Application-traffic-secret derivation on the server now
  uses a transcript snapshot through the server Finished (RFC 8446 §7.1) so the
  client Certificate/CertificateVerify absorbed afterwards does not perturb the
  app-secret transcript. In-memory ztls client ↔ server required-auth
  integration tests cover the success path and the forged-CV rejection, and
  OpenSSL interop both directions is CI-gated in `src/interop.zig`: a ztls
  server requiring auth accepts an `openssl s_client -cert -key` peer, and a
  ztls client with credentials completes against `openssl s_server -Verify
  -CAfile`. Residual: client-auth leaf EKU/KU enforcement is a no-op
  (`LeafUsage.client_auth` skips it — honest partial); the offered-scheme
  rejection of a malicious client CV has no dedicated test (defensive guard).
  *(#4, done — interop proven; EKU/KU and the malicious-scheme test remain)*
  All six
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
  unexpected attempted failures; P-384 is now locally implemented through
  OpenSSL/AWS-LC-backed key-share encode/parse and ECDHE primitive tests, but
  external named-group conformance beyond the proven server-side P-256 path
  stays tracked under broader provider-backed group work *(#6)*. HelloRetryRequest
  server retry now passes TLS-Anvil, and client-side HRR consumption for
  supported groups omitted from ClientHello1 `key_share` is implemented with
  RFC-cited unit tests covering the §4.4.1 transcript collapse, ClientHello2
  generation with selected-group-only key_share, rejection when HRR selects an
  already-offered key share, second-HRR rejection, unsupported-group rejection,
  and post-HRR ServerHello cipher-suite/group consistency checks; full
  client/server HRR state-machine support remains broader open work *(#1)*. Record-fragmentation
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
  It now includes per-row timed-work inventories for the comparable
  application-data row groups (`AppClientToServer`, `AppServerToClient`,
  `AppPingPong`) and the explicitly non-equivalent `Handshake` row. The
  handshake inventory documents the auth-policy asymmetry: ztls performs
  CertificateVerify signature verification, hostname verification, and leaf
  policy checks while rustls's `NoVerifier` does not, and libssl's
  `SSL_VERIFY_NONE` internal CertificateVerify behavior is opaque. `bench-analyze`
  emits `Handshake` in a separate non-equivalent section, not in the comparable
  TLS application-data table.
- `docs/research/perf/EXPLANATION_TEMPLATE.md` provides a per-row writeup
  template with timed-work inventory, raw timing table, normalized perf counter
  summary, hot symbols/disassembly notes, copy/allocation behavior, conclusion, and
  caveats. This is methodology tooling, not committed perf evidence.
- `justfile` has useful local recipes: `bench` for ztls rows,
  `bench-capture` / `bench-capture-default` for full-comparison captures,
  `bench-analyze` for `benchstat` comparison of captures,
  `bench-remote-capture` for EC2 provision/deploy/run/pullback/analyze,
  profiling helpers `bench-disasm`, `bench-disasm-libcrypto`, and `bench-perf`,
  row-oriented perf/disassembly tooling `bench-perf-row` and `bench-disasm-row`
  that capture per-implementation, per-row artifacts with stable output paths
  and metadata under `zig-out/perf/<timestamp>/`, and `bench-remote-perf-rows`
  for one-command EC2 row perf/disassembly capture.
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
  public VPC/subnet/security group, Nix flakes enabled, ASLR disabled, a larger
  Nix download buffer for remote cache fetches, and some noisy services masked.
- The AWS README documents the one-command remote path: `just
  bench-remote-capture` initializes OpenTofu, provisions/replaces each requested
  instance type, rsyncs the repo including `.git`, runs the capture inside the
  OpenSSL devshell, pulls the timestamped run directory back, writes
  `benchstat.txt`, and destroys EC2 resources by default unless `--keep-instance`
  is passed. The runner now emits timestamped phase logs and 30-second
  heartbeats during long provisioning/build/benchmark steps. The committed
  default matrix is currently one `c7i.large`; wider matrix runs are selected
  with `--instance-types`.
- `docs/research/perf/20260613-182405-ec2-c7i-large/` is the historical first
  committed EC2 result set. Fresh #11 remote-runner captures now live under
  `docs/research/perf/20260705-183821-ec2-c7i-large/` and
  `docs/research/perf/20260705-194022-ec2-c7i-2xlarge/`, with raw
  ztls/EVP/libssl/rustls outputs, `metadata.txt`, and `benchstat.txt`. They were
  captured on clean `c7i.large` and `c7i.2xlarge` hosts in `us-west-2` with
  `--count 5 --benchtime 500ms`; the `c7i.large` capture records git revision
  `5ec2eaae729d7e9aa8746650bf8288327f81fdf1`, and the `c7i.2xlarge` capture
  records git revision `89c869eb2a22c6c0f2ffe077c8f13204a92f4074`.
- The local benchmark docs require metadata: target, CPU model, Zig version,
  optimization mode, and git revision. AGENTS.md separately requires committed
  benchmark numbers to include machine + flags + date.

**Status:** `PARTIAL`

**Gaps:**

- **Remote benchmark workflow is proven but still early evidence.** `just
  bench-remote-capture` now owns provisioning, deploy, SSH execution, pullback,
  analysis, dirty-tree rejection, verbose progress reporting, and default
  cleanup, with committed clean EC2 captures on `c7i.large` and `c7i.2xlarge`.
  Pillar 3 still needs a documented repetition policy and acceptance thresholds
  before performance claims become marketing-grade.
- **Hardware matrix has two committed x86_64 points, not a final matrix policy.**
  `infra/bench/` defaults to `c7i.large` and accepts `--instance-types` for
  broader serial matrix captures. The committed same-day `c7i.large` and
  `c7i.2xlarge` captures prove the path across two EC2 shapes, but repetitions,
  instance-family breadth, and threshold policy remain open for marketing-grade
  performance evidence.
- **Selected app-data rows and the non-equivalent handshake row now have
  committed perf/disassembly evidence.**
  `docs/research/perf/20260705-215953-ec2-c7i-2xlarge-row-perf/` records pinned
  Linux/x86_64 `perf stat`, `perf report`, `perf annotate`, symbols, and row
  explanations for `AppPingPong/TLS_AES_128_GCM_SHA256/1350` and
  `AppClientToServer/TLS_CHACHA20_POLY1305_SHA256/16` across ztls, OpenSSL
  libssl, and rustls. The AES-GCM ping-pong row now has counter evidence that
  ztls executes fewer cycles/instructions/branches than libssl and rustls; the
  small ChaCha row now has counter evidence that rustls's ring path is cheaper
  than ztls's OpenSSL EVP path. The `Handshake` row has been explicitly demoted
  from comparable output because the auth-policy work differs across harnesses;
  `docs/research/perf/20260706-000535-ec2-c7i-2xlarge-handshake-row-perf/`
  records pinned row-perf evidence showing ztls and libssl both perform
  CertificateVerify verification while rustls `NoVerifier` does not. No
  cross-implementation handshake performance claim is allowed from the current
  row.
- **kTLS offload support is API-complete with a CI-gated example.**
  `RecordLayer.ktlsInfo()` now exports copied TLS 1.3 traffic key material,
  Linux kTLS cipher-type values, split AES-GCM salt/IV, ChaCha20-Poly1305 IV,
  and current big-endian record sequence with RFC-cited tests proving nonce
  reconstruction and deinit-safe copy semantics. `ClientHandshake` and
  `ServerHandshake` expose `txKtlsInfo()` / `rxKtlsInfo()` accessors, and
  post-KeyUpdate tests prove exported epochs carry new keys with sequence
  number reset to zero. KeyUpdate event surfacing is implemented: both
  `ClientHandshake.Event` and `ServerHandshake.Event` carry a `key_update`
  variant that surfaces RX and TX epoch changes and an optional response
  record, so kTLS callers can reinstall `TLS_RX`/`TLS_TX` at the right
  moment. The `examples/ktls_server.zig` Linux loopback example demonstrates
  the full userspace-handshake → kernel-data-plane loop including a
  pre-install KeyUpdate: the server completes the TLS 1.3 handshake in
  userspace, processes a client-initiated KeyUpdate (handling the
  `key_update` event), installs kTLS TX/RX via `setsockopt` with the
  post-KeyUpdate key material, and exchanges a kernel-encrypted/decrypted
  ping/pong against a ztls userspace client. The example is CI-gated
  (`examples-ci`) and proven on ubuntu-latest (run 28808144027, green): the
  kernel decrypted the client's `ping` and encrypted the server's `pong`
  using ztls-extracted keys, and the ztls userspace client decrypted the
  kernel-encrypted `pong`; on a kernel without `tls.ko` it gracefully skips
  with exit 0. The `ztls.ktls` namespace exposes the Linux UAPI constants
  and `packAesGcm128`/`packAesGcm256`/`packChaCha20Poly1305` helpers that
  fold the RFC 8446 §5.3 salt/IV split into the library. Residual scope:
  the example does the KeyUpdate in userspace before installing kTLS, not a
  live mid-stream re-key of an already-installed kTLS session (once kTLS RX
  is installed the kernel consumes encrypted records, so ztls cannot see a
  KeyUpdate via `handleRecord`); that would need a manual-ratchet API and
  kernel `EKEYEXPIRED` integration, tracked separately if wanted. *(#29)*

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
- `just check-backend-aws-lc` builds, tests, produces the benchmark binary,
  executes a one-row benchmark smoke, runs the in-memory example, builds the
  conformance shims, and runs the TLS 1.3 tlsfuzzer smoke with AWS-LC libcrypto
  linked; the recipe pins `PKG_CONFIG_PATH` to the AWS-LC derivation and checks
  the resolved include and library paths in the combined build log. `zig build
  test` inside `.#openssl` and `.#aws-lc` follows the shell-selected backend by
  default, while explicit `-Dcrypto-backend=...` still wins. `conformance/build.zig`
  accepts the same `-Dcrypto-backend=aws-lc` option, so `anvil_client` and
  `tlsfuzzer_server` can be built as AWS-LC-linked harness binaries.
- HKDF/HMAC/SHA transcript hashing remain on `std.crypto`, matching the roadmap
  policy unless a concrete provider/FIPS requirement appears.
- `src/crypto/backend_primitive_tests.zig` exercises the backend facade
  directly for X25519 (RFC 7748 known vectors plus low-order/all-zero public-key
  rejection), P-256 ECDH (mutual key agreement with fixed scalars, non-04 SEC1
  prefix rejection, and off-curve point rejection), AEAD (round-trip,
  tag-corruption, and ciphertext-corruption rejection for every
  `backend.capabilities.cipher_suites` entry, plus an RFC 8439 ChaCha20-Poly1305
  known-answer vector), and signatures (RSA-PSS SHA-256/SHA-384 plus ECDSA
  P-256/P-384 sign/verify round-trip, tampered-signature rejection,
  `BufferTooShort`, and key/scheme mismatch). These tests run in the normal
  `zig build test` lane and under `just check-backend-aws-lc`, so the same
  primitive vectors pass through both the OpenSSL- and AWS-LC-linked build lanes.
  X25519 and AEAD are backend-divergent in the AWS-LC lane; P-256/P-384 ECDH and
  signature paths still delegate through OpenSSL-compatible wrappers while
  linking AWS-LC libcrypto. This is a per-primitive smoke contract, not a
  Wycheproof matrix or divergent capability proof.

**Status:** `PARTIAL`

**Gaps:**

- **The provider abstraction is partly real but not exercised end-to-end.**
  `src/crypto/backend.zig` exists, `-Dcrypto-backend=aws-lc` is a recognized
  value, and X25519, P-256, AEAD, and CertificateVerify signing/verification
  dispatch through the facade. Certificate-chain signature verification and path
  validation are still ztls/std-derived rather than backend-backed, and the
  facade still lacks divergent-backend matrix evidence. *(#60)*
- **aws-lc has a real test lane but not a full backend matrix.** The
  `-Dcrypto-backend=aws-lc` build links AWS-LC libcrypto and runs the unit suite;
  X25519 uses AWS-LC's flat `curve25519.h` API, and AEAD uses AWS-LC's
  BoringSSL-style `EVP_AEAD` one-shot API. P-256 ECDH and signature paths
  intentionally remain proven OpenSSL-compatible wrappers until measured
  backend-specific implementations exist. CI-gated strict-complete TLS-Anvil
  AWS-LC captures on `ca53590` completed cleanly for both endpoints: server run
  `28746130104` had `437/437` finished, `passed=105`, `failed=0`,
  `expected_failed=0`, `expected_skipped=175`, `unexpected_skipped=0`,
  `not_attempted=157`; client run `28746130840` had `437/437` finished,
  `passed=91`, `failed=6`, `expected_failed=6`, `expected_skipped=135`,
  `unexpected_skipped=0`, `not_attempted=205`. The local AWS-LC provider-lane
  benchmark capture `docs/research/perf/20260705-160550-awslc-local/` records
  selected TLS handshake and 1350-byte ping-pong rows with ztls linked against
  AWS-LC and OpenSSL libssl baselines linked against OpenSSL; it is measurement
  evidence, not a performance conclusion or Linux x86_64 perf/disassembly proof.
  Wycheproof and provider/FIPS/version capability proof remain open.
  *(#60)*
- **OpenSSL-compatible API choices still need measured backend-specific paths.**
  X25519 and AEAD now have AWS-LC-specific primitive paths; EC/RSA key
  construction and signatures still delegate to the OpenSSL-compatible
  implementation. A scratch measurement on OpenSSL 3.6.2 showed the current EC/RSA construction
  path is faster than naive `EVP_PKEY_fromdata`/decoder replacements, so
  portability must come through backend-specific fast paths, not an unmeasured
  lowest-common API. *(#60)*
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
  and `KeyShare: passed=5`. *(#60)*
- **Named-group/key-exchange shape is only partly generalized.** X25519,
  P-256, and opt-in P-384 ECDHE are provider-backed on the server side, and the
  client can advertise/process those key shares locally. P-384 has local
  OpenSSL/AWS-LC primitive and unit coverage, but still lacks external
  TLS-Anvil/tlsfuzzer evidence; PQ and hybrid groups still need real backend
  math, variable-length key-share/shared-secret plumbing, and provider
  capability tests before aws-lc differences can be claimed honestly. *(#6, #60)*
- **The facade contract is partly enforced by primitive tests, not a full
  matrix.** `src/crypto/backend_primitive_tests.zig` runs the same X25519,
  P-256/P-384 ECDH, AEAD, and all currently advertised CertificateVerify
  signature primitive vectors through the backend facade under both the OpenSSL
  and AWS-LC lanes in `zig build test` and `just check-backend-aws-lc`. It now
  includes selected facade-direct Wycheproof vectors for X25519 and all
  advertised AEAD suites, while the
  wrapper-level Wycheproof tests still cover the public `x25519`/`aead` paths.
  This is a narrow primitive/vector contract — it is not a full Wycheproof
  harness, provider/FIPS divergence matrix, or certificate-chain ownership
  decision. The full backend matrix remains open. *(#60)*

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
