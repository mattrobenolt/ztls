const std = @import("std");
const testing = std.testing;

const ztls = @import("ztls");

const hex = @import("harness.zig").hex;

// Wycheproof v1 (google-wycheproof 0.9rc5) — X25519 tcId 1, normal case.
test "Wycheproof: X25519 shared secret tcId 1" {
    const private: ztls.x25519.SecretKey = .init(
        hex(32, "c8a9d5a91091ad851c668b0736c1c9a02936c0d3ad62670858088047ba057475"),
    );
    const public: ztls.x25519.PublicKey = .init(
        hex(32, "504a36999f489cd2fdbc08baff3d88fa00569ba986cba22548ffde80f9806829"),
    );
    const shared = try ztls.x25519.sharedSecret(private, public);
    const expected = hex(32, "436a2c040cf45fea9b29a0cb81b1f41458f863d0d61b453d0a982720d6d61320");
    try testing.expectEqualSlices(u8, &expected, &shared);
}

// RFC 7748 §6.1 / Wycheproof low-order public keys — all-zero shared secret is rejected.
test "Wycheproof boundary: X25519 identity element is rejected" {
    const private: ztls.x25519.SecretKey = .init(
        hex(32, "c8a9d5a91091ad851c668b0736c1c9a02936c0d3ad62670858088047ba057475"),
    );
    const public: ztls.x25519.PublicKey = .init(@splat(0));
    try testing.expectError(error.IdentityElement, ztls.x25519.sharedSecret(private, public));
}

// RFC 7748 §6.1 / Wycheproof — small-order (order-2) public key is rejected.
test "Wycheproof boundary: X25519 small-order public key is rejected" {
    const private: ztls.x25519.SecretKey = .init(
        hex(32, "c8a9d5a91091ad851c668b0736c1c9a02936c0d3ad62670858088047ba057475"),
    );
    const public: ztls.x25519.PublicKey = .init(
        hex(32, "0100000000000000000000000000000000000000000000000000000000000000"),
    );
    try testing.expectError(error.IdentityElement, ztls.x25519.sharedSecret(private, public));
}

// Wycheproof v1 (google-wycheproof 0.9rc5) — AES-GCM tcId 2.
test "Wycheproof: AES-128-GCM AAD/tag handling tcId 2" {
    const key: ztls.aead.Aes128GcmKey = .init(hex(16, "5b9604fe14eadba931b0ccf34843dab9"));
    const nonce: ztls.aead.Nonce = .init(hex(12, "921d2507fa8007b7bd067d34"));
    const aad = hex(16, "00112233445566778899aabbccddeeff");
    const msg = hex(16, "001d0c231287c1182784554ca3a21908");
    const expected_ct = hex(16, "49d8b9783e911913d87094d1f63cc765");
    const expected_tag: ztls.aead.Tag = .init(hex(16, "1e348ba07cca2cf04c618cb4d43a5b92"));

    const aead: ztls.aead.Aead = .{ .aes128_gcm = key };
    var ctx = try ztls.aead.Context.init(aead);
    defer ctx.deinit();

    var ct: [msg.len]u8 = undefined;
    var tag: ztls.aead.Tag = undefined;
    try aead.encrypt(&ctx, &ct, &tag, &msg, &aad, &nonce);
    try testing.expectEqualSlices(u8, &expected_ct, &ct);
    try testing.expectEqualSlices(u8, &expected_tag.data, &tag.data);

    var plain: [msg.len]u8 = undefined;
    try aead.decrypt(&ctx, &plain, &ct, &tag, &aad, &nonce);
    try testing.expectEqualSlices(u8, &msg, &plain);

    tag.data[0] ^= 1;
    try testing.expectError(
        error.AuthenticationFailed,
        aead.decrypt(&ctx, &plain, &ct, &tag, &aad, &nonce),
    );
}

