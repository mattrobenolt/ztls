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
| Decrypted inner plaintext has no non-zero content type byte | `error.InvalidInnerPlaintext` | `RecordLayer.decrypt` fuzz target | partial — no dedicated unit test |
| Unknown or illegal inner content type after handshake | `error.UnexpectedRecord` | `ClientHandshake.zig`: `handleRecord: post-handshake unexpected inner content type is rejected`; `ServerHandshake.zig`: `handleRecord: illegal post-handshake inner content type is rejected` | covered |
| Non-0x0303 record legacy version | Ignored as a legacy field; version negotiation lives in `supported_versions` | RFC 8446 §5.1 behavior; no branch on the field | covered by design |

## Alert records

| Malformed input | ztls response | Evidence | Row |
|---|---|---|---|
| Alert payload shorter than two bytes | `error.UnexpectedEof` | `alert.zig`: `parse: truncated`; fuzz `alert.parse` | covered |
| `close_notify` | `.closed` in connected state or no-op during handshake | `ClientHandshake.zig` / `ServerHandshake.zig`: `handleRecord: close_notify returns closed`; send-alert tests | covered |
| Fatal or non-close alert from peer | `error.PeerAlert` | `ClientHandshake.zig`: plaintext/encrypted fatal alert tests; `ServerHandshake.zig`: fatal alert tests | covered |
| Unknown alert description or warning-level §6.2 alert | Treated as a TLS 1.3 error/fatal alert regardless of the legacy AlertLevel byte | `alert.zig`: `parse: warning-level error alert is fatal`, `parse: unknown alert description is fatal` | covered |

## Client-side bad server behavior

| Malformed input | ztls response | Evidence | Row |
|---|---|---|---|
| Plaintext application data before ServerHello | `error.UnexpectedRecord` | `ClientHandshake.zig`: `handleRecord: application_data before ServerHello is rejected` | covered |
| Malformed ServerHello length/body | Parser error; caller can emit `decode_error` | `ClientHandshake.zig`: `handleRecord: malformed ServerHello is rejected`; `server_hello.zig` parser tests | covered |
| ServerHello unknown cipher-suite code point | `error.InvalidEnumTag`, not enum-unreachable panic | `server_hello.zig`: `parse: rejects unknown cipher suite`; `parseHelloRetryRequest: rejects unknown cipher suite` | covered |
| ServerHello HelloRetryRequest sentinel | `error.HelloRetryRequest` because HRR is not implemented yet | `server_hello.zig`: `parse: rejects HelloRetryRequest`; HRR support tracked by #1 | covered/out-of-scope |
| ServerHello missing required extensions | `error.MissingExtension` | `server_hello.zig`: `parse: missing extensions` | covered |
| ServerHello duplicate singleton extensions | `error.DuplicateExtension` | `server_hello.zig`: duplicate supported_versions/key_share tests | covered |
| ServerHello unsupported `supported_versions` value | `error.UnsupportedTlsVersion` | `server_hello.zig`: `parse: unsupported TLS version` | covered |
| ServerHello invalid `legacy_version` | `error.InvalidLegacyVersion` | `server_hello.zig`: `parse: rejects invalid legacy version` | covered |
| ServerHello mismatched `legacy_session_id_echo` | `error.InvalidSessionIdEcho` | `server_hello.zig`: `parse: rejects mismatched session id echo`; `ClientHandshake.zig`: `processServerHello: rejects mismatched session id echo` | covered |
| ServerHello non-zero `legacy_compression_method` | `error.InvalidCompressionMethod` | `server_hello.zig`: `parse: rejects non-zero compression method` | covered |
| ServerHello unsupported or malformed key_share group/length | `error.UnsupportedKeyShareGroup` | Parser path exists | partial — no dedicated unit test |
| ServerHello legacy session id longer than 32 bytes | Not explicitly capped by parser | none | gap |
| ServerHello downgrade sentinel in random | Not explicitly checked | none | gap |
| Server selects a suite outside the client's offered list | Client currently offers the supported set and does not track a narrowed offer set | none | gap if client-side suite configurability is added |
| Encrypted flight message arrives out of order | `error.UnexpectedMessage`; caller can emit `unexpected_message` | `ClientHandshake.zig`: `processFlight: rejects Finished before EncryptedExtensions` | covered |
| Encrypted application data before handshake completion | `error.UnexpectedRecord`; caller can emit `unexpected_message` | `ClientHandshake.zig`: `handleRecord: encrypted application data during server flight is rejected` | covered |
| Encrypted fatal alert during server flight | `error.PeerAlert` | `ClientHandshake.zig`: `handleRecord: encrypted fatal alert during server flight` | covered |
| CertificateVerify signature is invalid | `error.SignatureVerificationFailed`; caller can emit `decrypt_error` | `ClientHandshake.zig`: `processFlight: rejects wrong CertificateVerify signature` | covered |
| Server Finished MAC is invalid | `error.InvalidVerifyData`; caller can emit `decrypt_error` | `ClientHandshake.zig`: `processFlight: rejects wrong server Finished verify_data`; `finished.zig`: `verify: wrong verify_data` | covered |
| Handshake message spans encrypted records without caller buffer | `error.UnexpectedEof` | `ClientHandshake.zig`: `processFlight: handshake message spanning records needs buffer` | covered |
| Handshake message spans encrypted records with caller buffer | Reassembled and processed | `ClientHandshake.zig`: `processFlight: reassembles handshake message split across records` | covered |
| Certificate malformed DER, bad chain, hostname mismatch, key-usage/EKU/name-constraints rejection | Certificate parse/policy errors | `certificate.zig` parser/policy/name-constraints tests; Wycheproof boundary tests | partial — not every path is driven through `ClientHandshake` |
| Certificate arrives with no trust bundle and no explicit insecure opt-in | `error.MissingTrustAnchor` | `certificate.zig`: `parse: rejects missing trust anchor by default`; `ClientHandshake.zig`: `processFlight: rejects unanchored Certificate by default` | covered |
| Server Certificate request_context is non-empty | Not explicitly rejected in server-certificate parsing | none | gap |
| Leaf public key exceeds retained buffer | `error.CertificateKeyTooLarge` | path exists | partial — no dedicated unit test |
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
| ChangeCipherSpec before ClientHello | Silently discarded per RFC 8446 Appendix D.4 | `ServerHandshake.zig`: `handleRecord: drops ChangeCipherSpec while waiting for ClientHello` | covered |
| application_data before connected | `error.UnexpectedRecord` | `ServerHandshake.zig`: `handleRecord: rejects application_data before connected` | covered |
| Unsupported cipher-suite offer | `error.UnsupportedCipherSuite` | `ServerHandshake.zig`: `acceptClientHello: rejects unsupported suite`; tlsfuzzer unsupported suite test | covered |
| No shared key exchange group | `error.UnsupportedKeyShare` / parse rejection | `client_hello.zig`: `parse: no shared group is rejected (HRR not implemented)` | covered/out-of-scope |
| ClientHello duplicate extension | `error.DuplicateExtension` for covered extensions | `client_hello.zig`: duplicate supported_groups test | partial — not every singleton extension has a duplicate test |
| ClientHello missing required extension | `error.MissingExtension` / unsupported version/group | `client_hello.zig`: malformed ClientHello tests | covered |
| Unshared ALPN | `error.NoApplicationProtocol` | tlsfuzzer unshared ALPN test | partial — no local unit test |
| Oversized ClientHello legacy session id | Not explicitly capped by parser | none | gap |
| Oversized SNI hostname on parse path | Not explicitly capped by server parser | encode path rejects too-long server_name | gap |
| Bad client Finished MAC | `error.InvalidVerifyData` | server Finished verification path exists | partial — no dedicated unit test |
| Client Finished plus extra handshake message | `error.UnexpectedMessage` | path exists in `processClientFinishedPlaintext` | partial — no dedicated unit test |
| Non-Finished handshake in `wait_client_finished` | `error.UnexpectedMessage` | path exists | partial — no dedicated unit test |
| Connected-state KeyUpdate flood | `error.TooManyKeyUpdates` | `ServerHandshake.zig`: `handleRecord: KeyUpdate flood is rejected` | covered |
| Connected-state KeyUpdate not at record boundary | `error.UnexpectedMessage` | `ServerHandshake.zig`: `handleRecord: KeyUpdate not at record boundary is rejected` | covered |
| Simultaneous KeyUpdate requests | Both sides remain connected and ratchet safely | `ServerHandshake.zig`: `key update: simultaneous update_requested remains connected` | covered |
| Connected-state illegal inner content type | `error.UnexpectedRecord` | `ServerHandshake.zig`: `handleRecord: illegal post-handshake inner content type is rejected` | covered |

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
| Certificate parsing and verification | Unit tests and indirect client-flight fuzz | partial — no standalone certificate fuzz target |
| EncryptedExtensions parsing | Unit tests cover ALPN, unsolicited ALPN, malformed lengths, and forbidden TLS 1.3 extension placements; indirect client-flight fuzz covers state-machine dispatch | partial — no standalone parser fuzz target |

