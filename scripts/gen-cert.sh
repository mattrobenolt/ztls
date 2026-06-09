#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

mkdir -p tests/fixtures
openssl req -x509 -newkey ec \
    -pkeyopt ec_paramgen_curve:P-256 \
    -keyout tests/fixtures/server.key \
    -out tests/fixtures/server.crt \
    -days 3650 \
    -nodes \
    -subj "/CN=test.local" \
    -sha256
openssl x509 -in tests/fixtures/server.crt -outform DER -out tests/fixtures/server.crt.der