// Wycheproof v1 (google-wycheproof 0.9rc5) — AES-256-GCM non-empty AAD boundary vector.
test "Wycheproof boundary: AES-256-GCM AAD/tag handling" {
    const key: ztls.aead.Aes256GcmKey = .init(
        hex(32, "000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f"),
    );
    const nonce: ztls.aead.Nonce = .init(hex(12, "000102030405060708090a0b"));
    const aad = hex(16, "00112233445566778899aabbccddeeff");
    const msg = hex(16, "001d0c231287c1182784554ca3a21908");
    const expected_ct = hex(16, "471fda38d7620303aac5c2c7124b6165");
    const expected_tag: ztls.aead.Tag = .init(hex(16, "01af015e2daf8b415dc2027e8d51aa80"));

    const aead: ztls.aead.Aead = .{ .aes256_gcm = key };
    var ctx = try ztls.aead.Context.init(aead);
    defer ctx.deinit();

    var ct: [msg.len]u8 = undefined;
    var tag: ztls.aead.Tag = undefined;
    try aead.encrypt(&ctx, &ct, &tag, &msg, &aad, &nonce);
    try testing.expectEqualSlices(u8, &expected_ct, &ct);
    try testing.expectEqualSlices(u8, &expected_tag.data, &tag.data);

    var plain: [msg.len]u8 = undefined;
    try aead.decrypt(&ctx, &plain, &ct, &tag, &aad, &nonce);
    try testing.expectEqualSlices(u8, &msg, &plain);

    tag.data[0] ^= 1;
    try testing.expectError(
        error.AuthenticationFailed,
        aead.decrypt(&ctx, &plain, &ct, &tag, &aad, &nonce),
    );
}

// Wycheproof v1 (google-wycheproof 0.9rc5) — ChaCha20-Poly1305 tcId 4.
test "Wycheproof: ChaCha20-Poly1305 one-byte message tcId 4" {
    const key: ztls.aead.ChaCha20Poly1305Key = .init(
        hex(32, "cc56b680552eb75008f5484b4cb803fa5063ebd6eab91f6ab6aef4916a766273"),
    );
    const nonce: ztls.aead.Nonce = .init(hex(12, "99e23ec48985bccdeeab60f1"));
    const msg = hex(1, "2a");
    const expected_ct = hex(1, "3a");
    const expected_tag: ztls.aead.Tag = .init(hex(16, "cac27dec0968801e9f6eded69d807522"));

    const aead: ztls.aead.Aead = .{ .chacha20_poly1305 = key };
    var ctx = try ztls.aead.Context.init(aead);
    defer ctx.deinit();

    var ct: [msg.len]u8 = undefined;
    var tag: ztls.aead.Tag = undefined;
    try aead.encrypt(&ctx, &ct, &tag, &msg, &.{}, &nonce);
    try testing.expectEqualSlices(u8, &expected_ct, &ct);
    try testing.expectEqualSlices(u8, &expected_tag.data, &tag.data);

    var plain: [msg.len]u8 = undefined;
    try aead.decrypt(&ctx, &plain, &ct, &tag, &.{}, &nonce);
    try testing.expectEqualSlices(u8, &msg, &plain);

    tag.data[15] ^= 1;
    try testing.expectError(
        error.AuthenticationFailed,
        aead.decrypt(&ctx, &plain, &ct, &tag, &.{}, &nonce),
    );
}

// Wycheproof v1 (google-wycheproof 0.9rc5) — ChaCha20-Poly1305 non-empty AAD boundary vector.
test "Wycheproof boundary: ChaCha20-Poly1305 AAD handling" {
    const key: ztls.aead.ChaCha20Poly1305Key = .init(
        hex(32, "cc56b680552eb75008f5484b4cb803fa5063ebd6eab91f6ab6aef4916a766273"),
    );
    const nonce: ztls.aead.Nonce = .init(hex(12, "99e23ec48985bccdeeab60f1"));
    const aad = hex(16, "00112233445566778899aabbccddeeff");
    const msg = hex(1, "2a");
    const expected_ct = hex(1, "3a");
    const expected_tag: ztls.aead.Tag = .init(hex(16, "d7d9204f3da54c5438a2454128a7438e"));

    const aead: ztls.aead.Aead = .{ .chacha20_poly1305 = key };
    var ctx = try ztls.aead.Context.init(aead);
    defer ctx.deinit();

    var ct: [msg.len]u8 = undefined;
    var tag: ztls.aead.Tag = undefined;
    try aead.encrypt(&ctx, &ct, &tag, &msg, &aad, &nonce);
    try testing.expectEqualSlices(u8, &expected_ct, &ct);
    try testing.expectEqualSlices(u8, &expected_tag.data, &tag.data);

    var plain: [msg.len]u8 = undefined;
    try aead.decrypt(&ctx, &plain, &ct, &tag, &aad, &nonce);
    try testing.expectEqualSlices(u8, &msg, &plain);

    tag.data[15] ^= 1;
    try testing.expectError(
        error.AuthenticationFailed,
        aead.decrypt(&ctx, &plain, &ct, &tag, &aad, &nonce),
    );
}
