#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."

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
    --filter|--bench|--suite|--size)
      bench_filters+=("$1" "$2")
      shift 2
      ;;
    --filter=*|--bench=*|--suite=*|--size=*)
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

if [[ "${allow_dirty}" != true ]] && [[ -n "$(git status --porcelain --untracked-files=all)" ]]; then
  echo "remote worktree is dirty; rerun with --allow-dirty only for smoke/debug captures" >&2
  git status --short >&2
  exit 1
fi

git status --short >&2
git rev-parse HEAD >&2

bench_args=(--count "${count}" --benchtime "${benchtime}" "${bench_filters[@]}")
capture="$(scripts/bench-capture.sh --crypto-backend "${crypto_backend}" "${bench_args[@]}")"
scripts/bench-analyze.sh "${capture}" > "${capture}/benchstat.txt"
printf '%s\n' "${capture}"
