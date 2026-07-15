# Root justfile: workspace-level entrypoints only.
# Domain subprojects own their local workflows; root delegates to them.

import 'just/check.just'
import 'just/bench.just'
import 'just/brand.just'
import 'just/docs.just'

[doc("Show available recipes")]
[private]
default:
    @just --list

[doc("Run example program")]
[group("examples")]
example example *args:
    zig build example-{{ example }} -- {{ args }}

[doc("Run all CI gates")]
ci: test check-backend-aws-lc lint examples-ci capi-ci
    just conformance/ci

[doc("Run all CI gates under Zig 0.16 (lint via inline Z011 suppressions for dual-version deprecations)")]
[group("check")]
ci-0_16: test lint examples-ci
    just conformance/ci

[doc("Remove local scratch directories (.tmp/, book/, zig-out/)")]
clean:
    rm -rf .tmp book zig-out
    just conformance/clean
