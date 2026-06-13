//! TLS compression method registry values.
//!
//! TLS 1.3 only permits the null compression method.

pub const CompressionMethod = enum(u8) {
    no_compression = 0,
    _,
};
