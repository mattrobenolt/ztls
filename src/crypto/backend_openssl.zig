//! OpenSSL backend primitive wrappers.
const std = @import("std");

const c_openssl = @import("c_openssl.zig");
const c = c_openssl.openssl;
const is_boringssl_family = c_openssl.is_boringssl_family;
const CipherSuite = @import("../cipher_suite.zig").CipherSuite;
const ParameterSet = @import("mlkem_parameters.zig").ParameterSet;
const SignatureScheme = @import("../signature_scheme.zig").SignatureScheme;

pub const capabilities = struct {
    pub const cipher_suites: []const CipherSuite = &.{
        .aes_128_gcm_sha256,
        .aes_256_gcm_sha384,
        .chacha20_poly1305_sha256,
    };

    pub const client_x25519 = true;
    pub const client_p256 = true;
    pub const client_p384 = true;
    pub const client_x25519_mlkem768 = true;
    pub const client_secp256r1_mlkem768 = true;
    pub const client_secp384r1_mlkem1024 = true;
    pub const server_x25519 = true;
    pub const server_p256 = true;
    pub const server_p384 = true;
    pub const server_x25519_mlkem768 = true;
    pub const server_secp256r1_mlkem768 = true;
    pub const server_secp384r1_mlkem1024 = true;

    pub const certificate_verify_schemes: []const SignatureScheme = &.{
        .ecdsa_secp256r1_sha256,
        .ecdsa_secp384r1_sha384,
        .rsa_pss_rsae_sha256,
        .rsa_pss_rsae_sha384,
    };

    // RFC 8446 §4.4.2.2 — signature_algorithms_cert constrains the
    // certificate-chain signature algorithm (cert-to-cert), which is
    // independent of the CertificateVerify scheme (§4.4.3). Ed25519 chain
    // signatures are verified via std.crypto.sign.Ed25519 in
    // certificate_parser.zig, not the backend seam, so they are advertised
    // here even though certificate_verify_schemes omits ed25519.
    pub const certificate_signature_schemes: []const SignatureScheme = &.{
        .rsa_pkcs1_sha256,
        .rsa_pkcs1_sha384,
        .rsa_pkcs1_sha512,
        .ecdsa_secp256r1_sha256,
        .ecdsa_secp384r1_sha384,
        .ed25519,
    };
};

/// FIPS 140-3 narrowed capability table. `-Dcrypto-fips=true` selects this
/// table when OpenSSL headers are active. The caller is responsible for ensuring
/// the linked libcrypto is actually in FIPS mode (e.g. FIPS provider loaded).
/// No runtime provider probing is performed by ztls.
pub const capabilities_fips = struct {
    // FIPS 140-3 does not approve ChaCha20-Poly1305 for TLS 1.3.
    pub const cipher_suites: []const CipherSuite = &.{
        .aes_128_gcm_sha256,
        .aes_256_gcm_sha384,
    };

    pub const client_x25519 = true;
    pub const client_p256 = true;
    pub const client_p384 = true;
    // FIPS 140-3 does not approve ML-KEM (NIST FIPS 203 is not yet in the
    // 140-3 validated algorithms list as of 2026-07).
    pub const client_x25519_mlkem768 = false;
    pub const client_secp256r1_mlkem768 = false;
    pub const client_secp384r1_mlkem1024 = false;
    pub const server_x25519 = true;
    pub const server_p256 = true;
    pub const server_p384 = true;
    pub const server_x25519_mlkem768 = false;
    pub const server_secp256r1_mlkem768 = false;
    pub const server_secp384r1_mlkem1024 = false;

    pub const certificate_verify_schemes: []const SignatureScheme = &.{
        .ecdsa_secp256r1_sha256,
        .ecdsa_secp384r1_sha384,
        .rsa_pss_rsae_sha256,
        .rsa_pss_rsae_sha384,
    };

    // FIPS 140-3 does not approve RSA PKCS#1 v1.5 for TLS 1.3 certificate
    // signatures (only RSASSA-PSS is approved) and does not approve Ed25519.
    pub const certificate_signature_schemes: []const SignatureScheme = &.{
        .ecdsa_secp256r1_sha256,
        .ecdsa_secp384r1_sha384,
    };
};

pub const Error = error{ LibcryptoFailed, IdentityElement };

