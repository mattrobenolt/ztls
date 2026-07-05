# AWS-LC provider benchmark capture — 2026-07-05 local OrbStack arm64

Local provider-lane evidence for #22. This capture proves the benchmark harness can run selected comparable TLS rows with ztls linked against AWS-LC while OpenSSL libssl baselines remain linked against OpenSSL. It is not #31 performance-equivalence proof and should not be used for cross-machine marketing claims.

Capture command from the repository root:

```sh
scripts/bench-capture.sh --crypto-backend=aws-lc --count=5 --benchtime=500ms --filter 'BenchmarkHandshake/,BenchmarkAppPingPong/*/size=1350'
scripts/bench-analyze.sh zig-out/perf/20260705-160550 > zig-out/perf/20260705-160550/benchstat.txt
```

The raw capture was produced under `zig-out/perf/20260705-160550/` and copied here unchanged except for adding this README and the generated `benchstat.txt` analysis.

## Provenance

Key metadata from `metadata.txt`:

```text
git_revision=ca5359085548e1f890f913f50c9df8fba30b859d
git_dirty=false
zig_version=0.15.2
zig_optimization_mode=ReleaseFast
crypto_backend=aws-lc
ztls_linked_libcrypto=/nix/store/6386897pzawhk2m445xyl2vc6r024pl8-aws-lc-1.69.0/lib/libcrypto.so
evp_linked_libcrypto=/nix/store/bl7rmhhsy7vjb9qm3jfwgqpv3cn7wfb1-openssl-3.6.2/lib/libcrypto.so.3
libssl_linked_libcrypto=/nix/store/bl7rmhhsy7vjb9qm3jfwgqpv3cn7wfb1-openssl-3.6.2/lib/libcrypto.so.3
libssl_linked_libssl=/nix/store/bl7rmhhsy7vjb9qm3jfwgqpv3cn7wfb1-openssl-3.6.2/lib/libssl.so.3
rustls_version=0.23.40
uname=Linux orbstack 7.0.11-orbstack-00360-gc9bc4d96ac70 ... aarch64 GNU/Linux
args=--count=5 --benchtime=500ms --filter BenchmarkHandshake/,BenchmarkAppPingPong/*/size=1350
```

## Files

- `metadata.txt` — host/toolchain/provenance metadata.
- `ztls.txt` — raw ztls benchmark output linked against AWS-LC.
- `evp.txt` — raw OpenSSL EVP AEAD benchmark output; empty for this TLS-row filter.
- `libssl.txt` — raw OpenSSL libssl memory-BIO benchmark output.
- `rustls.txt` — raw rustls in-memory benchmark output; no comparable rows matched this filter.
- `benchstat.txt` — `scripts/bench-analyze.sh zig-out/perf/20260705-160550` output.

## Caveats

This is local arm64/OrbStack evidence. It is useful for #22 provider-lane coverage because it proves the AWS-LC-linked ztls benchmark path and selected comparable TLS rows run with recorded provenance. It is not durable Linux x86_64 perf/disassembly evidence, does not explain deltas, and does not close #31.

The selected filter intentionally avoids the full benchmark suite so the provider-lane capture remains cheap enough for local iteration. `benchstat.txt` warns that these rows only compare `ztls` and `openssl` for the selected groups, and `n=5` is below the sample count needed for 95% confidence intervals. Treat the numbers as recorded measurements, not conclusions.
