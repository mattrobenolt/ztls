# Attack-surface recon

Recon-stage scan for the Glasswing vulnerability harness. Maps ztls's trust
boundaries, public-API entry points, per-subsystem attack surface, and the
existing fuzz/test coverage. Outputs a narrow, prioritized hunt queue for the
downstream `whitehat-hacker` agents. The defensive inventory and per-row
evidence stay in `THREAT_MODEL.md` (attacker capability + defended classes)
and `NEGATIVE_SPACE.md` (per-malformed-input response). This doc extends
both — it does not duplicate their rows.

**Location.** This file lives at `docs/research/security/RECON.md`. Flatten
into `docs/research/RECON.md` if a docs-librarian pass prefers to keep
research docs at the top level.

**Status is not asserted here.** What is done and what evidence proves it is
`PRODUCTION_READINESS.md`'s job. This doc describes the surface and proposes
hunt work; it does not close or invert any readiness claim.

## Build, test, and flag conventions

Run from the root with the dev shell active (`flake.nix` is the source of
truth — add tools there rather than installing locally).

```sh
zig build test --summary all            # full unit-test + corpus-seeded fuzz run
zig build test --fuzz                   # let the fuzzer mutate the existing seeds
just test                              # wrapper for the above
just lint                               # zig fmt + ziglint + ast-grep rules
just ci                                 # test + check-backend-aws-lc + lint + examples-ci + conformance/ci
just check-backend-boringssl            # backend lane, requires the boringssl shell
```

Per-file fuzz corpus seeding: every `test "fuzz: …"` block runs its seeds in
the deterministic test build and feeds them to the Zig stdlib fuzzer when
`--fuzz` is set. Fuzz targets are listed under *Existing fuzz coverage* below
with file:line references.

Build options most relevant to security review:

- `-Dcrypto-backend=openssl|aws-lc|boringssl|openssl-fips|aws-lc-fips`
  chooses which libcrypto-family backend `src/crypto/backend.zig` links. Any
  hunt cross-referencing sigverify or AEAD behavior should at minimum pin the
  backend and re-run when switching.
- `-Doptimize=ReleaseFast` is required for benchmarks but also exposes
  inlining differences that can mask OOB reads in Debug.

## Trust boundaries

ztls is Sans-I/O. There is **no transport, no syscall, and no ztls-owned
allocator** inside the protocol/state-machine code (`rules/no-ztls-owned-allocations.yml`
enforces this in lint). That collapses the attacker boundary into three
seams, each with its own unreachable-from-the-other failure mode:

| Boundary | What crosses it | Direction | Source |
|---|---|---|---|
| **Network / peer bytes** | `record: []u8` and `msg: []const u8` parameters on the public API | Caller-supplied, fully attacker-controlled | All entry points in §"Entry points" |
| **libcrypto backend seam** | `pkey` handles and opaque AEAD contexts into OpenSSL/AWS-LC/BoringSSL | ztls calls out, backend owns its own allocations and freelists | `src/crypto/backend.zig`, `x25519.zig`, `p256.zig`, `p384.zig`, `aead.zig`, `signature.zig` |
| **Caller-owned buffers** | `out: []u8` parameters, `Storage` / `OutBuffer` arrays, `handshake_buf`, `ch_buf`, `fin_frag` | ztls writes into caller-provided storage, never owns it | `frame.OutBuffer`, `ClientHandshake.Storage`, `ServerHandshake.Storage`, `handshake_buf`, `ch_buf` |

