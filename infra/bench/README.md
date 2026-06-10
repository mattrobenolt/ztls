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

Rsync the repo up:

```bash
rsync -avz --exclude .git --exclude zig-out --exclude .zig-cache \
  --exclude .terraform \
  -e "ssh -i infra/bench/bench.pem -o StrictHostKeyChecking=no" \
  . root@$(tofu output -raw instance_ip):/root/ztls/
```

SSH in and run a full comparison capture:

```bash
ssh -i infra/bench/bench.pem -o StrictHostKeyChecking=no \
  root@$(tofu output -raw instance_ip)

cd ztls
just bench-capture --count=5
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
run=zig-out/perf/YYYYMMDD-HHMMSS
benchstat -row ".name /suite /size" -col /impl \
  ztls=${run}/ztls.txt \
  evp=${run}/evp.txt \
  libssl=${run}/libssl.txt \
  rustls=${run}/rustls.txt
```

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
- Filter syntax: `--filter 'BenchmarkHandshake/*,BenchmarkAppClientToServer/*'`
- `metadata.txt` records timestamp, git revision/dirty state, Zig version, kernel,
  and available CPU information.
- `configuration.nix` is applied on first boot only. If you change it, recreate
  the instance with `tofu destroy && tofu apply`.

## Destroy

```bash
tofu destroy
```
