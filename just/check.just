[doc("Run all tests")]
[group("check")]
test:
    zig build test --summary all

[doc("Build, test, benchmark-smoke, and tlsfuzzer-smoke with AWS-LC libcrypto")]
[group("check")]
check-backend-aws-lc:
    #!/usr/bin/env bash
    set -euo pipefail
    aws_lc_pkg_config_path="${ZTLS_AWS_LC_PKG_CONFIG_PATH:-}"
    if [ -z "$aws_lc_pkg_config_path" ]; then
        aws_lc_dev=$(nix build --no-link --print-out-paths nixpkgs#aws-lc.dev)
        aws_lc_pkg_config_path="$aws_lc_dev/lib/pkgconfig"
    fi
    aws_lc_include_dir=$(PKG_CONFIG_PATH="$aws_lc_pkg_config_path" pkg-config --variable=includedir libcrypto)
    aws_lc_lib_dir=$(PKG_CONFIG_PATH="$aws_lc_pkg_config_path" pkg-config --variable=libdir libcrypto)
    cache_dir=$(mktemp -d)
    log=$(mktemp)
    trap 'rm -rf "$cache_dir" "$log"' EXIT
    PKG_CONFIG_PATH="$aws_lc_pkg_config_path" zig build test --summary all --verbose --cache-dir "$cache_dir" 2>&1 | tee "$log"
    PKG_CONFIG_PATH="$aws_lc_pkg_config_path" zig build bench-bin --summary all --verbose --cache-dir "$cache_dir" 2>&1 | tee -a "$log"
    PKG_CONFIG_PATH="$aws_lc_pkg_config_path" zig build bench --cache-dir "$cache_dir" -- --filter 'BenchmarkRecordEncryptPrepared/TLS_AES_128_GCM_SHA256/1350' --count=1 --benchtime=1x --no-env
    PKG_CONFIG_PATH="$aws_lc_pkg_config_path" zig build example-in_memory_handshake --summary all --cache-dir "$cache_dir"
    (cd conformance && PKG_CONFIG_PATH="$aws_lc_pkg_config_path" zig build --summary all --verbose --cache-dir "$cache_dir/conformance") 2>&1 | tee -a "$log"
    (cd conformance && PKG_CONFIG_PATH="$aws_lc_pkg_config_path" uv run pytest -q tests/test_tls13.py)
    grep -F -- "-I$aws_lc_include_dir" "$log" >/dev/null || {
        echo "AWS-LC include path was not used: $aws_lc_include_dir" >&2
        exit 1
    }
    grep -F -- "-L$aws_lc_lib_dir" "$log" >/dev/null || {
        echo "AWS-LC library path was not used: $aws_lc_lib_dir" >&2
        exit 1
    }

[doc("Build, test, benchmark-smoke, and tlsfuzzer-smoke with BoringSSL libcrypto")]
[group("check")]
check-backend-boringssl:
    #!/usr/bin/env bash
    set -euo pipefail
    boringssl_pkg_config_path="${ZTLS_BORINGSSL_PKG_CONFIG_PATH:-}"
    if [ -z "$boringssl_pkg_config_path" ]; then
        echo "ZTLS_BORINGSSL_PKG_CONFIG_PATH is not set; run inside 'nix develop .#boringssl'" >&2
        exit 1
    fi
    boringssl_include_dir=$(PKG_CONFIG_PATH="$boringssl_pkg_config_path" pkg-config --variable=includedir libcrypto)
    boringssl_lib_dir=$(PKG_CONFIG_PATH="$boringssl_pkg_config_path" pkg-config --variable=libdir libcrypto)
    cache_dir=$(mktemp -d)
    log=$(mktemp)
    trap 'rm -rf "$cache_dir" "$log"' EXIT
    PKG_CONFIG_PATH="$boringssl_pkg_config_path" zig build test --summary all --verbose --cache-dir "$cache_dir" 2>&1 | tee "$log"
    PKG_CONFIG_PATH="$boringssl_pkg_config_path" zig build bench-bin --summary all --verbose --cache-dir "$cache_dir" 2>&1 | tee -a "$log"
    PKG_CONFIG_PATH="$boringssl_pkg_config_path" zig build bench --cache-dir "$cache_dir" -- --filter 'BenchmarkRecordEncryptPrepared/TLS_AES_128_GCM_SHA256/1350' --count=1 --benchtime=1x --no-env
    PKG_CONFIG_PATH="$boringssl_pkg_config_path" zig build example-in_memory_handshake --summary all --cache-dir "$cache_dir"
    (cd conformance && PKG_CONFIG_PATH="$boringssl_pkg_config_path" zig build --summary all --verbose --cache-dir "$cache_dir/conformance") 2>&1 | tee -a "$log"
    (cd conformance && PKG_CONFIG_PATH="$boringssl_pkg_config_path" uv run pytest -q tests/test_tls13.py)
    grep -F -- "-I$boringssl_include_dir" "$log" >/dev/null || {
        echo "BoringSSL include path was not used: $boringssl_include_dir" >&2
        exit 1
    }
    grep -F -- "-L$boringssl_lib_dir" "$log" >/dev/null || {
        echo "BoringSSL library path was not used: $boringssl_lib_dir" >&2
        exit 1
    }

[doc("Run AWS-LC and BoringSSL tests under Zig 0.16")]
[group("check")]
check-backends-0_16:
    #!/usr/bin/env bash
    set -euo pipefail
    case "$(zig version)" in
        0.16.*) ;;
        *) echo "check-backends-0_16 requires Zig 0.16" >&2; exit 1 ;;
    esac
    aws_lc_pkg_config_path="${ZTLS_AWS_LC_PKG_CONFIG_PATH:-}"
    boringssl_pkg_config_path="${ZTLS_BORINGSSL_PKG_CONFIG_PATH:-}"
    if [ -z "$aws_lc_pkg_config_path" ] || [ -z "$boringssl_pkg_config_path" ]; then
        echo "run inside the ztls Zig 0.16 Nix devshell" >&2
        exit 1
    fi
    cache_dir=$(mktemp -d)
    global_cache_dir=$(mktemp -d)
    trap 'rm -rf "$cache_dir" "$global_cache_dir"' EXIT
    PKG_CONFIG_PATH="$aws_lc_pkg_config_path" scripts/assert-libcrypto-family.sh aws-lc
    ZIG_GLOBAL_CACHE_DIR="$global_cache_dir" PKG_CONFIG_PATH="$aws_lc_pkg_config_path" zig build test --summary all --cache-dir "$cache_dir/aws-lc"
    PKG_CONFIG_PATH="$boringssl_pkg_config_path" scripts/assert-libcrypto-family.sh boringssl
    ZIG_GLOBAL_CACHE_DIR="$global_cache_dir" PKG_CONFIG_PATH="$boringssl_pkg_config_path" zig build test --summary all --cache-dir "$cache_dir/boringssl"

