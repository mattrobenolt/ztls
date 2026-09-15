//! Provider-backed pure ML-KEM primitives used by RFC 10024 hybrid groups.
//!
//! ztls owns the hybrid construction: this module only generates ML-KEM keys,
//! validates encapsulation keys, and encapsulates/decapsulates fixed-size
//! ciphertexts. Keeping the combiner above the provider seam makes the TLS wire
//! construction identical for OpenSSL, AWS-LC, and BoringSSL.
const std = @import("std");
const testing = std.testing;
const backend = @import("crypto/backend.zig");
const kem_impl = backend.kem_impl;
const kex = @import("kex.zig");

pub const ParameterSet = @import("crypto/mlkem_parameters.zig").ParameterSet;
pub const Error = error{
    BufferTooShort,
    IdentityElement,
    LibcryptoFailed,
    MalformedKeyShare,
};

pub const max_public_key_len = ParameterSet.mlkem1024.publicKeyLen();
pub const max_ciphertext_len = ParameterSet.mlkem1024.ciphertextLen();
pub const max_shared_secret_len = ParameterSet.mlkem1024.sharedSecretLen();

pub const KeyHandle = struct {
    parameter_set: ParameterSet,
    key: kem_impl.KemKey,

    pub fn deinit(self: *KeyHandle) void {
        kem_impl.freeKey(self.key);
        self.* = undefined;
    }
};

pub const PeerHandle = struct {
    parameter_set: ParameterSet,
    key: kem_impl.KemPeerKey,

    pub fn deinit(self: *PeerHandle) void {
        kem_impl.freeKey(self.key);
        self.* = undefined;
    }
};

pub fn generate(parameter_set: ParameterSet) Error!KeyHandle {
    return .{
        .parameter_set = parameter_set,
        .key = try kem_impl.kemKeygen(parameter_set),
    };
}

pub fn publicKey(key: *const KeyHandle, out: []u8) Error![]u8 {
    const expected = key.parameter_set.publicKeyLen();
    if (out.len < expected) return error.BufferTooShort;
    const public_key = try kem_impl.kemPublic(key.key, out[0..expected]);
    if (public_key.len != expected) return error.LibcryptoFailed;
    return public_key;
}

/// Import performs the FIPS 203 §7.2 encapsulation-key check in the provider.
pub fn loadPeerPublic(
    parameter_set: ParameterSet,
    public_key: []const u8,
) Error!PeerHandle {
    if (public_key.len != parameter_set.publicKeyLen())
        return error.MalformedKeyShare;
    return .{
        .parameter_set = parameter_set,
        .key = try kem_impl.kemLoadPublic(parameter_set, public_key),
    };
}

pub fn encapsulate(
    peer: *const PeerHandle,
    ciphertext_out: []u8,
    secret_out: []u8,
) Error!struct { ciphertext: []const u8, secret: []const u8 } {
    const ciphertext_len = peer.parameter_set.ciphertextLen();
    const secret_len = peer.parameter_set.sharedSecretLen();
    if (ciphertext_out.len < ciphertext_len or secret_out.len < secret_len)
        return error.BufferTooShort;
    const result = try kem_impl.kemEncapsulate(
        peer.parameter_set,
        peer.key,
        ciphertext_out[0..ciphertext_len],
        secret_out[0..secret_len],
    );
    if (result.ciphertext.len != ciphertext_len or result.secret.len != secret_len)
        return error.LibcryptoFailed;
    return .{ .ciphertext = result.ciphertext, .secret = result.secret };
}

pub fn decapsulate(
    key: *const KeyHandle,
    ciphertext: []const u8,
    secret_out: []u8,
) Error![]u8 {
    const expected_ciphertext_len = key.parameter_set.ciphertextLen();
    const expected_secret_len = key.parameter_set.sharedSecretLen();
    if (ciphertext.len != expected_ciphertext_len) return error.MalformedKeyShare;
    if (secret_out.len < expected_secret_len) return error.BufferTooShort;
    const secret = try kem_impl.kemDecapsulate(
        key.parameter_set,
        key.key,
        ciphertext,
        secret_out[0..expected_secret_len],
    );
    if (secret.len != expected_secret_len) return error.LibcryptoFailed;
    return secret;
}

// RFC 10024 §4 and FIPS 203 — each provider-backed parameter set must produce
// an encapsulation key and a fixed-size ciphertext that round-trips to the same
// 32-byte shared secret.
test "ML-KEM-768 encapsulate/decapsulate round-trip" {
    try testRoundTrip(.mlkem768);
}

// RFC 10024 §4 and FIPS 203 — ML-KEM-1024 uses its distinct fixed public-key
// and ciphertext sizes while retaining a 32-byte shared secret.
test "ML-KEM-1024 encapsulate/decapsulate round-trip" {
    try testRoundTrip(.mlkem1024);
}

fn testRoundTrip(parameter_set: ParameterSet) !void {
    const group: kex.NamedGroup = switch (parameter_set) {
        .mlkem768 => .x25519_mlkem768,
        .mlkem1024 => .secp384r1_mlkem1024,
    };
    if (!backend.supportsClientHybridGroup(group)) return error.SkipZigTest;

    var client_key = try generate(parameter_set);
    defer client_key.deinit();

    var public_key_buf: [max_public_key_len]u8 = undefined;
    const client_public = try publicKey(&client_key, &public_key_buf);
    try testing.expectEqual(@as(usize, parameter_set.publicKeyLen()), client_public.len);

    var peer = try loadPeerPublic(parameter_set, client_public);
    defer peer.deinit();

    var ciphertext_buf: [max_ciphertext_len]u8 = undefined;
    var server_secret_buf: [max_shared_secret_len]u8 = undefined;
    defer std.crypto.secureZero(u8, &server_secret_buf);
    const result = try encapsulate(&peer, &ciphertext_buf, &server_secret_buf);
    try testing.expectEqual(@as(usize, parameter_set.ciphertextLen()), result.ciphertext.len);
    try testing.expectEqual(@as(usize, parameter_set.sharedSecretLen()), result.secret.len);

    var client_secret_buf: [max_shared_secret_len]u8 = undefined;
    defer std.crypto.secureZero(u8, &client_secret_buf);
    const client_secret = try decapsulate(
        &client_key,
        result.ciphertext,
        &client_secret_buf,
    );
    try testing.expectEqualSlices(u8, result.secret, client_secret);
}

// RFC 10024 §4.2 — the client rejects a ciphertext whose length does not
// exactly match the selected group's ML-KEM parameter set before decapsulation.
test "ML-KEM rejects a wrong-length ciphertext" {
    if (!backend.supportsClientHybridGroup(.x25519_mlkem768))
        return error.SkipZigTest;
    var key = try generate(.mlkem768);
    defer key.deinit();
    var secret: [max_shared_secret_len]u8 = undefined;
    try testing.expectError(error.MalformedKeyShare, decapsulate(
        &key,
        &[_]u8{0} ** (ParameterSet.mlkem768.ciphertextLen() - 1),
        &secret,
    ));
}
