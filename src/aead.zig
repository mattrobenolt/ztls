//! AEAD cipher wrapper for TLS 1.3.
//!
//! TLS 1.3 mandates three AEAD cipher suites (RFC 8446 §9.1):
//!   - TLS_AES_128_GCM_SHA256
//!   - TLS_AES_256_GCM_SHA384
//!   - TLS_CHACHA20_POLY1305_SHA256
//!
//! All three share the same tag length (16 bytes) and nonce length (12 bytes).
//! Keys are derived during the handshake and held for the connection lifetime.
const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;

const c = @import("c.zig").openssl;
const construct = @import("nonce.zig").construct;
pub const Iv = @import("nonce.zig").Iv;
const memx = @import("memx.zig");
const Nonce = @import("nonce.zig").Nonce;

comptime {
    assert(@sizeOf(Nonce) == 12);
}

/// Authentication tag — 16 bytes for all TLS 1.3 ciphers.
pub const tag_len = 16;
pub const Tag = memx.Array(tag_len);

pub const Aes128GcmKey = memx.Array(16);
pub const Aes256GcmKey = memx.Array(32);
pub const ChaCha20Poly1305Key = memx.Array(32);

pub const Error = error{
    AuthenticationFailed,
    AeadSetupFailed,
    AeadEncryptFailed,
};

/// The set of supported AEAD cipher suites.
pub const Keys = enum {
    aes128_gcm,
    aes256_gcm,
    chacha20_poly1305,
};

/// A cipher context holding the key for one direction of a TLS connection.
pub const Aead = union(Keys) {
    aes128_gcm: Aes128GcmKey,
    aes256_gcm: Aes256GcmKey,
    chacha20_poly1305: ChaCha20Poly1305Key,

    pub fn suite(self: Aead) Keys {
        return switch (self) {
            .aes128_gcm => .aes128_gcm,
            .aes256_gcm => .aes256_gcm,
            .chacha20_poly1305 => .chacha20_poly1305,
        };
    }

    pub fn keyUsageLimit(self: Aead) u64 {
        return switch (self.suite()) {
            .aes128_gcm, .aes256_gcm => 1 << 24,
            .chacha20_poly1305 => 1 << 36,
        };
    }

    pub fn secureZero(self: *Aead) void {
        std.crypto.secureZero(u8, std.mem.asBytes(self));
    }

    fn keyBytes(self: *const Aead) []const u8 {
        return switch (self.*) {
            inline else => |*key| &key.data,
        };
    }

    /// Encrypt `plaintext` into `ciphertext` and write the authentication tag.
    /// `ciphertext` must be the same length as `plaintext`.
    /// `ad` is authenticated but not encrypted (the TLS record header).
    pub fn encrypt(
        self: Aead,
        ctx: *Context,
        ciphertext: []u8,
        tag: *Tag,
        plaintext: []const u8,
        ad: []const u8,
        npub: *const Nonce,
    ) Error!void {
        _ = self;
        try opensslEncrypt(ctx, ciphertext, tag, plaintext, ad, npub);
    }

    /// Decrypt `ciphertext` into `plaintext` and verify the authentication tag.
    /// `plaintext` must be the same length as `ciphertext`.
    /// Returns `error.AuthenticationFailed` if the tag does not verify.
    pub fn decrypt(
        self: Aead,
        ctx: *Context,
        plaintext: []u8,
        ciphertext: []const u8,
        tag: *const Tag,
        ad: []const u8,
        npub: *const Nonce,
    ) Error!void {
        _ = self;
        try opensslDecrypt(ctx, plaintext, ciphertext, tag, ad, npub);
    }
};

