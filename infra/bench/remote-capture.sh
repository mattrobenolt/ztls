#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."

log() {
  printf '[%s] bench-remote-host: %s\n' "$(date -u +%H:%M:%S)" "$*" >&2
}

crypto_backend="${ZTLS_CRYPTO_BACKEND:-openssl}"
allow_dirty=false
count=5
benchtime=500ms
bench_filters=()

while [[ $# -gt 0 ]]; do
  case "$1" in
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
    --filter)
      bench_filters+=("$1" "$2")
      shift 2
      ;;
    --filter=*)
      bench_filters+=("$1")
      shift
      ;;
    --allow-dirty)
      allow_dirty=true
      shift
      ;;
    *)
      echo "unsupported remote benchmark argument: $1" >&2
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

log "crypto backend: ${crypto_backend}"
log "count=${count} benchtime=${benchtime} allow_dirty=${allow_dirty}"
if [[ ${#bench_filters[@]} -gt 0 ]]; then
  log "bench filters: ${bench_filters[*]}"
fi
log "checking remote worktree cleanliness"
if [[ "${allow_dirty}" != true ]] && [[ -n "$(git status --porcelain --untracked-files=all)" ]]; then
  echo "remote worktree is dirty; rerun with --allow-dirty only for smoke/debug captures" >&2
  git status --short >&2
  exit 1
fi

git status --short >&2
revision=$(git rev-parse HEAD)
log "remote git revision: ${revision}"

bench_args=(--count "${count}" --benchtime "${benchtime}" "${bench_filters[@]}")
log "starting capture script"
capture="$(scripts/bench-capture.sh --crypto-backend "${crypto_backend}" "${bench_args[@]}")"
log "capture script returned: ${capture}"
log "writing remote benchstat: ${capture}/benchstat.txt"
scripts/bench-analyze.sh "${capture}" > "${capture}/benchstat.txt"
log "remote capture complete: ${capture}"
printf '%s\n' "${capture}"
