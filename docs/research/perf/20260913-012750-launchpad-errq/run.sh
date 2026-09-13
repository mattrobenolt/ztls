#!/usr/bin/env bash
# #88 acceptance measurement: unified unconditional ERR_set_mark/ERR_pop_to_mark
# record-path cost. Baseline ba4a10f vs candidate da79926, same host, same
# devshell libcrypto (OpenSSL 3.6.4), ReleaseFast, apple_m1 target CPU.
# Rows: existing RecordEncrypt/RecordDecrypt x {AES128-GCM, ChaCha20Poly1305}
# x {16, 1350, 16384}. No other rows, no cross-implementation numbers.
set -euo pipefail

BASE=/tmp/ztls-errq-baseline/zig-out/bin/benchmark
CAND=/tmp/ztls-errq-perf/zig-out/bin/benchmark
OUT=/tmp/ztls-errq-perf/docs/research/perf/20260913-012750-launchpad-errq
PIN="taskset -c 3"
ROUNDS=6
COUNT=5
BT=300ms

FILTER='^BenchmarkRecordEncrypt/TLS_AES_128_GCM_SHA256/16$,^BenchmarkRecordEncrypt/TLS_AES_128_GCM_SHA256/1350$,^BenchmarkRecordEncrypt/TLS_AES_128_GCM_SHA256/16384$,^BenchmarkRecordEncrypt/TLS_CHACHA20_POLY1305_SHA256/16$,^BenchmarkRecordEncrypt/TLS_CHACHA20_POLY1305_SHA256/1350$,^BenchmarkRecordEncrypt/TLS_CHACHA20_POLY1305_SHA256/16384$,^BenchmarkRecordDecrypt/TLS_AES_128_GCM_SHA256/16$,^BenchmarkRecordDecrypt/TLS_AES_128_GCM_SHA256/1350$,^BenchmarkRecordDecrypt/TLS_AES_128_GCM_SHA256/16384$,^BenchmarkRecordDecrypt/TLS_CHACHA20_POLY1305_SHA256/16$,^BenchmarkRecordDecrypt/TLS_CHACHA20_POLY1305_SHA256/1350$,^BenchmarkRecordDecrypt/TLS_CHACHA20_POLY1305_SHA256/16384$'

# Wall-time: ABBA-alternating rounds. Each invocation = 12 rows x 5 samples.
for r in $(seq 1 "$ROUNDS"); do
    if [ $((r % 2)) -eq 1 ]; then order="base cand"; else order="cand base"; fi
    for who in $order; do
        bin=$BASE; [ "$who" = cand ] && bin=$CAND
        echo "# round=$r who=$who start=$(date -u +%H:%M:%S) load=$(cut -d' ' -f1 /proc/loadavg)"
        $PIN "$bin" --filter "$FILTER" --count="$COUNT" --benchtime="$BT" --no-env \
            > "$OUT/wall-${who}-r${r}.txt" 2>&1
    done
done

# Instruction/cycle counts: fixed iteration counts per size, perf stat,
# alternating baseline/candidate, 3 repeats each.
declare -A ITERS=( [16]=4000000 [1350]=300000 [16384]=30000 )
for suite in TLS_AES_128_GCM_SHA256 TLS_CHACHA20_POLY1305_SHA256; do
    for op in RecordEncrypt RecordDecrypt; do
        for size in 16 1350 16384; do
            row="^Benchmark${op}/${suite}/${size}\$"
            for rep in 1 2 3; do
                for who in base cand; do
                    bin=$BASE; [ "$who" = cand ] && bin=$CAND
                    tag="${op}-${suite}-${size}-${who}-r${rep}"
                    $PIN perf stat -e instructions:u -x, \
                        -o "$OUT/perf-instr-${tag}.txt" -- \
                        "$bin" --filter "$row" --count=1 \
                        --benchtime="${ITERS[$size]}x" --no-env \
                        > "$OUT/perf-instr-${tag}.bench.txt" 2>&1
                    $PIN perf stat -e cycles:u,branches:u,branch-misses:u -x, \
                        -o "$OUT/perf-cyc-${tag}.txt" -- \
                        "$bin" --filter "$row" --count=1 \
                        --benchtime="${ITERS[$size]}x" --no-env \
                        > "$OUT/perf-cyc-${tag}.bench.txt" 2>&1
                done
            done
        done
    done
done
echo DONE
