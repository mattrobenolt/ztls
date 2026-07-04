import inspect
import json
import os
from pathlib import Path

from scripts import anvil_client
from scripts.anvil_client import write_run_metadata, write_trigger_script


def test_write_run_metadata_records_command_git_and_client_fields(tmp_path: Path):
    trigger = tmp_path / "logs" / "trigger_client.sh"
    trigger.parent.mkdir()
    write_run_metadata(tmp_path, "java -jar TLS-Anvil.jar client", 4433, trigger)

    metadata = json.loads((tmp_path / "run_metadata.json").read_text())
    assert metadata["command"] == "java -jar TLS-Anvil.jar client"
    assert metadata["port"] == 4433
    assert metadata["client_bin"].endswith("zig-out/bin/anvil_client")
    assert metadata["trigger_script"] == str(trigger)
    assert "revision" in metadata["git"]
    assert "dirty" in metadata["git"]


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


def test_trigger_script_is_executable_and_execs_client_bin(tmp_path: Path):
    client_bin = tmp_path / "anvil_client"
    trigger = tmp_path / "trigger_client.sh"

    write_trigger_script(trigger, client_bin)

    assert os.access(trigger, os.X_OK)
    assert trigger.read_text() == (
        f'#!/usr/bin/env bash\nexec "{client_bin}" >>"{tmp_path / "anvil_client.stderr.log"}" 2>&1\n'
    )
