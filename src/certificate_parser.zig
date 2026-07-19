//! X.509 certificate parser — ztls-owned fork of Zig 0.15.2 std.crypto.Certificate.
//!
//! SPDX-License-Identifier: MIT
//! Copyright (c) Zig contributors
//! Source: https://github.com/ziglang/zig/blob/0.15.2/lib/std/crypto/Certificate.zig
//!
//! Local changes from upstream:
//! - Import std as a package module (`@import("std")`) instead of std-internal path.
//! - Bounds-check DER element parsing so malformed certificate lengths return
//!   CertificateFieldHasInvalidLength instead of panicking on out-of-bounds access.
//! - Name-constraints parsing and enforcement (RFC 5280 §4.2.1.10).
//! - DNS-fallback-to-CN for hostname and name-constraint checking (RFC 5280 §4.2.1.10).

const std = @import("std");
const crypto = std.crypto;
const mem = std.mem;
/// OS trust-store loading stays std-owned; ztls owns X.509 parse-and-verify.
pub const Bundle = std.crypto.Certificate.Bundle;

buffer: []const u8,
index: u32,

pub const Version = enum { v1, v2, v3 };

pub const Algorithm = enum {
    sha1WithRSAEncryption,
    sha224WithRSAEncryption,
    sha256WithRSAEncryption,
    sha384WithRSAEncryption,
    sha512WithRSAEncryption,
    ecdsa_with_SHA224,
    ecdsa_with_SHA256,
    ecdsa_with_SHA384,
    ecdsa_with_SHA512,
    md2WithRSAEncryption,
    md5WithRSAEncryption,
    curveEd25519,

    pub const map = std.StaticStringMap(Algorithm).initComptime(.{
        .{ &.{ 0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x01, 0x01, 0x05 }, .sha1WithRSAEncryption },
        .{ &.{ 0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x01, 0x01, 0x0B }, .sha256WithRSAEncryption },
        .{ &.{ 0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x01, 0x01, 0x0C }, .sha384WithRSAEncryption },
        .{ &.{ 0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x01, 0x01, 0x0D }, .sha512WithRSAEncryption },
        .{ &.{ 0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x01, 0x01, 0x0E }, .sha224WithRSAEncryption },
        .{ &.{ 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x04, 0x03, 0x01 }, .ecdsa_with_SHA224 },
        .{ &.{ 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x04, 0x03, 0x02 }, .ecdsa_with_SHA256 },
        .{ &.{ 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x04, 0x03, 0x03 }, .ecdsa_with_SHA384 },
        .{ &.{ 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x04, 0x03, 0x04 }, .ecdsa_with_SHA512 },
        .{ &.{ 0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x01, 0x01, 0x02 }, .md2WithRSAEncryption },
        .{ &.{ 0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x01, 0x01, 0x04 }, .md5WithRSAEncryption },
        .{ &.{ 0x2B, 0x65, 0x70 }, .curveEd25519 },
    });

    pub fn Hash(comptime algorithm: Algorithm) type {
        return switch (algorithm) {
            .sha1WithRSAEncryption => crypto.hash.Sha1,
            .ecdsa_with_SHA224, .sha224WithRSAEncryption => crypto.hash.sha2.Sha224,
            .ecdsa_with_SHA256, .sha256WithRSAEncryption => crypto.hash.sha2.Sha256,
            .ecdsa_with_SHA384, .sha384WithRSAEncryption => crypto.hash.sha2.Sha384,
            .ecdsa_with_SHA512, .sha512WithRSAEncryption, .curveEd25519 => crypto.hash.sha2.Sha512,
            .md2WithRSAEncryption => @compileError("unimplemented"),
            .md5WithRSAEncryption => crypto.hash.Md5,
        };
    }
};

const AlgorithmCategory = enum {
    rsaEncryption,
    rsassa_pss,
    X9_62_id_ecPublicKey,
    curveEd25519,

    pub const map = std.StaticStringMap(AlgorithmCategory).initComptime(.{
        .{ &.{ 0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x01, 0x01, 0x01 }, .rsaEncryption },
        .{ &.{ 0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x01, 0x01, 0x0A }, .rsassa_pss },
        .{ &.{ 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x02, 0x01 }, .X9_62_id_ecPublicKey },
        .{ &.{ 0x2B, 0x65, 0x70 }, .curveEd25519 },
    });
};

const Attribute = enum {
    commonName,
    serialNumber,
    countryName,
    localityName,
    stateOrProvinceName,
    streetAddress,
    organizationName,
    organizationalUnitName,
    postalCode,
    organizationIdentifier,
    pkcs9_emailAddress,
    domainComponent,

    pub const map = std.StaticStringMap(Attribute).initComptime(.{
        .{ &.{ 0x55, 0x04, 0x03 }, .commonName },
        .{ &.{ 0x55, 0x04, 0x05 }, .serialNumber },
        .{ &.{ 0x55, 0x04, 0x06 }, .countryName },
        .{ &.{ 0x55, 0x04, 0x07 }, .localityName },
        .{ &.{ 0x55, 0x04, 0x08 }, .stateOrProvinceName },
        .{ &.{ 0x55, 0x04, 0x09 }, .streetAddress },
        .{ &.{ 0x55, 0x04, 0x0A }, .organizationName },
        .{ &.{ 0x55, 0x04, 0x0B }, .organizationalUnitName },
        .{ &.{ 0x55, 0x04, 0x11 }, .postalCode },
        .{ &.{ 0x55, 0x04, 0x61 }, .organizationIdentifier },
        .{ &.{ 0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x01, 0x09, 0x01 }, .pkcs9_emailAddress },
        .{ &.{ 0x09, 0x92, 0x26, 0x89, 0x93, 0xF2, 0x2C, 0x64, 0x01, 0x19 }, .domainComponent },
    });
};

const NamedCurve = enum {
    secp384r1,
    secp521r1,
    X9_62_prime256v1,

    pub const map = std.StaticStringMap(NamedCurve).initComptime(.{
        .{ &.{ 0x2B, 0x81, 0x04, 0x00, 0x22 }, .secp384r1 },
        .{ &.{ 0x2B, 0x81, 0x04, 0x00, 0x23 }, .secp521r1 },
        .{ &.{ 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x03, 0x01, 0x07 }, .X9_62_prime256v1 },
    });

    pub fn Curve(comptime curve: NamedCurve) type {
        return switch (curve) {
            .X9_62_prime256v1 => crypto.ecc.P256,
            .secp384r1 => crypto.ecc.P384,
            .secp521r1 => @compileError("unimplemented"),
        };
    }
};

const ExtensionId = enum {
    subject_key_identifier,
    key_usage,
    private_key_usage_period,
    subject_alt_name,
    issuer_alt_name,
    basic_constraints,
    crl_number,
    certificate_policies,
    authority_key_identifier,
    msCertsrvCAVersion,
    commonName,
    ext_key_usage,
    crl_distribution_points,
    info_access,
    entrustVersInfo,
    enroll_certtype,
    pe_logotype,
    netscape_cert_type,
    netscape_comment,
    name_constraints,

    pub const map = std.StaticStringMap(ExtensionId).initComptime(.{
        .{ &.{ 0x55, 0x04, 0x03 }, .commonName },
        .{ &.{ 0x55, 0x1D, 0x01 }, .authority_key_identifier },
        .{ &.{ 0x55, 0x1D, 0x07 }, .subject_alt_name },
        .{ &.{ 0x55, 0x1D, 0x0E }, .subject_key_identifier },
        .{ &.{ 0x55, 0x1D, 0x0F }, .key_usage },
        .{ &.{ 0x55, 0x1D, 0x0A }, .basic_constraints },
        .{ &.{ 0x55, 0x1D, 0x10 }, .private_key_usage_period },
        .{ &.{ 0x55, 0x1D, 0x11 }, .subject_alt_name },
        .{ &.{ 0x55, 0x1D, 0x12 }, .issuer_alt_name },
        .{ &.{ 0x55, 0x1D, 0x13 }, .basic_constraints },
        .{ &.{ 0x55, 0x1D, 0x14 }, .crl_number },
        .{ &.{ 0x55, 0x1D, 0x1F }, .crl_distribution_points },
        .{ &.{ 0x55, 0x1D, 0x20 }, .certificate_policies },
        .{ &.{ 0x55, 0x1D, 0x23 }, .authority_key_identifier },
        .{ &.{ 0x55, 0x1D, 0x1E }, .name_constraints },
        .{ &.{ 0x55, 0x1D, 0x25 }, .ext_key_usage },
        .{ &.{ 0x2B, 0x06, 0x01, 0x04, 0x01, 0x82, 0x37, 0x15, 0x01 }, .msCertsrvCAVersion },
        .{ &.{ 0x2B, 0x06, 0x01, 0x05, 0x05, 0x07, 0x01, 0x01 }, .info_access },
        .{ &.{ 0x2A, 0x86, 0x48, 0x86, 0xF6, 0x7D, 0x07, 0x41, 0x00 }, .entrustVersInfo },
        .{ &.{ 0x2b, 0x06, 0x01, 0x04, 0x01, 0x82, 0x37, 0x14, 0x02 }, .enroll_certtype },
        .{ &.{ 0x2b, 0x06, 0x01, 0x05, 0x05, 0x07, 0x01, 0x0c }, .pe_logotype },
        .{ &.{ 0x60, 0x86, 0x48, 0x01, 0x86, 0xf8, 0x42, 0x01, 0x01 }, .netscape_cert_type },
        .{ &.{ 0x60, 0x86, 0x48, 0x01, 0x86, 0xf8, 0x42, 0x01, 0x0d }, .netscape_comment },
    });
};

const GeneralNameTag = enum(u5) {
    otherName = 0,
    rfc822Name = 1,
    dNSName = 2,
    x400Address = 3,
    directoryName = 4,
    ediPartyName = 5,
    uniformResourceIdentifier = 6,
    iPAddress = 7,
    registeredID = 8,
    _,
};

