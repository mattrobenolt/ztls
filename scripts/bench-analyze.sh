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
      if (NF < 4) {
        emit_warning("warning: skipping incomplete benchmark row in " FILENAME ": " $0);
        next;
      }
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

# Detect and normalize CSV-format rustls captures (pre-Go-bench-format
# captures where rustls.txt has columns
# benchmark,suite,size,iterations,bytes,elapsed_ns,mib_per_sec).
# Returns 0 (true) if the input is CSV-format, 1 (false) if Go-bench-format.
is_csv_format() {
  local input="$1"
  # Check the first non-comment, non-blank line for CSV header or rustls_ prefix.
  local first_line
  first_line="$(grep -vE '^(#|$)' "${input}" 2>/dev/null | head -n 1)"
  [[ -z "${first_line}" ]] && return 1
  [[ "${first_line}" == benchmark,suite,* || "${first_line}" == rustls_* ]]
}

# Normalize CSV-format rustls output into Go-bench rows. Each CSV data row
# becomes one Go-bench sample line:
#   Benchmark<Name>/impl=rustls/suite=<suite>/size=<size>	<iters>	<ns_per_op> ns/op[  <mb_s> MB/s]
# Groups with fewer than 2 samples are excluded (benchstat needs n>=2).
normalize_rustls_csv() {
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
      key = row "/" $2 "/" $3;
      ns_per_op = $6 / $4;
      line = sprintf("Benchmark%s/impl=rustls/suite=%s/size=%s\t%d\t%.3f ns/op", row, $2, $3, $4, ns_per_op);
      if ($3 != 1) line = line sprintf("\t%.2f MB/s", ($5 * 1000.0) / $6);
      lines[++line_count] = line;
      line_keys[line_count] = key;
      counts[key]++;
    }
    END {
      for (i = 1; i <= line_count; i++) {
        key = line_keys[i];
        if (counts[key] < 2) {
          if (!excluded[key]++) excluded_count++;
          continue;
        }
        print lines[i];
      }
      if (excluded_count > 0) {
        print "warning: excluding " excluded_count " rustls benchmark group(s) from benchstat: fewer than 2 samples" > "/dev/stderr";
      }
    }
  ' "${input}" > "${output}"
  if [[ ! -s "${output}" ]]; then
    echo "warning: no comparable rustls benchmark rows in ${input}" >&2
  fi
}

ztls_norm="${tmp_dir}/ztls.txt"
evp_norm="${tmp_dir}/evp.txt"
libssl_norm="${tmp_dir}/libssl.txt"
rustls_norm="${tmp_dir}/rustls.txt"

normalize_go ztls "${run}/ztls.txt" "${ztls_norm}"
normalize_go evp "${run}/evp.txt" "${evp_norm}"
normalize_go openssl "${run}/libssl.txt" "${libssl_norm}"
# rustls captures may be in the old CSV format (pre-Go-bench captures) or
# the current Go-testing format. Detection is format-based: if the first
# non-comment line is a CSV header or starts with rustls_, route through
# the CSV normalizer; otherwise use the shared Go-bench normalizer.
if is_csv_format "${run}/rustls.txt"; then
  normalize_rustls_csv "${run}/rustls.txt" "${rustls_norm}"
else
  normalize_go rustls "${run}/rustls.txt" "${rustls_norm}"
fi

all_norm="${tmp_dir}/all.txt"
tls_norm="${tmp_dir}/tls-comparable.txt"
handshake_norm="${tmp_dir}/handshake-non-equivalent.txt"
crypto_norm="${tmp_dir}/crypto-floor.txt"
other_norm="${tmp_dir}/ztls-non-comparable.txt"
cat "${ztls_norm}" "${evp_norm}" "${libssl_norm}" "${rustls_norm}" > "${all_norm}"

awk '
  /^Benchmark(AppClientToServer|AppServerToClient|AppPingPong)\// { print }
' "${all_norm}" > "${tls_norm}"

awk '
  /^BenchmarkHandshake\// { print }
' "${all_norm}" > "${handshake_norm}"

awk '
  /^Benchmark(RecordEncrypt|RecordDecrypt|Encrypt|Decrypt|BulkEncryptOnce|BulkDecryptOnce)\// { print }
' "${all_norm}" > "${crypto_norm}"

awk '
  !/\/impl=ztls\// { next }
  /^Benchmark(Handshake|AppClientToServer|AppServerToClient|AppPingPong)\// { next }
  /^Benchmark(RecordEncrypt|RecordDecrypt|Encrypt|Decrypt|BulkEncryptOnce|BulkDecryptOnce)\// { next }
  { print }
' "${all_norm}" > "${other_norm}"

