#!/usr/bin/env bash
# Row-specific perf capture for one benchmark implementation and one row.
#
# Produces perf stat + perf record output under a stable path:
#   zig-out/perf/<timestamp>/perf-row-<impl>-<bench>-<suite>-<size>/
#
# Linux only. Refuses to run on other hosts.
set -euo pipefail
cd "$(dirname "$0")/.."

# --- argument parsing -------------------------------------------------------

impl=""
bench=""
suite=""
size="1"
crypto_backend="${ZTLS_CRYPTO_BACKEND:-openssl}"
count="1"
benchtime="500ms"
samples="1"
events="cycles,instructions,branches,branch-misses,cache-misses,L1-dcache-load-misses,LLC-load-misses"
out_dir=""

set_arg() {
  local key="$1"
  local val="$2"
  case "${key}" in
    impl) impl="${val}" ;;
    bench) bench="${val}" ;;
    suite) suite="${val}" ;;
    size) size="${val}" ;;
    crypto-backend) crypto_backend="${val}" ;;
    count) count="${val}" ;;
    benchtime) benchtime="${val}" ;;
    samples) samples="${val}" ;;
    events) events="${val}" ;;
    out-dir) out_dir="${val}" ;;
    *) return 1 ;;
  esac
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --impl)        impl="$2"; shift 2 ;;
    --impl=*)      impl="${1#*=}"; shift ;;
    --bench)       bench="$2"; shift 2 ;;
    --bench=*)     bench="${1#*=}"; shift ;;
    --suite)       suite="$2"; shift 2 ;;
    --suite=*)     suite="${1#*=}"; shift ;;
    --size)        size="$2"; shift 2 ;;
    --size=*)      size="${1#*=}"; shift ;;
    --crypto-backend)        crypto_backend="$2"; shift 2 ;;
    --crypto-backend=*)      crypto_backend="${1#*=}"; shift ;;
    --count)       count="$2"; shift 2 ;;
    --count=*)     count="${1#*=}"; shift ;;
    --benchtime)   benchtime="$2"; shift 2 ;;
    --benchtime=*) benchtime="${1#*=}"; shift ;;
    --samples)     samples="$2"; shift 2 ;;
    --samples=*)   samples="${1#*=}"; shift ;;
    --events)      events="$2"; shift 2 ;;
    --events=*)    events="${1#*=}"; shift ;;
    --out-dir)     out_dir="$2"; shift 2 ;;
    --out-dir=*)   out_dir="${1#*=}"; shift ;;
    *)
      # Accept key=value form for ergonomics with `just bench-perf-row impl=...`.
      if [[ "$1" == *=* ]]; then
        key="${1%%=*}"
        val="${1#*=}"
        if set_arg "${key}" "${val}"; then
          shift
          continue
        fi
      fi
      echo "unknown argument: $1" >&2
      exit 2
      ;;
  esac
done

if [[ -z "${impl}" || -z "${bench}" || -z "${suite}" ]]; then
  echo "usage: $0 --impl ztls|openssl|rustls --bench <row> --suite <suite> [--size <bytes>]" >&2
  exit 2
fi

case "${impl}" in
  ztls|openssl|rustls) ;;
  evp)
    echo "--impl=evp is not supported by row perf capture; EVP rows are raw-crypto floor measurements, not TLS row comparisons" >&2
    exit 2
    ;;
  *)
    echo "invalid --impl=${impl}; expected ztls, openssl, or rustls" >&2
    exit 2
    ;;
esac

# --- platform check ---------------------------------------------------------

os="$(uname -s)"
if [[ "${os}" != "Linux" ]]; then
  echo "perf is Linux-only. Re-run on a Linux host." >&2
  exit 1
fi

if ! command -v perf >/dev/null 2>&1; then
  echo "perf not found in PATH. Install via the Nix flake devshell." >&2
  exit 1
fi

# --- build the benchmark binary --------------------------------------------

