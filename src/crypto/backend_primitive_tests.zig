//! Backend primitive contract tests — run under every linked libcrypto lane.
//!
//! These tests exercise the backend facade (`src/crypto/backend.zig`) directly
//! rather than the higher-level `aead`/`x25519`/`signature` wrapper modules.
//! They run under both the OpenSSL and AWS-LC build lanes because
//! `backend.active` is resolved at compile time from the build option, and the
//! test entry point in `src/test.zig` imports this file unconditionally.
//!
//! The goal is a narrow contract: the same known vectors must pass regardless
//! of which libcrypto-family provider is linked. This is not a Wycheproof
//! harness and does not claim full matrix evidence — it is a per-primitive
//! smoke contract that the facade dispatches and the backend produces correct
//! results for representative inputs.
const std = @import("std");
const testing = std.testing;

const backend = @import("backend.zig");
const Certificate = @import("../cryptox/Certificate.zig");
const CipherSuite = @import("../cipher_suite.zig").CipherSuite;
const SignatureScheme = @import("../signature_scheme.zig").SignatureScheme;
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

    const priv = try backend.x25519.privateKeyFromSecret(&scalar);
    defer backend.x25519.freeKey(priv);
    const peer = try backend.x25519.publicKeyFromRaw(&peer_pub);
    defer backend.x25519.freeKey(peer);

    var shared: [32]u8 = undefined;
    try backend.x25519.sharedSecretDerive(priv, peer, &shared);
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

    const alice_priv = try backend.x25519.privateKeyFromSecret(&alice_secret);
    defer backend.x25519.freeKey(alice_priv);
    const alice_pub = try backend.x25519.rawPublicKeyFromPrivate(alice_priv);

    const bob_priv = try backend.x25519.privateKeyFromSecret(&bob_secret);
    defer backend.x25519.freeKey(bob_priv);
    const bob_pub = try backend.x25519.rawPublicKeyFromPrivate(bob_priv);

    const alice_peer = try backend.x25519.publicKeyFromRaw(&bob_pub);
    defer backend.x25519.freeKey(alice_peer);
    var alice_shared: [32]u8 = undefined;
    try backend.x25519.sharedSecretDerive(alice_priv, alice_peer, &alice_shared);

    const bob_peer = try backend.x25519.publicKeyFromRaw(&alice_pub);
    defer backend.x25519.freeKey(bob_peer);
    var bob_shared: [32]u8 = undefined;
    try backend.x25519.sharedSecretDerive(bob_priv, bob_peer, &bob_shared);

    try testing.expectEqualSlices(u8, &alice_shared, &bob_shared);
}

// RFC 7748 §6.1 — all-zero shared secret indicates a low-order peer public key
// and must be rejected by the backend facade.
test "backend.x25519: all-zero public key is rejected (IdentityElement)" {
    const scalar: [32]u8 = hex(
        32,
        "a546e36bf0527c9d3b16154b82465edd62144c0ac1fc5a18506a2244ba449ac4",
    );
    const zero_pub: [32]u8 = @splat(0);

    const priv = try backend.x25519.privateKeyFromSecret(&scalar);
    defer backend.x25519.freeKey(priv);
    const peer = try backend.x25519.publicKeyFromRaw(&zero_pub);
    defer backend.x25519.freeKey(peer);

    var shared: [32]u8 = undefined;
    try testing.expectError(
        error.IdentityElement,
        backend.x25519.sharedSecretDerive(priv, peer, &shared),
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

    const priv = try backend.x25519.privateKeyFromSecret(&scalar);
    defer backend.x25519.freeKey(priv);
    const peer = try backend.x25519.publicKeyFromRaw(&small_order_pub);
    defer backend.x25519.freeKey(peer);

    var shared: [32]u8 = undefined;
    try testing.expectError(
        error.IdentityElement,
        backend.x25519.sharedSecretDerive(priv, peer, &shared),
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
