[doc("Run ztls benchmarks")]
[group("bench")]
bench *args:
    zig build bench -- {{ args }}

[doc("Capture ztls/EVP/libssl/rustls benchmark comparison outputs")]
[group("bench")]
bench-capture *args:
    @scripts/bench-capture.sh {{ args }}

[doc("Analyze a benchmark capture with benchstat")]
[group("bench")]
bench-analyze capture="":
    @scripts/bench-analyze.sh {{ capture }}

[private]
bench-bin:
    zig build bench-bin

[doc("Disassemble the ztls benchmark binary")]
[group("bench")]
bench-disasm: bench-bin
    objdump -d zig-out/bin/benchmark > zig-out/benchmark.asm
    @echo zig-out/benchmark.asm

[doc("Disassemble libcrypto linked by the ztls benchmark binary")]
[group("bench")]
[linux]
bench-disasm-libcrypto: bench-bin
    objdump -d $(ldd zig-out/bin/benchmark | awk '/libcrypto/{print $3; exit}') > zig-out/libcrypto.asm
    @echo zig-out/libcrypto.asm

[doc("Record a perf profile for the ztls benchmark binary")]
[group("bench")]
[linux]
bench-perf *args: bench-bin
    perf record --call-graph dwarf --output zig-out/benchmark.perf.data -- zig-out/bin/benchmark {{ args }}
    @echo zig-out/benchmark.perf.data
