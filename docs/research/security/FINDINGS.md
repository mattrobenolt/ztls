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

## Finding S3 — server authentication bypass via PSK fast-path (CRITICAL, fixed)

**Severity:** critical — full active-MITM / server-impersonation bypass whenever
the client offers a session ticket.

**Root cause:** the `wait_cert_or_cr` `.finished` arm in `ClientHandshake.zig`
gated the "bare Finished after EncryptedExtensions, no
Certificate/CertificateVerify" fast path on `self.offered_psk == null` — which
records whether the *client offered* a PSK, not whether the *server selected*
it. `processServerHello` uses the PSK only when `sh.selected_identity != null`
and otherwise derives keys from ephemeral DHE alone, but recorded no selection
outcome. `offered_psk` stays set regardless.

**Consequence:** a client that offered a resumption ticket accepted a bare
server Finished with zero Certificate/CertificateVerify even when the server
did NOT select the PSK and the keys were pure ephemeral DHE. An active MITM
who completes the ECDHE (it chooses the ServerHello `key_share`) can forge a
Finished and the client believes it is authenticated — no certificate or
signature was ever checked. Exploitable whenever the client offers a
resumption ticket (every resumed connection).

**Fix:** added `server_selected_psk: bool` to `ClientHandshake`, set in
`processServerHello` when `sh.selected_identity != null`. The fast-path guard
now checks `!self.server_selected_psk` instead of `self.offered_psk == null`.
Regression test in `ServerHandshake.zig` drives a PSK-offering client whose
server declined the PSK and asserts a bare Finished is rejected with
`UnexpectedMessage`.

**Why existing tests missed it:** the PSK tests only exercise the case where
the server DOES select the PSK and sends a full authenticated flight. No test
drove offered-PSK + server-declined + bare-Finished. The `processFlight:
rejects Finished before EncryptedExtensions` test uses a non-PSK client, so it
hits the `offered_psk == null` reject and never reaches the fast path.

## Verified-handled (no bug)

- **H1 (EncryptedExtensions offered-vs-unoffered gate):** verified handled
  with an 18-test PoC suite. The gate is fail-closed — `offered_extensions`
  defaults to empty, rejecting all gated extensions. ALPN cross-check,
  duplicate rejection, and forbidden-extension rejection all work. One
  hardening note: `supported_groups` is accepted unconditionally but is safe
  today (mandatory, client ignores the value mid-handshake per RFC 8446
  §4.2.7).
- **H3 gap 2 (key_share group/length):** the key_share switch is properly
  bounded — `ext_len` validated against remaining, each group checks
  `key_len` against fixed lengths, unknown groups fall through to
  `UnsupportedKeyShareGroup` via the non-exhaustive enum. No bug.
- **H3 gap 3 (missing key_share after supported_versions):**
  `server_hello.zig` rejects with `MissingExtension` when `supported_versions`
  selected TLS 1.3 but no `key_share` was received. No bug.
- **H6 (Certificate request_context non-empty rejection):** already handled —
  `certificate.parse` (server cert path) rejects `ctx_len != 0` with
  `UnexpectedCertificateRequestContext` at line 241. The NEGATIVE_SPACE gap
  row was stale.
- **H7 (legacy session-id ≤32 cap):** already handled — `client_hello.parse`
  rejects `session_id_len > 32` with `InvalidVectorLength` at line 831. The
  server uses the same parser.
- **DER walker (`certificate_parser.zig`):** `der.Element.parse` length
  arithmetic is done in `usize`, bounds-checked against `bytes.len` and
  `maxInt(u32)` on every element. Known malformed-DER shapes all return typed
  errors, not crashes. Cleared.
- **H4 out-of-order/duplicate transitions (full-handshake path):** the
  state+progress double-gating correctly rejects duplicate Certificate,
  out-of-order CertificateVerify, and Finished-before-CV. The auth-bypass bug
  was a *missing precondition* (offered vs selected), not a flag desync.