pub const Context = struct {
    enc: *c.EVP_CIPHER_CTX,
    dec: *c.EVP_CIPHER_CTX,

    pub fn init(aead: Aead) Error!Context {
        const enc = c.EVP_CIPHER_CTX_new() orelse return error.AeadSetupFailed;
        errdefer c.EVP_CIPHER_CTX_free(enc);
        const dec = c.EVP_CIPHER_CTX_new() orelse return error.AeadSetupFailed;
        errdefer c.EVP_CIPHER_CTX_free(dec);

        try opensslInit(enc, aead, .encrypt);
        try opensslInit(dec, aead, .decrypt);
        return .{ .enc = enc, .dec = dec };
    }

    pub fn deinit(self: *Context) void {
        c.EVP_CIPHER_CTX_free(self.enc);
        c.EVP_CIPHER_CTX_free(self.dec);
        self.* = undefined;
    }
};

const OpensslDirection = enum { encrypt, decrypt };

fn opensslCipher(suite: Keys) *const c.EVP_CIPHER {
    return switch (suite) {
        .aes128_gcm => c.EVP_aes_128_gcm(),
        .aes256_gcm => c.EVP_aes_256_gcm(),
        .chacha20_poly1305 => c.EVP_chacha20_poly1305(),
    } orelse unreachable;
}

fn opensslInit(ctx: *c.EVP_CIPHER_CTX, aead: Aead, direction: OpensslDirection) Error!void {
    switch (direction) {
        .encrypt => {
            if (c.EVP_EncryptInit_ex(ctx, opensslCipher(aead.suite()), null, null, null) != 1) return error.AeadSetupFailed;
            if (c.EVP_CIPHER_CTX_ctrl(ctx, c.EVP_CTRL_AEAD_SET_IVLEN, @sizeOf(Nonce), null) != 1) return error.AeadSetupFailed;
            if (c.EVP_EncryptInit_ex(ctx, null, null, aead.keyBytes().ptr, null) != 1) return error.AeadSetupFailed;
        },
        .decrypt => {
            if (c.EVP_DecryptInit_ex(ctx, opensslCipher(aead.suite()), null, null, null) != 1) return error.AeadSetupFailed;
            if (c.EVP_CIPHER_CTX_ctrl(ctx, c.EVP_CTRL_AEAD_SET_IVLEN, @sizeOf(Nonce), null) != 1) return error.AeadSetupFailed;
            if (c.EVP_DecryptInit_ex(ctx, null, null, aead.keyBytes().ptr, null) != 1) return error.AeadSetupFailed;
        },
    }
}

fn opensslEncrypt(
    ctx: *Context,
    ciphertext: []u8,
    tag: *Tag,
    plaintext: []const u8,
    ad: []const u8,
    npub: *const Nonce,
) Error!void {
    var len: c_int = 0;
    var out_len: c_int = 0;
    if (c.EVP_EncryptInit_ex(ctx.enc, null, null, null, &npub.data) != 1) return error.AeadEncryptFailed;
    if (c.EVP_EncryptUpdate(ctx.enc, null, &len, ad.ptr, @intCast(ad.len)) != 1) return error.AeadEncryptFailed;
    if (c.EVP_EncryptUpdate(ctx.enc, ciphertext.ptr, &len, plaintext.ptr, @intCast(plaintext.len)) != 1) return error.AeadEncryptFailed;
    out_len += len;
    if (c.EVP_EncryptFinal_ex(ctx.enc, ciphertext.ptr + @as(usize, @intCast(out_len)), &len) != 1) return error.AeadEncryptFailed;
    if (c.EVP_CIPHER_CTX_ctrl(ctx.enc, c.EVP_CTRL_AEAD_GET_TAG, tag_len, &tag.data) != 1) return error.AeadEncryptFailed;
}

