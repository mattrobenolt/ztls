const testing = @import("std").testing;

const certificate = @import("certificate.zig");

pub const CertificateChain = union(enum) {
    slice: []const []const u8,
    single: []const u8,

    pub const empty: CertificateChain = .{ .slice = &.{} };

    pub fn init(certs_der: []const []const u8) CertificateChain {
        return .{ .slice = certs_der };
    }

    pub fn singleCert(cert_der: []const u8) CertificateChain {
        return .{ .single = cert_der };
    }

    pub fn encodedLen(self: CertificateChain) usize {
        return switch (self) {
            .slice => |certs_der| certificate.encodedLen(certs_der),
            .single => |cert_der| certificate.encodedLen(&.{cert_der}),
        };
    }

    pub fn encode(self: CertificateChain, out: []u8) certificate.EncodeError![]const u8 {
        return switch (self) {
            .slice => |certs_der| certificate.encode(out, certs_der),
            .single => |cert_der| certificate.encode(out, &.{cert_der}),
        };
    }
};

test "CertificateChain: single certificate view" {
    const cert = [_]u8{ 1, 2, 3 };
    const chain: CertificateChain = .singleCert(&cert);

    try testing.expectEqual(certificate.encodedLen(&.{&cert}), chain.encodedLen());
}
