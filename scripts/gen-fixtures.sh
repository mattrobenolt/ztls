#!/usr/bin/env bash
# Generate TLS test fixtures for the ztls test suite. This is a one-time
# provenance script — the generated files (server.key, server.crt,
# server.crt.der, cv_content.bin, cv.sig) are committed and should only be
# regenerated if the test key expires (10-year cert, ~2036) or the fixture
# format changes. RFC 8446 §4.4.3 defines the CertificateVerify content.
set -euo pipefail
cd "$(dirname "$0")/.."

mkdir -p tests/fixtures

# ECDSA P-256 key and self-signed certificate
openssl req -x509 -newkey ec \
    -pkeyopt ec_paramgen_curve:P-256 \
    -keyout tests/fixtures/server.key \
    -out tests/fixtures/server.crt \
    -days 3650 \
    -nodes \
    -subj "/CN=test.local" \
    -sha256
openssl x509 -in tests/fixtures/server.crt -outform DER -out tests/fixtures/server.crt.der

# TLS 1.3 CertificateVerify content and signature
uv run python -c "
import hashlib
h = hashlib.sha256(b'test transcript').digest()
content = b' ' * 64 + b'TLS 1.3, server CertificateVerify\x00' + h
with open('tests/fixtures/cv_content.bin', 'wb') as f:
    f.write(content)
"

openssl dgst -sha256 \
    -sign tests/fixtures/server.key \
    -out tests/fixtures/cv.sig \
    tests/fixtures/cv_content.bin
