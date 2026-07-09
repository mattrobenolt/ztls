#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."

log() {
  printf '[%s] bench-remote-perf-host: %s\n' "$(date -u +%H:%M:%S)" "$*" >&2
}

run_step() {
  local label=$1
  shift
  local start=${SECONDS}
  local next=30
  log "start: ${label}"
  "$@" &
  local pid=$!
  (
    while sleep 5; do
      local elapsed=$((SECONDS - start))
      if ((elapsed >= next)); then
        log "still running (${elapsed}s): ${label}"
        next=$((next + 30))
      fi
    done
  ) &
  local heartbeat_pid=$!
  local rc=0
  wait "${pid}" || rc=$?
  kill "${heartbeat_pid}" 2>/dev/null || true
  wait "${heartbeat_pid}" 2>/dev/null || true
  if [[ ${rc} -eq 0 ]]; then
    log "done ($((SECONDS - start))s): ${label}"
  else
    log "failed ($((SECONDS - start))s, exit ${rc}): ${label}"
    return "${rc}"
  fi
}

usage() {
  cat <<'USAGE'
usage: infra/bench/remote-perf-rows.sh [options]

Run the #31 row-oriented perf/disassembly evidence set on a remote Linux host.
This script expects to run inside the repo's nix develop .#openssl shell.

Options:
  --crypto-backend BACKEND  ztls backend: openssl or aws-lc (default: openssl)
  --count N                benchmark outer sample count for Zig/libssl rows (default: 5)
  --benchtime DURATION     Zig benchmark duration (default: 500ms)
  --samples N              rustls sample count (default: count)
  --events LIST            perf stat event list
  --out-dir PATH           output directory (default: zig-out/perf/<stamp>-row-perf)
  --pin-cpu CPU            taskset CPU to run rows on when taskset exists (default: 1)
  --include-handshake      also capture Handshake/TLS_AES_128_GCM_SHA256/1
  --skip-disasm            skip per-implementation disassembly capture
  --full-linked-disasm     also dump full linked libcrypto/libssl disassembly
  --keep-perf-data         keep binary perf.data files; default deletes them before pullback
  --allow-dirty            permit dirty worktree for smoke/debug runs
  -h, --help               show this help

Default rows:
  AppPingPong/TLS_AES_128_GCM_SHA256/1350 for ztls, openssl, rustls
  AppClientToServer/TLS_CHACHA20_POLY1305_SHA256/16 for ztls, openssl, rustls
USAGE
}

crypto_backend="${ZTLS_CRYPTO_BACKEND:-openssl}"
count=5
benchtime=500ms
samples=""
events="cycles,instructions,branches,branch-misses,cache-misses,L1-dcache-load-misses,LLC-load-misses"
out_dir=""
pin_cpu=1
include_handshake=false
skip_disasm=false
full_linked_disasm=false
keep_perf_data=false
allow_dirty=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --crypto-backend) crypto_backend="$2"; shift 2 ;;
    --crypto-backend=*) crypto_backend="${1#*=}"; shift ;;
    --count) count="$2"; shift 2 ;;
    --count=*) count="${1#*=}"; shift ;;
    --benchtime) benchtime="$2"; shift 2 ;;
    --benchtime=*) benchtime="${1#*=}"; shift ;;
    --samples) samples="$2"; shift 2 ;;
    --samples=*) samples="${1#*=}"; shift ;;
    --events) events="$2"; shift 2 ;;
    --events=*) events="${1#*=}"; shift ;;
    --out-dir) out_dir="$2"; shift 2 ;;
    --out-dir=*) out_dir="${1#*=}"; shift ;;
    --pin-cpu) pin_cpu="$2"; shift 2 ;;
    --pin-cpu=*) pin_cpu="${1#*=}"; shift ;;
    --include-handshake) include_handshake=true; shift ;;
    --skip-disasm) skip_disasm=true; shift ;;
    --full-linked-disasm) full_linked_disasm=true; shift ;;
    --keep-perf-data) keep_perf_data=true; shift ;;
    --allow-dirty) allow_dirty=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "unsupported remote perf argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

case "${crypto_backend}" in
  openssl|aws-lc|boringssl) ;;
  *) echo "unsupported --crypto-backend=${crypto_backend}; expected openssl, aws-lc, or boringssl" >&2; exit 2 ;;
esac

