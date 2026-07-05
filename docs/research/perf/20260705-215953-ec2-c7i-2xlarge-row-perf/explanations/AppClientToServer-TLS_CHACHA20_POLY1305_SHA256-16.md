# AppClientToServer / TLS_CHACHA20_POLY1305_SHA256 / 16

## Boundary

This row measures one 16-byte application-data record from client to server on
an already-connected TLS 1.3 session. ztls uses caller-owned buffers and OpenSSL
EVP ChaCha20-Poly1305; OpenSSL uses libssl over memory BIOs; rustls uses ring's
ChaCha20-Poly1305 path and its in-memory transfer shim.

Wall-time context comes from
`docs/research/perf/20260705-194022-ec2-c7i-2xlarge/benchstat.txt`: ztls measured
`1123.0 ns/op`, OpenSSL libssl `1971.0 ns/op`, and rustls `503.5 ns/op`. This
is the small-record ChaCha anomaly where rustls is clearly faster than ztls.

## Perf counter summary

Counters below are normalized by summed `stat_iteration_counts` from each row's
`metadata.txt`. `ns/op` is from this perf-instrumented run, so use it only for
context.

| impl | ns/op median | cycles/op | instructions/op | branches/op | branch misses/op | L1D misses/op |
|---|---:|---:|---:|---:|---:|---:|
| ztls | 1321.0 | 4180.3 | 6331.6 | 927.5 | 0.099 | 0.27 |
| openssl | 2284.0 | 7247.5 | 12534.9 | 2226.6 | 1.115 | 0.94 |
| rustls | 594.9 | 1883.0 | 5261.8 | 555.8 | 0.063 | 0.12 |

The counters explain the wall-time ordering. ztls is doing far less work than
libssl, but rustls does even less: about 45.0% of ztls's cycles/op and 83.1% of
ztls's instructions/op. The cycle gap is larger than the instruction gap, so the
primitive implementation and instruction efficiency matter here, not only wrapper
code volume.

## Hot symbols

ztls is dominated by OpenSSL's ChaCha20-Poly1305 AEAD path:

```text
65.76% chacha20_poly1305_aead_cipher
57.92% chacha20_poly1305_cipher
37.12% ChaCha20_avx512
33.62% chacha20_cipher
29.44% EVP_EncryptUpdate
```

rustls is dominated by ring's direct ChaCha20-Poly1305 implementation with some
in-memory buffer overhead:

```text
25.65% ring_core_0_17_14__chacha20_poly1305_seal_avx2
24.13% ring_core_0_17_14__chacha20_poly1305_open_avx2
5.14%  __memmove_avx512_unaligned_erms
4.36%  ConnectionCore::process_new_packets
4.33%  ChunkVecBuffer::write_to
2.00%  malloc
```

OpenSSL libssl is the worst of both worlds for this row: libssl/BIO wrapper work
plus OpenSSL ChaCha20-Poly1305. Its normalized counters are roughly 1.73x ztls
cycles/op and 1.98x ztls instructions/op.

## Interpretation

The evidence supports a narrow conclusion: ztls beats libssl for this row by
avoiding much of libssl's wrapper path, but rustls wins because its direct ring
ChaCha20-Poly1305 path is much cheaper for tiny records than ztls's OpenSSL EVP
ChaCha20-Poly1305 path. This is a real measured loss for ztls on small ChaCha
records, not noise.

The most plausible optimization target is not the ztls record framing code. The
ztls samples are overwhelmingly in OpenSSL's ChaCha20-Poly1305 symbols, while
branch and L1D miss counts are already low. If this row matters, the fix is
probably a backend-specific faster ChaCha path or accepting that OpenSSL EVP has
small-record overhead that ring avoids.

## Caveats

This row only covers 16-byte records. At larger ChaCha record sizes the wall-time
capture shows the gap narrows around 1350 bytes and ztls pulls ahead by 8192
bytes. Perf `LLC-load-misses` was not supported on this host. The absolute ns/op
values from this perf run should not replace the wall-time capture; perf
instrumentation changes timing.
