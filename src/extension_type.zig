//! TLS extension type registry values.
//!
//! RFC 8446 §4.2 and related extension RFCs.

const std = @import("std");
const testing = std.testing;

const memx = @import("memx.zig");

pub const DuplicateExtensionError = error{ InvalidExtensionLength, DuplicateExtension };

pub fn rejectDuplicateExtensions(extensions: []const u8) DuplicateExtensionError!void {
    var outer: usize = 0;
    while (outer < extensions.len) {
        if (extensions.len - outer < 4) return error.InvalidExtensionLength;
        const ext_type = memx.readInt(u16, extensions[outer..][0..2]);
        const ext_len = memx.readInt(u16, extensions[outer + 2 ..][0..2]);
        const next = outer + 4 + ext_len;
        if (next > extensions.len) return error.InvalidExtensionLength;

        var inner: usize = next;
        while (inner < extensions.len) {
            if (extensions.len - inner < 4) return error.InvalidExtensionLength;
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
};

pub fn isGrease(ext_type: ExtensionType) bool {
    const value = @intFromEnum(ext_type);
    return (value & 0x0f0f) == 0x0a0a and (value >> 8) == (value & 0xff);
}

// RFC 8446 §4.2 — an extension block must not contain the same ExtensionType
// more than once, including unknown extension types.
test "rejectDuplicateExtensions: rejects duplicate unknown type" {
    const extensions = [_]u8{
        0xab, 0xcd, 0x00, 0x01, 0x00,
        0x00, 0x15, 0x00, 0x00, 0xab,
        0xcd, 0x00, 0x00,
    };
    try testing.expectError(error.DuplicateExtension, rejectDuplicateExtensions(&extensions));
}

// RFC 8446 §4.2 — extension blocks are vectors of type/length/value entries.
// RFC 8701 §2 — GREASE values reserve code points of the form 0x?a?a.
test "isGrease: detects reserved GREASE extension code points" {
    try testing.expect(isGrease(@enumFromInt(0x0a0a)));
    try testing.expect(isGrease(@enumFromInt(0x1a1a)));
    try testing.expect(isGrease(@enumFromInt(0xfafa)));
    try testing.expect(!isGrease(@enumFromInt(0x5a5b)));
    try testing.expect(!isGrease(.heartbeat));
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