fn opensslDecrypt(
    ctx: *Context,
    plaintext: []u8,
    ciphertext: []const u8,
    tag: *const Tag,
    ad: []const u8,
    npub: *const Nonce,
) Error!void {
    var len: c_int = 0;
    var out_len: c_int = 0;
    if (c.EVP_DecryptInit_ex(ctx.dec, null, null, null, &npub.data) != 1) return error.AuthenticationFailed;
    if (c.EVP_DecryptUpdate(ctx.dec, null, &len, ad.ptr, @intCast(ad.len)) != 1) return error.AuthenticationFailed;
    if (c.EVP_DecryptUpdate(ctx.dec, plaintext.ptr, &len, ciphertext.ptr, @intCast(ciphertext.len)) != 1) return error.AuthenticationFailed;
    out_len += len;
    if (c.EVP_CIPHER_CTX_ctrl(ctx.dec, c.EVP_CTRL_AEAD_SET_TAG, tag_len, @constCast(&tag.data)) != 1) return error.AuthenticationFailed;
    if (c.EVP_DecryptFinal_ex(ctx.dec, plaintext.ptr + @as(usize, @intCast(out_len)), &len) != 1) return error.AuthenticationFailed;
}

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
    var ctx = try Context.init(aead);
    defer ctx.deinit();
    try aead.encrypt(&ctx, &ciphertext, &tag, plaintext, ad, &npub);

    var decrypted: [plaintext.len]u8 = undefined;
    try aead.decrypt(&ctx, &decrypted, &ciphertext, &tag, ad, &npub);
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
    var ctx = try Context.init(aead);
    defer ctx.deinit();
    try aead.encrypt(&ctx, &ciphertext, &tag, plaintext, ad, &npub);

    var decrypted: [plaintext.len]u8 = undefined;
    try aead.decrypt(&ctx, &decrypted, &ciphertext, &tag, ad, &npub);
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
    var ctx = try Context.init(aead);
    defer ctx.deinit();
    try aead.encrypt(&ctx, &ciphertext, &tag, plaintext, ad, &npub);

    var decrypted: [plaintext.len]u8 = undefined;
    try aead.decrypt(&ctx, &decrypted, &ciphertext, &tag, ad, &npub);
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
    var ctx = try Context.init(aead);
    defer ctx.deinit();
    try aead.encrypt(&ctx, &ciphertext, &tag, &plaintext, &ad, &npub);

    try testing.expectEqualSlices(u8, &expected_ciphertext, &ciphertext);
    try testing.expectEqualSlices(u8, &expected_tag, &tag.data);

    var decrypted: [plaintext.len]u8 = undefined;
    try aead.decrypt(&ctx, &decrypted, &ciphertext, &tag, &ad, &npub);
    try testing.expectEqualSlices(u8, &plaintext, &decrypted);
}

// RFC 8439 §2.8 — empty plaintext authenticates AAD and lengths.
test "ChaCha20Poly1305: empty plaintext known-answer vector" {
    const key: ChaCha20Poly1305Key = .init(hex(32, "1c9240a5eb55d38af333888604f6b5f0473917c1402b80099dca5cbc207075c0"));
    const npub: Nonce = .init(hex(12, "000000000102030405060708"));
    const ad = hex(12, "f33388860000000000004e91");
    const expected_tag = hex(16, "66f09890d77129cc79e1ed577bd95c04");

    var tag: Tag = undefined;
    const aead: Aead = .{ .chacha20_poly1305 = key };
    var ctx = try Context.init(aead);
    defer ctx.deinit();
    try aead.encrypt(&ctx, &.{}, &tag, &.{}, &ad, &npub);
    try testing.expectEqualSlices(u8, &expected_tag, &tag.data);
    try aead.decrypt(&ctx, &.{}, &.{}, &tag, &ad, &npub);
}

// RFC 8439 §2.8 — ChaCha20-Poly1305 rejects forged ciphertexts.
test "ChaCha20Poly1305: authentication failure on tampered ciphertext" {
    const key: ChaCha20Poly1305Key = .init(@splat(0x01));
    const iv: Iv = .init(@splat(0x02));
    const npub = construct(&iv, 0);
    const ad = "header";
    const plaintext = "secret";

    var ciphertext: [plaintext.len]u8 = undefined;
    var tag: Tag = undefined;
    const aead: Aead = .{ .chacha20_poly1305 = key };
    var ctx = try Context.init(aead);
    defer ctx.deinit();
    try aead.encrypt(&ctx, &ciphertext, &tag, plaintext, ad, &npub);

    ciphertext[0] ^= 0xff;
    var decrypted: [plaintext.len]u8 = undefined;
    try testing.expectError(error.AuthenticationFailed, aead.decrypt(&ctx, &decrypted, &ciphertext, &tag, ad, &npub));
}