// ---------------------------------------------------------------------------
// Error-queue hygiene (#88 finding 2)
// ---------------------------------------------------------------------------
//
// Failed libcrypto calls may push per-thread error-queue entries, and
// nothing in ztls ever reads the queue: without a guard, every
// attacker-reachable failure (malformed key_share, bad CertificateVerify,
// failed record decrypt) leaves residue for the life of the thread. Every
// outermost public fallible wrapper — AEAD seal/open included — brackets
// its libcrypto calls with ERR_set_mark / ERR_pop_to_mark so it removes
// exactly the entries it pushed and preserves the caller's.
//
// Bounds, verified against the pinned err sources (OpenSSL err_mark.c:
// counted marks; aws-lc 5.5.0 / boringssl 0.20260803.0 err.c: per-entry
// boolean mark flag):
// - Caller entries survive only within the per-thread ring (16 slots, 15
//   usable); a queue the caller has already filled is evicted by libcrypto
//   itself, taking the caller's oldest entries.
// - DER/PEM key loads (privateKeyFromDer/Pem) cannot preserve pre-existing
//   caller entries on the BoringSSL-family backends: their d2i key parsers
//   call ERR_clear_error between parse fallbacks, destroying the caller's
//   entries and ztls's mark before errqExit runs. The wrapper still leaves
//   no residue of its own there; pinned by a lane-dependent test.
// - The X509 leaf parse inside privateKeyPairsWithCertificate (#113) has
//   the same caveat class by a different mechanism: the family's d2i_X509
//   runs SPKI-to-EVP_PKEY conversion during the parse, and that path can
//   call ERR_clear_error, destroying pre-existing caller entries and the
//   mark before errqExit runs. aws-lc reaches the clear unconditionally
//   (x_pubkey.c err: label, even on success); BoringSSL clears only when
//   the SPKI decode fails; OpenSSL does not clear on this path. In every
//   variant the wrapper's own X509_check_private_key mismatch push is
//   still popped by the guard, so it leaves no residue of its own —
//   pinned by a lane-dependent test.
// - A caller's pending ERR_set_mark is consumed on the BoringSSL-family
//   backends even when the wrapper pushes nothing: errqEnter re-marks the
//   caller's top entry (idempotent flag) and errqExit clears it, so the
//   caller's own later pop_to_mark then drains the caller's entries.
//   OpenSSL's counted marks are immune.
// - Nesting rule (load-bearing convention): mark/pop is safe only at an
//   outermost entry point — a nested pair on the same entry lets the outer
//   pop drain the caller's entries on the flag-marking forks. Internal
//   helpers stay unguarded, and any future public front that calls another
//   fallible wrapper must call the unguarded impl instead (the
//   privateKeyFromP256Scalar → p256PrivateKeyFromSecretImpl split is the
//   pattern) and add the same nesting pin.
// - The guard is defer, not errdefer, as a forward-looking contract: no
//   current wrapper pushes on success, but a future one that
//   pushes-and-recovers internally must still clean up. No wrapper in the
//   exercised set distinguishes defer from errdefer today.

/// Enter a guarded public wrapper: mark the queue's current top so
/// `errqExit` can drop everything this wrapper pushes above it. On an empty
/// queue the mark is a no-op and `errqExit` then drains everything the
/// wrapper pushed — exactly the as-found (empty) state.
pub inline fn errqEnter() void {
    _ = c.ERR_set_mark();
}

/// Exit a guarded public wrapper: pop everything pushed since `errqEnter`.
pub inline fn errqExit() void {
    _ = c.ERR_pop_to_mark();
}

/// Provider-backed pure ML-KEM types. TLS hybrid composition remains in ztls
/// so the three RFC 10024 groups have identical wire behavior across backends.
pub const KemKey = *pkey;
pub const KemPeerKey = *pkey;

fn kemName(parameter_set: ParameterSet) [*:0]const u8 {
    return switch (parameter_set) {
        .mlkem768 => "ML-KEM-768",
        .mlkem1024 => "ML-KEM-1024",
    };
}

/// Generate a pure ML-KEM keypair. Caller must freeKey the result.
pub fn kemKeygen(parameter_set: ParameterSet) Error!KemKey {
    errqEnter();
    defer errqExit();
    return c.EVP_PKEY_Q_keygen(null, null, kemName(parameter_set)) orelse
        error.LibcryptoFailed;
}

/// Extract the raw ML-KEM encapsulation key.
pub fn kemPublic(key: KemKey, out: []u8) Error![]u8 {
    errqEnter();
    defer errqExit();
    var len: usize = out.len;
    if (c.EVP_PKEY_get_raw_public_key(key, out.ptr, &len) != 1)
        return error.LibcryptoFailed;
    return out[0..len];
}

/// Load a peer's raw ML-KEM encapsulation key after ztls validation.
pub fn kemLoadPublic(
    parameter_set: ParameterSet,
    public_key: []const u8,
) Error!KemPeerKey {
    errqEnter();
    defer errqExit();
    return c.EVP_PKEY_new_raw_public_key_ex(
        null,
        kemName(parameter_set),
        null,
        public_key.ptr,
        public_key.len,
    ) orelse error.LibcryptoFailed;
}

/// Encapsulate using the peer's pure ML-KEM public key.
pub fn kemEncapsulate(
    parameter_set: ParameterSet,
    peer_key: KemPeerKey,
    ciphertext_out: []u8,
    secret_out: []u8,
) Error!struct { ciphertext: []u8, secret: []u8 } {
    _ = parameter_set;
    errqEnter();
    defer errqExit();
    const ctx = c.EVP_PKEY_CTX_new(peer_key, null) orelse
        return error.LibcryptoFailed;
    defer c.EVP_PKEY_CTX_free(ctx);
    if (c.EVP_PKEY_encapsulate_init(ctx, null) != 1)
        return error.LibcryptoFailed;

    var ciphertext_len: usize = ciphertext_out.len;
    var secret_len: usize = secret_out.len;
    if (c.EVP_PKEY_encapsulate(
        ctx,
        ciphertext_out.ptr,
        &ciphertext_len,
        secret_out.ptr,
        &secret_len,
    ) != 1) return error.LibcryptoFailed;
    return .{
        .ciphertext = ciphertext_out[0..ciphertext_len],
        .secret = secret_out[0..secret_len],
    };
}