A fourth boundary — **trust anchor storage / private-key handle ownership** —
is entirely caller-side. ztls receives a `certificate.Policy` and the
client/server `Signer` implementations; it never reads a file, reads
environment variables, or touches the OS. The caller is responsible for
providing the bundle (see `THREAT_MODEL.md` §"Non-goals and caller
responsibilities" for the contract and the `insecure_no_chain_anchor`
opt-in's MITM exposure).

A fifth, narrower boundary: **replay-cache ownership for 0-RTT**. Replay
protection is documented caller-owned contract (`THREAT_MODEL.md`
§"Non-goals and caller responsibilities"). ztls surface only emits an
`EarlyDataAccepted` signal that the caller can use, but does not maintain a
deduplication set. Hunt tasks must respect this: a "0-RTT replay" bug that
depends on ztls maintaining a cache is an architectural absence, not a
defect.

## Entry points and data flows

Public API surfaces where untrusted bytes cross the **Network** boundary.
Mapped by `src/root.zig` and the `ClientHandshake` / `ServerHandshake`
public fn declarations. Files I cite are the dispatch root; deeper
processing paths lead into the per-subsystem surfaces in §"Attack surface
per subsystem".

### Record framing and AEAD

| Function | Source | Bytes that flow through |
|---|---|---|
| `frame.parseHeader(buf)` | `src/frame.zig:103` | 5-byte record header. Beefy surface. |
| `RecordBuffer.next()` | `src/RecordBuffer.zig:80` | Stores the assembled record slice before decryption. |
| `RecordLayer.decrypt(buf)` | `src/RecordLayer.zig:175` | Decrypts TLSCiphertext, returns inner plaintext + content type. |
| `RecordLayer.encrypt(ct, content, out)` | `src/RecordLayer.zig:233` | Caller-visible; not an entry, but mirrors the inverse path. |

### Server-side handshake

| Function | Source | Bytes that flow through |
|---|---|---|
| `ServerHandshake.handleRecord(record, out)` | `src/ServerHandshake.zig:1389` | Top-level dispatch. Routes by `state`. |
| `ServerHandshake.handleWaitClientHello` | `src/ServerHandshake.zig:1407` | Sniff+parse plaintext records. Risky on fragment edges. |
| `ServerHandshake.handleClientHelloRecord` | `src/ServerHandshake.zig:1462` | Cross-record ClientHello reassembly. `ch_buf` is the temporary. |
| `ServerHandshake.handleWaitClientFinished` | later in same file | Encrypted-server-flight reception. Includes 0-RTT decrypt-on-early_rx. |
| `ServerHandshake.handleConnected` | later in same file | Post-handshake dispatch. Drives KeyUpdate flood handling. |
| `ServerHandshake.processClientFinished(record)` | `src/ServerHandshake.zig:1276` | Server Finished verification surface. |
| `ServerHandshake.acceptClientHello(out)` | `src/ServerHandshake.zig:631` | Server-driven emit of CH acceptance; not a network entry but reads/rewrites internal state. |

### Client-side handshake

| Function | Source | Bytes that flow through |
|---|---|---|
| `ClientHandshake.handleRecord(record, out)` | `src/ClientHandshake.zig:870` | Top-level dispatch. Routes by `state`. |
| `ClientHandshake.processServerHello(msg)` | `src/ClientHandshake.zig:1250` | ServerHello (plaintext) parse + state transition. |
| `ClientHandshake.processHelloRetryRequest(record)` | `src/ClientHandshake.zig:1155` | HRR reception; triggers ClientHello2 re-emission. |
| `ClientHandshake.processFlight(payload, policy)` | `src/ClientHandshake.zig:1359` | Encrypted server flight parse + state-machine fan-out. Highest-risk entry on the client. |
| `ClientHandshake.injectClientHello(msg)` | `src/ClientHandshake.zig:767` | Caller pathway for fuzzer/HRR replay. |
| `ClientHandshake.start(out)` / `startWithPsk(out)` | `src/ClientHandshake.zig:616` / `:664` | PSK client entry. Generates ClientHello + binder. |
| `ClientHandshake.clientFinished(out)` | `src/ClientHandshake.zig:1559` | Client Finished emission + key promotion. |

### Per-message parsers (called from the above)

These are the leaf parsing surfaces — once the dispatch identifies
"<some handshake message>", bytes flow into these:

| Parser | Source | RFC |
|---|---|---|
| `server_hello.parse` / `parseHelloRetryRequest` | `src/server_hello.zig` | RFC 8446 §4.1.3, §4.1.4 |
| `client_hello.parse` | `src/client_hello.zig` (also emits) | RFC 8446 §4.1.2 |
| `encrypted_extensions.parse` | `src/encrypted_extensions.zig:96` | RFC 8446 §4.3.1 + referenced extension RFCs |
| `certificate.parse` / `parseClientChain` / `parseClientCertificate` | `src/certificate.zig:111/171/101` | RFC 8446 §4.4.2 + RFC 5280 |
| `certificate_request.parse` | `src/certificate_request.zig` | RFC 8446 §4.3.2 |
| `NewSessionTicket.parse` | `src/NewSessionTicket.zig:50` | RFC 8446 §4.6.1 |
| `finished.zig` Finished MAC | `src/finished.zig` | RFC 8446 §4.4.4 |
| `alert.parse` / `alert.encode` | `src/alert.zig:60` | RFC 8446 §6 |
| `handshake.parseKeyUpdate` | `src/handshake.zig:174` | RFC 8446 §4.6.3 |

### Crypto backend seam (downward calls only)

The provider facade in `src/crypto/backend.zig` is the *only* typed switch
point for backend shape (OpenSSL / AWS-LC / BoringSSL / `-fips` widths).
These are the lowest-level calls into libcrypto-family code and any
sanitizer flags must be enabled at this boundary:

| Backend function | Source | Calls out to |
|---|---|---|
| `backend.x25519.sharedSecretDerive` | `src/crypto/backend.zig:233` | `EVP_PKEY_derive`, `EVP_PKEY_CTX_set_*` (OpenSSL/AWS-LC/BoringSSL) |
| `backend.x25519.identityElement` reject | `src/x25519.zig` | (ztls-side check) |
| `backend.p256.*` / `backend.p384.*` | `src/crypto/backend.zig:241-271` | `EVP_PKEY_derive`, ec curve APIs |
| `backend.aead.encrypt/decrypt` | `src/crypto/backend.zig:286-347` | `EVP_Encrypt/Decrypt*` (OpenSSL) or `EVP_AEAD_*` (AWS-LC/BoringSSL) |
| `backend.sign.verify` | `src/crypto/backend.zig:386` | `EVP_DigestVerify*` |

Backend-internal allocations and zeroization are **outside** ztls's
contract (see `THREAT_MODEL.md` §"Non-goals and caller responsibilities").

## Existing fuzz coverage map

`test "fuzz: …"` blocks in `src/`. Each entry names the parser / dispatcher
the fuzzer seeds, the corpus the deterministic test run uses (this matters
because seedless re-runs rely on whatever the fuzzer generated earlier in
the same build), and a NEGATIVE_SPACE pointer for cross-check.

| Fuzz target | Source | NEGATIVE_SPACE row |
|---|---|---|
| `frame.parseHeader` | `src/frame.zig:189` (`fuzzParseHeader`) | "Record header shorter than 5 bytes", "Record length greater than RFC 8446 §5.2 maximum" |
| `alert.parse` | `src/alert.zig:142` (`fuzzParse`) | "Alert payload shorter than two bytes" |
| `server_hello.parse` | `src/server_hello.zig:993` | "Malformed ServerHello length/body", "ServerHello unknown cipher-suite", "ServerHello `supported_versions` absent/illegal", downgrade sentinel family |
| `parseHelloRetryRequest` | `src/server_hello.zig:1246` | HRR rejection / echoed extensions |
| `client_hello.parse` | `src/client_hello.zig:1996` | "Garbage or non-TLS input before ClientHello", "Malformed ClientHello compression methods", "Empty ClientHello record", duplicate extensions |
| `NewSessionTicket.parse` | `src/NewSessionTicket.zig:219` | "Post-handshake NewSessionTicket malformed" |
| `RecordLayer.decrypt` | `src/RecordLayer.zig:637` (`fuzzDecrypt`) | "Encrypted record has outer content type other than `application_data`", "TLSCiphertext length field exceeds supplied buffer", "AEAD ciphertext/tag/AAD corruption", "Decrypted inner plaintext has no non-zero content type byte" |
| `ClientHandshake.HandshakeReader` | `src/ClientHandshake.zig:3633` | "Handshake message spans encrypted records without caller buffer" (the reader parses coalesced records; coverage of the panic surface) |
| `ClientHandshake.processFlight` | `src/ClientHandshake.zig:3645` (`fuzzProcessFlight`) | "Encrypted flight message arrives out of order", CertificateVerify/Finished verification gates, PSK Finished fast-path, malware-shaped flight |
| `ServerHandshake.handleRecord` (pre-auth) | `src/ServerHandshake.zig:3854` | "Garbage or non-TLS input before ClientHello", CCS-only-after-HRR rule, alert-while-waiting-for-CH |
| `ServerHandshake.handleRecord` (connected) | `src/ServerHandshake.zig:3871` | "Connected-state KeyUpdate flood", "illegal post-handshake inner content type", simultaneous-update safety |

### Coverage gaps the recon pass names

The following surfaces have **partial** or **gap** coverage per
`NEGATIVE_SPACE.md` §"Parser and crypto boundary fuzz surfaces" and need
explicit hunt work:

- **Certificate parse + chain verification** (`src/certificate.zig`,
  `src/certificate_parser.zig`). The deterministic fuzz seed in
  `certificate.zig:1470` exists, but it sits on the leaf parser rather
  than the `parseServerChain` / `parseClientChain` flows that bind trust
  anchors and policy. Considered partial coverage because **DER/ASN.1 is
  the most-attacked leaf**.
- **EncryptedExtensions parser**. No standalone fuzz target. The
  offered-vs-unoffered gate logic (allowed when offered, denied when not,
  GREASE rejection) is exercised by per-row unit tests but not by an
  arbitrary-input seed list.
- **ServerCertificate `request_context` non-empty rejection** (gap row in
  NEGATIVE_SPACE).
- **Legacy session-id length cap on parse paths** (gap row — server and
  client parser do not strictly reject > 32 bytes on the legacy field).
- **Bad client Finished unit tests on the server side** (partial — the
  path exists but tests are referenced as missing in NEGATIVE_SPACE and in
  THREAT_MODEL).

The external tlsfuzzer / TLS-Anvil runners cover a separate negative
corpus. The PR-gated tlsfuzzer set is listed in `NEGATIVE_SPACE.md`
§"External conformance coverage" and is **not** part of `zig build test`.
Any hunt that claims external coverage should reference the appropriate
workflow under `conformance/`.

## Attack surface per subsystem

For each subsystem, list the attack class families likely to apply. Then
the hunt queue in §"Hunt queue" pins specific (class, surface, entry)
triples so a hunter does not re-derive the subsystem from scratch.

### 1. Record layer (`frame.zig`, `RecordLayer.zig`, `RecordBuffer.zig`)

- **Parser abuse** — `parseHeader` accepts any byte as ContentType; the
  enum has a `_` arm. The dispatch is in the consuming code
  (`ServerHandshake.handleWaitClientHello` and `RecordLayer.decrypt`)
  rather than the header parser itself.
- **AEAD / nonce** — `construct(iv, seq)` is pure Zig, seeded with seq;
  the only fuzz exposure is `decrypt` rejection of bad AEAD output. The
  sequence-number overflow / key-usage-limit tests are unit-tested but
  exhaust the limits *together* only in fuzz.
- **Inner-plaintext parsing** — `memx.lastIndexOfNonZero` returns `Option`
  on inner plaintext; the `InvalidInnerPlaintext` path is exercised by
  fuzz but only the `decrypt` fuzz corpus.

### 2. Handshake framing (`handshake.Reader`, `wire.Reader`)

- **Length truncation** — `wire.Reader.assumeRead*` family trusts
  `msg.len` bounds and will not panic as long as the caller computes
  `body_len` correctly. The defense here is the per-parser
  `body_len != msg.len - 4` check (server_hello, encrypted_extensions,
  certificate, certificate_request, NewSessionTicket all have it).
- **Coalescing** — handshake messages may be packed in one record. The
  `HandshakeReader.next()` walks them; it never crashes on a partial
  suffix because it restores `r.pos`.

### 3. ClientHello / ServerHello / HRR

- **Extensions placement** — `supported_versions` must appear in
  ServerHello/HRR and ClientHello; the parse path in `server_hello.zig`
  checks `MissingExtension` *after* `supported_versions` has selected, so
  extending the order is a known-shape attack to test.
- **Duplicate singleton extensions** — covered by
  `extension_type.rejectDuplicateExtensions`.
- **Cipher suite + group narrowing** — server narrows the client's offer
  list; the failure path is `UnsupportedCipherSuite` /
  `UnsupportedKeyShareGroup`.

### 4. EncryptedExtensions

- **Offered-vs-unoffered gate** — `server_name` / `record_size_limit` /
  `early_data` allowed only if the corresponding bit is in
  `opts.offered_extensions`. Logic bug here = unauthenticated state
  dependency.
- **ALPN cross-check** — server ALPN must be drawn from
  `offered_alpn` (`parseAlpn` performs this in
  `src/encrypted_extensions.zig:166`).
- **Internal message placement** — server-echoed
  `status_request/heartbeat/...` are rejected as
  `UnexpectedExtension`.

### 5. Certificate path (`certificate.zig`, `certificate_parser.zig`,
   `certificate_policy.zig`)

