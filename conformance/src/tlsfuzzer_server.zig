const std = @import("std");
const Io = std.Io;
const print = std.debug.print;
const IpAddress = Io.net.IpAddress;

const ztls = @import("ztls");

const harness = @import("harness.zig");

const hybrid_groups = [_]ztls.kex.NamedGroup{
    .x25519_mlkem768,
    .secp256r1_mlkem768,
    .secp384r1_mlkem1024,
};

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const port = try readPort(init.environ_map);
    const address: IpAddress = try .parse("127.0.0.1", port);
    var server = try address.listen(io, .{ .reuse_address = true });
    defer server.deinit(io);

    print("ztls tlsfuzzer server listening on 127.0.0.1:{d}\n", .{port});

    while (true) {
        const stream = server.accept(io) catch |err| switch (err) {
            error.ProcessFdQuotaExceeded, error.SystemFdQuotaExceeded => return err,
            else => continue,
        };
        handleConnection(io, stream) catch continue;
    }
}

fn readPort(env: *std.process.Environ.Map) !u16 {
    if (env.get("PORT")) |value| {
        return std.fmt.parseInt(u16, value, 10);
    }
    return 4433;
}

fn handleConnection(io: Io, stream: harness.Stream) !void {
    defer stream.close(io);

    var signer = try harness.testSigner();
    defer signer.deinit();

    const random = harness.randomBytes(io);
    // RFC 8446 §5.1 — provide storage for fragmented ClientHello reassembly.
    var reassembly_buf: [ztls.ServerHandshake.ch_reassembly_buffer_size]u8 = undefined;
    var hs: ztls.ServerHandshake = .init(.{
        .keypairs = .initWithP256P384(
            .generate(),
            try .generate(),
            try .generate(),
        ),
        .random = random,
        .hybrid_groups = &hybrid_groups,
        .alpn_protocols = &.{ "http/1.1", "h2" },
        .reassembly = &reassembly_buf,
    });
    defer hs.deinit();
    hs.setCredentials(&.{harness.testCertDer()}, signer.signer());

    var in_buf: [ztls.frame.header_len + ztls.frame.max_ciphertext_len]u8 = undefined;
    var out_buf: [harness.max_wire_record_len]u8 = undefined;

    while (true) {
        const record = harness.readRecord(io, stream, &in_buf) catch |err| switch (err) {
            error.EndOfStream => return,
            else => return,
        };

        const ev = hs.handleRecord(record, &out_buf) catch |err| {
            harness.sendBestEffortAlert(io, &hs, stream, err, &out_buf);
            return;
        };

        switch (ev) {
            .write => |bytes| {
                try ztls.io.writeAll(io, stream, bytes);
                hs.completeWrite();
                if (hs.sendPreparedServerFlight(&out_buf) catch |err| {
                    harness.sendBestEffortAlert(io, &hs, stream, err, &out_buf);
                    return;
                }) |flight| {
                    try ztls.io.writeAll(io, stream, flight);
                    hs.completeWrite();
                }
            },
            .application_data => |data| {
                const response = hs.sendApplicationData(data, &out_buf) catch |err| {
                    harness.sendBestEffortAlert(io, &hs, stream, err, &out_buf);
                    return;
                };
                try ztls.io.writeAll(io, stream, response);
                hs.completeWrite();
            },
            .key_update => |ku| {
                // RFC 8446 §4.6.3 — peer KeyUpdate ratchets traffic keys.
                // Write the response (if any) and acknowledge it; keep serving.
                if (ku.response) |bytes| {
                    try ztls.io.writeAll(io, stream, bytes);
                    hs.completeWrite();
                }
            },
            .closed => {
                harness.sendBestEffortCloseNotify(io, &hs, stream, &out_buf);
                return;
            },
            .none => {},
        }
    }
}
