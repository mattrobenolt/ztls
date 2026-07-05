#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."

log() {
  printf '[%s] bench-remote-perf: %s\n' "$(date -u +%H:%M:%S)" "$*" >&2
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
usage: infra/bench/run-perf-rows.sh [options]

Provision one EC2 benchmark host, run row-oriented perf/disassembly evidence,
pull the result back under zig-out/perf/, and destroy the host by default.

Options:
  --instance-type TYPE      EC2 instance type (default: c7i.2xlarge)
  --crypto-backend BACKEND  ztls backend: openssl or aws-lc (default: openssl)
  --count N                benchmark outer sample count (default: 5)
  --benchtime DURATION     Zig benchmark duration (default: 500ms)
  --samples N              rustls sample count (default: count)
  --pin-cpu CPU            CPU for taskset pinning on remote host (default: 1)
  --include-handshake      also capture Handshake/TLS_AES_128_GCM_SHA256/1
  --skip-disasm            skip per-implementation disassembly capture
  --full-linked-disasm     also dump full linked libcrypto/libssl disassembly
  --keep-perf-data         keep binary perf.data files in pulled artifacts
  --allow-dirty            permit dirty local/remote worktrees for smoke/debug runs
  --keep-instance          leave OpenTofu EC2 resources running after exit
  -h, --help               show this help
USAGE
}

instance_type="${ZTLS_BENCH_INSTANCE_TYPE:-c7i.2xlarge}"
crypto_backend="${ZTLS_CRYPTO_BACKEND:-openssl}"
count=5
benchtime=500ms
samples=""
pin_cpu=1
include_handshake=false
skip_disasm=false
full_linked_disasm=false
keep_perf_data=false
allow_dirty=false
keep_instance=false

tofu_dir="infra/bench"
remote_root="/root/ztls"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --instance-type) instance_type="$2"; shift 2 ;;
    --instance-type=*) instance_type="${1#*=}"; shift ;;
    --crypto-backend) crypto_backend="$2"; shift 2 ;;
    --crypto-backend=*) crypto_backend="${1#*=}"; shift ;;
    --count) count="$2"; shift 2 ;;
    --count=*) count="${1#*=}"; shift ;;
    --benchtime) benchtime="$2"; shift 2 ;;
    --benchtime=*) benchtime="${1#*=}"; shift ;;
    --samples) samples="$2"; shift 2 ;;
    --samples=*) samples="${1#*=}"; shift ;;
    --pin-cpu) pin_cpu="$2"; shift 2 ;;
    --pin-cpu=*) pin_cpu="${1#*=}"; shift ;;
    --include-handshake) include_handshake=true; shift ;;
    --skip-disasm) skip_disasm=true; shift ;;
    --full-linked-disasm) full_linked_disasm=true; shift ;;
    --keep-perf-data) keep_perf_data=true; shift ;;
    --allow-dirty) allow_dirty=true; shift ;;
    --keep-instance) keep_instance=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "unsupported perf runner argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

case "${crypto_backend}" in
  openssl|aws-lc) ;;
  *) echo "unsupported --crypto-backend=${crypto_backend}; expected openssl or aws-lc" >&2; exit 2 ;;
esac

if [[ -z "${samples}" ]]; then
  samples="${count}"
fi

if [[ "${allow_dirty}" != true ]] && [[ -n "$(git status --porcelain --untracked-files=all)" ]]; then
  echo "local worktree is dirty; commit first or rerun with --allow-dirty for smoke/debug captures" >&2
  git status --short >&2
  exit 1
fi

for tool in tofu rsync ssh nix; do
  if ! command -v "${tool}" >/dev/null 2>&1; then
    echo "missing required tool: ${tool}" >&2
    exit 1
  fi
done

created=false
cleanup() {
  if [[ "${keep_instance}" == true || "${created}" != true ]]; then
    return
  fi
  log "destroying EC2 benchmark resources"
  tofu -chdir="${tofu_dir}" destroy -auto-approve -input=false >/dev/null || true
}
trap cleanup EXIT

ssh_opts=()
ssh_for_key() {
  local key=$1
  ssh_opts=(
    -i "${key}"
    -o StrictHostKeyChecking=no
    -o UserKnownHostsFile=/dev/null
    -o ConnectTimeout=10
  )
}

wait_for_ssh() {
  local remote=$1
  for _ in $(seq 1 60); do
    if ssh "${ssh_opts[@]}" "${remote}" true >/dev/null 2>&1; then
      return
    fi
    sleep 5
  done
  echo "timed out waiting for SSH on ${remote}" >&2
  exit 1
}

quote_command() {
  printf '%q ' "$@"
}