- **DER parsing** — DER/ASN.1 is the most-attacked leaf in the world.
  Known-shape attacks: zero-length BIT STRING, INTEGER with leading zero
  + extra byte, indefinite-length, constructed on a primitive,
  BOOLEAN-as-anything, NULL when not NULL, IA5String malformed.
- **Chain construction** — `parseServerChain` walks certificate_list
  until the first error; the trust-store, KeyUsage / EKU, hostname,
  and signature-scheme policy all happen after parsing succeeds.
- **trust-anchor policy gap** — `insecure_no_chain_anchor` is a
  documented MITM-vulnerable mode. Not a parse bug, but hunt work needs
  to respect the documented boundary.

### 6. Finished, CertificateVerify

- **Verification fails closed** — `finished.zig` and
  `signature.verifies()` both fail closed with deterministic errors.
  Failure paths: `error.InvalidVerifyData` (Finished),
  `error.SignatureVerificationFailed` (CertificateVerify). Covered by
  NEGATIVE_SPACE §"Verification gates".

### 7. AEAD (aead.zig)

- **Nonce/AAD construction** is pure Zig. The only input from the
  attacker is the encrypted record; all attack variants reduce to
  "AEAD fails closed." Already covered.

### 8. Post-handshake / control-plane

- **KeyUpdate flood** — bounded by `handshake.max_post_handshake_messages`
  (16). NEGATIVE_SPACE §"Client-side bad server behavior" /
  "Server-side bad client behavior" both rate this evidence row as
  covered with a test, not a fuzz.
