# ztls — Design & Research Notes

TLS 1.3 framing library in Zig. Sans-I/O. Caller-owned TLS buffers. Production
crypto is delegated to the libcrypto family: OpenSSL/libcrypto first, AWS-LC as
a first-class design target, and BoringSSL later if its API surface earns it.
Everything else is ours.

---

## Goals

- **TLS 1.3 only** (RFC 8446). No 1.2 fallback, no negotiation theater.
- **Correctness and performance are co-equal first-class goals.** Not
  "correctness first, optimize later" — both matter from the start. A correct
  slow implementation isn't a milestone, it's a dead end.
- **No ztls-owned allocations in the TLS engine.** Caller owns all TLS buffers.
  The engine holds no heap state and never performs transport I/O. Production
  libcrypto-family backends may link libc and may perform backend/provider-owned
  allocation during setup or primitive initialization; those allocations must be
  explicit in the backend contract and must not leak into ztls buffer ownership.
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
- **Use libcrypto-family for provider-sensitive production primitives.** Do not
  implement our own AES-GCM, ChaCha20-Poly1305, X25519/P-256, post-quantum KEX,
  or signature primitives. OpenSSL/libcrypto is the first concrete backend
  target; AWS-LC remains first-class in the architecture rather than an
  accidental drop-in. stdlib hashing/HMAC/HKDF and utility crypto helpers remain
  acceptable where they do not create a competing AEAD/KEX/signature backend.
  ztls owns TLS framing, transcripts, alerts, record sequencing, and
  caller-buffer discipline.
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

- Our own AES, GCM, ChaCha20-Poly1305, X25519/P-256, post-quantum KEX, or
  signature primitive implementations. The production path for those is
  libcrypto-family/provider-backed primitives. stdlib hashing/HMAC/HKDF and
  small constant-time/zeroing/random helpers are not excluded by this rule.
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

### Consumer-facing API shape


```zig
// High-level client connection API: caller owns buffers and transport.
var hs: ztls.ClientHandshake = .init(keypair);
var reassembly: [32 * 1024]u8 = undefined;
hs.useHandshakeBuffer(&reassembly); // optional; supports handshake messages spanning records
hs.offerAlpn(&.{ "h2", "http/1.1" }); // optional; copied into ClientHello

const client_hello_wire = try hs.start(&out, random, "example.com");
// write client_hello_wire to the transport, then:
hs.completeWrite();

while (!hs.isConnected()) {
    const ev = try hs.handleRecord(record, &out);
    if (ev == .write) {
        // write ev.write to the transport
        hs.completeWrite();
    }
}

const selected_alpn = hs.selectedAlpnProtocol();
const app_wire = try hs.sendApplicationData(plaintext, &out);
hs.completeWrite();

// Low-level record layer remains available for callers that need it.
var rl = hkdf.makeRecordLayer(.{ .aes128_gcm = key }, traffic_secret);
const wire = try rl.encrypt(.application_data, plaintext, &out);
const dec = try rl.decrypt(wire);
```

The state machine owns the transcript, handshake key schedule, post-handshake
KeyUpdate receive path, optional caller-backed handshake reassembly, and
pending-write invariant. It still does no allocation and no I/O; callers provide
all storage and decide how bytes move.

### Crypto backends

Production crypto is a libcrypto-family backend. OpenSSL/libcrypto is the first
implementation target because the project already has OpenSSL interop and EVP
benchmark coverage. AWS-LC remains a first-class architecture target, not an
afterthought hidden behind an accidental OpenSSL-only design. BoringSSL may be a
later backend if its API differences are worth supporting directly.

There is no parallel `std.crypto` AEAD/KEX/signature backend. This is new
pre-alpha software, so there is no compatibility burden that justifies
preserving a second product path for provider-sensitive primitives. That does
not make every `std.crypto` use implementation debt: stdlib SHA-256/SHA-384,
HMAC/HKDF, timing-safe comparison, secure zeroing, and randomness are acceptable
where they keep the code smaller and do not create backend policy or algorithm
agility divergence.

This changes the memory contract. ztls-owned code still does not allocate, does
not import `std.heap`, does not own TLS buffers, and does no I/O. A production
libcrypto-family backend may link libc and may perform backend/provider-owned
allocation during initialization, context setup, provider fetch, or primitive
operation depending on the selected library. That behavior must be called out
honestly and kept behind the crypto backend boundary. Do not describe OpenSSL
EVP/provider paths as no-allocation.

The Sans-I/O boundary is preserved. The backend supplies provider-sensitive
primitive operations: AEAD, key exchange, signature verification/signing, and
later provider-backed PQ/hybrid KEX and signatures. Hashing/HMAC/HKDF may stay
on Zig stdlib unless measurement or provider-policy requirements justify a
facade. The backend does not own sockets, BIOs, trust-store loading,
certificate policy I/O, application buffers, or handshake state-machine
control.

