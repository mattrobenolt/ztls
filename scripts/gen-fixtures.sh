#!/usr/bin/env bash
# Generate TLS test fixtures for the ztls test suite. This is a provenance
# script — committed outputs should only be regenerated if the test key expires
# (10-year cert, ~2036) or the fixture format changes. RFC 8446 §4.4.3 defines
# the CertificateVerify content.
set -euo pipefail
cd "$(dirname "$0")/.."

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

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

# TLS 1.3 CertificateVerify content and signatures.
uv run python - "$tmp/cv_content.bin" <<'PY'
import hashlib
import sys

h = hashlib.sha256(b"test transcript").digest()
content = b" " * 64 + b"TLS 1.3, server CertificateVerify\x00" + h
with open(sys.argv[1], "wb") as f:
    f.write(content)
PY

openssl dgst -sha256 \
    -sign tests/fixtures/server.key \
    -out "$tmp/cv.sig" \
    "$tmp/cv_content.bin"

# RSA key/certificate for TLS 1.3 RSA-PSS CertificateVerify coverage.
mkdir -p tests/fixtures/rsa_pss
openssl req -x509 -newkey rsa:2048 \
    -keyout tests/fixtures/rsa_pss/server.key \
    -out tests/fixtures/rsa_pss/server.crt \
    -days 3650 \
    -nodes \
    -subj "/CN=rsa-pss.test" \
    -sha256
openssl x509 \
    -in tests/fixtures/rsa_pss/server.crt \
    -outform DER \
    -out tests/fixtures/rsa_pss/server.crt.der
openssl dgst -sha256 \
    -sigopt rsa_padding_mode:pss \
    -sigopt rsa_pss_saltlen:digest \
    -sigopt rsa_mgf1_md:sha256 \
    -sign tests/fixtures/rsa_pss/server.key \
    -out "$tmp/rsa_pss_cv.sig" \
    "$tmp/cv_content.bin"
openssl dgst -sha256 \
    -sigopt rsa_padding_mode:pss \
    -sigopt rsa_pss_saltlen:20 \
    -sigopt rsa_mgf1_md:sha256 \
    -sign tests/fixtures/rsa_pss/server.key \
    -out "$tmp/rsa_pss_cv_salt20.sig" \
    "$tmp/cv_content.bin"

uv run python - \
    "$tmp/cv.sig" \
    "$tmp/rsa_pss_cv.sig" \
    "$tmp/rsa_pss_cv_salt20.sig" \
    tests/fixtures/sig_fixtures.zig <<'PY'
from base64 import b64encode
from pathlib import Path
import sys

names = ["cv_sig", "rsa_pss_cv_sig", "rsa_pss_cv_salt20_sig"]
inputs = [Path(p) for p in sys.argv[1:4]]
out = Path(sys.argv[4])

lines = [
    "//! CertificateVerify signature fixtures, base64-encoded text.\n",
    "//! Generated with: scripts/gen-fixtures.sh\n",
    "//! Transcript hash: SHA-256(\"test transcript\")\n",
    "\n",
    "const std = @import(\"std\");\n",
    "\n",
    "fn decode(\n",
    "    comptime b64: []const u8,\n",
    ") [std.base64.standard.Decoder.calcSizeForSlice(b64) catch unreachable]u8 {\n",
    "    const len = std.base64.standard.Decoder.calcSizeForSlice(b64) catch unreachable;\n",
    "    var decoded: [len]u8 = undefined;\n",
    "    _ = std.base64.standard.Decoder.decode(&decoded, b64) catch unreachable;\n",
    "    return decoded;\n",
    "}\n",
    "\n",
]

for name, path in zip(names, inputs, strict=True):
    b64 = b64encode(path.read_bytes()).decode()
    chunks = [b64[i : i + 76] for i in range(0, len(b64), 76)]
    if len(chunks) == 1:
        lines.append(f"pub const {name} = decode(\"{chunks[0]}\");\n")
    else:
        lines.append(f"pub const {name} = decode(\"{chunks[0]}\" ++\n")
        for chunk in chunks[1:-1]:
            lines.append(f"    \"{chunk}\" ++\n")
        lines.append(f"    \"{chunks[-1]}\");\n")
    lines.append("\n")

out.write_text("".join(lines))
PY
