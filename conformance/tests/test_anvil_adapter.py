import json
import subprocess
import zipfile
import sys
from pathlib import Path

from scripts.anvil_adapter import extract_feature

CONF_DIR = Path(__file__).resolve().parents[1]
SCRIPTS_DIR = CONF_DIR / "scripts"


def run_adapter(*extra_args: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [sys.executable, str(SCRIPTS_DIR / "anvil_adapter.py"), *extra_args],
        capture_output=True,
        text=True,
    )


def run_report(*extra_args: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [sys.executable, str(SCRIPTS_DIR / "anvil_report.py"), *extra_args],
        capture_output=True,
        text=True,
    )


def load_normalized(path: Path) -> dict:
    return json.loads(path.read_text())


def write_test(path: Path, payload: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload) + "\n")


def test_extract_feature_from_tls_anvil_class_id():
    assert (
        extract_feature("server.tls13.rfc8446.HelloRetryRequest.cookieExchange")
        == "HelloRetryRequest"
    )
    assert extract_feature("server.tls13.rfc8446.ServerHello.verifyKeyShare") == "ServerHello"


def test_extract_feature_unknown_when_id_shape_is_not_tls_anvil():
    assert extract_feature("custom.bundle.testCase") == "unknown"


def test_adapter_normalizes_per_test_json_directory(tmp_path: Path):
    run_dir = tmp_path / "run"
    write_test(
        run_dir / "server" / "tls13" / "rfc8446" / "ServerHello" / "verify.json",
        {
            "Result": "STRICTLY_SUCCEEDED",
            "ClassName": "server.tls13.rfc8446.ServerHello",
            "MethodName": "verifyX25519KeyShare",
            "MetaData": {"description": "server hello accepts X25519 key share"},
        },
    )
    write_test(
        run_dir / "server" / "tls13" / "rfc8446" / "HelloRetryRequest" / "cookie.json",
        {
            "Result": "DISABLED",
            "TestClass": "server.tls13.rfc8446.HelloRetryRequest",
            "TestMethod": "cookieExchange",
            "DisabledReason": "Target does not send a Hello Retry Request",
        },
    )

    out = run_dir / "report.normalized.json"
    cp = run_adapter(str(run_dir), "--output", str(out))

    assert cp.returncode == 0, cp.stderr
    normalized = load_normalized(out)
    assert normalized["provenance"]["adapter_allow_partial"] is False
    assert normalized["tests"] == [
        {
            "id": "server.tls13.rfc8446.HelloRetryRequest.cookieExchange",
            "name": "server.tls13.rfc8446.HelloRetryRequest.cookieExchange",
            "result": "DISABLED",
            "feature": "HelloRetryRequest",
            "disabled_reason": "Target does not send a Hello Retry Request",
        },
        {
            "id": "server.tls13.rfc8446.ServerHello.verifyX25519KeyShare",
            "name": "server hello accepts X25519 key share",
            "result": "STRICTLY_SUCCEEDED",
            "feature": "ServerHello",
        },
    ]


def test_adapter_prefers_class_method_over_opaque_test_id(tmp_path: Path):
    run_dir = tmp_path / "run"
    write_test(
        run_dir / "results" / "8446-xhexdB876E" / "_testRun.json",
        {
            "TestId": "8446-xhexdB876E",
            "Result": "FULLY_FAILED",
            "TestClass": "de.rub.nds.tlstest.suite.tests.both.tls13.rfc8446.ComplianceRequirements",
            "TestMethod": "supportsSecp256r1",
            "FailedReason": "server rejected the secp256r1-only handshake",
            "MetaData": {"description": "TLS-compliant application MUST support secp256r1"},
        },
    )

    cp = run_adapter(str(run_dir))

    assert cp.returncode == 0, cp.stderr
    normalized = load_normalized(run_dir / "report.normalized.json")
    assert normalized["tests"] == [
        {
            "id": "de.rub.nds.tlstest.suite.tests.both.tls13.rfc8446.ComplianceRequirements.supportsSecp256r1",
            "name": "TLS-compliant application MUST support secp256r1",
            "result": "FULLY_FAILED",
            "feature": "ComplianceRequirements",
            "failure_reason": "server rejected the secp256r1-only handshake",
        }
    ]


def test_adapter_accepts_report_json_with_normalized_tests(tmp_path: Path):
    run_dir = tmp_path / "run"
    write_test(
        run_dir / "report.json",
        {
            "tests": [
                {
                    "id": "server.tls13.rfc8446.KeyUpdate.updateNotRequested",
                    "name": "key update not requested",
                    "result": "CONCEPTUALLY_SUCCEEDED",
                    "feature": "KeyUpdate",
                }
            ]
        },
    )

    cp = run_adapter(str(run_dir))

    assert cp.returncode == 0, cp.stderr
    normalized = load_normalized(run_dir / "report.normalized.json")
    assert normalized["tests"][0]["feature"] == "KeyUpdate"


def test_adapter_falls_back_to_per_test_files_when_report_json_is_not_normalized(
    tmp_path: Path,
):
    run_dir = tmp_path / "run"
    write_test(run_dir / "report.json", {"metadata": "not the normalized report schema"})
    write_test(
        run_dir / "ServerHello" / "valid.json",
        {
            "Result": "STRICTLY_SUCCEEDED",
            "ClassName": "server.tls13.rfc8446.ServerHello",
            "MethodName": "validKeyShare",
        },
    )

    cp = run_adapter(str(run_dir))

    assert cp.returncode == 0, cp.stderr
    normalized = load_normalized(run_dir / "report.normalized.json")
    assert normalized["tests"] == [
        {
            "id": "server.tls13.rfc8446.ServerHello.validKeyShare",
            "name": "server.tls13.rfc8446.ServerHello.validKeyShare",
            "result": "STRICTLY_SUCCEEDED",
            "feature": "ServerHello",
        }
    ]


