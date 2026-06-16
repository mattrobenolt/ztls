const std = @import("std");

const ztls = @import("ztls");
const harness = @import("harness.zig");

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

    var signer = try harness.testSigner();
    defer signer.deinit();

    var hs: ztls.ServerHandshake = .init(.generate());
    defer hs.deinit();
    hs.supportAlpn(&.{ "http/1.1", "h2" });
    hs.setCredentials(&.{harness.testCertDer()}, signer.signer());

    // RFC 8446 §5.1 — provide storage for fragmented ClientHello reassembly.
    var reassembly_buf: [ztls.ServerHandshake.ch_reassembly_buffer_size]u8 = undefined;
    hs.useHandshakeBuffer(&reassembly_buf);

    var in_buf: [ztls.frame.header_len + ztls.frame.max_ciphertext_len]u8 = undefined;
    var out_buf: [harness.max_wire_record_len]u8 = undefined;

    while (true) {
        const record = harness.readRecord(conn.stream, &in_buf) catch |err| switch (err) {
            error.EndOfStream => return,
            else => return,
        };

        const random = harness.randomBytes();
        const ev = hs.handleRecord(record, random, &out_buf) catch |err| {
            harness.sendBestEffortAlert(&hs, conn.stream, err, &out_buf);
            return;
        };

        switch (ev) {
            .write => |bytes| {
                try conn.stream.writeAll(bytes);
                hs.completeWrite();
                if (hs.sendPreparedServerFlight(&out_buf) catch |err| {
                    harness.sendBestEffortAlert(&hs, conn.stream, err, &out_buf);
                    return;
                }) |flight| {
                    try conn.stream.writeAll(flight);
                    hs.completeWrite();
                }
            },
            .application_data => |data| {
                const response = hs.sendApplicationData(data, &out_buf) catch |err| {
                    harness.sendBestEffortAlert(&hs, conn.stream, err, &out_buf);
                    return;
                };
                try conn.stream.writeAll(response);
                hs.completeWrite();
            },
            .closed => {
                harness.sendBestEffortCloseNotify(&hs, conn.stream, &out_buf);
                return;
            },
            .none => {},
        }
    }
}
