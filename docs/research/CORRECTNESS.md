# Correctness and conformance evidence

ztls correctness is built as layered evidence, not a single claim. The core remains
Sans-I/O and allocation-free; external harnesses wrap it only for conformance.

## Local correctness gate

Run the local correctness gate with:

```sh
just ci
```

The authoritative readiness status and evidence summary lives in `PRODUCTION_READINESS.md`.

`NEGATIVE_SPACE.md` is the supported-surface catalogue of malformed and
malicious peer inputs: each row names ztls's response and the test evidence or
an explicit gap. `THREAT_MODEL.md` defines the attacker capabilities,
defended attack classes, non-goals, and caller responsibilities.

## tlsfuzzer

`conformance/` contains a pytest/tlsfuzzer suite. The fixture starts
`conformance/zig-out/bin/tlsfuzzer_server`, a thin TCP wrapper around the Sans-I/O
`ServerHandshake`, on an ephemeral localhost port and fails if the server process
crashes before or during any test.

Run directly with:

```sh
just conformance/tlsfuzzer -q
```

The suite is protocol conformance evidence: it checks real wire behavior, alerts, and
state transitions against an independently maintained TLS test framework.

**Caveat:** tlsfuzzer tests the ztls server only. Client-side alert/state
behavior against a malicious server is not covered by this runner.

## Wycheproof boundary vectors

`zig build test` runs selected Wycheproof v1 vectors at ztls's libcrypto
boundary. These tests do **not** claim that ztls implements primitive
crypto. ztls does not implement AES-GCM, ChaCha20-Poly1305, X25519, or ECDSA
primitives. The purpose is to verify wrapper behavior:

- AEAD AAD/nonce/tag plumbing
- invalid tag rejection through `EVP_DecryptFinal_ex`
- X25519 byte order and shared-secret handling
- low-order/identity public key rejection mapped to `error.IdentityElement`

## Fuzzing

Fuzz targets are ordinary Zig tests using `std.testing.fuzz`. Run with Zig's fuzz
mode, for example:

```sh
zig build test -- --fuzz
```

Fuzz inventories and remaining gaps are tracked in `PRODUCTION_READINESS.md`; add new
targets there when their evidence changes.

The server `handleRecord` fuzz targets cover both the pre-auth boundary where
raw wire bytes first enter the Sans-I/O server and the connected post-auth
record-dispatch boundary. Post-auth fuzz seeds include cryptographically valid
application-data and KeyUpdate records so mutation can reach encrypted dispatch
paths instead of only AEAD authentication failures. `alert.parse` and
`RecordLayer.decrypt` are also fuzzed as local parser/record-boundary surfaces.

## Verification gates

The client and server handshakes carry explicit verification gates:

- client: Certificate, CertificateVerify, and server Finished must be verified
  before `clientFinished()` can promote to connected/application keys.
- server: client Finished must be verified before the server transitions to
  connected/application keys.

This mirrors rustls's proof-token idea in a Zig-appropriate form: the final
connected transition has an auditable local condition rather than relying on a
large implicit control-flow argument.


## External suite policy

External-suite scope, skip lists, and active readiness status live in
`PRODUCTION_READINESS.md` and the relevant GitHub issues. This file keeps only
runner mechanics and the rationale for each suite.
