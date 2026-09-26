# Zig 0.16 changes — verified detail

All examples verified against zig 0.16.0 (the toolchain in this repo's flake) and the 0.16.0 release notes. Source of truth: `zig env` → `.std_dir`.

## Table of contents

1. [I/O as an Interface](#io-as-an-interface)
2. [Juicy Main](#juicy-main)
3. [File system migration table](#file-system-migration-table)
4. [Tasks, cancelation, and Io implementations](#tasks-cancelation-and-io-implementations)
5. [Language changes](#language-changes)
6. [Format and error-set changes](#format-and-error-set-changes)

## I/O as an Interface

Anything that can block control flow or introduce nondeterminism takes an `Io` instance. `Io` is passed by value; implementations fill a vtable.

Custom `Io` implementations are legal. The interface lives in `std/Io.zig` (vtable entries like `netListenUnix`, `netConnectUnix` are visible there).

Key types:

- `std.Io.Writer` — only writer type. Buffering is in the interface, `flush()` is explicit.
- `std.Io.Reader` — only reader type.
- `std.Io.Writer.Allocating` — writes to allocated memory; has an `alignment: std.mem.Alignment` field now; `toOwnedSlice`.
- `std.Io.File.Writer = .init(file, io, &buffer)` / `file.writer(io, &buffer)`.
- `std.Io.File.Reader` via `file.reader(io, &buffer)`; `&.{}` for unbuffered.
- `std.Io.Writer = .fixed(buffer)` / `std.Io.Reader = .fixed(data)` — replaces FixedBufferStream.
- `Io.Writer.Allocating` for building strings: `.init(allocator)`, `.writer.print(...)`, `.toOwnedSlice()`.

Custom formatters: `pub fn format(self: @This(), w: *std.Io.Writer) std.Io.Writer.Error!void`, invoked with `{f}`.

## Juicy Main

`std.process.Init` fields: `minimal` (argv + environ), `arena` (`*ArenaAllocator`, process lifetime, threadsafe), `gpa` (Allocator, threadsafe), `io` (Io), `environ_map` (`*Environ.Map`), `preopens`.

`Init.Minimal` fields: `environ: Environ`, `args: Args`.

Arg iteration without allocation:

```zig
pub fn main(init: std.process.Init.Minimal) void {
    var args = init.args.iterate();
    while (args.next()) |arg| { ... }
}
```

Env access: `init.environ.getPosix("HOME")`, `init.environ_map` for the full map. Env vars are no longer global state — pass what you need down as parameters.

## File system migration table

| 0.15 | 0.16 |
|---|---|
| `std.fs.File` | `std.Io.File` |
| `std.fs.Dir` | `std.Io.Dir` |
| `std.fs.cwd()` | `std.Io.Dir.cwd()` |
| `fs.File.read`/`readv` | `Io.File.readStreaming` |
| `fs.File.pread`/`preadv` | `Io.File.readPositional` |
| `fs.File.write`/`writev` | `Io.File.writeStreaming` |
| `fs.File.pwrite` | `Io.File.writePositional` |
| `fs.File.writeAll` | `Io.File.writeStreamingAll` |
| `fs.File.setEndPos` | `Io.File.setLength` |
| `fs.File.getEndPos` | `Io.File.length` |
| `fs.File.seekTo`/`seekBy` | `Io.File.Reader.seekTo` / `.seekBy`, `Io.Writer.seekTo` |
| `fs.File.getPos` | `Io.File.Reader.logicalPos`, `Io.Writer.logicalPos` |
| `fs.Dir.makeDir` | `Io.Dir.createDir` |
| `fs.Dir.makePath` | `Io.Dir.createDirPath` |
| `fs.Dir.makeOpenDir` | `Io.Dir.createDirPathOpen` |
| `fs.Dir.chmod`/`chown` | `Io.Dir.setPermissions`/`setOwner` |
| `fs.Dir.realpath` | `Io.Dir.realPathFile` |
| `fs.Dir.readFileAlloc` | `Io.Dir.cwd().readFileAlloc(io, path, allocator, .limited(n))` — limit reached is now `error.StreamTooLong` |
| `fs.File.readToEndAlloc` | `file.reader(io, &.{}).interface.allocRemaining(allocator, .limited(n))` |
| `fs.path` | `std.Io.Dir.path` (deprecated alias) |
| `fs.copyFileAbsolute` etc. | `std.Io.Dir.copyFileAbsolute` etc. |
| `fs.openSelfExe` | `std.process.openExecutable` |
| `fs.selfExePathAlloc` | `std.process.executablePathAlloc` |
| `fs.Dir.setAsCwd` | `std.process.setCurrentDir` |

`file.close()` is now `file.close(io)`. `File.Stat` access time is optional. `File.Mode` → `Io.File.Permissions`. Memory-map sync points are explicit (`File.MemoryMap`).

Removed with no replacement: most `*AbsoluteZ`/`*W` variants, `fs.getAppDataDir`.

## Tasks, cancelation, and Io implementations

Spelling is "cancelation" (single l) throughout std.

- `io.async(fn, args)` → `Future(T)`, infallible, may just call the function inline. `io.concurrent(...)` — must run concurrently, can fail `error.ConcurrencyUnavailable`.
- `Future.await(io)` / `Future.cancel(io)`. `cancel` = await + interrupt request → `error.Canceled`. Even `Io.Threaded` supports it (signal → EINTR → check).
- `error.Canceled` is baked into cancelable I/O error sets. Only the cancel requester may ignore it. Alternatives: propagate, `io.recancel()`, or `io.swapCancelProtection()`.
- `Io.Group` — O(1) spawn of N tasks; `group.async(io, fn, args)`, `group.await(io)`, `group.cancel(io)`; always `defer group.cancel(io)`.
- `Io.Batch` — operation-level concurrency (`FileReadStreaming`, `FileWriteStreaming`, `DeviceIoControl`, `NetReceive` currently). `io.operateTimeout` adds timeouts to batchable ops.
- `io.checkCancel()` — extra cancelation points in long CPU-bound loops.
- `std.Random.IoSource = .{ .io = io }` → `.interface()` for a Random.
- `Io.Queue(T)`, `Io.Select`, `Io.Clock`/`Duration`/`Timestamp`/`Timeout` exist for units-typed time work.

Implementation status:

| Impl | Status |
|---|---|
| `Io.Threaded` | complete, well-tested, default; `-fsingle-threaded` loses task concurrency |
| `Io.Evented` | WIP (M:N green threads); **no networking yet** |
| `Io.Uring` | PoC (Evented on io_uring); unfinished |
| `Io.Kqueue` | PoC |
| `Io.Dispatch` | PoC (GCD) |
| `Io.failing` | supports no operations (useful in tests) |

For a custom event loop (this project), do not build on these — use `std.os.linux` + `std.os.linux.IoUring` directly. See [linux-raw-layer.md](linux-raw-layer.md).

Sync primitives that do not need `Io`: lock-free ones only. Everything contended moved: `Thread.ResetEvent`→`Io.Event`, `WaitGroup`→`Io.Group`, `Futex`→`Io.Futex`, `Mutex`→`Io.Mutex`, `Condition`→`Io.Condition`, `Semaphore`→`Io.Semaphore`. `std.once` removed. `Thread.Pool` removed. `ArenaAllocator` is threadsafe and lock-free now; `ThreadSafeAllocator` removed.

## Language changes

- `@Type` is **removed**. Replacement builtins: `@EnumLiteral()`, `@Int(signedness, bits)`, `@Tuple(types)`, `@Pointer(size, attrs, child, sentinel)`, `@Fn(param_types, param_attrs, return_type, attrs)`, `@Struct(layout, backing, names, types, attrs)`, `@Union(layout, backing, names, types, attrs)`, `@Enum(tag_int, mode, names, values)`. Use `&@splat(.{})` for default attrs. `std.meta.Int`/`std.meta.Tuple` deprecated. No `@Float` (use `std.meta.Float`), no `@Array`, no `@Opaque` (write `opaque {}`), no `@Optional`/`@ErrorUnion`/`@ErrorSet` — error sets can no longer be reified.
- Small integer → float coercion when every value fits without rounding (`u24`→`f32` yes, `u25`→`f32` no).
- `@floor/@ceil/@round/@trunc` can convert float→int directly (result type inferred); `@intFromFloat` deprecated.
- Unary float builtins (`@sqrt`, `@sin`, ..., `@round`) forward their result type, so `const x: f64 = @sqrt(@floatFromInt(n));` works now.
- Returning the address of a runtime-known local is a compile error: `error: returning address of expired local variable`.
- `packed struct`/`packed union` fields may not be pointers. Packed unions require same-`@bitSizeOf` fields or an explicit backing int (`packed union(u16)`); explicit backing ints allowed and required in extern contexts (also for enums: `enum(u8)`).
- Packed types and enums work as switch prong items (compared by backing integer).
- Runtime vector indexing forbidden; coerce to array: `const arr: [n]T = vector;`.
- Vectors/arrays no longer coerce in-memory through error unions.
- Zero-bit tuple fields are no longer implicitly comptime.
- `@cImport` deprecated — move C imports to `b.addTranslateC` + a `.h` file:

```zig
const translate_c = b.addTranslateC(.{ .root_source_file = b.path("src/c.h"), .target = target, .optimize = optimize });
// then .imports = &.{ .{ .name = "c", .module = translate_c.createModule() } }
```

Build system additions: local package overrides, project-local dependency fetching, test timeouts (`b.addTest` timeout options), `--error-style`, `--multiline-errors`.

## Format and error-set changes

- `{D}` duration specifier removed: `writer.print("{f}", .{std.Io.Duration{ .nanoseconds = ns }})`.
- `std.fmt.Formatter` → `Alt`; `std.fmt.format` → `Io.Writer.print`; `FormatOptions` → `Options`; `bufPrintZ` → `bufPrintSentinel`.
- leb128: `std.leb.readUleb128` → `std.Io.Reader.takeLeb128`.
- Error renames: `RenameAcrossMountPoints`/`NotSameFileSystem` → `CrossDevice`; `SharingViolation` → `FileBusy`; `EnvironmentVariableNotFound` → `EnvironmentVariableMissing`; `Io.Dir.rename` returns `DirNotEmpty` instead of `PathAlreadyExists`.
- `std.meta.intToEnum` deprecated → `std.enums.fromInt` (returns `?Enum`, use `orelse`, not `catch`).
- `std.compress.flate`: DEFLATE compression now exists in std (0.15's was broken); `Decompress` on `Io.Reader`/`Writer`.
- `SegmentedList`, `meta.declList`, `Io.GenericWriter`, `Io.AnyWriter`, `Io.null_writer`, `Io.CountingReader`, `Thread.Mutex.Recursive` removed.
- Child processes: `std.process.spawn(io, .{ .argv, .stdin, .stdout, .stderr })`, `std.process.run(allocator, io, .{...})`, `std.process.replace(io, .{ .argv })`.
- `std.mem` cut family: `cut`, `cutPrefix`, `cutSuffix`, `cutScalar`, `cutLast`, `cutLastScalar` — splitting without allocation.
