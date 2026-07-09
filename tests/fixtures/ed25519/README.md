# Ed25519 certificate fixture

Self-signed Ed25519 server certificate for testing Ed25519 certificate-chain
signature verification (RFC 8446 §4.4.2.2). The chain signature algorithm
(Ed25519, OID 1.3.101.112) is verified via `std.crypto.sign.Ed25519` in
`certificate_parser.zig`, independent of the CertificateVerify backend seam.

Subject/SAN:

```text
CN=ed25519.server.test
DNS:ed25519.server.test
```

Regenerate:

```sh
openssl req -x509 -newkey ed25519 -nodes -keyout server.key -out server.crt \
  -sha256 -days 3650 -subj '/CN=ed25519.server.test' \
  -addext 'basicConstraints=critical,CA:FALSE' \
  -addext 'keyUsage=critical,digitalSignature' \
  -addext 'extendedKeyUsage=serverAuth' \
  -addext 'subjectAltName=DNS:ed25519.server.test'
openssl x509 -in server.crt -outform DER -out server.der
```

The private key is committed because this is a public test fixture, not a
trust anchor or production credential.
