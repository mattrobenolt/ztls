import hashlib
import subprocess
import sys
import tempfile
import urllib.request
from pathlib import Path

import pytest

# Keep this revision aligned with the tlsfuzzer pin in pyproject.toml. The
# package excludes its _apps modules, so run the pinned upstream driver as a
# downloaded test artifact rather than maintaining a local fork.
TLSFUZZER_REVISION = "bf7f579dc0e65498cfb21b60e9b152f6bd84a3bf"
DRIVER_SHA256 = "f2a5fef6ecf61332018e536d22dfc7a7828fb8010c20c29b346923e309648d91"
DRIVER_URL = (
    "https://raw.githubusercontent.com/tlsfuzzer/tlsfuzzer/"
    f"{TLSFUZZER_REVISION}/tlsfuzzer/_apps/test_tls13_mlkem.py"
)
RFC10024_GROUPS = "secp256r1mlkem768,x25519mlkem768,secp384r1mlkem1024"


@pytest.mark.lockstep
def test_upstream_tls13_mlkem_matrix(ztls_server):
    with urllib.request.urlopen(DRIVER_URL, timeout=30) as response:
        driver = response.read()
    assert hashlib.sha256(driver).hexdigest() == DRIVER_SHA256

    with tempfile.TemporaryDirectory() as tmp:
        driver_path = Path(tmp) / "test_tls13_mlkem.py"
        driver_path.write_bytes(driver)
        result = subprocess.run(
            [
                sys.executable,
                str(driver_path),
                "-h",
                ztls_server["host"],
                "-p",
                str(ztls_server["port"]),
                "--no-fuzz",
                "--kems",
                RFC10024_GROUPS,
            ],
            capture_output=True,
            text=True,
            timeout=180,
            check=False,
        )

    assert result.returncode == 0, result.stdout + result.stderr
