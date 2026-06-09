const std = @import("std");
const Build = std.Build;

pub fn addSteps(b: *Build, opts: struct {
    target: Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    ztls_mod: *Build.Module,
}) void {
    const mod = opts.ztls_mod;

    const replay_fixtures_exe = b.addExecutable(.{
        .name = "generate_replay_fixtures",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/test/generate_replay_fixtures.zig"),
            .target = opts.target,
            .optimize = opts.optimize,
            .imports = &.{.{ .name = "ztls", .module = mod }},
        }),
    });
    const run_replay_fixtures = b.addRunArtifact(replay_fixtures_exe);
    const replay_fixtures_step = b.step(
        "generate-replay-fixtures",
        "Generate OpenSSL replay fixtures for benchmarks",
    );
    replay_fixtures_step.dependOn(&run_replay_fixtures.step);
}
