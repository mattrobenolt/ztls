/// TLS 1.3 record protection layer.
///
/// Composes record framing, nonce construction, and AEAD to implement
/// TLSCiphertext encrypt/decrypt. RFC 8446 §5.2
const Aead = @import("aead.zig").Aead;
const ContentType = @import("record.zig").ContentType;
const Iv = @import("nonce.zig").Iv;

pub const DecryptResult = struct {
    content_type: ContentType,
    /// Plaintext content — subslice of the caller-provided output buffer.
    content: []u8,
};

/// Protection state for one direction of a TLS connection (read or write).
///
/// The caller maintains two of these — one for each direction.
pub const RecordLayer = struct {
    aead: Aead,
    iv: Iv,
    seq: u64 = 0,
};
