#!/usr/bin/env bash
# ztls conformance patch (#91): rebuild X509CertificateChainProvider from the
# patched source in this directory and replace it inside the installed
# tls-test-framework jar. Upstream v1.5.0 (and v1.5.2/main as of 2026-09-12)
# builds each chain's self-signed signing certificate without a basicConstraints
# extension, so every generated root is a non-conforming CA certificate
# (RFC 5280 §4.2.1.9). ztls correctly rejects such issuers, which fails every
# non-DSA HappyFlow chain combination. The patch adds a critical
# basicConstraints cA=true to the signing certs only; leaf configs and all
# other chain diversity are untouched. See NOTICE.md for the Apache-2.0
# attribution and modification notice.
#
# Called from build.zig with the installed tools lib directory.
set -euo pipefail

tools_lib_dir="$1"
expected_jar_name="tls-test-framework-1.5.0.jar"
jar="$tools_lib_dir/$expected_jar_name"
src_dir="$(cd "$(dirname "$0")" && pwd)"
source_file="$src_dir/X509CertificateChainProvider.java"
class_entry="de/rub/nds/tlstest/framework/utils/X509CertificateChainProvider.class"

# Explicit pinned-version check: refuse to patch anything but the expected
# upstream artifact. A future TLS-Anvil bump must consciously update this
# script and the patched source; never version-glob silently.
if [[ ! -f "$jar" ]]; then
    echo "ERROR: expected $jar (TLS-Anvil v1.5.0) is not installed; refusing to glob for another version" >&2
    exit 1
fi
while IFS= read -r found; do
    if [[ "$found" != "$jar" ]]; then
        echo "ERROR: unexpected tls-test-framework artifact $found next to $jar" >&2
        exit 1
    fi
done < <(find "$tools_lib_dir" -maxdepth 1 -name 'tls-test-framework-*.jar')

work="$(mktemp -d)"
tmpjar="$(mktemp "$jar.tmp.XXXXXX")"
cleanup() { rm -rf "$work" "$tmpjar"; }
trap cleanup EXIT

classpath="$tools_lib_dir/../TLS-Anvil.jar:$tools_lib_dir/*"
javac -proc:none -cp "$classpath" -d "$work" "$source_file"

# Atomic update: patch a same-filesystem temp copy, verify the class entry
# inside it, and only then rename it over the installed jar.
cp "$jar" "$tmpjar"
(cd "$work" && jar uf "$tmpjar" "$class_entry")
unzip -p "$tmpjar" "$class_entry" | cmp -s - "$work/$class_entry"

class_sha256=$(sha256sum "$work/$class_entry" | cut -d' ' -f1)
source_sha256=$(sha256sum "$source_file" | cut -d' ' -f1)
mv -f "$tmpjar" "$jar"
jar_sha256=$(sha256sum "$jar" | cut -d' ' -f1)

# Provenance stamp: run_metadata records these digests next to the live
# digests of the installed jar so a stale or unpatched artifact is
# distinguishable from a patched one (a source hash alone proves nothing).
cat >"$tools_lib_dir/$expected_jar_name.provenance" <<EOF
patched=true
jar_sha256=$jar_sha256
class_sha256=$class_sha256
source_sha256=$source_sha256
EOF
rm -rf "$work"
echo "patched X509CertificateChainProvider (basicConstraints cA) into $jar"
