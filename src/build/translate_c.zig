//! Translate-C module wiring (#145). Zig 0.16 deprecates `@cImport`; each C
//! include set moves to a wrapper `.h` next to its consumer plus one
//! `b.addTranslateC` step that turns the translation into a module.
//!
//! Header search: `linkSystemLibrary` on the step resolves include dirs via
//! pkg-config at translate time — the same resolution the consuming modules
//! already use at link time, so every backend lane (OpenSSL, AWS-LC,
//! BoringSSL) translates against the headers PKG_CONFIG_PATH selects.
//!
//! The step's system libs exist only to feed that header search; the created
//! modules carry no link objects. `createModule` would propagate `-lcrypto`
//! onto every consumer, and a consumer that builds a static archive (the C
//! ABI's libztls.a) would then bundle the resolved shared object into it —
//! capi-ci rejects exactly that. Each consumer already declares its own
//! `linkSystemLibrary("crypto")`/`"ssl"` the way it did before #145, and
//! imported-module system libs still propagate through those declarations.

const std = @import("std");
const Build = std.Build;

pub const Modules = struct {
    /// libcrypto-family C API — the decls behind `src/crypto/c_openssl.zig`,
    /// the #88 errq check, and the `bench/c.zig` C-API baseline.
    openssl_c: *Build.Module,
    /// libssl C API — the `bench/c_ssl.zig` ground-truth baseline.
    openssl_ssl: *Build.Module,
    /// POSIX PTY plumbing — the #114 encrypted-PEM non-interaction check.
    pty_c: *Build.Module,
};

pub fn addModules(b: *Build, opts: struct {
    target: Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
}) Modules {
    const openssl_c = b.addTranslateC(.{
        .root_source_file = b.path("src/crypto/openssl_c.h"),
        .target = opts.target,
        .optimize = opts.optimize,
    });
    openssl_c.linkSystemLibrary("crypto", .{});

    const openssl_ssl = b.addTranslateC(.{
        .root_source_file = b.path("bench/c_ssl.h"),
        .target = opts.target,
        .optimize = opts.optimize,
    });
    openssl_ssl.linkSystemLibrary("ssl", .{});

    const pty_c = b.addTranslateC(.{
        .root_source_file = b.path("src/test/pty_c.h"),
        .target = opts.target,
        .optimize = opts.optimize,
    });

    return .{
        .openssl_c = bareModule(b, openssl_c),
        .openssl_ssl = bareModule(b, openssl_ssl),
        .pty_c = bareModule(b, pty_c),
    };
}

/// A module over the translated output, without the step's system-lib link
/// objects — linking stays each consumer's own declaration.
fn bareModule(b: *Build, tc: *Build.Step.TranslateC) *Build.Module {
    return b.createModule(.{
        .root_source_file = tc.getOutput(),
        .target = tc.target,
        .optimize = tc.optimize,
        .link_libc = tc.link_libc,
    });
}
