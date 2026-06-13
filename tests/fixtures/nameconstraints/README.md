# Name constraints fixtures

Generated with OpenSSL for RFC 5280 name-constraints enforcement tests.
Private keys are intentionally not committed; regenerate with the recipe in the
issue #8 implementation history if the certificate validity window ever matters.

Chain shape:

```text
root.crt -> intermediate.crt -> leaf_*.crt
```

`intermediate.crt` carries a critical Name Constraints extension:

- permitted DNS subtree: `example.com`
- excluded DNS subtree: `bad.example.com`

Expected leaves:

- `leaf_allowed.der` (`ok.example.com`) passes.
- `leaf_excluded.der` (`bad.example.com`) fails the excluded subtree.
- `leaf_outside.der` (`other.test`) fails the permitted subtree.
