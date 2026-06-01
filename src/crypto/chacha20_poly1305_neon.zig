const std = @import("std");
const crypto = std.crypto;
const assert = std.debug.assert;

pub const tag_length = 16;
pub const nonce_length = 12;
pub const key_length = 32;

const SealData = extern struct {
    key: [key_length]u8 align(16),
    counter: u32,
    nonce: [nonce_length]u8,
    extra_ciphertext: ?[*]const u8,
    extra_ciphertext_len: usize,
};

const OpenData = extern struct {
    key: [key_length]u8 align(16),
    counter: u32,
    nonce: [nonce_length]u8,
};

comptime {
    assert(@sizeOf(SealData) == 64);
    assert(@offsetOf(SealData, "key") == 0);
    assert(@offsetOf(SealData, "counter") == 32);
    assert(@offsetOf(SealData, "nonce") == 36);
    assert(@offsetOf(SealData, "extra_ciphertext") == 48);
    assert(@offsetOf(SealData, "extra_ciphertext_len") == 56);

    assert(@sizeOf(OpenData) == 48);
    assert(@offsetOf(OpenData, "key") == 0);
    assert(@offsetOf(OpenData, "counter") == 32);
    assert(@offsetOf(OpenData, "nonce") == 36);
}

extern fn chacha20_poly1305_seal(
    out_ciphertext: [*]u8,
    plaintext: [*]const u8,
    plaintext_len: usize,
    ad: [*]const u8,
    ad_len: usize,
    data: *SealData,
) void;

extern fn chacha20_poly1305_open(
    out_plaintext: [*]u8,
    ciphertext: [*]const u8,
    ciphertext_len: usize,
    ad: [*]const u8,
    ad_len: usize,
    data: *OpenData,
) void;

fn ptr(comptime T: type, slice: []T) [*]T {
    return if (slice.len == 0) undefined else slice.ptr;
}

fn constPtr(comptime T: type, slice: []const T) [*]const T {
    return if (slice.len == 0) undefined else slice.ptr;
}

pub fn encrypt(
    ciphertext: []u8,
    tag: *[tag_length]u8,
    plaintext: []const u8,
    ad: []const u8,
    npub: [nonce_length]u8,
    key: [key_length]u8,
) void {
    assert(ciphertext.len == plaintext.len);

    var data: SealData = .{
        .key = key,
        .counter = 0,
        .nonce = npub,
        .extra_ciphertext = null,
        .extra_ciphertext_len = 0,
    };
    chacha20_poly1305_seal(
        ptr(u8, ciphertext),
        constPtr(u8, plaintext),
        plaintext.len,
        constPtr(u8, ad),
        ad.len,
        &data,
    );
    tag.* = std.mem.asBytes(&data)[0..tag_length].*;
}

pub fn decrypt(
    plaintext: []u8,
    ciphertext: []const u8,
    tag: [tag_length]u8,
    ad: []const u8,
    npub: [nonce_length]u8,
    key: [key_length]u8,
) crypto.errors.AuthenticationError!void {
    assert(plaintext.len == ciphertext.len);

    var data: OpenData = .{
        .key = key,
        .counter = 0,
        .nonce = npub,
    };
    chacha20_poly1305_open(
        ptr(u8, plaintext),
        constPtr(u8, ciphertext),
        ciphertext.len,
        constPtr(u8, ad),
        ad.len,
        &data,
    );
    var computed = std.mem.asBytes(&data)[0..tag_length].*;
    if (!crypto.timing_safe.eql([tag_length]u8, computed, tag)) {
        crypto.secureZero(u8, &computed);
        @memset(plaintext, undefined);
        return error.AuthenticationFailed;
    }
}
