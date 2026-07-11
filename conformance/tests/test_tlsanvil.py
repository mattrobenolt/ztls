import json
import re
import subprocess
from pathlib import Path

CONF_DIR = Path(__file__).resolve().parents[1]


def test_tls_anvil_cli_dependencies_are_installed():
    jar = CONF_DIR / "zig-out" / "tools" / "TLS-Anvil.jar"
    lib = CONF_DIR / "zig-out" / "tools" / "lib"

    assert jar.is_file()
    assert lib.is_dir()

    result = subprocess.run(
        ["java", "-jar", str(jar), "server"],
        cwd=jar.parent,
        check=False,
        capture_output=True,
        text=True,
        timeout=20,
    )
    output = result.stdout + result.stderr

    assert result.returncode != 0
    assert "NoClassDefFoundError" not in output
    assert "The following option is required: [-connect]" in output


def test_tls_anvil_skip_list_uses_github_issue_refs():
    skip_list = json.loads((CONF_DIR / "anvil-skip-list.json").read_text())
    for entry in skip_list["skip"]:
        reason = entry["reason"]
        assert "TODO-" not in reason
        if "deferred" in reason or "supported surface" in reason:
            assert re.search(r"#\d+", reason), reason
