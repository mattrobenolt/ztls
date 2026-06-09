#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.14"
# dependencies = []
# ///
import hashlib
import pathlib
import subprocess
import sys

repo_root = pathlib.Path(__file__).resolve().parent.parent
fixtures_dir = repo_root / "tests" / "fixtures"
fixtures_dir.mkdir(parents=True, exist_ok=True)

transcript_hash = hashlib.sha256(b"test transcript").digest()
content = b" " * 64 + b"TLS 1.3, server CertificateVerify\x00" + transcript_hash
content_file = fixtures_dir / "cv_content.bin"
content_file.write_bytes(content)

subprocess.run(
    [
        "openssl", "dgst", "-sha256",
        "-sign", str(fixtures_dir / "server.key"),
        "-out", str(fixtures_dir / "cv.sig"),
        str(content_file),
    ],
    check=True,
)
