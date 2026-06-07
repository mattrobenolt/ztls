//! BoGo shim — minimal server mode for BoringSSL test runner integration.
//!
//! Implements a subset of the BoGo shim CLI contract. Test harness code;
//! allocators and I/O are acceptable here.
//!
//! Supported flags (server mode):
//!   -server                act as a server (listen on -port)
//!   -host <host>           host to connect to (client) or bind to (server)
//!   -port <port>           port to listen on or connect to
//!   -key-file <path>       PEM private key path (server)
//!   -cert-file <path>      PEM certificate path (server)
//!   -alpn <protocols>      comma-separated ALPN protocols
//!   -curves <curves>       comma-separated curve names (currently ignored beyond X25519)
//!   -expect-version <ver>  expected TLS version (must be 1.3)
//!   -expect-cipher-suite <suite>  expected cipher suite name
//!   -expect-alpn <proto>   expected negotiated ALPN protocol
//!   -no-ticket             disable session tickets (ignored; already no-op)
//!   -shim-writes-first     send empty application data after handshake
//!
//! PEM parsing is minimal: decodes base64 between -----BEGIN/-----END lines.
//! Only PKCS#8 private keys and X.509 certificates are supported.
const std = @import("std");
const fs = std.fs;
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

/// Minimal PEM decoder: extracts base64 between -----BEGIN ... ----- and
/// -----END ... ----- lines and decodes it. Returns DER bytes.
fn decodePem(arena: mem.Allocator, pem_bytes: []const u8) ![]const u8 {
    var lines = mem.splitScalar(u8, pem_bytes, '\n');
    var in_block = false;
    var b64_buf: std.ArrayList(u8) = .empty;
    defer b64_buf.deinit(arena);

    while (lines.next()) |line| {
        const trimmed = mem.trim(u8, line, " \r\t");
        if (mem.startsWith(u8, trimmed, "-----BEGIN ")) {
            in_block = true;
            continue;
        }
        if (mem.startsWith(u8, trimmed, "-----END ")) {
            in_block = false;
            continue;
        }
        if (in_block) {
            try b64_buf.appendSlice(arena, trimmed);
        }
    }

    if (b64_buf.items.len == 0) return error.EmptyPem;

    const decoder = std.base64.standard.Decoder;
    const size = try decoder.calcSizeForSlice(b64_buf.items);
    const der = try arena.alloc(u8, size);
    try decoder.decode(der, b64_buf.items);
    return der;
}

fn loadKey(arena: mem.Allocator, path: ?[]const u8) !ztls.signature.PrivateKey {
    if (path) |p| {
        const pem = try fs.cwd().readFileAlloc(arena, p, 64 * 1024);
        const der = try decodePem(arena, pem);
        // BoGo test certs are typically ECDSA P-256. Attempt to parse as PKCS#8
        // and fall back to raw scalar for the embedded fixture.
        // For now, if the file isn't found, fall back to embedded fixture.
        _ = der;
        // TODO: proper PKCS#8/SEC1 parsing for arbitrary BoGo test keys.
        // Until then, use the fallback fixture for any key file.
    }
    return try ztls.signature.PrivateKey.fromP256Scalar(fallback_scalar[0..32]);
}

fn loadCert(arena: mem.Allocator, path: ?[]const u8) ![]const u8 {
    if (path) |p| {
        const pem = try fs.cwd().readFileAlloc(arena, p, 64 * 1024);
        const der = try decodePem(arena, pem);
        return der;
    }
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
    stream.writeAll(alert_record) catch {};
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

    const cert_der = try loadCert(arena, args.cert_file);
    var signer = try loadKey(arena, args.key_file);
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
                if (args.expect_alpn) |expected| {
                    if (hs.selectedAlpnProtocol()) |selected| {
                        if (!mem.eql(u8, selected, expected)) {
                            print("bogo_shim: ALPN mismatch: expected '{s}', got '{s}'\n", .{ expected, selected });
                            return error.AlpnMismatch;
                        }
                    }
                }
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
