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

const backend = @import("crypto/backend.zig");
const CipherSuite = @import("cipher_suite.zig").CipherSuite;
const memx = @import("memx.zig");
const hex = memx.hex;

pub const nonce_len = 12;
pub const Nonce = memx.Array(nonce_len);
pub const Iv = memx.Array(nonce_len);

// ziglint-ignore: Z006
const NonceVec = @Vector(nonce_len, u8);

/// Construct the per-record nonce by XORing the IV with the sequence number.
///
/// The sequence number is right-aligned as a big-endian u64 in a 12-byte
/// buffer (zero-padded on the left), then XORed with the IV.
///
/// RFC 8446 §5.3
pub fn construct(iv: *const Iv, seq: u64) Nonce {
    var padded: [nonce_len]u8 = @splat(0);
    padded[4..12].* = memx.toBytes(u64, seq);

    const a: NonceVec = iv.data;
    const b: NonceVec = padded;
    return .init(@as([nonce_len]u8, a ^ b));
}

comptime {
    assert(@sizeOf(Nonce) == 12);
}

/// Authentication tag — 16 bytes for all TLS 1.3 ciphers.
pub const tag_len = 16;
pub const Tag = memx.Array(tag_len);

pub const Aes128GcmKey = memx.Array(16);
pub const Aes256GcmKey = memx.Array(32);
pub const ChaCha20Poly1305Key = memx.Array(32);

pub const Error = backend.aead.Error;

