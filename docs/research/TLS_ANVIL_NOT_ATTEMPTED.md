# TLS-Anvil not-attempted coverage

This note classifies the `not_attempted` rows from the completed TLS-Anvil
single-endpoint captures cited by `PRODUCTION_READINESS.md`:

- server capture: `conformance/zig-out/anvil/server/20260616-074609`
  - ztls revision: `496750d`
  - endpoint mode: `SERVER`
  - completion gate: `Running: false`, `FinishedTests: 437`, `TotalTests: 437`
  - normalized counts: `passed: 105`, `failed: 0`, `expected_skipped: 175`,
    `unexpected_skipped: 0`, `not_attempted: 157`
- client capture: workflow `ci-28722850517`
  - ztls revision: `b6aee2c`
  - endpoint mode: `CLIENT`
  - completion gate: `Running: false`, `FinishedTests: 437`, `TotalTests: 437`
  - normalized counts: `passed: 91`, `failed: 6`, `expected_skipped: 135`,
    `unexpected_skipped: 0`, `not_attempted: 205`

The adapter maps TLS-Anvil rows with `result == "DISABLED"` and
`disabled_reason == "TestEndpointMode doesn't match"` to `not_attempted`. These
rows are not failures, not passes, and not expected feature skips. They mean the
single-endpoint run did not exercise a test whose endpoint mode did not match
that run.

The counts are reproducible from the normalized reports:

```sh
python3 - <<'PY'
import json
for name, p in {
    'server': 'conformance/zig-out/anvil/server/20260616-074609/report.normalized.json',
    'client': '/tmp/ztls-anvil-client-b6/tls-anvil-client-summary/report.normalized.json',
}.items():
    data = json.load(open(p))
    rows = [
        t for t in data['tests']
        if t.get('result') == 'DISABLED'
        and t.get('disabled_reason') == "TestEndpointMode doesn't match"
    ]
    print(name, len(rows))
PY
```

Output:

```text
server 157
client 205
```

## Server capture classification

| Bucket | Count | Scope | Owner |
|---|---:|---|---|
| `tests.client.tls13.*` | 82 | In-scope TLS 1.3 client-role rows | Exercised by the strict client capture; current failures remain tracked by #48/#9 |
| `tests.both.lengthfield.EncryptedExtensions.*` | 2 | In-scope TLS 1.3 client-role length-field rows in the `both` package | Exercised by the strict client capture; all `STRICTLY_SUCCEEDED` |
| `tests.both.lengthfield.CertificateVerify.*` | 2 | In-scope TLS 1.3 client-role length-field rows in the `both` package | Exercised by the strict client capture; all `STRICTLY_SUCCEEDED` |
| `tests.both.lengthfield.Certificate.*TLS13` plus `certificateRequestContextLength` | 3 | In-scope TLS 1.3 client-role length-field rows in the `both` package | Exercised by the strict client capture; all `STRICTLY_SUCCEEDED` |
| `tests.client.tls12.*` | 60 | Out of scope | TLS 1.2 is outside ztls scope |
| `tests.both.lengthfield.ServerKeyExchange.*` | 5 | Out of scope | TLS 1.2 ServerKeyExchange is outside ztls scope |
| `tests.both.lengthfield.Certificate.*TLS12` | 2 | Out of scope | TLS 1.2 Certificate length fields are outside ztls scope |
| `tests.client.dtls.*` | 1 | Out of scope | DTLS is outside ztls scope |

Total: `82 + 2 + 2 + 3 + 60 + 5 + 2 + 1 = 157`.

## Client capture classification

| Bucket | Count | Scope | Owner |
|---|---:|---|---|
| `tests.server.tls13.*` | 82 | In-scope TLS 1.3 server-role rows | Exercised by the strict server capture; server attempted surface is clean |
| `tests.both.lengthfield.extensions.*TLS13` plus TLS 1.3 `Hello.*` | 14 | In-scope TLS 1.3 both-endpoint rows | Covered by the strict server capture |
| `tests.both.lengthfield.extensions.PreSharedKeyExtension.*` and `PSKKeyExchangeModesExtension.*ListLength` | 4 | Deferred TLS 1.3 PSK/resumption rows | PSK/session resumption tracked by #2 |
| `tests.server.tls12.*` | 89 | Out of scope | TLS 1.2 is outside ztls scope |
| `tests.server.dtls12.*` | 5 | Out of scope | DTLS is outside ztls scope |
| `tests.both.*TLS12` plus `ClientKeyExchange.*` | 11 | Out of scope | TLS 1.2 length fields and ClientKeyExchange are outside ztls scope |

Total: `82 + 14 + 4 + 89 + 5 + 11 = 205`.

The `14` client-capture both rows covered by the strict server capture are:

