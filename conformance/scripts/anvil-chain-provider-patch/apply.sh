#!/usr/bin/env bash
# ztls conformance patches (#91): rebuild/replace classes inside the jars the
# conformance build installs under zig-out/tools/lib. Two independent patches,
# each applied atomically to its own pinned jar with its own provenance stamp:
#
# 1. tls-test-framework-1.5.0.jar: rebuild X509CertificateChainProvider from
#    the patched source in this directory. Upstream v1.5.0 (and v1.5.2/main as
#    of 2026-09-12) builds each chain's self-signed signing certificate without
#    a basicConstraints extension, so every generated root is a non-conforming
#    CA certificate (RFC 5280 §4.2.1.9). The patch adds a critical
#    basicConstraints cA=true to the signing certs only; leaf configs and all
#    other chain diversity are untouched.
#
# 2. x509-attacker-4.3.10.jar: inject DateTimeAdapter + package-info into
#    de.rub.nds.x509attacker.config. Upstream has no package-info, so JAXB
#    marshals the config's joda-time DateTime validity fields as EMPTY
#    elements; TLS-Attacker's Config.createCopy()/ConfigIO round trips then
#    replace the configured validity dates with the copy's current time. The package-level adapter preserves the
#    configured instants (including deliberately expired/future windows)
#    exactly; it never relaxes any ztls-side validation.
#
# See NOTICE.md for the Apache-2.0 attribution and modification notice.
#
# Called from build.zig with the installed tools lib directory.
set -euo pipefail

tools_lib_dir="$1"
src_dir="$(cd "$(dirname "$0")" && pwd)"

work="$(mktemp -d)"
tmpjars=()
cleanup() { rm -rf "$work"; rm -f "${tmpjars[@]}"; }
trap cleanup EXIT

classpath="$tools_lib_dir/../TLS-Anvil.jar:$tools_lib_dir/*"

# Pinned-version guard: refuse to patch anything but the exact expected
# upstream artifact. A future TLS-Anvil/x509-attacker bump must consciously
# update this script and the patched sources; never version-glob silently.
expect_only() {
    local expected="$1" pattern="$2" jar found
    jar="$tools_lib_dir/$expected"
    if [[ ! -f "$jar" ]]; then
        echo "ERROR: expected $jar is not installed; refusing to glob for another version" >&2
        exit 1
    fi
    while IFS= read -r found; do
        if [[ "$found" != "$jar" ]]; then
            echo "ERROR: unexpected $pattern artifact $found next to $jar" >&2
            exit 1
        fi
    done < <(find "$tools_lib_dir" -maxdepth 1 -name "$pattern")
}

# Atomic jar update: patch a same-filesystem temp copy, verify the class
# entries inside it byte-for-byte, and only then rename it over the installed
# jar. Run in the parent shell so failures exit and cleanup retains temp paths.
update_jar() {
    local jar="$1" entry tmpjar
    tmpjar="$(mktemp "$jar.tmp.XXXXXX")"
    tmpjars+=("$tmpjar")
    cp "$jar" "$tmpjar"
    (cd "$work" && jar uf "$tmpjar" "${@:2}")
    for entry in "${@:2}"; do
        unzip -p "$tmpjar" "$entry" | cmp -s - "$work/$entry"
    done
    mv -f "$tmpjar" "$jar"
}

sha256_of() { sha256sum "$1" | cut -d' ' -f1; }

# --- Patch 1: chain provider basicConstraints (RFC 5280 §4.2.1.9) ---
expect_only "tls-test-framework-1.5.0.jar" 'tls-test-framework-*.jar'
ttf_jar="$tools_lib_dir/tls-test-framework-1.5.0.jar"
ttf_class=de/rub/nds/tlstest/framework/utils/X509CertificateChainProvider.class
javac -proc:none -cp "$classpath" -d "$work" "$src_dir/X509CertificateChainProvider.java"
update_jar "$ttf_jar" "$ttf_class"
ttf_jar_sha256=$(sha256_of "$ttf_jar")
# Provenance stamp: run_metadata records these digests next to the live
# digests of the installed jar so a stale or unpatched artifact is
# distinguishable from a patched one (a source hash alone proves nothing).
cat >"$ttf_jar.provenance" <<EOF
patched=true
jar_sha256=$ttf_jar_sha256
class_sha256=$(sha256_of "$work/$ttf_class")
source_sha256=$(sha256_of "$src_dir/X509CertificateChainProvider.java")
EOF
echo "patched X509CertificateChainProvider (basicConstraints cA) into $ttf_jar"

# --- Patch 2: x509-attacker DateTime JAXB adapter (validity preservation) ---
expect_only "x509-attacker-4.3.10.jar" 'x509-attacker-*.jar'
x509_jar="$tools_lib_dir/x509-attacker-4.3.10.jar"
adapter_class=de/rub/nds/x509attacker/config/DateTimeAdapter.class
package_info_class=de/rub/nds/x509attacker/config/package-info.class
javac -proc:none -cp "$classpath" -d "$work" \
    "$src_dir/DateTimeAdapter.java" "$src_dir/package-info.java"
update_jar "$x509_jar" "$adapter_class" "$package_info_class"
x509_jar_sha256=$(sha256_of "$x509_jar")
cat >"$x509_jar.provenance" <<EOF
patched=true
jar_sha256=$x509_jar_sha256
adapter_class_sha256=$(sha256_of "$work/$adapter_class")
adapter_source_sha256=$(sha256_of "$src_dir/DateTimeAdapter.java")
package_info_class_sha256=$(sha256_of "$work/$package_info_class")
package_info_source_sha256=$(sha256_of "$src_dir/package-info.java")
EOF
echo "patched DateTimeAdapter (JAXB validity serialization) into $x509_jar"