[doc("Compile explicit FIPS identities and reject BoringSSL FIPS")]
[group("check")]
check-fips-builds:
    #!/usr/bin/env bash
    set -euo pipefail
    aws_lc_pkg_config_path="${ZTLS_AWS_LC_PKG_CONFIG_PATH:-}"
    boringssl_pkg_config_path="${ZTLS_BORINGSSL_PKG_CONFIG_PATH:-}"
    if [ -z "$aws_lc_pkg_config_path" ] || [ -z "$boringssl_pkg_config_path" ]; then
        echo "run inside a ztls Nix devshell" >&2
        exit 1
    fi
    cache_dir=$(mktemp -d)
    global_cache_dir=$(mktemp -d)
    log=$(mktemp)
    trap 'rm -rf "$cache_dir" "$global_cache_dir" "$log"' EXIT
    ZIG_GLOBAL_CACHE_DIR="$global_cache_dir" zig build test-bin -Dcrypto-fips=true --cache-dir "$cache_dir/openssl"
    ZIG_GLOBAL_CACHE_DIR="$global_cache_dir" PKG_CONFIG_PATH="$aws_lc_pkg_config_path" zig build test-bin -Dcrypto-fips=true --cache-dir "$cache_dir/aws-lc"
    set +e
    ZIG_GLOBAL_CACHE_DIR="$global_cache_dir" PKG_CONFIG_PATH="$boringssl_pkg_config_path" zig build test-bin -Dcrypto-fips=true --cache-dir "$cache_dir/boringssl" >"$log" 2>&1
    status=$?
    set -e
    if [ "$status" -eq 0 ]; then
        echo "BoringSSL accepted unsupported FIPS policy" >&2
        exit 1
    fi
    grep -F -- '-Dcrypto-fips=true is unsupported with BoringSSL' "$log" >/dev/null

