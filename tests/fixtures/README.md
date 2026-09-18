# ztls test fixtures

These files are public test fixtures, not production credentials or trust anchors.
Private keys and scalars under this directory are intentionally committed only so
unit tests, examples, and conformance harnesses are reproducible.

## Layout

- `fixtures.zig` — the single build module. It `@embedFile`s the
  `fixtures.txtar` archive and the `rfc8448.txtar` and `openssl_replay.txtar`
  archives, then base64-decodes each named txtar section at comptime to
  produce typed slices (e.g. `server_ecdsa_cert_der`, `server_ecdsa_scalar`,
  `cv_sig`, `chain_leaf_der`, `name_constraints_der`, `rsa_pss.*`,
  `ed25519.*`). Nothing else in the repo should construct a fixture key,
  certificate, or scalar by hand; tests, examples, and conformance code
  consume this module.
- `fixtures.txtar` — the txtar archive holding every DER, scalar, and PEM
  fixture section as base64 between `-- name --` delimiters. The archive is
  compiled away at build time; the bytes never appear as a tracked binary
  file. Add a new section there alongside the matching `@embedFile`/extractor
  in `fixtures.zig` when a fixture family needs more binary data.
- `rfc8448.txtar`, `openssl_replay.txtar` — separate txtar archives for the
  RFC 8448 §3 / §5 handshake transcripts and the IEEE/CA Forum
  `openssl-replay` TLS 1.3 handshake capture. Both are `@embedFile`-d as raw
  txtar slices and consumed by analyzers/diff tools; the per-record base64
  pairs inside are decoded lazily.
- Loose PEM files (`server.crt`, `server.key`) live at the top of the
  fixtures directory for examples and interop harnesses that need an actual
  PEM-encoded identity on disk at runtime — e.g. `openssl s_server` and any
  code path that calls `addCertsFromFilePath` or parses PEM from stdio.
  These are fixture material, not trust anchors or production credentials.
- Per-feature subdirectories (e.g. `chain/`, `ed25519/`, `nameconstraints/`,
  `rsa_pss/`, `server-ecdsa/`) each carry their own `README.md` describing
  the cert/key shape, the cryptanalysis it covers, and the relevant issue
  reference. Add a subdirectory + README when a fixture family needs its own
  provenance note.

## Key-scheme inference and pairing fixtures (#112/#113)

The key PEM sections in `fixtures.txtar` (`rsa_pkcs1_key_pem`,
`ec_p256_key_pem`, `ec_p384_key_pem`, `ec_p521_key_pem`, `ed25519_key_pem`,
`ec_secp224r1_key_pem`) drive `PrivateKey.fromPemAuto` scheme inference and
`PrivateKey.pairsWith` load-time pairing tests. All are public test fixtures,
not credentials. `ec_p256_key_pem` is the existing loose `server.key`
(PKCS#8, pairs with `server_cert_der`); `rsa_pkcs1_key_pem` is the
traditional-container form of `rsa_pss_key_pem`'s key. Regenerate the
throwaway keys with:

```sh
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:secp384r1
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:secp521r1
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:secp224r1
openssl genpkey -algorithm ed25519
openssl pkey -in rsa_pss/server.key -traditional   # PKCS#1 form of that key
```

Paste each output as a raw `-- name --` section in `fixtures.txtar` (no
base64, same as `rsa_pss_key_pem`) and keep the matching `rawSection`
extractor in `fixtures.zig` in the same change.

## Encrypted PEM fixtures (#114)

`rsa_pss_key_encrypted_pkcs8_pem` and `rsa_pss_key_encrypted_legacy_pem` are
encrypted forms of `rsa_pss_key_pem` — the same RSA key that pairs with
`rsa_pss_cert_der` — under passphrase `ztls-fixture-passphrase`. The loaders
take no password input, so these fixtures must fail at load without prompting
or reading stdin, and `zig build encrypted-pem-check` runs them against both a
stdin pipe and a PTY to prove that. Public test material, not credentials; the
passphrase is in this file so the fixtures stay reproducible:

```sh
# rsa_pss_key_pem as a loose file, then
openssl pkcs8 -topk8 -in rsa_pss_key.pem -out encrypted_pkcs8.pem \
    -v2 aes-256-cbc -iter 2048 -saltlen 16 -passout pass:ztls-fixture-passphrase
openssl rsa -in rsa_pss_key.pem -traditional -aes256 -out encrypted_legacy.pem \
    -passout pass:ztls-fixture-passphrase
```

The PKCS#8 form (`ENCRYPTED PRIVATE KEY`, PBES2) and the legacy form
(`Proc-Type: 4,ENCRYPTED` / `DEK-Info: AES-256-CBC,…`) decode through
different libcrypto paths, so both containers are pinned. Verify a regenerated
fixture decrypts back to the plaintext key with
`openssl pkey -in encrypted_pkcs8.pem -passin pass:ztls-fixture-passphrase`.

## Guardrails

- `just lint-fixtures` rejects tracked `.der`, `.bin`, and `.sig` files under
  this directory. New binary data goes into `fixtures.txtar` (or a sibling
  `*.txtar`) as a base64 section paired with an extractor in `fixtures.zig`,
  so the bytes are available at comptime without paying a runtime allocation
  and never appear as a tracked binary file.
- Rename a fixture in `fixtures.zig` and the matching `-- name --` section
  in `fixtures.txtar` in the same change so comptime section lookup can
  resolve.
- Treat PEM files (`server.crt`, `server.key`) as fixture material, not as
  trust anchors or production credentials.
