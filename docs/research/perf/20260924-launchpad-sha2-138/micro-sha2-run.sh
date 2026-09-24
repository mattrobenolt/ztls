#!/usr/bin/env bash
cyc() { perf stat -x, -e cycles:u,instructions:u taskset -c 2 ./$1 $2 $3 2>&1 >/dev/null | awk -F, '{print $1}' | tr '\n' ' '; }
for rep in 1 2 3; do
for bin in micro-native micro-baseline; do
for op in hkdf256-std hkdf256-be hkdf384-std hkdf384-be tx256-std tx256-be tx384-std tx384-be; do
  read c1 i1 <<< "$(cyc $bin $op 20000)"; read c2 i2 <<< "$(cyc $bin $op 220000)"
  echo "$rep $bin $op $(( (c2-c1)/200000 )) $(( (i2-i1)/200000 ))"
done; done; done
