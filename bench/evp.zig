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

fn setupEvp(
    comptime suite: Suite,
    buf: []u8,
    nonce: *[12]u8,
    tag: *[16]u8,
) ?*c.EVP_CIPHER_CTX {
    _ = c.ERR_clear_error();

    const ctx = c.EVP_CIPHER_CTX_new() orelse return null;
    var key: [suite.key_len]u8 = @splat(0xab);

    if (c.EVP_CipherInit_ex2(ctx, suite.cipher(), &key, nonce, 1, null) != 1) {
        c.EVP_CIPHER_CTX_free(ctx);
        return null;
    }
    if (c.EVP_CIPHER_CTX_ctrl(ctx, c.EVP_CTRL_GCM_SET_IVLEN, @intCast(suite.iv_len), null) != 1) {
        c.EVP_CIPHER_CTX_free(ctx);
        return null;
    }
    if (c.EVP_CipherInit_ex2(ctx, null, &key, nonce, 1, null) != 1) {
        c.EVP_CIPHER_CTX_free(ctx);
        return null;
    }

    var out_len: c_int = 0;
    const aad = "tls13_record";
    _ = c.EVP_CipherUpdate(ctx, null, &out_len, aad, @intCast(aad.len));

    _ = c.EVP_CipherUpdate(ctx, buf.ptr, &out_len, buf.ptr, @intCast(buf.len));
    _ = c.EVP_CipherFinal_ex(ctx, buf.ptr, &out_len);
    _ = c.EVP_CIPHER_CTX_ctrl(ctx, c.EVP_CTRL_GCM_GET_TAG, @intCast(suite.tag_len), tag);

    return ctx;
}

fn encryptClosure(comptime suite: Suite, comptime size: usize) bench.Function {
    return struct {
        fn f(b: *bench.B) !void {
            var buf: [size]u8 = @splat(0xde);
            var nonce: [12]u8 = @splat(0xad);
            var tag: [16]u8 = undefined;

            const ctx = setupEvp(suite, &buf, &nonce, &tag) orelse return error.OpenSSLInit;
            defer c.EVP_CIPHER_CTX_free(ctx);

            b.setBytes(buf.len);
            while (try b.loop()) {
                var out_len: c_int = 0;
                _ = c.EVP_CipherUpdate(ctx, &buf, &out_len, &buf, @intCast(buf.len));
                _ = c.EVP_CipherFinal_ex(ctx, &buf, &out_len);
                _ = c.EVP_CIPHER_CTX_ctrl(ctx, c.EVP_CTRL_GCM_GET_TAG, @intCast(tag.len), &tag);
                b.keepAlive(tag);
            }
        }
    }.f;
}

fn decryptClosure(comptime suite: Suite, comptime size: usize) bench.Function {
    return struct {
        fn f(b: *bench.B) !void {
            var buf: [size]u8 = @splat(0xde);
            var nonce: [12]u8 = @splat(0xad);
            var tag: [16]u8 = undefined;

            const enc_ctx = setupEvp(suite, &buf, &nonce, &tag) orelse return error.OpenSSLInit;
            defer c.EVP_CIPHER_CTX_free(enc_ctx);

            const dec_ctx = c.EVP_CIPHER_CTX_new() orelse return error.OpenSSLInit;
            defer c.EVP_CIPHER_CTX_free(dec_ctx);
            var key: [suite.key_len]u8 = @splat(0xab);
            if (c.EVP_CipherInit_ex2(dec_ctx, suite.cipher(), &key, &nonce, 0, null) != 1) {
                return error.OpenSSLInit;
            }
            if (c.EVP_CIPHER_CTX_ctrl(
                dec_ctx,
                c.EVP_CTRL_GCM_SET_IVLEN,
                @intCast(suite.iv_len),
                null,
            ) != 1) return error.OpenSSLInit;

            var out_len: c_int = 0;
            const aad = "tls13_record";
            _ = c.EVP_CipherUpdate(dec_ctx, null, &out_len, aad, @intCast(aad.len));

            b.setBytes(buf.len);
            while (try b.loop()) {
                out_len = 0;
                _ = c.EVP_CipherUpdate(dec_ctx, &buf, &out_len, &buf, @intCast(buf.len));
                _ = c.EVP_CipherFinal_ex(dec_ctx, &buf, &out_len);
                b.keepAlive(buf);
            }
        }
    }.f;
}

