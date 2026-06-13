import subprocess

from conftest import CONF_DIR


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