[doc("Format all code")]
[group("check")]
fmt: fmt-zig fmt-actions fmt-just fmt-rust
    just conformance/fmt

[doc("Rerun a suite N times to shake out order- and timing-dependent flakes")]
[group("check")]
flake-check n="20":
    #!/usr/bin/env bash
    set -euo pipefail
    # Compilation caches but test runs do not, so each iteration really
    # re-executes. Cheap enough to be routine: these suites are milliseconds.
    for i in $(seq 1 {{ n }}); do
        if ! zig build test > /dev/null 2>&1; then
            echo "flaked on run $i of {{ n }}" >&2
            zig build test 2>&1 | tail -20 >&2
            exit 1
        fi
    done
    echo "{{ n }} consecutive green runs"

[doc("Run every in-tree integration gate (needs a Zig 0.16 devshell)")]
[group("check")]
integrations-ci:
    just integrations/ztls-std/ci
    just integrations/ztls-xev/ci
    if [ "$(uname -s)" = Linux ]; then just integrations/ztls-ktls/ci; else echo "ztls-ktls: Linux-only, skipped"; fi

[doc("Compile core ztls as an isolated fetched package with Zig 0.15.2")]
[group("check")]
distribution-core-ci:
    ./scripts/distribution-smoke.sh core

[doc("Compile integration modules as an isolated fetched package with Zig 0.16")]
[group("check")]
distribution-integrations-ci:
    ./scripts/distribution-smoke.sh integrations

# Consumer compatibility gate (#119). ztls owns candidate provenance,
# isolation, and the record; the consumers own their commands. See
# docs/research/CONSUMER_GATE.md. Consumer checkouts come from
# CONSUMER_GATE_HANDOFF_REPO / CONSUMER_GATE_Z53_REPO or --handoff-repo/
# --z53-repo.
[doc("Gate a ztls candidate against the active consumer suites (handoff, z53) (#119)")]
[group("check")]
consumer-gate $ztls_rev="HEAD" $handoff_rev="HEAD" $z53_rev="HEAD" $consumers="handoff z53" $out_dir="":
    #!/usr/bin/env bash
    set -euo pipefail
    args=(--ztls-rev "$ztls_rev" --handoff-rev "$handoff_rev" --z53-rev "$z53_rev" --consumers "$consumers")
    if [ -n "$out_dir" ]; then args+=(--out-dir "$out_dir"); fi
    exec ./scripts/consumer-gate.sh "${args[@]}"

# The qualification entrypoint: refuses symbolic revisions, so a record written
# by this recipe names the exact ztls and consumer commits that were tested.
[doc("Qualify a production candidate: fixed ztls SHA plus fixed handoff and z53 SHAs (#119)")]
[group("check")]
qualify-candidate $ztls_sha $handoff_sha $z53_sha $out_dir:
    ./scripts/consumer-gate.sh --require-fixed-revisions --ztls-rev "$ztls_sha" --handoff-rev "$handoff_sha" --z53-rev "$z53_sha" --out-dir "$out_dir"

[doc("Exercise consumer-gate guards offline without consumer builds")]
[group("check")]
consumer-gate-selftest:
    ./scripts/consumer-gate.sh --selftest

