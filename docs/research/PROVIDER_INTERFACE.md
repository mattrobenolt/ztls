# Provider interface design (libcrypto-family backends)

This document specifies the ztls-owned crypto facade *shape* for
libcrypto-family backends. It records the interface contract, ownership rules,
and acceptance criteria without asserting implementation status.

Read first: `AGENTS.md`, `docs/research/DESIGN.md` (§ Crypto backends),
`docs/research/CRYPTO_ROADMAP.md`. Supporting research lives in
`research/provider-interface-opus.md` and
`research/provider-interface-local-sonnet.md`.

---

## Goal and non-goals

The goal is a narrow, ztls-owned Zig facade for primitive crypto so that
backend choice (OpenSSL first, AWS-LC first-class, BoringSSL possible later)
never leaks into the handshake state machines. Backend-specific C imports belong
behind the facade; handshake code should depend only on ztls-owned Zig types.

Non-goals for this interface spec: no second backend, no new named groups, no
KEM wiring, no API behavior change. Where this doc proposes a Zig type or
signature, it is a target shape for implementation work.

Design principle (from the research): **define the interface in one-shot,
caller-buffer terms — not EVP terms.** That shape is the natural TLS 1.3 record
operation (whole record, 12-byte nonce, AAD = record header), maps 1:1 to
BoringSSL/AWS-LC flat funcs (`EVP_AEAD_CTX_seal`, `X25519`,
`HKDF_extract/expand`), and is implementable on stock OpenSSL behind cached EVP
objects. It is also the fast path, which is why it matters for the prior finding
that the EVP/libssl app-data path beat the current record path.

---

## Backend selection

A single comptime build option selects the backend:

```
-Dcrypto-backend=openssl   # default, first concrete target
-Dcrypto-backend=awslc     # first-class design target, not landed this milestone
-Dcrypto-backend=boringssl # possible later
-Dcrypto-fips=true|false   # narrows the capability table (build-time, see below)
```

The rest of ztls imports one backend-agnostic module (`src/crypto/`) and never
sees a `@cImport`. Each backend is one implementation file behind the same Zig
interface. AWS-LC is the lowest-risk second backend because it carries both the
BoringSSL flat/`EVP_AEAD` API family and enough OpenSSL 1.1.1 EVP compatibility
that most existing EVP code compiles; conditional compilation keys off
`OPENSSL_IS_AWSLC` / `OPENSSL_IS_BORINGSSL`.

---

## Facade surface

### 1. AEAD — per-direction state, lifecycle, rekey

This is the per-record hot path and the dominant API divergence between
backends. OpenSSL has no `EVP_AEAD`; it only offers streaming
`EVP_CIPHER_CTX` (init key/iv → `EVP_EncryptUpdate(NULL,…)` for AAD →
`EVP_EncryptUpdate` for data → final → `EVP_CTRL_AEAD_GET_TAG`). BoringSSL/AWS-LC
offer one-shot `EVP_AEAD_CTX_seal/open` with the tag appended to ciphertext.

Facade shape (one-shot over caller buffers; matches the current `aead.zig` seam):

```zig
pub const Suite = enum { aes_128_gcm, aes_256_gcm, chacha20_poly1305 };

pub const Aead = struct {
    /// One direction of record protection. Holds backend-owned cipher state.
    pub const Ctx = struct {
        // OpenSSL: an EVP_CIPHER_CTX allocated once at key install, reused
        //          per record (prefetched EVP_CIPHER*, never re-fetched).
        // AWS-LC/BoringSSL: an initialized EVP_AEAD_CTX, no per-record alloc.
        pub fn seal(self: *Ctx, nonce: [12]u8, aad: []const u8,
                    plaintext: []const u8, ct_out: []u8, tag_out: *[16]u8) Error!void;
        pub fn open(self: *Ctx, nonce: [12]u8, aad: []const u8,
                    ciphertext: []const u8, tag: [16]u8, pt_out: []u8) Error!void;
        pub fn deinit(self: *Ctx) void;
    };
    pub fn initDirection(suite: Suite, key: []const u8) Error!Ctx;
};
```

Lifecycle and rekey rules:

- **Per-direction state.** Each `RecordLayer` (rx and tx) owns one `Ctx`. ztls
  owns the 12-byte nonce construction (RFC 8446 §5.3: IV XOR big-endian seq),
  the record AAD (the 5-byte TLS record header), the sequence number, and the
  in-place/zero-copy buffer layout. The backend only does seal/open.
