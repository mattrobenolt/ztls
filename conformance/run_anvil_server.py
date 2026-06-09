#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.14"
# dependencies = []
# ///
"""TLS-Anvil server-runner scaffold for the ztls tlsfuzzer server."""

import json
import sys
from pathlib import Path

CONF_DIR = Path(__file__).resolve().parent
SERVER_BIN = CONF_DIR / "zig-out" / "bin" / "tlsfuzzer_server"
ANVIL_DIR = CONF_DIR / "zig-out" / "tools" / "tls-anvil"
ANVIL_JAR = ANVIL_DIR / "apps" / "TLS-Anvil.jar"
SKIP_LIST = CONF_DIR / "anvil-skip-list.json"


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
    if not ANVIL_JAR.exists():
        eprint(f"expected TLS-Anvil JAR at {ANVIL_JAR}; run 'just anvil-fetch'")
        return 1

    if not SERVER_BIN.exists():
        eprint(f"expected server binary at {SERVER_BIN}; run 'zig build tlsfuzzer-server' from conformance/")
        return 1

    eprint("TLS-Anvil server test runner scaffold is present; full runner is not wired yet")
    return 0


if __name__ == "__main__":
    sys.exit(main())
