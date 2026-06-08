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

Rsync the repo up (`.git`, `zig-out`, `.zig-cache`, and `.terraform` are excluded):

```bash
rsync -avz --exclude .git --exclude zig-out --exclude .zig-cache \
  --exclude .terraform \
  -e "ssh -i infra/bench/bench.pem -o StrictHostKeyChecking=no" \
  . root@$(tofu output -raw instance_ip):/root/ztls/
```

SSH in and run the comparison capture:

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

# Example comparison
benchstat -row ".name /suite /size" -col /impl \
  ztls=zig-out/perf/ztls-YYYYMMDD-HHMMSS.txt \
  openssl=zig-out/perf/bio-YYYYMMDD-HHMMSS.txt
```

## Notes

- Benchmarks emit Go benchmark format natively. `benchstat` is in the devshell.
- Filter syntax: `--filter 'BenchmarkHandshake/*,BenchmarkAppClientToServer/*'`
- All bench binaries build with `ReleaseFast`.

## Destroy

```bash
tofu destroy
```
