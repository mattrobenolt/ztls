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
        else => @compileError("ztls examples support only Linux and macOS"),
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

pub fn connect(addr: Address) !Stream {
    return if (comptime is_zig_16)
        addr.connect(io(), .{ .mode = .stream })
    else
        std.net.tcpConnectToAddress(addr);
}

pub fn close(stream: Stream) void {
    if (comptime is_zig_16) stream.close(io()) else stream.close();
}

pub fn fd(stream: Stream) std.posix.fd_t {
    return if (comptime is_zig_16) stream.socket.handle else stream.handle;
}

pub fn read(stream: Stream, buf: []u8) !usize {
    if (comptime !is_zig_16) return stream.read(buf);
    var data: [1][]u8 = .{buf};
    return io().vtable.netRead(io().userdata, stream.socket.handle, &data);
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
