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

ztls is production-ready when all six pillars are `PROVEN` and one immutable
candidate passes the qualification gates below. Evidence applies to its recorded
revision, not automatically to later commits.

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
| 1. Correctness | `PARTIAL` | Historical TLS-Anvil evidence covers `d07c551` (#108). The #118 fix, #119 consumer gate, and #120 candidate conformance pass. Resource and policy residuals remain tracked under #121–#126. |
| 2. Ergonomics | `PROVEN` | CI-gated examples cover both roles across io_uring, epoll, kqueue, and `std.Io`. Core and wrapper APIs expose hybrid capabilities and reject invalid local policy before key generation or wire I/O (#105). `ztls-std` (#77) gates plain and mTLS OpenSSL interop in both directions. `ztls-xev` satisfies #76's Linux/macOS contract, including in-flight cancellation (#83). |
| 3. Performance | `PROVEN` | n=10 captures on x86_64 (c7i.2xlarge), aarch64 (c7g.2xlarge), and macOS (Apple M1 Max) with formal CIs (p=0.000): ztls beats libssl on every comparable app-data row on all three platforms and rustls on all AES-GCM rows; regression gate committed. |
| 4. Providers | `PROVEN` | OpenSSL, AWS-LC, and BoringSSL passed strict-complete TLS-Anvil client and server runs at `d07c551`; malformed peer ML-KEM keys produce `illegal_parameter` while provider faults remain `internal_error` (#108). The capture is bound to that revision; candidate re-qualification is #120. |
| 5. Marketing | `PROVEN` | README leads with the proven performance story (n=10, both architectures, honest ChaCha20 loss) and the adversarial security posture; the why-ztls narrative and headline benchmarks are on the front door, backed by PERFORMANCE.md. |
| 6. User docs | `PROVEN` | One fetched package exposes core plus the Zig 0.16 integration modules (#79). Isolated consumer gates and `docs/USAGE.md` cover dependency wiring, hybrid capability checks, borrowed lifetimes, cleanup, drive loops, and integrations (#105). |

---

## Production candidate qualification

The selected candidate is `b9d03edfb422e4f2528635bae03cc1a5daffbe69`.
The controller revision is `01a5b0686efc01bb7bf7970d9d49797389fbbe9f`.
Only handoff and z53 participate. Kafka is abandoned and outside this gate.

| Gate | Evidence and residual scope |
|---|---|
| #118 — certificate path length | The published fix passes the local provider/Zig matrices and GitHub CI `35482684833`, including macOS. Parent review and mutation evidence support the patch. Delegated independent review did not execute. |
| #119 — consumer compatibility | Both real consumer suites pass against the candidate. Broken-import controls fail both consumers. The hostname-removal control fails two z53 authentication tests. |
| #120 — TLS-Anvil | Both roles account for 437 cases per provider with zero unexpected results. All six parent reports are terminal and all source trees are clean. |
| #121 — resource cleanup and transport recovery | Revised unit and replay diagnostics free every allocation. Two early-data abort leaks have regressions. Replacement-candidate consumer recovery remains unqualified. No duration-based gate applies. |

The consumer records are under
[`CONSUMER_GATE/20260919-launchpad-b9d03ed`](docs/research/CONSUMER_GATE/20260919-launchpad-b9d03ed/).
Each record includes the candidate package hash, exact revisions, commands,
original dependency pins, toolchain, and raw logs.

| Consumer | Revision | Tested profile |
|---|---|---|
| handoff | `557ba42de1e4aa3f16e3cff0c7ed6bb885fddebd` | Linux aarch64, kernel 7.2.3, Zig 0.16.0, AWS-LC 5.5.0 |
| z53 | `499c41abab505d72d9611f5fbb3cebfc91d90058` | Linux aarch64, kernel 7.2.3, Zig 0.16.0, OpenSSL 3.6.4 |

handoff passed 63 tests and four TLS/plaintext build configurations.
z53 passed four portable tests and 99 native tests, with one recorded skip.
Its native suite covers authentication rejection, partial TLS writes, reset,
idle expiry, cancellation, and repeated restart behavior.

The private handoff traffic probe verified `localhost` against the pinned fixture leaf for Python TLS clients.
The probe covered:

- Byte-exact echoes of 16 KiB and 1 MiB.
- A batch of 130 connections at concurrency 16.
- Twenty KeyUpdates with wire responses and byte-exact echoes.
- PostgreSQL STARTTLS and PROXY v2.
- Client and backend half-close behavior.

The raw OpenSSL KeyUpdate and half-close clients did not verify the peer certificate.
Both owned processes returned to their initial descriptor counts after each phase.
The proxy used ten descriptors and reached 7,876 KiB RSS in the final samples.
These are bounded functional checks, not throughput measurements or proof of indefinite stability.

Valgrind 3.27.1 found no leaked allocations in the complete in-memory handshake example.
The previous candidate's full unit suite leaked 124,416 direct bytes and 621,384 indirect bytes despite successful test assertions.
The #121 follow-up fixes omitted fixture cleanup and two engine leaks during aborted early-data handshakes.
Both abort regressions failed their allocation-count checks before the corresponding fixes.
The revised Debug and ReleaseFast suites free every allocation, with 849 test passes and one skip each.

The optimized OpenSSL reports map to seven vector-scan branches across five functions.
A standalone instruction probe reproduces the Memcheck definedness limitation with valid NUL-terminated strings.
The same ReleaseFast binary reports zero Memcheck errors with the diagnostic provider that disables C vectorization.
No suppressions apply. Production keeps the optimized provider.
Both Linux CI lanes check the full unit suite under Memcheck.
The Zig 0.15 lane also checks all three replay benchmark rows.
The benchmark driver depends on Zig 0.15 APIs.
The replay cleanup fix changes that benchmark's measurement boundary, not historical captures.

The [resource diagnosis](docs/research/CONSUMER_GATE/20260919-launchpad-resource-cleanup/) preserves the failures, controls, source patches, and provider disassembly.
These diagnostics do not qualify a new immutable candidate.
Consumer pool occupancy and the remaining transport-recovery checks stay open under #121.

The six candidate captures are under
[`captures-b9d03ed`](docs/research/TLS_ANVIL_91_CHAIN_FIXTURE/captures-b9d03ed/).
The manifest records workflow IDs, artifact hashes, and build provenance.
| Role | Passed | Expected failed | Expected skipped | Not attempted |
|---|---:|---:|---:|---:|
| Client | 92 | 6 | 134 | 205 |
| Server | 105 | 0 | 175 | 157 |

Each capture uses Zig 0.15.2 with one provider:

- OpenSSL 3.6.4.
- AWS-LC 5.5.0.
- BoringSSL 0.20260803.0.

Expected classifications remain unchanged. No partial-run override applies.
TLS-Anvil does not directly cover RFC 10024 hybrid groups, the new PSK continuity cases, or extracted-session ownership.
Those features retain their separate unit and interoperability evidence.

The #108 captures remain historical evidence for `d07c551`.
Unexercised profiles remain untested. Existing z53 operation provides historical evidence for its actual deployed revision, not this candidate.
The live service remains untouched.

Candidate gates do not erase known correctness residuals.
The #122 patch rejects unprocessed critical extensions and invalid SAN wrappers.
Signed public-path regressions failed before the fix. The local OpenSSL suite passes 849 tests with one skip.
Local OpenSSL, AWS-LC, BoringSSL, and Zig 0.16 gates pass.
Qualification of the replacement candidate remains pending.

The #123 contract applies a shared 1–253-octet SNI HostName bound to encoding, length preflight, and parsing.
The parser also rejects an empty ServerNameList. Accepted names remain borrowed, untrusted routing input.
DNS label validation and IDNA conversion remain caller responsibilities.

Six new boundary tests pass. Four initial regressions failed before the fixes.
The additional empty-list mutation fails its expected-error assertion.
Local gates pass for all three providers. Both Zig compatibility lanes pass.

#124 tracks focused handshake and parser evidence gaps.
Compiler-dependent zeroization and the IDNA contract remain audit or policy questions under #125 and #126.
Deferred C ABI work (#30) remains outside these consumers' qualification requirements.

---

## Pillar 1 — Correctness

**All-backend TLS-Anvil proof at `d07c551` (2026-09-17, #108):** Manual runs of
both scheduled workflows used clean `d07c551`. Client runs `35208400497` (OpenSSL),
`35208402638` (AWS-LC), and `35208404759` (BoringSSL) each completed 437 tests:
92 passes, six expected DSA failures, 134 expected skips, 205 not attempted, and
zero unexpected results. Server runs `35208407073` (OpenSSL), `35208409696`
(AWS-LC), and `35208412198` (BoringSSL) each completed 437 tests: 105 passes,
175 expected skips, 157 not attempted, and zero failures or unexpected results.

Commit `d07c551` classifies the 14 observed `NAMED_GROUP`-disabled cases by exact
stable test ID without restoring the broad pattern. It validates packed ML-KEM
coefficients before provider import, maps malformed peer keys to
`illegal_parameter`, and preserves provider faults as `internal_error`. Local
Zig 0.15.2 backend gates pass across OpenSSL, AWS-LC, and BoringSSL; the Zig 0.16
OpenSSL gate also passes. The client and server artifacts record clean
`d07c551` provenance.

**Accepted three-backend captures (2026-09-13 UTC, #91):** OpenSSL
`34739623436`, AWS-LC `34739624161`, and BoringSSL `34739624962` ran at clean
`e5800ee`. Each completed 437/437: 92 passes, six expected DSA failures (#52),
134 expected skips, 205 not attempted, and zero unexpected results. No partial
override was used. Both fixture patches' live jar/class/source digests match
their build stamps. All 3,410 client invocations carry the enabled local-port
diagnostic; none reports a certificate-validity rejection. The raw KeyUpdate
and client-authentication cases strictly succeed on every backend; non-DSA
HappyFlow cases also strictly succeed. An independent evidence review accepted
these captures against #91's criteria. Summaries, provenance, all invocation
logs and all per-test reports are preserved with verified archive manifests in
`docs/research/TLS_ANVIL_91_CHAIN_FIXTURE/captures-e5800ee/`.

The reproduced missing-CA-constraint case, serialization regression, unchanged
issuer validation and narrow #52 classifier, and fresh captures satisfy #91's
acceptance. This restores the bounded correctness/provider conformance claim;
it does not establish a unique retrospective cause for the earlier KeyUpdate
or client-authentication failures, whose original certificate bytes are absent.

**Earlier diagnostic AWS-LC capture (2026-09-13 UTC, #91):** run `34735309314` at clean
`7ae6014` completed 437/437 with matching patched-fixture provenance.
The aggregate reports 92 passes, six expected DSA failures, and zero unexpected results.
Fourteen client invocations reject expired server chains.
All 28 recovered certificates have identical validity endpoints, exactly one second before the client policy and real clocks.
Seven invocations match recorded case ports and adjacent start times.
Those cases report four strict successes and three conceptual successes despite rejection before Finished or CertificateVerify validation.
The green aggregate therefore does not establish the intended negative-test coverage.
The DateTime adapter's copy-to-DER regressions and the accepted captures above
address this fixture defect without relaxing certificate validation.
Historical KeyUpdate and client-authentication failures remain unexplained without their certificate bytes.
Raw logs, case reports, PEM certificates, extraction code, and clock associations:
`docs/research/TLS_ANVIL_91_CHAIN_FIXTURE/captures-7ae6014/`.

**Earlier AWS-LC capture (2026-09-13 UTC, #91):** run `34733530093` at clean
`0f3e3a4` completed 437/437 with matching patched-fixture provenance, 91 passes,
six expected DSA failures, and one unexpected client-authentication failure
(`8446-bejcyb2cLf`). All KeyUpdate tests passed in this run; that does not
establish a fix for their earlier failures. The per-invocation client log
immediately preceding the failed case reports `CertificateExpired` during
server-certificate validation. Actual certificate validity dates have not yet
been captured, so the cause of that rejection remains under investigation.
The new trigger changes startup timing; results cannot establish timing-cause
comparisons with the earlier trigger. Raw summaries, case results, and nearby
invocation logs: `docs/research/TLS_ANVIL_91_CHAIN_FIXTURE/captures-0f3e3a4/`.

**Earlier patched-fixture captures (2026-09-13 UTC, #91):** all three runs at
clean `1d900e2` completed 437/437 without partial-run overrides. OpenSSL
`34728687594` and BoringSSL `34728689625` each have 92 passes, six expected
DSA failures, and zero unexpected results. AWS-LC `34728688542` has 91 passes,
six expected DSA failures, and one unexpected KeyUpdate failure. Each has 134
expected skips and 205 not attempted. Actual jar/class/source hashes match
build provenance. Summaries and metadata are preserved under
`docs/research/TLS_ANVIL_91_CHAIN_FIXTURE/captures-1d900e2/`.
The earlier KeyUpdate failure remains forensically unattributed; current acceptance
uses the fresh captures above, not a claim that this old failure is explained.

**Earlier failed capture (2026-09-12, #91):** scheduled client run
[`34447449765`](https://github.com/mattrobenolt/ztls/actions/runs/34447449765)
on clean `7c5049e` completed 437/437 BoringSSL tests: 92 passed, six
unexpected failures, zero expected failures, 134 expected skips, and 205
not attempted. The six IDs match the historical #52 set, but their raw
`FailureInducingCombinations` include RSA and ECDH_ECDSA roots. The narrow
DSA classifier correctly leaves them unexpected. Client stderr includes
`CertificateIssuerNotCa`; the aggregate log does not establish per-case
causality. No issuer-policy relaxation or broader exception is justified.
The historical clean-capture descriptions below are provenance, not proof
of current correctness. The reproduction and fresh strict-complete captures
required to restore `PROVEN` are recorded above. The same run's AWS-LC summary has
92 passed and six unexpected failures; OpenSSL has 91 passed and seven
unexpected failures. Both also completed 437/437 from clean `7c5049e`, with
zero expected failures, 134 expected skips, and 205 not attempted. Their
per-case causes require separate reproduction.

The #91 investigation also exposed an alert-mapping defect:
`CertificateIssuerNotCa` fell through to `internal_error`. It now maps to
`bad_certificate` (RFC 8446 §6.2), with a regression assertion observed failing
before the fix and passing afterwards. Issuer rejection is unchanged; this
alert correction does not resolve the TLS-Anvil failures.

**Target:** every RFC 8446 MUST is mapped to evidence or an explicit
out-of-scope decision; the things that must *fail* are enumerated and tested as
rigorously as the things that must succeed.

**Supported surface today** (per `CORRECTNESS.md`): TLS 1.3 full handshake over
X25519 and P-256 ECDHE, three mandatory cipher suites, certificate-authenticated
server flight with client verification gates, application data, alerts,
`close_notify`,
post-handshake KeyUpdate (both directions, flood-bounded, record-boundary
enforced). PSK/session resumption is implemented (#110): both roles derive the
resumption_master_secret over the live transcript through client Finished. The
server exposes explicit allocation-free ticket preparation and emission with an
engine-owned unique nonce, caller-supplied fresh random ticket_age_add, a
seven-day lifetime limit, one ticket per record, and a 32-ticket per-connection
server issuance bound. The caller owns opaque identity encoding, persistence,
expiry, rotation, replay policy, resumption-chain limits, and any client-auth
continuity; v1 server-issued tickets do not advertise 0-RTT. The client
surfaces
NewSessionTicket events, produces a caller-storable SessionTicket (identity +
PSK + age/lifetime via ArrayBuffer), and emits a PSK ClientHello
(pre_shared_key + psk_key_exchange_modes + binder over the truncated transcript
prefix). After HelloRetryRequest, ClientHello2 retains a compatible PSK and both
roles recompute/verify its binder over the retry transcript; the server also
enforces PSK identity continuity across the retry (RFC 8446 §4.1.2: ages and
binders may be recomputed and hash-incompatible identities dropped — by lookup
entry or binder length; added, replaced, reordered, or retained-but-dropped
identities rejected; more than 8 offered identities refused before the HRR as a
documented admission bound), from fixed-capacity CH1 fingerprints with no
allocation; the server verifies
binders via a caller-owned PskLookup (which may be called repeatedly per
identity within a handshake) and selects an identity; both sides use the
PSK as the early secret in the key schedule (psk_dhe_ke, PSK + ECDHE). In-memory
tests cover issuance, matching client/server PSKs, resumption, renewal, and
client-auth transcript binding. The repository's OpenSSL-provisioned CI gates
resumption interop in both directions: ztls resumes a ticket from openssl
s_server, and openssl s_client resumes a ticket issued by ztls. The client and
server state machines handle the PSK resumption flight (EE + Finished, no server
Certificate/CertificateVerify). 0-RTT early data is implemented: the client can
offer early_data + derive the client_early_traffic_secret and send
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
A server that declines after early records are already in flight now applies
both RFC 8446 §4.2.10 decline strategies (#111). The regular 1-RTT response
trial-deprotects each application_data record with the handshake traffic
key, discards failures up to a configurable wire-byte budget, and treats the
first deprotected record as the start of the client's second flight. The
HelloRetryRequest response skips records with an outer content type of
application_data while ClientHello2 is pending (payloads of one AEAD tag or
less abort with `RecordTooShort` so zero-length abuse cannot burn budget;
ClientHello2 closes the window). The budget is `Config.early_data_skip_limit`
in wire payload bytes (ciphertext + tag, the 5-byte header excluded), default
`frame.max_ciphertext_len` (16640) so one full max-size early-data record
(2^14 + 1 + 16 = 16401) fits; exhaustion aborts with
`EarlyDataSkipLimitExceeded` → bad_record_mac per §5.2. Accepted 0-RTT
records preserve decryption errors (#116): `AuthenticationFailed` maps to
`bad_record_mac`, as §4.2.10 requires. The regression explicitly negotiates
early data, corrupts a record tag, and checks the error and alert.
It failed on the alert assertion before the fix. Authenticated malformed
EndOfEarlyData still produces `UnexpectedMessage` and `unexpected_message`.
Reject-path
tests cover max_early_data_size exceeded, no-PSK-selected early data,
server-declined 0-RTT, and client rejection of server-sent EndOfEarlyData;
decline-skip tests cover ordinary policy decline, no-PSK selection, and
required client authentication declining the PSK on the 1-RTT path, and the
full HRR → skipped early records → ClientHello2 → completed retry handshake,
plus budget exhaustion, malformed/zero-length abuse, skip-window closure,
post-window record corruption, and the default budget covering a full
max-size early record (#111).
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
  conformance breadth is feature-specific — HRR, resumption, 0-RTT, and client
  auth (formerly #1–#4), plus the BoGo re-entry path in #50. Plain P-384 now
  has bidirectional OpenSSL 3.6 interop; the RFC 10024 groups additionally pass
  the pinned upstream tlsfuzzer ML-KEM matrix. A skip-list narrowing during #48
  surfaces the strict-complete f50fcd8
  client capture's `sendEndOfEarlyDataAsServer` STRICTLY_SUCCEEDED row rather
  than the broader `*EarlyData*` skip pattern masking it as `unexpected_pass`;
  server EarlyData disabled rows remain expected-skipped under the 0-RTT
  feature (formerly #3), and this is evidence visibility from #48 rather than
  accepted client execution. BoGo is
  explicitly deferred in
  `docs/research/BOGO_DEFERRED.md` with re-entry criteria tracked by #50.
- **#91 acceptance is satisfied; historical causality has explicit limits.**
  The scheduled client run `34447449765` failed with non-DSA unexpected
  failures on all three backends. A single-case reproduction (HappyFlow
  `8446-jVohiUKi4u`, `ROOT=RSA` leaf RSA-1024 combination) attributes the
  failure to the TLS-Anvil fixture, not ztls: the pinned upstream
  `tls-test-framework-1.5.0` `X509CertificateChainProvider` generates chain
  signing (root) certificates without a basicConstraints extension, violating
  RFC 5280 §4.2.1.9; ztls's issuer-usage check rejects them with
  `CertificateIssuerNotCa` (observed on the tested backend; the other backends
  are unproven for this path). Upstream v1.5.2 and `main` have the same gap
  (no upstream fix or config option). A minimal in-repo conformance-tools
  patch (`conformance/scripts/anvil-chain-provider-patch/`, wired into the
  conformance build) adds a critical basicConstraints cA=true to the generated
  signing certs only; leaf configs and chain diversity are untouched. Red→green
  is proven for the reproduced case (RSA/ECDH_ECDSA-root HappyFlow cases flip
  from FULLY_FAILED to STRICTLY_SUCCEEDED; the DSA-root #52 class is
  unchanged), the regression is CI-gated (`just anvil-chain-patch-test`),
  provenance digests of the installed jar/class/patch source are recorded in
  client and server run metadata, and evidence (PEMs, probe red/green outputs,
  before/after per-case JSON, client stderr) lives in
  `docs/research/TLS_ANVIL_91_CHAIN_FIXTURE/`. Fresh strict-complete captures
  at `e5800ee` satisfy the all-backend acceptance requirement. The other five
  original non-DSA test IDs were not individually reproduced. A second #91 fixture
  defect is locally reproduced and patched: upstream x509-attacker 4.3.10 has
  no `package-info` for `de.rub.nds.x509attacker.config`, so JAXB marshals the
  config's joda `DateTime` `notBefore`/`notAfter` as empty XML elements and
  `Config.createCopy()`/`ConfigIO` round trips lose the configured
  2026-01-01..2028-01-01 validity window (the copy acquires current dates).
  Upstream report: https://github.com/tls-attacker/X509-Attacker/issues/67.
  The conformance build now injects a package-level
  `DateTimeAdapter` (`DateTimeAdapter.java` + `package-info.java` in
  `conformance/scripts/anvil-chain-provider-patch/`) into the installed
  x509-attacker-4.3.10 jar — atomic per-jar update, pinned-version refusal,
  and a provenance stamp (live jar, adapter class, package-info class, and
  both source digests) recorded and validated in client/server run metadata
  alongside the chain-provider stamp. Regression is CI-gated via `just
  anvil-chain-patch-test` (`ValidityRoundTripProbe`): green against the
  installed jars (repeated `createCopy` + `ConfigIO` round trips, both chain
  certificates, the default 2026–2028 window, non-default windows with
  milliseconds and UTC offsets, deliberately expired/future windows, and actual DER
  decoded by the JDK `CertificateFactory`), red against a pristine
  x509-attacker jar (adapter class absent, dates replaced by "now").
  Evidence: `docs/research/TLS_ANVIL_91_CHAIN_FIXTURE/`
  `validity-probe-green.txt` / `validity-probe-red-pristine.txt`, with commands,
  base revision and artifact/source hashes in `validity-probe-metadata.json`. This is
  local regression evidence; the fresh full captures with both patches are
  preserved in `captures-e5800ee/` and accepted above.
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
- A follow-up full-source audit (2026-07,
  `docs/research/security/AUDIT-2026-07.md`) re-read every production file and is
  under active, TDD remediation (one finding-class per slice: failing regression
  test first, then the fix). It surfaced findings the Glasswing pass missed —
  most importantly a CRITICAL server-authentication bypass (S5: an end-entity
  certificate accepted as an issuing CA; no BasicConstraints `cA` / `keyCertSign`
  enforcement on issuers), three further #72-class narrow-arithmetic panic sites
  (S6/S7), a public-AEAD length-mismatch write hazard reachable only off the
  public API / C ABI (S8), plus protocol/state-machine and hardening items
  (S9–S14, H1–H24). This bullet is the current parser/auth-surface status,
  superseding the Glasswing bullet above until remediation completes. Fixed and
  regression-tested:
  - S5 (CRITICAL) — end-entity-as-CA bypass: BasicConstraints `cA` and, when
    KeyUsage is present, `keyCertSign` enforced on every presented-chain issuer
    and the bundle trust anchor. The #118 patch enforces `pathLenConstraint`
    over the selected anchored path. It excludes the target and self-issued
    intermediates from the count. Bundle-anchor constraints apply as local
    policy under RFC 5280 §6.2, consistent with OpenSSL.
    Seventeen new tests cover both public certificate parsers and selected-path
    semantics. The parent reproduced the anchor-constraint mutation failure
    and restored a green core suite: 846 passes, one existing skip.
    All 15 OpenSSL differential checks matched the expected verdicts.
    `just ci`, `just check-backend-boringssl`, and Zig 0.16 `just ci-0_16`
    passed on Linux aarch64. GitHub CI `35482684833` also passed, including
    macOS. The parent reviewed the recovered patch. Delegated independent
    review did not execute. Candidate evidence appears in the section above.
  - S6/S7 — three #72-class narrow-arithmetic panic sites widened to `usize`.
  - S8 — public `Aead.encrypt`/`decrypt` reject mismatched in/out slice lengths
    (`SliceLengthMismatch`) before the backend call; not peer-reachable via the
    RecordLayer (equal-length in-place slices).
  - S9 — after HelloRetryRequest the server validates ClientHello2 against
    ClientHello1 (length-prefixed stable-field digest) and rejects `early_data`
    in CH2 (§4.1.2/§4.2.10). The stable-field digest deliberately excludes the
    `pre_shared_key` identities (ages/binders may be recomputed, §4.1.2), so
    PSK identity continuity is enforced separately from retained CH1 metadata:
    fixed-capacity 128-bit identity fingerprints plus a per-identity removal
    rule the server can prove — drop only identities hash-incompatible with
    the HRR cipher suite, established by the `PskLookup` entry for known PSKs
    or by the offered binder length for unknown ones (§4.2.11.2: binder
    length = the PSK's hash output; an unknown identity whose binder length
    matches the HRR suite's hash claims compatibility and must be retained).
    Added, replaced, reordered, and retained-but-dropped identities are
    `illegal_parameter`. A CH1 that needs a retry but offers more identities
    than the fixed capacity (`max_retry_psk_identities = 8`) is rejected
    before the HRR with `TooManyPskIdentities` (classified `.buffer`, alert
    `handshake_failure`) — an explicit documented admission bound, not a
    claim of support beyond it; with a usable key_share no retention is
    needed and any count is accepted. Regression-tested for #103 with a
    valid-binder identity substitution, addition/reorder/drop rejections,
    permitted-removal/age/binder acceptance, binder-length-based
    unknown-identity rejection, bounded admission, and mutation checks
    (enforcement disabled → substitution/drop tests fail; retention rule
    disabled → compatible-drop case fails; admission disabled → admission
    test fails; binder-length classification disabled either direction →
    the corresponding acceptance/rejection test fails). The #103-review P0
    slack-byte usize-underflow in the new offer iterator and the P1
    pre-existing sibling underflow in `selectPskWithTranscript` are fixed by
    replacing both walks with the vector-bounded `PskOfferIter`
    (client_hello.zig; both readers bounded to their own vectors), with
    wire-level red/green regressions on all three reachable paths (HRR CH1
    capture, CH2 continuity, ordinary PSK selection) that panicked with
    integer overflow before the fix and now return clean decode-class
    errors; the iterator also enforces one-binder-per-identity, which
    tightens previously-accepted malformed offer lists. Local unit evidence
    only (0.15 and 0.16 lanes both green); no external TLS-Anvil/BoGo run
    yet covers these cases. `PskLookup` may now be called repeatedly for the
    same identity within one handshake (CH1 selection, HRR retention, CH2
    selection) — documented on the type; implementations must stay
    side-effect-free.
  - S10 + H1 + H11 — PSK selection honors `psk_key_exchange_modes` (abort on a
    `pre_shared_key` offer with no modes; no resumption without `psk_dhe_ke`) and
    enforces PSK/cipher-suite hash compatibility on both server selection and
    client acceptance; the binder compare is constant-time (§4.2.9/§4.2.11.2).
  - S11 — the client rejects an EncryptedExtensions `early_data` acceptance
    unless it selected the PSK, installed early keys, and no HRR intervened, and
    only offers CH `early_data` when the ticket permits it (§4.2.10/§4.5).
  - S12 + S13 — the client rejects trailing handshake bytes after the server
    Finished, and frames ClientHello2 after HRR as a proper handshake record
    (§4.1.4/§5.1).
  - H6/H7/H8/H10 — X.509 DER strictness: unknown critical extensions rejected,
    SAN dNSName matched only for context-specific GeneralNames, EKU requires a
    SEQUENCE wrapper, and duplicate instances of a processed extension are
    rejected (RFC 5280 §4.2). The #122 patch also rejects unprocessed critical
    extensions and requires a constructed universal SAN SEQUENCE.
    Signed regressions reproduce both original acceptances. Critical-extension
    rejection maps to `unsupported_certificate`, not `internal_error`.
    The local suite passes 849 tests with one skip.
    OpenSSL, AWS-LC, BoringSSL, and Zig 0.16 gates pass.
  - H9 — X.509 time strictness: UTCTime `YY` now follows RFC 5280 (00–49 → 20YY,
    50–99 → 19YY, so a long-expired 19YY cert is no longer read as 20YY),
    GeneralizedTime requires exactly `YYYYMMDDHHMMSSZ`, and impossible dates
    (e.g. Feb 31, Feb 29 on a non-leap year) are rejected.
  - H2/H3 — OpenSSL backend hygiene: EC private scalars are freed with
    `BN_clear_free` (were `BN_free`, leaving secret residue), and `aeadInit`
    rejects a key whose length differs from the cipher's key length before any
    EVP setup (defense-in-depth; unreachable via the typed `Aead` facade).
  - H4/H5 — KEM hardening: the negotiated RFC 10024 group selects an exact
    parameter set and component layout before any provider call. This prevents
    group-echo confusion. The ML-KEM wrapper validates provider outputs against
    the exact ML-KEM-768 or ML-KEM-1024 lengths. ClientHello and ServerHello
    parsers require each group's exact role-specific share length and classical
    point format.
  - Public secret cleanup (#105): `SessionTicket`, `KtlsInfo`, P-256 and P-384
    key pairs, and packed kTLS crypto-info values own `secureZero()` methods.
    Each byte-erasure test failed when its cleanup body became a no-op.
    In-tree callers use those methods instead of raw object-layout erasure.
  - H13/H14 — ServerHandshake record hygiene: `receiveApplicationData` rejects
    application data interleaved inside a pending KeyUpdate fragment, and the
    0-RTT byte counter checks the remaining budget before adding (no saturation
    at `maxInt(u32)`).
  - H18/H19/H24 — misc hardening: `sendEarlyData` now follows the `pending_write`
    interlock (was a write-desync footgun); `parse`/`parseClientChain` validate
    the handshake body-length field like `parseClientCertificate`; and the
    `client_cert_policy` struct default is `.client_auth` (was `.server_auth`, a
    direct-construction trap).
  - H23 — `rejectDuplicateExtensions` caps the extension block at 64 entries
    (outer + inner count guards), bounding the previous O(n²) scan to O(64²) and
    neutralizing the pre-auth CPU amplifier.
  - H21 (partial) — hostname policy: SAN is now required for host matching (CN
    fallback removed, per RFC 9525), and public-suffix wildcards like `*.com` are
    rejected (heuristic, not a full PSL). server.crt was modernized with a SAN
    (key preserved).
  - H12 — the client post-handshake flood counter now tracks KeyUpdate and
    NewSessionTicket separately (limits 16 / 32), both reset on application data,
    so a ticket-heavy server no longer false-trips the KeyUpdate limit. Server
    issuance has its own 32-ticket per-connection bound and emits exactly one
    ticket per record.
    A
    cross-family council endorsed this split and rejected the audit's original
    "don't reset on app data" (which would cap a connection at 16 KeyUpdates for
    life — OpenSSL removed exactly such a cap).
  - S14 — the server now surfaces the verified mTLS client identity: an optional
    caller-owned `Config.client_cert_buffer` retains the verified leaf DER (copied
    only after the client is fully authenticated — after CertificateVerify and
    Finished), exposed via `clientCertificateDer()` / `clientCertificate()`
    (gated on `.connected`, explicit null when no client cert). Ergonomics
    (struct-return shape, three-way absence, parsed subject/SAN helpers) flagged
    for maintainer refinement.
  - H15 (safety subset) — the C ABI no longer silently wedges or ships a silent
    insecure default: a KeyUpdate carrying a response now surfaces as
    `ZTLS_EVENT_WRITE` (was `.none` + a jammed `err_pending_write`), and the sole
    client initializer is the explicitly-named `ztls_client_init_insecure` (was a
    silent `insecure_no_chain_anchor = true`). Full trust-anchor plumbing / a
    verifying `ztls_client_init` remain #30.

  Open — the remainder (re-adjudicated 2026-07 by a cross-family council):
  - H16 — `Signer` borrows the `PrivateKey` (deinit-then-use is a UAF). The
    council voted 2-1 to ref-count now, but on code inspection the borrowed
    `Signer` is consistent with ztls's caller-owns-everything Sans-I/O design:
    it is a stored caller-owned resource with a documented "must outlive the
    handshake" contract, exactly like caller-owned certs, reassembly buffers,
    keypairs, and ALPN — and the engine never frees it. Ref-counting it (the
    2-1 fix, reasoned from rustls/OpenSSL norms) would make it the lone
    engine-owned backend resource, against the philosophy. Deferred to #30
    (kimi's dissent): cross-language ownership genuinely needs a model at the C
    ABI boundary, where a Zig "must outlive" contract can't be expressed — so the
    credential-lifetime redesign belongs there, as a hard gate before the C ABI
    ships. The Zig API stays borrowed-consistent.
  - H17 — HKDF passes `Prk` and `TrafficSecret` by value.
    These signatures permit compiler-generated copies. They do not prove
    unwiped stack bytes in a particular binary. #125 tracks the source,
    disassembly, and zeroization audit. Explicit handshake locals have wipes.
  - Zeroing responsibility at the caller-owned-buffer boundary is now decided
    and documented rather than accidental (#81). `SliceBuffer.secureZero`
    zeroed the view's own 24-byte header — the fat pointer, its length, and
    `len` — and not the storage it pointed at, so `ClientHandshake.deinit`
    left the retained certificate chain byte-for-byte intact in caller memory
    while reading as though it had cleared it. The two reassembly buffers were
    cleared by nobody at all. Resolved by deleting the method: engines zero the
    secrets they hold inline and never write to memory they were lent, matching
    `RecordBuffer`, which holds decrypted application plaintext over caller
    storage and has never had a `secureZero`. Callers own clearing, stated on
    `useHandshakeBuffer`, `usePeerCertificateBuffer`, and `RecordBuffer.init`,
    and pinned by `deinit leaves caller-owned buffers to the caller` in both
    engines. `integrations/ztls-std` discharges the obligation for every buffer
    it declares, gated by `deinit zeroes the wrapper's own buffers, including
    the retained chain`. Note this is a hygiene and honesty fix, not a
    disclosure fix: certificates are public, and the reassembly buffers hold
    whatever handshake plaintext spanned a record boundary.
  - H20 — the high-level client record path constructs its Finished immediately
    after the server Finished. The `.send_finished` state alone does not prove
    a general 0.5-RTT interoperability failure. #124 tracks focused evidence
    for coalesced server data and low-level API sequences.
  - H21 (remainder) — SHA-1 chain signatures are in fact ALREADY rejected at the
    policy layer (`verifyChainCertificateSignatureAlgorithms`). #126 tracks
    the remaining IDNA and A-label contract. The rfc822/URI name-constraint
    item (#75) was fixed separately.
  - #75 (fixed) — rfc822Name/URI bare-host name-constraint escape: bare-host
    constraints (no leading `.`) now do exact host matching per RFC 5280
    §4.2.1.10, instead of being routed through `dnsNameInSubtree` (subtree
    match). Leading-`.` constraints keep subtree semantics. The differential
    test against OpenSSL 3.6.3 now agrees on every case.
  - #88 (fixed) — externally reported availability vulnerability
    (`p256`/`p384` `KeyPair.generate()` retried a non-retryable backend error
    forever: 100% CPU livelock when the crypto backend cannot allocate —
    reported at gh #88, originally zoxy-io/zoxy#222). Finding 1 (livelock) is
    fixed and regression-tested: the retry is bounded at 4 draws and retries
    only `IdentityElement` (an invalid scalar, range-checked against the
    group order through the backend BN/group APIs before any point math);
    `LibcryptoFailed` propagates on the first occurrence; `KeyPairs.init` is
    fallible at every call site; ztls-std maps the local failure to
    `InternalError` with the owned socket closed and `deinit` still a no-op;
    and the retry policy itself is pinned by comptime-draw tests on both
    curves, in which a regressed `catch continue` fails the error/count
    assertions instead of hanging. Finding 2 is fixed: the library-side
    residue is eliminated and regression-tested on all three
    backends — every outermost public fallible backend wrapper (shared EC
    P-256/P-384 key construction and ECDH, X25519, key loading, signature
    sign/verify, key-scheme inference and cert/key pairing checks (#112,
    #113), KEM, and the per-record AEAD seal/open paths) brackets its
    libcrypto calls with `ERR_set_mark`/`ERR_pop_to_mark`, so a handled
    failure removes exactly the queue entries it pushed and preserves the
    caller's, up to the per-thread ring capacity (16 slots, 15 usable —
    beyond that libcrypto itself evicts the oldest entries, including the
    caller's). Backend limitations are documented on the guard:
    DER/PEM key loads cannot preserve pre-existing caller entries on the
    BoringSSL-family backends (their d2i key parsers call `ERR_clear_error`
    between parse fallbacks, destroying the caller's entries and the mark
    before the guard's pop runs; the wrapper still leaves no residue of its
    own there — pinned by a lane-dependent test), the #113 cert/key
    pairing check has the same caveat class on the aws-lc lane (its
    d2i_X509 reaches an unconditional `ERR_clear_error` during SPKI
    conversion on every parse, while BoringSSL clears only on SPKI decode
    failure and OpenSSL does not clear on this path — pinned by the
    lane-dependent #113 hygiene test), and a caller's pending
    `ERR_set_mark` is consumed on those backends even when the wrapper
    pushes nothing (per-entry boolean flag; the caller's entries survive
    until the caller's own later pop). The guard is non-nested by
    construction (the one nesting case, `privateKeyFromP256Scalar` → the
    shared p256 secret-loading impl, is factored into an unguarded impl
    behind two guarded fronts) because the pinned BoringSSL-family err
    sources (aws-lc 5.5.0, boringssl 0.20260803.0) mark with a per-entry
    boolean flag, which nested mark/pop would let the outer pop drain the
    caller's entries; that convention is load-bearing and pinned by a test
    that goes red on the AWS-LC lane under a nesting mutation (OpenSSL's
    counted marks make the same mutation benign there). Queue hygiene is
    proven by facade tests that were red pre-fix on OpenSSL and AWS-LC (OpenSSL
    3.6.4 — the devshell version actually linked for these runs: EC
    residue, caller-preservation, repeated-failures-empty; AWS-LC
    additionally: bad-signature, bad-tag-decrypt, and DER-key-load
    residue) and by mutation checks (guard removal, over-drain to
    `ERR_clear_error`, reintroduced nesting). Allocation behavior is
    asserted by a dedicated standalone executable (`zig build
    errq-alloc-check`, OpenSSL and AWS-LC lanes; wired into `just test`) that
    installs counting `CRYPTO_set_mem_functions` hooks before any libcrypto
    call and, after fully warming the exact failing operation and clearing
    the warmup errors, asserts that each further failing guarded call
    (malformed EC key share, per-record AEAD tag rejection, and the #114
    declined encrypted-PEM load) returns the live-allocation count to the
    baseline snapshot — the
    memory assertion runs before the queue assertion, and with the guards
    removed the executable fails on the memory axis (`AllocationGrowth`),
    as it also does under a deliberate per-call libcrypto-allocated leak in
    `errqExit`. That check remains allocation-count retention evidence, not
    recovery-after-exhaustion: the hooks count and never fail, and
    realloc-based byte growth is invisible to the counts (documented in the
    executable). BoringSSL has no `CRYPTO_set_mem_functions`, so the
    counting-hook check cannot exist there (queue hygiene still applies).

    End-to-end fixed-arena recovery is separately proven against public
    historical zoxy commit `6e13999` (the bounded-keygen revision before
    zoxy v0.2.1 enlarged its 4 MiB heap). Under the original 700-connection,
    5,000 request/s, 15-second trigger dimensions, the same one-CPU zoxy
    configuration with baseline zoxy-io/ztls `634567a` recorded 46,204
    crypto-allocation sheds after load and failed all three later TLS probes;
    each probe added another shed. The guarded Zig 0.16 port of this source
    recorded 10,075 sheds, then answered TLS, plaintext, and admin probes after
    cumulative waits of 6, 21, and 51 seconds; its shed count stayed fixed and
    completed TLS handshakes advanced from 676 to 678. A diagnostic one MiB
    A/B also counted allocator-hook null returns directly: the guarded build
    returned null 46,310 times during load and still completed all later TLS
    probes, while the baseline counted 115,749 failures and completed none.
    The one MiB heap and hook counter are diagnostic only, not proposed zoxy
    changes. Current zoxy no longer embeds ztls, so the historical revision is
    the closest public reproduction of zoxy-io/zoxy#222. Harness, source
    patches, complete logs, metrics, and checksums:
    `docs/research/ERRQ_88_ARENA_RECOVERY/20260914-zoxy/`.
    The full-cleanup guard is accepted with a measured local record-path cost:
    approximately 18–24 ns on 10 of 12 rows, with two noisier 16 KiB decrypt
    rows at 34–37 ns;
    the smallest AES-GCM rows regress about 19–21%. Minimality of that cost
    is unproven. Raw capture and independently audited corrections:
    `docs/research/perf/20260913-012750-launchpad-errq/` and
    `docs/research/perf/20260913-020140-launchpad-errq-addendum/`.
  - H22 — `entropy.fillLinux` panics on an unexpected `getrandom` errno.
    Decision: keep the fail-stop for the entropy source. For a CSPRNG,
    proceeding without entropy is never acceptable; the only reachable
    errnos are EINTR/EAGAIN (handled) or EFAULT/EINVAL/ENOSYS, which indicate
    a ztls or kernel bug, not a recoverable condition. That is consistent
    with BoringSSL/AWS-LC backends, which abort on RAND failure. Backend key
    generation is now separately fallible (#88): `p256`/`p384` `generate()`
    return `p256.Error` — bounded retry of a bad draw, terminal propagation
    of a backend failure — as does `KeyPairs.init`; only `x25519.KeyPair.generate()`
    stays infallible (clamping makes an invalid scalar unreachable). The
    fail-stop contract is documented on `entropy.fill` and on the `generate()`
    convenience constructors (x25519/p256/p384), and the `getrandom` abort now
    emits an actionable errno message (`ztls: OS CSPRNG getrandom failed with
    errno {d}; cannot generate key material without entropy`) so embedders can
    diagnose the root cause rather than seeing a bare library panic. H12 (post-handshake KeyUpdate counter) is
  deliberately NOT taken as specified: the audit's "don't reset on app data"
  would make the bound a lifetime cap of 16 KeyUpdates and break long-lived
  high-throughput connections; the current reset-on-app-data burst counter
  matches Go's `maxUselessRecords` model. A sound refinement (separate
  NST/KeyUpdate accounting with a research-backed burst limit) is a design call,
  flagged rather than auto-applied.
- Targeted client-side bad-server tests for malformed ServerHello, unexpected
  flight messages, bad CertificateVerify and Finished checks, corrupted
  encrypted records, client-emitted alert descriptions, peer fatal alerts,
  illegal pre-handshake application data, unexpected post-handshake inner content
  types, and truncated-record framing robustness.
- `docs/research/RFC8446_MUST_MATRIX.md` maps TLS 1.3 normative requirements
  to tests, caller-boundary decisions, or explicit out-of-scope feature issues.
  The PSK/resumption (R002-004) and 0-RTT (R002-005) rows remain `PARTIAL`
  because each combines proven engine mechanics with obligations the Sans-I/O
  boundary assigns to the caller: opaque ticket persistence, expiry, rotation,
  replay rejection, and SNI partitioning for resumption, and 0-RTT anti-replay.
  Neither row requires a ztls-owned global ticket or replay cache; the engine's
  0-RTT default stays disabled, and the caller supplies the replay policy it
  can actually observe.
- `docs/research/NEGATIVE_SPACE.md` inventories supported-surface malformed and
  malicious peer inputs, mapping each to ztls's response and evidence or an
  explicit gap.
- `docs/research/THREAT_MODEL.md` defines the in-scope attacker, defended
  attack classes, non-goals, caller responsibilities, and threat-relevant gaps.
- Explicit verification gates (client must verify Certificate / CertificateVerify
  / Finished before promoting to app keys; server must verify client Finished).
- RFC 5280 name constraints are enforced in the certificate path for DNS, IP,
  rfc822Name, and URI GeneralName forms, including permitted/excluded subtree
  tests, bare-host exact-match for rfc822/URI (§4.2.1.10), critical
  unsupported-subtree rejection, and a differential test corpus against OpenSSL
  3.6.3 covering all four GeneralName forms (#75 resolved).

**Status:** `PARTIAL` — #118 passes local and GitHub gates.
Candidate consumer and conformance evidence passes at `b9d03ed`.
Resource and policy residuals under #121–#126 remain separate requirements.
The #91 fixture regressions and #108 conformance captures retain their historical provenance.

**Evidence and design decisions:**

- **External runner coverage is still partial.** Full TLS-Anvil execution is
  not in PR `just ci`, and BoGo is explicitly deferred per
  `docs/research/BOGO_DEFERRED.md`. The completed strict server/client captures
  account for endpoint-mode `not_attempted` rows, including the `tests.both.*`
  length-field rows that are role-specific despite their package name. TLS-Anvil
  normalization and wrapper-helper tests are gated. The real TLS-Anvil server
  and client suites run in separate scheduled/manual workflows. Historical #91
  runs have strict-clean evidence under the visible #52 `expected_failed`
  classification. The #108 runs of both workflows are strict-clean on all
  three backends at clean `d07c551`. Plain P-384 has bidirectional OpenSSL 3.6
  interoperability on every non-FIPS backend lane. TLS-Anvil has no RFC 10024
  suite, so the three hybrid groups use the same bidirectional OpenSSL matrix
  plus the pinned upstream tlsfuzzer ML-KEM driver: 35 sanity, per-group,
  malformed/truncated/padded-share, point-format, and HRR conversations pass.
  In-memory direct and HRR handshake matrices remain the deterministic core
  regression evidence *(#6)*.
  HelloRetryRequest server retry now passes TLS-Anvil, and client-side HRR consumption for
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
  and the full TLS-Anvil server/client suites run in scheduled/manual workflows.
  Historical commits retain strict-clean captures with 437 completed tests.
  The #108 manual runs of both scheduled workflows are strict-clean across all
  three backends at clean `d07c551`. BoGo is explicitly deferred
  (`docs/research/BOGO_DEFERRED.md`).
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

- **EstablishedSession extraction (#115, core proven; integration not yet
  wired):** `ServerHandshake.extractEstablished()` hands a connected server's
  post-handshake life to a compact `ztls.EstablishedSession` — 736 bytes vs
  the handshake engine's 19,408 on the OpenSSL lane (26x), 1,872 vs 21,120 on
  AWS-LC 5.5.0 and 1,856 vs 21,088 on BoringSSL (inline AEAD contexts;
  >11x), measured Zig 0.15.2 aarch64-linux with a comptime `@sizeOf`
  probe, asserted in a size test — preserving the rx/tx record layers and sequences,
  application traffic secrets, an in-flight KeyUpdate fragment, the
  consecutive-KeyUpdate counter, the last peer alert, an owed KeyUpdate
  response, and the pending-write latch. The connected record paths (record
  classification, KeyUpdate reassembly/ratchet/response, encrypted alerts,
  flood cap, latch) are shared implementations in handshake.zig used by both
  engines — no duplicated engine. Extraction is a move: the handshake engine
  transitions to `.extracted`, never touches the moved backend contexts again,
  and its `deinit` stays safe to call immediately (it wipes only its own
  duplicated secret bytes); it is valid exactly once at `isConnected()`
  (asserted, along with userspace TX, no pending ticket, and no early-data
  layer); both record directions must be userspace — TX ownership is
  asserted, RX ownership is untracked and documented as a caller contract on
  the seam and in `docs/USAGE.md`. Extraction wipes the record-layer bytes
  left behind in the consumed engine immediately (`RecordLayer.
  secureZeroMovedFrom`: no context release, so the moved copies stay live) —
  on AWS-LC and BoringSSL those bytes are the live inline traffic keys, and
  on OpenSSL the key/IV duplicates plus stale context pointers. Tickets must
  be issued before extraction — documented on the seam and in
  `docs/USAGE.md`. Evidence: twelve new RFC-cited tests in
  `ServerHandshake.zig`, including a deterministic differential test that
  drives a kept-connected control engine and an extracted session with the
  same record sequence and requires identical events and byte-identical
  KeyUpdate response records, plus four mutation checks (removing the
  ownership transfer segfaults through the double-freed EVP context on the
  OpenSSL lane; removing the flood-cap reset and removing the obligation
  carry each fail their exact assertions; replacing the moved-from wipe with
  `= undefined` fails the all-zero wipe assertion in BOTH Debug — where
  undefined poison (0xaa) is non-zero — and ReleaseFast, where `= undefined`
  is a no-op and the live keys remain: the discriminating ReleaseFast run is
  recorded, not just the Debug one). The isolated slice's core test gate was green on
  OpenSSL/Zig 0.15.2 Debug and ReleaseFast (803 pass, 1 lane skip each, of
  804), AWS-LC 5.5.0 Debug and ReleaseFast (804 pass each), and BoringSSL
  Debug (797 pass, 7 lane-specific skips), plus the same gate under Zig
  0.16.0: OpenSSL 803 pass/1 skip, AWS-LC 804 pass, BoringSSL 797 pass/7
  skips (`just check-backends-0_16`) — the test gate of each lane, not the
  bench/conformance legs of the full recipes. The
  refAllDeclsRecursive failure that sank the first prototype
  (c4faadc/eceb2fd, reverted in dc8868b/e585ae1) is diagnosed and fixed
  rather than hidden: a pub `= @This()` self-alias is a self-referential
  public declaration, and test.zig's runtime-recursive coverage helper
  follows it without bound (stack overflow); EstablishedSession now follows
  the repo's private-alias convention, and the root export is covered by the
  full refAllDecls walk. After integration with #103, #111, and #114,
  `just ci`, `just check-backend-boringssl`, and `just ci-0_16` passed on
  aarch64-linux: 829 core tests (OpenSSL 828 pass/1 skip, AWS-LC 829 pass,
  BoringSSL 822 pass/7 skips). Zig 0.16 integration validation first caught
  the server footprint ceiling (measured 135,088 bytes; revised ceiling
  135,256, exact buffer deltas unchanged), then a socketpair test closing
  before its peer finished sending. Draining the remaining payload before
  teardown fixed that race; the integration suite passed five additional
  runs. Wrapper/example adoption (ztls-std pooling, an example) is deliberately
  not wired in this slice.
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
  deterministic examples also run under Zig 0.16 via `just ci-0_16`
  (CI-gated), covering the `std.Io.net` transport
  boundary for TCP loopback plus the raw-fd epoll and io_uring examples.
  The 0.16 lane runs the full core gate (test + lint + examples +
  conformance); two `ziglint-ignore: Z011` inline suppressions bridge
  `mem.indexOfPos`/`std.meta.Int` deprecations that are inherent to
  dual-version support until 0.15 is dropped. *(#58, #61)*
- CI still does not execute manual peer-dependent demos such as `https_client`,
  `https_server`, or `iouring_client`; those demos now compile on both Zig
  0.15.2 and Zig 0.16 and exit non-zero when the peer or io_uring support is
  unavailable, so they cannot be mistaken for proof if wired into a gate later.

**Status:** `PROVEN` for the core Sans-I/O surface. The higher-order
`std.Io.net` wrapper is tracked separately below as `PROVEN`.

**Gaps:** none for the supported adoption path through the core engine.

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
client lifecycle: `ztls_client_init_insecure`, `ztls_client_deinit`,
`ztls_client_start`, `ztls_client_handle_record`,
`ztls_client_complete_write`, `ztls_client_send_application_data`,
`ztls_client_is_connected`, `ztls_client_selected_alpn`, plus
`ztls_version`, `ztls_client_size`, and `ztls_client_align`. The
opaque-sized approach is used: the C consumer allocates
`ztls_client_size()` bytes with alignment `ztls_client_align()` and
passes the pointer to `ztls_client_init_insecure`; the internal layout is
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
`ZTLS_ERR_NULL_PARAMETER` before entering the Zig engine. A KeyUpdate carrying a
response surfaces as `ZTLS_EVENT_WRITE`; NewSessionTicket (and a no-response
KeyUpdate) map to `ZTLS_EVENT_NONE` without wedging. Certificate verification is
deferred to #30: the sole init is the explicitly-named
`ztls_client_init_insecure` (no server authentication), so an unauthenticated
client cannot be created unknowingly.

**Deferred (tracked under #30):** server-side C ABI shims, RecordBuffer
C ABI, certificate verification, KeyUpdate initiation from C, PSK /
session resumption from C, ALPN offering from C (query is implemented,
offer is not), dynamic linking (`libztls.so` / `libztls.dylib`), and C
conformance harness integration (TLS-Anvil through the C ABI per
`docs/research/C_ABI_CONFORMANCE.md`). The C ABI is not claimed done.

---

### `std.Io.net` wrapper — ztls-std (#77) — PROVEN

`integrations/ztls-std/` is the reference higher-order integration: an
opinionated TLS 1.3 stream over Zig 0.16 `std.Io.net`. It is a separate
workspace with its own `build.zig`, `build.zig.zon` (path dep on the core), and
`justfile`; the root delegates through `just integrations-ci`, which is wired
into `just ci-0_16` and therefore runs in the `test-zig-0_16` CI job. The 0.15
lane cannot build a 0.16-only integration and does not gate it.

**Landed and gated.** `Client`/`Server` are the connection types
(`StreamImpl(Hs, role, config)`), with eager `connect`/`accept`, `Io.Reader`/
`Io.Writer` interfaces, `socketHandle`, `hasBuffered`, `info`, and the
`closeWrite`/`abort`/`close`/`deinit` lifecycle, and client authentication
(mTLS) on both roles. `just integrations-ci` runs lint plus 50 tests: 36
fixture-backed socketpair tests, six wrapper-level OpenSSL interoperability
tests, five API tests, two client-example tests, and one smoke test. An API
preflight test rejects invalid hybrid options without creating a socket;
`connect` and `accept` repeat validation before key generation or wire I/O.

**Wrapper interop is CI-gated in both directions, including mTLS.**
`ztls_std.Client` negotiates
TLS 1.3, AES-128-GCM, and `http/1.1` with `openssl s_server`, then exchanges an
HTTP request and response through the public Reader/Writer surface.
`openssl s_client` verifies the fixture-backed `ztls_std.Server` certificate and
hostname with `-CAfile -verify_return_error -verify_hostname`, negotiates the
same suite and ALPN, exchanges application data, and exits cleanly. Neither test
has a skip path when OpenSSL is absent, and the test run is marked side-effectful
so the build graph cannot substitute a cached non-execution. The same holds for
the two mTLS directions: `ztls_std.Client` presents the client fixture
certificate to `openssl s_server -Verify -verifyCAfile -verify_return_error`
(a failed client-cert verification aborts the handshake, so a completed
exchange proves OpenSSL verified the wrapper's credentials), and
`openssl s_client -cert -key` with a generated clientAuth certificate
interoperates with a requiring `ztls_std.Server` that verifies against a
caller-owned `Bundle` with the real clock, retains the leaf, and surfaces the
exact generated DER through `info().client_identity`. Negative interop is
also gated: a credential-less wrapper client receives OpenSSL's fatal alert,
and a credential-less `openssl s_client` decrypts the requiring wrapper
server's post-Finished `certificate_required` alert (number 116) while the
server reports `ClientCertificateRejected`.

The following client-authentication properties are gated by socketpair tests
rather than asserted in prose:

- **Client credentials are caller configuration.** An empty
  `client_credentials.cert_chain` is rejected as `InvalidOptions` before any
  wire I/O (the peer sees a bare EOF, and the failure path keeps the
  owned-socket close and deinit-is-a-no-op contract); a signer scheme the
  server's CertificateRequest cannot carry maps to `InvalidOptions` too.
- **Server-side identity retention is exact and bounded.** A requiring server
  with `Config.client_identity_storage` retains the exact client leaf DER
  (`client auth: required insecure mTLS retains the exact client leaf DER`),
  zeroes that storage on teardown, reports a null identity when an optional
  client sends no certificate, and surfaces undersized storage as
  `HandshakeBufferTooShort` rather than `ClientCertificateRejected`
  (`ClientCertificateTooLarge` reclassified `.buffer` in the core `classify`
  table for exactly this reason).
- **Fatal alerts are specific and use the correct key epoch.** The wrapper
  deleted the coarse `errors.alertForClass` (wrapper-only since the
  integrations stopped sharing it) and sends alerts through the canonical
  per-error `ztls.alert.alertForError` table — pinned for
  `SignatureVerificationFailed` -> `decrypt_error`, `AuthenticationFailed`
  -> `bad_record_mac`, `MissingTrustAnchor` -> `unknown_ca`,
  `CertificateExpired` -> `certificate_expired`, and silence after
  `PeerAlert` (RFC 8446 §6.2 says do not reply to a peer that already
  aborted). The core advances the server write direction to application keys
  immediately after encrypting its Finished while retaining the client
  handshake read key until the client Finished verifies. A core pair test
  proves a `certificate_required` rejection decrypts only under the client's
  application receive key, and a rollback test proves failed flight encryption
  keeps the handshake write epoch and clears the uncommitted application
  secret (RFC 8446 §4.4.4).

The following correctness properties are gated by tests rather than asserted in prose:

- **Connected streams support split halves.** One reader and one writer can run
  concurrently. RX never owns TX state. One `std.Io.Mutex` serializes each TX
  record through encryption, transport completion, and `completeWrite()`.
  Deterministic gates force a blocked read before the writer starts.
- **KeyUpdate handoff preserves wire order.** RX publishes
  `update_requested` before it waits for TX. The reader, writer, and
  `closeWrite` all drain that request under the TX lease. Peer-side core
  decryption proves that the response precedes application data and
  `close_notify`. It also proves that each record uses the correct key epoch.
- **Incomplete TX is terminal.** A test transport reports seven bytes of
  progress and then `SocketUnconnected`. The first flush reports that exact
  cause. The pending-write latch remains set. Later sends report `TxPoisoned`
  and cannot reuse the sequence number.
- **Abort precedes teardown.** `abort()` shuts down both transport directions
  and wakes blocked reads and writes as `TlsAborted`. A test transport blocks
  after record encryption and wakes only through `netShutdown`. Both tests join
  the active half before `deinit()` clears the connection. `close()` and
  `deinit()` assert that no reader or writer vtable call remains active.
- **The reader honors the whole `Io.Reader` contract.** An earlier revision
  repointed `interface.buffer` at the decrypted record in place — zero copy, and
  legal per the vtable contract — which made the reader's capacity equal to the
  current record's length. `peek(n)` past the record and
  `takeDelimiterInclusive('\n')` (HTTP header parsing) then hit
  `assert(seek == end)` in Debug and silently discarded the unconsumed tail in
  ReleaseFast. `stream` now copies into the destination the generic layer
  supplies; `reader: peek past the current record keeps the unconsumed tail` and
  `reader: takeDelimiterInclusive spans a record boundary` pin the fix, and
  `reader: a line longer than read_buffer reports StreamTooLong` pins the bound.
- **Handshake failures reach the peer.** RFC 8446 §6.2 fatal alerts are sent
  before the socket closes. `connect: hostname mismatch surfaces as
  CertificateVerificationFailed` asserts the ztls server peer observes
  `TlsAlertReceived` rather than a truncated connection; manual verification
  against `openssl s_server` shows `SSL alert number 42` (`bad_certificate`).
- **Peer alert detail is observable (#85).** Both handshake engines retain
  the most recent non-close_notify peer alert and expose it via
  `lastPeerAlert()` (RFC 8446 §6.2). Tested per return site (3 client, 4
  server): exact level/description on plaintext, encrypted-handshake, and
  connected paths for both roles; unknown non-exhaustive codes preserved
  verbatim; a later alert replaces an earlier one while close_notify (§6.1)
  and malformed records leave the stored value unchanged; deinit+reinit
  starts null. Mutation-checked red/green (storage removed → detail
  assertions fail with `TestExpectedEqual`). Green under Zig 0.15.2 and
  0.16.0 (`zig build test`). Wrappers (ztls-std/ztls-xev, C ABI) do not
  propagate the detail; open scope.
- **Error classification is exhaustive by construction.** One `classify` table
  covers the union of every core handshake error set with no `else` arm, so
  adding a core variant is a compile error in the integration until it is
  classified. Two role projections mean the same core error can mean different
  things per role (`UnsupportedCipherSuite` is negotiation for a server,
  `illegal_parameter` for a client). A local keygen failure (#88) is
  deliberately outside that table — it is not a peer event and predates
  in-place init, so `connect`/`accept` map it straight to `InternalError`
  after closing the owned socket and marking the Stream closed, keeping the
  documented `deinit`-is-a-no-op contract on every failure path. That gap is
  what caught PR #89 shipping with `try` on errors absent from
  `ConnectError`/`AcceptError`: the 0.16 lane did not compile.
- **Buffer footprint is configurable and pinned.** `Config` sizes record
  staging, reassembly, read look-ahead, write staging, and optional peer-chain
  retention at comptime. Defaults measure 151_856 bytes (client) and 134_928
  (server); `Config: buffer sizing is the whole story of the Stream footprint`
  asserts each knob's exact `@sizeOf` delta.
- **Post-handshake failures are diagnosable.** The `Io.Reader`/`Io.Writer`
  vtables can only carry `ReadFailed`/`WriteFailed`, which on their own cannot
  distinguish a cancelled task from a forged record from a dead socket. The real
  cause is now recorded before the narrow error is returned and recovered with
  `readError()`/`writeError()`, following the `std.Io.net.Stream.Reader.err`
  convention. Gated by four tests covering `TlsDecryptError` (forged record),
  `TlsAlertReceived` (peer abort), `IdleRecordFlood`, `TlsClosed`,
  `TlsAborted`, and `TxPoisoned`, plus a null-on-healthy-connection case.

**Runs on any `std.Io`, proven not asserted.** zio
(<https://github.com/lalinsky/zio>) is a stackful-coroutine runtime that ships a
full `std.Io` implementation, so ztls-std runs on it with zero adapter code:
`rt.io()` goes straight into `Client.connect`. `examples/zio_client.zig` is the
proof and is compiled by `just integrations-ci`; zio is a lazy dependency so
consumers of ztls-std do not fetch an I/O runtime. Deliberately **not** a
`ztls-zio` package: it would duplicate the drive loop, the reader/writer vtables,
and the error table with `Io` replaced by `Io`, which is the duplicate-artifact
failure mode. `ztls-xev` (#76) and `ztls-ktls` (#78) still warrant their own
packages because libxev is a callback-based completion loop with its own API and
kTLS is a kernel offload; neither implements the interface ztls-std targets.

That example also closes the timeout gap by demonstration rather than by API:
the whole exchange races a sleep through `Io.Select`, and a fired deadline arrives
as `error.Canceled` via `readError()`. Measured against `example.com`, both
phases: `handshake cancelled by the deadline` and `transfer cancelled by the
deadline (recovered as error.Canceled)`. Before the `err` convention landed, the
identical experiment reported a bare `ReadFailed`.

### libxev — ztls-xev (#76) — PROVEN

`integrations/ztls-xev/` is the completion-driven integration. libxev does not
implement `std.Io` — it borrows `std.Io.net.IpAddress` as a type and nothing else
— so unlike a `std.Io` runtime it needs a real adapter rather than working through
ztls-std unchanged. Separate workspace, own `build.zig`/`justfile`, own
`nix develop .#ztls-xev` shell; gated by `just integrations-ci` inside
`just ci-0_16`.

**Landed and gated.** Both roles. `Conn(role)` is one implementation
parameterised by client/server, exported as `Client` and `Server`: they share the
pump, the wire queue, both I/O paths, and teardown, differing only in which
engine they drive, how the handshake opens, and whether a server flight is owed.
`ClientConfig` (one trust-store load) and `ServerConfig` (one chain and signer)
are both shared across connections. Surface is
`init`/`handshake`/`read`/`write`/`close`/`closeReset`/`deinit` plus `state`,
`selectedAlpn`, and `cipherSuite`.

28 tests cover configuration, connection behavior, credentials, and address
resolution. The client round trip drives a real `xev.Loop` against a blocking
ztls server on a thread. Server tests run both roles on one loop over a
socketpair. Configuration tests prove that both constructors reject local
hybrid faults, and that client policy validation precedes trust-store allocation.
The server example uses `openssl s_client` with X25519MLKEM768 and ALPN across
repeated connections on one shared configuration.

The API is not a port of ztls-std, and the reasons are structural rather than
stylistic. ztls-std's drive loop owns the stack (`while (!isConnected())
blocking_read()`); `Conn.pump` is that loop inverted, with every local promoted to
a field and each completion re-entering it. `Io.Reader`/`Io.Writer` cannot be
offered at all, because `stream()` must produce bytes or fail and has no way to
say "call me back" — so ztls-std's drop-in byte-stream seam has no analogue here
and callers get explicit callback operations. `ztls.errors.classify` is shared, so
both integrations project from one exhaustive table.

Shape follows a proven server-side libxev TLS integration rather than being
invented: exactly-once callbacks including for synchronous failures, typed `ctx`
with completions hidden inside `Conn`, state-gated operations that *deliver*
`Closed`/`Concurrent` rather than asserting, and caller-owned buffers as runtime
slices so a server can pool them.

`ReadResult` splits `close_notify` from `eof`, which ztls-std cannot do
(`std.Io.Reader` has one `EndOfStream` for both). Observed on real traffic:
`www.cloudflare.com` completes with `close_notify` after 1_304_478 bytes across
many records, while a peer that drops mid-request yields `eof` with the
bytes-so-far.

**Both backends validated.** The Linux lane (io_uring) is CI-gated through
`just integrations-ci`. macOS (kqueue) is a recorded manual run: 21/21 on
`Darwin arm64`, 2026-07-25. That run is evidence for kqueue *by name*, not merely
for "a Mac" — `test "libxev backend matches the platform"` asserts
`xev.backend == .kqueue` on Darwin and fails with the actual backend otherwise.

Getting there found a real portability defect that a fully green Linux lane had
hidden. libxev dispatches socket close to a thread pool on the readiness backends
but not on io_uring, so with no pool the close fails `ThreadPoolRequired` and the
fd is never closed — both peers then wait forever. Reproduced on Linux under epoll
(`pool=false: read_cb=false`; `pool=true: read_err=error.EOF`) rather than by
guesswork, and fixed by requiring a pool with an assert at `Conn.init` on the
backends that need one. The lesson is the durable part: io_uring is the permissive
backend, and single-backend coverage is not backend coverage.

**In-flight cancellation (#83):** regression tests cover reads and writes,
abortive and orderly, on io_uring, epoll, and kqueue. ztls-xev pins libxev
`7497c85`, the exact head of mitchellh/libxev#224. Its kqueue deletion flush
prevents stale events after `tick(0)`. The macOS lane executes all four variants;
[the acceptance capture](docs/research/XEV_KQUEUE_83/20260914-production/README.md)
preserves the pin, mutation, test, and probe evidence. The epoll fix works
around what looks like an upstream libxev defect: its epoll TCP watcher
duplicates the fd per operation and the normal completion path closes that
duplicate, but the cancellation path (`stop_completion`) only does
`epoll_ctl(CTL_DEL)` and never closes it. A cancelled read therefore leaks a file
descriptor, and the retained duplicate keeps the socket endpoint alive so the
peer never observes EOF after the original fd closes. `Conn` serializes transport
completions, so the duplicate buys nothing here and is cleared before
registration, with asserts so an upstream change fails loudly. Reported
upstream as mitchellh/libxev#231 (dup leak and endpoint survival),
mitchellh/libxev#230 (the cancel branch testing the cancel's own state instead
of the target's — panic on dead targets, silent deregistration on recycled
fds), and mitchellh/libxev#233 (io_uring cancel matching reused `user_data`).

The write case turned out to be a different defect class than the read case, and
a nastier one. Keeping a write in flight takes a full pipe (`SO_SNDBUF` clamped,
peer never reads), and on a blocking fd io_uring runs that write as a kernel
worker thread blocked in the syscall. Canceling it promptly — the exact shape a
deadline-driven close takes — interrupts the syscall, and libxev's io_uring
write path re-arms on EINTR: the operation resurrects as a zombie that outlives
the close, and its late completion (EPIPE, once the peer finally goes away)
lands on the `Conn` after `deinit` has released it. A use-after-free, found by
the regression test on its first run (bus error at 0xaa, three of three runs).
The retirement that actually works on io_uring is `shutdown(2)`: the blocked
syscall fails promptly with EPIPE and the write's own callback resumes the
close, proven by `probe/stuck_write_cancel.zig` (BrokenPipe on the tick after
the shutdown; cancel of the same stuck write only ever worked when it landed
~25ms late, which is why the earlier probes missed the race). Reads still
retire by cancel on io_uring, and everything on the readiness backends retires
by `epoll_ctl(CTL_DEL)`. The close sequence also gained a `retire_pending`
gate: the socket close waits for the retire op's own completion, so the close
callback — and the caller's `deinit` — can no longer outrun it. That gate is
defense against CQE ordering variance rather than a locally reproducible
sequence; the shutdown retirement itself is mutation-checked (reverting it
fails the write test deterministically). The orderly close with a canceled
write degrades to no `close_notify` by design: the half-sent record has already
desynced the peer's stream and the engine's pending-write latch stays set, so
`sendAlert` refuses and the close proceeds to the socket; a `close_notify`
after half a record would be un-authenticatable garbage.

The former abortive-read failure reached `phase = .released`, but its socket
close callback never fired and `Loop.active` reached zero. Run `34742256947`
reproduces that state at diagnostic revision `f3d0a0e`. The tick-local deletion
was discarded on `wait == 0`. A stale EOF then re-fired and decremented `active`
for an already retired read. The loop gate blocked thread-pool completion
migration. Run `34742815211` passes the same test with only the deletion-flush
hunk. The production pin adopts the reviewed upstream revision that contains
that hunk.

Two hypotheses were tested against real macOS runs and both are dead: libxev
mis-accounting `active` on the cancel path (a single-socket probe comes back
clean on kqueue — `close_cb=true`, `peer=EOF`), and completion lifetime (the
stall is unchanged with `Conn.deinit` disabled in that scenario).

What the two-peer probe found instead is an outright libxev crash on kqueue —
pure libxev, no ztls — when one peer cancels an armed read and closes while the
other has a read armed:

    .BADF => unreachable
      src/posix.zig:290 in close
      src/backend/kqueue.zig:1285 in perform   (xev_posix.close(op.fd))
      src/backend/kqueue.zig:960 in thread_perform

The thread-pool worker attempted to close an invalid fd. The earlier closer was
not identified from the failure. With libxev `7497c85`, the same probe reports
both close callbacks, peer EOF, `active=0`, and four spins. This proves that the
pinned revision removes the reproduction. It does not attribute that result to
one of the revision's three kqueue changes. The stuck-write probe originally
hung before cancellation because its socket lacked `O_NONBLOCK`. With the probe
fixed, kqueue reports `Canceled`, the close callback, and `active=0`.

**macOS is now CI-gated.** A `macos-15` job runs `just integrations-ci` on kqueue,
scoped to the 0.16 integrations rather than the whole lane (conformance needs a
Python/TLS-Anvil stack never exercised on macOS). That is the durable fix: five
defects here were invisible under io_uring and every one was found because a
person ran a Mac by hand, so the coverage was only ever as fresh as the last
manual run — the 21/21 that closed #76 was stale within a day.

The macOS runner first narrowed the failure to the abortive read. The isolated
hunk then established the deletion-flush mechanism without a timing change.
Separate mutations remove that hunk and fail each write variant with an integer
overflow. The final production-pin run executes all four tests and passes. No
kqueue cancellation skip remains.



Not gaps, recorded here so they are not mistaken for debt: IOCP/Windows is an
explicit non-goal (`AGENTS.md`: "Target platforms: Linux and macOS. No Windows
support, no portability tax."). Client authentication,
`peek`/`consume`/`writeNegotiationPlaintext` for StartTLS-style detection,
key-update initiation, and session resumption are unrequested ztls-xev features
rather than missing work. ztls-xev satisfies the supported #76 contract.

---

Client authentication is wrapper-supported and CI-gated (socketpair + both
OpenSSL mTLS directions above). Server-side retention is deliberately leaf-only
(no full client chain).

The supported concurrency boundary is one reader task and one writer task.
Multiple readers or multiple writers share mutable stdlib staging state and are
not supported. `abort()` wakes active halves. The owner joins both halves before
`close()` or `deinit()` clears state.

No wrapper deadline is imposed. `std.Io` cancellation is the mechanism, and
`examples/zio_client.zig` exercises it. Session resumption and 0-RTT wrappers are
outside the #77 contract. `ztls-ktls` (#78) and independent distribution (#79)
remain separate expansion work.

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
- **The Zig 0.16/Linux kTLS integration is proven for its documented
  surface.** Core still exports copied traffic-key snapshots and the three
  Linux cipher layouts through `RecordLayer.ktlsInfo()` and `ztls.ktls`.
  `RecordBuffer.isEmpty()`, `hasPendingWrite()`, `hasPendingTicket()`, and
  `hasPendingKeyUpdateResponse()` make the one-way activation preconditions
  explicit and prevent application data from overtaking an RFC 8446 §4.6.3
  response. `ClientHandshake.receiveKtlsRecord()` and
  `ServerHandshake.receiveKtlsRecord()` validate kernel-decrypted record
  plaintext while preserving post-handshake counters and RX ratchets;
  `ratchetKtlsTx()` advances an externally sent TX KeyUpdate without producing
  duplicate userspace ciphertext.

  `integrations/ztls-ktls` owns the immediate export → pack → `setsockopt`
  sequence and zeroes every local key copy. Activation rejects read-ahead bytes,
  prepared tickets, pending writes, and unanswered KeyUpdate requests, and shuts
  down partial installs. Successful server activation latches TX ownership in
  the engine so later userspace NewSessionTicket emission fails with a typed
  error. Because a userspace buffer cannot exclude ciphertext racing into
  the socket queue, the handoff contract also requires an application-level
  peer barrier; the live suite forces that ordering. The data plane uses
  `sendmsg`/`recvmsg` ancillary metadata (`TLS_SET_RECORD_TYPE` /
  `TLS_GET_RECORD_TYPE`), dispatches AES-128-GCM, AES-256-GCM, and
  ChaCha20-Poly1305, handles peer- and locally initiated live KeyUpdate, sends
  `close_notify` explicitly, and treats bare FIN as truncation. It probes live
  rekey with an identical pre-send TX reinstall rather than trusting the kernel
  version. Kernels without the TLS ULP/cipher skip the live suite; kernels that
  support initial offload but reject a second install expose
  `.unsupported`, reject local updates before sending, and fail closed on a
  peer update.

  The CI-wired loopback suite exercises all three ciphers, userspace-peer and
  both-kTLS-role paths, crossed live rekeys, empty application records,
  proactive rekey after a coalesced NewSessionTicket, exact empty-buffer,
  flushed-ticket, and answered-KeyUpdate activation, two-record helper
  read-ahead drainage,
  explicit close alerts, bare-FIN truncation,
  and bounded fragmented-KeyUpdate failure. It is green locally on Linux
  7.2.3/aarch64 with the `tls` module
  loaded. The package example supersedes the deleted legacy
  `examples/ktls_server.zig` initial-offload proof, which had no control-record
  lifecycle and neither sent nor verified `close_notify` explicitly. The package
  does both.

  Residual scope is explicit in `integrations/ztls-ktls/README.md`: one
  single-threaded blocking caller; fragmented KeyUpdate is fatal because the
  kernel pauses before exposing its continuation; pre-live-rekey kernels cannot
  recover from a peer update after RX handoff; affected kernels can stay inside
  `recvmsg` on a stream of empty application records; client session tickets
  are not surfaced after handoff; and kernel-owned records do not yet get RFC
  8446 §5.5 preventive usage-limit accounting. Linux can silently select
  device offload on capable NICs; the package neither detects nor disables it,
  and live-rekey behavior there is driver-dependent and unverified. No
  userspace fallback, splice/sendfile, or unsafe no-padding mode is claimed.
  *(#29, #78)*

---

## Pillar 4 — Providers

**Current conformance evidence (2026-09-13 UTC, #91):** clean `e5800ee`
captures completed 437/437 on all three backends with zero unexpected results,
six expected DSA failures each, verified fixture provenance, and no validity
rejections in the enabled diagnostics. Full evidence is recorded under Pillar 1.
This supersedes the earlier failing aggregate for current acceptance, without
claiming a unique cause for every historical failure. Backend availability and
primitive tests remain separate from end-to-end conformance.

**Target:** aws-lc, BoringSSL, and bring-your-own libcrypto behind a clean seam,
each passing the same correctness and interop gates.

**Current evidence (real, but thin):**

- OpenSSL, AWS-LC, and BoringSSL are selected through `libcrypto.pc` and the
  matching headers. `src/crypto/c_openssl.zig` infers the family from
  `OPENSSL_IS_AWSLC` and `OPENSSL_IS_BORINGSSL`. The absence of both macros
  identifies OpenSSL. No backend environment variable or build option exists.
  `-Dcrypto-fips=true` remains an explicit capability policy for OpenSSL and
  AWS-LC. BoringSSL rejects that option. The flake exposes `.#base`, `.#openssl`,
  `.#aws-lc`, and `.#boringssl` devshells. Each backend shell makes its selected
  `libcrypto.pc` ambient while preserving the OpenSSL CLI for interop tools.
  The AWS-LC and BoringSSL recipes verify their include and library paths in
  Zig's verbose build output. TLS-Anvil workflows assert that selected headers
  match each matrix label before they build conformance harnesses. Benchmark
  scripts make the same assertion before they build ztls rows. The BoringSSL
  shell synthesizes `libcrypto.pc` because nixpkgs BoringSSL does not ship one.
  Final local gates passed `just ci`, `just check-backend-boringssl`, and Zig
  0.16 `just ci-0_16` on 2026-09-17. The Zig 0.16 AWS-LC suite passed 766 tests.
  Its BoringSSL suite passed 759 tests and skipped seven capability-specific
  tests. *(#109)*
  AEAD, CertificateVerify signing/verification, certificate public-key
  construction for CertificateVerify, and X25519/P-256 ECDHE dispatch through
  `src/crypto/backend.zig`.
- `src/crypto/backend.zig` exposes a `Backend` enum and an `active` selector.
  The selector combines the inferred family with the explicit FIPS policy.
  The backend owns compile-time capability declarations for
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
  loading and signing through `src/crypto/backend.zig`. Scheme inference is
  provider-backed (#112): `PrivateKey.fromPemAuto(pem)` loads the key and
  derives the CertificateVerify scheme from the exact key type
  (`EVP_PKEY_id`, not base_id — RFC 8446 §4.2.3 assigns a loadable
  rsassaPss-OID key to rsa_pss_pss_*, which ztls does not implement or
  advertise; a backend may also reject that container while loading) and
  curve via the legacy `EVP_PKEY_get0_EC_KEY` →
  `EC_GROUP_get_curve_name` family, then gates the result against the
  active `certificate_verify_schemes` table, so a key that loads but cannot
  sign CertificateVerify on the linked backend (Ed25519, P-521 today) fails
  at load with `error.UnsupportedKeyScheme` — the capability gate is the
  deliberate deviation from a pure metadata mapping, and it auto-opens if
  Ed25519/P-521 CertificateVerify signing lands later. Load-time cert/key
  pairing is provider-backed too (#113): `PrivateKey.pairsWith(leaf_der)`
  parses exactly one leaf with `d2i_X509` and compares through
  `X509_check_private_key`, returning `error.CertificateKeyMismatch` for a
  parsed-but-unpaired leaf and `error.InvalidCertificate` for invalid DER or
  trailing bytes, so startup and rotation can distinguish a wrong pairing from a
  corrupt file; both inputs are borrowed and the parsed X509 is freed inside
  the wrapper. Both paths run on all three backends (OpenSSL, AWS-LC,
  BoringSSL lanes green), proven by RFC-cited tests for matching and
  mismatched EC/RSA material, both PEM containers, every gate/mapping
  rejection, and CertificateVerify-shaped sign round-trips, with mutation
  checks red on the mapping flip, the gate removal, the pairing comparison
  inversion, and removal of the exact-DER trailing-byte check. Encrypted PEM
  input is declined at load (#114): both loaders pass an explicit
  `pem_password_cb` returning -1 — the provider-family convention for "no
  password available" — so an encrypted key (PKCS#8 PBES2
  `ENCRYPTED PRIVATE KEY`, or the legacy `Proc-Type: 4,ENCRYPTED`/
  `DEK-Info` container) fails with `error.LibcryptoFailed` instead of falling
  back to `PEM_def_callback`, which prompts (on the terminal when one is
  attached, and on stderr either way) and reads process stdin (measured
  pre-fix on OpenSSL 3.6.4 and AWS-LC 5.5.0). Encrypted private keys are not
  part of the loader API and no
  caller-owned password API exists yet; `docs/USAGE.md` states the same. The
  evidence is a source-embedded encrypted pair of fixtures (same RSA key as
  `rsa_pss_key_pem`, both containers), an error-contract test per API, a
  lane-independent error-queue residue test (red under errq-guard removal,
  `TestUnexpectedResult`), an allocation-retention round in
  `errq-alloc-check` (red on the memory axis, `AllocationGrowth`, under the
  same guard removal; OpenSSL and AWS-LC lanes, BoringSSL skips the hook
  check by construction), and a standalone `zig build encrypted-pem-check`
  executable wired into `zig build test` that replaces the loader's
  stdin/stdout/stderr with a two-line passphrase sentinel on a pipe and on a
  PTY and asserts no consumption and no prompt text, bounded by SIGALRM and
  non-blocking probe stdin. Mutation: restoring the pre-#114 NULL callback
  turns that check red on OpenSSL and AWS-LC (`PromptWritten` *and*
  `StdinConsumed`), while BoringSSL was already non-interactive (its
  `PEM_def_callback` returns -1 for NULL userdata, documented in
  `openssl/pem.h`), so the change is behavior-preserving there and makes the
  contract explicit on every lane. Encrypted loads were exercised on all six
  lanes (OpenSSL, AWS-LC, BoringSSL × Zig 0.15.2/0.16); the check's Darwin
  build was verified by cross-target semantic analysis only — linking it
  needs a darwin libcrypto, so it has not been executed on macOS. `PrivateKey` also
  carries a `nonce_mode` option (`NonceMode`, RFC 6979, mattrobenolt/ztls#82):
  default `.random`; `.deterministic` makes an ECDSA CertificateVerify
  byte-reproducible. Capability is compiled support only
  (`supportsDeterministicNonce()`: not BoringSSL-family and the nonce-type
  macro in the headers); the provider can still reject, and unsupported
  requests fail loudly (`DeterministicNonceUnsupported`, or
  `LibcryptoFailed` on a provider set-params rejection) — never a silently
  random nonce. Proven by the RFC 6979 §A.2.5 and §A.2.6 KATs (A.2.6
  mutation-checked red under a random nonce) plus the AWS-LC rejection
  assertions; pre-3.2-header compile behavior validated by header-overlay
  simulation only, not an actual OpenSSL 3.0 runtime.
- **Known absent:** the RFC 8446 §4.2.3 `rsa_pss_pss_*` CertificateVerify
  schemes are neither named in `SignatureScheme` nor advertised by any
  backend. Automatic loading therefore rejects rsassaPss-OID keys with
  `error.UnsupportedKeyScheme` when the backend parser accepts the container;
  some backends may reject the container earlier with `error.LibcryptoFailed`.
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
  test` inside `.#openssl` and `.#aws-lc` follows the selected headers.
  `conformance/build.zig` uses the same header inference, so `anvil_client` and
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
- BoringSSL is a compile + primitive-test + CI-gated lane. `nix develop
  .#boringssl --command zig build test` infers BoringSSL from its headers.
  The suite runs 795 tests: 788 pass and seven capability-specific tests skip
  (measured 2026-09-18, including the #114 encrypted-PEM tests and check).
  BoringSSL has no FIPS policy identity.
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
  `commonHook`. Zig 0.16 needs BoringSSL warning pragma macros disabled during
  `@cImport`; they only suppress C warnings. `just check-backends-0_16` runs the
  full AWS-LC and BoringSSL suites, while `ci-0_16` runs OpenSSL and that gate.
  TLS-Anvil workflow matrices include `boringssl` alongside
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

**Status:** `PROVEN` (library milestone) — strict-complete TLS-Anvil client and
server runs at clean `d07c551` passed on OpenSSL, AWS-LC, and BoringSSL with
zero unexpected results (#108). The capture is historical for that revision;
candidate re-qualification is #120.

Commit `d07c551` rejects non-canonical ML-KEM encapsulation keys before provider
import. It maps peer input to `illegal_parameter` and keeps provider faults
mapped to `internal_error`. OpenSSL, AWS-LC, and BoringSSL pass the local backend
and tlsfuzzer gates plus the #108 client and server TLS-Anvil runs at their
recorded revision.

Historical baseline: three libcrypto backends compile and pass the full test
suite, tlsfuzzer smoke, in-memory example, and benchmark smoke. The devshells
select matching package paths, and the headers determine the backend family.
All three backends have committed clean
TLS-Anvil captures (437/437 each, no unexpected failures) bound to their
recorded revisions; dated captures are not candidate qualification. CI-gated
backend
lanes (`just check-backend-aws-lc`, `just check-backend-boringssl`) run the
same gates as the default. X25519, P-256, AEAD, and CertificateVerify
dispatch through the backend facade; capability tables are backend-owned.

**Design decisions and residual scope:**

- **The provider abstraction is real for handshake primitives; certificate
  chain policy remains ztls-owned.** `src/crypto/backend.zig` dispatches
  X25519, P-256/P-384, AEAD, CertificateVerify signing/verification, and pure
  ML-KEM-768/1024 operations. RFC 10024 composition stays in ztls above that
  seam. Certificate-chain signature verification and
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
- **aws-lc has a real test lane but not a full external conformance matrix.**
  The AWS-LC package path links AWS-LC libcrypto and runs the unit suite.
  X25519 uses AWS-LC's flat `curve25519.h` API, while AEAD uses AWS-LC's
  BoringSSL-style `EVP_AEAD` one-shot API, and ML-KEM uses its pure KEM API.
  P-256/P-384 ECDH and signature
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
- **Capability gating covers the whole advertised handshake surface.**
  ClientHello cipher suites, named groups, `signature_algorithms`, and
  `signature_algorithms_cert` come from the active backend capability table.
  Server selection consults the same facade. Public `ztls.capabilities` exposes
  `active_backend`, `is_fips`, `hybrid_groups`, group support, policy validation,
  and the P-384 requirement. OpenSSL, AWS-LC, and BoringSSL advertise all three
  RFC 10024 groups. The `openssl-fips` and `aws-lc-fips` identities advertise
  none. Explicit local policy returns `InvalidHybridPolicy`,
  `HybridGroupUnavailable`, or `MissingP384KeyPair` without a downgrade.
  Those FIPS tables also drop ChaCha20-Poly1305, RSA PKCS#1 v1.5 certificate
  signatures, and Ed25519. They retain AES-GCM, P-256/P-384, X25519, RSA-PSS,
  and ECDSA. Comptime subset assertions and divergence tests enforce the
  reduced set. The FIPS build option declares compile-time policy only.
  The caller or linker must ensure that libcrypto runs in FIPS mode.
  The strict-complete `b6aee2c` client TLS-Anvil capture (`ci-28722850517`)
  closes the remote P-256 evidence gap with `ComplianceRequirements: passed=2`
  and `KeyShare: passed=5`. *(#6, #60)*
- **Named-group/key-exchange plumbing is group-sized and provider-backed.**
  X25519, P-256, and opt-in P-384 ECDHE work on both roles. RFC 10024 adds
  X25519MLKEM768, SecP256r1MLKEM768, and SecP384r1MLKEM1024 through pure
  ML-KEM provider operations with ztls-owned component order and secret
  composition. Exact ClientHello/ServerHello share lengths, malformed point
  rejection, direct negotiation, HRR selected-group-only ClientHello2,
  transcript collapse, and direct plus post-HRR PSK resumption with application
  data are covered locally. Bidirectional OpenSSL 3.6 interop exercises plain P-384 and
  every hybrid group with ztls linked to each non-FIPS backend. TLS-Anvil has no
  RFC 10024 coverage; the pinned upstream tlsfuzzer ML-KEM driver instead covers
  35 external conversations across the three groups, including HRR and malformed
  share rejection. Large KEM union variants use pointer captures to avoid Zig
  0.15's x86_64
  by-value offset bug *(#6, #65)*.
- **The facade contract is partly enforced by primitive tests, not a full
  matrix.** `src/crypto/backend_primitive_tests.zig` runs the same X25519,
  P-256/P-384 ECDH, AEAD, and all currently advertised CertificateVerify
  signature primitive vectors through the backend facade under both the OpenSSL
  and AWS-LC lanes in `zig build test` and `just check-backend-aws-lc`;
  BoringSSL has its matching backend lane. ML-KEM-768 and ML-KEM-1024
  keygen/encapsulate/decapsulate round trips and all three RFC 10024 handshakes
  run in those same lanes. The suite also includes selected facade-direct
  Wycheproof vectors for X25519 and all
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
wiring pointer. The root fetched package exposes `ztls` on Zig 0.15.2 and the
Zig 0.16 `ztls_std`, `ztls_xev`, and Linux-only `ztls_ktls` integration modules
(#79). `ztls_xev` gates its libxev dependency behind an explicit opt-in. The
distribution consumer compiles from an isolated package cache, checks the Zig
0.15 integration-version diagnostic, checks the xev opt-in diagnostic, and
rejects eager benchmark, test-runner, fixture-decoder, or libxev fetches on
core and standard-wrapper paths. `docs/USAGE.md` documents the
caller-owned-buffer model, `RecordBuffer`, `Outbox`, the `pending_write` /
`completeWrite()` interlock,
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
   lived in #20 was applied; #20 is open again for recurrent readiness drift.
   Status assertions moved here, and `docs/research/*` keeps mechanism,
   rationale, acceptance criteria, and runbook mechanics.
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
