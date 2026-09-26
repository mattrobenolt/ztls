# Matt's Zig style — the rules his repos enforce

Distilled from exosphere-zig's `ZIG_STYLE.md`, the `matt-nits` checklist, and its `AGENTS.md`. These are taste rules the model cannot guess; apply them when writing or reviewing any Zig in Matt's projects. Mechanical enough to check a diff against.

## Working rules (from AGENTS.md)

- When corrected or interrupted: stop, acknowledge, follow the new direction. Do not continue the old approach or argue.
- Verify flags/options/APIs exist in `build.zig`, `build.zig.zon`, or source before suggesting them. `zigdoc` first for std and deps.
- Prefer `just` recipes over raw commands; keep a Justfile.
- Prefer `ast-grep`/`sg` for syntax-aware searches when code shape matters.
- Linux only in these projects; no OS conditionals or capability checks.
- Zig imports are lazy — add freely; circular imports are not a concern.
- Before calling work done: report the commands run and their results.
- TDD-ish for bug fixes: failing test first, fix, show passing.

## Expression shape

- Type on the left, anonymous literal on the right: `var x: Foo = .init(...)`, `const foo: Type = .{ .field = value };`. Never repeat the type on both sides; drop the annotation when the return type already pins it.
- Control flow as expressions: `return switch (...)`, `return if (...)` — one return, not returns in every branch. Collapse `if (cond) return A; return B;` (but never into a double-`return`).
- `try` and centralized `catch`; avoid scattered panics. Drop `try` on infallible positions.
- `@branchHint(.cold)` on rare error returns (seq overflow and similar).
- Soft limit 70 lines per function. Centralize control flow in parents; push pure computation to helpers.
- Multi-line struct literals when the one-liner exceeds ~80 chars (ziglint Z024 max 120).
- Alias a subexpression used 2+ times in a function.

## File structure

1. `//!` module doc (never `///` at file top), 2. imports with short aliases, 3. `const X = @This();` named for the type, 4. scoped logging.
- Hoist `const testing = std.testing;` at top; tests inline in the same file.
- Method order: `init` → `deinit` → public API → private helpers.
- Allocator is the FIRST argument (after comptime params).
- `const` → `pub const` when a type/value leaks across modules.
- Free helper functions taking an enum → methods on the enum with `comptime self`.
- Comments explain WHY, never WHAT. Document non-obvious thresholds and protocol details.
- Magic numbers with semantic meaning → named const or enum tag (loop counters and spec-inline protocol bytes are fine bare). Bare `[N]u8`/slices with domain meaning → named type alias.

## File-as-a-struct — the file IS the type

A type with state and methods is its own file, named for the type: `Server.zig` contains `const Server = @This();`, and consumers import the file directly as the type — no inner `pub const Server = struct { ... }` wrapper:

```zig
// src/Server.zig
const Server = @This();

pub const Config = struct { ... };   // decls are type decls
const Phase = enum { ... };

// fields at file scope
config: Config,
ring: Ring,

pub fn init(gpa: Allocator, config: Config) !Server {
    ...
    return .{ ... };                  // anonymous literal via @This()
}
pub fn deinit(self: *Server) void { ... }
fn dispatch(self: *Server, cqe: linux.io_uring_cqe) !void { ... }

// consumer:
const Server = @import("Server.zig");
var server: Server = try .init(gpa, .{});
```

This is ztls's `ServerHandshake.zig` / `RecordBuffer.zig` shape. Consequences: every file-scope decl is a member; tests inline at the bottom exercise the real type; one type per stateful file, helper types nest inside it. A file of standalone functions (no state) stays lowercase (`sys.zig`, `mem.zig`) — and only earns existence when it has real content, not one function.

## Import style — alias densely, never qualify in bodies

The import block is a table of contents; bodies stay short. From ztls/z53/exosphere:

```zig
const std = @import("std");
const assert = std.debug.assert;
const mem = std.mem;
const math = std.math;
const testing = std.testing;   // files with tests
const Io = std.Io;             // when Io is used — alias the namespace itself
const net = Io.net;
const Allocator = std.mem.Allocator;
const print = std.debug.print; // mains and small tools
const process = std.process;   // mains
const linux = std.os.linux;    // raw-layer files
const Ring = linux.IoUring;

const wire = @import("wire.zig");                 // local module, short lowercase name
const OutBuffer = frame.OutBuffer;                // frequently-used types lifted
const HandshakeReader = handshake.Reader;         // (pub const when re-exported)
```

- Every std path used in bodies gets an alias — even single-use common ones (`assert`, `print`). No `std.`-qualified chains inside function bodies.
- Deep std type paths lift to PascalCase aliases (`Sha256`, `Allocator`, `Ring`).
- Kernel snake_case types (`linux.io_uring_cqe`, `linux.cmsghdr`) stay qualified inline — ziglint infers typeness from identifier case and Z006s a PascalCase alias of them; that matches Matt's own `syscall.zig` idiom.
- Use sites are bare: `assert(x)`, `print("...", .{})`, `mem.eql(...)`, `testing.expect(...)`.

## Booleans → enums, always consider it

`true`/`false` at call sites carry no meaning. Prefer:
- Two-variant plain enum for exactly-one-state: `CloseMode = enum { graceful, abortive }`, `conn.close(.graceful)`.
- `std.EnumSet(Flag)` for simultaneous flags: `flags.contains(.terminating)`.
- A `phase: enum { ... }` field beats multiple bools and scales into a real state machine.
Legitimate bools: packed-struct bits, `atomic.Value(bool)`, presence (semantically `?T != null`), `?bool` tri-state, generated code. **Sharpened (owner, 2026-09-16): a latch that gates multiple code paths is a FLAG, not a presence indicator — EnumSet it. The test is whether the bit changes behavior in more than one place (client_eof arming deferred EOF + gating recv arms = flag; "has a signer attached" = presence). When in doubt, name the state.**

## Buffers

- Hand-rolled `buf: [N]T` + `len` pairs are banned in new code — use a shared `ArrayBuffer(T, N)` and derive from the type (`Buffer.Index`, `remainingCapacity()`, `appendSlice` vs `appendSliceAssumeCapacity`).
- NOT ArrayBuffer sites: ring buffers (head/tail modulo), lengths that ARE the sync point (atomics), read-cursor + len (that's IoBuffer's shape), allocator-owned backing, `?ArrayBuffer` where empty-vs-absent matters, always-full arrays.

## Arithmetic and safety (TigerStyle-descended)

ReleaseFast: `+`/`-` wrap silently, `@intCast` truncates unchecked, `std.debug.assert` is erased. Choose by where operands come from:
- User/wire-controlled lengths, counts, offsets → validate in EVERY build mode; error-return when recoverable. Check-before-mutate, ordered so the check can't itself wrap.
- External-contract values (FFI/kernel-reported sizes) → checked method in every mode.
- Programmer invariants (capacity contracts, refcounts) → `std.debug.assert` is correct; pair `x`/`xAssumeCapacity` conventions.
- Wraparound IS the semantics (generations, epochs) → `+%`/`-%`, written deliberately.
- `@panic` only for after-the-fact impossibility (state already corrupt). A bounds check that fires BEFORE damage is recoverable — return an error, tear down the scope, log loudly. Process abort over something you caught is pure cost; an externally-reachable abort is a DoS vector.

## Logging (when the project has src/log.zig)

Structured key-value, not printf: `log.info("connection accepted", .{ .fd = fd, .addr = addr })`. Scoped per module: `const log = logging.scoped(.module_name);`. Levels PANIC/ERROR/WARN/INFO/DEBUG/TRACE. Until the project has its log module, keep startup output minimal and structured-shaped.

## Types — sized, packed, and structured (Matt, 2026-09-16: "I don't like usize")