- **Simultaneous KeyUpdate** — both sides remain connected; covered by
  integration test.
- **Alert handling** — alert bytes smuggled inside the AEAD inner
  plaintext. The decoder's `isFatal()` ignores the legacy AlertLevel
  byte for non-`user_canceled`/`close_notify` descriptions.

### 9. PSK / 0-RTT (RFC 8446 §4.2.11, §4.1.3, §4.2.10, §4.5, §4.6.1)

- **Binder verification** — `startWithPsk` computes a binder over the
  ClientHello plus the partial server-identity transcript. Server-side
  fork of the same logic in `acceptClientHello` must produce a matching
  binder. Section-interaction: §4.2.11 binder = HMAC over
  `truncated_transcript(SHA of CH) || ...`. Reasoning depth is the
  bottleneck.
- **0-RTT decryption** on the server: `ServerHandshake.handleWaitClientFinished`
  tries to decrypt under `early_rx` first if `early_rx` is set and
  `end_of_early_data_received` is false; the comment around `early_rx`
  warns that an early_rx *failure* must NOT fall through to handshake
  decrypt (in-place corruption). The condition `if (!self.end_of_early_data_received)`
  is the gate that must not be confused.
- **HRR + 0-RTT + PSK** — three interacting flights can produce a
  multi-state path that interacts with the binder computation.

