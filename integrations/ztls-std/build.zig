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

    // Fixtures module for tests (ECDSA P-256 test cert + scalar).
    const fixtures_mod = b.addModule("fixtures", .{
        .root_source_file = ztls_dep.path("tests/fixtures/fixtures.zig"),
        .target = target,
        .optimize = optimize,
    });

    // The ztls-std library module: exposes the opinionated std.Io.net TLS
    // stream wrapper. Consumers import this as `@import("ztls_std")`.
    const mod = b.addModule("ztls_std", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .imports = &.{
            .{ .name = "ztls", .module = ztls_mod },
        },
    });
    // Tests need fixtures for the in-memory round-trip.
    mod.addImport("fixtures", fixtures_mod);

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

    // Examples: runnable programs that exercise the higher-order ztls-std
    // API (Client.connect / Server.accept / Stream.reader / writer). Each is
    // wired as `zig build example-<name>`.
    const examples = [_][]const u8{
        "tls_client",
    };
    for (examples) |name| {
        const exe_mod = b.createModule(.{
            .root_source_file = b.path(b.fmt("examples/{s}.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "ztls_std", .module = mod },
                .{ .name = "ztls", .module = ztls_mod },
            },
        });
        exe_mod.addImport("fixtures", fixtures_mod);
        const example_exe = b.addExecutable(.{
            .name = name,
            .root_module = exe_mod,
        });
        const run = b.addRunArtifact(example_exe);
        if (b.args) |args| run.addArgs(args);
        const step = b.step(
            b.fmt("example-{s}", .{name}),
            b.fmt("Run {s} example", .{name}),
        );
        step.dependOn(&run.step);
    }

    // Tests.
    const mod_tests = b.addTest(.{ .root_module = mod });
    const run_mod_tests = b.addRunArtifact(mod_tests);
    const exe_tests = b.addTest(.{ .root_module = exe.root_module });
    const run_exe_tests = b.addRunArtifact(exe_tests);

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_mod_tests.step);
    test_step.dependOn(&run_exe_tests.step);
}
