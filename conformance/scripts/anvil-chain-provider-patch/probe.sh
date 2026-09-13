#!/usr/bin/env bash
# ztls #91 regression probes: run AnvilChainProviderProbe and
# ValidityRoundTripProbe against the jars that are EFFECTIVE on the classpath
# TLS-Anvil itself uses (zig-out/tools/TLS-Anvil.jar + zig-out/tools/lib/*).
# Optional argument: a pristine upstream jar (tls-test-framework-*.jar or
# x509-attacker-*.jar) used to demonstrate the red state. The probe reports
# its effective code sources, so classpath masking is visible, and exits
# nonzero on any failed check.
#
# - A tls-test-framework override is prepended: its class exists in both jars,
#   so shadowing the patched one is enough.
# - An x509-attacker override REPLACES the installed jar on the probe
#   classpath: merely prepending it would still load the patched-only classes
#   (DateTimeAdapter, package-info) from the installed jar later on the
#   classpath, hiding the red state. TLS-Anvil.jar is deliberately absent
#   from this classpath: its manifest Class-Path lists lib/*.jar relative to
#   its own location, which would pull the INSTALLED x509-attacker jar back
#   in and mask the override. Every class the probe needs lives in lib/.
set -euo pipefail

conf_dir="$(cd "$(dirname "$0")/../.." && pwd)"
src_dir="$(cd "$(dirname "$0")" && pwd)"
tools_dir="$conf_dir/zig-out/tools"
effective_ttf="$tools_dir/lib/tls-test-framework-1.5.0.jar"
effective_x509="$tools_dir/lib/x509-attacker-4.3.10.jar"

for jar in "$tools_dir/TLS-Anvil.jar" "$effective_ttf" "$effective_x509"; do
    if [[ ! -f "$jar" ]]; then
        echo "ERROR: $jar missing; run 'zig build' first" >&2
        exit 1
    fi
done

ttf_prefix=""
x509_override=""
if [[ "${1:-}" != "" ]]; then
    case "$(basename "$1")" in
        tls-test-framework-*.jar) ttf_prefix="$1:" ;;
        x509-attacker-*.jar) x509_override="$1" ;;
        *)
            echo "ERROR: override must be a tls-test-framework or x509-attacker jar" >&2
            exit 2
            ;;
    esac
fi

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
javac -proc:none -cp "$tools_dir/TLS-Anvil.jar:$tools_dir/lib/*" \
    -d "$work" \
    "$src_dir/AnvilChainProviderProbe.java" "$src_dir/ValidityRoundTripProbe.java"

java -cp "$work:$ttf_prefix$tools_dir/TLS-Anvil.jar:$tools_dir/lib/*" \
    AnvilChainProviderProbe

# Classpath for the validity probe: every lib jar except the installed
# x509-attacker jar; the override (if any) takes its place.
validity_cp=""
for entry in "$tools_dir"/lib/*.jar; do
    # With an override, the installed x509-attacker jar is dropped so the
    # pristine one is the effective artifact; without one it stays.
    if [[ -z "$x509_override" || "$(basename "$entry")" != "$(basename "$effective_x509")" ]]; then
        validity_cp+="$entry:"
    fi
done
java -cp "$work:${x509_override:+$x509_override:}$validity_cp" \
    ValidityRoundTripProbe
