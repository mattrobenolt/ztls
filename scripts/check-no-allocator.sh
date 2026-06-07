#!/usr/bin/env bash
# Guardrail for TODO-28a2091a: the ztls-owned TLS engine must not allocate.
#
# Core src/*.zig (excluding the src/test harnesses, which are allowed to use a
# testing allocator) must not import std.heap, take a std.mem.Allocator, or call
# libc malloc/free. Backend-owned libcrypto frees (EVP_*_free, OPENSSL_free,
# EC_KEY_free, ...) are permitted per the documented crypto backend contract in
# docs/research/DESIGN.md and docs/research/PROVIDER_INTERFACE.md.
#
# Exit 0 when clean, 1 when a violation is found. No dependencies beyond grep.
set -euo pipefail

cd "$(dirname "$0")/.."

mapfile -t files < <(find src -name '*.zig' -not -path 'src/test/*' | sort)

# Collect violations into one buffer, then decide exit status once. Avoid
# `grep | while` pipelines: the loop body runs in a subshell and cannot set a
# flag in the parent.
violations=""

add() {
  # $1 = file, $2 = grep pattern, $3 = optional allowlist pattern to drop
  local hits
  hits=$(grep -nE "$2" "$1" 2>/dev/null || true)
  # Drop pure-comment lines (`   //...`).
  hits=$(printf '%s\n' "$hits" | grep -vE '^[0-9]+:[[:space:]]*//' || true)
  if [ -n "${3:-}" ]; then
    hits=$(printf '%s\n' "$hits" | grep -vE "$3" || true)
  fi
  hits=$(printf '%s\n' "$hits" | grep -vE '^[[:space:]]*$' || true)
  if [ -n "$hits" ]; then
    while IFS= read -r line; do
      violations+="$1:$line"$'\n'
    done <<<"$hits"
  fi
}

backend_free='EVP_|OPENSSL_|EC_KEY_|EC_GROUP_|EC_POINT_|RSA_|BN_|BIO_|X509_|ASN1_'

for f in "${files[@]}"; do
  add "$f" 'std\.heap\b'
  add "$f" '(std\.mem\.Allocator|mem\.Allocator|: *Allocator\b|\bAllocator\))'
  add "$f" '\b(malloc|calloc|realloc)\b'
  add "$f" '(^|[^_A-Za-z])free\(' "$backend_free"
done

if [ -n "$violations" ]; then
  printf '%s' "$violations" | sed 's/^/no-allocator violation: /'
  echo
  echo "Core ztls engine code must be allocator-free (see docs/research/DESIGN.md)."
  echo "Backend-owned libcrypto allocations are documented and live behind the"
  echo "crypto facade; ztls-owned std.heap/Allocator/malloc/free is not allowed."
  exit 1
fi

echo "no-allocator check: clean (${#files[@]} core files scanned)"
