//! Single entry point for all test fixtures.
//!
//! Consumed as a build module (`@import("fixtures")`) by the test module,
//! examples, and conformance harnesses. This replaces the old symlink-based
//! `test_fixtures` directory aliases — no symlinks, no relative path gymnastics.
//!
//! Three fixture kinds live here:
//! - Zig-embedded DER/base64 constants (shared_fixtures, certificate_fixtures,
//!   sig_fixtures) — re-exported as submodules.
//! - txtar archives (rfc8448, openssl_replay) — embedded and exported as bytes.
//! - PEM key files (rsa_pss/server.key) — embedded and exported as bytes.
//!
//! PEM certificate files loaded at runtime via `addCertsFromFilePath` still
//! use the real `tests/fixtures/` path directly — those are not embedded.

pub const shared = @import("shared_fixtures.zig");
pub const cert = @import("certificate_fixtures.zig");
pub const sig = @import("sig_fixtures.zig");

pub const rfc8448_txtar: []const u8 = @embedFile("rfc8448.txtar");
pub const openssl_replay_txtar: []const u8 = @embedFile("openssl_replay.txtar");
pub const rsa_pss_key_pem: []const u8 = @embedFile("rsa_pss/server.key");
