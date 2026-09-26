# Linux raw layer in zig 0.16 std — inventory and recipes

Verified against the exact stdlib this repo compiles with (`zig env` → `.std_dir`, zig 0.16.0, aarch64-linux). This is the layer ztls's raw-fd examples and kTLS integration live on: stock syscalls, io_uring, kTLS ULP.

## Layer map

| Layer | What it is | Use for |
|---|---|---|
| `std.Io` | interface, takes `Io` everywhere | high-level portable code |
| `std.posix` | 54 functions left; medium layer removed | `setsockopt`-survivors only, see landmine below |
| `std.posix.system` | `std.os.linux` (no libc) or `std.c` (libc) | escape hatch |
| `std.os.linux` | raw per-syscall wrappers, return `usize` | **the raw layer (examples, kTLS)** |
| `std.os.linux.IoUring` | raw ring wrapper, sqe/cqe structs | io_uring modes |

`std.os.linux.zig` re-exports arch bits: `syscall3`/`syscall6`/... live in `os/linux/<arch>.zig` and take a `SYS` enum value (`SYS` is an arch-switched enum; `splice` is in it).

**`linux.E` is a plain `enum(u16)`, NOT an error set.** You cannot write `linux.E!T` return types or return errno values as errors. Declare a real error set and map errno values onto it:

```zig
pub const SysError = error{ WouldBlock, ConnectionReset, BrokenPipe, Interrupted, Unexpected };

pub fn toError(e: linux.E) SysError {
    return switch (e) {
        .AGAIN => error.WouldBlock,
        .CONNRESET => error.ConnectionReset,
        .PIPE => error.BrokenPipe,
        .INTR => error.Interrupted,
        else => error.Unexpected,
    };
}

pub fn rc(r: usize) SysError!u32 {
    const e = linux.errno(r);
    return if (e == .SUCCESS) @intCast(r) else toError(e);
}
```

## std.posix survivors (the full 54, function-shaped)

The useful ones for this project: `read`, `setsockopt`, `getpeername`, `mmap`, `munmap`, `mremap`, `msync`, `kill`, `raise`, `openat`, `openatZ`, `getppid`, `sched_getaffinity`, `sigaltstack`, `sigfillset`, `sigemptyset`, `sigaddset`, `sigdelset`, `sigismember`, `sysctl`, `getSelfPhdrs`, `dl_iterate_phdr`, `fanotify_*`, `reboot`. (Plus type/const decls.) Everything else you remember from 0.15 posix — `socket`, `bind`, `listen`, `accept`, `epoll_*`, `pipe2`, `sendmsg`, `recvmsg`, `splice`, `fcntl` as posix fns — is **gone**.

## std.os.linux direct wrappers (present, verified)

`socket(domain, socket_type, protocol) usize`, `setsockopt(fd, level, optname, optval_ptr, optlen) usize`, `bind`, `listen`, `accept4`, `connect`, `shutdown`, `sendmsg`, `recvmsg`, `sendto`, `recvfrom`, `epoll_create1`, `epoll_ctl`, `epoll_wait`, `epoll_pwait2`, `pipe2`, `fcntl`, `ioctl`, `getsockname`, `getpeername`, `sockaddr` types, `io_uring_setup`, `io_uring_enter`, `io_uring_register`. **Bare `send`/`recv` do NOT exist in 0.16.0** (verified on-kernel) — use `sendto`/`recvfrom` or the msg forms; `iovec`/`iovec_const` come from `std.posix` (`linux.iovec_const` is a private alias).

All return raw `usize`. Decode with the enum pattern above — never `linux.E!T`, it is an enum, not an error set:

```zig
const rc = linux.socket(linux.AF.INET, linux.SOCK.STREAM | linux.SOCK.NONBLOCK, 0);
const fd: i32 = @intCast(try rc(rc));   // rc() from the error-mapping recipe
```

### The std.posix.setsockopt EINVAL landmine

`std.posix.setsockopt(fd, level: i32, optname: u32, opt: []const u8)` maps `.INVAL => unreachable`. In ReleaseFast that `unreachable` is UB; in Debug/ReleaseSafe a panic that kills the process. Use it only for options where EINVAL really is a programming bug (TCP_NODELAY, SO_REUSEADDR); any option whose EINVAL is a legitimate runtime failure must use `linux.setsockopt` directly with explicit errno handling.

