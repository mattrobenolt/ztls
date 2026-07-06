# EC2 handshake row perf capture — 2026-07-06 c7i.2xlarge

Committed #31 evidence for the non-equivalent full-handshake row. The capture
was produced by `just bench-remote-perf-rows --include-handshake` from a clean
checkout. The runner provisioned a `c7i.2xlarge` NixOS EC2 host, deployed the
repository with `.git`, ran the row perf set inside `nix develop .#openssl`,
pulled results back, deleted binary `perf.data` files, and destroyed EC2
resources.

This directory intentionally keeps only the handshake row artifacts from the
local run. The same remote run also recaptured the default app-data rows, but
those are already committed with explanations under
`docs/research/perf/20260705-215953-ec2-c7i-2xlarge-row-perf/`.

## Command

```sh
just bench-remote-perf-rows --include-handshake
```

Handshake row captured across:

```text
ztls
openssl
rustls
```

## Provenance

Key metadata from `metadata.txt`:

```text
git_revision=9c87b56087193b8d868a0f95178feab0e04fc717
git_dirty=false
crypto_backend=openssl
count=5
benchtime=500ms
samples=5
pin_command=taskset -c 1
include_handshake=true
kernel=6.12.93
uname=Linux ip-10-0-1-5.us-west-2.compute.internal ... x86_64 GNU/Linux
CPU=Intel(R) Xeon(R) Platinum 8488C, 4 cores / 8 SMT threads
```

EC2/OpenTofu host configuration:

```text
ec2_instance_type=c7i.2xlarge
ec2_region=us-west-2
ec2_crypto_backend=openssl
```

Perf event set:

```text
cycles,instructions,branches,branch-misses,cache-misses,L1-dcache-load-misses,LLC-load-misses
```

`LLC-load-misses` was not supported by the host kernel/perf event set and is
recorded as `<not supported>` in the raw `perf-stat.txt` files.

## Normalized counter summary

Counters are normalized by the summed `stat_iteration_counts` in each row's
`metadata.txt`. `ns/op` is the median of the `perf stat` benchmark output, not
the wall-time capture; perf instrumentation changes absolute timings.

### Handshake / TLS_AES_128_GCM_SHA256 / 1

| impl | ns/op median | cycles/op | instructions/op | branches/op | branch misses/op | L1D misses/op |
|---|---:|---:|---:|---:|---:|---:|
| ztls | 436995.0 | 1439748.8 | 4754323.8 | 247285.8 | 507.604 | 7874.01 |
| openssl | 393776.0 | 1292365.6 | 3805507.3 | 372345.1 | 1662.765 | 7475.05 |
| rustls | 166356.5 | 549157.7 | 1789400.1 | 65436.2 | 403.248 | 1578.63 |

## Files

Top-level:

- `metadata.txt` — host/toolchain/provenance metadata for the capture.
- `explanations/Handshake-TLS_AES_128_GCM_SHA256-1.md` — row explanation.

Per-row directories:

- `metadata.txt` — row command, linked libraries, iteration counts.
- `perf-stat.txt` — raw `perf stat` counters.
- `perf-report.txt` — top sampled symbols from `perf record`.
- `perf-report.full.txt` — full stdio `perf report` output.
- `perf-annotate.txt` — hot-path annotated disassembly from `perf annotate`.
- `bench-output-stat.txt` / `bench-output-record.txt` — benchmark output from the perf stat/record runs.

Per-implementation disassembly directories:

- `metadata.txt` — binary path and linked-library metadata.
- `symbols.txt` — symbol table for the benchmark binary.

Full benchmark-binary assembly (`binary.asm`) was generated under `zig-out/` but
is not committed here because it is tens of megabytes of mostly cold text. The
committed `perf-annotate.txt` files contain the sampled hot-path disassembly.

## Caveats

This capture is transparency evidence for a non-equivalent row. It does not make
the handshake row an apples-to-apples cross-implementation benchmark. ztls and
libssl both show CertificateVerify verification work in perf samples, while the
rustls `NoVerifier` path does not. `bench-analyze` therefore reports handshake
rows in a separate non-equivalent section and these numbers must not be used as
cross-library performance claims.
