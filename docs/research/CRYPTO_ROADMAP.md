# Crypto backend roadmap

ztls uses OpenSSL/libcrypto for AEAD record protection, with OpenSSL also
present in benchmark and interop harnesses. `std.crypto` remains fine for small,
internal primitives such as SHA-2/HMAC/HKDF where a libcrypto call would only add
fallible runtime plumbing without buying a meaningful backend boundary.

Production crypto should come from the libcrypto family where the primitive is a
real backend concern. OpenSSL/libcrypto is the first concrete backend target
because it is already in the dev shell, benchmark ladder, and interop harnesses.
AWS-LC must remain a first-class design target, not an accidental maybe-later
drop-in.

The product question is no longer whether to avoid libcrypto. It is how to use
libcrypto-family primitive APIs without importing libssl machinery, without
giving up ztls' Sans-I/O state-machine boundary, and while being honest that
production backends may link libc and allocate inside backend/provider code.

## Backend allocation contract: honest, explicit, bounded

OpenSSL 3 EVP cannot honestly be described as allocation-free. `EVP_CIPHER_CTX`
is opaque and heap-allocated through `EVP_CIPHER_CTX_new`; provider-backed
ciphers can allocate internal algorithm contexts during init; OpenSSL's AES-GCM
and ChaCha20-Poly1305 provider `newctx` paths use OpenSSL heap allocation.
Provider fetch/setup may also allocate.

That fact does not disqualify libcrypto-family production crypto. It changes the
contract:

1. ztls-owned TLS engine code remains allocator-free, caller-buffered, and
   Sans-I/O;
2. production crypto backends may link libc and may perform backend/provider-owned
   allocation behind the primitive API;
3. backend allocation behavior must be documented and kept behind initialization,
   context, or provider boundaries as much as the chosen library permits;
4. no documentation or code should claim OpenSSL-compatible EVP/provider paths
   preserve a strict no-heap invariant.

AWS-LC/BoringSSL-style APIs may expose more caller-owned context shapes than
OpenSSL 3 EVP. Treat those as backend-specific advantages. Do not flatten them
into a fake generic OpenSSL-compatible promise.

## Backend seams

The AEAD seam is already clean enough to preserve:

- `src/aead.zig` owns key/tag/suite types and encrypt/decrypt dispatch;
- `src/RecordLayer.zig` only calls `Aead.encrypt` / `Aead.decrypt`;
- HKDF derives byte-array traffic keys and constructs `RecordLayer` values.

The non-AEAD seams are mixed. HKDF, HMAC, and SHA-2 can stay on `std.crypto`
until there is a concrete provider/FIPS requirement. X25519, certificate
signature verification, and server signing are real backend boundaries and need
a `src/crypto/` facade so provider decisions do not leak through the handshake
state machines.

The backend facade should target the libcrypto family first, not a native rewrite
first. Required facade areas:

- AEAD for AES-GCM and ChaCha20-Poly1305;
- X25519/P-256 key exchange where supported by the selected backend;
- certificate/signature verification and server signing;
- future provider-backed PQ or hybrid KEX/signature algorithms without changing
  the TLS engine API shape every time a provider adds an algorithm.

First cleanup step: keep direct crypto imports honest. `std.crypto` imports are
fine for hashing/HKDF helpers, but record AEAD should not expose or preserve a
parallel stdlib backend path.

## Milestones

### 0. Measurement and guardrails

Add repeatable profiling and instruction checks before making performance claims:

- benchmark binaries must default to native CPU;
- AArch64 AES-GCM builds must contain `aese` and `pmull`;
- x86_64 AES-GCM builds must contain AES-NI/VAES and PCLMUL-family
  instructions where supported;
- `perf`/callgrind runs should be filterable by suite and size;
- docs should record the exact benchmark command, CPU, Zig version, backend
  library/version, and commit.

Create TODOs from measured hot spots only. No speculative SIMD rewrites.

The concrete ztls-owned facade shape (AEAD lifecycle/rekey, HKDF/hash policy,
named-group KEX and shared-secret sizing, signatures, comptime capabilities,
backend allocation/zeroization/lifetime rules, error mapping) is specified in
`docs/research/PROVIDER_INTERFACE.md`. The no-allocator guardrail is
`rules/no-ztls-owned-allocations.yml` via `just no-alloc`.

