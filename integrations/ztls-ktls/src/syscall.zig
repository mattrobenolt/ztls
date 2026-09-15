const std = @import("std");
const testing = std.testing;
const posix = std.posix;
const linux = std.os.linux;
const ktls = @import("ztls").ktls;

const cmsg_data_offset = std.mem.alignForward(
    usize,
    @sizeOf(linux.cmsghdr),
    @sizeOf(usize),
);
const cmsg_space = cmsg_data_offset + std.mem.alignForward(usize, 1, @sizeOf(usize));

pub const SetResult = enum {
    ok,
    unavailable,
    busy,
    failed,
};

pub const SendError = error{
    WouldBlock,
    Interrupted,
    ConnectionClosed,
    UnexpectedSystemError,
};

pub const ControlSendError = SendError || error{ShortControlWrite};

pub const RecvError = error{
    WouldBlock,
    Interrupted,
    KeyExpired,
    ConnectionClosed,
    InvalidControlMessage,
    BadRecord,
    RecordTooLarge,
    InvalidRecord,
    UnexpectedSystemError,
};

pub const Received = struct {
    len: usize,
    content_type: ?u8,
};

pub fn setSockOpt(fd: posix.socket_t, level: u32, option: u32, value: []const u8) SetResult {
    const rc = linux.setsockopt(fd, @intCast(level), option, value.ptr, @intCast(value.len));
    return switch (linux.errno(rc)) {
        .SUCCESS => .ok,
        .NOENT, .NOPROTOOPT, .PROTONOSUPPORT, .OPNOTSUPP => .unavailable,
        .BUSY => .busy,
        else => .failed,
    };
}

pub fn sendData(fd: posix.socket_t, bytes: []const u8) SendError!usize {
    const rc = linux.sendto(fd, bytes.ptr, bytes.len, linux.MSG.NOSIGNAL, null, 0);
    return switch (linux.errno(rc)) {
        .SUCCESS => @intCast(@as(isize, @bitCast(rc))),
        .AGAIN => error.WouldBlock,
        .INTR => error.Interrupted,
        .PIPE, .CONNRESET, .NOTCONN => error.ConnectionClosed,
        else => error.UnexpectedSystemError,
    };
}

// ziglint-ignore: Z015 -- package-private syscall helper error set.
pub fn sendControl(
    fd: posix.socket_t,
    content_type: u8,
    bytes: []const u8,
) ControlSendError!void {
    var control: [cmsg_space]u8 align(@alignOf(linux.cmsghdr)) = @splat(0);
    const header: *linux.cmsghdr = @ptrCast(&control);
    header.* = .{
        .len = cmsg_data_offset + 1,
        .level = @intCast(ktls.SOL_TLS),
        .type = @intCast(ktls.TLS_SET_RECORD_TYPE),
    };
    control[cmsg_data_offset] = content_type;

    var iov: [1]posix.iovec_const = .{.{ .base = bytes.ptr, .len = bytes.len }};
    const msg: linux.msghdr_const = .{
        .name = null,
        .namelen = 0,
        .iov = &iov,
        .iovlen = iov.len,
        .control = &control,
        .controllen = control.len,
        .flags = 0,
    };
    const rc = linux.sendmsg(fd, &msg, linux.MSG.NOSIGNAL);
    switch (linux.errno(rc)) {
        .SUCCESS => {
            const sent: usize = @intCast(@as(isize, @bitCast(rc)));
            if (sent != bytes.len) return error.ShortControlWrite;
        },
        .AGAIN => return error.WouldBlock,
        .INTR => return error.Interrupted,
        .PIPE, .CONNRESET, .NOTCONN => return error.ConnectionClosed,
        else => return error.UnexpectedSystemError,
    }
}