## Hunt queue

Eight narrow tasks. Each is one (attack class, target surface, entry
point) plus a proof artifact a `whitehat-hacker` can chase. Items marked
**Fable-worthy** are reserved for `siege` because reasoning depth is the
bottleneck rather than single-function bounds checking. The pre-Fable
filter recommendation: if the hunter's first move is "read the bytes at
offset X and check the bounds," leave it on opus.

### H1 — EncryptedExtensions offered-vs-unoffered gate logic and
       per-extension placement dual with ServerHello extension subset
- **Attack class:** parser+state-machine. The server is allowed to
  return a subset of the client-offered extensions; mismatched
  understanding of that subset is a state-divergence attack.
- **Target:** `src/encrypted_extensions.zig:96 (`parse`),
  `src/encrypted_extensions.zig:166 (`parseAlpn`), the `Options`
  passed by `ClientHandshake.processFlightMessage`. Cross-cut with
  `src/extension_type.zig:42 (`rejectDuplicateExtensions`).
- **Entry point:** `ClientHandshake.processFlight(payload, policy)` —
  → `parseFlightMessage` `wait_ee` arm → `encrypted_extensions.parse`.
- **Trust boundary:** Network → processFlightMessage → parse. Bytes
  inside the encrypted server flight; AAAD authenticates them.
- **Why fruitful:** NEGATIVE_SPACE has the EE parser marked *partial*
  — no standalone fuzz target — and ALPN, server_name,
  record_size_limit, and early_data each carry a different identity
  rule (acknowledge-when-offered; act-when-acknowledged). A mutation
  that walks the EE block with seed variations on the offered-set
  membership is a high-yield corpus surface.
- **Existing coverage:** per-row unit tests in
  `encrypted_extensions.zig` (ALPN rejection paths, offered/unoffered
  arms), but no `--fuzz` seed dataset. tlsfuzzer covers a few rows
  externally per `NEGATIVE_SPACE.md` §"External conformance coverage".
- **Proof artifact:** a `zig build test --fuzz` corpus seed list that
  hits all four *`extension X is server-offerable`* arms; on first
  crash a reproducer unit test inside `encrypted_extensions.zig` or
  appended to the fuzz target. The hunter should also produce a
  dv-style test that pairs a malicious EE with a `parseServerHello`
  path showing the cross-message group divergence.
- **Priority:** P1.
- **Validator focus:** does the boundary actually rely on
  `opts.offered_extensions` or fall back to "trust nothing"?
- **Fable-worthy:** no. Single-parser surface with targeted seeds.

### H2 — Certificate parse + chain verification under hostile DER
- **Attack class:** parser abuse + verification-gate bypass. DER/ASN.1
  has a long history of malformed-type attacks
  (zero-length BIT STRING, illegal INTEGER encoding, indefinite
  length, constructed-on-primitive). Curve-key validation and trust
  policy enforcement are separate layers below the parse.
- **Target:** `src/certificate_parser.zig` (the DER walker),
  `src/certificate.zig:111 (`parse`), `:171 (`parseClientChain`),
  `:101 (`parseClientCertificate`), `src/certificate_policy.zig`,
  `src/certificate_chain.zig`.
- **Entry point:** `ClientHandshake.processFlight` →
  `processServerCertificate` → `certificate.parse`, and
  `ServerHandshake.handleRecord` →
  `processClientCertificate` → `certificate.parseClientCertificate`.
- **Trust boundary:** Network → encrypted server flight
  (Certificate entry in coalesced flight, AAAD-authenticated) and
  network → encrypted client Certificate (AAAD-authenticated with
  request_context echo from CertificateRequest).
- **Why fruitful:** Coverage is *partial* per NEGATIVE_SPACE §"Parser
  and crypto boundary fuzz surfaces". The leaf parser has a fuzz seed
  (`certificate.zig:1470`) but the chain validation path and the
  client-auth flow with `parseClientChain` are not separately fuzzed.
  DER is the most exhausted surface in the corpus history.
