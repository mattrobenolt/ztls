//! TLS 1.3 signature scheme identifiers.
//!
//! RFC 8446 §4.2.3

/// RFC 8446 §4.2.3 signature schemes supported by ztls.
pub const SignatureScheme = enum(u16) {
    ecdsa_secp256r1_sha256 = 0x0403,
    ecdsa_secp384r1_sha384 = 0x0503,
    rsa_pss_rsae_sha256 = 0x0804,
    rsa_pss_rsae_sha384 = 0x0805,
    rsa_pss_rsae_sha512 = 0x0806,
    _,
};
