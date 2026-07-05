# AppPingPong / TLS_AES_128_GCM_SHA256 / 1350

## Boundary

This row measures one application-data ping-pong on an already-connected TLS
1.3 session: client encrypt/write, server decrypt/read, server encrypt/write,
client decrypt/read. There is no kernel I/O. ztls uses caller-owned buffers;
OpenSSL uses libssl over memory BIOs; rustls uses its in-memory buffers and
transfer shim. This is one of the strongest comparable TLS rows, with the usual
caveat that the libraries expose different memory-transport APIs.

Wall-time context comes from
`docs/research/perf/20260705-194022-ec2-c7i-2xlarge/benchstat.txt`: ztls measured
`785.7 ns/op`, OpenSSL libssl `1845.0 ns/op`, and rustls `1383.6 ns/op` on the
same EC2 instance shape.

## Perf counter summary

Counters below are normalized by summed `stat_iteration_counts` from each row's
`metadata.txt`. `ns/op` is from this perf-instrumented run, so use it only for
context.

| impl | ns/op median | cycles/op | instructions/op | branches/op | branch misses/op | L1D misses/op |
|---|---:|---:|---:|---:|---:|---:|
| ztls | 926.7 | 2934.8 | 9151.8 | 1239.4 | 0.061 | 0.28 |
| openssl | 2173.0 | 6878.0 | 22046.1 | 3872.0 | 1.790 | 34.08 |
| rustls | 1668.2 | 5354.8 | 17085.1 | 1985.5 | 0.968 | 1.34 |

The wall-time ordering is explained by the counters: ztls executes about 42.7%
of libssl's cycles/op and 41.5% of libssl's instructions/op. Against rustls,
ztls executes about 54.8% of cycles/op and 53.6% of instructions/op. Branch and
L1D miss counts are also lower.

## Hot symbols

ztls is dominated by OpenSSL's AES-GCM primitive path:

```text
67.81% ossl_gcm_stream_update
58.12% vaes_gcm_cipherupdate
27.35% ossl_aes_gcm_decrypt_avx512
26.07% ossl_aes_gcm_encrypt_avx512
35.24% EVP_DecryptUpdate
34.69% EVP_EncryptUpdate
```

OpenSSL libssl spends less of the sample in raw AES-GCM and more in libssl
record/BIO machinery:

```text
56.40% tls13_cipher
15.99% EVP_DecryptUpdate
14.45% EVP_EncryptUpdate
4.33%  EVP_CIPHER_CTX_ctrl
4.26%  EVP_CipherInit_ex
3.62%  WPACKET_put_bytes__
2.76%  WPACKET_init_static_len
```

rustls is dominated by ring AES-GCM plus buffer/copy/allocator work:

```text
20.15% ring_core_0_17_14__aes_gcm_enc_update_vaes_avx2
17.96% ring_core_0_17_14__aes_gcm_dec_update_vaes_avx2
8.34%  ring_core_0_17_14__gcm_ghash_vpclmulqdq_avx2_1
5.54%  rustls::vecbuf::ChunkVecBuffer::write_to
4.59%  __memmove_avx512_unaligned_erms
3.70%  __libc_malloc2
2.79%  ConnectionCore::process_new_packets
```

## Interpretation

For this row, the evidence supports the design hypothesis: ztls's caller-owned
record path reaches the OpenSSL AES-GCM primitive with substantially less TLS
wrapper work than libssl's memory-BIO path, and less buffer/copy/allocator work
than the rustls in-memory harness. This is no longer just a wall-time claim; the
normalized counters and sampled symbols agree.

The strongest concrete result is that ztls does less work per ping-pong:
fewer cycles, fewer instructions, fewer branches, and fewer L1D misses. The
OpenSSL libssl row shows visible WPACKET and EVP context setup/control overhead
inside `tls13_cipher`. The rustls row shows ring AES-GCM plus buffer movement and
allocator symbols.

## Caveats

The row is comparable, not identical. ztls, libssl, and rustls expose different
memory transport APIs, and that difference is part of the benchmark boundary.
Perf `LLC-load-misses` was not supported on this host. The absolute ns/op values
from this perf run should not replace the wall-time capture; perf instrumentation
changes timing.
