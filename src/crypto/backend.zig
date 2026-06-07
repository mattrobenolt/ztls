//! Libcrypto-family provider selection.
//!
//! This is the narrow compile-time facade used while the concrete OpenSSL
//! calls still live in the existing primitive modules. It gives future AWS-LC /
//! BoringSSL ports one typed switch point instead of scattering product names
//! through handshake code.
const std = @import("std");
const testing = std.testing;

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

pub const active: Backend = .openssl;

// docs/research/PROVIDER_INTERFACE.md §1 — current production backend is
// OpenSSL/libcrypto; AWS-LC and BoringSSL remain named libcrypto-family targets,
// not runtime claims.
test "backend family is explicit" {
    try testing.expectEqual(Backend.openssl, active);
    try testing.expect(Backend.openssl.isLibcryptoFamily());
    try testing.expect(Backend.aws_lc.isLibcryptoFamily());
    try testing.expect(Backend.boringssl.isLibcryptoFamily());
    try testing.expectEqualStrings("openssl", Backend.openssl.name());
}