openssl_pkg_config_path="${ZTLS_OPENSSL_PKG_CONFIG_PATH:-}"
if [[ -z "${openssl_pkg_config_path}" ]]; then
  openssl_dev=$(nix build --no-link --print-out-paths nixpkgs#openssl.dev)
  openssl_pkg_config_path="${openssl_dev}/lib/pkgconfig"
fi

build_ztls() {
  if [[ "${crypto_backend}" == "aws-lc" ]]; then
    aws_lc_pkg_config_path="${ZTLS_AWS_LC_PKG_CONFIG_PATH:-}"
    if [[ -z "${aws_lc_pkg_config_path}" ]]; then
      aws_lc_dev=$(nix build --no-link --print-out-paths nixpkgs#aws-lc.dev)
      aws_lc_pkg_config_path="${aws_lc_dev}/lib/pkgconfig"
    fi
    PKG_CONFIG_PATH="${aws_lc_pkg_config_path}${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}" \
      zig build -Dcrypto-backend=aws-lc bench-bin >/dev/null
  else
    PKG_CONFIG_PATH="${openssl_pkg_config_path}${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}" \
      zig build -Dcrypto-backend=openssl bench-bin >/dev/null
  fi
}

build_openssl() {
  PKG_CONFIG_PATH="${openssl_pkg_config_path}${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}" \
    zig build -Dcrypto-backend=openssl bench-openssl-bin >/dev/null
}

build_rustls() {
  cargo build --quiet --release --manifest-path bench/rustls/Cargo.toml
}

case "${impl}" in
  ztls)    build_ztls;    binary="zig-out/bin/benchmark" ;;
  openssl) build_openssl; binary="zig-out/bin/bio_bench" ;;
  rustls)  build_rustls;  binary="bench/rustls/target/release/rustls_bench" ;;
esac

if [[ ! -f "${binary}" ]]; then
  echo "binary not found after build: ${binary}" >&2
  exit 1
fi

# --- construct the benchmark command ---------------------------------------

bench_cmd=()
case "${impl}" in
  ztls|openssl)
    filter="${bench}*${suite}"
    if [[ "${size}" != "1" ]]; then
      filter="${filter}*${size}"
    fi
    bench_cmd=("${binary}" "--filter" "${filter}" "--benchtime" "${benchtime}")
    if [[ "${count}" != "1" ]]; then
      bench_cmd+=("--count" "${count}")
    fi
    ;;
  rustls)
    rustls_bench="${bench}"
    case "${bench}" in
      Handshake)                 rustls_bench="rustls_handshake" ;;
      HandshakeClientStart)      rustls_bench="rustls_handshake_client_start" ;;
      HandshakeServerAccept)     rustls_bench="rustls_handshake_server_accept" ;;
      HandshakeServerFlight)     rustls_bench="rustls_handshake_server_flight" ;;
      HandshakeClientFlight)     rustls_bench="rustls_handshake_client_flight" ;;
      HandshakeServerFinished)   rustls_bench="rustls_handshake_server_finished" ;;
      AppClientToServer)         rustls_bench="rustls_app_client_to_server" ;;
      AppServerToClient)         rustls_bench="rustls_app_server_to_client" ;;
      AppPingPong)               rustls_bench="rustls_app_ping_pong" ;;
    esac
    bench_cmd=("${binary}" "--bench" "${rustls_bench}" "--suite" "${suite}" "--size" "${size}" "--samples" "${samples}")
    ;;
esac

# --- output directory -------------------------------------------------------

stamp="$(date -u +%Y%m%d-%H%M%S)"
if [[ -z "${out_dir}" ]]; then
  out_dir="zig-out/perf/${stamp}"
fi

safe_impl="${impl}"
safe_bench="$(echo "${bench}" | tr '[:upper:]' '[:lower:]')"
safe_suite="$(echo "${suite}" | tr -cd 'A-Za-z0-9_-')"
row_dir="${out_dir}/perf-row-${safe_impl}-${safe_bench}-${safe_suite}-${size}"
mkdir -p "${row_dir}"

# --- linked library detection ----------------------------------------------

linked_libcrypto=""
linked_libssl=""
case "$(uname -s)" in
  Linux)
    linked_libcrypto="$(ldd "${binary}" 2>/dev/null | awk '/libcrypto/{print $3; exit}' || true)"
    if [[ "${impl}" == "openssl" ]]; then
      linked_libssl="$(ldd "${binary}" 2>/dev/null | awk '/libssl/{print $3; exit}' || true)"
    fi
    ;;
  Darwin)
    linked_libcrypto="$(otool -L "${binary}" 2>/dev/null | awk '/libcrypto/{print $1; exit}' || true)"
    if [[ "${impl}" == "openssl" ]]; then
      linked_libssl="$(otool -L "${binary}" 2>/dev/null | awk '/libssl/{print $1; exit}' || true)"
    fi
    ;;
esac

# --- metadata ---------------------------------------------------------------

cpu_model=""
if command -v lscpu >/dev/null 2>&1; then
  cpu_model="$(lscpu 2>/dev/null | awk -F: '/Model name/{gsub(/^ +/,"",$2); print $2; exit}' || true)"
elif command -v sysctl >/dev/null 2>&1; then
  cpu_model="$(sysctl -n machdep.cpu.brand_string 2>/dev/null || true)"
