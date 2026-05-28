# ztls — Design & Research Notes

TLS 1.3 framing library in Zig. No allocations. No I/O. Leverage libcrypto for
the actual crypto primitives. Everything else is ours.

---

## Goals

- **TLS 1.3 only** (RFC 8446). No 1.2 fallback, no negotiation theater.
- **Correctness and performance are co-equal first-class goals.** Not
  "correctness first, optimize later" — both matter from the start. A correct
  slow implementation isn't a milestone, it's a dead end.
- **No allocations in the library itself.** Caller owns all memory. Buffers are
  passed in as slices. The engine holds no heap state. Like BearSSL, not like
  OpenSSL.
- **No I/O.** The engine is a pure state machine: you feed it bytes, it gives
  you bytes back. Where those bytes come from and go is entirely the caller's
  problem.
- **Zero unnecessary copies.** No memcpy or memmove unless unavoidable.
  Design the API and buffer layout to allow in-place and zero-copy paths.
- **Memory-conscious struct design.** Use packed structs, unions, and bit
  fields intentionally. Every byte of struct size is a choice. Profile
  struct layouts. Don't waste cache lines.
- **SIMD where it matters.** Zig exposes SIMD via `@Vector`. AES-GCM, ChaCha,
  SHA-256, and record scanning are all candidates. Measure first, then apply.
- **Leverage libcrypto.** Don't write our own crypto (yet). Use OpenSSL/libcrypto
  for AEAD (AES-GCM, ChaCha20-Poly1305), ECDH (X25519, P-256), HKDF, and
  signature verification. We own the TLS framing and state machine.
- **Linux and macOS only.** No Windows. Design for real targets.
- **Higher-level wrappers are separate.** If someone wants a `net.Stream`
  adapter or an async wrapper, that's a thin layer on top, not baked in.
- **Every line of code is a cost.** Write less code. Each line must justify its
  existence. Prefer deletion over addition. Prefer clarity over cleverness, but
  never at the cost of correctness or performance.
- **Profile, disassemble, benchmark everything non-trivial.** Intuitions about
  performance are wrong. Check the asm. Measure wall time. Use perf/Instruments.

---

## What We Are Not Doing (Yet)

- Our own AES, GCM, SHA, X25519 implementations. libcrypto handles that.
- TLS 1.2 or earlier.
- DTLS.
- 0-RTT (initially — nice to add later, but adds replay complexity).
- Client certificates (initially — server auth only for v1).
- Custom DHE groups (only X25519 and P-256 to start).

---

## Prior Art & References

### BearSSL

The spiritual predecessor. Key ideas we're stealing:

