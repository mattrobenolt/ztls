#!/usr/bin/env python3
"""Convert a TLS-Anvil output directory into the normalized report schema.

The normalized schema is the input consumed by `anvil_report.py`:

    {"tests": [{"id": str, "name": str, "result": str, "feature": str,
                "disabled_reason": str?, "failure_reason": str?,
                "case_result_counts": {str: int}?}]}

TLS-Anvil output is not perfectly stable across versions. The shapes below are
exercised by synthetic tests and are predictions of the real TLS-Anvil layout,
not a claim that every upstream version has been observed locally:

- a root `report.json` already containing `tests`;
- a `report.zip` containing such a `report.json` or per-test JSON files;
- a directory tree of per-test JSON files with TLS-Anvil-style `Result` and
  optional `MetaData` fields.

Real captured-output validation remains #9 follow-up work.
"""

import argparse
import json
import platform
import re
import subprocess
import sys
import tempfile
import zipfile
from datetime import UTC, datetime
from pathlib import Path
from typing import Any

CONF_DIR = Path(__file__).resolve().parents[1]
REPO_ROOT = CONF_DIR.parent

CANONICAL_RESULTS = frozenset(
    {
        "STRICTLY_SUCCEEDED",
        "CONCEPTUALLY_SUCCEEDED",
        "FULLY_FAILED",
        "PARTIALLY_FAILED",
        "DISABLED",
        "TEST_SUITE_ERROR",
        "NOT_SPECIFIED",
        "TIMEOUT",
    }
)
GENERATED_NAMES = frozenset(
    {"summary.json", "report.normalized.json", "report.normalized.audit.json"}
)


def load_json(path: Path) -> Any:
    return json.loads(path.read_text())


def command_output(args: list[str], cwd: Path) -> str | None:
    try:
        cp = subprocess.run(args, cwd=cwd, capture_output=True, text=True, check=True)
    except OSError, subprocess.CalledProcessError:
        return None
    return cp.stdout.strip()


def git_provenance() -> dict[str, Any]:
    revision = command_output(["git", "rev-parse", "--short", "HEAD"], REPO_ROOT)
    status = command_output(["git", "status", "--porcelain"], REPO_ROOT)
    return {
        "revision": revision or "unknown",
        "dirty": bool(status),
    }


def optional_string(raw: dict[str, Any], *keys: str) -> str | None:
    for key in keys:
        value = raw.get(key)
        if value is not None:
            return str(value)
    return None


def normalized_from_tests(raw: Any) -> list[dict[str, Any]] | None:
    if not isinstance(raw, dict) or not isinstance(raw.get("tests"), list):
        return None
    tests: list[dict[str, Any]] = []
    for idx, test in enumerate(raw["tests"]):
        if not isinstance(test, dict):
            continue
        test_id = str(test.get("id") or test.get("name") or f"test-{idx}")
        name = str(test.get("name") or test_id)
        result = canonical_result(test.get("result"))
        feature = str(test.get("feature") or extract_feature(test_id, name))
        normalized: dict[str, Any] = {
            "id": test_id,
            "name": name,
            "result": result,
            "feature": feature,
        }
        disabled_reason = optional_string(
            test, "disabled_reason", "disabledReason", "DisabledReason"
        )
        if disabled_reason is not None:
            normalized["disabled_reason"] = disabled_reason
        failure_reason = optional_string(test, "FailedReason", "failureReason", "failure_reason")
        if failure_reason is not None:
            normalized["failure_reason"] = failure_reason
        case_counts = test_case_result_counts(test)
        if case_counts:
            normalized["case_result_counts"] = case_counts
        tests.append(normalized)
    return tests


def canonical_result(value: Any) -> str:
    result = str(value or "NOT_SPECIFIED")
    if result in CANONICAL_RESULTS:
        return result
    return "NOT_SPECIFIED"


def metadata_description(raw: dict[str, Any]) -> str | None:
    meta = raw.get("MetaData") or raw.get("metadata")
    if isinstance(meta, dict):
        desc = meta.get("description") or meta.get("Description")
        if desc:
            return str(desc)
    return None


def class_method_id(raw: dict[str, Any], fallback: str) -> str:
    cls = raw.get("className") or raw.get("ClassName") or raw.get("TestClass")
    method = raw.get("methodName") or raw.get("MethodName") or raw.get("TestMethod")
    if cls and method:
        return f"{cls}.{method}"
    if cls:
        return str(cls)

    for key in ("id", "Id", "testId", "TestId", "name", "Name"):
        if raw.get(key):
            return str(raw[key])
    return fallback


