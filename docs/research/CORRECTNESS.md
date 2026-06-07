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
- corrupted application-data MAC rejection
- oversized TLSCiphertext rejection
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

The server `handleRecord` fuzz target is intentionally pre-auth because real
AEAD rejects arbitrary ciphertext before deeper state-machine paths. Deeper
post-auth fuzzing requires a fuzz-only/mock AEAD provider; that is test coverage
plumbing, not a production crypto backend.

## Verification gates

The client and server handshakes carry explicit verification gates:

- client: Certificate, CertificateVerify, and server Finished must be verified
  before `clientFinished()` can promote to connected/application keys.
- server: client Finished must be verified before the server transitions to
  connected/application keys.

This mirrors rustls's proof-token idea in a Zig-appropriate form: the final
connected transition has an auditable local condition rather than relying on a
large implicit control-flow argument.

## External suites not currently CI-gated

BoGo and TLS-Anvil are valuable but not yet operational in this repo. They are
larger integrations:

- **BoGo** requires a command-line shim that speaks BoringSSL's runner protocol,
  maps ztls errors, and maintains a disabled-test manifest for unsupported TLS
  features such as HRR, PSK, resumption, 0-RTT, and client auth.
- **TLS-Anvil** requires a Java/JUnit runner and a long-running server/client
  wrapper. It is best treated as a periodic conformance report rather than a
  lightweight per-commit gate.

These suites should be added once the supported TLS surface grows beyond the
current TLS 1.3 full-handshake/app-data/KeyUpdate subset. Until then,
`tlsfuzzer`, OpenSSL interop, RFC vectors, fuzzing, and Wycheproof boundary
vectors are the active auditable correctness program.
