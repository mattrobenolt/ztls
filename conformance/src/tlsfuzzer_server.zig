const std = @import("std");
const print = std.debug.print;

const ztls = @import("ztls");

const harness = @import("harness.zig");
const net = @import("net_compat");
const Address = net.Address;

pub fn main() !void {
    const port = try readPort();
    const address: Address = try net.parseIp("127.0.0.1", port);
    var server = try net.listen(address, .{ .reuse_address = true });
    defer net.deinitServer(&server);

    print("ztls tlsfuzzer server listening on 127.0.0.1:{d}\n", .{port});

    while (true) {
        const stream = net.accept(&server) catch |err| switch (err) {
            error.ProcessFdQuotaExceeded, error.SystemFdQuotaExceeded => return err,
            else => continue,
        };
        handleConnection(stream) catch continue;
    }
}

fn readPort() !u16 {
    if (net.env("PORT")) |value| {
        return std.fmt.parseInt(u16, value, 10);
    }
    return 4433;
}

fn handleConnection(stream: net.Stream) !void {
    defer net.close(stream);

    var signer = try harness.testSigner();
    defer signer.deinit();

    const random = harness.randomBytes();
    // RFC 8446 §5.1 — provide storage for fragmented ClientHello reassembly.
    var reassembly_buf: [ztls.ServerHandshake.ch_reassembly_buffer_size]u8 = undefined;
    var hs: ztls.ServerHandshake = .init(.{
        .keypairs = .init(.generate()),
        .random = random,
        .alpn_protocols = &.{ "http/1.1", "h2" },
        .reassembly = &reassembly_buf,
    });
    defer hs.deinit();
    hs.setCredentials(&.{harness.testCertDer()}, signer.signer());

    var in_buf: [ztls.frame.header_len + ztls.frame.max_ciphertext_len]u8 = undefined;
    var out_buf: [harness.max_wire_record_len]u8 = undefined;

    while (true) {
        const record = harness.readRecord(stream, &in_buf) catch |err| switch (err) {
            error.EndOfStream => return,
            else => return,
        };

        const ev = hs.handleRecord(record, &out_buf) catch |err| {
            harness.sendBestEffortAlert(&hs, stream, err, &out_buf);
            return;
        };

        switch (ev) {
            .write => |bytes| {
                try net.writeAll(stream, bytes);
                hs.completeWrite();
                if (hs.sendPreparedServerFlight(&out_buf) catch |err| {
                    harness.sendBestEffortAlert(&hs, stream, err, &out_buf);
                    return;
                }) |flight| {
                    try net.writeAll(stream, flight);
                    hs.completeWrite();
                }
            },
            .application_data => |data| {
                const response = hs.sendApplicationData(data, &out_buf) catch |err| {
                    harness.sendBestEffortAlert(&hs, stream, err, &out_buf);
                    return;
                };
                try net.writeAll(stream, response);
                hs.completeWrite();
            },
            .key_update => |ku| {
                // RFC 8446 §4.6.3 — peer KeyUpdate ratchets traffic keys.
                // Write the response (if any) and acknowledge it; keep serving.
                if (ku.response) |bytes| {
                    try net.writeAll(stream, bytes);
                    hs.completeWrite();
                }
            },
            .closed => {
                harness.sendBestEffortCloseNotify(&hs, stream, &out_buf);
                return;
            },
            .none => {},
        }
    }
}
