#!/usr/bin/env python3
"""Convert a TLS-Anvil output directory into the normalized report schema.

The normalized schema is the input consumed by `anvil_report.py`:

    {"tests": [{"id": str, "name": str, "result": str, "feature": str}]}

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
import re
import sys
import tempfile
import zipfile
from pathlib import Path
from typing import Any

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
GENERATED_NAMES = frozenset({"summary.json", "report.normalized.json"})


def load_json(path: Path) -> Any:
    return json.loads(path.read_text())


def normalized_from_tests(raw: Any) -> list[dict[str, str]] | None:
    if not isinstance(raw, dict) or not isinstance(raw.get("tests"), list):
        return None
    tests: list[dict[str, str]] = []
    for idx, test in enumerate(raw["tests"]):
        if not isinstance(test, dict):
            continue
        test_id = str(test.get("id") or test.get("name") or f"test-{idx}")
        name = str(test.get("name") or test_id)
        result = canonical_result(test.get("result"))
        feature = str(test.get("feature") or extract_feature(test_id, name))
        tests.append({"id": test_id, "name": name, "result": result, "feature": feature})
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
    for key in ("id", "Id", "testId", "TestId", "name", "Name"):
        if raw.get(key):
            return str(raw[key])

    cls = raw.get("className") or raw.get("ClassName") or raw.get("TestClass")
    method = raw.get("methodName") or raw.get("MethodName") or raw.get("TestMethod")
    if cls and method:
        return f"{cls}.{method}"
    if cls:
        return str(cls)
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


def normalized_from_per_test(path: Path, raw: Any) -> dict[str, str] | None:
    if not isinstance(raw, dict):
        return None
    if "Result" not in raw and "result" not in raw:
        return None

    test_id = class_method_id(raw, path.with_suffix("").as_posix())
    name = metadata_description(raw) or str(raw.get("Name") or raw.get("name") or test_id)
    result = canonical_result(raw.get("Result", raw.get("result")))
    feature = str(raw.get("feature") or raw.get("Feature") or extract_feature(test_id, name))
    return {"id": test_id, "name": name, "result": result, "feature": feature}


def json_files(root: Path) -> list[Path]:
    return sorted(
        p
        for p in root.rglob("*.json")
        if p.is_file() and p.name not in GENERATED_NAMES and not p.name.startswith("summary.")
    )


def load_from_dir(run_dir: Path) -> list[dict[str, str]]:
    report = run_dir / "report.json"
    if report.is_file():
        tests = normalized_from_tests(load_json(report))
        if tests is not None:
            return tests

    tests: list[dict[str, str]] = []
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


def load_from_zip(path: Path) -> list[dict[str, str]]:
    with tempfile.TemporaryDirectory() as tmp:
        tmp_dir = Path(tmp)
        with zipfile.ZipFile(path) as zf:
            zf.extractall(tmp_dir)
        return load_from_dir(tmp_dir)


def load_run(run_dir: Path) -> list[dict[str, str]]:
    if not run_dir.is_dir():
        raise FileNotFoundError(run_dir)

    zipped = run_dir / "report.zip"
    if zipped.is_file():
        tests = load_from_zip(zipped)
        if tests:
            return tests

    return load_from_dir(run_dir)


def write_normalized(tests: list[dict[str, str]], output: Path) -> None:
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps({"tests": tests}, indent=2) + "\n")


def main() -> int:
    parser = argparse.ArgumentParser(description="Normalize a TLS-Anvil output directory.")
    parser.add_argument("run_dir", type=Path, help="TLS-Anvil output directory")
    parser.add_argument(
        "--output",
        type=Path,
        default=None,
        help="normalized report path (default: <run_dir>/report.normalized.json)",
    )
    args = parser.parse_args()

    if not args.run_dir.is_dir():
        print(f"error: run directory not found: {args.run_dir}", file=sys.stderr)
        return 2

    tests = load_run(args.run_dir)
    if not tests:
        print(f"error: no TLS-Anvil result JSON found under {args.run_dir}", file=sys.stderr)
        return 2

    output = args.output or (args.run_dir / "report.normalized.json")
    write_normalized(tests, output)
    print(output)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
