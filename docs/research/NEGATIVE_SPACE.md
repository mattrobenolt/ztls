# Negative-space inventory

This is the catalogue of supported-surface peer malice and malformed input: what
must fail, how ztls responds, and which evidence proves the response. It is not
the RFC MUST matrix (`RFC8446_MUST_MATRIX.md`) and not the threat model
(`THREAT_MODEL.md`). It is the lower-level "what happens if the peer does this
bad thing?" map.

Statuses in this file are local to a row:

- **covered** — a named local/conformance test or fuzz target exercises it.
- **partial** — a generic parser/fuzz layer covers the shape, but not every
  protocol-specific permutation.
- **gap** — no direct evidence yet, or the behavior is intentionally deferred
  to another open issue.

The authoritative readiness state remains `PRODUCTION_READINESS.md`.

## Record framing and record protection

| Malformed input | ztls response | Evidence | Row |
|---|---|---|---|
| Record header shorter than 5 bytes | `error.BufferTooShort` from `frame.parseHeader` | `frame.zig`: `parseHeader: buffer too short`; fuzz `parseHeader` | covered |
| Record length greater than RFC 8446 §5.2 maximum | `error.RecordTooLarge` | `frame.zig`: `parseHeader: length exceeds max`; `RecordBuffer.zig`: `next: oversized length is rejected`; tlsfuzzer `test_tls13_oversized_record_is_rejected` | covered |
| Record length says more bytes than are available | `RecordBuffer.next()` returns `null`; direct `handleRecord` callers get `error.IncompleteRecord` | `RecordBuffer.zig`: `next: truncated records return null`; `ClientHandshake.zig`: `handleRecord: truncated encrypted flight is rejected`; tlsfuzzer truncated-record tests | covered |
| TLSCiphertext shorter than AEAD tag | `error.RecordTooShort` | `RecordLayer.zig`: `decrypt: payload shorter than tag` | covered |
| TLSCiphertext length field exceeds supplied buffer | `error.BufferTooShort` | `RecordLayer.zig`: `decrypt: truncated ciphertext record` | covered |
| Encrypted record has outer content type other than `application_data` | `error.UnexpectedContentType` | `RecordLayer.zig`: `decrypt: wrong content type` | covered |
| AEAD ciphertext/tag/AAD corruption | `error.AuthenticationFailed`; callers send `bad_record_mac` where alerting is appropriate | `aead.zig` tamper tests; `ClientHandshake.zig`: `handleRecord: corrupted encrypted flight is rejected`; tlsfuzzer corrupted app-data test | covered |
| Replayed encrypted record | `error.AuthenticationFailed` because sequence-derived nonce no longer matches | `RecordLayer.zig`: `decrypt: replayed record is rejected` | covered |
| Record sequence number overflow | `error.SequenceNumberOverflow` | `RecordLayer.zig`: `encrypt: sequence number overflow`, `decrypt: sequence number overflow` | covered |
| AEAD per-key record usage limit reached | `error.KeyUpdateRequired` | `RecordLayer.zig`: `encrypt/decrypt: key update required at AEAD usage limit` | covered |
| Zero-length application data | Accepted and round-trips as empty plaintext | `RecordLayer.zig`: `encrypt/decrypt: zero-length application data` | covered |
| Maximum plaintext fragment length | Accepted at exactly 2^14 bytes; larger sends fail with `error.PlaintextTooLarge` | `RecordLayer.zig`: `encrypt/decrypt: maximum plaintext fragment length` | covered |
| Decrypted inner plaintext has no non-zero content type byte | `error.InvalidInnerPlaintext` | `RecordLayer.zig`: `decrypt: rejects all-zero inner plaintext`; `ClientHandshake.zig` / `ServerHandshake.zig`: `handleRecord: all-zero inner plaintext maps to unexpected_message`; `RecordLayer.decrypt` fuzz target | covered |
| Unknown or illegal inner content type after handshake | `error.UnexpectedRecord` | `ClientHandshake.zig`: `handleRecord: post-handshake unexpected inner content type is rejected`; `ServerHandshake.zig`: `handleRecord: illegal post-handshake inner content type is rejected` | covered |
| Non-0x0303 record legacy version | Ignored as a legacy field; version negotiation lives in `supported_versions` | RFC 8446 §5.1 behavior; no branch on the field | covered by design |

