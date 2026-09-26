//! TLS-Anvil client TCP wrapper.
//!
//! Thin I/O harness that drives ClientHandshake over a TCP stream. Reads
//! HOST and PORT from environment, completes a TLS 1.3 handshake, then echoes
//! arbitrary application data back to the peer until close_notify.
//!
//! This is test harness code; allocators and I/O are acceptable here.
const std = @import("std");
const Io = std.Io;
const mem = std.mem;
const posix = std.posix;
const print = std.debug.print;
const ascii = std.ascii;
const builtin = @import("builtin");

const ztls = @import("ztls");

/// Connect to a host:port with retry. TLS-Anvil starts the trigger script
/// (the client) before opening its server socket, so the first connect attempt
/// may get ConnectionRefused. Retry briefly to avoid the race.
fn connectToHost(io: Io, host: []const u8, port: u16) !Io.net.Stream {
    const addr: Io.net.IpAddress = try .parse(host, port);
    var attempts: u8 = 0;
    while (attempts < 50) : (attempts += 1) {
        return addr.connect(io, .{ .mode = .stream }) catch |err| switch (err) {
            error.ConnectionRefused => {
                io.sleep(.fromNanoseconds(20 * std.time.ns_per_ms), .awake) catch return err;
                continue;
            },
            else => return err,
        };
    }
    return error.ConnectionRefused;
}

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const env_map = init.environ_map;

    const host = env_map.get("HOST") orelse "127.0.0.1";
    const port = blk: {
        const port_str = env_map.get("PORT") orelse "4433";
        break :blk try std.fmt.parseInt(u16, port_str, 10);
    };

    const insecure_no_host_name = if (env_map.get("ZTLS_INSECURE_NO_HOST_NAME")) |value|
        mem.eql(u8, value, "1") or ascii.eqlIgnoreCase(value, "true")
    else
        false;
    const cert_host_name: ?[]const u8 = if (insecure_no_host_name)
        null
    else if (env_map.get("ZTLS_HOST_NAME")) |name|
        if (name.len == 0) null else name
    else
        host;
    const insecure_no_chain_anchor = if (env_map.get("ZTLS_INSECURE_NO_CHAIN_ANCHOR")) |value|
        mem.eql(u8, value, "1") or ascii.eqlIgnoreCase(value, "true")
    else
        false;
    // #91 diagnostics opt-in: log the local source port and, on pre-connection
    // certificate validity failures, the policy/real clocks and the decrypted
    // record bytes holding the server Certificate message. Scoped to
    // connection-establishment validity failures only; never enabled by
    // default. Never captures application plaintext or keys.
    const diagnostics = if (env_map.get("ZTLS_ANVIL_DIAGNOSTICS")) |value|
        mem.eql(u8, value, "1") or ascii.eqlIgnoreCase(value, "true")
    else
        false;

    const stream = try connectToHost(io, host, port);
    defer stream.close(io);

    if (diagnostics) logLocalPort(stream);

    const kp: ztls.x25519.KeyPair = .generate();
    var random: ztls.Random = .empty;
    io.random(&random.data);

    var hs: ztls.ClientHandshake = .init(.{
        .keypairs = try .init(kp),
        .host_name = cert_host_name,
        .now_sec = Io.Timestamp.now(io, .real).toSeconds(),
        .random = random,
        .insecure_no_chain_anchor = insecure_no_chain_anchor,
        .alpn_protocols = &.{ "h2", "http/1.1" },
    });
    if (insecure_no_chain_anchor) hs.policy.leaf_usage = .none;
    defer hs.deinit();

    var out: [ztls.ClientHandshake.max_out_len]u8 = undefined;
    var storage: ztls.RecordBuffer.Storage = .empty;
    var rb: ztls.RecordBuffer = .init(&storage.buffer);

    // ClientHello.
    try ztls.io.writeAll(io, stream, try hs.start(&out));
    hs.completeWrite();

    // Drive handshake.
    while (!hs.isConnected()) {
        const n = try ztls.io.fill(io, stream, &rb);
        if (n == 0) return error.ServerClosed;
        while (true) {
            const record = (rb.next() catch |err| {
                return sendAlertAndReturnError(io, stream, &hs, err, &out);
            }) orelse break;
            const ev = hs.handleRecord(record, &out) catch |err| {
                // #91 diagnostics: capture the flight bytes before the alert
                // path — sendAlert writes into `out`, never `record`, but log
                // first so the probe cannot depend on that staying true.
                if (diagnostics) logValidityProbe(io, &hs, err, record);
                return sendAlertAndReturnError(io, stream, &hs, err, &out);
            };
            switch (ev) {
                .write => |w| {
                    try ztls.io.writeAll(io, stream, w);
                    hs.completeWrite();
                },
                .application_data,
                .closed,
                .key_update,
                .new_session_ticket,
                => return error.UnexpectedDuringHandshake,
                .none => {},
            }
        }
    }

    // Echo application data until close_notify.
    while (true) {
        const n = try ztls.io.fill(io, stream, &rb);
        // Bare transport EOF is truncation or a transport close, not an
        // orderly TLS close. Do not send close_notify here — only the
        // `.closed` branch below (peer sent close_notify) sends a reciprocal
        // close_notify. RFC 8446 §6.1.
        if (n == 0) break;
        while (true) {
            const record = (rb.next() catch |err| {
                return sendAlertAndReturnError(io, stream, &hs, err, &out);
            }) orelse break;
            const ev = hs.handleRecord(record, &out) catch |err| {
                return sendAlertAndReturnError(io, stream, &hs, err, &out);
            };
            switch (ev) {
                .application_data => |data| {
                    const rec = try hs.sendApplicationData(data, &out);
                    try ztls.io.writeAll(io, stream, rec);
                    hs.completeWrite();
                },
                .write => |w| {
                    try ztls.io.writeAll(io, stream, w);
                    hs.completeWrite();
                },
                .key_update => |ku| {
                    // RFC 8446 §4.6.3 — a peer KeyUpdate ratchets the traffic
                    // keys. Write the response (if any) and acknowledge it; the
                    // anvil echo loop keeps running under the new epoch.
                    if (ku.response) |w| {
                        try ztls.io.writeAll(io, stream, w);
                        hs.completeWrite();
                    }
                },
                .new_session_ticket => {},
                .closed => {
                    // RFC 8446 §6.1 — close_notify is bidirectional on orderly shutdown.
                    const rec = try hs.sendAlert(.close_notify, &out);
                    try ztls.io.writeAll(io, stream, rec);
                    hs.completeWrite();
                    return;
                },
                .none => {},
            }
        }
    }
}

