#!/usr/bin/env bash
# Disassemble a benchmark binary and its dynamically linked libraries for one
# implementation. Produces stable output under:
#   zig-out/perf/<timestamp>/disasm-<impl>/
#
# Works on Linux (objdump) and macOS (otool fallback). Disassembly produced on
# the wrong architecture is not useful for explaining a capture from a
# different architecture — use the same host class as the wall-time capture.
set -euo pipefail
cd "$(dirname "$0")/.."

# --- argument parsing -------------------------------------------------------

impl=""
crypto_backend="${ZTLS_CRYPTO_BACKEND:-openssl}"
out_dir=""

set_arg() {
  local key="$1"
  local val="$2"
  case "${key}" in
    impl) impl="${val}" ;;
    crypto-backend) crypto_backend="${val}" ;;
    out-dir) out_dir="${val}" ;;
    *) return 1 ;;
  esac
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --impl)              impl="$2"; shift 2 ;;
    --impl=*)            impl="${1#*=}"; shift ;;
    --crypto-backend)    crypto_backend="$2"; shift 2 ;;
    --crypto-backend=*)  crypto_backend="${1#*=}"; shift ;;
    --out-dir)           out_dir="$2"; shift 2 ;;
    --out-dir=*)         out_dir="${1#*=}"; shift ;;
    *)
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

if [[ -z "${impl}" ]]; then
  echo "usage: $0 --impl ztls|openssl|evp|rustls [--crypto-backend openssl|aws-lc]" >&2
  exit 2
fi

case "${impl}" in
  ztls|openssl|evp|rustls) ;;
  *)
    echo "invalid --impl=${impl}; expected ztls, openssl, evp, or rustls" >&2
    exit 2
    ;;
esac

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

build_evp() {
  PKG_CONFIG_PATH="${openssl_pkg_config_path}${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}" \
    zig build -Dcrypto-backend=openssl bench-evp-bin >/dev/null
}

build_rustls() {
  cargo build --quiet --release --manifest-path bench/rustls/Cargo.toml
}

case "${impl}" in
  ztls)    build_ztls;    binary="zig-out/bin/benchmark" ;;
  openssl) build_openssl; binary="zig-out/bin/bio_bench" ;;
  evp)     build_evp;     binary="zig-out/bin/evp_bench" ;;
  rustls)  build_rustls;  binary="bench/rustls/target/release/rustls_bench" ;;
esac

if [[ ! -f "${binary}" ]]; then
  echo "binary not found after build: ${binary}" >&2
  exit 1
fi

# --- output directory -------------------------------------------------------

stamp="$(date -u +%Y%m%d-%H%M%S)"
if [[ -z "${out_dir}" ]]; then
  out_dir="zig-out/perf/${stamp}"
fi
disasm_dir="${out_dir}/disasm-${impl}"
mkdir -p "${disasm_dir}"

# --- tool selection ---------------------------------------------------------

disasm_tool=()
symbol_tool=()
case "$(uname -s)" in
  Linux)
    if command -v objdump >/dev/null 2>&1; then
      disasm_tool=(objdump -d)
      symbol_tool=(nm -C)
    fi
    ;;
  Darwin)
    if command -v objdump >/dev/null 2>&1; then
      disasm_tool=(objdump -d)
      symbol_tool=(nm -C)
    elif command -v otool >/dev/null 2>&1; then
      disasm_tool=(otool -tv)
      symbol_tool=(nm -C)
    fi
    ;;
esac

if [[ ${#disasm_tool[@]} -eq 0 ]]; then
  echo "no disassembly tool found (objdump or otool required)" >&2
  exit 1
fi

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

{
  echo "timestamp_utc=${stamp}"
  echo "git_revision=$(git rev-parse HEAD 2>/dev/null || true)"
  if [[ -z "$(git status --porcelain --untracked-files=all 2>/dev/null)" ]]; then
    echo "git_dirty=false"
  else
    echo "git_dirty=true"
  fi
  echo "impl=${impl}"
  echo "crypto_backend=${crypto_backend}"
  echo "binary_path=${binary}"
  echo "disasm_tool=${disasm_tool[*]}"
  if [[ -n "${linked_libcrypto}" ]]; then
    echo "linked_libcrypto=${linked_libcrypto}"
  fi
  if [[ -n "${linked_libssl}" ]]; then
    echo "linked_libssl=${linked_libssl}"
  fi
  echo "kernel=$(uname -r)"
  echo "uname=$(uname -a)"
} > "${disasm_dir}/metadata.txt"

# --- disassemble ------------------------------------------------------------

echo "disassembling ${binary}..." >&2
"${disasm_tool[@]}" "${binary}" > "${disasm_dir}/binary.asm" 2>&1

echo "extracting symbols from ${binary}..." >&2
"${symbol_tool[@]}" "${binary}" > "${disasm_dir}/symbols.txt" 2>&1

if [[ -n "${linked_libcrypto}" && -f "${linked_libcrypto}" ]]; then
  echo "disassembling ${linked_libcrypto}..." >&2
  "${disasm_tool[@]}" "${linked_libcrypto}" > "${disasm_dir}/libcrypto.asm" 2>&1
fi

if [[ -n "${linked_libssl}" && -f "${linked_libssl}" ]]; then
  echo "disassembling ${linked_libssl}..." >&2
  "${disasm_tool[@]}" "${linked_libssl}" > "${disasm_dir}/libssl.asm" 2>&1
fi

echo "${disasm_dir}"
