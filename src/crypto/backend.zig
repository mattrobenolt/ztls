//! Libcrypto-family provider selection.
//!
//! This is the narrow compile-time facade used while the concrete OpenSSL
//! calls still live in the existing primitive modules. It gives future AWS-LC /
//! BoringSSL ports one typed switch point instead of scattering product names
//! through handshake code.
const std = @import("std");
const testing = std.testing;

const build_options = @import("build_options");
const backend_openssl = @import("backend_openssl.zig");
const backend_aws_lc = @import("backend_aws_lc.zig");

pub const Backend = enum {
    openssl,
    aws_lc,
    boringssl,

    pub fn isLibcryptoFamily(comptime self: Backend) bool {
        return switch (self) {
            .openssl, .aws_lc, .boringssl => true,
        };
    }

    pub fn name(comptime self: Backend) []const u8 {
        return switch (self) {
            .openssl => "openssl",
            .aws_lc => "aws-lc",
            .boringssl => "boringssl",
        };
    }
};

pub const active: Backend = parse(build_options.crypto_backend) orelse
    @compileError("unsupported crypto backend: " ++ build_options.crypto_backend);

const x25519_impl = switch (active) {
    .openssl => backend_openssl,
    .aws_lc => backend_aws_lc,
    .boringssl => @compileError("BoringSSL backend not yet implemented"),
};

const p256_impl = switch (active) {
    .openssl => backend_openssl,
    .aws_lc => backend_aws_lc,
    .boringssl => @compileError("BoringSSL backend not yet implemented"),
};

pub const x25519 = struct {
    pub const Error = x25519_impl.Error;
    pub const pkey = x25519_impl.pkey;

    pub inline fn privateKeyFromSecret(secret: *const [32]u8) Error!*pkey {
        return x25519_impl.privateKeyFromSecret(secret);
    }

    pub inline fn publicKeyFromRaw(public_key: *const [32]u8) Error!*pkey {
        return x25519_impl.publicKeyFromRaw(public_key);
    }

    pub inline fn rawPublicKeyFromPrivate(key: *pkey) Error![32]u8 {
        return x25519_impl.rawPublicKeyFromPrivate(key);
    }

    pub inline fn sharedSecretDerive(ours: *pkey, peer: *pkey, out: *[32]u8) Error!void {
        return x25519_impl.sharedSecretDerive(ours, peer, out);
    }

    pub inline fn freeKey(key: *pkey) void {
        x25519_impl.freeKey(key);
    }
};

pub const p256 = struct {
    pub const Error = p256_impl.Error;
    pub const pkey = p256_impl.pkey;

    pub inline fn privateKeyFromSecret(secret: *const [32]u8) Error!*pkey {
        return p256_impl.p256PrivateKeyFromSecret(secret);
    }

    pub inline fn publicKeyFromRaw(public_key: *const [65]u8) Error!*pkey {
        return p256_impl.p256PublicKeyFromRaw(public_key);
    }

    pub inline fn rawPublicKeyFromPrivate(key: *pkey) Error![65]u8 {
        return p256_impl.p256RawPublicKeyFromPrivate(key);
    }

    pub inline fn sharedSecretDerive(ours: *pkey, peer: *pkey, out: *[32]u8) Error!void {
        return p256_impl.p256SharedSecretDerive(ours, peer, out);
    }

    pub inline fn freeKey(key: *pkey) void {
        p256_impl.freeKey(key);
    }
};

fn parse(comptime name_: []const u8) ?Backend {
    if (std.mem.eql(u8, name_, "openssl")) return .openssl;
    if (std.mem.eql(u8, name_, "aws-lc")) return .aws_lc;
    if (std.mem.eql(u8, name_, "boringssl")) return .boringssl;
    return null;
}

// docs/research/PROVIDER_INTERFACE.md §1 — current production backend is
// OpenSSL/libcrypto; AWS-LC and BoringSSL remain named libcrypto-family targets,
// not runtime claims.
test "backend family is explicit" {
    try testing.expectEqualStrings(build_options.crypto_backend, active.name());
    try testing.expect(active.isLibcryptoFamily());
    inline for (@typeInfo(Backend).@"enum".fields) |field| {
        const backend: Backend = @enumFromInt(field.value);
        try testing.expectEqual(backend, parse(backend.name()).?);
    }
    try testing.expect(Backend.openssl.isLibcryptoFamily());
    try testing.expect(Backend.aws_lc.isLibcryptoFamily());
    try testing.expect(Backend.boringssl.isLibcryptoFamily());
    try testing.expectEqualStrings("openssl", Backend.openssl.name());
    try testing.expectEqualStrings("aws-lc", Backend.aws_lc.name());
}