/// Decapsulate a pure ML-KEM ciphertext.
pub fn kemDecapsulate(
    parameter_set: ParameterSet,
    our_key: KemKey,
    ciphertext: []const u8,
    secret_out: []u8,
) Error![]u8 {
    _ = parameter_set;
    errqEnter();
    defer errqExit();
    const ctx = c.EVP_PKEY_CTX_new(our_key, null) orelse
        return error.LibcryptoFailed;
    defer c.EVP_PKEY_CTX_free(ctx);
    if (c.EVP_PKEY_decapsulate_init(ctx, null) != 1)
        return error.LibcryptoFailed;

    var secret_len: usize = secret_out.len;
    if (c.EVP_PKEY_decapsulate(
        ctx,
        secret_out.ptr,
        &secret_len,
        ciphertext.ptr,
        ciphertext.len,
    ) != 1) return error.LibcryptoFailed;
    return secret_out[0..secret_len];
}

pub fn freeKey(key: anytype) void {
    c.EVP_PKEY_free(key);
}

pub const pkey = c.EVP_PKEY;
pub const x25519_pkey = *pkey;

pub fn privateKeyFromSecret(secret: *const [32]u8) Error!x25519_pkey {
    errqEnter();
    defer errqExit();
    return c.EVP_PKEY_new_raw_private_key(
        c.EVP_PKEY_X25519,
        null,
        secret,
        secret.len,
    ) orelse error.LibcryptoFailed;
}

pub fn publicKeyFromRaw(public_key: *const [32]u8) Error!x25519_pkey {
    errqEnter();
    defer errqExit();
    return c.EVP_PKEY_new_raw_public_key(
        c.EVP_PKEY_X25519,
        null,
        public_key,
        public_key.len,
    ) orelse error.LibcryptoFailed;
}

pub fn rawPublicKeyFromPrivate(key: *const x25519_pkey) Error![32]u8 {
    errqEnter();
    defer errqExit();
    var public_key: [32]u8 = undefined;
    var len: usize = public_key.len;
    if (c.EVP_PKEY_get_raw_public_key(key.*, &public_key, &len) != 1) return error.LibcryptoFailed;
    if (len != public_key.len) return error.LibcryptoFailed;
    return public_key;
}

pub fn sharedSecretDerive(
    ours: *const x25519_pkey,
    peer: *const x25519_pkey,
    out: *[32]u8,
) Error!void {
    errqEnter();
    defer errqExit();
    const ctx = c.EVP_PKEY_CTX_new(ours.*, null) orelse return error.LibcryptoFailed;
    defer c.EVP_PKEY_CTX_free(ctx);
    if (c.EVP_PKEY_derive_init(ctx) != 1) return error.LibcryptoFailed;
    if (c.EVP_PKEY_derive_set_peer(ctx, peer.*) != 1) return error.LibcryptoFailed;

    var len: usize = out.len;
    if (c.EVP_PKEY_derive(ctx, out, &len) != 1) return error.IdentityElement;
    if (len != out.len) return error.LibcryptoFailed;

    // RFC 7748 §6.1 — all-zero X25519 output is a low-order peer public key.
    if (std.crypto.timing_safe.eql([32]u8, out.*, @splat(0))) return error.IdentityElement;
}

/// Unguarded impl — the body shared by `p256PrivateKeyFromSecret` and
/// `privateKeyFromP256Scalar`. Both are outermost public entry points, so
/// each guards on its own and calls this impl directly; a guard here would
/// nest behind theirs and (on the flag-marking BoringSSL-family queues) let
/// the outer pop drain the caller's entries (#88 finding 2).
fn p256PrivateKeyFromSecretImpl(secret: *const [32]u8) Error!*pkey {
    const group = c.EC_GROUP_new_by_curve_name(c.NID_X9_62_prime256v1) orelse
        return error.LibcryptoFailed;
    defer c.EC_GROUP_free(group);

    const priv = c.BN_bin2bn(secret, secret.len, null) orelse return error.LibcryptoFailed;
    defer c.BN_clear_free(priv);

    // Scalar range check [1, n-1] (SEC 1 §3.2.1) before any point math, so
    // `IdentityElement` can only mean an invalid scalar — a library failure
    // is `LibcryptoFailed` and not retryable (#88).
    const order = c.EC_GROUP_get0_order(group) orelse return error.LibcryptoFailed;
    if (c.BN_is_zero(priv) == 1 or c.BN_cmp(priv, order) >= 0)
        return error.IdentityElement;

    const public = c.EC_POINT_new(group) orelse return error.LibcryptoFailed;
    defer c.EC_POINT_free(public);
    if (c.EC_POINT_mul(group, public, priv, null, null, null) != 1)
        return error.LibcryptoFailed;

    const ec = c.EC_KEY_new_by_curve_name(c.NID_X9_62_prime256v1) orelse
        return error.LibcryptoFailed;
    errdefer c.EC_KEY_free(ec);
    // The scalar is already range-checked, so these three can only fail on
    // the library side (they allocate internally) — never a retry signal.
    if (c.EC_KEY_set_private_key(ec, priv) != 1) return error.LibcryptoFailed;
    if (c.EC_KEY_set_public_key(ec, public) != 1) return error.LibcryptoFailed;
    if (c.EC_KEY_check_key(ec) != 1) return error.LibcryptoFailed;

    const key = c.EVP_PKEY_new() orelse return error.LibcryptoFailed;
    errdefer c.EVP_PKEY_free(key);
    if (c.EVP_PKEY_assign_EC_KEY(key, ec) != 1) return error.LibcryptoFailed;
    return key;
}

