bench_suite := "TLS_AES_128_GCM_SHA256"
bench_size := "1350"
bench_filter := "Encrypt"
bench_bin := "record_protection_bench"

[doc("List ztls, OpenSSL EVP, OpenSSL memory-BIO, and rustls benchmark rows")]
[group("bench")]
bench-list:
    zig build bench -- --filter ".*"
    zig build bench-evp -- --filter ".*"
    zig build bench-openssl -- --filter ".*"
    zig build bench-rustls -- --list

[doc("Run comparable ztls, OpenSSL EVP, OpenSSL memory-BIO, and rustls benchmark rows")]
[group("bench")]
bench-compare filter=bench_filter:
    zig build bench -- --filter {{ filter }}
    zig build bench-evp -- --filter {{ filter }}
    zig build bench-openssl -- --filter {{ filter }}
    zig build bench-rustls -- --filter {{ filter }}

[doc("Run one exact app-data row for ztls and OpenSSL memory BIO")]
[group("bench")]
bench-app-row suite=bench_suite size=bench_size:
    zig build bench -- --filter AppClientToServer/{{ suite }}/{{ size }}
    zig build bench -- --filter AppPreparedClientToServer/{{ suite }}/{{ size }}
    zig build bench-openssl -- --filter BioAppClientToServer/{{ suite }}/{{ size }}

[doc("Run one exact record-crypto row for ztls and OpenSSL EVP reuse")]
[group("bench")]
bench-record-row suite=bench_suite size=bench_size:
    zig build bench -- --filter RecordEncrypt/{{ suite }}/{{ size }}
    zig build bench -- --filter RecordEncryptPrepared/{{ suite }}/{{ size }}
    zig build bench-evp -- --filter Encrypt/{{ suite }}/{{ size }}

[doc("Run full benchmark comparison set into zig-out/perf")]
[group("bench")]
bench-capture:
    @scripts/bench-capture.sh

[doc("Compare benchmark captures with benchstat")]
[group("bench")]
benchstat a b:
    benchstat {{ a }} {{ b }}

[doc("Build benchmark binaries used for perf, callgrind, and disassembly")]
[group("bench")]
bench-bins:
    zig build bench-bin bench-evp-bin bench-openssl-bin bench-rustls-bin

[doc("Disassemble an installed benchmark binary to a file")]
[group("bench")]
bench-disasm bin=bench_bin out=f"zig-out/{{bin}}.asm": bench-bins
    objdump -d zig-out/bin/{{ bin }} > {{ out }}
    @echo {{ out }}

[doc("Disassemble the libcrypto linked by an installed benchmark binary")]
[group("bench")]
[linux]
bench-disasm-libcrypto bin=bench_bin out="zig-out/libcrypto.asm": bench-bins
    objdump -d $(ldd zig-out/bin/{{ bin }} | awk '/libcrypto/{print $3; exit}') > {{ out }}
    @echo {{ out }}

[doc("Record a perf profile for an installed benchmark binary")]
[group("bench")]
[linux]
bench-perf bin=bench_bin *args: bench-bins
    perf record --call-graph dwarf --output zig-out/{{ bin }}.perf.data -- zig-out/bin/{{ bin }} {{ args }}
    @echo zig-out/{{ bin }}.perf.data
