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
ci: test check-backend-aws-lc lint examples-ci
    just conformance/ci

[doc("Run core library checks under Zig 0.16 (test + examples + conformance; lint stays on 0.15 due to 0.16 deprecation noise)")]
[group("check")]
ci-0_16: test examples-ci
    just conformance/ci
