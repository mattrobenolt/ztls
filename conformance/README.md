# TLS conformance

Wire-level TLS 1.3 conformance tests for ztls using [`tlsfuzzer`](https://github.com/tlsfuzzer/tlsfuzzer).

The pytest fixture builds against `conformance/zig-out/bin/tlsfuzzer_server`, starts it on an ephemeral localhost port, verifies it accepts TCP connections, and fails the test if the server process crashes before or during a conversation.

Run from the repo root:

```sh
just tlsfuzzer
just tlsfuzzer -q
just tlsfuzzer -k handshake
```

The current suite is intentionally small but real: it performs TLS 1.3 X25519 handshakes against the ztls Sans-I/O server wrapper across all three mandatory cipher suites, validates ServerHello, EncryptedExtensions, Certificate, CertificateVerify, Finished, sends client Finished, exchanges application data, and closes with `close_notify`. It also covers KeyUpdate(update_requested), malformed KeyUpdate rejection, corrupted application-data MAC rejection, oversized record rejection, close_notify before handshake, garbage pre-handshake bytes, premature Finished, empty/truncated record handling, malformed ClientHello key_share parsing, and unsupported-cipher/unshared-ALPN ClientHello failures.

This is the CI-gated external protocol-conformance harness for the supported ztls server surface. New TLS features should add matching tlsfuzzer conversations in this directory before being treated as supported.

TLS-Anvil is available as a manual runner while result normalization and skip-list enforcement are still being wired:

```sh
just anvil-server --timeout 300
```

The recipe starts the ztls server harness on an ephemeral localhost port, runs TLS-Anvil in server-test mode, and writes results under `zig-out/anvil/server/`. It is not part of `just ci` yet; #9 tracks turning this into a normalized, CI-gated external runner.
