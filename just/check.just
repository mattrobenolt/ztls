[doc("Run all tests")]
[group("check")]
test:
    zig build test --summary all

[doc("Format all code")]
[group("check")]
fmt: fmt-zig fmt-actions fmt-conformance

[doc("Check formatting and lint (for CI)")]
[group("check")]
lint: lint-zig lint-actions lint-conformance

[doc("Format Zig code")]
[group("check")]
fmt-zig:
    zig fmt src/ examples/ bench/ build.zig

[group("check")]
lint-zig:
    zig fmt --check src/ examples/ bench/ build.zig
    ziglint build.zig examples bench $(fd --extension zig --exclude cryptox . src)
    ast-grep scan --rule rules/no-ztls-owned-allocations.yml src --globs '*.zig' --globs '!src/test/**' --report-style short

[private]
fmt-conformance:
    just conformance/fmt

[private]
lint-conformance:
    just conformance/lint

[doc("Auto-fix GitHub Actions workflows")]
[group("check")]
fmt-actions:
    pinact run .github/workflows/*.yml

[group("check")]
lint-actions:
    pinact run --fix=false --no-api .github/workflows/*.yml
    zizmor .github
