#!/usr/bin/env python3
"""Parse TLS-Anvil-like test results, apply skip-list rules, and emit a
normalized summary.

Input: a results JSON file (see test_fixtures/anvil_report_synthetic.json for
the expected schema). This is the normalizer input schema, not a claim about
TLS-Anvil's raw upstream schema. Raw TLS-Anvil output must first pass through
anvil_adapter.py.

Output (written next to the input or to --output-dir):
  summary.json  – machine-readable summary
  summary.txt   – human-readable one-page report

Classification rules (applied in order):
  1. Test name/id/disabled_reason matches a skip-list glob pattern → expected_skipped.
     If the test also passed (STRICTLY_SUCCEEDED / CONCEPTUALLY_SUCCEEDED),
     it is additionally flagged as unexpected_pass.
  2. Test name/id/disabled_reason matches no skip pattern:
     a. DISABLED with TLS-Anvil's server/client endpoint-mode reason → not_attempted
     b. DISABLED → unexpected_skipped
     c. STRICTLY_SUCCEEDED / CONCEPTUALLY_SUCCEEDED → passed
     d. FULLY_FAILED / PARTIALLY_FAILED → failed (also unexpected_fail)
     e. TEST_SUITE_ERROR / NOT_SPECIFIED → errored

Exit code 0 = clean evidence (no unexpected results).
Exit code 1 = at least one unexpected_pass, unexpected_fail, or
             unexpected_skipped.
"""

import argparse
import fnmatch
import json
import sys
from datetime import UTC, datetime
from pathlib import Path
from typing import Any

CONF_DIR = Path(__file__).resolve().parents[1]
SKIP_LIST_PATH = CONF_DIR / "anvil-skip-list.json"

PASS_RESULTS = frozenset({"STRICTLY_SUCCEEDED", "CONCEPTUALLY_SUCCEEDED"})
FAIL_RESULTS = frozenset({"FULLY_FAILED", "PARTIALLY_FAILED"})
ERROR_RESULTS = frozenset({"TEST_SUITE_ERROR", "NOT_SPECIFIED"})
SKIP_RESULTS = frozenset({"DISABLED"})
ENDPOINT_MODE_MISMATCH_REASON = "TestEndpointMode doesn't match"


def load_skip_list(path: Path) -> list[dict[str, str]]:
    raw = json.loads(path.read_text())
    entries: list[dict[str, str]] = []
    for entry in raw["skip"]:
        entries.append({"pattern": entry["pattern"], "reason": entry["reason"]})
    return entries


def load_results(path: Path) -> tuple[list[dict[str, str]], dict[str, Any]]:
    raw = json.loads(path.read_text())
    provenance = raw.get("provenance", {})
    if not isinstance(provenance, dict):
        provenance = {}
    return list(raw["tests"]), provenance


def matches_any_pattern(
    name: str,
    patterns: list[dict[str, str]],
    test_id: str = "",
    disabled_reason: str = "",
) -> str | None:
    """Return the first matching pattern string, or None.

    Matching is case-sensitive fnmatch globbing (shell-style) against the
    display name, stable test id, and TLS-Anvil disabled reason. Real TLS-Anvil
    output often carries the useful feature name in the Java class id rather
    than the human description. Reason matching is for explicit tool-state
    policies only; do not use it to hide feature-capability gaps.
    """
    for entry in patterns:
        pat = entry["pattern"]
        if (
            fnmatch.fnmatch(name, pat)
            or (test_id and fnmatch.fnmatch(test_id, pat))
            or (disabled_reason and fnmatch.fnmatch(disabled_reason, pat))
        ):
            return pat
    return None