- **Allocate once, reuse per record.** The cipher context is created at key
  install and reused for every record. Never `EVP_CIPHER_CTX_new/free` per
  record — that per-op malloc/setup is the likely cause of the prior EVP app-data
  gap. On OpenSSL, prefetch the `EVP_CIPHER*` via `EVP_CIPHER_fetch` once and
  cache it; never use the `EVP_aes_*_gcm()` convenience getters in the hot path
  (provider name-search penalty on OpenSSL 3).
- **Rekey / KeyUpdate.** A key update tears down the old `Ctx` (freeing backend
  state, wiping ztls-visible key bytes) and installs a fresh one. The facade must
  preserve that lifecycle: no old provider state may survive a rekey.
- Keep one AEAD seam; a `src/crypto/aead.zig` facade should expose the record
  operation shape rather than duplicating record-layer policy.

### 2. HKDF / hash policy

The TLS 1.3 key schedule (RFC 8446 §7.1) needs HKDF-Extract and HKDF-Expand as
*distinct* steps. Policy: **HKDF/HMAC/SHA-256/SHA-384 and transcript hashing stay on `std.crypto`
by default.** Per CRYPTO_ROADMAP §4 this is intentional implementation detail,
not migration debt, until a concrete provider/FIPS requirement appears. Moving it
only makes sense for FIPS posture.

If/when that policy appears, the facade shape is flat:

```zig
pub fn extract(hash: Hash, salt: []const u8, ikm: []const u8) Prk;        // -> PRK
pub fn expand(hash: Hash, prk: Prk, info: []const u8, out: []u8) void;     // labelled keys
```

This maps directly to BoringSSL/AWS-LC `HKDF_extract`/`HKDF_expand` (no alloc),
and to OpenSSL via a cached `EVP_KDF` with `EXTRACT_ONLY`/`EXPAND_ONLY` modes
(avoid the slower `EVP_PKEY_HKDF` bridge). RFC 8448 Finished/HKDF vectors are the conformance gate for any such move.

### 3. Key exchange — named groups and shared-secret sizing

Named-group plumbing must not assume 32-byte public keys or shared secrets.
X25519 and P-256 both output 32-byte shared secrets, but P-384 outputs 48 bytes
and hybrid groups need still wider public-key/ciphertext sizing.

Facade shape (flat keypair/derive for DH-style groups, KEM seam reserved):

```zig
pub const NamedGroup = enum(u16) {
    x25519 = 0x001d, secp256r1 = 0x0017, secp384r1 = 0x0018, _,
};

// Sized for the widest supported group, not a fixed 32.
pub const max_public_key_len = 97;     // P-384 uncompressed SEC1; X25519=32, P-256=65
pub const max_shared_secret_len = 48;  // P-384; X25519/P-256 = 32

pub const KeyPair = struct {
    group: NamedGroup,
    public_key: [max_public_key_len]u8,
    public_key_len: u8,
    secret: Secret, // opaque: raw scalar bytes or backend-owned EVP_PKEY*
    pub fn generate(group: NamedGroup) Error!KeyPair;
    /// Writes into caller buffer, returns the group-sized slice.
    pub fn sharedSecret(self: *const KeyPair, peer_public: []const u8,
                        out: *[max_shared_secret_len]u8) Error![]const u8;
    pub fn deinit(self: *KeyPair) void;
};
```

Shared-secret sizing decision: `hkdf.handshakeSecret` should take
`dhe: []const u8` instead of a fixed-size shared-secret type. Call sites and
RFC 8448 test vectors should follow that slice-shaped contract. This unblocks
P-256/P-384 and future hybrid groups.

Backend mapping: AWS-LC/BoringSSL implement KEX with flat allocation-free funcs
(`X25519_keypair`, `X25519`); OpenSSL implements the same shape behind the
`EVP_PKEY` derive dance (backend-owned alloc, see lifetime audit). P-256 needs
`EVP_PKEY` on OpenSSL regardless.

**KEM seam (design now, implement later).** PQ/hybrid key exchange is
encapsulate/decapsulate, not DH-derive, so the KEX facade reserves a second
shape rather than being a DH-only dead end:

```zig
pub fn kemKeypair(group: NamedGroup) Error!KeyPair;
pub fn kemEncapsulate(peer_public: []const u8, ct_out: []u8, ss_out: []u8) Error!void;
pub fn kemDecapsulate(self: *const KeyPair, ct: []const u8, ss_out: []u8) Error!void;
```

