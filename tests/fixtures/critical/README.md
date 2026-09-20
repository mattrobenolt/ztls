# Certificate extension fixtures

These signed P-256 fixtures exercise RFC 5280 sections 4.2 and 4.2.1.6 (#122).
The root is a trust anchor. All leaves contain both TLS authentication usages.
The tests use timestamp `1800000000` and hostname `critical.test`.

| Fixture | Extension content |
|---|---|
| `valid` | Supported critical Basic Constraints and Key Usage |
| `ignored` | Non-critical Netscape Comment |
| `critical` | Critical Netscape Comment, which ztls does not process |
| `san_application` | Application-class GeneralNames wrapper |
| `san_context` | Context-specific GeneralNames wrapper |
| `san_private` | Private-class GeneralNames wrapper |
| `san_set` | Universal SET wrapper instead of SEQUENCE |
| `san_primitive` | Primitive SEQUENCE wrapper instead of constructed SEQUENCE |

The DER certificates reside in `../fixtures.txtar` under `extension_*_der`.
The public certificate tests cover both authentication roles for critical-extension policy.
Hostname tests cover all five malformed SAN wrappers.

`openssl-results.json` contains the reference commands and raw OpenSSL verdicts.
OpenSSL 3.6.4 accepts the primitive SEQUENCE wrapper. ztls requires the constructed GeneralNames encoding.
The malformed-SAN client-auth results are reference controls, not comparisons against ztls client-auth behavior.

## Regeneration

Run the generator in a private output directory:

```sh
bash tests/fixtures/critical/generate.sh /tmp/ztls-extension-fixtures
```

Replace the corresponding base64 sections in `../fixtures.txtar`.
Replace `root.crt` with the generated root.
Repeat the reference commands with the replacement certificates.
Keep generated private keys outside the repository.
