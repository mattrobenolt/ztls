"""Test TLS-Anvil result normalization and skip-list enforcement.

Uses the committed synthetic fixture (test_fixtures/anvil_report_synthetic.json)
as the input shape; the parser does not require a real TLS-Anvil run.
"""

import fnmatch
import json
import subprocess
import sys
from pathlib import Path

CONF_DIR = Path(__file__).resolve().parents[1]
SCRIPTS_DIR = CONF_DIR / "scripts"
FIXTURE_PATH = CONF_DIR / "test_fixtures" / "anvil_report_synthetic.json"
SKIP_LIST_PATH = CONF_DIR / "anvil-skip-list.json"

# The synthetic fixture has these known expected counts.
# If the fixture or skip-list changes, these must be updated.
EXPECTED_COUNTS = {
    "total": 21,
    "expected_skipped": 3,
    "unexpected_skipped": 4,
    "passed": 9,
    "failed": 4,
    "errored": 1,
    "timeout": 0,
    "not_attempted": 0,
}

EXPECTED_UNEXPECTED = {
    "unexpected_fail": 4,
    "unexpected_skipped": 4,
}

EXPECTED_FEATURES = 19  # distinct feature values in the fixture


# ─── helpers ────────────────────────────────────────────────────────────


def run_report(*extra_args: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [sys.executable, str(SCRIPTS_DIR / "anvil_report.py"), *extra_args],
        capture_output=True,
        text=True,
    )


def load_summary_json(dir_path: Path) -> dict:
    return json.loads((dir_path / "summary.json").read_text())


def load_summary_txt(dir_path: Path) -> str:
    return (dir_path / "summary.txt").read_text()


# ─── skip-list validation ───────────────────────────────────────────────


def test_skip_list_loaded():
    """confirm the skip-list file is parseable and has entries."""
    raw = json.loads(SKIP_LIST_PATH.read_text())
    assert "skip" in raw
    assert isinstance(raw["skip"], list)
    assert len(raw["skip"]) >= 1
    for entry in raw["skip"]:
        assert "pattern" in entry
        assert "reason" in entry
        # ensure pattern uses fnmatch-compatible wildcards
        assert "*" in entry["pattern"], f"pattern must be a glob: {entry['pattern']}"


# ─── synthetic fixture validation ───────────────────────────────────────


def test_synthetic_fixture_loads():
    raw = json.loads(FIXTURE_PATH.read_text())
    assert "tests" in raw
    assert isinstance(raw["tests"], list)
    for test in raw["tests"]:
        assert "id" in test
        assert "name" in test
        assert "result" in test
        assert "feature" in test


# ─── skip-list matching behavior ────────────────────────────────────────


def test_pattern_hello_retry_request_reason_matches():
    """HRR skips match TLS-Anvil's disabled reason, not broad RFC prose."""
    assert fnmatch.fnmatch(
        "Target does not send a Hello Retry Request",
        "*Target does not send a Hello Retry Request*",
    )


def test_pattern_psk_disabled_reason_matches():
    """PSK skips match TLS-Anvil's disabled reason, not passing PSK prose."""
    assert fnmatch.fnmatch(
        "SUT does not support PSK handshakes",
        "*SUT does not support PSK handshakes*",
    )


def test_pattern_tls12_lowercase_id_matches():
    """Real TLS-Anvil class ids use lowercase tls12."""
    assert fnmatch.fnmatch("de.rub.nds.tlstest.suite.tests.server.tls12.foo", "*tls12*")


