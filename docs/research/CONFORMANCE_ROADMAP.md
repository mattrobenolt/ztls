# Conformance roadmap

This document tracks protocol and conformance features that are **not** part of
the currently advertised ztls surface. It exists so that "not implemented" is a
documented, bounded decision with explicit prerequisites and acceptance
criteria, not an unlabeled hole.

Read alongside `CORRECTNESS.md` (what is supported and how it is proven),
`DESIGN.md` (testing strategy), and `PROVIDER_INTERFACE.md` (backend seams for
groups/suites/PQ).

## Currently supported surface (evidence in CORRECTNESS.md)

- TLS 1.3 full handshake over X25519, three mandatory cipher suites.
- Certificate-authenticated server flight; client verifies Certificate,
  CertificateVerify, and server Finished before promoting to application keys.
- Application data, alerts, `close_notify`.
- Post-handshake **KeyUpdate** (both directions, request/no-request, flood
  bound, record-boundary enforcement).
- **NewSessionTicket** is parsed for structural validity and then ignored
  (`src/new_session_ticket.zig`, `ClientHandshake.handleRecord` →
  `.new_session_ticket => _ = try new_session_ticket.parse(msg.raw)`). Ticket
  contents are not stored and resumption is not offered. This is consumption for
  rejection of malformed input, not resumption support.

Anything below is out of the advertised surface. Tests asserting these features
are therefore absent by design, not disabled conformance gaps.

---

## HelloRetryRequest — TODO-d254dfa2, TODO-13a46a83

**Current behavior (honest):**
- Client: `server_hello.parse` detects the HRR magic random and returns
  `error.HelloRetryRequest` (`src/server_hello.zig`, tested
  `test "parse: rejects HelloRetryRequest"`). ztls never follows the retry.
- Server: when a ClientHello offers no X25519 key_share/group, ztls returns
  `error.UnsupportedKeyShare` instead of emitting HRR
  (`client_hello.parseKeyShare` / `parseSupportedGroups`, pinned by
  `test "parse: no shared group is rejected (HRR not implemented)"`).

**Prerequisites:**
- More than one named group implemented (PROVIDER_INTERFACE §3) — HRR only has a
  point when the server supports a group the client did not key-share. With a
  single group the choice is "supported or fatal," which is the current path.
- Server-side ClientHello1/ClientHello2 transcript handling: the synthetic
  `message_hash` substitution for ClientHello1 (RFC 8446 §4.4.1) and cookie
  echo (§4.2.2).
- Client-side: resend ClientHello with the server-selected group, carry the
  cookie, and enforce the "second HRR is illegal" rule (§4.1.4).

**Acceptance criteria:**
- Server emits HRR selecting a supported group when the client offers only an
  unsupported one, and completes the handshake on the retried ClientHello.
- Client consumes one HRR, retries, and rejects a second HRR with
  `unexpected_message`.
- Transcript hash uses the `message_hash` synthetic for ClientHello1; verified
  against OpenSSL interop in both roles.
- tlsfuzzer HRR conversations added to `conformance/` (TODO-13a46a83) and gated
  in `just ci`.

---

## NewSessionTicket consumption / storage — TODO-64f4d3df

**Current behavior:** parsed and discarded (see supported surface above). No
ticket store, no `ticket_age_add` accounting, no `max_early_data_size`.

**Prerequisites:** depends on PSK/resumption (TODO-1cd51100) for the only
consumer of a stored ticket. Standalone ticket storage with no resumption path
is dead state and should not be built first.

**Acceptance criteria:** ticket store API that records ticket, nonce, lifetime,
`ticket_age_add`, and issuance time; expiry enforced against `ticket_lifetime`;
exercised by the resumption flow below.

---

## PSK / resumption — TODO-1cd51100

**Prerequisites:**
- NewSessionTicket storage (TODO-64f4d3df).
- Key schedule extension: binder derivation (RFC 8446 §4.2.11.2), `psk_ke` and
  `psk_dhe_ke` modes, `Derive-Secret`/`HKDF-Expand-Label` for `res binder`,
  `ext binder`, and the early/handshake/master flow with PSK input.
- ClientHello `pre_shared_key` (must be last extension) + `psk_key_exchange_modes`.
- Binder MAC computed over the truncated ClientHello transcript — needs a
  two-pass ClientHello encoder or a transcript-with-placeholder strategy.
