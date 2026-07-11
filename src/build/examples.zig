const std = @import("std");
const Build = std.Build;

pub fn addSteps(b: *Build, opts: struct {
    target: Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    ztls_mod: *Build.Module,
    txtar_mod: ?*Build.Module,
}) void {
    const mod = opts.ztls_mod;

    // Shared 0.15/0.16 networking compat shim — examples and conformance both
    // import it so neither carries a divergent copy.
    const net_compat_mod = b.createModule(.{
        .root_source_file = b.path("shared/net_compat.zig"),
        .target = opts.target,
        .optimize = opts.optimize,
    });

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
        exe_mod.addImport("net_compat", net_compat_mod);
        if (opts.txtar_mod) |tm| exe_mod.addImport("txtar", tm);
        const exe = b.addExecutable(.{ .name = name, .root_module = exe_mod });
        const run = b.addRunArtifact(exe);
        if (b.args) |args| run.addArgs(args);
        const step = b.step(b.fmt("example-{s}", .{name}), b.fmt("Run {s} example", .{name}));
        step.dependOn(&run.step);
    }

    if (opts.target.result.os.tag == .linux) {
        const linux_examples = [_][]const u8{
            "iouring_client",
            "iouring_pingpong",
            "epoll_pingpong",
            "ktls_server",
        };
        for (linux_examples) |name| {
            const exe_mod = b.createModule(.{
                .root_source_file = b.path(b.fmt("examples/{s}.zig", .{name})),
                .target = opts.target,
                .optimize = opts.optimize,
                .imports = &.{.{ .name = "ztls", .module = mod }},
            });
            exe_mod.addImport("net_compat", net_compat_mod);
            const exe = b.addExecutable(.{ .name = name, .root_module = exe_mod });
            const run = b.addRunArtifact(exe);
            if (b.args) |args| run.addArgs(args);
            const step = b.step(
                b.fmt("example-{s}", .{name}),
                b.fmt("Run Linux {s} example", .{name}),
            );
            step.dependOn(&run.step);
        }
    }
}