def classify_tests(
    tests: list[dict[str, str]],
    skip_entries: list[dict[str, str]],
    provenance: dict[str, Any] | None = None,
) -> dict[str, Any]:
    counts: dict[str, int] = {
        "total": 0,
        "expected_skipped": 0,
        "unexpected_skipped": 0,
        "passed": 0,
        "failed": 0,
        "errored": 0,
        "timeout": 0,
        "not_attempted": 0,
    }
    unexpected: list[dict[str, str]] = []
    by_feature: dict[str, dict[str, int]] = {}
    matched_patterns: set[str] = set()
    reason_by_pattern = {entry["pattern"]: entry["reason"] for entry in skip_entries}
    expected_skip_count_by_reason: dict[str, int] = {}

    for test in tests:
        name = test["name"]
        test_id = test.get("id", "")
        result = test["result"]
        feature = test.get("feature", "unknown")
        disabled_reason = test.get("disabled_reason", "")
        failure_reason = test.get("failure_reason", "")

        counts["total"] += 1

        # Detect timeout
        if result == "TIMEOUT":
            counts["timeout"] += 1
            by_feature.setdefault(feature, dict[str, int]()).setdefault("timeout", 0)
            by_feature[feature]["timeout"] += 1
            continue

        if result in SKIP_RESULTS and disabled_reason == ENDPOINT_MODE_MISMATCH_REASON:
            counts["not_attempted"] += 1
            by_feature.setdefault(feature, dict[str, int]()).setdefault("not_attempted", 0)
            by_feature[feature]["not_attempted"] += 1
            continue

        match_reason = disabled_reason if result in SKIP_RESULTS else ""
        pattern = matches_any_pattern(name, skip_entries, test_id, match_reason)

        if result in SKIP_RESULTS and pattern is not None:
            matched_patterns.add(pattern)
            counts["expected_skipped"] += 1
            reason = reason_by_pattern[pattern]
            expected_skip_count_by_reason[reason] = expected_skip_count_by_reason.get(reason, 0) + 1
            by_feature.setdefault(feature, dict[str, int]()).setdefault("expected_skipped", 0)
            by_feature[feature]["expected_skipped"] += 1
            continue

        if result in PASS_RESULTS and pattern is not None:
            matched_patterns.add(pattern)
            reason = reason_by_pattern[pattern]
            unexpected.append(
                {
                    "id": test_id,
                    "test": name,
                    "result": result,
                    "classification": "unexpected_pass",
                    "rationale": f"pattern '{pattern}' matched but test {result} — review ({reason})",
                }
            )

        if result in SKIP_RESULTS:
            counts["unexpected_skipped"] += 1
            by_feature.setdefault(feature, dict[str, int]()).setdefault("unexpected_skipped", 0)
            by_feature[feature]["unexpected_skipped"] += 1
            unexpected.append(
                {
                    "id": test_id,
                    "test": name,
                    "result": result,
                    "classification": "unexpected_skipped",
                    "rationale": f"test was {result} but no skip-list pattern matched",
                }
            )
        elif result in PASS_RESULTS:
            counts["passed"] += 1
            by_feature.setdefault(feature, dict[str, int]()).setdefault("passed", 0)
            by_feature[feature]["passed"] += 1
        elif result in FAIL_RESULTS:
            counts["failed"] += 1
            by_feature.setdefault(feature, dict[str, int]()).setdefault("failed", 0)
            by_feature[feature]["failed"] += 1
            unexpected.append(
                {
                    "id": test_id,
                    "test": name,
                    "result": result,
                    "classification": "unexpected_fail",
                    "failure_reason": failure_reason,
                    "rationale": failure_rationale(result, failure_reason),
                }
            )
        else:
            counts["errored"] += 1
            by_feature.setdefault(feature, dict[str, int]()).setdefault("errored", 0)
            by_feature[feature]["errored"] += 1

    all_patterns = {e["pattern"] for e in skip_entries}
    unmatched_patterns = sorted(all_patterns - matched_patterns)

    return {
        "counts": counts,
        "unexpected": unexpected,
        "feature_breakdown": by_feature,
        "unmatched_skip_patterns": unmatched_patterns,
        "expected_skip_count_by_reason": expected_skip_count_by_reason,
        "provenance": provenance or {},
    }


def failure_rationale(result: str, failure_reason: str) -> str:
    rationale = f"test {result} but no skip-list pattern matched — regression candidate"
    if failure_reason:
        return f"{rationale}: {failure_reason}"
    return rationale


def write_summary_json(summary: dict[str, Any], path: Path) -> None:
    path.write_text(json.dumps(summary, indent=2) + "\n")