- Server PSK selection, binder verification, and `selected_identity` echo.

**Acceptance criteria:**
- Resumed handshake (psk_dhe_ke) interops with OpenSSL in both roles.
- Binder verification failure → `decrypt_error`; obfuscated ticket age checked.
- tlsfuzzer resumption conversations gated in CI.

---

## 0-RTT / early data — TODO-b3d94b1f

**Prerequisites:** PSK/resumption (TODO-1cd51100) complete; `early_data`
extension; early traffic secret derivation; `end_of_early_data` message;
anti-replay policy (single-use tickets and/or a bounded replay window). This is
a **policy** decision as much as a protocol one — Sans-I/O ztls cannot own a
global replay cache, so the anti-replay contract must be pushed to the caller
and documented.

**Acceptance criteria:**
- Documented anti-replay contract: what ztls enforces vs. what the embedder must
  enforce. No "0-RTT is safe" claim without that boundary written down.
- Accept/reject early data both interop-tested against OpenSSL.
- Replay of early data is rejected per the documented policy and tested.

This feature must not ship before its replay-safety boundary is written and
reviewed.

---

## Extension negotiation hardening — TODO-391e747f

**Current behavior:** ztls parses `server_name`, `supported_versions`,
`supported_groups`, `key_share`, and `alpn`, rejects duplicates of every
recognized type (RFC 8446 §4.2), and ignores unknown extensions (RFC 8446
§4.1.2). Both the duplicate `supported_groups` rejection and the
ignore-unknown path are pinned by tests in `src/client_hello.zig`
(`test "parse: rejects duplicate supported_groups"`,
`test "parse: ignores unknown extension"`). It does not negotiate
`max_fragment_length`, `record_size_limit`, `signature_algorithms_cert`,
`status_request`, etc.

**Prerequisites:** decide which extensions are in scope. `record_size_limit`
(RFC 8449) is the highest-value candidate given the caller-owned-buffer design.

**Acceptance criteria (per extension adopted):** parse + emit + negotiation
fallback tested; unknown/duplicate handling tested; tlsfuzzer coverage where the
suite exercises it. Until adopted, "ignored" is the documented behavior.

---

## Post-handshake messages beyond KeyUpdate — TODO-613d4fed

**Current behavior:** KeyUpdate fully handled; NewSessionTicket parsed/ignored.
Post-handshake CertificateRequest (client auth) is not handled.

**Prerequisites:** client cert auth (TODO-55fe53a8) for post-handshake auth;
otherwise no remaining post-handshake message types are in scope.

**Acceptance criteria:** covered by the client-auth criteria below; no separate
work item once KeyUpdate (done) and post-handshake auth are accounted for.

---

## Client certificate authentication — TODO-55fe53a8, TODO-bff0601f

**Prerequisites:**
- `CertificateRequest` parse (client) / emit (server), incl.
  `signature_algorithms` and `certificate_authorities`.
- Client sends Certificate (possibly empty) + CertificateVerify over the
  handshake transcript with the client's key (reuse `src/signature.zig`).
- Server verifies the client CertificateVerify and Certificate chain.
- Empty-certificate handling and the server's `certificate_required` /
  optional-auth policy.

**Acceptance criteria:**
- Mutual-auth handshake interops with `openssl s_server -Verify` and
  `openssl s_client -cert` in both roles (TODO-bff0601f).
- Missing/invalid client cert produces the correct alert
  (`certificate_required` / `bad_certificate`).
- RFC-cited unit tests for CertificateRequest parse/emit and client
  CertificateVerify.

---

## Future / PQ named groups — TODO-e458fa4a

**Prerequisites:** named-group abstraction from PROVIDER_INTERFACE §3
(`NamedGroup` enum, `max_public_key_len`/`max_shared_secret_len` sizing, removal
of the hard-wired `x25519.KeyPair` in the handshakes) and the KEM seam from §
"KEM seam." X25519MLKEM768 (`0x11ec`) is the lead target, gated on backend
support (capabilities, PROVIDER_INTERFACE §5).

**Acceptance criteria:**
- Group negotiation selects among ≥2 groups; HRR (TODO-d254dfa2) handles the
  no-shared-group case.
- Hybrid X25519MLKEM768 shared secret matches the backend reference and interops
  with an OpenSSL build that supports it.
