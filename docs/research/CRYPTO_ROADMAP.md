# Crypto backend roadmap

ztls currently uses `std.crypto` for all cryptographic primitives. OpenSSL is
present only in benchmark and interop harnesses. That is still the right default:
core ztls remains no-allocation, no-I/O, and easy to audit.

The performance question is narrower: what would it take to match or replace
libcrypto-class primitive performance without importing libssl's machinery or
violating ztls' memory model?

## Current evidence

All useful numbers must come from native CPU builds. Generic AArch64 selects
software AES/GHASH in Zig 0.15.2 on the current Apple-Silicon Linux VM and is
not comparable to OpenSSL. The benchmark binary must report a real CPU model and
objdump must show hardware crypto instructions.

On the current AArch64 host, native `record_protection_bench` contains:

- `aese` / `aesmc` for AES rounds;
- `pmull` / `pmull2` for GHASH.

That changes the read substantially. ztls AES-GCM is in the same arena as
OpenSSL EVP, not orders of magnitude behind. OpenSSL still wins on large bulk
records, while ztls is competitive or faster on small records where EVP/libssl
setup overhead dominates.

The bigger pure-crypto hole is ChaCha20-Poly1305. `std.crypto`'s AArch64
ChaCha path is scalar in Zig 0.15.2, while OpenSSL uses NEON implementations for
ChaCha and Poly1305. ztls now has an AArch64 Linux prototype using BoringSSL's
Apache-2.0 combined `chacha20_poly1305_armv8` assembly. It is intentionally
narrow: Linux/AArch64 only, std.crypto fallback elsewhere, and the public AEAD
API remains unchanged.

Handshake latency is a separate problem. Full handshakes are dominated by
certificate parsing/signature verification, X25519, HKDF/transcript hashing, and
server signing. AEAD changes will not move handshake numbers much.

## OpenSSL EVP is not a no-allocation core backend

OpenSSL 3 EVP cannot honestly be used inside strict no-allocation ztls core.
`EVP_CIPHER_CTX` is opaque and heap-allocated through `EVP_CIPHER_CTX_new`.
Even with caller-created contexts, provider-backed ciphers allocate internal
algorithm contexts during init; OpenSSL's AES-GCM and ChaCha20-Poly1305 provider
`newctx` paths use OpenSSL heap allocation.

So there are only two honest libcrypto options:

1. keep OpenSSL EVP as an opt-in adapter outside the strict core memory
   contract, with allocation behavior explicitly owned by the caller/provider;
2. do not add an EVP backend to core, and use EVP only as the benchmark floor
   while ztls develops no-allocation native primitives.

Do not add an EVP backend that claims to preserve the no-allocation invariant.
Fake invariants are worse than slow code.

BoringSSL is different and exposes caller-owned `EVP_AEAD_CTX`-style APIs, but
that is a separate backend, not OpenSSL-compatible libcrypto.

## Backend seams

The AEAD seam is already clean enough to preserve:

- `src/aead.zig` owns key/tag/suite types and encrypt/decrypt dispatch;
- `src/RecordLayer.zig` only calls `Aead.encrypt` / `Aead.decrypt`;
- HKDF derives byte-array traffic keys and constructs `RecordLayer` values.

The non-AEAD seams are weaker. HKDF, HMAC, SHA-2, X25519, and certificate
signature verification call `std.crypto` directly. That is fine today, but a
full native-crypto backend needs a `src/crypto/` facade so hot primitives can be
swapped without threading backend decisions through the handshake state machines.

First cleanup step: remove direct unused crypto imports from files that do not
need them, especially the dead `std.crypto.aead.aes_gcm.Aes128Gcm` import in
`src/RecordLayer.zig`.

## Milestones

### 0. Measurement and guardrails

Add repeatable profiling and instruction checks before writing new crypto:

- benchmark binaries must default to native CPU;
- AArch64 AES-GCM builds must contain `aese` and `pmull`;
- x86_64 AES-GCM builds must contain AES-NI/VAES and PCLMUL-family
  instructions where supported;
- `perf`/callgrind runs should be filterable by suite and size;
- docs should record the exact benchmark command, CPU, Zig version, and commit.

Create TODOs from measured hot spots only. No speculative SIMD rewrites.

### 1. Backend facade

Create a small crypto facade without changing behavior:

- keep `std.crypto` as the only implementation initially;
- preserve public `aead` key/tag/suite types;
- hide AEAD, SHA-2, HMAC/HKDF, X25519, and signature-verification choices behind
  ztls-owned modules over time;
- add a build option only when a second backend actually exists.

The goal is boring refactoring with identical benchmark numbers.

### 2. Fairer OpenSSL crypto-floor rows

The current EVP benchmark reinitializes `EVP_CIPHER_CTX` for every operation.
That is useful because it mirrors simple EVP usage, but it overstates setup cost
for small records. Add reused-context EVP rows so small-record comparisons do
not accidentally measure only EVP init overhead.

Those rows are still not no-allocation core candidates; they are a better
crypto floor.

### 3. ChaCha20-Poly1305 native SIMD

This was the highest-value primitive target and is the first native prototype.

For AArch64 Linux, ztls imports BoringSSL's combined NEON ChaCha20-Poly1305
assembly through a small Zig facade. For x86_64, target AVX2/SSE2 next if
benchmarks justify it. Avoid headerless SUPERCOP/Floodyberry snapshots; use
sources with unambiguous licensing.

Requirements:

- no heap state;
- no new public API complexity;
- RFC 8439 known-answer coverage before benchmarks matter;
- objdump proof of vectorized hot paths;
- >2x speedup over Zig 0.15.2 `std.crypto` ChaCha before merging.

Initial native AArch64 Linux prototype results improved record ChaCha from about
`142/398/489 MiB/s` at 128/1350/16384 bytes to about
`478/1217/1485 MiB/s` for encrypt and `377/1119/1502 MiB/s` for decrypt.

### 4. AES-GCM parallel GHASH

AES-GCM already uses hardware AES and PMULL on AArch64. The likely remaining gap
is OpenSSL's more aggressively interleaved AES/GHASH pipelines and multi-block
GHASH reduction.

Target this after ChaCha unless profiling contradicts that. The win is probably
smaller and the maintenance burden is higher.

Requirements:

- no regression for 16-byte records;
- measurable improvement for 8 KiB and 16 KiB records;
- instruction-level proof that hardware AES/GHASH paths remain selected.

### 5. SHA-2/HKDF and handshake math

If handshake profiling shows transcript hashing or HKDF as material, add SHA-256
extension paths for AArch64 and x86_64 SHA-NI. SHA-384 may remain scalar unless
numbers justify the work.

If handshake remains ~2x slower than OpenSSL, profile and split TODOs for:

- X25519 scalar multiplication;
- P-256 ECDSA verification;
- DER/certificate parsing;
- server signing callback cost.

Do not let AEAD work pretend to solve handshake latency.

## Success criteria

A ztls-owned crypto backend is worth calling successful only when:

- AES-GCM is within roughly 10–15% of OpenSSL EVP for large records on supported
  AArch64 and x86_64 targets;
- ChaCha20-Poly1305 is within roughly 20% of OpenSSL EVP across realistic record
  sizes;
- full ztls app-data rows match or beat OpenSSL memory-BIO rows for small and
  MTU-sized records;
- all relevant Wycheproof/RFC vectors pass;
- the backend remains no-allocation and no-I/O;
- instruction checks catch accidental scalar fallback.

Until then, `std.crypto` remains the correctness/default backend, OpenSSL EVP is
our comparison floor, and any libcrypto adapter is explicitly outside the strict
core allocation contract.
