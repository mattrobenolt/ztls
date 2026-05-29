[private]
default:
    @just --list

[doc("Generate test certificate fixtures (ECDSA P-256, self-signed, valid 10 years)")]
[group("fixtures")]
gen-fixtures:
    mkdir -p tests/fixtures
    openssl req -x509 -newkey ec \
        -pkeyopt ec_paramgen_curve:P-256 \
        -keyout tests/fixtures/server.key \
        -out tests/fixtures/server.crt \
        -days 3650 \
        -nodes \
        -subj "/CN=test.local" \
        -sha256
