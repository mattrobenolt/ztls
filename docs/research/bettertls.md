# bettertls — Coverage Inventory

Source: <https://github.com/Netflix/bettertls>

bettertls exercises X.509 path building and name-constraints enforcement across
TLS implementations. It is structured as a Go harness that loads test-case JSON,
builds certificate chains, and asserts expected policy outcomes.

## What bettertls validates

1. **Name constraints** — permitted/excluded subtrees for DNS, IP, directory,
   rfc822Name/email, and URI name forms.
2. **Path building** — correct selection of intermediates and trust anchors when
   multiple candidates exist.
3. **Critical extension handling** — rejection of unrecognized critical
   extensions is also tested indirectly.

## ztls coverage scope

ztls enforces RFC 5280 Name Constraints during certificate path validation
for the GeneralName forms used by TLS server-auth certificates:

- `dNSName`
- `iPAddress`
- `rfc822Name`
- `uniformResourceIdentifier`

The local coverage intentionally avoids vendoring the full Go bettertls harness
for now. Instead it uses two layers of CI-friendly Zig evidence:

- synthetic DER unit tests for DNS, IP, email, URI, permitted/excluded subtree
  matching, and critical unsupported-subtree rejection;
- OpenSSL-generated chain fixtures under `tests/fixtures/nameconstraints/` for
  real path-validation behavior through `certificate.parse()`.

The chain fixtures model the bettertls core shape without the combinatorial
explosion:

```text
root.crt -> intermediate.crt -> leaf_*.crt
```

`intermediate.crt` carries a critical Name Constraints extension with:

- permitted DNS subtree: `example.com`
- excluded DNS subtree: `bad.example.com`

Covered outcomes:

| Fixture | Leaf SAN | Expected |
|---|---|---|
| `leaf_allowed.der` | `ok.example.com` | accepted |
| `leaf_excluded.der` | `bad.example.com` | rejected by excluded subtree |
| `leaf_outside.der` | `other.test` | rejected by permitted subtree |

## Deliberate non-goals for the local slice

- No full bettertls Go harness yet. If that breadth becomes worth carrying, give
  it a dedicated issue instead of folding it into the core enforcement code.
- No `directoryName` constraint enforcement yet. ztls rejects unsupported
  GeneralName forms in critical Name Constraints instead of pretending to process
  them.
- No combinatorial clone of bettertls's thousands of cases. The local tests
  exercise the matching and chain-validation logic directly; the full harness can
  add breadth later.

## Future harness path

A real bettertls lane should come after the external conformance façade is in
place:

1. vendor or fetch bettertls test vectors reproducibly;
2. add a ztls runner/shim that evaluates the generated chains against
   `certificate.parse()` policy;
3. normalize results with skip accounting, following the TLS-Anvil report shape;
4. gate the lane only once its dependency footprint and runtime are stable.
