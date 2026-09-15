const std = @import("std");

const Mode = enum {
    core,
    std,
    xev,
    xev_without_option,
    ktls,
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const mode = b.option(Mode, "mode", "ztls module to compile") orelse .core;

    const ztls_dep = if (mode == .xev)
        b.dependency("ztls", .{
            .target = target,
            .optimize = optimize,
            .xev = true,
        })
    else
        b.dependency("ztls", .{
            .target = target,
            .optimize = optimize,
        });
    const integration_name = switch (mode) {
        .core => "ztls",
        .std => "ztls_std",
        .xev, .xev_without_option => "ztls_xev",
        .ktls => "ztls_ktls",
    };

    const options = b.addOptions();
    options.addOption([]const u8, "mode", @tagName(mode));

    const exe = b.addExecutable(.{
        .name = "ztls-distribution-consumer",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "ztls", .module = ztls_dep.module("ztls") },
                .{ .name = "integration", .module = ztls_dep.module(integration_name) },
                .{ .name = "consumer_options", .module = options.createModule() },
            },
        }),
    });
    b.installArtifact(exe);
}
