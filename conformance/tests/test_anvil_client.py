import ast
import inspect
import json
import os
import re
import signal
import subprocess
import time
from datetime import UTC, datetime
from pathlib import Path

import pytest

from scripts import anvil_client
from scripts.anvil_client import (
    INVOCATIONS_DIR_NAME,
    INVOCATION_HEADER,
    TRIGGER_FAIL_EXIT,
    write_run_metadata,
    write_trigger_script,
)

# Invariant: each TLS-Anvil trigger invocation must be attributable on its
# own — separate stderr file, subsecond UTC + epoch_ns + PID identity taken
# from one clock snapshot — while the client's exit status, signal death, and
# environment stay exactly what TLS-Anvil would observe with a bare `exec` of
# the client binary. TLS-Anvil test cases can fail 20-60 ms apart, so the
# stamps must carry subsecond precision and must come from a single
# time.time_ns() read (two reads can straddle a clock tick and disagree).

START_RECORD = re.compile(r"anvil_client start utc=(\S+) epoch_ns=(\d+) pid=(\d+)")
LEDGER_RECORD = re.compile(r"anvil_client start utc=(\S+) epoch_ns=(\d+) pid=(\d+) stderr=(.+)")


def _fake_client(path: Path, body: str) -> Path:
    path.write_text(f"#!/usr/bin/env python3\n{body}")
    path.chmod(0o755)
    return path


def _run_trigger(trigger: Path, marker: str) -> subprocess.CompletedProcess[bytes]:
    env = os.environ.copy()
    env["ATTRIB_MARKER"] = marker
    return subprocess.run([str(trigger)], capture_output=True, env=env, timeout=30)


def _invocation_files(tmp_path: Path) -> list[Path]:
    directory = tmp_path / INVOCATIONS_DIR_NAME
    if not directory.exists():
        return []
    return sorted(directory.iterdir())


def _ledger_entries(log_path: Path) -> list[tuple[str, str, str, Path]]:
    entries = []
    for line in log_path.read_text().splitlines():
        match = LEDGER_RECORD.fullmatch(line)
        assert match is not None, f"malformed ledger line: {line}"
        stamp, epoch_ns, pid, stderr_repr = match.groups()
        entries.append((stamp, epoch_ns, pid, ast.literal_eval(stderr_repr)))
    return entries


def _invocation_by_marker(invocations: list[Path], marker: str) -> Path:
    matches = [p for p in invocations if f"marker={marker}" in p.read_text()]
    assert len(matches) == 1, f"marker {marker!r} must identify exactly one invocation"
    return matches[0]


def test_write_run_metadata_records_command_git_and_client_fields(tmp_path: Path):
    trigger = tmp_path / "logs" / "trigger_client.py"
    trigger.parent.mkdir()
    write_run_metadata(tmp_path, "java -jar TLS-Anvil.jar client", 4433, trigger)

    metadata = json.loads((tmp_path / "run_metadata.json").read_text())
    assert metadata["command"] == "java -jar TLS-Anvil.jar client"
    assert metadata["port"] == 4433
    assert metadata["client_bin"].endswith("zig-out/bin/anvil_client")
    assert metadata["trigger_script"] == str(trigger)
    assert "revision" in metadata["git"]
    assert "dirty" in metadata["git"]
    assert "chain_provider" in metadata
    assert metadata["chain_provider"]["patch_status"] in {
        "patched",
        "unpatched",
        "stale",
        "jar_missing",
    }


def test_main_writes_run_metadata_before_launching_tls_anvil():
    source = inspect.getsource(anvil_client.main)
    assert source.index("write_run_metadata") < source.index("subprocess.Popen(")


def test_main_uses_tls_anvil_client_mode_with_trigger_script():
    source = inspect.getsource(anvil_client.main)
    assert '"client"' in source
    assert '"-port"' in source
    assert '"-triggerScript"' in source
    assert 'env["HOST"] = "127.0.0.1"' in source
    assert 'env["PORT"] = str(port)' in source
    assert 'env["ZTLS_HOST_NAME"] = "localhost"' in source
    assert 'env["ZTLS_INSECURE_NO_CHAIN_ANCHOR"] = "1"' in source
    assert 'env["ZTLS_INSECURE_NO_HOST_NAME"] = "1"' in source


