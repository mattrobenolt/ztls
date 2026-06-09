fmt_paths := "src/ examples/ bench/ build.zig"

[doc("Run unit tests")]
[group("check")]
test:
    zig build test --summary all

[doc("Check GitHub Actions pins and workflow lint")]
[group("check")]
check-actions:
    pinact run --fix=false --no-api .github/workflows/*.yml
    zizmor .github

[doc("Assert the ztls-owned engine is allocator-free")]
[group("check")]
check-no-alloc:
    ast-grep scan --rule rules/no-ztls-owned-allocations.yml src --globs '*.zig' --globs '!src/test/**' --report-style short

[doc("Check duplicated package-local server fixtures match")]
[group("check")]
check-fixtures:
    @scripts/check-fixtures.sh

[doc("Run ziglint, excluding vendored cryptox")]
[group("check")]
lint:
    ziglint build.zig examples bench $(fd --extension zig --exclude cryptox . src)

[doc("Check Python conformance tests with ruff and ty")]
[group("check")]
[script("bash")]
check-conformance-python:
    cd conformance
    uv run ruff format --check .
    uv run ruff check .
    uv run ty check .

[doc("Run Wycheproof boundary smoke vectors")]
[group("check")]
wycheproof:
    zig build test-wycheproof
