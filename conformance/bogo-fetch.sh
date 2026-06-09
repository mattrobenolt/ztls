#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

bogo_dir="zig-out/tools/boringssl"

if ! command -v go >/dev/null 2>&1; then
    echo "SKIP: go not found in PATH"
    exit 0
fi

mkdir -p zig-out/tools
if [[ ! -d ${bogo_dir} ]]; then
    git clone --depth 1 https://github.com/google/boringssl.git "${bogo_dir}"
fi

cd "${bogo_dir}/ssl/test/runner"
go build -o runner .
