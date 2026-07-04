# TLS-Anvil not-attempted coverage

This note classifies the `not_attempted` rows from the completed TLS-Anvil
server capture cited by `PRODUCTION_READINESS.md`. It is intentionally
server-capture-only; the completed client capture's `not_attempted: 205` bucket
still needs its own #49 classification before any both-endpoint coverage claim:

- capture: `conformance/zig-out/anvil/server/20260616-074609`
- normalized report: `report.normalized.json`
- ztls revision: `496750d`
- run dirty state: `false`
- TLS-Anvil jar: `anvil-core-2.3.4`
- endpoint mode: `SERVER`
- completion gate: `Running: false`, `FinishedTests: 437`, `TotalTests: 437`

The adapter maps TLS-Anvil rows with `result == "DISABLED"` and
`disabled_reason == "TestEndpointMode doesn't match"` to `not_attempted`. These
rows are not failures, not passes, and not expected feature skips. They mean the
server-mode run did not exercise a test whose endpoint mode did not match the
run.

The count is reproducible from the normalized report:

```sh
python3 - <<'PY'
import json
p = 'conformance/zig-out/anvil/server/20260616-074609/report.normalized.json'
data = json.load(open(p))
rows = [
    t for t in data['tests']
    if t.get('result') == 'DISABLED'
    and t.get('disabled_reason') == "TestEndpointMode doesn't match"
]
print(len(rows))
PY
```

Output:

```text
157
```

## Classification

| Bucket | Count | Scope | Owner |
|---|---:|---|---|
| `tests.client.tls13.*` | 82 | In-scope TLS 1.3 client-role coverage debt | TLS-Anvil client runner evidence tracked by #48 and broader runner work tracked by #9 |
| `tests.both.lengthfield.EncryptedExtensions.*` | 2 | In-scope TLS 1.3 both-endpoint coverage debt | both-endpoint accounting tracked by #49 |
| `tests.both.lengthfield.CertificateVerify.*` | 2 | In-scope TLS 1.3 both-endpoint coverage debt | both-endpoint accounting tracked by #49 |
| `tests.both.lengthfield.Certificate.*TLS13` plus `certificateRequestContextLength` | 3 | In-scope TLS 1.3 both-endpoint coverage debt | both-endpoint accounting tracked by #49 |
| `tests.client.tls12.*` | 60 | Out of scope | TLS 1.2 is outside ztls scope |
| `tests.both.lengthfield.ServerKeyExchange.*` | 5 | Out of scope | TLS 1.2 ServerKeyExchange is outside ztls scope |
| `tests.both.lengthfield.Certificate.*TLS12` | 2 | Out of scope | TLS 1.2 Certificate length fields are outside ztls scope |
| `tests.client.dtls.*` | 1 | Out of scope | DTLS is outside ztls scope |

Total: `82 + 2 + 2 + 3 + 60 + 5 + 2 + 1 = 157`.

The actionable in-scope debt is `89` rows: `82` client TLS 1.3 rows and `7`
TLS 1.3 both-endpoint length-field rows. The explicit out-of-scope set is `68`
rows: `67` TLS 1.2-era rows and `1` DTLS row.

## Meaning for readiness

The attempted server-side TLS-Anvil surface remains represented by the normalized
counts in `PRODUCTION_READINESS.md`: `passed: 105`, `failed: 0`,
`expected_skipped: 175`, `unexpected_skipped: 0`, and `not_attempted: 157`.
This document only classifies the `not_attempted` bucket.

Classification is not conformance execution. The `89` in-scope rows remain
coverage debt until strict TLS-Anvil client evidence and #49 both-endpoint
accounting show which rows are exercised, explicitly deferred, or still blocked
on runner shape. Issue #9 owns the broader runner work. The `68` out-of-scope
rows should not be moved into `expected_skipped`; keeping endpoint-mode
mismatches separate preserves the distinction between a feature skip and an
unexercised endpoint role.

## Guardrails

- Do not use `--allow-partial` output as readiness evidence.
- Do not add a skip-list pattern that absorbs `TestEndpointMode doesn't match`.
- Do not close #9 from this classification alone.
- Do not treat this server-only table as the client `not_attempted` classification.
- Keep Pillar 1 at `PARTIAL` until external client/both-endpoint runner evidence
  exists and #49 accounts for the both-endpoint rows.