def test_trigger_script_is_executable_stdlib_python_without_shell_helpers(tmp_path: Path):
    # Invariant: attribution must not depend on Bash/date portability or add
    # per-invocation helper processes (tee/strace) on the client path. The
    # trigger is a stdlib-Python program that execs the client directly.
    trigger = tmp_path / "trigger_client.py"
    write_trigger_script(trigger, client_bin=tmp_path / "anvil_client")

    script = trigger.read_text()
    assert os.access(trigger, os.X_OK)
    assert script.startswith("#!/usr/bin/env python3\n")
    assert "import os\nimport sys\nimport time\n" in script
    assert "os.execv(CLIENT_BIN, [CLIENT_BIN])" in script
    assert "os.O_EXCL" in script, "invocation files must be created exclusively"
    for forbidden in (
        "subprocess",
        "os.system",
        "tee",
        "strace",
        "date +",
        "shlex",
        "Popen",
    ):
        assert forbidden not in script, f"trigger must not use {forbidden}"


def test_trigger_script_reads_the_clock_once_and_only_via_time_ns(tmp_path: Path):
    # Single-snapshot invariant: one time.time_ns() call supplies the UTC
    # stamp and the epoch_ns identity; any other clock read (time.time,
    # datetime.now, a second time_ns) could straddle a tick and disagree.
    trigger = tmp_path / "trigger_client.py"
    write_trigger_script(trigger, client_bin=tmp_path / "anvil_client")

    script = trigger.read_text()
    assert script.count("= time.time_ns()") == 1, "exactly one clock call site"
    for forbidden in ("time.time(", "datetime.now", "time.monotonic", "time.clock"):
        assert forbidden not in script


def test_start_record_has_subsecond_utc_and_single_snapshot_identity(tmp_path: Path):
    # Format invariant, not a coincidence check: the UTC stamp must always
    # carry a microsecond fraction (so 20-60 ms-apart cases are orderable),
    # and the fraction must agree with the epoch_ns remainder of the same
    # snapshot rather than a second clock read.
    client = _fake_client(
        tmp_path / "anvil_client",
        "import sys\nsys.exit(42)\n",
    )
    trigger = tmp_path / "trigger_client.py"
    write_trigger_script(trigger, client_bin=client)

    assert _run_trigger(trigger, "subsecond").returncode == 42

    header = _invocation_files(tmp_path)[0].read_text().splitlines()[0]
    match = START_RECORD.fullmatch(header)
    assert match is not None, f"missing start record in header: {header}"
    stamp, epoch_ns, _pid = match.groups()

    parsed = re.fullmatch(r"(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2})\.(\d{6})Z", stamp)
    assert parsed is not None, f"utc stamp must be subsecond ISO-8601: {stamp}"
    utc = datetime.strptime(stamp, "%Y-%m-%dT%H:%M:%S.%fZ").replace(tzinfo=UTC)
    remainder_ns = int(epoch_ns) % 1_000_000_000
    assert utc.replace(microsecond=0) == datetime.fromtimestamp(
        int(epoch_ns) // 1_000_000_000, tz=UTC
    )
    assert utc.microsecond == remainder_ns // 1000, (
        "utc fraction and epoch_ns remainder must come from one snapshot"
    )
    assert int(epoch_ns) <= time.time_ns() + 1_000_000_000


