const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Mirror the ztls core's crypto-backend option so this package builds
    // against the same libcrypto the devshell selects (OpenSSL default).
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

    // The ztls-std library module: exposes the opinionated std.Io.net TLS
    // stream wrapper. Consumers import this as `@import("ztls_std")`.
    const mod = b.addModule("ztls_std", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .imports = &.{
            .{ .name = "ztls", .module = ztls_mod },
        },
    });

    // Smoke executable: proves the ztls-std + ztls wiring builds and runs.
    const exe = b.addExecutable(.{
        .name = "ztls_std",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "ztls_std", .module = mod },
            },
        }),
    });
    b.installArtifact(exe);

    const run_step = b.step("run", "Run the smoke executable");
    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| run_cmd.addArgs(args);

    // Tests.
    const mod_tests = b.addTest(.{ .root_module = mod });
    const run_mod_tests = b.addRunArtifact(mod_tests);
    const exe_tests = b.addTest(.{ .root_module = exe.root_module });
    const run_exe_tests = b.addRunArtifact(exe_tests);

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_mod_tests.step);
    test_step.dependOn(&run_exe_tests.step);
}
