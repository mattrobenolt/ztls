#!/usr/bin/env python3
"""Parse TLS-Anvil-like test results, apply skip-list rules, and emit a
normalized summary.

Input: a results JSON file (see test_fixtures/anvil_report_synthetic.json for
the expected schema). This is the normalizer input schema, not a claim about
TLS-Anvil's raw upstream schema. When real TLS-Anvil output arrives, add a
format adapter that converts it into this shape.

Output (written next to the input or to --output-dir):
  summary.json  – machine-readable summary
  summary.txt   – human-readable one-page report

Classification rules (applied in order):
  1. Test name matches a skip-list glob pattern → expected_skipped.
     If the test also passed (STRICTLY_SUCCEEDED / CONCEPTUALLY_SUCCEEDED),
     it is additionally flagged as unexpected_pass.
  2. Test name matches no skip pattern:
     a. DISABLED → unexpected_skipped
     b. STRICTLY_SUCCEEDED / CONCEPTUALLY_SUCCEEDED → passed
     c. FULLY_FAILED / PARTIALLY_FAILED → failed (also unexpected_fail)
     d. TEST_SUITE_ERROR / NOT_SPECIFIED → errored

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


def load_skip_list(path: Path) -> list[dict[str, str]]:
    raw = json.loads(path.read_text())
    entries: list[dict[str, str]] = []
    for entry in raw["skip"]:
        entries.append({"pattern": entry["pattern"], "reason": entry["reason"]})
    return entries


def load_results(path: Path) -> list[dict[str, str]]:
    raw = json.loads(path.read_text())
    return list(raw["tests"])


def matches_any_pattern(
    name: str,
    patterns: list[dict[str, str]],
    test_id: str = "",
) -> str | None:
    """Return the first matching pattern string, or None.

    Matching is case-sensitive fnmatch globbing (shell-style) against both the
    display name and stable test id. Real TLS-Anvil output often carries the
    useful feature name in the Java class id rather than the human description.
    """
    for entry in patterns:
        pat = entry["pattern"]
        if fnmatch.fnmatch(name, pat) or (test_id and fnmatch.fnmatch(test_id, pat)):
            return pat
    return None


def classify_tests(
    tests: list[dict[str, str]],
    skip_entries: list[dict[str, str]],
) -> dict[str, Any]:
    counts: dict[str, int] = {
        "total": 0,
        "expected_skipped": 0,
        "unexpected_skipped": 0,
        "passed": 0,
        "failed": 0,
        "errored": 0,
        "timeout": 0,
    }
    unexpected: list[dict[str, str]] = []
    by_feature: dict[str, dict[str, int]] = {}
    matched_patterns: set[str] = set()
    reason_by_pattern = {entry["pattern"]: entry["reason"] for entry in skip_entries}

    for test in tests:
        name = test["name"]
        test_id = test.get("id", "")
        result = test["result"]
        feature = test.get("feature", "unknown")

        counts["total"] += 1

        # Detect timeout
        if result == "TIMEOUT":
            counts["timeout"] += 1
            by_feature.setdefault(feature, dict[str, int]()).setdefault("timeout", 0)
            by_feature[feature]["timeout"] += 1
            continue

        pattern = matches_any_pattern(name, skip_entries, test_id)

        if pattern is not None:
            matched_patterns.add(pattern)
            counts["expected_skipped"] += 1
            by_feature.setdefault(feature, dict[str, int]()).setdefault("expected_skipped", 0)
            by_feature[feature]["expected_skipped"] += 1

            if result in PASS_RESULTS:
                reason = reason_by_pattern[pattern]
                unexpected.append(
                    {
                        "id": test_id,
                        "test": name,
                        "result": result,
                        "classification": "unexpected_pass",
                        "rationale": (
                            f"pattern '{pattern}' matched but test {result} — review ({reason})"
                        ),
                    }
                )
        else:
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
                        "rationale": (
                            f"test {result} but no skip-list pattern matched — regression candidate"
                        ),
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
    }


def write_summary_json(summary: dict[str, Any], path: Path) -> None:
    path.write_text(json.dumps(summary, indent=2) + "\n")


def write_summary_txt(summary: dict[str, Any], path: Path) -> None:
    c = summary["counts"]
    lines: list[str] = [
        "TLS-Anvil Conformance Summary",
        f"Generated: {datetime.now(UTC).isoformat()}",
        "",
        "Counts:",
        f"  total              : {c['total']:>6}",
        f"  expected_skipped   : {c['expected_skipped']:>6}",
        f"  unexpected_skipped : {c['unexpected_skipped']:>6}",
        f"  passed             : {c['passed']:>6}",
        f"  failed             : {c['failed']:>6}",
        f"  errored            : {c['errored']:>6}",
        f"  timeout            : {c['timeout']:>6}",
        "",
    ]

    if c["total"] > 0:
        pass_rate = (c["passed"] / c["total"]) * 100
        lines.append(f"Pass rate: {c['passed']}/{c['total']} = {pass_rate:.1f}%")
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
            "were expected-skipped by the configured skip list. Review "
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
    tests = load_results(args.results_json)
    summary = classify_tests(tests, skip_entries)

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
