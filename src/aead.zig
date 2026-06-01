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
const builtin = @import("builtin");
const crypto = std.crypto;
const assert = std.debug.assert;
const Aes128Gcm = crypto.aead.aes_gcm.Aes128Gcm;
const Aes256Gcm = crypto.aead.aes_gcm.Aes256Gcm;
const ChaCha20Poly1305 = crypto.aead.chacha_poly.ChaCha20Poly1305;
const ChaCha20Poly1305Neon = @import("crypto/chacha20_poly1305_neon.zig");
pub const Error = crypto.errors.AuthenticationError;
const testing = std.testing;

const construct = @import("nonce.zig").construct;
pub const Iv = @import("nonce.zig").Iv;
const memx = @import("memx.zig");
const Nonce = @import("nonce.zig").Nonce;

const use_neon_chacha = builtin.cpu.arch == .aarch64 and builtin.os.tag == .linux;

// Verify our assumptions about the stdlib types at compile time.
comptime {
    assert(Aes128Gcm.tag_length == 16);
    assert(Aes256Gcm.tag_length == 16);
    assert(ChaCha20Poly1305.tag_length == 16);
    assert(ChaCha20Poly1305Neon.tag_length == 16);
    assert(Aes128Gcm.nonce_length == @sizeOf(Nonce));
    assert(Aes256Gcm.nonce_length == @sizeOf(Nonce));
    assert(ChaCha20Poly1305.nonce_length == @sizeOf(Nonce));
    assert(ChaCha20Poly1305Neon.nonce_length == @sizeOf(Nonce));
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
            .aes128_gcm => |key| Aes128Gcm.encrypt(ciphertext, &tag.data, plaintext, ad, npub.data, key.data),
            .aes256_gcm => |key| Aes256Gcm.encrypt(ciphertext, &tag.data, plaintext, ad, npub.data, key.data),
            .chacha20_poly1305 => |key| {
                if (comptime use_neon_chacha) {
                    ChaCha20Poly1305Neon.encrypt(ciphertext, &tag.data, plaintext, ad, npub.data, key.data);
                } else {
                    ChaCha20Poly1305.encrypt(ciphertext, &tag.data, plaintext, ad, npub.data, key.data);
                }
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
            .aes128_gcm => |key| try Aes128Gcm.decrypt(plaintext, ciphertext, tag.data, ad, npub.data, key.data),
            .aes256_gcm => |key| try Aes256Gcm.decrypt(plaintext, ciphertext, tag.data, ad, npub.data, key.data),
            .chacha20_poly1305 => |key| {
                if (comptime use_neon_chacha) {
                    try ChaCha20Poly1305Neon.decrypt(plaintext, ciphertext, tag.data, ad, npub.data, key.data);
                } else {
                    try ChaCha20Poly1305.decrypt(plaintext, ciphertext, tag.data, ad, npub.data, key.data);
                }
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

fn hex(comptime bytes_len: usize, comptime encoded: []const u8) [bytes_len]u8 {
    var out: [bytes_len]u8 = undefined;
    _ = std.fmt.hexToBytes(&out, encoded) catch unreachable;
    return out;
}

// RFC 8439 §2.8.2 — ChaCha20-Poly1305 AEAD construction test vector
test "ChaCha20Poly1305: RFC 8439 known-answer vector" {
    const key: ChaCha20Poly1305Key = .init(hex(32, "808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9f"));
    const npub: Nonce = .init(hex(12, "070000004041424344454647"));
    const ad = hex(12, "50515253c0c1c2c3c4c5c6c7");
    const plaintext = hex(
        114,
        "4c616469657320616e642047656e746c656d656e206f662074686520636c61737320" ++
            "6f66202739393a204966204920636f756c64206f6666657220796f75206f6e6c7920" ++
            "6f6e652074697020666f7220746865206675747572652c2073756e73637265656e20" ++
            "776f756c642062652069742e",
    );
    const expected_ciphertext = hex(
        114,
        "d31a8d34648e60db7b86afbc53ef7ec2a4aded51296e08fea9e2b5a736ee62d" ++
            "63dbea45e8ca9671282fafb69da92728b1a71de0a9e060b2905d6a5b67ecd3b" ++
            "3692ddbd7f2d778b8c9803aee328091b58fab324e4fad675945585808b4831" ++
            "d7bc3ff4def08e4b7a9de576d26586cec64b6116",
    );
    const expected_tag = hex(16, "1ae10b594f09e26a7e902ecbd0600691");

    var ciphertext: [plaintext.len]u8 = undefined;
    var tag: Tag = undefined;
    const aead: Aead = .{ .chacha20_poly1305 = key };
    aead.encrypt(&ciphertext, &tag, &plaintext, &ad, &npub);

    try testing.expectEqualSlices(u8, &expected_ciphertext, &ciphertext);
    try testing.expectEqualSlices(u8, &expected_tag, &tag.data);

    var decrypted: [plaintext.len]u8 = undefined;
    try aead.decrypt(&decrypted, &ciphertext, &tag, &ad, &npub);
    try testing.expectEqualSlices(u8, &plaintext, &decrypted);
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
