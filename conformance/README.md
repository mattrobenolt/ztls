# TLS conformance

Wire-level TLS 1.3 conformance tests for ztls using [`tlsfuzzer`](https://github.com/tlsfuzzer/tlsfuzzer).

The pytest fixture builds against `zig-out/bin/ztls_tlsfuzzer_server`, starts it on an ephemeral localhost port, verifies it accepts TCP connections, and fails the test if the server process crashes before or during a conversation.

Run from the repo root:

```sh
just tlsfuzzer
just tlsfuzzer -q
just tlsfuzzer -k handshake
```

The current suite is intentionally small but real: it performs a TLS 1.3 X25519 handshake against the ztls Sans-I/O server wrapper, validates ServerHello, EncryptedExtensions, Certificate, CertificateVerify, Finished, sends client Finished, exchanges application data, and closes with `close_notify`. It also includes a negative ClientHello case that verifies unsupported cipher suites fail with a fatal `handshake_failure` alert.

This is the first external protocol-conformance harness. Grow it by adding negative conversations for malformed ClientHello extensions, invalid Finished, record limits, KeyUpdate, and alert behavior. Unsupported protocol features should be skipped explicitly with comments naming the missing ztls feature.