## Alert records

| Malformed input | ztls response | Evidence | Row |
|---|---|---|---|
| Alert payload shorter than two bytes | `error.UnexpectedEof` | `alert.zig`: `parse: truncated`; fuzz `alert.parse` | covered |
| `close_notify` | `.closed` in connected state or no-op during handshake | `ClientHandshake.zig`: `handleRecord: close_notify returns closed`; `ServerHandshake.zig`: `handleRecord: connected close_notify is clean, fatal alert records detail`; send-alert tests | covered |
| Fatal or non-close alert from peer | `error.PeerAlert` | `ClientHandshake.zig`: plaintext/encrypted fatal alert tests; `ServerHandshake.zig`: fatal alert tests | covered |
| Unknown alert description or warning-level §6.2 alert | Treated as a TLS 1.3 error/fatal alert regardless of the legacy AlertLevel byte | `alert.zig`: `parse: warning-level error alert is fatal`, `parse: unknown alert description is fatal` | covered |

## Client-side bad server behavior

| Malformed input | ztls response | Evidence | Row |
|---|---|---|---|
| Plaintext application data before ServerHello | `error.UnexpectedRecord` | `ClientHandshake.zig`: `handleRecord: application_data before ServerHello is rejected` | covered |
| Malformed ServerHello length/body | Parser error; caller can emit `decode_error` | `ClientHandshake.zig`: `handleRecord: malformed ServerHello is rejected`; `server_hello.zig` parser tests | covered |
| ServerHello unknown cipher-suite code point | `error.InvalidEnumTag`, not enum-unreachable panic | `server_hello.zig`: `parse: rejects unknown cipher suite`; `parseHelloRetryRequest: rejects unknown cipher suite` | covered |
| ServerHello HelloRetryRequest sentinel — when the client receives an HRR it does not drive forward (single-shot, no ClientHello2) | `error.HelloRetryRequest` | `server_hello.zig`: `parse: rejects HelloRetryRequest`; client-side HRR consumption is part of the supported surface (formerly #1); defensive single-shot rejection remains a parser invariant | covered |
| ServerHello `supported_versions` absent | `error.UnsupportedTlsVersion` (treated as legacy TLS 1.2-or-below) | `server_hello.zig`: `parse: missing extensions / no supported_versions yields UnsupportedTlsVersion`; `parse: rejects ServerHello without supported_versions as legacy` | covered |
| ServerHello `supported_versions` selects non-TLS-1.3 | `error.IllegalParameter` | `server_hello.zig`: `parse: unsupported TLS version in supported_versions is illegal_parameter` | covered |
| ServerHello `legacy_version` ≤ SSLv3 (0x0300) | `error.UnsupportedTlsVersion` | `server_hello.zig`: `parse: rejects SSLv3-or-lower legacy version` | covered |
| ServerHello `legacy_version` > 0x0300 when `supported_versions` selects TLS 1.3 | Ignored per RFC 8446 §4.2.1 | `server_hello.zig`: `parse: accepts non-0x0303 legacy_version when supported_versions selects TLS 1.3` | covered |
| ServerHello downgrade sentinel in random | `error.IllegalParameter` (checked both with and without `supported_versions`) | `server_hello.zig`: `parse: rejects TLS 1.2 downgrade sentinel`, `parse: rejects TLS 1.1 downgrade sentinel`, `parse: rejects downgrade sentinel when supported_versions selects TLS 1.3`, `parse: no supported_versions + downgrade sentinel yields IllegalParameter` | covered |
| ServerHello missing required extensions (`key_share` absent, `supported_versions` present) | `error.MissingExtension` | `server_hello.zig`: the required-extension check after `supported_versions` selects TLS 1.3 | partial — no dedicated key_share-absent unit test |
| ServerHello duplicate singleton extensions | `error.DuplicateExtension` | `server_hello.zig`: duplicate supported_versions/key_share tests | covered |
| ServerHello or HRR unknown/unsolicited extension | `error.UnsupportedExtension`; caller emits `unsupported_extension` alert per RFC 8446 §4.2 | `server_hello.zig`: `parse: rejects unknown unsolicited extension`; `parseHelloRetryRequest: rejects unknown unsolicited extension`; `ClientHandshake.alertForError` maps `UnsupportedExtension` to `unsupported_extension` | covered |
| ServerHello or HRR recognized wrong-message extension (`record_size_limit`) | `error.UnexpectedExtension`; caller emits `illegal_parameter` alert per RFC 8446 §4.2 | `server_hello.zig`: `parse: rejects record_size_limit in ServerHello`; `parseHelloRetryRequest: rejects record_size_limit`; `ClientHandshake.alertForError` maps `UnexpectedExtension` to `illegal_parameter` | covered |
| ServerHello mismatched `legacy_session_id_echo` | `error.InvalidSessionIdEcho` | `server_hello.zig`: `parse: rejects mismatched session id echo`; `ClientHandshake.zig`: `processServerHello: rejects mismatched session id echo` | covered |
| ServerHello non-zero `legacy_compression_method` | `error.InvalidCompressionMethod` | `server_hello.zig`: `parse: rejects non-zero compression method` | covered |
| ServerHello unsupported or malformed key_share group/length | `error.UnsupportedKeyShareGroup` | `server_hello.zig`: `parse: rejects key_share for unsupported group`, `parse: rejects compressed secp256r1 key_share`, `parse: rejects compressed secp384r1 key_share` | covered |
| ServerHello legacy session id longer than 32 bytes | `error.IllegalParameter` | `server_hello.zig`: `session_id_len > 32` is rejected in the ServerHello parse and the HRR parse; `parse: rejects oversized legacy_session_id_echo without overflow` exercises the oversized input (it asserts refusal, not the exact tag) | covered |
| Server selects a suite outside the client's offered list | `error.IllegalParameter` (RFC 8446 §4.1.3, `illegal_parameter` alert) | `ClientHandshake.zig`: `processServerHello: rejects unoffered cipher suite` | covered |
| Encrypted flight message arrives out of order | `error.UnexpectedMessage`; caller can emit `unexpected_message` | `ClientHandshake.zig`: `processFlight: rejects Finished before EncryptedExtensions` | covered |
| Encrypted application data before handshake completion | `error.UnexpectedRecord`; caller can emit `unexpected_message` | `ClientHandshake.zig`: `handleRecord: encrypted application data during server flight is rejected` | covered |
| Encrypted fatal alert during server flight | `error.PeerAlert` | `ClientHandshake.zig`: `handleRecord: encrypted fatal alert during server flight` | covered |
| CertificateVerify signature is invalid | `error.SignatureVerificationFailed`; caller can emit `decrypt_error` | `ClientHandshake.zig`: `processFlight: rejects wrong CertificateVerify signature` | covered |
| Server Finished MAC is invalid | `error.InvalidVerifyData`; caller can emit `decrypt_error` | `ClientHandshake.zig`: `processFlight: rejects wrong server Finished verify_data`; `finished.zig`: `verify: wrong verify_data` | covered |
| Handshake message spans encrypted records without caller buffer | `error.UnexpectedEof` | `ClientHandshake.zig`: `processFlight: handshake message spanning records needs buffer` | covered |
| Handshake message spans encrypted records with caller buffer | Reassembled and processed | `ClientHandshake.zig`: `processFlight: reassembles handshake message split across records` | covered |
| Certificate malformed DER, bad chain, hostname mismatch, key-usage/EKU/name-constraints rejection | Certificate parse/policy errors | `certificate.zig` parser/policy/name-constraints tests; Wycheproof boundary tests | partial — not every path is driven through `ClientHandshake` |
| Excess non-self-issued intermediate CAs below `pathLenConstraint` | `CertificatePathLengthExceeded` → `bad_certificate` | `certificate.zig`: `parse: rejects chain exceeding pathLenConstraint zero`, `parseClientChain: rejects client chain exceeding pathLenConstraint zero`, and the selected-path constraint matrix (#118) | covered for both public certificate parsers, including anchor policy and target exclusion |
| Certificate arrives with no trust bundle and no explicit insecure opt-in | `error.MissingTrustAnchor` | `certificate.zig`: `parse: rejects missing trust anchor by default`; `ClientHandshake.zig`: `processFlight: rejects unanchored Certificate by default` | covered |
| Server Certificate request_context is non-empty | `error.UnexpectedCertificateRequestContext` (RFC 8446 §4.4.2; `illegal_parameter` at the client) | `certificate.zig`: `parse: rejects non-empty server certificate request context`; `ClientHandshake.zig`: `processFlight: rejects non-empty server Certificate request context` | covered |
| Leaf public key exceeds retained buffer | `error.CertificateKeyTooLarge` | `ClientHandshake.zig` and `ServerHandshake.zig` raise it when the retained-key buffer is too small | partial — no dedicated unit test |
| Post-handshake NewSessionTicket malformed | Ticket parser error | `ClientHandshake.zig`: `handleRecord: malformed NewSessionTicket is rejected`; `NewSessionTicket.zig` negative tests | covered |
| Post-handshake unexpected inner content type | `error.UnexpectedRecord`; caller can emit `unexpected_message` | `ClientHandshake.zig`: `handleRecord: post-handshake unexpected inner content type is rejected` | covered |
| KeyUpdate flood | `error.TooManyKeyUpdates` | `ClientHandshake.zig`: `handleRecord: KeyUpdate flood is rejected` | covered |
| KeyUpdate not at record boundary | `error.UnexpectedMessage` | `ClientHandshake.zig`: `handleRecord: KeyUpdate not at record boundary is rejected` | covered |
| Illegal KeyUpdate request byte | `error.IllegalParameter` | `handshake.zig`: `parseKeyUpdate`; tlsfuzzer invalid KeyUpdate request | partial — direct client connected-state unit test absent |

## Server-side bad client behavior

| Malformed input | ztls response | Evidence | Row |
|---|---|---|---|
| Garbage or non-TLS input before ClientHello | Parser/state error, no panic | tlsfuzzer garbage pre-handshake tests; `ServerHandshake.handleRecord` fuzz target | covered |
| Truncated ClientHello record | Framing returns incomplete/null or parse error | tlsfuzzer truncated ClientHello tests | covered |
| Malformed ClientHello compression methods | `error.InvalidCompressionMethod` | `client_hello.zig`: `parse: rejects malformed compression methods` | covered |
| Empty ClientHello record | Rejected | tlsfuzzer empty ClientHello test | covered |
| ChangeCipherSpec before ClientHello | `error.UnexpectedRecord`; CCS is accepted only in the HRR window before ClientHello2 or while waiting for the client Finished (RFC 8446 Appendix D.4) | `ServerHandshake.zig`: `handleRecord: rejects ChangeCipherSpec before ClientHello`, `handleRecord: drops valid ChangeCipherSpec while waiting for client Finished`, `acceptClientHello: HRR sends at most one compatibility ChangeCipherSpec` | covered |
| application_data before connected | `error.UnexpectedRecord` | `ServerHandshake.zig`: `handleRecord: rejects application_data before connected` | covered |
| Unsupported cipher-suite offer | `error.UnsupportedCipherSuite` | `ServerHandshake.zig`: `acceptClientHello: rejects unsupported suite`; tlsfuzzer unsupported suite test | covered |
| No shared key exchange group — when the server has no overlap with the client offer | `error.UnsupportedKeyShare` / parse rejection; HRR applies only when a shared group lacks a key share | `client_hello.zig`: `parse: no shared supported group is rejected`; `ServerHandshake.zig`: `acceptClientHello: rejects ClientHello with no shared group`; `acceptClientHello: emits HelloRetryRequest for missing secp256r1 key share` | covered |
| ClientHello duplicate extension | `error.DuplicateExtension` for covered extensions | `client_hello.zig`: duplicate supported_groups test | partial — not every singleton extension has a duplicate test |
| ClientHello missing required extension | `error.MissingExtension` / unsupported version/group | `client_hello.zig`: malformed ClientHello tests | covered |
| Unshared ALPN | `error.NoApplicationProtocol` | tlsfuzzer unshared ALPN test | partial — no local unit test |
| Oversized ClientHello legacy session id | `error.InvalidVectorLength` (RFC 8446 §4.1.2 length 0..32) | `client_hello.zig`: parse rejects `session_id_len > 32`; `parse: rejects oversized legacy_session_id` covers 33 and 255 | covered |
| Oversized SNI hostname on parse path | Accepted; the parsed hostname is exposed to the caller through `clientServerName()` | `client_hello.zig`: `parseSni` bounds `name_len` by the extension length only and applies no 253-octet cap; the encode path rejects a name over 253 octets with `ServerNameTooLong` | policy difference — #123 |
| Bad client Finished MAC | `error.InvalidVerifyData` | `ServerHandshake.zig`: `processClientFinished: rejects bad verify_data` | covered |
| Client Finished plus extra handshake message | `error.UnexpectedMessage` | `ServerHandshake.zig`: `processClientFinishedPlaintext` rejects a trailing message after Finished | partial — no dedicated unit test |
| Non-Finished handshake in `wait_client_finished` | `error.UnexpectedMessage` | `ServerHandshake.zig`: `processClientFinishedPlaintext` requires Finished as the last message | partial — no dedicated unit test |
| Connected-state KeyUpdate flood | `error.TooManyKeyUpdates` | `ServerHandshake.zig`: `handleRecord: KeyUpdate flood is rejected` | covered |
| Connected-state KeyUpdate not at record boundary | `error.UnexpectedMessage` | `ServerHandshake.zig`: `handleRecord: KeyUpdate not at record boundary is rejected` | covered |
| Simultaneous KeyUpdate requests | Both sides remain connected and ratchet safely | `ServerHandshake.zig`: `key update: simultaneous update_requested remains connected` | covered |
| Connected-state illegal inner content type | `error.UnexpectedRecord` | `ServerHandshake.zig`: `handleRecord: illegal post-handshake inner content type is rejected` | covered |
| 0-RTT record after the server declined the early_data offer (no PSK selected, ticket without early data, or required client auth declining the PSK) | Discarded by trial-deprotection with the handshake key (RFC 8446 §4.2.10); the first deprotected record starts the client's second flight. The failed trial's buffer is backend-owned failure output and is never re-decrypted or inspected | `ServerHandshake.zig`: `0-RTT: no PSK selected means early data is skipped and 1-RTT completes`, `0-RTT: declined early records in flight are skipped and 1-RTT completes`, `0-RTT: required client auth declines PSK, skips early data, completes 1-RTT` | covered |
| More undecryptable bytes than the decline-skip budget (`Config.early_data_skip_limit`, wire payload bytes — ciphertext + tag, header excluded — default 16640, one full max-size early record) | `error.EarlyDataSkipLimitExceeded` → `bad_record_mac` (§5.2 beyond the §4.2.10 tolerance) | `ServerHandshake.zig`: `0-RTT: decline skip budget exhaustion aborts the handshake`; `alert.zig`: `alertForError: parser and semantic failures map to protocol alerts` | covered |
| Corrupted record after the skip window closed (first handshake-key record already seen) | `error.AuthenticationFailed` (ordinary §5.2 failure; pending flight fragment dropped) | `ServerHandshake.zig`: `0-RTT: corrupted record after the skip window aborts` | covered |
| 0-RTT record after the server declined the early_data offer by responding HelloRetryRequest (records in flight while ClientHello2 is pending) | Skipped by outer content type (RFC 8446 §4.2.10 HRR strategy), bounded by the shared wire-byte budget; ClientHello2 closes the window | `ServerHandshake.zig`: `0-RTT: HRR decline skips in-flight early data and the retry handshake completes`, `0-RTT: HRR skip window closes at ClientHello2` | covered |
| Malformed outer application_data during the HRR skip window (zero-length or one AEAD tag or less) | `error.RecordTooShort`; consumes no budget and does not close the window | `ServerHandshake.zig`: `0-RTT: HRR decline skip rejects malformed application_data records` | covered |
| More HRR-declined bytes than the budget | `error.EarlyDataSkipLimitExceeded` → `bad_record_mac` | `ServerHandshake.zig`: `0-RTT: HRR decline skip budget exhaustion aborts the handshake` | covered |
| 0-RTT record with a corrupt authentication tag after explicit early_data acceptance | `AuthenticationFailed` → `bad_record_mac` (RFC 8446 §4.2.10, §5.2) | `ServerHandshake.zig`: `0-RTT: accepted early data distinguishes authentication and handshake errors` | covered |
| Authenticated EndOfEarlyData with a nonzero body length after early_data acceptance | `UnexpectedMessage` → `unexpected_message` (RFC 8446 §4.5) | `ServerHandshake.zig`: `0-RTT: accepted early data distinguishes authentication and handshake errors` | covered |

## Parser and crypto boundary fuzz surfaces

| Surface | Fuzz/evidence | Row |
|---|---|---|
| `frame.parseHeader` | `frame.zig`: `fuzz: parseHeader handles arbitrary input` | covered |
| `alert.parse` | `alert.zig`: `fuzz: parse handles arbitrary input` | covered |
| `server_hello.parse` / HRR parse | `server_hello.zig`: parse fuzz targets | covered |
| `client_hello.parse` | `client_hello.zig`: parse fuzz target | covered |
| `NewSessionTicket.parse` | `NewSessionTicket.zig`: parse fuzz target | covered |
| `RecordLayer.decrypt` | `RecordLayer.zig`: `fuzz: decrypt handles arbitrary input` | covered |
| client `HandshakeReader` and decrypted flight processing | `ClientHandshake.zig`: fuzz targets | covered |
| server `handleRecord` pre-auth and post-auth | `ServerHandshake.zig`: fuzz targets | covered |
| Certificate parsing and verification | `certificate.zig`: `fuzz: parse handles arbitrary input`; `certificate_name_constraints_differential_test.zig` fuzz target; unit and differential verification tests | covered for parsing; chain verification stays unit/differential-covered, not fuzz-driven |
| EncryptedExtensions parsing | Unit tests cover ALPN, unsolicited ALPN, malformed lengths, forbidden TLS 1.3 extension placements, unknown/unsolicited extension rejection (`parse: rejects unknown unsolicited extension`), offered-only SNI acknowledgments (`parse: accepts server_name acknowledgment when SNI offered`, `parse: rejects server_name when SNI not offered`, `parse: rejects server_name acknowledgment with non-empty extension_data`), and offered-only `record_size_limit` acknowledgments (`parse: rejects unoffered record_size_limit in EncryptedExtensions`, `parse: accepts offered record_size_limit in EncryptedExtensions`, `parse: rejects malformed record_size_limit in EncryptedExtensions`); indirect client-flight fuzz covers state-machine dispatch | partial — no standalone parser fuzz target |

## Verification gates

| Gate | Response if missing/invalid | Evidence | Row |
|---|---|---|---|
| Client must verify Certificate before CertificateVerify | Missing/wrong order yields `error.UnexpectedMessage`; parse/policy failures stop handshake | `ClientHandshake.zig` state-machine tests and certificate tests | covered |
| Client must verify CertificateVerify before Finished | Bad signature yields `error.SignatureVerificationFailed` and no promotion | `processFlight: rejects wrong CertificateVerify signature` | covered |
| Client must verify server Finished before application keys | Bad verify_data yields `error.InvalidVerifyData`; `clientFinished()` also checks progress | `processFlight: rejects wrong server Finished verify_data`; `clientFinished` tests | covered |
| Server must verify client Finished before application keys | Bad/missing Finished prevents `.connected` | `ServerHandshake.zig`: `processClientFinished: verifies Finished and installs app keys`, `processClientFinished: rejects bad verify_data` | covered |

## External conformance coverage

The gated external negative runner is tlsfuzzer, and it exercises the ztls
server. Its negative conversations include corrupted application data, truncated
KeyUpdate, invalid KeyUpdate request, oversized records, close_notify before
handshake, garbage pre-handshake, Finished before handshake, truncated/empty
ClientHello, malformed key_share, unshared ALPN, and unsupported cipher suite.

TLS-Anvil client/server workflows provide broad external coverage outside PR
`just ci`, and BoGo is durably deferred in `BOGO_DEFERRED.md`. The local
`ClientHandshake` bad-server tests still carry the highest-risk supported-surface
paths directly and remain the fastest regression signal.

## Open gaps surfaced by the inventory

#124 tracks the focused negative-test and parser-fuzz gaps below.

These are deliberately not closed by writing the inventory:

- The RFC matrix distinguishes engine tests from caller-owned PSK and replay
  obligations. Read `PRODUCTION_READINESS.md` for the resulting readiness claim.
- Full bettertls harness execution remains outside the local name-constraints
  fixture set; if it becomes a supported lane, give it its own issue.
- BoGo remains deferred per `BOGO_DEFERRED.md`; TLS-Anvil server/client evidence
  lives in the dedicated workflows.
- P-521, FFDHE, exporters, and unscheduled extensions remain outside the
  current supported surface. RFC 10024 malformed-share and unsupported-policy
  rejection is covered in the core handshake/parser suites; evidence status
  lives in `PRODUCTION_READINESS.md`.
- The following negative-side families are covered for the supported surface:
  HRR (in-memory end-to-end + TLS-Anvil; formerly #1), PSK/binder verification
  (formerly #2), 0-RTT rejection paths (EndOfEarlyData absence, server-sent
  EndOfEarlyData, `max_early_data_size` exceeded, no-PSK-but-early-data-offered,
  server-declined-0-RTT decision — formerly #3), and client certificate
  authentication (rejects offered-scheme violations, EKU/KU violations,
  missing chain — formerly #4). A declining server skips already-in-flight early
  records on both §4.2.10 decline paths (#111): bounded trial-deprotection
  with the handshake key on the regular 1-RTT response, and outer-content-type
  skipping while ClientHello2 is pending after HelloRetryRequest. Anti-replay
  for 0-RTT remains caller-owned (no engine replay cache); the accepted-0-RTT
  decrypt-failure alert mapping is covered by `0-RTT: accepted early data
  distinguishes authentication and handshake errors` (#116).
- Oversized SNI hostnames are accepted on the parse path and surfaced to the
  caller; the encode path is capped. The policy difference is tracked by #123.
- The ServerHello oversized-session-id overflow test asserts refusal rather than
  the exact error tag; the cap itself is enforced, so this is an evidence nit,
  not a gap.
- Some server-side client-Finished negative paths exist structurally but lack
  focused unit tests (Finished with a trailing message; a non-Finished
  handshake in `wait_client_finished`).
