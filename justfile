# Taxonomy
# --------
# build:   zig build handles Zig compilation, linking, and module creation.
#          Never add recipes that compile Zig code — that's build.zig's job.
# check:   fast local gates: unit tests and lint. Every CI gate lives here.
# interop: ztls against ground-truth peers (OpenSSL s_client/s_server).
#          Invoked via zig build test-openssl / test-openssl-server.
# conformance: external suite façade — tlsfuzzer, TLS-Anvil, BoGo.
#          Shim executables are built in zig build; just runs the suites.
# bench:   benchmark execution, capture, comparison, profiling, disasm.
# examples: human-facing example runs. Exercises the Sans-I/O API.
# scripts: standalone automation in scripts/. just recipes call them;
#          never embed shell/Python in the justfile.
# tools:   fetch/build third-party tools not already in the devshell.
#          These live under scripts/ or are system commands.

set lazy

import 'just/check.just'
import 'just/bench.just'

[doc("Show available recipes")]
[private]
default:
    @just --list

[doc("Run example program")]
[group("examples")]
example example *args:
    zig build example-{{ example }} -- {{ args }}

[doc("Run all CI gates")]
ci: test lint
    zig build test-openssl
    zig build test-openssl-server
    just conformance/tlsfuzzer -v
    zig build bench -- --filter RecordEncrypt/{{ bench_suite }}/{{ bench_size }}
    zig build bench-evp -- --filter Encrypt/{{ bench_suite }}/{{ bench_size }}
    zig build bench-openssl -- --filter BioAppClientToServer/{{ bench_suite }}/{{ bench_size }}
