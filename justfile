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

# ztls is Zig 0.16-only. This is the single CI lane.
[doc("Run all CI gates")]
ci: test check-backend-aws-lc check-backends check-fips-builds lint consumer-gate-selftest examples-ci capi-ci distribution-ci integrations-ci
    if [ "$(uname -s)" = Linux ]; then just check-memory; fi
    just conformance/ci

[doc("Remove local scratch directories (.tmp/, book/, zig-out/)")]
clean:
    rm -rf .tmp book zig-out
    just conformance/clean
