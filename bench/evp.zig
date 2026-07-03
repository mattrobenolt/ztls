const std = @import("std");

const bench = @import("benchmark");
const c = @import("c").openssl;
const Suite = struct {
    name: []const u8,
    cipher: *const fn () callconv(.c) ?*const c.EVP_CIPHER,
    key_len: usize,
    iv_len: usize,
    tag_len: usize,
};

const suites = [_]Suite{
    .{
        .name = "AES_128_GCM",
        .cipher = c.EVP_aes_128_gcm,
        .key_len = 16,
        .iv_len = 12,
        .tag_len = 16,
    },
    .{
        .name = "AES_256_GCM",
        .cipher = c.EVP_aes_256_gcm,
        .key_len = 32,
        .iv_len = 12,
        .tag_len = 16,
    },
    .{
        .name = "CHACHA20_POLY1305",
        .cipher = c.EVP_chacha20_poly1305,
        .key_len = 32,
        .iv_len = 12,
        .tag_len = 16,
    },
};

const sizes = [_]usize{ 16, 32, 64, 128, 256, 512, 1024, 1350, 8192, 16384 };

const aad = "tls13_record";

fn initCipher(
    comptime suite: Suite,
    ctx: *c.EVP_CIPHER_CTX,
    key: *const [suite.key_len]u8,
    nonce: *const [12]u8,
    encrypt: bool,
) !void {
    _ = c.ERR_clear_error();
    const enc: c_int = if (encrypt) 1 else 0;
    if (c.EVP_CipherInit_ex2(ctx, suite.cipher(), key, nonce, enc, null) != 1)
        return error.OpenSSLInit;
    if (c.EVP_CIPHER_CTX_ctrl(ctx, c.EVP_CTRL_GCM_SET_IVLEN, @intCast(suite.iv_len), null) != 1)
        return error.OpenSSLInit;
    if (c.EVP_CipherInit_ex2(ctx, null, key, nonce, enc, null) != 1)
        return error.OpenSSLInit;
}

fn resetCipher(ctx: *c.EVP_CIPHER_CTX, nonce: *const [12]u8, encrypt: bool) !void {
    const enc: c_int = if (encrypt) 1 else 0;
    if (c.EVP_CipherInit_ex2(ctx, null, null, nonce, enc, null) != 1)
        return error.OpenSSLInit;
}

fn encryptWithCtx(
    comptime suite: Suite,
    ctx: *c.EVP_CIPHER_CTX,
    src: []const u8,
    dst: []u8,
    nonce: *const [12]u8,
    tag: *[16]u8,
) !void {
    try resetCipher(ctx, nonce, true);
    var out_len: c_int = 0;
    if (c.EVP_CipherUpdate(ctx, null, &out_len, aad.ptr, @intCast(aad.len)) != 1)
        return error.OpenSSLInit;
    if (c.EVP_CipherUpdate(ctx, dst.ptr, &out_len, src.ptr, @intCast(src.len)) != 1)
        return error.OpenSSLInit;
    if (c.EVP_CipherFinal_ex(ctx, dst.ptr + @as(usize, @intCast(out_len)), &out_len) != 1)
        return error.OpenSSLInit;
    if (c.EVP_CIPHER_CTX_ctrl(ctx, c.EVP_CTRL_GCM_GET_TAG, @intCast(suite.tag_len), tag) != 1)
        return error.OpenSSLInit;
}

fn decryptWithCtx(
    comptime suite: Suite,
    ctx: *c.EVP_CIPHER_CTX,
    ciphertext: []const u8,
    plaintext: []u8,
    nonce: *const [12]u8,
    tag: *const [16]u8,
) !void {
    try resetCipher(ctx, nonce, false);
    var out_len: c_int = 0;
    if (c.EVP_CipherUpdate(ctx, null, &out_len, aad.ptr, @intCast(aad.len)) != 1)
        return error.OpenSSLInit;
    if (c.EVP_CipherUpdate(
        ctx,
        plaintext.ptr,
        &out_len,
        ciphertext.ptr,
        @intCast(ciphertext.len),
    ) != 1) return error.OpenSSLInit;
    if (c.EVP_CIPHER_CTX_ctrl(
        ctx,
        c.EVP_CTRL_GCM_SET_TAG,
        @intCast(suite.tag_len),
        @constCast(tag),
    ) != 1) return error.OpenSSLInit;
    if (c.EVP_CipherFinal_ex(ctx, plaintext.ptr + @as(usize, @intCast(out_len)), &out_len) != 1)
        return error.OpenSSLAuth;
}

fn makeCiphertext(
    comptime suite: Suite,
    comptime size: usize,
    plaintext: *const [size]u8,
    nonce: *const [12]u8,
    tag: *[16]u8,
) ![size]u8 {
    const ctx = c.EVP_CIPHER_CTX_new() orelse return error.OpenSSLInit;
    defer c.EVP_CIPHER_CTX_free(ctx);
    var key: [suite.key_len]u8 = @splat(0xab);
    try initCipher(suite, ctx, &key, nonce, true);
    var ciphertext: [size]u8 = undefined;
    try encryptWithCtx(suite, ctx, plaintext, &ciphertext, nonce, tag);
    return ciphertext;
}

