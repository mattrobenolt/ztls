[private]
default:
    @just --list

[doc("Run unit tests")]
[group("test")]
test:
    zig build test --summary all

[doc("Check GitHub Actions pins")]
[group("test")]
ci-actions:
    pinact run --fix=false --no-api .github/workflows/*.yml
    zizmor .github

[doc("Assert the ztls-owned engine is allocator-free (TODO-28a2091a)")]
[group("test")]
no-alloc:
    ast-grep scan --rule rules/no-ztls-owned-allocations.yml src --globs '*.zig' --globs '!src/test/**' --report-style short

[doc("Run unit, interop, formatting, benchmark smoke, and workflow checks")]
[group("test")]
ci: ci-actions
    zig fmt --check src/ examples/ bench/ build.zig
    just no-alloc
    zig build test
    zig build test-openssl
    zig build test-openssl-server
    zig build test-wycheproof
    just conformance-python
    just tlsfuzzer -q
    zig build bench -- --bench record_encrypt --suite aes_128 --size 1350
    zig build bench-evp -- --bench openssl_evp_reuse_encrypt --suite aes_128 --size 1350
    zig build bench-openssl -- --bench openssl_bio_app_client_to_server --suite aes_128 --size 1350

[doc("Run Wycheproof boundary smoke vectors")]
[group("test")]
wycheproof:
    zig build test-wycheproof

[doc("Check Python conformance tests with ruff and ty")]
[group("test")]
[working-directory("conformance")]
conformance-python:
    uv run ruff format --check .
    uv run ruff check .
    uv run ty check .

[doc("Run tlsfuzzer TLS 1.3 conformance smoke tests")]
[group("test")]
tlsfuzzer *ARGS:
    zig build tlsfuzzer-server
    cd conformance && uv run pytest {{ ARGS }}

[doc("Run strict tlsfuzzer lockstep conversations")]
[group("test")]
tlsfuzzer-lockstep:
    zig build tlsfuzzer-server
    cd conformance && uv run pytest -q -m lockstep

[doc("List ztls, OpenSSL EVP, OpenSSL memory-BIO, and rustls benchmark rows")]
[group("bench")]
bench-list:
    zig build bench -- --list
    zig build bench-evp -- --list
    zig build bench-openssl -- --list
    zig build bench-rustls -- --list

[doc("Run comparable ztls, OpenSSL EVP, OpenSSL memory-BIO, and rustls benchmark rows")]
[group("bench")]
bench-compare FILTER="aes_128":
    zig build bench -- --filter {{ FILTER }}
    zig build bench-evp -- --filter {{ FILTER }}
    zig build bench-openssl -- --filter {{ FILTER }}
    zig build bench-rustls -- --filter {{ FILTER }}

[doc("Run one exact app-data row for ztls and OpenSSL memory BIO")]
[group("bench")]
bench-app-row SUITE="aes_128" SIZE="1350":
    zig build bench -- --bench ztls_app_client_to_server --suite {{ SUITE }} --size {{ SIZE }}
    zig build bench -- --bench ztls_app_prepared_client_to_server --suite {{ SUITE }} --size {{ SIZE }}
    zig build bench-openssl -- --bench openssl_bio_app_client_to_server --suite {{ SUITE }} --size {{ SIZE }}

[doc("Run one exact record-crypto row for ztls and OpenSSL EVP reuse")]
[group("bench")]
bench-record-row SUITE="aes_128" SIZE="1350":
    zig build bench -- --bench record_encrypt --suite {{ SUITE }} --size {{ SIZE }}
    zig build bench -- --bench record_encrypt_prepared --suite {{ SUITE }} --size {{ SIZE }}
    zig build bench-evp -- --bench openssl_evp_reuse_encrypt --suite {{ SUITE }} --size {{ SIZE }}

[doc("Rank measured ztls handshake split rows by elapsed time")]
[group("bench")]
bench-handshake-hotspots SUITE="aes_128" OUT="":
    scripts/handshake-hotspots.sh {{ SUITE }} {{ OUT }}

[doc("Run full benchmark comparison set into zig-out/perf")]
[group("bench")]
bench-capture:
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p zig-out/perf
    stamp=$(date +%Y%m%d-%H%M%S)
    zig build bench > "zig-out/perf/ztls-all-${stamp}.csv"
    zig build bench-evp > "zig-out/perf/evp-all-${stamp}.csv"
    zig build bench-openssl > "zig-out/perf/bio-all-${stamp}.csv"
    zig build bench-rustls > "zig-out/perf/rustls-all-${stamp}.csv"
    echo "${stamp}"

[doc("Analyze captured ztls/OpenSSL benchmark CSVs")]
[group("bench")]
bench-analyze *ARGS:
    nu scripts/analyze-bench.nu {{ ARGS }}

[doc("Build benchmark binaries used for perf, callgrind, and disassembly")]
[group("bench")]
bench-bins:
    zig build bench-bin bench-evp-bin bench-openssl-bin bench-rustls-bin

[doc("Disassemble an installed benchmark binary to a file")]
[group("bench")]
bench-disasm BIN="record_protection_bench" OUT="zig-out/{{ BIN }}.asm": bench-bins
    objdump -d zig-out/bin/{{ BIN }} > {{ OUT }}
    @echo {{ OUT }}

[doc("Disassemble the libcrypto linked by an installed benchmark binary")]
[group("bench")]
[linux]
bench-disasm-libcrypto BIN="record_protection_bench" OUT="zig-out/libcrypto.asm": bench-bins
    objdump -d $(ldd zig-out/bin/{{ BIN }} | awk '/libcrypto/{print $3; exit}') > {{ OUT }}
    @echo {{ OUT }}

[doc("Record a perf profile for an installed benchmark binary")]
[group("bench")]
[linux]
bench-perf BIN="record_protection_bench" *ARGS: bench-bins
    perf record --call-graph dwarf --output zig-out/{{ BIN }}.perf.data -- zig-out/bin/{{ BIN }} {{ ARGS }}
    @echo zig-out/{{ BIN }}.perf.data

[doc("Run example program")]
[group("demo")]
example EXAMPLE *ARGS:
    zig build example-{{ EXAMPLE }} -- {{ ARGS }}

[doc("Generate test key and self-signed ECDSA P-256 certificate")]
[group("fixtures")]
gen-cert:
    mkdir -p tests/fixtures
    openssl req -x509 -newkey ec \
        -pkeyopt ec_paramgen_curve:P-256 \
        -keyout tests/fixtures/server.key \
        -out tests/fixtures/server.crt \
        -days 3650 \
        -nodes \
        -subj "/CN=test.local" \
        -sha256
    openssl x509 -in tests/fixtures/server.crt -outform DER -out tests/fixtures/server.crt.der

[doc("Generate TLS 1.3 CertificateVerify content and sign it with the test key")]
[group("fixtures")]
gen-cv-sig: gen-cert
    #!/usr/bin/env python3
    import hashlib, pathlib, subprocess

    transcript_hash = hashlib.sha256(b"test transcript").digest()
    content = b" " * 64 + b"TLS 1.3, server CertificateVerify\x00" + transcript_hash
    content_file = pathlib.Path("tests/fixtures/cv_content.bin")
    content_file.write_bytes(content)

    subprocess.run([
        "openssl", "dgst", "-sha256",
        "-sign", "tests/fixtures/server.key",
        "-out", "tests/fixtures/cv.sig",
        str(content_file),
    ], check=True)

[doc("Generate all test fixtures")]
[group("fixtures")]
gen-fixtures: gen-cert gen-cv-sig
