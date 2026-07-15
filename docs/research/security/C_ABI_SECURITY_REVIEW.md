# C ABI Security Design Audit

Scope: the proposed C-compatible ABI described in GitHub issue [#30](https://github.com/mattrobenolt/ztls/issues/30), before any `src/capi.zig` implementation exists. This audit examines how the proposed exposed-struct design interacts with the secrets and backend handles already present in the current Zig types.

The Zig engine is intentionally allocator-free, move-disciplined, and caller-buffered. The C ABI must preserve those invariants or the boundary becomes a secret-extraction and use-after-free hazard. The findings below are tied to concrete field names in `src/ClientHandshake.zig`, `src/ServerHandshake.zig`, `src/RecordLayer.zig`, and `src/aead.zig` as they exist today.

## What the current structs carry

`ClientHandshake` (today) contains:

- `state` — the handshake state-machine enum.
- `suite` — a `union(enum)` that is either a `Buffering` pair of `Sha256`/`Sha384` hashers or a `HashArm` carrying transcript state, handshake secret, finished keys, and application-traffic secrets.
- `keypairs` — ephemeral X25519, P-256, and optional P-384 keypairs; the `secret_key` fields in each are caller-owned secrets.
- `rx` / `tx` / `early_tx` — `RecordLayer` values that hold AEAD keys, IVs, sequence numbers, and backend cipher contexts.
- `offered_psk` — an `?[]const u8` slice pointing into caller memory (the `SessionTicket.psk` buffer).
- `kem_key` — an `?mlkem.KeyHandle`, a backend-owned opaque key handle (e.g., an OpenSSL `EVP_PKEY*`).
- `client_credentials` — a `CertificateChain` plus a `Signer` that references caller-owned certificate bytes and a private-key handle.
- `pending_write` — a latch that gates the engine until the caller acknowledges a produced write.

`ServerHandshake` carries a similar set:

- `state`, `keypairs`, `suite_state` (a `Suite` union), `rx` / `tx` / `early_rx`.
- `selected_psk` — a slice into caller memory via the `PskLookup` callback.
- `psk_lookup` — a C-style callback/context pointer pair.
- `server_credentials` — chain + signer references, like the client side.
- `ch_buf`, `fin_frag`, `ku_frag` — reassembly buffers.

`RecordLayer` is the smallest secret container:

- `aead` — an `Aead` union that stores the actual 16-byte or 32-byte traffic key in its active arm.
- `iv` — the 12-byte base IV.
- `seq` — the 64-bit sequence counter.
- `key_limit` — the AEAD usage limit.
- `ctx` — an `AeadContext` that is a backend-specific context: under OpenSSL it contains two `*EVP_CIPHER_CTX` pointers; under AWS-LC/BoringSSL it contains an `EVP_AEAD_CTX` that may embed pointers.

`RecordLayer.deinit()` (in `src/RecordLayer.zig`) calls `ctx.deinit()` and then `secureZero`s every byte of the struct, including the `aead` key and `iv`. That zeroization is only reachable through a Zig function call; a C consumer cannot trigger it by assigning or freeing the struct.

## Critical findings

### 1. Transparent C struct assignment copies secrets and backend handles, breaking move/zeroization semantics

The [#30](https://github.com/mattrobenolt/ztls/issues/30) proposal exposes the full `ztls_client` and `ztls_server` structs with a documented "do not touch `_` fields" convention. In C, that does not stop the compiler from treating the struct as a plain value type. A consumer can write:

```c
ztls_client a = *client;
ztls_client_deinit(client);
ztls_client_deinit(&a);
```

That assignment copies every byte of the Zig state, including:

- the `keypairs` secret keys,
- the `suite` / `suite_state` transcript and HKDF secrets,
- the `rx`/`tx`/`early_tx`/`early_rx` `RecordLayer` keys and IVs,
- the `AeadContext` backend pointers (`*EVP_CIPHER_CTX` or `EVP_AEAD_CTX` internals),
- the `kem_key` opaque backend handle,
- the `offered_psk` / `selected_psk` pointer and length,
- `pending_write` and other state.

Zig has no move constructor and no copy constructor. `ztls_client_deinit` is expected to be called exactly once on a logical instance. After a C assignment, two C objects both claim ownership of the same backend contexts. Calling `deinit` on both frees the same `EVP_CIPHER_CTX` twice (double free) while leaving at least one copy of the traffic secrets in memory. Calling `deinit` on only one leaves the other with a dangling backend context and a live copy of the keys. Forgetting to call `deinit` at all leaves all secrets and backend handles in the C object forever.

This is not a hypothetical style issue. The current `RecordLayer` already relies on `deinit` to call `ctx.deinit()` and then `secureZero` the whole struct. The C ABI must either guarantee a single logical owner, or it must provide a way to duplicate and invalidate backend state safely. The proposed design does neither.

**Required fix.** If the C structs remain transparent, the header must declare them as non-copyable, non-movable, and non-assignable. A stronger and safer approach is to hide the entire internal state behind an opaque handle so that C consumers cannot perform `=` or `memcpy` and must use the library-provided lifecycle functions. At minimum, every secret-bearing and backend-handle-bearing sub-struct (`Suite`, `RecordLayer`, `KeyPairs`, KEM key, PSK slices) must be placed in an opaque byte region, and the C ABI must supply explicit `ztls_client_copy` / `ztls_client_move` helpers that know how to re-key contexts or zero the source.

### 2. The proposed `uint8_t state` field is writable from C and breaks the state machine

Issue #30 puts `uint8_t state` directly in the exposed `ztls_client` struct as a public field for inspection. Because the whole struct is writable, C code can do:

```c
client->state = ZTLS_CLIENT_CONNECTED;
```

while `client->suite` is still in the `buffering` arm, `rx`/`tx` are still `undefined` (they are only installed after ServerHello and key derivation), and the transcript has not absorbed the server flight. A subsequent `ztls_client_send_application_data` would then encrypt data under an uninitialized `tx` `RecordLayer`, invoking a backend context that may be null or stale.

Even "benign" mutations, such as rewinding `state` from `connected` back to `wait_sh`, cause the transcript and traffic keys to fall out of sync. The Zig state machine is designed around monotonic progression driven by message processing; exposing a mutable state byte violates that invariant at the ABI level.

**Required fix.** `state` must be a query-only value. Remove it from the writable C struct. Provide a getter such as `ztls_client_state ztls_client_get_state(const ztls_client *client)`. If a field must remain in the struct for offset convenience, it should be declared `const` and documented as read-only, but a getter is the safer contract.

### 3. `offered_psk`, `selected_psk`, and `kem_key` are slices/handles into caller memory, and C struct copying duplicates them

`ClientHandshake.offered_psk` is an `?[]const u8` that points at the `psk` buffer inside a caller-owned `SessionTicket`. The C representation would be a pointer plus length. When a C consumer copies the struct, the pointer and length are duplicated but the underlying buffer is not. If the caller frees the `SessionTicket` while the copy still holds the slice, the next handshake step dereferences a dangling PSK — a potential use-after-free that could also affect the binder computation and the early-secret derivation.

`kem_key` is an `?mlkem.KeyHandle` — a backend opaque pointer such as an OpenSSL `EVP_PKEY*`. A C struct copy duplicates the pointer. Calling `ztls_client_deinit` on both the original and the copy frees the same key handle twice, while any other copy retains a dangling handle. Because the handle is used during ServerHello processing (decapsulation), a dangling or double-freed handle can crash the process or produce wrong shared secrets.

**Required fix.** Either:

- Copy the PSK into a fixed-size internal buffer (max 48 bytes for SHA-384) and expose it as an opaque byte array, removing the lifetime coupling; or
- Document that the caller must keep the PSK buffer alive until `ztls_client_deinit`, and add a `ZTLS_ERR_NULL_PARAMETER` / lifetime check if the slice becomes invalid. The PSK is small enough that copying it into the struct is preferable.

For the KEM key, the backend handle must be owned exactly once. It should live in an opaque internal region and be freed only by the single `deinit` call on the original handle. The ABI should not expose the handle as a copyable C field.

## High findings

### 4. Output-buffer pointers from `handle_record` and `complete_write` borrow caller memory with a strict contract

The Zig `handleRecord` function returns a `ClientHandshake.Event` whose `application_data` or `write` slices are subslices of either the caller's `record` buffer or the caller's `out` buffer. The C ABI in #30 maps this to:

```c
typedef struct {
    ztls_event_type type;
    const uint8_t *data;
    size_t data_len;
} ztls_event;
```

The C consumer receives a pointer into memory it owns. The `pending_write` latch on `ClientHandshake`/`ServerHandshake` exists precisely because the engine must not advance until the caller has written those bytes and acknowledged them with `complete_write`. The pointer is only valid until the next engine call or until `complete_write` is called. If the consumer:

- frees the `out` or `record` buffer before the next call,
- reuses the `out` buffer for another write,
- or calls `handle_record` again without first calling `complete_write`,

the `ztls_event.data` pointer becomes dangling or points to overwritten plaintext.

The shim must enforce this. If `pending_write` is set, the next call to `handle_record`, `send_application_data`, `send_alert`, etc. must return `ZTLS_ERR_PENDING_WRITE` and must not produce a new event. The C header must state the contract explicitly: event pointers are borrowed, not owned; they are invalidated by any subsequent call on the same handle or by `complete_write`.

**Required fix.** Export `complete_write` for both client and server. Ensure every C function that produces output checks `pending_write` before mutating state. In the C header, document that `ztls_event.data` and `out_written` pointers are valid only until the next ztls call on the same handle or until `complete_write` is called, whichever comes first.

### 5. `RecordLayer` should not be exposed as a transparent C struct

Issue #30 discusses whether to expose `ztls_record_layer` as a struct. The current `RecordLayer` contains raw traffic key bytes, the IV, the sequence number, and a backend cipher context. Exposing those fields to C would let a consumer read the active traffic key directly from `rx.aead` or `tx.aead`, and would let them copy the `ctx` field, leading to the same double-free hazard described in finding 1.

`RecordLayer.ktlsInfo()` already exists to copy the key material out into a value (`KtlsInfo`) for callers that need to configure kTLS. The C ABI should use that mechanism rather than exposing `RecordLayer` internals.

**Required fix.** Do not define `ztls_record_layer` in the public header. Hide `rx`/`tx`/`early_tx`/`early_rx` inside the opaque internal region of `ztls_client` / `ztls_server`. Provide functions like `ztls_client_ktls_tx_info(const ztls_client *c, ztls_ktls_info *out)` that copy key material into a caller-provided value and return an error if the handshake is not connected.

### 6. Backend-dependent struct sizes make a transparent layout unstable

The `AeadContext` size differs across backends. The backend tests in `src/crypto/backend.zig` assert that the OpenSSL `AeadContext` size differs from the AWS-LC/BoringSSL size. Because `RecordLayer` embeds `AeadContext` and `ClientHandshake` / `ServerHandshake` embed `RecordLayer`, the total size and internal offsets of any C struct that faithfully mirrors the Zig layout would depend on the backend selected at compile time. A C consumer that compiles against one backend's header and links against a shared library built with another backend would have a layout mismatch, leading to silent corruption or crashes.

**Required fix.** Any C-facing struct must be backend-independent. If the layout is kept transparent, the internal region must be sized to the maximum across supported backends and aligned to the strictest requirement. The cleaner solution is to hide the internal state behind an opaque handle or a fixed-size opaque byte array whose size is chosen conservatively and verified at build time with a `sizeof` static assertion in `src/capi.zig`.

## Medium findings

### 7. Null pointer handling at the C boundary

The Zig API uses slices and non-optional pointers; it assumes the caller passes valid references. The C ABI must validate every pointer before converting it to a slice. Issue #30 defines `ZTLS_ERR_NULL_PARAMETER`, but every exported function needs an explicit null check for the handle, the output buffer, and the event pointer. Forgetting a check turns a C `NULL` into a Zig null slice dereference, which is a panic in Debug/ReleaseSafe and undefined behavior in ReleaseFast.

**Required fix.** Add null checks in `src/capi.zig` for every exported function. Map any null handle, output buffer, or length pointer to `ZTLS_ERR_NULL_PARAMETER` before entering the Zig engine.

### 8. Secure zeroing is only available through Zig-side `deinit`

C consumers cannot call `std.crypto.secureZero`. If they allocate a `ztls_client` on the stack and forget to call `ztls_client_deinit`, the secret keys remain in the stack frame or in a heap allocation that may be reused. Even calling `memset(client, 0, sizeof(*client))` from C zeroes the bytes but does not free the backend `EVP_CIPHER_CTX` handles inside `RecordLayer.ctx`, producing a memory leak and leaving the backend contexts alive.

**Required fix.** The C ABI must provide a single `ztls_client_deinit` / `ztls_server_deinit` that is the only supported way to retire a handle. The header should warn that manual `memset` or `free` without `deinit` leaks backend resources and may leave secrets on the stack. If opaque handles are used, the `free` function can perform both zeroization and backend cleanup atomically.

## Low findings

### 9. Error-code mapping is broad and loses detail

The `ztls_result` enum in #30 collapses Zig error sets into coarse C codes. For security-relevant errors such as `AuthenticationFailed`, `PeerAlert`, and `InvalidState`, the mapping is acceptable, but diagnostic detail is lost. This is a design choice, not a vulnerability, as long as the mapping is injective for the security-relevant errors.

## Recommendation: transparent layout is not defensible without opaque secret sub-structs

Issue #30 argues that Zig `extern struct` can be exposed directly because the core types are fixed-size and stack-allocatable. That is true for the *outer* shape, but it is false for the *contents* that carry secrets and backend handles. The following parts of the current Zig types cannot be safely exposed as C fields:

- `ClientHandshake.suite` / `ServerHandshake.suite_state` — tagged unions containing transcript state and HKDF secrets.
- `ClientHandshake.keypairs` / `ServerHandshake.keypairs` — secret scalar keys.
- `ClientHandshake.rx` / `tx` / `early_tx` / `ServerHandshake.rx` / `tx` / `early_rx` — `RecordLayer` with backend contexts.
- `ClientHandshake.kem_key` — backend opaque handle.
- `ClientHandshake.offered_psk` / `ServerHandshake.selected_psk` — slices into caller memory.
- `ServerHandshake.psk_lookup` — callback/context pointer pair.
- `ClientHandshake.client_credentials` / `ServerHandshake.server_credentials` — signer private-key references and certificate slices.

A transparent C struct that exposes those as fields is a footgun. The C compiler will happily copy them, and the Zig side has no way to know that a copy exists. The only way to preserve the no-copy invariant is to make the internal region opaque and non-assignable.

### Minimum mechanical changes if transparent structs are kept

1. Replace the exposed `Suite` and `RecordLayer` fields with fixed-size opaque byte arrays (e.g., `uint8_t _suite_state[ZTLS_SUITE_STATE_SIZE]`, `uint8_t _record_layers[ZTLS_RECORD_LAYERS_SIZE]`) and do not define `ztls_record_layer` in the header.
2. Remove the writable `state` field; expose `ztls_client_get_state` / `ztls_server_get_state` only.
3. Copy the offered PSK into a fixed internal buffer (max 48 bytes) rather than exposing a pointer/length.
4. Keep the KEM key, backend contexts, and signer private-key handles inside the opaque region; do not expose them as copyable C fields.
5. Document that the C struct is non-copyable and must be zero-initialized before `init`; `deinit` must be called exactly once per logical handle; `memcpy`/`=` is undefined behavior.
6. Add null checks and `ZTLS_ERR_NULL_PARAMETER` for all exported functions.
7. Provide `complete_write` for both client and server, and gate every producing call on `pending_write`.
8. Provide kTLS info via value-copy functions, not by exposing `RecordLayer` fields.
9. Add a `sizeof` static assertion in `src/capi.zig` that verifies the C header's opaque sizes match the Zig struct sizes for the selected backend.

### Preferred changes if opaque handles are acceptable

The safest C ABI is one where the consumer cannot copy or inspect the internal state:

1. Define `ztls_client` and `ztls_server` as incomplete types in the header, or as structs containing only a fixed-size `uint8_t opaque[N]` block.
2. Require the consumer to allocate storage of the documented size (stack, heap, or embedded) and pass it to `ztls_client_init` / `ztls_server_init`. The init function receives a `void *` or pointer to the opaque storage and validates alignment.
3. Provide `ztls_client_deinit` / `ztls_server_deinit` as the only way to retire a handle; they zeroize the storage and free all backend handles.
4. Provide explicit `ztls_client_copy` / `ztls_server_copy` only if copying is genuinely needed, and implement them by re-deriving or re-initializing backend contexts so that the two handles do not share a single `EVP_CIPHER_CTX`.

This preserves the caller-owns-buffers philosophy from #30 while removing the copy-and-double-free hazard. It also makes backend-dependent layout differences irrelevant to the C consumer.

## What this audit does not cover

- Thread-safety rules. The C ABI inherits the same single-owner rule as the Zig API: no concurrent mutation of a handle.
- Certificate verification policy. The current `certificate.Policy` and `Certificate.Bundle` path is complex and is listed as out of scope in #30; a future `ztls_verifier` handle should receive its own security audit.
- 0-RTT replay semantics. The PSK lifetime issues above are structural; the replay-risk warning in `startWithPsk` is a caller-policy concern, not a C ABI boundary flaw.
- ABI stability. Issue #30 explicitly defers ABI stability until 1.0, so this audit focuses on safety, not versioning.

