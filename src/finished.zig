/// TLS 1.3 Finished handshake message — verify and encode.
///
/// RFC 8446 §4.4.4
const std = @import("std");
const crypto = std.crypto;
const Sha256 = crypto.hash.sha2.Sha256;
const testing = std.testing;

const wire = @import("wire.zig");

pub const VerifyError = error{
    UnexpectedEof,
    InvalidHandshakeType,
    InvalidVerifyData,
};

/// Verify a server Finished handshake message under the negotiated transcript
/// hash. `finished_key` is derived from the server handshake traffic secret via
/// hkdf.finishedKey(); `transcript_hash` covers all messages up to and
/// including CertificateVerify. The verify_data length is the hash's output
/// (32 bytes SHA-256, 48 SHA-384). RFC 8446 §4.4.4
pub fn verify(
    comptime Hash: type,
    msg: []const u8,
    finished_key: []const u8,
    transcript_hash: []const u8,
) VerifyError!void {
    const Hmac = crypto.auth.hmac.Hmac(Hash);
    const Digest = [Hmac.mac_length]u8;

    var r: wire.Reader = .init(msg);
    const handshake_type = try r.read(u8);
    if (handshake_type != 0x14) return error.InvalidHandshakeType;
    try r.skip(3);
    const verify_data = r.remaining();

    // Recompute: HMAC(finished_key, transcript_hash)
    var expected: Digest = undefined;
    Hmac.create(&expected, transcript_hash, finished_key);

    if (verify_data.len != expected.len) return error.InvalidVerifyData;
    if (!crypto.timing_safe.eql(Digest, verify_data[0..Hmac.mac_length].*, expected))
        return error.InvalidVerifyData;
}

/// Encode a client Finished handshake message into `out` under the negotiated
/// transcript hash. `finished_key` is derived from the client handshake traffic
/// secret via hkdf.finishedKey(); `transcript_hash` covers all messages up to
/// and including the server's Finished. RFC 8446 §4.4.4
pub fn encode(
    comptime Hash: type,
    out: []u8,
    finished_key: []const u8,
    transcript_hash: []const u8,
) error{BufferTooShort}![]u8 {
    const Hmac = crypto.auth.hmac.Hmac(Hash);
    const total = 4 + Hmac.mac_length; // header(4) + verify_data
    if (out.len < total) return error.BufferTooShort;

    var w: wire.Writer = .init(out);
    w.append(u8, 0x14); // Finished
    w.append(u24, Hmac.mac_length);
    Hmac.create(w.reserve(Hmac.mac_length), transcript_hash, finished_key);
    return w.written();
}

// RFC 8446 §4.4.4
// Test vectors from RFC 8448 §3.
// server_handshake_traffic_secret:
//   b67b7d690cc16c4e75e54213cb2d37b4e9c912bcded9105d42befd59d391ad38
// finished_key:
//   008d3b66f816ea559f96b537e885c31fc068bf492c652f01f288a1d8cdc19fc8
// transcript hash (all messages through CertificateVerify):
//   96081...df13  (from RFC 8448)
// expected verify_data:
//   9b9b141d906337fbd2cbdce71df4deda4ab42c309572cb7fffee5454b78f0718

const server_finished_key: [32]u8 = .{
    0x00, 0x8d, 0x3b, 0x66, 0xf8, 0x16, 0xea, 0x55,
    0x9f, 0x96, 0xb5, 0x37, 0xe8, 0x85, 0xc3, 0x1f,
    0xc0, 0x68, 0xbf, 0x49, 0x2c, 0x65, 0x2f, 0x01,
    0xf2, 0x88, 0xa1, 0xd8, 0xcd, 0xc1, 0x9f, 0xc8,
};

const server_transcript_hash: [32]u8 = .{
    0x96, 0x08, 0x10, 0x2a, 0x0f, 0x1c, 0xcc, 0x6d,
    0xb6, 0x25, 0x0b, 0x7b, 0x7e, 0x41, 0x7b, 0x1a,
    0x00, 0x0e, 0xaa, 0xda, 0x3d, 0xaa, 0xe4, 0x77,
    0x7a, 0x76, 0x86, 0xc9, 0xff, 0x83, 0xdf, 0x13,
};

const finished_msg: [36]u8 = .{
    0x14, 0x00, 0x00, 0x20,
    0x9b, 0x9b, 0x14, 0x1d,
    0x90, 0x63, 0x37, 0xfb,
    0xd2, 0xcb, 0xdc, 0xe7,
    0x1d, 0xf4, 0xde, 0xda,
    0x4a, 0xb4, 0x2c, 0x30,
    0x95, 0x72, 0xcb, 0x7f,
    0xff, 0xee, 0x54, 0x54,
    0xb7, 0x8f, 0x07, 0x18,
};

test "verify: wrong verify_data" {
    var bad = finished_msg;
    bad[4] ^= 0xff;
    try testing.expectError(
        error.InvalidVerifyData,
        verify(Sha256, &bad, &server_finished_key, &server_transcript_hash),
    );
}

test "verify: wrong handshake type" {
    var bad = finished_msg;
    bad[0] = 0x01;
    try testing.expectError(
        error.InvalidHandshakeType,
        verify(Sha256, &bad, &server_finished_key, &server_transcript_hash),
    );
}

test "encode then verify round-trip" {
    const key = server_finished_key;
    const hash = server_transcript_hash;
    var buf: [64]u8 = undefined;
    const msg = try encode(Sha256, &buf, &key, &hash);
    try verify(Sha256, msg, &key, &hash);
}