warn_comparable_gaps() {
  local file="$1"
  if [[ ! -s "${file}" ]]; then
    return
  fi
  # Warn when a comparable TLS row group has a missing implementation or
  # mismatched sample counts. A "row group" is identified by bench/suite/size;
  # the implementations present are extracted from the impl= tag.
  awk '
    /^Benchmark(AppClientToServer|AppServerToClient|AppPingPong)\// {
      line = $0
      # Strip metrics; only the benchmark name matters for the key.
      name_part = line
      sub(/[[:space:]].*/, "", name_part)
      n = split(name_part, parts, "/")
      bench = parts[1]
      sub(/^Benchmark/, "", bench)
      suite = ""; size = "1"; impl = ""
      for (i = 2; i <= n; i++) {
        if (parts[i] ~ /^impl=/) impl = substr(parts[i], 6)
        else if (parts[i] ~ /^suite=/) suite = substr(parts[i], 7)
        else if (parts[i] ~ /^size=/) size = substr(parts[i], 6)
        else if (suite == "") suite = parts[i]
        else if (parts[i] ~ /^[0-9]+$/) size = parts[i]
      }
      key = bench "/" suite "/" size
      # Track unique implementations per key.
      if (!impl_seen[key "/" impl]) {
        impl_seen[key "/" impl] = 1
        impls[key] = (key in impls ? impls[key] "," : "") impl
      }
      # Sample count = number of lines for this key/impl combination.
      sample_counts[key "/" impl]++
      seen_key[key] = 1
    }
    END {
      for (key in seen_key) {
        n_impls = split(impls[key], impl_list, ",")
        if (n_impls < 3) {
          missing_count++
          if (missing_count <= 10) {
            missing_examples[missing_count] = sprintf("%s has only %d implementation(s): %s", key, n_impls, impls[key])
          }
        }
        # Check sample count mismatch across implementations for this row.
        ref_count = ""
        mismatch = 0
        for (i = 1; i <= n_impls; i++) {
          c = sample_counts[key "/" impl_list[i]]
          if (ref_count == "") ref_count = c
          else if (c != ref_count) mismatch = 1
        }
        if (mismatch) {
          detail = ""
          for (i = 1; i <= n_impls; i++) {
            if (i > 1) detail = detail ", "
            detail = detail impl_list[i] "=" sample_counts[key "/" impl_list[i]]
          }
          mismatch_count++
          if (mismatch_count <= 10) {
            mismatch_examples[mismatch_count] = sprintf("%s: %s", key, detail)
          }
        }
      }
      if (missing_count > 0) {
        printf "warning: %d comparable TLS row group(s) have fewer than 3 implementations\n", missing_count > "/dev/stderr"
        for (i = 1; i <= missing_count && i <= 10; i++) {
          printf "warning:   %s\n", missing_examples[i] > "/dev/stderr"
        }
        if (missing_count > 10) {
          printf "warning:   ... %d more omitted\n", missing_count - 10 > "/dev/stderr"
        }
      }
      if (mismatch_count > 0) {
        printf "warning: %d comparable TLS row group(s) have sample-count mismatches\n", mismatch_count > "/dev/stderr"
        for (i = 1; i <= mismatch_count && i <= 10; i++) {
          printf "warning:   %s\n", mismatch_examples[i] > "/dev/stderr"
        }
        if (mismatch_count > 10) {
          printf "warning:   ... %d more omitted\n", mismatch_count - 10 > "/dev/stderr"
        }
      }
    }
  ' "${file}"
}

run_benchstat() {
  local title="$1"
  local file="$2"
  if [[ ! -s "${file}" ]]; then
    return
  fi
  echo "## ${title}"
  benchstat -row ".name /suite /size" -col /impl "${file}" | sed '/^geomean[[:space:]]/d'
  echo
}

warn_comparable_gaps "${tls_norm}"
run_benchstat "Comparable TLS application-data rows" "${tls_norm}"
if [[ -s "${handshake_norm}" ]]; then
  echo "## Non-equivalent handshake rows (auth-policy differs; reported for transparency only)"
  echo "ztls verifies CertificateVerify, hostname, and leaf policy; rustls NoVerifier skips signature and policy; libssl SSL_VERIFY_NONE behavior is partly opaque. Do not use the vs-base columns below as apples-to-apples performance claims."
  echo
  benchstat -row ".name /suite /size" -col /impl "${handshake_norm}" | sed '/^geomean[[:space:]]/d'
  echo
fi
run_benchstat "Crypto floor rows (not TLS-to-TLS comparisons)" "${crypto_norm}"
run_benchstat "ztls-only diagnostic rows" "${other_norm}"
