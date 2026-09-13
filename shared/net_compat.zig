//! 0.15/0.16 networking compatibility shim for examples and conformance harnesses.
//!
//! Both the examples and the conformance TCP shims need the same type aliases,
//! I/O wrappers, and dual-version std.net / std.Io.net bridging. This is the
//! single source — examples and conformance each import it as a module from
//! their build files so neither carries a divergent copy.
const std = @import("std");
const builtin = @import("builtin");
const Allocator = std.mem.Allocator;

const is_zig_16 = builtin.zig_version.major == 0 and builtin.zig_version.minor >= 16;
const Net = if (is_zig_16) std.Io.net else std.net;

pub const Address = if (is_zig_16) Net.IpAddress else Net.Address;
pub const Stream = Net.Stream;
pub const Server = Net.Server;

fn io() std.Io {
    return std.Io.Threaded.global_single_threaded.io();
}

pub fn env(comptime name: [:0]const u8) ?[]const u8 {
    if (std.c.getenv(name)) |value| return std.mem.span(value);
    return null;
}

pub fn readFileAlloc(allocator: Allocator, path: []const u8, limit: usize) ![]u8 {
    return if (comptime is_zig_16)
        std.Io.Dir.cwd().readFileAlloc(io(), path, allocator, .limited(limit))
    else
        std.fs.cwd().readFileAlloc(allocator, path, limit);
}

pub fn timestamp() i64 {
    return if (comptime is_zig_16)
        std.Io.Timestamp.now(io(), .real).toSeconds()
    else
        std.time.timestamp();
}

pub fn sleep20ms() void {
    if (comptime is_zig_16) {
        const req: std.c.timespec = .{ .sec = 0, .nsec = 20 * std.time.ns_per_ms };
        _ = std.c.nanosleep(&req, null);
    } else {
        std.Thread.sleep(20 * std.time.ns_per_ms);
    }
}

pub fn fillRandom(buf: []u8) void {
    switch (builtin.os.tag) {
        .linux => {
            var remaining = buf;
            while (remaining.len != 0) {
                const rc = std.os.linux.getrandom(remaining.ptr, remaining.len, 0);
                const signed_rc: isize = @bitCast(rc);
                if (signed_rc >= 0) {
                    remaining = remaining[@intCast(signed_rc)..];
                    continue;
                }
                const errno: usize = @intCast(-signed_rc);
                switch (errno) {
                    4, 11 => continue, // EINTR, EAGAIN
                    else => @panic("getrandom failed"),
                }
            }
        },
        .macos => std.c.arc4random_buf(buf.ptr, buf.len),
        else => @compileError("ztls examples and conformance shims support only Linux and macOS"),
    }
}

pub fn parseIp(ip: []const u8, port: u16) !Address {
    return if (comptime is_zig_16)
        Net.IpAddress.parse(ip, port)
    else
        Net.Address.parseIp(ip, port);
}

pub fn listen(addr: Address, options: anytype) !Server {
    return if (comptime is_zig_16)
        addr.listen(io(), .{ .reuse_address = options.reuse_address })
    else
        addr.listen(Net.Address.ListenOptions{ .reuse_address = options.reuse_address });
}

pub fn serverPort(server: Server) u16 {
    return if (comptime is_zig_16)
        server.socket.address.getPort()
    else
        server.listen_address.in.getPort();
}

pub fn serverFd(server: Server) std.posix.fd_t {
    return if (comptime is_zig_16)
        server.socket.handle
    else
        server.stream.handle;
}

pub fn deinitServer(server: *Server) void {
    if (comptime is_zig_16) server.deinit(io()) else server.deinit();
}

pub fn accept(server: *Server) !Stream {
    if (comptime is_zig_16) return server.accept(io());
    return (try server.accept()).stream;
}

/// Connect to a resolved address. No retry — for server-side examples that
/// control the listening socket.
pub fn connect(addr: Address) !Stream {
    return if (comptime is_zig_16)
        addr.connect(io(), .{ .mode = .stream })
    else
        std.net.tcpConnectToAddress(addr);
}

/// Connect to a host:port with retry. TLS-Anvil starts the trigger script
/// (the client) before opening its server socket, so the first connect attempt
/// may get ConnectionRefused. Retry briefly to avoid the race.
pub fn connectToHost(_: Allocator, host: []const u8, port: u16) !Stream {
    const addr = try parseIp(host, port);
    var attempts: u8 = 0;
    while (attempts < 50) : (attempts += 1) {
        if (is_zig_16) {
            return addr.connect(io(), .{ .mode = .stream }) catch |err| switch (err) {
                error.ConnectionRefused => {
                    sleep20ms();
                    continue;
                },
                else => return err,
            };
        } else {
            return std.net.tcpConnectToAddress(addr) catch |err| switch (err) {
                error.ConnectionRefused => {
                    sleep20ms();
                    continue;
                },
                else => return err,
            };
        }
    }
    return error.ConnectionRefused;
}

pub fn close(stream: Stream) void {
    if (comptime is_zig_16) stream.close(io()) else stream.close();
}

pub fn fd(stream: Stream) std.posix.fd_t {
    return if (comptime is_zig_16) stream.socket.handle else stream.handle;
}

/// Local (source) TCP port of a connected stream. Harness diagnostics use it
/// to bind a client invocation to the exact connection a peer trace recorded.
/// Null if the OS lookup fails or the family is not INET/INET6. POSIX-only so
/// it works identically under 0.15 and 0.16 on Linux and macOS.
pub fn localPort(stream: Stream) ?u16 {
    var addr: std.posix.sockaddr.storage = undefined;
    var addr_len: std.posix.socklen_t = @sizeOf(std.posix.sockaddr.storage);
    // std.posix.getsockname moved off POSIX in 0.16; the libc symbol is
    // identical on both versions and every net_compat consumer links libc.
    if (std.c.getsockname(fd(stream), @ptrCast(&addr), &addr_len) != 0) return null;
    const bytes: [*]const u8 = @ptrCast(&addr);
    // sockaddr_in and sockaddr_in6 both carry the port big-endian at offset 2
    // on Linux and macOS; only the family field layout differs (u16 at 0 on
    // Linux, len byte + family byte at 1 on macOS).
    const family: u16 = if (builtin.os.tag == .macos)
        bytes[1]
    else
        std.mem.readInt(u16, bytes[0..2], builtin.cpu.arch.endian());
    if (family != std.posix.AF.INET and family != std.posix.AF.INET6) return null;
    return std.mem.readInt(u16, bytes[2..4], .big);
}

pub fn read(stream: Stream, buf: []u8) !usize {
    if (comptime !is_zig_16) return stream.read(buf);
    var data: [1][]u8 = .{buf};
    return io().vtable.netRead(io().userdata, stream.socket.handle, &data);
}

pub fn readAtLeast(stream: Stream, buf: []u8, len: usize) !usize {
    var total: usize = 0;
    while (total < len) {
        const n = try read(stream, buf[total..]);
        if (n == 0) break;
        total += n;
    }
    return total;
}

pub fn writeAll(stream: Stream, bytes: []const u8) !void {
    if (comptime !is_zig_16) return stream.writeAll(bytes);
    var rest = bytes;
    while (rest.len != 0) {
        const data: [1][]const u8 = .{rest};
        const n = try io().vtable.netWrite(io().userdata, stream.socket.handle, "", &data, 1);
        rest = rest[n..];
    }
}
