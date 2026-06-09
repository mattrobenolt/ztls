#!/usr/bin/env bash
set -euo pipefail

CONF_DIR="$(cd "$(dirname "$0")" && pwd)"
SHIM_BIN="${CONF_DIR}/zig-out/bin/bogo"
BOGO_RUNNER="${CONF_DIR}/zig-out/tools/boringssl/ssl/test/runner/runner"
SKIP_LIST="${CONF_DIR}/bogo-skip-list.json"

if ! command -v go >/dev/null 2>&1; then
    echo "SKIP: go not found in PATH; add go to devshell (TODO-0a5196f2)"
    exit 0
fi

if [[ ! -x "$BOGO_RUNNER" ]]; then
    echo "SKIP: BoGo runner not found at ${BOGO_RUNNER}; run 'just bogo-fetch' first (TODO-0a5196f2)"
    exit 0
fi

if [[ ! -x "$SHIM_BIN" ]]; then
    echo "SKIP: BoGo shim not found at ${SHIM_BIN}; run 'zig build bogo-shim' first"
    exit 0
fi

# TODO: invoke BoGo runner with the shim path, apply skip list, and report.
echo "BoGo test runner: scaffolding present, full runner not yet wired (TODO-0a5196f2)"
exit 0