if [[ -z "${samples}" ]]; then
  samples="${count}"
fi

if [[ "${allow_dirty}" != true ]] && [[ -n "$(git status --porcelain --untracked-files=all)" ]]; then
  echo "remote worktree is dirty; rerun with --allow-dirty only for smoke/debug captures" >&2
  git status --short >&2
  exit 1
fi

stamp="$(date -u +%Y%m%d-%H%M%S)"
if [[ -z "${out_dir}" ]]; then
  out_dir="zig-out/perf/${stamp}-row-perf"
fi
mkdir -p "${out_dir}"

pin_prefix=()
if command -v taskset >/dev/null 2>&1; then
  pin_prefix=(taskset -c "${pin_cpu}")
  log "pinning benchmark rows with taskset -c ${pin_cpu}"
else
  log "taskset not found; running without CPU pinning"
fi

revision="$(git rev-parse HEAD)"
log "remote git revision: ${revision}"
log "output directory: ${out_dir}"
log "crypto_backend=${crypto_backend} count=${count} benchtime=${benchtime} samples=${samples}"
log "events=${events} include_handshake=${include_handshake} skip_disasm=${skip_disasm} full_linked_disasm=${full_linked_disasm} keep_perf_data=${keep_perf_data}"

{
  echo "timestamp_utc=${stamp}"
  echo "git_revision=${revision}"
  if [[ -z "$(git status --porcelain --untracked-files=all 2>/dev/null)" ]]; then
    echo "git_dirty=false"
  else
    echo "git_dirty=true"
  fi
  echo "crypto_backend=${crypto_backend}"
  echo "count=${count}"
  echo "benchtime=${benchtime}"
  echo "samples=${samples}"
  echo "perf_events=${events}"
  echo "pin_cpu=${pin_cpu}"
  if [[ ${#pin_prefix[@]} -gt 0 ]]; then
    echo "pin_command=${pin_prefix[*]}"
  else
    echo "pin_command="
  fi
  echo "include_handshake=${include_handshake}"
  echo "full_linked_disasm=${full_linked_disasm}"
  echo "kernel=$(uname -r)"
  echo "uname=$(uname -a)"
  if command -v lscpu >/dev/null 2>&1; then
    echo
    echo "[lscpu]"
    lscpu
  fi
} > "${out_dir}/metadata.txt"

rows=(
  "AppPingPong|TLS_AES_128_GCM_SHA256|1350"
  "AppClientToServer|TLS_CHACHA20_POLY1305_SHA256|16"
)
if [[ "${include_handshake}" == true ]]; then
  rows+=("Handshake|TLS_AES_128_GCM_SHA256|1")
fi
impls=(ztls openssl rustls)

for row in "${rows[@]}"; do
  IFS='|' read -r bench suite size <<< "${row}"
  for impl in "${impls[@]}"; do
    run_step "perf row ${impl} ${bench} ${suite} size=${size}" \
      "${pin_prefix[@]}" scripts/bench-perf-row.sh \
        --impl "${impl}" \
        --bench "${bench}" \
        --suite "${suite}" \
        --size "${size}" \
        --crypto-backend "${crypto_backend}" \
        --count "${count}" \
        --benchtime "${benchtime}" \
        --samples "${samples}" \
        --events "${events}" \
        --out-dir "${out_dir}"
  done
done

shopt -s nullglob
for perf_data in "${out_dir}"/perf-row-*/perf.data; do
  row_dir="$(dirname "${perf_data}")"
  run_step "perf annotate $(basename "${row_dir}")" \
    perf annotate --input "${perf_data}" --stdio > "${row_dir}/perf-annotate.txt"
done

if [[ "${skip_disasm}" != true ]]; then
  disasm_args=()
  if [[ "${full_linked_disasm}" != true ]]; then
    disasm_args+=(--skip-linked-libs)
  fi
  for impl in "${impls[@]}"; do
    run_step "disassemble ${impl}" \
      scripts/bench-disasm-row.sh --impl "${impl}" --crypto-backend "${crypto_backend}" --out-dir "${out_dir}" "${disasm_args[@]}"
  done
fi

if [[ "${keep_perf_data}" != true ]]; then
  log "deleting binary perf.data files before pullback"
  find "${out_dir}" -name perf.data -delete
fi

log "remote perf evidence complete: ${out_dir}"
printf '%s\n' "${out_dir}"