- **No `usize` in struct fields or local state.** Use explicit widths (`u64`, `u32`, `u16`) — deterministic sizes over pointer-sized. `usize` only where a std API parameter forces it, and cast at the boundary.
- **Bit-tag types are `packed struct(uN)`, not shift-math.** A tag like `op:8 | slot:16 | gen:16 | spare:24` is `packed struct(u64)` with those fields; convert with `@bitCast` both ways. No manual `packTag`/`unpackTag` shift functions — the type system does the packing. **Packing rules (verified on-toolchain): first declared field sits at bit 0 (declare LSB-first to keep an MSB-first wire layout); explicit bit-align on fields is rejected; nested packed structs and bools are legal fields — plain structs (std.EnumSet) are not; std IntegerBitSet is exact-fit backed (`std.meta.Int(.unsigned, N)`, NOT power-of-2 rounded) so width is never the obstacle — names are: bit flags read individually at dispatch become named bools in a nested packed struct (`spare: packed struct(u24) { slotless, backend, splice_in: bool, pad: u5, reserved: u16 }`), never index-constant masks and never unnamed std bit sets.**
- **Clustered bools → `std.EnumSet`** (extends the enums-over-bools rule): two or more related bool fields on one struct (op-in-flight flags, state latches that group) become one `EnumSet(Kind)` with `.contains`/`.insert`/`.remove` at call sites.
- **No manually-allocated list slices.** `gpa.alloc(T, n)` for a list that the type owns → `std.ArrayList(T)`. For a fixed-capacity table (the common case here): `initCapacity(gpa, n)` + `expandToCapacity()` — two calls, exact allocation, `items.len` set to capacity. NOT the `.empty + ensureTotalCapacity + resize` dance. `.empty` is for growable lists only. For appending when capacity is known-good: `appendAssumeCapacity` (not `append` + `catch unreachable`). `deinit(gpa)` in teardown. (Owner-corrected 2026-09-16 — the mechanical refactor used the wrong idiom.)
- **No hand-rolled `buffer` + `len` pairs.** Append-shaped → `ArrayBuffer(T)`; read-cursor (len + pos) → `SliceBuffer(T)`. Port from `~/code/ztls/src/array_buffer.zig` with attribution (not exported from ztls root). Keep the no-secureZero-on-views contract: clear the backing storage where it is declared (ztls #81).
- **The devShell is the tool contract.** Scripts in this repo do NOT carry runtime tool guards (require_tools / command -v checks) — every tool a script needs goes in flake.nix's devShell. A missing tool is a flake fix, never a script check. The only legitimate preflight is for build artifacts the script consumes (e.g. the compiled proxy binary).
- **Zeroing: `crypto.secureZero` for anything that has ever held secret material; `@memset` only for never-secret contract hygiene, with a comment saying why the content is not secret.** The distinction is dead-store elimination: `@memset` on a dead buffer can be elided by the optimizer in ReleaseFast; `secureZero` cannot. Classify by what the buffer CAN hold, not what it holds at the zeroing site. (Owner-raised 2026-09-16.)

## Sockets (0.16 idiom, from ztls examples/net_compat)

**Ring-native ops need own address builders:** std's address types (`net.IpAddress`, `net.UnixAddress`) are Io-vtable-bound — their listen/connect are blocking `Io` paths and the raw sockaddr bytes are never exposed. A ring op (`IoUring.connect` etc.) needs the sockaddr pointer + addrlen itself, so the sockaddr builder for any ring-bound endpoint is caller code. Validate std first every time — but if the piece is ring-native, owning it is correct, not duplication. (Owner-raised 2026-09-16; UnixAddress checked and declined: thin path-slice wrapper, blocking-only, hard-coded 108 where our derived capacity check is stricter.)

Boring blocking setup through std, ring for the data path:
```zig
const net = std.Io.net;
const addr = try net.IpAddress.parse("127.0.0.1", port);
var listener = try addr.listen(io, .{ .reuse_address = true });   // typed options, no raw setsockopt
defer listener.deinit(io);
// listener.socket.handle is the fd for the ring
// listener.socket.address.getPort() is the bound port (port 0 → ephemeral)
const stream = try listener.accept(io);      // or addr.connect(io, .{ .mode = .stream })
stream.socket.handle;                        // fd for ring ops
```
No hand-rolled `socket/bind/listen/setsockopt` wrappers unless std genuinely cannot express it (see the raw-layer reference for the setsockopt EINVAL trap).