pub fn p256PrivateKeyFromSecret(secret: *const [32]u8) Error!*pkey {
    errqEnter();
    defer errqExit();
    return p256PrivateKeyFromSecretImpl(secret);
}

pub fn p256PublicKeyFromRaw(public_key: *const [65]u8) Error!*pkey {
    errqEnter();
    defer errqExit();
    if (public_key[0] != 0x04) return error.IdentityElement;

    var ec: ?*c.EC_KEY = c.EC_KEY_new_by_curve_name(c.NID_X9_62_prime256v1) orelse
        return error.LibcryptoFailed;
    errdefer c.EC_KEY_free(ec);

    var ptr: ?[*]const u8 = public_key;
    if (c.o2i_ECPublicKey(&ec, &ptr, public_key.len) == null)
        return error.IdentityElement;
    if (c.EC_KEY_check_key(ec) != 1) return error.IdentityElement;

    const key = c.EVP_PKEY_new() orelse return error.LibcryptoFailed;
    errdefer c.EVP_PKEY_free(key);
    if (c.EVP_PKEY_assign_EC_KEY(key, ec) != 1) return error.LibcryptoFailed;
    return key;
}

pub fn p256RawPublicKeyFromPrivate(key: *pkey) Error![65]u8 {
    errqEnter();
    defer errqExit();
    const ec = c.EVP_PKEY_get1_EC_KEY(key) orelse return error.LibcryptoFailed;
    defer c.EC_KEY_free(ec);

    var len = c.i2o_ECPublicKey(ec, null);
    if (len != 65) return error.LibcryptoFailed;
    var public_key: [65]u8 = undefined;
    var ptr: [*]u8 = &public_key;
    len = c.i2o_ECPublicKey(ec, @ptrCast(&ptr));
    if (len != 65) return error.LibcryptoFailed;
    if (public_key[0] != 0x04) return error.LibcryptoFailed;
    return public_key;
}

pub fn p256SharedSecretDerive(ours: *pkey, peer: *pkey, out: *[32]u8) Error!void {
    errqEnter();
    defer errqExit();
    const ctx = c.EVP_PKEY_CTX_new(ours, null) orelse return error.LibcryptoFailed;
    defer c.EVP_PKEY_CTX_free(ctx);
    if (c.EVP_PKEY_derive_init(ctx) != 1) return error.LibcryptoFailed;
    if (c.EVP_PKEY_derive_set_peer(ctx, peer) != 1) return error.IdentityElement;

    var len: usize = out.len;
    if (c.EVP_PKEY_derive(ctx, out, &len) != 1) return error.IdentityElement;
    if (len != out.len) return error.LibcryptoFailed;
}

// RFC 8446 §4.2.8.2 — secp384r1 (P-384) ECDHE. The uncompressed public key is
// 0x04 || X(48) || Y(48) = 97 bytes; the shared secret is the 48-byte
// x-coordinate.
pub fn p384PrivateKeyFromSecret(secret: *const [48]u8) Error!*pkey {
    errqEnter();
    defer errqExit();
    const group = c.EC_GROUP_new_by_curve_name(c.NID_secp384r1) orelse
        return error.LibcryptoFailed;
    defer c.EC_GROUP_free(group);

    const priv = c.BN_bin2bn(secret, secret.len, null) orelse return error.LibcryptoFailed;
    defer c.BN_clear_free(priv);

    // Scalar range check [1, n-1] before point math — see
    // `p256PrivateKeyFromSecret` (#88).
    const order = c.EC_GROUP_get0_order(group) orelse return error.LibcryptoFailed;
    if (c.BN_is_zero(priv) == 1 or c.BN_cmp(priv, order) >= 0)
        return error.IdentityElement;

    const public = c.EC_POINT_new(group) orelse return error.LibcryptoFailed;
    defer c.EC_POINT_free(public);
    if (c.EC_POINT_mul(group, public, priv, null, null, null) != 1)
        return error.LibcryptoFailed;

    const ec = c.EC_KEY_new_by_curve_name(c.NID_secp384r1) orelse
        return error.LibcryptoFailed;
    errdefer c.EC_KEY_free(ec);
    // Past the range check these can only fail on the library side (#88).
    if (c.EC_KEY_set_private_key(ec, priv) != 1) return error.LibcryptoFailed;
    if (c.EC_KEY_set_public_key(ec, public) != 1) return error.LibcryptoFailed;
    if (c.EC_KEY_check_key(ec) != 1) return error.LibcryptoFailed;

    const key = c.EVP_PKEY_new() orelse return error.LibcryptoFailed;
    errdefer c.EVP_PKEY_free(key);
    if (c.EVP_PKEY_assign_EC_KEY(key, ec) != 1) return error.LibcryptoFailed;
    return key;
}

pub fn p384PublicKeyFromRaw(public_key: *const [97]u8) Error!*pkey {
    errqEnter();
    defer errqExit();
    if (public_key[0] != 0x04) return error.IdentityElement;

    var ec: ?*c.EC_KEY = c.EC_KEY_new_by_curve_name(c.NID_secp384r1) orelse
        return error.LibcryptoFailed;
    errdefer c.EC_KEY_free(ec);

    var ptr: ?[*]const u8 = public_key;
    if (c.o2i_ECPublicKey(&ec, &ptr, public_key.len) == null)
        return error.IdentityElement;
    if (c.EC_KEY_check_key(ec) != 1) return error.IdentityElement;

    const key = c.EVP_PKEY_new() orelse return error.LibcryptoFailed;
    errdefer c.EVP_PKEY_free(key);
    if (c.EVP_PKEY_assign_EC_KEY(key, ec) != 1) return error.LibcryptoFailed;
    return key;
}

