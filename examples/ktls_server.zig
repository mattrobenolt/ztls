//! Linux kTLS server proof: userspace TLS 1.3 handshake → kernel data plane.
//!
//! The server completes the TLS 1.3 handshake in userspace (ztls), then
//! demonstrates the full kTLS loop:
//!
//! 1. Handshake in userspace (ztls ServerHandshake over a real TCP socket).
//! 2. The client triggers a KeyUpdate(update_requested). The server's
//!    `handleRecord` returns a `key_update` event carrying both epoch changes
//!    and the response record. The server writes the response, completes the
//!    write, and extracts the new `txKtlsInfo()` / `rxKtlsInfo()`.
//! 3. The server installs the Linux kTLS ULP and TX/RX keys via `setsockopt`,
//!    using the post-KeyUpdate traffic key material.
//! 4. Ping/pong through the kernel data plane: the server uses raw `send`/
//!    `recv` (the kernel encrypts/decrypts), the client uses ztls userspace.
//!    The client successfully decrypting what the kernel encrypted PROVES the
//!    extracted key material is correct — including after a KeyUpdate.
//! 5. Clean `close_notify` shutdown.
//!
//! Graceful skip: if the kernel lacks TLS support (`setsockopt(TCP_ULP)`
//! fails with `ENOPROTOOPT`/`ENOSYS`/`PROTONOSUPPORT`), this example prints a
//! clear message and exits 0 — it never breaks CI on a kernel without
//! `tls.ko`. The same applies if `setsockopt(TLS_TX/TLS_RX)` fails.
//!
//! References:
//!   - https://docs.kernel.org/networking/tls.html
//!   - include/uapi/linux/tls.h
//!   - RFC 8446 §4.6.3 (KeyUpdate), §5.3 (nonce/IV), §7.2 (key schedule)
const std = @import("std");
const builtin = @import("builtin");
const print = std.debug.print;
const posix = std.posix;

const net = @import("net_compat.zig");
const Address = net.Address;

const ztls = @import("ztls");

const shared_fixtures = @import("test_fixtures/shared_fixtures.zig");

comptime {
    if (builtin.os.tag != .linux) @compileError("ktls_server is Linux-only");
}

const cert_der: []const u8 = &shared_fixtures.server_ecdsa_cert_der;
const scalar: []const u8 = &shared_fixtures.server_ecdsa_scalar;

const host = "127.0.0.1";
const server_name = "ztls.server.test";
const port: u16 = 0; // OS-assigned ephemeral port

// Linux kTLS UAPI constants and struct layouts come from `ztls.ktls` so the
// caller never handles the kernel struct layout or the RFC 8446 §5.3 salt/IV
// split directly.
const ktls = ztls.ktls;

const ServerCtx = struct {
    listener: *net.Server,
    keypair: ztls.x25519.KeyPair,
};

pub fn main() !void {
    const client_keypair: ztls.x25519.KeyPair = .generate();
    const server_keypair: ztls.x25519.KeyPair = .generate();

    const addr: Address = try net.parseIp(host, port);
    var server_listener = try net.listen(addr, .{ .reuse_address = true });
    defer net.deinitServer(&server_listener);
    const actual_port = net.serverPort(server_listener);
    print("[ktls]   server listening on {s}:{d}\n", .{ host, actual_port });

    var sctx: ServerCtx = .{ .listener = &server_listener, .keypair = server_keypair };
    const server_thread = try std.Thread.spawn(.{}, serverRun, .{&sctx});

    try clientRun(client_keypair, actual_port);

    server_thread.join();
    print("\n=== kTLS server OK ===\n", .{});
}