pub const Parsed = struct {
    certificate: Certificate,
    issuer_slice: Slice,
    subject_slice: Slice,
    common_name_slice: Slice,
    signature_slice: Slice,
    signature_algorithm: Algorithm,
    pub_key_algo: PubKeyAlgo,
    pub_key_slice: Slice,
    message_slice: Slice,
    subject_alt_name_slice: Slice,
    key_usage_slice: Slice,
    ext_key_usage_slice: Slice,
    name_constraints_slice: Slice,
    name_constraints_critical: bool,
    is_ca: bool = false,
    basic_constraints_path_len: ?u8 = null,
    validity: Validity,
    version: Version,

    pub const PubKeyAlgo = union(AlgorithmCategory) {
        rsaEncryption: void,
        rsassa_pss: void,
        X9_62_id_ecPublicKey: NamedCurve,
        curveEd25519: void,
    };

    pub const Validity = struct {
        not_before: u64,
        not_after: u64,
    };

    pub const Slice = der.Element.Slice;

    fn slice(p: Parsed, s: Slice) []const u8 {
        return p.certificate.buffer[s.start..s.end];
    }

    pub fn issuer(p: Parsed) []const u8 {
        return p.slice(p.issuer_slice);
    }

    pub fn subject(p: Parsed) []const u8 {
        return p.slice(p.subject_slice);
    }

    fn commonName(p: Parsed) []const u8 {
        return p.slice(p.common_name_slice);
    }

    fn signature(p: Parsed) []const u8 {
        return p.slice(p.signature_slice);
    }

    pub fn pubKey(p: Parsed) []const u8 {
        return p.slice(p.pub_key_slice);
    }

    fn message(p: Parsed) []const u8 {
        return p.slice(p.message_slice);
    }

    fn subjectAltName(p: Parsed) []const u8 {
        return p.slice(p.subject_alt_name_slice);
    }

    fn keyUsage(p: Parsed) []const u8 {
        return p.slice(p.key_usage_slice);
    }

    fn extKeyUsage(p: Parsed) []const u8 {
        return p.slice(p.ext_key_usage_slice);
    }

    pub fn nameConstraints(p: Parsed) []const u8 {
        return p.slice(p.name_constraints_slice);
    }

    pub const NameConstraintError = der.Element.ParseError || error{
        CertificateFieldHasWrongDataType,
        CertificateNameConstraintViolation,
        CertificateNameConstraintUnsupported,
    };

    const NameConstraintName = struct {
        tag: GeneralNameTag,
        value: []const u8,
    };

    /// RFC 5280 §4.2.1.10 — a CA's Name Constraints extension restricts all
    /// supported GeneralName values in subordinate certificates.
    pub fn verifyNameConstraints(ca: Parsed, subordinate: Parsed) NameConstraintError!void {
        if (ca.nameConstraints().len == 0) return;
        if (ca.name_constraints_critical) try ca.verifyNameConstraintSupport();

        const subject_alt_name = subordinate.subjectAltName();
        if (subject_alt_name.len == 0) {
            const common_name = subordinate.commonName();
            if (common_name.len != 0) {
                try ca.verifyNameConstraintName(.{ .tag = .dNSName, .value = common_name });
            }
            return;
        }

        const general_names = try der.Element.parse(subject_alt_name, 0);
        if (general_names.identifier.class != .universal or general_names.identifier.tag != .sequence)
            return error.CertificateFieldHasWrongDataType;

        var name_i = general_names.slice.start;
        while (name_i < general_names.slice.end) {
            const general_name = try der.Element.parse(subject_alt_name, name_i);
            name_i = general_name.slice.end;
            const name = try supportedGeneralName(subject_alt_name, general_name) orelse continue;
            try ca.verifyNameConstraintName(name);
        }
    }

    fn verifyNameConstraintSupport(ca: Parsed) NameConstraintError!void {
        const extension = ca.nameConstraints();
        const sequence = try der.Element.parse(extension, 0);
        if (sequence.identifier.class != .universal or sequence.identifier.tag != .sequence)
            return error.CertificateFieldHasWrongDataType;

        var field_i = sequence.slice.start;
        while (field_i < sequence.slice.end) {
            const field = try der.Element.parse(extension, field_i);
            field_i = field.slice.end;
            if (field.identifier.class != .context_specific) return error.CertificateFieldHasWrongDataType;
            switch (@intFromEnum(field.identifier.tag)) {
                0, 1 => {},
                else => return error.CertificateFieldHasWrongDataType,
            }

            const subtrees = try nameConstraintSubtrees(extension, field);
            var subtree_i = subtrees.start;
            while (subtree_i < subtrees.end) {
                const subtree = try der.Element.parse(extension, subtree_i);
                subtree_i = subtree.slice.end;
                _ = try parseGeneralSubtree(extension, subtree);
            }
        }
    }

    const PermittedConstraint = enum { none_seen, seen_unmatched, seen_matched };

    const ConstraintState = struct {
        permitted: PermittedConstraint = .none_seen,
    };

    fn verifyNameConstraintName(ca: Parsed, name: NameConstraintName) NameConstraintError!void {
        const extension = ca.nameConstraints();
        const sequence = try der.Element.parse(extension, 0);
        if (sequence.identifier.class != .universal or sequence.identifier.tag != .sequence)
            return error.CertificateFieldHasWrongDataType;

        var state: ConstraintState = .{};
        var field_i = sequence.slice.start;
        while (field_i < sequence.slice.end) {
            const field = try der.Element.parse(extension, field_i);
            field_i = field.slice.end;
            if (field.identifier.class != .context_specific) return error.CertificateFieldHasWrongDataType;

            switch (@intFromEnum(field.identifier.tag)) {
                0 => try ca.checkNameConstraintSubtrees(extension, field, name, .permitted, &state),
                1 => try ca.checkNameConstraintSubtrees(extension, field, name, .excluded, &state),
                else => return error.CertificateFieldHasWrongDataType,
            }
        }

        if (state.permitted == .seen_unmatched) return error.CertificateNameConstraintViolation;
    }

    const ConstraintKind = enum { permitted, excluded };

    fn checkNameConstraintSubtrees(
        ca: Parsed,
        extension: []const u8,
        field: der.Element,
        name: NameConstraintName,
        kind: ConstraintKind,
        state: *ConstraintState,
    ) NameConstraintError!void {
        const subtrees = try nameConstraintSubtrees(extension, field);
        var subtree_i = subtrees.start;
        while (subtree_i < subtrees.end) {
            const subtree = try der.Element.parse(extension, subtree_i);
            subtree_i = subtree.slice.end;
            const constraint = parseGeneralSubtree(extension, subtree) catch |err| switch (err) {
                error.CertificateNameConstraintUnsupported => {
                    if (ca.name_constraints_critical) return err;
                    continue;
                },
                else => |e| return e,
            };
            if (constraint.tag != name.tag) continue;

            const matches = try nameMatchesConstraint(name, constraint);
            switch (kind) {
                .permitted => if (matches) {
                    state.permitted = .seen_matched;
                } else if (state.permitted == .none_seen) {
                    state.permitted = .seen_unmatched;
                },
                .excluded => if (matches) return error.CertificateNameConstraintViolation,
            }
        }
    }

    fn nameConstraintSubtrees(_: []const u8, field: der.Element) NameConstraintError!der.Element.Slice {
        if (field.slice.start == field.slice.end) return error.CertificateFieldHasInvalidLength;
        return field.slice;
    }

    fn parseGeneralSubtree(extension: []const u8, subtree: der.Element) NameConstraintError!NameConstraintName {
        if (subtree.identifier.class != .universal or subtree.identifier.tag != .sequence)
            return error.CertificateFieldHasWrongDataType;
        const base = try der.Element.parse(extension, subtree.slice.start);
        var option_i = base.slice.end;
        while (option_i < subtree.slice.end) {
            const option = try der.Element.parse(extension, option_i);
            option_i = option.slice.end;
            if (option.identifier.class != .context_specific)
                return error.CertificateFieldHasWrongDataType;
            switch (@intFromEnum(option.identifier.tag)) {
                0 => if (!baseDistanceIsZero(extension[option.slice.start..option.slice.end]))
                    return error.CertificateNameConstraintUnsupported,
                1 => return error.CertificateNameConstraintUnsupported,
                else => return error.CertificateFieldHasWrongDataType,
            }
        }
        return (try supportedGeneralName(extension, base)) orelse error.CertificateNameConstraintUnsupported;
    }

    fn supportedGeneralName(bytes: []const u8, elem: der.Element) NameConstraintError!?NameConstraintName {
        if (elem.identifier.class != .context_specific) return error.CertificateFieldHasWrongDataType;
        const tag: GeneralNameTag = @enumFromInt(@intFromEnum(elem.identifier.tag));
        return switch (tag) {
            .rfc822Name,
            .dNSName,
            .uniformResourceIdentifier,
            .iPAddress,
            => .{ .tag = tag, .value = bytes[elem.slice.start..elem.slice.end] },
            else => null,
        };
    }

    fn nameMatchesConstraint(name: NameConstraintName, constraint: NameConstraintName) NameConstraintError!bool {
        return switch (name.tag) {
            .dNSName => dnsNameInSubtree(name.value, constraint.value),
            .rfc822Name => emailNameInSubtree(name.value, constraint.value),
            .uniformResourceIdentifier => uriNameInSubtree(name.value, constraint.value),
            .iPAddress => ipAddressInSubtree(name.value, constraint.value),
            else => false,
        };
    }

    fn dnsNameInSubtree(name_raw: []const u8, subtree_raw: []const u8) bool {
        const name = trimTrailingDot(name_raw);
        const subtree = trimTrailingDot(subtree_raw);
        if (name.len == 0 or subtree.len == 0) return false;

        if (subtree[0] == '.') return asciiEndsWithIgnoreCase(name, subtree);
        if (std.ascii.eqlIgnoreCase(name, subtree)) return true;
        return name.len > subtree.len and
            name[name.len - subtree.len - 1] == '.' and
            asciiEndsWithIgnoreCase(name, subtree);
    }

    fn emailNameInSubtree(name: []const u8, subtree: []const u8) bool {
        if (mem.indexOfScalar(u8, subtree, '@')) |subtree_at| {
            const name_at = mem.lastIndexOfScalar(u8, name, '@') orelse return false;
            return mem.eql(u8, name[0..name_at], subtree[0..subtree_at]) and
                std.ascii.eqlIgnoreCase(name[name_at + 1 ..], subtree[subtree_at + 1 ..]);
        }
        const at = mem.lastIndexOfScalar(u8, name, '@') orelse return false;
        return dnsNameInSubtree(name[at + 1 ..], subtree);
    }

    fn uriNameInSubtree(uri: []const u8, subtree: []const u8) bool {
        const scheme = mem.indexOf(u8, uri, "://") orelse return false;
        var authority = uri[scheme + 3 ..];
        if (mem.indexOfAny(u8, authority, "/?#")) |end| authority = authority[0..end];
        if (mem.indexOfScalar(u8, authority, '@')) |at| authority = authority[at + 1 ..];
        if (mem.indexOfScalar(u8, authority, ':')) |port| authority = authority[0..port];
        return dnsNameInSubtree(authority, subtree);
    }

    fn baseDistanceIsZero(distance: []const u8) bool {
        if (distance.len == 0) return false;
        for (distance) |byte| {
            if (byte != 0) return false;
        }
        return true;
    }

    fn ipAddressInSubtree(address: []const u8, subtree: []const u8) NameConstraintError!bool {
        const mask_start: usize = switch (subtree.len) {
            8 => 4,
            32 => 16,
            else => return error.CertificateFieldHasInvalidLength,
        };
        if (address.len != mask_start) return false;

        for (address, subtree[0..mask_start], subtree[mask_start..]) |addr, base, mask| {
            if ((addr & mask) != (base & mask)) return false;
        }
        return true;
    }

    fn trimTrailingDot(value: []const u8) []const u8 {
        if (value.len > 1 and value[value.len - 1] == '.') return value[0 .. value.len - 1];
        return value;
    }

    fn asciiEndsWithIgnoreCase(value: []const u8, suffix: []const u8) bool {
        if (value.len < suffix.len) return false;
        return std.ascii.eqlIgnoreCase(value[value.len - suffix.len ..], suffix);
    }

    /// RFC 5280 §4.2.1.3 — KeyUsage is a BIT STRING. Missing extension means
    /// no key-usage restriction; present extension must contain the requested bit.
    pub fn allowsKeyUsage(p: Parsed, bit_index: u4) ParseError!bool {
        const extension = p.keyUsage();
        if (extension.len == 0) return true;

        const bit_string_elem = try der.Element.parse(extension, 0);
        if (bit_string_elem.identifier.tag != .bitstring) return error.CertificateFieldHasWrongDataType;
        if (bit_string_elem.slice.start == bit_string_elem.slice.end) return error.CertificateHasInvalidBitString;

        const unused_bits = extension[bit_string_elem.slice.start];
        if (unused_bits > 7) return error.CertificateHasInvalidBitString;
        const bits: der.Element.Slice = .{ .start = bit_string_elem.slice.start + 1, .end = bit_string_elem.slice.end };
        const data_len = bits.end - bits.start;
        if (data_len == 0) {
            if (unused_bits != 0) return error.CertificateHasInvalidBitString;
            return false;
        }
        const bit_len = data_len * 8 - unused_bits;
        if (bit_index >= bit_len) return false;

        const byte_index: usize = bit_index / 8;
        const mask: u8 = @as(u8, 0x80) >> @intCast(bit_index % 8);
        return (extension[bits.start + byte_index] & mask) != 0;
    }

    /// RFC 5280 §4.2.1.12 — ExtendedKeyUsage is a sequence of OIDs. Missing
    /// extension means no EKU restriction; present extension must include OID.
    pub fn allowsExtKeyUsage(p: Parsed, oid: []const u8) ParseError!bool {
        const extension = p.extKeyUsage();
        if (extension.len == 0) return true;

        const sequence = try der.Element.parse(extension, 0);
        if (sequence.identifier.class != .universal or sequence.identifier.tag != .sequence)
            return error.CertificateFieldHasWrongDataType;
        if (sequence.slice.end != extension.len) return error.CertificateFieldHasInvalidLength;
        var oid_i = sequence.slice.start;
        while (oid_i < sequence.slice.end) {
            const oid_elem = try der.Element.parse(extension, oid_i);
            oid_i = oid_elem.slice.end;
            if (oid_elem.identifier.tag != .object_identifier) return error.CertificateFieldHasWrongDataType;
            if (mem.eql(u8, extension[oid_elem.slice.start..oid_elem.slice.end], oid)) return true;
        }
        return false;
    }

    pub const VerifyError = error{
        CertificateIssuerMismatch,
        CertificateNotYetValid,
        CertificateExpired,
        CertificateSignatureAlgorithmUnsupported,
        CertificateSignatureAlgorithmMismatch,
        CertificateFieldHasInvalidLength,
        CertificateFieldHasWrongDataType,
        CertificatePublicKeyInvalid,
        CertificateSignatureInvalidLength,
        CertificateSignatureInvalid,
        CertificateSignatureUnsupportedBitCount,
        CertificateSignatureNamedCurveUnsupported,
    };

    /// This function verifies:
    ///  * That the subject's issuer is indeed the provided issuer.
    ///  * The time validity of the subject.
    ///  * The signature.
    pub fn verify(parsed_subject: Parsed, parsed_issuer: Parsed, now_sec: i64) VerifyError!void {
        // Check that the subject's issuer name matches the issuer's
        // subject name.
        if (!mem.eql(u8, parsed_subject.issuer(), parsed_issuer.subject())) {
            return error.CertificateIssuerMismatch;
        }

        if (now_sec < parsed_subject.validity.not_before)
            return error.CertificateNotYetValid;
        if (now_sec > parsed_subject.validity.not_after)
            return error.CertificateExpired;

        switch (parsed_subject.signature_algorithm) {
            inline .sha1WithRSAEncryption,
            .sha224WithRSAEncryption,
            .sha256WithRSAEncryption,
            .sha384WithRSAEncryption,
            .sha512WithRSAEncryption,
            => |algorithm| return verifyRsa(
                algorithm.Hash(),
                parsed_subject.message(),
                parsed_subject.signature(),
                parsed_issuer.pub_key_algo,
                parsed_issuer.pubKey(),
            ),

            inline .ecdsa_with_SHA224,
            .ecdsa_with_SHA256,
            .ecdsa_with_SHA384,
            .ecdsa_with_SHA512,
            => |algorithm| return verify_ecdsa(
                algorithm.Hash(),
                parsed_subject.message(),
                parsed_subject.signature(),
                parsed_issuer.pub_key_algo,
                parsed_issuer.pubKey(),
            ),

            .md2WithRSAEncryption, .md5WithRSAEncryption => {
                return error.CertificateSignatureAlgorithmUnsupported;
            },

            .curveEd25519 => return verifyEd25519(
                parsed_subject.message(),
                parsed_subject.signature(),
                parsed_issuer.pub_key_algo,
                parsed_issuer.pubKey(),
            ),
        }
    }

    pub const VerifyHostNameError = error{
        CertificateHostMismatch,
        CertificateFieldHasInvalidLength,
    };

    pub fn verifyHostName(parsed_subject: Parsed, host_name: []const u8) VerifyHostNameError!void {
        // If the Subject Alternative Names extension is present, this is
        // what to check. Otherwise, only the common name is checked.
        const subject_alt_name = parsed_subject.subjectAltName();
        if (subject_alt_name.len == 0) {
            if (checkHostName(host_name, parsed_subject.commonName())) {
                return;
            } else {
                return error.CertificateHostMismatch;
            }
        }

        const general_names = try der.Element.parse(subject_alt_name, 0);
        var name_i = general_names.slice.start;
        while (name_i < general_names.slice.end) {
            const general_name = try der.Element.parse(subject_alt_name, name_i);
            name_i = general_name.slice.end;
            if (general_name.identifier.class == .context_specific) {
                switch (@as(GeneralNameTag, @enumFromInt(@intFromEnum(general_name.identifier.tag)))) {
                    .dNSName => {
                        const dns_name = subject_alt_name[general_name.slice.start..general_name.slice.end];
                        if (checkHostName(host_name, dns_name)) return;
                    },
                    else => {},
                }
            }
        }

        return error.CertificateHostMismatch;
    }

    // Check hostname according to RFC2818 specification:
    //
    // If more than one identity of a given type is present in
    // the certificate (e.g., more than one DNSName name, a match in any one
    // of the set is considered acceptable.) Names may contain the wildcard
    // character * which is considered to match any single domain name
    // component or component fragment. E.g., *.a.com matches foo.a.com but
    // not bar.foo.a.com. f*.com matches foo.com but not bar.com.
    fn checkHostName(host_name: []const u8, dns_name: []const u8) bool {
        // Empty strings should not match
        if (host_name.len == 0 or dns_name.len == 0) return false;

        // RFC 6125 Section 6.4.1: Exact match (case-insensitive)
        if (std.ascii.eqlIgnoreCase(dns_name, host_name)) {
            return true; // exact match
        }

        // RFC 6125 Section 6.4.3: Wildcard certificates
        // Wildcard must be leftmost label and in the form "*.rest.of.domain"
        if (dns_name.len >= 3 and mem.startsWith(u8, dns_name, "*.")) {
            const wildcard_suffix = dns_name[2..];

            // No additional wildcards allowed in the suffix
            if (mem.indexOf(u8, wildcard_suffix, "*") != null) return false;

            // Find the first dot in hostname to split first label from rest
            const dot_pos = mem.indexOf(u8, host_name, ".") orelse return false;

            // Wildcard matches exactly one label, so compare the rest
            const host_suffix = host_name[dot_pos + 1 ..];

            // Match suffixes (case-insensitive per RFC 6125)
            return std.ascii.eqlIgnoreCase(wildcard_suffix, host_suffix);
        }

        return false;
    }
};

