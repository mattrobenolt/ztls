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
| 1. Correctness | `PARTIAL` | Strong layered evidence; client-side negative testing and a MUST-coverage matrix are the structural holes. |
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
- OpenSSL interop, both directions (`test-openssl`, `test-openssl-server`).
- tlsfuzzer conformance, CI-gated (`just tlsfuzzer`).
- Wycheproof boundary vectors at the libcrypto seam.
- Fuzzing on the major parsers.
- Explicit verification gates (client must verify Certificate / CertificateVerify
  / Finished before promoting to app keys; server must verify client Finished).

**Status:** `PARTIAL`

**Gaps (this is the punch-list that converts dread into work):**

- **No MUST-coverage matrix.** The single highest-value correctness artifact
  ztls lacks: a table mapping every RFC 8446 normative requirement to the
  test(s) that prove it or the decision that scopes it out. Until this exists,
  "proven correct" cannot be claimed. *(new todo needed)*
- **No negative-space inventory.** TLS's danger lives in everything that must
  fail. A single enumeration of "every way a peer can be malicious × what ztls
  does in response" does not exist. *(new todo needed)*
- **Client-side negative testing is absent — structural.** tlsfuzzer exercises
  the server only; client behavior against a *malicious server* is untested.
  *(todo #17, #15)*
- **No written threat model.** "Done" for a TLS library includes an enumerated,
  in-scope attack list with documented responses. *(new todo needed)*
- **External runners not gated.** BoGo and TLS-Anvil shims exist but are not in
  `just ci`; their value scales with feature surface. *(todos #9,
  #9, #9)*
- **Fuzz surface gaps:** post-auth server `handleRecord`, `alert.parse`,
  `RecordLayer.decrypt` are unwired. *(todo #7, #7)*
- **Specific unproven behaviors in the supported surface:** replayed-record
  rejection *(#14)*, systematic alert testing *(#15)*, KeyUpdate
  simultaneity *(#16)*, record-boundary edge cases *(#18)*, name
  constraints parsed-but-not-enforced *(#8)*.

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
  `close_notify` in one command.
- `examples/in_memory_handshake.zig` proves the pure Sans-I/O client/server path
  without sockets, including application data both directions, but no shutdown.
- `examples/full_handshake.zig`, `handshake_keys.zig`, `key_schedule.zig`, and
  `record_protection.zig` are educational protocol/crypto demos, not I/O-model
  cells.
- `.github/workflows/` does not run any `example-*` step. CI formats/lints
  `examples/`, but does not execute the examples.

**Status:** `PARTIAL`

**Gaps:**

- **epoll is entirely absent.** No client or server example covers the Linux
  readiness cell for epoll. *(todo #19)*
- **io_uring is client-only.** `examples/iouring_client.zig` exists, but there is
  no matching io_uring server example. *(todo #19)*
- **The manual network examples can pass without proving TLS.** `https_client`,
  `https_server`, and `iouring_client` intentionally exit successfully when the
  peer is absent/unavailable, which is friendly for demos but weak evidence for
  production readiness. *(todo #19)*
- **Examples are not CI-gated as runnable examples.** `just ci` formats and
  lints `examples/`, but does not execute even the deterministic examples such
  as `tcp_loopback` and `in_memory_handshake`. *(todo #19)*
- **Ergonomics are possible, not yet pleasant.** Real users must hand-roll the
  drive loop around `RecordBuffer`, remember to call `completeWrite()` after
  every emitted record, juggle distinct `OutBuffer` / `FlightBuffer` types, and
  interpret state transitions through event switches. `tcp_loopback.zig` is
  idiomatic enough Zig, but it is still a recipe a user copies carefully rather
  than a small obvious adapter they can trust. *(todo #19)*

---

## Pillar 3 — Performance

**Target:** reproducible benchmarks across a hardware matrix showing ztls vs
OpenSSL libssl vs rustls, with a documented methodology that *proves the
comparisons measure equivalent work*. This is the project's justification.

**Current evidence (real, but not yet decisive):**

- `docs/research/PERFORMANCE.md` lays out the intended layers: record protection,
  parser/framing throughput, deterministic client handshake replay, full
  in-memory ztls connection rows, OpenSSL EVP raw-AEAD rows, OpenSSL/libssl
  memory-BIO rows, and rustls in-memory client/server rows.
- `justfile` has useful local recipes: `bench-list`, `bench-compare`,
  `bench-app-row`, `bench-record-row`, `bench-capture`, `benchstat`,
  `bench-bins`, `bench-disasm`, `bench-disasm-libcrypto`, and `bench-perf`.
  `just ci` smoke-runs one ztls record row, one EVP row, and one OpenSSL BIO
  app-data row; it does not run rustls.
- `just bench-capture` is the closest local full-comparison command: it writes
  timestamped ztls, EVP, BIO, and rustls captures under `zig-out/perf/`.
- `infra/bench/` is an OpenTofu/NixOS EC2 host recipe with a pinned-ish shape:
  region `us-west-2`, default `c7i.large`, generated ED25519 SSH key,
  public VPC/subnet/security group, Nix flakes enabled, ASLR disabled, and some
  noisy services masked.
- The AWS README documents the actual remote ritual today: `cd infra/bench`,
  `tofu init`, `tofu apply`, rsync the repo, SSH to the instance, run a manual
  `nix develop -c bash -c '...'` benchmark snippet, rsync `zig-out/perf/` back,
  then run `benchstat` locally.
- The local benchmark docs require metadata: target, CPU model, Zig version,
  optimization mode, and git revision. AGENTS.md separately requires committed
  benchmark numbers to include machine + flags + date.

**Status:** `PARTIAL`

**Gaps:**

- **Equivalence methodology is the headline gap.** There is no written matrix
  proving that ztls, OpenSSL/libssl memory-BIO, and rustls rows measure the same
  work: identical measurement boundary, payload sizes, suites, buffer strategy,
  setup included/excluded, handshake/app-data split, and row-by-row rationale.
  The docs say the memory-BIO rows are the closest current comparison, and they
  correctly label EVP rows as not a TLS comparison, but they do not yet make the
  apples-to-apples case falsifiable. *(todo #12)*
- **Full comparison is not one command on benchmark hardware.** Locally,
  `just bench-capture` captures all four harnesses, but the AWS path is a manual
  provisioning/deploy/SSH/remote-command/pullback/benchstat ritual. The remote
  README snippet captures only ztls and OpenSSL BIO, omitting EVP and rustls, so
  it is not even the full local comparison transplanted to EC2. *(todo
  #11)*
- **No defined hardware matrix.** `infra/bench/` provisions one instance type
  (`c7i.large`) and notes that lower-noise runs should use `c7i.2xlarge` or
  larger, but there is no committed matrix of instance families/sizes,
  architectures, CPU pinning policy, repetitions, or acceptance thresholds.
  *(todo #11)*
- **Documented analysis command is missing.** `docs/research/PERFORMANCE.md`
  tells users to run `just bench-analyze` and says it consumes captures, but the
  justfile has no `bench-analyze` recipe and grep found no implementation. That
  breaks the documented capture-to-ratio workflow. *(todo #13)*
- **Published results with provenance are absent.** The repo has harnesses and
  workflow notes, but no committed ztls-vs-libssl-vs-rustls result set with the
  required machine, flags, date, Zig version, target/CPU, git revision, and
  backend/library versions. Without that, Pillar 5 has no trustworthy input.
  *(todo #10)*

---

## Pillar 4 — Providers

**Target:** aws-lc, BoringSSL, and bring-your-own libcrypto behind a clean seam,
each passing the same correctness and interop gates.

**Current evidence (real, but thin):**

- OpenSSL/libcrypto is the only working backend. The concrete binding is
  centralized in `src/c.zig`, but OpenSSL types and calls still leak directly
  into primitive modules.
- `src/aead.zig` is the strongest seam: `RecordLayer` owns TLS nonce/AAD/sequence
  work and calls `Aead.encrypt` / `Aead.decrypt`; the module reuses
  `EVP_CIPHER_CTX` values rather than allocating them per record.
- `src/x25519.zig` uses OpenSSL EVP raw-key APIs for X25519, but exposes only a
  hard-coded X25519 keypair/secret shape to the handshake.
- `src/signature.zig` has a useful caller-facing `Signer` vtable for server
  signing, but the concrete `PrivateKey` helper is OpenSSL-specific.
- `src/certificate.zig` performs CertificateVerify verification with OpenSSL EVP
  and deprecated EC/RSA construction helpers; certificate parsing/path policy is
  still ztls/std-derived code.
- `src/crypto/backend.zig` names `openssl`, `aws_lc`, and `boringssl`, but
  `active` is hard-coded to `.openssl` and no primitive dispatch imports it.
- HKDF/HMAC/SHA transcript hashing remain on `std.crypto`, matching the roadmap
  policy unless a concrete provider/FIPS requirement appears.

**Status:** `PARTIAL`

**Gaps:**

- **The provider abstraction is mostly aspirational scaffolding.** There is no
  `-Dcrypto-backend` build option, no selected backend module, and no primitive
  dispatch through `src/crypto/backend.zig`; OpenSSL calls are compiled directly
  from `src/aead.zig`, `src/x25519.zig`, `src/signature.zig`, and
  `src/certificate.zig`. This contradicts the first-class aws-lc design target
  in practice: aws-lc is named, but not selectable or protected from OpenSSL-only
  assumptions. *(todo #22)*
- **aws-lc has no implementation or validation lane.** A second backend requires
  an aws-lc build input/CI lane, one implementation file behind the facade, and
  the same unit, Wycheproof, interop, conformance, and benchmark gates as
  OpenSSL. *(todo #22)*
- **OpenSSL-only API choices block aws-lc compatibility.** `src/certificate.zig`
  uses `EC_KEY_new_by_curve_name`, `o2i_ECPublicKey`, `EVP_PKEY_assign_EC_KEY`,
  `d2i_RSAPublicKey`, and `EVP_PKEY_assign_RSA`; `src/signature.zig` uses
  `EC_GROUP` / `EC_POINT` / `EC_KEY` construction for P-256 test signing. These
  need backend-portable key construction (`EVP_PKEY_fromdata`, raw-key helpers,
  or backend-specific implementations hidden behind the seam). *(todo #22)*
- **Capability gating does not exist.** Cipher suites are enumerated directly
  from `CipherSuite`; `client_hello.zig` always advertises only X25519 but not
  through a backend capability table; `kex.zig` names future P-256/P-384/PQ
  groups while `publicKeyLen()` returns a real length only for X25519. A backend
  cannot currently narrow suites/groups/signature schemes for missing algorithms,
  FIPS posture, or provider-version differences. *(todo #22)*
- **Named-group/key-exchange shape is still X25519-only.** Handshake code stores
  `x25519.KeyPair`, wire encoding writes `.x25519`, and shared secrets are fixed
  at 32 bytes; P-256/P-384 and PQ/hybrid groups require variable-length
  key-share/public-key/shared-secret plumbing before aws-lc capability differences
  can be tested honestly. *(todo #22)*
- **The facade contract is not enforced by tests.** Existing tests prove OpenSSL
  behavior, but there is no backend matrix that runs the same primitive vectors,
  interop harnesses, and conformance shims for every enabled provider. *(todo
  #22)*

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

1. **Reconcile the five duplicate todo pairs.** Two agent sessions ~2h apart on
   2026-06-07 created parallel todos for the same five features. The
   01:31 batch (deferral records) is cited by the roadmap; the 03:26 batch
   (implementation-slice records) is cited by the skip-lists. Both halves carry
   real, *different* facts — merge, don't delete.

   | Feature | Deferral todo | Slice todo |
   |---|---|---|
   | HelloRetryRequest | #1 | #1 |
   | PSK / resumption | #2 | #2 |
   | 0-RTT policy | #3 | #3 |
   | Client cert auth | #4 | #4 |
   | Extension negotiation | #5 | #5 |

2. **Decide the canonical-ID policy** and repoint skip-lists + roadmap to one ID
   per feature.
3. **Consolidate `docs/research/`.** Seven status-bearing docs is the root of
   the duplication/rot. Status moves here; those docs keep mechanism only.

   **Docs/research reconciliation kill-list — 2026-06-08**

   **Target:** `docs/research/` keeps mechanism, rationale, acceptance criteria,
   and test instructions only. All assertions about what ztls currently supports,
   what is implemented, what is done, and which evidence proves readiness move to
   this spine.

   **Current evidence:** read `API_ROADMAP.md`, `CRYPTO_ROADMAP.md`,
   `PERFORMANCE.md`, `DESIGN.md`, and `bettertls.md`; re-skimmed
   `CONFORMANCE_ROADMAP.md` and `CORRECTNESS.md`; searched `docs/research/*.md`
   for status-bearing language.

   **Status:** `PARTIAL`

   **Kill-list:**

   - **Severity: high — `docs/research/DESIGN.md` Build Order is a second
     readiness dashboard.** Lines under `## Build Order` use ✅ / ◐ to assert
     completed and partial implementation state for record framing, AEAD,
     handshake, app data, KeyUpdate, interop, fuzzing, alerts, X.509, ALPN,
     usage limits, HRR, and NewSessionTicket. **Classification: (a) status
     assertion to DELETE.** Keep any mechanism that is still useful elsewhere,
     but the done/partial ladder belongs only here. *(todo #20)*
   - **Severity: high — `docs/research/CORRECTNESS.md` is a parallel Pillar 1
     evidence/status page.** `CI-gated checks`, `tlsfuzzer Current coverage`,
     `Fuzzing Current fuzz surfaces`, `Known gaps in the supported surface`, and
     `External suite policy` all assert supported surface, current coverage,
     known gaps, and todo dispositions already summarized in Pillar 1. **Classification:
     (a) status assertions to DELETE or reduce to mechanism/runbook.** Keep suite
     mechanics and commands only if they do not claim readiness. *(todo #20)*
   - **Severity: high — `docs/research/CONFORMANCE_ROADMAP.md` asserts current
     supported/out-of-scope surface and todo disposition.** The opening
     `Currently supported surface`, per-feature `Current behavior`, and
     `Disposition summary` duplicate Pillar 1 and the immediate duplicate-todo
     cleanup item. **Classification: mixed (a)/(b).** Delete supported-surface
     and disposition assertions; keep prerequisites, acceptance criteria, and
     observable wire behavior only where needed to define future work. *(todo #20)*
   - **Severity: high — `docs/research/bettertls.md` has a status table.**
     `Current ztls status` lists Partial / Not implemented for name constraints,
     path building, and name-form enforcement, duplicating Pillar 1's certificate
     gap. **Classification: (a) status assertion to DELETE.** Keep the
     bettertls mechanism, validation scope, and pre-integration checklist.
     *(covered by #8 for implementation; docs cleanup todo still
     needed)*
   - **Severity: medium — `docs/research/API_ROADMAP.md` contradicts current
     ergonomics evidence.** It says the canonical API examples deliberately avoid
     `std.net`, io_uring, HTTP parsing, and runtime-specific adapters, and says
     `examples/in_memory_handshake.zig` is the supported server API proof until a
     wrapper exists. Pillar 2 now records `https_client`, `https_server`,
     `tcp_loopback`, and `iouring_client` as existing proof points, while still
     rating them `PARTIAL`. **Classification: (c) stale / out-of-date content to
     fix or remove.** Keep wrapper acceptance criteria and drive-loop mechanics;
     delete or rewrite the stale canonical-example/status claims. *(todo #20)*
   - **Severity: medium — `docs/research/PERFORMANCE.md` duplicates Pillar 3
     harness inventory and contains a stale command.** It asserts current harness
     scope, current full-suite target, benchmark rows, and says `just
     bench-analyze` exists; Pillar 3 already records the missing recipe as a
     gap. **Classification: mixed (a)/(c)/(b).** Delete current-status inventory,
     fix/remove the stale `bench-analyze` workflow, and keep methodology,
     prior-art, row definitions, and profiling mechanics. *(#13 for
     stale benchmark analysis; broader docs cleanup todo still needed)*
   - **Severity: medium — `docs/research/CRYPTO_ROADMAP.md` duplicates Pillar 4
     provider state and Pillar 3 performance caveats.** `Current evidence`,
     current AArch64 claims, AEAD/X25519/signature current-state paragraphs, and
     `Success criteria` assert backend status and performance direction in a
     roadmap doc. **Classification: mixed (a)/(b).** Keep backend allocation
     contract, facade requirements, and milestone mechanics; move/delete current
     evidence/status claims unless this spine cites them. *(#22
     covers provider work; docs cleanup is #20)*
   - **Severity: low — duplicated libcrypto allocation/no-allocator contract
     appears in `DESIGN.md`, `CRYPTO_ROADMAP.md`, and AGENTS.md.** This is mostly
     mechanism/policy, not readiness status, but the wording is repeated enough
     to drift. **Classification: (b) mechanism content that STAYS, with one
     canonical wording preferred in later consolidation.**
   - **Severity: low — duplicated external-suite descriptions appear in
     `DESIGN.md`, `CORRECTNESS.md`, `CONFORMANCE_ROADMAP.md`, and
     `bettertls.md`.** Suite purpose and command mechanics can stay, but coverage
     and support claims should not be repeated. **Classification: mixed (a)/(b).**
   - **Severity: low — duplicated benchmark taxonomy appears in `PERFORMANCE.md`,
     `CRYPTO_ROADMAP.md`, `DESIGN.md`, and Pillar 3.** Methodology and row
     definitions stay; current harness/evidence assertions move here.
     **Classification: mixed (a)/(b).**

   **Gaps:**

   - **The kill-list has not been applied.** A single docs cleanup todo now
     covers this reconciliation pass; the next step is to delete/rewrite the
     status assertions deliberately, not opportunistically while doing feature
     work. *(todo #20)*
4. **Define the build.zig / justfile taxonomy** so new tools have a required
   home instead of being appended ad-hoc.

   **Build/just taxonomy audit — 2026-06-08**

   **Target:** every `build.zig` step and `justfile` recipe has one obvious
   category, naming follows that category, and future tooling has a required
   home instead of landing as an ad-hoc suffix or private helper.

   **Current evidence:** `build.zig` and `justfile` were read end to end for
   step/recipe inventory, grouping, duplication, dead one-offs, and naming
   consistency.

   **Status:** `PARTIAL`

   **Inventory by purpose:**

   - **Build/library plumbing:** public `ztls` module, test-only `test_mod`,
     lazy `txtar`, OpenSSL/libcrypto linkage, benchmark C shim modules
     (`bench/c.zig`, `bench/c_ssl.zig`), native-target override for aarch64
     Linux. These are implicit build graph nodes rather than user-facing steps.
   - **Unit/check tests:** `zig build test`; just recipes `test`, `wycheproof`,
     `check-actions`, `check-no-alloc`, `check-fixtures`, `lint`,
     `check-conformance-python`, and aggregate `ci`.
   - **Interop tests:** `zig build test-openssl` and
     `zig build test-openssl-server`; both are invoked directly by `just ci`.
   - **Conformance shims/runners:** build steps `tlsfuzzer-server`,
     `tls-anvil-client`, `bogo-shim`; just recipes `tlsfuzzer`,
     `tlsfuzzer-lockstep`, `anvil-fetch`, `anvil-server`, `anvil-client`,
     `bogo-fetch`, `bogo`, and private helpers `build-tlsfuzzer-server`,
     `build-tls-anvil-client`, `bogo-clone`, `bogo-build-runner`.
   - **Wycheproof:** `zig build test-wycheproof` plus just `wycheproof`.
     Functionally check/correctness evidence, but named separately from both
     unit tests and conformance suites.
   - **Fixtures:** `zig build generate-replay-fixtures`; just recipes
     `gen-cert`, `gen-cv-sig`, `gen-fixtures`, and `check-fixtures`.
     Replay-fixture generation lives only in `build.zig`; certificate fixture
     generation lives only in `justfile`.
   - **Bench run/list/compare:** `zig build bench`, `bench-micro`,
     `bench-evp`, `bench-openssl`, `bench-rustls`; just recipes `bench-list`,
     `bench-compare`, `bench-app-row`, `bench-record-row`,
     `bench-handshake-hotspots`, `bench-capture`, `benchstat`.
   - **Bench binaries/profiling/disassembly:** build steps `bench-bin`,
     `bench-micro-bin`, `bench-micro-disasm`, `bench-evp-bin`,
     `bench-openssl-bin`, `bench-rustls-bin`; just recipes `bench-bins`,
     `bench-disasm`, `bench-disasm-libcrypto`, `bench-perf`.
   - **Examples/demo:** generated build steps `example-{name}` and
     `example-{name}-asm` for `full_handshake`, `handshake_keys`,
     `https_client`, `https_server`, `in_memory_handshake`, `key_schedule`,
     `tcp_loopback`, `record_protection`; Linux-only `example-iouring_client`;
     just recipe `example`.
   - **Default/help:** private just `default` lists available recipes.

   **Duplication / naming / dead-space findings:**

   - **Severity: medium — conformance façade is split.** `justfile` exposes
     tlsfuzzer, TLS-Anvil, and BoGo through separate verbs and output shapes,
     while `build.zig` exposes only shim-build steps. This overlaps with the
     separate cleanup item to unify the conformance façade. *(todo #9;
     taxonomy surface in #21)*
   - **Severity: medium — benchmark naming mixes subject and action.** `bench`
     means ztls record/app benchmark in `build.zig`, while `bench-evp`,
     `bench-openssl`, and `bench-rustls` name comparison subjects; binary steps
     use both singular `bench-bin` and subject-suffixed `bench-*-bin`; just adds
     row selectors and profiling tools on top. This is workable but not a
     taxonomy. *(todo #13 covers the broken documented bench-analysis path;
     broader taxonomy cleanup is tracked by #21)*
   - **Severity: medium — documented benchmark analysis is dead.** The readiness
     performance audit already found docs pointing at `just bench-analyze`, but
     the justfile has no such recipe. This audit confirms the recipe is absent
     from the build/just taxonomy. *(todo #13)*
   - **Severity: low — `bench-handshake-hotspots` is a placeholder recipe.** It
     prints `TODO: reimplement for Go benchmark format` and produces no analysis.
     It is visible in the bench group, so users can run a dead one-off. *(todo
     #13 if kept as benchmark-analysis work; otherwise #21)*
   - **Severity: low — fixture generation is split by fixture type.** Replay
     fixtures are a `zig build` step; certificate/CV fixtures are just recipes;
     fixture consistency checking is a check recipe. The split may be justified,
     but the taxonomy does not say where future generated fixtures belong.
     *(todo #21)*
   - **Severity: low — examples have run steps and asm steps, but the Linux-only
     io_uring example has no matching asm step.** This may be intentional, but
     it is an inconsistency in the generated example surface. *(todo #21
     only if example-asm is meant to be universal)*
   - **Severity: low — interop lives outside the conformance group.** OpenSSL
     client/server interop is invoked directly from `just ci` through build
     steps, not wrapped by just recipes or grouped with external conformance.
     The split is understandable, but not named by a taxonomy. *(todo
     #21)*

   **Proposed taxonomy:**

   - **`build`** — library/module construction and installable binaries. No
     protocol claims; no external services.
   - **`check`** — fast local gates: unit tests, lint/format, allocator policy,
     workflow lint, fixture consistency, language-tool checks.
   - **`interop`** — ztls against ground-truth peers such as OpenSSL `s_client`
     / `s_server`; separate from conformance suites because these are focused
     integration probes.
   - **`conformance`** — external suite façade: tlsfuzzer, TLS-Anvil, BoGo,
     bettertls inventory/runners. One public shape should own suite selection,
     shim building, fetching, skip/inventory handling, and result normalization.
   - **`bench`** — benchmark execution, row listing, comparison capture,
     benchmark binaries, profiling, disassembly, and analysis. Names should be
     `{category}-{subject}-{action}` or `{category}-{action}` consistently; ztls
     should be an explicit subject when compared with EVP/BIO/rustls.
   - **`fixtures`** — deterministic generated test/bench/example artifacts and
     their verification. Future fixture generators should not be hidden under
     bench or conformance just because one consumer needs them.
   - **`examples` / `demo`** — human-facing example runs and optional emitted
     artifacts such as asm. Runnable evidence examples that gate readiness should
     also have check/CI wrappers rather than relying on manual demo recipes.
   - **`tools`** — fetch/build third-party tools and shims when they are not
     themselves conformance execution. Private helpers may live here, but public
     recipes should point users at the higher-level category.

   **Gaps:**

   - **No canonical taxonomy is implemented.** The map above is only an audit
     artifact; cleanup still needs a deliberate rename/rehome pass and a policy
     for where new recipes land. *(todo #21)*
5. **Unify the conformance façade.** One `just conformance <suite>` interface
   and one result format over the polyglot runners (the Go/JVM/Python/Rust stays
   under the hood; the interface and output unify).
