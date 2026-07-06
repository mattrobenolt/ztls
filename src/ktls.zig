//! Linux kernel TLS (kTLS) UAPI constants and struct layouts.
//!
//! These are pure data definitions from `include/uapi/linux/tls.h` — no
//! syscalls, no I/O. They are defined unconditionally (they're just bytes) so
//! non-Linux callers can compile kTLS packing code for key-logging/debug, but
//! the resulting structs are only meaningful with Linux `setsockopt(TLS_*)`,
//! which is Linux-only. The `pack*` helpers fold the salt/IV split and cipher
//! layout into the library so callers never handle the kernel struct layout or
//! the RFC 8446 §5.3 nonce split themselves.
//!
//! References:
//!   - https://docs.kernel.org/networking/tls.html
//!   - include/uapi/linux/tls.h
//!   - RFC 8446 §5.3 (per-record nonce / IV split), §7.1 (traffic key derivation)
const std = @import("std");
const testing = std.testing;

const RecordLayer = @import("RecordLayer.zig");
const KtlsInfo = RecordLayer.KtlsInfo;
const KtlsCipherType = RecordLayer.KtlsCipherType;

/// `SOL_TCP` (IPPROTO_TCP) for `setsockopt(fd, SOL_TCP, TCP_ULP, ...)`.
/// Kernel UAPI name kept verbatim for grep-ability against include/uapi/linux/tls.h.
// ziglint-ignore: Z006 -- kernel UAPI constant, matches include/uapi/linux/tls.h
pub const SOL_TCP: u32 = 6;
/// `TCP_ULP` socket option to install the TLS ULP. include/uapi/linux/tls.h.
// ziglint-ignore: Z006 -- kernel UAPI constant, matches include/uapi/linux/tls.h
pub const TCP_ULP: u32 = 31;
/// `SOL_TLS` = `IPPROTO_TCP + 256`. include/uapi/linux/tls.h.
// ziglint-ignore: Z006 -- kernel UAPI constant, matches include/uapi/linux/tls.h
pub const SOL_TLS: u32 = 282;
/// `TLS_TX` direction: install the transmit traffic key.
// ziglint-ignore: Z006 -- kernel UAPI constant, matches include/uapi/linux/tls.h
pub const TLS_TX: u32 = 1;
/// `TLS_RX` direction: install the receive traffic key.
// ziglint-ignore: Z006 -- kernel UAPI constant, matches include/uapi/linux/tls.h
pub const TLS_RX: u32 = 2;

/// `TLS_1_3_VERSION` (0x0304) for `tls_crypto_info.version`.
// ziglint-ignore: Z006 -- kernel UAPI constant, matches include/uapi/linux/tls.h
pub const TLS_1_3_VERSION: u16 = 0x0304;

/// `tls_cipher_type` values from include/uapi/linux/tls.h. These mirror
/// `RecordLayer.KtlsCipherType` but are the raw kernel UAPI integers.
// ziglint-ignore: Z006 -- kernel UAPI constant, matches include/uapi/linux/tls.h
pub const TLS_CIPHER_AES_GCM_128: u16 = 51;
// ziglint-ignore: Z006 -- kernel UAPI constant, matches include/uapi/linux/tls.h
pub const TLS_CIPHER_AES_GCM_256: u16 = 52;
// ziglint-ignore: Z006 -- kernel UAPI constant, matches include/uapi/linux/tls.h
pub const TLS_CIPHER_CHACHA20_POLY1305: u16 = 54;

/// `struct tls_crypto_info` from include/uapi/linux/tls.h.
pub const TlsCryptoInfo = extern struct {
    version: u16,
    cipher_type: u16,
};

/// `struct tls12_crypto_info_aes_gcm_128` from include/uapi/linux/tls.h.
/// The 12-byte TLS 1.3 IV splits into `salt[4]` (first 4 bytes) and `iv[8]`
/// (last 8 bytes); the kernel reconstructs the per-record nonce as
/// `salt || iv XOR seq` (RFC 8446 §5.3).
pub const Tls12CryptoInfoAesGcm128 = extern struct {
    info: TlsCryptoInfo,
    iv: [8]u8,
    key: [16]u8,
    salt: [4]u8,
    rec_seq: [8]u8,
};

