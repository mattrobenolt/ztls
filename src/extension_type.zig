//! TLS extension type registry values.
//!
//! RFC 8446 §4.2 and related extension RFCs.

const std = @import("std");
const testing = std.testing;

const memx = @import("memx.zig");

// Sixty-four is more than twice a normal ClientHello's standard plus GREASE
// extensions, while keeping duplicate detection bounded without extra storage.
const max_extensions: usize = 64;

pub const OfferedExtension = enum {
    server_name,
    record_size_limit,
    early_data,
};

pub const OfferedExtensions = std.EnumSet(OfferedExtension);

pub const DuplicateExtensionError = error{ InvalidExtensionLength, DuplicateExtension };

pub fn rejectDuplicateExtensions(extensions: []const u8) DuplicateExtensionError!void {
    var extension_count: usize = 0;
    var outer: usize = 0;
    while (outer < extensions.len) {
        if (extensions.len - outer < 4) return error.InvalidExtensionLength;
        extension_count += 1;
        if (extension_count > max_extensions) return error.InvalidExtensionLength;

        const ext_type = memx.readInt(u16, extensions[outer..][0..2]);
        const ext_len = memx.readInt(u16, extensions[outer + 2 ..][0..2]);
        const next = outer + 4 + ext_len;
        if (next > extensions.len) return error.InvalidExtensionLength;

        var inner_count = extension_count;
        var inner: usize = next;
        while (inner < extensions.len) {
            if (extensions.len - inner < 4) return error.InvalidExtensionLength;
            inner_count += 1;
            if (inner_count > max_extensions) return error.InvalidExtensionLength;
            if (memx.readInt(u16, extensions[inner..][0..2]) == ext_type)
                return error.DuplicateExtension;
            const inner_len = memx.readInt(u16, extensions[inner + 2 ..][0..2]);
            inner += 4 + inner_len;
            if (inner > extensions.len) return error.InvalidExtensionLength;
        }

        outer = next;
    }
}

pub const ExtensionType = enum(u16) {
    server_name = 0x0000,
    status_request = 0x0005,
    supported_groups = 0x000a,
    signature_algorithms = 0x000d,
    heartbeat = 0x000f,
    alpn = 0x0010,
    status_request_v2 = 0x0011,
    signed_certificate_timestamp = 0x0012,
    padding = 0x0015,
    record_size_limit = 0x001c,
    pre_shared_key = 0x0029,
    early_data = 0x002a,
    supported_versions = 0x002b,
    cookie = 0x002c,
    psk_key_exchange_modes = 0x002d,
    certificate_authorities = 0x002f,
    oid_filters = 0x0030,
    post_handshake_auth = 0x0031,
    signature_algorithms_cert = 0x0032,
    key_share = 0x0033,
    _,

    pub fn isGrease(self: ExtensionType) bool {
        const value = @intFromEnum(self);
        return (value & 0x0f0f) == 0x0a0a and (value >> 8) == (value & 0xff);
    }
};

// RFC 8446 §4.2 — extension blocks contain a vector of Extension entries.
test "rejectDuplicateExtensions: rejects more than the extension count cap" {
    var extensions: [4 * (max_extensions + 1)]u8 = undefined;
    for (0..max_extensions + 1) |index| {
        const offset = index * 4;
        extensions[offset] = @intCast(index >> 8);
        extensions[offset + 1] = @intCast(index & 0xff);
        extensions[offset + 2] = 0;
        extensions[offset + 3] = 0;
    }

    try testing.expectError(error.InvalidExtensionLength, rejectDuplicateExtensions(&extensions));
}

// RFC 8446 §4.2 — an extension block must not contain the same ExtensionType
// more than once, including unknown extension types.
test "rejectDuplicateExtensions: rejects duplicate unknown type" {
    const extensions: [13]u8 = .{
        0xab, 0xcd, 0x00, 0x01, 0x00,
        0x00, 0x15, 0x00, 0x00, 0xab,
        0xcd, 0x00, 0x00,
    };
    try testing.expectError(error.DuplicateExtension, rejectDuplicateExtensions(&extensions));
}

// RFC 8446 §4.2 — a normal block with distinct ExtensionType values is valid.
test "rejectDuplicateExtensions: accepts distinct extension types" {
    const extensions: [15]u8 = .{
        0x00, 0x00, 0x00, 0x01, 0x00,
        0x00, 0x0a, 0x00, 0x00, 0x00,
        0x2b, 0x00, 0x02, 0x03, 0x04,
    };
    try rejectDuplicateExtensions(&extensions);
}

// RFC 8446 §4.2 — extension blocks are vectors of type/length/value entries.
// RFC 8701 §2 — GREASE values reserve code points of the form 0x?a?a.
test "ExtensionType.isGrease: detects reserved GREASE extension code points" {
    const grease_0a: ExtensionType = @enumFromInt(0x0a0a);
    const grease_1a: ExtensionType = @enumFromInt(0x1a1a);
    const grease_fa: ExtensionType = @enumFromInt(0xfafa);
    const unknown: ExtensionType = @enumFromInt(0x5a5b);
    try testing.expect(grease_0a.isGrease());
    try testing.expect(grease_1a.isGrease());
    try testing.expect(grease_fa.isGrease());
    try testing.expect(!unknown.isGrease());
    try testing.expect(!ExtensionType.heartbeat.isGrease());
}

test "rejectDuplicateExtensions: rejects malformed block" {
    try testing.expectError(
        error.InvalidExtensionLength,
        rejectDuplicateExtensions(&.{ 0x00, 0x15, 0x00 }),
    );
    try testing.expectError(
        error.InvalidExtensionLength,
        rejectDuplicateExtensions(&.{ 0x00, 0x15, 0x00, 0x02, 0x00 }),
    );
}
