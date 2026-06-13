//! TLS protocol version registry values.
//!
//! RFC 8446 keeps legacy_version and record-layer version fields at TLS 1.2
//! while negotiating TLS 1.3 through supported_versions.

pub const ProtocolVersion = enum(u16) {
    tls_1_2 = 0x0303,
    tls_1_3 = 0x0304,
    _,
};
