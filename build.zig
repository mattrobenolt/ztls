const std = @import("std");
const Build = std.Build;
const Target = std.Target;
const builtin = @import("builtin");
const panic = std.debug.panic;

const bench_mod = @import("src/build/bench.zig");
const examples_mod = @import("src/build/examples.zig");
const tests = @import("src/build/tests.zig");

/// libcrypto-family backend kind. Field names are the wire strings used on the
/// CLI and in metadata, so @tagName round-trips to -Dcrypto-backend=... values.
/// `openssl-fips` and `aws-lc-fips` are compile-time FIPS capability identities:
/// they link the same libcrypto as their non-FIPS counterparts and narrow
/// the advertised capability table at compile time. The build option declares FIPS
/// intent; the caller/linker is responsible for ensuring the linked libcrypto is
/// actually in FIPS mode (e.g. loading the OpenSSL FIPS provider or linking
/// AWS-LC FIPS). No runtime provider probing is performed by ztls.
pub const Backend = enum {
    openssl,
    @"aws-lc",
    boringssl,
    @"openssl-fips",
    @"aws-lc-fips",
};

fn nativeTarget() Target.Query {
    var query: Target.Query = .{ .cpu_model = .native };
    // Zig's native CPU detection reports generic under some Apple-Silicon Linux
    // VMs despite /proc/cpuinfo exposing aes/pmull. For performance work that
    // silently selects std.crypto's soft AES path, which is not a useful target.
    if (builtin.cpu.arch == .aarch64 and builtin.os.tag == .linux) {
        query.cpu_model = .{ .explicit = &Target.aarch64.cpu.apple_m1 };
    }
    return query;
}

pub fn build(b: *Build) void {
    const target = b.standardTargetOptions(.{
        .default_target = nativeTarget(),
    });
    const optimize = b.standardOptimizeOption(.{});
    const env_map = if (@hasField(@TypeOf(b.graph.*), "environ_map"))
        b.graph.environ_map
    else
        b.graph.env_map;
    const env_crypto_backend = env_map.get("ZTLS_CRYPTO_BACKEND") orelse "";
    const crypto_backend_str = b.option(
        []const u8,
        "crypto-backend",
        "libcrypto-family backend to compile: openssl, aws-lc, boringssl, " ++
            "openssl-fips, aws-lc-fips",
    ) orelse if (env_crypto_backend.len > 0) env_crypto_backend else "openssl";
    const crypto_backend: Backend = std.meta.stringToEnum(Backend, crypto_backend_str) orelse
        panic(
            "unsupported -Dcrypto-backend={s}; supported: openssl, aws-lc, boringssl, " ++
                "openssl-fips, aws-lc-fips",
            .{crypto_backend_str},
        );
    const build_options = b.addOptions();
    build_options.addOption(Backend, "crypto_backend", crypto_backend);

    const mod = b.addModule("ztls", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    mod.addOptions("build_options", build_options);
    mod.link_libc = true;
    mod.linkSystemLibrary("crypto", .{});

    const test_mod = b.createModule(.{
        .root_source_file = b.path("src/test.zig"),
        .target = target,
        .optimize = optimize,
    });
    test_mod.addOptions("build_options", build_options);
    test_mod.link_libc = true;
    test_mod.linkSystemLibrary("crypto", .{});
    const txtar_mod = if (b.lazyDependency("txtar", .{
        .target = target,
        .optimize = optimize,
    })) |dep| dep.module("txtar") else null;
    if (txtar_mod) |tm| test_mod.addImport("txtar", tm);

    // Test fixtures module — replaces the old test_fixtures symlinks.
    const fixtures_mod = b.createModule(.{
        .root_source_file = b.path("tests/fixtures/fixtures.zig"),
        .target = target,
        .optimize = optimize,
    });
    test_mod.addImport("fixtures", fixtures_mod);

    const c_mod = b.createModule(.{
        .root_source_file = b.path("bench/c.zig"),
        .target = target,
        .optimize = optimize,
    });
    c_mod.link_libc = true;
    c_mod.linkSystemLibrary("crypto", .{});

    const c_ssl_mod = b.createModule(.{
        .root_source_file = b.path("bench/c_ssl.zig"),
        .target = target,
        .optimize = optimize,
    });
    c_ssl_mod.link_libc = true;
    c_ssl_mod.linkSystemLibrary("ssl", .{});
    c_ssl_mod.linkSystemLibrary("crypto", .{});

    const benchmark_dep = b.dependency("benchmark", .{
        .target = target,
        .optimize = .ReleaseFast,
    });

    tests.addSteps(b, .{
        .test_mod = test_mod,
    });

    bench_mod.addSteps(b, .{
        .target = target,
        .ztls_mod = mod,
        .c_mod = c_mod,
        .c_ssl_mod = c_ssl_mod,
        .build_options = build_options,
        .benchmark_dep = benchmark_dep,
        .txtar_mod = txtar_mod,
        .fixtures_mod = fixtures_mod,
    });

    examples_mod.addSteps(b, .{
        .target = target,
        .optimize = optimize,
        .ztls_mod = mod,
        .txtar_mod = txtar_mod,
        .fixtures_mod = fixtures_mod,
    });

    // Zig autodoc for the public API. `zig build docs -p docs/site` installs the
    // generated HTML into the mdBook source tree at docs/site/zig-docs, where
    // `mdbook build` sweeps it into the published site at /zig-docs/.
    const docs_obj = b.addObject(.{
        .name = "ztls-docs",
        .root_module = mod,
    });
    const docs_install = b.addInstallDirectory(.{
        .source_dir = docs_obj.getEmittedDocs(),
        .install_dir = .prefix,
        .install_subdir = "zig-docs",
    });
    const docs_step = b.step("docs", "Generate Zig API docs");
    docs_step.dependOn(&docs_install.step);
}