- `extensions.EncryptThenMacExtension.encryptThenMacExtensionLengthTLS13`
- `extensions.ALPNExtension.alpnProposedAlpnProtocolsLengthTLS13`
- `extensions.SupportedVersionsExtension.supportedVersionsListLength`
- `extensions.PSKKeyExchangeModesExtension.pskKeyExchangeModesExtensionLength`
- `extensions.SignatureAndHashAlgorithmsExtension.signatureAndHashAlgorithmsListLengthTLS13`
- `extensions.ExtendedMasterSecretExtension.extendedMasterSecretExtensionLengthTLS13`
- `extensions.PaddingExtension.paddingExtensionLengthTLS13`
- `extensions.HeartbeatExtension.heartbeatExtensionLengthTLS13`
- `extensions.RenegotiationExtension.renegotiationExtensionLengthTLS13`
- `extensions.KeyShareExtension.keyShareEntryListLength`
- `Hello.clientHelloCompressionLengthTLS13`
- `Hello.clientHelloCipherSuitesLengthTLS13`
- `extensions.SignatureAndHashAlgorithmsExtension.signatureAndHashAlgorithmsExtensionLengthTLS13`
- `extensions.ALPNExtension.alpnExtensionLengthTLS13`

`EncryptThenMacExtension.encryptThenMacExtensionLengthTLS13` is counted as
server-covered TLS 1.3 framing evidence, not as TLS 1.2 Encrypt-then-MAC feature
support: the server capture proves ztls parses the framing and ignores the
extension semantics in TLS 1.3.

## Both-endpoint accounting

The TLS-Anvil package prefix `tests.both.*` is not itself an endpoint-mode claim.
Some rows in that package carry role annotations; the seven TLS 1.3
`EncryptedExtensions`/`CertificateVerify`/`Certificate` length-field rows are
client-role tests and therefore run in the strict client capture.

Across the current strict server/client captures, the `tests.both.*` endpoint
mismatches classify as:

| Bucket | Count | Rows |
|---|---:|---|
| Covered by opposite endpoint capture | 21 | 14 client-capture TLS 1.3 extension/Hello length-field rows listed above, plus the seven server-capture TLS 1.3 `EncryptedExtensions`/`CertificateVerify`/`Certificate` rows that pass in the strict client capture |
| Feature-deferred | 4 | client-capture PSK extension rows tracked by #2 |
| Out of scope | 18 | TLS 1.2/DTLS `ServerKeyExchange`, `Certificate.*TLS12`, `ClientKeyExchange`, and TLS 1.2 extension/Hello rows |

The seven server-capture endpoint mismatches that pass in the strict client
capture are:

- `EncryptedExtensions.encryptedExtensionsExtensionsLength`
- `EncryptedExtensions.encryptedExtensionsLength`
- `CertificateVerify.certificateVerifySignatureLength`
- `CertificateVerify.certificateVerifyLength`
- `Certificate.certificateListLengthTLS13`
- `Certificate.certificateMessageLengthTLS13`
- `Certificate.certificateRequestContextLength`

Each is `STRICTLY_SUCCEEDED` with `case_result_counts: STRICTLY_SUCCEEDED=9` in
client workflow `ci-28722850517` at `b6aee2c`. They should not be moved into the
skip list, and they are not #49 runner debt.

## Meaning for readiness

The attempted server-side TLS-Anvil surface remains clean (`105/105` attempted
passed). The attempted client-side surface improved after P-256 support but is
not accepted: the strict client capture still has `6` unexpected failures, all
currently attributed to TLS-Anvil `DSA_WITH_SHA256` certificate parameter
combinations tracked by #52. The `anvil_report.py` normalizer now classifies
the six #52 rows as `expected_failed` (visible, distinct from
`expected_skipped`) when per-case `failure_combinations` evidence proves every
failed case is a DSA-root RSA-leaf combination. This is a visibility mechanism,
not a conformance pass; it has been locally replayed by re-adapting the raw
per-test `_testRun.json` files from the `ci-28722850517` artifact and confirmed
by strict client workflow `ci-28725543965` on `6ba72b3` with `expected_failed: 6`
and zero unexpected results. The `not_attempted` buckets are now accounted for
at the role and both-endpoint level, and the former seven #49 rows
are covered by the strict client capture.

Classification is not conformance execution. The explicit out-of-scope rows
should not be moved into `expected_skipped`; keeping endpoint-mode mismatches
separate preserves the distinction between a feature skip and an unexercised
endpoint role.

## Guardrails

- Do not use `--allow-partial` output as readiness evidence.
- Do not add a skip-list pattern that absorbs `TestEndpointMode doesn't match`.
- Do not close #9 from this classification alone.
- Do not reopen #49 on the package prefix alone; verify the row's TLS-Anvil
  endpoint annotation and opposite-capture result.
- Keep Pillar 1 at `PARTIAL` while external conformance remains outside required
  PR CI and the strict client run still has unexpected failures.
