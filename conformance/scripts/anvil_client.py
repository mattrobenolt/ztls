#!/usr/bin/env python3
import argparse
import json
import os
import platform
import stat
import subprocess
import sys
from datetime import UTC, datetime
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from scripts.anvil_server import (  # noqa: E402
    ANVIL_JAR,
    ANVIL_TOOL_LOG_DIR,
    CONF_DIR,
    copy_new_logs,
    free_port,
    git_provenance,
    snapshot_logs,
    terminate,
)

CLIENT_BIN = CONF_DIR / "zig-out" / "bin" / "anvil_client"


def write_run_metadata(output_folder: Path, command: str, port: int, trigger_script: Path) -> None:
    metadata = {
        "generated_at": datetime.now(UTC).isoformat(),
        "host": platform.node(),
        "git": git_provenance(),
        "port": port,
        "client_bin": str(CLIENT_BIN),
        "trigger_script": str(trigger_script),
        "tls_anvil_jar": str(ANVIL_JAR),
        "command": command,
    }
    (output_folder / "run_metadata.json").write_text(json.dumps(metadata, indent=2) + "\n")


def write_trigger_script(
    path: Path, client_bin: Path = CLIENT_BIN, log_path: Path | None = None
) -> None:
    if log_path is None:
        log_path = path.parent / "anvil_client.stderr.log"
    path.write_text(f'#!/usr/bin/env bash\nexec "{client_bin}" >>"{log_path}" 2>&1\n')
    mode = path.stat().st_mode
    path.chmod(mode | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Run TLS-Anvil client tests against the ztls client harness."
    )
    parser.add_argument(
        "--port", type=int, default=0, help="local TLS-Anvil server port; 0 picks one"
    )
    parser.add_argument(
        "--timeout", type=int, default=0, help="seconds before stopping TLS-Anvil; 0 disables"
    )
    parser.add_argument("--strength", default="1", help="TLS-Anvil combinatorial strength")
    parser.add_argument("--parallel-tests", default="1", help="TLS-Anvil parallelTests value")
    parser.add_argument(
        "--parallel-handshakes", default="1", help="TLS-Anvil parallelHandshakes value"
    )
    parser.add_argument("--output-folder", type=Path, default=None)
    args, extra = parser.parse_known_args()

    port = args.port or free_port()
    output_folder = args.output_folder or (
        CONF_DIR / "zig-out" / "anvil" / "client" / datetime.now(UTC).strftime("%Y%m%d-%H%M%S")
    )
    output_folder.mkdir(parents=True, exist_ok=True)
    logs_dir = output_folder / "logs"
    logs_dir.mkdir(parents=True, exist_ok=True)
    trigger_script = logs_dir / "trigger_client.sh"
    write_trigger_script(trigger_script, log_path=logs_dir / "anvil_client.stderr.log")

    cmd = [
        "java",
        "-jar",
        str(ANVIL_JAR),
        "-disableTcpDump",
        "-strength",
        args.strength,
        "-parallelTests",
        args.parallel_tests,
        "-parallelHandshakes",
        args.parallel_handshakes,
        "-outputFolder",
        str(output_folder),
        *extra,
        "client",
        "-port",
        str(port),
        "-triggerScript",
        str(trigger_script),
    ]
    command = " ".join(cmd)
    print(command, flush=True)
    (logs_dir / "TLS-Anvil.command.txt").write_text(command + "\n")
    write_run_metadata(output_folder, command, port, trigger_script)

    env = os.environ.copy()
    env["HOST"] = "127.0.0.1"
    env["PORT"] = str(port)
    env["ZTLS_HOST_NAME"] = "localhost"
    env["ZTLS_INSECURE_NO_CHAIN_ANCHOR"] = "1"
    env["ZTLS_INSECURE_NO_HOST_NAME"] = "1"
    tool_logs_before = snapshot_logs(ANVIL_TOOL_LOG_DIR)
    timeout = args.timeout or None
    stdout_path = logs_dir / "TLS-Anvil.stdout.log"
    try:
        with stdout_path.open("wb") as stdout:
            anvil = subprocess.Popen(
                cmd,
                cwd=CONF_DIR,
                env=env,
                stdout=stdout,
                stderr=subprocess.STDOUT,
            )
            try:
                return anvil.wait(timeout=timeout)
            except subprocess.TimeoutExpired:
                terminate(anvil)
                print(
                    f"TLS-Anvil timed out after {args.timeout}s; partial results: {output_folder}",
                    file=sys.stderr,
                )
                return 124
    finally:
        copied = copy_new_logs(ANVIL_TOOL_LOG_DIR, logs_dir, tool_logs_before)
        if copied:
            print(
                "copied TLS-Anvil logs: " + ", ".join(str(p) for p in copied),
                file=sys.stderr,
            )


if __name__ == "__main__":
    raise SystemExit(main())
