const std = @import("std");
const net = std.net;
const time = std.time;
const sleep = std.Thread.sleep;

const ztls = @import("ztls");

const shared_fixtures = @import("test_fixtures/shared_fixtures.zig");
const cert_der: []const u8 = &shared_fixtures.server_ecdsa_cert_der;
const scalar: []const u8 = &shared_fixtures.server_ecdsa_scalar;

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

pub fn randomBytes() ztls.client_hello.Random {
    var bytes: [32]u8 = undefined;
    std.crypto.random.bytes(&bytes);
    return .init(bytes);
}

pub fn hex(comptime len: usize, comptime encoded: []const u8) [len]u8 {
    var out: [len]u8 = @splat(0);
    _ = std.fmt.hexToBytes(&out, encoded) catch unreachable;
    return out;
}

pub fn readRecord(stream: net.Stream, buf: []u8) ![]u8 {
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

pub fn sendBestEffortCloseNotify(hs: anytype, stream: net.Stream, out: []u8) void {
    const alert_record = hs.sendAlert(.close_notify, out) catch return;
    stream.writeAll(alert_record) catch return;
}

pub fn sendBestEffortAlert(
    hs: *ztls.ServerHandshake,
    stream: net.Stream,
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

pub fn connectWithRetry(port: u16) !net.Stream {
    const addr: net.Address = try .parseIp("127.0.0.1", port);
    for (0..100) |_| {
        return net.tcpConnectToAddress(addr) catch {
            sleep(20 * time.ns_per_ms);
            continue;
        };
    }
    return error.ServerNeverCameUp;
}
