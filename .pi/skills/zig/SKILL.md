---
name: zig
description: "Write correct, idiomatic Zig 0.16 code in this repository (pins zig 0.16.0). Triggers on any task involving .zig files, build.zig.zon, or Zig compile errors here. LLM training data is based on Zig 0.11-0.15 and produces broken code against 0.16; this skill holds patterns verified against this repo's exact toolchain. This is the project-local Zig 0.16 skill and shadows the global 0.15 'zig' skill in this repo."
---

# Zig 0.16 (this repo)

This repo builds with zig 0.16.0 (nix flake, `zig_0_16`). Training data covers 0.11-0.15 at best. The 0.15-era patterns (the global `zig` skill) are **wrong here** in specific, silent ways — mostly around `std.Io`, `std.posix`, and `main`'s signature.

Rule zero: verify APIs against the pinned toolchain, not memory.

```bash
zigdoc std.Io.File          # API discovery, toolchain-aware
zig env                     # .std_dir = actual std source for THIS zig
ziglint src/                # style + correctness lint
grep -n "pub fn find" "$(zig env | ...)"   # or grep $STD directly
```

`zig env` prints `.std_dir` — grep that tree when a signature matters. It is the source of truth, and it is cheap.

## Critical changes you will get wrong

### 1. `main` takes `std.process.Init` ("Juicy Main")

```zig
pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;                          // general purpose allocator, threadsafe
    const io = init.io;                            // default Io implementation
    const arena: std.mem.Allocator = init.arena.allocator();  // process-lifetime, threadsafe, auto-freed
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    // init.environ_map: *Environ.Map — env vars are NOT global anymore
    // init.preopens: Preopens
}
```

- argv and environ exist **only** through this parameter. `std.process.environ` and global argv access are gone. Empty param list `pub fn main() !void` is legal but then you get no args/env.
- `std.process.Init.Minimal` is the smaller variant (argv + environ only).
- Use `std.testing.io` in tests, like `std.testing.allocator`.

### 2. I/O as an Interface — everything takes `Io`

`std.fs.File` → `std.Io.File`. `std.fs.Dir` → `std.Io.Dir`. `std.fs.cwd()` → `std.Io.Dir.cwd()`. `file.close()` → `file.close(io)`.

```zig
// stdout, buffered (from this repo's src/main.zig — it compiles):
var stdout_buffer: [1024]u8 = undefined;
var stdout_file_writer: std.Io.File.Writer = .init(.stdout(), io, &stdout_buffer);
const stdout_writer = &stdout_file_writer.interface;
try stdout_writer.print("hello {s}\n", .{"world"});
try stdout_writer.flush();            // still required — output stays buffered otherwise

// one-shot:
try std.Io.File.stdout().writeStreamingAll(io, "Hello, world!\n");

// file reading:
var file_reader = file.reader(io, &.{});          // &.{} = empty buffer, unbuffered
const contents = try file_reader.interface.allocRemaining(allocator, .limited(max));

// FixedBufferStream is gone:
var writer: std.Io.Writer = .fixed(buffer);        // was fixedBufferStream
var reader: std.Io.Reader = .fixed(data);
```

- Functions that do I/O take `Io` (by value) or `*Io`. If you have no `Io` at hand: `var threaded: std.Io.Threaded = .init_single_threaded; const io = threaded.io();` — a workaround, not a pattern; thread `Io` through instead.
- `std.net` → `std.Io.net` (IpAddress, listen, bind, and `UnixAddress` for UDS — `io.vtable.netListenUnix` / `netConnectUnix` exist in the interface; verify backend support before relying on them).
- Io implementations: `Io.Threaded` is complete (default for `init.io`). `Io.Evented`/`Io.Uring`/`Io.Kqueue` are WIP/proof-of-concept (Evented lacks networking). This project's event loop does not use them — see [references/linux-raw-layer.md](references/linux-raw-layer.md).

### 3. `std.posix` was gutted — 54 functions left

The medium layer was removed. Survivors include `read`, `setsockopt`, `getpeername`, `mmap`/`munmap`/`mremap`/`msync`, `kill`/`raise`, `openat`, `sched_getaffinity`, `sigfillset`/`sigemptyset`/`sigaddset`/`sigdelset`/`sigismember`, `sigaltstack`. Everything else: go **higher** (`std.Io`) or **lower** (`std.posix.system` — which is `std.os.linux` without libc, `std.c` with libc).

