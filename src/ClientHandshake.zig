/// TLS 1.3 client handshake state machine.
///
/// Owns the running transcript hash and drives the handshake message sequence.
/// Does no I/O: the caller feeds in decrypted record bytes and receives bytes
/// to send. RFC 8446 §4, Appendix A.
const std = @import("std");
const Sha256 = std.crypto.hash.sha2.Sha256;
const testing = std.testing;

const hkdf = @import("hkdf.zig");
const RecordLayer = @import("RecordLayer.zig");
const SharedSecret = hkdf.SharedSecret;

const ClientHandshake = @This();

/// The handshake-traffic RecordLayers derived once the key exchange completes.
/// `rx` decrypts the server's flight (server handshake traffic secret);
/// `tx` encrypts our Finished (client handshake traffic secret).
pub const HandshakeKeys = struct {
    rx: RecordLayer,
    tx: RecordLayer,
};

/// RFC 8446 Appendix A.1 — client state machine, trimmed to the flows we
/// support (full 1-RTT handshake, no PSK, no client auth, no HelloRetryRequest).
pub const State = enum {
    start,
    wait_sh,
    wait_ee,
    wait_cert,
    wait_cv,
    wait_finished,
    connected,
};

/// Hash-parameterized handshake state. Each arm carries every secret whose
/// size depends on the negotiated hash, sealing the size polymorphism inside
/// the union so the rest of ClientHandshake stays hash-agnostic.
///
/// Only the SHA-256 suite exists today. SHA-384 becomes a second arm carrying
/// Sha384 + HkdfSha384.Prk-sized fields; all callers switch in one place.
const Suite = union(enum) {
    sha256: struct {
        transcript: Sha256,
        handshake_secret: hkdf.HkdfSha256.Prk = undefined,
        client_finished_key: hkdf.HkdfSha256.Prk = undefined,
        server_finished_key: hkdf.HkdfSha256.Prk = undefined,
    },

    /// Feed one handshake message (4-byte header + body, no record framing)
    /// into the running transcript hash. RFC 8446 §4.4.1.
    fn update(self: *Suite, msg: []const u8) void {
        switch (self.*) {
            .sha256 => |*s| s.transcript.update(msg),
        }
    }

    /// Snapshot the transcript without disturbing the running hash. peek()
    /// copies the hasher by value and finalizes the copy, so the live hash
    /// keeps absorbing.
    ///
    /// Returns a concrete digest for now so chunk-1 tests can check it against
    /// RFC 8448. Once key-schedule derivation moves into the arm, the digest
    /// stops escaping and this becomes internal.
    fn transcriptHash(self: Suite) [Sha256.digest_length]u8 {
        return switch (self) {
            .sha256 => |s| s.transcript.peek(),
        };
    }

    /// RFC 8446 §7.1 — mix the DHE shared secret into the key schedule and
    /// derive the handshake-traffic keys. Call once, after the transcript has
    /// absorbed ClientHello and ServerHello.
    ///
    /// Snapshots the transcript at the ServerHello point and derives every
    /// secret rooted there — traffic keys and both finished keys — because the
    /// running hash moves on and cannot be rewound. The handshake secret and
    /// finished keys are retained in the arm; the RecordLayers are returned.
    fn deriveHandshakeKeys(self: *Suite, dhe: *const SharedSecret) HandshakeKeys {
        switch (self.*) {
            .sha256 => |*s| {
                const H = hkdf.HkdfSha256;
                s.handshake_secret = H.handshakeSecret(H.early_secret, dhe);

                const th = s.transcript.peek();
                const client_secret = H.clientHandshakeTrafficSecret(s.handshake_secret, &.init(th));
                const server_secret = H.serverHandshakeTrafficSecret(s.handshake_secret, &.init(th));

                s.client_finished_key = H.finishedKey(client_secret);
                s.server_finished_key = H.finishedKey(server_secret);

                return .{
                    .rx = H.makeRecordLayer(.aes128_gcm, server_secret),
                    .tx = H.makeRecordLayer(.aes128_gcm, client_secret),
                };
            },
        }
    }
};

