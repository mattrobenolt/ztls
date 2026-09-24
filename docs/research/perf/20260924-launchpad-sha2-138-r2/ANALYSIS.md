# #138 round 2: HMAC keyed once per secret

The setup is in `metadata.txt`. Round 1 is in
`../20260924-launchpad-sha2-138/`.

## Result

A native fork build now needs fewer cycles per handshake than a native base
build, in both field kex rows. A baseline fork build is within 0.5% of a
native fork build. Round 1 cost 0.9-1.2% on the native X25519 row. Round 2
removes that cost.

## Change

- `src/hmac.zig` keys HMAC once: `init` absorbs the inner and outer pad
  blocks, and each `mac` copies the two states. An expand under a keyed
  secret costs two compressions instead of four.
- The handshakes key each secret once for the labels derived from it.
- The server derived the client and server handshake traffic secrets twice
  (`makeHandshakeArm`, then again for the record layers). It now derives
  them once.
- Without a PSK, the HandshakeSecret salt
  (Derive-Secret(EarlySecret, "derived", "")) is a comptime constant.

## HMAC count for one server handshake

Measured with counters in a scratch copy (`hmac-count-*.diff.txt`). The
setup is TLS_AES_128_GCM_SHA256, no PSK, no HelloRetryRequest. The same
counts hold for TLS_AES_256_GCM_SHA384.

| | base (std HMAC) | round 2 |
|---|---:|---:|
| HMAC keyings | 25 | 14 |
| MACs (expands, extracts, Finished) | 25 | 22 |
| compressions (2 per keying, 2 per MAC) | 100 | 72 |

The 22 MACs share keys as follows:

| key | MACs under one keying |
|---|---|
| handshake secret | c hs traffic, s hs traffic |
| client handshake traffic secret | finished, key, iv |
| server handshake traffic secret | finished, key, iv |
| server application traffic secret | key, iv |
| client application traffic secret | key, iv |
| master secret (at client Finished) | c ap traffic, res master |
| single use (8) | handshake extract, server Finished, two "derived", two master extracts, s ap traffic, client Finished |

That makes 14 MACs on 6 shared keyings, and 8 single-use MACs. Three MACs are
gone: the two duplicate handshake traffic secrets and the comptime "derived"
salt. The master secret is still derived twice, once for the server flight
and once at client Finished. Keeping it between the two calls would need a
struct field, which the memory rule does not allow.

## Field row: handoff `handshake-c64`, TLS_AES_128_GCM_SHA256

Cycles per handshake: the median of five repetitions, then the range.

| build | X25519 run 1 | X25519 run 2 | X25519MLKEM768 |
|---|---:|---:|---:|
| base native | 167,476 (166,562-168,340) | 167,876 (167,657-167,957) | 208,208 (207,959-209,743) |
| base baseline | 242,800 (+45.0%) | 242,932 (+44.7%) | 300,173 (+44.2%) |
| fork native | 166,676 (166,521-167,190) -0.5% | 166,876 (166,340-167,767) -0.6% | 207,157 (206,964-207,500) -0.5% |
| fork baseline | 167,357 (167,001-167,812) -0.1% | 167,396 (166,894-167,724) -0.3% | 207,240 (206,878-208,388) -0.5% |

Fork native has the lower median in all three runs. On the X25519MLKEM768
row the ranges do not overlap. On the two X25519 rows they overlap at the
edges. Instructions per handshake also fall: 518,284 and 518,210 against
519,457 and 519,819 (X25519), and 689,888 against 692,417 (X25519MLKEM768).

Fork baseline against fork native: +0.4%, +0.3%, and +0.04%.

## In-memory ztls handshake (client and server in one process)

Cycles per handshake (cycles:u slope), the median of five repetitions. The
r1 and r2 rows ran in the same interleaved capture as the base rows.

| build | TLS_AES_128_GCM_SHA256 | TLS_AES_256_GCM_SHA384 |
|---|---:|---:|
| base native | 512,345 | 676,787 |
| base baseline | 657,643 (+28.4%) | 711,160 (+5.1%) |
| r1 native | 512,040 (-0.1%) | 570,166 (-15.8%) |
| r1 baseline | 526,657 (+2.8%) | 592,621 (-12.4%) |
| r2 native | 508,640 (-0.7%) | 549,756 (-18.8%) |
| r2 baseline | 522,856 (+2.1%) | 563,762 (-16.7%) |

In memory, r2 baseline is 2.8% slower than r2 native. The perf reports
attribute that difference to `compiler_rt.memset`: 1.93% of cycles in r2
native, 4.72% in r2 baseline, 2.56% in base native, and 4.29% in base
baseline. Zig's compiler_rt memset compiles for the target CPU, as std SHA-2
did. The wipes and zero fills of the client and server structs call it. The
SHA-2 symbols are libcrypto's in both r2 builds. The server-only field row
shows a smaller share of this cost (0.0-0.4%). Routing ztls wipes to a
runtime-dispatched memset is outside #138.

## Per-connection struct sizes

`@sizeOf` in bytes, aarch64-linux, Zig 0.16.0. "Suite" is the
ServerHandshake `suite_state` type (`src/suite_state.zig`).

| backend | struct | base a40f1cc | r1 9881a69 | r2 |
|---|---|---:|---:|---:|
| OpenSSL 3.6.4 | ServerHandshake | 19,408 | 19,360 | 19,360 |
| | EstablishedSession | 736 | 712 | 712 |
| | Suite | 544 | 520 | 520 |
| | ClientHandshake | 3,488 | 3,456 | 3,456 |
| AWS-LC 5.9.0 | ServerHandshake | 21,120 | 21,064 | 21,064 |
| | EstablishedSession | 1,872 | 1,848 | 1,848 |
| | Suite | 544 | 520 | 520 |
| | ClientHandshake | 5,184 | 5,160 | 5,160 |
| BoringSSL 0.20260803.0 | ServerHandshake | 21,088 | 21,024 | 21,024 |
| | EstablishedSession | 1,856 | 1,824 | 1,824 |
| | Suite | 544 | 512 | 512 |
| | ClientHandshake | 5,168 | 5,128 | 5,128 |

Round 2 changes no size. Round 1 made each struct smaller, because the
backend SHA-2 contexts are smaller than std's. The test "per-connection
structs stay within their measured sizes" in `src/ServerHandshake.zig` pins
the r2 sizes as ceilings for each backend.
