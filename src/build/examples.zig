const std = @import("std");
const Build = std.Build;

pub fn addSteps(b: *Build, opts: struct {
    target: Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    ztls_mod: *Build.Module,
    txtar_mod: ?*Build.Module,
}) void {
    const mod = opts.ztls_mod;

    const examples = [_][]const u8{
        "full_handshake",
        "handshake_keys",
        "https_client",
        "https_server",
        "in_memory_handshake",
        "key_schedule",
        "tcp_loopback",
        "record_protection",
    };
    for (examples) |name| {
        const exe_mod = b.createModule(.{
            .root_source_file = b.path(b.fmt("examples/{s}.zig", .{name})),
            .target = opts.target,
            .optimize = opts.optimize,
            .imports = &.{.{ .name = "ztls", .module = mod }},
        });
        if (opts.txtar_mod) |tm| exe_mod.addImport("txtar", tm);
        const exe = b.addExecutable(.{ .name = name, .root_module = exe_mod });
        const run = b.addRunArtifact(exe);
        const step = b.step(b.fmt("example-{s}", .{name}), b.fmt("Run {s} example", .{name}));
        step.dependOn(&run.step);
    }

    if (opts.target.result.os.tag == .linux) {
        const exe_mod = b.createModule(.{
            .root_source_file = b.path("examples/iouring_client.zig"),
            .target = opts.target,
            .optimize = opts.optimize,
            .imports = &.{.{ .name = "ztls", .module = mod }},
        });
        const exe = b.addExecutable(.{ .name = "iouring_client", .root_module = exe_mod });
        const run = b.addRunArtifact(exe);
        const step = b.step("example-iouring_client", "Run Linux io_uring client example");
        step.dependOn(&run.step);
    }
}
