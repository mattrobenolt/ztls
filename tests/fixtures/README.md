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