def write_summary_txt(summary: dict[str, Any], path: Path) -> None:
    c = summary["counts"]
    lines: list[str] = [
        "TLS-Anvil Conformance Summary",
        f"Generated: {datetime.now(UTC).isoformat()}",
        "",
    ]

    provenance = summary.get("provenance") or {}
    if provenance:
        git = provenance.get("git") or {}
        tls_anvil = provenance.get("tls_anvil") or {}
        report = tls_anvil.get("report") or {}
        lines.extend(
            [
                "Provenance:",
                f"  source_run_dir       : {provenance.get('source_run_dir', 'unknown')}",
                f"  git_revision         : {git.get('revision', 'unknown')}",
                f"  git_dirty            : {git.get('dirty', 'unknown')}",
                f"  adapter_allow_partial: {provenance.get('adapter_allow_partial', 'unknown')}",
                f"  report_complete      : {report.get('complete', 'unknown')}",
                f"  report_finished      : {report.get('finished_tests', 'unknown')}/{report.get('total_tests', 'unknown')}",
                "",
            ]
        )

    lines.extend(
        [
            "Counts:",
            f"  total              : {c['total']:>6}",
            f"  expected_skipped   : {c['expected_skipped']:>6}",
            f"  unexpected_skipped : {c['unexpected_skipped']:>6}",
            f"  passed             : {c['passed']:>6}",
            f"  failed             : {c['failed']:>6}",
            f"  errored            : {c['errored']:>6}",
            f"  timeout            : {c['timeout']:>6}",
            f"  not_attempted      : {c['not_attempted']:>6}",
            "",
        ]
    )

    if c["total"] > 0:
        pass_rate = (c["passed"] / c["total"]) * 100
        attempted = c["passed"] + c["failed"] + c["errored"] + c["timeout"]
        lines.append(f"Pass rate (total): {c['passed']}/{c['total']} = {pass_rate:.1f}%")
        if attempted > 0:
            attempted_rate = (c["passed"] / attempted) * 100
            lines.append(
                f"Pass rate (attempted): {c['passed']}/{attempted} = {attempted_rate:.1f}%"
            )
        else:
            lines.append("Pass rate (attempted): n/a")
        lines.append("")

    if summary.get("expected_skip_count_by_reason"):
        lines.append("Expected skip count by reason:")
        for reason, count in sorted(summary["expected_skip_count_by_reason"].items()):
            lines.append(f"  - {count:>4} {reason}")
        lines.append("")

    if summary["unmatched_skip_patterns"]:
        lines.append("Unmatched skip-list patterns (no test matched):")
        for pat in summary["unmatched_skip_patterns"]:
            lines.append(f"  - {pat}")
        lines.append("")

    unexpected = summary["unexpected"]
    if unexpected:
        lines.append(f"Unexpected results ({len(unexpected)}):")
        for item in unexpected:
            lines.append(f"  [{item['classification']}] {item['test']}")
            lines.append(f"    {item['rationale']}")
            if item.get("failure_reason"):
                lines.append(f"    failure_reason: {item['failure_reason']}")
        lines.append("")

    feature = summary["feature_breakdown"]
    if feature:
        lines.append("Per-feature breakdown:")
        for feat in sorted(feature):
            cats = feature[feat]
            parts = [f"{k}={v}" for k, v in sorted(cats.items()) if v > 0]
            lines.append(f"  {feat}: {', '.join(parts)}")
        lines.append("")

    if c["total"] > 0:
        skipped_pct = (c["expected_skipped"] / c["total"]) * 100
        lines.append(
            f"Note: {c['expected_skipped']}/{c['total']} tests ({skipped_pct:.1f}%) "
            "were expected-skipped by the configured skip list. not_attempted "
            "tests are runner-direction gaps, not conformance passes. Review "
            "unexpected_pass entries as license-to-claim signals and "
            "unmatched_skip_patterns as stale-skip candidates."
        )

    path.write_text("\n".join(lines) + "\n")


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Normalize TLS-Anvil-like test results against skip-list rules."
    )
    parser.add_argument(
        "results_json",
        type=Path,
        help="Path to TLS-Anvil-like results JSON (array of test results).",
    )
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=None,
        help="Directory for summary.json and summary.txt (default: next to results_json).",
    )
    parser.add_argument(
        "--skip-list",
        type=Path,
        default=SKIP_LIST_PATH,
        help="Path to skip-list JSON (default: conformance/anvil-skip-list.json).",
    )
    args = parser.parse_args()

    if not args.results_json.is_file():
        print(f"error: results file not found: {args.results_json}", file=sys.stderr)
        return 2

    if not args.skip_list.is_file():
        print(f"error: skip-list file not found: {args.skip_list}", file=sys.stderr)
        return 2

    skip_entries = load_skip_list(args.skip_list)
    tests, provenance = load_results(args.results_json)
    summary = classify_tests(tests, skip_entries, provenance)

    output_dir = args.output_dir or args.results_json.parent
    output_dir.mkdir(parents=True, exist_ok=True)

    txt_path = output_dir / "summary.txt"
    json_path = output_dir / "summary.json"

    write_summary_json(summary, json_path)
    write_summary_txt(summary, txt_path)

    print(txt_path.read_text())

    unexpected = summary["unexpected"]
    if unexpected:
        n = len(unexpected)
        print(f"Anvil report: {n} unexpected result(s) — see summary for details.", file=sys.stderr)
        return 1

    print("Anvil report: clean — no unexpected results.", file=sys.stderr)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
