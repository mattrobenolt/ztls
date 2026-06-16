#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

crypto_backend="openssl"
bench_args=()
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
    *)
      bench_args+=("$1")
      shift
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

if [[ "${crypto_backend}" == "aws-lc" ]]; then
  aws_lc_pkg_config_path="${ZTLS_AWS_LC_PKG_CONFIG_PATH:-}"
  if [[ -z "${aws_lc_pkg_config_path}" ]]; then
    aws_lc_dev=$(nix build --no-link --print-out-paths nixpkgs#aws-lc.dev)
    aws_lc_pkg_config_path="${aws_lc_dev}/lib/pkgconfig"
  fi
fi

zig_backend() {
  if [[ "${crypto_backend}" == "aws-lc" ]]; then
    PKG_CONFIG_PATH="${aws_lc_pkg_config_path}${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}" zig "$@"
  else
    zig "$@"
  fi
}

stamp="$(date -u +%Y%m%d-%H%M%S)"
run_dir="zig-out/perf/${stamp}"
mkdir -p "${run_dir}"

rustls_version() {
  if [[ -f bench/rustls/Cargo.lock ]]; then
    awk '
      $1 == "name" && $3 == "\"rustls\"" { in_rustls = 1; next }
      in_rustls && $1 == "version" { gsub("\"", "", $3); print $3; exit }
    ' bench/rustls/Cargo.lock
    return
  fi

  (cd bench/rustls && cargo tree --package rustls --depth 0 2>/dev/null | awk 'NR == 1 { print $2 }')
}

cpu_governor() {
  local governor=/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
  if [[ -r "${governor}" ]]; then
    cat "${governor}"
  fi
}

linked_libcrypto() {
  local binary=$1
  case "$(uname -s)" in
    Linux)
      ldd "${binary}" 2>/dev/null | awk '/libcrypto/{print $3; exit}'
      ;;
    Darwin)
      otool -L "${binary}" 2>/dev/null | awk '/libcrypto/{print $1; exit}'
      ;;
  esac
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

zig_backend build -Dcrypto-backend="${crypto_backend}" bench-bin >/dev/null
linked_crypto="$(linked_libcrypto zig-out/bin/benchmark || true)"

{
  echo "timestamp_utc=${stamp}"
  echo "git_revision=$(git rev-parse HEAD 2>/dev/null || true)"
  if git diff --quiet --ignore-submodules HEAD -- 2>/dev/null; then
    echo "git_dirty=false"
  else
    echo "git_dirty=true"
  fi
  echo "zig_version=$(zig version)"
  echo "zig_optimization_mode=ReleaseFast"
  echo "crypto_backend=${crypto_backend}"
  if [[ "${crypto_backend}" == "aws-lc" ]]; then
    echo "aws_lc_pkg_config_path=${aws_lc_pkg_config_path}"
  fi
  if [[ -n "${linked_crypto}" ]]; then
    echo "linked_libcrypto=${linked_crypto}"
  fi
  echo "openssl_cli_version=$(openssl version)"
  echo "rustls_profile=release"
  echo "rustls_version=$(rustls_version)"
  governor="$(cpu_governor)"
  if [[ -n "${governor}" ]]; then
    echo "cpu_governor=${governor}"
  fi
  if command -v rustc >/dev/null 2>&1; then
    echo "rustc_version=$(rustc --version)"
  fi
  if command -v benchstat >/dev/null 2>&1; then
    benchstat_path="$(command -v benchstat)"
    echo "benchstat_path=${benchstat_path}"
  fi
  if command -v go >/dev/null 2>&1; then
    echo "go_version=$(go version)"
    if [[ -n "${benchstat_path:-}" ]]; then
      echo
      echo "[benchstat]"
      go version -m "${benchstat_path}" 2>/dev/null || true
    fi
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
  printf 'args='
  printf '%q ' "${bench_args[@]}"
  printf '\n'
} > "${run_dir}/metadata.txt"

zig_backend build -Dcrypto-backend="${crypto_backend}" bench -- "${bench_args[@]}" > "${run_dir}/ztls.txt"
zig build bench-evp -- "${bench_args[@]}" > "${run_dir}/evp.txt"
zig build bench-openssl -- "${bench_args[@]}" > "${run_dir}/libssl.txt"
run_rustls "${bench_args[@]}"

echo "${run_dir}"
