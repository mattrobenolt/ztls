const testing = @import("std").testing;

/// Per-record nonce construction for TLS 1.3.
///
/// RFC 8446 §5.3
const memx = @import("memx.zig");

const len = 12;

pub const Nonce = [len]u8;
pub const Iv = [len]u8;

const NonceVec = @Vector(len, u8);

/// Construct the per-record nonce by XORing the IV with the sequence number.
///
/// The sequence number is right-aligned as a big-endian u64 in a 12-byte
/// buffer (zero-padded on the left), then XORed with the IV.
///
/// RFC 8446 §5.3
pub fn construct(iv: *const Iv, seq: u64) Nonce {
    var padded: Nonce = @splat(0);
    padded[4..12].* = memx.toBytes(u64, seq);

    const a: NonceVec = iv.*;
    const b: NonceVec = padded;
    return a ^ b;
}

// RFC 8446 §5.3 — nonce construction
test "construct: seq 0 is just the IV" {
    const iv: Iv = .{ 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b };
    const nonce = construct(&iv, 0);
    try testing.expectEqualSlices(u8, &iv, &nonce);
}

test "construct: seq increments flip the right bytes" {
    const iv: Iv = @splat(0);
    try testing.expectEqual(
        Nonce{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
        construct(&iv, 1),
    );
    try testing.expectEqual(
        Nonce{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255 },
        construct(&iv, 255),
    );
    try testing.expectEqual(
        Nonce{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0 },
        construct(&iv, 256),
    );
}

test "construct: XOR with non-zero IV" {
    const iv: Iv = .{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
    try testing.expectEqual(
        Nonce{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe },
        construct(&iv, 1),
    );
}

test "construct: seq max u64 produces expected nonce" {
    const iv: Iv = @splat(0);
    try testing.expectEqual(
        Nonce{ 0, 0, 0, 0, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff },
        construct(&iv, 0xffffffffffffffff),
    );
}
