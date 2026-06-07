//! BoGo shim — minimal server mode for BoringSSL test runner integration.
//!
//! Implements a subset of the BoGo shim CLI contract. Test harness code;
//! allocators and I/O are acceptable here.
//!
//! Supported flags (server mode):
//!   -server                act as a server (listen on -port)
//!   -host <host>           host to connect to (client) or bind to (server)
//!   -port <port>           port to listen on or connect to
//!   -key-file <path>       parsed but unsupported; embedded fixture only for now
//!   -cert-file <path>      parsed but unsupported; embedded fixture only for now
//!   -alpn <protocols>      comma-separated ALPN protocols
//!   -curves <curves>       parsed but ignored beyond X25519
//!   -expect-version <ver>  expected TLS version (must be 1.3)
//!   -expect-cipher-suite <suite>  expected cipher suite name
//!   -expect-alpn <proto>   expected negotiated ALPN protocol
//!   -no-ticket             parsed but ignored; ztls sends no tickets
//!   -shim-writes-first     parsed but not implemented yet
const std = @import("std");
const mem = std.mem;
const net = std.net;
const crypto = std.crypto;
const print = std.debug.print;

const ztls = @import("ztls");

// Embedded fallback fixtures when files aren't provided.
const fallback_cert_der = @embedFile("fixtures/server-ecdsa/server.der");
const fallback_scalar = @embedFile("fixtures/server-ecdsa/scalar.bin");

const Args = struct {
    server: bool = false,
    host: []const u8 = "127.0.0.1",
    port: u16 = 0,
    key_file: ?[]const u8 = null,
    cert_file: ?[]const u8 = null,
    alpn: ?[]const u8 = null,
    curves: ?[]const u8 = null,
    expect_version: ?[]const u8 = null,
    expect_cipher_suite: ?[]const u8 = null,
    expect_alpn: ?[]const u8 = null,
    no_ticket: bool = false,
    shim_writes_first: bool = false,
};

fn parseArgs(arena: mem.Allocator) !Args {
    var args: Args = .{};
    var it = try std.process.argsWithAllocator(arena);
    defer it.deinit();
    _ = it.next(); // skip executable name
    while (it.next()) |arg| {
        if (mem.eql(u8, arg, "-server")) {
            args.server = true;
        } else if (mem.eql(u8, arg, "-host")) {
            args.host = it.next() orelse return error.MissingArg;
        } else if (mem.eql(u8, arg, "-port")) {
            const port_str = it.next() orelse return error.MissingArg;
            args.port = try std.fmt.parseInt(u16, port_str, 10);
        } else if (mem.eql(u8, arg, "-key-file")) {
            args.key_file = it.next();
        } else if (mem.eql(u8, arg, "-cert-file")) {
            args.cert_file = it.next();
        } else if (mem.eql(u8, arg, "-alpn")) {
            args.alpn = it.next();
        } else if (mem.eql(u8, arg, "-curves")) {
            args.curves = it.next();
        } else if (mem.eql(u8, arg, "-expect-version")) {
            args.expect_version = it.next();
        } else if (mem.eql(u8, arg, "-expect-cipher-suite")) {
            args.expect_cipher_suite = it.next();
        } else if (mem.eql(u8, arg, "-expect-alpn")) {
            args.expect_alpn = it.next();
        } else if (mem.eql(u8, arg, "-no-ticket")) {
            args.no_ticket = true;
        } else if (mem.eql(u8, arg, "-shim-writes-first")) {
            args.shim_writes_first = true;
        }
        // Unknown flags are silently ignored for forward compatibility.
    }
    return args;
}

fn loadKey(path: ?[]const u8) !ztls.signature.PrivateKey {
    if (path != null) return error.UnsupportedKeyFile;
    return .fromP256Scalar(fallback_scalar[0..32]);
}

fn loadCert(path: ?[]const u8) ![]const u8 {
    if (path != null) return error.UnsupportedCertFile;
    return fallback_cert_der;
}

