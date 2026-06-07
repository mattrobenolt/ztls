const testing = @import("std").testing;

pub const PendingWrite = enum {
    idle,
    pending,

    pub fn isPending(self: PendingWrite) bool {
        return self == .pending;
    }

    pub fn mark(self: *PendingWrite) void {
        self.* = .pending;
    }

    pub fn clear(self: *PendingWrite) void {
        self.* = .idle;
    }
};

test "PendingWrite: mark and clear" {
    var state: PendingWrite = .idle;
    try testing.expect(!state.isPending());
    state.mark();
    try testing.expect(state.isPending());
    state.clear();
    try testing.expect(!state.isPending());
}
