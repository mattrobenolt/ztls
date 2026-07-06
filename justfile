# Root justfile: workspace-level entrypoints only.
# Domain subprojects own their local workflows; root delegates to them.

import 'just/check.just'
import 'just/bench.just'
import 'just/brand.just'

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