state: State,
suite: Suite,

/// Start a client handshake. The negotiated suite is hardcoded to SHA-256
/// for now; suite selection moves to ServerHello processing in a later chunk.
pub const init: ClientHandshake = .{
    .state = .start,
    .suite = .{ .sha256 = .{ .transcript = .init(.{}) } },
};

// RFC 8448 §3 raw handshake messages (4-byte handshake header included, no
// record framing), shared across the transcript and key-schedule tests.
const rfc8448_client_hello = [_]u8{
        0x01, 0x00, 0x00, 0xc0, 0x03, 0x03, 0xcb, 0x34,
        0xec, 0xb1, 0xe7, 0x81, 0x63, 0xba, 0x1c, 0x38,
        0xc6, 0xda, 0xcb, 0x19, 0x6a, 0x6d, 0xff, 0xa2,
        0x1a, 0x8d, 0x99, 0x12, 0xec, 0x18, 0xa2, 0xef,
        0x62, 0x83, 0x02, 0x4d, 0xec, 0xe7, 0x00, 0x00,
        0x06, 0x13, 0x01, 0x13, 0x03, 0x13, 0x02, 0x01,
        0x00, 0x00, 0x91, 0x00, 0x00, 0x00, 0x0b, 0x00,
        0x09, 0x00, 0x00, 0x06, 0x73, 0x65, 0x72, 0x76,
        0x65, 0x72, 0xff, 0x01, 0x00, 0x01, 0x00, 0x00,
        0x0a, 0x00, 0x14, 0x00, 0x12, 0x00, 0x1d, 0x00,
        0x17, 0x00, 0x18, 0x00, 0x19, 0x01, 0x00, 0x01,
        0x01, 0x01, 0x02, 0x01, 0x03, 0x01, 0x04, 0x00,
        0x23, 0x00, 0x00, 0x00, 0x33, 0x00, 0x26, 0x00,
        0x24, 0x00, 0x1d, 0x00, 0x20, 0x99, 0x38, 0x1d,
        0xe5, 0x60, 0xe4, 0xbd, 0x43, 0xd2, 0x3d, 0x8e,
        0x43, 0x5a, 0x7d, 0xba, 0xfe, 0xb3, 0xc0, 0x6e,
        0x51, 0xc1, 0x3c, 0xae, 0x4d, 0x54, 0x13, 0x69,
        0x1e, 0x52, 0x9a, 0xaf, 0x2c, 0x00, 0x2b, 0x00,
        0x03, 0x02, 0x03, 0x04, 0x00, 0x0d, 0x00, 0x20,
        0x00, 0x1e, 0x04, 0x03, 0x05, 0x03, 0x06, 0x03,
        0x02, 0x03, 0x08, 0x04, 0x08, 0x05, 0x08, 0x06,
        0x04, 0x01, 0x05, 0x01, 0x06, 0x01, 0x02, 0x01,
        0x04, 0x02, 0x05, 0x02, 0x06, 0x02, 0x02, 0x02,
    0x00, 0x2d, 0x00, 0x02, 0x01, 0x01, 0x00, 0x1c,
    0x00, 0x02, 0x40, 0x01,
};

const rfc8448_server_hello = [_]u8{
        0x02, 0x00, 0x00, 0x56, 0x03, 0x03, 0xa6, 0xaf,
        0x06, 0xa4, 0x12, 0x18, 0x60, 0xdc, 0x5e, 0x6e,
        0x60, 0x24, 0x9c, 0xd3, 0x4c, 0x95, 0x93, 0x0c,
        0x8a, 0xc5, 0xcb, 0x14, 0x34, 0xda, 0xc1, 0x55,
        0x77, 0x2e, 0xd3, 0xe2, 0x69, 0x28, 0x00, 0x13,
        0x01, 0x00, 0x00, 0x2e, 0x00, 0x33, 0x00, 0x24,
        0x00, 0x1d, 0x00, 0x20, 0xc9, 0x82, 0x88, 0x76,
        0x11, 0x20, 0x95, 0xfe, 0x66, 0x76, 0x2b, 0xdb,
        0xf7, 0xc6, 0x72, 0xe1, 0x56, 0xd6, 0xcc, 0x25,
        0x3b, 0x83, 0x3d, 0xf1, 0xdd, 0x69, 0xb1, 0xb0,
    0x4e, 0x75, 0x1f, 0x0f, 0x00, 0x2b, 0x00, 0x02,
    0x03, 0x04,
};

