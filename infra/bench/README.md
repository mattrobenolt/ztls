# EC2 NixOS benchmark host (OpenTofu)

Single NixOS instance for running ztls benchmark captures on less-noisy hardware.

## One-command capture

From repo root with the devshell active:

```bash
just bench-remote-capture
```

That recipe runs `infra/bench/run-capture.sh`, which:

1. initializes OpenTofu,
2. provisions or replaces the benchmark instance,
3. rsyncs the repo to `/root/ztls` while preserving `.git`,
4. runs the capture through `nix develop .#openssl`,
5. pulls the timestamped run directory back under `zig-out/perf/`,
6. writes `benchstat.txt`, and
7. destroys the EC2 resources on exit unless `--keep-instance` is passed.

The default matrix is one `c7i.large` OpenSSL-backed capture with
`--count=5 --benchtime=500ms`. Override it explicitly when a wider hardware
matrix is needed:

```bash
just bench-remote-capture --instance-types c7i.large,c7i.2xlarge
```

For smoke/debug runs only, pass a narrower benchmark after `--`:

```bash
just bench-remote-capture --count 1 --benchtime 1x -- \
  --bench AppPingPong --suite TLS_AES_128_GCM_SHA256 --size 128
```

Dirty worktrees are rejected by default because benchmark evidence needs a clean
revision. Use `--allow-dirty` only for workflow debugging; do not commit or cite
those captures as performance evidence.

## Manual escape hatch

The script is the source of truth, but the manual shape is useful for debugging.
From repo root:

```bash
cd infra/bench
tofu init
tofu apply -var instance_type=c7i.large
```

Then deploy and run the same remote runner:

```bash
rsync -az --delete --no-owner --no-group \
  --exclude .envrc.local --exclude zig-out --exclude .zig-cache --exclude .terraform \
  --exclude bench.pem --exclude terraform.tfstate \
  --exclude terraform.tfstate.backup \
  --exclude conformance/.venv --exclude conformance/.zig-cache --exclude conformance/zig-out \
  -e "ssh -i infra/bench/bench.pem -o StrictHostKeyChecking=no" \
  . root@$(tofu -chdir=infra/bench output -raw instance_ip):/root/ztls/

ssh -i infra/bench/bench.pem -o StrictHostKeyChecking=no \
  root@$(tofu -chdir=infra/bench output -raw instance_ip) \
  'cd /root/ztls && nix --extra-experimental-features "nix-command flakes" \
    develop .#openssl --command infra/bench/remote-capture.sh'
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
The instance type is controlled by the OpenTofu `instance_type` variable and by
`just bench-remote-capture --instance-types ...` for matrix captures. `c7i.large`
does **not** let you:

- Disable Turbo Boost (no `intel_pstate` exposed by hypervisor)
- Set a performance CPU governor (no cpufreq driver in VM)
- Isolate 2 physical cores with `cset` (only 1 core available)
- Pin to `taskset -c 0` without hurting OpenSSL (its record layer benefits from
  both hyperthreads on a single-core VM)

For lower-noise runs, use `--instance-types c7i.2xlarge` or larger — 2 physical
cores let you pin the benchmark to one core and system/perf to the other.

## Notes

- Benchmark binaries build with `ReleaseFast`.
- `just bench` runs ztls benchmarks only and passes arguments through to the ztls harness.
- `just bench-capture` captures ztls, raw EVP, libssl memory-BIO, and rustls rows.
- `just bench-capture-default` captures all comparison rows locally with `--count=5 --benchtime=500ms`.
- `just bench-remote-capture` provisions EC2, runs the default capture remotely,
  pulls results back, writes `benchstat.txt`, and destroys the host unless
  `--keep-instance` is passed.
- Filter syntax: `--filter 'BenchmarkHandshake/*,BenchmarkAppClientToServer/*'`
- `metadata.txt` records timestamp, git revision/dirty state, Zig version,
  optimization mode, OpenSSL/rustls/benchstat provenance, kernel, and available
  CPU information. If `.git` is not copied to the host, the capture is not
  acceptable #10 evidence.
- `configuration.nix` is applied on first boot only. If you change it, recreate
  the instance with `tofu destroy && tofu apply`; the one-command runner's
  default cleanup handles this for normal captures.

## Destroy

```bash
tofu destroy
```
