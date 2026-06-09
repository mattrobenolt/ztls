[doc("Run all tests")]
[group("check")]
test:
    zig build test --summary all

[doc("Run all linters (fmt, ziglint, no-alloc, python, actions)")]
[group("check")]
lint:
    zig fmt --check src/ examples/ bench/ build.zig
    ziglint build.zig examples bench $(fd --extension zig --exclude cryptox . src)
    ast-grep scan --rule rules/no-ztls-owned-allocations.yml src --globs '*.zig' --globs '!src/test/**' --report-style short
    cd conformance && uv run ruff format --check .
    cd conformance && uv run ruff check .
    cd conformance && uv run ty check .
    pinact run --fix=false --no-api .github/workflows/*.yml
    zizmor .github

[doc("Check duplicated package-local server fixtures match")]
[group("check")]
check-fixtures:
    @scripts/check-fixtures.sh
