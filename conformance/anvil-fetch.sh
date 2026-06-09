#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

anvil_version="1.5.0"
anvil_dir="zig-out/tools/tls-anvil"
anvil_zip="${anvil_dir}/TLS-Anvil-v${anvil_version}.zip"

mkdir -p "${anvil_dir}"
if [[ -f ${anvil_dir}/apps/TLS-Anvil.jar ]]; then
    echo "TLS-Anvil already fetched"
    exit 0
fi

curl -sL -o "${anvil_zip}" "https://github.com/tls-attacker/TLS-Anvil/releases/download/v${anvil_version}/TLS-Anvil-v${anvil_version}.zip"
uv run --script - <<'PY'
import zipfile, sys
with zipfile.ZipFile(sys.argv[1]) as archive:
    archive.extractall(sys.argv[2])
PY "${anvil_zip}" "${anvil_dir}/"
echo "TLS-Anvil fetched to ${anvil_dir}/"
