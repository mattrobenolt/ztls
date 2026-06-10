#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

stamp="$(date -u +%Y%m%d-%H%M%S)"
run_dir="zig-out/perf/${stamp}"
mkdir -p "${run_dir}"

{
  echo "timestamp_utc=${stamp}"
  echo "git_revision=$(git rev-parse HEAD 2>/dev/null || true)"
  if git diff --quiet --ignore-submodules HEAD -- 2>/dev/null; then
    echo "git_dirty=false"
  else
    echo "git_dirty=true"
  fi
  echo "zig_version=$(zig version)"
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
zig build bench-rustls -- "$@" > "${run_dir}/rustls.txt"

echo "${run_dir}"
