#!/usr/bin/env bash
cyc() { perf stat -x, -e cycles:u,instructions:u taskset -c 2 $1 $2 $3 2>&1 >/dev/null | awk -F, '{print $1}' | tr '\n' ' '; }
for rep in 1 2 3 4 5; do
for suite in sha256 sha384; do
for v in base-native base-baseline fork-native fork-baseline; do
  read c1 i1 <<< "$(cyc out/$v/bin/hs $suite 200)"; read c2 i2 <<< "$(cyc out/$v/bin/hs $suite 2200)"
  echo "$rep $suite $v $(( (c2-c1)/2000 )) $(( (i2-i1)/2000 ))"
done; done; done
