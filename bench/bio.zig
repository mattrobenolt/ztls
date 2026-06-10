const std = @import("std");
const assert = std.debug.assert;

const bench = @import("benchmark");
const c = @import("c_ssl").openssl;

const sizes = [_]usize{ 16, 128, 1350, 8192, 16384 };
const cert_path = "tests/fixtures/server.crt";
const key_path = "tests/fixtures/server.key";

const suites = [_][]const u8{
    "TLS_AES_128_GCM_SHA256",
    "TLS_AES_256_GCM_SHA384",
    "TLS_CHACHA20_POLY1305_SHA256",
};

const Contexts = struct {
    client: ?*c.SSL_CTX,
    server: ?*c.SSL_CTX,
};

const Conn = struct {
    client: ?*c.SSL,
    server: ?*c.SSL,
};

fn sslWriteAll(ssl: ?*c.SSL, buf: []const u8) void {
    var done: usize = 0;
    while (done < buf.len) {
        const rc = c.SSL_write(ssl, buf.ptr + done, @intCast(buf.len - done));
        if (rc > 0) {
            done += @intCast(rc);
            continue;
        }
        const err = c.SSL_get_error(ssl, rc);
        if (err == c.SSL_ERROR_WANT_READ or err == c.SSL_ERROR_WANT_WRITE) continue;
        @panic("SSL_write failed");
    }
}

fn sslReadExact(ssl: ?*c.SSL, buf: []u8) void {
    var done: usize = 0;
    while (done < buf.len) {
        const rc = c.SSL_read(ssl, buf.ptr + done, @intCast(buf.len - done));
        if (rc > 0) {
            done += @intCast(rc);
            continue;
        }
        const err = c.SSL_get_error(ssl, rc);
        if (err == c.SSL_ERROR_WANT_READ or err == c.SSL_ERROR_WANT_WRITE) continue;
        @panic("SSL_read failed");
    }
}

fn stepHandshake(ssl: ?*c.SSL) bool {
    const rc = c.SSL_do_handshake(ssl);
    if (rc == 1) return true;
    const err = c.SSL_get_error(ssl, rc);
    if (err == c.SSL_ERROR_WANT_READ or err == c.SSL_ERROR_WANT_WRITE) return false;
    @panic("SSL_do_handshake failed");
}

fn doHandshake(client: ?*c.SSL, server: ?*c.SSL) void {
    for (0..10000) |_| {
        const cd = c.SSL_is_init_finished(client) != 0 or stepHandshake(client);
        const sd = c.SSL_is_init_finished(server) != 0 or stepHandshake(server);
        if (cd and sd) return;
    }
    @panic("handshake did not converge");
}

fn makeContexts(suite: []const u8) Contexts {
    const client_ctx = c.SSL_CTX_new(c.TLS_method()) orelse @panic("SSL_CTX_new");
    const server_ctx = c.SSL_CTX_new(c.TLS_method()) orelse @panic("SSL_CTX_new");

    assert(c.SSL_CTX_set_min_proto_version(client_ctx, c.TLS1_3_VERSION) == 1);
    assert(c.SSL_CTX_set_max_proto_version(client_ctx, c.TLS1_3_VERSION) == 1);
    assert(c.SSL_CTX_set_min_proto_version(server_ctx, c.TLS1_3_VERSION) == 1);
    assert(c.SSL_CTX_set_max_proto_version(server_ctx, c.TLS1_3_VERSION) == 1);
    assert(c.SSL_CTX_set_ciphersuites(client_ctx, suite.ptr) == 1);
    assert(c.SSL_CTX_set_ciphersuites(server_ctx, suite.ptr) == 1);
    assert(c.SSL_CTX_set1_groups_list(client_ctx, "X25519") == 1);
    assert(c.SSL_CTX_set1_groups_list(server_ctx, "X25519") == 1);
    c.SSL_CTX_set_verify(client_ctx, c.SSL_VERIFY_NONE, null);
    c.SSL_CTX_set_verify(server_ctx, c.SSL_VERIFY_NONE, null);
    _ = c.SSL_CTX_set_num_tickets(server_ctx, 0);

    assert(c.SSL_CTX_use_certificate_file(server_ctx, cert_path.ptr, c.SSL_FILETYPE_PEM) == 1);
    assert(c.SSL_CTX_use_PrivateKey_file(server_ctx, key_path.ptr, c.SSL_FILETYPE_PEM) == 1);
    assert(c.SSL_CTX_check_private_key(server_ctx) == 1);

    return .{ .client = client_ctx, .server = server_ctx };
}