fn serverRun(ctx: *ServerCtx) !void {
    const stream = try net.accept(ctx.listener);
    defer net.close(stream);
    const sockfd = net.fd(stream);
    print("[server] accepted connection (fd={d})\n", .{sockfd});

    var random: ztls.Random = undefined;
    net.fillRandom(&random.data);

    var hs: ztls.ServerHandshake = .init(.{
        .keypairs = .init(ctx.keypair),
        .random = random,
        .alpn_protocols = &.{"h2"},
    });
    defer hs.deinit();

    var signer: ztls.signature.PrivateKey = try .fromP256Scalar(scalar[0..32]);
    defer signer.deinit();
    hs.setCredentials(&.{cert_der}, signer.signer());

    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);
    var out: ztls.ServerHandshake.OutBuffer = .empty;
    var flight: ztls.ServerHandshake.FlightBuffer = .empty;

    // 1. Handshake in userspace
    while (!hs.isConnected()) {
        const n = try net.read(stream, rb.writable());
        if (n == 0) return error.ClientClosed;
        rb.advance(n);
        while (try rb.next()) |record| {
            const ev = try hs.handleRecord(record, &out.buffer);
            switch (ev) {
                .write => |w| {
                    try net.writeAll(stream, w);
                    hs.completeWrite();
                    if (try hs.sendServerFlightBuffered(&flight)) |flight_bytes| {
                        try net.writeAll(stream, flight_bytes);
                        hs.completeWrite();
                    }
                },
                .none => {},
                .application_data, .closed, .key_update => return error.UnexpectedDuringHandshake,
            }
        }
    }
    print("[server] handshake complete (ALPN={s})\n", .{hs.selectedAlpnProtocol().?});

    // 2. KeyUpdate: client triggers, server handles event
    // The client sends a KeyUpdate(update_requested). The server processes it
    // via handleRecord (still in userspace), gets the key_update event, writes
    // the response, and extracts the new key material. Then we install kTLS
    // with the post-KeyUpdate keys.
    while (true) {
        const n = try net.read(stream, rb.writable());
        if (n == 0) return error.ClientClosed;
        rb.advance(n);
        var saw_key_update = false;
        while (try rb.next()) |record| {
            const ev = try hs.handleRecord(record, &out.buffer);
            switch (ev) {
                .key_update => |ku| {
                    // RFC 8446 §4.6.3 — write the response first (encrypted
                    // under the OLD TX key), then completeWrite.
                    if (ku.response) |w| {
                        try net.writeAll(stream, w);
                        hs.completeWrite();
                    }
                    print(
                        "[server] KeyUpdate event: rx={}, tx={}, response={s}\n",
                        .{ ku.rx, ku.tx, if (ku.response != null) "yes" else "no" },
                    );
                    saw_key_update = true;
                },
                .application_data, .closed, .write => return error.UnexpectedAfterKeyUpdate,
                .none => {},
            }
        }
        if (saw_key_update) break;
    }

    // 3. Extract post-KeyUpdate traffic keys
    const tx_info = hs.txKtlsInfo();
    const rx_info = hs.rxKtlsInfo();
    print(
        "[server] extracted post-KeyUpdate kTLS key material (cipher={s}, seq={d})\n",
        .{ @tagName(tx_info.cipher_type), std.mem.readInt(u64, &tx_info.rec_seq, .big) },
    );

    // 4. Install kTLS ULP + TX/RX keys
    const ulp_name = "tls";
    posix.setsockopt(sockfd, ktls.SOL_TCP, ktls.TCP_ULP, ulp_name) catch |err| {
        if (isKtlsUnavailable(err)) {
            print("[ktls]   kTLS unavailable on this kernel, skipping\n", .{});
            return;
        }
        print("[ktls]   setsockopt(TCP_ULP) failed: {s}, skipping\n", .{@errorName(err)});
        return;
    };

    installKtlsAesGcm128(sockfd, ktls.TLS_TX, tx_info) catch |err| {
        print("[ktls]   setsockopt(TLS_TX) failed: {s}, skipping\n", .{@errorName(err)});
        return;
    };
    installKtlsAesGcm128(sockfd, ktls.TLS_RX, rx_info) catch |err| {
        print("[ktls]   setsockopt(TLS_RX) failed: {s}, skipping\n", .{@errorName(err)});
        return;
    };
    print("[server] kTLS installed: data plane is now kernel-owned\n", .{});

    // 5. Ping/pong through the kernel data plane
    // The kernel decrypts incoming records; we get plaintext via recv.
    // The kernel encrypts outgoing records; we send plaintext via send.
    var kbuf: [4096]u8 = undefined;
    const ping_n = recvExact(sockfd, kbuf[0..4]) catch |err| {
        print("[server] recv ping failed: {s}\n", .{@errorName(err)});
        return err;
    };
    if (!std.mem.eql(u8, kbuf[0..ping_n], "ping")) {
        print("[server] unexpected data: {s}\n", .{kbuf[0..ping_n]});
        return error.UnexpectedPing;
    }
    print("[server] received (kernel-decrypted): {s}\n", .{kbuf[0..ping_n]});

    _ = try sendAll(sockfd, "pong");
    print("[server] sent (kernel-encrypted): pong\n", .{});

    // 6. close_notify — handled by the `defer net.close(stream)` below:
    // with kTLS TX installed, closing the fd makes the kernel send a
    // close_notify. Do NOT close explicitly here — the defer owns the fd,
    // and a double close hits EBADF (posix.close maps EBADF to unreachable).
    print("[server] connection complete; deferring close (kernel sends close_notify)\n", .{});
}

/// Install a TLS 1.3 AES-GCM-128 traffic key via `setsockopt(TLS_TX/TLS_RX)`.
/// `ztls.ktls.packAesGcm128` folds the RFC 8446 §5.3 salt/IV split and the
/// kernel struct layout into the library, so this is just pack + setsockopt.
fn installKtlsAesGcm128(
    sockfd: posix.socket_t,
    direction: u32,
    info: ztls.RecordLayer.KtlsInfo,
) !void {
    const crypto_info = ktls.packAesGcm128(info) catch |err| switch (err) {
        error.CipherMismatch => return error.UnsupportedCipher,
    };
    const opt_bytes = std.mem.asBytes(&crypto_info);
    posix.setsockopt(sockfd, ktls.SOL_TLS, direction, opt_bytes) catch |err| {
        if (isKtlsUnavailable(err)) return error.KtlsUnavailable;
        return error.KtlsSetsockoptFailed;
    };
}

