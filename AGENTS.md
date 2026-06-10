# AGENTS.md

This is ztls: a Sans-I/O TLS 1.3 library in Zig. No transport I/O. Caller-owned buffers.
Read `docs/research/DESIGN.md` before writing any code.

---

## What This Is

A pure TLS 1.3 state machine. The engine consumes and produces byte slices.
Core library code does not open sockets. ztls-owned protocol/state-machine code
must not allocate. Higher-level wrappers that add I/O belong outside the core
engine; repo examples and test shims may use sockets to exercise the Sans-I/O
API.

Target platforms: Linux and macOS. No Windows support, no portability tax.

---

## Non-Negotiable Principles

**Correctness and performance are co-equal.** Not "make it work, then make it
fast." Both are first-class from the start. A working slow implementation is
not an acceptable intermediate state — correctness decisions shape performance
decisions and vice versa.

**No ztls-owned allocations in the TLS engine.** If you find yourself reaching
for an allocator in protocol/framing code, stop. Caller owns all TLS buffers.
The engine holds no heap state. Production crypto backends may perform
documented backend-owned libc/libcrypto allocations; do not hide those behind a
fake no-allocation claim.

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

## Dev Environment

The Nix flake is the source of truth for development tooling. If a recipe,
script, test, or conformance harness needs a command, add it to `flake.nix`;
don't suggest installing it globally and don't make scripts skip because a
devshell dependency is absent. Generated or downloaded artifacts may be recipe
dependencies, but tools should be assumed present in the devshell.

When already inside the devshell, run commands directly. Don't wrap normal
checks in `nix develop --command` unless there is evidence the current shell is
missing the updated environment.

---

## Project State and Continuity

**Read `PRODUCTION_READINESS.md` before starting any task.** It is the single
source of truth for what is done, what "done" means, and what is still unproven.
Status lives there and nowhere else. Every other document describes mechanism;
none of them asserts whether something is finished. If you catch another doc
claiming done/not-done, that line is a bug — delete it and point to the spine.

**Write state back in the same change.** When your work changes the evidence
behind a readiness claim, update `PRODUCTION_READINESS.md` in the same commit. A
claim whose evidence moved but whose status didn't is a lie. Closing a gap means
updating the dashboard, not just landing the code.

**Search open GitHub issues before filing one; extend the existing issue, don't
fork a parallel one. Two issues for one feature is the failure that produced the
duplicate-record mess — do not reproduce it.**

**Committed files cite GitHub issues (#NN), never pi todos. Every cited issue
must resolve via `gh issue view`, and be open if cited as active work. pi todos
are ephemeral execution scratch — break an issue into todos to delegate to
subagents; never reference a pi todo from a committed artifact.**

**"Closed" means proven, not "a slice landed."** If you did partial work, the
todo and the readiness doc say partial. Never close a todo or upgrade a status on
the strength of a commit that only moves toward the goal. Honest partial beats
false done.

**Respect workspace ownership.** The root is the ztls library workspace; domain
subprojects such as `conformance/` own their local build/test/fmt/lint workflows
and should be usable from inside that directory. Root just recipes may delegate
to subprojects, but don't smear subproject details back into the root.

---

## Code Style

- Prefer `ast-grep` for structural searches and mechanical refactors. Use plain
  text tools for literal text, but reach for syntax-aware matching before ad hoc
  regex scripts when changing code.
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

Protocol tests cite the spec section they validate. Utility tests that are not
direct protocol assertions should name the invariant or behavior clearly. Error
path tests are not optional.

**Unit tests** usually live in the same file as the code they test (`test` blocks).

**Integration tests** live in `src/test/` and examples. The harnesses connect a
ztls client to a ztls server in memory and exercise both directions against
`openssl s_server` / `openssl s_client` as ground-truth peers.

**Conformance tests** live under `conformance/` as a discrete subproject with
its own `build.zig`, `justfile`, Python environment, and harness code. The root
workspace delegates to `just conformance/ci`; when working on conformance, `cd
conformance` and use its local `just fmt`, `just lint`, and suite recipes.

---

## Crypto

Production crypto comes from the libcrypto family. OpenSSL/libcrypto is the
first implementation target because it is already in the dev shell and interop
harnesses; AWS-LC must remain a first-class design target, with BoringSSL
possible later behind its own backend if the API surface is worth it.

Do not add or preserve a `std.crypto` backend as a parallel product path. This
is pre-alpha software; there is no compatibility reason to keep transitional
backend scaffolding once the production direction is chosen.

The strict no-allocation invariant applies to ztls-owned framing, state machine,
record buffers, and caller-visible TLS I/O. A libcrypto-family production build
may link libc and may execute backend/provider-owned allocations during setup or
primitive initialization. Keep ztls itself allocator-free: no `std.heap` in
`src/`, no malloc/free owned by ztls, and all TLS input/output buffers remain
caller-owned.

Do not use libssl in core. Do not implement your own primitive crypto. Post-
quantum support should come through provider-backed key exchange and signature
mechanisms where the selected libcrypto-family backend supports them.

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
- Don't assert project status anywhere except `PRODUCTION_READINESS.md`.
- Don't create a todo without first searching for an existing one on the same
  feature. Extend, don't fork.
- Don't close a todo or raise a readiness status on partial work. Say partial.
- Don't invent a new top-level home for a file when the taxonomy already defines
  one. Raise it instead of improvising.