- **Existing coverage:** `certificate.zig` unit tests cover
  happy-path and a few malformed-frame cases (length, type),
  Wycheproof boundary tests for X25519/`signature.zig`. Certificate
  trust-chain verification uses caller-supplied `certificate.Policy`;
  hostname / KU / EKU / signature-scheme tests live in
  `certificate_policy.zig`. No standalone `parseClientChain` fuzz.
- **Proof artifact:** a `zig build test --fuzz` reproducer that drops a
  1KB DER blob with malformed INTEGER/BIT STRING/SET nesting into
  `certificate.parseServerChain(<msg>, policy)`. On crash a unit test
  pinned to the failing bytes. Secondary: a `parseClientChain` fuzz
  with a known bad request_context length.
- **Priority:** P0.
- **Validator focus:** the bug is reachable from `processFlight`, not
  only from `parse`; the chain walker must be in the call trace.
- **Fable-worthy:** no. Routine parser audit.

### H3 — ServerHello parse gaps: legacy_session_id length cap, key_share
       group/length enum, and `missing extension` after supported_versions
- **Attack class:** parser abuse.
- **Target:**
  - legacy id length: `src/server_hello.zig` parse path, around the
    `legacy_session_id_echo` field read.
  - key_share group / length: `src/server_hello.zig` `UnsupportedKeyShareGroup`
    path (partial coverage per NEGATIVE_SPACE).
  - missing extensions: `src/server_hello.zig`
    `error.MissingExtension` (no dedicated `key_share`-absent test).
- **Entry point:**
  `ClientHandshake.handleRecord(...)` → `processServerHello` →
  `server_hello.parse`.
- **Trust boundary:** Network → plaintext ClientHello response
  (ServerHello). No AAAD protection until the keys are derived, so
  any reachable parse-stage bug here is a pre-key channel crash.
- **Why fruitful:** NEGATIVE_SPACE marks legacy-session-id length cap
  as **gap** for both directions, key_share as *partial*, and
  `missing supported_versions after key_share` as a defined-but-untested
  error. Three narrow items in one parser.
- **Existing coverage:** downgrade-sentinel, legacy_version, missing
  supported_versions tests are good; the gaps above are not yet
  reachable from a deterministic unit test.
- **Proof artifact:** three unit tests appended to `server_hello.zig`:
  (a) 33-byte legacy_session_id, (b) `key_share` with malformed group
  byte and len=0, (c) ServerHello with `supported_versions` selecting
  TLS 1.3 but missing `key_share`.
- **Priority:** P0.
- **Validator focus:** legacy_session_id > 32 must surface as
  `InvalidExtensionLength`-class error, never a silent truncation.
- **Fable-worthy:** no.

### H4 — processFlight state-machine transition attacks across
       wait_cert_or_cr → wait_cert vs finished fast-path (PSK)
- **Attack class:** state-machine confusion.
- **Target:** `src/ClientHandshake.zig:1483 (`processFlightMessage`),
  `:1470 (`processServerCertificate`), and the `wait_cert_or_cr` arm
  that accepts three message types (CertificateRequest, Certificate,
  Finished).
- **Entry point:**
  `ClientHandshake.handleRecord(...)` →
  `processHandshakeRecord` →
  `processFlight` →
  `processFlightMessage`.
- **Trust boundary:** Network → encrypted server flight. AAAD-
  authenticated.
- **Why fruitful:** the `wait_cert_or_cr` arm has three legal message
  types but the server can't legally send more than one. A fuzz can
  construct a flight that triggers one or more transitions out of
  guard order, then smuggles a post-state message. The
  `fuzzProcessFlight` target in `ClientHandshake.zig:3645` runs the
  fuzz after `processServerHello` succeeds, but the seed list is
  empty (`{}`) — only mutation tests the surface. The relevant path
  requires Intent or, more usefully, some structured seeds.
- **Existing coverage:** `processFlight: rejects Finished before
  EncryptedExtensions` test exists; CertificateRequest before EE,
  finished in PSK case, Certificate→CV→Finished happy-path are
  covered. Out-of-order or duplicated Certificate / CV cases want
  combined coverage.
- **Proof artifact:** a `processFlight` acceptance test that drives
  a malformed flight shape past the happy path, then asserts the
  state machine does not promote to `send_finished` or `.connected`
  while progress tracking flags disagree. Two unit tests are likely
  enough to demonstrate reachability before feeding the fuzz target
  with structured seeds.
- **Priority:** P1.
- **Validator focus:** `server_flight_progress` invariants;
  `processFlightMessage` state machine must advance state only after
  the progress gate is satisfied.
- **Fable-worthy:** no, but **H4 + H5a** (next item) together push
  across the Fable threshold.

