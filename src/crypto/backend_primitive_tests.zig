//! Backend primitive contract tests — run under every linked libcrypto lane.
//!
//! These tests exercise the backend facade (`src/crypto/backend.zig`) directly
//! rather than the higher-level `aead`/`x25519`/`p256`/`signature` wrapper modules.
//! They run under both the OpenSSL and AWS-LC build lanes because
//! `backend.active` is resolved at compile time from the build option, and the
//! test entry point in `src/test.zig` imports this file unconditionally.
//!
//! The goal is a narrow contract: the same known vectors must pass regardless
//! of which libcrypto-family provider is linked. This includes selected
//! facade-direct Wycheproof vectors, but is not a full Wycheproof harness or
//! full provider matrix claim.
const std = @import("std");
const testing = std.testing;

const backend = @import("backend.zig");
const Certificate = @import("../certificate_parser.zig");
const CipherSuite = @import("../cipher_suite.zig").CipherSuite;
const cert_fixtures = @import("../test_fixtures/certificate_fixtures.zig");

const hex = @import("../memx.zig").hex;

// ---------------------------------------------------------------------------
// X25519 — direct backend.x25519 facade
// ---------------------------------------------------------------------------

// RFC 7748 §5.2 — X25519 scalar multiplication test vector.
test "backend.x25519: RFC 7748 §5.2 shared secret" {
    const scalar: [32]u8 = hex(
        32,
        "a546e36bf0527c9d3b16154b82465edd62144c0ac1fc5a18506a2244ba449ac4",
    );
    const peer_pub: [32]u8 = hex(
        32,
        "e6db6867583030db3594c1a424b15f7c726624ec26b3353b10a903a6d0ab1c4c",
    );
    const want: [32]u8 = hex(
        32,
        "c3da55379de9c6908e94ea4df28d084f32eccf03491c71f754b4075577a28552",
    );

    var priv = try backend.x25519.privateKeyFromSecret(&scalar);
    defer backend.x25519.freeKey(&priv);
    var peer = try backend.x25519.publicKeyFromRaw(&peer_pub);
    defer backend.x25519.freeKey(&peer);

    var shared: [32]u8 = undefined;
    try backend.x25519.sharedSecretDerive(&priv, &peer, &shared);
    try testing.expectEqualSlices(u8, &want, &shared);
}

// RFC 7748 §6.1 — two parties derive the same shared secret.
test "backend.x25519: RFC 7748 §6.1 mutual key agreement" {
    const alice_secret: [32]u8 = hex(
        32,
        "77076d0a7318a57d3c16c17251b26645df4c2f87ebc0992ab177fba51db92c2a",
    );
    const bob_secret: [32]u8 = hex(
        32,
        "5dab087e624a8a4b79e17f8b83800ee66f3bb1292618b6fd1c2f8b27ff88e0eb",
    );

    var alice_priv = try backend.x25519.privateKeyFromSecret(&alice_secret);
    defer backend.x25519.freeKey(&alice_priv);
    const alice_pub = try backend.x25519.rawPublicKeyFromPrivate(&alice_priv);

    var bob_priv = try backend.x25519.privateKeyFromSecret(&bob_secret);
    defer backend.x25519.freeKey(&bob_priv);
    const bob_pub = try backend.x25519.rawPublicKeyFromPrivate(&bob_priv);

    var alice_peer = try backend.x25519.publicKeyFromRaw(&bob_pub);
    defer backend.x25519.freeKey(&alice_peer);
    var alice_shared: [32]u8 = undefined;
    try backend.x25519.sharedSecretDerive(&alice_priv, &alice_peer, &alice_shared);

    var bob_peer = try backend.x25519.publicKeyFromRaw(&alice_pub);
    defer backend.x25519.freeKey(&bob_peer);
    var bob_shared: [32]u8 = undefined;
    try backend.x25519.sharedSecretDerive(&bob_priv, &bob_peer, &bob_shared);

    try testing.expectEqualSlices(u8, &alice_shared, &bob_shared);
}