// RFC 5280 §4.2.1.6 — dNSName is the context-specific [2] GeneralName,
// not a universal tag with the same tag number.
test "Parsed.verifyHostName rejects universal tag 2 as dNSName" {
    const san = "\x30\x0c\x02\x0avictim.com";
    const parsed = parsedForNameConstraintsTest(
        san,
        .empty,
        .{ .start = 0, .end = san.len },
        .empty,
        false,
    );

    try std.testing.expectError(error.CertificateHostMismatch, parsed.verifyHostName("victim.com"));
}

test "Parsed.checkHostName RFC 6125 compliance" {
    const expectEqual = std.testing.expectEqual;

    // Exact match tests
    try expectEqual(true, Parsed.checkHostName("ziglang.org", "ziglang.org"));
    try expectEqual(true, Parsed.checkHostName("ziglang.org", "Ziglang.org")); // case insensitive
    try expectEqual(true, Parsed.checkHostName("ZIGLANG.ORG", "ziglang.org")); // case insensitive

    // Valid wildcard matches
    try expectEqual(true, Parsed.checkHostName("bar.ziglang.org", "*.ziglang.org"));
    try expectEqual(true, Parsed.checkHostName("BAR.ziglang.org", "*.Ziglang.ORG")); // case insensitive

    // RFC 6125: Wildcard matches exactly one label
    try expectEqual(false, Parsed.checkHostName("foo.bar.ziglang.org", "*.ziglang.org"));
    try expectEqual(false, Parsed.checkHostName("ziglang.org", "*.ziglang.org")); // no empty match

    // RFC 6125: No partial wildcards allowed
    try expectEqual(false, Parsed.checkHostName("ziglang.org", "zig*.org"));
    try expectEqual(false, Parsed.checkHostName("ziglang.org", "*lang.org"));
    try expectEqual(false, Parsed.checkHostName("ziglang.org", "zi*ng.org"));

    // RFC 6125: No multiple wildcards
    try expectEqual(false, Parsed.checkHostName("foo.bar.org", "*.*.org"));

    // RFC 6125: Wildcard must be in leftmost label
    try expectEqual(false, Parsed.checkHostName("foo.bar.org", "foo.*.org"));

    // Single label hostnames should not match wildcards
    try expectEqual(false, Parsed.checkHostName("localhost", "*.local"));
    try expectEqual(false, Parsed.checkHostName("localhost", "*.localhost"));

    // Edge cases
    try expectEqual(false, Parsed.checkHostName("", ""));
    try expectEqual(false, Parsed.checkHostName("example.com", ""));
    try expectEqual(false, Parsed.checkHostName("", "*.example.com"));
    try expectEqual(false, Parsed.checkHostName("example.com", "*"));
    try expectEqual(false, Parsed.checkHostName("example.com", "*."));
}

// RFC 5280 §4.2.1.3 — KeyUsage.digitalSignature is bit 0 in the BIT STRING.
test "Parsed.allowsKeyUsage reads digitalSignature" {
    const parsed: Parsed = .{
        .certificate = .{ .buffer = "\x03\x02\x07\x80", .index = 0 },
        .issuer_slice = .empty,
        .subject_slice = .empty,
        .common_name_slice = .empty,
        .signature_slice = .empty,
        .signature_algorithm = .ecdsa_with_SHA256,
        .pub_key_algo = .{ .curveEd25519 = {} },
        .pub_key_slice = .empty,
        .message_slice = .empty,
        .subject_alt_name_slice = .empty,
        .key_usage_slice = .{ .start = 0, .end = 4 },
        .ext_key_usage_slice = .empty,
        .name_constraints_slice = .empty,
        .name_constraints_critical = false,
        .validity = .{ .not_before = 0, .not_after = 0 },
        .version = .v3,
    };

    try std.testing.expect(try parsed.allowsKeyUsage(0));
    try std.testing.expect(!try parsed.allowsKeyUsage(1));
}

// RFC 5280 §4.2.1.3 — a BIT STRING with only the unused-bits octet and a
// non-zero unused-bits count is malformed and must not underflow bit length.
test "Parsed.allowsKeyUsage rejects malformed empty bit payload" {
    const parsed: Parsed = .{
        .certificate = .{ .buffer = "\x03\x01\x05", .index = 0 },
        .issuer_slice = .empty,
        .subject_slice = .empty,
        .common_name_slice = .empty,
        .signature_slice = .empty,
        .signature_algorithm = .ecdsa_with_SHA256,
        .pub_key_algo = .{ .curveEd25519 = {} },
        .pub_key_slice = .empty,
        .message_slice = .empty,
        .subject_alt_name_slice = .empty,
        .key_usage_slice = .{ .start = 0, .end = 3 },
        .ext_key_usage_slice = .empty,
        .name_constraints_slice = .empty,
        .name_constraints_critical = false,
        .validity = .{ .not_before = 0, .not_after = 0 },
        .version = .v3,
    };

    try std.testing.expectError(error.CertificateHasInvalidBitString, parsed.allowsKeyUsage(0));
}

// RFC 5280 §4.2.1.12 — ExtendedKeyUsage contains id-kp-serverAuth as an OID.
test "Parsed.allowsExtKeyUsage finds serverAuth" {
    const server_auth_oid = [_]u8{ 0x2b, 0x06, 0x01, 0x05, 0x05, 0x07, 0x03, 0x01 };
    const parsed: Parsed = .{
        .certificate = .{ .buffer = "\x30\x0a\x06\x08\x2b\x06\x01\x05\x05\x07\x03\x01", .index = 0 },
        .issuer_slice = .empty,
        .subject_slice = .empty,
        .common_name_slice = .empty,
        .signature_slice = .empty,
        .signature_algorithm = .ecdsa_with_SHA256,
        .pub_key_algo = .{ .curveEd25519 = {} },
        .pub_key_slice = .empty,
        .message_slice = .empty,
        .subject_alt_name_slice = .empty,
        .key_usage_slice = .empty,
        .ext_key_usage_slice = .{ .start = 0, .end = 12 },
        .name_constraints_slice = .empty,
        .name_constraints_critical = false,
        .validity = .{ .not_before = 0, .not_after = 0 },
        .version = .v3,
    };

    try std.testing.expect(try parsed.allowsExtKeyUsage(&server_auth_oid));
    try std.testing.expect(!try parsed.allowsExtKeyUsage(&.{ 0x2b, 0x06, 0x01, 0x05, 0x05, 0x07, 0x03, 0x02 }));
}

