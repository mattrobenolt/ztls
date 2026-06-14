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
| 2. Ergonomics | `PARTIAL` | `std.net.Stream` examples cover both roles; io_uring has a client-only proof; epoll is absent and examples are not CI-gated. |
| 3. Performance | `PARTIAL` | Rich bench harness exists; equivalence methodology and reproducible hardware-matrix results are missing. |
| 4. Providers | `PARTIAL` | OpenSSL primitives are live, but the provider seam is mostly aspirational: no backend selection, no second backend, no capability table. |
| 5. Marketing | `NONE` | Not started. |
| 6. User docs | `PARTIAL` | `docs/USAGE.md` exists; completeness unaudited. |

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

- **External runners not gated.** BoGo and TLS-Anvil shims exist but are not in
  `just ci`; their value scales with feature surface. *(#9)*
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
| Client | `PARTIAL` — `examples/iouring_client.zig` builds and exercises a real client handshake + app-data path when paired with `examples/https_server.zig`, but it exits successfully without proving TLS if no server is listening. | `NONE` | `PARTIAL` — `examples/https_client.zig` and the client side of `examples/tcp_loopback.zig` build; `tcp_loopback` proves real handshake + app data + `close_notify`, while `https_client` is a manual two-terminal demo and exits successfully without proving TLS if no server is listening. |
| Server | `NONE` | `NONE` | `PARTIAL` — `examples/https_server.zig` and the server side of `examples/tcp_loopback.zig` build; `tcp_loopback` proves real handshake + app data + `close_notify`, while `https_server` is a manual one-shot demo and exits successfully without proving TLS if no client connects. |

**Current evidence (useful, but not enough):**

- Complete example inventory: `full_handshake.zig`, `handshake_keys.zig`,
  `https_client.zig`, `https_server.zig`, `in_memory_handshake.zig`,
  `iouring_client.zig`, `key_schedule.zig`, `record_protection.zig`, and
  `tcp_loopback.zig`.
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
  `example-tcp_loopback` and `example-in_memory_handshake`. CI still does not
  execute manual peer-dependent demos such as `https_client`, `https_server`, or
  `iouring_client`.

**Status:** `PARTIAL`

**Gaps:**

- **epoll is entirely absent.** No client or server example covers the Linux
  readiness cell for epoll. *(#19)*
- **io_uring is client-only.** `examples/iouring_client.zig` exists, but there is
  no matching io_uring server example. *(#19)*
- **The manual network examples can pass without proving TLS.** `https_client`,
  `https_server`, and `iouring_client` intentionally exit successfully when the
  peer is absent/unavailable, which is friendly for demos but weak evidence for
  production readiness. *(#19)*
- **Ergonomics are possible, not yet pleasant.** Real users must hand-roll the
  drive loop around `RecordBuffer`, remember to call `completeWrite()` after
  every emitted record, juggle distinct `OutBuffer` / `FlightBuffer` types, and
  interpret state transitions through event switches. `tcp_loopback.zig` is
  idiomatic enough Zig, but it is still a recipe a user copies carefully rather
  than a small obvious adapter they can trust. *(#19)*

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
  `bench-analyze` for `benchstat` comparison of captures, and profiling helpers `bench-disasm`,
  `bench-disasm-libcrypto`, and `bench-perf`. `just ci` no longer runs benchmark
  measurements; benchmarks are not correctness evidence on uncontrolled CI
  runners.
- `just bench-capture-default` writes a timestamped run directory under
  `zig-out/perf/` with metadata plus ztls, EVP, libssl memory-BIO, and rustls
  captures; `just bench-analyze <capture>` compares those captures with
  `benchstat`.
- `infra/bench/` is an OpenTofu/NixOS EC2 host recipe with a pinned-ish shape:
  region `us-west-2`, default `c7i.large`, generated ED25519 SSH key,
  public VPC/subnet/security group, Nix flakes enabled, ASLR disabled, and some
  noisy services masked.
- The AWS README documents the actual remote ritual today: `cd infra/bench`,
  `tofu init`, `tofu apply`, rsync the repo including `.git`, SSH to the
  instance, run `just bench-capture-default` inside the flake devshell, rsync
  `zig-out/perf/` back, then run `just bench-analyze <capture>` locally.
- `docs/research/perf/20260613-182405-ec2-c7i-large/` is the first committed
  EC2 result set, with raw ztls/EVP/libssl/rustls outputs, `metadata.txt`, and
  `benchstat.txt`. It was captured on a clean `c7i.large` host at git revision
  `c7097426cfad938c609b626c56790ec9e1115952` with `--count=5 --benchtime=500ms`.
- The local benchmark docs require metadata: target, CPU model, Zig version,
  optimization mode, and git revision. AGENTS.md separately requires committed
  benchmark numbers to include machine + flags + date.

**Status:** `PARTIAL`

**Gaps:**

- **Full benchmark workflow is still manually orchestrated.** The remote path
  now uses the same `just bench-capture` and `just bench-analyze` commands as
  local runs, but provisioning, deploy, SSH execution, and pullback are still
  manual steps. *(#11)*
- **No defined hardware matrix.** `infra/bench/` provisions one instance type
  (`c7i.large`) and notes that lower-noise runs should use `c7i.2xlarge` or
  larger, but there is no committed matrix of instance families/sizes,
  architectures, CPU pinning policy, repetitions, or acceptance thresholds.
  *(#11)*
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

- OpenSSL/libcrypto is the only working backend. The concrete binding is
  centralized in `src/crypto/c_openssl.zig`; OpenSSL key-construction fast paths
  live in `src/crypto/openssl_key.zig`, but OpenSSL EVP calls still leak into
  primitive modules.
- `src/aead.zig` is the strongest seam: `RecordLayer` owns TLS nonce/AAD/sequence
  work and calls `Aead.encrypt` / `Aead.decrypt`; the module reuses
  `EVP_CIPHER_CTX` values rather than allocating them per record.
- `src/x25519.zig` uses OpenSSL EVP raw-key APIs for X25519, but exposes only a
  hard-coded X25519 keypair/secret shape to the handshake.
- `src/signature.zig` has a useful caller-facing `Signer` vtable for server
  signing, but the concrete `PrivateKey` helper is OpenSSL-specific.
- `src/certificate.zig` performs CertificateVerify verification with OpenSSL EVP
  and delegates public-key construction to `src/crypto/openssl_key.zig`;
  certificate parsing/path policy is still ztls/std-derived code.
- `-Dcrypto-backend=openssl` selects the current backend at build time, and
  named-but-unimplemented backends fail clearly instead of silently falling back.
  `src/crypto/backend.zig` still does not dispatch primitive implementations.
- HKDF/HMAC/SHA transcript hashing remain on `std.crypto`, matching the roadmap
  policy unless a concrete provider/FIPS requirement appears.

**Status:** `PARTIAL`

**Gaps:**

- **The provider abstraction is still mostly aspirational scaffolding.** The
  build has a `-Dcrypto-backend` selection point, but only `openssl` is
  implemented and no selected backend module dispatches primitives through
  `src/crypto/backend.zig`; OpenSSL calls are compiled directly through
  `src/crypto/c_openssl.zig` from `src/aead.zig`, `src/x25519.zig`,
  `src/signature.zig`, `src/certificate.zig`, and backend-specific helpers such
  as `src/crypto/openssl_key.zig`. This contradicts the first-class aws-lc
  design target in practice: aws-lc is named and rejected clearly, but not
  implemented. *(#22)*
- **aws-lc has no implementation or validation lane.** A second backend requires
  an aws-lc build input/CI lane, one implementation file behind the facade, and
  the same unit, Wycheproof, interop, conformance, and benchmark gates as
  OpenSSL. *(#22)*
- **OpenSSL-only API choices still need backend dispatch.** The OpenSSL EC/RSA
  key-construction fast paths are isolated in `src/crypto/openssl_key.zig` rather
  than smeared through certificate/signature code, but there is still no selected
  backend interface that lets aws-lc provide its own measured implementation.
  A scratch measurement on OpenSSL 3.6.2 showed the current construction path is
  faster than naive `EVP_PKEY_fromdata`/decoder replacements, so portability must
  come through backend-specific fast paths, not an unmeasured lowest-common API.
  *(#22)*
- **Capability gating does not exist.** Cipher suites are enumerated directly
  from `CipherSuite`; `client_hello.zig` always advertises only X25519 but not
  through a backend capability table; `kex.zig` names future P-256/P-384/PQ
  groups while `publicKeyLen()` returns a real length only for X25519. A backend
  cannot currently narrow suites/groups/signature schemes for missing algorithms,
  FIPS posture, or provider-version differences. *(#22)*
- **Named-group/key-exchange shape is still X25519-only.** Handshake code stores
  `x25519.KeyPair`, wire encoding writes `.x25519`, and shared secrets are fixed
  at 32 bytes; P-256/P-384 and PQ/hybrid groups require variable-length
  key-share/public-key/shared-secret plumbing before aws-lc capability differences
  can be tested honestly. *(#22)*
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

**Current evidence:** `docs/USAGE.md` exists; completeness unaudited.

**Status:** `PARTIAL`

**Gaps:** audit USAGE.md; getting-started guide; API reference; integration
guides that reuse the Pillar 2 examples as their backbone.

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
