# #88 zoxy fixed-arena recovery retest — 2026-09-14

## Scope

This capture retests the second finding in #88: whether ztls's guarded
libcrypto boundaries let a fixed-arena embedder serve new TLS handshakes after
libcrypto allocation failures. It does not measure throughput or claim that
zoxy's historical 4 MiB heap was correctly sized.

Current zoxy no longer embeds ztls. The retest therefore uses public zoxy commit
`6e13999b3a3340e71501d38d75671f7fade0d576`, which has the first #88 fix
(bounded key generation) but predates zoxy v0.2.1's larger heap. This preserves
the original 4 MiB fixed libcrypto arena and makes the second finding observable
without restoring the key-generation livelock from zoxy-io/zoxy#222.

The ztls baseline is zoxy-io/ztls
`634567aedb66ed7c8abcd0d6b2e4fefdba6b6cb5`. The candidate applies the source
changes from upstream commits `da799269498a02a4befc25da90ba01865070cf78`
and `36ac3cd32c4ca511c4b3418bdbd482d20de6df71` to that Zig 0.16 fork. The local
port is commits `89d54fca0b682ed2890fbcf66c008b75c457fb28` and
`48dbc85f688c10d33d2334c60647eb3765561b69`; its compressed mail patch is
`ztls-zig16-port.patch.xz`. It retains the fork's `deterministic_nonce: bool` API
rather than importing unrelated newer API changes.

The candidate port passed 701 tests with zero failures and one backend-specific
skip, followed by `zig build errq-alloc-check`; see
`ztls-candidate-tests.log`. The end-to-end A/B exercises the OpenSSL backend;
AWS-LC and BoringSSL queue behavior remains covered by the library's
backend-specific regression tests rather than this embedder run.

## Workload

`harness.sh` ran each binary separately with:

- zoxy pinned to one of the host's four allowed CPUs;
- four loopback HTTP/1.1 origins;
- plaintext, TLS, and admin listeners;
- 1,386 connection slots and 1,024 TLS engines;
- the zoxy source tree's ECDSA P-256 test certificate;
- the official zrk 1.4.1 aarch64 Linux release binary;
- `-c 700 -t 4 -d 15s -R 5000 --timeout 1s`;
- one-second bounded HTTP, TLS, and admin probes before load and after waits of
  6, 15, and 30 seconds. The waits are sequential, so the post-load probes are
  approximately +6, +21, and +51 seconds.

The zrk archive matched its published `SHA256SUMS.txt`; the exact upstream file
is preserved as `zrk-1.4.1-SHA256SUMS.txt`, and the executed verification is in
`zrk-release-verification.log`. The binary used in all four final runs was:

```text
0f2c5fe657a82076b58535337317294e2baffc3b3637b35dae69e1206178db63  zrk
```

This matches the original trigger's key dimensions, but not every environmental
detail: it ran directly on the Linux host rather than in a 4 GiB container, and
used Python loopback origins rather than nginx containers. Those differences do
not change the separately fixed libcrypto arena size. The evidence is about
failure and subsequent availability, not comparative performance.

Every run was externally bounded, drained with `SIGTERM`, exited zero, and left
no zoxy, zrk, origin, or listening-port process behind.

## Production-shaped 4 MiB A/B

The only zoxy source change in these two builds is the local ztls dependency
path. Both otherwise use commit `6e13999` and its normal 4 MiB heap. The
`build.zig.zon` hunk in `zoxy-1m-instrumentation.patch.xz` preserves the same
baseline-pin-to-candidate-path substitution used for this pair; the one MiB and
counter hunks were absent from these builds.

| Result | Baseline `634567a` | Guard candidate `48dbc85` |
|---|---:|---:|
| Binary SHA-256 | `a4ac425b…d4d53` | `2e354756…165b` |
| Pre-load HTTP / TLS / admin | 200 / 200 / 200 | 200 / 200 / 200 |
| `shed_tls_crypto` after load | 46,204 | 10,075 |
| Post-load TLS probes | 000 / 000 / 000 | 200 / 200 / 200 |
| Post-load HTTP probes | 200 / 200 / 200 | 200 / 200 / 200 |
| Post-load admin probes | 200 / 200 / 200 | 200 / 200 / 200 |
| Final `shed_tls_crypto` | 46,206 | 10,075 |
| Final accepted | 46,886 | 39,212 |
| Final admitted / completed | 680 / 680 | 29,137 / 29,137 |
| TLS handshakes completed, first post-load → final | 637 → 637 | 676 → 678 |

`zoxy_shed_tls_crypto` is incremented only when TLS-engine initialization
returns `CryptoUnavailable`; in this revision that path catches the ephemeral
keypair/backend failure and returns the engine slot. Thus the candidate's 10,075
sheds are direct evidence that the normal 4 MiB arena reached allocation
failure during load. The unchanged count plus three successful later TLS probes
and two newly completed handshakes show recovery after that failure. The
baseline instead sheds each later TLS probe and never completes another
handshake.

The A/B does not say that every connection survives exhaustion. The candidate
shed 10,075 admissions and recorded `zoxy_tls_handshake_failed=28,455` under
the overload. The narrower result is that handled failures no longer make the TLS
listener permanently unavailable.

## One MiB diagnostic A/B

A second pair reduces the arena to one MiB and adds a counter at the fixed
heap's malloc/realloc hooks. `zoxy-1m-instrumentation.patch.xz` is the complete
compressed zoxy patch. This is deliberately diagnostic and is not a proposed zoxy
configuration or product change.

| Result | Baseline `634567a` | Guard candidate `48dbc85` |
|---|---:|---:|
| Hook-observed allocation failures | 115,749 | 46,310 |
| Post-load TLS probes | 000 / 000 / 000 | 200 / 200 / 200 |
| Final `shed_tls_crypto` | 57,595 | 0 |
| TLS handshakes completed, first post-load → final | 37 → 37 | 52 → 54 |

The diagnostic counter is printed after the bounded load and health probes but
before process exit. The candidate therefore returned null from its fixed heap
46,310 times during the load and still completed each later TLS probe. Here the
allocation failures occur after engine initialization, so zoxy records them as
handshake failures rather than `shed_tls_crypto`; the hook counter removes any
reliance on that higher-level classification.

## Artifacts

Each `.tar.xz` contains the harness transcript, rendered config, zrk output,
zoxy stderr and final metrics dumps, origin/access logs, payload, and the public
zoxy test certificate/key used for that run:

- `final-4m-baseline-c700.tar.xz`
- `final-4m-candidate-c700.tar.xz`
- `final-1m-baseline-instrumented-c700.tar.xz`
- `final-1m-candidate-instrumented-c700.tar.xz`

Validate with:

```sh
sha256sum -c SHA256SUMS
xz -t *.xz
xz -dc ztls-zig16-port.patch.xz | less
```
