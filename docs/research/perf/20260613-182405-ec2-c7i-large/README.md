# EC2 benchmark capture — 2026-06-13 c7i.large

Historical committed evidence that closed #10; #11 tracks the remaining
hardware-matrix workflow.

Capture command on the EC2 benchmark host:

```sh
just bench-capture-default
```

which expands to:

```sh
scripts/bench-capture.sh --count=5 --benchtime=500ms
```

The raw capture was produced under `zig-out/perf/20260613-182405/` on the remote host and copied here unchanged except for adding this README and the generated `benchstat.txt` analysis.

## Provenance

Key metadata from `metadata.txt`:

```text
git_revision=c7097426cfad938c609b626c56790ec9e1115952
git_dirty=false
zig_version=0.15.2
zig_optimization_mode=ReleaseFast
openssl_version=OpenSSL 3.6.2 7 Apr 2026
rustls_version=0.23.40
rustc_version=rustc 1.96.0 (ac68faa20 2026-05-25)
go_version=go version go1.26.3 linux/amd64
uname=Linux ip-10-0-1-37.us-west-2.compute.internal 6.12.91 ... x86_64 GNU/Linux
CPU=Intel(R) Xeon(R) Platinum 8488C, 1 core / 2 SMT threads
args=--count=5 --benchtime=500ms
```

EC2/OpenTofu host configuration:

```text
region=us-west-2
instance_type=c7i.large
```

## Files

- `metadata.txt` — host/toolchain/provenance metadata.
- `ztls.txt` — raw ztls benchmark output.
- `evp.txt` — raw OpenSSL EVP AEAD benchmark output.
- `libssl.txt` — raw OpenSSL libssl memory-BIO benchmark output.
- `rustls.txt` — raw rustls in-memory benchmark output.
- `benchstat.txt` — `just bench-analyze zig-out/perf/20260613-182405` output.

## Caveats

This is a first committed result set, not a full hardware matrix. `c7i.large` is cheap and useful, but it exposes one physical core with two SMT threads, so it is not the final low-noise benchmark host shape. #11 tracks making the full hardware-matrix workflow one-command reproducible.

The `benchstat` geomean rows span non-identical benchmark sets and are explicitly marked non-comparable by benchstat. Use the row-level comparisons defined in `docs/research/PERFORMANCE.md`, not the mixed geomean, for claims.
