# Threat model

ztls is a Sans-I/O TLS 1.3 engine. The caller owns transport I/O, buffers,
trust anchors, private-key storage, connection lifetime, and deployment policy.
ztls owns TLS record framing, record protection plumbing, handshake state,
verification gates, KeyUpdate handling, alert emission helpers, and the contract
between TLS logic and the libcrypto-family backend.

This document names the adversary ztls is designed against, the attack classes
ztls currently defends, the evidence for those defenses, and the boundaries that
remain caller responsibility or open project work. The lower-level malformed
input catalogue lives in `NEGATIVE_SPACE.md`; the normative RFC MUST matrix
lives in `RFC8446_MUST_MATRIX.md`.

## Supported surface covered here

The current threat model covers the implemented TLS 1.3 surface:

- TLS 1.3 only. No TLS 1.2 fallback, no DTLS.
- X25519 and P-256 key exchange.
- The three mandatory TLS 1.3 AEAD suites:
  `TLS_AES_128_GCM_SHA256`, `TLS_AES_256_GCM_SHA384`, and
  `TLS_CHACHA20_POLY1305_SHA256`.
- Server-authenticated 1-RTT handshake. Client certificate authentication is not
  implemented yet (#4).
- Application data, alerts, `close_notify`, and KeyUpdate in both directions.
- NewSessionTicket is parsed for structural validity and discarded until PSK /
  resumption exists (#2).
- HelloRetryRequest (#1), PSK/resumption (#2), 0-RTT (#3), client auth (#4),
  and P-384 / PQ groups (#6) are explicitly outside the current implemented
  surface. Extension behavior beyond the current surface is tracked
  by the feature issue that introduces that extension.

## In-scope adversary capabilities

The attacker may be an active network attacker or a malicious TLS peer. In
particular, assume the attacker can:

- read, inject, modify, truncate, drop, replay, and reorder TLS records;
- send arbitrary byte sequences at parser and `handleRecord` entry points;
- send syntactically valid but semantically illegal TLS messages;
- choose invalid, unsupported, duplicated, or missing extensions;
- corrupt AEAD ciphertexts, tags, AAD, and record sequence expectations;
- present arbitrary certificates, chains, public keys, and signatures;
- attempt downgrade and version-confusion patterns;
- send unbounded streams of post-handshake control messages;
- close the connection at any point with alerts or transport EOF.

The attacker cannot force ztls to perform transport I/O or allocation in the TLS
engine, because ztls has neither transport ownership nor ztls-owned heap state.
Backend-owned libcrypto allocations are outside the engine allocation contract
and are documented as backend behavior, not ztls buffer ownership.

## Defended attack classes

### Record tampering and replay

ztls authenticates encrypted records with the negotiated AEAD and constructs the
per-record nonce from the traffic IV XOR the big-endian record sequence number.
Modified ciphertext, tag, AAD, or replay under the wrong sequence number fails
AEAD authentication rather than yielding plaintext.

Evidence:

- `RecordLayer.zig`: `decrypt: replayed record is rejected`.
- `RecordLayer.zig`: sequence-overflow and key-usage-limit tests.
- `aead.zig`: tampered ciphertext/tag/AAD tests.
- `ClientHandshake.zig`: `handleRecord: corrupted encrypted flight is rejected`.
- tlsfuzzer corrupted application-data record conversation.
- `NEGATIVE_SPACE.md` record-framing and record-protection rows.

### Record-boundary and parser robustness

ztls rejects oversized records, treats incomplete records as incomplete input,
and fuzzes the major parser and dispatch surfaces. Malformed inputs must produce
errors or incomplete-input signals, not panics or out-of-bounds access.

Evidence:

- `frame.zig`: short and oversized header tests plus parse fuzzing.
- `RecordBuffer.zig`: truncated and oversized record tests.
- `RecordLayer.zig`: truncated ciphertext and decrypt fuzzing.
- `alert.zig`, `server_hello.zig`, `client_hello.zig`, `NewSessionTicket.zig`:
  parser tests and fuzz targets.
- `ClientHandshake.zig`: bad-server tests for malformed ServerHello, truncated
  encrypted flight, out-of-order flight messages, and illegal application data.
- `ServerHandshake.zig`: pre-auth and connected `handleRecord` fuzz targets.
- `NEGATIVE_SPACE.md` parser/fuzz rows.

### Handshake authentication and key promotion

The client must verify Certificate, CertificateVerify, and server Finished before
it can send its own Finished and promote to application traffic keys. The server
must verify client Finished before it promotes to connected/application keys.
Bad CertificateVerify signatures and bad Finished MACs stop the handshake. The
server-side bad-Finished rejection path is structurally enforced, but dedicated
state-machine negative tests are still a gap below.

Evidence:

- `ClientHandshake.zig`: `processFlight: rejects wrong CertificateVerify
  signature`.
- `ClientHandshake.zig`: `processFlight: rejects wrong server Finished
  verify_data`.
- `ClientHandshake.zig`: `clientFinished: RFC 8448 §3 emits Finished and
  upgrades to app keys`.
- `ServerHandshake.zig`: `processClientFinished: verifies Finished and installs
  app keys`.
- `finished.zig`: wrong verify_data and wrong handshake type tests.
- `certificate.zig`: signature verification and policy tests.
- `NEGATIVE_SPACE.md` verification-gate rows.

### Certificate policy failures

ztls can verify server certificate chains against caller-provided trust anchors
and enforce hostname, KeyUsage, EKU, signature-algorithm policy, and RFC 5280
name constraints before the client handshake completes. The caller must provide
the trust bundle and policy; ztls does not load OS roots.

Important current boundary: chain anchoring only happens when
`certificate.Policy.bundle` is set. A client policy with neither a bundle nor
the explicit `insecure_no_chain_anchor` test/demo opt-in rejects the Certificate
with `error.MissingTrustAnchor`. The insecure opt-in still verifies
CertificateVerify key possession, applies leaf certificate policy, and lets
`ClientHandshake.start()` fill `Policy.host_name` from SNI when no explicit
hostname is set, but it does not authenticate the chain to any trust root. In
that mode, ztls does not defend against an active MITM presenting a self-signed
certificate for the target hostname.

Evidence:

- `certificate.zig` and `certificate_policy.zig` tests for hostname mismatch,
  missing intermediates, untrusted leaf, KeyUsage without `digitalSignature`,
  EKU without `serverAuth`, and unsupported signature algorithms.
- `ClientHandshake.zig` server-flight tests bind CertificateVerify to the leaf
  public key and transcript.

Name-constraints enforcement covers DNS, IP, rfc822Name, and URI GeneralName
forms in permitted/excluded subtrees. Chain-level fixture tests cover DNS;
synthetic DER unit tests cover IP, rfc822Name, URI, critical unsupported-subtree
rejection, and explicit `minimum = 0`. Unsupported GeneralName forms inside a
critical Name Constraints extension are rejected rather than silently ignored.

### Key-exchange invalid-point handling

ztls delegates X25519 arithmetic to libcrypto but rejects identity-element shared
secrets before they enter the TLS key schedule.

Evidence:

- `x25519.zig`: identity and small-order public-key rejection tests.
- Wycheproof boundary vectors for X25519.
- `NEGATIVE_SPACE.md` key-exchange rows.

### Version confusion and downgrade attempts

ztls implements only TLS 1.3. There is no TLS 1.2 fallback path to negotiate.
ServerHello `supported_versions` must select TLS 1.3, and unsupported versions
are rejected.

Evidence:

- `server_hello.zig`: unsupported TLS version tests; `parse: rejects TLS 1.2
  downgrade sentinel` and `parse: rejects TLS 1.1 downgrade sentinel` cover
  RFC 8446 §4.1.3 downgraded-connection sentinel detection (R004-020
  `PROVEN`).
- Client/server handshake tests use TLS 1.3 key schedule and RFC 8448 vectors.

### KeyUpdate abuse and post-handshake control traffic

ztls bounds consecutive post-handshake control messages, rejects KeyUpdate when
it does not end at a record boundary, and handles simultaneous update requests
without disconnecting or desynchronizing traffic keys.

Evidence:

- `ClientHandshake.zig` and `ServerHandshake.zig`: KeyUpdate flood tests.
- `ClientHandshake.zig` and `ServerHandshake.zig`: KeyUpdate record-boundary
  tests.
- `ServerHandshake.zig`: simultaneous KeyUpdate integration test.
- `NEGATIVE_SPACE.md` post-handshake rows.

### Alert and close semantics

`close_notify` is the only clean closure alert. Other peer alerts abort the TLS
conversation with `error.PeerAlert`. Client-side bad-server tests also verify
that callers can emit the RFC-required alert descriptions for the highest-risk
local error paths.

Evidence:

- `alert.zig`: parse/encode tests and fuzz target.
- `ClientHandshake.zig`: plaintext/encrypted fatal alert tests and emitted-alert
  checks for `decode_error`, `decrypt_error`, `unexpected_message`, and
  `bad_record_mac` paths.
- `ServerHandshake.zig`: close_notify and fatal alert tests.

## Non-goals and caller responsibilities

### Transport and connection policy

ztls does not own sockets, files, DNS, timers, retries, or connection limits.
The caller owns transport-level DoS handling, rate limiting beyond the engine's
KeyUpdate bound, timeout policy, EOF handling, and the decision to close after an
error.

### Trust-store and private-key lifecycle

ztls does not load system trust stores and does not own private-key storage. The
caller supplies `certificate.Policy` and server `Signer` implementations. If the
caller explicitly sets `insecure_no_chain_anchor`, client connections are not
authenticated to any root and are vulnerable to active MITM certificate
substitution. ztls cannot protect keys outside its own structs or backend
handles.

### Side-channel resistance

ztls does not claim whole-engine constant-time behavior. It uses timing-safe
comparisons for Finished verify_data and X25519 identity detection, and relies
on the selected libcrypto-family backend for primitive side-channel posture.
Cache, power, EM, and backend-internal timing are deployment/backend concerns.

### Backend compromise and backend zeroization

ztls does not implement fallback primitives. If the linked OpenSSL/AWS-LC/
BoringSSL backend is compromised, ztls inherits that risk. ztls zeroes its own
key and suite-state copies on teardown, but backend-internal scratch, provider
contexts, allocator freelists, and primitive work buffers are governed by the
backend's lifecycle guarantees.

### Replay safety for future 0-RTT

0-RTT is not implemented. If added, replay protection must be a documented
contract between ztls and the caller, because a Sans-I/O library cannot own a
global replay cache.

### Unsupported TLS features

HelloRetryRequest, PSK/resumption, client certificates, 0-RTT, P-384/PQ key
exchange, and broader extension negotiation are not defended as implemented
features until their tracking issues land.

## Open threat-relevant gaps

| Gap | Boundary | Tracking |
|---|---|---|
| RFC 5280 directoryName constraints are not enforced | Certificate policy | future X.509 expansion |
| TLS-Anvil / BoGo external runners are not CI-gated | External conformance breadth | #9 |
| Legacy session ID parse caps need dedicated enforcement/tests | Parser hardening | `NEGATIVE_SPACE.md` gap |
| Server Certificate non-empty `request_context` needs rejection evidence | Parser/state-machine hardening | `NEGATIVE_SPACE.md` gap |
| Server-side bad client-Finished negative unit tests are partial | Server state-machine evidence | `NEGATIVE_SPACE.md` gap |
| Certificate and EncryptedExtensions standalone fuzz targets are absent | Parser fuzz breadth | `NEGATIVE_SPACE.md` gap |
| Provider seam is not production-real beyond OpenSSL | Backend diversity | #22 |

## Boundary diagram

```text
caller / embedder
  owns transport I/O, buffers, trust anchors, private-key storage,
  timeouts, connection lifecycle, rate limiting, and deployment policy
        |
        | complete TLS records / caller-owned plaintext buffers
        v
ztls engine
  owns record framing, AEAD nonce/AAD/sequence plumbing, handshake state,
  transcript/key schedule, verification gates, KeyUpdate and alert handling
        |
        | primitive calls and backend-owned contexts
        v
libcrypto-family backend
  owns AEAD, X25519, signature verification, provider internals,
  primitive side-channel posture, and backend allocation/zeroization behavior
```

The threat boundary is intentionally narrow: ztls defends the TLS state machine
and record protocol over caller-provided buffers. Everything below the primitive
API belongs to the backend; everything around the engine belongs to the caller.
