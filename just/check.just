[doc("Run all tests")]
[group("check")]
test:
    zig build test --summary all

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
lint: lint-zig lint-actions lint-just
    just conformance/lint

[doc("Format Zig code")]
[group("check")]
fmt-zig:
    zig fmt src/ examples/ bench/ build.zig

[group("check")]
lint-zig:
    zig fmt --check src/ examples/ bench/ build.zig
    ziglint build.zig examples bench $(fd --extension zig --exclude cryptox . src)
    ast-grep scan --rule rules/no-ztls-owned-allocations.yml src --globs '*.zig' --globs '!src/test/**' --globs '!src/bench/**' --globs '!src/interop.zig' --report-style short

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
