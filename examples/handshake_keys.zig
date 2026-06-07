/// Demonstrates the TLS 1.3 key exchange pipeline:
///
///   X25519 keypair → ClientHello → ServerHello → DHE shared secret
///     → HKDF key schedule → traffic secrets → RecordLayer
///
/// Uses known values from RFC 8448 §3 throughout so every intermediate
/// value can be cross-referenced against the spec.
const std = @import("std");
const print = std.debug.print;

const ztls = @import("ztls");

pub fn main() !void {
    // ── X25519 key exchange ──────────────────────

    // Use the RFC 8448 §3 client private key for deterministic output.
    const kp: ztls.x25519.KeyPair = .{
        .secret_key = .init(.{
            0x49, 0xaf, 0x42, 0xba, 0x7f, 0x79, 0x94, 0x85,
            0x2d, 0x71, 0x3e, 0xf2, 0x78, 0x4b, 0xcb, 0xca,
            0xa7, 0x91, 0x1d, 0xe2, 0x6a, 0xdc, 0x56, 0x42,
            0xcb, 0x63, 0x45, 0x40, 0xe7, 0xea, 0x50, 0x05,
        }),
        .public_key = .init(.{
            0x99, 0x38, 0x1d, 0xe5, 0x60, 0xe4, 0xbd, 0x43,
            0xd2, 0x3d, 0x8e, 0x43, 0x5a, 0x7d, 0xba, 0xfe,
            0xb3, 0xc0, 0x6e, 0x51, 0xc1, 0x3c, 0xae, 0x4d,
            0x54, 0x13, 0x69, 0x1e, 0x52, 0x9a, 0xaf, 0x2c,
        }),
    };

    // ── ClientHello ────────────────────────

    const random: ztls.client_hello.Random = .init(.{
        0xcb, 0x34, 0xec, 0xb1, 0xe7, 0x81, 0x63, 0xba,
        0x1c, 0x38, 0xc6, 0xda, 0xcb, 0x19, 0x6a, 0x6d,
        0xff, 0xa2, 0x1a, 0x8d, 0x99, 0x12, 0xec, 0x18,
        0xa2, 0xef, 0x62, 0x83, 0x02, 0x4d, 0xec, 0xe7,
    });

    var ch_buf: [512]u8 = undefined;
    const client_hello = try ztls.client_hello.encode(
        &ch_buf,
        random,
        kp.public_key,
        "server",
        &.{},
    );
    print("ClientHello: {} bytes\n", .{client_hello.len});

    // ── ServerHello ────────────────────────

    const server_hello_bytes: []const u8 = &.{
        0x02, 0x00, 0x00, 0x56, 0x03, 0x03, 0xa6, 0xaf, 0x06, 0xa4, 0x12, 0x18, 0x60,
        0xdc, 0x5e, 0x6e, 0x60, 0x24, 0x9c, 0xd3, 0x4c, 0x95, 0x93, 0x0c, 0x8a, 0xc5,
        0xcb, 0x14, 0x34, 0xda, 0xc1, 0x55, 0x77, 0x2e, 0xd3, 0xe2, 0x69, 0x28, 0x00,
        0x13, 0x01, 0x00, 0x00, 0x2e, 0x00, 0x33, 0x00, 0x24, 0x00, 0x1d, 0x00, 0x20,
        0xc9, 0x82, 0x88, 0x76, 0x11, 0x20, 0x95, 0xfe, 0x66, 0x76, 0x2b, 0xdb, 0xf7,
        0xc6, 0x72, 0xe1, 0x56, 0xd6, 0xcc, 0x25, 0x3b, 0x83, 0x3d, 0xf1, 0xdd, 0x69,
        0xb1, 0xb0, 0x4e, 0x75, 0x1f, 0x0f, 0x00, 0x2b, 0x00, 0x02, 0x03, 0x04,
    };

    const sh = try ztls.server_hello.parse(server_hello_bytes);
    print("cipher_suite:      {s}\n", .{@tagName(sh.cipher_suite)});
    print("server_public_key: {x}\n", .{sh.server_public_key.data});

    // ── DHE shared secret ──────────────────────

    const dhe = try ztls.x25519.sharedSecret(kp.secret_key, sh.server_public_key);
    print("shared_secret:     {x}\n", .{dhe});

    // ── Key schedule ────────────────────────

    const hkdf = ztls.hkdf.HkdfSha256;

    const handshake = hkdf.handshakeSecret(hkdf.early_secret, &dhe);
    const master = hkdf.masterSecret(handshake);

    // Transcript hash: SHA-256(ClientHello || ServerHello) from RFC 8448 §3.
    const transcript_hs: hkdf.Prk = .init(.{
        0x86, 0x0c, 0x06, 0xed, 0xc0, 0x78, 0x58, 0xee,
        0x8e, 0x78, 0xf0, 0xe7, 0x42, 0x8c, 0x58, 0xed,
        0xd6, 0xb4, 0x3f, 0x2c, 0xa3, 0xe6, 0xe9, 0x5f,
        0x02, 0xed, 0x06, 0x3c, 0xf0, 0xe1, 0xca, 0xd8,
    });

    const client_hs_secret = hkdf.clientHandshakeTrafficSecret(handshake, &transcript_hs);
    const server_hs_secret = hkdf.serverHandshakeTrafficSecret(handshake, &transcript_hs);

    print("\nhandshake_secret:        {x}\n", .{handshake.data});
    print("master_secret:           {x}\n", .{master.data});
    print("client_hs_traffic:       {x}\n", .{client_hs_secret.data});
    print("server_hs_traffic:       {x}\n", .{server_hs_secret.data});

    // ── RecordLayer keys ───────────────────────

    const server_key = hkdf.trafficKey(.aes128_gcm, server_hs_secret);
    const server_iv = hkdf.trafficIv(server_hs_secret);
    const client_key = hkdf.trafficKey(.aes128_gcm, client_hs_secret);
    const client_iv = hkdf.trafficIv(client_hs_secret);

    print("\nserver_write_key: {x}\n", .{server_key.data});
    print("server_write_iv:  {x}\n", .{server_iv.data});
    print("client_write_key: {x}\n", .{client_key.data});
    print("client_write_iv:  {x}\n", .{client_iv.data});

    // ── RecordLayer round-trip ─────────────────────

    var server_tx: ztls.RecordLayer = try .init(.{ .aes128_gcm = server_key }, server_iv);
    defer server_tx.deinit();
    var client_rx: ztls.RecordLayer = try .init(.{ .aes128_gcm = server_key }, server_iv);
    defer client_rx.deinit();

    const plaintext = "EncryptedExtensions";
    var out: [plaintext.len + ztls.RecordLayer.overhead]u8 = undefined;
    const wire = try server_tx.encrypt(.handshake, plaintext, &out);
    const received = try client_rx.decrypt(wire);

    print("\nencrypted {} bytes → {} wire bytes\n", .{ plaintext.len, wire.len });
    print("content_type: {s}\n", .{@tagName(received.content_type)});
    print("content:      {s}\n", .{received.content});
}
