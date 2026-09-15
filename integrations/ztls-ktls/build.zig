const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const crypto_backend = b.option(
        []const u8,
        "crypto-backend",
        "libcrypto backend: openssl | aws-lc | boringssl",
    ) orelse "openssl";

    const ztls_dep = b.dependency("ztls", .{
        .target = target,
        .optimize = optimize,
        .@"crypto-backend" = crypto_backend,
    });
    const ztls_mod = ztls_dep.module("ztls");
    const fixtures_mod = b.addModule("fixtures", .{
        .root_source_file = ztls_dep.path("tests/fixtures/fixtures.zig"),
        .target = target,
        .optimize = optimize,
    });
    const net_compat_mod = b.addModule("net_compat", .{
        .root_source_file = ztls_dep.path("shared/net_compat.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    const mod = b.addModule("ztls_ktls", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .link_libc = true,
        .imports = &.{.{ .name = "ztls", .module = ztls_mod }},
    });

    const ztest_dep = b.lazyDependency("ztest", .{});
    const test_runner: ?std.Build.Step.Compile.TestRunner = if (ztest_dep) |z|
        .{ .path = z.path("src/test_runner.zig"), .mode = .simple }
    else
        null;
    const tests = b.addTest(.{
        .root_module = mod,
        .test_runner = test_runner,
    });
    const run_tests = b.addRunArtifact(tests);
    run_tests.has_side_effects = true;

    const integration_tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("examples/ktls_pingpong.zig"),
            .target = target,
            .optimize = optimize,
            .link_libc = true,
            .imports = &.{
                .{ .name = "ztls_ktls", .module = mod },
                .{ .name = "ztls", .module = ztls_mod },
                .{ .name = "fixtures", .module = fixtures_mod },
                .{ .name = "net_compat", .module = net_compat_mod },
            },
        }),
        .test_runner = test_runner,
    });
    const run_integration_tests = b.addRunArtifact(integration_tests);
    run_integration_tests.has_side_effects = true;

    const test_step = b.step("test", "Run unit and Linux kTLS integration tests");
    test_step.dependOn(&run_tests.step);
    test_step.dependOn(&run_integration_tests.step);

    const build_examples_step = b.step("build-examples", "Compile every example");
    const example_mod = b.createModule(.{
        .root_source_file = b.path("examples/ktls_pingpong.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .imports = &.{
            .{ .name = "ztls_ktls", .module = mod },
            .{ .name = "ztls", .module = ztls_mod },
            .{ .name = "fixtures", .module = fixtures_mod },
            .{ .name = "net_compat", .module = net_compat_mod },
        },
    });
    const example = b.addExecutable(.{
        .name = "ktls_pingpong",
        .root_module = example_mod,
    });
    build_examples_step.dependOn(&b.addInstallArtifact(example, .{}).step);
}