pub fn recvRecord(fd: posix.socket_t, bytes: []u8) RecvError!Received {
    var control: [cmsg_space]u8 align(@alignOf(linux.cmsghdr)) = @splat(0);
    var iov: [1]posix.iovec = .{.{ .base = bytes.ptr, .len = bytes.len }};
    var msg: linux.msghdr = .{
        .name = null,
        .namelen = 0,
        .iov = &iov,
        .iovlen = iov.len,
        .control = &control,
        .controllen = control.len,
        .flags = 0,
    };
    const rc = linux.recvmsg(fd, &msg, 0);
    switch (linux.errno(rc)) {
        .SUCCESS => {},
        .AGAIN => return error.WouldBlock,
        .INTR => return error.Interrupted,
        .KEYEXPIRED => return error.KeyExpired,
        .CONNRESET, .NOTCONN => return error.ConnectionClosed,
        .IO => return error.InvalidControlMessage,
        .BADMSG => return error.BadRecord,
        .MSGSIZE => return error.RecordTooLarge,
        .INVAL => return error.InvalidRecord,
        else => return error.UnexpectedSystemError,
    }

    const len: usize = @intCast(@as(isize, @bitCast(rc)));
    return .{
        .len = len,
        .content_type = try parseControl(&control, msg.controllen, msg.flags),
    };
}

fn parseControl(
    control: *align(@alignOf(linux.cmsghdr)) const [cmsg_space]u8,
    controllen: usize,
    flags: u32,
) error{InvalidControlMessage}!?u8 {
    if (flags & (linux.MSG.CTRUNC | linux.MSG.TRUNC) != 0) {
        return error.InvalidControlMessage;
    }
    if (controllen == 0) return null;
    if (controllen < cmsg_data_offset + 1) return error.InvalidControlMessage;

    const header: *const linux.cmsghdr = @ptrCast(control);
    if (header.len < cmsg_data_offset + 1 or
        header.len > controllen or
        header.level != @as(i32, @intCast(ktls.SOL_TLS)) or
        header.type != @as(i32, @intCast(ktls.TLS_GET_RECORD_TYPE)) or
        flags & linux.MSG.EOR == 0)
    {
        return error.InvalidControlMessage;
    }
    return control[cmsg_data_offset];
}

fn testControl(record_type: u8) [cmsg_space]u8 {
    var control: [cmsg_space]u8 align(@alignOf(linux.cmsghdr)) = @splat(0);
    const header: *linux.cmsghdr = @ptrCast(&control);
    header.* = .{
        .len = cmsg_data_offset + 1,
        .level = @intCast(ktls.SOL_TLS),
        .type = @intCast(ktls.TLS_GET_RECORD_TYPE),
    };
    control[cmsg_data_offset] = record_type;
    return control;
}

test "cmsg storage matches Linux CMSG_LEN and CMSG_SPACE for one-byte record type" {
    try testing.expectEqual(
        std.mem.alignForward(usize, @sizeOf(linux.cmsghdr), @sizeOf(usize)) + 1,
        cmsg_data_offset + 1,
    );
    try testing.expectEqual(
        std.mem.alignForward(usize, cmsg_data_offset + 1, @sizeOf(usize)),
        cmsg_space,
    );
}

test "cmsg parser requires the Linux record type and end-of-record flag" {
    var control: [cmsg_space]u8 align(@alignOf(linux.cmsghdr)) = testControl(22);
    try testing.expectEqual(
        @as(?u8, 22),
        try parseControl(&control, control.len, linux.MSG.EOR),
    );
    try testing.expectEqual(
        @as(?u8, null),
        try parseControl(&control, 0, 0),
    );
    try testing.expectError(
        error.InvalidControlMessage,
        parseControl(&control, control.len, 0),
    );

    const header: *linux.cmsghdr = @ptrCast(&control);
    header.type = @intCast(ktls.TLS_SET_RECORD_TYPE);
    try testing.expectError(
        error.InvalidControlMessage,
        parseControl(&control, control.len, linux.MSG.EOR),
    );
}

test "cmsg parser rejects truncation and inconsistent lengths" {
    var control: [cmsg_space]u8 align(@alignOf(linux.cmsghdr)) = testControl(21);
    try testing.expectError(
        error.InvalidControlMessage,
        parseControl(&control, control.len, linux.MSG.EOR | linux.MSG.TRUNC),
    );
    try testing.expectError(
        error.InvalidControlMessage,
        parseControl(&control, cmsg_data_offset, linux.MSG.EOR),
    );

    const header: *linux.cmsghdr = @ptrCast(&control);
    header.len = control.len + 1;
    try testing.expectError(
        error.InvalidControlMessage,
        parseControl(&control, control.len, linux.MSG.EOR),
    );
}