fi

{
  echo "timestamp_utc=${stamp}"
  echo "git_revision=$(git rev-parse HEAD 2>/dev/null || true)"
  if [[ -z "$(git status --porcelain --untracked-files=all 2>/dev/null)" ]]; then
    echo "git_dirty=false"
  else
    echo "git_dirty=true"
  fi
  echo "impl=${impl}"
  echo "bench=${bench}"
  echo "suite=${suite}"
  echo "size=${size}"
  echo "crypto_backend=${crypto_backend}"
  echo "perf_events=${events}"
  echo "perf_stat_command=perf stat -e ${events} --output ${row_dir}/perf-stat.txt -- ${bench_cmd[*]}"
  echo "perf_record_command=perf record --call-graph dwarf,16384 -F 997 --output ${row_dir}/perf.data -- ${bench_cmd[*]}"
  echo "bench_command=${bench_cmd[*]}"
  echo "binary_path=${binary}"
  if [[ -n "${linked_libcrypto}" ]]; then
    echo "linked_libcrypto=${linked_libcrypto}"
  fi
  if [[ -n "${linked_libssl}" ]]; then
    echo "linked_libssl=${linked_libssl}"
  fi
  echo "kernel=$(uname -r)"
  echo "cpu_model=${cpu_model}"
  echo "optimization_mode=ReleaseFast"
  echo "zig_version=$(zig version)"
  if [[ "${impl}" == "rustls" ]]; then
    echo "rustc_version=$(rustc --version 2>/dev/null || true)"
  fi
  echo "uname=$(uname -a)"
} > "${row_dir}/metadata.txt"

# --- perf stat --------------------------------------------------------------

extract_iterations() {
  local file="$1"
  awk '
    /^Benchmark/ {
      if ($2 ~ /^[0-9]+$/) values[++n] = $2
      next
    }
    /^benchmark,/ || /^[[:space:]]*#/ || /^[[:space:]]*$/ { next }
    /^[A-Za-z_]+,/ {
      split($0, fields, ",")
      if (fields[4] ~ /^[0-9]+$/) values[++n] = fields[4]
    }
    END {
      for (i = 1; i <= n; i++) {
        printf "%s%s", (i == 1 ? "" : ","), values[i]
      }
    }
  ' "${file}"
}

echo "running perf stat for ${impl} ${bench} ${suite} ${size}..." >&2
if ! perf stat -e "${events}" --output "${row_dir}/perf-stat.txt" -- \
  "${bench_cmd[@]}" > "${row_dir}/bench-output-stat.txt" 2>&1; then
  echo "perf stat failed; see ${row_dir}/perf-stat.txt and ${row_dir}/bench-output-stat.txt" >&2
  exit 1
fi
stat_iteration_counts="$(extract_iterations "${row_dir}/bench-output-stat.txt")"
if [[ -z "${stat_iteration_counts}" ]]; then
  echo "perf stat run emitted no benchmark iteration count; check --bench/--suite/--size filter" >&2
  exit 1
fi
echo "stat_iteration_counts=${stat_iteration_counts}" >> "${row_dir}/metadata.txt"

# --- perf record ------------------------------------------------------------

echo "running perf record for ${impl} ${bench} ${suite} ${size}..." >&2
if ! perf record --call-graph dwarf,16384 -F 997 \
  --output "${row_dir}/perf.data" -- \
  "${bench_cmd[@]}" > "${row_dir}/bench-output-record.txt" 2>&1; then
  echo "perf record failed; see ${row_dir}/bench-output-record.txt" >&2
  exit 1
fi
record_iteration_counts="$(extract_iterations "${row_dir}/bench-output-record.txt")"
if [[ -z "${record_iteration_counts}" ]]; then
  echo "perf record run emitted no benchmark iteration count; check --bench/--suite/--size filter" >&2
  exit 1
fi
echo "record_iteration_counts=${record_iteration_counts}" >> "${row_dir}/metadata.txt"

# --- perf report (top symbols) ----------------------------------------------

if [[ ! -s "${row_dir}/perf.data" ]]; then
  echo "perf.data is empty after successful perf record" >&2
  exit 1
fi

perf_report_full="${row_dir}/perf-report.full.txt"
perf report --input "${row_dir}/perf.data" --stdio --sort symbol --no-demangle \
  > "${perf_report_full}"
awk 'BEGIN { n = 0 } !/^#/ && NF { print; n++; if (n == 80) exit }' \
  "${perf_report_full}" > "${row_dir}/perf-report.txt"

echo "${row_dir}"
