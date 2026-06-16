# ztls test fixtures

These files are public test fixtures, not production credentials or trust anchors.
Private keys and scalars under this directory are intentionally committed only so
unit tests, examples, and conformance harnesses are reproducible.

Binary DER, signature, and scalar blobs are committed as text fixtures in
`*_fixtures.zig` modules. Do not commit new `.der`, `.bin`, or `.sig` files;
`just lint-fixtures` rejects them.
