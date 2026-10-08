#!/usr/bin/env bash
# ztls conformance patches (#91, #146): rebuild/replace classes inside the
# jars the conformance build installs under zig-out/tools/lib. One remaining
# patch, applied atomically to its own pinned jar with its own provenance
# stamp:
#
# 1. x509-attacker-4.3.10.jar: inject DateTimeAdapter + package-info into
#    de.rub.nds.x509attacker.config. Upstream has no package-info, so JAXB
#    marshals the config's joda-time DateTime validity fields as EMPTY
#    elements; TLS-Attacker's Config.createCopy()/ConfigIO round trips then
#    replace the configured validity dates with the copy's current time. The
#    package-level adapter preserves the configured instants (including
#    deliberately expired/future windows) exactly; it never relaxes any
#    ztls-side validation.
#
# The tls-test-framework jar is NO LONGER patched. TLS-Anvil v1.5.3 adopted
# the #91 chain fix upstream: X509CertificateChainProvider now adds a
# critical basicConstraints cA=true to every chain signing certificate
# (RFC 5280 §4.2.1.9), which is exactly what the retired local fork used to
# do. The v1.5.0-era fork and its patch block were removed with the v1.5.3
# bump (#146); probe.sh still verifies the installed (upstream) provider
# carries the fix.
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

# --- DateTimeAdapter patch: x509-attacker JAXB validity preservation ---
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