/// `struct tls12_crypto_info_aes_gcm_256` from include/uapi/linux/tls.h.
pub const Tls12CryptoInfoAesGcm256 = extern struct {
    info: TlsCryptoInfo,
    iv: [8]u8,
    key: [32]u8,
    salt: [4]u8,
    rec_seq: [8]u8,
};

/// `struct tls12_crypto_info_chacha20_poly1305` from include/uapi/linux/tls.h.
/// ChaCha20-Poly1305 has no salt/IV split: the full 12-byte IV goes in `iv`,
/// and `salt` is omitted (size 0).
pub const Tls12CryptoInfoChaCha20Poly1305 = extern struct {
    info: TlsCryptoInfo,
    iv: [12]u8,
    key: [32]u8,
    /// ChaCha20-Poly1305 uses an 8-byte rec_seq in the kernel struct even
    /// though the TLS 1.3 IV is 12 bytes; the nonce is `iv XOR seq` over the
    /// last 8 bytes (RFC 8446 §5.3).
    rec_seq: [8]u8,
};

pub const PackError = error{CipherMismatch};

/// Pack a `KtlsInfo` into the AES-GCM-128 kernel struct. Returns an error if
/// the info's cipher type is not AES-GCM-128.
pub fn packAesGcm128(info: KtlsInfo) PackError!Tls12CryptoInfoAesGcm128 {
    if (info.cipher_type != .aes_gcm_128) return error.CipherMismatch;
    return .{
        .info = .{ .version = info.version, .cipher_type = @intFromEnum(info.cipher_type) },
        .iv = info.iv[0..8].*,
        .key = info.key[0..16].*,
        .salt = info.salt[0..4].*,
        .rec_seq = info.rec_seq,
    };
}

/// Pack a `KtlsInfo` into the AES-GCM-256 kernel struct.
pub fn packAesGcm256(info: KtlsInfo) PackError!Tls12CryptoInfoAesGcm256 {
    if (info.cipher_type != .aes_gcm_256) return error.CipherMismatch;
    return .{
        .info = .{ .version = info.version, .cipher_type = @intFromEnum(info.cipher_type) },
        .iv = info.iv[0..8].*,
        .key = info.key[0..32].*,
        .salt = info.salt[0..4].*,
        .rec_seq = info.rec_seq,
    };
}

/// Pack a `KtlsInfo` into the ChaCha20-Poly1305 kernel struct. ChaCha20 uses
/// the full 12-byte IV with no salt.
pub fn packChaCha20Poly1305(info: KtlsInfo) PackError!Tls12CryptoInfoChaCha20Poly1305 {
    if (info.cipher_type != .chacha20_poly1305) return error.CipherMismatch;
    return .{
        .info = .{ .version = info.version, .cipher_type = @intFromEnum(info.cipher_type) },
        .iv = info.iv[0..12].*,
        .key = info.key[0..32].*,
        .rec_seq = info.rec_seq,
    };
}

// include/uapi/linux/tls.h — kernel UAPI cipher_type values match the ztls
// KtlsCipherType enum integers.
test "kernel cipher_type values match KtlsCipherType" {
    try testing.expectEqual(@as(u16, 51), @intFromEnum(KtlsCipherType.aes_gcm_128));
    try testing.expectEqual(@as(u16, 52), @intFromEnum(KtlsCipherType.aes_gcm_256));
    try testing.expectEqual(@as(u16, 54), @intFromEnum(KtlsCipherType.chacha20_poly1305));
    try testing.expectEqual(TLS_CIPHER_AES_GCM_128, @intFromEnum(KtlsCipherType.aes_gcm_128));
    try testing.expectEqual(TLS_CIPHER_AES_GCM_256, @intFromEnum(KtlsCipherType.aes_gcm_256));
    try testing.expectEqual(
        TLS_CIPHER_CHACHA20_POLY1305,
        @intFromEnum(KtlsCipherType.chacha20_poly1305),
    );
}