fn makeConn(ctxs: Contexts) Conn {
    const client = c.SSL_new(ctxs.client) orelse @panic("SSL_new");
    const server = c.SSL_new(ctxs.server) orelse @panic("SSL_new");

    var client_read: ?*c.BIO = null;
    var server_write: ?*c.BIO = null;
    var server_read: ?*c.BIO = null;
    var client_write: ?*c.BIO = null;

    assert(c.BIO_new_bio_pair(&client_read, 0, &server_write, 0) == 1);
    assert(c.BIO_new_bio_pair(&server_read, 0, &client_write, 0) == 1);

    c.SSL_set_bio(client, client_read, client_write);
    c.SSL_set_bio(server, server_read, server_write);
    c.SSL_set_connect_state(client);
    c.SSL_set_accept_state(server);

    return .{ .client = client, .server = server };
}

fn freeConn(conn: Conn) void {
    c.SSL_free(conn.client);
    c.SSL_free(conn.server);
}

fn freeContexts(ctxs: Contexts) void {
    c.SSL_CTX_free(ctxs.client);
    c.SSL_CTX_free(ctxs.server);
}

fn connected(ctxs: Contexts) Conn {
    const conn = makeConn(ctxs);
    doHandshake(conn.client, conn.server);
    return conn;
}

fn benchHandshake(comptime suite: []const u8) bench.Function {
    return struct {
        pub fn benchFn(b: *bench.B) !void {
            const ctxs = makeContexts(suite);
            defer freeContexts(ctxs);

            const warm = connected(ctxs);
            defer freeConn(warm);

            while (try b.loop()) {
                const conn = connected(ctxs);
                freeConn(conn);
            }
        }
    }.benchFn;
}

pub fn benchmarkHandshake(b: *bench.B) !void {
    @setEvalBranchQuota(1000000);
    var name_buf: [80]u8 = undefined;
    inline for (suites) |suite| {
        const name = try std.fmt.bufPrint(&name_buf, "impl=openssl/suite={s}", .{suite});
        _ = try b.run(name, benchHandshake(suite));
    }
}

const Direction = enum { client_to_server, server_to_client, ping_pong };

fn benchApp(
    comptime suite: []const u8,
    comptime size: usize,
    comptime dir: Direction,
) bench.Function {
    return struct {
        pub fn benchFn(b: *bench.B) !void {
            const ctxs = makeContexts(suite);
            defer freeContexts(ctxs);

            var payload: [16384]u8 = @splat(0x42);
            var recvbuf: [16384]u8 = undefined;

            const conn = connected(ctxs);
            defer freeConn(conn);

            sslWriteAll(conn.client, payload[0..size]);
            sslReadExact(conn.server, recvbuf[0..size]);

            switch (dir) {
                .client_to_server => b.setBytes(size),
                .server_to_client => b.setBytes(size),
                .ping_pong => b.setBytes(size * 2),
            }

            while (try b.loop()) {
                switch (dir) {
                    .client_to_server => {
                        sslWriteAll(conn.client, payload[0..size]);
                        sslReadExact(conn.server, recvbuf[0..size]);
                    },
                    .server_to_client => {
                        sslWriteAll(conn.server, payload[0..size]);
                        sslReadExact(conn.client, recvbuf[0..size]);
                    },
                    .ping_pong => {
                        sslWriteAll(conn.client, payload[0..size]);
                        sslReadExact(conn.server, recvbuf[0..size]);
                        sslWriteAll(conn.server, payload[0..size]);
                        sslReadExact(conn.client, recvbuf[0..size]);
                    },
                }
            }
        }
    }.benchFn;
}

pub fn benchmarkAppClientToServer(b: *bench.B) !void {
    @setEvalBranchQuota(1000000);
    var name_buf: [80]u8 = undefined;
    inline for (suites) |suite| {
        inline for (sizes) |size| {
            const name = try std.fmt.bufPrint(
                &name_buf,
                "impl=openssl/suite={s}/size={d}",
                .{ suite, size },
            );
            _ = try b.run(name, benchApp(suite, size, .client_to_server));
        }
    }
}

pub fn benchmarkAppServerToClient(b: *bench.B) !void {
    @setEvalBranchQuota(1000000);
    var name_buf: [80]u8 = undefined;
    inline for (suites) |suite| {
        inline for (sizes) |size| {
            const name = try std.fmt.bufPrint(
                &name_buf,
                "impl=openssl/suite={s}/size={d}",
                .{ suite, size },
            );
            _ = try b.run(name, benchApp(suite, size, .server_to_client));
        }
    }
}

pub fn benchmarkAppPingPong(b: *bench.B) !void {
    @setEvalBranchQuota(1000000);
    var name_buf: [80]u8 = undefined;
    inline for (suites) |suite| {
        inline for (sizes) |size| {
            const name = try std.fmt.bufPrint(
                &name_buf,
                "impl=openssl/suite={s}/size={d}",
                .{ suite, size },
            );
            _ = try b.run(name, benchApp(suite, size, .ping_pong));
        }
    }
}
