[doc("Run ztls benchmarks")]
[group("bench")]
bench *args:
    zig build bench -- {{ args }}

[doc("Capture ztls/EVP/libssl/rustls benchmark comparison outputs")]
[group("bench")]
bench-capture *args:
    @scripts/bench-capture.sh {{ args }}

[private]
bench-bin:
    zig build bench-bin

[doc("Disassemble the ztls benchmark binary")]
[group("bench")]
bench-disasm: bench-bin
    objdump -d zig-out/bin/record_protection_bench > zig-out/record_protection_bench.asm
    @echo zig-out/record_protection_bench.asm

[doc("Disassemble libcrypto linked by the ztls benchmark binary")]
[group("bench")]
[linux]
bench-disasm-libcrypto: bench-bin
    objdump -d $(ldd zig-out/bin/record_protection_bench | awk '/libcrypto/{print $3; exit}') > zig-out/libcrypto.asm
    @echo zig-out/libcrypto.asm

[doc("Record a perf profile for the ztls benchmark binary")]
[group("bench")]
[linux]
bench-perf *args: bench-bin
    perf record --call-graph dwarf --output zig-out/record_protection_bench.perf.data -- zig-out/bin/record_protection_bench {{ args }}
    @echo zig-out/record_protection_bench.perf.data
