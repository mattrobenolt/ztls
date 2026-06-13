//! TLS extension type registry values.
//!
//! RFC 8446 §4.2 and related extension RFCs.

pub const ExtensionType = enum(u16) {
    server_name = 0x0000,
    supported_groups = 0x000a,
    signature_algorithms = 0x000d,
    alpn = 0x0010,
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
