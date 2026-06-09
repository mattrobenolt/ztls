#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

scripts/gen-cert.sh
scripts/gen-cv-sig.py
