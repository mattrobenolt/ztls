//! Transport-agnostic helper for draining one engine-produced TLS record.
//!
//! Outbox does no I/O itself. Callers provide a tiny writer adapter with
//! `write(bytes) !usize`; returning 0 means the transport made no progress
//! (for example, WouldBlock). The queued record slice is borrowed and must stay
//! valid until `writeBlocked()` becomes false.
const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;

pub const FlushResult = enum {
    drained,
    pending,
};

pub const Error = error{
    PendingWrite,
    WriteOverflow,
};

pending: []const u8 = "",

pub const init: Outbox = .{};

const Outbox = @This();

/// True while a TLS record has not been fully accepted by the transport. While
/// blocked, callers must not feed another record-producing call to the engine.
pub fn writeBlocked(self: *const Outbox) bool {
    return self.pending.len != 0;
}

/// Queue one engine-produced TLS record and immediately try to flush it.
/// `record` is borrowed and must stay valid until this outbox drains. Returns
/// `error.PendingWrite` if another record is still blocked.
pub fn send(
    self: *Outbox,
    hs: anytype,
    record: []const u8,
    writer: anytype,
) (Error || WriteErrorSet(@TypeOf(writer)))!FlushResult {
    try self.queue(record);
    return self.flush(hs, writer);
}

fn queue(self: *Outbox, record: []const u8) Error!void {
    if (self.writeBlocked()) return error.PendingWrite;
    self.pending = record;
}

/// Flush queued bytes through `writer.write(bytes) !usize`.
///
/// Calls `hs.completeWrite()` exactly once, and only after every queued byte has
/// been accepted. On writer error or zero-byte progress, the pending tail is
/// preserved and the engine remains write-blocked. `hs` must be a mutable
/// handshake pointer, not a value.
pub fn flush(
    self: *Outbox,
    hs: anytype,
    writer: anytype,
) (Error || WriteErrorSet(@TypeOf(writer)))!FlushResult {
    comptime requireHandshakePointer(@TypeOf(hs));

    if (self.pending.len == 0) return .drained;

    while (self.pending.len > 0) {
        const n = try writer.write(self.pending);
        if (n == 0) return .pending;
        if (n > self.pending.len) return error.WriteOverflow;
        self.pending = self.pending[n..];
    }

    hs.completeWrite();
    return .drained;
}

fn requireHandshakePointer(comptime T: type) void {
    switch (@typeInfo(T)) {
        .pointer => |ptr| {
            if (ptr.size != .one or ptr.is_const)
                @compileError("Outbox expects a mutable *Handshake pointer");
        },
        else => @compileError("Outbox expects a mutable *Handshake pointer"),
    }
}

fn requireWriter(comptime Writer: type) void {
    if (!@hasDecl(Writer, "write"))
        @compileError("Outbox writer must expose write([]const u8) !usize");
    const write_info = @typeInfo(@TypeOf(Writer.write)).@"fn";
    if (write_info.params.len != 2)
        @compileError("Outbox writer write method must take self and []const u8");
    const bytes_type = write_info.params[1].type orelse
        @compileError("Outbox writer write method must take []const u8");
    if (bytes_type != []const u8)
        @compileError("Outbox writer write method must take []const u8");
    const write_return = write_info.return_type orelse
        @compileError("Outbox writer write method must return !usize");
    switch (@typeInfo(write_return)) {
        .error_union => |err| if (err.payload != usize)
            @compileError("Outbox writer write method must return !usize"),
        else => @compileError("Outbox writer write method must return !usize"),
    }
}

fn WriteErrorSet(comptime WriterParam: type) type {
    const Writer = switch (@typeInfo(WriterParam)) {
        .pointer => |ptr| ptr.child,
        else => WriterParam,
    };
    comptime requireWriter(Writer);
    const write_return = @typeInfo(@TypeOf(Writer.write)).@"fn".return_type.?;
    return @typeInfo(write_return).error_union.error_set;
}

const FakeHandshake = struct {
    complete_write_calls: usize = 0,

    pub fn completeWrite(self: *FakeHandshake) void {
        self.complete_write_calls += 1;
    }
};

const WriterError = error{Failed};

const StepWriter = struct {
    steps: []const usize,
    index: usize = 0,
    fail_at: ?usize = null,
    captured: [128]u8 = undefined,
    captured_len: usize = 0,

    fn write(self: *StepWriter, bytes: []const u8) WriterError!usize {
        if (self.fail_at == self.index) return error.Failed;
        const n = if (self.index < self.steps.len) self.steps[self.index] else bytes.len;
        self.index += 1;
        assert(n <= bytes.len);
        @memcpy(self.captured[self.captured_len..][0..n], bytes[0..n]);
        self.captured_len += n;
        return n;
    }
};

