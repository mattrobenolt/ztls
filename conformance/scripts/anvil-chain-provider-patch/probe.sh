#!/usr/bin/env bash
# ztls #91 regression: run AnvilChainProviderProbe against the tls-test-framework
# jar that is EFFECTIVE on the classpath TLS-Anvil itself uses
# (zig-out/tools/TLS-Anvil.jar + zig-out/tools/lib/*). Optional argument:
# an explicit tls-test-framework jar placed first on the classpath (used to
# demonstrate the red state against the pristine upstream class).
set -euo pipefail

conf_dir="$(cd "$(dirname "$0")/../.." && pwd)"
src_dir="$(cd "$(dirname "$0")" && pwd)"
tools_dir="$conf_dir/zig-out/tools"
effective_jar="$tools_dir/lib/tls-test-framework-1.5.0.jar"
class_entry=de/rub/nds/tlstest/framework/utils/X509CertificateChainProvider.class

if [[ ! -f "$effective_jar" ]]; then
    echo "ERROR: $effective_jar missing; run 'zig build' first" >&2
    exit 1
fi

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
javac -proc:none -cp "$tools_dir/TLS-Anvil.jar:$tools_dir/lib/*" \
    -d "$work" "$src_dir/AnvilChainProviderProbe.java"

# The installed jar set is exactly the TLS-Anvil runtime classpath; an
# explicit override jar (if given) is prepended so its class is the effective
# one, which the probe reports via its code-source assertion.
override="${1:-}"
prefix=""
if [[ -n "$override" ]]; then
    prefix="$override:"
fi
java -cp "$work:$prefix$tools_dir/TLS-Anvil.jar:$tools_dir/lib/*" \
    AnvilChainProviderProbe
