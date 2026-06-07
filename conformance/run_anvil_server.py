#!/usr/bin/env python3
"""TLS-Anvil server-runner scaffold for the ztls tlsfuzzer server.

Skips gracefully when Java or the TLS-Anvil JAR is missing. Full invocation and
skip-list accounting are still TODO-122ca1af.
"""

import json
import shutil
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
SERVER_BIN = REPO_ROOT / "zig-out" / "bin" / "ztls_tlsfuzzer_server"
ANVIL_DIR = REPO_ROOT / "zig-out" / "tools" / "tls-anvil"
ANVIL_JAR = ANVIL_DIR / "apps" / "TLS-Anvil.jar"
SKIP_LIST = REPO_ROOT / "conformance" / "anvil-skip-list.json"


def eprint(msg: str) -> None:
    print(msg, file=sys.stderr)


def check_skip_list(name: str) -> tuple[bool, str]:
    data = json.loads(SKIP_LIST.read_text())
    for entry in data.get("skip", []):
        import fnmatch

        if fnmatch.fnmatch(name, entry["pattern"]):
            return True, entry["reason"]
    return False, ""


def main() -> int:
    java = shutil.which("java")
    if not java:
        eprint("SKIP: java not found in PATH; add jdk to devshell (TODO-122ca1af)")
        return 0

    if not ANVIL_JAR.exists():
        eprint(
            f"SKIP: TLS-Anvil JAR not found at {ANVIL_JAR}; run 'just anvil-fetch' first (TODO-122ca1af)"
        )
        return 0

    if not SERVER_BIN.exists():
        eprint(
            f"SKIP: server binary not found at {SERVER_BIN}; run 'zig build tlsfuzzer-server' first"
        )
        return 0

    # TODO: find an ephemeral port, start SERVER_BIN, wait for ready,
    # invoke TLS-Anvil in server mode, collect JUnit/console output,
    # diff against skip list, and report pass/skip/fail counts.
    eprint(
        "TLS-Anvil server test runner: scaffolding present, full runner not yet wired (TODO-122ca1af)"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