// Wycheproof v1 (google-wycheproof 0.9rc5) — X25519 tcId 1, normal case,
// exercised directly through the backend facade.
test "backend.x25519: Wycheproof tcId 1 shared secret" {
    const scalar: [32]u8 = hex(
        32,
        "c8a9d5a91091ad851c668b0736c1c9a02936c0d3ad62670858088047ba057475",
    );
    const peer_pub: [32]u8 = hex(
        32,
        "504a36999f489cd2fdbc08baff3d88fa00569ba986cba22548ffde80f9806829",
    );
    const want: [32]u8 = hex(
        32,
        "436a2c040cf45fea9b29a0cb81b1f41458f863d0d61b453d0a982720d6d61320",
    );

    var priv = try backend.x25519.privateKeyFromSecret(&scalar);
    defer backend.x25519.freeKey(&priv);
    var peer = try backend.x25519.publicKeyFromRaw(&peer_pub);
    defer backend.x25519.freeKey(&peer);

    var shared: [32]u8 = undefined;
    try backend.x25519.sharedSecretDerive(&priv, &peer, &shared);
    try testing.expectEqualSlices(u8, &want, &shared);
}

// RFC 7748 §6.1 / Wycheproof low-order public keys — all-zero shared secret
// indicates a low-order peer public key and must be rejected by the backend facade.
test "backend.x25519: all-zero public key is rejected (IdentityElement)" {
    const scalar: [32]u8 = hex(
        32,
        "a546e36bf0527c9d3b16154b82465edd62144c0ac1fc5a18506a2244ba449ac4",
    );
    const zero_pub: [32]u8 = @splat(0);

    var priv = try backend.x25519.privateKeyFromSecret(&scalar);
    defer backend.x25519.freeKey(&priv);
    var peer = try backend.x25519.publicKeyFromRaw(&zero_pub);
    defer backend.x25519.freeKey(&peer);

    var shared: [32]u8 = undefined;
    try testing.expectError(
        error.IdentityElement,
        backend.x25519.sharedSecretDerive(&priv, &peer, &shared),
    );
}

// RFC 7748 §6.1 — a small-order twist public key produces all-zero output.
test "backend.x25519: small-order public key is rejected (IdentityElement)" {
    const scalar: [32]u8 = hex(
        32,
        "a546e36bf0527c9d3b16154b82465edd62144c0ac1fc5a18506a2244ba449ac4",
    );
    const small_order_pub: [32]u8 = hex(
        32,
        "0100000000000000000000000000000000000000000000000000000000000000",
    );

    var priv = try backend.x25519.privateKeyFromSecret(&scalar);
    defer backend.x25519.freeKey(&priv);
    var peer = try backend.x25519.publicKeyFromRaw(&small_order_pub);
    defer backend.x25519.freeKey(&peer);

    var shared: [32]u8 = undefined;
    try testing.expectError(
        error.IdentityElement,
        backend.x25519.sharedSecretDerive(&priv, &peer, &shared),
    );
}

// ---------------------------------------------------------------------------
// AEAD — direct backend.aead facade for every advertised cipher suite
// ---------------------------------------------------------------------------

// RFC 8446 §5.2 — TLS 1.3 record protection uses AEAD with a 16-byte tag and
// 12-byte nonce. The backend must encrypt/decrypt consistently for every
// cipher suite advertised in `backend.capabilities.cipher_suites`.
test "backend.aead: round-trip for every advertised cipher suite" {
    inline for (backend.capabilities.cipher_suites) |suite| {
        const key_bytes: [keyLenForSuite(suite)]u8 = @splat(0xab);
        const nonce: [backend.aead.nonce_len]u8 = @splat(0xcd);
        const ad = "tls-record-header";
        const plaintext = "backend-aead-contract";

        var ctx: backend.aead.Context = try backend.aead.init(suite, &key_bytes);
        defer backend.aead.deinit(&ctx);

        var ciphertext: [plaintext.len]u8 = undefined;
        var tag: [backend.aead.tag_len]u8 = undefined;
        try backend.aead.encrypt(&ctx, &ciphertext, &tag, plaintext, ad, &nonce);

        var decrypted: [plaintext.len]u8 = undefined;
        try backend.aead.decrypt(&ctx, &decrypted, &ciphertext, &tag, ad, &nonce);
        try testing.expectEqualSlices(u8, plaintext, &decrypted);
    }
}

