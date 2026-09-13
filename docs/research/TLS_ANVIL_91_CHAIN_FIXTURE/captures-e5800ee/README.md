# Three-backend capture after fixture serialization repair

Revision: `e5800ee9396c9b285fade5515306cea8f0a13cff`, clean in every capture.
All three workflow dispatches explicitly enabled `ZTLS_ANVIL_DIAGNOSTICS=1`.
Project status and acceptance are recorded in `PRODUCTION_READINESS.md` (#91).

| Backend | Workflow run | Invocation logs |
|---|---|---:|
| OpenSSL | https://github.com/mattrobenolt/ztls/actions/runs/34739623436 | 1140 |
| AWS-LC | https://github.com/mattrobenolt/ztls/actions/runs/34739624161 | 1136 |
| BoringSSL | https://github.com/mattrobenolt/ztls/actions/runs/34739624962 | 1134 |

Each capture reports 437/437 complete: 92 passes, six expected DSA failures,
134 expected skips, 205 not attempted, and zero unexpected results.
Both fixture patches' actual jar/class/source hashes match their build stamps.
All 3,410 invocation logs contain the local-port diagnostic; none contains a
certificate-validity error diagnostic.

Each backend directory contains the original summary, reports, and run metadata.
`invocations-and-cases.tar.xz` preserves all invocation stderr files and all 437
individual test reports. Paths inside each archive are relative to that backend's
GitHub artifact download directory. `archive-manifest.json` records each original
file's size and SHA-256, plus the archive SHA-256. Every archived file was read
back and verified against its source before committing.

The earlier KeyUpdate and client-authentication cases have no captured original
certificate bytes. These new results do not prove a unique retrospective cause
for those earlier failures. The serialization regression separately demonstrates
configured-date loss and preservation through copies into actual DER.

To inspect an archive outside the repository, for example:

```sh
python3 - <<'PY'
import tarfile
with tarfile.open('docs/research/TLS_ANVIL_91_CHAIN_FIXTURE/captures-e5800ee/aws-lc/invocations-and-cases.tar.xz') as archive:
    archive.extractall('/tmp/anvil-e5800ee-aws-lc', filter='data')
PY
```
