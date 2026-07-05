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

Result normalization and skip-list enforcement are scaffolded by two steps: `anvil-adapter` converts TLS-Anvil output directories into `report.normalized.json`, then `anvil-report` applies the skip list and writes summaries. The adapter is covered by synthetic real-output-shape tests and rejects unfinished raw TLS-Anvil runs by default; `--allow-partial` is only for local audit/debug.

The real server suite is wired as a dedicated GitHub Actions workflow, `.github/workflows/tls-anvil-server.yml`, on `workflow_dispatch` and a weekly schedule. It runs the same sequential settings used for accepted local evidence, strict-normalizes with `just anvil-report-dir`, and uploads summary/provenance/log artifacts without `keyfile.log`.

The client suite has the same local runner shape and a manual workflow in `.github/workflows/tls-anvil-client.yml`. `just anvil-client` launches TLS-Anvil in client mode, writes a trigger script that starts `zig-out/bin/anvil_client` for each handshake, uses the same strict adapter/report path, and captures run metadata plus TLS-Anvil command/stdout/client-stderr/tool logs under `zig-out/anvil/client/<timestamp>/`. The latest strict client workflow derives an attempted TLS 1.3 surface and exits cleanly with the visible #52 `expected_failed` bucket. The workflow is intentionally separate from PR `just ci`; BoGo is durably deferred in `docs/research/BOGO_DEFERRED.md`.

```sh
# Run the CI-shaped TLS-Anvil server suite locally into a deterministic dir:
just anvil-ci-server zig-out/anvil/server/manual 5400

# Run the CI-shaped TLS-Anvil client suite locally into a deterministic dir:
just anvil-ci-client zig-out/anvil/client/manual 5400

# Adapt and normalize a TLS-Anvil output directory:
just anvil-report-dir zig-out/anvil/server/<timestamp>
just anvil-report-dir zig-out/anvil/client/<timestamp>

# Or normalize an already-adapted results JSON against the skip list:
just anvil-report test_fixtures/anvil_report_synthetic.json
```

The report script:
- classifies every test as expected_skipped, expected_failed, not_attempted, passed, failed, errored, or unexpected_skipped;
- treats TLS-Anvil server/client endpoint-mode mismatches as not_attempted, not evidence of feature conformance;
- flags unexpected_pass (skip-list deferred feature that actually passed — license-to-claim);
- flags unexpected_fail (unskipped test that failed — regression candidate);
- flags expected_failed (failed test whose structured failure combinations match a documented non-actionable class, currently DSA-root TLS 1.3 certificate combinations under #52);
- reports unmatched_skip_patterns and expected_skip_count_by_reason to catch stale or overbroad skip rules;
- writes `summary.json` (machine-readable) and `summary.txt` (human-readable).

The parser exits 0 only when the report has no unexpected pass/fail/skipped classifications; it exits 1 when review is required. Synthetic parser tests and wrapper helper tests run in `just ci`; real TLS-Anvil server execution runs in the dedicated scheduled/manual workflow, while client execution has a manual workflow with strict normalized evidence. The completed server/client `not_attempted` buckets are classified in `docs/research/TLS_ANVIL_NOT_ATTEMPTED.md`.
