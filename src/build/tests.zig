const std = @import("std");
const Build = std.Build;

pub fn addSteps(b: *Build, opts: struct {
    target: Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    ztls_mod: *Build.Module,
    test_mod: *Build.Module,
}) void {
    const mod = opts.ztls_mod;

    const mod_tests = b.addTest(.{ .root_module = opts.test_mod });
    const run_tests = b.addRunArtifact(mod_tests);
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_tests.step);

    const interop_exe = b.addExecutable(.{
        .name = "openssl_interop",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/test/openssl_interop.zig"),
            .target = opts.target,
            .optimize = opts.optimize,
            .imports = &.{.{ .name = "ztls", .module = mod }},
        }),
    });
    const run_interop = b.addRunArtifact(interop_exe);
    const interop_step = b.step("test-openssl", "Run the openssl s_server interop test");
    interop_step.dependOn(&run_interop.step);

    const server_interop_exe = b.addExecutable(.{
        .name = "openssl_server_interop",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/test/openssl_server_interop.zig"),
            .target = opts.target,
            .optimize = opts.optimize,
            .imports = &.{.{ .name = "ztls", .module = mod }},
        }),
    });
    const run_server_interop = b.addRunArtifact(server_interop_exe);
    const server_interop_step = b.step(
        "test-openssl-server",
        "Run the openssl s_client interop test",
    );
    server_interop_step.dependOn(&run_server_interop.step);

    const wycheproof_tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/test/wycheproof_smoke.zig"),
            .target = opts.target,
            .optimize = opts.optimize,
            .imports = &.{.{ .name = "ztls", .module = mod }},
        }),
    });
    const run_wycheproof = b.addRunArtifact(wycheproof_tests);
    const wycheproof_step = b.step("test-wycheproof", "Run Wycheproof boundary smoke vectors");
    wycheproof_step.dependOn(&run_wycheproof.step);
}