ztls owns the hybrid combiner (concat order, length checks, FIPS-203 §7.2
encap-key validation) and calls the backend for the raw ML-KEM and X25519/P-256
pieces separately, keeping PQ portable across backends. Groups:
X25519MLKEM768 (`0x11ec`), SecP256r1MLKEM768 (`0x11eb`), SecP384r1MLKEM1024
(`0x11ed`). Driven via `EVP_PKEY_encapsulate/decapsulate` on OpenSSL 3.5 / AWS-LC.

### 4. Signatures and signing

Signing should stay behind a vtable-shaped interface: scheme + opaque context +
`sign` function, with callers supplying key material through it. Verification
should expose a backend-neutral function and hide backend-specific public-key
construction.

Facade shape:

```zig
pub fn verify(scheme: SignatureScheme, pubkey: PublicKey,
              msg: []const u8, sig: []const u8) Error!void;
// signing stays behind the existing Signer vtable
```

Schemes required for TLS 1.3 server auth: rsa_pss_rsae_sha256/384/512, ECDSA
P-256/384, Ed25519 (one-shot `EVP_DigestVerify`, no streaming). Backend caveat:
OpenSSL-3-deprecated key-construction APIs such as `EC_KEY_*`,
`EVP_PKEY_assign_EC_KEY`, `d2i_RSAPublicKey`, and `EVP_PKEY_assign_RSA` should
not appear above the backend seam; AWS-LC does not expose the same public
surface. The backend-portable replacement is `EVP_PKEY_fromdata` with
`OSSL_PARAM`, or `EVP_PKEY_new_raw_public_key` for raw keys.

### 5. Capabilities — suites / groups / signature schemes / FIPS / PQ

Capabilities are a **compile-time** property of the selected backend, not a
runtime probe. ztls negotiates only what the active backend declares:

```zig
pub const capabilities = struct {
    pub const suites: []const Suite = ...;
    pub const groups: []const NamedGroup = ...;
    pub const sig_schemes: []const SignatureScheme = ...;
    pub const fips: bool = build_options.crypto_fips;
    pub const pq: bool = ...; // backend+version gated
};
```

FIPS posture is build-time selection (OpenSSL fips provider vs `aws-lc-fips`),
surfaced as a comptime flag that *narrows* the capability table (e.g. drops
non-approved signatures or groups). Getting this wrong means negotiating
algorithms the backend cannot run. BoringSSL/AWS-LC have no runtime provider
model; OpenSSL fetches by name — prefetch and cache all handles at backend init.

### 6. Memory ownership and backend allocations

- **ztls-owned engine code allocates nothing.** No `std.heap`, no
  `std.mem.Allocator`, no libc malloc/free. All TLS input/output buffers are
  caller-owned. Enforced by the no-allocator check (below).
- **Backend-owned allocations are permitted and documented.** Production
  libcrypto-family builds link libc and may allocate inside backend/provider code
  during init, context setup, provider fetch, or primitive ops. Heap objects with
  explicit frees: `EVP_CIPHER_CTX`, `EVP_PKEY`, `EVP_PKEY_CTX`, `EVP_KDF[_CTX]`,
  `EVP_MD_CTX`, fetched `EVP_CIPHER*`/`EVP_MD*`. Backend-owned objects live behind the facade and
  must never leak into ztls buffer ownership. Do not describe EVP/provider paths
  as no-allocation (DESIGN.md § Crypto backends).
- **Allocation-free per-op** on AWS-LC/BoringSSL: `EVP_AEAD_CTX_seal/open` after
  init, `X25519`, `HKDF_extract/expand`. This is the no-alloc win that makes
  AWS-LC the clean second backend.

### 7. Error mapping

All three libraries use a thread-local error queue and signal success with
`1`/non-NULL. Numeric error codes differ across backends — **never branch on
specific codes across backends**; branch on the boolean result plus operation
context. Map at the seam to ztls error sets and TLS alerts:

| Operation failure | ztls error | TLS alert |
|---|---|---|
| AEAD `open` auth fail | `error.AuthenticationFailed` | `bad_record_mac` (opaque — no padding/decrypt-oracle detail) |
| KEX / setup / fetch | `error.LibcryptoFailed` | `internal_error` |
| Signature verify | `error.BadSignature` | `decrypt_error` (RFC 8446 §6.2) |
| ML-KEM length / encap-key check | `error.IllegalParameter` | `illegal_parameter` |
| All-zero X25519 result | `error.IdentityElement` | `internal_error` |