// RFC 5280 §4.2.1.12 — ExtKeyUsageSyntax is a SEQUENCE OF KeyPurposeId.
test "Parsed.allowsExtKeyUsage rejects non-SEQUENCE wrapper" {
    const malformed_eku = "\x04\x0a\x06\x08\x2b\x06\x01\x05\x05\x07\x03\x01";
    const parsed: Parsed = .{
        .certificate = .{ .buffer = malformed_eku, .index = 0 },
        .issuer_slice = .empty,
        .subject_slice = .empty,
        .common_name_slice = .empty,
        .signature_slice = .empty,
        .signature_algorithm = .ecdsa_with_SHA256,
        .pub_key_algo = .{ .curveEd25519 = {} },
        .pub_key_slice = .empty,
        .message_slice = .empty,
        .subject_alt_name_slice = .empty,
        .key_usage_slice = .empty,
        .ext_key_usage_slice = .{ .start = 0, .end = malformed_eku.len },
        .name_constraints_slice = .empty,
        .name_constraints_critical = false,
        .validity = .{ .not_before = 0, .not_after = 0 },
        .version = .v3,
    };

    try std.testing.expectError(
        error.CertificateFieldHasWrongDataType,
        parsed.allowsExtKeyUsage("\x2b\x06\x01\x05\x05\x07\x03\x01"),
    );
}

// RFC 5280 §4.2.1.10 — Name Constraints extension value can be extracted from
// a Parsed certificate structure.
test "Parsed.nameConstraints extracts extension value" {
    const nc_value = "\x30\x11\xA0\x0F\x30\x0D\x82\x0Bexample.com";
    const parsed: Parsed = .{
        .certificate = .{ .buffer = nc_value, .index = 0 },
        .issuer_slice = .empty,
        .subject_slice = .empty,
        .common_name_slice = .empty,
        .signature_slice = .empty,
        .signature_algorithm = .ecdsa_with_SHA256,
        .pub_key_algo = .{ .curveEd25519 = {} },
        .pub_key_slice = .empty,
        .message_slice = .empty,
        .subject_alt_name_slice = .empty,
        .key_usage_slice = .empty,
        .ext_key_usage_slice = .empty,
        .name_constraints_slice = .{ .start = 0, .end = nc_value.len },
        .name_constraints_critical = false,
        .validity = .{ .not_before = 0, .not_after = 0 },
        .version = .v3,
    };

    try std.testing.expectEqualSlices(u8, nc_value, parsed.nameConstraints());
}

// RFC 5280 §4.2.1.10 — absent Name Constraints returns empty slice.
test "Parsed.nameConstraints absent returns empty" {
    const parsed = parsedForNameConstraintsTest("", .empty, .empty, .empty, false);
    try std.testing.expectEqual(@as(usize, 0), parsed.nameConstraints().len);
}

fn parsedForNameConstraintsTest(
    buffer: []const u8,
    name_constraints: Parsed.Slice,
    subject_alt_name: Parsed.Slice,
    common_name: Parsed.Slice,
    critical: bool,
) Parsed {
    return .{
        .certificate = .{ .buffer = buffer, .index = 0 },
        .issuer_slice = .empty,
        .subject_slice = .empty,
        .common_name_slice = common_name,
        .signature_slice = .empty,
        .signature_algorithm = .ecdsa_with_SHA256,
        .pub_key_algo = .{ .curveEd25519 = {} },
        .pub_key_slice = .empty,
        .message_slice = .empty,
        .subject_alt_name_slice = subject_alt_name,
        .key_usage_slice = .empty,
        .ext_key_usage_slice = .empty,
        .name_constraints_slice = name_constraints,
        .name_constraints_critical = critical,
        .validity = .{ .not_before = 0, .not_after = 0 },
        .version = .v3,
    };
}

// RFC 5280 §4.2.1.10 — permitted dNSName subtrees constrain subordinate DNS SANs.
test "Parsed.verifyNameConstraints: DNS permitted subtree" {
    const constraints = "\x30\x11\xA0\x0F\x30\x0D\x82\x0Bexample.com";
    const san = "\x30\x10\x82\x0Eok.example.com";
    const ca = parsedForNameConstraintsTest(
        constraints,
        .{ .start = 0, .end = constraints.len },
        .empty,
        .empty,
        true,
    );
    const leaf = parsedForNameConstraintsTest(
        san,
        .empty,
        .{ .start = 0, .end = san.len },
        .empty,
        false,
    );
    try ca.verifyNameConstraints(leaf);
}

// RFC 5280 §4.2.1.10 — a subordinate outside a permitted dNSName subtree fails.
test "Parsed.verifyNameConstraints: DNS permitted subtree mismatch" {
    const constraints = "\x30\x11\xA0\x0F\x30\x0D\x82\x0Bexample.com";
    const san = "\x30\x0E\x82\x0Coutside.test";
    const ca = parsedForNameConstraintsTest(
        constraints,
        .{ .start = 0, .end = constraints.len },
        .empty,
        .empty,
        true,
    );
    const leaf = parsedForNameConstraintsTest(
        san,
        .empty,
        .{ .start = 0, .end = san.len },
        .empty,
        false,
    );
    try std.testing.expectError(error.CertificateNameConstraintViolation, ca.verifyNameConstraints(leaf));
}

// RFC 5280 §4.2.1.10 — excluded dNSName subtrees override otherwise valid names.
test "Parsed.verifyNameConstraints: DNS excluded subtree" {
    const constraints = "\x30\x15\xA1\x13\x30\x11\x82\x0Fbad.example.com";
    const san = "\x30\x11\x82\x0Fbad.example.com";
    const ca = parsedForNameConstraintsTest(
        constraints,
        .{ .start = 0, .end = constraints.len },
        .empty,
        .empty,
        true,
    );
    const leaf = parsedForNameConstraintsTest(
        san,
        .empty,
        .{ .start = 0, .end = san.len },
        .empty,
        false,
    );
    try std.testing.expectError(error.CertificateNameConstraintViolation, ca.verifyNameConstraints(leaf));
}

// RFC 5280 §6.1.4 — every supported SAN value is checked, not just the name
// that matched the caller's hostname policy.
test "Parsed.verifyNameConstraints: mixed DNS SAN violation is rejected" {
    const constraints = "\x30\x15\xA1\x13\x30\x11\x82\x0Fbad.example.com";
    const san = "\x30\x21\x82\x0Eok.example.com\x82\x0Fbad.example.com";
    const ca = parsedForNameConstraintsTest(
        constraints,
        .{ .start = 0, .end = constraints.len },
        .empty,
        .empty,
        true,
    );
    const leaf = parsedForNameConstraintsTest(
        san,
        .empty,
        .{ .start = 0, .end = san.len },
        .empty,
        false,
    );
    try std.testing.expectError(error.CertificateNameConstraintViolation, ca.verifyNameConstraints(leaf));
}

// RFC 5280 §4.2.1.10 — when subjectAltName is absent, ztls applies DNS
// constraints to the Common Name used by its TLS hostname fallback.
test "Parsed.verifyNameConstraints: DNS common name fallback" {
    const constraints = "\x30\x11\xA0\x0F\x30\x0D\x82\x0Bexample.com";
    const common_name = "ok.example.com";
    const ca = parsedForNameConstraintsTest(
        constraints,
        .{ .start = 0, .end = constraints.len },
        .empty,
        .empty,
        true,
    );
    const leaf = parsedForNameConstraintsTest(
        common_name,
        .empty,
        .empty,
        .{ .start = 0, .end = common_name.len },
        false,
    );
    try ca.verifyNameConstraints(leaf);
}

// RFC 5280 §4.2.1.10 — iPAddress constraints are address-and-mask subtrees.
test "Parsed.verifyNameConstraints: IP permitted subnet" {
    const constraints = "\x30\x0E\xA0\x0C\x30\x0A\x87\x08\x7F\x00\x00\x00\xFF\xFF\xFF\x00";
    const san = "\x30\x06\x87\x04\x7F\x00\x00\x01";
    const ca = parsedForNameConstraintsTest(
        constraints,
        .{ .start = 0, .end = constraints.len },
        .empty,
        .empty,
        true,
    );
    const leaf = parsedForNameConstraintsTest(
        san,
        .empty,
        .{ .start = 0, .end = san.len },
        .empty,
        false,
    );
    try ca.verifyNameConstraints(leaf);
}

// RFC 5280 §6.1.4 — permitted subtrees are maintained per name type; an IP
// permitted subtree does not constrain a subordinate's DNS names.
test "Parsed.verifyNameConstraints: permitted subtrees are type-specific" {
    const constraints = "\x30\x0E\xA0\x0C\x30\x0A\x87\x08\x7F\x00\x00\x00\xFF\xFF\xFF\x00";
    const san = "\x30\x0E\x82\x0Coutside.test";
    const ca = parsedForNameConstraintsTest(
        constraints,
        .{ .start = 0, .end = constraints.len },
        .empty,
        .empty,
        true,
    );
    const leaf = parsedForNameConstraintsTest(
        san,
        .empty,
        .{ .start = 0, .end = san.len },
        .empty,
        false,
    );
    try ca.verifyNameConstraints(leaf);
}

// RFC 5280 §4.2.1.10 — rfc822Name constraints match the mailbox domain.
test "Parsed.verifyNameConstraints: email permitted subtree" {
    const constraints = "\x30\x11\xA0\x0F\x30\x0D\x81\x0Bexample.com";
    const san = "\x30\x12\x81\x10user@example.com";
    const ca = parsedForNameConstraintsTest(
        constraints,
        .{ .start = 0, .end = constraints.len },
        .empty,
        .empty,
        true,
    );
    const leaf = parsedForNameConstraintsTest(
        san,
        .empty,
        .{ .start = 0, .end = san.len },
        .empty,
        false,
    );
    try ca.verifyNameConstraints(leaf);
}

// RFC 5280 §4.2.1.10 — an rfc822Name constraint with a mailbox compares the
// local part exactly and the domain case-insensitively.
test "Parsed.verifyNameConstraints: email mailbox local part is case-sensitive" {
    const constraints = "\x30\x12\xA0\x10\x30\x0E\x81\x0CUser@EXAMPLE";
    const san = "\x30\x0E\x81\x0Cuser@example";
    const ca = parsedForNameConstraintsTest(
        constraints,
        .{ .start = 0, .end = constraints.len },
        .empty,
        .empty,
        true,
    );
    const leaf = parsedForNameConstraintsTest(
        san,
        .empty,
        .{ .start = 0, .end = san.len },
        .empty,
        false,
    );
    try std.testing.expectError(error.CertificateNameConstraintViolation, ca.verifyNameConstraints(leaf));
}

// RFC 5280 §4.2.1.10 — URI constraints apply to the host portion.
test "Parsed.verifyNameConstraints: URI excluded subtree" {
    const constraints = "\x30\x15\xA1\x13\x30\x11\x86\x0Fbad.example.com";
    const san = "\x30\x1B\x86\x19https://bad.example.com/a";
    const ca = parsedForNameConstraintsTest(
        constraints,
        .{ .start = 0, .end = constraints.len },
        .empty,
        .empty,
        true,
    );
    const leaf = parsedForNameConstraintsTest(
        san,
        .empty,
        .{ .start = 0, .end = san.len },
        .empty,
        false,
    );
    try std.testing.expectError(error.CertificateNameConstraintViolation, ca.verifyNameConstraints(leaf));
}

