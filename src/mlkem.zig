//! ML-KEM hybrid key exchange for TLS 1.3.
//!
//! Wraps the backend KEM API (encapsulate/decapsulate) for the
//! X25519MLKEM768 named group (draft-ietf-tls-ecdhe-mlkem). Unlike ECDHE
//! (where both sides derive via sharedSecret), KEM is asymmetric:
//!   - The client generates a keypair and sends the public key as key_share.
//!   - The server encapsulates using the client public, producing a ciphertext
//!     (sent as the server key_share) + a shared secret.
//!   - The client decapsulates using its private key + the server ciphertext.
//!
//! The shared secret (64 bytes for X25519MLKEM768 = 32 X25519 + 32 ML-KEM)
//! is the DHE input to the TLS 1.3 key schedule.
const std = @import("std");
const testing = std.testing;
const kem_impl = @import("crypto/backend.zig").kem_impl;
const NamedGroup = @import("kex.zig").NamedGroup;

const mlkem = @This();

pub const Error = kem_impl.Error;

/// X25519MLKEM768 public key (key_share) length.
/// draft-ietf-tls-ecdhe-mlkem-05 §3: 32 (X25519) + 1184 (ML-KEM-768 encap) = 1216.
pub const x25519_mlkem768_public_length: usize = 1216;

/// X25519MLKEM768 ciphertext (server key_share) length.
/// The ciphertext from EVP_PKEY_encapsulate is 1120 bytes.
pub const x25519_mlkem768_ciphertext_length: usize = 1120;

/// X25519MLKEM768 shared secret length.
/// 32 (X25519 ECDH) + 32 (ML-KEM) = 64.
pub const x25519_mlkem768_shared_secret_length: usize = 64;

/// X25519MLKEM768 private key length (raw, from EVP_PKEY_get_octet_string_param).
/// 2432 bytes in OpenSSL 3.6.
pub const x25519_mlkem768_private_length: usize = 2432;

/// Opaque backend key handle. Must be freed via deinit().
pub const KeyHandle = kem_impl.KemKey;

/// Opaque peer public key handle (for encapsulation). Must be freed.
pub const PeerHandle = kem_impl.KemPeerKey;

/// Generate an X25519MLKEM768 keypair. Caller must deinit the result.
pub fn generateX25519Mlkem768() Error!KeyHandle {
    return kem_impl.kemKeygen("X25519MLKEM768");
}

/// Extract the raw public key (TLS key_share bytes) from a key handle.
pub fn publicKey(key: KeyHandle, out: []u8) Error![]u8 {
    const public_key = try kem_impl.kemPublic(key, out);
    if (public_key.len != x25519_mlkem768_public_length)
        return error.LibcryptoFailed;
    return public_key;
}

/// Load a peer's raw public key for encapsulation. Caller must freeKey.
pub fn loadPeerPublic(pub_key: []const u8) Error!PeerHandle {
    if (pub_key.len != x25519_mlkem768_public_length)
        return error.LibcryptoFailed;
    return kem_impl.kemLoadPublic("X25519MLKEM768", pub_key);
}

/// Server: encapsulate using the client's public key.
/// Returns the ciphertext (server key_share) and the shared secret.
pub fn encapsulate(
    peer: PeerHandle,
    enc_out: []u8,
    sec_out: []u8,
) Error!struct { enc: []const u8, sec: []const u8 } {
    const r = try kem_impl.kemEncapsulate(peer, enc_out, sec_out);
    if (r.enc.len != x25519_mlkem768_ciphertext_length)
        return error.LibcryptoFailed;
    if (r.sec.len != x25519_mlkem768_shared_secret_length)
        return error.LibcryptoFailed;
    return .{ .enc = r.enc, .sec = r.sec };
}

/// Client: decapsulate using our private key + the server's ciphertext.
/// Returns the shared secret.
pub fn decapsulate(
    key: KeyHandle,
    enc: []const u8,
    sec_out: []u8,
) Error![]u8 {
    const secret = try kem_impl.kemDecapsulate(key, enc, sec_out);
    if (secret.len != x25519_mlkem768_shared_secret_length)
        return error.LibcryptoFailed;
    return secret;
}

pub fn freeKey(key: anytype) void {
    kem_impl.freeKey(key);
}

// RFC 8446 §4.2.8 + draft-ietf-tls-ecdhe-mlkem-05 — KEM round-trip: the
// server encapsulates using the client public key, the client decapsulates,
// and both derive the same shared secret. OpenSSL-only; AWS-LC returns
// LibcryptoFailed (the hybrid KEM keygen API isn't available yet).
test "X25519MLKEM768: encapsulate/decapsulate round-trip" {
    const backend = @import("crypto/backend.zig");
    if (!backend.supportsServerX25519Mlkem768()) return error.SkipZigTest;
    const client_key = try generateX25519Mlkem768();
    defer freeKey(client_key);

    var pub_buf: [x25519_mlkem768_public_length]u8 = undefined;
    const client_pub = try publicKey(client_key, &pub_buf);
    try testing.expectEqual(@as(usize, x25519_mlkem768_public_length), client_pub.len);

    const peer = try loadPeerPublic(client_pub);
    defer freeKey(peer);

    var enc_buf: [x25519_mlkem768_ciphertext_length + 64]u8 = undefined;
    var sec_buf: [x25519_mlkem768_shared_secret_length + 64]u8 = undefined;
    const result = try encapsulate(peer, &enc_buf, &sec_buf);
    try testing.expectEqual(x25519_mlkem768_ciphertext_length, result.enc.len);
    try testing.expectEqual(x25519_mlkem768_shared_secret_length, result.sec.len);

    var dec_sec: [x25519_mlkem768_shared_secret_length + 64]u8 = undefined;
    const client_sec = try decapsulate(client_key, result.enc, &dec_sec);
    try testing.expectEqual(x25519_mlkem768_shared_secret_length, client_sec.len);
    try testing.expectEqualSlices(u8, result.sec, client_sec);
}