def test_each_invocation_is_attributable_via_ledger_not_filename_order(tmp_path: Path):
    # Invariant: invocation identity comes from the ledger and per-invocation
    # content, never from assuming sorted filename order matches invocation
    # order (PIDs are not monotonic and timestamps can tie).
    client = _fake_client(
        tmp_path / "anvil_client",
        "import os, sys\n"
        "print(f'client pid={os.getpid()}', file=sys.stderr)\n"
        "print(f'marker={os.environ[\"ATTRIB_MARKER\"]}', file=sys.stderr)\n"
        "sys.exit(42)\n",
    )
    trigger = tmp_path / "trigger_client.py"
    write_trigger_script(trigger, client_bin=client)

    runs = [_run_trigger(trigger, marker) for marker in ("first", "second")]

    for run in runs:
        assert run.returncode == 42, "client exit status must pass through exactly"

    invocations = _invocation_files(tmp_path)
    assert len(invocations) == 2, "two invocations must produce two separate stderr files"
    assert invocations[0].read_text() != invocations[1].read_text()

    ledger = _ledger_entries(tmp_path / "anvil_client.invocations.log")
    assert len(ledger) == 2, "one ledger line per invocation"
    for entry, marker in zip(ledger, ("first", "second"), strict=True):
        stamp, epoch_ns, ledger_pid, ledger_stderr = entry
        invocation = _invocation_by_marker(invocations, marker)
        assert Path(ledger_stderr) == invocation, (
            "ledger must index the invocation file of the same client run"
        )
        assert re.fullmatch(r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6}Z", stamp)
        assert int(ledger_pid) > 0

        header, client_pid_line, marker_line = invocation.read_text().splitlines()
        match = START_RECORD.fullmatch(header)
        assert match is not None, f"missing start record in {invocation.name}"
        assert match.group(1) == stamp
        assert match.group(2) == epoch_ns
        assert match.group(3) == ledger_pid

        client_pid = int(client_pid_line.removeprefix("client pid="))
        assert client_pid == int(ledger_pid), "exec must keep the client on the script PID"
        assert marker_line == f"marker={marker}", "stderr and environment must pass through"


def test_trigger_script_quotes_paths_with_spaces_and_quotes(tmp_path: Path):
    # repr()-embedded paths must survive spaces, single quotes, and double
    # quotes without any shell layer between the trigger and the client.
    trigger_dir = tmp_path / "log dir 'w' \"q\""
    trigger_dir.mkdir()
    client = _fake_client(
        trigger_dir / "anvil client 'c'",
        "import os, sys\nprint(f'marker={os.environ[\"ATTRIB_MARKER\"]}', file=sys.stderr)\n"
        "sys.exit(42)\n",
    )
    trigger = trigger_dir / "trigger_client.py"
    write_trigger_script(trigger, client_bin=client)

    run = _run_trigger(trigger, "quoted")

    assert run.returncode == 42
    invocations = _invocation_files(trigger_dir)
    assert len(invocations) == 1
    assert "marker=quoted" in invocations[0].read_text()
    ledger = _ledger_entries(trigger_dir / "anvil_client.invocations.log")
    assert len(ledger) == 1
    assert Path(ledger[0][3]) == invocations[0]


@pytest.mark.skipif(os.geteuid() == 0, reason="root bypasses directory permissions")
def test_trigger_fails_loudly_when_invocation_file_cannot_be_created(tmp_path: Path):
    # Log-creation failure must be loud and nonzero (TRIGGER_FAIL_EXIT),
    # never a silent overwrite or a swallowed client run.
    trigger = tmp_path / "trigger_client.py"
    write_trigger_script(trigger, client_bin=_fake_client(tmp_path / "anvil_client", "pass\n"))

    invocations_dir = tmp_path / INVOCATIONS_DIR_NAME
    invocations_dir.chmod(0o500)
    try:
        run = _run_trigger(trigger, "denied")
    finally:
        invocations_dir.chmod(0o700)

    assert run.returncode == TRIGGER_FAIL_EXIT
    assert b"anvil_client: cannot create" in run.stderr
    assert not (tmp_path / "anvil_client.invocations.log").exists()


def test_trigger_script_preserves_client_signal_death(tmp_path: Path):
    client = _fake_client(
        tmp_path / "anvil_client",
        "import os, signal\nos.kill(os.getpid(), signal.SIGTERM)\n",
    )
    trigger = tmp_path / "trigger_client.py"
    write_trigger_script(trigger, client_bin=client)

    run = _run_trigger(trigger, "signal")

    assert run.returncode == -signal.SIGTERM, "signal death must surface unchanged"
    files = _invocation_files(tmp_path)
    assert len(files) == 1
    assert files[0].read_text().startswith("anvil_client start utc=")


def test_invocation_header_constant_matches_generated_script(tmp_path: Path):
    trigger = tmp_path / "trigger_client.py"
    write_trigger_script(trigger, client_bin=tmp_path / "anvil_client")

    script = trigger.read_text()
    assert repr(INVOCATION_HEADER) in script
