# bettertls — Coverage Inventory

Source: <https://github.com/Netflix/bettertls>

bettertls exercises X.509 path building and name constraints enforcement
across TLS implementations. It is structured as a Go harness that loads
test-case JSON, builds certificate chains, and asserts expected policy
outcomes (accept/reject).

## What bettertls validates

1. **Name constraints** — permitted/excluded subtrees for DNS, IP, directory,
   and URI name forms.
2. **Path building** — correct selection of intermediates and trust anchors
   when multiple candidates exist.
3. **Critical extension handling** — rejection of unrecognized critical
   extensions is also tested indirectly.

## Current ztls status

| Feature | Status | Notes |
|---------|--------|-------|
| Name Constraints parsing | Partial | Extension value is extracted during DER parse (`Parsed.nameConstraints`). Inner structure (permittedSubtrees, excludedSubtrees, GeneralSubtree) is not yet parsed. |
| Name Constraints enforcement | Not implemented | Chain validation (`certificate.zig`) does not intersect leaf/intermediate names against CA subtrees. |
| Path building | Partial | ztls walks the chain linearly and anchors to a caller-provided `Bundle`. It does not backtrack or try alternate paths. |
| DNS name constraints | Not implemented | No name-matching logic for `dNSName` subtrees. |
| IP address constraints | Not implemented | No `iPAddress` subtree matching. |
| Directory/URI constraints | Not implemented | Not relevant for TLS server auth; low priority. |

## Why enforcement is deferred

- The `cryptox/Certificate.zig` parser is vendored from Zig stdlib with local
  DER bounds fixes. Adding full GeneralName parsing and subtree matching is
  invasive and needs careful RFC 5280 compliance before it can claim
  correctness.
- ztls chain validation is linear (`subject.verify(issuer, now_sec)`). Name
  constraints require checking *every* CA in the chain against the leaf and
  all subordinate names, which needs a small API redesign.
- No existing caller requires name constraints yet; leaf hostname verification,
  EKU, and KeyUsage policy are the active paths.

## Pre-integration checklist (before adding a harness)

- [ ] Parse GeneralName subtypes inside Name Constraints (`dNSName`, `iPAddress`).
- [ ] Implement DNS name matching against permitted/excluded subtrees.
- [ ] Implement IP address matching (address + netmask parsing).
- [ ] Wire subtree checks into `certificate.zig` chain validation.
- [ ] Generate synthetic test chains (or vendor bettertls test JSON) for Zig
      unit tests.
- [ ] Add `zig build test-bettertls` step that runs the Go harness against a
      ztls shim.

## Smallest next slice (when needed)

1. Parse the `NameConstraints` SEQUENCE into `permitted` / `excluded` slices.
2. Add a `verifyNameConstraints(host_name)` helper that checks only DNS
   permitted/excluded subtrees against the leaf SAN/CN.
3. Unit-test with synthetic DER (no full bettertls harness yet).
4. Only after unit tests pass, wire the check into `certificate.zig` chain
   validation and add the Go harness.
