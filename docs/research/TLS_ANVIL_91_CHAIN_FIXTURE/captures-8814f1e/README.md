# Candidate capture: 8814f1e

These six terminal captures use `8814f1e55642a7ce73841779ca0b25e530d31ef8` and clean source trees.
Each profile accounts for 437 cases with zero unexpected results.
Accounted cases are not equivalent to passing cases.

| Role | Provider | Workflow run | Passed | Expected failed | Expected skipped | Not attempted |
|---|---|---:|---:|---:|---:|---:|
| Client | OpenSSL 3.6.4 | 35504483868 | 92 | 6 | 134 | 205 |
| Client | AWS-LC 5.5.0 | 35504485066 | 92 | 6 | 134 | 205 |
| Client | BoringSSL 0.20260803.0 | 35504486215 | 92 | 6 | 134 | 205 |
| Server | OpenSSL 3.6.4 | 35504511374 | 105 | 0 | 175 | 157 |
| Server | AWS-LC 5.5.0 | 35504512407 | 105 | 0 | 175 | 157 |
| Server | BoringSSL 0.20260803.0 | 35504513273 | 105 | 0 | 175 | 157 |

The workflows use Zig 0.15.2.
The expected classifications remain unchanged. No partial-run override applies.
Client captures include the invocation diagnostics.

Each profile preserves its workflow metadata and artifact inventory.
The reports include raw and normalized forms plus summaries.
`workflow-log.sha256` binds the downloaded workflow log retained outside Git.
`build-provenance.log` contains selected lines from that log.
It is a derived extract, not an additional artifact from GitHub.

`SHA256SUMS` binds every other file in this capture.
Historical captures remain unchanged.
Project status lives in [PRODUCTION_READINESS.md](../../../../PRODUCTION_READINESS.md).
