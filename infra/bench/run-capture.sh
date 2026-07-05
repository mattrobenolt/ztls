#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."

log() {
  printf '[%s] bench-remote: %s\n' "$(date -u +%H:%M:%S)" "$*" >&2
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

instance_types="${ZTLS_BENCH_INSTANCE_TYPES:-c7i.large}"
crypto_backend="${ZTLS_CRYPTO_BACKEND:-openssl}"
count=5
benchtime=500ms
allow_dirty=false
keep_instance=false
extra_remote_args=()

tofu_dir="infra/bench"
remote_root="/root/ztls"

usage() {
  cat <<'USAGE'
usage: infra/bench/run-capture.sh [options] [-- benchmark filters]

Provision/select EC2 benchmark instance(s), deploy this repo, run benchmark
capture under the OpenSSL devshell, pull results back, and write benchstat.

Options:
  --instance-types LIST     comma/space-separated EC2 matrix (default: c7i.large)
  --crypto-backend BACKEND  ztls backend: openssl or aws-lc (default: shell/default openssl)
  --count N                benchmark sample count (default: 5)
  --benchtime DURATION     Zig benchmark duration (default: 500ms)
  --allow-dirty            permit dirty local/remote worktrees for smoke/debug runs
  --keep-instance          leave Terraform-managed EC2 resources running after exit
  -h, --help               show this help

Everything after -- is passed to the remote capture script, e.g.
  -- --filter 'BenchmarkAppPingPong/.*/size=128'
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --instance-types)
      instance_types="$2"
      shift 2
      ;;
    --instance-types=*)
      instance_types="${1#*=}"
      shift
      ;;
    --crypto-backend)
      crypto_backend="$2"
      shift 2
      ;;
    --crypto-backend=*)
      crypto_backend="${1#*=}"
      shift
      ;;
    --count)
      count="$2"
      shift 2
      ;;
    --count=*)
      count="${1#*=}"
      shift
      ;;
    --benchtime)
      benchtime="$2"
      shift 2
      ;;
    --benchtime=*)
      benchtime="${1#*=}"
      shift
      ;;
    --allow-dirty)
      allow_dirty=true
      shift
      ;;
    --keep-instance)
      keep_instance=true
      shift
      ;;
    --)
      shift
      extra_remote_args+=("$@")
      break
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "unsupported benchmark runner argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

case "${crypto_backend}" in
  openssl|aws-lc) ;;
  *)
    echo "unsupported --crypto-backend=${crypto_backend}; expected openssl or aws-lc" >&2
    exit 2
    ;;
esac

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
  echo "destroying EC2 benchmark resources" >&2
  tofu -chdir="${tofu_dir}" destroy -auto-approve -input=false >/dev/null || true
}
trap cleanup EXIT

split_matrix() {
  local raw=${1//,/ }
  for item in ${raw}; do
    [[ -n "${item}" ]] && printf '%s\n' "${item}"
  done
}

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

log "instance matrix: ${instance_types}"
log "crypto backend: ${crypto_backend}"
log "count=${count} benchtime=${benchtime} allow_dirty=${allow_dirty} keep_instance=${keep_instance}"
if [[ ${#extra_remote_args[@]} -gt 0 ]]; then
  log "extra remote args: ${extra_remote_args[*]}"
fi

run_step "OpenTofu init (${tofu_dir})" tofu -chdir="${tofu_dir}" init -input=false >/dev/null

mapfile -t matrix < <(split_matrix "${instance_types}")
if [[ ${#matrix[@]} -eq 0 ]]; then
  echo "empty --instance-types matrix" >&2
  exit 2
fi

outputs=()
for instance_type in "${matrix[@]}"; do
  safe_instance=${instance_type//[^A-Za-z0-9._-]/_}
  log "provisioning benchmark host: ${instance_type}"
  run_step "OpenTofu apply (${instance_type})" \
    tofu -chdir="${tofu_dir}" apply -auto-approve -input=false -var "instance_type=${instance_type}" >/dev/null
  created=true

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
    infra/bench/remote-capture.sh
    --crypto-backend "${crypto_backend}"
    --count "${count}"
    --benchtime "${benchtime}"
  )
  if [[ "${allow_dirty}" == true ]]; then
    remote_args+=(--allow-dirty)
  fi
  remote_args+=("${extra_remote_args[@]}")

  remote_cmd=(
    nix
    --extra-experimental-features "nix-command flakes"
    develop .#openssl
    --command
    "${remote_args[@]}"
  )
  quoted_remote_cmd=$(quote_command "${remote_cmd[@]}")

  log "running benchmark capture on ${instance_type}: ${quoted_remote_cmd}"
  remote_capture=$(ssh "${ssh_opts[@]}" "${remote}" "cd ${quoted_remote_root} && ${quoted_remote_cmd}")
  remote_capture=$(printf '%s\n' "${remote_capture}" | tail -n 1)
  if [[ "${remote_capture}" != zig-out/perf/* ]]; then
    echo "remote capture returned unexpected path: ${remote_capture}" >&2
    exit 1
  fi

  local_capture="zig-out/perf/$(basename "${remote_capture}")-${safe_instance}-${crypto_backend}"
  mkdir -p "$(dirname "${local_capture}")"
  log "remote capture path: ${remote_capture}"
  log "pulling ${remote_capture} to ${local_capture}"
  run_step "rsync results from ${instance_type}" \
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

  run_step "write benchstat for ${local_capture}" \
    scripts/bench-analyze.sh "${local_capture}" > "${local_capture}/benchstat.txt"
  outputs+=("${local_capture}")
  printf '%s\n' "${local_capture}"
done

printf 'captured %d benchmark run(s):\n' "${#outputs[@]}" >&2
printf '  %s\n' "${outputs[@]}" >&2
