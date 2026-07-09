# Conformance roadmap

This document tracks protocol and conformance features that are **not** part of
the supported ztls surface. It exists so that "not implemented" is a documented,
bounded decision with explicit prerequisites and acceptance criteria, not an
unlabeled hole.

Read alongside `CORRECTNESS.md` (what is supported and how it is proven),
`DESIGN.md` (testing strategy), and `PROVIDER_INTERFACE.md` (backend seams for
groups/suites/PQ).


## HelloRetryRequest — #1


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

**Status:** Partial. The 0-RTT accept-path is implemented: the client offers
early_data + derives the client_early_traffic_secret + sends 0-RTT data
(`sendEarlyData`); the server derives the early traffic key from the selected
PSK + ClientHello transcript, decrypts 0-RTT records, and enforces
max_early_data_size. The server emits the early_data extension in
EncryptedExtensions when accepting (RFC 8446 §4.2.10). The client sends
EndOfEarlyData under the early traffic key after the server Finished and before
its own Finished when the server accepted, and does not send it when the server
declined (RFC 8446 §4.5). The server expects and decrypts the client's
EndOfEarlyData with early_rx before the client Finished. Reject-path tests cover
max_early_data_size exceeded, no-PSK early data, server-declined 0-RTT, and
client rejection of server-sent EndOfEarlyData. OpenSSL 0-RTT interop is
CI-gated (ztls client → openssl s_server with `-early_data`).

**Residual:**
- Anti-replay is the caller's job: ztls does not own a global replay cache
  (Sans-I/O cannot). The caller must implement replay-safe policy (single-use
  tickets and/or a bounded replay window). No replay-of-early-data test exists
  because ztls does not own a replay cache.
- 0-RTT is disabled by default (`offer_early_data=false`).
- TLS-Anvil/tlsfuzzer 0-RTT coverage is not yet CI-gated.

---

## Extension negotiation hardening (formerly #5)

#5 was closed; the acceptance criteria below describe how new extensions should be
adopted. Until each candidate extension lands, "ignored" is the documented
behavior.


**Scope decision:** `record_size_limit` (RFC 8449) and `max_fragment_length`
(RFC 6066) are outside the supported TLS 1.3 surface. ztls already enforces the
TLS 1.3 record-size ceiling, and callers own buffer sizing; negotiating smaller
peer records is useful but not required for the present Sans-I/O API contract.
The legacy `max_fragment_length` extension also carries TLS 1.2-era semantics
that do not justify implementation before resumption, client auth, and provider
work. TLS-Anvil skips for these extensions cite this decision (#34).

**Acceptance criteria (per extension adopted later):** parse + emit + negotiation
fallback tested; unknown/duplicate handling tested; tlsfuzzer coverage where the
suite exercises it. Until adopted, "ignored" is the documented behavior.

---

## Post-handshake messages beyond KeyUpdate (formerly #23)

#23 was closed once KeyUpdate (done) and post-handshake auth are accounted for.


**Prerequisites:** client cert auth (#4) for post-handshake auth;
otherwise no remaining post-handshake message types are in scope.

**Acceptance criteria:** covered by the client-auth criteria below; no separate
work item once KeyUpdate (done) and post-handshake auth are accounted for.

---

## Client certificate authentication — #4

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

## External runners — TLS-Anvil, tlsfuzzer lockstep, BoGo shim

These broaden matrix coverage. Their value scales with the feature surface
above; early runs mostly exercise features ztls intentionally does not
implement.

**TLS-Anvil:** Java/JUnit runner. Server and client workflows are wired outside
PR `just ci`; #48 closed the client runner, #49 closed both-endpoint accounting,
and #52 classifies DSA-root TLS 1.3 certificate parameter failures as visible
`expected_failed` rows rather than skips or passes. Remaining disabled rows map
to feature issues or explicit TLS 1.2/DTLS/out-of-scope decisions.

**tlsfuzzer lockstep:** tighter request/response stepping than the current
conversation harness. The current conversations run deterministically under
`just conformance/tlsfuzzer` and are gated by `just conformance/ci`.

**BoGo shim:** BoringSSL's `runner` driving a ztls shim over a CLI/stdio
protocol is durably deferred in `BOGO_DEFERRED.md`. The 2026-06 scaffolding
(`conformance/src/bogo.zig`, `bogo-fetch.sh`, `run_bogo.sh`, and
`bogo-skip-list.json`) was removed in PR #21 because it was a non-functional
stub. Re-entry requires the acceptance bar in `BOGO_DEFERRED.md`: pinned
runner source, a real dual-role shim, GitHub-issue skip accounting, strict
report gating, and a manual/scheduled workflow outside PR `just ci`.

---