[doc("Build and run the C ABI example (libztls.a + c_client.c)")]
[group("check")]
capi-ci:
    #!/usr/bin/env bash
    set -euo pipefail
    zig build -Dcapi --summary all
    lib=$(find zig-out -name 'libztls.a' -print -quit)
    if [ -z "$lib" ]; then
        echo "libztls.a not found in zig-out" >&2
        exit 1
    fi
    libdir=$(dirname "$lib")
    if command -v llvm-ar >/dev/null 2>&1; then
        archive_members=$(llvm-ar t "$lib")
    else
        archive_members=$(ar t "$lib")
    fi
    printf '%s\n' "$archive_members"
    shared_members=$(printf '%s\n' "$archive_members" | grep -E '(\.so$|\.so\.|\.dylib$)' || true)
    if [ -n "$shared_members" ]; then
        printf 'libztls.a contains shared-object archive members:\n%s\n' "$shared_members" >&2
        exit 1
    fi
    zig cc -o zig-out/c_client examples/c_client.c -I include -L "$libdir" -lztls -lcrypto -lm
    zig-out/c_client

[doc("Run deterministic examples as TLS smoke tests")]
[group("examples")]
examples-ci:
    zig build example-tcp_loopback --summary all
    zig build example-in_memory_handshake --summary all
    zig build example-epoll_pingpong --summary all
    zig build example-iouring_pingpong --summary all

[doc("Check formatting and lint (for CI)")]
[group("check")]
lint: lint-zig lint-shell lint-actions lint-just lint-markdown lint-issues lint-readme-index lint-fixtures lint-rust
    just conformance/lint

[doc("Lint markdown research docs for status-language drift")]
[group("check")]
lint-markdown:
    #!/usr/bin/env bash
    matches=$(grep -rnE --include='*.md' --exclude-dir=rfcs -e '[Nn]ow (uses|enforces|defaults|requires|provides|supports|accepts|rejects|returns|fails|emits|includes|features|serves|offers|builds|depends|targets|relies|will|becomes)' -e '(is|are) (currently|presently|today)' -e 'this commit (has|now|will)' docs/research/) || true
    # Reject bold status-heading forms (e.g. `**Status:**`, `**State:**`,
    # `**Done:**`, `**Progress:**`, or the same without trailing colon): a
    # verdict label outside the spine. Status lives only in
    # PRODUCTION_READINESS.md; the search scope `docs/research/` already
    # excludes the spine, but `grep -v` makes the exclusion explicit and
    # future-proof if the scope widens.
    heading_matches=$(grep -rniE --include='*.md' --exclude-dir=rfcs -e '^\*\*(status|state|done|progress):?\*\*( |$)' docs/research/ | grep -v 'PRODUCTION_READINESS.md' || true)
    if [[ -n "$matches" || -n "$heading_matches" ]]; then
        [[ -n "$matches" ]] && printf 'status-language drift found in research docs:\n%s\n' "$matches" >&2
        [[ -n "$heading_matches" ]] && printf 'status-heading drift found in research docs (PRODUCTION_READINESS.md is the spine and is the only doc allowed to carry status):\n%s\n' "$heading_matches" >&2
        exit 1
    fi
    echo "no status-language drift"

[doc("Lint research doc headings for closed-issue citations")]
[group("check")]
lint-issues:
    #!/usr/bin/env bash
    set -u
    candidates=$(grep -rEn '^## .+ — #[0-9]+' docs/research/ --include='*.md' --exclude-dir=rfcs) || true
    if [ -z "$candidates" ]; then
        echo "no active-work headings referencing issues"
        exit 0
    fi
    findings=""
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        issue=$(printf '%s' "$line" | grep -oE '#[0-9]+' | head -1 | tr -d '#')
        state=$(gh issue view "$issue" --json state --jq '.state' 2>/dev/null) || state=UNKNOWN
        if [ "$state" = "CLOSED" ]; then
            findings="${findings}${line} (issue #${issue} is CLOSED)"$'\n'
        fi
    done <<< "$candidates"
    if [ -n "$findings" ]; then
        printf 'closed-issue citations in research doc headings:\n%s' "$findings" >&2
        exit 1
    fi
    echo "no closed-issue citations in research doc headings"

