# research

Design notes, RFC references, prior art, conformance/sub-feature roadmaps,
perf methodology, and committed capture evidence for ztls. Status — what is
done and how we know it — lives in `PRODUCTION_READINESS.md`; nothing here
re-asserts it.

## design

- [`DESIGN.md`](DESIGN.md) — goals, non-goals, prior art (BearSSL, rustls,
  Go `crypto/tls`), Sans-I/O pattern, RFC reference table, architecture,
  consumer-facing API sketch, and crypto backend boundary notes.
- [`PROVIDER_INTERFACE.md`](PROVIDER_INTERFACE.md) — ztls-owned crypto
  facade shape (AEAD, HKDF/hash policy, named groups, signatures,
  capabilities, memory ownership, error mapping) for libcrypto-family
  backends.

## correctness

- [`CORRECTNESS.md`](CORRECTNESS.md) — local correctness gate commands and
  external-suite mechanics (tlsfuzzer, Wycheproof, fuzzing). Pure runbook;
  status-bearing evidence is rooted in `PRODUCTION_READINESS.md`.
- [`RFC8446_MUST_MATRIX.md`](RFC8446_MUST_MATRIX.md) — claims-to-evidence
  map for TLS 1.3 normative requirements with named test/caller/disposition
  evidence.
- [`NEGATIVE_SPACE.md`](NEGATIVE_SPACE.md) — supported-surface catalogue of
  malformed and malicious peer inputs and the engine response with evidence.
- [`TLS_ANVIL_NOT_ATTEMPTED.md`](TLS_ANVIL_NOT_ATTEMPTED.md) — classification
  of endpoint-mode rows that a completed server-mode TLS-Anvil run did not
  exercise, split into in-scope runner debt and explicit out-of-scope rows.
- [`THREAT_MODEL.md`](THREAT_MODEL.md) — in-scope adversary capabilities,
  defended attack classes with evidence, non-goals, and caller boundaries.

## roadmaps

These track features and gates that are not yet part of the supported
surface. Each is a precondition list plus acceptance criteria — never a
status claim.

- [`CONFORMANCE_ROADMAP.md`](CONFORMANCE_ROADMAP.md) — HelloRetryRequest,
  PSK/resumption, 0-RTT, client cert auth, PQ groups, and external runners
  (TLS-Anvil, BoGo, tlsfuzzer lockstep).
- [`BOGO_DEFERRED.md`](BOGO_DEFERRED.md) — decision record and re-entry bar
  for deferring BoringSSL BoGo runner integration instead of carrying a fake
  shim or workflow.
- [`API_ROADMAP.md`](API_ROADMAP.md) — HTTPS wrapper acceptance criteria,
  io_uring client proof shape, and the future client-auth policy shape.
- [`CRYPTO_ROADMAP.md`](CRYPTO_ROADMAP.md) — backend allocation contract,
  backend seams, milestones (OpenSSL → AWS-LC → BoringSSL), PQ/hybrid
  extension path, success criteria routed to `PRODUCTION_READINESS.md`.

## conformance suite scope

- [`bettertls.md`](bettertls.md) — what `bettertls` validates, how ztls
  covers the local slice without vendoring the Go harness, and the future
  harness path.
- [`C_ABI_CONFORMANCE.md`](C_ABI_CONFORMANCE.md) — gate shape for #30, including the C harness under TLS-Anvil, skip-list inheritance from the #52 DSA-root classifier, new surface (handshake/alerts/KeyUpdate), and the FFI-residual gap that the C harness does not cover.

## performance

- [`PERFORMANCE.md`](PERFORMANCE.md) — benchmark scenario plans, equivalence
  methodology (where ztls / libssl / rustls / EVP rows are comparable),
  per-row timed-work inventories, profiling-tool notes, and row-oriented
  perf/disassembly tooling.
- [`perf/`](perf/) — committed benchmark captures and the benchmark explanation
  template (`perf/EXPLANATION_TEMPLATE.md`). Captures include the EC2 baseline
  [`perf/20260613-182405-ec2-c7i-large/`](perf/20260613-182405-ec2-c7i-large/)
  and the local AWS-LC provider-lane capture
  [`perf/20260705-160550-awslc-local/`](perf/20260705-160550-awslc-local/).

## references

- [`rfcs/`](rfcs/) — full RFC text files for offline reference:
  - `rfc8446-tls13.txt` — TLS 1.3 (primary)
  - `rfc5869-hkdf.txt` — HKDF
  - `rfc8439-chacha20-poly1305.txt` — ChaCha20-Poly1305 AEAD
  - `rfc7748-x25519-x448.txt` — X25519 / X448 key exchange
  - `rfc8032-eddsa.txt` — EdDSA / Ed25519
  - `rfc8448-tls13-examples.txt` — TLS 1.3 example handshake traces with
    known numerical test vectors