- **Zero dynamic allocation.** The context structs are fixed-size; caller
  allocates them wherever (stack, static, heap — doesn't matter).
- **No I/O.** The engine exposes four channels via buf()/ack() pairs:
  - `sendapp` — write plaintext into the engine
  - `recvapp` — read plaintext out of the engine
  - `sendrec` — get TLS records to send over the wire
  - `recvrec` — feed raw bytes received from the wire into the engine
- **State machine.** `br_ssl_engine_current_state()` returns a bitmask of
  which channels are currently open. The caller drives the loop.

Source: https://bearssl.org/api1.html  
TLS 1.3 status (BearSSL doesn't support it, ironically): https://bearssl.org/tls13.html

### rustls

Rust's premier TLS library. No I/O, but does allocate.

- `read_tls(reader)` / `write_tls(writer)` for the record layer
- `process_new_packets()` advances the state machine after feeding data
- Plaintext is accessed via `reader()` / `writer()` interfaces
- The "encrypted pipe" model is a clean mental model even if the API is more
  opaque than BearSSL's

We want BearSSL's allocation discipline with a more Zig-natural API than
BearSSL's C.

Source: https://docs.rs/rustls/latest/rustls/  
Architecture: https://github.com/rustls/rustls/blob/main/rustls/src/lib.rs

### Go crypto/tls

The record layer and halfConn design is worth studying. Key observations:

- `halfConn` tracks one direction (in or out): version, cipher, seq number,
  traffic secret. Clean separation of encrypt/decrypt paths.
- `decrypt()` can return a plaintext that overlaps the input (in-place when
  possible).
- `writeRecordLocked()` fragments large payloads across multiple records
  automatically.
- For TLS 1.3, the version field in the record header is frozen at 0x0303
  (TLS 1.2) — the actual version is in the `supported_versions` extension.
- Dynamic record sizing to trade off latency vs. throughput (disabled by
  default in our case — caller decides).

Source: https://github.com/golang/go/blob/master/src/crypto/tls/conn.go  
TLS 1.3 server handshake: https://github.com/golang/go/blob/master/src/crypto/tls/handshake_server_tls13.go

### Sans-IO Pattern

The broader pattern of separating protocol logic from I/O. Python community
coined the term. Rust's webrtc-rs/sansio formalizes it as a trait.

The core insight: a protocol implementation is a state machine that maps
`(state, input_bytes) -> (new_state, output_bytes)`. I/O is not the
protocol's job.

---

## RFC References

All stored locally in `docs/research/rfcs/`.

| File | RFC | Content |
|------|-----|---------|
| `rfc8446-tls13.txt` | RFC 8446 | TLS 1.3 — the whole thing |
| `rfc5869-hkdf.txt` | RFC 5869 | HKDF (HMAC-based Key Derivation) |
| `rfc8439-chacha20-poly1305.txt` | RFC 8439 | ChaCha20-Poly1305 AEAD |
| `rfc7748-x25519-x448.txt` | RFC 7748 | X25519 and X448 key exchange |
| `rfc8032-eddsa.txt` | RFC 8032 | EdDSA (Ed25519) |

Key sections in RFC 8446 to bookmark:

- §2 — Protocol overview, handshake flow diagrams
- §4.1 — Key exchange messages (ClientHello, ServerHello)
- §4.2 — Extensions (key_share, supported_versions, signature_algorithms, etc.)
- §4.4 — Authentication messages (Certificate, CertificateVerify, Finished)
- §5 — **Record protocol** — this is the first thing we build
- §5.1 — Record layer wire format
- §5.2 — Record payload protection (TLSInnerPlaintext, AEAD)
- §5.3 — Per-record nonce construction
- §5.4 — Record padding
- §5.5 — Key usage limits (when to do KeyUpdate)
- §7 — **Cryptographic computations** — HKDF key schedule
- §7.1 — Key schedule (the HKDF ladder)
- §7.3 — Traffic key calculation
- §7.4 — (EC)DHE shared secret calculation
- Appendix A — State machine (client and server)
- Appendix B — Wire format reference (data structures)
- Appendix C — Implementation pitfalls

---

## Architecture

### The Mental Model

```
         Network bytes (TLS records)
               |         ^
         feed  |         | drain
               v         |
         +-----+---------+-----+
         |                     |
         |    Engine (ztls)    |
         |    state machine    |
         |                     |
         +-----+---------+-----+
               |         ^
        read   |         | write
               v         |
         Plaintext application data
```

The engine has no threads, no callbacks, no I/O. It's a struct you poke.

### Layers We'll Build

**Layer 0 — Record framing** (implement first)
- Parse `TLSPlaintext` headers (5 bytes: type + version + length)
- Emit record headers
- No crypto yet — just wire format parsing

**Layer 1 — Record protection** (AEAD encrypt/decrypt)
- `TLSCiphertext` <-> `TLSInnerPlaintext` via AEAD
- Nonce construction (XOR of IV with sequence number, §5.3)
- Sequence number tracking per direction
- Padding stripping (scan from end for non-zero byte to find real ContentType)
- Key usage limit tracking (§5.5 — 2^24.5 records per key for AES-GCM)

**Layer 2 — Handshake state machine**
- Client path: ClientHello → (HelloRetryRequest?) → ServerHello →
  EncryptedExtensions → Certificate → CertificateVerify → Finished →
  (client Finished) → Application Data
- Server path: same in reverse
- Transcript hash maintained across handshake messages (§4.4.1)
- Key schedule: derive handshake secrets, then application secrets (§7.1)

**Layer 3 — Application data**
- Encrypt/decrypt application data records using derived traffic keys
- KeyUpdate handling (§4.6.3)

**Layer 4 (optional, separate package) — I/O adapters**
- Wraps engine with `std.net.Stream` or posix fd
- Owns the read/write buffers
- Drives the state machine loop

### Engine API Shape (Zig sketch)

The core insight from BearSSL: the engine contains no buffers beyond its
internal state. Callers pass slices everywhere. The question is whether we
follow BearSSL's buf()/ack() pattern exactly, or do something more Zig-natural.

BearSSL's pattern works great in C because you need pointer stability. In Zig,
we can be more slice-oriented. Rough sketch:

```zig
pub const Engine = struct {
    // Internal state — all fixed-size, no heap
    state: HandshakeState,
    role: Role,  // .client or .server

    // Crypto state (libcrypto handles via EVP_AEAD_CTX etc.)
    // These are fixed-size C structs embedded directly
    read_key: AeadCtx,
    write_key: AeadCtx,
    read_seq: u64,
    write_seq: u64,

    // HKDF/transcript state
    transcript: TranscriptHash,
    // ... key schedule secrets ...

    pub const Role = enum { client, server };

    pub const Status = packed struct {
        /// Engine has TLS records ready to be sent over the wire
        send_records: bool,
        /// Engine can accept TLS records from the wire
        recv_records: bool,
        /// Engine can accept plaintext to encrypt and send
        send_data: bool,
        /// Engine has plaintext available for the application to read
        recv_data: bool,
        /// Handshake is complete
        connected: bool,
        /// Fatal error — engine is dead
        closed: bool,
    };

    /// Initialize a client engine. No allocation. Config is caller-owned.
    pub fn initClient(config: *const ClientConfig) Engine;
    pub fn initServer(config: *const ServerConfig) Engine;

    /// What does the engine need right now?
    pub fn status(self: *const Engine) Status;

    /// Feed raw bytes from the network into the engine.
    /// Returns how many bytes were consumed.
    /// Call status() after to see what changed.
    pub fn feedRecords(self: *Engine, data: []const u8) Error!usize;

    /// Copy outgoing TLS records into buf. Returns bytes written.
    /// Call repeatedly until send_records is false.
    pub fn drainRecords(self: *Engine, buf: []u8) Error!usize;

    /// Write plaintext application data. Engine will encrypt it into records.
    /// Only valid when status().send_data is true (i.e., handshake complete).
    pub fn write(self: *Engine, plaintext: []const u8) Error!usize;

    /// Read decrypted application data into buf.
    /// Only valid when status().recv_data is true.
    pub fn read(self: *Engine, buf: []u8) Error!usize;

    /// Initiate close (sends close_notify alert).
    pub fn close(self: *Engine) void;
};
```

This is a sketch, not a commitment. The internal buffer question needs more
thought — specifically, whether the engine needs internal staging buffers for
incomplete records or if the caller is expected to handle that.

BearSSL's answer: the engine owns two internal buffers (input and output),
which the caller allocates and hands in at init time. That's probably right for
us too — you can't parse a record without buffering it somewhere, and making
the caller responsible for that state is messy.

So: caller allocates the buffers (fixed-size arrays, probably on stack or as
part of a connection struct), passes them to `init`. Engine holds slices into
them. No heap.

### What libcrypto Gives Us

Via `<openssl/evp.h>` and friends:

- `EVP_AEAD_CTX` — AES-128-GCM, AES-256-GCM, ChaCha20-Poly1305
- `EVP_PKEY_CTX` + X25519 / P-256 — ECDH key generation and shared secret
- `HMAC` + `EVP_MD` — for HKDF (or `EVP_KDF` directly in newer OpenSSL)
- `EVP_DigestSign` / `EVP_DigestVerify` — signature verify for certs
- `X509` parsing — for certificate chain validation

The Zig `std.crypto` alternative: Zig 0.14+ has X25519, AES-GCM,
ChaCha20-Poly1305, and HKDF in stdlib. That's actually a viable path to drop
libcrypto entirely for the symmetric/KEM stuff. RSA signature verification is
the hard part that would keep us on libcrypto (or we punt on RSA certs and
only support ECDSA initially).

Worth deciding: do we start with libcrypto bindings and potentially migrate to
zig stdlib crypto, or start with zig stdlib and add libcrypto as a fallback?
The BearSSL philosophy is to own the crypto too, but that's a lot more scope.

---

## Build Order

1. Record layer parser — `TLSPlaintext` parse/emit, no crypto, unit tests
2. AEAD wrapper — thin Zig wrapper around libcrypto EVP_AEAD_CTX (or zig
   stdlib crypto.aead)
3. Nonce construction and sequence number tracking
4. Encrypted record encode/decode (Layer 1 complete)
5. HKDF key schedule — derive handshake and application secrets
6. ClientHello construction
7. ServerHello parsing + key_share extraction
8. EncryptedExtensions, Certificate, CertificateVerify parsing
9. Finished message verify/send
10. Application data read/write
11. KeyUpdate
12. Integration test against a real server (e.g., curl's localhost test server)

Start with a test that talks to itself (client + server in the same process,
piped together) before touching the network.

---

## Testing Strategy

### Philosophy

Tests cite the RFC section they're validating. No test without a spec reference.
Every error path is tested. Fuzzing is not optional.

### Unit Tests

- Record layer: parse/emit round-trips, length edge cases, truncated input,
  oversized records. Cite §5.1.
- AEAD: encrypt/decrypt, bad auth tag, nonce reuse detection. Use Wycheproof
  test vectors (JSON) for AES-GCM, ChaCha20-Poly1305, HKDF, X25519.
- Key schedule: derive expected secrets against known-good vectors from RFC 8446
  Appendix B test vectors and from tlsfuzzer's known-answer tests.
- Handshake parsing: valid and malformed messages for every handshake type.

### Integration Tests

- Client + server in the same process, connected via an in-memory pipe.
  Full handshake, application data exchange, clean close.
- Client talking to `openssl s_server`. Server accepting from `openssl s_client`.
  These are the ground truth implementations.
- Negative tests: wrong Finished MAC, replayed nonce, bad cert signature.
  Engine must produce the correct alert.

### Conformance / Industry Test Suites

- **tlsfuzzer** (https://github.com/tlsfuzzer/tlsfuzzer) — RFC conformance and
  protocol fuzzer. Runs Python scripts against a live server. Comprehensive
  TLS 1.3 coverage. Run via `scripts/test-tls13-*.py`.
- **TLS-Anvil** (https://github.com/tls-attacker/TLS-Anvil) — ~408 RFC-based
  client and server tests for TLS 1.3. Java/JUnit based. More structured than
  tlsfuzzer.
- **Wycheproof** (https://github.com/C2SP/wycheproof) — test vectors for
  every crypto primitive we use (AES-GCM, ChaCha20-Poly1305, HKDF, X25519,
  ECDH, ECDSA). These are JSON files; write a test harness to consume them.
- **bettertls** (https://github.com/Netflix/bettertls) — name constraints and
  path-building correctness for certificate validation.

### Benchmarks

- Benchmark record encode and decode throughput (bytes/sec).
- Benchmark full handshake round-trips.
- Compare against OpenSSL and BearSSL at equivalent cipher suite.
- Check generated asm for hot paths (record AEAD, nonce XOR, header parse).
  Use `zig build -Doptimize=ReleaseFast` and inspect via `objdump -d`.

---

## Open Questions

1. **libcrypto vs zig stdlib crypto**: Zig stdlib has enough for symmetric
   crypto. RSA cert verification is the blocker for going fully libcrypto-free.
   Could support ECDSA-only initially and stay stdlib.

2. **Internal buffer ownership**: Does the engine own its staging buffers
   (caller allocates, engine holds slice), or does the caller pass a fresh
   buffer on every call? BearSSL does the former. Probably right.

3. **0-RTT scope**: Skip entirely for now. Security properties are subtle and
   it adds complexity to the state machine. Add later.

4. **Session tickets / PSK resumption**: Useful for performance but not needed
   for a correct implementation. Phase 2.

5. **Certificate validation**: Full X.509 chain validation is a lot of code.
   Options: (a) call out to libcrypto for this, (b) implement minimal validation
   (BearSSL's approach), (c) provide a callback and let the caller decide.
   Option (c) is most flexible and keeps scope tight. Mandatory for security
   but not for the protocol machinery itself.

6. **SNI and ALPN**: These are just extensions in ClientHello/EncryptedExtensions.
   Should be supported from the start since basically everyone needs them.
