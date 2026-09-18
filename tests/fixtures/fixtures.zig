//! Single entry point for all test fixtures.
//!
//! Consumed as a build module (`@import("fixtures")`) by the test module,
//! examples, and conformance harnesses. Replaces the old symlink-based
//! `test_fixtures` directory aliases and the three `.zig` fixture files that
//! were just base64 data with duplicated `decode()` boilerplate.
//!
//! Binary fixture data (DER certificates, scalars, signatures) lives in
//! `fixtures.txtar` as base64 sections. PEM key files that need to be on
//! disk at runtime (for openssl s_server, addCertsFromFilePath) stay as
//! loose files under `tests/fixtures/`. txtar archives (rfc8448,
//! openssl_replay) are embedded directly.

const std = @import("std");

// --- comptime txtar section extractor ---------------------------------------

/// The raw txtar content containing all DER/base64 fixture sections.
const data_txtar: []const u8 = @embedFile("fixtures.txtar");

/// Extract a named section from an txtar archive at comptime.
/// Format: `-- name --\ncontent\n-- next --\n...`
fn txtarSection(data: []const u8, name: []const u8) []const u8 {
    @setEvalBranchQuota(100_000);
    const header = "-- " ++ name ++ " --\n";
    const start = std.mem.indexOf(u8, data, header) orelse
        @compileError("fixture section not found: " ++ name);
    const content_start = start + header.len;
    const end = std.mem.indexOfPos(u8, data, content_start, "\n-- ") orelse
        (std.mem.indexOfPos(u8, data, content_start, "\n\n") orelse data.len);
    return data[content_start..end];
}

/// Base64-decode a txtar section at comptime into a fixed-size byte array.
fn decodeSection(name: []const u8) [std.base64.standard.Decoder.calcSizeForSlice(txtarSection(data_txtar, name)) catch unreachable]u8 {
    const b64 = txtarSection(data_txtar, name);
    const len = std.base64.standard.Decoder.calcSizeForSlice(b64) catch unreachable;
    var decoded: [len]u8 = undefined;
    _ = std.base64.standard.Decoder.decode(&decoded, b64) catch unreachable;
    return decoded;
}

/// Return a raw txtar section as bytes (no base64 decode) — for PEM sections.
fn rawSection(name: []const u8) []const u8 {
    return txtarSection(data_txtar, name);
}

// --- DER fixtures (base64-decoded at comptime) ------------------------------

pub const server_cert_der = decodeSection("server_cert_der");
pub const server_ecdsa_cert_der = decodeSection("server_ecdsa_cert_der");
pub const server_ecdsa_scalar = decodeSection("server_ecdsa_scalar");
pub const client_ecdsa_cert_der = decodeSection("client_ecdsa_cert_der");
pub const client_ecdsa_scalar = decodeSection("client_ecdsa_scalar");
pub const rsa_pss_cert_der = decodeSection("rsa_pss_cert_der");
pub const ed25519_cert_der = decodeSection("ed25519_cert_der");
pub const chain_leaf_der = decodeSection("chain_leaf_der");
pub const chain_intermediate_der = decodeSection("chain_intermediate_der");
pub const audit_s5_leaf_der = decodeSection("audit_s5_leaf_der");
pub const audit_s5_issuer_der = decodeSection("audit_s5_issuer_der");
pub const name_constraints_der = decodeSection("name_constraints_der");
pub const name_constraints_noncritical_der = decodeSection("name_constraints_noncritical_der");
pub const nc_intermediate_der = decodeSection("nc_intermediate_der");
pub const nc_leaf_allowed_der = decodeSection("nc_leaf_allowed_der");
pub const nc_leaf_excluded_der = decodeSection("nc_leaf_excluded_der");
pub const nc_leaf_outside_der = decodeSection("nc_leaf_outside_der");
pub const crosssigned_leaf_der = decodeSection("crosssigned_leaf_der");
pub const crosssigned_intermediate_der = decodeSection("crosssigned_intermediate_der");
pub const crosssigned_root_cross_der = decodeSection("crosssigned_root_cross_der");

// --- Signature fixtures (base64-decoded at comptime) ------------------------

pub const cv_sig = decodeSection("cv_sig");
pub const rsa_pss_cv_sig = decodeSection("rsa_pss_cv_sig");
pub const rsa_pss_cv_salt20_sig = decodeSection("rsa_pss_cv_salt20_sig");

// --- PEM key fixtures (raw, not base64-decoded) ------------------------------

/// RSA-2048 PKCS#8 key — the same key material as `rsa_pss_key_pem` and the
/// `rsa_pss/server.crt` certificate. Scheme-inference and pairing fixtures
/// (#112/#113).
pub const rsa_pss_key_pem: []const u8 = rawSection("rsa_pss_key_pem");

/// RSA-2048 PKCS#1 (traditional) container of the same RSA key: the PEM
/// container is parsed by libcrypto, both forms load the same EVP_PKEY (#112).
pub const rsa_pkcs1_key_pem: []const u8 = rawSection("rsa_pkcs1_key_pem");

/// P-256 PKCS#8 key — pairs with `server_cert_der` (CN=test.local) (#112/#113).
pub const ec_p256_key_pem: []const u8 = rawSection("ec_p256_key_pem");
/// P-384 PKCS#8 key — infers ecdsa_secp384r1_sha384 (#112).
pub const ec_p384_key_pem: []const u8 = rawSection("ec_p384_key_pem");
/// P-521 PKCS#8 key — loads everywhere; rejected by the CertificateVerify
/// capability gate until a backend advertises ecdsa_secp521r1_sha512 (#112).
pub const ec_p521_key_pem: []const u8 = rawSection("ec_p521_key_pem");
/// Ed25519 PKCS#8 key — loads everywhere; rejected by the CertificateVerify
/// capability gate until the sign seam grows a one-shot Ed25519 flow (#112).
pub const ed25519_key_pem: []const u8 = rawSection("ed25519_key_pem");
/// secp224r1 PKCS#8 key — loads everywhere but has no TLS 1.3 ECDSA scheme
/// (RFC 8446 §4.2.3): the deterministic loads-then-rejects inference vector.
pub const ec_secp224r1_key_pem: []const u8 = rawSection("ec_secp224r1_key_pem");

// --- txtar archives (embedded directly) -------------------------------------

pub const rfc8448_txtar: []const u8 = @embedFile("rfc8448.txtar");
pub const openssl_replay_txtar: []const u8 = @embedFile("openssl_replay.txtar");
