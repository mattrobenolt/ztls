/// AEAD cipher wrapper for TLS 1.3.
///
/// TLS 1.3 mandates three AEAD cipher suites (RFC 8446 §9.1):
///   - TLS_AES_128_GCM_SHA256
///   - TLS_AES_256_GCM_SHA384
///   - TLS_CHACHA20_POLY1305_SHA256
///
/// All three share the same tag length (16 bytes) and nonce length (12 bytes).
/// Keys are derived during the handshake and held for the connection lifetime.
const std = @import("std");
const crypto = std.crypto;
const nonce_mod = @import("nonce.zig");

const Aes128Gcm = crypto.aead.aes_gcm.Aes128Gcm;
const Aes256Gcm = crypto.aead.aes_gcm.Aes256Gcm;
const ChaCha20Poly1305 = crypto.aead.chacha_poly.ChaCha20Poly1305;

// Verify our assumptions about the stdlib types at compile time.
comptime {
    std.debug.assert(Aes128Gcm.tag_length == 16);
    std.debug.assert(Aes256Gcm.tag_length == 16);
    std.debug.assert(ChaCha20Poly1305.tag_length == 16);
    std.debug.assert(Aes128Gcm.nonce_length == @sizeOf(nonce_mod.Nonce));
    std.debug.assert(Aes256Gcm.nonce_length == @sizeOf(nonce_mod.Nonce));
    std.debug.assert(ChaCha20Poly1305.nonce_length == @sizeOf(nonce_mod.Nonce));
}

/// Authentication tag — 16 bytes for all TLS 1.3 ciphers.
pub const tag_len = 16;
pub const Tag = [tag_len]u8;

pub const Error = crypto.errors.AuthenticationError;

/// A cipher context holding the key for one direction of a TLS connection.
/// Construct with Aead.init*(), then call encrypt/decrypt per record.
pub const Aead = union(enum) {
    aes128_gcm: [Aes128Gcm.key_length]u8,
    aes256_gcm: [Aes256Gcm.key_length]u8,
    chacha20_poly1305: [ChaCha20Poly1305.key_length]u8,

    pub fn initAes128Gcm(key: [Aes128Gcm.key_length]u8) Aead {
        return .{ .aes128_gcm = key };
    }

    pub fn initAes256Gcm(key: [Aes256Gcm.key_length]u8) Aead {
        return .{ .aes256_gcm = key };
    }

    pub fn initChaCha20Poly1305(key: [ChaCha20Poly1305.key_length]u8) Aead {
        return .{ .chacha20_poly1305 = key };
    }

    /// Encrypt `plaintext` into `ciphertext` and write the authentication tag.
    /// `ciphertext` must be the same length as `plaintext`.
    /// `ad` is authenticated but not encrypted (the TLS record header).
    pub fn encrypt(
        self: Aead,
        ciphertext: []u8,
        tag: *Tag,
        plaintext: []const u8,
        ad: []const u8,
        npub: *const nonce_mod.Nonce,
    ) void {
        switch (self) {
            .aes128_gcm => |key| Aes128Gcm.encrypt(ciphertext, tag, plaintext, ad, npub.*, key),
            .aes256_gcm => |key| Aes256Gcm.encrypt(ciphertext, tag, plaintext, ad, npub.*, key),
            .chacha20_poly1305 => |key| ChaCha20Poly1305.encrypt(ciphertext, tag, plaintext, ad, npub.*, key),
        }
    }

    /// Decrypt `ciphertext` into `plaintext` and verify the authentication tag.
    /// `plaintext` must be the same length as `ciphertext`.
    /// Returns `error.AuthenticationFailed` if the tag does not verify.
    pub fn decrypt(
        self: Aead,
        plaintext: []u8,
        ciphertext: []const u8,
        tag: *const Tag,
        ad: []const u8,
        npub: *const nonce_mod.Nonce,
    ) Error!void {
        switch (self) {
            .aes128_gcm => |key| try Aes128Gcm.decrypt(plaintext, ciphertext, tag.*, ad, npub.*, key),
            .aes256_gcm => |key| try Aes256Gcm.decrypt(plaintext, ciphertext, tag.*, ad, npub.*, key),
            .chacha20_poly1305 => |key| try ChaCha20Poly1305.decrypt(plaintext, ciphertext, tag.*, ad, npub.*, key),
        }
    }
};

const testing = std.testing;

// RFC 8446 §9.1 — mandatory cipher suites

