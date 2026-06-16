# RSA-PSS fixture

Self-signed RSA-2048 certificate and private key for TLS 1.3 RSA-PSS
CertificateVerify tests. The private key is a public test fixture, not a
production credential.

Regenerate from the repository root with:

```sh
scripts/gen-fixtures.sh
```

The script writes the certificate DER and CertificateVerify signatures into text
fixture modules rather than committing `.der` or `.sig` blobs.
