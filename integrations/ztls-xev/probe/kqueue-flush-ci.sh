#!/usr/bin/env bash
# Diagnostic branch only (#83): one hunk from mitchellh/libxev#224.
# Modify only this checkout's downloaded dependency, never a global Zig cache.
set -euo pipefail
cd "$(dirname "$0")/../../.."
(cd integrations/ztls-xev && zig build --fetch)

dep=integrations/ztls-xev/zig-pkg/libxev-0.0.0-86vtcwIRFADbH4hk-EjROXxlrKIRPQdA41XiTSytYO-F
source_file="$dep/src/backend/kqueue.zig"
patch_file=integrations/ztls-xev/probe/kqueue-flush.patch
expected=01c0c18f47f81b718f03c4d15279c88852ad148a423fa08d5b3f128cfd9db069
actual=$(sha256sum "$source_file" | cut -d' ' -f1)
if [[ "$actual" != "$expected" ]]; then
    echo "Unexpected libxev source: $actual; refusing diagnostic patch" >&2
    exit 1
fi
printf 'libxev kqueue source before: %s\n' "$actual"
git apply --check --directory="$dep" "$patch_file"
git apply --directory="$dep" "$patch_file"
printf 'libxev kqueue source after: '
sha256sum "$source_file"
