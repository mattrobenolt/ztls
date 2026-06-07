const std = @import("std");

const ztls = @import("ztls");

const cert_der = @embedFile("fixtures/server-ecdsa/server.der");
const scalar = @embedFile("fixtures/server-ecdsa/scalar.bin");

pub fn main() !void {
    const port = try readPort();
    const address = try std.net.Address.parseIp("127.0.0.1", port);
    var server = try address.listen(.{ .reuse_address = true });
    defer server.deinit();

    var stdout_buf: [256]u8 = undefined;
    var stdout_file = std.fs.File.stdout().writer(&stdout_buf);
    const stdout = &stdout_file.interface;
    try stdout.print("ztls tlsfuzzer server listening on 127.0.0.1:{d}\n", .{port});
    try stdout.flush();

    while (true) {
        const conn = server.accept() catch |err| switch (err) {
            error.ProcessFdQuotaExceeded, error.SystemFdQuotaExceeded => return err,
            else => continue,
        };
        handleConnection(conn) catch continue;
    }
}

fn readPort() !u16 {
    if (std.posix.getenv("PORT")) |value| {
        return std.fmt.parseInt(u16, value, 10);
    }
    return 4433;
}

fn handleConnection(conn: std.net.Server.Connection) !void {
    defer conn.stream.close();

    var signer: ztls.signature.PrivateKey = try .fromP256Scalar(scalar[0..32]);
    defer signer.deinit();

    var hs: ztls.ServerHandshake = .init(.generate());
    defer hs.deinit();
    hs.supportAlpn(&.{ "http/1.1", "h2" });

    var in_buf: [ztls.frame.header_len + ztls.frame.max_ciphertext_len]u8 = undefined;
    const out_buf_len =
        ztls.frame.header_len + ztls.frame.max_plaintext_len + ztls.aead.tag_len + 1;
    var out_buf: [out_buf_len]u8 = undefined;

    while (true) {
        const record = readRecord(conn.stream, &in_buf) catch |err| switch (err) {
            error.EndOfStream => return,
            else => return,
        };

        const random: ztls.client_hello.Random = randomBytes();
        const ev = hs.handleRecord(record, random, &out_buf) catch |err| {
            sendBestEffortAlert(&hs, conn.stream, err, &out_buf);
            return;
        };

        switch (ev) {
            .write => |bytes| {
                try conn.stream.writeAll(bytes);
                hs.completeWrite();
                if (!hs.isConnected()) {
                    const flight = hs.sendPreparedAuthenticatedFlight(
                        &.{cert_der},
                        signer.signer(),
                        &out_buf,
                    ) catch |err| {
                        sendBestEffortAlert(&hs, conn.stream, err, &out_buf);
                        return;
                    };
                    try conn.stream.writeAll(flight);
                    hs.completeWrite();
                }
            },
            .application_data => |data| {
                const response = hs.sendApplicationData(data, &out_buf) catch |err| {
                    sendBestEffortAlert(&hs, conn.stream, err, &out_buf);
                    return;
                };
                try conn.stream.writeAll(response);
                hs.completeWrite();
            },
            .closed => return,
            .none => {},
        }
    }
}

fn randomBytes() ztls.client_hello.Random {
    var bytes: [32]u8 = undefined;
    std.crypto.random.bytes(&bytes);
    return .init(bytes);
}

fn readRecord(stream: std.net.Stream, buf: []u8) ![]u8 {
    const got_header = try stream.readAtLeast(buf[0..ztls.frame.header_len], ztls.frame.header_len);
    if (got_header == 0) return error.EndOfStream;
    if (got_header != ztls.frame.header_len) return error.UnexpectedEof;
    const hdr = try ztls.frame.parseHeader(buf[0..ztls.frame.header_len]);
    const len = hdr.length();
    if (len > ztls.frame.max_ciphertext_len) return error.RecordTooLarge;
    const got_payload = try stream.readAtLeast(buf[ztls.frame.header_len..][0..len], len);
    if (got_payload != len) return error.UnexpectedEof;
    return buf[0 .. ztls.frame.header_len + len];
}

fn sendBestEffortAlert(
    hs: *ztls.ServerHandshake,
    stream: std.net.Stream,
    err: anyerror,
    out: []u8,
) void {
    const description: ztls.alert.Description = switch (err) {
        error.AuthenticationFailed => .bad_record_mac,
        error.UnsupportedCipherSuite => .handshake_failure,
        error.NoApplicationProtocol => .no_application_protocol,
        error.UnexpectedRecord, error.UnexpectedMessage => .unexpected_message,
        error.IllegalParameter => .illegal_parameter,
        error.IncompleteRecord,
        error.UnexpectedEof,
        error.RecordTooShort,
        error.InvalidInnerPlaintext,
        => .decode_error,
        else => .internal_error,
    };
    const alert_record = hs.sendAlert(description, out) catch return;
    stream.writeAll(alert_record) catch return;
}