fn readRecord(stream: net.Stream, buf: []u8) ![]u8 {
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

fn expectVersion(version: ?[]const u8) !void {
    if (version) |v| {
        if (!mem.eql(u8, v, "1.3") and !mem.eql(u8, v, "TLS1.3") and !mem.eql(u8, v, "tls1.3")) return error.VersionMismatch;
    }
}

fn suiteName(suite: ztls.CipherSuite) []const u8 {
    return switch (suite) {
        .aes_128_gcm_sha256 => "TLS_AES_128_GCM_SHA256",
        .aes_256_gcm_sha384 => "TLS_AES_256_GCM_SHA384",
        .chacha20_poly1305_sha256 => "TLS_CHACHA20_POLY1305_SHA256",
    };
}

fn expectCipherSuite(expected: ?[]const u8, actual: ztls.CipherSuite) !void {
    if (expected) |name| {
        if (!mem.eql(u8, name, suiteName(actual))) return error.CipherSuiteMismatch;
    }
}

fn expectAlpn(expected: ?[]const u8, actual: ?[]const u8) !void {
    if (expected) |want| {
        const got = actual orelse return error.AlpnMismatch;
        if (!mem.eql(u8, want, got)) return error.AlpnMismatch;
    }
}

fn checkExpectations(args: Args, hs: *const ztls.ServerHandshake) !void {
    try expectVersion(args.expect_version);
    try expectCipherSuite(args.expect_cipher_suite, hs.suite);
    try expectAlpn(args.expect_alpn, hs.selectedAlpnProtocol());
}

fn sendBestEffortAlert(hs: *ztls.ServerHandshake, stream: net.Stream, err: anyerror, out: []u8) void {
    const description: ztls.alert.Description = switch (err) {
        error.AuthenticationFailed => .bad_record_mac,
        error.UnsupportedCipherSuite => .handshake_failure,
        error.NoApplicationProtocol => .no_application_protocol,
        error.UnexpectedRecord, error.UnexpectedMessage => .unexpected_message,
        error.IllegalParameter => .illegal_parameter,
        error.IncompleteRecord, error.UnexpectedEof, error.RecordTooShort, error.InvalidInnerPlaintext => .decode_error,
        else => .internal_error,
    };
    const alert_record = hs.sendAlert(description, out) catch return;
    stream.writeAll(alert_record) catch return;
}

pub fn main() !void {
    var arena_allocator: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();

    const args = try parseArgs(arena);

    if (!args.server) {
        // Client mode is future work.
        print("bogo_shim: client mode not yet implemented\n", .{});
        std.process.exit(1);
    }

    const cert_der = try loadCert(args.cert_file);
    var signer = try loadKey(args.key_file);
    defer signer.deinit();

    const address = try net.Address.parseIp(args.host, args.port);
    var server = try address.listen(.{ .reuse_address = true });
    defer server.deinit();

    print("ztls bogo shim listening on {s}:{d}\n", .{ args.host, args.port });

    const conn = try server.accept();
    defer conn.stream.close();

    var hs: ztls.ServerHandshake = .init(.generate());
    defer hs.deinit();

    if (args.alpn) |alpn_str| {
        // Parse comma-separated list.
        var protocols: std.ArrayList([]const u8) = .empty;
        defer protocols.deinit(arena);
        var it = mem.splitScalar(u8, alpn_str, ',');
        while (it.next()) |p| {
            if (p.len > 0) try protocols.append(arena, p);
        }
        if (protocols.items.len > 0) {
            hs.supportAlpn(protocols.items);
        }
    }

    var in_buf: [ztls.frame.header_len + ztls.frame.max_ciphertext_len]u8 = undefined;
    var out_buf: [ztls.frame.header_len + ztls.frame.max_plaintext_len + ztls.aead.tag_len + 1]u8 = undefined;
    var expectations_checked = false;

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
                    const flight = hs.sendPreparedAuthenticatedFlight(&.{cert_der}, signer.signer(), &out_buf) catch |err| {
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

        if (hs.isConnected() and !expectations_checked) {
            checkExpectations(args, &hs) catch |err| {
                print("bogo_shim: expectation failed: {s}\n", .{@errorName(err)});
                return err;
            };
            expectations_checked = true;
        }
    }
}

fn randomBytes() ztls.client_hello.Random {
    var bytes: [32]u8 = undefined;
    std.crypto.random.bytes(&bytes);
    return .init(bytes);
}
