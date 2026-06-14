[doc("Run all tests")]
[group("check")]
test:
    zig build test --summary all

[doc("Build and test the AWS-LC backend dispatch shim; still links system libcrypto")]
[group("check")]
check-backend-shim:
    zig build test --summary all -Dcrypto-backend=aws-lc

[doc("Format all code")]
[group("check")]
fmt: fmt-zig fmt-actions fmt-just
    just conformance/fmt

[doc("Run deterministic examples as TLS smoke tests")]
[group("examples")]
examples-ci:
    zig build example-tcp_loopback --summary all
    zig build example-in_memory_handshake --summary all

[doc("Check formatting and lint (for CI)")]
[group("check")]
lint: lint-zig lint-actions lint-just lint-markdown lint-issues lint-readme-index
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
    ast-grep scan --rule rules/no-c-pointer-types.yml src --globs '*.zig' --globs '!src/crypto/**' --report-style short

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
