set lazy

fmt_paths := "src/ examples/ bench/ build.zig"
conformance_dir := "conformance"

bench_suite := "aes_128"
bench_size := "1350"
bench_filter := "aes_128"
bench_bin := "record_protection_bench"

anvil_version := "1.5.0"
anvil_dir := "zig-out/tools/tls-anvil"
anvil_zip := f"{{anvil_dir}}/TLS-Anvil-v{{anvil_version}}.zip"
anvil_url := f"https://github.com/tls-attacker/TLS-Anvil/releases/download/v{{anvil_version}}/TLS-Anvil-v{{anvil_version}}.zip"

bogo_dir := "zig-out/tools/boringssl"

[doc("Show available recipes")]
[private]
default:
    @just --list

[doc("Run unit tests")]
[group("check")]
test:
    zig build test --summary all

[doc("Check GitHub Actions pins and workflow lint")]
[group("check")]
check-actions:
    pinact run --fix=false --no-api .github/workflows/*.yml
    zizmor .github

[doc("Assert the ztls-owned engine is allocator-free")]
[group("check")]
check-no-alloc:
    ast-grep scan --rule rules/no-ztls-owned-allocations.yml src --globs '*.zig' --globs '!src/test/**' --report-style short

[doc("Run ziglint, excluding vendored cryptox")]
[group("check")]
lint:
    ziglint build.zig examples bench $(fd --extension zig --exclude cryptox . src)

[doc("Check Python conformance tests with ruff and ty")]
[group("check")]
[working-directory("conformance")]
check-conformance-python:
    uv run ruff format --check .
    uv run ruff check .
    uv run ty check .

[doc("Run unit, interop, formatting, benchmark smoke, and workflow checks")]
[group("check")]
ci: check-actions lint check-no-alloc check-conformance-python
    zig fmt --check {{ fmt_paths }}
    zig build test
    zig build test-openssl
    zig build test-openssl-server
    zig build test-wycheproof
    just tlsfuzzer -q
    zig build bench -- --bench record_encrypt --suite {{ bench_suite }} --size {{ bench_size }}
    zig build bench-evp -- --bench openssl_evp_reuse_encrypt --suite {{ bench_suite }} --size {{ bench_size }}
    zig build bench-openssl -- --bench openssl_bio_app_client_to_server --suite {{ bench_suite }} --size {{ bench_size }}

[doc("Run Wycheproof boundary smoke vectors")]
[group("check")]
wycheproof:
    zig build test-wycheproof

[doc("Run tlsfuzzer TLS 1.3 conformance smoke tests")]
[group("conformance")]
[working-directory("conformance")]
tlsfuzzer *args: build-tlsfuzzer-server
    uv run pytest {{ args }}

[doc("Run strict tlsfuzzer lockstep conversations")]
[group("conformance")]
[working-directory("conformance")]
tlsfuzzer-lockstep: build-tlsfuzzer-server
    uv run pytest -q -m lockstep

[doc("Download TLS-Anvil release JAR and dependencies")]
[group("conformance")]
[script("bash")]
anvil-fetch:
    set -euo pipefail

    mkdir -p {{ anvil_dir }}
    if [[ -f {{ anvil_dir }}/apps/TLS-Anvil.jar ]]; then
        echo "TLS-Anvil already fetched"
        exit 0
    fi

    curl -sL -o {{ anvil_zip }} {{ anvil_url }}
    uv run --script - <<'PY'
    # /// script
    # requires-python = ">=3.14"
    # dependencies = []
    # ///
    import zipfile

    with zipfile.ZipFile('{{ anvil_zip }}') as archive:
        archive.extractall('{{ anvil_dir }}/')
    PY
    @echo "TLS-Anvil fetched to {{ anvil_dir }}/"

[doc("Run TLS-Anvil server tests")]
[group("conformance")]
[working-directory("conformance")]
anvil-server: anvil-fetch build-tlsfuzzer-server
    ./run_anvil_server.py

[doc("Run TLS-Anvil client tests")]
[group("conformance")]
[working-directory("conformance")]
anvil-client: anvil-fetch build-tls-anvil-client
    ./run_anvil_client.py

[doc("Clone BoringSSL and build the BoGo runner")]
[group("conformance")]
bogo-fetch: bogo-clone bogo-build-runner

[doc("Run BoGo tests against the ztls shim")]
[group("conformance")]
bogo: bogo-fetch
    zig build bogo-shim
    {{ conformance_dir }}/run_bogo.sh

[doc("List ztls, OpenSSL EVP, OpenSSL memory-BIO, and rustls benchmark rows")]
[group("bench")]
bench-list:
    zig build bench -- --list
    zig build bench-evp -- --list
    zig build bench-openssl -- --list
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
    zig build bench -- --bench ztls_app_client_to_server --suite {{ suite }} --size {{ size }}
    zig build bench -- --bench ztls_app_prepared_client_to_server --suite {{ suite }} --size {{ size }}
    zig build bench-openssl -- --bench openssl_bio_app_client_to_server --suite {{ suite }} --size {{ size }}

[doc("Run one exact record-crypto row for ztls and OpenSSL EVP reuse")]
[group("bench")]
bench-record-row suite=bench_suite size=bench_size:
    zig build bench -- --bench record_encrypt --suite {{ suite }} --size {{ size }}
    zig build bench -- --bench record_encrypt_prepared --suite {{ suite }} --size {{ size }}
    zig build bench-evp -- --bench openssl_evp_reuse_encrypt --suite {{ suite }} --size {{ size }}

[doc("Rank measured ztls handshake split rows by elapsed time")]
[group("bench")]
bench-handshake-hotspots suite=bench_suite out="":
    scripts/handshake-hotspots.sh {{ suite }} {{ out }}

[doc("Run full benchmark comparison set into zig-out/perf")]
[group("bench")]
[script("bash")]
bench-capture:
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
bench-analyze *args:
    nu scripts/analyze-bench.nu {{ args }}

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

[doc("Run example program")]
[group("demo")]
example example *args:
    zig build example-{{ example }} -- {{ args }}

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
    #!/usr/bin/env -S uv run --script
    # /// script
    # requires-python = ">=3.14"
    # dependencies = []
    # ///
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

[doc("Build the tlsfuzzer server shim")]
[private]
build-tlsfuzzer-server:
    zig build tlsfuzzer-server

[doc("Build the TLS-Anvil client shim")]
[private]
build-tls-anvil-client:
    zig build tls-anvil-client

[doc("Clone BoringSSL if it is not already present")]
[private]
[script("bash")]
bogo-clone:
    set -euo pipefail

    mkdir -p zig-out/tools
    if [[ ! -d {{ bogo_dir }} ]]; then
        git clone --depth 1 https://github.com/google/boringssl.git {{ bogo_dir }}
    fi

[doc("Build the BoGo runner")]
[private]
[working-directory("zig-out/tools/boringssl/ssl/test/runner")]
bogo-build-runner:
    go build -o runner .