pub fn p384RawPublicKeyFromPrivate(key: *pkey) Error![97]u8 {
    errqEnter();
    defer errqExit();
    const ec = c.EVP_PKEY_get1_EC_KEY(key) orelse return error.LibcryptoFailed;
    defer c.EC_KEY_free(ec);

    var len = c.i2o_ECPublicKey(ec, null);
    if (len != 97) return error.LibcryptoFailed;
    var public_key: [97]u8 = undefined;
    var ptr: [*]u8 = &public_key;
    len = c.i2o_ECPublicKey(ec, @ptrCast(&ptr));
    if (len != 97) return error.LibcryptoFailed;
    if (public_key[0] != 0x04) return error.LibcryptoFailed;
    return public_key;
}

pub fn p384SharedSecretDerive(ours: *pkey, peer: *pkey, out: *[48]u8) Error!void {
    errqEnter();
    defer errqExit();
    const ctx = c.EVP_PKEY_CTX_new(ours, null) orelse return error.LibcryptoFailed;
    defer c.EVP_PKEY_CTX_free(ctx);
    if (c.EVP_PKEY_derive_init(ctx) != 1) return error.LibcryptoFailed;
    if (c.EVP_PKEY_derive_set_peer(ctx, peer) != 1) return error.IdentityElement;

    var len: usize = out.len;
    if (c.EVP_PKEY_derive(ctx, out, &len) != 1) return error.IdentityElement;
    if (len != out.len) return error.LibcryptoFailed;
}

pub fn x25519FreeKey(key: *x25519_pkey) void {
    c.EVP_PKEY_free(key.*);
    key.* = undefined;
}

pub const AeadError = error{
    AuthenticationFailed,
    AeadSetupFailed,
    AeadEncryptFailed,
};

pub const AeadContext = struct {
    enc: *c.EVP_CIPHER_CTX,
    dec: *c.EVP_CIPHER_CTX,
};

pub const aead_tag_len = 16;
pub const aead_nonce_len = 12;

fn aeadCipher(suite: CipherSuite) *const c.EVP_CIPHER {
    return switch (suite) {
        .aes_128_gcm_sha256 => c.EVP_aes_128_gcm(),
        .aes_256_gcm_sha384 => c.EVP_aes_256_gcm(),
        .chacha20_poly1305_sha256 => c.EVP_chacha20_poly1305(),
    } orelse unreachable;
}

pub fn aeadInit(suite: CipherSuite, key_bytes: []const u8) AeadError!AeadContext {
    errqEnter();
    defer errqExit();
    const cipher = aeadCipher(suite);
    const key_len: usize = @intCast(c.EVP_CIPHER_key_length(cipher));
    if (key_bytes.len != key_len) return error.AeadSetupFailed;

    const enc = c.EVP_CIPHER_CTX_new() orelse return error.AeadSetupFailed;
    errdefer c.EVP_CIPHER_CTX_free(enc);
    const dec = c.EVP_CIPHER_CTX_new() orelse return error.AeadSetupFailed;
    errdefer c.EVP_CIPHER_CTX_free(dec);

    if (c.EVP_EncryptInit_ex(enc, cipher, null, null, null) != 1)
        return error.AeadSetupFailed;
    if (c.EVP_CIPHER_CTX_ctrl(enc, c.EVP_CTRL_AEAD_SET_IVLEN, aead_nonce_len, null) != 1)
        return error.AeadSetupFailed;
    if (c.EVP_EncryptInit_ex(enc, null, null, key_bytes.ptr, null) != 1)
        return error.AeadSetupFailed;

    if (c.EVP_DecryptInit_ex(dec, cipher, null, null, null) != 1)
        return error.AeadSetupFailed;
    if (c.EVP_CIPHER_CTX_ctrl(dec, c.EVP_CTRL_AEAD_SET_IVLEN, aead_nonce_len, null) != 1)
        return error.AeadSetupFailed;
    if (c.EVP_DecryptInit_ex(dec, null, null, key_bytes.ptr, null) != 1)
        return error.AeadSetupFailed;

    return .{ .enc = enc, .dec = dec };
}

// The backend boundary rejects slices that cannot satisfy the cipher's
// implicit fixed-size key read.
test "OpenSSL AEAD initialization rejects wrong key length" {
    if (comptime c_openssl.family != .boringssl) {
        const testing = std.testing;
        const wrong_key: [1]u8 = @splat(0);
        var ctx = aeadInit(.aes_256_gcm_sha384, &wrong_key) catch |err| {
            try testing.expect(err == error.AeadSetupFailed);
            return;
        };
        defer aeadDeinit(&ctx);
        return error.TestUnexpectedResult;
    } else return error.SkipZigTest;
}

pub fn aeadDeinit(ctx: *AeadContext) void {
    c.EVP_CIPHER_CTX_free(ctx.enc);
    c.EVP_CIPHER_CTX_free(ctx.dec);
    ctx.* = undefined;
}