def test_adapter_to_report_matches_skip_patterns_by_stable_id(tmp_path: Path):
    run_dir = tmp_path / "run"
    write_test(
        run_dir / "HelloRetryRequest" / "cookie.json",
        {
            "Result": "DISABLED",
            "ClassName": "server.tls13.rfc8446.HelloRetryRequest",
            "MethodName": "cookieExchange",
            "MetaData": {"description": "cookie exchange and retry"},
        },
    )
    skip_list = tmp_path / "skip.json"
    skip_list.write_text(
        json.dumps(
            {
                "skip": [
                    {"pattern": "*HelloRetryRequest*", "reason": "HRR deferred (#1)"},
                ]
            }
        )
    )

    adapted = run_adapter(str(run_dir))
    assert adapted.returncode == 0, adapted.stderr

    out = tmp_path / "out"
    out.mkdir()
    reported = run_report(
        str(run_dir / "report.normalized.json"),
        "--output-dir",
        str(out),
        "--skip-list",
        str(skip_list),
    )

    assert reported.returncode == 0, reported.stderr
    summary = json.loads((out / "summary.json").read_text())
    assert summary["counts"]["expected_skipped"] == 1
    assert summary["unmatched_skip_patterns"] == []


def write_partial_report_zip(path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    report_info = zipfile.ZipInfo("report.json", (2026, 1, 1, 0, 0, 0))
    test_info = zipfile.ZipInfo(
        "results/opaque/_testRun.json",
        (2026, 1, 1, 0, 0, 0),
    )
    with zipfile.ZipFile(path, "w") as zf:
        zf.writestr(
            report_info,
            json.dumps({"Running": True, "TotalTests": 2, "FinishedTests": 0}) + "\n",
        )
        zf.writestr(
            test_info,
            json.dumps(
                {
                    "Result": "STRICTLY_SUCCEEDED",
                    "TestClass": "server.tls13.rfc8446.ServerHello",
                    "TestMethod": "validKeyShare",
                }
            )
            + "\n",
        )


def test_adapter_rejects_raw_tls_anvil_report_that_is_still_running(tmp_path: Path):
    run_dir = tmp_path / "run"
    write_test(
        run_dir / "report.json",
        {
            "Running": True,
            "TotalTests": 2,
            "FinishedTests": 0,
        },
    )
    write_test(
        run_dir / "results" / "opaque" / "_testRun.json",
        {
            "Result": "STRICTLY_SUCCEEDED",
            "TestClass": "server.tls13.rfc8446.ServerHello",
            "TestMethod": "validKeyShare",
        },
    )

    cp = run_adapter(str(run_dir))

    assert cp.returncode == 2
    assert "still Running" in cp.stderr


def test_adapter_rejects_still_running_report_zip(tmp_path: Path):
    run_dir = tmp_path / "run"
    write_partial_report_zip(run_dir / "report.zip")

    cp = run_adapter(str(run_dir))

    assert cp.returncode == 2
    assert "still Running" in cp.stderr


def test_adapter_allow_partial_accepts_still_running_report(tmp_path: Path):
    run_dir = tmp_path / "run"
    write_test(
        run_dir / "report.json",
        {
            "Running": True,
            "TotalTests": 2,
            "FinishedTests": 0,
        },
    )
    write_test(
        run_dir / "results" / "opaque" / "_testRun.json",
        {
            "Result": "STRICTLY_SUCCEEDED",
            "TestClass": "server.tls13.rfc8446.ServerHello",
            "TestMethod": "validKeyShare",
        },
    )

    cp = run_adapter(str(run_dir), "--allow-partial")

    assert cp.returncode == 0, cp.stderr
    normalized = load_normalized(run_dir / "report.normalized.json")
    assert normalized["provenance"]["adapter_allow_partial"] is True
    assert normalized["provenance"]["tls_anvil"]["report"]["running"] is True
    assert normalized["tests"][0]["id"] == "server.tls13.rfc8446.ServerHello.validKeyShare"


def test_adapter_allow_partial_accepts_still_running_report_zip(tmp_path: Path):
    run_dir = tmp_path / "run"
    write_partial_report_zip(run_dir / "report.zip")

    cp = run_adapter(str(run_dir), "--allow-partial")

    assert cp.returncode == 0, cp.stderr
    normalized = load_normalized(run_dir / "report.normalized.json")
    assert normalized["provenance"]["adapter_allow_partial"] is True
    assert normalized["provenance"]["tls_anvil"]["report"]["running"] is True
    assert normalized["tests"][0]["id"] == "server.tls13.rfc8446.ServerHello.validKeyShare"


def test_adapter_rejects_directory_without_result_json(tmp_path: Path):
    run_dir = tmp_path / "run"
    run_dir.mkdir()
    write_test(run_dir / "noise.json", {"hello": "world"})

    cp = run_adapter(str(run_dir))

    assert cp.returncode == 2
    assert "no TLS-Anvil result JSON" in cp.stderr


def test_adapter_marks_unknown_results_as_not_specified(tmp_path: Path):
    run_dir = tmp_path / "run"
    write_test(
        run_dir / "unknown.json",
        {
            "Result": "ALIEN_RESULT",
            "id": "server.tls13.rfc8446.Alert.alien",
        },
    )

    cp = run_adapter(str(run_dir))

    assert cp.returncode == 0, cp.stderr
    normalized = load_normalized(run_dir / "report.normalized.json")
    assert normalized["tests"][0]["result"] == "NOT_SPECIFIED"
