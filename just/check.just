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
    PKG_CONFIG_PATH="$aws_lc_pkg_config_path" zig build test --summary all --verbose --cache-dir "$cache_dir" -Dcrypto-backend=aws-lc 2>&1 | tee "$log"
    PKG_CONFIG_PATH="$aws_lc_pkg_config_path" zig build bench-bin --summary all --verbose --cache-dir "$cache_dir" -Dcrypto-backend=aws-lc 2>&1 | tee -a "$log"
    PKG_CONFIG_PATH="$aws_lc_pkg_config_path" zig build bench --cache-dir "$cache_dir" -Dcrypto-backend=aws-lc -- --filter 'BenchmarkRecordEncryptPrepared/TLS_AES_128_GCM_SHA256/1350' --count=1 --benchtime=1x --no-env
    PKG_CONFIG_PATH="$aws_lc_pkg_config_path" zig build example-in_memory_handshake --summary all --cache-dir "$cache_dir" -Dcrypto-backend=aws-lc
    (cd conformance && PKG_CONFIG_PATH="$aws_lc_pkg_config_path" ZTLS_CRYPTO_BACKEND=aws-lc zig build --summary all --verbose --cache-dir "$cache_dir/conformance" -Dcrypto-backend=aws-lc) 2>&1 | tee -a "$log"
    (cd conformance && PKG_CONFIG_PATH="$aws_lc_pkg_config_path" ZTLS_CRYPTO_BACKEND=aws-lc uv run pytest -q tests/test_tls13.py)
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
    PKG_CONFIG_PATH="$boringssl_pkg_config_path" zig build test --summary all --verbose --cache-dir "$cache_dir" -Dcrypto-backend=boringssl 2>&1 | tee "$log"
    PKG_CONFIG_PATH="$boringssl_pkg_config_path" zig build bench-bin --summary all --verbose --cache-dir "$cache_dir" -Dcrypto-backend=boringssl 2>&1 | tee -a "$log"
    PKG_CONFIG_PATH="$boringssl_pkg_config_path" zig build bench --cache-dir "$cache_dir" -Dcrypto-backend=boringssl -- --filter 'BenchmarkRecordEncryptPrepared/TLS_AES_128_GCM_SHA256/1350' --count=1 --benchtime=1x --no-env
    PKG_CONFIG_PATH="$boringssl_pkg_config_path" zig build example-in_memory_handshake --summary all --cache-dir "$cache_dir" -Dcrypto-backend=boringssl
    (cd conformance && PKG_CONFIG_PATH="$boringssl_pkg_config_path" ZTLS_CRYPTO_BACKEND=boringssl zig build --summary all --verbose --cache-dir "$cache_dir/conformance" -Dcrypto-backend=boringssl) 2>&1 | tee -a "$log"
    (cd conformance && PKG_CONFIG_PATH="$boringssl_pkg_config_path" ZTLS_CRYPTO_BACKEND=boringssl uv run pytest -q tests/test_tls13.py)
    grep -F -- "-I$boringssl_include_dir" "$log" >/dev/null || {
        echo "BoringSSL include path was not used: $boringssl_include_dir" >&2
        exit 1
    }
    grep -F -- "-L$boringssl_lib_dir" "$log" >/dev/null || {
        echo "BoringSSL library path was not used: $boringssl_lib_dir" >&2
        exit 1
    }

[doc("Format all code")]
[group("check")]
fmt: fmt-zig fmt-actions fmt-just fmt-rust
    just conformance/fmt

[doc("Run deterministic examples as TLS smoke tests")]
[group("examples")]
examples-ci:
    zig build example-tcp_loopback --summary all
    zig build example-in_memory_handshake --summary all
    zig build example-epoll_pingpong --summary all
    zig build example-iouring_pingpong --summary all
    zig build example-ktls_server --summary all

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
    zig fmt --check src/ examples/ bench/ shared/ build.zig
    ziglint build.zig examples bench shared $(fd --extension zig --exclude certificate_parser.zig . src)
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
