import fcntl
import os
import socket
import subprocess
import time
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parent.parent
SERVER_BIN = REPO_ROOT / "zig-out" / "bin" / "ztls_tlsfuzzer_server"


def _wait_for_ready(proc: subprocess.Popen, host: str, port: int, timeout_s: float = 5.0) -> None:
    deadline = time.monotonic() + timeout_s
    marker = b"ztls tlsfuzzer server listening on"
    captured = bytearray()
    assert proc.stdout is not None
    flags = fcntl.fcntl(proc.stdout, fcntl.F_GETFL)
    fcntl.fcntl(proc.stdout, fcntl.F_SETFL, flags | os.O_NONBLOCK)
    saw_marker = False
    while time.monotonic() < deadline:
        if proc.poll() is not None:
            raise RuntimeError(
                f"ztls_tlsfuzzer_server exited early rc={proc.returncode}: {captured.decode(errors='replace')!r}"
            )
        try:
            chunk = proc.stdout.read(4096)
            if chunk:
                captured.extend(chunk)
                saw_marker = marker in captured
        except (BlockingIOError, OSError):
            pass
        if saw_marker:
            try:
                with socket.create_connection((host, port), timeout=0.2):
                    return
            except OSError:
                pass
        time.sleep(0.05)
    raise RuntimeError(
        f"ztls_tlsfuzzer_server not ready on {host}:{port}; output={captured.decode(errors='replace')!r}"
    )


@pytest.fixture(scope="session")
def ztls_server():
    if not SERVER_BIN.exists():
        pytest.fail(f"missing {SERVER_BIN}; run `zig build tlsfuzzer-server` first", pytrace=False)
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        sock.bind(("127.0.0.1", 0))
        port = sock.getsockname()[1]
    env = os.environ.copy()
    env["PORT"] = str(port)
    proc = subprocess.Popen(
        [str(SERVER_BIN)], env=env, stdout=subprocess.PIPE, stderr=subprocess.STDOUT
    )
    _wait_for_ready(proc, "127.0.0.1", port)
    try:
        yield {"host": "127.0.0.1", "port": port, "proc": proc}
    finally:
        if proc.poll() is None:
            proc.terminate()
            try:
                proc.wait(timeout=2)
            except subprocess.TimeoutExpired:
                proc.kill()
                proc.wait(timeout=2)


@pytest.fixture(autouse=True)
def _server_alive(request):
    if "ztls_server" not in request.fixturenames:
        yield
        return
    proc = request.getfixturevalue("ztls_server")["proc"]
    if proc.poll() is not None:
        pytest.fail(f"ztls_tlsfuzzer_server died before test rc={proc.returncode}", pytrace=False)
    yield
    if proc.poll() is not None:
        captured = proc.stdout.read() if proc.stdout else b""
        pytest.fail(
            f"ztls_tlsfuzzer_server died during test rc={proc.returncode}: {captured.decode(errors='replace')!r}",
            pytrace=False,
        )
