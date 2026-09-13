import inspect
import json
import os
from pathlib import Path

from scripts import anvil_server
from scripts.anvil_server import copy_new_logs, snapshot_logs, write_run_metadata


def test_write_run_metadata_records_command_and_git(tmp_path: Path):
    write_run_metadata(tmp_path, "java -jar TLS-Anvil.jar server", 4433)

    metadata = json.loads((tmp_path / "run_metadata.json").read_text())
    assert metadata["command"] == "java -jar TLS-Anvil.jar server"
    assert metadata["port"] == 4433
    assert "revision" in metadata["git"]
    assert "dirty" in metadata["git"]


def test_main_writes_run_metadata_before_launching_tls_anvil():
    source = inspect.getsource(anvil_server.main)
    assert source.index("write_run_metadata") < source.index(
        "subprocess.Popen(\n                    cmd"
    )


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


def _write_synthetic_chain_provider_state(
    tmp_path: Path, class_bytes: bytes, provenance_lines: list[str] | None
) -> None:
    """Materialize a synthetic installed-jar + provenance stamp state."""
    import zipfile

    lib = tmp_path / "lib"
    lib.mkdir(exist_ok=True)
    jar = lib / "tls-test-framework-1.5.0.jar"
    with zipfile.ZipFile(jar, "w") as archive:
        archive.writestr(
            "de/rub/nds/tlstest/framework/utils/X509CertificateChainProvider.class",
            class_bytes,
        )
    patch_source = tmp_path / "X509CertificateChainProvider.java"
    patch_source.write_text("// synthetic patch source\n")
    if provenance_lines is not None:
        (tmp_path / "provenance").write_text("\n".join(provenance_lines) + "\n")
    else:
        (tmp_path / "provenance").unlink(missing_ok=True)


def _install_synthetic_paths(monkeypatch, tmp_path: Path) -> None:
    monkeypatch.setattr(
        anvil_server,
        "TLS_TEST_FRAMEWORK_JAR",
        tmp_path / "lib" / "tls-test-framework-1.5.0.jar",
    )
    monkeypatch.setattr(
        anvil_server, "CHAIN_PROVIDER_PATCH_SOURCE", tmp_path / "X509CertificateChainProvider.java"
    )
    monkeypatch.setattr(anvil_server, "CHAIN_PROVIDER_PROVENANCE", tmp_path / "provenance")


def test_chain_provider_provenance_detects_patched_artifact(tmp_path, monkeypatch):
    import hashlib

    class_bytes = b"patched-class-bytes"
    jar_path = tmp_path / "lib" / "tls-test-framework-1.5.0.jar"
    source_path = tmp_path / "X509CertificateChainProvider.java"
    _write_synthetic_chain_provider_state(tmp_path, class_bytes, [])
    (tmp_path / "provenance").write_text(
        "\n".join(
            [
                "patched=true",
                f"jar_sha256={hashlib.sha256(jar_path.read_bytes()).hexdigest()}",
                f"class_sha256={hashlib.sha256(class_bytes).hexdigest()}",
                f"source_sha256={hashlib.sha256(source_path.read_bytes()).hexdigest()}",
            ]
        )
        + "\n"
    )
    _install_synthetic_paths(monkeypatch, tmp_path)

    provenance = anvil_server.chain_provider_provenance()

    assert provenance["patch_status"] == "patched"
    assert provenance["chain_provider_class_sha256"] == hashlib.sha256(class_bytes).hexdigest()
    assert provenance["patch_source_sha256"] == provenance["expected_source_sha256"]


def test_chain_provider_provenance_detects_unpatched_and_stale_artifacts(tmp_path, monkeypatch):
    import hashlib

    # No provenance stamp at all: the installed jar is the pristine upstream.
    _write_synthetic_chain_provider_state(tmp_path, b"pristine-class-bytes", None)
    _install_synthetic_paths(monkeypatch, tmp_path)
    assert anvil_server.chain_provider_provenance()["patch_status"] == "unpatched"

    jar_path = tmp_path / "lib" / "tls-test-framework-1.5.0.jar"

    # Stamp matches jar and class but the patch source drifted after the
    # build: source-only drift must not report patched.
    _write_synthetic_chain_provider_state(tmp_path, b"patched-class-bytes", [])
    (tmp_path / "provenance").write_text(
        "\n".join(
            [
                "patched=true",
                f"jar_sha256={hashlib.sha256(jar_path.read_bytes()).hexdigest()}",
                "class_sha256=" + hashlib.sha256(b"patched-class-bytes").hexdigest(),
                "source_sha256=" + hashlib.sha256(b"older-source").hexdigest(),
            ]
        )
        + "\n"
    )
    provenance = anvil_server.chain_provider_provenance()
    assert provenance["patch_status"] == "stale"
    assert provenance["patch_source_sha256"] != provenance["expected_source_sha256"]

    # Stamp present but missing the source digest entirely: the stamp cannot
    # attribute the artifact to the current source, so it is not patched.
    (tmp_path / "provenance").write_text(
        "\n".join(
            [
                "patched=true",
                f"jar_sha256={hashlib.sha256(jar_path.read_bytes()).hexdigest()}",
                "class_sha256=" + hashlib.sha256(b"patched-class-bytes").hexdigest(),
            ]
        )
        + "\n"
    )
    provenance = anvil_server.chain_provider_provenance()
    assert provenance["patch_status"] == "stale"
    assert provenance["expected_source_sha256"] is None
    anvil_server.CHAIN_PROVIDER_PATCH_SOURCE.unlink()
    assert anvil_server.chain_provider_provenance()["patch_status"] == "stale"

    # Stamp present but the live jar/class differ: stale artifact.
    _write_synthetic_chain_provider_state(
        tmp_path,
        b"pristine-class-bytes",
        ["patched=true", "jar_sha256=deadbeef", "class_sha256=deadbeef", "source_sha256=x"],
    )
    assert anvil_server.chain_provider_provenance()["patch_status"] == "stale"

    # Installed jar missing entirely.
    (tmp_path / "lib" / "tls-test-framework-1.5.0.jar").unlink()
    assert anvil_server.chain_provider_provenance()["patch_status"] == "jar_missing"
    assert anvil_server.chain_provider_provenance()["jar_sha256"] is None


def test_write_run_metadata_records_chain_provider_provenance(tmp_path, monkeypatch):
    _write_synthetic_chain_provider_state(tmp_path, b"patched-class-bytes", None)
    _install_synthetic_paths(monkeypatch, tmp_path)
    monkeypatch.chdir(tmp_path)

    anvil_server.write_run_metadata(tmp_path, "java -jar TLS-Anvil.jar server", 4433)

    metadata = json.loads((tmp_path / "run_metadata.json").read_text())
    assert "chain_provider" in metadata
    assert metadata["chain_provider"]["patch_status"] == "unpatched"
    assert metadata["chain_provider"]["tls_test_framework_jar"].endswith(
        "tls-test-framework-1.5.0.jar"
    )