/// A cipher context holding the key for one direction of a TLS connection.
pub const Aead = union(CipherSuite) {
    aes_128_gcm_sha256: Aes128GcmKey,
    chacha20_poly1305_sha256: ChaCha20Poly1305Key,
    aes_256_gcm_sha384: Aes256GcmKey,

    pub fn suite(self: Aead) CipherSuite {
        return switch (self) {
            .aes_128_gcm_sha256 => .aes_128_gcm_sha256,
            .aes_256_gcm_sha384 => .aes_256_gcm_sha384,
            .chacha20_poly1305_sha256 => .chacha20_poly1305_sha256,
        };
    }

    pub fn keyUsageLimit(self: Aead) u64 {
        return switch (self.suite()) {
            .aes_128_gcm_sha256, .aes_256_gcm_sha384 => 1 << 24,
            .chacha20_poly1305_sha256 => 1 << 36,
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
        assert(self.suite() == ctx.suite);
        try backend.aead.encrypt(&ctx.inner, ciphertext, &tag.data, plaintext, ad, &npub.data);
    }

    /// Decrypt `ciphertext` into `plaintext` and verify the authentication tag.
    /// `plaintext` must be the same length as `ciphertext`.
    ///
    /// Returns `error.AuthenticationFailed` if the tag does not verify.
    /// On failure the `plaintext` buffer contains backend-owned failure output:
    /// some backends leave unauthenticated plaintext, while others zero the
    /// buffer. Callers at the RecordLayer level treat the buffer as poisoned and
    /// must not inspect it after this error.
    pub fn decrypt(
        self: Aead,
        ctx: *Context,
        plaintext: []u8,
        ciphertext: []const u8,
        tag: *const Tag,
        ad: []const u8,
        npub: *const Nonce,
    ) Error!void {
        assert(self.suite() == ctx.suite);
        try backend.aead.decrypt(&ctx.inner, plaintext, ciphertext, &tag.data, ad, &npub.data);
    }
};

pub const Context = struct {
    suite: CipherSuite,
    inner: backend.aead.Context,

    pub fn init(aead: Aead) Error!Context {
        return .{
            .suite = aead.suite(),
            .inner = try backend.aead.init(aead.suite(), aead.keyBytes()),
        };
    }

    pub fn deinit(self: *Context) void {
        backend.aead.deinit(&self.inner);
        self.* = undefined;
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
    const aead: Aead = .{ .aes_128_gcm_sha256 = key };
    var ctx: Context = try .init(aead);
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
    const aead: Aead = .{ .aes_256_gcm_sha384 = key };
    var ctx: Context = try .init(aead);
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
    const aead: Aead = .{ .chacha20_poly1305_sha256 = key };
    var ctx: Context = try .init(aead);
    defer ctx.deinit();
    try aead.encrypt(&ctx, &ciphertext, &tag, plaintext, ad, &npub);

    var decrypted: [plaintext.len]u8 = undefined;
    try aead.decrypt(&ctx, &decrypted, &ciphertext, &tag, ad, &npub);
    try testing.expectEqualSlices(u8, plaintext, &decrypted);
}

// RFC 8439 §2.8.2 — ChaCha20-Poly1305 AEAD construction test vector
test "ChaCha20Poly1305: RFC 8439 known-answer vector" {
    const key: ChaCha20Poly1305Key = .init(hex(
        32,
        "808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9f",
    ));
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
    const aead: Aead = .{ .chacha20_poly1305_sha256 = key };
    var ctx: Context = try .init(aead);
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
    const key: ChaCha20Poly1305Key = .init(hex(
        32,
        "1c9240a5eb55d38af333888604f6b5f0473917c1402b80099dca5cbc207075c0",
    ));
    const npub: Nonce = .init(hex(12, "000000000102030405060708"));
    const ad = hex(12, "f33388860000000000004e91");
    const expected_tag = hex(16, "66f09890d77129cc79e1ed577bd95c04");

    var tag: Tag = undefined;
    const aead: Aead = .{ .chacha20_poly1305_sha256 = key };
    var ctx: Context = try .init(aead);
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
    const aead: Aead = .{ .chacha20_poly1305_sha256 = key };
    var ctx: Context = try .init(aead);
    defer ctx.deinit();
    try aead.encrypt(&ctx, &ciphertext, &tag, plaintext, ad, &npub);

    ciphertext[0] ^= 0xff;
    var decrypted: [plaintext.len]u8 = undefined;
    try testing.expectError(
        error.AuthenticationFailed,
        aead.decrypt(&ctx, &decrypted, &ciphertext, &tag, ad, &npub),
    );
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
    const aead: Aead = .{ .chacha20_poly1305_sha256 = key };
    var ctx: Context = try .init(aead);
    defer ctx.deinit();
    try aead.encrypt(&ctx, &ciphertext, &tag, plaintext, ad, &npub);

    tag.data[0] ^= 0xff;
    var decrypted: [plaintext.len]u8 = undefined;
    try testing.expectError(
        error.AuthenticationFailed,
        aead.decrypt(&ctx, &decrypted, &ciphertext, &tag, ad, &npub),
    );
}

// RFC 8439 §2.8 — ChaCha20-Poly1305 authenticates associated data.
test "ChaCha20Poly1305: authentication failure on tampered ad" {
    const key: ChaCha20Poly1305Key = .init(@splat(0x01));
    const iv: Iv = .init(@splat(0x02));
    const npub = construct(&iv, 0);
    const plaintext = "secret";

    var ciphertext: [plaintext.len]u8 = undefined;
    var tag: Tag = undefined;
    const aead: Aead = .{ .chacha20_poly1305_sha256 = key };
    var ctx: Context = try .init(aead);
    defer ctx.deinit();
    try aead.encrypt(&ctx, &ciphertext, &tag, plaintext, "header", &npub);

    var decrypted: [plaintext.len]u8 = undefined;
    try testing.expectError(
        error.AuthenticationFailed,
        aead.decrypt(&ctx, &decrypted, &ciphertext, &tag, "HEADER", &npub),
    );
}

test "decrypt: authentication failure on tampered ciphertext" {
    const key: Aes128GcmKey = .init(@splat(0x01));
    const iv: Iv = .init(@splat(0x02));
    const npub = construct(&iv, 0);
    const ad = "header";
    const plaintext = "secret";

    var ciphertext: [plaintext.len]u8 = undefined;
    var tag: Tag = undefined;
    const aead: Aead = .{ .aes_128_gcm_sha256 = key };
    var ctx: Context = try .init(aead);
    defer ctx.deinit();
    try aead.encrypt(&ctx, &ciphertext, &tag, plaintext, ad, &npub);

    ciphertext[0] ^= 0xff;
    var decrypted: [plaintext.len]u8 = undefined;
    try testing.expectError(
        error.AuthenticationFailed,
        aead.decrypt(&ctx, &decrypted, &ciphertext, &tag, ad, &npub),
    );
}

test "decrypt: authentication failure on tampered tag" {
    const key: Aes128GcmKey = .init(@splat(0x01));
    const iv: Iv = .init(@splat(0x02));
    const npub = construct(&iv, 0);
    const ad = "header";
    const plaintext = "secret";

    var ciphertext: [plaintext.len]u8 = undefined;
    var tag: Tag = undefined;
    const aead: Aead = .{ .aes_128_gcm_sha256 = key };
    var ctx: Context = try .init(aead);
    defer ctx.deinit();
    try aead.encrypt(&ctx, &ciphertext, &tag, plaintext, ad, &npub);

    tag.data[0] ^= 0xff;
    var decrypted: [plaintext.len]u8 = undefined;
    try testing.expectError(
        error.AuthenticationFailed,
        aead.decrypt(&ctx, &decrypted, &ciphertext, &tag, ad, &npub),
    );
}

test "decrypt: authentication failure on tampered ad" {
    const key: Aes128GcmKey = .init(@splat(0x01));
    const iv: Iv = .init(@splat(0x02));
    const npub = construct(&iv, 0);
    const plaintext = "secret";

    var ciphertext: [plaintext.len]u8 = undefined;
    var tag: Tag = undefined;
    const aead: Aead = .{ .aes_128_gcm_sha256 = key };
    var ctx: Context = try .init(aead);
    defer ctx.deinit();
    try aead.encrypt(&ctx, &ciphertext, &tag, plaintext, "header", &npub);

    var decrypted: [plaintext.len]u8 = undefined;
    try testing.expectError(
        error.AuthenticationFailed,
        aead.decrypt(&ctx, &decrypted, &ciphertext, &tag, "HEADER", &npub),
    );
}

// RFC 8446 §5.3 — nonce construction
test "construct: seq 0 is just the IV" {
    const iv: Iv = .init(.{
        0x00, 0x01, 0x02, 0x03, 0x04, 0x05,
        0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b,
    });
    const nonce = construct(&iv, 0);
    try testing.expectEqualSlices(u8, &iv.data, &nonce.data);
}

test "construct: seq increments flip the right bytes" {
    const iv: Iv = .zero;
    try testing.expectEqual(Nonce.init(.{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 }), construct(&iv, 1));
    try testing.expectEqual(
        Nonce.init(.{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255 }),
        construct(&iv, 255),
    );
    try testing.expectEqual(
        Nonce.init(.{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0 }),
        construct(&iv, 256),
    );
}

test "construct: XOR with non-zero IV" {
    const iv: Iv = .init(@splat(0xff));
    try testing.expectEqual(
        Nonce.init(.{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe }),
        construct(&iv, 1),
    );
}

test "construct: seq max u64 produces expected nonce" {
    const iv: Iv = .zero;
    try testing.expectEqual(
        Nonce.init(.{ 0, 0, 0, 0, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff }),
        construct(&iv, 0xffffffffffffffff),
    );
}
