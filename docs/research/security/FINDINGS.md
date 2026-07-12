# Security findings — Glasswing hunt H2 + H3

Adversarial security review of the ztls parser surface, run via the Glasswing
vulnerability-discovery harness (recon → hunt → validate). This is not an
external audit; it is an internal adversarial pass using the project's
`whitehat-hacker` agents. The recon is at `RECON.md`; this file records the
findings, the fixes, and the residual scope.

## Methodology

1. **Recon** (`attack-surface-recon` agent) mapped trust boundaries, entry
   points, per-subsystem attack surface, and existing fuzz coverage, producing
   an 8-item prioritized hunt queue (`RECON.md`).
2. **Hunt** (`whitehat-hacker` agents, parallel) ran two P0 tasks:
   - H2: certificate parse + chain verification under hostile DER.
   - H3: ServerHello parse gaps (legacy_session_id, key_share, missing
     extensions).
3. **Validate**: findings verified independently by the parent (reproduced
   against the real ztls source with inline regression tests) before fixing.

## Finding S1 — integer-overflow DoS in parser bounds checks (class bug)

**Severity:** remote, unauthenticated-content denial of service. A malicious
server can crash any ztls client; a malicious client can crash a ztls server
configured for client auth. Pre-key for ServerHello/HRR (no AEAD protection);
post-key but attacker-content for Certificate.

**Root cause:** Zig 0.15 evaluates `narrow_type + comptime_int` in the narrow
type before widening for the comparison. Bounds checks of the form
`if (remaining < len + N)` where `len` is a `u8`/`u16`/`u24` overflow the
narrow type when `len` is near its max, causing a panic (Debug/ReleaseSafe) or
undefined behavior (ReleaseFast) before the comparison can reject the
oversized input.

**Affected sites (14 total):**

| File | Line | Expression | Narrow type |
|---|---|---|---|
| `certificate.zig` | 114 | `ctx_len + 3` | u8 |
| `certificate.zig` | 127 | `cert_len + 2` | u24 |
| `certificate.zig` | 157 | `ctx_len + 3` | u8 |
| `certificate.zig` | 175 | `cert_len + 2` | u24 |
| `certificate.zig` | 259 | `cert_len + 2` | u24 |
| `certificate_request.zig` | 83 | `ctx_len + 2` | u8 |
| `client_hello.zig` | 832 | `session_id_len + 2` | u8 |
| `client_hello.zig` | 837 | `cipher_suites_len + 1` | u16 |
| `client_hello.zig` | 842 | `compression_len + 2` | u8 |
| `NewSessionTicket.zig` | 49 | `nonce_len + 2` | u8 |
| `NewSessionTicket.zig` | 53 | `ticket_len + 2` | u16 |
| `ServerHandshake.zig` | 375 | `identity_len + 4` | u16 |
| `server_hello.zig` | 169 | `session_id_len + 2 + 1 + 2` | u8 |
| `server_hello.zig` | 477 | `session_id_len + 2 + 1 + 2` | u8 |

**Reproduction:** a 44-byte ServerHello with `session_id_len = 0xFF` at offset
38 panics with `integer overflow` at `server_hello.zig:477` before any
extension parsing. A 11-byte Certificate with `cert_len = 0xFFFFFF` panics at
`certificate.zig:259`. Both reachable from the public API with a single
malformed message.

**Fix:** widen the narrow-type arithmetic to `usize` before the addition:
`@as(usize, len) + N`. Applied to all 14 sites. Regression tests added in
`server_hello.zig` and `certificate.zig` asserting the hostile inputs return
an error, not a panic.

**Why existing fuzz coverage missed it:** the fuzz seeds are single valid
corpus entries that only mutate under `--fuzz` (not in default CI). A panic is
not an `error`, so the fuzz `catch return` wouldn't swallow a hit. The
`parseClientCertificate`/`parseClientChain` paths had no fuzz target at all.

## Finding S2 — missing ≤32 cap on legacy_session_id_echo (hardening)

**Severity:** low (spec-conformance gap, not a memory-safety or bypass bug).

**Root cause:** `server_hello.zig` reads `session_id_len` and validates only
that enough bytes remain — no `> 32` rejection. RFC 8446 §4.1.3 caps
`legacy_session_id_echo` at 32 bytes.

**Impact:** through the live handshake, a 33-byte echo is caught by
`InvalidSessionIdEcho` (the expected echo is the client's ≤32-byte value). The
silent accept only manifests via the direct `parse(msg)` / null-echo public
API. Not a handshake bypass. The 251–255 sub-range of this missing check is
the S1 crash above.

**Fix:** the S1 fix (widening) prevents the crash. A dedicated `> 32` cap is a
follow-up hardening item, tracked below.

## Verified-handled (no bug)

- **H3 gap 2 (key_share group/length):** the key_share switch is properly
  bounded — `ext_len` validated against remaining, each group checks
  `key_len` against fixed lengths, unknown groups fall through to
  `UnsupportedKeyShareGroup` via the non-exhaustive enum. No bug.
- **H3 gap 3 (missing key_share after supported_versions):**
  `server_hello.zig` rejects with `MissingExtension` when `supported_versions`
  selected TLS 1.3 but no `key_share` was received. No bug.
- **DER walker (`certificate_parser.zig`):** `der.Element.parse` length
  arithmetic is done in `usize`, bounds-checked against `bytes.len` and
  `maxInt(u32)` on every element. Known malformed-DER shapes (indefinite
  length, zero-length BIT STRING, constructed-on-primitive, bad INTEGER,
  NULL-mismatch) all return typed errors, not crashes. Cleared.

## Residual scope (not covered by this pass)

- **H1 (EncryptedExtensions offered-vs-unoffered gate), H4 (processFlight
  state-machine confusion), H8 (bad-ClientFinished tests):** P1 hunts not yet
  run. The recon queue in `RECON.md` has the scoped tasks.
- **H5 (PSK binder + 0-RTT state transitions):** P0, marked Fable-worthy
  (multi-section RFC reasoning). Not yet run; reserved for `siege` or a
  dedicated opus pass.
- **H6 (Certificate request_context gap), H7 (legacy session-id cap):** P2,
  not yet run.
- **ReleaseFast behavior of the S1 class:** the overflow is UB under
  ReleaseFast. The fix prevents the panic in safety builds; under ReleaseFast
  the widened arithmetic prevents the UB. Confirming no residual OOB read
  under ReleaseFast is a follow-up.
- **Full ASan/MSan sweep of the backend seam:** recommended as a parallel
  effort by `fuzz-engineer`.

## Files changed

- `src/server_hello.zig` — 2 overflow fixes + regression test
- `src/certificate.zig` — 5 overflow fixes + 2 regression tests
- `src/certificate_request.zig` — 1 overflow fix
- `src/client_hello.zig` — 3 overflow fixes
- `src/NewSessionTicket.zig` — 2 overflow fixes
- `src/ServerHandshake.zig` — 1 overflow fix
- `docs/research/security/RECON.md` — recon document (new)
- `docs/research/security/FINDINGS.md` — this file (new)