### 1. Documentation and support tiers

Keep the docs aligned with the production direction:

- OpenSSL/libcrypto is the first concrete production backend target;
- AWS-LC is first-class in the architecture and must not be blocked by OpenSSL-3-
  only assumptions;
- BoringSSL is a possible later backend with its own API caveats;
- do not preserve `std.crypto` as an exposed backend choice;
- libcrypto-family builds may link libc and may allocate inside backend/provider
  code;
- ztls remains Sans-I/O and caller-buffered.

### 2. OpenSSL/libcrypto AEAD backend

OpenSSL/libcrypto is the first concrete backend target. Add record-protection
AEAD first because the current benchmark ladder already has OpenSSL EVP floor
rows and libssl BIO rows.

Requirements:

- support AES-128-GCM, AES-256-GCM, and ChaCha20-Poly1305;
- use reused contexts; never allocate/free EVP contexts per record;
- preserve ztls nonce construction, record AAD, in-place paths, and sequence
  number ownership;
- support KeyUpdate/rekey safely without leaking old provider state;
- link libc/libcrypto only for the backend build;
- label benchmark rows by backend.

This backend is not no-allocation. It is the first production libcrypto-family
implementation with an explicit backend-owned allocation contract.

### 3. AWS-LC AEAD backend

Add AWS-LC as a named backend, not as an assumed OpenSSL substitute.

Requirements:

- inspect the actual AWS-LC headers/library used in the dev shell or CI;
- prefer AWS-LC/BoringSSL-style AEAD APIs if they are stable and better match
  ztls' one-shot record operation shape;
- otherwise use the OpenSSL-compatible EVP subset where available;
- keep AWS-LC/OpenSSL divergences inside backend modules;
- run the same AEAD tests, interop tests, and benchmark rows as the OpenSSL
  backend.

### 4. HKDF/HMAC/SHA transcript hashing

Keep the TLS 1.3 key schedule and transcript hashes on `std.crypto` by default.
Moving these to libcrypto only makes sense for a concrete provider/FIPS policy,
not as cleanup for its own sake.

If that policy appears later, move SHA-256/SHA-384, HKDF, and HMAC behind a small
facade and run the existing RFC 8448 Finished/HKDF vectors against it.

### 5. Key exchange

X25519 uses OpenSSL EVP raw-key APIs for public-key derivation and shared
secret calculation. The remaining work is turning the single hard-coded group
into provider-backed named groups:

- P-256/P-384 where supported by the selected provider;
- capability queries for supported groups;
- shared-secret slices sized by group rather than fixed 32-byte assumptions;
- multiple key-share and HelloRetryRequest work only when more than one useful
  group exists.

### 6. Signatures and certificates

TLS `CertificateVerify` signing and verification use OpenSSL EVP, while trust
policy and I/O stay outside ztls:

- expand EVP private-key loading beyond unencrypted DER/PEM when needed;
- decide whether the ztls-owned X.509 parser/chain validation remains an
  implementation detail or moves to libcrypto/provider verification;
- keep certificate parsing/path policy caller-buffered and Sans-I/O;
- avoid pulling libssl or OS trust-store loading into core.

### 7. PQ/hybrid groups

Post-quantum support should come from provider-backed KEX/signature mechanisms,
not ztls-owned PQ primitives.

Requirements:

- named-group abstraction for hybrid groups such as X25519MLKEM768 where the
  backend supports them;
- backend capability reporting for experimental/FIPS/provider-specific support;
- multiple key shares and HelloRetryRequest retry path;
- careful version-specific testing because AWS-LC, OpenSSL, and BoringSSL differ
  in API surface, naming, and maturity.

## Success criteria

A production crypto backend is worth calling successful only when the backend
facade, provider matrix, allocation contract, vector coverage, interop coverage,
benchmark methodology, and PQ/hybrid extension path all have reproducible
evidence. The authoritative status for those criteria lives in
`PRODUCTION_READINESS.md`.
