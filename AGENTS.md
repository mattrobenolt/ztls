# AGENTS.md

This is ztls: a TLS 1.3 framing library in Zig. No allocations. No I/O.
Read `docs/research/DESIGN.md` before writing any code.

---

## What This Is

A pure TLS 1.3 state machine. The engine consumes and produces byte slices.
It does not open sockets. It does not call malloc. Higher-level wrappers that
add I/O belong in a separate package.

Target platforms: Linux and macOS. No Windows support, no portability tax.

---

## Non-Negotiable Principles

**Correctness and performance are co-equal.** Not "make it work, then make it
fast." Both are first-class from the start. A working slow implementation is
not an acceptable intermediate state — correctness decisions shape performance
decisions and vice versa.

**No allocations in library code.** If you find yourself reaching for an
allocator, stop. Caller owns all memory. Buffers are passed as slices. The
engine holds no heap state. If a data structure doesn't fit in a fixed-size
stack or caller-provided buffer, redesign it.

**No unnecessary copies.** Avoid memcpy and memmove unless provably
unavoidable. Design buffer layouts to allow in-place and zero-copy paths. If
you add a copy, document why it can't be avoided.

**Memory-conscious struct layout.** Every byte of struct size is a deliberate
choice. Use packed structs, union types, and bit fields where they reduce size
without sacrificing correctness. Profile struct layouts and cache line
behavior on hot paths. Don't leave padding on the table.

**SIMD where it matters.** Zig exposes SIMD via `@Vector`. Hot paths — record
header scanning, AES-GCM, ChaCha, SHA — are candidates. Measure before
applying. Check the generated asm to confirm the compiler did what you think.

**Every line of code is a cost.** Less code is better code. Each line must
justify its existence. If you can delete something and the behavior is
unchanged, delete it. Prefer reading over writing. A 10-line function that's
obviously correct beats a 30-line one that might be.

**Profile, disassemble, benchmark before claiming something is fast.** Use
`perf` on Linux, `Instruments` on macOS. Inspect asm with `objdump -d` or
`llvm-objdump`. Build with `-Doptimize=ReleaseFast` for benchmarks. Gut
feelings about performance are wrong until measured.

---

## Code Style

- Zig only for library code. No C source files except generated bindings.
- Use `std.debug.assert` liberally for invariants, never for input validation.
- Error sets are explicit. No `anyerror` in public API functions.
- Prefer `comptime` for configuration that is fixed at compile time.
- No `std.heap` imports in `src/`. If a file needs an allocator, it's in the
  wrong place.
- Keep functions short. If a function doesn't fit on a screen, it probably does
  too much.
- Format with `zig fmt`. Non-negotiable.

---

## Tests

Every test cites the RFC section it validates. Format:

```zig
// RFC 8446 §5.3 — per-record nonce is XOR of IV with big-endian sequence number
test "nonce construction" { ... }
```

No test without a spec reference. Error path tests are not optional.

**Unit tests** live in the same file as the code they test (`test` blocks).

**Integration tests** live in `src/test/`. The integration test harness connects
a ztls client to a ztls server via an in-memory pipe, and also connects to
`openssl s_server` / `openssl s_client` as ground-truth peers.

**Conformance tests** — see `docs/research/DESIGN.md` § Testing Strategy.
tlsfuzzer and Wycheproof test vectors are the primary external suites. When a
test suite covers something we implement, we run it. No exceptions.

---

## Crypto

Default backend is `std.crypto` — zero dependencies, pure Zig.
A `libcrypto` backend will be offered as an opt-in build flag for
deployments that want OpenSSL's hardware-accelerated primitives.
Both backends present the same API; the flag is a comptime switch.

Do not reach for libcrypto by default. Do not implement your own crypto.

See `docs/research/DESIGN.md` for full backend rationale.

---

## RFCs

Full RFC text is in `docs/research/rfcs/`. Read them. When in doubt, read the
RFC. When still in doubt, read the RFC again.

Primary reference: `rfc8446-tls13.txt` (RFC 8446).

Key sections for implementation:
- §5 — Record protocol (start here)
- §5.3 — Per-record nonce
- §7.1 — Key schedule
- §4.4.4 — Finished MAC
- Appendix A — State machine
- Appendix B — Wire format reference

---

## API Stability

We have no public API contract yet. This is pre-alpha implementation work.
Do not hesitate to change function signatures, rename types, restructure
modules, or rethink abstractions. The cost of changing things now is zero.
The cost of not changing them later is high. Move fast and don't apologize
for breaking things that aren't contracted.

---

## Zig Style

Type annotations go on the left side of the declaration. The right side uses
`.init()` or `.{}` — never repeat the type name on the right.

```zig
// correct
const iv: Iv = .init(@splat(0));
const key: Aes128GcmKey = .init(@splat(0xab));
var tag: Tag = undefined;

// wrong
const iv = Iv.init(@splat(0));
const key = Aes128GcmKey.init(@splat(0xab));
```

This applies to all typed values — newtypes, structs, enums. Consistent with
how Zig struct literals work: `.{}`, `.init()`, `.{ .field = val }` are all
resolved from the declared type on the left.

---

## What Not To Do

- Don't add TLS 1.2 support. The scope is TLS 1.3. Period.
- Don't add Windows-specific code paths.
- Don't reach for an allocator to "simplify" something. Simplify the design.
- Don't write a test without citing a spec section.
- Don't commit benchmarks that haven't been run. Benchmark results in comments
  should include the machine, build flags, and date.
- Don't paper over a performance problem with a comment like "good enough for
  now." File it, measure it, and fix it or explicitly defer it with a note on
  what's blocking.
- Don't use `std.log` or print-debugging in library code. Use test assertions.