def test_end_of_early_data_pass_not_hidden_by_skip_list():
    """sendEndOfEarlyDataAsServer STRICTLY_SUCCEEDED must NOT match any committed
    skip-list pattern.  The old broad *EarlyData* glob matched this test's Java
    class id (StateMachine.sendEndOfEarlyDataAsServer) and caused a false
    unexpected_pass.  The narrowed pattern is scoped to the
    server.tls13.rfc8446.EarlyData class, which is in a different package."""
    from scripts.anvil_report import matches_any_pattern

    skip_entries = json.loads(SKIP_LIST_PATH.read_text())["skip"]

    # Real id produced by the adapter (TestClass + "." + TestMethod).
    test_id = (
        "de.rub.nds.tlstest.suite.tests.client.tls13.statemachine"
        ".StateMachine.sendEndOfEarlyDataAsServer"
    )
    test_name = (
        "Servers MUST NOT send this message, and clients receiving it MUST "
        'terminate the connection with an "unexpected_message" alert.'
    )

    assert matches_any_pattern(test_name, skip_entries, test_id) is None, (
        "A skip-list pattern matched the EndOfEarlyData server-rejection test — "
        "narrow or remove any *EarlyData* glob so a real passing test is not "
        "classified as unexpected_pass"
    )


def test_server_early_data_disabled_still_caught_by_skip_list():
    """After removing the broad *EarlyData* pattern, DISABLED tests from
    de.rub.nds.tlstest.suite.tests.server.tls13.rfc8446.EarlyData must still
    be caught as expected_skipped via the narrowed class-scoped pattern."""
    from scripts.anvil_report import matches_any_pattern

    skip_entries = json.loads(SKIP_LIST_PATH.read_text())["skip"]

    # Representative test: selectedFirstIdentity from the server EarlyData class.
    test_id = "de.rub.nds.tlstest.suite.tests.server.tls13.rfc8446.EarlyData.selectedFirstIdentity"
    test_name = (
        'If the server supplies an "early_data" extension, the client MUST '
        "verify that the server's selected_identity is 0."
    )
    disabled_reason = (
        "public void de.rub.nds.tlstest.suite.tests.server.tls13.rfc8446"
        ".EarlyData.selectedFirstIdentity("
        "de.rub.nds.anvilcore.teststate.AnvilTestCase,"
        "de.rub.nds.tlstest.framework.execution.WorkflowRunner) is @Disabled"
    )

    assert matches_any_pattern(test_name, skip_entries, test_id, disabled_reason) is not None, (
        "server.tls13.rfc8446.EarlyData DISABLED test was not caught — "
        "the narrowed EarlyData skip pattern may be missing or incorrect"
    )


def test_end_of_early_data_pass_is_clean_pass_in_pipeline(tmp_path):
    """End-to-end: sendEndOfEarlyDataAsServer STRICTLY_SUCCEEDED must yield
    exit 0 and counts.passed == 1, not an unexpected_pass entry."""
    fixture = tmp_path / "end-of-early-data.json"
    fixture.write_text(
        json.dumps(
            {
                "tests": [
                    {
                        "id": (
                            "de.rub.nds.tlstest.suite.tests.client.tls13.statemachine"
                            ".StateMachine.sendEndOfEarlyDataAsServer"
                        ),
                        "name": (
                            "Servers MUST NOT send this message, and clients receiving it MUST "
                            'terminate the connection with an "unexpected_message" alert.'
                        ),
                        "result": "STRICTLY_SUCCEEDED",
                        "feature": "StateMachine",
                    }
                ]
            }
        )
    )
    out = tmp_path / "out"
    out.mkdir()

    cp = run_report(str(fixture), "--output-dir", str(out), "--skip-list", str(SKIP_LIST_PATH))

    assert cp.returncode == 0, (
        f"Expected exit 0 for EndOfEarlyData STRICTLY_SUCCEEDED, got {cp.returncode}.\n"
        f"stderr={cp.stderr}"
    )
    s = load_summary_json(out)
    assert s["counts"]["passed"] == 1
    assert s["unexpected"] == []