Use the same mapping consistently for every backend implementation.

---

## How this unblocks the roadmap

- **P-256/P-384** (CRYPTO_ROADMAP §5): the `NamedGroup` + variable-length
  shared-secret shape and the `hkdf.handshakeSecret([]const u8)` contract remove
  the fixed-32 assumption. ClientHello key_share encoding and ServerHello
  parsing must carry the group id.
- **HRR**: only meaningful once more than one useful group exists; the named-group
  facade is its prerequisite.
- **PQ/hybrid** (§7): the reserved KEM seam + ztls-owned hybrid combiner means PQ
  arrives as new groups/algorithms without changing the TLS engine API shape.
- **AWS-LC** (§3): one new implementation file behind the same interface;
  capability table and FIPS flag are comptime.

---

## No-allocator invariant

The no-allocator check should reject ztls-owned allocation ingress in the TLS
engine:

- `std.heap` and direct `@import("std").heap` use,
- `std.mem.Allocator` and direct `@import("std").mem.Allocator` use,
- bare libc `malloc`/`calloc`/`realloc` and `c.malloc`/`c.calloc`/`c.realloc`,
- bare `free(...)` / `c.free(...)`.

Exit 0 means clean; exit 1 means violation. Backend-owned libcrypto destructors
such as `c.EVP_*_free`, `c.EC_*_free`, `c.X509_*_free`, and friends are
intentionally allowed: structurally they are not `free(...)`/`c.free(...)`, and
they release backend-owned objects rather than ztls-owned TLS buffers.

---

## Zeroization and lifetime rules

- **ztls-visible traffic keys / IVs.** Record-layer teardown must call
  `std.crypto.secureZero` or an equivalent over ztls-visible key bytes and IVs,
  and must free backend-owned AEAD contexts.
- **KEX ephemeral secrets.** Raw scalar bytes held by ztls must be securely
  zeroed. Backend-owned private keys must be released through the backend free
  path that owns their cleanse semantics.
- **Signature private keys.** Caller/backend-owned signing keys must have an
  explicit `deinit` path. Per-call signing contexts must be freed on both
  success and error paths.
- **Certificate verification objects.** Public keys, verification contexts, and
  partially-constructed backend objects must be released with `defer`/`errdefer`
  discipline at the seam.

### Backend-owned state relying on libcrypto free/cleanse semantics

- `EVP_CIPHER_CTX_free` cleanses cipher key/round-key material internally; ztls
  does not and cannot reach inside opaque provider contexts. ztls's
  responsibility is wiping its own copy of key bytes and always calling the
  backend free function. OpenSSL secret-zeroization primitive is
  `OPENSSL_cleanse`; ztls relies on the ctx free path for backend-internal
  secrets.
- `EVP_PKEY_free` releases and cleanses private-key material for KEX and signing
  keys. A facade `KeyPair` that owns an `EVP_PKEY` should centralize that free
  path rather than spreading transient ownership through handshake code.

### Caveats and rules going forward

- **Clone caveat.** ztls does not deep-clone any backend-owned ctx. If a future
  facade adds a clone, it must clone backend state explicitly (`EVP_CIPHER_CTX_copy`
  / `EVP_PKEY` up-ref), never bit-copy a struct holding a raw pointer — a bit-copy
  would produce a double-free on the second `deinit`.
- **Deinit ordering.** Free backend ctx (which cleanses internal secrets) and
  `secureZero` ztls-visible key bytes in the same `deinit`; order between them is
  immaterial since they target disjoint memory, but both must run on every path.
  `errdefer` must free partially-constructed backend objects.
- **Rekey.** KeyUpdate must `deinit` the old `RecordLayer` (free old ctx + wipe
  old keys) before installing the new one. No old provider state survives.
- **Facade migration rule.** When raw X25519 secret ownership moves to a
  `kex.KeyPair` holding an `EVP_PKEY`, `deinit` must switch from raw
  `secureZero` to `EVP_PKEY_free` (which cleanses) plus zeroing any ztls-held
  scalar copy. Do not leave both the raw-bytes wipe and a leaked `EVP_PKEY`.

### Residual zeroization limits

- ztls cannot guarantee backend-internal scratch (e.g. provider algorithm
  contexts) is cleansed beyond what the library's free path does. This is
  accepted per the documented backend contract.
- Transcript-hash state and transient key-schedule locals need an explicit
  policy decision if stricter zeroization requirements are adopted.