// include/uapi/linux/tls.h — SOL_TLS = IPPROTO_TCP + 256, TLS_TX=1, TLS_RX=2.
test "kernel socket option constants" {
    try testing.expectEqual(@as(u32, 282), SOL_TLS);
    try testing.expectEqual(@as(u32, 31), TCP_ULP);
    try testing.expectEqual(@as(u32, 1), TLS_TX);
    try testing.expectEqual(@as(u32, 2), TLS_RX);
    try testing.expectEqual(@as(u16, 0x0304), TLS_1_3_VERSION);
}

// RFC 8446 §5.3 — the AES-GCM pack splits the 12-byte IV into salt[4] + iv[8];
// the kernel reconstructs the nonce as salt || iv XOR seq.
test "packAesGcm128 splits the 12-byte IV and copies key/seq" {
    var info: KtlsInfo = .{
        .cipher_type = .aes_gcm_128,
        .key_len = 16,
        .salt_len = 4,
        .iv_len = 8,
        .rec_seq = .{ 0, 0, 0, 0, 0, 0, 0, 5 },
    };
    info.key[0..16].* = [_]u8{0xaa} ** 16;
    info.salt = .{ 0x01, 0x02, 0x03, 0x04 };
    info.iv[0..8].* = .{ 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c };

    const out = try packAesGcm128(info);
    try testing.expectEqual(@as(u16, 0x0304), out.info.version);
    try testing.expectEqual(TLS_CIPHER_AES_GCM_128, out.info.cipher_type);
    try testing.expectEqualSlices(u8, &.{ 0x01, 0x02, 0x03, 0x04 }, &out.salt);
    try testing.expectEqualSlices(
        u8,
        &.{ 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c },
        &out.iv,
    );
    try testing.expectEqualSlices(u8, &([_]u8{0xaa} ** 16), &out.key);
    try testing.expectEqualSlices(u8, &info.rec_seq, &out.rec_seq);
}

test "packAesGcm128 rejects a non-AES-GCM-128 info" {
    var info: KtlsInfo = .{
        .cipher_type = .aes_gcm_256,
        .key_len = 32,
        .salt_len = 4,
        .iv_len = 8,
        .rec_seq = .{0} ** 8,
    };
    info.key[0..32].* = [_]u8{0xbb} ** 32;
    info.salt = .{ 0, 0, 0, 0 };
    info.iv[0..8].* = .{0} ** 8;
    try testing.expectError(error.CipherMismatch, packAesGcm128(info));
}

// RFC 8446 §5.3 — ChaCha20-Poly1305 uses the full 12-byte IV with no salt.
test "packChaCha20Poly1305 uses the full 12-byte IV" {
    var info: KtlsInfo = .{
        .cipher_type = .chacha20_poly1305,
        .key_len = 32,
        .salt_len = 0,
        .iv_len = 12,
        .rec_seq = .{ 0, 0, 0, 0, 0, 0, 0, 9 },
    };
    info.key[0..32].* = [_]u8{0xcc} ** 32;
    info.iv = .{ 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b };

    const out = try packChaCha20Poly1305(info);
    try testing.expectEqual(TLS_CIPHER_CHACHA20_POLY1305, out.info.cipher_type);
    try testing.expectEqualSlices(u8, &info.iv, &out.iv);
    try testing.expectEqualSlices(u8, &([_]u8{0xcc} ** 32), &out.key);
    try testing.expectEqualSlices(u8, &info.rec_seq, &out.rec_seq);
}

test "packAesGcm256 copies the 32-byte key and splits the IV" {
    var info: KtlsInfo = .{
        .cipher_type = .aes_gcm_256,
        .key_len = 32,
        .salt_len = 4,
        .iv_len = 8,
        .rec_seq = .{0} ** 8,
    };
    info.key[0..32].* = [_]u8{0xdd} ** 32;
    info.salt = .{ 0xa, 0xb, 0xc, 0xd };
    info.iv[0..8].* = .{ 0xe, 0xf, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15 };

    const out = try packAesGcm256(info);
    try testing.expectEqual(TLS_CIPHER_AES_GCM_256, out.info.cipher_type);
    try testing.expectEqualSlices(u8, &([_]u8{0xdd} ** 32), &out.key);
    try testing.expectEqualSlices(u8, &info.salt, &out.salt);
    try testing.expectEqualSlices(u8, &info.iv[0..8].*, &out.iv);
}
