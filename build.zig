const std = @import("std");
const builtin = @import("builtin");

fn nativeTarget() std.Target.Query {
    var query: std.Target.Query = .{ .cpu_model = .native };
    // Zig's native CPU detection reports generic under some Apple-Silicon Linux
    // VMs despite /proc/cpuinfo exposing aes/pmull. For performance work that
    // silently selects std.crypto's soft AES path, which is not a useful target.
    if (builtin.cpu.arch == .aarch64 and builtin.os.tag == .linux) {
        query.cpu_model = .{ .explicit = &std.Target.aarch64.cpu.apple_m1 };
    }
    return query;
}

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{
        .default_target = nativeTarget(),
    });
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.addModule("ztls", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Tests get their own module so the txtar dependency (used only to decode
    // the RFC 8448 fixture archive) never leaks into the public ztls module.
    const test_mod = b.createModule(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    // txtar decodes the RFC 8448 fixture archive. Lazy: only fetched when a
    // step that needs it (tests, the full_handshake example) is built.
    const txtar_mod: ?*std.Build.Module = if (b.lazyDependency("txtar", .{
        .target = target,
        .optimize = optimize,
    })) |dep| dep.module("txtar") else null;
    if (txtar_mod) |tm| test_mod.addImport("txtar", tm);
    const mod_tests = b.addTest(.{ .root_module = test_mod });
    const run_tests = b.addRunArtifact(mod_tests);
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_tests.step);

    // Interop harness: drives the client against openssl s_server. Kept out of
    // the unit `test` step since it needs openssl and the network.
    const interop_exe = b.addExecutable(.{
        .name = "openssl_interop",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/test/openssl_interop.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "ztls", .module = mod }},
        }),
    });
    const run_interop = b.addRunArtifact(interop_exe);
    const interop_step = b.step("test-openssl", "Run the openssl s_server interop test");
    interop_step.dependOn(&run_interop.step);

    const replay_fixtures_exe = b.addExecutable(.{
        .name = "generate_replay_fixtures",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/test/generate_replay_fixtures.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "ztls", .module = mod }},
        }),
    });
    const run_replay_fixtures = b.addRunArtifact(replay_fixtures_exe);
    const replay_fixtures_step = b.step("generate-replay-fixtures", "Generate OpenSSL replay fixtures for benchmarks");
    replay_fixtures_step.dependOn(&run_replay_fixtures.step);

    const bench_mod = b.addModule("ztls_bench", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    const bench_root = b.createModule(.{
        .root_source_file = b.path("bench/record_protection.zig"),
        .target = target,
        .optimize = .ReleaseFast,
        .imports = &.{.{ .name = "ztls", .module = bench_mod }},
    });
    if (txtar_mod) |tm| bench_root.addImport("txtar", tm);
    const bench_exe = b.addExecutable(.{
        .name = "record_protection_bench",
        .root_module = bench_root,
    });
    const run_bench = b.addRunArtifact(bench_exe);
    if (b.args) |args| run_bench.addArgs(args);
    const bench_step = b.step("bench", "Run performance benchmarks");
    bench_step.dependOn(&run_bench.step);

    const install_bench = b.addInstallArtifact(bench_exe, .{});
    const bench_bin_step = b.step("bench-bin", "Build the benchmark binary for profiling");
    bench_bin_step.dependOn(&install_bench.step);

    const evp_bench_mod = b.createModule(.{
        .target = target,
        .optimize = .ReleaseFast,
        .link_libc = true,
    });
    const evp_bench = b.addExecutable(.{
        .name = "openssl_evp_bench",
        .root_module = evp_bench_mod,
    });
    evp_bench.addCSourceFile(.{ .file = b.path("bench/openssl_evp.c"), .flags = &.{"-O3"} });
    evp_bench.linkLibC();
    evp_bench.linkSystemLibrary("crypto");
    const run_evp_bench = b.addRunArtifact(evp_bench);
    if (b.args) |args| run_evp_bench.addArgs(args);
    const evp_bench_step = b.step("bench-evp", "Run OpenSSL EVP AEAD benchmarks");
    evp_bench_step.dependOn(&run_evp_bench.step);
    const install_evp_bench = b.addInstallArtifact(evp_bench, .{});
    const evp_bench_bin_step = b.step("bench-evp-bin", "Build the OpenSSL EVP benchmark binary");
    evp_bench_bin_step.dependOn(&install_evp_bench.step);

    const bio_bench_mod = b.createModule(.{
        .target = target,
        .optimize = .ReleaseFast,
        .link_libc = true,
    });
    const bio_bench = b.addExecutable(.{
        .name = "openssl_bio_bench",
        .root_module = bio_bench_mod,
    });
    bio_bench.addCSourceFile(.{ .file = b.path("bench/openssl_bio.c"), .flags = &.{"-O3"} });
    bio_bench.linkLibC();
    bio_bench.linkSystemLibrary("ssl");
    bio_bench.linkSystemLibrary("crypto");
    const run_bio_bench = b.addRunArtifact(bio_bench);
    if (b.args) |args| run_bio_bench.addArgs(args);
    const bio_bench_step = b.step("bench-openssl", "Run OpenSSL libssl memory BIO benchmarks");
    bio_bench_step.dependOn(&run_bio_bench.step);
    const install_bio_bench = b.addInstallArtifact(bio_bench, .{});
    const bio_bench_bin_step = b.step("bench-openssl-bin", "Build the OpenSSL memory BIO benchmark binary");
    bio_bench_bin_step.dependOn(&install_bio_bench.step);

    const examples = [_][]const u8{
        "full_handshake",
        "handshake_keys",
        "key_schedule",
        "record_protection",
    };
    for (examples) |name| {
        const exe_mod = b.createModule(.{
            .root_source_file = b.path(b.fmt("examples/{s}.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "ztls", .module = mod }},
        });
        if (txtar_mod) |tm| exe_mod.addImport("txtar", tm);
        const exe = b.addExecutable(.{ .name = name, .root_module = exe_mod });
        const run = b.addRunArtifact(exe);
        const step = b.step(b.fmt("example-{s}", .{name}), b.fmt("Run {s} example", .{name}));
        step.dependOn(&run.step);

        const asm_step = b.step(b.fmt("example-{s}-asm", .{name}), b.fmt("Emit asm for {s} example", .{name}));
        const asm_exe = b.addExecutable(.{
            .name = name,
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("examples/{s}.zig", .{name})),
                .target = target,
                .optimize = .ReleaseFast,
                .imports = &.{.{ .name = "ztls", .module = mod }},
            }),
        });
        _ = asm_exe.getEmittedAsm();
        asm_step.dependOn(&asm_exe.step);
    }
}