def test_skip_pattern_falsification_caught():
    """Renaming a skip pattern should change classification, not silently
    absorb the difference."""
    # Simulate changing *HelloRetryRequest* -> *FooBar*
    altered = [{"pattern": "*FooBar*", "reason": "deferred (#1)"}]
    # This name should no longer match
    name = "TLS 1.3 HelloRetryRequest - HRR cookie exchange and retry"
    # Import the matcher directly
    from scripts.anvil_report import matches_any_pattern

    assert matches_any_pattern(name, altered) is None
    # But the original pattern should match
    original = [{"pattern": "*HelloRetryRequest*", "reason": "deferred (#1)"}]
    assert matches_any_pattern(name, original) == "*HelloRetryRequest*"


def test_skip_pattern_matches_disabled_reason_when_name_and_id_are_generic():
    from scripts.anvil_report import matches_any_pattern

    patterns = [
        {
            "pattern": "*ProtocolVersion of the test is not supported*",
            "reason": "protocol version out of scope",
        }
    ]
    assert (
        matches_any_pattern(
            "generic disabled test",
            patterns,
            "opaque-8446-abcd",
            "ProtocolVersion of the test is not supported by the target",
        )
        == "*ProtocolVersion of the test is not supported*"
    )


def test_skip_pattern_matches_stable_test_id_when_name_is_generic():
    from scripts.anvil_report import matches_any_pattern

    patterns = [{"pattern": "*HelloRetryRequest*", "reason": "deferred (#1)"}]
    assert (
        matches_any_pattern(
            "cookie exchange and retry",
            patterns,
            "server.tls13.rfc8446.HelloRetryRequest.cookieExchange",
        )
        == "*HelloRetryRequest*"
    )


# ─── parser invocation / CLI exit codes ─────────────────────────────────


def test_report_on_synthetic_fixture(tmp_path):
    """Full pipeline: parse fixture, emit summary, check exit code 1."""
    out = tmp_path / "out"
    out.mkdir()

    cp = run_report(
        str(FIXTURE_PATH),
        "--output-dir",
        str(out),
        "--skip-list",
        str(SKIP_LIST_PATH),
    )
    # The synthetic fixture intentionally has unexpected results → exit 1
    assert cp.returncode == 1, f"expected exit 1, got {cp.returncode}\nstderr={cp.stderr}"
    assert "unexpected result" in cp.stderr

    assert (out / "summary.json").is_file()
    assert (out / "summary.txt").is_file()


def test_summary_json_structure(tmp_path):
    out = tmp_path / "out"
    out.mkdir()
    run_report(
        str(FIXTURE_PATH),
        "--output-dir",
        str(out),
        "--skip-list",
        str(SKIP_LIST_PATH),
    )
    s = load_summary_json(out)

    assert "counts" in s
    assert "unexpected" in s
    assert "feature_breakdown" in s
    assert "unmatched_skip_patterns" in s
    assert "expected_skip_count_by_reason" in s
    assert "provenance" in s


def test_summary_json_counts_match_expected(tmp_path):
    out = tmp_path / "out"
    out.mkdir()
    run_report(
        str(FIXTURE_PATH),
        "--output-dir",
        str(out),
        "--skip-list",
        str(SKIP_LIST_PATH),
    )
    s = load_summary_json(out)
    for key, expected in EXPECTED_COUNTS.items():
        actual = s["counts"][key]
        assert actual == expected, f"counts.{key}: expected {expected}, got {actual}"


def test_committed_skip_list_reports_unmatched_patterns_for_synthetic_fixture(tmp_path):
    out = tmp_path / "out"
    out.mkdir()
    run_report(
        str(FIXTURE_PATH),
        "--output-dir",
        str(out),
        "--skip-list",
        str(SKIP_LIST_PATH),
    )
    s = load_summary_json(out)
    assert isinstance(s["unmatched_skip_patterns"], list)