**setsockopt landmine:** `std.posix.setsockopt` maps `EINVAL` to `unreachable` — UB in ReleaseFast, a process-killing panic in Debug/ReleaseSafe. Acceptable only where EINVAL can mean a programming bug (TCP_NODELAY on a fresh socket, SO_REUSEADDR); for any option where EINVAL is a legitimate runtime failure, use the raw layer with your own errno handling:

```zig
pub fn setsockopt(fd: i32, level: i32, optname: u32, opt: []const u8) bool {
    const rc = linux.setsockopt(fd, level, optname, opt.ptr, @intCast(opt.len));  // returns usize
    return linux.errno(rc) == .SUCCESS;   // decode yourself, no unreachable paths
}
```

### 4. Raw Linux layer — this project's home turf

`std.os.linux` still has direct wrappers: `socket`, `setsockopt`, `bind`, `listen`, `accept4`, `connect`, `shutdown`, `sendmsg`, `recvmsg`, `epoll_create1`, `epoll_ctl`, `epoll_wait`, `pipe2`, `fcntl`, `ioctl`, `io_uring_setup`. All return `usize`; decode with `linux.errno(rc)` into a real error set — **`linux.E` is an `enum(u16)`, not an error set**: never write `linux.E!T` signatures or return errno values as errors; declare error sets and map errno values onto them (`io_uring_cqe.err()` also returns the enum). See the `SysError`/`toError`/`rc` recipe in [references/linux-raw-layer.md](references/linux-raw-layer.md).

**`splice` has no wrapper** — hand-roll it (syscall number exists in the `SYS` enum):

```zig
const rc = linux.syscall6(.splice, fd_in, @intFromPtr(off_in_opt), fd_out, @intFromPtr(off_out_opt), len, flags);
```

**kTLS lives here** — the verified UAPI layer (constants, installs, cmsg framing) is `ztls.ktls` in `src/ktls.zig`, with `integrations/ztls-ktls` as the data-plane integration. Define kernel TLS constants there, nowhere else.

`std.os.linux.IoUring` is the raw ring wrapper (init, get_sqe, submit, enter, copy_cqes, cqe_seen, plus op builders: `splice`, `read_fixed`, `write_fixed`, `accept`, ...). Use that, **not** `std.Io.Uring` (the WIP Evented backend).

Full inventory and recipes: [references/linux-raw-layer.md](references/linux-raw-layer.md).

### 5. Unchanged from 0.15, still easy to get wrong

- `std.ArrayList` is unmanaged: init `.empty`, allocator per mutating call (`list.append(allocator, item)`), `list.deinit(allocator)`. `ArrayListUnmanaged` is now just a deprecated alias for `ArrayList`. No `.init(allocator)` — that managed variant is deprecated.
- Cast builtins are single-argument, return type inferred from context: `const x: DestType = @ptrCast(ptr);`
- Type reflection tags lowercase: `.int`, `.float`, `.@"struct"`, `.@"enum"`.
- `callconv(.c)` lowercase; `std.os` → `std.posix`; `std.rand` → `std.Random`; `@setCold` → `@branchHint(.cold)`.
- Structs/arrays have no `==`; use `std.meta.eql` / `std.mem.eql`.

### 6. `std.mem` renames — "index of" is now "find"

`indexOf` → `find`, `indexOfScalar` → `findScalar`, `lastIndexOf` → `findLast`, `indexOfPos` → `findPosLinear` family. New cut helpers: `cut`, `cutPrefix`, `cutSuffix`, `cutScalar`, `cutLast`, `cutLastScalar`. Emitting `std.mem.indexOf*` is a compile error now.

### 7. Other 0.16 breaks, one line each

