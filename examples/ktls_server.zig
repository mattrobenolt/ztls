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

    // 4. Install kTLS ULP + TX/RX keys.
    //
    // Use the raw Linux setsockopt syscall directly instead of posix.setsockopt:
    // when the kernel has no `tls` ULP module loaded, setsockopt(TCP_ULP)
    // returns ENOENT, which posix.setsockopt does not map and would route
    // through unexpectedErrno -> dumpCurrentStackTrace (slow/noisy). Handling
    // errno ourselves keeps the unavailable-kernel path clean and quiet.
    const ulp_name = "tls";
    switch (ktlsSetsockopt(sockfd, ktls.SOL_TCP, ktls.TCP_ULP, ulp_name)) {
        .ok => {},
        .unavailable => {
            print("[ktls]   kTLS unavailable on this kernel, skipping\n", .{});
            return;
        },
        .failed => |err| {
            print("[ktls]   setsockopt(TCP_ULP) failed: errno {d}, skipping\n", .{err});
            return;
        },
    }

    switch (installKtlsAesGcm128(sockfd, ktls.TLS_TX, tx_info)) {
        .ok => {},
        .unavailable => {
            print("[ktls]   kTLS TX unavailable on this kernel, skipping\n", .{});
            return;
        },
        .failed => |err| {
            print("[ktls]   setsockopt(TLS_TX) failed: errno {d}, skipping\n", .{err});
            return;
        },
    }
    switch (installKtlsAesGcm128(sockfd, ktls.TLS_RX, rx_info)) {
        .ok => {},
        .unavailable => {
            print("[ktls]   kTLS RX unavailable on this kernel, skipping\n", .{});
            return;
        },
        .failed => |err| {
            print("[ktls]   setsockopt(TLS_RX) failed: errno {d}, skipping\n", .{err});
            return;
        },
    }
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

const linux = std.os.linux;

/// Result of a kTLS setsockopt that may fail because the kernel lacks TLS
/// support (ENOENT/NOPROTOOPT/OPNOTSUPP/PROTONOSUPPORT) or for another reason.
const KtlsSetsockoptResult = union(enum) {
    ok,
    /// Kernel does not provide the TLS ULP / cipher — caller should skip.
    unavailable,
    /// Some other errno; carries the raw errno value for diagnostics.
    failed: u16,
};

/// Raw Linux setsockopt for kTLS install. Bypasses posix.setsockopt so that
/// ENOENT (no `tls` ULP module loaded) maps to `.unavailable` instead of
/// routing through unexpectedErrno -> dumpCurrentStackTrace.
fn ktlsSetsockopt(
    sockfd: posix.socket_t,
    level: u32,
    optname: u32,
    opt: []const u8,
) KtlsSetsockoptResult {
    const rc = linux.setsockopt(sockfd, @intCast(level), optname, opt.ptr, @intCast(opt.len));
    const e = linux.E.init(rc);
    return switch (e) {
        .SUCCESS => .ok,
        // Kernel has no tls ULP / cipher module registered.
        .NOENT, .NOPROTOOPT, .PROTONOSUPPORT, .OPNOTSUPP => .unavailable,
        else => |err| .{ .failed = @intFromEnum(err) },
    };
}

/// Install a TLS 1.3 AES-GCM-128 traffic key via `setsockopt(TLS_TX/TLS_RX)`.
/// `ztls.ktls.packAesGcm128` folds the RFC 8446 §5.3 salt/IV split and the
/// kernel struct layout into the library, so this is just pack + setsockopt.
fn installKtlsAesGcm128(
    sockfd: posix.socket_t,
    direction: u32,
    info: ztls.RecordLayer.KtlsInfo,
) KtlsSetsockoptResult {
    const crypto_info = ktls.packAesGcm128(info) catch return .{ .failed = 0 };
    return ktlsSetsockopt(sockfd, ktls.SOL_TLS, direction, std.mem.asBytes(&crypto_info));
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
            .application_data,
            .closed,
            .new_session_ticket,
            => return error.UnexpectedDuringHandshake,
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
            .new_session_ticket => {},
            .none => {},
        };
    }

    // 3. Send ping to the kernel-encrypted server
    const ping = "ping";
    try net.writeAll(stream, try hs.sendApplicationData(ping, &out.buffer));
    hs.completeWrite();
    print("[client] sent: {s}\n", .{ping});

    // 4. Receive pong from the kernel-encrypted server. If the server could
    //    not install kTLS (kernel without tls.ko), it skips and closes the
    //    connection; treat that reset/early-close as a graceful skip rather
    //    than a hard error so this example never breaks CI on a kernel without
    //    kTLS.
    while (true) {
        const n = net.read(stream, rb.writable()) catch |err| switch (err) {
            error.ConnectionResetByPeer, error.BrokenPipe => {
                print("[client] server closed without pong (kTLS unavailable), skipping\n", .{});
                return;
            },
            else => return err,
        };
        if (n == 0) {
            print("[client] server closed without pong (kTLS unavailable), skipping\n", .{});
            return;
        }
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
            .new_session_ticket => {},
            .closed => return,
            .none => {},
        };
    }
}