def test_summary_json_unexpected_count_match_expected(tmp_path):
    out = tmp_path / "out"
    out.mkdir()
    run_report(
        str(FIXTURE_PATH),
        "--output-dir",
        str(out),
        "--skip-list",
        str(SKIP_LIST_PATH),
    )
    s = load_summary_json(out)
    classified: dict[str, int] = {}
    for item in s["unexpected"]:
        cls = item["classification"]
        classified[cls] = classified.get(cls, 0) + 1

    for cls, expected in EXPECTED_UNEXPECTED.items():
        actual = classified.get(cls, 0)
        assert actual == expected, f"unexpected.{cls}: expected {expected}, got {actual}"


def test_summary_json_feature_breakdown_size(tmp_path):
    out = tmp_path / "out"
    out.mkdir()
    run_report(
        str(FIXTURE_PATH),
        "--output-dir",
        str(out),
        "--skip-list",
        str(SKIP_LIST_PATH),
    )
    s = load_summary_json(out)
    assert len(s["feature_breakdown"]) == EXPECTED_FEATURES


def test_summary_json_unexpected_pass_has_rationale(tmp_path):
    fixture = tmp_path / "unexpected-pass.json"
    fixture.write_text(
        json.dumps(
            {
                "tests": [
                    {
                        "id": "clean-pass",
                        "name": "clean pass that still matches a stale skip",
                        "result": "STRICTLY_SUCCEEDED",
                        "feature": "Clean",
                    }
                ]
            }
        )
    )
    skip_list = tmp_path / "skip.json"
    skip_list.write_text(
        json.dumps({"skip": [{"pattern": "*stale skip*", "reason": "stale skip (#9)"}]})
    )
    out = tmp_path / "out"
    out.mkdir()

    cp = run_report(str(fixture), "--output-dir", str(out), "--skip-list", str(skip_list))

    assert cp.returncode == 1
    s = load_summary_json(out)
    ups = [item for item in s["unexpected"] if item["classification"] == "unexpected_pass"]
    assert len(ups) == 1
    assert "pattern" in ups[0]["rationale"]
    assert "review" in ups[0]["rationale"]


def test_skip_pattern_does_not_hide_failed_test(tmp_path):
    fixture = tmp_path / "failed-skipped-id.json"
    fixture.write_text(
        json.dumps(
            {
                "tests": [
                    {
                        "id": "server.tls13.rfc8446.HelloRetryRequest.sentHelloRetryRequest",
                        "name": "HelloRetryRequest should be sent",
                        "result": "FULLY_FAILED",
                        "feature": "HelloRetryRequest",
                        "failure_reason": "No Hello Retry Request received",
                    }
                ]
            }
        )
    )
    skip_list = tmp_path / "skip.json"
    skip_list.write_text(
        json.dumps(
            {
                "skip": [
                    {
                        "pattern": "*HelloRetryRequest*",
                        "reason": "HelloRetryRequest is deferred (#1)",
                    }
                ]
            }
        )
    )
    out = tmp_path / "out"
    out.mkdir()

    cp = run_report(str(fixture), "--output-dir", str(out), "--skip-list", str(skip_list))

    assert cp.returncode == 1
    s = load_summary_json(out)
    assert s["counts"]["expected_skipped"] == 0
    assert s["counts"]["failed"] == 1
    assert s["unexpected"][0]["classification"] == "unexpected_fail"


def test_summary_json_unexpected_fail_has_rationale(tmp_path):
    out = tmp_path / "out"
    out.mkdir()
    run_report(
        str(FIXTURE_PATH),
        "--output-dir",
        str(out),
        "--skip-list",
        str(SKIP_LIST_PATH),
    )
    s = load_summary_json(out)
    ufs = [item for item in s["unexpected"] if item["classification"] == "unexpected_fail"]
    assert len(ufs) >= 2
    for uf in ufs:
        assert "rationale" in uf
        assert "regression" in uf["rationale"].lower()


