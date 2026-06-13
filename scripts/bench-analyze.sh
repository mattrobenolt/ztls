#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

if [[ $# -gt 1 ]]; then
  echo "usage: $0 [zig-out/perf/<capture>]" >&2
  exit 2
fi

run="${1:-}"
if [[ -z "${run}" ]]; then
  run="$(find zig-out/perf -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort | tail -n 1)"
fi

if [[ -z "${run}" ]]; then
  echo "no capture directory found under zig-out/perf" >&2
  exit 1
fi

for file in ztls.txt evp.txt libssl.txt rustls.txt; do
  if [[ ! -f "${run}/${file}" ]]; then
    echo "missing ${run}/${file}" >&2
    exit 1
  fi
done

if [[ -f "${run}/metadata.txt" ]]; then
  echo "# capture=${run}"
  sed -n '/^$/q; p' "${run}/metadata.txt" | sed 's/^/# /'
  echo
fi

tmp_dir=""
cleanup() {
  if [[ -n "${tmp_dir}" ]]; then
    rm -rf "${tmp_dir}"
  fi
}
trap cleanup EXIT

tmp_dir="$(mktemp -d)"

normalize_go() {
  local impl="$1"
  local input="$2"
  local output="$3"
  awk -v impl="${impl}" '
    function emit_warning(msg) {
      print msg > "/dev/stderr";
    }
    /^Benchmark/ {
      name = $1;
      sub(/^Benchmark/, "", name);
      n = split(name, parts, "/");
      base = parts[1];
      suite = "";
      size = "1";
      for (i = 2; i <= n; i++) {
        if (parts[i] ~ /^impl=/) continue;
        if (parts[i] ~ /^suite=/) {
          suite = substr(parts[i], 7);
        } else if (parts[i] ~ /^size=/) {
          size = substr(parts[i], 6);
        } else if (suite == "") {
          suite = parts[i];
        } else if (parts[i] ~ /^[0-9]+$/) {
          size = parts[i];
        }
      }
      if (suite == "") suite = "none";
      printf "Benchmark%s/impl=%s/suite=%s/size=%s", base, impl, suite, size;
      for (i = 2; i <= NF; i++) printf "\t%s", $i;
      printf "\n";
    }
  ' "${input}" > "${output}"
  if [[ ! -s "${output}" ]]; then
    echo "warning: no benchmark rows in ${input}" >&2
  fi
}

normalize_rustls() {
  local input="$1"
  local output="$2"
  awk -F, '
    function row_name(name) {
      if (name == "rustls_handshake") return "Handshake";
      if (name == "rustls_handshake_client_start") return "HandshakeClientStart";
      if (name == "rustls_handshake_server_accept") return "HandshakeServerAccept";
      if (name == "rustls_handshake_server_flight") return "HandshakeServerFlight";
      if (name == "rustls_handshake_client_flight") return "HandshakeClientFlight";
      if (name == "rustls_handshake_server_finished") return "HandshakeServerFinished";
      if (name == "rustls_app_client_to_server") return "AppClientToServer";
      if (name == "rustls_app_server_to_client") return "AppServerToClient";
      if (name == "rustls_app_ping_pong") return "AppPingPong";
      return "";
    }
    /^#/ || /^benchmark,/ || NF == 0 { next }
    {
      row = row_name($1);
      if (row == "") {
        print "warning: skipping unknown rustls benchmark " $1 > "/dev/stderr";
        next;
      }
      ns_per_op = $6 / $4;
      printf "Benchmark%s/impl=rustls/suite=%s/size=%s %d %.3f ns/op", row, $2, $3, $4, ns_per_op;
      if ($3 != 1) printf " %.2f MB/s", ($5 * 1000.0) / $6;
      printf "\n";
    }
  ' "${input}" > "${output}"
  if [[ ! -s "${output}" ]]; then
    echo "warning: no benchmark rows in ${input}" >&2
  fi
}

ztls_norm="${tmp_dir}/ztls.txt"
evp_norm="${tmp_dir}/evp.txt"
libssl_norm="${tmp_dir}/libssl.txt"
rustls_norm="${tmp_dir}/rustls.txt"

normalize_go ztls "${run}/ztls.txt" "${ztls_norm}"
normalize_go evp "${run}/evp.txt" "${evp_norm}"
normalize_go openssl "${run}/libssl.txt" "${libssl_norm}"
normalize_rustls "${run}/rustls.txt" "${rustls_norm}"

benchstat -row ".name /suite /size" -col /impl \
  ztls="${ztls_norm}" \
  evp="${evp_norm}" \
  libssl="${libssl_norm}" \
  rustls="${rustls_norm}"