- Capability gating so a backend without the group never advertises it.

---

## Fuzzing expansion — TODO-3aec61dd

**Current fuzz surfaces:** `server_hello.parse`, `certificate.parse`,
`new_session_ticket.parse`, client `HandshakeReader`, client decrypted
`processFlight`, server `handleRecord` initial state (see CORRECTNESS.md).

**Cheap high-value additions (candidates):** `client_hello.parse` byte fuzz,
`RecordLayer` record-header/length fuzz, alert parse fuzz.

**Acceptance criteria:** each new target rejects arbitrary input without panic
under `zig build test -- --fuzz`; added to the CORRECTNESS.md fuzz inventory.

---

## Wycheproof expansion — TODO-86ff7908

**Current:** boundary smoke vectors for AEAD AAD/nonce/tag, X25519
identity/low-order rejection, ECDSA DER verification.

**Prerequisites:** none structural; this is widening vector coverage at the
existing libcrypto boundary, not new protocol surface.

**Acceptance criteria:** additional Wycheproof groups (e.g. full AES-GCM/ChaCha
vector files, X25519 test groups, ECDSA edge cases) loaded and gated in
`zig build test-wycheproof`, still framed as wrapper-behavior tests (ztls does
not implement primitives).

---

## External runners — TLS-Anvil (TODO-8842b110), tlsfuzzer lockstep
## (TODO-9a7143c2), BoGo shim (TODO-dae1ed86)

These broaden matrix coverage. Their value scales with the feature surface
above; running them now mostly exercises features ztls intentionally does not
implement.

**TLS-Anvil (TODO-8842b110):** Java/JUnit runner. Prerequisite: a stable TCP
wrapper for both roles (the `ztls_tlsfuzzer_server` pattern, plus a client
wrapper). Acceptance: Anvil's TLS 1.3 server-and-client suites run in CI with a
documented, justified skip list mapping each skip to an unimplemented feature.

**tlsfuzzer lockstep (TODO-9a7143c2):** tighter request/response stepping than
the current conversation harness. Prerequisite: none beyond the existing
fixture. Acceptance: lockstep mode runs the current conversations deterministically
and is gated in `just tlsfuzzer`.

**BoGo shim (TODO-dae1ed86):** BoringSSL's `runner` drives a shim binary over a
defined CLI/stdio protocol. Prerequisite: a ztls shim implementing the BoGo
shim contract for both roles. Acceptance: BoGo runs against the shim with a
documented skip/expected-failure list tied to unimplemented features, gated or
at least scripted in `just`.

---

## Disposition summary

| TODO | Feature | Disposition |
|------|---------|-------------|
| TODO-d254dfa2 | HRR | Open. Blocked on multi-group support; current reject-path documented + tested. |
| TODO-13a46a83 | HRR tlsfuzzer | Open. Blocked on TODO-d254dfa2. |
| TODO-64f4d3df | NewSessionTicket consumption | Open. Blocked on resumption; parse-and-ignore documented. |
| TODO-1cd51100 | PSK/resumption | Open. Prereqs enumerated. |
| TODO-b3d94b1f | 0-RTT policy | Open. Replay-safety boundary must be written before any impl. |
| TODO-391e747f | Extension negotiation | Open. Scope decision pending; current ignore-unknown behavior documented. |
| TODO-613d4fed | Post-handshake | Open, folds into client-auth; KeyUpdate done. |
| TODO-55fe53a8 | Client cert auth | Open. Prereqs enumerated. |
| TODO-bff0601f | Client-auth OpenSSL tests | Open. Blocked on TODO-55fe53a8. |
| TODO-e458fa4a | Future/PQ groups | Open. Blocked on group abstraction + KEM seam. |
| TODO-3aec61dd | Fuzzing expansion | Open. Cheap incremental targets identified. |
| TODO-86ff7908 | Wycheproof expansion | Open. No structural blocker. |
| TODO-8842b110 | TLS-Anvil | Open. Needs wrappers + justified skip list. |
| TODO-9a7143c2 | tlsfuzzer lockstep | Open. No structural blocker. |
| TODO-dae1ed86 | BoGo shim | Open. Needs shim binary. |

No TODO in this slice can be honestly closed as "implemented." Each is given
explicit prerequisites and acceptance criteria so future work starts from a
known boundary rather than rediscovering scope.
</content>
</invoke>