def test_summary_json_and_txt_carry_provenance(tmp_path):
    fixture = tmp_path / "with-provenance.json"
    fixture.write_text(
        json.dumps(
            {
                "provenance": {
                    "source_run_dir": "zig-out/anvil/server/example",
                    "adapter_allow_partial": False,
                    "git": {"revision": "abc1234", "dirty": False},
                    "tls_anvil": {
                        "report": {
                            "complete": True,
                            "finished_tests": 1,
                            "total_tests": 1,
                        }
                    },
                },
                "tests": [
                    {
                        "id": "clean-1",
                        "name": "clean pass",
                        "result": "STRICTLY_SUCCEEDED",
                        "feature": "Clean",
                    }
                ],
            }
        )
    )
    skip_list = tmp_path / "skip.json"
    skip_list.write_text(json.dumps({"skip": []}))
    out = tmp_path / "out"
    out.mkdir()

    cp = run_report(str(fixture), "--output-dir", str(out), "--skip-list", str(skip_list))

    assert cp.returncode == 0, cp.stderr
    s = load_summary_json(out)
    assert s["provenance"]["git"]["revision"] == "abc1234"
    txt = load_summary_txt(out)
    assert "Provenance:" in txt
    assert "git_revision         : abc1234" in txt
    assert "adapter_allow_partial: False" in txt
    assert "report_finished      : 1/1" in txt


def test_report_rejects_allow_partial_provenance(tmp_path):
    fixture = tmp_path / "partial.json"
    fixture.write_text(
        json.dumps(
            {
                "provenance": {
                    "adapter_allow_partial": True,
                    "tls_anvil": {
                        "report": {"complete": True, "finished_tests": 1, "total_tests": 1}
                    },
                },
                "tests": [
                    {
                        "id": "clean-1",
                        "name": "clean pass",
                        "result": "STRICTLY_SUCCEEDED",
                        "feature": "Clean",
                    }
                ],
            }
        )
    )
    skip_list = tmp_path / "skip.json"
    skip_list.write_text(json.dumps({"skip": []}))
    out = tmp_path / "out"
    out.mkdir()

    cp = run_report(str(fixture), "--output-dir", str(out), "--skip-list", str(skip_list))

    assert cp.returncode == 1
    s = load_summary_json(out)
    assert s["unexpected"] == []
    assert "partial TLS-Anvil captures" in s["evidence_blockers"][0]
    assert "evidence blocker" in cp.stderr
    assert "Evidence blockers:" in load_summary_txt(out)


def test_report_rejects_incomplete_tls_anvil_provenance(tmp_path):
    fixture = tmp_path / "incomplete.json"
    fixture.write_text(
        json.dumps(
            {
                "provenance": {
                    "adapter_allow_partial": False,
                    "tls_anvil": {
                        "report": {"complete": False, "finished_tests": 7, "total_tests": 9}
                    },
                },
                "tests": [
                    {
                        "id": "clean-1",
                        "name": "clean pass",
                        "result": "STRICTLY_SUCCEEDED",
                        "feature": "Clean",
                    }
                ],
            }
        )
    )
    skip_list = tmp_path / "skip.json"
    skip_list.write_text(json.dumps({"skip": []}))
    out = tmp_path / "out"
    out.mkdir()

    cp = run_report(str(fixture), "--output-dir", str(out), "--skip-list", str(skip_list))

    assert cp.returncode == 1
    s = load_summary_json(out)
    assert s["unexpected"] == []
    assert "incomplete (7/9)" in s["evidence_blockers"][0]
    assert "evidence blocker" in cp.stderr


def test_summary_txt_contains_counts(tmp_path):
    out = tmp_path / "out"
    out.mkdir()
    run_report(
        str(FIXTURE_PATH),
        "--output-dir",
        str(out),
        "--skip-list",
        str(SKIP_LIST_PATH),
    )
    txt = load_summary_txt(out)
    assert "total" in txt
    assert "expected_skipped" in txt
    assert "unexpected_skipped" in txt
    assert "passed" in txt
    assert "failed" in txt
    assert "errored" in txt
    assert "timeout" in txt
    assert "not_attempted" in txt
    assert "Pass rate (attempted)" in txt