// RFC 8446 §5.2 — AEAD must reject tag corruption for every advertised suite.
test "backend.aead: tag corruption is rejected for every advertised cipher suite" {
    inline for (backend.capabilities.cipher_suites) |suite| {
        const key_bytes: [keyLenForSuite(suite)]u8 = @splat(0xab);
        const nonce: [backend.aead.nonce_len]u8 = @splat(0xcd);
        const ad = "tls-record-header";
        const plaintext = "backend-aead-contract";

        var ctx: backend.aead.Context = try backend.aead.init(suite, &key_bytes);
        defer backend.aead.deinit(&ctx);

        var ciphertext: [plaintext.len]u8 = undefined;
        var tag: [backend.aead.tag_len]u8 = undefined;
        try backend.aead.encrypt(&ctx, &ciphertext, &tag, plaintext, ad, &nonce);

        tag[0] ^= 0xff;
        var decrypted: [plaintext.len]u8 = undefined;
        try testing.expectError(
            error.AuthenticationFailed,
            backend.aead.decrypt(&ctx, &decrypted, &ciphertext, &tag, ad, &nonce),
        );
    }
}

// RFC 8446 §5.2 — AEAD must reject ciphertext corruption for every advertised suite.
test "backend.aead: ciphertext corruption is rejected for every advertised cipher suite" {
    inline for (backend.capabilities.cipher_suites) |suite| {
        const key_bytes: [keyLenForSuite(suite)]u8 = @splat(0xab);
        const nonce: [backend.aead.nonce_len]u8 = @splat(0xcd);
        const ad = "tls-record-header";
        const plaintext = "backend-aead-contract";

        var ctx: backend.aead.Context = try backend.aead.init(suite, &key_bytes);
        defer backend.aead.deinit(&ctx);

        var ciphertext: [plaintext.len]u8 = undefined;
        var tag: [backend.aead.tag_len]u8 = undefined;
        try backend.aead.encrypt(&ctx, &ciphertext, &tag, plaintext, ad, &nonce);

        ciphertext[0] ^= 0xff;
        var decrypted: [plaintext.len]u8 = undefined;
        try testing.expectError(
            error.AuthenticationFailed,
            backend.aead.decrypt(&ctx, &decrypted, &ciphertext, &tag, ad, &nonce),
        );
    }
}

// Wycheproof v1 (google-wycheproof 0.9rc5) — AES-128-GCM tcId 2, exercised
// directly through the backend facade with tag corruption rejection.
test "backend.aead: Wycheproof AES-128-GCM tcId 2" {
    const key: [16]u8 = hex(16, "5b9604fe14eadba931b0ccf34843dab9");
    const nonce: [12]u8 = hex(12, "921d2507fa8007b7bd067d34");
    const ad = hex(16, "00112233445566778899aabbccddeeff");
    const plaintext = hex(16, "001d0c231287c1182784554ca3a21908");
    const expected_ct = hex(16, "49d8b9783e911913d87094d1f63cc765");
    const expected_tag = hex(16, "1e348ba07cca2cf04c618cb4d43a5b92");

    var ctx: backend.aead.Context = try backend.aead.init(.aes_128_gcm_sha256, &key);
    defer backend.aead.deinit(&ctx);

    var ciphertext: [plaintext.len]u8 = undefined;
    var tag: [backend.aead.tag_len]u8 = undefined;
    try backend.aead.encrypt(&ctx, &ciphertext, &tag, &plaintext, &ad, &nonce);
    try testing.expectEqualSlices(u8, &expected_ct, &ciphertext);
    try testing.expectEqualSlices(u8, &expected_tag, &tag);

    var decrypted: [plaintext.len]u8 = undefined;
    try backend.aead.decrypt(&ctx, &decrypted, &ciphertext, &tag, &ad, &nonce);
    try testing.expectEqualSlices(u8, &plaintext, &decrypted);

    tag[0] ^= 1;
    try testing.expectError(
        error.AuthenticationFailed,
        backend.aead.decrypt(&ctx, &decrypted, &ciphertext, &tag, &ad, &nonce),
    );
}