test "Aes128Gcm: encrypt/decrypt round-trip" {
    const key: [Aes128Gcm.key_length]u8 = @splat(0xab);
    const iv: nonce_mod.Iv = @splat(0xcd);
    const npub = nonce_mod.construct(&iv, 0);
    const ad = "header";
    const plaintext = "hello world";

    var ciphertext: [plaintext.len]u8 = undefined;
    var tag: Tag = undefined;
    const aead = Aead.initAes128Gcm(key);
    aead.encrypt(&ciphertext, &tag, plaintext, ad, &npub);

    var decrypted: [plaintext.len]u8 = undefined;
    try aead.decrypt(&decrypted, &ciphertext, &tag, ad, &npub);
    try testing.expectEqualSlices(u8, plaintext, &decrypted);
}

test "Aes256Gcm: encrypt/decrypt round-trip" {
    const key: [Aes256Gcm.key_length]u8 = @splat(0xab);
    const iv: nonce_mod.Iv = @splat(0xcd);
    const npub = nonce_mod.construct(&iv, 0);
    const ad = "header";
    const plaintext = "hello world";

    var ciphertext: [plaintext.len]u8 = undefined;
    var tag: Tag = undefined;
    const aead = Aead.initAes256Gcm(key);
    aead.encrypt(&ciphertext, &tag, plaintext, ad, &npub);

    var decrypted: [plaintext.len]u8 = undefined;
    try aead.decrypt(&decrypted, &ciphertext, &tag, ad, &npub);
    try testing.expectEqualSlices(u8, plaintext, &decrypted);
}

test "ChaCha20Poly1305: encrypt/decrypt round-trip" {
    const key: [ChaCha20Poly1305.key_length]u8 = @splat(0xab);
    const iv: nonce_mod.Iv = @splat(0xcd);
    const npub = nonce_mod.construct(&iv, 0);
    const ad = "header";
    const plaintext = "hello world";

    var ciphertext: [plaintext.len]u8 = undefined;
    var tag: Tag = undefined;
    const aead = Aead.initChaCha20Poly1305(key);
    aead.encrypt(&ciphertext, &tag, plaintext, ad, &npub);

    var decrypted: [plaintext.len]u8 = undefined;
    try aead.decrypt(&decrypted, &ciphertext, &tag, ad, &npub);
    try testing.expectEqualSlices(u8, plaintext, &decrypted);
}

test "decrypt: authentication failure on tampered ciphertext" {
    const key: [Aes128Gcm.key_length]u8 = @splat(0x01);
    const iv: nonce_mod.Iv = @splat(0x02);
    const npub = nonce_mod.construct(&iv, 0);
    const ad = "header";
    const plaintext = "secret";

    var ciphertext: [plaintext.len]u8 = undefined;
    var tag: Tag = undefined;
    const aead = Aead.initAes128Gcm(key);
    aead.encrypt(&ciphertext, &tag, plaintext, ad, &npub);

    ciphertext[0] ^= 0xff; // tamper
    var decrypted: [plaintext.len]u8 = undefined;
    try testing.expectError(error.AuthenticationFailed, aead.decrypt(&decrypted, &ciphertext, &tag, ad, &npub));
}

test "decrypt: authentication failure on tampered tag" {
    const key: [Aes128Gcm.key_length]u8 = @splat(0x01);
    const iv: nonce_mod.Iv = @splat(0x02);
    const npub = nonce_mod.construct(&iv, 0);
    const ad = "header";
    const plaintext = "secret";

    var ciphertext: [plaintext.len]u8 = undefined;
    var tag: Tag = undefined;
    const aead = Aead.initAes128Gcm(key);
    aead.encrypt(&ciphertext, &tag, plaintext, ad, &npub);

    tag[0] ^= 0xff; // tamper
    var decrypted: [plaintext.len]u8 = undefined;
    try testing.expectError(error.AuthenticationFailed, aead.decrypt(&decrypted, &ciphertext, &tag, ad, &npub));
}

test "decrypt: authentication failure on tampered ad" {
    const key: [Aes128Gcm.key_length]u8 = @splat(0x01);
    const iv: nonce_mod.Iv = @splat(0x02);
    const npub = nonce_mod.construct(&iv, 0);
    const plaintext = "secret";

    var ciphertext: [plaintext.len]u8 = undefined;
    var tag: Tag = undefined;
    const aead = Aead.initAes128Gcm(key);
    aead.encrypt(&ciphertext, &tag, plaintext, "header", &npub);

    var decrypted: [plaintext.len]u8 = undefined;
    try testing.expectError(error.AuthenticationFailed, aead.decrypt(&decrypted, &ciphertext, &tag, "HEADER", &npub));
}