// RFC 5280 §4.2.1.10 / RFC 3986 §3.2 — URI constraints use the authority host,
// not userinfo, when matching the URI GeneralName form.
test "Parsed.verifyNameConstraints: URI strips userinfo before host matching" {
    const constraints = "\x30\x15\xA1\x13\x30\x11\x86\x0Fbad.example.com";
    const san = "\x30\x25\x86\x23https://user:pass@bad.example.com/a";
    const ca = parsedForNameConstraintsTest(
        constraints,
        .{ .start = 0, .end = constraints.len },
        .empty,
        .empty,
        true,
    );
    const leaf = parsedForNameConstraintsTest(
        san,
        .empty,
        .{ .start = 0, .end = san.len },
        .empty,
        false,
    );
    try std.testing.expectError(error.CertificateNameConstraintViolation, ca.verifyNameConstraints(leaf));
}

// RFC 5280 §4.2.1.10 — an explicitly encoded minimum of zero is equivalent to
// the DEFAULT value and must not make a supported GeneralSubtree unsupported.
test "Parsed.verifyNameConstraints: explicit minimum zero is accepted" {
    const constraints = "\x30\x14\xA0\x12\x30\x10\x82\x0Bexample.com\x80\x01\x00";
    const san = "\x30\x10\x82\x0Eok.example.com";
    const ca = parsedForNameConstraintsTest(
        constraints,
        .{ .start = 0, .end = constraints.len },
        .empty,
        .empty,
        true,
    );
    const leaf = parsedForNameConstraintsTest(
        san,
        .empty,
        .{ .start = 0, .end = san.len },
        .empty,
        false,
    );
    try ca.verifyNameConstraints(leaf);
}

// RFC 5280 §4.2.1.10 — critical Name Constraints must be processed; unsupported
// critical GeneralName forms are rejected instead of silently ignored.
test "Parsed.verifyNameConstraints: critical unsupported subtree is rejected" {
    const constraints = "\x30\x08\xA0\x06\x30\x04\xA4\x02\x30\x00";
    const san = "\x30\x10\x82\x0Eok.example.com";
    const ca = parsedForNameConstraintsTest(
        constraints,
        .{ .start = 0, .end = constraints.len },
        .empty,
        .empty,
        true,
    );
    const leaf = parsedForNameConstraintsTest(
        san,
        .empty,
        .{ .start = 0, .end = san.len },
        .empty,
        false,
    );
    try std.testing.expectError(error.CertificateNameConstraintUnsupported, ca.verifyNameConstraints(leaf));
}

// RFC 5280 §4.2 — non-critical unsupported extensions are outside the relying
// party's required processing set; supported constraints are still enforced.
test "Parsed.verifyNameConstraints: non-critical unsupported subtree is ignored" {
    const constraints = "\x30\x08\xA0\x06\x30\x04\xA4\x02\x30\x00";
    const san = "\x30\x10\x82\x0Eok.example.com";
    const ca = parsedForNameConstraintsTest(
        constraints,
        .{ .start = 0, .end = constraints.len },
        .empty,
        .empty,
        false,
    );
    const leaf = parsedForNameConstraintsTest(
        san,
        .empty,
        .{ .start = 0, .end = san.len },
        .empty,
        false,
    );
    try ca.verifyNameConstraints(leaf);
}

pub const ParseError = der.Element.ParseError || ParseVersionError || ParseTimeError || ParseEnumError ||
    ParseBitStringError || error{
    CertificateUnsupportedCriticalExtension,
    CertificateHasDuplicateExtension,
};

pub fn parse(cert: Certificate) ParseError!Parsed {
    const cert_bytes = cert.buffer;
    const certificate = try der.Element.parse(cert_bytes, cert.index);
    const tbs_certificate = try der.Element.parse(cert_bytes, certificate.slice.start);
    const version_elem = try der.Element.parse(cert_bytes, tbs_certificate.slice.start);
    const version = try parseVersion(cert_bytes, version_elem);
    const serial_number = if (@as(u8, @bitCast(version_elem.identifier)) == 0xa0)
        try der.Element.parse(cert_bytes, version_elem.slice.end)
    else
        version_elem;
    // RFC 5280, section 4.1.2.3:
    // "This field MUST contain the same algorithm identifier as
    // the signatureAlgorithm field in the sequence Certificate."
    const tbs_signature = try der.Element.parse(cert_bytes, serial_number.slice.end);
    const issuer = try der.Element.parse(cert_bytes, tbs_signature.slice.end);
    const validity = try der.Element.parse(cert_bytes, issuer.slice.end);
    const not_before = try der.Element.parse(cert_bytes, validity.slice.start);
    const not_before_utc = try parseTime(cert, not_before);
    const not_after = try der.Element.parse(cert_bytes, not_before.slice.end);
    const not_after_utc = try parseTime(cert, not_after);
    const subject = try der.Element.parse(cert_bytes, validity.slice.end);

    const pub_key_info = try der.Element.parse(cert_bytes, subject.slice.end);
    const pub_key_signature_algorithm = try der.Element.parse(cert_bytes, pub_key_info.slice.start);
    const pub_key_algo_elem = try der.Element.parse(cert_bytes, pub_key_signature_algorithm.slice.start);
    const pub_key_algo: Parsed.PubKeyAlgo = switch (try parseAlgorithmCategory(cert_bytes, pub_key_algo_elem)) {
        inline else => |tag| @unionInit(Parsed.PubKeyAlgo, @tagName(tag), {}),
        .X9_62_id_ecPublicKey => pub_key_algo: {
            // RFC 5480 Section 2.1.1.1 Named Curve
            // ECParameters ::= CHOICE {
            //   namedCurve         OBJECT IDENTIFIER
            //   -- implicitCurve   NULL
            //   -- specifiedCurve  SpecifiedECDomain
            // }
            const params_elem = try der.Element.parse(cert_bytes, pub_key_algo_elem.slice.end);
            const named_curve = try parseNamedCurve(cert_bytes, params_elem);
            break :pub_key_algo .{ .X9_62_id_ecPublicKey = named_curve };
        },
    };
    const pub_key_elem = try der.Element.parse(cert_bytes, pub_key_signature_algorithm.slice.end);
    const pub_key = try parseBitString(cert, pub_key_elem);

    var common_name = der.Element.Slice.empty;
    var name_i = subject.slice.start;
    while (name_i < subject.slice.end) {
        const rdn = try der.Element.parse(cert_bytes, name_i);
        var rdn_i = rdn.slice.start;
        while (rdn_i < rdn.slice.end) {
            const atav = try der.Element.parse(cert_bytes, rdn_i);
            var atav_i = atav.slice.start;
            while (atav_i < atav.slice.end) {
                const ty_elem = try der.Element.parse(cert_bytes, atav_i);
                const val = try der.Element.parse(cert_bytes, ty_elem.slice.end);
                atav_i = val.slice.end;
                const ty = parseAttribute(cert_bytes, ty_elem) catch |err| switch (err) {
                    error.CertificateHasUnrecognizedObjectId => continue,
                    else => |e| return e,
                };
                switch (ty) {
                    .commonName => common_name = val.slice,
                    else => {},
                }
            }
            rdn_i = atav.slice.end;
        }
        name_i = rdn.slice.end;
    }

    const sig_algo = try der.Element.parse(cert_bytes, tbs_certificate.slice.end);
    const algo_elem = try der.Element.parse(cert_bytes, sig_algo.slice.start);
    const signature_algorithm = try parseAlgorithm(cert_bytes, algo_elem);
    const sig_elem = try der.Element.parse(cert_bytes, sig_algo.slice.end);
    const signature = try parseBitString(cert, sig_elem);

    // Extensions
    var subject_alt_name_slice = der.Element.Slice.empty;
    var key_usage_slice = der.Element.Slice.empty;
    var ext_key_usage_slice = der.Element.Slice.empty;
    var name_constraints_slice = der.Element.Slice.empty;
    var name_constraints_critical = false;
    var is_ca = false;
    var basic_constraints_path_len: ?u8 = null;
    ext: {
        if (version == .v1)
            break :ext;

        if (pub_key_info.slice.end >= tbs_certificate.slice.end)
            break :ext;

        const outer_extensions = try der.Element.parse(cert_bytes, pub_key_info.slice.end);
        if (outer_extensions.identifier.tag != .bitstring)
            break :ext;

        const extensions = try der.Element.parse(cert_bytes, outer_extensions.slice.start);

        // Only processed extensions can overwrite parsed policy state. Recognition
        // is semantic for these five: obsolete X.509v1 and modern PKIX OID forms
        // map to the same ID and intentionally count as duplicates.
        var seen_extensions: std.EnumSet(ExtensionId) = .initEmpty();
        var ext_i = extensions.slice.start;
        while (ext_i < extensions.slice.end) {
            const extension = try der.Element.parse(cert_bytes, ext_i);
            ext_i = extension.slice.end;
            const oid_elem = try der.Element.parse(cert_bytes, extension.slice.start);
            const critical_elem = try der.Element.parse(cert_bytes, oid_elem.slice.end);
            const extension_critical = critical_elem.identifier.tag == .boolean;
            if (extension_critical and critical_elem.slice.end - critical_elem.slice.start != 1)
                return error.CertificateFieldHasWrongDataType;
            const is_critical = extension_critical and cert_bytes[critical_elem.slice.start] != 0;
            const ext_id = parseExtensionId(cert_bytes, oid_elem) catch |err| switch (err) {
                error.CertificateHasUnrecognizedObjectId => {
                    if (is_critical) return error.CertificateUnsupportedCriticalExtension;
                    continue;
                },
                else => |e| return e,
            };
            switch (ext_id) {
                .subject_alt_name,
                .key_usage,
                .ext_key_usage,
                .basic_constraints,
                .name_constraints,
                => {
                    if (seen_extensions.contains(ext_id)) return error.CertificateHasDuplicateExtension;
                    seen_extensions.insert(ext_id);
                },
                else => {},
            }
            const ext_bytes_elem = if (!extension_critical)
                critical_elem
            else
                try der.Element.parse(cert_bytes, critical_elem.slice.end);
            switch (ext_id) {
                .subject_alt_name => subject_alt_name_slice = ext_bytes_elem.slice,
                .key_usage => key_usage_slice = ext_bytes_elem.slice,
                .ext_key_usage => ext_key_usage_slice = ext_bytes_elem.slice,
                .basic_constraints => {
                    const basic_constraints = try parseBasicConstraints(cert_bytes, ext_bytes_elem.slice);
                    is_ca = basic_constraints.is_ca;
                    basic_constraints_path_len = basic_constraints.path_len;
                },
                .name_constraints => {
                    name_constraints_slice = ext_bytes_elem.slice;
                    name_constraints_critical = is_critical;
                },
                else => continue,
            }
        }
    }

    return .{
        .certificate = cert,
        .common_name_slice = common_name,
        .issuer_slice = issuer.slice,
        .subject_slice = subject.slice,
        .signature_slice = signature,
        .signature_algorithm = signature_algorithm,
        .message_slice = .{ .start = certificate.slice.start, .end = tbs_certificate.slice.end },
        .pub_key_algo = pub_key_algo,
        .pub_key_slice = pub_key,
        .validity = .{
            .not_before = not_before_utc,
            .not_after = not_after_utc,
        },
        .subject_alt_name_slice = subject_alt_name_slice,
        .key_usage_slice = key_usage_slice,
        .ext_key_usage_slice = ext_key_usage_slice,
        .name_constraints_slice = name_constraints_slice,
        .name_constraints_critical = name_constraints_critical,
        .is_ca = is_ca,
        .basic_constraints_path_len = basic_constraints_path_len,
        .version = version,
    };
}

const BasicConstraints = struct {
    is_ca: bool = false,
    path_len: ?u8 = null,
};