pub fn aeadEncrypt(
    ctx: *AeadContext,
    ciphertext: []u8,
    tag: *[aead_tag_len]u8,
    plaintext: []const u8,
    ad: []const u8,
    npub: *const [aead_nonce_len]u8,
) AeadError!void {
    errqEnter();
    defer errqExit();
    var len: c_int = 0;
    var out_len: c_int = 0;
    if (c.EVP_EncryptInit_ex(ctx.enc, null, null, null, npub) != 1)
        return error.AeadEncryptFailed;
    if (c.EVP_EncryptUpdate(ctx.enc, null, &len, ad.ptr, @intCast(ad.len)) != 1)
        return error.AeadEncryptFailed;
    if (c.EVP_EncryptUpdate(
        ctx.enc,
        ciphertext.ptr,
        &len,
        plaintext.ptr,
        @intCast(plaintext.len),
    ) != 1) return error.AeadEncryptFailed;
    out_len += len;
    if (c.EVP_EncryptFinal_ex(ctx.enc, ciphertext.ptr + @as(usize, @intCast(out_len)), &len) != 1)
        return error.AeadEncryptFailed;
    if (c.EVP_CIPHER_CTX_ctrl(ctx.enc, c.EVP_CTRL_AEAD_GET_TAG, aead_tag_len, tag) != 1)
        return error.AeadEncryptFailed;
}

pub fn aeadDecrypt(
    ctx: *AeadContext,
    plaintext: []u8,
    ciphertext: []const u8,
    tag: *const [aead_tag_len]u8,
    ad: []const u8,
    npub: *const [aead_nonce_len]u8,
) AeadError!void {
    errqEnter();
    defer errqExit();
    var len: c_int = 0;
    var out_len: c_int = 0;
    if (c.EVP_DecryptInit_ex(ctx.dec, null, null, null, npub) != 1)
        return error.AuthenticationFailed;
    if (c.EVP_DecryptUpdate(ctx.dec, null, &len, ad.ptr, @intCast(ad.len)) != 1)
        return error.AuthenticationFailed;
    // EVP_DecryptUpdate writes plaintext to `plaintext` before
    // EVP_DecryptFinal_ex verifies the tag — the output buffer
    // holds unauthenticated data until the call succeeds.
    if (c.EVP_DecryptUpdate(
        ctx.dec,
        plaintext.ptr,
        &len,
        ciphertext.ptr,
        @intCast(ciphertext.len),
    ) != 1) return error.AuthenticationFailed;
    out_len += len;
    if (c.EVP_CIPHER_CTX_ctrl(
        ctx.dec,
        c.EVP_CTRL_AEAD_SET_TAG,
        aead_tag_len,
        // OpenSSL's control API takes a mutable pointer, but SET_TAG reads it.
        @constCast(tag),
    ) != 1) return error.AuthenticationFailed;
    if (c.EVP_DecryptFinal_ex(ctx.dec, plaintext.ptr + @as(usize, @intCast(out_len)), &len) != 1)
        return error.AuthenticationFailed;
}

pub const SignatureError = error{
    BufferTooShort,
    InvalidEncoding,
    LibcryptoFailed,
    SignatureVerificationFailed,
    UnsupportedSignatureScheme,
};

/// signatureSign-only extension: verification and key loading can never
/// fail this way, so the deterministic-nonce error stays out of their
/// error sets (mattrobenolt/ztls#82).
pub const SignError = SignatureError || error{DeterministicNonceUnsupported};

/// ECDSA nonce strategy for the sign seam (mattrobenolt/ztls#82):
/// `.random` (default) or `.deterministic` RFC 6979 deterministic-k.
pub const NonceMode = enum {
    random,
    deterministic,
};

/// Whether the translated headers carry the nonce-type signature parameter
/// (OpenSSL 3.2+; absent from BoringSSL-family headers). Compiled support
/// only — the provider can still reject the parameter at runtime.
pub const supports_deterministic_nonce = !is_boringssl_family and
    @hasDecl(c, "OSSL_SIGNATURE_PARAM_NONCE_TYPE");

pub const EcCurve = enum {
    secp256r1,
    secp384r1,

    fn nid(comptime self: EcCurve) c_int {
        return switch (self) {
            .secp256r1 => c.NID_X9_62_prime256v1,
            .secp384r1 => c.NID_secp384r1,
        };
    }
};

fn signatureDigest(scheme: SignatureScheme) SignatureError!*const c.EVP_MD {
    return switch (scheme) {
        .ecdsa_secp256r1_sha256, .rsa_pss_rsae_sha256 => c.EVP_sha256(),
        .ecdsa_secp384r1_sha384, .rsa_pss_rsae_sha384 => c.EVP_sha384(),
        .rsa_pss_rsae_sha512 => c.EVP_sha512(),
        else => return error.UnsupportedSignatureScheme,
    } orelse return error.LibcryptoFailed;
}

fn configureRsaPss(
    ctx: ?*c.EVP_PKEY_CTX,
    scheme: SignatureScheme,
    md: *const c.EVP_MD,
) SignatureError!void {
    switch (scheme) {
        .rsa_pss_rsae_sha256, .rsa_pss_rsae_sha384, .rsa_pss_rsae_sha512 => {
            if (c.EVP_PKEY_CTX_set_rsa_padding(ctx, c.RSA_PKCS1_PSS_PADDING) != 1)
                return error.LibcryptoFailed;
            if (c.EVP_PKEY_CTX_set_rsa_mgf1_md(ctx, md) != 1)
                return error.LibcryptoFailed;
            if (c.EVP_PKEY_CTX_set_rsa_pss_saltlen(ctx, c.RSA_PSS_SALTLEN_DIGEST) != 1)
                return error.LibcryptoFailed;
        },
        else => {},
    }
}