- `@Type` removed → `@Int(.unsigned, 10)`, `@Struct`, `@Union`, `@Enum`, `@Pointer`, `@Fn`, `@Tuple`, `@EnumLiteral()`.
- `@cImport` deprecated → `b.addTranslateC` in build.zig.
- Sync primitives moved: `Thread.ResetEvent`→`Io.Event`, `WaitGroup`→`Io.Group`, `Futex`→`Io.Futex`, `Mutex`→`Io.Mutex`, `Condition`→`Io.Condition`, `Semaphore`→`Io.Semaphore`. `std.once` and `Thread.Pool` removed. `ArenaAllocator` is now threadsafe/lock-free; `ThreadSafeAllocator` removed.
- Entropy: `std.crypto.random.bytes` → `io.random(&buf)` (or `io.randomSecure`); Random via `std.Random.IoSource{ .io = io }`.
- Time: `std.time.Instant`/`Timer` → `std.Io.Timestamp`. `{D}` format specifier removed → `{f}` with `std.Io.Duration`.
- Floats: small ints (`u24`→`f32`) coerce implicitly; `@floor/@ceil/@round/@trunc` convert to int directly; `@intFromFloat` deprecated.
- Managed containers removed (`AutoArrayHashMap` → `array_hash_map.Auto`, etc.); `PriorityQueue`/`PriorityDequeue` lost their allocator field; `BitSet`/`EnumSet` use `.empty`/`.full` decl literals.
- Returning the address of a local is now a compile error ("expired local variable").
- Pointers are forbidden in `packed struct`/`packed union`. `extern` enums/packed types need explicit backing ints.
- Runtime vector indexing is forbidden — coerce to array first.
- fmt: `Formatter`→`Alt`, `bufPrintZ`→`bufPrintSentinel`.
- Error renames: `RenameAcrossMountPoints`/`NotSameFileSystem`→`CrossDevice`, `SharingViolation`→`FileBusy`, `EnvironmentVariableNotFound`→`EnvironmentVariableMissing`.
- Child processes: `std.process.spawn(io, .{ .argv, .stdin, ... })`, `std.process.run(allocator, io, .{...})`, `std.process.replace(io, ...)`.

Full detail with examples: [references/zig-0.16-changes.md](references/zig-0.16-changes.md). Matt's style rules (expression shape, enums-over-bools, buffers, arithmetic placement, sockets idiom): [references/matt-zig-style.md](references/matt-zig-style.md) — apply when writing or reviewing any Zig here.

## Security footgun: narrow-type arithmetic in bounds checks

Zig evaluates `narrow_type + comptime_int` in the narrow type **before** widening for the comparison. A bounds check like:

```zig
const len = r.assumeRead(u16);           // attacker-controlled TLS record length
if (remaining < len + 5) return error.UnexpectedEof;   // BUG: len + 5 overflows u16
```

panics (Debug/ReleaseSafe) or is UB (ReleaseFast) before the comparison rejects the oversized input. Remote DoS class — caused 14 exploitable sites in ztls (#72). `ziglint` does not catch this. This project parses TLS record headers (u16 lengths) constantly. Always widen first:

```zig
if (remaining < @as(usize, len) + 5) return error.UnexpectedEof;
```

Audit every `narrow_var + comptime_int` bounds check when writing or reviewing record parsing.

## Style

- `camelCase` functions, `snake_case` variables/constants, `PascalCase` types.
- Prefer `const foo: Type = .{ .field = value };` over `const foo = Type{...};`.
- File order: `//!` doc, `const Self = @This();`, imports, `const log = std.log.scoped(...)`.
- Allocators explicit; `errdefer` for cleanup on error paths.
- Use `@splat` for uniform array/vector init: `const mask: [4]u8 = @splat(0);`
- Extract type aliases for repeated semantic types (`const RecordLen = u16;` not bare `u16` in every signature).
- Tests inline with the code they cover.
- Comments explain why, not what.
- `std.time.nanoTimestamp()` returns `i128`: `const ns: i64 = @intCast(@as(i64, @truncate(std.time.nanoTimestamp())));`

## Before writing Zig code

1. `zigdoc <symbol>` for any std API you are not certain of — 0.16 renamed too much to guess.
2. Read existing code in `src/` first; match established patterns.
3. Grep the pinned std source (`zig env` → `.std_dir`) when a signature matters.
4. After writing, run BOTH `zig build test` AND `zig build`. Lazy analysis can leave a non-test entry's call graph unanalyzed — a green test build with a broken `run()` is a real observed failure mode. Every live-test command touching a socket runs under `timeout N` — a blocked syscall is not a finding.
