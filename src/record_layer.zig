/// TLS 1.3 record protection layer.
///
/// Composes record framing, nonce construction, and AEAD to implement
/// TLSCiphertext encrypt/decrypt. RFC 8446 §5.2
const aead_mod = @import("aead.zig");
const nonce_mod = @import("nonce.zig");
const record = @import("record.zig");

const Aead = aead_mod.Aead;
const ContentType = record.ContentType;

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
    iv: nonce_mod.Iv,
    seq: u64,

    pub fn init(aead: Aead, iv: nonce_mod.Iv) RecordLayer {
        return .{ .aead = aead, .iv = iv, .seq = 0 };
    }
};