// Wycheproof v1 (google-wycheproof 0.9rc5) — AES-256-GCM non-empty AAD
// boundary vector, exercised directly through the backend facade.
test "backend.aead: Wycheproof AES-256-GCM AAD boundary" {
    const key: [32]u8 = hex(
        32,
        "000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f",
    );
    const nonce: [12]u8 = hex(12, "000102030405060708090a0b");
    const ad = hex(16, "00112233445566778899aabbccddeeff");
    const plaintext = hex(16, "001d0c231287c1182784554ca3a21908");
    const expected_ct = hex(16, "471fda38d7620303aac5c2c7124b6165");
    const expected_tag = hex(16, "01af015e2daf8b415dc2027e8d51aa80");

    var ctx: backend.aead.Context = try backend.aead.init(.aes_256_gcm_sha384, &key);
    defer backend.aead.deinit(&ctx);

    var ciphertext: [plaintext.len]u8 = undefined;
    var tag: [backend.aead.tag_len]u8 = undefined;
    try backend.aead.encrypt(&ctx, &ciphertext, &tag, &plaintext, &ad, &nonce);
    try testing.expectEqualSlices(u8, &expected_ct, &ciphertext);
    try testing.expectEqualSlices(u8, &expected_tag, &tag);

    var decrypted: [plaintext.len]u8 = undefined;
    try backend.aead.decrypt(&ctx, &decrypted, &ciphertext, &tag, &ad, &nonce);
    try testing.expectEqualSlices(u8, &plaintext, &decrypted);

    tag[0] ^= 1;
    try testing.expectError(
        error.AuthenticationFailed,
        backend.aead.decrypt(&ctx, &decrypted, &ciphertext, &tag, &ad, &nonce),
    );
}

// Wycheproof v1 (google-wycheproof 0.9rc5) — ChaCha20-Poly1305 non-empty AAD
// boundary vector, exercised directly through the backend facade.
test "backend.aead: Wycheproof ChaCha20-Poly1305 AAD boundary" {
    const key: [32]u8 = hex(
        32,
        "cc56b680552eb75008f5484b4cb803fa5063ebd6eab91f6ab6aef4916a766273",
    );
    const nonce: [12]u8 = hex(12, "99e23ec48985bccdeeab60f1");
    const ad = hex(16, "00112233445566778899aabbccddeeff");
    const plaintext = hex(1, "2a");
    const expected_ct = hex(1, "3a");
    const expected_tag = hex(16, "d7d9204f3da54c5438a2454128a7438e");

    var ctx: backend.aead.Context = try backend.aead.init(.chacha20_poly1305_sha256, &key);
    defer backend.aead.deinit(&ctx);

    var ciphertext: [plaintext.len]u8 = undefined;
    var tag: [backend.aead.tag_len]u8 = undefined;
    try backend.aead.encrypt(&ctx, &ciphertext, &tag, &plaintext, &ad, &nonce);
    try testing.expectEqualSlices(u8, &expected_ct, &ciphertext);
    try testing.expectEqualSlices(u8, &expected_tag, &tag);

    var decrypted: [plaintext.len]u8 = undefined;
    try backend.aead.decrypt(&ctx, &decrypted, &ciphertext, &tag, &ad, &nonce);
    try testing.expectEqualSlices(u8, &plaintext, &decrypted);

    tag[15] ^= 1;
    try testing.expectError(
        error.AuthenticationFailed,
        backend.aead.decrypt(&ctx, &decrypted, &ciphertext, &tag, &ad, &nonce),
    );
}

// RFC 8439 §2.8.2 — ChaCha20-Poly1305 known-answer vector through the backend facade.
test "backend.aead: ChaCha20-Poly1305 RFC 8439 §2.8.2 known-answer vector" {
    const key: [32]u8 = hex(
        32,
        "808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9f",
    );
    const nonce: [12]u8 = hex(12, "070000004041424344454647");
    const ad = hex(12, "50515253c0c1c2c3c4c5c6c7");
    const plaintext = hex(
        114,
        "4c616469657320616e642047656e746c656d656e206f662074686520636c61737320" ++
            "6f66202739393a204966204920636f756c64206f6666657220796f75206f6e6c7920" ++
            "6f6e652074697020666f7220746865206675747572652c2073756e73637265656e20" ++
            "776f756c642062652069742e",
    );
    const expected_ct = hex(
        114,
        "d31a8d34648e60db7b86afbc53ef7ec2a4aded51296e08fea9e2b5a736ee62d" ++
            "63dbea45e8ca9671282fafb69da92728b1a71de0a9e060b2905d6a5b67ecd3b" ++
            "3692ddbd7f2d778b8c9803aee328091b58fab324e4fad675945585808b4831" ++
            "d7bc3ff4def08e4b7a9de576d26586cec64b6116",
    );
    const expected_tag = hex(16, "1ae10b594f09e26a7e902ecbd0600691");

    var ctx: backend.aead.Context = try backend.aead.init(
        .chacha20_poly1305_sha256,
        &key,
    );
    defer backend.aead.deinit(&ctx);

    var ciphertext: [plaintext.len]u8 = undefined;
    var tag: [backend.aead.tag_len]u8 = undefined;
    try backend.aead.encrypt(&ctx, &ciphertext, &tag, &plaintext, &ad, &nonce);
    try testing.expectEqualSlices(u8, &expected_ct, &ciphertext);
    try testing.expectEqualSlices(u8, &expected_tag, &tag);

    var decrypted: [plaintext.len]u8 = undefined;
    try backend.aead.decrypt(&ctx, &decrypted, &ciphertext, &tag, &ad, &nonce);
    try testing.expectEqualSlices(u8, &plaintext, &decrypted);
}

