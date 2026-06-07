#!/usr/bin/env bash
set -euo pipefail

suite=${1:-aes_128}
out=${2:-}

cmd=(zig build bench -- --bench ztls_handshake_split --suite "$suite")

if [[ -n "$out" ]]; then
  mkdir -p "$(dirname "$out")"
  exec > "$out"
fi

printf '# command %q' "${cmd[0]}"
for arg in "${cmd[@]:1}"; do
  printf ' %q' "$arg"
done
printf '\n'

"${cmd[@]}" | awk -F, '
  /^#/ { print; next }
  /^benchmark,/ { header = $0; print; next }
  /^ztls_handshake_/ {
    rows[++n] = $0
    names[n] = $1
    suites[n] = $2
    sizes[n] = $3
    iterations[n] = $4
    bytes[n] = $5
    ns[n] = $6 + 0
    rates[n] = $7
    total += ns[n]
    next
  }
  { print }
  END {
    if (n == 0) {
      print "# no ztls_handshake_split rows matched" > "/dev/stderr"
      exit 1
    }

    print ""
    print "# raw_rows"
    for (i = 1; i <= n; i++) print rows[i]

    print ""
    print "hotspot,rank,benchmark,suite,iterations,elapsed_ns,pct_of_split_total,ops_per_sec"
    for (rank = 1; rank <= n; rank++) {
      best = 0
      for (i = 1; i <= n; i++) {
        if (used[i]) continue
        if (best == 0 || ns[i] > ns[best]) best = i
      }
      used[best] = 1
      pct = total == 0 ? 0 : (100.0 * ns[best] / total)
      printf "hotspot,%d,%s,%s,%s,%d,%.2f,%s\n", rank, names[best], suites[best], iterations[best], ns[best], pct, rates[best]
    }
  }
'