fn parseBasicConstraints(bytes: []const u8, extension_slice: der.Element.Slice) ParseError!BasicConstraints {
    const sequence = try der.Element.parse(bytes, extension_slice.start);
    if (sequence.identifier.tag != .sequence) return error.CertificateFieldHasWrongDataType;
    if (sequence.slice.end != extension_slice.end) return error.CertificateFieldHasInvalidLength;

    var result: BasicConstraints = .{};
    var field_index = sequence.slice.start;
    if (field_index < sequence.slice.end) {
        const ca = try der.Element.parse(bytes, field_index);
        if (ca.identifier.tag == .boolean) {
            if (ca.slice.end - ca.slice.start != 1) return error.CertificateFieldHasInvalidLength;
            result.is_ca = bytes[ca.slice.start] != 0;
            field_index = ca.slice.end;
        }
    }
    if (field_index < sequence.slice.end) {
        const path_len = try der.Element.parse(bytes, field_index);
        if (path_len.identifier.tag != .integer) return error.CertificateFieldHasWrongDataType;
        const encoded = bytes[path_len.slice.start..path_len.slice.end];
        if (encoded.len == 0 or encoded.len > 2) return error.CertificateFieldHasInvalidLength;
        if (encoded[0] & 0x80 != 0) return error.CertificateFieldHasWrongDataType;
        var value: u16 = 0;
        for (encoded) |byte| value = (value << 8) | byte;
        if (value > std.math.maxInt(u8)) return error.CertificateFieldHasInvalidLength;
        result.path_len = @intCast(value);
        field_index = path_len.slice.end;
    }
    if (field_index != sequence.slice.end) return error.CertificateFieldHasInvalidLength;
    if (result.path_len != null and result.is_ca == false) return error.CertificateFieldHasInvalidLength;
    return result;
}

// RFC 5280 §4.2.1.9 — pathLenConstraint requires cA to be asserted.
test "parseBasicConstraints rejects pathLenConstraint without cA" {
    const encoded = "\x30\x03\x02\x01\x00";
    const extension_slice: der.Element.Slice = .{ .start = 0, .end = encoded.len };

    try std.testing.expectError(
        error.CertificateFieldHasInvalidLength,
        parseBasicConstraints(encoded, extension_slice),
    );
}

// RFC 5280 §4.2 — an unrecognized critical extension must cause rejection.
test "parse rejects unknown critical extension" {
    const cert_der = &[_]u8{
        0x30, 0x81, 0x80, 0x30, 0x6b, 0xa0, 0x03, 0x02, 0x01, 0x02, 0x02, 0x01,
        0x01, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01,
        0x01, 0x0b, 0x05, 0x00, 0x30, 0x00, 0x30, 0x22, 0x18, 0x0f, 0x32, 0x30,
        0x32, 0x36, 0x30, 0x31, 0x30, 0x31, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30,
        0x5a, 0x18, 0x0f, 0x32, 0x30, 0x33, 0x30, 0x30, 0x31, 0x30, 0x31, 0x30,
        0x30, 0x30, 0x30, 0x30, 0x30, 0x5a, 0x30, 0x00, 0x30, 0x1a, 0x30, 0x0d,
        0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05,
        0x00, 0x03, 0x09, 0x00, 0x30, 0x06, 0x02, 0x01, 0x01, 0x02, 0x01, 0x03,
        0xa3, 0x0e, 0x30, 0x0c, 0x30, 0x0a, 0x06, 0x03, 0x2a, 0x03, 0x04, 0x01,
        0x01, 0xff, 0x04, 0x00, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
        0xf7, 0x0d, 0x01, 0x01, 0x0b, 0x05, 0x00, 0x03, 0x02, 0x00, 0x00,
    };
    const cert: Certificate = .{ .buffer = cert_der, .index = 0 };

    try std.testing.expectError(error.CertificateUnsupportedCriticalExtension, cert.parse());
}

// RFC 5280 §4.2 — a certificate must not contain duplicate extension OIDs.
test "parse rejects duplicate recognized extensions" {
    const cert_der = &[_]u8{
        0x30, 0x81, 0x8a, 0x30, 0x75, 0xa0, 0x03, 0x02, 0x01, 0x02, 0x02, 0x01,
        0x01, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01,
        0x01, 0x0b, 0x05, 0x00, 0x30, 0x00, 0x30, 0x22, 0x18, 0x0f, 0x32, 0x30,
        0x32, 0x36, 0x30, 0x31, 0x30, 0x31, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30,
        0x5a, 0x18, 0x0f, 0x32, 0x30, 0x33, 0x30, 0x30, 0x31, 0x30, 0x31, 0x30,
        0x30, 0x30, 0x30, 0x30, 0x30, 0x5a, 0x30, 0x00, 0x30, 0x1a, 0x30, 0x0d,
        0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05,
        0x00, 0x03, 0x09, 0x00, 0x30, 0x06, 0x02, 0x01, 0x01, 0x02, 0x01, 0x03,
        0xa3, 0x18, 0x30, 0x16, 0x30, 0x09, 0x06, 0x03, 0x55, 0x1d, 0x11, 0x04,
        0x02, 0x30, 0x00, 0x30, 0x09, 0x06, 0x03, 0x55, 0x1d, 0x11, 0x04, 0x02,
        0x30, 0x00, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d,
        0x01, 0x01, 0x0b, 0x05, 0x00, 0x03, 0x02, 0x00, 0x00,
    };
    const cert: Certificate = .{ .buffer = cert_der, .index = 0 };

    try std.testing.expectError(error.CertificateHasDuplicateExtension, cert.parse());
}

// RFC 5280 §4.2 — recognized extensions outside ztls's processing set do not
// overwrite parsed policy state, including obsolete and modern OID aliases.
test "parse accepts old and new authority key identifier OIDs" {
    const cert_der = &[_]u8{
        0x30, 0x81, 0x8a, 0x30, 0x75, 0xa0, 0x03, 0x02, 0x01, 0x02, 0x02, 0x01,
        0x01, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01,
        0x01, 0x0b, 0x05, 0x00, 0x30, 0x00, 0x30, 0x22, 0x18, 0x0f, 0x32, 0x30,
        0x32, 0x36, 0x30, 0x31, 0x30, 0x31, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30,
        0x5a, 0x18, 0x0f, 0x32, 0x30, 0x33, 0x30, 0x30, 0x31, 0x30, 0x31, 0x30,
        0x30, 0x30, 0x30, 0x30, 0x30, 0x5a, 0x30, 0x00, 0x30, 0x1a, 0x30, 0x0d,
        0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05,
        0x00, 0x03, 0x09, 0x00, 0x30, 0x06, 0x02, 0x01, 0x01, 0x02, 0x01, 0x03,
        0xa3, 0x18, 0x30, 0x16, 0x30, 0x09, 0x06, 0x03, 0x55, 0x1d, 0x01, 0x04,
        0x02, 0x30, 0x00, 0x30, 0x09, 0x06, 0x03, 0x55, 0x1d, 0x23, 0x04, 0x02,
        0x30, 0x00, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d,
        0x01, 0x01, 0x0b, 0x05, 0x00, 0x03, 0x02, 0x00, 0x00,
    };
    const cert: Certificate = .{ .buffer = cert_der, .index = 0 };

    _ = try cert.parse();
}

fn contents(cert: Certificate, elem: der.Element) []const u8 {
    return cert.buffer[elem.slice.start..elem.slice.end];
}

const ParseBitStringError = error{ CertificateFieldHasWrongDataType, CertificateHasInvalidBitString };

fn parseBitString(cert: Certificate, elem: der.Element) !der.Element.Slice {
    if (elem.identifier.tag != .bitstring) return error.CertificateFieldHasWrongDataType;
    if (elem.slice.end - elem.slice.start < 1) return error.CertificateHasInvalidBitString;
    if (cert.buffer[elem.slice.start] != 0) return error.CertificateHasInvalidBitString;
    return .{ .start = elem.slice.start + 1, .end = elem.slice.end };
}

// ITU-T X.690 §8.6.2.2 — DER BIT STRING content starts with an unused-bits octet.
test "parseBitString rejects empty bit string content" {
    const cert: Certificate = .{ .buffer = "\x03\x00", .index = 0 };
    const elem = try der.Element.parse(cert.buffer, 0);

    try std.testing.expectError(error.CertificateHasInvalidBitString, parseBitString(cert, elem));
}

const ParseTimeError = error{ CertificateTimeInvalid, CertificateFieldHasWrongDataType };

/// Returns number of seconds since epoch.
fn parseTime(cert: Certificate, elem: der.Element) ParseTimeError!u64 {
    const bytes = cert.contents(elem);
    switch (elem.identifier.tag) {
        .utc_time => {
            // Example: "YYMMDD000000Z"
            if (bytes.len != 13)
                return error.CertificateTimeInvalid;
            if (bytes[12] != 'Z')
                return error.CertificateTimeInvalid;

            return Date.toSeconds(.{
                .year = @as(u16, 2000) + try parseTimeDigits(bytes[0..2], 0, 99),
                .month = try parseTimeDigits(bytes[2..4], 1, 12),
                .day = try parseTimeDigits(bytes[4..6], 1, 31),
                .hour = try parseTimeDigits(bytes[6..8], 0, 23),
                .minute = try parseTimeDigits(bytes[8..10], 0, 59),
                .second = try parseTimeDigits(bytes[10..12], 0, 59),
            });
        },
        .generalized_time => {
            // Examples:
            // "19920521000000Z"
            // "19920622123421Z"
            // "19920722132100.3Z"
            if (bytes.len < 15)
                return error.CertificateTimeInvalid;
            return Date.toSeconds(.{
                .year = try parseYear4(bytes[0..4]),
                .month = try parseTimeDigits(bytes[4..6], 1, 12),
                .day = try parseTimeDigits(bytes[6..8], 1, 31),
                .hour = try parseTimeDigits(bytes[8..10], 0, 23),
                .minute = try parseTimeDigits(bytes[10..12], 0, 59),
                .second = try parseTimeDigits(bytes[12..14], 0, 59),
            });
        },
        else => return error.CertificateFieldHasWrongDataType,
    }
}

const Date = struct {
    /// example: 1999
    year: u16,
    /// range: 1 to 12
    month: u8,
    /// range: 1 to 31
    day: u8,
    /// range: 0 to 59
    hour: u8,
    /// range: 0 to 59
    minute: u8,
    /// range: 0 to 59
    second: u8,

    /// Convert to number of seconds since epoch.
    pub fn toSeconds(date: Date) u64 {
        var sec: u64 = 0;

        {
            var year: u16 = 1970;
            while (year < date.year) : (year += 1) {
                const days: u64 = std.time.epoch.getDaysInYear(year);
                sec += days * std.time.epoch.secs_per_day;
            }
        }

        {
            var month: u4 = 1;
            while (month < date.month) : (month += 1) {
                const days: u64 = std.time.epoch.getDaysInMonth(
                    date.year,
                    @enumFromInt(month),
                );
                sec += days * std.time.epoch.secs_per_day;
            }
        }

        sec += (date.day - 1) * @as(u64, std.time.epoch.secs_per_day);
        sec += date.hour * @as(u64, 60 * 60);
        sec += date.minute * @as(u64, 60);
        sec += date.second;

        return sec;
    }
};

fn parseTimeDigits(text: *const [2]u8, min: u8, max: u8) !u8 {
    const nn: @Vector(2, u16) = .{ text[0], text[1] };
    const zero: @Vector(2, u16) = .{ '0', '0' };
    const mm: @Vector(2, u16) = .{ 10, 1 };
    const result = @reduce(.Add, (nn -% zero) *% mm);
    if (result < min) return error.CertificateTimeInvalid;
    if (result > max) return error.CertificateTimeInvalid;
    return @intCast(result);
}

test parseTimeDigits {
    const expectEqual = std.testing.expectEqual;
    try expectEqual(@as(u8, 0), try parseTimeDigits("00", 0, 99));
    try expectEqual(@as(u8, 99), try parseTimeDigits("99", 0, 99));
    try expectEqual(@as(u8, 42), try parseTimeDigits("42", 0, 99));

    const expectError = std.testing.expectError;
    try expectError(error.CertificateTimeInvalid, parseTimeDigits("13", 1, 12));
    try expectError(error.CertificateTimeInvalid, parseTimeDigits("00", 1, 12));
    try expectError(error.CertificateTimeInvalid, parseTimeDigits("Di", 0, 99));
}

fn parseYear4(text: *const [4]u8) !u16 {
    const nnnn: @Vector(4, u32) = .{ text[0], text[1], text[2], text[3] };
    const zero: @Vector(4, u32) = .{ '0', '0', '0', '0' };
    const mmmm: @Vector(4, u32) = .{ 1000, 100, 10, 1 };
    const result = @reduce(.Add, (nnnn -% zero) *% mmmm);
    if (result > 9999) return error.CertificateTimeInvalid;
    return @intCast(result);
}

