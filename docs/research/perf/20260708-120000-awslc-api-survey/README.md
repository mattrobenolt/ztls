# AWS-LC 5.0.0 API Survey — EC/RSA Key Construction & Signature Paths

## Purpose

Provenance record for ztls #60 slice C: measure and decide AWS-LC EC/RSA
key-construction and signature paths. This is an API survey, not a benchmark
capture — no measurement was taken because no alternative API exists to
compare against.

## Decision

**Keep the OpenSSL-compatible EC/RSA/signature path for AWS-LC.**

This is a **compatibility decision**, not a speed claim. AWS-LC 5.0.0 (a
BoringSSL fork) does not expose the OpenSSL 3.x provider API at all, so the
legacy `EC_KEY_*` / `EVP_PKEY_assign_*` / `d2i_*` / `EVP_DigestSign*` API
family used by `backend_openssl.zig` is the only key-construction/signature
path available. There is no alternative API to measure against.

## API Survey Evidence

**AWS-LC version:** 5.0.0 (Nix `nixpkgs#aws-lc.dev`)
**Header path:** `…/aws-lc-5.0.0-dev/include/openssl/`
**Derivation:** `/nix/store/sa23jx80d87f578pqbrrk50ww730hajy-aws-lc-5.0.0-dev`

### OpenSSL 3.x provider API — ABSENT

The following symbols were searched for across all headers in the AWS-LC
include directory. None were found:

- `EVP_PKEY_fromdata` / `EVP_PKEY_fromdata_init` — not in `openssl/evp.h`
- `OSSL_PARAM` / `OSSL_PARAM_construct_octet_string` / `OSSL_PARAM_construct_end` — not in any header
- `EVP_PKEY_CTX_new_from_name` / `EVP_PKEY_CTX_new_from_pkey` — not in `openssl/evp.h`
- `OSSL_PROVIDER` — not in any header
- `OSSL_DECODER` / `OSSL_ENCODER` — not in any header
- `provider.h` — file does not exist
- `core.h` — file does not exist
- `param_build.h` — file does not exist

### Legacy EC/RSA/signature API — PRESENT (the only path)

All of the following were confirmed present in the AWS-LC 5.0.0 headers:

- `openssl/ec_key.h`: `EC_KEY_new_by_curve_name`, `EC_KEY_set_private_key`,
  `EC_KEY_set_public_key`, `EC_KEY_check_key`, `EC_KEY_free`, `o2i_ECPublicKey`,
  `i2o_ECPublicKey`, `d2i_ECPrivateKey`
- `openssl/ec.h`: `EC_GROUP_new_by_curve_name`, `EC_POINT_new`,
  `EC_POINT_mul`, `EC_POINT_set_affine_coordinates`,
  `EC_POINT_get_affine_coordinates`, `EC_POINT_oct2point`, `EC_POINT_point2oct`
- `openssl/evp.h`: `EVP_PKEY_new`, `EVP_PKEY_assign_EC_KEY`,
  `EVP_PKEY_assign_RSA`, `EVP_PKEY_get1_EC_KEY`, `EVP_PKEY_CTX_new`,
  `EVP_PKEY_derive_init`, `EVP_PKEY_derive_set_peer`, `EVP_PKEY_derive`,
  `EVP_DigestSignInit` / `EVP_DigestSignUpdate` / `EVP_DigestSignFinal` /
  `EVP_DigestSign`, `EVP_DigestVerifyInit` / `EVP_DigestVerifyUpdate` /
  `EVP_DigestVerifyFinal`, `d2i_AutoPrivateKey`
- `openssl/rsa.h`: `d2i_RSAPublicKey`, `d2i_RSAPrivateKey`, `RSA_free`
- `openssl/ecdh.h`: `ECDH_compute_key`

### Build-side confirmation

`src/crypto/c_openssl.zig` already conditionally excludes `openssl/core.h`,
`openssl/core_names.h`, and `openssl/params.h` from the AWS-LC `@cImport`,
and has a comptime assertion that `OPENSSL_IS_AWSLC` is defined. The KEM
functions in `backend_aws_lc.zig` (which use `OSSL_PARAM` /
`EVP_PKEY_fromdata` in the OpenSSL backend) are stubbed out for AWS-LC and
return `error.LibcryptoFailed`; the capability flags for ML-KEM are false, so
the KEM path is never reached under AWS-LC.

## Why No Measurement

A measurement with nothing to compare against is not informative. The current
EC/RSA/signature path uses the legacy API, which is the only API AWS-LC
provides. There is no "alternative path" to benchmark against. A prior scratch
measurement on OpenSSL 3.6.2 showed the legacy path is faster than naive
`EVP_PKEY_fromdata`/decoder replacements on that backend, reinforcing that the
legacy path is not a compromise — but the AWS-LC decision rests on the API
survey (no alternative exists), not on a speed claim.

## Provenance

See `metadata.txt` for git revision, host, and AWS-LC derivation paths.