fn keyLenForSuite(suite: CipherSuite) usize {
    return switch (suite) {
        .aes_128_gcm_sha256 => 16,
        .aes_256_gcm_sha384, .chacha20_poly1305_sha256 => 32,
    };
}

// ---------------------------------------------------------------------------
// P-256 ECDH — direct backend.p256 facade
// ---------------------------------------------------------------------------

// SEC 1 §2.3.4 (via RFC 8446 §4.2.8) — P-256 uncompressed SEC1 public key is
// 65 bytes: 0x04 || X || Y. Two parties with fixed scalars must derive the
// same 32-byte shared secret through the backend facade.
test "backend.p256: mutual key agreement with fixed scalars" {
    const alice_scalar: [32]u8 = hex(
        32,
        "000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f",
    );
    const bob_scalar: [32]u8 = hex(
        32,
        "202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f",
    );

    const alice_priv = try backend.p256.privateKeyFromSecret(&alice_scalar);
    defer backend.p256.freeKey(alice_priv);
    const alice_pub = try backend.p256.rawPublicKeyFromPrivate(alice_priv);

    const bob_priv = try backend.p256.privateKeyFromSecret(&bob_scalar);
    defer backend.p256.freeKey(bob_priv);
    const bob_pub = try backend.p256.rawPublicKeyFromPrivate(bob_priv);

    // Both public keys must be uncompressed SEC1 (0x04 prefix, 65 bytes).
    try testing.expectEqual(@as(u8, 0x04), alice_pub[0]);
    try testing.expectEqual(@as(u8, 0x04), bob_pub[0]);

    const alice_peer = try backend.p256.publicKeyFromRaw(&bob_pub);
    defer backend.p256.freeKey(alice_peer);
    var alice_shared: [32]u8 = undefined;
    try backend.p256.sharedSecretDerive(alice_priv, alice_peer, &alice_shared);

    const bob_peer = try backend.p256.publicKeyFromRaw(&alice_pub);
    defer backend.p256.freeKey(bob_peer);
    var bob_shared: [32]u8 = undefined;
    try backend.p256.sharedSecretDerive(bob_priv, bob_peer, &bob_shared);

    try testing.expectEqualSlices(u8, &alice_shared, &bob_shared);
}

// SEC 1 §2.3.4 — an uncompressed P-256 public key must start with 0x04. A
// malformed prefix is rejected by the backend facade before any point math.
test "backend.p256: non-04 SEC1 prefix is rejected" {
    const scalar: [32]u8 = @splat(0);
    var fixed_scalar: [32]u8 = scalar;
    fixed_scalar[31] = 1;

    const priv = try backend.p256.privateKeyFromSecret(&fixed_scalar);
    defer backend.p256.freeKey(priv);
    const pub_bytes = try backend.p256.rawPublicKeyFromPrivate(priv);

    // Tamper with the prefix: 0x03 (compressed) is not accepted by this facade.
    var bad_pub = pub_bytes;
    bad_pub[0] = 0x03;

    try testing.expectError(
        error.IdentityElement,
        backend.p256.publicKeyFromRaw(&bad_pub),
    );
}

// SEC 1 §2.3.3 — a point with valid 0x04 prefix but coordinates not on the
// P-256 curve must be rejected. x=1, y=0 does not satisfy the curve equation.
test "backend.p256: off-curve point is rejected" {
    var off_curve: [65]u8 = @splat(0);
    off_curve[0] = 0x04;
    off_curve[32] = 0x01; // x = 1 (big-endian, last byte of X field)

    try testing.expectError(
        error.IdentityElement,
        backend.p256.publicKeyFromRaw(&off_curve),
    );
}

// SEC 1 §3.2.1 — a private key scalar must be in [1, n - 1]. Scalar zero is
// invalid and must not construct a usable backend P-256 key.
test "backend.p256: zero scalar private key is rejected" {
    const scalar: [32]u8 = @splat(0);
    try testing.expectError(
        error.LibcryptoFailed,
        backend.p256.privateKeyFromSecret(&scalar),
    );
}

