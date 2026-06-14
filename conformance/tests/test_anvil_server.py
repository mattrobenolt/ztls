import json
import os
from pathlib import Path

from scripts.anvil_server import copy_new_logs, snapshot_logs, write_run_metadata


def test_write_run_metadata_records_command_and_git(tmp_path: Path):
    write_run_metadata(tmp_path, "java -jar TLS-Anvil.jar server", 4433)

    metadata = json.loads((tmp_path / "run_metadata.json").read_text())
    assert metadata["command"] == "java -jar TLS-Anvil.jar server"
    assert metadata["port"] == 4433
    assert "revision" in metadata["git"]
    assert "dirty" in metadata["git"]


def test_snapshot_logs_returns_empty_for_missing_or_empty_dir(tmp_path: Path):
    assert snapshot_logs(tmp_path / "missing") == {}

    empty = tmp_path / "empty"
    empty.mkdir()
    assert snapshot_logs(empty) == {}


def test_copy_new_logs_copies_only_new_or_changed_files(tmp_path: Path):
    src = tmp_path / "tool-logs"
    dest = tmp_path / "run" / "logs"
    src.mkdir()

    old = src / "old.log"
    old.write_text("old\n")
    before = snapshot_logs(src)

    new = src / "new.log"
    new.write_text("new\n")
    old.write_text("old changed\n")
    os.utime(old, ns=(before[old.name] + 1_000_000, before[old.name] + 1_000_000))

    copied = copy_new_logs(src, dest, before)

    assert sorted(p.name for p in copied) == ["new.log", "old.log"]
    assert (dest / "new.log").read_text() == "new\n"
    assert (dest / "old.log").read_text() == "old changed\n"


def test_copy_new_logs_ignores_missing_source(tmp_path: Path):
    dest = tmp_path / "run" / "logs"
    assert copy_new_logs(tmp_path / "missing", dest, {}) == []
    assert not dest.exists()


def test_copy_new_logs_ignores_unchanged_files(tmp_path: Path):
    src = tmp_path / "tool-logs"
    dest = tmp_path / "run" / "logs"
    src.mkdir()
    unchanged = src / "unchanged.log"
    unchanged.write_text("same\n")

    before = snapshot_logs(src)
    assert copy_new_logs(src, dest, before) == []
    assert not dest.exists()
