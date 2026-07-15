# Attack-surface recon — C ABI trust boundary (#30)

Recon-stage scan for the C ABI surface proposed in #30. Parallel to
`RECON.md`, which covers the wire byte trust boundary; this doc covers
the boundary that arises once `src/capi.zig` and `include/ztls.h` exist
and an untrusted C embedder crosses the FFI. The C-ABI trust boundary
is a distinct attacker surface that the existing Glasswing recon does
not enumerate, so a hunter running `whitehat-hacker` against the
existing wire surface will not catch FFI-shaped bugs.

**Status is not asserted here.** What is done and what evidence proves
it is `PRODUCTION_READINESS.md`'s job. The doc describes the surface
and proposes hunt work; it does not close or invert any readiness
claim. The C ABI is described in #30 as proposed surface; nothing in
this recon presupposes which parts have landed.

**Format parallel.** This file mirrors `RECON.md` (sections, hunt
queue shape, naming conventions) so a downstream hunter can carry the
method over without re-learning the conventions. Inline RFC cites
follow the same protocol-test convention as the rest of the tree;
FFI-boundary citations use the proposed #30 surface and the C-FFI
precedents it cites.

## Build and header conventions

The C ABI target lives in `src/capi.zig` and `include/ztls.h`. Build
flavor and library layout (per #30):

- `zig build -Dcapi` produces `libztls.a` or `libztls.so`/
  `libztls.dylib`. Static and dynamic linking both target the same
  source; layout is unstable by design (pre-1.0, documented in #30) (pre-alpha).
- The header is hand-written (decision of #30, open question 3). It
  pins `_suite_state[ZTLS_SUITE_STATE_SIZE]` and `_reserved[N]` byte
  arrays as opaque regions inside otherwise-`extern struct` layouts.
- `include/ztls.h` is the single source of truth for the C ABI
  contract from the embedder's perspective. Drifting away from
  `src/capi.zig` is a contract drift, not a feature branch.
- `ZTLS_MAX_WIRE_RECORD_LEN` and `ZTLS_RECORD_BUFFER_STORAGE` are
  pinned manifest constants. The values cited in #30 (`16645` and
  `33290`) walk the runtime path, not the symbolic assumption: `16645`
  is `5 + 16640` (header + max body) and `33290` is `2 * min_storage`
  — both are derivable from the Zig source at the call site.


## Trust boundaries

The C ABI trust boundary is new and orthogonal to the three seams
listed in `RECON.md` §"Trust boundaries". The fourth seam — a Python
ctypes / Ruby FFI / Rust unsafe / Go cgo embedder feeding callers into
ztls — has its own failure modes that the wire attacker cannot
reach.

| Boundary | What crosses it | Direction | Source |
|---|---|---|---|
| **Wire bytes** (existing) | `record: []u8` and `msg: []const u8` | Caller-supplied, fully attacker-controlled on the wire | `RECON.md` §"Trust boundaries" |
| **Backend seam** (existing) | libcrypto handles into OpenSSL / AWS-LC / BoringSSL | ztls calls out; backend owns its own allocations | `src/crypto/backend.zig` |
| **Caller-owned buffers** (existing) | `out: []u8` and `OutBuffer`/`Storage` arrays | Caller provides storage; ztls writes into it | `RECON.md` §"Trust boundaries" |
| **C ABI struct layout** (new — #30) | `ztls_client`, `ztls_server`, `ztls_record_buffer` sized at the C consumer's compile site; `ZTLS_SUITE_STATE_SIZE` and layout of `_suite_state` cross the dynamic-linker boundary | Caller allocates the struct with `sizeof(ztls_client)`; ztls writes into the layout that `src/capi.zig` defines; the consumer's `include/ztls.h` pins the layout expectation | #30 §"Why not opaque pointers?" + §"Struct layout approach" |
| **Pointer-output invariants** (new — #30) | `const uint8_t **out` / `size_t *out_len` parameters on query functions (`ztls_client_selected_alpn`, `ztls_server_client_server_name`); the `ztls_event.data` pointer | ztls writes a pointer that the embedder dereferences; lifetime and aliasing are caller-visible contracts | #30 §"Proposed API Surface" → "Event type" and server query section |
| **Length-parameter conventions** (new — #30) | `size_t out_len`, `size_t record_len`, `size_t plaintext_len`, `size_t count` — every size is `size_t` on the C side; ztls has `usize` internally | Caller-provided; the embedder's view of "size of this buffer" matches or diverges from `usize` at the host ABI boundary | #30 §"Struct layout approach" → "Pointer captures for large union variants" |

The fifth axis — the **embedder's own unsafe code** that calls into
ztls — is a trust boundary that runs the *other* way. Rust unsafe
blocks, Python ctypes shims, Ruby FFI::Struct layouts, and Go cgo
calling ztls all carry their own memory-model assumptions that ztls
does not control. A fix on the ztls side might still be exposed at
the embedder if the embedder manages its own lifetime.

A sixth, narrower axis — **wisdom-of-the-crowd consumer mistakes** —
covers the category of bugs that arise from well-intentioned embedders
making plausible mistakes: passing `NULL` for "not set", passing
`&buffer[0]` for "empty", declaring `ztls_record_buffer rb = {0}` and
missing a field, calling `ztls_client_init` with `public_key = NULL`
and hoping for "magic init". The recon prose below distinguishes
"embedder is malicious" from "embedder is careless", because the C
ABI must defend both with the same primitives.


## Attacker model

Three attacker classes share the surface, each with a distinct
mental model and a distinct exploit shape. The wire-byte attacker
(covered in `RECON.md`) is listed for context; the new class is the
embedder.

**Wire-byte attacker (existing, see `RECON.md`):** a hostile TLS peer
on the wire. Has no knowledge of struct layouts, pointers, NULL,
length-param conventions, or ABI versions. Communicates with ztls
through serialized bytes that the embedding parses. Cannot pass
invalid pointers; cannot lie about `struct size_t`; cannot mutate
state across calls; cannot issue commands outside the protocol.

**Untrusted C embedder (new — this scope):** the application
programmer on the other side of the FFI. May pass:

- `NULL` for any pointer parameter, deliberately or by accident.
- Wild or freed pointers, including pointers that were valid at the
  time of the call but have since been reused (use-after-free at the
  caller, propagated into ztls).
- Pointers whose offset matches the layout they remember from a
  different ztls version (version-skew bias — also known as
  `addrof`-shaped bugs, but applied to longs-lived layouts).
- Pointers that alias each other or ztls-internal storage they have
  not been told about (aliasing surprise).
- Length values that exceed the buffer backing the pointer
  (length-mismatch; "if you trust caller-reported lengths you walk
  into wherever they tell you").
- Length values that *under-report* the buffer backing the pointer
  (truncation; C embeds that pass `record_len = strlen(record)`
  rather than the actual buffer size).
- All-zero bytes where they expect the API to "do something
  sensible" (zero-length ALPN list, empty server_name, etc.) — the
  embedder may not know that `0x00…00` is the X25519 identity element
  and reject shaped.
- Buffer contents modified after `ztls_*_write_record` returns
  but before ztls has stopped using them (aliasing two ctypes call
  paths because the embedder retains references).
- Signed/unsigned mismatch: a host ABI where `size_t` is 32-bit
  crossing ztls `usize` at 64-bit, or a host where `ssize_t` got
  passed where `size_t` was expected.

**Foreign-runtime embedder (subset, raised here for visibility):**
embedders using Python ctypes / Ruby FFI / Rust unsafe / Go cgo have
specific failure modes that the C ABI has to be robust against. Each
runtime has its own allocator, garbage collector, goroutine
scheduler, and conventions about what it does to a callable when
control yields. A Python ctypes embedder might pass a `CFUNCTYPE`
that the Python GC collects before ztls invokes it. A Go cgo
embedder might run ztls on a goroutine that migrates threads mid-
handshake. A Ruby embedder might allocate a `FFI::Struct` whose
inner buffers got relocated by Ruby's GC. Treat the C-ABI as
correctness-against-the-runtime as well as correctness-against-
the-programmer.

The C ABI is the seam that intersects all three. Recon work for the
embedder attacker is in §"Hunt queue". Recon work for the foreign-
runtime attacker falls out of the same hunt list but takes a
different proof shape (driver must spawn the embedder runtime and
call through it, not just `dlopen` the library).


## Externally-controlled inputs across the C ABI

Each input that crosses the boundary is enumerated below. The
classification distinguishes *byte-controlled* (ztls reads the
bytes for protocol semantics), *length-controlled* (ztls trusts a
size but may also prefix-validate), *pointer-controlled* (the bits
are not interesting; only the address and lifetime), and *struct-
shape-controlled* (ztls expects a struct of specific layout that
exists at the C-side compile).

### Bytes

- `public_key[32]` / `secret_key[32]` — `(const uint8_t *public_key, …)`
  on `ztls_client_init` and `ztls_server_init`. The bytes carry
  protocol semantics (X25519 / P-256 key material). All-zero public
  key is the X25519 identity element per RFC 7748 §6.1; the
  existing ztls code path rejects it with `IdentityElement` (see
  `src/x25519.zig`); the C ABI question is whether the rejection
  is exposed as `ZTLS_ERR_IDENTITY_ELEMENT` (per #30's error list)
  or surfaced as a generic `ZTLS_ERR_HANDSHAKE_FAILURE`.
- `random[32]` — client `random` on `ztls_client_start`; server
  `random` on `ztls_server_handle_record`. RFC 8446 §4.1.2 forbids
  all-zero `Random`; #30 leaves the rejection to ztls. The C ABI
  of #30 documents caller-supplied random as the convention, but
  the rejection surface is silent until a malformed `random` is
  fed in.
- `record[record_len]` — `(uint8_t *record, size_t record_len)` on
  `ztls_client_handle_record` and `ztls_server_handle_record`.
  Bytes may be a TLSPlaintext or TLSCiphertext depending on state.
  Decrypted in place per #30's open question 4.
- `plaintext` on `ztls_client_send_application_data` — input to
  AEAD. Byte-controlled; semantics are app-layer payload.
- `cert_chain_der` on `ztls_server_send_authenticated_flight` —
  DER-encoded chain supplied by the embedder. Crosses directly into
  the existing `src/certificate.zig` parser, but the DER itself is
  server-controlled in the normal handshake flow. (The C-embedder
  attacker can shape it.)
- ALPN string array — `const char *const *protocols` on
  `ztls_client_offer_alpn` / `ztls_server_support_alpn`. Each
  protocol is a NUL-terminated C string. Byte-controlled but
  constrained by the wire-format ALPN requirement (RFC 7301):
  ASCII, no embedded NULs, length-prefixed on the wire. Embedder
  who passes a string with an embedded NUL produces a C-string
  truncation that ztls never gets to see.

### Lengths

- `size_t out_len` — on every fallible function that produces
  bytes. Embedder-controlled.
- `size_t record_len` — the wire bytes. Embedder-controlled.
- `size_t plaintext_len` — input plaintext bytes.
- `size_t count` — on `ztls_client_offer_alpn(...count)` /
  `ztls_server_support_suites(...count)`. Embedder-controlled.
  Integer overflow is the lurking class for any of these.
- `size_t cert_chain_len` — on the server's send-cert-chain calls.
- `size_t out_written` — out-parameter, the *caller's* storage.
  Embedder allocates the size_t; ztls writes into it.

The narrow-type arithmetic class (Zig 0.15 evaluates
`narrow_type + comptime_int` in the narrow type before widening,
see project `AGENTS.md` §"Zig Style" and #72's 14-site fix) is
present in C ABI code as well as wire code. `record_len + N`,
`count + 1`, `out_len - N` all use attacker-controlled integers
that read as `usize` in capi.zig but arrived as `size_t` from a
caller who might pass a length near `~size_t`'s max. Hints the
hunter must inspect capi.zig once it lands: every `if (x < y + N)`
with `y` from a caller, every `for (0..count)` with `count`
attacker-controlled, every `ptr + len` arithmetic on caller
lengths.


### Pointers

- `out` — caller-provided scratch buffer for handshake output.
  Always paired with `out_len`. Pointer-controlled.
- `out_written` — the caller's `size_t *`. Pointer-controlled.
  Embedder may pass a valid `size_t *` they want filled, a NULL
  pointer they do not care about, or a wild pointer.
- `record` — caller-provided `uint8_t *`. Pointer-controlled AND
  byte-controlled.
- `selected_alpn` out-parameter — `const uint8_t **out` /
  `size_t *out_len` on the query functions. Pointer-controlled,
  and lifetime matters.
- `client_server_name` out-parameter — same shape as
  `selected_alpn`.
- `event` (`ztls_event *`) on `ztls_client_handle_record` /
  `ztls_server_handle_record`. Pointer-controlled; ztls fills in
  fields, embedder reads them.
- `ztls_record_buffer *rb` — caller-provided. The struct's
  `storage[ZTLS_RECORD_BUFFER_STORAGE]` lives in the embedder's
  allocation. Pointer-controlled.

### Struct shape

- `sizeof(ztls_client)` / `sizeof(ztls_server)` /
  `sizeof(ztls_record_layer)` — the embedder allocates with one
  value of these constants; ztls uses another. The CI shape of
  this drift falls out of `RECON.md` tangentially; the C ABI
  version-skew variant is new and explicit.
- `ZTLS_SUITE_STATE_SIZE` — a single manifest constant, the
  maximum of the SHA-256 / SHA-384 union arms. If the maximum
  has to grow, the header bumps `ZTLS_SUITE_STATE_SIZE`; the
  embedder recompiles; the layout matches. If the maximum does
  not grow but ztls internally uses a larger arm, structure
  write past `_suite_state[N]` corrupts either the next
  `_reserved` region (if it exists and is large enough) or the
  first field after `_suite_state`. CI does not exercise this
  drift today.
- `event_type` / `state` enum — the tag values. Embedder passes
  a `ztls_event` whose `type` field is one of
  `ZTLS_EVENT_*`. The enum shape is fixed across versions.
- `record_layer` — the exposed `extern struct`'s AEAD-context
  region is opaque per #30 open question 5. Repinning the
  size across versions is where the F4 ABI skew hunt lives.


## Lifetime and aliasing assumptions per function

This part of the doc protects hunters from writing "the C API copies
the input" assumptions that are not actually specified. Each function
is paired with the lifetime and aliasing expectations the embedder code
will encode. Anything here is a *contract claim* about the C ABI shape
proposed in #30; no claim is reversed, only listed for inspection.

### Init / deinit pair

`ztls_client_init(client, public_key[32], secret_key[32])` /
`ztls_client_deinit(client)` — same shape for server. The Zig
counterpart `ClientHandshake.init(keypair: KeyPair)` inlines
keypair bytes into the struct (see `src/ClientHandshake.zig:1`
and the `KeyPair` field declaration). The C-ABI shape that
preserves the Zig primitive is: ztls copies `public_key` /
`secret_key` into the client struct's own storage before
returning. The contract claim that protects the embedder:
*after init, the caller may free or overwrite the input key
arrays without affecting the client.* If capi.zig aliases
caller storage instead, the embedder's "I free my key after
init" plausibly corrupts the client. Hunt candidate: a harness
that zeroes `secret_key` after init and asserts the client still
completes a handshake; if capi.zig aliases, the runner crashes
or returns the wrong shared secret. This is an FFI version of
the lifetime-aliasing class.

### In-place record decryption

`ztls_client_handle_record(client, record, record_len, out,
out_len, event)` and the server analogue. Per #30 open question
4 the record is *non-const* (decrypted in place). Aliasing risk:
caller passes a `record` buffer that aliases either:
1. their own application buffer that they continue to read
   after the call,
2. the `out` buffer (a one-buffer aliasing optimization that
   some embedders might naturally try), or
3. ztls-internal storage the embedder believes they own.

(3) is a careless or accidental class — the embedder fills in an
aliased buffer the API has not advertised. (1) and (2) are
carelessness classes: the embedder passes a record buffer they
were using for something else and ends up seeing their own bytes
mutated. Hunt candidate: a harness that pre-fills `record[0..8]`
with a sentinel, calls handle_record, and asserts the sentinel
bits are intact (or were clobbered per the documented contract).


### RecordBuffer writable vs next aliasing

`ztls_record_buffer_writable(rb, **out, *out_len)` returns a
writable region into `rb.storage`. After the embedder fills the
region and calls `ztls_record_buffer_advance(rb, n)`, subsequent
`ztls_record_buffer_next(rb, **out, *out_len)` returns a pointer
to the next complete record in the same underlying storage.

The aliasing question that needs a clear answer: if the embedder
hands back the `writable` pointer after advance(), then `next()`
fires before the embedder has had a chance to do anything with
the writable contents, does `next()` consume the storage the
embedder just wrote into? The Sans-I/O framing semantics
(§"Why" choice of #30) require that callers receive records as
streaming output; the buffer's `filled` cursor moves forward
with each advance(). Embedders can rely on the rule: between
consecutive advance() and next() calls, the storage that
writable revealed is owned by ztls (consumed into the framing
state). Embedders who hold onto the writable pointer and expect
to read it after next() are buggy, but the ABI docs should
publish this rule.

### ztls_event.data pointer

For events of type `APPLICATION_DATA` and `WRITE`, `event.data`
points to decrypted plaintext bytes or to handshake-output bytes.
The C-API contract claim of #30 is that `event.data` and
`event.data_len` describe the bytes that the embedder dereferences
next. **Lifetime aliasing question:** does `event.data` alias
the caller's `record` (post-decryption) or ztls-internal storage?
Both are plausible implementations:

- *alias caller `record`*: `event.data` points into the
  embedder's input buffer that just got decrypted in place.
  Embedder reads it directly; aliasing risk if the embedder is
  reusing the input buffer.
- *alias ztls-internal storage*: `event.data` points into
  ztls's framing output (a separate ring or buffer); embedder
  reads it, copies it, releases it. Higher cost; aliasing
  guaranteed to not bite the embedder's other buffers.

The choice is not made in #30. The hunter will exercise both
shapes via a mutable-record with overlapping content and report
which of the two the design lands on.

### Query results: selected_alpn, client_server_name

`ztls_client_selected_alpn(client, **out, *out_len)`. The `out`
pointer is into either the EE bytes (post-decrypt, stored in the
client's handshake state) or the client's own output state. The
embedder reads `*out` for the lifetime of `client` in the
relevant connected state. After the client transitions to a
post-handshake KeyUpdate or re-handshake state (out of scope
per #30's "What is out of scope" item), the EE bytes may be
invalidated. Hunt candidate: a harness that captures the
selected_alpn pointer during `WAIT_EE`, drives the rest of the
handshake to `CONNECTED`, and asserts the captured pointer still
resolves to the same bytes.

`ztls_server_client_server_name(server, **out, *out_len)` —
similar lifetime to selected_alpn.

### Application data receive

`ztls_server_receive_application_data(server, **out, *out_len)`.
Per the proposed #30 signature, this returns a pointer into
either the caller's `record` (post-decrypt) or ztls-internal
storage, with the same aliasing tradeoffs as the event.data
case above. Distinct from receive_application_data in that the
embedder here is not iterating over an event-driven API: this
is a direct read of the latest received plaintext.

### Signer callback (open question 2 in #30)

If the signer callback lands, the trust boundary runs the other
direction: ztls calls into the embedder's `sign(msg, out)` (or
equivalent). The embedder is then an attacker-controlled
function-from-ztls. The class of vulnerabilities is: a
misbehaving signer can produce a signature of the wrong scheme,
wrong length, wrong key id, or wrong digest. C-ABI review of
this callback must include:

- ztls validates the callback returned the expected signature
  length and rejects lengths at the boundary; *not* after the
  bytes are written into the AEAD/HMAC computation.
- ztls validates the callback did not touch any state outside
  the embedder-visible handle.
- ztls does not rely on the callback to zeroize private-key
  memory; this is the embedder's contract.
- ztls does not feed the callback a buffer whose address leaks
  into a different callback's return path (callback aliasing).

This hunt is conditional on Q2 landing. If Q2 is deferred
without `ztls_signer_*`, the F5 hunt collapses to a no-op.


## NULL, all-zero, past-end distinctions the ABI must preserve

Each embedder control-plane call site defines a NULL contract.
The list enumerates the conventions the C ABI must publish so an
embedder knows which NULL means *failure*, which NULL means
*functionally equivalent to zero-length*, and which NULL means
*not permitted at all*.

### NULL pointers

- `public_key` / `secret_key`: per the proposed #30 contract,
  `NULL_PARAMETER` is in the error enum. The convention must
  publish: "all key arrays are non-NULL."
- `random`: per #30, all functions taking `random` expect the
  caller to provide 32 bytes; `NULL` random is invalid. The
  error code is unclear from #30; the ABI must surface a
  distinguishable "you gave me NULL" vs "you gave me a malformed
  random so I rejected your handshake."
- `server_name`: an empty C string (`""`) is the *legal* "I don't
  want SNI" form per RFC 8446 §3.1. `NULL` is invalid.
- `out`: NULL with `out_len > 0` is invalid; NULL with `out_len
  == 0` may or may not be valid depending on the function (see
  the per-function "is output required?" question).
- `out_written`: NULL means "embedder does not care about the
  byte count". Functions must defer writing this and not
  dereference a NULL pointer under any circumstance.
- `event`: NULL. The proposed #30 shape makes `event` non-NULL
  for `ztls_client_handle_record` /
  `ztls_server_handle_record`. The ABI must publish that.
- `protocols` (ALPN offer support): NULL with `count == 0` is
  "no protocols", `== 0`; NULL with `count > 0` is invalid.
- `rb`: NULL on the record-buffer API is invalid (functions
  dereference `rb`).

### All-zero key material

- All-zero `public_key[32]` (X25519): identity element per RFC
  7748 §6.1; ztls rejects with `IdentityElement` in the wire
  path. The C-ABI question is: does the embedded API
  *(a)* reject at init time (preferred — caller-supplied
  identity element is a programmer error), or
  *(b)* accept at init time and reject at handshake time (would
  surface as a handshake-time error rather than init-time)?
  Per the proposed `ZTLS_ERR_IDENTITY_ELEMENT` enum entry, the
  intent is (a). The ABI must publish this so the C consumer
  knows *why* the init failed, not "your key is bad."
- All-zero `secret_key[32]` (X25519): a low-entropy input but
  not a protocol-mandated rejection; the C ABI may accept at
  init and let the protocol layer's key-derivation semantics
  catch any issue. Currently not enforced.

### All-zero random

`random[32] = {0}` is forbidden by RFC 8446 §4.1.2. The C ABI
must surface the rejection cleanly. Question: which of
`ZTLS_ERR_INVALID_STATE` / `ZTLS_ERR_HANDSHAKE_FAILURE` (per
#30's error enum) is the rejection surface? The hunter must
inspect what error the embedder gets so a misclassified
rejection does not look like "weird crypto error".

### Empty / zero-length inputs

- `server_name = ""` — empty string, legal C string but
  semantically absent. Per RFC 8446 §3.1 the SNI extension is
  optional; an absent SNI means no host name, not an empty
  one. The C ABI must distinguish "I omitted SNI" (no
  extension) from "I sent SNI with empty HostName" (the
  OpenSSL convention; not RFC-mandated). The ztls decoder
  state already accepts both; the embedder must know which the
  C-API produces.
- `out_len = 0` with `out != NULL` — buffer-too-small error
  class; the embedder attempt to write into a zero-length
  buffer gets a clear error.
- `count = 0` on ALPN / suites — "empty list" is meaningful
  (no ALPN offered; no suites supported); the embedder's
  intent is preserved.


### Past-end / out-of-range

- A pointer past the end of an allocated region (e.g., one byte
  past the end of `record`) is legal-looking. ztls never
  validates "you allocated on the address side"; the embedder
  owns that contract.
- A length that exceeds the buffer backing the pointer is a
  protocol-violation at best, a memory safety bug at worst.
  ztls validates `record_len` against the framing's expected
  bounds; the embedder is responsible for not skipping past
  its own buffer.
- A `count` that exceeds the embedded array is the same shape
  as a too-large ALPN list.

### Out-of-band constants

- `ZTLS_MAX_WIRE_RECORD_LEN` and `ZTLS_RECORD_BUFFER_STORAGE`:
  if the library version diverges from the header's pinned
  values, the embedder's `ztls_record_buffer` allocation is
  undersized or oversized. The C ABI's drift detection
  contract is silent; a hunter must exercise the dynamic-link
  case where the embedder was built against header version X
  and the runtime library is patch version Y with a different
  internal storage size.
- `ZTLS_SUITE_STATE_SIZE`: see §"Externally-controlled inputs
  across the C ABI" → "Struct shape" above.


## Existing C-ABI coverage map

The C ABI does not yet exist in-tree (`src/capi.zig` is a #30
deliverable). The fuzz-target map, regression-test set, and
conformance runs do not yet exercise the FFI surface. This
section is an empty placeholder — once `src/capi.zig` and
`include/ztls.h` land, the following entries are expected:

- A targeted libFuzzer harness driving the C ABI surface, not
  the Zig-internal surface. The harness must produce seeds for
  the `init`, `handle_record`, `send_application_data`,
  `send_alert`, `record_buffer_writable/next`, `selected_alpn`,
  `client_server_name`, and (if Q2 lands) signer callback
  paths.
- C-level unit tests in `tests/capi/` exercising the per-
  function contracts above: NULL rejection, zero-length
  acceptance, in-place record buffer clobbering,
  `_suite_state` size sanity.
- A header-vs-library smoke check that compares
  `sizeof(ztls_client)` in `tests/capi/` (C side) against the
  Zig-side `ClientHandshake` size at the same commit. Today,
  mismatch detection is incidental (`zig build test` would
  notice if capi.zig referenced a wrong size); a deliberate
  CI step is a follow-up.

The wire-side hunts from the prior recon (H1–H8 in `RECON.md`)
do *not* exercise the FFI surface. They exercise the
Zig-internal functions `ClientHandshake.handle_record` etc.
The C-ABI shim in `src/capi.zig` will be a translation layer;
bugs introduced in the shim layer do not surface in the
existing fuzz suite. Fuzz-engineer work for the C ABI is
recommended to land alongside #30's initial capi.zig, with a
dedicated libFuzzer target named `fuzz_capi_handle_record`
or similar.


## Attack surface per FFI shape

Subsystems the hunter must attack one-by-one. The categories
are not orthogonal to `RECON.md` §"Attack surface per
subsystem"; a wire-side hunt that targets server_hello's
key_share enum does not catch a C-ABI struct-layout bug. The
C-ABI subsystem crosswalk:

### 1. Pointer-output invariants

`ztls_client_selected_alpn`, `ztls_server_client_server_name`,
`ztls_server_receive_application_data`, `ztls_event.data`,
and `record_buffer_next` are all pointer-output. Each is a
distinct lifetime and aliasing contract. Recon entry:
*each pointer-output function is a hunt target with its own
trust boundary and its own lifetime claim*. The F6, F8, and
F9 hunts below reflect this.

### 2. Pointer-input invariants

`record` (mutable, byte-controlled); `out` (mutable,
length-controlled); `out_written` (length-out only);
`out_len` (length-controlled); `random` (byte-controlled);
`public_key` / `secret_key` (byte-controlled); ALPN string
arrays (byte-controlled + length-controlled). Pointer-input
issues revolve around NULL handling, length-mismatch, and
narrow-type arithmetic overflow.

### 3. NULL contract gaps

The proposed #30 enum includes `ZTLS_ERR_NULL_PARAMETER`,
but the per-function NULL contract is not enumerated in #30
itself. A function-by-function NULL matrix is a hunt
artifact — once `src/capi.zig` lands, a C harness matrix
of every parameter pair-rest-possible-NULL tests the contract.

### 4. Lifetime / state transitions

`client` and `server` structs cross state transitions. Each
transition may invalidate data the embedder captured from a
prior query. The hunter must exercise every transition order
documented in `THREAT_MODEL.md` (Initial → Connected →
KeyUpdate → Closed and so on) and check that pointer data
captured in state A is still valid in state B.

### 5. ABI version skew

`ZTLS_SUITE_STATE_SIZE` is fixed; ABI drift in the
`ClientHandshake.Suite` union could exceed the pinned size.
The CI today does not detect this for the C ABI. The ABI-
skew hunt is structural: compare the binary's sizeof
output to the header's `_suite_state[N]` value under
different build flags, builds, and patches.

### 6. Signer callback (conditional on open question 2 in #30)

The callback runs from ztls to embedder. Embedding the
callback without first defending it gives an attacker
multiple vectors: signature length inflation, signature
scheme gap, expiry of validity constraints. The hunt is
only relevant if Q2 lands; otherwise this section is empty.

### 7. RecordBuffer state-machine

The record buffer's `writable` / `advance` / `next` triple
is a small state machine with three integers (`pos`, `filled`,
storage cursor). On the wire, the state machine is fuzz-
covered (`RecordBuffer.next` tests in the tree); the C
variant is new. The hunter must confirm the FFI state
machine reaches the same coverage state as the Zig state
machine.

### 8. Event/opaque regions

`_suite_state[ZTLS_SUITE_STATE_SIZE]`, `_reserved[N]`, and
the inside of `ztls_record_layer` are opaque byte arrays
visible to the embedder. They are not user-mutable, but
their sizes affect struct layout and ABI skew. The hunter
should not look inside these byte arrays (the embedder must
not either); the hunter should look at the byte-array
*sizes* and the load-store alignment.


## Hunt queue

Ten narrow tasks. Each is one (attack class, target function,
entry point) plus a proof artifact a `whitehat-hacker` can
chase once `src/capi.zig` lands. Items marked **Fable-worthy**
are reserved for `siege` because reasoning depth is the
bottleneck rather than a single-function bounds check. The
pre-Fable filter recommendation: if the hunter's first move
is "read the bytes at offset X and check the bounds", leave
it on opus. If the hunter has to hold a multi-object
state-machine lifetime in working memory, escalate.

### F1 — Pointer/length confusion in mutating
       `(out, out_len, out_written)` triplets
- **Attack class:** pointer/length bounds FFI bug. The
  classical "trust caller-reported lengths" vulnerability
  class. Compound: out is both pointer-input AND length-
  output; out_written is a separate pointer-output for the
  bytes-written count.
- **Target (proposed in #30):** every fallible function
  with the signature `(client, uint8_t *out, size_t out_len,
  size_t *out_written, …)`. Including `ztls_client_start`,
  `ztls_client_handle_record`, `ztls_client_send_application_data`,
  `ztls_client_send_alert`,
  `ztls_server_handle_record`,
  `ztls_server_send_authenticated_flight`,
  `ztls_server_send_certificate_chain_flight`,
  `ztls_server_send_application_data`,
  `ztls_server_send_alert`.
- **Trust boundary:** FFI; lengths are
  embedder-controlled.
- **Why fruitful:** the per-function defence against
  length-mismatch is not enumerated in #30. Each of the
  above functions needs `(out != NULL || out_len == 0)`,
  `(out_written == NULL || dereferenceable)`, and
  `out_len <= buffer backing out` enforced in capi.zig.
  These three checks independently protect against
  attacker-controlled bytes overflows, attacker-controlled
  NULL pointer-of-tuple writes, and attacker-controlled
  length truncation.
- **Existing coverage:** none yet. The Zig-internal API
  has trust boundaries of its own
  (`wire.Reader.assumeRead*`) but those do not cover the
  C ABI's `(out, out_len)` tuple.
- **Proof artifact:** a C harness that drives each
  function with `(out != NULL, out_len = 1)`, `(out ==
  NULL, out_len = 0)`, `(out != NULL, out_len = 0)`,
  `(out != NULL, out_len = max_size_t)`,
  `(out != NULL, out_len = 12345 illegal)`, and
  `(out_written = NULL, …)`. For each, the expected
  outcome is a typed error and a clean return; UB or
  silent success is the bug.
- **Priority:** P0.
- **Validator focus:** the hunter must show the rejection
  happens *before* capi.zig writes into `out` or
  dereferences `out_written`.
- **Fable-worthy:** no.


### F2 — NULL parameter gaps across entry points
- **Attack class:** NULL contract FFI bug. Distinct from
  F1 because the questions are: is `NULL` `out` with
  `out_len == 0` legal? is `NULL` `out_written` legal? is
  `NULL` `event` legal? is `NULL` `server_name` legal?
  is `NULL` `random` legal? is `NULL` `public_key` legal?
  Each *function* gets its own matrix; the matrix is only
  complete when the contract is published and tested for
  every entry point.
- **Target:** every public function in the proposed #30
  API. Each function's parameter list maps to a row in the
  NULL matrix; each row maps to a hunt sub-target.
- **Trust boundary:** FFI; pointers are
  embedder-controlled.
- **Why fruitful:** the proposed `ZTLS_ERR_NULL_PARAMETER`
  error exists but the per-function NULL contract is open.
  Embedder-side, the "I am calling this function from a
  language runtime that returns NULL on missing"
  conventions vary across Python/Ruby/Rust/Go
  and a missed contract bit will surface as either a
  defensive NULL_PARAM error (good) or a segfault through
  ztls (bad).
- **Existing coverage:** none.
- **Proof artifact:** a C harness that drives each
  function with NULL on each pointer position, paired
  with the suspected rejection or crash. The hunter must
  publish the per-function NULL matrix as a doc
  artifact.
- **Priority:** P0.
- **Validator focus:** is the rejection order NULL →
  length-check → state-check, so a NULL_PARAM error is
  distinguishable from a state error?
- **Fable-worthy:** no.

### F3 — Mutable in-place record buffer surprise
- **Attack class:** lifetime / aliasing FFI bug. The
  embedder mutates the buffer they hand ztls and reads
  back its mutated form; this is by design (decryption in
  place), but the contract must publish that. Aliasing
  variants: (a) embedder's own application buffers alias
  the record buffer; (b) input `record` aliases output
  `out`; (c) embedder is doing a memcpy to free staging
  memory that races with ztls.
- **Target:** `ztls_client_handle_record` and
  `ztls_server_handle_record`.
- **Trust boundary:** FFI; the bytes are caller-supplied
  but the *mutation* is ztls-side.
- **Why fruitful:** #30's open question 4 frames it as a
  design choice but does not enumerate the aliasing
  variants. The embedder's README-level documentation
  may claim "the buffer is modified in place" but the
  contract must also be that `out` is *not* modified in
  place (encryption path) and that the embedder must not
  alias record-buffers to other state.
- **Existing coverage:** the Zig side has coverage for
  decryption-in-place semantics; C-side coverage does
  not exist.
- **Proof artifact:** a C harness that uses pre-recorded
  ciphertext, fills `record` with a sentinel at offset
  8, calls handle_record, and asserts the post-call
  state of the sentinel. Variants: `out` aliases
  `record`, `record` aliases a stack buffer the harness
  reads afterward.
- **Priority:** P1.
- **Validator focus:** does the capi.zig preserve-by-
  wire convention specifically (record is in/out, out is
  out-only)?
- **Fable-worthy:** no.


### F4 — ABI version skew between libztls.so and
       include/ztls.h
- **Attack class:** struct-layout skew FFI bug. CVE-2017-
  3735-class: a dynamic-linker mismatch where the
  consumer's view of a struct (compiled against header X)
  diverges from the runtime (patch-version Y) used at
  load time. The project has no explicit drift
  detection; the embedder is on the hook for matching
  `_suite_state` sizes.
- **Target:** the `_suite_state[ZTLS_SUITE_STATE_SIZE]`
  byte array inside `ztls_client` and `ztls_server`; the
  `_reserved[N]` byte array; the `ztls_record_layer`
  AEAD-context region if exposed.
- **Trust boundary:** FFI + dynamic linker. Layered
  attacker model: a header pinned at version X across
  patches; a runtime that has grown.
- **Why fruitful:** the project documents pre-alpha
  instability as a "pin your version, recompile on
  upgrade" discipline. The discipline is embedder-side;
  ztls-side, the discipline is "a CI-built header matches
  the CI-built library." If CI drift goes undetected, the
  discipline is silent for the embedder that pulls a
  patch-versioned binary.
- **Existing coverage:** none. CI does not have a header-
  versus-library check today (the Zig-internal types
  are not ABI-pinned for C consumers).
- **Proof artifact:** a C harness built against header
  X.Y, with a synthetic ABI mismatch (capi.zig bumped
  to a stub `ZTLS_SUITE_STATE_SIZE = N + 16` and
  recompile only the capi target); load the resulting
  binary into libFuzzer and exercise the
  `*_handle_record` flow; capture the segmentation fault
  or memory corruption.
- **Priority:** P0.
- **Validator focus:** does capi.zig expose any form of
  runtime layout check on init, or does it rely on
  embedder discipline?
- **Fable-worthy:** no.

### F5 — Signer callback trust boundary (open question 2)
- **Attack class:** callback trust boundary; ztls calls
  into embedder-supplied function. If Q2 lands
  (`ztls_signer_*` is exposed), this hunt categorizes
  the trust boundary that runs from ztls to embedder.
- **Target:** the proposed `ztls_signer_sign` (or
  equivalent) callback type. Every callback parameter
  is a class boundary: a malicious or buggy signer can
  produce a wrong-length signature, wrong scheme, wrong
  digest, or a signature referencing key id X while the
  peer's identity is key id Y.
- **Trust boundary:** FFI in reverse. ztls calls into
  embedder code; the embedder is the attacker.
- **Why fruitful:** open question 2 of #30 has not landed,
  so this hunt is conditional. If Q2 lands with a
  hand-off API (caller-supplied callback), ztls's
  validation of the callback output is the only line of
  defence against an embedder that misbehaves on
  purpose. Per-function checks: signature length,
  signature scheme, key identity vs peer-supplied
  identity.
- **Existing coverage:** none in the C ABI; the Zig
  side has signer types (`signature.zig`) but the C
  API's callback path is new.
- **Proof artifact:** a C harness where the signer
  callback returns a wrong-length buffer, the wrong
  signature scheme, or the wrong key id; capi.zig must
  reject each shape before they reach
  `signature.zig`'s verification path.
- **Priority:** P1 (P2 if Q2 does not land).
- **Validator focus:** does ztls validate at the
  callback boundary, or does it forward to the
  verification path and let it fail?
- **Fable-worthy:** potentially yes if Q2 lands with a
  complex multi-field trusted-key identity scheme that
  requires holding the embedder's trust state and the
  peer's requirements in working memory simultaneously.


### F6 — RecordBuffer writable vs next aliasing
- **Attack class:** state-machine aliasing FFI bug. The
  `writable` and `next` pointer-output functions both
  return pointers into `rb.storage`. They alias across
  calls; the embedder's view of "I have a writable
  region" must not include "this region is also what
  next gave me last time."
- **Target:** the three-call sequence
  `writable(rb) -> write some bytes -> advance(rb, n) ->
  next(rb)` plus variants with extra intermediate calls.
- **Trust boundary:** FFI; the embedder is
  embedder-controlled (and may be careless).
- **Why fruitful:** the Sans-I/O framing semantics are
  clear in the Zig source but the C-API shape must
  publish a per-call rule. The hunter must verify the
  contract: between successive calls, does
  `(*out, *out_len)` from writable still point to the
  same memory after next()? Does the next writable call
  give the same pointer the embedder already advanced?
  The contract claim about `advance` must be precise.
- **Existing coverage:** Zig `RecordBuffer.next` is
  fuzz-covered; the C variant is new.
- **Proof artifact:** a C harness that records the
  pointers returned by writable, next (in order), and
  asserts the relative ordering after a sequence of
  inserts and consumes. Variants: re-call writable
  without advance, re-call writable across multiple
  advance() calls without next.
- **Priority:** P1.
- **Validator focus:** does the capi.zig mirror the
  Sans-I/O contract exactly, or does it introduce a
  buffer-read protocol that the Zig side does not have?
- **Fable-worthy:** no.

### F7 — All-zero X25519 public_key identity-element
       rejection surface at the FFI
- **Attack class:** parser+credential gate FFI bug. The
  wire path rejects the X25519 identity element; the
  question is whether the C-API surfaces the rejection
  cleanly to the C consumer. The bug shape: an
  embedder passes all-zero public_key by mistake
  (defaulted array, zeroed struct, etc.) and gets
  *some* error back. If the error is muted or
  miscategorized, the embedder's debugging trace is
  "my key is bad" instead of "you gave me the identity
  element, that's an RFC 7748 §6.1 reject."
- **Target:** `ztls_client_init` and `ztls_server_init`
  with all-zero `public_key[32]`.
- **Trust boundary:** FFI; the bytes are
  embedder-controlled but the rejection is ztls-side.
- **Why fruitful:** identity-element rejects are
  deliberately a separate error enum in #30
  (`ZTLS_ERR_IDENTITY_ELEMENT`). The hunter must
  verify the rejection does happen, surfaces the right
  error code, and is not silently accepted at init time
  only to fail later in the handshake with a
  misleading HANDSHAKE_FAILURE.
- **Existing coverage:** wire-side coverage already
  exists in `src/x25519.zig` (the `IdentityElement`
  reject path); C-side coverage is not present.
- **Proof artifact:** a C harness driving
  `ztls_client_init(client, all_zeros[32], …)` and
  asserting the return is exactly
  `ZTLS_ERR_IDENTITY_ELEMENT`. Negative complement:
  same call with a valid key returning `ZTLS_OK`.
- **Priority:** P0 (security-critical correctness
  gate).
- **Validator focus:** is the rejection classified
  under `ZTLS_ERR_IDENTITY_ELEMENT` or under a generic
  HANDSHAKE_FAILURE bucket? The latter is the bug
  shape.
- **Fable-worthy:** no.


### F8 — Selected ALPN pointer lifetime
- **Attack class:** pointer-output lifetime FFI bug.
  `ztls_client_selected_alpn(client, **out, *out_len)`
  returns a pointer to the EE bytes; the embedder reads
  them. The bug shape: the embedder captures the
  pointer in state `WAIT_EE` and reads after the
  client has transitioned to `CONNECTED`, and the
  underlying memory has changed (state-invalidating
  rewrite, KeyUpdate, post-handshake record rotation
  that overwrites the EE region).
- **Target:** the pointer returned by
  `ztls_client_selected_alpn`, and similarly the
  pointer returned by `ztls_server_client_server_name`.
- **Trust boundary:** FFI (pointer-output surface).
- **Why fruitful:** the C-API exposes a pointer that
  the embedder treats as owned-storage; ztls treats
  the underlying bytes as state-internal. The point
  at which they diverge is the bug. Sibling hunt:
  server-side `client_server_name` is the same
  shape.
- **Existing coverage:** wire-side, the EE bytes are
  freed at handshake completion by the Zig
  allocator; C-side, the embedder has no visibility
  into that freeing pattern.
- **Proof artifact:** a C harness that captures the
  pointer at `WAIT_EE`, drives the rest of the
  handshake to `CONNECTED`, reads the bytes, and
  asserts the bytes are unchanged (or surfaces a
  documented invalidation event).
- **Priority:** P1 (correctness gate; not a memory-
  safety bug if ztls retains the bytes).
- **Validator focus:** lifespan contract the
  embedder can rely on.
- **Fable-worthy:** no.

### F9 — Event.data pointer where-does-it-alias
- **Attack class:** aliasing surprise FFI bug. The
  pointer in `event.data` aliases either the caller's
  `record` (post-decryption) or ztls-internal storage;
  the embedder has to know which to handle the lifetime
  correctly.
- **Target:** `ztls_event.data` after
  `ztls_client_handle_record` /
  `ztls_server_handle_record` returns
  `ZTLS_EVENT_APPLICATION_DATA` and the embedder
  dereferences the pointer.
- **Trust boundary:** FFI (pointer-output with
  cross-call aliasing).
- **Why fruitful:** bugs here are embedder-visible, not
  ztls-internal. The recon must publish which shape
  the design lands on. If ztls lands on *alias
  ztls-internal storage* and, e.g., issues a KeyUpdate
  that retires the storage, the embedder reads zeroed
  bytes. If ztls lands on *alias caller's record*, the
  embedder reading it during a new handle_record call
  reads stale bytes.
- **Existing coverage:** wire-side coverage does not
  apply (events are an embedder-side abstraction).
- **Proof artifact:** a C harness that captures
  `event.data` after one `handle_record` call,
  performs another `handle_record` (with different
  ciphertext), then reads the captured pointer and
  asserts the data either matches the first call's
  payload or surfaces a documented invalidation
  pattern.
- **Priority:** P1.
- **Validator focus:** is the embedder expected to
  memcpy the data out before the next call, or does
  ztls guarantee a stable read window?
- **Fable-worthy:** no.


### F10 — Narrow-type arithmetic overflow on
       C-introduced length fields (#72 class)
- **Attack class:** `#72` class; the project-level
  pattern of "Zig 0.15 evaluates `narrow_type +
  comptime_int` in the narrow type before widening,
  causing panic or UB on attacker-controlled lengths
  near the narrow-type max." The fix is `@as(usize,
  len) + N`. The wire-side sweep found 14 sites;
  the C ABI introduces *new* length inputs to the
  protocol surface — `count`, `out_len`, `record_len`,
  `plaintext_len`, `cert_chain_len` — that may widen
  or replace existing checks in `src/capi.zig`. The
  hunter must re-sweep capi.zig with the falsifiable
  predicate "every `len + N` arithmetic in capi.zig
  where `len` is from a caller is widened to
  `usize` first."
- **Target:** every Zig line in `src/capi.zig` that
  does arithmetic on a caller-supplied length before
  it widens.
- **Trust boundary:** FFI; lengths are
  embedder-controlled.
- **Why fruitful:** the project has documented #72 in
  `AGENTS.md` §"Zig Style" and the wire-side hunts
  fixed 14 sites. C-ABI code is new and the same rule
  applies; without a fuzz target or linter reach,
  C-ABI code is more likely than the wire surface to
  re-introduce the class.
- **Existing coverage:** `ziglint` does not catch this
  class. CI fuzz seeds are byte-focused and miss
  length math. A specific capi.zig re-sweep is
  needed.
- **Proof artifact:** a C harness driving
  `ztls_*_offer_alpn(client, ptr, count = MAX)`,
  `ztls_server_support_suites(server, ptr, count =
  MAX)`, etc.; the target panic with `integer
  overflow` at the offending line in capi.zig. The
  reproducer must be paired with a Zig-side unit
  test (in the same commit) that constrains the
  count to the overflow boundary and asserts a
  typed rejection.
- **Priority:** P0 (the wire-side reduction depended
  on aggressive sweep; the C ABI is a fresh surface).
- **Validator focus:** "every `+` in capi.zig that
  combines a length with a constant". The hunter
  must publish the per-site widening fix.
- **Fable-worthy:** no.


## Out of scope for this pass

- **Wire-side hunt topics.** `RECON.md` §"Hunt queue"
  covers wire-byte attack classes; the FFI recon does
  not duplicate those rows. A FFI-side re-discovery of
  the same bug class is a duplicate, not a new hunt.
- **Backend internal sanitizers (ASan/MSan).** Belongs
  to `fuzz-engineer` / `benchmark-methodologist`; the
  FFI recon enumerates surfaces but does not run
  them under sanitizers.
- **Header generation tools (`-femit-h`).** Open
  question 3 of #30; the recon does not evaluate it.
- **kTLS UAPI behavior.** Outside the protocol surface.
- **TLS 1.2 / DTLS / SSL 3.0 fallback.** ztls
  implements TLS 1.3 only.
- **PQ groups / hybrid KEX.** Outside the supported
  surface per `THREAT_MODEL.md`.
- **Complete ABI for v1.0.** `PRODUCTION_READINESS.md`
  tracks API stability; the FFI recon does not
  pre-commit on stability.

## Cross-document index

- [`RECON.md`](../security/RECON.md) — wire-byte recon;
  this doc is the FFI counterpart.
- [`FINDINGS.md`](../security/FINDINGS.md) — Glasswing
  H2/H3 finding record; cross-references the S1 14-site
  overflow fix that the F10 hunt repeats for the C
  ABI surface.
- `THREAT_MODEL.md` — defended classes with evidence,
  attacker model. The FFI attacker is a new class to
  add once F1/F2 surface as findings.
- `NEGATIVE_SPACE.md` — per-malformed-input response
  table. The FFI NULL/length/zero matrix is a future
  NEGATIVE_SPACE extension; this doc is the recon
  step that *precedes* that extension.
- `RFC8446_MUST_MATRIX.md` — RFC normative claims to
  evidence. Items cited from FFI hunts should not
  duplicate the wire-side rows.
- `PRODUCTION_READINESS.md` — status. Single source of
  truth. This doc does not contradict it; if a hunt
  produces findings, the readiness doc is where the
  status moves.
- #30 — the issue that defines the C ABI surface this
  doc reconnoiters.

