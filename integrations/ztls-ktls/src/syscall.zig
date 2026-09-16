const std = @import("std");
const testing = std.testing;
const posix = std.posix;
const linux = std.os.linux;
const ktls = @import("ztls").ktls;

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
    var control: ktls.ControlBuffer = .{};
    const encoded = ktls.encodeRecordType(&control, content_type);

    var iov: [1]posix.iovec_const = .{.{ .base = bytes.ptr, .len = bytes.len }};
    const msg: linux.msghdr_const = .{
        .name = null,
        .namelen = 0,
        .iov = &iov,
        .iovlen = iov.len,
        .control = encoded.ptr,
        .controllen = encoded.len,
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
    var control: ktls.ControlBuffer = .{};
    var iov: [1]posix.iovec = .{.{ .base = bytes.ptr, .len = bytes.len }};
    var msg: linux.msghdr = .{
        .name = null,
        .namelen = 0,
        .iov = &iov,
        .iovlen = iov.len,
        .control = &control.bytes,
        .controllen = control.bytes.len,
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
    // controllen is kernel-reported in-out: it cannot exceed the buffer
    // handed in, but treat a violation as a contract failure, never a slice
    // panic.
    if (msg.controllen > control.bytes.len) return error.InvalidControlMessage;
    const content_type = try ktls.parseRecordType(
        control.bytes[0..msg.controllen],
        msg.flags,
    );
    return .{
        .len = len,
        .content_type = try eorChecked(content_type, msg.flags),
    };
}

/// kTLS attaches the record-type cmsg to the first chunk of a record and
/// sets MSG_EOR only on the recv that consumes its final byte, so the core
/// parser deliberately does not require EOR. This integration reads into a
/// buffer that holds one maximum plaintext record — a split record can
/// never be reassembled — so a report without EOR is a contract violation
/// here. That guard is caller policy, as the core parser's contract intends.
fn eorChecked(content_type: ?u8, flags: u32) error{InvalidControlMessage}!?u8 {
    if (content_type != null and flags & linux.MSG.EOR == 0) {
        return error.InvalidControlMessage;
    }
    return content_type;
}

test "record reports require MSG_EOR in this integration" {
    try testing.expectEqual(@as(?u8, 22), try eorChecked(22, linux.MSG.EOR));
    try testing.expectEqual(@as(?u8, null), try eorChecked(null, 0));
    try testing.expectError(
        error.InvalidControlMessage,
        eorChecked(22, 0),
    );
}