def test_summary_txt_contains_per_feature(tmp_path):
    out = tmp_path / "out"
    out.mkdir()
    run_report(
        str(FIXTURE_PATH),
        "--output-dir",
        str(out),
        "--skip-list",
        str(SKIP_LIST_PATH),
    )
    txt = load_summary_txt(out)
    assert "Per-feature breakdown" in txt


def test_unmatched_skip_patterns_reported(tmp_path):
    """A skip-list with a pattern that matches nothing should appear in
    unmatched_skip_patterns."""
    out = tmp_path / "out"
    out.mkdir()

    custom_skip = tmp_path / "custom_skip.json"
    custom_skip.write_text(
        json.dumps(
            {
                "comment": "test",
                "skip": [
                    {"pattern": "*ThisPatternMatchesNothingXYZ*", "reason": "test"},
                    {"pattern": "*Alert*", "reason": "alerts"},
                ],
            }
        )
    )

    run_report(
        str(FIXTURE_PATH),
        "--output-dir",
        str(out),
        "--skip-list",
        str(custom_skip),
    )
    s = load_summary_json(out)
    unmatched = s["unmatched_skip_patterns"]
    assert "*ThisPatternMatchesNothingXYZ*" in unmatched
    assert "*Alert*" not in unmatched  # matches Alert tests


def test_failed_test_with_matching_disabled_reason_still_fails(tmp_path):
    fixture = tmp_path / "failed-with-disabled-reason.json"
    failure_reason = "server returned handshake_failure"
    fixture.write_text(
        json.dumps(
            {
                "tests": [
                    {
                        "id": "opaque-failed-test",
                        "name": "generic failed test",
                        "result": "FULLY_FAILED",
                        "feature": "Generic",
                        "disabled_reason": "ProtocolVersion of the test is not supported by the target",
                        "failure_reason": failure_reason,
                    }
                ]
            }
        )
    )
    skip_list = tmp_path / "skip.json"
    skip_list.write_text(
        json.dumps(
            {
                "skip": [
                    {
                        "pattern": "*ProtocolVersion of the test is not supported*",
                        "reason": "protocol version out of scope",
                    }
                ]
            }
        )
    )
    out = tmp_path / "out"
    out.mkdir()

    cp = run_report(str(fixture), "--output-dir", str(out), "--skip-list", str(skip_list))

    assert cp.returncode == 1
    s = load_summary_json(out)
    assert s["counts"]["failed"] == 1
    assert s["counts"]["expected_skipped"] == 0
    unexpected = s["unexpected"]
    assert unexpected[0]["classification"] == "unexpected_fail"
    assert unexpected[0]["failure_reason"] == failure_reason
    assert failure_reason in unexpected[0]["rationale"]
    assert failure_reason in load_summary_txt(out)


def test_endpoint_mode_disabled_is_not_attempted(tmp_path):
    fixture = tmp_path / "endpoint-mode.json"
    fixture.write_text(
        json.dumps(
            {
                "tests": [
                    {
                        "id": "de.rub.nds.tlstest.suite.tests.client.tls13.rfc8446.ClientHello.checkLegacySessionId",
                        "name": "client-direction test",
                        "result": "DISABLED",
                        "feature": "ClientHello",
                        "disabled_reason": "TestEndpointMode doesn't match",
                    }
                ]
            }
        )
    )
    skip_list = tmp_path / "skip.json"
    skip_list.write_text(
        json.dumps(
            {
                "skip": [
                    {"pattern": "*ClientHello*", "reason": "would be a feature skip if attempted"}
                ]
            }
        )
    )
    out = tmp_path / "out"
    out.mkdir()

    cp = run_report(str(fixture), "--output-dir", str(out), "--skip-list", str(skip_list))

    assert cp.returncode == 0, cp.stderr
    s = load_summary_json(out)
    assert s["counts"]["not_attempted"] == 1
    assert s["counts"]["expected_skipped"] == 0
    assert s["counts"]["unexpected_skipped"] == 0
    assert s["feature_breakdown"] == {"ClientHello": {"not_attempted": 1}}
    assert s["unexpected"] == []