// ---------------------------------------------------------------------------
// P-384 ECDH — direct backend.p384 facade
// ---------------------------------------------------------------------------

// SEC 1 §2.3.4 (via RFC 8446 §4.2.8) — P-384 uncompressed SEC1 public key is
// 97 bytes: 0x04 || X || Y. Two parties with fixed scalars must derive the
// same 48-byte shared secret through the backend facade.
test "backend.p384: mutual key agreement with fixed scalars" {
    const alice_scalar: [48]u8 = hex(
        48,
        "000102030405060708090a0b0c0d0e0f" ++
            "101112131415161718191a1b1c1d1e1f" ++
            "202122232425262728292a2b2c2d2e2f",
    );
    const bob_scalar: [48]u8 = hex(
        48,
        "303132333435363738393a3b3c3d3e3f" ++
            "404142434445464748494a4b4c4d4e4f" ++
            "505152535455565758595a5b5c5d5e5f",
    );

    const alice_priv = try backend.p384.privateKeyFromSecret(&alice_scalar);
    defer backend.p384.freeKey(alice_priv);
    const alice_pub = try backend.p384.rawPublicKeyFromPrivate(alice_priv);

    const bob_priv = try backend.p384.privateKeyFromSecret(&bob_scalar);
    defer backend.p384.freeKey(bob_priv);
    const bob_pub = try backend.p384.rawPublicKeyFromPrivate(bob_priv);

    try testing.expectEqual(@as(u8, 0x04), alice_pub[0]);
    try testing.expectEqual(@as(u8, 0x04), bob_pub[0]);

    const alice_peer = try backend.p384.publicKeyFromRaw(&bob_pub);
    defer backend.p384.freeKey(alice_peer);
    var alice_shared: [48]u8 = undefined;
    try backend.p384.sharedSecretDerive(alice_priv, alice_peer, &alice_shared);

    const bob_peer = try backend.p384.publicKeyFromRaw(&alice_pub);
    defer backend.p384.freeKey(bob_peer);
    var bob_shared: [48]u8 = undefined;
    try backend.p384.sharedSecretDerive(bob_priv, bob_peer, &bob_shared);

    try testing.expectEqualSlices(u8, &alice_shared, &bob_shared);
}

// SEC 1 §2.3.4 — an uncompressed P-384 public key must start with 0x04.
test "backend.p384: non-04 SEC1 prefix is rejected" {
    var scalar: [48]u8 = @splat(0);
    scalar[47] = 1;

    const priv = try backend.p384.privateKeyFromSecret(&scalar);
    defer backend.p384.freeKey(priv);
    const pub_bytes = try backend.p384.rawPublicKeyFromPrivate(priv);

    var bad_pub = pub_bytes;
    bad_pub[0] = 0x03;

    try testing.expectError(
        error.IdentityElement,
        backend.p384.publicKeyFromRaw(&bad_pub),
    );
}

// SEC 1 §2.3.3 — a point with valid 0x04 prefix but coordinates not on the
// P-384 curve must be rejected. x=1, y=0 does not satisfy the curve equation.
test "backend.p384: off-curve point is rejected" {
    var off_curve: [97]u8 = @splat(0);
    off_curve[0] = 0x04;
    off_curve[48] = 0x01; // x = 1 (big-endian, last byte of X field)

    try testing.expectError(
        error.IdentityElement,
        backend.p384.publicKeyFromRaw(&off_curve),
    );
}

// SEC 1 §3.2.1 — a private key scalar must be in [1, n - 1]. Scalar zero is
// invalid and must not construct a usable backend P-384 key.
test "backend.p384: zero scalar private key is rejected" {
    const scalar: [48]u8 = @splat(0);
    try testing.expectError(
        error.LibcryptoFailed,
        backend.p384.privateKeyFromSecret(&scalar),
    );
}

// ---------------------------------------------------------------------------
// Signature — direct backend.sign facade
// ---------------------------------------------------------------------------

const rsa_pss_key_pem = @embedFile("../test_fixtures/rsa_pss/server.key");

fn rsaPssPublicKey() !*backend.sign.pkey {
    const parsed = try Certificate.parse(.{
        .buffer = &cert_fixtures.rsa_pss_cert_der,
        .index = 0,
    });
    return backend.sign.rsaPublicKeyFromDer(parsed.pubKey());
}