### splice — no wrapper, hand-roll

`SYS.splice` exists; there is no `linux.splice` fn. Six-arg syscall:

```zig
fn splice(fd_in: i32, off_in: ?*const u64, fd_out: i32, off_out: ?*const u64, len: usize, flags: u32) SysError!usize {
    const rc = linux.syscall6(.splice,
        @as(u64, @bitCast(@as(i64, fd_in))),  @intFromPtr(off_in),
        @as(u64, @bitCast(@as(i64, fd_out))), @intFromPtr(off_out),
        len, flags);
    const e = linux.errno(rc);
    return if (e == .SUCCESS) @intCast(rc) else toError(e);
}
```

(Adjust to the repo's error strategy once established — this is the shape, not the mandated implementation.)

This is a recipe, not a live file — the errno-switch mapping lives inline at each consumer (`examples/epoll_pingpong.zig`, `src/ktls.zig`). A dedicated raw-layer file earns existence only when a third consumer of the mapping appears.

## std.os.linux.IoUring — the raw ring wrapper

`std/os/linux/IoUring.zig`. This is the one to use. Do **not** confuse with `std.Io.Uring` — that file is the WIP `Io.Evented` implementation (its functions take `*Evented`), unfinished, no networking.

Lifecycle: `init(entries, flags)`, `init_params(entries, *io_uring_params)`, `deinit`.
Submission: `get_sqe()`, `submit()`, `submit_and_wait(nr)`, `enter(to_submit, min_complete, flags)`, `flush_sq()`, `sq_ready()`.
Completion: `cq_ready()`, `copy_cqes(buf, wait_nr)`, `copy_cqe()`, `cqe_seen(cqe)`, `cq_advance(n)`, `cq_ring_needs_flush()`.
Op builders returning `*io_uring_sqe`: `nop`, `read`, `write`, `readv`, `writev`, `read_fixed`, `write_fixed`, `send`, `recv`, `accept`, `accept_multishot`, `accept_direct`, `accept_multishot_direct`, `connect`, `close`, `close_direct`, `fsync`, **`splice`**, `timeout`, `timeout_remove`, `cancel`, more — grep `.std_dir/os/linux/IoUring.zig` for `pub fn` before assuming one exists.

**Provided buffers**: `provide_buffers(...)` registers buffer groups; `IoUring.BufferGroup` has `recv` / `recv_multishot` that consume registered buffers by `buf_index`.

SQE fields are set through the returned pointer (`sqe.user_data`, `.opcode` implied by builder, `.flags`, `.ioprio`, `.fd`, `.len`, `.addr`, `.off`, `.buf_index`, `.splice_fd_in`, personality, etc.). `io_uring_sqe` struct: `std/os/linux/io_uring_sqe.zig`.

For io_uring ownership discipline (slot index, generation, direction, op kind in `user_data`; discard CQEs whose generation mismatches; cancel before reuse), encode the generation-tag scheme in `user_data` — the raw wrapper leaves `user_data` entirely to us.

## kTLS

The verified UAPI layer (constants, installs, cmsg framing) lives in ztls core (`src/ktls.zig`), with `integrations/ztls-ktls` owning the data plane. Two toolchain facts from that work:
- UAPI constant names trip ziglint Z006 (PascalCase wanted); the reference pattern is `// ziglint-ignore: Z006 -- kernel UAPI constant name, kept verbatim for grep-ability.` per declaration.
- An array type alias cannot carry alignment (`pub const B = [24]u8 align(8);` is a syntax error) — alignment is legal only on variables, fields, and pointer types; wrap in a one-field struct when a control buffer needs alignment.

## std.Io.net — what exists (for completeness)

`Io.net` has `IpAddress`, `parse`/`resolve`, `listen`/`bind` with `Io`, and `UnixAddress` (`Io/net.zig`): `init(path)` (rejects over-long paths), `isAbstract`, `listen(ua, io, options)` → `io.vtable.netListenUnix`, and `netConnectUnix` in the vtable. `Io.net.Socket.createPair` exists. The epoll/io_uring examples bypass `Io.net` for the raw layer (nonblocking, custom accept loops), but `UnixAddress` validation logic is worth reading before reimplementing.

`Io.Evented` has no networking; `Io.Threaded` maps these to blocking syscalls.
