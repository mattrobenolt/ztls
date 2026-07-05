#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

log() {
  printf '[%s] bench-capture: %s\n' "$(date -u +%H:%M:%S)" "$*" >&2
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

crypto_backend="${ZTLS_CRYPTO_BACKEND:-openssl}"
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

log "crypto backend: ${crypto_backend}"
log "benchmark args: ${bench_args[*]:-(default all rows)}"

openssl_pkg_config_path="${ZTLS_OPENSSL_PKG_CONFIG_PATH:-}"
if [[ -z "${openssl_pkg_config_path}" ]]; then
  log "resolving nixpkgs#openssl.dev"
  openssl_dev=$(nix build --no-link --print-out-paths nixpkgs#openssl.dev)
  openssl_pkg_config_path="${openssl_dev}/lib/pkgconfig"
fi
log "OpenSSL pkg-config path: ${openssl_pkg_config_path}"

if [[ "${crypto_backend}" == "aws-lc" ]]; then
  aws_lc_pkg_config_path="${ZTLS_AWS_LC_PKG_CONFIG_PATH:-}"
  if [[ -z "${aws_lc_pkg_config_path}" ]]; then
    log "resolving nixpkgs#aws-lc.dev"
    aws_lc_dev=$(nix build --no-link --print-out-paths nixpkgs#aws-lc.dev)
    aws_lc_pkg_config_path="${aws_lc_dev}/lib/pkgconfig"
  fi
  log "AWS-LC pkg-config path: ${aws_lc_pkg_config_path}"
fi

zig_for_backend() {
  if [[ "${crypto_backend}" == "aws-lc" ]]; then
    PKG_CONFIG_PATH="${aws_lc_pkg_config_path}${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}" zig "$@"
  else
    PKG_CONFIG_PATH="${openssl_pkg_config_path}${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}" zig "$@"
  fi
}

zig_for_openssl_baseline() {
  PKG_CONFIG_PATH="${openssl_pkg_config_path}${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}" \
    ZTLS_CRYPTO_BACKEND=openssl \
    zig "$@"
}

stamp="$(date -u +%Y%m%d-%H%M%S)"
run_dir="zig-out/perf/${stamp}"
mkdir -p "${run_dir}"
log "capture directory: ${run_dir}"

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

linked_library() {
  local binary=$1
  local library=$2
  case "$(uname -s)" in
    Linux)
      ldd "${binary}" 2>/dev/null | awk -v library="${library}" '$1 ~ library {print $3; exit}'
      ;;
    Darwin)
      otool -L "${binary}" 2>/dev/null | awk -v library="${library}" '$1 ~ library {print $1; exit}'
      ;;
  esac
}

assert_linked_under() {
  local name=$1
  local linked=$2
  local expected_dir=$3
  if [[ -z "${linked}" || -z "${expected_dir}" ]]; then
    return
  fi
  case "${linked}" in
    "${expected_dir}"/*) ;;
    *)
      echo "${name} linked ${linked}, expected under ${expected_dir}" >&2
      exit 1
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
      --filter|--bench|--suite|--size|--samples)
        rustls_args+=("$1" "$2")
        shift 2
        ;;
      --filter=*|--bench=*|--suite=*|--size=*|--samples=*)
        rustls_args+=("$1")
        shift
        ;;
      --count)
        rustls_args+=("--samples" "$2")
        shift 2
        ;;
      --count=*)
        rustls_args+=("--samples" "${1#*=}")
        shift
        ;;
      --benchtime)
        shift 2
        ;;
      --benchtime=*)
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

run_step "build ztls benchmark binary (${crypto_backend})" \
  zig_for_backend build -Dcrypto-backend="${crypto_backend}" bench-bin >/dev/null
run_step "build OpenSSL EVP/libssl benchmark binaries" \
  zig_for_openssl_baseline build -Dcrypto-backend=openssl bench-evp-bin bench-openssl-bin >/dev/null

linked_crypto="$(linked_library zig-out/bin/benchmark 'libcrypto' || true)"
linked_evp_crypto="$(linked_library zig-out/bin/evp_bench 'libcrypto' || true)"
linked_libssl_crypto="$(linked_library zig-out/bin/bio_bench 'libcrypto' || true)"
linked_libssl_ssl="$(linked_library zig-out/bin/bio_bench 'libssl' || true)"
log "ztls linked libcrypto: ${linked_crypto:-unknown}"
log "EVP linked libcrypto: ${linked_evp_crypto:-unknown}"
log "libssl bench linked libcrypto: ${linked_libssl_crypto:-unknown}"
log "libssl bench linked libssl: ${linked_libssl_ssl:-unknown}"

assert_linked_under "OpenSSL EVP benchmark" "${linked_evp_crypto}" "${ZTLS_OPENSSL_LIB_DIR:-}"
assert_linked_under "OpenSSL libssl benchmark crypto" "${linked_libssl_crypto}" "${ZTLS_OPENSSL_LIB_DIR:-}"
assert_linked_under "OpenSSL libssl benchmark ssl" "${linked_libssl_ssl}" "${ZTLS_OPENSSL_LIB_DIR:-}"

{
  echo "timestamp_utc=${stamp}"
  echo "git_revision=$(git rev-parse HEAD 2>/dev/null || true)"
  if [[ -z "$(git status --porcelain --untracked-files=all 2>/dev/null)" ]]; then
    echo "git_dirty=false"
  else
    echo "git_dirty=true"
  fi
  echo "zig_version=$(zig version)"
  echo "zig_optimization_mode=ReleaseFast"
  echo "crypto_backend=${crypto_backend}"
  echo "openssl_pkg_config_path=${openssl_pkg_config_path}"
  if [[ "${crypto_backend}" == "aws-lc" ]]; then
    echo "aws_lc_pkg_config_path=${aws_lc_pkg_config_path}"
  fi
  if [[ -n "${linked_crypto}" ]]; then
    echo "linked_libcrypto=${linked_crypto}"
    echo "ztls_linked_libcrypto=${linked_crypto}"
  fi
  if [[ -n "${linked_evp_crypto}" ]]; then
    echo "evp_linked_libcrypto=${linked_evp_crypto}"
  fi
  if [[ -n "${linked_libssl_crypto}" ]]; then
    echo "libssl_linked_libcrypto=${linked_libssl_crypto}"
  fi
  if [[ -n "${linked_libssl_ssl}" ]]; then
    echo "libssl_linked_libssl=${linked_libssl_ssl}"
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

run_step "run ztls benchmarks -> ${run_dir}/ztls.txt" \
  zig_for_backend build -Dcrypto-backend="${crypto_backend}" bench -- "${bench_args[@]}" > "${run_dir}/ztls.txt"
run_step "run OpenSSL EVP crypto-floor benchmarks -> ${run_dir}/evp.txt" \
  zig_for_openssl_baseline build -Dcrypto-backend=openssl bench-evp -- "${bench_args[@]}" > "${run_dir}/evp.txt"
run_step "run OpenSSL libssl memory-BIO benchmarks -> ${run_dir}/libssl.txt" \
  zig_for_openssl_baseline build -Dcrypto-backend=openssl bench-openssl -- "${bench_args[@]}" > "${run_dir}/libssl.txt"
run_step "run rustls benchmarks -> ${run_dir}/rustls.txt" \
  run_rustls "${bench_args[@]}"

log "capture complete: ${run_dir}"
echo "${run_dir}"