// RFC 8446 §4.4.3 — CertificateVerify signs caller-assembled bytes; the backend
// signs exactly the provided message and verifies `context || transcript_hash`.
test "backend.sign: RSA-PSS SHA-256 sign/verify round-trip" {
    const private_key = try backend.sign.privateKeyFromPem(rsa_pss_key_pem);
    defer backend.sign.freeKey(private_key);
    const public_key = try rsaPssPublicKey();
    defer backend.sign.freeKey(public_key);

    const context = "TLS 1.3, client CertificateVerify";
    const transcript_hash: [32]u8 = @splat(0x42);
    const msg = context ++ transcript_hash;

    var sig_buf: [256]u8 = undefined;
    const sig = try backend.sign.sign(private_key, .rsa_pss_rsae_sha256, msg, &sig_buf);
    try testing.expect(sig.len > 0);

    try backend.sign.verify(
        public_key,
        .rsa_pss_rsae_sha256,
        context,
        &transcript_hash,
        sig,
    );
}

// RFC 8446 §4.4.3 — signature verification must reject a tampered signature.
test "backend.sign: RSA-PSS SHA-256 rejects tampered signature" {
    const private_key = try backend.sign.privateKeyFromPem(rsa_pss_key_pem);
    defer backend.sign.freeKey(private_key);
    const public_key = try rsaPssPublicKey();
    defer backend.sign.freeKey(public_key);

    const context = "TLS 1.3, client CertificateVerify";
    const transcript_hash: [32]u8 = @splat(0x42);
    const msg = context ++ transcript_hash;

    var sig_buf: [256]u8 = undefined;
    const sig = try backend.sign.sign(private_key, .rsa_pss_rsae_sha256, msg, &sig_buf);
    sig_buf[sig.len - 1] ^= 0xff;

    try testing.expectError(
        error.SignatureVerificationFailed,
        backend.sign.verify(public_key, .rsa_pss_rsae_sha256, context, &transcript_hash, sig),
    );
}

// RFC 8446 §4.4.3 — RSA-PSS SHA-384 is advertised for CertificateVerify and
// must round-trip through the backend facade under every provider lane.
test "backend.sign: RSA-PSS SHA-384 sign/verify round-trip and tamper rejection" {
    const private_key = try backend.sign.privateKeyFromPem(rsa_pss_key_pem);
    defer backend.sign.freeKey(private_key);
    const public_key = try rsaPssPublicKey();
    defer backend.sign.freeKey(public_key);

    const context = "TLS 1.3, client CertificateVerify";
    const transcript_hash: [48]u8 = @splat(0x24);
    const msg = context ++ transcript_hash;

    var sig_buf: [256]u8 = undefined;
    const sig = try backend.sign.sign(private_key, .rsa_pss_rsae_sha384, msg, &sig_buf);
    try testing.expect(sig.len > 0);

    try backend.sign.verify(
        public_key,
        .rsa_pss_rsae_sha384,
        context,
        &transcript_hash,
        sig,
    );

    sig_buf[sig.len - 1] ^= 0xff;
    try testing.expectError(
        error.SignatureVerificationFailed,
        backend.sign.verify(public_key, .rsa_pss_rsae_sha384, context, &transcript_hash, sig),
    );
}

// RFC 8446 §4.4.3 — ECDSA P-256 SHA-256 sign/verify round-trip through the
// backend facade using a deterministic scalar.
test "backend.sign: ECDSA P-256 SHA-256 sign/verify round-trip" {
    const scalar: [32]u8 = hex(
        32,
        "000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f",
    );

    const priv = try backend.sign.privateKeyFromP256Scalar(&scalar);
    defer backend.sign.freeKey(priv);

    // Derive SEC1 bytes with the P-256 facade, then load the verification key
    // through the signature facade path used by CertificateVerify.
    const pub_bytes = try backend.p256.rawPublicKeyFromPrivate(priv);
    const pub_key = try backend.sign.ecPublicKeyFromSec1(.secp256r1, &pub_bytes);
    defer backend.sign.freeKey(pub_key);

    const context = "TLS 1.3, server CertificateVerify";
    const transcript_hash: [32]u8 = @splat(0x99);
    const msg = context ++ transcript_hash;

    var sig_buf: [256]u8 = undefined;
    const sig = try backend.sign.sign(priv, .ecdsa_secp256r1_sha256, msg, &sig_buf);
    try testing.expect(sig.len > 0);

    try backend.sign.verify(
        pub_key,
        .ecdsa_secp256r1_sha256,
        context,
        &transcript_hash,
        sig,
    );
}

