const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const ztls_dep = b.dependency("ztls", .{
        .target = target,
        .optimize = optimize,
    });
    const ztls_mod = ztls_dep.module("ztls");

    {
        const exe = b.addExecutable(.{
            .name = "tlsfuzzer_server",
            .root_module = b.createModule(.{
                .root_source_file = b.path("src/tlsfuzzer_server.zig"),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "ztls", .module = ztls_mod }},
            }),
        });
        exe.linkLibC();
        const install = b.addInstallArtifact(exe, .{});
        const step = b.step("tlsfuzzer-server", "Build the tlsfuzzer server harness");
        step.dependOn(&install.step);
    }

    {
        const exe = b.addExecutable(.{
            .name = "anvil_client",
            .root_module = b.createModule(.{
                .root_source_file = b.path("src/anvil_client.zig"),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "ztls", .module = ztls_mod }},
            }),
        });
        exe.linkLibC();
        const install = b.addInstallArtifact(exe, .{});
        const step = b.step("anvil-client", "Build the TLS-Anvil client harness");
        step.dependOn(&install.step);
    }

    {
        const exe = b.addExecutable(.{
            .name = "bogo",
            .root_module = b.createModule(.{
                .root_source_file = b.path("src/bogo.zig"),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "ztls", .module = ztls_mod }},
            }),
        });
        exe.linkLibC();
        const install = b.addInstallArtifact(exe, .{});
        const step = b.step("bogo", "Build the BoGo harness");
        step.dependOn(&install.step);
    }
}
