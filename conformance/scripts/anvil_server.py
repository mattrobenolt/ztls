#!/usr/bin/env python3
import argparse
import json
import os
import platform
import shutil
import socket
import subprocess
import sys
import time
from datetime import UTC, datetime
from pathlib import Path

CONF_DIR = Path(__file__).resolve().parents[1]
SERVER_BIN = CONF_DIR / "zig-out" / "bin" / "tlsfuzzer_server"
ANVIL_JAR = CONF_DIR / "zig-out" / "tools" / "TLS-Anvil.jar"
# TLS-Anvil v1.5.0 writes testsuite/tlsattacker logs beside the jar under
# `logs/default_<date>_*`. Copy any files changed during a run into that run's
# output directory so timeout/failure evidence stays attached to the capture.
ANVIL_TOOL_LOG_DIR = ANVIL_JAR.parent / "logs"
REPO_ROOT = CONF_DIR.parent


def command_output(args: list[str], cwd: Path) -> str | None:
    try:
        cp = subprocess.run(args, cwd=cwd, capture_output=True, text=True, check=True)
    except OSError, subprocess.CalledProcessError:
        return None
    return cp.stdout.strip()


def git_provenance() -> dict[str, object]:
    revision = command_output(["git", "rev-parse", "--short", "HEAD"], REPO_ROOT)
    status = command_output(["git", "status", "--porcelain"], REPO_ROOT)
    return {"revision": revision or "unknown", "dirty": bool(status)}


def write_run_metadata(output_folder: Path, command: str, port: int) -> None:
    metadata = {
        "generated_at": datetime.now(UTC).isoformat(),
        "host": platform.node(),
        "git": git_provenance(),
        "port": port,
        "server_bin": str(SERVER_BIN),
        "tls_anvil_jar": str(ANVIL_JAR),
        "command": command,
    }
    (output_folder / "run_metadata.json").write_text(json.dumps(metadata, indent=2) + "\n")


def free_port() -> int:
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        sock.bind(("127.0.0.1", 0))
        return int(sock.getsockname()[1])


def wait_for_server(proc: subprocess.Popen[bytes], port: int) -> None:
    deadline = time.monotonic() + 5
    captured = bytearray()
    assert proc.stdout is not None
    while time.monotonic() < deadline:
        if proc.poll() is not None:
            raise RuntimeError(
                f"ztls server exited rc={proc.returncode}: {captured.decode(errors='replace')!r}"
            )
        line = proc.stdout.readline()
        if line:
            captured.extend(line)
            if b"ztls tlsfuzzer server listening on" in line:
                with socket.create_connection(("127.0.0.1", port), timeout=1):
                    return
        time.sleep(0.05)
    raise RuntimeError(
        f"ztls server not ready on 127.0.0.1:{port}; output={captured.decode(errors='replace')!r}"
    )


def terminate(proc: subprocess.Popen[bytes]) -> None:
    if proc.poll() is not None:
        return
    proc.terminate()
    try:
        proc.wait(timeout=2)
    except subprocess.TimeoutExpired:
        proc.kill()
        proc.wait(timeout=2)


def snapshot_logs(log_dir: Path) -> dict[str, int]:
    if not log_dir.is_dir():
        return {}
    return {p.name: p.stat().st_mtime_ns for p in log_dir.iterdir() if p.is_file()}


def copy_new_logs(log_dir: Path, dest_dir: Path, before: dict[str, int]) -> list[Path]:
    if not log_dir.is_dir():
        return []
    copied: list[Path] = []
    for src in sorted(p for p in log_dir.iterdir() if p.is_file()):
        if before.get(src.name) == src.stat().st_mtime_ns:
            continue
        dest_dir.mkdir(parents=True, exist_ok=True)
        dest = dest_dir / src.name
        shutil.copy2(src, dest)
        copied.append(dest)
    return copied


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Run TLS-Anvil server tests against the ztls server harness."
    )
    parser.add_argument("--port", type=int, default=0, help="local ztls server port; 0 picks one")
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
        CONF_DIR / "zig-out" / "anvil" / "server" / datetime.now(UTC).strftime("%Y%m%d-%H%M%S")
    )
    output_folder.mkdir(parents=True, exist_ok=True)
    logs_dir = output_folder / "logs"
    logs_dir.mkdir(parents=True, exist_ok=True)

    env = os.environ.copy()
    env["PORT"] = str(port)
    server = subprocess.Popen(
        [str(SERVER_BIN)],
        cwd=CONF_DIR,
        env=env,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    try:
        wait_for_server(server, port)
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
            "server",
            "-connect",
            f"127.0.0.1:{port}",
        ]
        command = " ".join(cmd)
        print(command, flush=True)
        (logs_dir / "TLS-Anvil.command.txt").write_text(command + "\n")
        write_run_metadata(output_folder, command, port)
        tool_logs_before = snapshot_logs(ANVIL_TOOL_LOG_DIR)
        timeout = args.timeout or None
        stdout_path = logs_dir / "TLS-Anvil.stdout.log"
        try:
            with stdout_path.open("wb") as stdout:
                anvil = subprocess.Popen(
                    cmd,
                    cwd=CONF_DIR,
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
    finally:
        terminate(server)


if __name__ == "__main__":
    raise SystemExit(main())