// RFC 8446 §4.4.3 — ECDSA signature verification must reject a tampered signature.
test "backend.sign: ECDSA P-256 SHA-256 rejects tampered signature" {
    const scalar: [32]u8 = hex(
        32,
        "000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f",
    );

    const priv = try backend.sign.privateKeyFromP256Scalar(&scalar);
    defer backend.sign.freeKey(priv);

    const pub_bytes = try backend.p256.rawPublicKeyFromPrivate(priv);
    const pub_key = try backend.sign.ecPublicKeyFromSec1(.secp256r1, &pub_bytes);
    defer backend.sign.freeKey(pub_key);

    const context = "TLS 1.3, server CertificateVerify";
    const transcript_hash: [32]u8 = @splat(0x99);
    const msg = context ++ transcript_hash;

    var sig_buf: [256]u8 = undefined;
    const sig = try backend.sign.sign(priv, .ecdsa_secp256r1_sha256, msg, &sig_buf);
    sig_buf[0] ^= 0xff;

    try testing.expectError(
        error.SignatureVerificationFailed,
        backend.sign.verify(
            pub_key,
            .ecdsa_secp256r1_sha256,
            context,
            &transcript_hash,
            sig,
        ),
    );
}

// RFC 8446 §4.4.3 — ECDSA P-384 SHA-384 is advertised for CertificateVerify
// and must round-trip through the backend facade under every provider lane.
test "backend.sign: ECDSA P-384 SHA-384 sign/verify round-trip and tamper rejection" {
    const scalar: [48]u8 = hex(
        48,
        "000102030405060708090a0b0c0d0e0f" ++
            "101112131415161718191a1b1c1d1e1f" ++
            "202122232425262728292a2b2c2d2e2f",
    );

    const priv = try backend.p384.privateKeyFromSecret(&scalar);
    defer backend.p384.freeKey(priv);

    const pub_bytes = try backend.p384.rawPublicKeyFromPrivate(priv);
    const pub_key = try backend.sign.ecPublicKeyFromSec1(.secp384r1, &pub_bytes);
    defer backend.sign.freeKey(pub_key);

    const context = "TLS 1.3, server CertificateVerify";
    const transcript_hash: [48]u8 = @splat(0x66);
    const msg = context ++ transcript_hash;

    var sig_buf: [256]u8 = undefined;
    const sig = try backend.sign.sign(priv, .ecdsa_secp384r1_sha384, msg, &sig_buf);
    try testing.expect(sig.len > 0);

    try backend.sign.verify(
        pub_key,
        .ecdsa_secp384r1_sha384,
        context,
        &transcript_hash,
        sig,
    );

    sig_buf[0] ^= 0xff;
    try testing.expectError(
        error.SignatureVerificationFailed,
        backend.sign.verify(
            pub_key,
            .ecdsa_secp384r1_sha384,
            context,
            &transcript_hash,
            sig,
        ),
    );
}

// RFC 8446 §4.4.3 — the signing output buffer must be large enough or the
// backend returns BufferTooShort without truncation.
test "backend.sign: BufferTooShort on undersized output" {
    const key = try backend.sign.privateKeyFromPem(rsa_pss_key_pem);
    defer backend.sign.freeKey(key);

    var sig_buf: [1]u8 = undefined;
    try testing.expectError(
        error.BufferTooShort,
        backend.sign.sign(key, .rsa_pss_rsae_sha256, "test message", &sig_buf),
    );
}

// RFC 8446 §4.2.3 — the CertificateVerify scheme must be compatible with the
// signing key; an ECDSA key with an RSA-PSS scheme is a backend failure.
test "backend.sign: key/scheme mismatch is a libcrypto failure" {
    const scalar: [32]u8 = @splat(0);
    var fixed: [32]u8 = scalar;
    fixed[31] = 1;
    const priv = try backend.sign.privateKeyFromP256Scalar(&fixed);
    defer backend.sign.freeKey(priv);

    var sig_buf: [256]u8 = undefined;
    try testing.expectError(
        error.LibcryptoFailed,
        backend.sign.sign(priv, .rsa_pss_rsae_sha256, "test message", &sig_buf),
    );
}
