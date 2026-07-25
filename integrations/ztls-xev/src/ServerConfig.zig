//! Server credentials shared across many connections.
//!
//! A server presents the same certificate to every client, so the chain and the
//! signer belong to a long-lived config rather than to each `Conn`. That is the
//! mirror of `ClientConfig`, where the expensive shared thing is the trust store
//! rather than the credential.
//!
//! Everything here is borrowed. The DER chain, the `PrivateKey` behind `signer`,
//! and the ALPN list must all outlive every connection using this config —
//! nothing is copied and nothing is freed.
const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;

const ztls = @import("ztls");

const ServerConfig = @This();

pub const Options = struct {
    /// Certificate chain, leaf first, DER. Borrowed.
    cert_chain: []const []const u8,
    /// Signer for CertificateVerify, from
    /// `var key: ztls.signature.PrivateKey = try .fromP256Scalar(scalar);`
    /// then `key.signer()`. The `PrivateKey` must outlive this config.
    signer: ztls.signature.Signer,
    /// ALPN protocols this server accepts, in preference order. Borrowed. An
    /// empty list means ALPN is not offered; a client that requires it will
    /// fail the handshake.
    alpn: []const []const u8 = &.{},
};

cert_chain: []const []const u8,
signer: ztls.signature.Signer,
alpn: []const []const u8,

/// No allocation and nothing to tear down; there is no `deinit` because there
/// is nothing owned. Certificate rotation is a matter of building a new config
/// and pointing new connections at it, leaving in-flight ones on the old one
/// until they finish.
pub fn init(options: Options) ServerConfig {
    // A server with no chain cannot authenticate, and the failure is far more
    // useful here than as a handshake error on every connection.
    assert(options.cert_chain.len > 0);
    return .{
        .cert_chain = options.cert_chain,
        .signer = options.signer,
        .alpn = options.alpn,
    };
}

test "init: credentials are borrowed verbatim" {
    const leaf = [_]u8{ 0x30, 0x82 };
    const chain = [_][]const u8{&leaf};
    var key: ztls.signature.PrivateKey = try .fromP256Scalar(&@as([32]u8, @splat(7)));
    defer key.deinit();

    const config: ServerConfig = .init(.{
        .cert_chain = &chain,
        .signer = key.signer(),
        .alpn = &.{"h2"},
    });

    try testing.expectEqual(@as(usize, 1), config.cert_chain.len);
    try testing.expectEqualSlices(u8, &leaf, config.cert_chain[0]);
    try testing.expectEqualStrings("h2", config.alpn[0]);
}

// The config is shared by every connection, so it must hold nothing that is
// per-connection state. A new field is a prompt to check that.
test "config is reusable across connections: no per-connection state" {
    inline for (@typeInfo(ServerConfig).@"struct".fields) |field| {
        const ok = comptime std.mem.eql(u8, field.name, "cert_chain") or
            std.mem.eql(u8, field.name, "signer") or
            std.mem.eql(u8, field.name, "alpn");
        if (!ok) @compileError("new ServerConfig field '" ++ field.name ++
            "': confirm it is connection-independent before sharing a ServerConfig");
    }
}
