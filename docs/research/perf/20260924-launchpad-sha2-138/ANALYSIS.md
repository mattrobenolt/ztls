# Handshake SHA-2 on the libcrypto backend (#138)

The setup is in `metadata.txt`. The raw outputs are in this directory.

## Result

A `-Dcpu=baseline` build now does a handshake in about the same cycles as a
`-Dcpu=native` build. Before this change it needed 43-44% more cycles. On a
native build, SHA-256 handshakes cost 0.2-1.2% more cycles in the handoff
field row. They cost the same in the in-memory ztls handshake. SHA-384
handshakes are 15.7% faster on a native build.

## Field row: handoff `handshake-c64`, TLS_AES_128_GCM_SHA256

Cycles per handshake: the median of five repetitions, then the range.

| build | X25519 run 1 | X25519 run 2 | X25519MLKEM768 |
|---|---:|---:|---:|
| base native | 169,089 (167,871-169,518) | 168,468 (168,116-172,458) | 208,450 (206,504-212,077) |
| base baseline | 242,234 (+43.3%) | 242,858 (+44.2%) | 300,837 (+44.3%) |
| fork native | 171,079 (+1.2%) | 170,030 (+0.9%) | 208,822 (+0.2%) |
| fork baseline | 172,111 (+1.8%) | 170,702 (+1.3%) | 210,002 (+0.7%) |

Base baseline repeats the #138 evidence (243,455, +43.6%). The fork removes
that gap: fork baseline is within 0.4-0.7% of fork native in every run.

Fork native is 0.9-1.2% slower than base native on the X25519 row. The two
runs do not overlap. The instruction count shows the same delta: 525,290 and
525,485 instructions per handshake against 519,394 and 519,638 (+1.1%). On
the X25519MLKEM768 row the delta is 0.2%, and the ranges overlap.

## In-memory ztls handshake (client and server in one process)

Cycles per handshake (cycles:u slope), the median of five repetitions.

| build | TLS_AES_128_GCM_SHA256 | TLS_AES_256_GCM_SHA384 |
|---|---:|---:|
| base native | 512,573 | 677,912 |
| base baseline | 657,524 (+28.3%) | 711,844 (+5.0%) |
| fork native | 512,001 (-0.1%) | 571,603 (-15.7%) |
| fork baseline | 527,012 (+2.8%) | 590,882 (-12.8%) |

The field suite cannot force a SHA-384 suite, so this table is the SHA-384
evidence. The fork-baseline residue against fork native (+2.9%, +3.4%) is not
SHA-2: the fork imports all SHA-2 from libcrypto. The rest of the in-memory
pair (the client path, ztls vector code) still compiles for the baseline CPU.
In the server-only field row this residue is 0.4-0.7%.

## SHA-2 operations (micro-benchmark)

Cycles per operation, the median of three repetitions.

| operation | std native | backend native | std baseline | backend baseline |
|---|---:|---:|---:|---:|
| HKDF-Expand, SHA-256 (one HMAC) | 464 | 477 | 2,698 | 470 |
| transcript, SHA-256 | 3,420 | 3,225 | 19,359 | 3,223 |
| HKDF-Expand, SHA-384 | 3,492 | 1,533 | 3,853 | 1,711 |
| transcript, SHA-384 | 15,921 | 6,389 | 16,458 | 6,400 |

Zig std SHA-256 uses the SHA2 instructions only when the target CPU has
them. Zig std SHA-384 does not use the SHA512 instructions on this host even
for `-Dcpu=native`. AWS-LC selects both at run time.

## Why fork native costs about 1% on the X25519 field row

This is an explanation that the data supports, not a proof.

- Each HMAC makes nine libcrypto calls (two `Init`, five `Update`, two
  `Final`) through the PLT. Std inlines the same work. The micro-benchmark
  measures +176 instructions and +13 cycles for each HMAC on native. A
  server handshake runs about 21 HMACs, so the instruction delta (+5,900
  per handshake) matches the call overhead.
- In the hot micro loop the overhead is about 270 cycles for each handshake.
  The field row measures 1,600-2,000. The difference is consistent with cold
  instruction-cache and TLB behavior for the libcrypto code in a proxy that
  runs other work between handshakes. This capture has no cache counters, so
  that part is a hypothesis.
- The in-memory handshake shows no delta (-0.1%). The overhead is small
  enough that the placement of the code decides it.

The candidate fix is fewer calls for each HMAC: precomputed ipad and opad
states for each PRK, which also removes two compressions from each
HKDF-Expand. That is a separate change and is not part of this capture.
