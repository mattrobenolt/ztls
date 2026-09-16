//! Linux kernel TLS (kTLS) UAPI: the constants and struct layouts, the
//! `TCP_ULP`/`TLS_TX`/`TLS_RX` installs, and the record-type cmsg framing
//! that carries control records.
//!
//! The constants and structs are pure data definitions from
//! `include/uapi/linux/tls.h`, defined unconditionally (they're just bytes)
//! so non-Linux callers can compile kTLS packing and framing code for
//! key-logging/debug. The `pack*` helpers fold the salt/IV split and cipher
//! layout into the library so callers never handle the kernel struct layout
//! or the RFC 8446 §5.3 nonce split themselves; the cmsg encoder and parser
//! are likewise pure buffer shaping.
//!
//! The install helpers call `linux.setsockopt`, never `std.posix.setsockopt`:
//! the posix wrapper maps EINVAL to `unreachable`, and EINVAL is a legitimate
//! answer for this API (a `tls_crypto_info.version` or `cipher_type` the
//! kernel does not know). In ReleaseFast that `unreachable` is UB; a typed
//! error is not. Every errno decode here is total. The installs are
//! meaningful only with Linux `setsockopt(TLS_*)`; on other targets they
//! compile but report `error.Unavailable`, the contract's "stay in
//! userspace TLS" signal.
//!
//! Install ordering is caller-owned: the kernel accepts TX and RX installs
//! independently (either alone, in either order), so "TX after the server
//! flight, RX after the client Finished, rekey on KeyUpdate" is policy this
//! module does not enforce.
//!
//! References:
//!   - https://docs.kernel.org/networking/tls.html
//!   - include/uapi/linux/tls.h
//!   - RFC 8446 §5.3 (per-record nonce / IV split), §7.1 (traffic key derivation)
const std = @import("std");
const builtin = @import("builtin");
const testing = std.testing;
const linux = std.os.linux;
const posix = std.posix;

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
/// Ancillary-data type used to select a non-application TLS TX record.
// ziglint-ignore: Z006 -- kernel UAPI constant, matches include/uapi/linux/tls.h
pub const TLS_SET_RECORD_TYPE: u32 = 1;
/// Ancillary-data type carrying the decrypted TLS RX record type.
// ziglint-ignore: Z006 -- kernel UAPI constant, matches include/uapi/linux/tls.h
pub const TLS_GET_RECORD_TYPE: u32 = 2;

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

    /// Erase the packed key material and invalidate this value.
    pub fn secureZero(self: *Tls12CryptoInfoAesGcm128) void {
        std.crypto.secureZero(u8, std.mem.asBytes(self));
    }
};