def extract_feature(test_id: str, name: str = "") -> str:
    for source in (test_id, name):
        parts = re.split(r"[./$#\s:-]+", source)
        for idx, part in enumerate(parts):
            if re.fullmatch(r"rfc\d+", part, flags=re.IGNORECASE) and idx + 1 < len(parts):
                return parts[idx + 1] or "unknown"
        for part in parts:
            if part in {
                "HelloRetryRequest",
                "ServerHello",
                "EncryptedExtensions",
                "Certificate",
                "CertificateVerify",
                "Finished",
                "KeyUpdate",
                "NewSessionTicket",
                "Psk",
                "EarlyData",
                "RecordSizeLimit",
                "MaxFragmentLength",
                "DTLS",
                "Tls12",
            }:
                return part
    return "unknown"


def normalize_case_counts(value: Any) -> dict[str, int]:
    if not isinstance(value, dict):
        return {}
    counts: dict[str, int] = {}
    for key, count in value.items():
        if isinstance(key, str) and isinstance(count, int) and count > 0:
            counts[key] = count
    return counts


def test_case_result_counts(raw: dict[str, Any]) -> dict[str, int]:
    counts = normalize_case_counts(raw.get("case_result_counts"))
    if counts:
        return counts
    cases = raw.get("TestCases") or raw.get("testCases") or raw.get("test_cases")
    if not isinstance(cases, list):
        return {}
    for case in cases:
        if not isinstance(case, dict):
            continue
        result = canonical_result(case.get("Result", case.get("result")))
        counts[result] = counts.get(result, 0) + 1
    return counts


def normalized_from_per_test(path: Path, raw: Any) -> dict[str, Any] | None:
    if not isinstance(raw, dict):
        return None
    if "Result" not in raw and "result" not in raw:
        return None

    test_id = class_method_id(raw, path.with_suffix("").as_posix())
    name = metadata_description(raw) or str(raw.get("Name") or raw.get("name") or test_id)
    result = canonical_result(raw.get("Result", raw.get("result")))
    feature = str(raw.get("feature") or raw.get("Feature") or extract_feature(test_id, name))
    normalized: dict[str, Any] = {
        "id": test_id,
        "name": name,
        "result": result,
        "feature": feature,
    }
    disabled_reason = optional_string(raw, "DisabledReason", "disabledReason", "disabled_reason")
    if disabled_reason is not None:
        normalized["disabled_reason"] = disabled_reason
    failure_reason = optional_string(raw, "FailedReason", "failureReason", "failure_reason")
    if failure_reason is not None:
        normalized["failure_reason"] = failure_reason
    case_counts = test_case_result_counts(raw)
    if case_counts:
        normalized["case_result_counts"] = case_counts
    return normalized


def json_files(root: Path) -> list[Path]:
    return sorted(
        p
        for p in root.rglob("*.json")
        if p.is_file() and p.name not in GENERATED_NAMES and not p.name.startswith("summary.")
    )


def load_from_dir(run_dir: Path) -> list[dict[str, Any]]:
    report = run_dir / "report.json"
    if report.is_file():
        tests = normalized_from_tests(load_json(report))
        if tests is not None:
            return tests

    tests: list[dict[str, Any]] = []
    for path in json_files(run_dir):
        try:
            raw = load_json(path)
        except json.JSONDecodeError:
            continue
        if path.name == "report.json":
            maybe_tests = normalized_from_tests(raw)
            if maybe_tests is not None:
                tests.extend(maybe_tests)
                continue
        test = normalized_from_per_test(path.relative_to(run_dir), raw)
        if test is not None:
            tests.append(test)
    return tests


def load_from_zip(path: Path, *, allow_partial: bool) -> list[dict[str, Any]]:
    with tempfile.TemporaryDirectory() as tmp:
        tmp_dir = Path(tmp)
        with zipfile.ZipFile(path) as zf:
            zf.extractall(tmp_dir)
        validate_complete_run(tmp_dir, allow_partial)
        return load_from_dir(tmp_dir)


def raw_tls_anvil_report(run_dir: Path) -> dict[str, Any] | None:
    report = run_dir / "report.json"
    if not report.is_file():
        return None
    raw = load_json(report)
    if not isinstance(raw, dict) or normalized_from_tests(raw) is not None:
        return None
    if not any(key in raw for key in ("Running", "TotalTests", "FinishedTests", "TestCaseCount")):
        return None
    return raw


def status_count(raw: dict[str, Any]) -> int:
    total = 0
    for key in (
        "StrictlySucceededTests",
        "ConceptuallySucceededTests",
        "DisabledTests",
        "PartiallyFailedTests",
        "FullyFailedTests",
        "TestSuiteErrorTests",
    ):
        value = raw.get(key)
        if isinstance(value, int):
            total += value
    return total


def anvil_command(run_dir: Path) -> str | None:
    path = run_dir / "logs" / "TLS-Anvil.command.txt"
    if not path.is_file():
        return None
    return path.read_text().strip() or None


