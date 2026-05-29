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
const assert = std.debug.assert;
const Aes128Gcm = crypto.aead.aes_gcm.Aes128Gcm;
const Aes256Gcm = crypto.aead.aes_gcm.Aes256Gcm;
const ChaCha20Poly1305 = crypto.aead.chacha_poly.ChaCha20Poly1305;
pub const Error = crypto.errors.AuthenticationError;
const testing = std.testing;

const construct = @import("nonce.zig").construct;
pub const Iv = @import("nonce.zig").Iv;
const memx = @import("memx.zig");
const Nonce = @import("nonce.zig").Nonce;

// Verify our assumptions about the stdlib types at compile time.
comptime {
    assert(Aes128Gcm.tag_length == 16);
    assert(Aes256Gcm.tag_length == 16);
    assert(ChaCha20Poly1305.tag_length == 16);
    assert(Aes128Gcm.nonce_length == @sizeOf(Nonce));
    assert(Aes256Gcm.nonce_length == @sizeOf(Nonce));
    assert(ChaCha20Poly1305.nonce_length == @sizeOf(Nonce));
}

/// Authentication tag — 16 bytes for all TLS 1.3 ciphers.
pub const tag_len = 16;
pub const Tag = memx.Array(tag_len);

pub const Aes128GcmKey = memx.Array(Aes128Gcm.key_length);
pub const Aes256GcmKey = memx.Array(Aes256Gcm.key_length);
pub const ChaCha20Poly1305Key = memx.Array(ChaCha20Poly1305.key_length);

/// The set of supported AEAD cipher suites.
pub const Keys = enum {
    aes128_gcm,
    aes256_gcm,
    chacha20_poly1305,

    fn toCipher(comptime tag: Keys) type {
        return switch (tag) {
            .aes128_gcm => Aes128Gcm,
            .aes256_gcm => Aes256Gcm,
            .chacha20_poly1305 => ChaCha20Poly1305,
        };
    }
};

/// A cipher context holding the key for one direction of a TLS connection.
pub const Aead = union(Keys) {
    aes128_gcm: Aes128GcmKey,
    aes256_gcm: Aes256GcmKey,
    chacha20_poly1305: ChaCha20Poly1305Key,

    /// Encrypt `plaintext` into `ciphertext` and write the authentication tag.
    /// `ciphertext` must be the same length as `plaintext`.
    /// `ad` is authenticated but not encrypted (the TLS record header).
    pub fn encrypt(
        self: Aead,
        ciphertext: []u8,
        tag: *Tag,
        plaintext: []const u8,
        ad: []const u8,
        npub: *const Nonce,
    ) void {
        switch (self) {
            inline else => |key, t| {
                const C = t.toCipher();
                C.encrypt(ciphertext, &tag.data, plaintext, ad, npub.data, key.data);
            },
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
        npub: *const Nonce,
    ) Error!void {
        switch (self) {
            inline else => |key, t| {
                const C = t.toCipher();
                try C.decrypt(plaintext, ciphertext, tag.data, ad, npub.data, key.data);
            },
        }
    }
};

// RFC 8446 §9.1 — mandatory cipher suites

test "Aes128Gcm: encrypt/decrypt round-trip" {
    const key: Aes128GcmKey = .init(@splat(0xab));
    const iv: Iv = .init(@splat(0xcd));
    const npub = construct(&iv, 0);
    const ad = "header";
    const plaintext = "hello world";

    var ciphertext: [plaintext.len]u8 = undefined;
    var tag: Tag = undefined;
    const aead: Aead = .{ .aes128_gcm = key };
    aead.encrypt(&ciphertext, &tag, plaintext, ad, &npub);

    var decrypted: [plaintext.len]u8 = undefined;
    try aead.decrypt(&decrypted, &ciphertext, &tag, ad, &npub);
    try testing.expectEqualSlices(u8, plaintext, &decrypted);
}

test "Aes256Gcm: encrypt/decrypt round-trip" {
    const key: Aes256GcmKey = .init(@splat(0xab));
    const iv: Iv = .init(@splat(0xcd));
    const npub = construct(&iv, 0);
    const ad = "header";
    const plaintext = "hello world";

    var ciphertext: [plaintext.len]u8 = undefined;
    var tag: Tag = undefined;
    const aead: Aead = .{ .aes256_gcm = key };
    aead.encrypt(&ciphertext, &tag, plaintext, ad, &npub);

    var decrypted: [plaintext.len]u8 = undefined;
    try aead.decrypt(&decrypted, &ciphertext, &tag, ad, &npub);
    try testing.expectEqualSlices(u8, plaintext, &decrypted);
}

test "ChaCha20Poly1305: encrypt/decrypt round-trip" {
    const key: ChaCha20Poly1305Key = .init(@splat(0xab));
    const iv: Iv = .init(@splat(0xcd));
    const npub = construct(&iv, 0);
    const ad = "header";
    const plaintext = "hello world";

    var ciphertext: [plaintext.len]u8 = undefined;
    var tag: Tag = undefined;
    const aead: Aead = .{ .chacha20_poly1305 = key };
    aead.encrypt(&ciphertext, &tag, plaintext, ad, &npub);

    var decrypted: [plaintext.len]u8 = undefined;
    try aead.decrypt(&decrypted, &ciphertext, &tag, ad, &npub);
    try testing.expectEqualSlices(u8, plaintext, &decrypted);
}

test "decrypt: authentication failure on tampered ciphertext" {
    const key: Aes128GcmKey = .init(@splat(0x01));
    const iv: Iv = .init(@splat(0x02));
    const npub = construct(&iv, 0);
    const ad = "header";
    const plaintext = "secret";

    var ciphertext: [plaintext.len]u8 = undefined;
    var tag: Tag = undefined;
    const aead: Aead = .{ .aes128_gcm = key };
    aead.encrypt(&ciphertext, &tag, plaintext, ad, &npub);

    ciphertext[0] ^= 0xff;
    var decrypted: [plaintext.len]u8 = undefined;
    try testing.expectError(error.AuthenticationFailed, aead.decrypt(&decrypted, &ciphertext, &tag, ad, &npub));
}

test "decrypt: authentication failure on tampered tag" {
    const key: Aes128GcmKey = .init(@splat(0x01));
    const iv: Iv = .init(@splat(0x02));
    const npub = construct(&iv, 0);
    const ad = "header";
    const plaintext = "secret";

    var ciphertext: [plaintext.len]u8 = undefined;
    var tag: Tag = undefined;
    const aead: Aead = .{ .aes128_gcm = key };
    aead.encrypt(&ciphertext, &tag, plaintext, ad, &npub);

    tag.data[0] ^= 0xff;
    var decrypted: [plaintext.len]u8 = undefined;
    try testing.expectError(error.AuthenticationFailed, aead.decrypt(&decrypted, &ciphertext, &tag, ad, &npub));
}

test "decrypt: authentication failure on tampered ad" {
    const key: Aes128GcmKey = .init(@splat(0x01));
    const iv: Iv = .init(@splat(0x02));
    const npub = construct(&iv, 0);
    const plaintext = "secret";

    var ciphertext: [plaintext.len]u8 = undefined;
    var tag: Tag = undefined;
    const aead: Aead = .{ .aes128_gcm = key };
    aead.encrypt(&ciphertext, &tag, plaintext, "header", &npub);

    var decrypted: [plaintext.len]u8 = undefined;
    try testing.expectError(error.AuthenticationFailed, aead.decrypt(&decrypted, &ciphertext, &tag, "HEADER", &npub));
}