pub fn privateKeyFromDer(der: []const u8) SignatureError!*pkey {
    errqEnter();
    defer errqExit();
    var ptr: ?[*]const u8 = der.ptr;
    return c.d2i_AutoPrivateKey(null, &ptr, @intCast(der.len)) orelse error.LibcryptoFailed;
}

pub fn privateKeyFromPem(pem: []const u8) SignatureError!*pkey {
    errqEnter();
    defer errqExit();
    const bio = c.BIO_new_mem_buf(pem.ptr, @intCast(pem.len)) orelse
        return error.LibcryptoFailed;
    defer _ = c.BIO_free(bio);
    return c.PEM_read_bio_PrivateKey(bio, null, null, null) orelse error.LibcryptoFailed;
}

pub const KeySchemeError = error{UnsupportedKeyScheme};

/// Infer the CertificateVerify SignatureScheme from a loaded private key
/// (#112). Uses the exact key type (`EVP_PKEY_id`), not the base type. RFC
/// 8446 §4.2.3 assigns rsassaPss-OID keys to rsa_pss_pss_*, which ztls does
/// not implement or advertise; preserving EVP_PKEY_RSA_PSS therefore rejects
/// those keys instead of mislabeling them rsa_pss_rsae_*. Ed25519 and P-521
/// map to their schemes here; whether the active backend can sign them is a
/// separate capability question (`fromPemAuto` gates on it).
/// Outermost guarded wrapper (#88 finding 2): EVP_PKEY_get0_EC_KEY can push
/// error-queue entries on OpenSSL when a provider-held EC key has no legacy
/// export, and every mapping failure must leave no residue.
pub fn keyScheme(key: *const pkey) KeySchemeError!SignatureScheme {
    errqEnter();
    defer errqExit();
    return switch (c.EVP_PKEY_id(key)) {
        c.EVP_PKEY_RSA => .rsa_pss_rsae_sha256,
        c.EVP_PKEY_EC => switch (ecCurveNid(key) orelse return error.UnsupportedKeyScheme) {
            c.NID_X9_62_prime256v1 => .ecdsa_secp256r1_sha256,
            c.NID_secp384r1 => .ecdsa_secp384r1_sha384,
            c.NID_secp521r1 => .ecdsa_secp521r1_sha512,
            else => error.UnsupportedKeyScheme,
        },
        c.EVP_PKEY_ED25519 => .ed25519,
        else => error.UnsupportedKeyScheme,
    };
}

fn ecCurveNid(key: *const pkey) ?c_int {
    const ec = c.EVP_PKEY_get0_EC_KEY(key) orelse return null;
    const group = c.EC_KEY_get0_group(ec) orelse return null;
    return c.EC_GROUP_get_curve_name(group);
}

/// RFC 8446 §4.4.3 — the CertificateVerify key must correspond to the leaf
/// certificate's public key. Load-time pairing check (#113): parses the
/// caller's exact leaf DER with d2i_X509, rejects trailing bytes, and compares
/// through X509_check_private_key. The X509 is provider-owned, freed in this scope,
/// and never escapes (public data, no zeroization needed); the private key
/// is borrowed read-only, so ownership and zeroization stay with `freeKey`.
/// `false` is conservative on every lane: an SPKI the backend cannot
/// convert to an EVP_PKEY reports not-paired, never a false accept.
/// Outermost guarded wrapper (#88 finding 2): a clean mismatch pushes
/// X509_R_KEY_VALUES_MISMATCH on all three families.
pub fn privateKeyPairsWithCertificate(
    key: *const pkey,
    leaf_cert_der: []const u8,
) error{InvalidEncoding}!bool {
    errqEnter();
    defer errqExit();
    var ptr: ?[*]const u8 = leaf_cert_der.ptr;
    const x509 = c.d2i_X509(null, &ptr, @intCast(leaf_cert_der.len)) orelse
        return error.InvalidEncoding;
    defer c.X509_free(x509);
    if (ptr.? != leaf_cert_der.ptr + leaf_cert_der.len) return error.InvalidEncoding;
    return c.X509_check_private_key(x509, key) == 1;
}

/// Outermost entry point (key load for signing): guards on its own and calls
/// the unguarded p256 impl — a guard in the impl would nest behind this one
/// (#88 finding 2, see the hygiene comment above).
pub fn privateKeyFromP256Scalar(scalar: *const [32]u8) SignatureError!*pkey {
    errqEnter();
    defer errqExit();
    return p256PrivateKeyFromSecretImpl(scalar) catch |err| switch (err) {
        error.LibcryptoFailed, error.IdentityElement => error.LibcryptoFailed,
    };
}

