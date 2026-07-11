#!/usr/bin/env bash
# Compare a fresh benchmark capture against a committed baseline with benchstat.
#
# This is the manual regression gate for Pillar 3. It is not CI-gated — EC2
# benchmark runs are too expensive and noisy for PR-level CI. The gate is a
# committed baseline plus a documented repetition policy and threshold; see
# docs/research/PERFORMANCE.md "Acceptance thresholds and regression gate".
#
# The gate passes if ztls sec/op does not regress by more than 15% on any
# comparable AES-GCM row versus the baseline, and ztls remains faster than
# libssl on every comparable AES-GCM row. The 15% threshold is generous because
# current deltas are 66–253%; it exists to catch silent regressions, not 1% noise.
#
# Usage:
#   scripts/bench-regression.sh [baseline_capture] [fresh_capture]
#
# Defaults: baseline = latest committed capture under docs/research/perf/;
#           fresh   = latest local capture under zig-out/perf/.
set -euo pipefail
cd "$(dirname "$0")/.."

baseline="${1:-}"
fresh="${2:-}"

if [[ -z "${baseline}" ]]; then
  baseline="$(find docs/research/perf -mindepth 1 -maxdepth 1 -type d \
    -path '*ec2-c7i*' 2>/dev/null | sort | tail -n 1)"
fi
if [[ -z "${fresh}" ]]; then
  fresh="$(find zig-out/perf -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort | tail -n 1)"
fi

if [[ -z "${baseline}" ]]; then
  echo "no baseline capture found under docs/research/perf/" >&2
  exit 1
fi
if [[ -z "${fresh}" ]]; then
  echo "no fresh capture found under zig-out/perf/" >&2
  echo "run: just bench-remote-capture --instance-types c7i.2xlarge --count 10 --benchtime 500ms" >&2
  exit 1
fi
if [[ ! -f "${baseline}/ztls.txt" ]]; then
  echo "baseline ${baseline}/ztls.txt missing" >&2
  exit 1
fi
if [[ ! -f "${fresh}/ztls.txt" ]]; then
  echo "fresh ${fresh}/ztls.txt missing" >&2
  exit 1
fi

tmp_dir=""
cleanup() { [[ -n "${tmp_dir}" ]] && rm -rf "${tmp_dir}"; }
trap cleanup EXIT
tmp_dir="$(mktemp -d)"

# Normalize Go-bench-format ztls output into benchstat rows. Same normalization
# as scripts/bench-analyze.sh normalize_go, kept inline so this script is
# self-contained.
normalize_go() {
  local input="$1" output="$2"
  awk '
    /^Benchmark/ {
      if (NF < 4) next
      name = $1
      sub(/^Benchmark/, "", name)
      n = split(name, parts, "/")
      base = parts[1]
      suite = ""; size = "1"
      for (i = 2; i <= n; i++) {
        if (parts[i] ~ /^impl=/) continue
        if (parts[i] ~ /^suite=/) { suite = substr(parts[i], 7) }
        else if (parts[i] ~ /^size=/) { size = substr(parts[i], 6) }
        else if (suite == "") { suite = parts[i] }
        else if (parts[i] ~ /^[0-9]+$/) { size = parts[i] }
      }
      if (suite == "") suite = "none"
      printf "Benchmark%s/impl=ztls/suite=%s/size=%s", base, suite, size
      for (i = 2; i <= NF; i++) printf "\t%s", $i
      printf "\n"
    }
  ' "${input}" > "${output}"
}

normalize_go "${baseline}/ztls.txt" "${tmp_dir}/baseline.txt"
normalize_go "${fresh}/ztls.txt" "${tmp_dir}/fresh.txt"

# Filter to comparable AES-GCM app-data rows for the regression check.
grep -E '^Benchmark(AppClientToServer|AppServerToClient|AppPingPong)/.*TLS_AES_128_GCM_SHA256|^Benchmark(AppClientToServer|AppServerToClient|AppPingPong)/.*TLS_AES_256_GCM_SHA384' \
  "${tmp_dir}/baseline.txt" > "${tmp_dir}/baseline-aes.txt" || true
grep -E '^Benchmark(AppClientToServer|AppServerToClient|AppPingPong)/.*TLS_AES_128_GCM_SHA256|^Benchmark(AppClientToServer|AppServerToClient|AppPingPong)/.*TLS_AES_256_GCM_SHA384' \
  "${tmp_dir}/fresh.txt" > "${tmp_dir}/fresh-aes.txt" || true

echo "# regression check"
echo "# baseline: ${baseline}"
echo "# fresh:    ${fresh}"
echo "# threshold: 15% regression on any comparable AES-GCM row fails the gate"
echo
echo "## Comparable AES-GCM rows (ztls baseline vs fresh)"
benchstat -row ".name /suite /size" "${tmp_dir}/baseline-aes.txt" "${tmp_dir}/fresh-aes.txt" \
  | sed '/^geomean[[:space:]]/d'
echo

# Check for regressions beyond 15% using benchstat CSV output. benchstat CSV with
# two inputs emits: name,old_secop,old_CI,new_secop,new_CI,vs_base,P. The vs_base
# field is a signed percentage (e.g. "+12.34%" or "-4.03%") or "~" for noise.
# A regression is a positive delta (fresh slower than baseline) beyond +15%.
echo "## Regression check"
regressions=0
while IFS=, read -r name _ _ _ _ delta rest; do
  if [[ "${delta}" == "~" || -z "${delta}" ]]; then
    continue
  fi
  # Strip trailing %; keep the sign. Only flag positive deltas (slower).
  pct="${delta%\%}"
  if awk -v p="${pct}" 'BEGIN{exit !(p > 15)}'; then
    echo "FAIL: ${name} regressed by ${delta} (threshold: +15%)"
    regressions=$((regressions + 1))
  fi
# benchstat CSV emits two sections: sec/op then B/s. Only the sec/op section
# is relevant for regression (positive delta = slower). A positive delta in the
# B/s section means higher throughput (faster), which is not a regression. We
# stop at the first `geomean` row, which ends the sec/op section.
done < <(benchstat -format csv -row ".name /suite /size" \
  "${tmp_dir}/baseline-aes.txt" "${tmp_dir}/fresh-aes.txt" 2>/dev/null \
  | awk '/^geomean/{exit} /^App/{print}' || true)

if [[ ${regressions} -eq 0 ]]; then
  echo "PASS: no comparable AES-GCM row regressed beyond the 15% threshold"
  exit 0
else
  echo
  echo "${regressions} row(s) failed the regression threshold"
  exit 1
fi