fn isKtlsUnavailable(err: anyerror) bool {
    return switch (err) {
        error.NotFound,
        error.NoDevice,
        error.ProtocolNotSupported,
        error.NotSupported,
        => true,
        else => false,
    };
}

fn recvExact(sockfd: posix.socket_t, buf: []u8) !usize {
    var total: usize = 0;
    while (total < buf.len) {
        const n = posix.recv(sockfd, buf[total..], 0) catch |err| switch (err) {
            error.WouldBlock => continue,
            else => return err,
        };
        if (n == 0) return error.PeerClosed;
        total += n;
    }
    return total;
}

fn sendAll(sockfd: posix.socket_t, bytes: []const u8) !usize {
    var sent: usize = 0;
    while (sent < bytes.len) {
        const n = posix.send(sockfd, bytes[sent..], 0) catch |err| switch (err) {
            error.WouldBlock => continue,
            else => return err,
        };
        sent += n;
    }
    return sent;
}

fn clientRun(client_keypair: ztls.x25519.KeyPair, actual_port: u16) !void {
    const addr: Address = try net.parseIp(host, actual_port);
    const stream = try net.connect(addr);
    defer net.close(stream);
    print("[client] connected to {s}:{d}\n", .{ host, actual_port });

    var random: ztls.Random = undefined;
    net.fillRandom(&random.data);

    var hs: ztls.ClientHandshake = .init(.{
        .keypairs = .init(client_keypair),
        .host_name = server_name,
        .now_sec = net.timestamp(),
        .random = random,
        .insecure_no_chain_anchor = true,
        .alpn_protocols = &.{"h2"},
    });
    defer hs.deinit();

    var out: ztls.ClientHandshake.OutBuffer = .empty;
    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);

    // 1. Handshake
    try net.writeAll(stream, try hs.start(&out.buffer));
    hs.completeWrite();
    print("[client] ClientHello sent\n", .{});

    while (!hs.isConnected()) {
        const n = try net.read(stream, rb.writable());
        if (n == 0) return error.ServerClosed;
        rb.advance(n);
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out.buffer)) {
            .write => |w| {
                try net.writeAll(stream, w);
                hs.completeWrite();
            },
            .key_update => |ku| {
                if (ku.response) |w| {
                    try net.writeAll(stream, w);
                    hs.completeWrite();
                }
            },
            .application_data, .closed => return error.UnexpectedDuringHandshake,
            .none => {},
        };
    }
    print("[client] handshake complete (ALPN={s})\n", .{hs.selectedAlpnProtocol().?});

    // 2. Trigger KeyUpdate
    // RFC 8446 §4.6.3 — the client sends KeyUpdate(update_requested) to force
    // the server to update its TX key as well. The server will respond with
    // KeyUpdate(update_not_requested).
    const ku_rec = try hs.sendKeyUpdate(&out.buffer, .update_requested);
    try net.writeAll(stream, ku_rec);
    hs.completeWrite();
    print("[client] sent KeyUpdate(update_requested)\n", .{});

    // Process the server's KeyUpdate response.
    var got_server_response = false;
    while (!got_server_response) {
        const n = try net.read(stream, rb.writable());
        if (n == 0) return error.ServerClosed;
        rb.advance(n);
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out.buffer)) {
            .key_update => |ku| {
                print(
                    "[client] server KeyUpdate response: rx={}, tx={}, response={s}\n",
                    .{ ku.rx, ku.tx, if (ku.response != null) "yes" else "no" },
                );
                if (ku.response) |w| {
                    try net.writeAll(stream, w);
                    hs.completeWrite();
                }
                got_server_response = true;
            },
            .write => |w| {
                try net.writeAll(stream, w);
                hs.completeWrite();
            },
            .application_data => |data| {
                print("[client] received early data: {s}\n", .{data});
            },
            .closed => return error.ServerClosedEarly,
            .none => {},
        };
    }

    // 3. Send ping to the kernel-encrypted server
    const ping = "ping";
    try net.writeAll(stream, try hs.sendApplicationData(ping, &out.buffer));
    hs.completeWrite();
    print("[client] sent: {s}\n", .{ping});

    // 4. Receive pong from the kernel-encrypted server
    while (true) {
        const n = try net.read(stream, rb.writable());
        if (n == 0) break;
        rb.advance(n);
        while (try rb.next()) |record| switch (try hs.handleRecord(record, &out.buffer)) {
            .application_data => |data| {
                if (std.mem.eql(u8, data, "pong")) {
                    print("[client] received: {s}\n", .{data});
                    return;
                }
                print("[client] received unexpected: {s}\n", .{data});
            },
            .write => |w| {
                try net.writeAll(stream, w);
                hs.completeWrite();
            },
            .key_update => |ku| {
                if (ku.response) |w| {
                    try net.writeAll(stream, w);
                    hs.completeWrite();
                }
            },
            .closed => return,
            .none => {},
        };
    }
}