fn sendAlertAndReturnError(
    io: Io,
    stream: Io.net.Stream,
    hs: *ztls.ClientHandshake,
    err: anyerror,
    out: []u8,
) anyerror {
    // The peer already sent us a fatal alert; replying with our own alert
    // would be wrong (and would emit a spurious internal_error). Just
    // propagate the original error. RFC 8446 §6.
    if (err == error.PeerAlert) return err;
    const rec = hs.sendAlert(ztls.alert.alertForError(err), out) catch return err;
    ztls.io.writeAll(io, stream, rec) catch return err;
    hs.completeWrite();
    return err;
}

/// Local (source) TCP port of a connected stream. Harness diagnostics use it
/// to bind a client invocation to the exact connection a peer trace recorded.
/// Null if the OS lookup fails or the family is not INET/INET6. POSIX-only:
/// works identically on Linux and macOS.
pub fn localPort(stream: Io.net.Stream) ?u16 {
    var addr: posix.sockaddr.storage = undefined;
    var addr_len: posix.socklen_t = @sizeOf(posix.sockaddr.storage);
    // posix.getsockname moved off POSIX in 0.16; the libc symbol is
    // identical and every consumer of this helper links libc.
    if (std.c.getsockname(stream.socket.handle, @ptrCast(&addr), &addr_len) != 0) return null;
    const bytes: [*]const u8 = @ptrCast(&addr);
    // sockaddr_in and sockaddr_in6 both carry the port big-endian at offset 2
    // on Linux and macOS; only the family field layout differs (u16 at 0 on
    // Linux, len byte + family byte at 1 on macOS).
    const family: u16 = if (builtin.os.tag == .macos)
        bytes[1]
    else
        mem.readInt(u16, bytes[0..2], builtin.cpu.arch.endian());
    if (family != posix.AF.INET and family != posix.AF.INET6) return null;
    return mem.readInt(u16, bytes[2..4], .big);
}

/// One maximum wire record: RFC 8446 §5.1 header (5) plus the largest
/// ciphertext (2^14 + 256, RFC 8446 §5.2).
const max_diag_record_len = 5 + (1 << 14) + 256;

/// #91 diagnostics: log the local TCP source port so a per-invocation client
/// log can be paired with the TLS-Anvil trace's DstPort.
fn logLocalPort(stream: Io.net.Stream) void {
    if (localPort(stream)) |port| {
        print("anvil_client diag local_port={d}\n", .{port});
    } else {
        print("anvil_client diag local_port=unknown\n", .{});
    }
}

