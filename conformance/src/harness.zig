const std = @import("std");
const Io = std.Io;

const ztls = @import("ztls");

pub const Stream = Io.net.Stream;

const fixtures = @import("fixtures");
const cert_der: []const u8 = &fixtures.server_ecdsa_cert_der;
const scalar: []const u8 = &fixtures.server_ecdsa_scalar;

pub const max_wire_record_len = ztls.frame.header_len +
    ztls.frame.max_plaintext_len +
    ztls.aead.tag_len +
    1;

pub fn testCertDer() []const u8 {
    return cert_der;
}

pub fn testScalar() []const u8 {
    return scalar;
}

pub fn testSigner() !ztls.signature.PrivateKey {
    return .fromP256Scalar(scalar[0..32]);
}

pub fn randomBytes(io: Io) ztls.Random {
    var bytes: [32]u8 = undefined;
    io.random(&bytes);
    return .init(bytes);
}

pub fn hex(comptime len: usize, comptime encoded: []const u8) [len]u8 {
    var out: [len]u8 = @splat(0);
    _ = std.fmt.hexToBytes(&out, encoded) catch unreachable;
    return out;
}

fn readAtLeast(io: Io, stream: Stream, buf: []u8, len: usize) !usize {
    var total: usize = 0;
    while (total < len) {
        var data: [1][]u8 = .{buf[total..]};
        const n = try io.vtable.netRead(io.userdata, stream.socket.handle, &data);
        if (n == 0) break;
        total += n;
    }
    return total;
}

pub fn readRecord(io: Io, stream: Stream, buf: []u8) ![]u8 {
    const got_header = try readAtLeast(
        io,
        stream,
        buf[0..ztls.frame.header_len],
        ztls.frame.header_len,
    );
    if (got_header == 0) return error.EndOfStream;
    if (got_header != ztls.frame.header_len) return error.UnexpectedEof;
    const hdr = try ztls.frame.parseHeader(buf[0..ztls.frame.header_len]);
    const len = hdr.length();
    if (len > ztls.frame.max_ciphertext_len) return error.RecordTooLarge;
    const got_payload = try readAtLeast(io, stream, buf[ztls.frame.header_len..][0..len], len);
    if (got_payload != len) return error.UnexpectedEof;
    return buf[0 .. ztls.frame.header_len + len];
}

pub fn sendBestEffortCloseNotify(
    io: Io,
    hs: *ztls.ServerHandshake,
    stream: Stream,
    out: []u8,
) void {
    const alert_record = hs.sendAlert(.close_notify, out) catch return;
    ztls.io.writeAll(io, stream, alert_record) catch return;
}

pub fn sendBestEffortAlert(
    io: Io,
    hs: *ztls.ServerHandshake,
    stream: Stream,
    err: anyerror,
    out: []u8,
) void {
    const description = ztls.alert.alertForError(err);
    const alert_record = hs.sendAlert(description, out) catch return;
    ztls.io.writeAll(io, stream, alert_record) catch return;
}

pub fn connectWithRetry(io: Io, port: u16) !Stream {
    const addr: Io.net.IpAddress = try .parse("127.0.0.1", port);
    for (0..100) |_| {
        return addr.connect(io, .{ .mode = .stream }) catch {
            const delay: Io.Duration = .fromNanoseconds(20 * std.time.ns_per_ms);
            io.sleep(delay, .awake) catch return error.ServerNeverCameUp;
            continue;
        };
    }
    return error.ServerNeverCameUp;
}
