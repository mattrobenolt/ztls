# Provider interface design (libcrypto-family backends)

Status: design milestone for TODO-dd650791 (+ TODO-28a2091a no-allocator
guardrail, TODO-ea7c998a zeroization/lifetime audit). This document fixes the
ztls-owned crypto facade *shape* so the next implementation slice can land
without rediscovering crypto-roadmap context. It does **not** change TLS
behavior, and it does not implement AWS-LC, P-256, HRR, PQ, PSK, or client auth.

Read first: `AGENTS.md`, `docs/research/DESIGN.md` (§ Crypto backends),
`docs/research/CRYPTO_ROADMAP.md`. Supporting research lives in
`research/provider-interface-opus.md` and
`research/provider-interface-local-sonnet.md`.

---

## Goal and non-goals

The goal is a narrow, ztls-owned Zig facade for primitive crypto so that
backend choice (OpenSSL first, AWS-LC first-class, BoringSSL possible later)
never leaks into the handshake state machines. Today `@cImport("openssl/...")`
is duplicated across `src/aead.zig`, `src/x25519.zig`, `src/signature.zig`, and
`src/cryptox/Certificate.zig` / `src/certificate.zig`. There is no backend seam.
That is the architectural debt this design targets.

Non-goals for this milestone: no second backend, no new named groups, no KEM
wiring, no API behavior change. Where this doc proposes a Zig type or signature,
it is a *target shape* for a later writer, not code landed here.

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
  state, wiping ztls-visible key bytes) and installs a fresh one. This is exactly
  what `RecordLayer.deinit()` + re-`init()` does today; the facade must preserve
  it. No old provider state may survive a rekey.
- This already-clean `src/aead.zig` seam is the model: a `src/crypto/aead.zig`
  should re-export it rather than rebuild it.

### 2. HKDF / hash policy

The TLS 1.3 key schedule (RFC 8446 §7.1) needs HKDF-Extract and HKDF-Expand as
*distinct* steps. `src/hkdf.zig` already implements the ladder on `std.crypto`.

Policy: **HKDF/HMAC/SHA-256/SHA-384 and transcript hashing stay on `std.crypto`
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
(avoid the slower `EVP_PKEY_HKDF` bridge). The RFC 8448 Finished/HKDF vectors
already in `hkdf.zig` are the conformance gate for any such move.

### 3. Key exchange — named groups and shared-secret sizing

Currently X25519 is hard-wired: `ClientHandshake`/`ServerHandshake` store
`keypair: x25519.KeyPair`, and `hkdf.SharedSecret = memx.Array(32)` (the one
in-code TODO, `src/hkdf.zig:26`). X25519 and P-256 both output 32 bytes so the
fixed type accidentally works; P-384 (48 bytes) breaks it.

Facade shape (flat keypair/derive; DH today, KEM seam reserved):

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

Shared-secret sizing decision: change `hkdf.handshakeSecret` to take
`dhe: []const u8` instead of `*const SharedSecret`, and delete the fixed
`SharedSecret` type. Two call sites (`ClientHandshake.processServerHello`,
`ServerHandshake.installHandshakeKeys`) and the RFC 8448 test vectors update.
This is the unblock for P-256/P-384 and is the resolution of `src/hkdf.zig:26`.

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

`src/signature.zig` already exposes a vtable `Signer` (scheme + opaque context +
`sign` fn) — that *is* the provider interface for signing, and callers supply
key material through it. Verification (`certificate.zig`) uses
`EVP_DigestVerify*`. This is the most source-compatible area across backends.

Facade shape:

```zig
pub fn verify(scheme: SignatureScheme, pubkey: PublicKey,
              msg: []const u8, sig: []const u8) Error!void;
// signing stays behind the existing Signer vtable
```

Schemes required for TLS 1.3 server auth: rsa_pss_rsae_sha256/384/512, ECDSA
P-256/384, Ed25519 (one-shot `EVP_DigestVerify`, no streaming). Backend caveat:
the public-key construction helpers in `certificate.zig`
(`ecPublicKeyFromSec1` via `EC_KEY_new_by_curve_name` + `EVP_PKEY_assign_EC_KEY`,
`rsaPublicKeyFromDer` via `d2i_RSAPublicKey`) and `signature.zig`
(`p256KeyFromScalar`) use **OpenSSL-3-deprecated APIs not present in AWS-LC's
public surface**. The backend-portable replacement is `EVP_PKEY_fromdata` with
`OSSL_PARAM` (or `EVP_PKEY_new_raw_public_key` for raw keys, as `x25519.zig`
already does). This is a correctness item for AWS-LC compat — flagged here, not
fixed in this milestone.

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
non-approved sigs / X25519-only groups). Getting this wrong means negotiating
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
  `EVP_MD_CTX`, fetched `EVP_CIPHER*`/`EVP_MD*`. These live behind the facade and
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

`src/x25519.zig` already does this (`error.LibcryptoFailed`,
`error.IdentityElement`); the facade generalizes that pattern.

---

## How this unblocks the roadmap

- **P-256/P-384** (CRYPTO_ROADMAP §5): the `NamedGroup` + variable-length
  shared-secret shape and the `hkdf.handshakeSecret([]const u8)` change remove
  the fixed-32 assumption. `client_hello.zig` key_share encoding and
  `server_hello.zig` parsing must carry the group id (called out as a dependency,
  not done here).
- **HRR**: only meaningful once more than one useful group exists; the named-group
  facade is its prerequisite.