test parseYear4 {
    const expectEqual = std.testing.expectEqual;
    try expectEqual(@as(u16, 0), try parseYear4("0000"));
    try expectEqual(@as(u16, 9999), try parseYear4("9999"));
    try expectEqual(@as(u16, 1988), try parseYear4("1988"));

    const expectError = std.testing.expectError;
    try expectError(error.CertificateTimeInvalid, parseYear4("999b"));
    try expectError(error.CertificateTimeInvalid, parseYear4("crap"));
    try expectError(error.CertificateTimeInvalid, parseYear4("r:bQ"));
}

fn parseAlgorithm(bytes: []const u8, element: der.Element) ParseEnumError!Algorithm {
    return parseEnum(Algorithm, bytes, element);
}

fn parseAlgorithmCategory(bytes: []const u8, element: der.Element) ParseEnumError!AlgorithmCategory {
    return parseEnum(AlgorithmCategory, bytes, element);
}

fn parseAttribute(bytes: []const u8, element: der.Element) ParseEnumError!Attribute {
    return parseEnum(Attribute, bytes, element);
}

fn parseNamedCurve(bytes: []const u8, element: der.Element) ParseEnumError!NamedCurve {
    return parseEnum(NamedCurve, bytes, element);
}

fn parseExtensionId(bytes: []const u8, element: der.Element) ParseEnumError!ExtensionId {
    return parseEnum(ExtensionId, bytes, element);
}

const ParseEnumError = error{ CertificateFieldHasWrongDataType, CertificateHasUnrecognizedObjectId };

fn parseEnum(comptime E: type, bytes: []const u8, element: der.Element) ParseEnumError!E {
    if (element.identifier.tag != .object_identifier)
        return error.CertificateFieldHasWrongDataType;
    const oid_bytes = bytes[element.slice.start..element.slice.end];
    return E.map.get(oid_bytes) orelse return error.CertificateHasUnrecognizedObjectId;
}

const ParseVersionError = error{ UnsupportedCertificateVersion, CertificateFieldHasInvalidLength };

fn parseVersion(bytes: []const u8, version_elem: der.Element) ParseVersionError!Version {
    if (@as(u8, @bitCast(version_elem.identifier)) != 0xa0)
        return .v1;

    if (version_elem.slice.end - version_elem.slice.start != 3)
        return error.CertificateFieldHasInvalidLength;

    const encoded_version = bytes[version_elem.slice.start..version_elem.slice.end];

    if (mem.eql(u8, encoded_version, "\x02\x01\x02")) {
        return .v3;
    } else if (mem.eql(u8, encoded_version, "\x02\x01\x01")) {
        return .v2;
    } else if (mem.eql(u8, encoded_version, "\x02\x01\x00")) {
        return .v1;
    }

    return error.UnsupportedCertificateVersion;
}

fn verifyRsa(
    comptime Hash: type,
    msg: []const u8,
    sig: []const u8,
    pub_key_algo: Parsed.PubKeyAlgo,
    pub_key: []const u8,
) !void {
    if (pub_key_algo != .rsaEncryption) return error.CertificateSignatureAlgorithmMismatch;
    const pk_components = try rsa.PublicKey.parseDer(pub_key);
    const exponent = pk_components.exponent;
    const modulus = pk_components.modulus;
    if (exponent.len > modulus.len) return error.CertificatePublicKeyInvalid;
    if (sig.len != modulus.len) return error.CertificateSignatureInvalidLength;

    switch (modulus.len) {
        inline 128, 256, 384, 512 => |modulus_len| {
            const public_key = rsa.PublicKey.fromBytes(exponent, modulus) catch
                return error.CertificateSignatureInvalid;
            rsa.PKCS1v1_5Signature.verify(modulus_len, sig[0..modulus_len].*, msg, public_key, Hash) catch
                return error.CertificateSignatureInvalid;
        },
        else => return error.CertificateSignatureUnsupportedBitCount,
    }
}

fn verify_ecdsa(
    comptime Hash: type,
    message: []const u8,
    encoded_sig: []const u8,
    pub_key_algo: Parsed.PubKeyAlgo,
    sec1_pub_key: []const u8,
) !void {
    const sig_named_curve = switch (pub_key_algo) {
        .X9_62_id_ecPublicKey => |named_curve| named_curve,
        else => return error.CertificateSignatureAlgorithmMismatch,
    };

    switch (sig_named_curve) {
        .secp521r1 => {
            return error.CertificateSignatureNamedCurveUnsupported;
        },
        inline .X9_62_prime256v1,
        .secp384r1,
        => |curve| {
            const Ecdsa = crypto.sign.ecdsa.Ecdsa(curve.Curve(), Hash);
            const sig = Ecdsa.Signature.fromDer(encoded_sig) catch |err| switch (err) {
                error.InvalidEncoding => return error.CertificateSignatureInvalid,
            };
            const pub_key = Ecdsa.PublicKey.fromSec1(sec1_pub_key) catch |err| switch (err) {
                error.InvalidEncoding => return error.CertificateSignatureInvalid,
                error.NonCanonical => return error.CertificateSignatureInvalid,
                error.NotSquare => return error.CertificateSignatureInvalid,
            };
            sig.verify(message, pub_key) catch |err| switch (err) {
                error.IdentityElement => return error.CertificateSignatureInvalid,
                error.NonCanonical => return error.CertificateSignatureInvalid,
                error.SignatureVerificationFailed => return error.CertificateSignatureInvalid,
            };
        },
    }
}

fn verifyEd25519(
    message: []const u8,
    encoded_sig: []const u8,
    pub_key_algo: Parsed.PubKeyAlgo,
    encoded_pub_key: []const u8,
) !void {
    if (pub_key_algo != .curveEd25519) return error.CertificateSignatureAlgorithmMismatch;
    const Ed25519 = crypto.sign.Ed25519;
    if (encoded_sig.len != Ed25519.Signature.encoded_length) return error.CertificateSignatureInvalid;
    const sig = Ed25519.Signature.fromBytes(encoded_sig[0..Ed25519.Signature.encoded_length].*);
    if (encoded_pub_key.len != Ed25519.PublicKey.encoded_length) return error.CertificateSignatureInvalid;
    const pub_key = Ed25519.PublicKey.fromBytes(encoded_pub_key[0..Ed25519.PublicKey.encoded_length].*) catch |err| switch (err) {
        error.NonCanonical => return error.CertificateSignatureInvalid,
    };
    sig.verify(message, pub_key) catch |err| switch (err) {
        error.IdentityElement => return error.CertificateSignatureInvalid,
        error.NonCanonical => return error.CertificateSignatureInvalid,
        error.SignatureVerificationFailed => return error.CertificateSignatureInvalid,
        error.InvalidEncoding => return error.CertificateSignatureInvalid,
        error.WeakPublicKey => return error.CertificateSignatureInvalid,
    };
}

const Certificate = @This();

pub const der = struct {
    pub const Class = enum(u2) {
        universal,
        application,
        context_specific,
        private,
    };

    pub const PC = enum(u1) {
        primitive,
        constructed,
    };

    pub const Identifier = packed struct(u8) {
        tag: Tag,
        pc: PC,
        class: Class,
    };

    pub const Tag = enum(u5) {
        boolean = 1,
        integer = 2,
        bitstring = 3,
        octetstring = 4,
        null = 5,
        object_identifier = 6,
        sequence = 16,
        sequence_of = 17,
        utc_time = 23,
        generalized_time = 24,
        _,
    };

    pub const Element = struct {
        identifier: Identifier,
        slice: Slice,

        pub const Slice = struct {
            start: u32,
            end: u32,

            pub const empty: Slice = .{ .start = 0, .end = 0 };
        };

        pub const ParseError = error{CertificateFieldHasInvalidLength};

        pub fn parse(bytes: []const u8, index: u32) Element.ParseError!Element {
            var i: usize = index;
            if (i >= bytes.len) return error.CertificateFieldHasInvalidLength;
            const identifier: Identifier = @bitCast(bytes[i]);
            i += 1;
            if (i >= bytes.len) return error.CertificateFieldHasInvalidLength;
            const size_byte = bytes[i];
            i += 1;
            if ((size_byte >> 7) == 0) {
                const end = i + size_byte;
                if (end > bytes.len or end > std.math.maxInt(u32)) return error.CertificateFieldHasInvalidLength;
                return .{
                    .identifier = identifier,
                    .slice = .{
                        .start = @intCast(i),
                        .end = @intCast(end),
                    },
                };
            }

            const len_size: u7 = @truncate(size_byte);
            if (len_size > @sizeOf(u32) or i + len_size > bytes.len) {
                return error.CertificateFieldHasInvalidLength;
            }

            const end_i = i + len_size;
            var long_form_size: u32 = 0;
            while (i < end_i) : (i += 1) {
                long_form_size = (long_form_size << 8) | bytes[i];
            }

            const end = i + long_form_size;
            if (end > bytes.len or end > std.math.maxInt(u32)) return error.CertificateFieldHasInvalidLength;
            return .{
                .identifier = identifier,
                .slice = .{
                    .start = @intCast(i),
                    .end = @intCast(end),
                },
            };
        }
    };
};

test {
    _ = Bundle;
}

