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
    # DER-encoded certificate for embedding in tests
    openssl x509 -in tests/fixtures/server.crt -outform DER -out tests/fixtures/server.crt.der
    # Sign the TLS 1.3 CertificateVerify content with a known transcript hash
    # Transcript hash = SHA-256("test transcript")
    python3 -c "\
        import hashlib; \
        transcript = hashlib.sha256(b'test transcript').digest(); \
        content = b' ' * 64 + b'TLS 1.3, server CertificateVerify\x00' + transcript; \
        open('/tmp/tls_cv_content.bin', 'wb').write(content)"
    openssl dgst -sha256 -sign tests/fixtures/server.key \
        -out tests/fixtures/cv.sig /tmp/tls_cv_content.bin
    @echo "Generated tests/fixtures/server.{crt,crt.der,key} and cv.sig"
