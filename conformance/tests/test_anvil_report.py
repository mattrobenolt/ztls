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
    "expected_skipped": 11,
    "unexpected_skipped": 1,
    "passed": 7,
    "failed": 2,
    "errored": 0,
    "timeout": 0,
}

EXPECTED_UNEXPECTED = {
    "unexpected_pass": 2,
    "unexpected_fail": 2,
    "unexpected_skipped": 1,
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


def test_pattern_hello_retry_request_matches():
    """*HelloRetryRequest* glob matches the synthetic HRR test name."""
    assert fnmatch.fnmatch(
        "TLS 1.3 HelloRetryRequest - HRR cookie exchange and retry",
        "*HelloRetryRequest*",
    )


def test_pattern_psk_matches_mixed_case_psk():
    """Psk in the test name matches the case-sensitive *Psk* glob."""
    assert fnmatch.fnmatch("TLS 1.3 Psk - external Psk handshake", "*Psk*")


def test_pattern_psk_matches_psk_derivation():
    """*Psk* glob matches 'PskDerivation' since * consumes prefix/suffix."""
    assert fnmatch.fnmatch("TLS 1.3 PskDerivation - PSK binder computation", "*Psk*")


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


def test_committed_skip_list_matches_synthetic_fixture(tmp_path):
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
    assert s["unmatched_skip_patterns"] == []


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
    ups = [item for item in s["unexpected"] if item["classification"] == "unexpected_pass"]
    assert len(ups) >= 2
    for up in ups:
        assert "rationale" in up
        assert "#" in up["rationale"] or "review" in up["rationale"].lower()


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