// RFC 8439 §2.8 — ChaCha20-Poly1305 rejects forged tags.
test "ChaCha20Poly1305: authentication failure on tampered tag" {
    const key: ChaCha20Poly1305Key = .init(@splat(0x01));
    const iv: Iv = .init(@splat(0x02));
    const npub = construct(&iv, 0);
    const ad = "header";
    const plaintext = "secret";

    var ciphertext: [plaintext.len]u8 = undefined;
    var tag: Tag = undefined;
    const aead: Aead = .{ .chacha20_poly1305 = key };
    var ctx = try Context.init(aead);
    defer ctx.deinit();
    try aead.encrypt(&ctx, &ciphertext, &tag, plaintext, ad, &npub);

    tag.data[0] ^= 0xff;
    var decrypted: [plaintext.len]u8 = undefined;
    try testing.expectError(error.AuthenticationFailed, aead.decrypt(&ctx, &decrypted, &ciphertext, &tag, ad, &npub));
}

// RFC 8439 §2.8 — ChaCha20-Poly1305 authenticates associated data.
test "ChaCha20Poly1305: authentication failure on tampered ad" {
    const key: ChaCha20Poly1305Key = .init(@splat(0x01));
    const iv: Iv = .init(@splat(0x02));
    const npub = construct(&iv, 0);
    const plaintext = "secret";

    var ciphertext: [plaintext.len]u8 = undefined;
    var tag: Tag = undefined;
    const aead: Aead = .{ .chacha20_poly1305 = key };
    var ctx = try Context.init(aead);
    defer ctx.deinit();
    try aead.encrypt(&ctx, &ciphertext, &tag, plaintext, "header", &npub);

    var decrypted: [plaintext.len]u8 = undefined;
    try testing.expectError(error.AuthenticationFailed, aead.decrypt(&ctx, &decrypted, &ciphertext, &tag, "HEADER", &npub));
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
    var ctx = try Context.init(aead);
    defer ctx.deinit();
    try aead.encrypt(&ctx, &ciphertext, &tag, plaintext, ad, &npub);

    ciphertext[0] ^= 0xff;
    var decrypted: [plaintext.len]u8 = undefined;
    try testing.expectError(error.AuthenticationFailed, aead.decrypt(&ctx, &decrypted, &ciphertext, &tag, ad, &npub));
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
    var ctx = try Context.init(aead);
    defer ctx.deinit();
    try aead.encrypt(&ctx, &ciphertext, &tag, plaintext, ad, &npub);

    tag.data[0] ^= 0xff;
    var decrypted: [plaintext.len]u8 = undefined;
    try testing.expectError(error.AuthenticationFailed, aead.decrypt(&ctx, &decrypted, &ciphertext, &tag, ad, &npub));
}

test "decrypt: authentication failure on tampered ad" {
    const key: Aes128GcmKey = .init(@splat(0x01));
    const iv: Iv = .init(@splat(0x02));
    const npub = construct(&iv, 0);
    const plaintext = "secret";

    var ciphertext: [plaintext.len]u8 = undefined;
    var tag: Tag = undefined;
    const aead: Aead = .{ .aes128_gcm = key };
    var ctx = try Context.init(aead);
    defer ctx.deinit();
    try aead.encrypt(&ctx, &ciphertext, &tag, plaintext, "header", &npub);

    var decrypted: [plaintext.len]u8 = undefined;
    try testing.expectError(error.AuthenticationFailed, aead.decrypt(&ctx, &decrypted, &ciphertext, &tag, "HEADER", &npub));
}
