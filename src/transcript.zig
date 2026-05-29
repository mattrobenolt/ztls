/// TLS 1.3 handshake transcript hash.
///
/// A running hash over all handshake messages (4-byte header + body).
/// Used to bind the key schedule to the specific messages exchanged.
///
/// RFC 8446 §4.4.1
const std = @import("std");
const testing = std.testing;

pub const Sha256Transcript = Transcript(std.crypto.hash.sha2.Sha256);
pub const Sha384Transcript = Transcript(std.crypto.hash.sha2.Sha384);

fn Transcript(comptime Hash: type) type {
    return struct {
        const Self = @This();
        pub const digest_length = Hash.digest_length;

        hash: Hash = Hash.init(.{}),

        /// Feed a handshake message into the transcript.
        /// `msg` must include the 4-byte handshake header (type + uint24 length).
        pub fn update(self: *Self, msg: []const u8) void {
            self.hash.update(msg);
        }

        /// Return the current transcript hash without consuming the state.
        pub fn digest(self: Self) [digest_length]u8 {
            var h = self.hash; // copy — value semantics
            return h.finalResult();
        }
    };
}

// RFC 8446 §4.4.1 — transcript hash

test "Sha256Transcript: empty digest matches SHA-256(empty)" {
    const t: Sha256Transcript = .{};
    const got = t.digest();
    // SHA-256("") = e3b0c442...
    try testing.expectEqualSlices(u8, &.{
        0xe3, 0xb0, 0xc4, 0x42, 0x98, 0xfc, 0x1c, 0x14,
        0x9a, 0xfb, 0xf4, 0xc8, 0x99, 0x6f, 0xb9, 0x24,
        0x27, 0xae, 0x41, 0xe4, 0x64, 0x9b, 0x93, 0x4c,
        0xa4, 0x95, 0x99, 0x1b, 0x78, 0x52, 0xb8, 0x55,
    }, &got);
}

test "Sha256Transcript: digest does not consume state" {
    var t: Sha256Transcript = .{};
    t.update("hello");
    const first = t.digest();
    const second = t.digest();
    try testing.expectEqualSlices(u8, &first, &second);
}

test "Sha256Transcript: update is cumulative" {
    var t: Sha256Transcript = .{};
    t.update("hello");
    const after_hello = t.digest();
    t.update(" world");
    const after_world = t.digest();
    try testing.expect(!std.mem.eql(u8, &after_hello, &after_world));
}

test "Sha384Transcript: digest_length is 48" {
    try testing.expectEqual(@as(usize, 48), Sha384Transcript.digest_length);
}
