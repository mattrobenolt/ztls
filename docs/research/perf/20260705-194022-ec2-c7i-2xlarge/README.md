# EC2 benchmark capture — 2026-07-05 c7i.2xlarge

Committed #11 evidence for the remote benchmark runner on a larger EC2 benchmark
host shape. The capture was produced by `just bench-remote-capture` from a clean
local checkout after the verbose runner fixes landed. The runner provisioned the
NixOS EC2 host, deployed the repository with `.git`, ran the full
ztls/EVP/libssl/rustls comparison under `nix develop .#openssl`, pulled the
result directory back, wrote `benchstat.txt`, and destroyed the EC2 resources.

The raw capture was produced on the remote host under
`zig-out/perf/20260705-194022/` and pulled back locally as
`zig-out/perf/20260705-194022-c7i.2xlarge-openssl`. Files here are copied from
that local result directory.

## Command

```sh
just bench-remote-capture --instance-types c7i.2xlarge
```

This complements the same-day `c7i.large` remote capture and proves the runner
against a second hardware shape without rerunning the already-captured default
host.

## Provenance

Key metadata from `metadata.txt`:

```text
git_revision=89c869eb2a22c6c0f2ffe077c8f13204a92f4074
git_dirty=false
zig_version=0.15.2
zig_optimization_mode=ReleaseFast
crypto_backend=openssl
openssl_cli_version=OpenSSL 3.6.2 7 Apr 2026 (Library: OpenSSL 3.6.2)
rustls_version=0.23.40
rustc_version=rustc 1.96.0 (ac68faa20 2026-05-25)
go_version=go version go1.26.3 linux/amd64
uname=Linux ip-10-0-1-127.us-west-2.compute.internal 6.12.93 ... x86_64 GNU/Linux
CPU=Intel(R) Xeon(R) Platinum 8488C, 4 cores / 8 SMT threads
args=--count 5 --benchtime 500ms
```

EC2/OpenTofu host configuration:

```text
ec2_instance_type=c7i.2xlarge
ec2_region=us-west-2
ec2_crypto_backend=openssl
```

## Files

- `metadata.txt` — host/toolchain/provenance metadata.
- `ztls.txt` — raw ztls benchmark output.
- `evp.txt` — raw OpenSSL EVP AEAD benchmark output.
- `libssl.txt` — raw OpenSSL libssl memory-BIO benchmark output.
- `rustls.txt` — raw rustls in-memory benchmark output.
- `benchstat.txt` — `scripts/bench-analyze.sh zig-out/perf/20260705-194022-c7i.2xlarge-openssl` output.

## Caveats

This is workflow and measurement evidence, not a marketing-grade performance
claim. The capture proves the larger-host path and records full provenance, but
#31 still owns perf-counter/disassembly explanation and any claim that a row is
faster or slower for a specific reason. Use row-level comparisons only; mixed
geomeans are not meaningful when benchmark sets differ.
