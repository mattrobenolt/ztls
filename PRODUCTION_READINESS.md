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
| 1. Correctness | `PROVEN` | RFC 8446 MUST matrix closed for the supported surface; interop + tlsfuzzer PR-gated; TLS-Anvil scheduled with clean captures (437/437, no unexpected failures); adversarial security review found and fixed 3 vulns. Full TLS-Anvil is scheduled-only (2-hour runtime can't be PR-gated); BoGo explicitly deferred. |
| 2. Ergonomics | `PROVEN` | CI-gated deterministic examples cover client and server roles across io_uring, epoll, and `std.net.Stream`; Config setup, server credentials, and `Outbox` cover the supported core ergonomics boundary. |
| 3. Performance | `PROVEN` | n=10 captures on x86_64 (c7i.2xlarge), aarch64 (c7g.2xlarge), and macOS (Apple M1 Max) with formal CIs (p=0.000): ztls beats libssl on every comparable app-data row on all three platforms and rustls on all AES-GCM rows; regression gate committed. |
| 4. Providers | `PROVEN` | OpenSSL (default), AWS-LC, and BoringSSL all compile, pass the full test suite, tlsfuzzer smoke, and have clean TLS-Anvil captures (437/437 each). CI-gated backend lanes (`just check-backend-aws-lc`, `just check-backend-boringssl`). Cert-chain stays ztls/std (ownership decision); FIPS comptime-validated; PQ/P-384 is #6. |
| 5. Marketing | `PROVEN` | README leads with the proven performance story (n=10, both architectures, honest ChaCha20 loss) and the adversarial security posture; the why-ztls narrative and headline benchmarks are on the front door, backed by PERFORMANCE.md. |
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
enforced). PSK/session resumption is implemented: the client
derives the resumption_master_secret over the live transcript (RFC 8448 §4
vector-proven), surfaces NewSessionTicket events, and produces a caller-storable
SessionTicket (identity + PSK + age/lifetime via ArrayBuffer); the client emits
a PSK ClientHello (pre_shared_key + psk_key_exchange_modes + binder over the
truncated transcript prefix); the server verifies the binder via a caller-owned
PskLookup and selects an identity; both sides use the PSK as the early secret
in the key schedule (psk_dhe_ke, PSK + ECDHE). An in-memory PSK resumption
handshake completes to connected with an application-data round trip, and
OpenSSL resumption interop is CI-gated: a ztls client captures an NST from
openssl s_server on connection 1 and resumes with it on connection 2. The
client state machine handles the PSK resumption flight (EE + Finished, no
server Certificate/CertificateVerify). 0-RTT early data is implemented: the
client can offer early_data + derive the client_early_traffic_secret and send
0-RTT data (sendEarlyData); the server derives the early traffic key from the
selected PSK + ClientHello transcript and decrypts 0-RTT records, enforcing
max_early_data_size. The server emits the early_data extension in
EncryptedExtensions when it accepts 0-RTT (RFC 8446 §4.2.10). The client sends
EndOfEarlyData under the client_early_traffic_secret after the server Finished
and before its own Finished when the server accepted 0-RTT, and does not send
it when the server declined (RFC 8446 §4.5). The server expects and decrypts
the client's EndOfEarlyData with early_rx before the client Finished, and
rejects its absence with unexpected_message. The server declines 0-RTT when
the selected PSK's max_early_data_size is null, omitting early_data from EE;
the client detects this, clears early_tx, and proceeds without EndOfEarlyData.
Reject-path tests cover max_early_data_size exceeded, no-PSK-selected early
data, server-declined 0-RTT, and client rejection of server-sent EndOfEarlyData.
0-RTT is disabled by default (offer_early_data=false) and the caller is
responsible for replay-safe policy — 0-RTT data is not forward-secret and can
be replayed by a network attacker; no anti-replay cache exists in ztls (the
Sans-I/O library cannot own a global replay cache). An in-memory 0-RTT test
proves the early traffic key derivation + EndOfEarlyData + record flow
end-to-end, and OpenSSL 0-RTT interop is CI-gated: a ztls client sends 0-RTT
data to openssl s_server and receives the HTTP response.

**Current evidence (real, and good):**