Backend design implications:

- keep ztls key/tag/suite and record APIs stable where possible;
- hide provider-specific details behind ztls-owned crypto facade modules;
- avoid libssl in core; use primitive libcrypto-family APIs for AEAD, KEX, and
  signatures;
- accept and document backend-owned libc/provider allocation for production
  backends instead of pretending OpenSSL-compatible EVP is allocation-free;
- keep OpenSSL interop and EVP/libssl benchmark rows as compatibility and
  performance floors;
- route post-quantum evolution through provider-backed KEX/signature mechanisms
  where the backend supports them, while ztls handles TLS negotiation and
  transcript semantics.

X.509 validation uses caller-owned policy: `Policy.bundle` anchors the parsed
chain to a trust root, `Policy.now_sec` checks validity periods, and
`Policy.host_name` verifies the leaf SAN/CN. Loading OS trust stores remains a
caller/wrapper responsibility because ztls library code does no I/O.

---

## Testing Strategy

### Philosophy

Tests cite the RFC section they're validating. No test without a spec reference.
Every error path is tested. Fuzzing is not optional.

### Unit Tests

- Record layer: parse/emit round-trips, length edge cases, truncated input,
  oversized records. Cite §5.1.
- AEAD: encrypt/decrypt, bad auth tag, nonce reuse detection. Wycheproof
  boundary vectors validate ztls's libcrypto call shape: AAD, nonce, tag, and
  authentication-failure propagation.
- Key schedule: derive expected secrets against RFC 8448 where available and
  independent vectors where RFC 8448 has no trace (e.g. SHA-384 suite support).
- Handshake parsing: valid and malformed messages for every handshake type.
- Fuzz targets: parser/state-machine byte surfaces (`server_hello.parse`,
  Certificate parsing, HandshakeReader, decrypted processFlight) must reject
  arbitrary bytes without panics. Run with `zig build test --fuzz --webui=127.0.0.1:<port>` on Linux.

### Integration Tests

- Client + server in the same process, connected via an in-memory pipe.
  Full handshake, application data exchange, clean close.
- Client talking to `openssl s_server`. Server accepting from `openssl s_client`.
  These are the ground truth implementations.
- Negative tests: wrong Finished MAC, replayed nonce, bad cert signature.
  Engine must produce the correct alert.

### Conformance / Industry Test Suites

- **tlsfuzzer** (https://github.com/tlsfuzzer/tlsfuzzer) — RFC conformance and
  protocol fuzzer. Runs Python scripts against a live server. The active TLS 1.3
  suite lives in `conformance/` and runs from the root with
  `just conformance/tlsfuzzer`.
- **TLS-Anvil** (https://github.com/tls-attacker/TLS-Anvil) — ~408 RFC-based
  client and server tests for TLS 1.3. Java/JUnit based. Useful for broad future
  matrix coverage, especially once ztls implements HRR, PSK/resumption, 0-RTT,
  or client auth.
- **Wycheproof** (https://github.com/C2SP/wycheproof) — integration vectors at
  the libcrypto boundary (AEAD tag/AAD/nonce handling, X25519 identity-element
  rejection, ECDSA DER verification), not proof that ztls implements primitive
  crypto. Boundary smoke vectors run with `zig build test`.
- **bettertls** (https://github.com/Netflix/bettertls) — name constraints and
  path-building correctness for certificate validation. A bettertls inventory is maintained in
  `docs/research/bettertls.md`.

### Benchmarks

See `docs/research/PERFORMANCE.md` for the benchmark methodology and prior-art notes.

## Open Questions

1. ~~**libcrypto vs zig stdlib crypto**~~ — resolved: production crypto moves to
   the libcrypto family. OpenSSL/libcrypto is the first concrete target; AWS-LC
   remains first-class in the architecture. Do not keep `std.crypto` as an
   exposed backend choice.

2. **Internal buffer ownership**: Does the engine own its staging buffers
   (caller allocates, engine holds slice), or does the caller pass a fresh
   buffer on every call? BearSSL does the former. Probably right.

3. **0-RTT scope**: Skip entirely for now. Security properties are subtle and
   it adds complexity to the state machine. Add later.

4. **Session tickets / PSK resumption**: Useful for performance but not needed
   for a correct implementation. Phase 2.

5. **Certificate validation**: Full X.509 path validation remains caller-policy
   driven. libcrypto-family backends may provide signature primitives and future
   provider-backed signature algorithms, but ztls/wrappers still own trust bundle
   provisioning, hostname policy, and any OS trust-store I/O.

6. **SNI and ALPN shape**: SNI should seed hostname verification by default.
   ALPN should use caller-owned offered protocol slices, validate the server's
   EncryptedExtensions selection against the offered list, and copy the selected
   protocol into handshake state so the result does not borrow the decrypted
   record buffer.
