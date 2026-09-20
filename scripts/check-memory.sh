#!/usr/bin/env bash
set -euo pipefail

if [[ $(uname -s) != Linux ]]; then
    echo "The memory gate requires Linux." >&2
    exit 1
fi
targets=(test benchmark)
build_steps=(test-bin bench-bin)
if [[ ${1:-} == --unit-only ]]; then
    targets=(test)
    build_steps=(test-bin)
    shift
fi
if [[ $# -gt 1 ]]; then
    echo "Usage: scripts/check-memory.sh [--unit-only] [new-output-directory]" >&2
    exit 1
fi
: "${ZTLS_OPENSSL_PKG_CONFIG_PATH:?Run inside the ztls Nix development shell.}"
if [[ -n ${1:-} ]]; then
    mkdir -- "$1"
    output=$(realpath -- "$1")
else
    mkdir -p zig-out
    output=$(mktemp -d "$PWD/zig-out/memory.XXXXXX")
fi
printf 'Memory evidence: %s\n' "$output"
trap 'printf "Memory evidence retained: %s\n" "$output"' EXIT

git rev-parse HEAD > "$output/revision.txt"
git status --porcelain=v1 > "$output/worktree.txt"
git diff --binary HEAD -- src tests bench shared build.zig build.zig.zon \
    flake.nix flake.lock nix scripts/check-memory.sh justfile just > "$output/source.patch"
zig version > "$output/zig-version.txt"
valgrind --version > "$output/valgrind-version.txt"
uname -a > "$output/host.txt"
printf '%s\n' "${targets[@]}" > "$output/targets.txt"
provider=$(nix build .#openssl-memcheck.out --no-link --print-out-paths)
printf '%s\n' "$provider" > "$output/provider.txt"
sha256sum "$provider/lib/libcrypto.so.3" > "$output/provider.sha256"

# Compile against the production headers. Only diagnostic runs select the
# equivalent provider with compiler vectorization disabled (#121).
PKG_CONFIG_PATH="$ZTLS_OPENSSL_PKG_CONFIG_PATH" zig build "${build_steps[@]}" \
    -Doptimize=ReleaseFast -Dcpu=baseline \
    --prefix "$output/bin" > "$output/build.log" 2>&1
LD_LIBRARY_PATH="$provider/lib" LD_DEBUG=libs ZTEST_FILTER=test_0 \
    "$output/bin/bin/test" > "$output/provider-binding.log" 2>&1
grep -F "calling init: $provider/lib/libcrypto.so.3" "$output/provider-binding.log" >/dev/null

unset ZTEST_FILTER
for target in "${targets[@]}"; do
    args=()
    if [[ $target == benchmark ]]; then
        args=(--filter=BenchmarkClientHandshakeReplay --benchtime=1x --count=1)
    fi
    LD_LIBRARY_PATH="$provider/lib" timeout 300 valgrind \
        --leak-check=full --show-leak-kinds=all --errors-for-leak-kinds=all \
        --track-origins=yes --error-exitcode=99 \
        --log-file="$output/$target-valgrind.log" \
        "$output/bin/bin/$target" "${args[@]}" > "$output/$target.log" 2>&1
    if [[ $target == benchmark ]]; then
        [[ $(grep -c '^BenchmarkClientHandshakeReplay/' "$output/$target.log") == 3 ]]
    else
        grep -Eq '^ztest: [1-9][0-9]* passed, 0 failed,' "$output/$target.log"
    fi
    printf '%s: zero Memcheck errors\n' "$target"
done
