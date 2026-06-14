//! TLS 1.3 transcript utilities.
//!
//! RFC 8446 §4.4.1 — The Transcript Hash.
const std = @import("std");
const testing = std.testing;

const handshake = @import("handshake.zig");

/// Construct the synthetic "message_hash" handshake message that replaces
/// ClientHello1 in the running transcript hash when a HelloRetryRequest is
/// received.  RFC 8446 §4.4.1:
///
///   Transcript-Hash(ClientHello1, HelloRetryRequest, ... Mn) =
///       Hash(message_hash ||        /* Handshake type  0xfe  */
///            00 00 Hash.length  ||  /* Handshake body length  */
///            Hash(ClientHello1) ||  /* digest of first flight */
///            HelloRetryRequest  || ... || Mn)
///
/// `ch1_hash` must be exactly `digest_len` bytes (the output of the negotiated
/// hash over the ClientHello1 handshake message bytes).
///
/// Usage: call this after receiving the HRR but before feeding the HRR into
/// the transcript.  Reset the running hash, feed the returned synthetic message
/// into it, then continue feeding HRR and subsequent messages normally.
pub fn messageHashSynthetic(
    comptime digest_len: usize,
    ch1_hash: [digest_len]u8,
) [4 + digest_len]u8 {
    var out: [4 + digest_len]u8 = undefined;
    out[0] = @intFromEnum(handshake.Type.message_hash);
    out[1] = 0x00;
    out[2] = 0x00;
    out[3] = @intCast(digest_len); // body length: fits in one byte for SHA-256/384
    out[4..][0..digest_len].* = ch1_hash;
    return out;
}

// RFC 8446 §4.4.1 — synthetic message_hash structure.
//
// SHA-256 digest_len = 32, so the synthetic message is 36 bytes:
//   fe 00 00 20 <32-byte hash>
//
// SHA-384 digest_len = 48, so the synthetic message is 52 bytes:
//   fe 00 00 30 <48-byte hash>

test "messageHashSynthetic: SHA-256 header" {
    // The first four bytes must always be 0xfe 0x00 0x00 <len>.
    const hash: [32]u8 = @splat(0xab);
    const msg = messageHashSynthetic(32, hash);
    try testing.expectEqual(@as(usize, 36), msg.len);
    try testing.expectEqual(@intFromEnum(handshake.Type.message_hash), msg[0]);
    try testing.expectEqual(@as(u8, 0x00), msg[1]);
    try testing.expectEqual(@as(u8, 0x00), msg[2]);
    try testing.expectEqual(@as(u8, 32), msg[3]);
    try testing.expectEqualSlices(u8, &hash, msg[4..]);
}

test "messageHashSynthetic: SHA-384 header" {
    const hash: [48]u8 = @splat(0xcd);
    const msg = messageHashSynthetic(48, hash);
    try testing.expectEqual(@as(usize, 52), msg.len);
    try testing.expectEqual(@intFromEnum(handshake.Type.message_hash), msg[0]);
    try testing.expectEqual(@as(u8, 0x00), msg[2]);
    try testing.expectEqual(@as(u8, 48), msg[3]);
    try testing.expectEqualSlices(u8, &hash, msg[4..]);
}

// RFC 8446 §4.4.1 — verify against RFC 8448 §5 trace.
//
// ClientHello1 (RFC 8448 §5, 180 octets):
//   01 00 00 b0 03 03 b0 b1 c5 a5 ...
//
// SHA-256(ClientHello1) can be computed and the synthetic message must match:
//   fe 00 00 20 <sha256(CH1)>
//
// The "c hs traffic" transcript hash in RFC 8448 §5 is computed over
// message_hash(CH1) || HRR || CH2 — this test exercises only the synthetic
// message structure, not the full transcript.
test "messageHashSynthetic: RFC 8448 §5 ClientHello1 SHA-256" {
    const Sha256 = std.crypto.hash.sha2.Sha256;

    // RFC 8448 §5 — ClientHello1 payload (180 octets), handshake record body.
    const ch1: []const u8 = &.{
        0x01, 0x00, 0x00, 0xb0, 0x03, 0x03, 0xb0, 0xb1, 0xc5, 0xa5, 0xaa, 0x37, 0xc5,
        0x91, 0x9f, 0x2e, 0xd1, 0xd5, 0xc6, 0xff, 0xf7, 0xfc, 0xb7, 0x84, 0x97, 0x16,
        0x94, 0x5a, 0x2b, 0x8c, 0xee, 0x92, 0x58, 0xa3, 0x46, 0x67, 0x7b, 0x6f, 0x00,
        0x00, 0x06, 0x13, 0x01, 0x13, 0x03, 0x13, 0x02, 0x01, 0x00, 0x00, 0x81, 0x00,
        0x00, 0x00, 0x0b, 0x00, 0x09, 0x00, 0x00, 0x06, 0x73, 0x65, 0x72, 0x76, 0x65,
        0x72, 0xff, 0x01, 0x00, 0x01, 0x00, 0x00, 0x0a, 0x00, 0x08, 0x00, 0x06, 0x00,
        0x1d, 0x00, 0x17, 0x00, 0x18, 0x00, 0x33, 0x00, 0x26, 0x00, 0x24, 0x00, 0x1d,
        0x00, 0x20, 0xe8, 0xe8, 0xe3, 0xf3, 0xb9, 0x3a, 0x25, 0xed, 0x97, 0xa1, 0x4a,
        0x7d, 0xca, 0xcb, 0x8a, 0x27, 0x2c, 0x62, 0x88, 0xe5, 0x85, 0xc6, 0x48, 0x4d,
        0x05, 0x26, 0x2f, 0xca, 0xd0, 0x62, 0xad, 0x1f, 0x00, 0x2b, 0x00, 0x03, 0x02,
        0x03, 0x04, 0x00, 0x0d, 0x00, 0x20, 0x00, 0x1e, 0x04, 0x03, 0x05, 0x03, 0x06,
        0x03, 0x02, 0x03, 0x08, 0x04, 0x08, 0x05, 0x08, 0x06, 0x04, 0x01, 0x05, 0x01,
        0x06, 0x01, 0x02, 0x01, 0x04, 0x02, 0x05, 0x02, 0x06, 0x02, 0x02, 0x02, 0x00,
        0x2d, 0x00, 0x02, 0x01, 0x01, 0x00, 0x1c, 0x00, 0x02, 0x40, 0x01,
    };

    var ch1_hash: [32]u8 = undefined;
    Sha256.hash(ch1, &ch1_hash, .{});

    const msg = messageHashSynthetic(32, ch1_hash);
    // header
    try testing.expectEqual(@intFromEnum(handshake.Type.message_hash), msg[0]);
    try testing.expectEqual(@as(u8, 0x00), msg[1]);
    try testing.expectEqual(@as(u8, 0x00), msg[2]);
    try testing.expectEqual(@as(u8, 32), msg[3]);
    // body must be exactly Hash(CH1)
    try testing.expectEqualSlices(u8, &ch1_hash, msg[4..]);
}