- RFC-cited unit tests; every test names its spec section (AGENTS.md mandate).
- RFC 8448 known-answer vectors for the key schedule and transcript.
- OpenSSL interop in both directions, covered by `zig build test`.
- tlsfuzzer conformance, CI-gated (`just conformance/tlsfuzzer`).
- The TLS-Anvil/tlsfuzzer Zig shims build under both Zig 0.15.2 and Zig
  0.16; `just ci-0_16` (CI-gated via the `test-zig-0_16` job in
  `.github/workflows/ci.yml`) runs the full core gate (test + lint + examples +
  conformance) under 0.16, so the external conformance harness is no longer
  tied to the removed `std.net` APIs. *(#58, #61)*
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
  -CAfile`. Client-auth leaf EKU/KU enforcement is now live: the
  `LeafUsage.client_auth` path calls `verifyClientAuthWithSignatureSchemes`,
  which checks X.509v3, `KeyUsage.digitalSignature` when KU is present, EKU
  `clientAuth` when EKU is present, and a TLS 1.3-compatible certificate
  signature algorithm — mirroring the server-auth path. A new
  `client_ecdsa_cert_der` fixture with `clientAuth` EKU exercises the success
  path, and policy tests cover EKU-without-clientAuth rejection,
  KeyUsage-without-digitalSignature rejection, and clientAuth-EKU acceptance.
  The offered-scheme rejection of a malicious client CV is covered by a
  dedicated test (verifyClientSignatureWithSchemes rejects a scheme absent
  from the offered list). *(formerly #4 — interop proven; EKU/KU enforcement
  live; malicious-scheme test covers the defensive guard)*
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
  conformance breadth is feature-specific — HRR, resumption, 0-RTT, client
  auth (formerly #1–#4) plus P-384/PQ groups (#6) — and the BoGo
  re-entry path in #50. A skip-list narrowing landed during #48
  surfaces the strict-complete f50fcd8
  client capture's `sendEndOfEarlyDataAsServer` STRICTLY_SUCCEEDED row rather
  than the broader `*EarlyData*` skip pattern masking it as `unexpected_pass`;
  server EarlyData disabled rows remain expected-skipped under the 0-RTT
  feature (formerly #3), and this is evidence visibility from #48 rather than
  accepted client execution. BoGo is
  explicitly deferred in
  `docs/research/BOGO_DEFERRED.md` with re-entry criteria tracked by #50.
- Wycheproof boundary vectors at the libcrypto seam.
- Fuzzing on the major parsers plus record decrypt and server `handleRecord`
  pre-auth/post-auth dispatch.
- Internal adversarial security review (Project Glasswing harness: recon → hunt
  → validate) covering the supported parser and state-machine surface. Found
  and fixed three vulnerabilities: an integer-overflow DoS class across 14
  parser bounds-check sites (#72), a server authentication bypass via the PSK
  fast-path (#73), and a selectPsk binders-length overflow. Seven additional
  surfaces verified handled. Recon and findings at
  `docs/research/security/FINDINGS.md`; the narrow-type arithmetic lesson is
  encoded in `AGENTS.md` and the security agent prompts.
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

**Status:** `PROVEN`

**Evidence and design decisions:**

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
  and post-HRR ServerHello cipher-suite/group consistency checks. An in-memory
  end-to-end HRR round trip (ztls client → server HRR → ClientHello2 → server
  flight → connected → application-data both ways) is now covered, proving both
  state machines compose with the §4.4.1 transcript collapse. OpenSSL forced-
  HRR interop remains ungated (it needs a client/server config knob to limit
  offered key_share groups so a real peer can be forced to retry; the in-memory
  e2e + TLS-Anvil HRR + unit tests cover the mechanism). *(formerly #1, partial — e2e +
  TLS-Anvil done; OpenSSL forced-HRR interop remains)*. Record-fragmentation
  capability is probe-positive and locally covered for fragmented ClientHello,
  Finished, and KeyUpdate; TLS-Anvil's `RecordLayer.interleaveRecords` remains a
  sender-restriction expected skip, not a missing-fragmentation result. The
  TLS-Anvil-derived failures fixed and closed by completed-run evidence are
  legacy-only `signature_algorithms` rejection *(#35)*, `close_notify` on
  orderly close *(#36)*, compatibility CCS emission *(#37)*, SSLv3
  `legacy_version` rejection *(#38)*, record-fragmentation capability *(#40)*,
  and fragmented KeyUpdate handling *(#41)*.
- **Full TLS-Anvil is scheduled-only, not PR-gated.** The 2-hour runtime
  can't go in PR `just ci`; this is an accepted design decision, not a
  correctness gap. The RFC 8446 MUST matrix is closed for the supported
  surface (unit tests in PR CI), tlsfuzzer is PR-gated (`just conformance/ci`),
  and the full TLS-Anvil server/client suites run in scheduled/manual workflows
  with committed strict-clean captures (437/437, no unexpected attempted
  failures). BoGo is explicitly deferred (`docs/research/BOGO_DEFERRED.md`).
  The adversarial security review (Glasswing) found and fixed 3 vulnerabilities.
  Future feature work that changes TLS scope must reopen the relevant MUST
  matrix rows in the same change.

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
  deterministic examples plus `example-ktls_server` also run under Zig 0.16
  via `just ci-0_16` (CI-gated), covering the `std.Io.net` transport
  boundary for TCP loopback plus the raw-fd epoll and io_uring examples.
  The 0.16 lane runs the full core gate (test + lint + examples +
  conformance); two `ziglint-ignore: Z011` inline suppressions bridge
  `mem.indexOfPos`/`std.meta.Int` deprecations that are inherent to
  dual-version support until 0.15 is dropped. *(#58, #61)*
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

### C ABI (#30) — PARTIAL

The C ABI surface for the ztls TLS 1.3 client lifecycle is partially
landed. `src/capi.zig` exports C-callable shims (`callconv(.c)`) for the
client lifecycle: `ztls_client_init`, `ztls_client_deinit`,
`ztls_client_start`, `ztls_client_handle_record`,
`ztls_client_complete_write`, `ztls_client_send_application_data`,
`ztls_client_is_connected`, `ztls_client_selected_alpn`, plus
`ztls_version`, `ztls_client_size`, and `ztls_client_align`. The
opaque-sized approach is used: the C consumer allocates
`ztls_client_size()` bytes with alignment `ztls_client_align()` and
passes the pointer to `ztls_client_init`; the internal layout is
unstable and not directly accessible. `include/ztls.h` is the C ABI
contract. `zig build -Dcapi` produces `libztls.a` (static) and installs
the header. `examples/c_client.c` compiles against the header + lib
with `zig cc` and runs exit 0. `just capi-ci` is wired into `just ci`.
Zig test blocks in `src/capi.zig` drive a full client handshake (init
→ start → handle_record through connected → send_application_data)
against an in-memory `ServerHandshake` through the C ABI shims.

The security review
(`docs/research/security/C_ABI_SECURITY_REVIEW.md`) drove the
opaque-sized design: transparent C structs leak secrets and backend
pointers across C struct copies, so the internal state is hidden behind
runtime size/align queries. NULL parameter checks map to
`ZTLS_ERR_NULL_PARAMETER` before entering the Zig engine. KeyUpdate and
NewSessionTicket events map to `ZTLS_EVENT_NONE` with a documented
deferred note (honest partial). Certificate verification is deferred:
`ztls_client_init` sets `insecure_no_chain_anchor = true`.

**Deferred (tracked under #30):** server-side C ABI shims, RecordBuffer
C ABI, certificate verification, KeyUpdate initiation from C, PSK /
session resumption from C, ALPN offering from C (query is implemented,
offer is not), dynamic linking (`libztls.so` / `libztls.dylib`), and C
conformance harness integration (TLS-Anvil through the C ABI per
`docs/research/C_ABI_CONFORMANCE.md`). The C ABI is not claimed done.

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
  cannot silently poison the baseline rows. The four benchmarks (ztls, EVP,
  libssl, rustls) all emit Go-testing-style output and flow through one shared
  `normalize_go` path; the rustls harness auto-calibrates iteration counts to
  `--benchtime` (matching the `benchmark` package's `predictN` loop) and
  disables session tickets (`send_tls13_tickets = 0`, matching libssl's
  `SSL_CTX_set_num_tickets(0)`) so the handshake row measures a clean full
  1-RTT without NewSessionTicket issuance cost. The analyzer splits comparable
  TLS, crypto-floor, and ztls-only diagnostic rows and warns when a comparable
  TLS row group has a missing implementation or mismatched sample counts across
  implementations.
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
- `docs/research/PERFORMANCE.md` now carries a **Results and conclusions**
  section stating the performance claim, backed by the n=10 EC2 capture
  (`docs/research/perf/20260712-102422-ec2-c7i-2xlarge/`, formal CIs, p=0.000):
  across the 45 comparable TLS application-data rows on x86_64 `c7i.2xlarge`,
  ztls is faster than OpenSSL libssl on every row (+21% to +261%) and faster
  than rustls on all 30 AES-GCM rows (+65% to +131%) and on large ChaCha20
  records; ztls is slower than rustls on small ChaCha20 records (16B/128B:
  -50% to -56%), a real measured loss attributed to OpenSSL EVP ChaCha20
  small-record overhead versus ring's direct path. The claim is backed by the
  committed benchstat capture and the row-perf explanations that tie wall-time
  deltas to normalized cycles/instructions/branches and hot-symbol evidence.
  An **Acceptance thresholds and regression gate** section defines the
  repetition policy, the 15% regression threshold on comparable AES-GCM rows,
  and the `just bench-regression-check` recipe (`scripts/bench-regression.sh`)
  that runs a fresh EC2 n=10 capture and compares against the committed
  baseline with benchstat A/B, exiting nonzero on regression beyond threshold.

**Status:** `PROVEN`

Two n=10 EC2 captures — x86_64 (`docs/research/perf/20260712-102422-ec2-c7i-2xlarge/`)
and aarch64 (`docs/research/perf/20260712-201912-ec2-c7g-2xlarge/`) — produce
formal confidence intervals (`± 0%` to `± 5%`) and p=0.000 for every
comparable row. ztls beats OpenSSL libssl on every comparable app-data row on
both architectures and rustls on all 30 AES-GCM rows on both architectures;
the ChaCha20 small-record loss to rustls on x86_64 largely disappears on
aarch64 (where OpenSSL's NEON ChaCha20 is more competitive with ring). The
regression gate (`just bench-regression-check`) is committed and tested. The
claim is reproducible and backed by counter/symbol evidence. The canonical
x86_64 capture's rustls.txt is in the pre-Go-bench CSV format;
`bench-analyze.sh` detects this and routes it through a CSV fallback
normalizer, so the committed `benchstat.txt` and a regenerated analysis stay
in sync without re-running the capture.

**Gaps:**

- **Hardware matrix covers both x86_64 and aarch64.** Committed n=10 captures
  on `c7i.2xlarge` (Intel x86_64) and `c7g.2xlarge` (AWS Graviton4 aarch64)
  prove the claim on both architectures with formal CIs. The `c7i.large`
  capture confirms the x86_64 ordering on a smaller shape. Instance-family
  breadth (e.g. AMD, Graviton3) and a final matrix policy remain open for
  marketing-grade evidence, but the core claim (ztls faster than libssl and
  rustls on AES-GCM app data on both x86_64 and aarch64) is established with
  formal CIs. macOS (Apple M1 Max) is now proven with an n=10 capture; Intel
  Macs and other Linux distros are not measured.
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
  `-Dcrypto-backend=aws-lc` build option. BoringSSL is selectable through
  `nix develop .#boringssl` / `ZTLS_CRYPTO_BACKEND=boringssl` or
  `-Dcrypto-backend=boringssl`. The flake exposes `.#base`, `.#openssl`,
  `.#aws-lc`, and `.#boringssl` devshells; each backend shell makes its selected
  `libcrypto.pc` ambient while preserving the OpenSSL CLI for interop tools.
  The AWS-LC lane rejects non-AWS-LC headers at compile time and verifies the
  AWS-LC include/library paths in Zig's verbose build output. The BoringSSL
  lane synthesizes a `libcrypto.pc` (nixpkgs boringssl ships no pkg-config
  file) and rejects non-BoringSSL headers at compile time via an
  `OPENSSL_IS_BORINGSSL` comptime guard.
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
  Ed25519 certificate-chain signatures are verified via
  `std.crypto.sign.Ed25519` in `src/certificate_parser.zig` and are advertised
  in the non-FIPS `certificate_signature_schemes` tables of both backends. The
  certificate-chain signature algorithm (RFC 8446 §4.4.2.2) is independent of
  the CertificateVerify scheme (§4.4.3); `certificate_verify_schemes` omits
  `ed25519` because Ed25519 CertificateVerify signing/verification is not yet
  backed by the backend seam.
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
- BoringSSL is a compile + primitive-test + CI-gated lane: `nix develop
  .#boringssl` + `zig build test -Dcrypto-backend=boringssl` compiles and all
  597 non-FIPS tests pass (8 FIPS tests skip — BoringSSL has no FIPS variant).
  `just check-backend-boringssl` builds, tests, produces the benchmark binary,
  executes a one-row benchmark smoke, runs the in-memory example, builds the
  conformance shims, and runs the TLS 1.3 tlsfuzzer smoke with BoringSSL
  libcrypto linked; the recipe pins `PKG_CONFIG_PATH` to the BoringSSL
  derivation and checks the resolved include and library paths in the build
  log. A CI workflow lane (`.github/workflows/ci.yml` `test-boringssl` job)
  runs `just check-backend-boringssl` under `nix develop .#boringssl` on
  pushes/PRs. Benchmark scripts (`bench-capture.sh`, `bench-perf-row.sh`,
  `bench-disasm-row.sh`, `remote-capture.sh`, `remote-perf-rows.sh`) accept
  `boringssl` as a `--crypto-backend` value; BoringSSL ztls benchmark rows
  are ztls-linked-only with OpenSSL libssl baselines kept explicit (no mixed
  geomeans). The BoringSSL backend (`src/crypto/backend_boringssl.zig`)
  mirrors the AWS-LC backend: X25519 via flat `curve25519.h`, AEAD via
  `EVP_AEAD` one-shot, EC/RSA/signature via legacy EVP (BoringSSL has no
  provider API), KEM stubs (BoringSSL has `NID_X25519MLKEM768` but no
  `EVP_PKEY_Q_keygen`). The same `backend_primitive_tests.zig` vectors run
  under the BoringSSL lane. The flake synthesizes both `libcrypto.pc` and
  `libssl.pc` for BoringSSL (nixpkgs ships neither) and exports
  `ZTLS_BORINGSSL_PKG_CONFIG_PATH` / `ZTLS_BORINGSSL_LIB_DIR` env vars in
  `commonHook`. TLS-Anvil workflow matrices include `boringssl` alongside
  `openssl` and `aws-lc` for both client and server scheduled/dispatch runs.
  The first BoringSSL TLS-Anvil captures are complete. Server run
  `ci-29157499150` on `fd571eb` is strict-complete `437/437`: `passed=105`,
  `failed=0`, `expected_skipped=175`, `unexpected_skipped=0`,
  `not_attempted=157` — clean, matching the OpenSSL and AWS-LC server
  captures. Client run `ci-29157500023` on `fd571eb` is strict-complete
  `437/437`: `passed=91`, `failed=7` (`expected_failed=6` DSA-root per #52,
  `unexpected_fail=1` KeyUpdate ChaCha20-Poly1305 case), `expected_skipped=134`,
  `unexpected_skipped=0`, `not_attempted=205`. The unexpected KeyUpdate
  failure was `respondsWithValidKeyUpdate` with
  `TLS_CHACHA20_POLY1305_SHA256` + `INCLUDE_CHANGE_CIPHER_SPEC=true`;
  #71 identified the root cause as a `ConnectionRefused` race in the
  `anvil_client`'s `connectToHost` (TLS-Anvil starts the trigger script
  before opening its server socket), not a BoringSSL AEAD or KeyUpdate bug.
  Commit `03e136e` adds a connection retry; local TLS-Anvil verification
  confirms `respondsWithValidKeyUpdate` passes under BoringSSL with the
  fix. CI re-run `ci-29169246626` on `9415920` confirms: `passed=92`,
  `failed=6` (all expected_failed DSA-root #52), `unexpected_fail=0`,
  workflow conclusion `success`.
  BoringSSL benchmark captures are local smoke only (no committed EC2
  row-perf evidence). *(#63, #70, #71 — server capture clean; client
  capture KeyUpdate failure root-caused and fixed, CI-confirmed)*

**Status:** `PROVEN`

Three libcrypto backends (OpenSSL default, AWS-LC, BoringSSL) are selectable
via `-Dcrypto-backend=...` / devshells, compile and pass the full test suite,
tlsfuzzer smoke, in-memory example, benchmark smoke, and have committed clean
TLS-Anvil captures (437/437 each, no unexpected failures). CI-gated backend
lanes (`just check-backend-aws-lc`, `just check-backend-boringssl`) run the
same gates as the default. X25519, P-256, AEAD, and CertificateVerify
dispatch through the backend facade; capability tables are backend-owned.

**Design decisions and residual scope:**

- **The provider abstraction is partly real but not exercised end-to-end.**
  `src/crypto/backend.zig` exists, `-Dcrypto-backend=aws-lc` is a recognized
  value, and X25519, P-256, AEAD, and CertificateVerify signing/verification
  dispatch through the facade. Certificate-chain signature verification and
  path validation stay ztls/std-derived rather than backend-backed — that is
  the recorded ownership decision: the backend seam lacks PKCS#1 v1.5 /
  Ed25519 / ECDSA-all-hashes primitives, the std path is exercised and tested,
  and there is no FIPS/perf driver to move it. On divergent-backend evidence,
  FIPS-narrowed capability tables (`openssl-fips`, `aws-lc-fips` backend
  identities) provide a comptime divergence matrix — each FIPS table drops
  ChaCha20-Poly1305, RSA PKCS#1 v1.5 certificate signatures, Ed25519, and
  ML-KEM, with comptime `assertSubset` checks proving FIPS ⊆ non-FIPS and seven
  divergence tests under the default backend verifying the excluded algorithms
  are missing — and the AWS-LC EC/RSA/signature path is recorded as a
  compatibility-justified keep-compatible decision (no OpenSSL 3.x provider
  API in AWS-LC 5.0.0 headers). Honest residual: capability-layer evidence is
  the floor; external-runner FIPS conformance lane and full Wycheproof JSON-
  harness breadth are still absent. BoringSSL backend now compiles and passes
  primitive tests with a CI-gated lane and tlsfuzzer smoke (#63 CI/follow-up
  slice); the BoringSSL TLS-Anvil server capture is clean (105/105, matching
  OpenSSL/AWS-LC) and the client capture has 1 unexpected KeyUpdate/ChaCha20
  finding (#71, root-caused and fixed locally — ConnectionRefused race in
  anvil_client). *(#60, #63, #70, #71)*
- **aws-lc has a real test lane but not a full backend matrix.** The
  `-Dcrypto-backend=aws-lc` build links AWS-LC libcrypto and runs the unit suite;
  X25519 uses AWS-LC's flat `curve25519.h` API, and AEAD uses AWS-LC's
  BoringSSL-style `EVP_AEAD` one-shot API. P-256/P-384 ECDH and signature
  paths delegate to OpenSSL-compatible wrappers using the legacy
  `EC_KEY_*` / `EVP_DigestSign*` API — the only API AWS-LC 5.0.0 exposes for
  these primitives (see the compatibility-decision gap below). CI-gated
  strict-complete TLS-Anvil
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
  Wycheproof coverage is now facade-direct for X25519, all advertised AEAD
  suites, P-256/P-384 ECDH (known-answer shared secrets), RSA-PSS SHA-256
  (verify + tamper tcId 62), ECDSA P-256/P-384 (verify + invalid-DER tamper)
  under both the OpenSSL and AWS-LC lanes — inline comptime hex with tcId and
  source-JSON citations, no JSON harness. Provider/FIPS/version capability
  proof: FIPS-narrowed capability tables (`openssl-fips`, `aws-lc-fips`)
  declare that ChaCha20-Poly1305, RSA PKCS#1 v1.5 certificate signatures,
  Ed25519, and ML-KEM are dropped, with comptime `assertSubset` checks
  proving each FIPS table is a strict subset of its non-FIPS counterpart and
  seven divergence tests under the default backend verifying the excluded
  algorithms are missing. Honest residual: Wycheproof vectors are facade-
  direct and JSON-harnessless (selected tcIds, not full Wycheproof breadth),
  and there is no external-runner FIPS conformance lane for a FIPS-linked
  libcrypto build. *(#60)*
- **OpenSSL-compatible EC/RSA/signature path for AWS-LC is a compatibility
  decision, not a speed placeholder.**
  X25519 and AEAD have AWS-LC-specific primitive paths. EC (P-256/P-384) key
  construction, ECDH, and signatures (RSA-PSS/ECDSA sign+verify) delegate to the
  OpenSSL-compatible implementation in `backend_openssl.zig`, which uses the
  legacy `EC_KEY_*` / `EVP_PKEY_assign_*` / `d2i_*` / `EVP_DigestSign*` API
  family. An API survey of AWS-LC 5.0.0 headers (Nix `aws-lc.dev`,
  `nixpkgs#aws-lc.dev`, include path `…/aws-lc-5.0.0-dev/include/openssl/`)
  confirms AWS-LC does not expose the OpenSSL 3.x provider API at all:
  `EVP_PKEY_fromdata`, `OSSL_PARAM`, `OSSL_PROVIDER`, `OSSL_DECODER`, and
  `EVP_PKEY_CTX_new_from_name` are absent from `openssl/evp.h`, `openssl/ec_key.h`,
  and all other headers; `provider.h`, `core.h`, and `param_build.h` do not exist.
  The legacy `EC_KEY_*` / `EVP_PKEY_assign_*` / `d2i_*` / `EVP_DigestSign*` API
  is the only key-construction/signature path AWS-LC provides, so there is no
  alternative API to measure against — a measurement with nothing to compare
  against is not informative. `c_openssl.zig` already conditionally excludes
  `core.h`, `core_names.h`, and `params.h` from the AWS-LC `@cImport`. The
  `backend_aws_lc.zig` header doc cites this as a compatibility decision (#60
  slice C). A prior scratch measurement on OpenSSL 3.6.2 showed the legacy
  EC/RSA construction path is faster than naive `EVP_PKEY_fromdata`/decoder
  replacements on that backend, reinforcing that the legacy path is not a
  compromise — but the AWS-LC decision rests on the API survey (no alternative
  exists), not on a speed claim. *(#60, slice C done — compatibility-justified,
  no AWS-LC alternative API to measure)*
- **Capability gating exists but is shallow.** ClientHello cipher-suite,
  supported-group, `signature_algorithms`, and `signature_algorithms_cert`
  advertisement now comes from the active backend capability declaration; server
  default suite selection and X25519/P-256 HRR/key-share selection consult the
  same facade. The current OpenSSL and AWS-LC capability sets are intentionally
  identical but backend-owned rather than aliases, the ztls client has local
  X25519/P-256 first-flight key-share plumbing, and compile-time FIPS-narrowed
  capability tables (`openssl-fips`, `aws-lc-fips` backend identities) now
  exist: each FIPS table drops ChaCha20-Poly1305 (not FIPS 140-3 approved),
  RSA PKCS#1 v1.5 certificate signatures (only PSS approved for TLS 1.3),
  Ed25519, and ML-KEM, keeping AES-GCM, P-256/P-384, X25519, RSA-PSS, and
  ECDSA. The non-FIPS `certificate_signature_schemes` tables now advertise
  `.ed25519` because Ed25519 chain signatures are verified via
  `std.crypto.sign.Ed25519` in `certificate_parser.zig`, independent of the
  CertificateVerify backend seam (RFC 8446 §4.4.2.2 vs §4.4.3);
  `certificate_verify_schemes` still omits `ed25519` because Ed25519
  CertificateVerify signing/verification is not backend-backed. Comptime assertions prove each FIPS table is a strict subset of its
  non-FIPS counterpart, and divergence tests (running under the default
  backend) verify the FIPS tables exclude the non-approved algorithms. The FIPS
  build option declares intent; the caller/linker is responsible for ensuring
  the linked libcrypto is actually in FIPS mode (no runtime FIPS provider-load
  verification is performed by ztls). Residual: the full runtime test suite is
  not FIPS-lane-gated — the suite uses non-FIPS algorithms (RFC 8448 §3
  fixtures with RSA PKCS1 cert signatures, ChaCha20-Poly1305 tests), so FIPS
  correctness is proven by comptime capability assertions and divergence tests,
  not by running the suite under a FIPS backend.
  The strict-complete `b6aee2c` client TLS-Anvil capture (`ci-28722850517`)
  closes the remote P-256 evidence gap with `ComplianceRequirements: passed=2`
  and `KeyShare: passed=5`. *(#60)*
- **Named-group/key-exchange shape is only partly generalized.** X25519,
  P-256, and opt-in P-384 ECDHE are provider-backed on the server side, and the
  client can advertise/process those key shares locally. P-384 has local
  OpenSSL/AWS-LC primitive and unit coverage, but still lacks external
  TLS-Anvil/tlsfuzzer evidence; PQ and hybrid groups still need real backend
  math, variable-length key-share/shared-secret plumbing, and provider
  capability tests before aws-lc differences can be claimed honestly. The
  X25519MLKEM768 hybrid KEM handshake now works on both aarch64 and x86_64
  (CI-gated in-memory KEM handshake test passes on ubuntu-latest x86_64 with
  Nix OpenSSL 3.6.2); the initial x86_64 shared-secret mismatch was an x86_64
  codegen issue with by-value capture of the large KEM KeyShare union, fixed
  by using pointer captures. *(#6, #60, #65)*
- **The facade contract is partly enforced by primitive tests, not a full
  matrix.** `src/crypto/backend_primitive_tests.zig` runs the same X25519,
  P-256/P-384 ECDH, AEAD, and all currently advertised CertificateVerify
  signature primitive vectors through the backend facade under both the OpenSSL
  and AWS-LC lanes in `zig build test` and `just check-backend-aws-lc`. It now
  includes selected facade-direct Wycheproof vectors for X25519 and all
  advertised AEAD suites, while the
  wrapper-level Wycheproof tests still cover the public `x25519`/`aead` paths.
  This is a narrow primitive/vector contract — it is not yet a full Wycheproof
  JSON-harness breadth, a per-primitive divergent-cipher/per-primitive
  divergent-signature evidence matrix, or an external-runner FIPS
  conformance lane. Wycheproof is now facade-direct for X25519, AEAD,
  P-256/P-384 ECDH, RSA-PSS, and ECDSA P-256/P-384 (selected tcIds, both
  OpenSSL and AWS-LC lanes); the FIPS divergence matrix is comptime (subset
  asserts + divergence tests under the default backend); the certificate-
  chain ownership decision is recorded as keep ztls/std (see the cert-chain
  ownership gap above). BoringSSL backend now compiles and passes primitive
  tests with a CI-gated lane, `just check-backend-boringssl` recipe,
  benchmark lane, and tlsfuzzer smoke (#63 CI/follow-up slice); the
  BoringSSL TLS-Anvil server capture is clean (105/105, matching
  OpenSSL/AWS-LC) and the client capture has 1 unexpected
  KeyUpdate/ChaCha20 finding (#71, root-caused and fixed — ConnectionRefused
  race in anvil_client). *(#60, #63, #70, #71)*

---

## Pillar 5 — Marketing flair

**Target:** the "why ztls over libssl" story, told clearly and backed by Pillar 3
numbers.

**Status:** `PROVEN`

**Current evidence:** `README.md` leads with the proven performance story —
real n=10 numbers on x86_64 and aarch64, the honest ChaCha20 small-record
loss stated alongside the wins, mechanism tied to cycles/symbols. The README
also carries the honest security posture (adversarially reviewed, 3 vulns
fixed, not an external audit). The "why ztls over libssl" narrative is the
README's Performance + Why-it-works-this-way sections; the benchmarks-as-
marketing surface is the README headline table + `docs/research/PERFORMANCE.md`
full tables. The herald agent's voice-calibration notes are committed in
`.pi/agents/herald.md`.

The story is told, backed by `PROVEN` Pillar 3 numbers, on the front door.
A standalone why-ztls page, a separate benchmarks page, or a project site
would be additional surfaces but are not required for the target ("the story,
told clearly and backed by numbers").

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