log "instance_type=${instance_type} crypto_backend=${crypto_backend} count=${count} benchtime=${benchtime} samples=${samples}"
log "pin_cpu=${pin_cpu} include_handshake=${include_handshake} skip_disasm=${skip_disasm} full_linked_disasm=${full_linked_disasm} keep_instance=${keep_instance}"

run_step "OpenTofu init (${tofu_dir})" tofu -chdir="${tofu_dir}" init -input=false >/dev/null

log "provisioning benchmark host: ${instance_type}"
created=true
run_step "OpenTofu apply (${instance_type})" \
  tofu -chdir="${tofu_dir}" apply -auto-approve -input=false -var "instance_type=${instance_type}" >/dev/null

instance_ip=$(tofu -chdir="${tofu_dir}" output -raw instance_ip)
aws_region=$(tofu -chdir="${tofu_dir}" output -raw aws_region)
key_file=$(tofu -chdir="${tofu_dir}" output -raw ssh_key_file)
if [[ "${key_file}" != /* ]]; then
  key_file="${tofu_dir}/${key_file}"
fi
chmod 600 "${key_file}"
ssh_for_key "${key_file}"
remote="root@${instance_ip}"

log "instance ready: ip=${instance_ip} region=${aws_region} key=${key_file}"
log "waiting for ${remote}"
wait_for_ssh "${remote}"

quoted_remote_root=$(printf '%q' "${remote_root}")

log "deploying repo to ${remote}:${remote_root}"
run_step "rsync repo to ${instance_type}" \
  rsync -az --delete --no-owner --no-group \
  --exclude .envrc.local \
  --exclude zig-out \
  --exclude .zig-cache \
  --exclude .terraform \
  --exclude bench.pem \
  --exclude terraform.tfstate \
  --exclude terraform.tfstate.backup \
  --exclude conformance/.venv \
  --exclude conformance/.zig-cache \
  --exclude conformance/zig-out \
  -e "ssh ${ssh_opts[*]}" \
  ./ "${remote}:${remote_root}/"

log "normalizing remote ownership"
ssh "${ssh_opts[@]}" "${remote}" \
  "rm -f ${quoted_remote_root}/.envrc.local && chown -R root:root ${quoted_remote_root}"

remote_args=(
  infra/bench/remote-perf-rows.sh
  --crypto-backend "${crypto_backend}"
  --count "${count}"
  --benchtime "${benchtime}"
  --samples "${samples}"
  --pin-cpu "${pin_cpu}"
)
if [[ "${include_handshake}" == true ]]; then
  remote_args+=(--include-handshake)
fi
if [[ "${skip_disasm}" == true ]]; then
  remote_args+=(--skip-disasm)
fi
if [[ "${full_linked_disasm}" == true ]]; then
  remote_args+=(--full-linked-disasm)
fi
if [[ "${keep_perf_data}" == true ]]; then
  remote_args+=(--keep-perf-data)
fi
if [[ "${allow_dirty}" == true ]]; then
  remote_args+=(--allow-dirty)
fi

remote_cmd=(
  nix
  --extra-experimental-features "nix-command flakes"
  develop .#openssl
  --command
  "${remote_args[@]}"
)
quoted_remote_cmd=$(quote_command "${remote_cmd[@]}")

log "running remote perf rows on ${instance_type}: ${quoted_remote_cmd}"
remote_capture=$(ssh "${ssh_opts[@]}" "${remote}" "cd ${quoted_remote_root} && ${quoted_remote_cmd}")
remote_capture=$(printf '%s\n' "${remote_capture}" | tail -n 1)
if [[ "${remote_capture}" != zig-out/perf/* ]]; then
  echo "remote perf capture returned unexpected path: ${remote_capture}" >&2
  exit 1
fi

safe_instance=${instance_type//[^A-Za-z0-9._-]/_}
local_capture="zig-out/perf/$(basename "${remote_capture}")-${safe_instance}-${crypto_backend}"
mkdir -p "$(dirname "${local_capture}")"
log "remote perf path: ${remote_capture}"
log "pulling ${remote_capture} to ${local_capture}"
run_step "rsync perf results from ${instance_type}" \
  rsync -az --delete \
  -e "ssh ${ssh_opts[*]}" \
  "${remote}:${remote_root}/${remote_capture}/" \
  "${local_capture}/"

{
  echo
  echo "[ec2]"
  echo "ec2_instance_type=${instance_type}"
  echo "ec2_region=${aws_region}"
  echo "ec2_instance_ip=${instance_ip}"
  echo "ec2_crypto_backend=${crypto_backend}"
} >> "${local_capture}/metadata.txt"

log "local perf evidence: ${local_capture}"
printf '%s\n' "${local_capture}"