/// #91 diagnostics: on a certificate validity failure, log both clocks and
/// the decrypted record bytes so the actual server Certificate message and
/// its validity dates are recoverable offline from the per-invocation log.
/// Only CertificateExpired/CertificateNotYetValid — no other failure class.
fn logValidityProbe(
    io: Io,
    hs: *const ztls.ClientHandshake,
    err: anyerror,
    record: []const u8,
) void {
    if (err != error.CertificateExpired and err != error.CertificateNotYetValid) return;
    const plain = validityProbePlaintext(record);
    print(
        "anvil_client diag validity err={s} policy_now_sec={d} real_now_sec={d} " ++
            "record_len={d} plaintext_len={d} handshake_buf_len={d}\n",
        .{
            @errorName(err),
            hs.policy.now_sec,
            Io.Timestamp.now(io, .real).toSeconds(),
            @min(record.len, max_diag_record_len),
            plain.len,
            hs.handshake_buf.len,
        },
    );
    var i: usize = 0;
    while (i < plain.len) : (i += 32) {
        print("anvil_client diag cert_hex={x}\n", .{plain[i..@min(i + 32, plain.len)]});
    }
}

/// Recover the handshake flight bytes a failed `handleRecord` leaves behind.
/// The record was decrypted in place before flight validation ran, so it
/// still holds: 5-byte header (RFC 8446 §5.1), inner plaintext
/// (content || real type byte || zero padding, §5.2), then the 16-byte tag
/// (§5.4). Strip all three wrappers to expose the Certificate message.
fn validityProbePlaintext(record: []const u8) []const u8 {
    const header_len = 5;
    const tag_len = 16;
    if (record.len < header_len + tag_len + 1 or
        record.len > max_diag_record_len) return record[0..0];
    const inner = record[header_len .. record.len - tag_len];
    // RFC 8446 §5.2 — the real ContentType is the last non-zero byte; the
    // bytes before it are the handshake flight. Mirrors RecordLayer.decrypt.
    var end = inner.len;
    while (end > 0 and inner[end - 1] == 0) end -= 1;
    if (end == 0 or inner[end - 1] != 22) return record[0..0];
    return inner[0 .. end - 1];
}

// RFC 8446 §5.2 — inner plaintext is content, real type byte, zero padding;
// §5.4 — the tag follows the ciphertext. The probe must recover the exact
// Certificate message a validity failure leaves in the decrypted record.
test "validityProbePlaintext recovers the flight from a decrypted record" {
    const cert_msg = [_]u8{ 0x0b, 0x00, 0x00, 0x04, 0xde, 0xad, 0xbe, 0xef };
    const pad: usize = 3;
    var record: [5 + cert_msg.len + 1 + pad + 16]u8 = undefined;
    record[0] = 23;
    record[1] = 0x03;
    record[2] = 0x03;
    @memcpy(record[5..][0..cert_msg.len], &cert_msg);
    record[5 + cert_msg.len] = 22; // real handshake ContentType
    @memset(record[5 + cert_msg.len + 1 ..][0..pad], 0);
    @memset(record[record.len - 16 ..], 0xaa); // tag
    try std.testing.expectEqualSlices(u8, &cert_msg, validityProbePlaintext(&record));
}

// RFC 8446 §5.2 — padding is optional; a record without it must recover too.
test "validityProbePlaintext handles zero padding and short records" {
    const msg = [_]u8{ 0x0b, 0x00, 0x00, 0x01, 0xff };
    var record: [5 + msg.len + 1 + 16]u8 = undefined;
    record[0] = 23;
    @memcpy(record[5..][0..msg.len], &msg);
    record[5 + msg.len] = 22;
    try std.testing.expectEqualSlices(u8, &msg, validityProbePlaintext(&record));

    // A different content type must not expose application plaintext.
    record[5 + msg.len] = 23;
    try std.testing.expectEqualSlices(u8, &.{}, validityProbePlaintext(&record));
    @memset(record[5 .. record.len - 16], 0);
    try std.testing.expectEqualSlices(u8, &.{}, validityProbePlaintext(&record));
    const oversized: [max_diag_record_len + 1]u8 = undefined;
    try std.testing.expectEqualSlices(u8, &.{}, validityProbePlaintext(&oversized));

    // Degenerate records (header + tag only) yield nothing, not garbage.
    const short = [_]u8{0} ** 21;
    try std.testing.expectEqualSlices(u8, &.{}, validityProbePlaintext(&short));
}

// The local-port half of the #91 diagnostics must report a real source port
// for a fresh connection, distinct from the listener's port.
test "localPort reports the client-side source port" {
    const io = std.testing.io;
    const listen_addr: Io.net.IpAddress = try .parse("127.0.0.1", 0);
    var listener = try listen_addr.listen(io, .{ .reuse_address = false });
    defer listener.deinit(io);
    const server_port = listener.socket.address.getPort();
    const client_addr: Io.net.IpAddress = try .parse("127.0.0.1", server_port);
    const client = try client_addr.connect(io, .{ .mode = .stream });
    defer client.close(io);
    const port = localPort(client) orelse return error.NoLocalPort;
    try std.testing.expect(port != 0);
    try std.testing.expect(port != server_port);
}
