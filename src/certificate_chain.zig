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

    /// Encode a Certificate message echoing the CertificateRequest
    /// request_context (RFC 8446 §4.4.2). Used by the client when responding to
    /// a server CertificateRequest.
    pub fn encodeWithRequestContext(
        self: CertificateChain,
        out: []u8,
        request_context: []const u8,
    ) certificate.EncodeError![]const u8 {
        return switch (self) {
            .slice => |certs_der| certificate.encodeWithRequestContext(
                out,
                request_context,
                certs_der,
            ),
            .single => |cert_der| certificate.encodeWithRequestContext(
                out,
                request_context,
                &.{cert_der},
            ),
        };
    }
};

test "CertificateChain: single certificate view" {
    const cert = [_]u8{ 1, 2, 3 };
    const chain: CertificateChain = .singleCert(&cert);

    try testing.expectEqual(certificate.encodedLen(&.{&cert}), chain.encodedLen());
}