## Verification gates

| Gate | Response if missing/invalid | Evidence | Row |
|---|---|---|---|
| Client must verify Certificate before CertificateVerify | Missing/wrong order yields `error.UnexpectedMessage`; parse/policy failures stop handshake | `ClientHandshake.zig` state-machine tests and certificate tests | covered |
| Client must verify CertificateVerify before Finished | Bad signature yields `error.SignatureVerificationFailed` and no promotion | `processFlight: rejects wrong CertificateVerify signature` | covered |
| Client must verify server Finished before application keys | Bad verify_data yields `error.InvalidVerifyData`; `clientFinished()` also checks progress | `processFlight: rejects wrong server Finished verify_data`; `clientFinished` tests | covered |
| Server must verify client Finished before application keys | Bad/missing Finished prevents `.connected` | `ServerHandshake.zig`: `processClientFinished: verifies Finished and installs app keys` | partial — bad Finished unit tests still absent |

## External conformance coverage

The gated external negative runner today is tlsfuzzer, and it exercises the ztls
server. Its negative conversations include corrupted application data, truncated
KeyUpdate, invalid KeyUpdate request, oversized records, close_notify before
handshake, garbage pre-handshake, Finished before handshake, truncated/empty
ClientHello, malformed key_share, unshared ALPN, and unsupported cipher suite.

Client-side external negative runners are not gated yet. TLS-Anvil and BoGo are
tracked by #9. The local `ClientHandshake` bad-server tests cover the highest
risk supported-surface paths, but they are not a replacement for a broad external
client runner.

## Open gaps surfaced by the inventory

These are deliberately not closed by writing the inventory:

- RFC MUST matrix exists, but its `GAP`/`PARTIAL` rows remain #25 follow-up.
- Full bettertls harness execution remains outside the local name-constraints
  fixture set (#9).
- BoGo/TLS-Anvil execution remains #9.
- HRR, PSK/resumption, 0-RTT, client certificates, and PQ/non-X25519 groups are
  out of the current supported surface and tracked by their feature issues.
- ServerHello downgrade-sentinel handling is not explicitly tested.
- Legacy session id length caps on parse paths need dedicated enforcement/tests.
- Server Certificate `request_context` non-empty rejection needs a targeted test.
- Some server-side client-Finished negative paths exist structurally but lack
  focused unit tests.
