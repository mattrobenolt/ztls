//! ztls-std: opinionated TLS 1.3 stream wrapper over `std.Io.net` (Zig 0.16).
//!
//! Converts a connected `std.Io.net` stream into a TLS connection so a caller
//! can `connect`/`read`/`writeAll`/`close` without writing a Sans-I/O drive
//! loop. This is the reference integration; ztls-xev and ztls-ktls adapt its
//! handshake-to-completion loop. See #77 and ROADMAP.md.
//!
//! SCAFFOLD ONLY: the wrapper API (Client.connect/accept, system-bundle cert
//! verification by default, the byte-stream buffering layer over the ztls
//! event union) is the implementation work tracked by #77. This file currently
//! just re-exports ztls to prove the dependency wiring builds.
const ztls = @import("ztls");

/// Re-export ztls so consumers of ztls-std can reach the core if needed.
pub const core = ztls;

test "scaffold: ztls dependency is wired" {
    // Forces the ztls import to resolve at compile/test time. The real wrapper
    // tests (in-memory ztls<->ztls handshake through the stream API, OpenSSL
    // interop) land with #77.
    _ = ztls;
}