### H5 — PSK binder verification and 0-RTT state transitions
- **Attack class:** RFC section-interaction + multi-flight state
  confusion.
- **Target:**
  - `src/ClientHandshake.zig:664 (`startWithPsk`) — binder
    computation must match server; cross-section
    RFC 8446 §4.2.11 (binder), §4.1.3 (ServerHello extensions), §7.1
    (partial transcript), §4.6.1 (ticket).
  - `src/ServerHandshake.zig:351 (`selectPsk`) — caller-supplied
    `PskLookup` is consulted with the binder; if the binder-mismatch
    path is reachable through fuzz, the connection must abort.
  - `handleWaitClientFinished` early-data decrypt path
    (`src/ServerHandshake.zig:1558` and onward, server side).
- **Entry point:**
  - Client: `startWithPsk(out)` emits CH + binder; subsequent server
    reception feeds back into `processServerHello` and `processFlight`.
  - Server: `acceptClientHello(out)` produces HRR-shaped
    negotiations; binder is computed client-side against the server's
    view of the transcript.
- **Trust boundary:** Network → plaintext CH extension pre-key,
  Network → encrypted flight post-shared-secret. Binder is computed
  over a partial transcript, so any flaw that lets a peer alter the
  inputs without the binder reflecting it is a bypass.
- **Why fruitful:** this is **the** Glasswing high-value surface for
  TLS 1.3 resumption. NEGATIVE_SPACE marks the binder and 0-RTT rows
  covered, but THREAT_MODEL marks 0-RTT anti-replay caller-owned
  and §"Open threat-relevant gaps" lists BoGo / TLS-Anvil breadth and
  the server-side bad-Finished unit tests as partial. The boundary
  between sections 4.2.11, 4.1.3, and 7.1 is precisely the kind of
  thing a multi-section trace is the only way to falsify.
- **Existing coverage:** `THREAT_MODEL.md` §"Defended attack classes"
  → "PSK/session resumption…" and the listed client-side
  bad-server tests. NOT covered: server-side reject paths for
  injected binders, offered-PSK-vs-binder-bitmismatch vector,
  0-RTT data replay through the early_rx decrypt path
  (`ServerHandshake.zig:1558`).
- **Proof artifact:** a transcript trace showing (a) client emits
  CH with binder=b1 over truncated transcript t1, (b) server
  receives a flight that diverges from t1 but for which the binder
  still verifies. Equivalent trace for 0-RTT: client offers early
  data, server accepts in EE, client does NOT send
  `EndOfEarlyData`, server must not conflate the early-data key and
  the handshake key on the in-flight record. Reproducer should be
  driven via the existing tests with a small modification monkey-
  patching the transcript.
- **Priority:** P0.
- **Validator focus:** a Fable-grade validator is justified because
  reasoning depth is the bottleneck: confirm that any reachable bug
  here is a protocol bug, not a trivial parse bug, by tracing the
  full handshake flight across three RFC sections.
- **Fable-worthy:** **yes**. Multi-section reasoning and a multi-
  flight state trace are required.

### H6 — Server Certificate `request_context` non-empty rejection (gap)
- **Attack class:** parser gate gap.
- **Target:** `src/certificate.zig:101 (`parseClientCertificate`) —
  this is the client-auth-facing parser and explicitly rejects a
  mismatched request_context. The server-side parser used to read a
  server Certificate (e.g. in the opposite direction if a peer were
  confused about role) does NOT have an equivalent check, per
  NEGATIVE_SPACE §"Client-side bad server behavior" → "Server
  Certificate request_context is non-empty".
- **Entry point:** the relevant code path is server-side mirroring
  of `parseClientCertificate` — to be located before fixing. Likely
  consumer: a checker utility or the server's own verifier path
  reading an inbound Certificate.
- **Trust boundary:** Network → encrypted client Certificate payload
  (or a peer that confused role, post-shared-secret). Even under a
  correct server role, the parser must reject a server-shaped
  Certificate with non-empty request_context.
- **Why fruitful:** NEGATIVE_SPACE marks this as a **gap**. No
  targeted test exists. H6 is cheap, narrow, and required as a
  regression bar before any other hunt pulls a partial Certificate
  parser change.
- **Existing coverage:** none.
- **Proof artifact:** one unit test that calls the server-side
  Certificate parser with a `request_context` of length ≥ 1 and
  asserts `error.UnexpectedCertificateRequestContext` (or an
  `InvalidHandshakeLength` / `InvalidVectorLength` class
  equivalent, depending on which surface the fix attaches to).
- **Priority:** P2.
- **Validator focus:** does the rejection happen before any
  downstream parser consumes the request_context bytes?
- **Fable-worthy:** no.

### H7 — Legacy session-id length cap on client and server ClientHello
       parse paths (gap)
- **Attack class:** parser abuse (DoS / bounded-buffer abuse).
- **Target:**
  - ClientHello parse in `src/client_hello.zig` (the `legacy_session_id`
    field, RFC 8446 §4.1.2 limits to ≤ 32 bytes).
  - Same field on server-side `acceptClientHello` in
    `src/ServerHandshake.zig`.
- **Entry point:** `ServerHandshake.handleRecord(record, out)` →
  `handleWaitClientHello` → `handleClientHelloRecord` →
  `processClientHelloMessage` → `client_hello.parse`.
- **Trust boundary:** Network → plaintext initial ClientHello. No
  AAAD. Any reachable pre-key parser crash is a serious issue.
- **Why fruitful:** NEGATIVE_SPACE marks this as **gap** for both
  sides. The unit tests for malformed ClientHello exercise a few
  shapes but not legacy_session_id length specifically. Cheap,
  narrow, and gates any post-handshake DoS analysis.
- **Existing coverage:** `client_hello.zig` and
  `ServerHandshake.zig` unit tests cover several malformed-CH
  shapes; legacy_session_id length is not in that list.
- **Proof artifact:** one ClientHello parse test with a
  `legacy_session_id` field of 33 bytes; assert a clean rejection
  error class.
- **Priority:** P2.
- **Validator focus:** does the parse drop bytes cleanly without
  reading past the declared length? Does the server-side accept
  path reject (`UnsupportedClientHello` / equivalent) before
  allocating from the parsed value?
- **Fable-worthy:** no.

### H8 — Server-side bad-ClientFinished negative tests (partial)
- **Attack class:** verification-gate bypass.
- **Target:**
  - `src/ServerHandshake.zig:1276 (`processClientFinished`).
  - `src/finished.zig` Finished MAC verification path.
