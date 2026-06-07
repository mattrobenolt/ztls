/// Libcrypto-family provider selection.
///
/// This is the narrow compile-time facade used while the concrete OpenSSL
/// calls still live in the existing primitive modules. It gives future AWS-LC /
/// BoringSSL ports one typed switch point instead of scattering product names
/// through handshake code.
const std = @import("std");

pub const Backend = enum {
    openssl,
    aws_lc,
    boringssl,
};

pub const active: Backend = .openssl;

pub fn isLibcryptoFamily(backend: Backend) bool {
    return switch (backend) {
        .openssl, .aws_lc, .boringssl => true,
    };
}

pub fn name(backend: Backend) []const u8 {
    return switch (backend) {
        .openssl => "openssl",
        .aws_lc => "aws-lc",
        .boringssl => "boringssl",
    };
}

// Provider interface roadmap — current production backend is OpenSSL/libcrypto;
// AWS-LC and BoringSSL remain named libcrypto-family targets, not runtime claims.
test "backend family is explicit" {
    try std.testing.expectEqual(Backend.openssl, active);
    try std.testing.expect(isLibcryptoFamily(.openssl));
    try std.testing.expect(isLibcryptoFamily(.aws_lc));
    try std.testing.expect(isLibcryptoFamily(.boringssl));
    try std.testing.expectEqualStrings("openssl", name(.openssl));
}