## Finding S4 — integer-overflow DoS in selectPsk binders length check (#72 class, fixed)

**Severity:** remote, unauthenticated-content denial of service on any
resumption-enabled (PSK/0-RTT) ztls server.

**Root cause:** `ServerHandshake.zig:369` evaluated `2 + identities_len + 2 +
binders_len` in u16 before widening for the comparison. Both `identities_len`
and `binders_len` are `u16`; the sum overflows u16 before the comparison can
reject the oversized input. This is the same #72 class — a site the original
sweep missed because it predates the sweep and sits in a function
(`selectPsk`) that the sweep's grep pattern didn't cover.

**Reproduction:** a ClientHello with a `pre_shared_key` extension whose
`binders_len` field is `0xFFFF` panics with `integer overflow` at
`ServerHandshake.zig:369` in `selectPsk`, before any binder verification.
Reachable on any server with `psk_lookup` configured (resumption/0-RTT).

**Fix:** widened to `@as(usize, 2) + identities_len + 2 + binders_len`. Also
widened the adjacent line 364 (`2 + identities_len + 2 > psk_ext.len`)
defensively, even though it was non-exploitable (parse pre-bounds
`identities_len ≤ 65531`). Regression test asserts the hostile input returns
`error.InvalidExtensionLength`, not a panic.

## H5 verified-handled (no bug)

- **Binder-input bypass (Q1):** the binder is verified over `prefix =
  msg[0..binders_offset]`, which spans the entire ClientHello up to the
  binders list — including the identity and obfuscated ticket age. Any
  alteration of those inputs changes `Hash(prefix)` and breaks the HMAC. No
  trivial input-alteration bypass.
- **early_rx fall-through (Q2):** `handleWaitClientFinished` does
  `handshake.decryptProtected(early_rx, record) catch return error.UnexpectedMessage`
  — a failed early-data decrypt aborts immediately and never retries under the
  handshake key. The in-place mutation of `record` doesn't matter because the
  handshake terminates; there's no second decrypt on the corrupted buffer.
  Correctly handled.

- **H5 (PSK binder + 0-RTT):** RUN. Found S4 (selectPsk overflow, fixed).
  Binder-input bypass and early_rx fall-through verified handled. Two areas
  unproven and re-queued: (a) the full EndOfEarlyData accept/decline ×
  present/absent state matrix, (b) PSK-offer-surviving-HRR (binder transcript
  must include CH1 + HRR for resumption after HelloRetryRequest — whether ztls
  supports or correctly rejects this is untraced).
- **ReleaseFast behavior of the S1/S4 class:** the overflow is UB under
  ReleaseFast. The fix prevents the panic in safety builds; under ReleaseFast
  the widened arithmetic prevents the UB. Confirming no residual OOB read
  under ReleaseFast is a follow-up.
- **Full ASan/MSan sweep of the backend seam:** recommended as a parallel
  effort by `fuzz-engineer`.
- **EE fuzz target:** the H1 PoC suite is corpus material for a future
  `test "fuzz: encrypted_extensions"` target (fuzz-engineer scope).

## Files changed

- `src/server_hello.zig` — 2 S1 overflow fixes + ≤32 session_id cap (S2) + regression test
- `src/certificate.zig` — 5 S1 overflow fixes + 2 regression tests
- `src/certificate_request.zig` — 1 S1 overflow fix
- `src/client_hello.zig` — 3 S1 overflow fixes
- `src/NewSessionTicket.zig` — 2 S1 overflow fixes
- `src/ServerHandshake.zig` — 1 S1 overflow fix + bad-ClientFinished test (H8) + PSK auth-bypass regression test (S3)
- `src/ClientHandshake.zig` — S3 fix: `server_selected_psk` field + guard fix
- `docs/research/security/RECON.md` — recon document (new)
- `docs/research/security/FINDINGS.md` — this file (new)
