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

### TLS-Anvil

TLS-Anvil provides ~408 RFC-based server and client tests. The runner (`just anvil-server`) starts the ztls harness and executes the upstream suite. Results are captured under `zig-out/anvil/server/<timestamp>/`.

Result normalization and skip-list enforcement are scaffolded via the `anvil-report` recipe. The current parser consumes a normalized JSON shape exercised by a synthetic fixture; the next slice adapts real TLS-Anvil output into that shape.

```sh
# Normalize a results JSON against the skip list:
just anvil-report test_fixtures/anvil_report_synthetic.json

# Or use the script directly with custom options:
uv run python scripts/anvil_report.py \
    zig-out/anvil/server/<timestamp>/report.json \
    --skip-list anvil-skip-list.json
```

The report script:
- classifies every test as expected_skipped, passed, failed, errored, or unexpected_skipped;
- flags unexpected_pass (skip-list deferred feature that actually passed — license-to-claim);
- flags unexpected_fail (unskipped test that failed — regression candidate);
- reports unmatched_skip_patterns to catch stale skip rules;
- writes `summary.json` (machine-readable) and `summary.txt` (human-readable).

The parser exits 0 only when the report has no unexpected pass/fail/skipped classifications; it exits 1 when review is required. Synthetic parser tests run in `just ci`, but real TLS-Anvil execution is not yet CI-gated (#9).