- **PQ/hybrid** (§7): the reserved KEM seam + ztls-owned hybrid combiner means PQ
  arrives as new groups/algorithms without changing the TLS engine API shape.
- **AWS-LC** (§3): one new implementation file behind the same interface;
  capability table and FIPS flag are comptime.

---

## No-allocator invariant (TODO-28a2091a)

Check: `scripts/check-no-allocator.sh`, wired as `just no-alloc` and run inside
`just ci`. It scans tracked core `src/*.zig` (excluding `src/test/` harnesses,
which legitimately use a testing allocator) for:

- `std.heap` imports/use,
- `std.mem.Allocator` / `Allocator` parameters and fields (comments ignored),
- bare libc `malloc`/`calloc`/`realloc`,
- `free(` calls that are not backend-owned libcrypto frees
  (`EVP_*`, `OPENSSL_*`, `EC_*`, `RSA_*`, `BN_*`, `BIO_*`, `X509_*`, `ASN1_*`).

Exit 0 clean, exit 1 on violation. Backend-owned libcrypto frees are explicitly
allowed because they free backend-owned allocations, not ztls buffers. Current
state: clean, 21 core files scanned. The only `Allocator`-adjacent text in core
is a comment in `ClientHandshake.zig` ("keeps ztls allocation-free"), correctly
ignored.

Equivalent ad-hoc command:

```sh
grep -rnE 'std\.heap|mem\.Allocator|\b(malloc|calloc|realloc)\b' src --include='*.zig' \
  | grep -v '/test/'
```

---

## Zeroization and lifetime audit (TODO-ea7c998a)

### What is zeroed today

- **Traffic keys / IV.** `RecordLayer.deinit()` (`src/RecordLayer.zig:40-47`)
  calls `std.crypto.secureZero` over the caller-visible `aead` key union and the
  `iv`, then frees both `EVP_CIPHER_CTX`s via `Aead.Context.deinit`
  (`src/aead.zig:122-125`). Tested: `RecordLayer.zig:199` "deinit: clears
  caller-visible traffic key material".
- **X25519 ephemeral secret.** Today `ClientHandshake`/`ServerHandshake`
  `deinit()` call `std.crypto.secureZero` over the raw `keypair.secret_key`
  bytes. `x25519.zig` itself creates and frees a transient `EVP_PKEY`
  (`EVP_PKEY_free`) per `sharedSecret` call (`src/x25519.zig:48,63,65`).
- **Signature private keys.** `signature.PrivateKey.deinit` frees the `EVP_PKEY`
  (`src/signature.zig:43`); `signEcdsaP256Sha256` frees its per-call
  `EVP_MD_CTX` (`src/signature.zig:65`). Caller-owned; not stored in handshake
  structs.
- **Certificate verify.** `certificate.zig` frees the per-verify `EVP_PKEY` and
  `EVP_MD_CTX` (`src/certificate.zig:251,254`) and uses `errdefer
  EVP_PKEY_free` on the construction paths (`:149,:160`).

### Backend-owned state relying on libcrypto free/cleanse semantics

- `EVP_CIPHER_CTX_free` cleanses the cipher key/round-key material internally;
  ztls does not (and cannot) reach inside the opaque ctx. ztls's responsibility
  is wiping its *own* copy of the key bytes (done in `RecordLayer.deinit`) and
  always calling the free function. OpenSSL secret-zeroization primitive is
  `OPENSSL_cleanse`; ztls relies on the ctx free path for backend-internal
  secrets.
- `EVP_PKEY_free` releases and cleanses private-key material for KEX and signing
  keys. The transient-`EVP_PKEY`-per-call pattern in `x25519.zig` is correct but
  re-allocates each handshake; the facade's `KeyPair` that holds the `EVP_PKEY`
  for its lifetime would reduce churn and centralize the free.

### Caveats and rules going forward

- **Clone caveat.** ztls does not deep-clone any backend-owned ctx. If a future
  facade adds a clone, it must clone backend state explicitly (`EVP_CIPHER_CTX_copy`
  / `EVP_PKEY` up-ref), never bit-copy a struct holding a raw pointer — a bit-copy
  would produce a double-free on the second `deinit`.
- **Deinit ordering.** Free backend ctx (which cleanses internal secrets) and
  `secureZero` ztls-visible key bytes in the same `deinit`; order between them is
  immaterial since they target disjoint memory, but both must run on every path.
  `errdefer` must free partially-constructed backend objects (the construction
  paths already do this).
- **Rekey.** KeyUpdate must `deinit` the old `RecordLayer` (free old ctx + wipe
  old keys) before installing the new one. No old provider state survives.
- **Facade migration rule.** When the X25519 `secureZero(secret_key)` path moves
  to a `kex.KeyPair` holding an `EVP_PKEY`, `deinit` must switch from raw
  `secureZero` to `EVP_PKEY_free` (which cleanses) plus zeroing any ztls-held
  scalar copy. Do not leave both the raw-bytes wipe and a leaked `EVP_PKEY`.

### Residual zeroization gaps (tracked, not fixed here)

- ztls cannot guarantee backend-internal scratch (e.g. provider algorithm
  contexts) is cleansed beyond what the library's free path does. This is
  accepted per the documented backend contract.
- Transcript-hash and HKDF intermediate secrets on `std.crypto` live on the
  stack in handshake structs; they are not individually `secureZero`d today. If
  a FIPS/zeroization policy lands, the key-schedule intermediates are the next
  audit target.
