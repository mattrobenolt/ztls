# EC2 NixOS benchmark host (OpenTofu)

Single NixOS instance for running ztls benchmark captures on less-noisy hardware.

## Prerequisites

From repo root with the devshell active:

```bash
cd infra/bench
tofu init
tofu apply
```

## Deploy and run

Rsync the repo up. Keep `.git` so benchmark metadata can record the exact
revision, and avoid preserving the local UID/GID into `/root/ztls`:

```bash
rsync -az --delete --no-owner --no-group \
  --exclude zig-out --exclude .zig-cache --exclude .terraform \
  --exclude conformance/.venv --exclude conformance/.zig-cache --exclude conformance/zig-out \
  -e "ssh -i infra/bench/bench.pem -o StrictHostKeyChecking=no" \
  . root@$(tofu output -raw instance_ip):/root/ztls/
```

SSH in and run a full comparison capture:

```bash
ssh -i infra/bench/bench.pem -o StrictHostKeyChecking=no \
  root@$(tofu output -raw instance_ip)

cd ztls
chown -R root:root /root/ztls
nix --extra-experimental-features "nix-command flakes" develop --command \
  bash -lc 'git status --short && git rev-parse HEAD && just bench-capture-default'
```

`just bench-capture` writes one timestamped run directory:

```text
zig-out/perf/YYYYMMDD-HHMMSS/
  metadata.txt
  ztls.txt
  evp.txt
  libssl.txt
  rustls.txt
```

Pull results back:

```bash
rsync -avz \
  -e "ssh -i infra/bench/bench.pem -o StrictHostKeyChecking=no" \
  root@$(tofu output -raw instance_ip):/root/ztls/zig-out/perf/ \
  zig-out/perf/
```

Compare captures with benchstat:

```bash
just bench-analyze zig-out/perf/YYYYMMDD-HHMMSS
```

With no argument, `just bench-analyze` uses the newest capture under
`zig-out/perf/`.

## Local workflow sanity check

Use `just bench-smoke` to validate the capture/analyze plumbing on the current
host. It runs only one `AppPingPong` iteration per row, so it is useful for
checking scripts and metadata but is not benchmark evidence for #10.

Use `just bench-capture-default` for a local full-comparison capture with the
same default flags expected on the EC2 host: `--count=5 --benchtime=500ms`.
Local captures are still workflow sanity checks; committed performance evidence
requires the EC2 benchmark host and full provenance.

## Instance sizing

Default is `c7i.large` (1 physical core, 2 SMT threads) for cheap quick runs.
It does **not** let you:

- Disable Turbo Boost (no `intel_pstate` exposed by hypervisor)
- Set a performance CPU governor (no cpufreq driver in VM)
- Isolate 2 physical cores with `cset` (only 1 core available)
- Pin to `taskset -c 0` without hurting OpenSSL (its record layer benefits from
  both hyperthreads on a single-core VM)

For lower-noise runs, switch to `c7i.2xlarge` or larger in `variables.tf` —
2 physical cores let you pin the benchmark to one core and system/perf to the other.

## Notes

- Benchmark binaries build with `ReleaseFast`.
- `just bench` runs ztls benchmarks only and passes arguments through to the ztls harness.
- `just bench-capture` captures ztls, raw EVP, libssl memory-BIO, and rustls rows.
- `just bench-capture-default` captures all comparison rows with `--count=5 --benchtime=500ms`.
- Filter syntax: `--filter 'BenchmarkHandshake/*,BenchmarkAppClientToServer/*'`
- `metadata.txt` records timestamp, git revision/dirty state, Zig version,
  optimization mode, OpenSSL/rustls/benchstat provenance, kernel, and available
  CPU information. If `.git` is not copied to the host, the capture is not
  acceptable #10 evidence.
- `configuration.nix` is applied on first boot only. If you change it, recreate
  the instance with `tofu destroy && tofu apply`.

## Destroy

```bash
tofu destroy
```
