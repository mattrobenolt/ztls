#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

mkdir -p zig-out/perf
stamp="$(date +%Y%m%d-%H%M%S)"
zig build bench > "zig-out/perf/ztls-${stamp}.txt"
zig build bench-evp > "zig-out/perf/evp-${stamp}.txt"
zig build bench-openssl > "zig-out/perf/bio-${stamp}.txt"
zig build bench-rustls > "zig-out/perf/rustls-${stamp}.txt"
echo "${stamp}"
