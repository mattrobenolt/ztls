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

[doc("Run unit, interop, formatting, benchmark smoke, and workflow checks")]
[group("test")]
ci: ci-actions
    zig fmt --check src/ examples/ bench/ build.zig
    zig build test
    zig build test-openssl
    zig build test-openssl-server
    zig build bench -- --filter record_encrypt --filter aes_128
    zig build bench-evp -- --filter aes_128
    zig build bench-openssl -- --filter aes_128

[doc("List ztls, OpenSSL EVP, and OpenSSL memory-BIO benchmark rows")]
[group("bench")]
bench-list:
    zig build bench -- --list
    zig build bench-evp -- --list
    zig build bench-openssl -- --list

[doc("Run comparable ztls, OpenSSL EVP, and OpenSSL memory-BIO benchmark rows")]
[group("bench")]
bench-compare FILTER="aes_128":
    zig build bench -- --filter {{ FILTER }}
    zig build bench-evp -- --filter {{ FILTER }}
    zig build bench-openssl -- --filter {{ FILTER }}

[doc("Build benchmark binaries used for perf, callgrind, and disassembly")]
[group("bench")]
bench-bins:
    zig build bench-bin bench-evp-bin bench-openssl-bin

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