const OverflowWriter = struct {
    fn write(_: OverflowWriter, bytes: []const u8) WriterError!usize {
        return bytes.len + 1;
    }
};

test "Outbox: fresh outbox is not write-blocked" {
    const outbox: Outbox = .{};
    try testing.expect(!outbox.writeBlocked());
}

test "Outbox: send drains fully and completes write once" {
    var outbox: Outbox = .{};
    var hs: FakeHandshake = .{};
    var writer: StepWriter = .{ .steps = &.{5} };

    try testing.expectEqual(.drained, try outbox.send(&hs, "hello", &writer));
    try testing.expect(!outbox.writeBlocked());
    try testing.expectEqual(@as(usize, 1), hs.complete_write_calls);
    try testing.expectEqualStrings("hello", writer.captured[0..writer.captured_len]);
}

test "Outbox: partial send stays blocked and does not complete write" {
    var outbox: Outbox = .{};
    var hs: FakeHandshake = .{};
    var writer: StepWriter = .{ .steps = &.{ 2, 0 } };

    try testing.expectEqual(.pending, try outbox.send(&hs, "hello", &writer));
    try testing.expect(outbox.writeBlocked());
    try testing.expectEqual(@as(usize, 0), hs.complete_write_calls);
    try testing.expectEqualStrings("he", writer.captured[0..writer.captured_len]);
}

test "Outbox: zero-byte progress stays blocked" {
    var outbox: Outbox = .{};
    var hs: FakeHandshake = .{};
    var writer: StepWriter = .{ .steps = &.{0} };

    try testing.expectEqual(.pending, try outbox.send(&hs, "hello", &writer));
    try testing.expect(outbox.writeBlocked());
    try testing.expectEqual(@as(usize, 0), hs.complete_write_calls);
    try testing.expectEqual(@as(usize, 0), writer.captured_len);
}

test "Outbox: idle flush is drained without completing write" {
    var outbox: Outbox = .{};
    var hs: FakeHandshake = .{};
    var writer: StepWriter = .{ .steps = &.{} };

    try testing.expectEqual(.drained, try outbox.flush(&hs, &writer));
    try testing.expectEqual(@as(usize, 0), hs.complete_write_calls);
}

test "Outbox: partial drain resumes across flush calls" {
    var outbox: Outbox = .{};
    var hs: FakeHandshake = .{};
    var writer: StepWriter = .{ .steps = &.{ 2, 0, 0, 3 } };

    try testing.expectEqual(.pending, try outbox.send(&hs, "hello", &writer));
    try testing.expectEqual(.pending, try outbox.flush(&hs, &writer));
    try testing.expectEqual(@as(usize, 0), hs.complete_write_calls);
    try testing.expectEqual(.drained, try outbox.flush(&hs, &writer));
    try testing.expect(!outbox.writeBlocked());
    try testing.expectEqual(@as(usize, 1), hs.complete_write_calls);
    try testing.expectEqualStrings("hello", writer.captured[0..writer.captured_len]);
}

test "Outbox: queue while blocked returns PendingWrite" {
    var outbox: Outbox = .{};
    try outbox.queue("one");
    try testing.expectError(error.PendingWrite, outbox.queue("two"));
}

test "Outbox: writer error leaves pending tail and does not complete write" {
    var outbox: Outbox = .{};
    var hs: FakeHandshake = .{};
    var writer: StepWriter = .{ .steps = &.{ 2, 0 }, .fail_at = 2 };

    try testing.expectEqual(.pending, try outbox.send(&hs, "hello", &writer));
    try testing.expectError(error.Failed, outbox.flush(&hs, &writer));
    try testing.expect(outbox.writeBlocked());
    try testing.expectEqual(@as(usize, 0), hs.complete_write_calls);
}

test "Outbox: writer over-reporting bytes returns WriteOverflow" {
    var outbox: Outbox = .{};
    var hs: FakeHandshake = .{};

    const writer: OverflowWriter = .{};
    try testing.expectError(error.WriteOverflow, outbox.send(&hs, "hello", writer));
    try testing.expect(outbox.writeBlocked());
    try testing.expectEqual(@as(usize, 0), hs.complete_write_calls);
}

test "Outbox: sequential records complete once each" {
    var outbox: Outbox = .{};
    var hs: FakeHandshake = .{};
    var writer: StepWriter = .{ .steps = &.{ 3, 3 } };

    try testing.expectEqual(.drained, try outbox.send(&hs, "one", &writer));
    try testing.expectEqual(.drained, try outbox.send(&hs, "two", &writer));
    try testing.expectEqual(@as(usize, 2), hs.complete_write_calls);
    try testing.expectEqualStrings("onetwo", writer.captured[0..writer.captured_len]);
}
