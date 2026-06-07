#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.14"
# dependencies = []
# ///
"""TLS-Anvil client-runner scaffold for the ztls TLS-Anvil client binary."""

import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
CLIENT_BIN = REPO_ROOT / "zig-out" / "bin" / "ztls_tls_anvil_client"
ANVIL_DIR = REPO_ROOT / "zig-out" / "tools" / "tls-anvil"
ANVIL_JAR = ANVIL_DIR / "apps" / "TLS-Anvil.jar"


def eprint(msg: str) -> None:
    print(msg, file=sys.stderr)


def main() -> int:
    if not ANVIL_JAR.exists():
        eprint(f"expected TLS-Anvil JAR at {ANVIL_JAR}; run 'just anvil-fetch'")
        return 1

    if not CLIENT_BIN.exists():
        eprint(f"expected client binary at {CLIENT_BIN}; run 'zig build tls-anvil-client'")
        return 1

    eprint("TLS-Anvil client test runner scaffold is present; full runner is not wired yet")
    return 0


if __name__ == "__main__":
    sys.exit(main())
