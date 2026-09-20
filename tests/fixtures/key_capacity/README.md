# Public-key retention fixtures

The leaf contains a real RSA-8192 key. Its PKCS#1 public key occupies 1,038 bytes, above the engine's 1,024-byte retention capacity.
A P-256 root signs the leaf. The leaf permits server and client authentication for `capacity.test`.

`fixtures.txtar` contains both DER certificates as base64 sections. The generator creates fresh test keys and certificates.
Regeneration changes the bytes. No private key enters the committed fixtures.
The tests use the fixed timestamp 1790000000, which is 2026-09-21 14:13:20 UTC.

OpenSSL 3.6.4 accepted the chain for both TLS roles on 2026-09-20.
The server-role check also verified `capacity.test`. These verdicts establish fixture validity, not support for oversized keys in ztls.

## Generation

Run the generator in the Nix development shell:

```sh
bash tests/fixtures/key_capacity/generate.sh /tmp/ztls-key-capacity
```

Encode `root.der` into the `key_capacity_root_der` section of `tests/fixtures/fixtures.txtar`.
Encode `leaf.der` into the `key_capacity_leaf_der` section of `tests/fixtures/fixtures.txtar`.
Update `key_capacity_time` to a timestamp within both certificates' validity intervals.
Keep generated DER files outside the repository.

The public-path tests cite #124. They check chain validation before the retention-capacity refusal.