def test_disabled_reason_skip_pattern_counts_as_expected_skip(tmp_path):
    fixture = tmp_path / "reason-skip.json"
    fixture.write_text(
        json.dumps(
            {
                "tests": [
                    {
                        "id": "opaque-disabled-test",
                        "name": "generic disabled test",
                        "result": "DISABLED",
                        "feature": "Generic",
                        "disabled_reason": "ProtocolVersion of the test is not supported by the target",
                    }
                ]
            }
        )
    )
    skip_list = tmp_path / "skip.json"
    reason = "protocol version out of scope"
    skip_list.write_text(
        json.dumps(
            {
                "skip": [
                    {
                        "pattern": "*ProtocolVersion of the test is not supported*",
                        "reason": reason,
                    }
                ]
            }
        )
    )
    out = tmp_path / "out"
    out.mkdir()

    cp = run_report(str(fixture), "--output-dir", str(out), "--skip-list", str(skip_list))

    assert cp.returncode == 0, cp.stderr
    s = load_summary_json(out)
    assert s["counts"]["expected_skipped"] == 1
    assert s["expected_skip_count_by_reason"] == {reason: 1}


def test_unexpected_skipped_has_rationale(tmp_path):
    out = tmp_path / "out"
    out.mkdir()
    run_report(
        str(FIXTURE_PATH),
        "--output-dir",
        str(out),
        "--skip-list",
        str(SKIP_LIST_PATH),
    )
    s = load_summary_json(out)
    uss = [item for item in s["unexpected"] if item["classification"] == "unexpected_skipped"]
    assert len(uss) >= 1
    for us in uss:
        assert "rationale" in us
        assert "no skip-list pattern" in us["rationale"].lower()


def test_all_passing_report_exits_zero(tmp_path):
    """A fixture where every non-matching test passes and matching tests
    are all non-pass should produce exit 0."""
    all_clean = tmp_path / "clean.json"
    all_clean.write_text(
        json.dumps(
            {
                "tests": [
                    {
                        "id": "clean-1",
                        "name": "TLS 1.3 CleanTest - sample pass",
                        "result": "STRICTLY_SUCCEEDED",
                        "feature": "Clean",
                    },
                    {
                        "id": "clean-2",
                        "name": "TLS 1.3 DeferredSkipped - known deferred",
                        "result": "DISABLED",
                        "feature": "Deferred",
                    },
                ],
            }
        )
    )
    custom_skip = tmp_path / "clean_skip.json"
    custom_skip.write_text(
        json.dumps(
            {
                "comment": "test",
                "skip": [
                    {"pattern": "*DeferredSkipped*", "reason": "deferred (#99)"},
                ],
            }
        )
    )

    out = tmp_path / "out"
    out.mkdir()
    cp = run_report(
        str(all_clean),
        "--output-dir",
        str(out),
        "--skip-list",
        str(custom_skip),
    )
    assert cp.returncode == 0, f"expected clean exit 0, got {cp.returncode}\nstderr={cp.stderr}"
    assert "clean" in cp.stderr.lower()


def test_parser_rejects_missing_input(tmp_path):
    cp = run_report(str(tmp_path / "nonexistent.json"))
    assert cp.returncode == 2


def test_parser_rejects_missing_skip_list(tmp_path):
    cp = run_report(
        str(FIXTURE_PATH),
        "--skip-list",
        str(tmp_path / "nonexistent.json"),
    )
    assert cp.returncode == 2
