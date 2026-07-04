[doc("Run all tests")]
[group("check")]
test:
    zig build test --summary all

[doc("Build, test, and build benchmark binary with AWS-LC libcrypto")]
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
    grep -F -- "-I$aws_lc_include_dir" "$log" >/dev/null || {
        echo "AWS-LC include path was not used: $aws_lc_include_dir" >&2
        exit 1
    }
    grep -F -- "-L$aws_lc_lib_dir" "$log" >/dev/null || {
        echo "AWS-LC library path was not used: $aws_lc_lib_dir" >&2
        exit 1
    }

[doc("Format all code")]
[group("check")]
fmt: fmt-zig fmt-actions fmt-just
    just conformance/fmt

[doc("Run deterministic examples as TLS smoke tests")]
[group("examples")]
examples-ci:
    zig build example-tcp_loopback --summary all
    zig build example-in_memory_handshake --summary all
    zig build example-epoll_pingpong --summary all
    zig build example-iouring_pingpong --summary all

[doc("Check formatting and lint (for CI)")]
[group("check")]
lint: lint-zig lint-actions lint-just lint-markdown lint-issues lint-readme-index lint-fixtures
    just conformance/lint

[doc("Lint markdown research docs for status-language drift")]
[group("check")]
lint-markdown:
    #!/usr/bin/env bash
    matches=$(grep -rnE --include='*.md' --exclude-dir=rfcs -e '[Nn]ow (uses|enforces|defaults|requires|provides|supports|accepts|rejects|returns|fails|emits|includes|features|serves|offers|builds|depends|targets|relies|will|becomes)' -e '(is|are) (currently|presently|today)' -e 'this commit (has|now|will)' docs/research/) || true
    if [[ -n "$matches" ]]; then
        printf 'status-language drift found in research docs:\n%s\n' "$matches" >&2
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
    zig fmt src/ examples/ bench/ build.zig

[group("check")]
lint-zig:
    zig fmt --check src/ examples/ bench/ build.zig
    ziglint build.zig examples bench $(fd --extension zig --exclude cryptox . src)
    ast-grep scan --rule rules/no-ztls-owned-allocations.yml src --globs '*.zig' --globs '!src/test/**' --globs '!src/bench/**' --globs '!src/interop.zig' --report-style short
    ast-grep scan --rule rules/no-c-pointer-types.yml src --globs '*.zig' --report-style short
    # std-alias rules: enforce the aliases we always want. cryptox is a vendored
    # std fork kept close to upstream, so it is excluded like ziglint does.
    rc=0; for rule in rules/std-alias-*.yml; do ast-grep scan --rule "$rule" src examples bench --globs '*.zig' --globs '!src/cryptox/**' --report-style short || rc=1; done; exit $rc

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
