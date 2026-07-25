//! Client configuration shared across many connections.
//!
//! The expensive, reusable piece of a TLS client is the trust store: loading the
//! OS bundle parses every certificate in `/etc/ssl/certs`. ztls-std rescans it
//! per `connect` when `verify == .system_bundle`, which is the wrong trade for a
//! server-side proxy opening thousands of outbound connections. Here it is
//! loaded once into a `ClientConfig` and borrowed by every `Conn`.
//!
//! A `ClientConfig` is immutable once built and safe to share across connections on
//! one event loop. It holds no per-connection state.
const std = @import("std");
const assert = std.debug.assert;
const crypto = std.crypto;
const mem = std.mem;
const testing = std.testing;

const ztls = @import("ztls");

const ClientConfig = @This();

/// Certificate verification policy. No default: a TLS client should not be able
/// to skip this decision by omission.
pub const Verify = union(enum) {
    /// Verify against a bundle this `ClientConfig` owns, loaded from the OS trust
    /// store by `initSystemBundle`.
    owned_bundle,
    /// Verify against a caller-owned bundle. Borrowed for the `ClientConfig`'s life.
    bundle: *const crypto.Certificate.Bundle,
    /// Skip chain-anchor verification. Hostname verification still runs unless
    /// the per-connection `host` is null. Demo/test only.
    insecure,
};

pub const Options = struct {
    verify: Verify,
    /// ALPN protocols to offer, in preference order. Borrowed for the `ClientConfig`'s
    /// life, so it must outlive every `Conn` using it.
    alpn: []const []const u8 = &.{},
    /// Offer an X25519MLKEM768 hybrid key share (post-quantum). False by
    /// default: it adds ~1.2 KB to every ClientHello.
    offer_pq_key_share: bool = false,
};

verify: Verify,
alpn: []const []const u8,
offer_pq_key_share: bool,
/// Owned only when `verify == .owned_bundle`; `deinit` frees it.
bundle: crypto.Certificate.Bundle = .empty,
gpa: ?mem.Allocator = null,

/// Build a `ClientConfig` around a caller-owned bundle or `.insecure`. No allocation.
pub fn init(options: Options) ClientConfig {
    assert(options.verify != .owned_bundle); // use initSystemBundle
    return .{
        .verify = options.verify,
        .alpn = options.alpn,
        .offer_pq_key_share = options.offer_pq_key_share,
    };
}

/// Load the OS trust store once, into a bundle this `ClientConfig` owns. `gpa` is
/// retained for `deinit`. `options.verify` is ignored and forced to
/// `.owned_bundle`.
pub fn initSystemBundle(
    io: std.Io,
    gpa: mem.Allocator,
    options: Options,
) !ClientConfig {
    var bundle: crypto.Certificate.Bundle = .empty;
    try bundle.rescan(gpa, io, std.Io.Timestamp.now(io, .real));
    return .{
        .verify = .owned_bundle,
        .alpn = options.alpn,
        .offer_pq_key_share = options.offer_pq_key_share,
        .bundle = bundle,
        .gpa = gpa,
    };
}

pub fn deinit(self: *ClientConfig) void {
    if (self.gpa) |gpa| self.bundle.deinit(gpa);
    self.* = undefined;
}

/// Trust anchors to hand the engine, or null when anchoring is disabled.
pub fn trustAnchors(self: *const ClientConfig) ?*const crypto.Certificate.Bundle {
    return switch (self.verify) {
        .owned_bundle => &self.bundle,
        .bundle => |b| b,
        .insecure => null,
    };
}

pub fn insecureNoChainAnchor(self: *const ClientConfig) bool {
    return self.verify == .insecure;
}

test "init: insecure config needs no allocator and anchors nothing" {
    var config: ClientConfig = .init(.{ .verify = .insecure, .alpn = &.{"h2"} });
    defer config.deinit();

    try testing.expect(config.insecureNoChainAnchor());
    try testing.expectEqual(@as(?*const crypto.Certificate.Bundle, null), config.trustAnchors());
    try testing.expectEqualStrings("h2", config.alpn[0]);
}

test "init: a borrowed bundle is anchored and not owned" {
    const bundle: crypto.Certificate.Bundle = .empty;
    var config: ClientConfig = .init(.{ .verify = .{ .bundle = &bundle } });
    defer config.deinit();

    try testing.expect(!config.insecureNoChainAnchor());
    try testing.expectEqual(&bundle, config.trustAnchors().?);
    // Nothing to free: no allocator was retained.
    try testing.expectEqual(@as(?mem.Allocator, null), config.gpa);
}

test "config is reusable across connections: no per-connection state" {
    // The whole point of Config existing rather than per-connect Options is that
    // the trust store is loaded once. Assert the type carries nothing that would
    // make sharing it unsafe.
    inline for (@typeInfo(ClientConfig).@"struct".fields) |field| {
        const ok = comptime std.mem.eql(u8, field.name, "verify") or
            std.mem.eql(u8, field.name, "alpn") or
            std.mem.eql(u8, field.name, "offer_pq_key_share") or
            std.mem.eql(u8, field.name, "bundle") or
            std.mem.eql(u8, field.name, "gpa");
        if (!ok) @compileError("new ClientConfig field '" ++ field.name ++
            "': confirm it is connection-independent before sharing a Config");
    }
    _ = ztls;
}
