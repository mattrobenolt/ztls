conformance_dir := "conformance"

# Build the tlsfuzzer server shim. Shared dep of tlsfuzzer, tlsfuzzer-lockstep, and anvil-server.
[private]
build-tlsfuzzer-server:
    zig build tlsfuzzer-server

# Build the TLS-Anvil client shim. Shared dep of anvil-client.
[private]
build-tls-anvil-client:
    zig build tls-anvil-client

[doc("Run tlsfuzzer TLS 1.3 conformance smoke tests")]
[group("conformance")]
tlsfuzzer *args: build-tlsfuzzer-server
    cd {{ conformance_dir }} && uv run pytest {{ args }}

[doc("Run strict tlsfuzzer lockstep conversations")]
[group("conformance")]
tlsfuzzer-lockstep: build-tlsfuzzer-server
    cd {{ conformance_dir }} && uv run pytest -q -m lockstep

[doc("Download TLS-Anvil release JAR and dependencies")]
[group("conformance")]
anvil-fetch:
    @scripts/anvil-fetch.sh

[doc("Run TLS-Anvil server tests")]
[group("conformance")]
anvil-server: anvil-fetch build-tlsfuzzer-server
    cd {{ conformance_dir }} && ./run_anvil_server.py

[doc("Run TLS-Anvil client tests")]
[group("conformance")]
anvil-client: anvil-fetch build-tls-anvil-client
    cd {{ conformance_dir }} && ./run_anvil_client.py

[doc("Clone BoringSSL and build the BoGo runner")]
[group("conformance")]
bogo-fetch:
    @scripts/bogo-fetch.sh

[doc("Run BoGo tests against the ztls shim")]
[group("conformance")]
bogo: bogo-fetch
    zig build bogo-shim
    {{ conformance_dir }}/run_bogo.sh

[doc("Generate test key and self-signed ECDSA P-256 certificate")]
[group("fixtures")]
gen-cert:
    @scripts/gen-cert.sh

[doc("Generate TLS 1.3 CertificateVerify content and sign it with the test key")]
[group("fixtures")]
gen-cv-sig: gen-cert
    @scripts/gen-cv-sig.py

[doc("Generate all test fixtures")]
[group("fixtures")]
gen-fixtures: gen-cert gen-cv-sig

[doc("Run example program")]
[group("examples")]
example example *args:
    zig build example-{{ example }} -- {{ args }}
