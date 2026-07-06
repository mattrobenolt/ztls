# Handshake / TLS_AES_128_GCM_SHA256 / 1

## Boundary

This row measures a full in-memory TLS 1.3 handshake with no resumption, X25519
key exchange, and a server ECDSA P-256 certificate. It is deliberately reported
as **non-equivalent** across ztls, OpenSSL libssl, and rustls because the auth
policy work differs:

- ztls skips chain-anchor trust verification with `insecure_no_chain_anchor = true`
  but still verifies CertificateVerify, hostname `ztls.server.test`, and leaf
  policy.
- OpenSSL libssl uses `SSL_VERIFY_NONE`, skipping trust-store validation and
  hostname checking. This perf capture shows that it still performs
  CertificateVerify signature verification through `tls_process_cert_verify`.
- rustls uses the benchmark `NoVerifier`, which skips server certificate policy
  and `verify_tls13_signature`; it still performs server-side signing and normal
  key-schedule/record work.

Because of that asymmetry, the table below is transparency evidence only. Do not
read the vs-base direction as a fair handshake performance claim.

Wall-time context comes from
`docs/research/perf/20260705-194022-ec2-c7i-2xlarge/benchstat.txt`, where ztls
measured `387.9 µs/op`, OpenSSL libssl `347.8 µs/op`, and rustls `147.2 µs/op`.

## Perf counter summary

Counters below are normalized by summed `stat_iteration_counts` from each row's
`metadata.txt`. `ns/op` is from this perf-instrumented run, so use it only for
context.

| impl | ns/op median | cycles/op | instructions/op | branches/op | branch misses/op | L1D misses/op |
|---|---:|---:|---:|---:|---:|---:|
| ztls | 436995.0 | 1439748.8 | 4754323.8 | 247285.8 | 507.604 | 7874.01 |
| openssl | 393776.0 | 1292365.6 | 3805507.3 | 372345.1 | 1662.765 | 7475.05 |
| rustls | 166356.5 | 549157.7 | 1789400.1 | 65436.2 | 403.248 | 1578.63 |

The counters confirm the non-equivalence: rustls executes much less work in this
row, not merely the same work faster. It uses about 38% of ztls' cycles/op and
about 38% of ztls' instructions/op. The hot-symbol evidence explains why.

## Hot symbols

ztls samples show X25519 key generation/derivation plus ECDSA signing and real
ECDSA verification:

```text
26.96% EVP_PKEY_new_raw_private_key
26.25% ecx_import -> ossl_x25519_public_from_private
15.69% ossl_x25519 -> x25519_scalar_mult
15.20% EVP_DigestVerifyFinal
15.10% ossl_ecdsa_verify
14.90% ossl_ecdsa_simple_verify_sig
```

OpenSSL libssl samples prove that `SSL_VERIFY_NONE` still performs
CertificateVerify signature verification in this harness:

```text
94.44% state_machine
19.64% tls_process_cert_verify
18.50% EVP_DigestVerifyFinal
18.43% ecdsa_digest_verify_final
18.13% ossl_ecdsa_simple_verify_sig
16.98% tls_construct_server_hello
7.83%  ossl_ecx_compute_key -> ossl_x25519
7.63%  EVP_PKEY_generate -> x25519_gen
```

rustls samples do not show a CertificateVerify verification path. They are
mostly X25519/key-schedule work plus a small amount of server-side ECDSA signing
and allocation/buffer overhead:

```text
18.52% ring_core_0_17_14__x25519_ge_scalarmult_base_adx
17.48% ring_core_0_17_14__fiat_curve25519_adx_mul
11.61% ring_core_0_17_14__fiat_curve25519_adx_square
8.47%  ring_core_0_17_14__x25519_scalar_mult_adx
5.41%  ring_core_0_17_14__sha256_block_data_order_hw
3.16%  ring_core_0_17_14__ecp_nistz256_ord_sqr_mont_adx
0.45%  ring::ecdsa::signing::format_rs_asn1::format_integer_tlv
```

## Interpretation

This row should stay out of the comparable TLS table. ztls and libssl both pay
for CertificateVerify verification; rustls does not. ztls additionally performs
hostname and leaf-policy checks that libssl and rustls skip. The perf evidence
makes that difference visible instead of leaving it as prose handwaving.

The libssl result is useful: it removes one opaque point from the earlier docs.
With `SSL_VERIFY_NONE`, libssl skips trust-store/hostname policy but still
verifies the TLS CertificateVerify signature as protocol integrity. That means
ztls-vs-libssl is closer to comparable than ztls-vs-rustls, but still not fully
equivalent because ztls runs hostname and leaf-policy checks.

The rustls number remains useful only as a diagnostic lower-bound for a
NoVerifier handshake path. It is not a fair comparison to ztls' authenticated
client path.

## Caveats

Perf `LLC-load-misses` was not supported on this host. The absolute ns/op values
from this perf run should not replace the wall-time capture; perf instrumentation
changes timing. This evidence resolves the methodology question by documenting
and mechanically separating the non-equivalent handshake row, not by aligning the
harnesses.
