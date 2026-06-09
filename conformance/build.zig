const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const ztls_dep = b.dependency("ztls", .{
        .target = target,
        .optimize = optimize,
    });
    const ztls_mod = ztls_dep.module("ztls");

    inline for (.{
        .{ .name = "tlsfuzzer_server", .src = "src/tlsfuzzer_server.zig" },
        .{ .name = "anvil_client", .src = "src/anvil_client.zig" },
        .{ .name = "bogo", .src = "src/bogo.zig" },
    }) |entry| {
        const exe = b.addExecutable(.{
            .name = entry.name,
            .root_module = b.createModule(.{
                .root_source_file = b.path(entry.src),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "ztls", .module = ztls_mod }},
            }),
        });
        exe.linkLibC();
        b.installArtifact(exe);
    }
}