fn bulkEncryptOnceClosure(comptime suite: Suite, comptime size: usize) bench.Function {
    return struct {
        fn f(b: *bench.B) !void {
            var buf: [size]u8 = @splat(0xde);
            var nonce: [12]u8 = @splat(0xad);
            var tag: [16]u8 = undefined;

            const ctx = c.EVP_CIPHER_CTX_new() orelse return error.OpenSSLInit;
            defer c.EVP_CIPHER_CTX_free(ctx);
            var key: [suite.key_len]u8 = @splat(0xab);
            nonce = @splat(0xad);

            if (c.EVP_CipherInit_ex2(ctx, suite.cipher(), &key, &nonce, 1, null) != 1) {
                return error.OpenSSLInit;
            }
            if (c.EVP_CIPHER_CTX_ctrl(
                ctx,
                c.EVP_CTRL_GCM_SET_IVLEN,
                @intCast(suite.iv_len),
                null,
            ) != 1) return error.OpenSSLInit;

            var out_len: c_int = 0;
            const aad = "tls13_record";
            _ = c.EVP_CipherUpdate(ctx, null, &out_len, aad, @intCast(aad.len));

            b.setBytes(buf.len);
            while (try b.loop()) {
                out_len = 0;
                _ = c.EVP_CipherUpdate(ctx, &buf, &out_len, &buf, @intCast(buf.len));
                _ = c.EVP_CipherFinal_ex(ctx, &buf, &out_len);
                _ = c.EVP_CIPHER_CTX_ctrl(ctx, c.EVP_CTRL_GCM_GET_TAG, @intCast(tag.len), &tag);
                b.keepAlive(tag);
            }
        }
    }.f;
}

fn bulkDecryptOnceClosure(comptime suite: Suite, comptime size: usize) bench.Function {
    return struct {
        fn f(b: *bench.B) !void {
            var buf: [size]u8 = @splat(0xde);
            var nonce: [12]u8 = @splat(0xad);
            var tag: [16]u8 = undefined;

            const enc_ctx = setupEvp(suite, &buf, &nonce, &tag) orelse return error.OpenSSLInit;
            defer c.EVP_CIPHER_CTX_free(enc_ctx);

            const dec_ctx = c.EVP_CIPHER_CTX_new() orelse return error.OpenSSLInit;
            defer c.EVP_CIPHER_CTX_free(dec_ctx);
            var key: [suite.key_len]u8 = @splat(0xab);
            if (c.EVP_CipherInit_ex2(dec_ctx, suite.cipher(), &key, &nonce, 0, null) != 1) {
                return error.OpenSSLInit;
            }
            if (c.EVP_CIPHER_CTX_ctrl(
                dec_ctx,
                c.EVP_CTRL_GCM_SET_IVLEN,
                @intCast(suite.iv_len),
                null,
            ) != 1) return error.OpenSSLInit;

            var out_len: c_int = 0;
            const aad = "tls13_record";
            _ = c.EVP_CipherUpdate(dec_ctx, null, &out_len, aad, @intCast(aad.len));

            b.setBytes(buf.len);
            while (try b.loop()) {
                out_len = 0;
                _ = c.EVP_CipherUpdate(dec_ctx, &buf, &out_len, &buf, @intCast(buf.len));
                _ = c.EVP_CipherFinal_ex(dec_ctx, &buf, &out_len);
                b.keepAlive(buf);
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