pub const rsa = struct {
    const max_modulus_bits = 4096;
    const Uint = std.crypto.ff.Uint(max_modulus_bits);
    const Modulus = std.crypto.ff.Modulus(max_modulus_bits);
    const Fe = Modulus.Fe;

    /// RFC 3447 8.1 RSASSA-PSS
    pub const PSSSignature = struct {
        pub fn fromBytes(comptime modulus_len: usize, msg: []const u8) [modulus_len]u8 {
            var result: [modulus_len]u8 = @splat(0);
            @memcpy(result[0..msg.len], msg);
            return result;
        }

        pub const VerifyError = EncryptError || error{InvalidSignature};

        pub fn verify(
            comptime modulus_len: usize,
            sig: [modulus_len]u8,
            msg: []const u8,
            public_key: PublicKey,
            comptime Hash: type,
        ) VerifyError!void {
            try concatVerify(modulus_len, sig, &.{msg}, public_key, Hash);
        }

        pub fn concatVerify(
            comptime modulus_len: usize,
            sig: [modulus_len]u8,
            msg: []const []const u8,
            public_key: PublicKey,
            comptime Hash: type,
        ) VerifyError!void {
            const mod_bits = public_key.n.bits();
            const em_dec = try encrypt(modulus_len, sig, public_key);

            try EMSA_PSS_VERIFY(msg, &em_dec, mod_bits - 1, Hash.digest_length, Hash);
        }

        fn EMSA_PSS_VERIFY(msg: []const []const u8, em: []const u8, emBit: usize, sLen: usize, comptime Hash: type) VerifyError!void {
            // 1.   If the length of M is greater than the input limitation for
            //      the hash function (2^61 - 1 octets for SHA-1), output
            //      "inconsistent" and stop.
            // All the cryptographic hash functions in the standard library have a limit of >= 2^61 - 1.
            // Even then, this check is only there for paranoia. In the context of TLS certificates, emBit cannot exceed 4096.
            if (emBit >= 1 << 61) return error.InvalidSignature;

            // emLen = \ceil(emBits/8)
            const emLen = ((emBit - 1) / 8) + 1;
            std.debug.assert(emLen == em.len);

            // 2.   Let mHash = Hash(M), an octet string of length hLen.
            var mHash: [Hash.digest_length]u8 = undefined;
            {
                var hasher: Hash = .init(.{});
                for (msg) |part| hasher.update(part);
                hasher.final(&mHash);
            }

            // 3.   If emLen < hLen + sLen + 2, output "inconsistent" and stop.
            if (emLen < Hash.digest_length + sLen + 2) {
                return error.InvalidSignature;
            }

            // 4.   If the rightmost octet of EM does not have hexadecimal value
            //      0xbc, output "inconsistent" and stop.
            if (em[em.len - 1] != 0xbc) {
                return error.InvalidSignature;
            }

            // 5.   Let maskedDB be the leftmost emLen - hLen - 1 octets of EM,
            //      and let H be the next hLen octets.
            const maskedDB = em[0..(emLen - Hash.digest_length - 1)];
            const h = em[(emLen - Hash.digest_length - 1)..(emLen - 1)][0..Hash.digest_length];

            // 6.   If the leftmost 8emLen - emBits bits of the leftmost octet in
            //      maskedDB are not all equal to zero, output "inconsistent" and
            //      stop.
            const zero_bits = emLen * 8 - emBit;
            var mask: u8 = maskedDB[0];
            var i: usize = 0;
            while (i < 8 - zero_bits) : (i += 1) {
                mask = mask >> 1;
            }
            if (mask != 0) {
                return error.InvalidSignature;
            }

            // 7.   Let dbMask = MGF(H, emLen - hLen - 1).
            const mgf_len = emLen - Hash.digest_length - 1;
            var mgf_out_buf: [512]u8 = undefined;
            if (mgf_len > mgf_out_buf.len) { // Modulus > 4096 bits
                return error.InvalidSignature;
            }
            const mgf_out = mgf_out_buf[0 .. ((mgf_len - 1) / Hash.digest_length + 1) * Hash.digest_length];
            var dbMask = try MGF1(Hash, mgf_out, h, mgf_len);

            // 8.   Let DB = maskedDB \xor dbMask.
            i = 0;
            while (i < dbMask.len) : (i += 1) {
                dbMask[i] = maskedDB[i] ^ dbMask[i];
            }

            // 9.   Set the leftmost 8emLen - emBits bits of the leftmost octet
            //      in DB to zero.
            i = 0;
            mask = 0;
            while (i < 8 - zero_bits) : (i += 1) {
                mask = mask << 1;
                mask += 1;
            }
            dbMask[0] = dbMask[0] & mask;

            // 10.  If the emLen - hLen - sLen - 2 leftmost octets of DB are not
            //      zero or if the octet at position emLen - hLen - sLen - 1 (the
            //      leftmost position is "position 1") does not have hexadecimal
            //      value 0x01, output "inconsistent" and stop.
            if (dbMask[mgf_len - sLen - 2] != 0x00) {
                return error.InvalidSignature;
            }

            if (dbMask[mgf_len - sLen - 1] != 0x01) {
                return error.InvalidSignature;
            }

            // 11.  Let salt be the last sLen octets of DB.
            const salt = dbMask[(mgf_len - sLen)..];

            // 12.  Let
            //         M' = (0x)00 00 00 00 00 00 00 00 || mHash || salt ;
            //      M' is an octet string of length 8 + hLen + sLen with eight
            //      initial zero octets.
            if (sLen > Hash.digest_length) { // A seed larger than the hash length would be useless
                return error.InvalidSignature;
            }
            var m_p_buf: [8 + Hash.digest_length + Hash.digest_length]u8 = undefined;
            var m_p = m_p_buf[0 .. 8 + Hash.digest_length + sLen];
            std.mem.copyForwards(u8, m_p, &([_]u8{0} ** 8));
            std.mem.copyForwards(u8, m_p[8..], &mHash);
            std.mem.copyForwards(u8, m_p[(8 + Hash.digest_length)..], salt);

            // 13.  Let H' = Hash(M'), an octet string of length hLen.
            var h_p: [Hash.digest_length]u8 = undefined;
            Hash.hash(m_p, &h_p, .{});

            // 14.  If H = H', output "consistent".  Otherwise, output
            //      "inconsistent".
            if (!std.mem.eql(u8, h, &h_p)) {
                return error.InvalidSignature;
            }
        }

        fn MGF1(comptime Hash: type, out: []u8, seed: *const [Hash.digest_length]u8, len: usize) ![]u8 {
            var counter: u32 = 0;
            var idx: usize = 0;
            var hash = seed.* ++ @as([4]u8, undefined);

            while (idx < len) {
                std.mem.writeInt(u32, hash[seed.len..][0..4], counter, .big);
                Hash.hash(&hash, out[idx..][0..Hash.digest_length], .{});
                idx += Hash.digest_length;
                counter += 1;
            }

            return out[0..len];
        }
    };

    /// RFC 3447 8.2 RSASSA-PKCS1-v1_5
    pub const PKCS1v1_5Signature = struct {
        pub fn fromBytes(comptime modulus_len: usize, msg: []const u8) [modulus_len]u8 {
            var result: [modulus_len]u8 = @splat(0);
            @memcpy(result[0..msg.len], msg);
            return result;
        }

        pub const VerifyError = EncryptError || error{InvalidSignature};

        pub fn verify(
            comptime modulus_len: usize,
            sig: [modulus_len]u8,
            msg: []const u8,
            public_key: PublicKey,
            comptime Hash: type,
        ) VerifyError!void {
            try concatVerify(modulus_len, sig, &.{msg}, public_key, Hash);
        }

        pub fn concatVerify(
            comptime modulus_len: usize,
            sig: [modulus_len]u8,
            msg: []const []const u8,
            public_key: PublicKey,
            comptime Hash: type,
        ) VerifyError!void {
            const em_dec = try encrypt(modulus_len, sig, public_key);
            const em = try EMSA_PKCS1_V1_5_ENCODE(msg, modulus_len, Hash);
            if (!std.mem.eql(u8, &em_dec, &em)) return error.InvalidSignature;
        }

        fn EMSA_PKCS1_V1_5_ENCODE(msg: []const []const u8, comptime emLen: usize, comptime Hash: type) VerifyError![emLen]u8 {
            comptime var em_index = emLen;
            var em: [emLen]u8 = undefined;

            // 1. Apply the hash function to the message M to produce a hash value
            //    H:
            //
            //       H = Hash(M).
            //
            //    If the hash function outputs "message too long," output "message
            //    too long" and stop.
            var hasher: Hash = .init(.{});
            for (msg) |part| hasher.update(part);
            em_index -= Hash.digest_length;
            hasher.final(em[em_index..]);

            // 2. Encode the algorithm ID for the hash function and the hash value
            //    into an ASN.1 value of type DigestInfo (see Appendix A.2.4) with
            //    the Distinguished Encoding Rules (DER), where the type DigestInfo
            //    has the syntax
            //
            //    DigestInfo ::= SEQUENCE {
            //        digestAlgorithm AlgorithmIdentifier,
            //        digest OCTET STRING
            //    }
            //
            //    The first field identifies the hash function and the second
            //    contains the hash value.  Let T be the DER encoding of the
            //    DigestInfo value (see the notes below) and let tLen be the length
            //    in octets of T.
            const hash_der: []const u8 = &switch (Hash) {
                crypto.hash.Sha1 => .{
                    0x30, 0x21, 0x30, 0x09, 0x06, 0x05, 0x2b, 0x0e,
                    0x03, 0x02, 0x1a, 0x05, 0x00, 0x04, 0x14,
                },
                crypto.hash.sha2.Sha224 => .{
                    0x30, 0x2d, 0x30, 0x0d, 0x06, 0x09, 0x60, 0x86,
                    0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x04, 0x05,
                    0x00, 0x04, 0x1c,
                },
                crypto.hash.sha2.Sha256 => .{
                    0x30, 0x31, 0x30, 0x0d, 0x06, 0x09, 0x60, 0x86,
                    0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x01, 0x05,
                    0x00, 0x04, 0x20,
                },
                crypto.hash.sha2.Sha384 => .{
                    0x30, 0x41, 0x30, 0x0d, 0x06, 0x09, 0x60, 0x86,
                    0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x02, 0x05,
                    0x00, 0x04, 0x30,
                },
                crypto.hash.sha2.Sha512 => .{
                    0x30, 0x51, 0x30, 0x0d, 0x06, 0x09, 0x60, 0x86,
                    0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x03, 0x05,
                    0x00, 0x04, 0x40,
                },
                else => @compileError("unreachable"),
            };
            em_index -= hash_der.len;
            @memcpy(em[em_index..][0..hash_der.len], hash_der);

            // 3. If emLen < tLen + 11, output "intended encoded message length too
            //    short" and stop.

            // 4. Generate an octet string PS consisting of emLen - tLen - 3 octets
            //    with hexadecimal value 0xff.  The length of PS will be at least 8
            //    octets.
            em_index -= 1;
            @memset(em[2..em_index], 0xff);

            // 5. Concatenate PS, the DER encoding T, and other padding to form the
            //    encoded message EM as
            //
            //       EM = 0x00 || 0x01 || PS || 0x00 || T.
            em[em_index] = 0x00;
            em[1] = 0x01;
            em[0] = 0x00;

            // 6. Output EM.
            return em;
        }
    };

    pub const PublicKey = struct {
        n: Modulus,
        e: Fe,

        pub const FromBytesError = error{CertificatePublicKeyInvalid};

        pub fn fromBytes(pub_bytes: []const u8, modulus_bytes: []const u8) FromBytesError!PublicKey {
            // Reject modulus below 512 bits.
            // 512-bit RSA was factored in 1999, so this limit barely means anything,
            // but establish some limit now to ratchet in what we can.
            const _n = Modulus.fromBytes(modulus_bytes, .big) catch return error.CertificatePublicKeyInvalid;
            if (_n.bits() < 512) return error.CertificatePublicKeyInvalid;

            // Exponent must be odd and greater than 2.
            // Also, it must be less than 2^32 to mitigate DoS attacks.
            // Windows CryptoAPI doesn't support values larger than 32 bits [1], so it is
            // unlikely that exponents larger than 32 bits are being used for anything
            // Windows commonly does.
            // [1] https://learn.microsoft.com/en-us/windows/win32/api/wincrypt/ns-wincrypt-rsapubkey
            if (pub_bytes.len > 4) return error.CertificatePublicKeyInvalid;
            const _e = Fe.fromBytes(_n, pub_bytes, .big) catch return error.CertificatePublicKeyInvalid;
            if (!_e.isOdd()) return error.CertificatePublicKeyInvalid;
            const e_v = _e.toPrimitive(u32) catch return error.CertificatePublicKeyInvalid;
            if (e_v < 2) return error.CertificatePublicKeyInvalid;

            return .{
                .n = _n,
                .e = _e,
            };
        }

        pub const ParseDerError = der.Element.ParseError || error{CertificateFieldHasWrongDataType};

        pub fn parseDer(pub_key: []const u8) ParseDerError!struct { modulus: []const u8, exponent: []const u8 } {
            const pub_key_seq = try der.Element.parse(pub_key, 0);
            if (pub_key_seq.identifier.tag != .sequence) return error.CertificateFieldHasWrongDataType;
            const modulus_elem = try der.Element.parse(pub_key, pub_key_seq.slice.start);
            if (modulus_elem.identifier.tag != .integer) return error.CertificateFieldHasWrongDataType;
            const exponent_elem = try der.Element.parse(pub_key, modulus_elem.slice.end);
            if (exponent_elem.identifier.tag != .integer) return error.CertificateFieldHasWrongDataType;
            // Skip over meaningless zeroes in the modulus.
            const modulus_raw = pub_key[modulus_elem.slice.start..modulus_elem.slice.end];
            const modulus_offset = for (modulus_raw, 0..) |byte, i| {
                if (byte != 0) break i;
            } else modulus_raw.len;
            return .{
                .modulus = modulus_raw[modulus_offset..],
                .exponent = pub_key[exponent_elem.slice.start..exponent_elem.slice.end],
            };
        }
    };

    const EncryptError = error{MessageTooLong};

    fn encrypt(comptime modulus_len: usize, msg: [modulus_len]u8, public_key: PublicKey) EncryptError![modulus_len]u8 {
        const m = Fe.fromBytes(public_key.n, &msg, .big) catch return error.MessageTooLong;
        const e = public_key.n.powPublic(m, public_key.e) catch unreachable;
        var res: [modulus_len]u8 = undefined;
        e.toBytes(&res, .big) catch unreachable;
        return res;
    }
};