// RFC 8446 §4.4.1 — Transcript-Hash over handshake messages.
// Vector from RFC 8448 §3 (simple 1-RTT handshake, TLS_AES_128_GCM_SHA256):
// SHA-256(ClientHello || ServerHello) =
//   860c06edc07858ee8e78f0e7428c58edd6b43f2ca3e6e95f02ed063cf0e1cad8
test "transcript hash: RFC 8448 §3 ClientHello || ServerHello" {
    var hs: ClientHandshake = .init;
    hs.suite.update(&rfc8448_client_hello);
    hs.suite.update(&rfc8448_server_hello);

    try testing.expectEqualSlices(u8, &.{
        0x86, 0x0c, 0x06, 0xed, 0xc0, 0x78, 0x58, 0xee,
        0x8e, 0x78, 0xf0, 0xe7, 0x42, 0x8c, 0x58, 0xed,
        0xd6, 0xb4, 0x3f, 0x2c, 0xa3, 0xe6, 0xe9, 0x5f,
        0x02, 0xed, 0x06, 0x3c, 0xf0, 0xe1, 0xca, 0xd8,
    }, &hs.suite.transcriptHash());
}

// RFC 8446 §7.1 — handshake key schedule driven by the live transcript.
// Vectors from RFC 8448 §3. The DHE shared secret and the resulting server
// handshake write_key / write_iv and server finished_key are ground truth.
test "deriveHandshakeKeys: RFC 8448 §3 server handshake key/iv/finished" {
    const dhe: SharedSecret = .init(.{
        0x8b, 0xd4, 0x05, 0x4f, 0xb5, 0x5b, 0x9d, 0x63,
        0xfd, 0xfb, 0xac, 0xf9, 0xf0, 0x4b, 0x9f, 0x0d,
        0x35, 0xe6, 0xd6, 0x3f, 0x53, 0x75, 0x63, 0xef,
        0xd4, 0x62, 0x72, 0x90, 0x0f, 0x89, 0x49, 0x2d,
    });

    var hs: ClientHandshake = .init;
    hs.suite.update(&rfc8448_client_hello);
    hs.suite.update(&rfc8448_server_hello);

    const keys = hs.suite.deriveHandshakeKeys(&dhe);

    // server_write_key
    try testing.expectEqualSlices(u8, &.{
        0x3f, 0xce, 0x51, 0x60, 0x09, 0xc2, 0x17, 0x27,
        0xd0, 0xf2, 0xe4, 0xe8, 0x6e, 0xe4, 0x03, 0xbc,
    }, &keys.rx.aead.aes128_gcm.data);
    // server_write_iv
    try testing.expectEqualSlices(u8, &.{
        0x5d, 0x31, 0x3e, 0xb2, 0x67, 0x12, 0x76, 0xee,
        0x13, 0x00, 0x0b, 0x30,
    }, &keys.rx.iv.data);
    // server finished_key (retained in the arm)
    try testing.expectEqualSlices(u8, &.{
        0x00, 0x8d, 0x3b, 0x66, 0xf8, 0x16, 0xea, 0x55,
        0x9f, 0x96, 0xb5, 0x37, 0xe8, 0x85, 0xc3, 0x1f,
        0xc0, 0x68, 0xbf, 0x49, 0x2c, 0x65, 0x2f, 0x01,
        0xf2, 0x88, 0xa1, 0xd8, 0xcd, 0xc1, 0x9f, 0xc8,
    }, &hs.suite.sha256.server_finished_key.data);
}
