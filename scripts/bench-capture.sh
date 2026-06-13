#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

stamp="$(date -u +%Y%m%d-%H%M%S)"
run_dir="zig-out/perf/${stamp}"
mkdir -p "${run_dir}"

rustls_version() {
  awk '
    $1 == "name" && $3 == "\"rustls\"" { in_rustls = 1; next }
    in_rustls && $1 == "version" { gsub("\"", "", $3); print $3; exit }
  ' bench/rustls/Cargo.lock
}

run_rustls() {
  local rustls_args=()
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --list)
        rustls_args+=("$1")
        shift
        ;;
      --filter|--bench|--suite|--size)
        rustls_args+=("$1" "$2")
        shift 2
        ;;
      --filter=*|--bench=*|--suite=*|--size=*)
        rustls_args+=("$1")
        shift
        ;;
      --count|--benchtime)
        shift 2
        ;;
      --count=*|--benchtime=*)
        shift
        ;;
      *)
        shift
        ;;
    esac
  done
  cargo run --release --manifest-path bench/rustls/Cargo.toml -- "${rustls_args[@]}" \
    > "${run_dir}/rustls.txt"
}

{
  echo "timestamp_utc=${stamp}"
  echo "git_revision=$(git rev-parse HEAD 2>/dev/null || true)"
  if git diff --quiet --ignore-submodules HEAD -- 2>/dev/null; then
    echo "git_dirty=false"
  else
    echo "git_dirty=true"
  fi
  echo "zig_version=$(zig version)"
  echo "openssl_version=$(openssl version)"
  echo "rustls_version=$(rustls_version)"
  if command -v rustc >/dev/null 2>&1; then
    echo "rustc_version=$(rustc --version)"
  fi
  if command -v benchstat >/dev/null 2>&1; then
    echo "benchstat_path=$(command -v benchstat)"
  fi
  if command -v go >/dev/null 2>&1; then
    echo "go_version=$(go version)"
  fi
  echo "uname=$(uname -a)"
  if command -v lscpu >/dev/null 2>&1; then
    echo
    echo "[lscpu]"
    lscpu
  fi
  if command -v sysctl >/dev/null 2>&1; then
    echo
    echo "[sysctl]"
    sysctl -n machdep.cpu.brand_string 2>/dev/null || true
    sysctl -n hw.ncpu 2>/dev/null || true
  fi
  echo
  echo "args=$*"
} > "${run_dir}/metadata.txt"

zig build bench -- "$@" > "${run_dir}/ztls.txt"
zig build bench-evp -- "$@" > "${run_dir}/evp.txt"
zig build bench-openssl -- "$@" > "${run_dir}/libssl.txt"
run_rustls "$@"

echo "${run_dir}"
