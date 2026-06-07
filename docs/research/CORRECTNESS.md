# Correctness and conformance evidence

ztls correctness is built as layered evidence, not a single claim. The core remains
Sans-I/O and allocation-free; external harnesses wrap it only for conformance.

## CI-gated checks

Run the full local gate with:

```sh
just ci
```

This currently includes:

- workflow hardening: `pinact`, `zizmor`
- formatting: `zig fmt --check src/ examples/ bench/ build.zig`
- RFC-cited unit tests: `zig build test`
- OpenSSL interop, ztls client to `openssl s_server`: `zig build test-openssl`
- OpenSSL interop, `openssl s_client` to ztls server: `zig build test-openssl-server`
- Wycheproof boundary smoke vectors: `zig build test-wycheproof`
- Python conformance lint/type check: `just conformance-python`
- tlsfuzzer conformance: `just tlsfuzzer -q`
- benchmark smoke rows used to catch build/link/perf-regression breakage

## tlsfuzzer

`conformance/` contains a pytest/tlsfuzzer suite. The fixture starts
`zig-out/bin/ztls_tlsfuzzer_server`, a thin TCP wrapper around the Sans-I/O
`ServerHandshake`, on an ephemeral localhost port and fails if the server process
crashes before or during any test.

Run directly with:

```sh
just tlsfuzzer -q
```

Current coverage:

- TLS 1.3 X25519 handshake across all three mandatory cipher suites:
  - `TLS_AES_128_GCM_SHA256`
  - `TLS_AES_256_GCM_SHA384`
  - `TLS_CHACHA20_POLY1305_SHA256`
- ServerHello, EncryptedExtensions, Certificate, CertificateVerify, Finished
- client Finished, application-data echo, and `close_notify`
- KeyUpdate(update_requested) with server response
- malformed KeyUpdate rejection (`decode_error` / `illegal_parameter`)
- corrupted application-data MAC rejection
- oversized TLSCiphertext rejection
- close_notify before handshake
- garbage pre-handshake bytes
- premature Finished before handshake keys exist
- truncated and empty ClientHello records
- malformed/truncated `key_share`
- unsupported cipher suite fatal `handshake_failure`
- unshared ALPN fatal `no_application_protocol`

This is protocol conformance evidence: it checks real wire behavior, alerts, and
state transitions against an independently maintained TLS test framework.

## Wycheproof boundary vectors

`zig build test-wycheproof` runs selected Wycheproof v1 vectors at ztls's
libcrypto boundary. These tests do **not** claim that ztls implements primitive
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

Current fuzz surfaces include:

- `server_hello.parse`
- `certificate.parse`
- `new_session_ticket.parse`
- client `HandshakeReader`
- client decrypted `processFlight`
- server `handleRecord` in the initial state

The server `handleRecord` fuzz target covers the pre-auth boundary where raw
wire bytes first enter the Sans-I/O server. Post-auth behavior is covered by
unit tests and tlsfuzzer conversations, where records are cryptographically
valid enough to reach the state-machine paths under test.

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

The CI-gated conformance target is the currently supported ztls protocol surface:
TLS 1.3 full handshake with X25519, certificate-authenticated server flight,
application data, alerts, and KeyUpdate. PSK, resumption, 0-RTT, client auth,
and HelloRetryRequest are not implemented product features, so tests for them
are not disabled conformance holes; they are outside the advertised surface.
Their prerequisites and acceptance criteria are tracked in
`docs/research/CONFORMANCE_ROADMAP.md`. Where ztls's current behavior for an
unimplemented feature is observable (e.g. client rejects HelloRetryRequest, and
the server rejects a ClientHello with no shared group instead of emitting HRR),
that behavior is pinned by RFC-cited tests so it cannot drift silently.

BoGo and TLS-Anvil are useful additional external runners, but their value is in
broad matrix coverage across features ztls does not yet implement. For the
current supported surface, the active external conformance authority is
tlsfuzzer, backed by OpenSSL interop, RFC vectors, fuzzing, verification gates,
and Wycheproof boundary vectors.