- **Entry point:**
  `ServerHandshake.handleRecord(...)` →
  `handleWaitClientFinished` →
  `processClientFinished` (path: decryption + verification).
- **Trust boundary:** Network → encrypted record carrying
  ClientFinished. AAAD-authenticated.
- **Why fruitful:** NEGATIVE_SPACE §"Verification gates" → "Server
  must verify client Finished before application keys" is marked
  partial — bad Finished unit tests are flagged as missing.
  THREAT_MODEL §"Handshake authentication and key promotion"
  acknowledges this gap. This is a verification-gate edge.
- **Existing coverage:** the happy-path and one structural test
  exist; "bad verify_data" cases (tampered MAC, trimmed Finished,
  Finished + extra handshake message, non-Finished in
  `wait_client_finished`) are partial.
- **Proof artifact:** four unit tests in
  `ServerHandshake.zig`:
  (a) bad `verify_data` byte,
  (b) Finished length = 0 (handled elsewhere),
  (c) Finished + CertificateRequest in the same record,
  (d) CertificateRequest alone in `wait_client_finished`.
- **Priority:** P1.
- **Validator focus:** the encrypted-flight path genuinely verifies
  the MAC; the test must reach `verifyClientFinished` (not be
  rejected earlier by a fragment-length check).
- **Fable-worthy:** no.

## Out of scope for this pass

- **PQ and P-384 key exchange** — outside the supported surface per
  THREAT_MODEL.md. Future hunt when the corresponding workspace task
  in PRODUCTION_READINESS.md and `CONFORMANCE_ROADMAP.md` reaches
  that slice.
- **Backend-internal sanitizer evidence under ASan/MSan** — these
  belong to `benchmark-methodologist`/`fuzz-engineer`, not the recon
  pass. The boundary surfaces are listed; running them under
  sanitizers is a follow-up.
- **kTLS UAPI behavior** — outside the protocol surface.
- **TLS 1.2 / DTLS / SSL 3.0 fallback** — ztls implements TLS 1.3
  only.
- **Trust-store loading** — caller-owned. Hunt work that suggests
  "add trust anchors to ztls" is misaligned.
- **Memory-safety evidence under ASan** — recommended as a
  parallel to backend-side observability, not a recon deliverable.

## Cross-document index

- `THREAT_MODEL.md` — adversary capabilities, defended classes with
  evidence, non-goals. Read this for the Boolean risk boundaries.
- `NEGATIVE_SPACE.md` — per-malformed-input response table. Read
  this for the row-by-row ground-truth; do not duplicate its rows.
- `RFC8446_MUST_MATRIX.md` — claims-to-evidence map for normative
  requirements. RFC 8446 + RFC 8701 + RFC 8449 are the spec family.
- `DESIGN.md` — architecture, Sans-I/O rationale, prior art. The
  reasons ztls makes these specific choices.
- `PROVIDER_INTERFACE.md` — the libcrypto facade shape.
- `PRODUCTION_READINESS.md` — status. The single source of truth.
  This recon doc must not contradict it; if the recon identifies a
  gap that should be tracked, the readiness table is where it goes.