[doc("Reject tracked binary fixture files")]
[group("check")]
lint-fixtures:
    #!/usr/bin/env bash
    set -euo pipefail
    matches=$(git ls-files 'tests/fixtures/*' | grep -E '\.(der|bin|sig)$' || true)
    if [ -n "$matches" ]; then
        printf 'binary fixture files are not allowed:\n%s\n' "$matches" >&2
        exit 1
    fi
    echo "no tracked binary fixture files"

[doc("Verify docs/research/README.md links match filesystem")]
[group("check")]
lint-readme-index:
    #!/usr/bin/env bash
    set -u
    readme=docs/research/README.md
    if [ ! -f "$readme" ]; then
        echo "missing $readme" >&2
        exit 1
    fi
    linked=$(mktemp)
    actual=$(mktemp)
    trap 'rm -f "$linked" "$actual"' EXIT
    grep -oE '\(([A-Za-z0-9./_-]+\.md)\)' "$readme" | sed 's|[()]||g' | sort -u > "$linked"
    find docs/research -maxdepth 1 -type f -name '*.md' ! -name 'README.md' | sed 's|^docs/research/||' | sort -u > "$actual"
    unlinked=$(comm -23 "$actual" "$linked" | sed '/^$/d')
    broken=$(comm -13 "$actual" "$linked" | sed '/^$/d')
    findings=""
    if [ -n "$unlinked" ]; then
        findings="${findings}unlinked research files (in docs/research/ but not referenced from README):"$'\n'"$unlinked"$'\n'
    fi
    if [ -n "$broken" ]; then
        findings="${findings}linked from README but missing on disk:"$'\n'"$broken"$'\n'
    fi
    if [ -n "$findings" ]; then
        printf '%s' "$findings" >&2
        exit 1
    fi
    echo "README index matches research files"
    echo "no closed-issue citations in research doc headings"

[doc("Format Zig code")]
[group("check")]
fmt-zig:
    zig fmt src/ examples/ bench/ shared/ build.zig

[doc("Format Rust benchmark code (bench/rustls)")]
[group("check")]
fmt-rust:
    cargo fmt --manifest-path bench/rustls/Cargo.toml

[group("check")]
lint-zig:
    zig fmt --check src/ examples/ bench/ shared/ tests/distribution-consumer/ build.zig
    ziglint build.zig examples bench shared tests/distribution-consumer $(fd --extension zig --exclude certificate_parser.zig . src)
    ast-grep scan --rule rules/no-ztls-owned-allocations.yml src --globs '*.zig' --globs '!src/test/**' --globs '!src/bench/**' --globs '!src/interop.zig' --report-style short
    ast-grep scan --rule rules/no-c-pointer-types.yml src --globs '*.zig' --report-style short
    # std-alias rules: enforce the aliases we always want. certificate_parser.zig
    # is an upstream-derived std fork kept close to upstream, so it is excluded
    # like ziglint does.
    rc=0; for rule in rules/std-alias-*.yml; do ast-grep scan --rule "$rule" src examples bench shared --globs '*.zig' --globs '!src/certificate_parser.zig' --report-style short || rc=1; done; exit $rc

[doc("Lint shell scripts")]
[group("check")]
lint-shell:
    shellcheck --severity=warning scripts/*.sh infra/bench/*.sh infra/iam/*.sh

[doc("Lint Rust benchmark code (rustfmt --check + clippy -D warnings)")]
[group("check")]
lint-rust:
    cargo fmt --check --manifest-path bench/rustls/Cargo.toml
    cargo clippy --all-targets --release --manifest-path bench/rustls/Cargo.toml -- -D warnings

[doc("Format Justfiles")]
[group("check")]
fmt-just:
    @fd '(^justfile$|\.just$)' -tf -x just --fmt --unstable --justfile {}

[group("check")]
lint-just:
    @fd '(^justfile$|\.just$)' -tf -x just --check --fmt --unstable --justfile {}

[doc("Auto-fix GitHub Actions workflows")]
[group("check")]
fmt-actions:
    pinact run .github/workflows/*.yml

[group("check")]
lint-actions:
    pinact run --fix=false --no-api .github/workflows/*.yml
    zizmor .github