def run_metadata(run_dir: Path) -> dict[str, Any]:
    path = run_dir / "run_metadata.json"
    if not path.is_file():
        return {}
    try:
        raw = load_json(path)
    except json.JSONDecodeError:
        return {}
    return raw if isinstance(raw, dict) else {}


def raw_tls_anvil_report_from_zip(run_dir: Path) -> dict[str, Any] | None:
    zipped = run_dir / "report.zip"
    if not zipped.is_file():
        return None
    try:
        with zipfile.ZipFile(zipped) as zf:
            with zf.open("report.json") as report:
                raw = json.loads(report.read().decode())
    except KeyError, json.JSONDecodeError, zipfile.BadZipFile:
        return None
    if not isinstance(raw, dict) or normalized_from_tests(raw) is not None:
        return None
    if not any(key in raw for key in ("Running", "TotalTests", "FinishedTests", "TestCaseCount")):
        return None
    return raw


def raw_report_provenance(run_dir: Path, allow_partial: bool) -> dict[str, Any]:
    metadata = run_metadata(run_dir)
    raw = raw_tls_anvil_report(run_dir) or raw_tls_anvil_report_from_zip(run_dir)
    report: dict[str, Any] = {"present": raw is not None}
    if raw is not None:
        total = raw.get("TotalTests")
        finished = raw.get("FinishedTests")
        observed = status_count(raw)
        report.update(
            {
                "running": raw.get("Running"),
                "total_tests": total,
                "finished_tests": finished,
                "status_count": observed,
                "complete": raw.get("Running") is False
                and isinstance(total, int)
                and observed == total,
            }
        )
    return {
        "generated_at": datetime.now(UTC).isoformat(),
        "adapter_allow_partial": allow_partial,
        "source_run_dir": str(run_dir),
        "host": metadata.get("host") or platform.node(),
        "git": metadata.get("git") or git_provenance(),
        "run_metadata": metadata,
        "tls_anvil": {
            "jar": metadata.get("tls_anvil_jar")
            or str(CONF_DIR / "zig-out" / "tools" / "TLS-Anvil.jar"),
            "command": metadata.get("command") or anvil_command(run_dir),
            "report": report,
        },
    }


def validate_complete_run(run_dir: Path, allow_partial: bool) -> None:
    if allow_partial:
        return
    raw = raw_tls_anvil_report(run_dir)
    if raw is None:
        return
    if raw.get("Running") is True:
        raise ValueError(
            "TLS-Anvil report.json says the run is still Running; rerun the adapter "
            "with --allow-partial only for local debugging, not acceptance evidence"
        )
    total = raw.get("TotalTests")
    if isinstance(total, int) and total > 0:
        observed = status_count(raw)
        if observed and observed < total:
            raise ValueError(
                f"TLS-Anvil report.json is incomplete: classified {observed}/{total} tests; "
                "use --allow-partial only for local debugging"
            )


def load_run(run_dir: Path, *, allow_partial: bool = False) -> list[dict[str, Any]]:
    if not run_dir.is_dir():
        raise FileNotFoundError(run_dir)
    validate_complete_run(run_dir, allow_partial)

    zipped = run_dir / "report.zip"
    if zipped.is_file():
        tests = load_from_zip(zipped, allow_partial=allow_partial)
        if tests:
            return tests

    return load_from_dir(run_dir)


def write_normalized(
    tests: list[dict[str, Any]],
    output: Path,
    provenance: dict[str, Any],
) -> None:
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps({"provenance": provenance, "tests": tests}, indent=2) + "\n")


def main() -> int:
    parser = argparse.ArgumentParser(description="Normalize a TLS-Anvil output directory.")
    parser.add_argument("run_dir", type=Path, help="TLS-Anvil output directory")
    parser.add_argument(
        "--output",
        type=Path,
        default=None,
        help="normalized report path (default: <run_dir>/report.normalized.json)",
    )
    parser.add_argument(
        "--allow-partial",
        action="store_true",
        help="allow a raw TLS-Anvil report.json that still says Running/incomplete; for local audit only",
    )
    args = parser.parse_args()

    if not args.run_dir.is_dir():
        print(f"error: run directory not found: {args.run_dir}", file=sys.stderr)
        return 2

    try:
        tests = load_run(args.run_dir, allow_partial=args.allow_partial)
    except ValueError as err:
        print(f"error: {err}", file=sys.stderr)
        return 2
    if not tests:
        print(f"error: no TLS-Anvil result JSON found under {args.run_dir}", file=sys.stderr)
        return 2

    output = args.output or (args.run_dir / "report.normalized.json")
    write_normalized(tests, output, raw_report_provenance(args.run_dir, args.allow_partial))
    print(output)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
