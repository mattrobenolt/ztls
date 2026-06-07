#!/usr/bin/env python3
"""Run TLS-Anvil client tests using the ztls TLS-Anvil client binary.

Skips gracefully when Java or the TLS-Anvil JAR is missing.
"""

import shutil
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
CLIENT_BIN = REPO_ROOT / "zig-out" / "bin" / "ztls_tls_anvil_client"
ANVIL_DIR = REPO_ROOT / "zig-out" / "tools" / "tls-anvil"
ANVIL_JAR = ANVIL_DIR / "apps" / "TLS-Anvil.jar"


def eprint(msg: str) -> None:
    print(msg, file=sys.stderr)


def main() -> int:
    if not shutil.which("java"):
        eprint("SKIP: java not found in PATH; add jdk to devshell (TODO-122ca1af)")
        return 0

    if not ANVIL_JAR.exists():
        eprint(
            f"SKIP: TLS-Anvil JAR not found at {ANVIL_JAR}; run 'just anvil-fetch' first (TODO-122ca1af)"
        )
        return 0

    if not CLIENT_BIN.exists():
        eprint(
            f"SKIP: client binary not found at {CLIENT_BIN}; run 'zig build tls-anvil-client' first"
        )
        return 0

    # TODO: start TLS-Anvil in client mode, start ztls client against it,
    # collect results, apply skip list.
    eprint(
        "TLS-Anvil client test runner: scaffolding present, full runner not yet wired (TODO-122ca1af)"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
