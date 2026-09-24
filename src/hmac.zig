//! HMAC keyed once, reused for many messages (RFC 2104 §2, #138).
//!
//! `init` absorbs the key-derived inner and outer pad blocks. Each `mac` then
//! copies those two states, so it costs two compressions instead of four. The
//! TLS 1.3 key schedule expands several labels from one secret. Keying once
//! per secret removes two compressions from every expand after the first.
//!
//! The pad states are key-equivalent secrets. Keep a value of this type on
//! the stack of one derivation, never in a struct that outlives the call, and
//! wipe it with `secureZero` in a `defer`. `mac` wipes its own working copies.
const std = @import("std");
const crypto = std.crypto;
const mem = std.mem;

pub fn Hmac(comptime Hash: type) type {
    return struct {
        const Self = @This();
        pub const mac_length = Hash.digest_length;

        inner: Hash,
        outer: Hash,

        pub fn init(key: []const u8) Self {
            // RFC 2104 §2: a key longer than the block is hashed first.
            var digest: [mac_length]u8 = undefined;
            defer wipe(&digest);
            const k = if (key.len > Hash.block_length) blk: {
                Hash.hash(key, &digest, .{});
                break :blk &digest;
            } else key;

            var pad: [Hash.block_length]u8 = @splat(0x36);
            defer wipe(&pad);
            for (pad[0..k.len], k) |*p, b| p.* ^= b;
            var self: Self = .{ .inner = .init(.{}), .outer = .init(.{}) };
            self.inner.update(&pad);
            for (&pad) |*p| p.* ^= 0x36 ^ 0x5c;
            self.outer.update(&pad);
            return self;
        }

        /// HMAC(key, parts[0] || parts[1] || ...). `parts` is a tuple of
        /// byte slices, so a message in pieces needs no copy.
        pub fn mac(self: *const Self, out: *[mac_length]u8, parts: anytype) void {
            var h = self.inner;
            defer wipe(mem.asBytes(&h));
            inline for (parts) |part| h.update(part);
            var inner_digest: [mac_length]u8 = undefined;
            defer wipe(&inner_digest);
            h.final(&inner_digest);
            h = self.outer;
            h.update(&inner_digest);
            h.final(out);
        }

        /// One-shot HMAC. The keyed state never leaves this call.
        pub fn create(out: *[mac_length]u8, msg: []const u8, key: []const u8) void {
            var self: Self = .init(key);
            defer self.secureZero();
            self.mac(out, .{msg});
        }

        pub fn secureZero(self: *Self) void {
            wipe(mem.asBytes(self));
        }
    };
}

// The comptime key-schedule constants in hkdf.zig run this code at comptime,
// where a volatile store is not allowed and a wipe has no meaning.
pub inline fn wipe(bytes: []u8) void {
    if (!@inComptime()) crypto.secureZero(u8, bytes);
}

const testing = std.testing;
const sha2 = @import("crypto/backend.zig").sha2;

const hmac_pairs = .{
    .{ Hmac(sha2.Sha256), crypto.auth.hmac.sha2.HmacSha256 },
    .{ Hmac(sha2.Sha384), crypto.auth.hmac.sha2.HmacSha384 },
    .{ Hmac(crypto.hash.sha2.Sha256), crypto.auth.hmac.sha2.HmacSha256 },
    .{ Hmac(crypto.hash.sha2.Sha384), crypto.auth.hmac.sha2.HmacSha384 },
};

// RFC 2104 §2 — HMAC over keys shorter than, equal to, and longer than the
// block (a long key is hashed first), and over empty and multi-block
// messages. Both the backend hash and std hash instantiations match
// std.crypto.auth.hmac.
test "Hmac matches std HMAC for every key and message length class" {
    var buf: [300]u8 = undefined;
    var prng: std.Random.DefaultPrng = .init(0x1382);
    prng.random().bytes(&buf);
    inline for (hmac_pairs) |pair| {
        const K, const Ref = pair;
        const key_lengths = [_]usize{ 0, 1, 32, 48, 64, 65, 128, 129, 300 };
        const msg_lengths = [_]usize{ 0, 1, 55, 56, 64, 111, 112, 128, 300 };
        for (key_lengths) |key_len| for (msg_lengths) |msg_len| {
            var got: [K.mac_length]u8 = undefined;
            var want: [Ref.mac_length]u8 = undefined;
            K.create(&got, buf[0..msg_len], buf[0..key_len]);
            Ref.create(&want, buf[0..msg_len], buf[0..key_len]);
            try testing.expectEqualSlices(u8, &want, &got);
        };
    }
}

// RFC 2104 §2 — one keyed state serves many messages. Each mac matches a
// fresh one-shot HMAC, a message split into parts matches the joined
// message, and the keyed state does not change between macs.
test "Hmac keyed once gives the same MAC for every reuse and every split" {
    var buf: [200]u8 = undefined;
    var prng: std.Random.DefaultPrng = .init(0x13820);
    prng.random().bytes(&buf);
    inline for (hmac_pairs) |pair| {
        const K, const Ref = pair;
        const key = buf[0..K.mac_length];
        var keyed: K = .init(key);
        defer keyed.secureZero();
        const before = keyed;
        for ([_]usize{ 0, 13, 55, 64, 150 }) |split| {
            const msg = buf[40..];
            var want: [Ref.mac_length]u8 = undefined;
            Ref.create(&want, msg, key);
            var joined: [K.mac_length]u8 = undefined;
            keyed.mac(&joined, .{msg});
            var parts: [K.mac_length]u8 = undefined;
            keyed.mac(&parts, .{ msg[0..split], msg[split..] });
            try testing.expectEqualSlices(u8, &want, &joined);
            try testing.expectEqualSlices(u8, &want, &parts);
        }
        try testing.expectEqualSlices(u8, mem.asBytes(&before), mem.asBytes(&keyed));
    }
}

// The pad states are key-equivalent secrets: secureZero clears every byte.
test "Hmac secureZero clears both pad states" {
    var keyed: Hmac(sha2.Sha384) = .init("key");
    keyed.secureZero();
    for (mem.asBytes(&keyed)) |b| try testing.expectEqual(@as(u8, 0), b);
}
