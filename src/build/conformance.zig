const std = @import("std");
const Build = std.Build;

pub fn addSteps(b: *Build, opts: struct {
    target: Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    ztls_mod: *Build.Module,
}) void {
    const mod = opts.ztls_mod;

    const tlsfuzzer_server_exe = b.addExecutable(.{
        .name = "ztls_tlsfuzzer_server",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/test/tlsfuzzer_server.zig"),
            .target = opts.target,
            .optimize = opts.optimize,
            .imports = &.{.{ .name = "ztls", .module = mod }},
        }),
    });
    const install_tlsfuzzer_server = b.addInstallArtifact(tlsfuzzer_server_exe, .{});
    const tlsfuzzer_server_step = b.step("tlsfuzzer-server", "Build the tlsfuzzer TCP server");
    tlsfuzzer_server_step.dependOn(&install_tlsfuzzer_server.step);

    const tls_anvil_client_exe = b.addExecutable(.{
        .name = "ztls_tls_anvil_client",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/test/tls_anvil_client.zig"),
            .target = opts.target,
            .optimize = opts.optimize,
            .imports = &.{.{ .name = "ztls", .module = mod }},
        }),
    });
    const install_tls_anvil_client = b.addInstallArtifact(tls_anvil_client_exe, .{});
    const tls_anvil_client_step = b.step("tls-anvil-client", "Build the TLS-Anvil TCP client");
    tls_anvil_client_step.dependOn(&install_tls_anvil_client.step);

    const bogo_shim_exe = b.addExecutable(.{
        .name = "ztls_bogo_shim",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/test/bogo_shim.zig"),
            .target = opts.target,
            .optimize = opts.optimize,
            .imports = &.{.{ .name = "ztls", .module = mod }},
        }),
    });
    const install_bogo_shim = b.addInstallArtifact(bogo_shim_exe, .{});
    const bogo_shim_step = b.step("bogo-shim", "Build the BoGo shim");
    bogo_shim_step.dependOn(&install_bogo_shim.step);
}
