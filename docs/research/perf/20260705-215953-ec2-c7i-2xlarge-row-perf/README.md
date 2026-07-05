# EC2 row perf/disassembly capture — 2026-07-05 c7i.2xlarge

Committed #31 evidence for row-level Linux/x86_64 perf and hot-path disassembly.
The capture was produced by `just bench-remote-perf-rows` from a clean checkout.
The runner provisioned a `c7i.2xlarge` NixOS EC2 host, deployed the repository
with `.git`, ran the row perf set inside `nix develop .#openssl`, pulled results
back, deleted binary `perf.data` files, and destroyed EC2 resources.

## Command

```sh
just bench-remote-perf-rows
```

Default rows captured:

```text
AppPingPong/TLS_AES_128_GCM_SHA256/1350
AppClientToServer/TLS_CHACHA20_POLY1305_SHA256/16
```

Implementations captured for each row:

```text
ztls
openssl
rustls
```

## Provenance

Key metadata from `metadata.txt`:

```text
git_revision=c8b9f03b28c13cb7e6af85e48ea8df4c4c3b7e3e
git_dirty=false
crypto_backend=openssl
count=5
benchtime=500ms
samples=5
pin_command=taskset -c 1
include_handshake=false
kernel=6.12.93
uname=Linux ip-10-0-1-99.us-west-2.compute.internal ... x86_64 GNU/Linux
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
the earlier wall-time capture; perf instrumentation changes absolute timings,
so use these numbers for counter context, not marketing claims.

### AppPingPong / TLS_AES_128_GCM_SHA256 / 1350

| impl | ns/op median | cycles/op | instructions/op | branches/op | branch misses/op | L1D misses/op |
|---|---:|---:|---:|---:|---:|---:|
| ztls | 926.7 | 2934.8 | 9151.8 | 1239.4 | 0.061 | 0.28 |
| openssl | 2173.0 | 6878.0 | 22046.1 | 3872.0 | 1.790 | 34.08 |
| rustls | 1668.2 | 5354.8 | 17085.1 | 1985.5 | 0.968 | 1.34 |

### AppClientToServer / TLS_CHACHA20_POLY1305_SHA256 / 16

| impl | ns/op median | cycles/op | instructions/op | branches/op | branch misses/op | L1D misses/op |
|---|---:|---:|---:|---:|---:|---:|
| ztls | 1321.0 | 4180.3 | 6331.6 | 927.5 | 0.099 | 0.27 |
| openssl | 2284.0 | 7247.5 | 12534.9 | 2226.6 | 1.115 | 0.94 |
| rustls | 594.9 | 1883.0 | 5261.8 | 555.8 | 0.063 | 0.12 |

## Files

Top-level:

- `metadata.txt` — host/toolchain/provenance metadata for the capture.
- `explanations/` — row explanations following the performance template shape.

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
committed `perf-annotate.txt` files contain the sampled hot-path disassembly
needed for the row explanations. Full linked `libcrypto`/`libssl` disassembly
was intentionally not generated; use `--full-linked-disasm` only for a narrower
follow-up where the giant assembly dump is actually useful.

## Caveats

This capture advances #31 with durable perf/disassembly evidence for two
app-data rows. It does not close #31 by itself: the handshake row remains
methodologically blocked by auth-policy asymmetry, and broader marketing-grade
claims still need the repetition/threshold policy described in
`PRODUCTION_READINESS.md`.
