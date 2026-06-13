const std = @import("std");
const Build = std.Build;
const Target = std.Target;
const builtin = @import("builtin");

const bench_mod = @import("src/build/bench.zig");
const examples_mod = @import("src/build/examples.zig");
const tests = @import("src/build/tests.zig");

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
    const crypto_backend = b.option(
        []const u8,
        "crypto-backend",
        "libcrypto-family backend to compile: openssl",
    ) orelse "openssl";
    if (!std.mem.eql(u8, crypto_backend, "openssl")) {
        std.debug.panic(
            "unsupported -Dcrypto-backend={s}; only openssl is implemented",
            .{crypto_backend},
        );
    }
    const build_options = b.addOptions();
    build_options.addOption([]const u8, "crypto_backend", crypto_backend);

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
        .benchmark_dep = benchmark_dep,
        .txtar_mod = txtar_mod,
    });

    examples_mod.addSteps(b, .{
        .target = target,
        .optimize = optimize,
        .ztls_mod = mod,
        .txtar_mod = txtar_mod,
    });
}
