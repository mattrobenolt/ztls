const std = @import("std");
const testing = std.testing;

const certificate = @import("certificate.zig");
const fuzz_compat = @import("fuzz_compat.zig");

const pem_begin_certificate = "-----BEGIN CERTIFICATE-----";
const pem_end_certificate = "-----END CERTIFICATE-----";
const pem_decoder = std.base64.standard.decoderWithIgnore("\t\n\x0b\x0c\r ");

fn findBytes(haystack: []const u8, needle: []const u8) ?usize {
    if (comptime @hasDecl(std.mem, "find")) return std.mem.find(u8, haystack, needle);

    // Zig 0.15 uses indexOf; Zig 0.16 renamed it to find.
    // ziglint-ignore: Z011
    return std.mem.indexOf(u8, haystack, needle);
}

pub const PemDecodeError = error{
    NoCertificate,
    MissingCertificateEnd,
    InvalidCertificateEncoding,
    CertificateBufferTooShort,
    CertificateChainTooLong,
};

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

    /// Decode RFC 7468 CERTIFICATE blocks into caller-owned storage.
    ///
    /// The returned chain borrows both output buffers. They must outlive every
    /// handshake that uses the chain and must not overlap `pem`. One chain slot
    /// is required per block; `pem.len` bytes always suffice for DER storage.
    /// Non-whitespace outside the Base64 alphabet is rejected, and output
    /// storage may contain partial data after an error.
    pub fn fromPem(
        pem: []const u8,
        der_storage: []u8,
        chain_storage: [][]const u8,
    ) PemDecodeError!CertificateChain {
        var pem_pos: usize = 0;
        var der_len: usize = 0;
        var certificate_count: usize = 0;

        while (findBytes(pem[pem_pos..], pem_begin_certificate)) |begin_offset| {
            const body_start = pem_pos + begin_offset + pem_begin_certificate.len;
            const end_offset = findBytes(
                pem[body_start..],
                pem_end_certificate,
            ) orelse return error.MissingCertificateEnd;
            const body_end = body_start + end_offset;

            if (certificate_count == chain_storage.len)
                return error.CertificateChainTooLong;

            const certificate_der = der_storage[der_len..];
            const certificate_len = pem_decoder.decode(
                certificate_der,
                pem[body_start..body_end],
            ) catch |err| switch (err) {
                error.NoSpaceLeft => return error.CertificateBufferTooShort,
                error.InvalidCharacter,
                error.InvalidPadding,
                => return error.InvalidCertificateEncoding,
            };
            if (certificate_len == 0) return error.InvalidCertificateEncoding;

            chain_storage[certificate_count] = certificate_der[0..certificate_len];
            certificate_count += 1;
            der_len += certificate_len;
            pem_pos = body_end + pem_end_certificate.len;
        }

        if (certificate_count == 0) return error.NoCertificate;
        return .init(chain_storage[0..certificate_count]);
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

// RFC 7468 §2, §3, §5.2 — certificate files can contain explanatory text,
// multiple CERTIFICATE blocks, common ASCII whitespace, and mixed newlines.
test "CertificateChain.fromPem: decodes a certificate chain" {
    const pem = "Subject: CN=example.test\r\n" ++
        "-----BEGIN CERTIFICATE-----\r\n" ++
        "MAMC AQE=\r\n" ++
        "-----END CERTIFICATE-----\r\n" ++
        "ignored text\n" ++
        "-----BEGIN CERTIFICATE-----\n" ++
        "MAMCAQI=\n" ++
        "-----END CERTIFICATE-----\n";
    var der_storage: [10]u8 = undefined;
    var chain_storage: [2][]const u8 = undefined;
    const chain: CertificateChain = try .fromPem(pem, &der_storage, &chain_storage);

    const certificates = switch (chain) {
        .slice => |slice| slice,
        .single => unreachable,
    };
    try testing.expectEqual(@as(usize, 2), certificates.len);
    try testing.expectEqualSlices(u8, &.{ 0x30, 0x03, 0x02, 0x01, 0x01 }, certificates[0]);
    try testing.expectEqualSlices(u8, &.{ 0x30, 0x03, 0x02, 0x01, 0x02 }, certificates[1]);
}

// RFC 7468 §2 — malformed boundaries and base64 fail without guessing.
test "CertificateChain.fromPem: rejects malformed input" {
    var der_storage: [16]u8 = undefined;
    var chain_storage: [2][]const u8 = undefined;

    try testing.expectError(
        error.NoCertificate,
        CertificateChain.fromPem("not a certificate", &der_storage, &chain_storage),
    );
    try testing.expectError(
        error.MissingCertificateEnd,
        CertificateChain.fromPem(
            "-----BEGIN CERTIFICATE-----\nMAMCAQE=",
            &der_storage,
            &chain_storage,
        ),
    );
    try testing.expectError(
        error.InvalidCertificateEncoding,
        CertificateChain.fromPem(
            "-----BEGIN CERTIFICATE-----\n!\n-----END CERTIFICATE-----",
            &der_storage,
            &chain_storage,
        ),
    );
    try testing.expectError(
        error.InvalidCertificateEncoding,
        CertificateChain.fromPem(
            "-----BEGIN CERTIFICATE-----\n-----END CERTIFICATE-----",
            &der_storage,
            &chain_storage,
        ),
    );
}

// RFC 7468 §2 — caller-owned storage bounds the decoded bytes and chain count.
test "CertificateChain.fromPem: rejects exhausted caller storage" {
    const one =
        \\-----BEGIN CERTIFICATE-----
        \\MAMCAQE=
        \\-----END CERTIFICATE-----
    ;
    const two = one ++ one;
    var short_der: [4]u8 = undefined;
    var full_der: [10]u8 = undefined;
    var one_certificate: [1][]const u8 = undefined;

    try testing.expectError(
        error.CertificateBufferTooShort,
        CertificateChain.fromPem(one, &short_der, &one_certificate),
    );
    try testing.expectError(
        error.CertificateChainTooLong,
        CertificateChain.fromPem(two, &full_der, &one_certificate),
    );
}

fn fuzzFromPem(_: void, input: []const u8) anyerror!void {
    var der_storage: [1024]u8 = undefined;
    var chain_storage: [8][]const u8 = undefined;
    _ = CertificateChain.fromPem(input, &der_storage, &chain_storage) catch return;
}

// RFC 7468 §2 — textual certificate parsing must reject arbitrary input with
// an error, never panic or write outside caller-provided storage.
test "fuzz: CertificateChain.fromPem handles arbitrary input" {
    const seed =
        \\-----BEGIN CERTIFICATE-----
        \\MAMCAQE=
        \\-----END CERTIFICATE-----
    ;
    try fuzz_compat.fuzzBytes(fuzzFromPem, {}, .{ .corpus = &.{seed} });
}
