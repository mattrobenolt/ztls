#!/usr/bin/env python3
import argparse
import os
import socket
import subprocess
import sys
import time
from datetime import UTC, datetime
from pathlib import Path

CONF_DIR = Path(__file__).resolve().parents[1]
SERVER_BIN = CONF_DIR / "zig-out" / "bin" / "tlsfuzzer_server"
ANVIL_JAR = CONF_DIR / "zig-out" / "tools" / "TLS-Anvil.jar"


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
    output_folder.parent.mkdir(parents=True, exist_ok=True)

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
        print(" ".join(cmd), flush=True)
        timeout = args.timeout or None
        try:
            return subprocess.run(cmd, cwd=CONF_DIR, timeout=timeout, check=False).returncode
        except subprocess.TimeoutExpired:
            print(
                f"TLS-Anvil timed out after {args.timeout}s; partial results: {output_folder}",
                file=sys.stderr,
            )
            return 124
    finally:
        terminate(server)


if __name__ == "__main__":
    raise SystemExit(main())
