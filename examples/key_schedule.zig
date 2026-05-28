/// Demonstrates the TLS 1.3 key schedule and record layer composition.
///
/// Uses known values from RFC 8448 §3 (simple 1-RTT, X25519,
/// TLS_AES_128_GCM_SHA256) to show the full pipeline:
///
///   DHE shared secret
///     → HKDF key schedule (early → handshake → master secrets)
///     → traffic secrets
///     → RecordLayer keys and IVs
///     → encrypt/decrypt application data
const std = @import("std");
const print = std.debug.print;

const ztls = @import("ztls");
const hkdf = ztls.hkdf.HkdfSha256;
const RecordLayer = ztls.RecordLayer;

pub fn main() !void {
    // X25519 shared secret from RFC 8448 §3.
    const dhe_secret: ztls.hkdf.SharedSecret = .init(.{
        0x8b, 0xd4, 0x05, 0x4f, 0xb5, 0x5b, 0x9d, 0x63,
        0xfd, 0xfb, 0xac, 0xf9, 0xf0, 0x4b, 0x9f, 0x0d,
        0x35, 0xe6, 0xd6, 0x3f, 0x53, 0x75, 0x63, 0xef,
        0xd4, 0x62, 0x72, 0x90, 0x0f, 0x89, 0x49, 0x2d,
    });

    // Transcript hash: SHA-256(ClientHello || ServerHello) from RFC 8448 §3.
    const transcript_hs: hkdf.Prk = .init(.{
        0x86, 0x0c, 0x06, 0xed, 0xc0, 0x78, 0x58, 0xee,
        0x8e, 0x78, 0xf0, 0xe7, 0x42, 0x8c, 0x58, 0xed,
        0xd6, 0xb4, 0x3f, 0x2c, 0xa3, 0xe6, 0xe9, 0x5f,
        0x02, 0xed, 0x06, 0x3c, 0xf0, 0xe1, 0xca, 0xd8,
    });

    // Key schedule.
    const handshake = hkdf.handshakeSecret(hkdf.early_secret, &dhe_secret);
    const master = hkdf.masterSecret(handshake);

    // Handshake traffic secrets.
    const client_hs_secret = hkdf.clientHandshakeTrafficSecret(handshake, &transcript_hs);
    const server_hs_secret = hkdf.serverHandshakeTrafficSecret(handshake, &transcript_hs);

    print("=== key schedule (RFC 8448 §3) ===\n", .{});
    print("early_secret:         {x}\n", .{hkdf.early_secret.data});
    print("handshake_secret:     {x}\n", .{handshake.data});
    print("master_secret:        {x}\n", .{master.data});
    print("client_hs_secret:     {x}\n", .{client_hs_secret.data});
    print("server_hs_secret:     {x}\n", .{server_hs_secret.data});

    // Derive RecordLayer keys and IVs from the server handshake traffic secret.
    var server_write_key: ztls.aead.Aes128GcmKey = undefined;
    hkdf.trafficKey(server_hs_secret, &server_write_key.data);
    const server_write_iv = hkdf.trafficIv(server_hs_secret);

    var client_write_key: ztls.aead.Aes128GcmKey = undefined;
    hkdf.trafficKey(client_hs_secret, &client_write_key.data);
    const client_write_iv = hkdf.trafficIv(client_hs_secret);

    print("\n=== handshake traffic keys ===\n", .{});
    print("server_write_key: {x}\n", .{server_write_key.data});
    print("server_write_iv:  {x}\n", .{server_write_iv.data});
    print("client_write_key: {x}\n", .{client_write_key.data});
    print("client_write_iv:  {x}\n", .{client_write_iv.data});

    // Wire up RecordLayers with derived keys.
    var server_tx: RecordLayer = .{
        .aead = .initAes128Gcm(server_write_key),
        .iv = server_write_iv,
    };
    var client_rx: RecordLayer = .{
        .aead = .initAes128Gcm(server_write_key),
        .iv = server_write_iv,
    };

    // Server encrypts a handshake record, client decrypts it.
    const plaintext = "EncryptedExtensions";
    var out: [plaintext.len + RecordLayer.overhead]u8 = undefined;
    const wire = try server_tx.encrypt(.handshake, plaintext, &out);
    const received = try client_rx.decrypt(wire);

    print("\n=== record layer ===\n", .{});
    print("encrypted {} bytes -> {} wire bytes\n", .{ plaintext.len, wire.len });
    print("content_type: {s}\n", .{@tagName(received.content_type)});
    print("content:      {s}\n", .{received.content});
}
