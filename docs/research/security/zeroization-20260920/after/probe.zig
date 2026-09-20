const ztls = @import("ztls");
const H256 = ztls.hkdf.HkdfSha256;
const H384 = ztls.hkdf.HkdfSha384;

export fn audit_handshake256(early: *const H256.Prk, dhe: *const [32]u8, out: *H256.Prk) void {
    out.* = H256.handshakeSecret(early.*, dhe);
}

export fn audit_master256(handshake: *const H256.Prk, out: *H256.Prk) void {
    out.* = H256.masterSecret(handshake.*);
}

export fn audit_key256(secret: *const H256.Prk, out: *[16]u8) void {
    H256.expandLabel(out, "key", &.{}, secret.*);
}

export fn audit_handshake384(early: *const H384.Prk, dhe: *const [48]u8, out: *H384.Prk) void {
    out.* = H384.handshakeSecret(early.*, dhe);
}

export fn audit_master384(handshake: *const H384.Prk, out: *H384.Prk) void {
    out.* = H384.masterSecret(handshake.*);
}

export fn audit_key384(secret: *const H384.Prk, out: *[32]u8) void {
    H384.expandLabel(out, "key", &.{}, secret.*);
}
