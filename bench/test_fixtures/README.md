# benchmark fixtures

`openssl_replay.txtar` contains server records captured from OpenSSL `s_server`
for the three mandatory TLS 1.3 cipher suites. The ztls client side is fixed
(RFC 8448 X25519 keypair, RFC 8448 ClientHello random, SNI `localhost`), while
OpenSSL supplies fresh server randomness and key shares at generation time.

Regenerate with:

```sh
zig build generate-replay-fixtures > bench/test_fixtures/openssl_replay.txtar
```

The archive intentionally stores base64 text entries rather than loose opaque
binaries. These fixtures are benchmark/conformance inputs, not library data.
