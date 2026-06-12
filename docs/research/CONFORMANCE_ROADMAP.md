# Conformance roadmap

This document tracks protocol and conformance features that are **not** part of
the currently advertised ztls surface. It exists so that "not implemented" is a
documented, bounded decision with explicit prerequisites and acceptance
criteria, not an unlabeled hole.

Read alongside `CORRECTNESS.md` (what is supported and how it is proven),
`DESIGN.md` (testing strategy), and `PROVIDER_INTERFACE.md` (backend seams for
groups/suites/PQ).


## HelloRetryRequest — #1, #1


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
- tlsfuzzer HRR conversations added to `conformance/` (#1) and gated
  in `just ci`.

---

## NewSessionTicket consumption / storage — #2


**Prerequisites:** depends on PSK/resumption (#2) for the only
consumer of a stored ticket. Standalone ticket storage with no resumption path
is dead state and should not be built first.

**Acceptance criteria:** ticket store API that records ticket, nonce, lifetime,
`ticket_age_add`, and issuance time; expiry enforced against `ticket_lifetime`;
exercised by the resumption flow below.

---

## PSK / resumption — #2

**Prerequisites:**
- NewSessionTicket storage (#2).
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

## 0-RTT / early data — #3

**Prerequisites:** PSK/resumption (#2) complete; `early_data`
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

## Extension negotiation hardening — #5


**Prerequisites:** decide which extensions are in scope. `record_size_limit`
(RFC 8449) is the highest-value candidate given the caller-owned-buffer design.

**Acceptance criteria (per extension adopted):** parse + emit + negotiation
fallback tested; unknown/duplicate handling tested; tlsfuzzer coverage where the
suite exercises it. Until adopted, "ignored" is the documented behavior.

---

## Post-handshake messages beyond KeyUpdate — #23


**Prerequisites:** client cert auth (#4) for post-handshake auth;
otherwise no remaining post-handshake message types are in scope.

**Acceptance criteria:** covered by the client-auth criteria below; no separate
work item once KeyUpdate (done) and post-handshake auth are accounted for.

---

## Client certificate authentication — #4, #4

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
  `openssl s_client -cert` in both roles (#4).
- Missing/invalid client cert produces the correct alert
  (`certificate_required` / `bad_certificate`).
- RFC-cited unit tests for CertificateRequest parse/emit and client
  CertificateVerify.

---

## Future / PQ named groups — #6

**Prerequisites:** named-group abstraction from PROVIDER_INTERFACE §3
(`NamedGroup` enum, `max_public_key_len`/`max_shared_secret_len` sizing, removal
of the hard-wired `x25519.KeyPair` in the handshakes) and the KEM seam from §
"KEM seam." X25519MLKEM768 (`0x11ec`) is the lead target, gated on backend
support (capabilities, PROVIDER_INTERFACE §5).

**Acceptance criteria:**
- Group negotiation selects among ≥2 groups; HRR (#1) handles the
  no-shared-group case.
- Hybrid X25519MLKEM768 shared secret matches the backend reference and interops
  with an OpenSSL build that supports it.
- Capability gating so a backend without the group never advertises it.

---

## Wycheproof boundary-vector policy

Current Wycheproof tests live in `src/wycheproof.zig` and exercise ztls wrapper
behavior at the libcrypto boundary: X25519 normal and low-order public keys,
AES-GCM AAD/tag plumbing, and ChaCha20-Poly1305 AAD/tag plumbing. ztls does not
implement those primitives, so mirroring full primitive vector suites is not a
current readiness gate.

Expand Wycheproof coverage when the ztls wrapper surface grows: new named
groups, new AEAD suites, new signature schemes, or a second libcrypto-family
backend. Track that expansion in the feature/provider issue that grows the
surface, so vector scope follows actual API risk instead of becoming standalone
conformance busywork.

---

## External runners — TLS-Anvil (#9), tlsfuzzer lockstep
## (#9), BoGo shim (#9)

These broaden matrix coverage. Their value scales with the feature surface
above; running them now mostly exercises features ztls intentionally does not
implement.

**TLS-Anvil (#9):** Java/JUnit runner. Prerequisite: a stable TCP
wrapper for both roles (the `tlsfuzzer_server` pattern, plus a client
wrapper). Acceptance: Anvil's TLS 1.3 server-and-client suites run in CI with a
documented, justified skip list mapping each skip to an unimplemented feature.

**tlsfuzzer lockstep (#9):** tighter request/response stepping than
the current conversation harness. Prerequisite: none beyond the existing
fixture. Acceptance: lockstep mode runs the current conversations deterministically
and is gated in `just conformance/tlsfuzzer`.

**BoGo shim (#9):** BoringSSL's `runner` drives a shim binary over a
defined CLI/stdio protocol. Prerequisite: a ztls shim implementing the BoGo
shim contract for both roles. Acceptance: BoGo runs against the shim with a
documented skip/expected-failure list tied to unimplemented features, gated or
at least scripted in `just`.

---