/// `struct tls12_crypto_info_aes_gcm_256` from include/uapi/linux/tls.h.
pub const Tls12CryptoInfoAesGcm256 = extern struct {
    info: TlsCryptoInfo,
    iv: [8]u8,
    key: [32]u8,
    salt: [4]u8,
    rec_seq: [8]u8,

    /// Erase the packed key material and invalidate this value.
    pub fn secureZero(self: *Tls12CryptoInfoAesGcm256) void {
        std.crypto.secureZero(u8, std.mem.asBytes(self));
    }
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

    /// Erase the packed key material and invalidate this value.
    pub fn secureZero(self: *Tls12CryptoInfoChaCha20Poly1305) void {
        std.crypto.secureZero(u8, std.mem.asBytes(self));
    }
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

/// A TLS content type (RFC 8446 §5.1): the byte a `TLS_SET_RECORD_TYPE` cmsg
/// selects and a `TLS_GET_RECORD_TYPE` cmsg reports. Left as the raw byte
/// because the content-type enum belongs to the TLS layer, not the UAPI.
pub const RecordType = u8;

/// Outcome of a kTLS option install.
pub const InstallError = error{
    /// This socket cannot do kTLS: no ULP named "tls" (ENOENT) or no TLS
    /// support at this level (ENOPROTOOPT / EPROTONOSUPPORT / EOPNOTSUPP).
    /// The caller's signal to stay in userspace TLS. ENOPROTOOPT is also
    /// what a TLS_TX/TLS_RX install reports when the ULP was never attached,
    /// since the socket then has no TLS level at all — and it is the answer
    /// on non-Linux targets, where no socket can do kTLS.
    Unavailable,
    /// kTLS is present but the socket forbids the install right now: EBUSY,
    /// which the kernel returns when a TLS_TX rekey races records in flight.
    Busy,
    /// Everything else, EINVAL included: a crypto-info the kernel cannot use
    /// (EINVAL), a socket that is not ESTABLISHED (ENOTCONN), a second ULP
    /// attach (EEXIST). A programming error or a dead socket — no fallback.
    Failed,
};

/// The ULP name the kernel matches. The terminator is passed explicitly:
/// upstream has written its own NUL at `optlen - 1`, which would truncate the
/// name to "tl" if the length were exactly 3. The NUL-terminated form is
/// correct on both readings.
const tls_ulp_name = "tls\x00";

/// Attach the `"tls"` ULP; every `TLS_*` option install requires it.
///
/// The kernel attaches only in `TCP_ESTABLISHED` and only once. Attach before
/// the first userspace read: plaintext already pulled off the socket cannot
/// be told apart from a TLS record afterwards (see `parseRecordType`).
pub fn ulpInstall(fd: posix.socket_t) InstallError!void {
    if (comptime builtin.os.tag != .linux) return error.Unavailable;
    return decodeInstallErrno(syscallErrno(linux.setsockopt(
        fd,
        @intCast(SOL_TCP),
        TCP_ULP,
        tls_ulp_name.ptr,
        tls_ulp_name.len,
    )));
}

/// Install the transmit key (`TLS_TX`).
pub fn txInstall(fd: posix.socket_t, info: *const Tls12CryptoInfoAesGcm128) InstallError!void {
    return installCryptoInfo(fd, TLS_TX, std.mem.asBytes(info));
}

/// Install the receive key (`TLS_RX`).
pub fn rxInstall(fd: posix.socket_t, info: *const Tls12CryptoInfoAesGcm128) InstallError!void {
    return installCryptoInfo(fd, TLS_RX, std.mem.asBytes(info));
}

/// Install a packed crypto-info struct for `direction` (`TLS_TX` or
/// `TLS_RX`). The kernel selects the cipher layout from the option length,
/// so `crypto_info` is the bytes of one of the `Tls12CryptoInfo*` structs;
/// prefer the typed `txInstall`/`rxInstall` when the cipher is AES-GCM-128.
pub fn installCryptoInfo(
    fd: posix.socket_t,
    direction: u32,
    crypto_info: []const u8,
) InstallError!void {
    if (comptime builtin.os.tag != .linux) return error.Unavailable;
    return decodeInstallErrno(syscallErrno(linux.setsockopt(
        fd,
        @intCast(SOL_TLS),
        direction,
        crypto_info.ptr,
        @intCast(crypto_info.len),
    )));
}

/// Decode a raw syscall return into its errno. `std.os.linux.errno` is
/// public only on Zig >= 0.16, and `std.posix.errno` misreads raw syscall
/// returns when libc is linked (ztls links libc): it expects the libc
/// -1-plus-errno convention, not the kernel's -errno return. The decode
/// below is byte-identical to both std versions' own.
fn syscallErrno(rc: usize) linux.E {
    const signed: isize = @bitCast(rc);
    const int = if (signed > -4096 and signed < 0) -signed else 0;
    return @enumFromInt(int);
}

/// Compress a kTLS setsockopt errno onto the install outcome. Total by
/// construction: an unmapped errno is `Failed`, never a panic.
fn decodeInstallErrno(e: linux.E) InstallError!void {
    return switch (e) {
        .SUCCESS => {},
        .NOENT, .NOPROTOOPT, .PROTONOSUPPORT, .OPNOTSUPP => error.Unavailable,
        .BUSY => error.Busy,
        else => error.Failed,
    };
}

/// `struct cmsghdr` (include/linux/socket.h): the ancillary-data header the
/// record-type cmsgs ride in. Transcribed like the tls.h layouts above
/// because `std.os.linux.cmsghdr` exists only on Zig >= 0.16 and the layout
/// is kernel-frozen; the comptime block below cross-checks the transcription
/// where std names the struct.
pub const cmsghdr = extern struct {
    /// The kernel and glibc use `usize` for this field; musl uses `socklen_t`.
    len: usize,
    level: i32,
    type: i32,
};

comptime {
    if (@hasDecl(linux, "cmsghdr")) {
        std.debug.assert(@sizeOf(cmsghdr) == @sizeOf(linux.cmsghdr));
        std.debug.assert(@alignOf(cmsghdr) == @alignOf(linux.cmsghdr));
        std.debug.assert(@offsetOf(cmsghdr, "len") == @offsetOf(linux.cmsghdr, "len"));
        std.debug.assert(@offsetOf(cmsghdr, "level") == @offsetOf(linux.cmsghdr, "level"));
        std.debug.assert(@offsetOf(cmsghdr, "type") == @offsetOf(linux.cmsghdr, "type"));
    }
}

/// `CMSG_ALIGN(sizeof(struct cmsghdr))`: a cmsghdr is 16 bytes on 64-bit and
/// cmsg data starts at the next word boundary.
const cmsg_data_offset = std.mem.alignForward(usize, @sizeOf(cmsghdr), @sizeOf(usize));

/// `CMSG_LEN(sizeof(u8))`: the `cmsg_len` of a one-byte record-type cmsg.
const cmsg_len = cmsg_data_offset + 1;

/// `CMSG_SPACE(sizeof(u8))`: the control buffer one record-type cmsg needs,
/// padding included. kTLS reports `controllen == 24` for such a cmsg, so the
/// receive buffer must be at least this large even though the cmsg is 17 long.
pub const control_space = std.mem.alignForward(usize, cmsg_len, @sizeOf(usize));

/// A control buffer for one record-type cmsg. Wrapped in a struct because the
/// buffer has to be as aligned as `struct cmsghdr` and Zig cannot express an
/// alignment on an array type alias; `bytes` is the `msghdr.control` target.
pub const ControlBuffer = struct {
    bytes: [control_space]u8 align(@alignOf(cmsghdr)) = @splat(0),
};

/// Encode a `TLS_SET_RECORD_TYPE` cmsg selecting `content_type` for the
/// record `sendmsg` is about to write. Returns the buffer as the
/// `msghdr.control` / `msg_controllen` pair, padding zeroed.
///
/// The kernel refuses any other cmsg on a kTLS socket with EINVAL, so there
/// is deliberately no way to pass a different level or cmsg type.
pub fn encodeRecordType(buf: *ControlBuffer, content_type: RecordType) []u8 {
    // @memset, not crypto.secureZero, and deliberately so: nothing here is
    // ever secret — the cmsg is UAPI constants plus the record type (a
    // protocol-public value that rides every TLS record's inner content
    // type in the clear), and the padding never leaves the kernel's
    // copyin. The zeroing is contract hygiene: deterministic framing bytes
    // into a buffer the kernel validates. The store is also non-elidable
    // in practice (the pointer escapes into the sendmsg wrapper), but the
    // content class is the reason.
    @memset(&buf.bytes, 0);
    const header: *cmsghdr = @ptrCast(&buf.bytes);
    header.* = .{
        .len = cmsg_len,
        .level = SOL_TLS,
        .type = TLS_SET_RECORD_TYPE,
    };
    buf.bytes[cmsg_data_offset] = content_type;
    return &buf.bytes;
}

pub const ParseError = error{InvalidControlMessage};

/// Record type from the control buffer a kTLS `recvmsg` filled, or null when
/// the kernel attached no cmsg at all.
///
/// kTLS reports the type of every record it decrypts, attaching the cmsg to
/// the *first* bytes of the record; `MSG_EOR` is set only on the recv that
/// consumes the record's final byte. A record larger than the caller's read
/// buffer therefore legitimately yields cmsg-present + EOR-clear, so EOR is
/// deliberately NOT required here — record completion is the caller's to
/// track from `msg_flags`, and guarding split control records is caller
/// policy. Control data that breaks the framing contract is an error, never
/// a guess: bytes whose record type was never reported cannot be classified,
/// and guessing desynchronizes the record layer. A null return with bytes
/// received means the kernel attached no cmsg at all — plaintext that
/// reached the socket buffer before the ULP attach.
pub fn parseRecordType(control: []const u8, flags: u32) ParseError!?RecordType {
    if (flags & (linux.MSG.CTRUNC | linux.MSG.TRUNC) != 0) {
        return error.InvalidControlMessage;
    }
    if (control.len == 0) return null;
    if (control.len < cmsg_len) return error.InvalidControlMessage;

    // Bit-cast instead of @ptrCast: the cmsg is only promised to live inside
    // `control`, and an unaligned caller buffer must not become an
    // @alignCast panic in safe builds.
    const header: cmsghdr = @bitCast(control[0..@sizeOf(cmsghdr)].*);
    if (header.len < cmsg_len or
        header.len > control.len or
        header.level != SOL_TLS or
        header.type != TLS_GET_RECORD_TYPE)
    {
        return error.InvalidControlMessage;
    }
    return control[cmsg_data_offset];
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
    try testing.expectEqual(@as(u32, 1), TLS_SET_RECORD_TYPE);
    try testing.expectEqual(@as(u32, 2), TLS_GET_RECORD_TYPE);
    try testing.expectEqual(@as(u16, 0x0304), TLS_1_3_VERSION);
}

test "packed kTLS info secureZero methods erase every byte" {
    inline for (.{
        Tls12CryptoInfoAesGcm128,
        Tls12CryptoInfoAesGcm256,
        Tls12CryptoInfoChaCha20Poly1305,
    }) |T| {
        var info: T = undefined;
        @memset(std.mem.asBytes(&info), 0xab);
        info.secureZero();
        try testing.expect(std.mem.allEqual(u8, std.mem.asBytes(&info), 0));
    }
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
    defer info.secureZero();
    info.key[0..16].* = [_]u8{0xaa} ** 16;
    info.salt = .{ 0x01, 0x02, 0x03, 0x04 };
    info.iv[0..8].* = .{ 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c };

    var out = try packAesGcm128(info);
    defer out.secureZero();
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
    defer info.secureZero();
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
    defer info.secureZero();
    info.key[0..32].* = [_]u8{0xcc} ** 32;
    info.iv = .{ 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b };

    var out = try packChaCha20Poly1305(info);
    defer out.secureZero();
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
    defer info.secureZero();
    info.key[0..32].* = [_]u8{0xdd} ** 32;
    info.salt = .{ 0xa, 0xb, 0xc, 0xd };
    info.iv[0..8].* = .{ 0xe, 0xf, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15 };

    var out = try packAesGcm256(info);
    defer out.secureZero();
    try testing.expectEqual(TLS_CIPHER_AES_GCM_256, out.info.cipher_type);
    try testing.expectEqualSlices(u8, &([_]u8{0xdd} ** 32), &out.key);
    try testing.expectEqualSlices(u8, &info.salt, &out.salt);
    try testing.expectEqualSlices(u8, &info.iv[0..8].*, &out.iv);
}

// The errno decode is the contract: total, with EINVAL an ordinary value (a
// crypto_info the kernel cannot use), never a panic.
test "install errno decode maps onto InstallError" {
    try decodeInstallErrno(.SUCCESS);
    try testing.expectError(error.Unavailable, decodeInstallErrno(.NOENT));
    try testing.expectError(error.Unavailable, decodeInstallErrno(.NOPROTOOPT));
    try testing.expectError(error.Unavailable, decodeInstallErrno(.PROTONOSUPPORT));
    try testing.expectError(error.Unavailable, decodeInstallErrno(.OPNOTSUPP));
    try testing.expectError(error.Busy, decodeInstallErrno(.BUSY));
    try testing.expectError(error.Failed, decodeInstallErrno(.INVAL));
    try testing.expectError(error.Failed, decodeInstallErrno(.NOTCONN));
    try testing.expectError(error.Failed, decodeInstallErrno(.EXIST));
}

test "a record-type cmsg occupies the kernel's CMSG_LEN and CMSG_SPACE" {
    try testing.expectEqual(@as(usize, 16), @sizeOf(cmsghdr));
    try testing.expectEqual(@as(usize, 16), cmsg_data_offset);
    try testing.expectEqual(@as(usize, 17), cmsg_len);
    try testing.expectEqual(@as(usize, 24), control_space);
    try testing.expectEqual(@alignOf(cmsghdr), @alignOf(ControlBuffer));
}

test "encodeRecordType writes one cmsg and zeroes the padding" {
    var control: ControlBuffer = .{ .bytes = @splat(0xaa) };
    const bytes = encodeRecordType(&control, 21);
    try testing.expectEqual(control_space, bytes.len);

    const header: cmsghdr = @bitCast(bytes[0..@sizeOf(cmsghdr)].*);
    try testing.expectEqual(cmsg_len, header.len);
    try testing.expectEqual(@as(i32, SOL_TLS), header.level);
    try testing.expectEqual(@as(i32, TLS_SET_RECORD_TYPE), header.type);
    try testing.expectEqual(@as(RecordType, 21), bytes[cmsg_data_offset]);
    try testing.expect(std.mem.allEqual(u8, bytes[cmsg_len..], 0));
}

test "parseRecordType rejects control data off the kTLS contract" {
    // No cmsg: the kernel consumed no record, so there is no type to report.
    try testing.expectEqual(
        @as(?RecordType, null),
        try parseRecordType(&.{}, linux.MSG.EOR),
    );

    var control: ControlBuffer = .{};
    const encoded = encodeRecordType(&control, 23);
    const header: *cmsghdr = @ptrCast(&control.bytes);

    // The encoder builds a send-side cmsg; receiving never sees one.
    try testing.expectError(
        error.InvalidControlMessage,
        parseRecordType(encoded, linux.MSG.EOR),
    );
    // What the kernel reports instead: a GET cmsg of length CMSG_LEN(1).
    header.type = TLS_GET_RECORD_TYPE;
    try testing.expectEqual(
        @as(?RecordType, 23),
        try parseRecordType(&control.bytes, linux.MSG.EOR),
    );

    // Truncated at the cmsg level and at the buffer level.
    try testing.expectError(
        error.InvalidControlMessage,
        parseRecordType(control.bytes[0 .. cmsg_len - 1], linux.MSG.EOR),
    );
    try testing.expectError(
        error.InvalidControlMessage,
        parseRecordType(&control.bytes, linux.MSG.EOR | linux.MSG.CTRUNC),
    );
    // First chunk of a record larger than the read buffer: cmsg present,
    // EOR clear — a valid prefix read, not a contract violation (the caller
    // tracks record completion from msg_flags).
    try testing.expectEqual(@as(?RecordType, 23), parseRecordType(&control.bytes, 0));

    // A len that claims more than the control buffer holds, then a level the
    // kernel never uses for a report.
    header.len = control_space + 1;
    try testing.expectError(
        error.InvalidControlMessage,
        parseRecordType(&control.bytes, linux.MSG.EOR),
    );
    header.len = cmsg_len;
    header.level = SOL_TCP;
    try testing.expectError(
        error.InvalidControlMessage,
        parseRecordType(&control.bytes, linux.MSG.EOR),
    );
}

/// A connected loopback TCP pair. kTLS attaches only in TCP_ESTABLISHED, so
/// the connecting socket stays open for the fixture's lifetime: a peer FIN
/// moves the accepted socket to CLOSE_WAIT, where the ULP attach answers
/// ENOTCONN.
const Loopback = struct {
    /// Accepted socket: the one kTLS installs on.
    server: posix.socket_t,
    /// Connecting socket, held open to keep the pair established.
    client: posix.socket_t,

    fn init() error{HostSetupFailed}!Loopback {
        const listener: posix.socket_t = @intCast(try hostCall(linux.socket(
            linux.AF.INET,
            linux.SOCK.STREAM | linux.SOCK.CLOEXEC,
            0,
        )));
        errdefer _ = linux.close(listener);
        var addr: linux.sockaddr.in = .{
            .port = std.mem.nativeToBig(u16, 0),
            .addr = std.mem.nativeToBig(u32, 0x7F000001),
        };
        _ = try hostCall(linux.bind(listener, @ptrCast(&addr), @sizeOf(linux.sockaddr.in)));
        var addr_len: linux.socklen_t = @sizeOf(linux.sockaddr.in);
        _ = try hostCall(linux.getsockname(listener, @ptrCast(&addr), &addr_len));
        _ = try hostCall(linux.listen(listener, 1));

        const client: posix.socket_t = @intCast(try hostCall(linux.socket(
            linux.AF.INET,
            linux.SOCK.STREAM | linux.SOCK.CLOEXEC,
            0,
        )));
        errdefer _ = linux.close(client);
        _ = try hostCall(linux.connect(client, @ptrCast(&addr), @sizeOf(linux.sockaddr.in)));
        var peer_len: linux.socklen_t = @sizeOf(linux.sockaddr.in);
        const server: posix.socket_t = @intCast(try hostCall(linux.accept(
            listener,
            null,
            &peer_len,
        )));
        _ = linux.close(listener);
        return .{ .server = server, .client = client };
    }

    fn deinit(self: Loopback) void {
        _ = linux.close(self.server);
        _ = linux.close(self.client);
    }
};

/// Probe scaffolding: these socket calls cannot fail on a working Linux
/// host, so they collapse into one setup error rather than inventing an
/// errno vocabulary the probes would never assert on.
fn hostCall(rc: usize) error{HostSetupFailed}!usize {
    return if (syscallErrno(rc) == .SUCCESS) rc else error.HostSetupFailed;
}

/// A synthetic TLS 1.3 AES-128-GCM key. The kernel checks the struct shape
/// at install and derives no key schedule until a record moves. Both
/// directions of the round-trip probe share these bytes so one side
/// encrypts what the other decrypts.
fn testKey() Tls12CryptoInfoAesGcm128 {
    return .{
        .info = .{ .version = TLS_1_3_VERSION, .cipher_type = TLS_CIPHER_AES_GCM_128 },
        .iv = @splat(0x11),
        .key = @splat(0x22),
        .salt = @splat(0x33),
        .rec_seq = @splat(0),
    };
}

/// Gate for the live probes: attach the ULP, or skip when this kernel has
/// no TLS ULP at all (module unloaded, kTLS configured out) — the same
/// discipline the ztls-ktls integration's live tests use.
fn skipUnlessUlp(fd: posix.socket_t) (InstallError || error{SkipZigTest})!void {
    ulpInstall(fd) catch |err| switch (err) {
        error.Unavailable => return error.SkipZigTest,
        else => |e| return e,
    };
}

test "ulpInstall attaches once, and only to an established TCP socket" {
    if (builtin.os.tag != .linux) return error.SkipZigTest;

    // ENOTCONN: tls_init refuses sockets that have not completed a
    // handshake.
    const bare: posix.socket_t = @intCast(try hostCall(linux.socket(
        linux.AF.INET,
        linux.SOCK.STREAM | linux.SOCK.CLOEXEC,
        0,
    )));
    defer _ = linux.close(bare);
    ulpInstall(bare) catch |err| switch (err) {
        error.Unavailable => return error.SkipZigTest,
        error.Busy => return error.TestUnexpectedResult,
        error.Failed => {},
    };

    const pair = try Loopback.init();
    defer pair.deinit();
    try skipUnlessUlp(pair.server);
    // EEXIST: the ULP is on the socket now, so this is a typed failure
    // rather than a second attach.
    try testing.expectError(error.Failed, ulpInstall(pair.server));
}

test "txInstall and rxInstall accept a synthetic TLS 1.3 AES-128-GCM key" {
    if (builtin.os.tag != .linux) return error.SkipZigTest;
    const pair = try Loopback.init();
    defer pair.deinit();
    try skipUnlessUlp(pair.server);

    var info = testKey();
    defer info.secureZero();
    try txInstall(pair.server, &info);
    try rxInstall(pair.server, &info);
}

test "installs without the ULP are typed Unavailable errors, not panics" {
    if (builtin.os.tag != .linux) return error.SkipZigTest;
    const pair = try Loopback.init();
    defer pair.deinit();

    var info = testKey();
    defer info.secureZero();
    // ENOPROTOOPT: without an attached ULP the socket has no TLS level, so
    // the option never reaches a handler — kTLS is not usable on this
    // socket, with or without the kernel module loaded.
    try testing.expectError(error.Unavailable, txInstall(pair.server, &info));
    try testing.expectError(error.Unavailable, rxInstall(pair.server, &info));
}

test "a crypto_info the kernel cannot use is a typed EINVAL failure" {
    if (builtin.os.tag != .linux) return error.SkipZigTest;
    const pair = try Loopback.init();
    defer pair.deinit();
    try skipUnlessUlp(pair.server);

    // EINVAL is the errno `std.posix.setsockopt` maps to `unreachable`; it
    // has to be an ordinary typed failure here, in every build mode.
    var wrong_version = testKey();
    defer wrong_version.secureZero();
    wrong_version.info.version = 0x0305; // TLS has no 0x03/0x05 major/minor pair
    try testing.expectError(error.Failed, txInstall(pair.server, &wrong_version));

    var wrong_cipher = testKey();
    defer wrong_cipher.secureZero();
    wrong_cipher.info.cipher_type = 99; // tls_cipher_type values are 51..58
    try testing.expectError(error.Failed, rxInstall(pair.server, &wrong_cipher));
}

test "record-type cmsg round-trips through a live kTLS pair" {
    if (builtin.os.tag != .linux) return error.SkipZigTest;
    const pair = try Loopback.init();
    defer pair.deinit();
    try skipUnlessUlp(pair.client);
    try skipUnlessUlp(pair.server);

    var info = testKey();
    defer info.secureZero();
    try txInstall(pair.client, &info);
    try rxInstall(pair.server, &info);

    const handshake: RecordType = 22; // RFC 8446 §5.1 content type
    var control: ControlBuffer = .{};
    const sent_control = encodeRecordType(&control, handshake);

    const payload = "ping";
    var send_iov: [1]posix.iovec_const = .{.{ .base = payload.ptr, .len = payload.len }};
    const send_msg: linux.msghdr_const = .{
        .name = null,
        .namelen = 0,
        .iov = &send_iov,
        .iovlen = send_iov.len,
        .control = @ptrCast(sent_control.ptr),
        .controllen = sent_control.len,
        .flags = 0,
    };
    try testing.expectEqual(
        payload.len,
        try hostCall(linux.sendmsg(pair.client, &send_msg, linux.MSG.NOSIGNAL)),
    );

    var plain: [64]u8 = @splat(0);
    var recv_control: ControlBuffer = .{};
    var recv_iov: [1]posix.iovec = .{.{ .base = &plain, .len = plain.len }};
    var recv_msg: linux.msghdr = .{
        .name = null,
        .namelen = 0,
        .iov = &recv_iov,
        .iovlen = recv_iov.len,
        .control = &recv_control.bytes,
        .controllen = recv_control.bytes.len,
        .flags = 0,
    };
    const received = try hostCall(linux.recvmsg(pair.server, &recv_msg, 0));
    try testing.expectEqual(payload.len, received);
    try testing.expectEqualStrings(payload, plain[0..received]);

    // The kernel's own report: CMSG_SPACE controllen, MSG_EOR, GET-type cmsg.
    try testing.expectEqual(control_space, recv_msg.controllen);
    try testing.expect(recv_msg.flags & linux.MSG.EOR != 0);
    const recv_header: cmsghdr = @bitCast(recv_control.bytes[0..@sizeOf(cmsghdr)].*);
    try testing.expectEqual(cmsg_len, recv_header.len);
    try testing.expectEqual(@as(i32, SOL_TLS), recv_header.level);
    try testing.expectEqual(@as(i32, TLS_GET_RECORD_TYPE), recv_header.type);
    try testing.expectEqual(
        @as(?RecordType, handshake),
        try parseRecordType(recv_control.bytes[0..recv_msg.controllen], recv_msg.flags),
    );
}
