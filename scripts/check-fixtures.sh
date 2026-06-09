#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

canonical="tests/fixtures/server-ecdsa"
for dir in src/test/fixtures/server-ecdsa src/test_fixtures/server-ecdsa bench/test_fixtures/server-ecdsa examples/fixtures/server-ecdsa; do
    cmp -s "$canonical/server.der" "$dir/server.der"
    cmp -s "$canonical/scalar.bin" "$dir/scalar.bin"
    if [[ -f "$dir/server.crt" ]]; then
        cmp -s "$canonical/server.crt" "$dir/server.crt"
    fi
done