fn encryptClosure(comptime suite: Suite, comptime size: usize) bench.Function {
    return struct {
        fn f(b: *bench.B) !void {
            const plaintext: [size]u8 = @splat(0xde);
            var ciphertext: [size]u8 = undefined;
            var nonce: [12]u8 = @splat(0xad);
            var tag: [16]u8 = undefined;
            var key: [suite.key_len]u8 = @splat(0xab);

            const ctx = c.EVP_CIPHER_CTX_new() orelse return error.OpenSSLInit;
            defer c.EVP_CIPHER_CTX_free(ctx);
            try initCipher(suite, ctx, &key, &nonce, true);

            b.setBytes(plaintext.len);
            while (try b.loop()) {
                try encryptWithCtx(suite, ctx, &plaintext, &ciphertext, &nonce, &tag);
                b.keepAlive(tag);
            }
        }
    }.f;
}

fn decryptClosure(comptime suite: Suite, comptime size: usize) bench.Function {
    return struct {
        fn f(b: *bench.B) !void {
            const plaintext: [size]u8 = @splat(0xde);
            var out: [size]u8 = undefined;
            var nonce: [12]u8 = @splat(0xad);
            var tag: [16]u8 = undefined;
            var key: [suite.key_len]u8 = @splat(0xab);
            const ciphertext = try makeCiphertext(suite, size, &plaintext, &nonce, &tag);

            const ctx = c.EVP_CIPHER_CTX_new() orelse return error.OpenSSLInit;
            defer c.EVP_CIPHER_CTX_free(ctx);
            try initCipher(suite, ctx, &key, &nonce, false);

            b.setBytes(ciphertext.len);
            while (try b.loop()) {
                try decryptWithCtx(suite, ctx, &ciphertext, &out, &nonce, &tag);
                b.keepAlive(out);
            }
        }
    }.f;
}

fn bulkEncryptOnceClosure(comptime suite: Suite, comptime size: usize) bench.Function {
    return struct {
        fn f(b: *bench.B) !void {
            const plaintext: [size]u8 = @splat(0xde);
            var ciphertext: [size]u8 = undefined;
            var nonce: [12]u8 = @splat(0xad);
            var tag: [16]u8 = undefined;
            var key: [suite.key_len]u8 = @splat(0xab);

            b.setBytes(plaintext.len);
            while (try b.loop()) {
                {
                    const ctx = c.EVP_CIPHER_CTX_new() orelse return error.OpenSSLInit;
                    defer c.EVP_CIPHER_CTX_free(ctx);
                    try initCipher(suite, ctx, &key, &nonce, true);
                    try encryptWithCtx(suite, ctx, &plaintext, &ciphertext, &nonce, &tag);
                }
                b.keepAlive(tag);
            }
        }
    }.f;
}

fn bulkDecryptOnceClosure(comptime suite: Suite, comptime size: usize) bench.Function {
    return struct {
        fn f(b: *bench.B) !void {
            const plaintext: [size]u8 = @splat(0xde);
            var out: [size]u8 = undefined;
            var nonce: [12]u8 = @splat(0xad);
            var tag: [16]u8 = undefined;
            var key: [suite.key_len]u8 = @splat(0xab);
            const ciphertext = try makeCiphertext(suite, size, &plaintext, &nonce, &tag);

            b.setBytes(ciphertext.len);
            while (try b.loop()) {
                {
                    const ctx = c.EVP_CIPHER_CTX_new() orelse return error.OpenSSLInit;
                    defer c.EVP_CIPHER_CTX_free(ctx);
                    try initCipher(suite, ctx, &key, &nonce, false);
                    try decryptWithCtx(suite, ctx, &ciphertext, &out, &nonce, &tag);
                }
                b.keepAlive(out);
            }
        }
    }.f;
}

pub fn benchmarkEncrypt(b: *bench.B) !void {
    @setEvalBranchQuota(1000000);
    inline for (suites) |suite| {
        inline for (sizes) |size| {
            const name = std.fmt.comptimePrint("{s}/{d}", .{ suite.name, size });
            _ = try b.run(name, encryptClosure(suite, size));
        }
    }
}

pub fn benchmarkDecrypt(b: *bench.B) !void {
    @setEvalBranchQuota(1000000);
    inline for (suites) |suite| {
        inline for (sizes) |size| {
            const name = std.fmt.comptimePrint("{s}/{d}", .{ suite.name, size });
            _ = try b.run(name, decryptClosure(suite, size));
        }
    }
}

pub fn benchmarkBulkEncryptOnce(b: *bench.B) !void {
    @setEvalBranchQuota(1000000);
    inline for (suites) |suite| {
        inline for (sizes) |size| {
            const name = std.fmt.comptimePrint("{s}/{d}", .{ suite.name, size });
            _ = try b.run(name, bulkEncryptOnceClosure(suite, size));
        }
    }
}

pub fn benchmarkBulkDecryptOnce(b: *bench.B) !void {
    @setEvalBranchQuota(1000000);
    inline for (suites) |suite| {
        inline for (sizes) |size| {
            const name = std.fmt.comptimePrint("{s}/{d}", .{ suite.name, size });
            _ = try b.run(name, bulkDecryptOnceClosure(suite, size));
        }
    }
}