pub fn ecPublicKeyFromSec1(
    comptime curve: EcCurve,
    pub_key: []const u8,
) SignatureError!*pkey {
    errqEnter();
    defer errqExit();
    var ec: ?*c.EC_KEY = c.EC_KEY_new_by_curve_name(curve.nid()) orelse
        return error.InvalidEncoding;
    errdefer c.EC_KEY_free(ec);

    var ptr: ?[*]const u8 = pub_key.ptr;
    if (c.o2i_ECPublicKey(&ec, &ptr, @intCast(pub_key.len)) == null)
        return error.InvalidEncoding;
    if (c.EC_KEY_check_key(ec) != 1) return error.InvalidEncoding;

    const key = c.EVP_PKEY_new() orelse return error.SignatureVerificationFailed;
    errdefer c.EVP_PKEY_free(key);
    if (c.EVP_PKEY_assign_EC_KEY(key, ec) != 1)
        return error.SignatureVerificationFailed;
    return key;
}

pub fn rsaPublicKeyFromDer(pub_key: []const u8) SignatureError!*pkey {
    errqEnter();
    defer errqExit();
    var ptr: ?[*]const u8 = pub_key.ptr;
    const rsa = c.d2i_RSAPublicKey(null, &ptr, @intCast(pub_key.len)) orelse
        return error.InvalidEncoding;
    errdefer c.RSA_free(rsa);

    const key = c.EVP_PKEY_new() orelse return error.SignatureVerificationFailed;
    errdefer c.EVP_PKEY_free(key);
    if (c.EVP_PKEY_assign_RSA(key, rsa) != 1)
        return error.SignatureVerificationFailed;
    return key;
}

// RFC 6979 deterministic ECDSA nonces (mattrobenolt/ztls#82). The comptime
// gate prunes the provider-parameter path when the headers lack the macro;
// the per-key settable-params probe stays because compiled support does not
// bind the provider, and a silently random nonce is the failure this option
// exists to prevent.
fn configureDeterministicNonce(
    pctx: ?*c.EVP_PKEY_CTX,
    scheme: SignatureScheme,
) SignError!void {
    if (comptime !supports_deterministic_nonce)
        return error.DeterministicNonceUnsupported;
    switch (scheme) {
        .ecdsa_secp256r1_sha256, .ecdsa_secp384r1_sha384 => {},
        else => return error.DeterministicNonceUnsupported,
    }
    const settable = c.EVP_PKEY_CTX_settable_params(pctx);
    if (c.OSSL_PARAM_locate_const(settable, c.OSSL_SIGNATURE_PARAM_NONCE_TYPE) == null)
        return error.DeterministicNonceUnsupported;
    var nonce_type: c_uint = 1; // 1 = deterministic-k (RFC 6979).
    var params = [_]c.OSSL_PARAM{
        c.OSSL_PARAM_construct_uint(c.OSSL_SIGNATURE_PARAM_NONCE_TYPE, &nonce_type),
        c.OSSL_PARAM_construct_end(),
    };
    if (c.EVP_PKEY_CTX_set_params(pctx, &params) != 1) return error.LibcryptoFailed;
}

// ziglint-ignore: Z015 -- SignError is a public error-set alias.
pub fn signatureSign(
    key: *pkey,
    scheme: SignatureScheme,
    msg: []const u8,
    out: []u8,
    nonce_mode: NonceMode,
) SignError![]const u8 {
    errqEnter();
    defer errqExit();
    const md = try signatureDigest(scheme);
    const ctx = c.EVP_MD_CTX_new() orelse return error.LibcryptoFailed;
    defer c.EVP_MD_CTX_free(ctx);

    var pctx: ?*c.EVP_PKEY_CTX = null;
    if (c.EVP_DigestSignInit(ctx, &pctx, md, null, key) != 1) return error.LibcryptoFailed;
    try configureRsaPss(pctx, scheme, md);
    if (nonce_mode == .deterministic) try configureDeterministicNonce(pctx, scheme);
    if (c.EVP_DigestSignUpdate(ctx, msg.ptr, msg.len) != 1) return error.LibcryptoFailed;

    var required_len: usize = 0;
    if (c.EVP_DigestSignFinal(ctx, null, &required_len) != 1) return error.LibcryptoFailed;
    if (out.len < required_len) return error.BufferTooShort;

    var len: usize = out.len;
    if (c.EVP_DigestSignFinal(ctx, out.ptr, &len) != 1) return error.LibcryptoFailed;
    return out[0..len];
}

pub fn signatureVerify(
    key: *pkey,
    scheme: SignatureScheme,
    context: []const u8,
    transcript_hash: []const u8,
    sig: []const u8,
) SignatureError!void {
    errqEnter();
    defer errqExit();
    const md = try signatureDigest(scheme);
    const ctx = c.EVP_MD_CTX_new() orelse return error.SignatureVerificationFailed;
    defer c.EVP_MD_CTX_free(ctx);

    var pctx: ?*c.EVP_PKEY_CTX = null;
    if (c.EVP_DigestVerifyInit(ctx, &pctx, md, null, key) != 1)
        return error.SignatureVerificationFailed;
    configureRsaPss(pctx, scheme, md) catch return error.SignatureVerificationFailed;
    if (c.EVP_DigestVerifyUpdate(ctx, context.ptr, context.len) != 1)
        return error.SignatureVerificationFailed;
    if (c.EVP_DigestVerifyUpdate(ctx, transcript_hash.ptr, transcript_hash.len) != 1)
        return error.SignatureVerificationFailed;
    if (c.EVP_DigestVerifyFinal(ctx, sig.ptr, sig.len) != 1)
        return error.SignatureVerificationFailed;
}
