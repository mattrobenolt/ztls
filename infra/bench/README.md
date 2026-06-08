# EC2 NixOS benchmark host (OpenTofu)

Single NixOS instance for running ztls benchmarks. Clone of the proven fuckscram infra pattern.

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

SSH in and run comparison captures:

```bash
ssh -i infra/bench/bench.pem -o StrictHostKeyChecking=no \
  root@$(tofu output -raw instance_ip)

cd ztls
nix develop -c bash -c '
  mkdir -p zig-out/perf
  stamp=$(date +%Y%m%d-%H%M%S)
  zig build bench -- --count=5 > "zig-out/perf/ztls-${stamp}.txt"
  zig build bench-openssl -- --count=5 > "zig-out/perf/bio-${stamp}.txt"
  echo "${stamp}"
'
```

Pull results back and compare with benchstat:

```bash
rsync -avz \
  -e "ssh -i infra/bench/bench.pem -o StrictHostKeyChecking=no" \
  root@$(tofu output -raw instance_ip):/root/ztls/zig-out/perf/ \
  zig-out/perf/

benchstat -row ".name /suite /size" -col /impl \
  ztls=zig-out/perf/ztls-YYYYMMDD-HHMMSS.txt \
  openssl=zig-out/perf/bio-YYYYMMDD-HHMMSS.txt
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
- Filter syntax: `--filter 'BenchmarkHandshake/*,BenchmarkAppClientToServer/*'`
- Both benchmark suites use the same OpenSSL libcrypto backend. Differences come
  from record-framing overhead, not crypto implementation.
- `configuration.nix` is applied on first boot only. If you change it, recreate
  the instance with `tofu destroy && tofu apply`.

## Destroy

```bash
tofu destroy
```
