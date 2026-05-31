const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.addModule("ztls", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Tests get their own module so the txtar dependency (used only to decode
    // the RFC 8448 fixture archive) never leaks into the public ztls module.
    const test_mod = b.createModule(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    // txtar decodes the RFC 8448 fixture archive. Lazy: only fetched when a
    // step that needs it (tests, the full_handshake example) is built.
    const txtar_mod: ?*std.Build.Module = if (b.lazyDependency("txtar", .{
        .target = target,
        .optimize = optimize,
    })) |dep| dep.module("txtar") else null;
    if (txtar_mod) |tm| test_mod.addImport("txtar", tm);
    const mod_tests = b.addTest(.{ .root_module = test_mod });
    const run_tests = b.addRunArtifact(mod_tests);
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_tests.step);

    // Interop harness: drives the client against openssl s_server. Kept out of
    // the unit `test` step since it needs openssl and the network.
    const interop_exe = b.addExecutable(.{
        .name = "openssl_interop",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/test/openssl_interop.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "ztls", .module = mod }},
        }),
    });
    const run_interop = b.addRunArtifact(interop_exe);
    const interop_step = b.step("test-openssl", "Run the openssl s_server interop test");
    interop_step.dependOn(&run_interop.step);

    const examples = [_][]const u8{
        "full_handshake",
        "handshake_keys",
        "key_schedule",
        "record_protection",
    };
    for (examples) |name| {
        const exe_mod = b.createModule(.{
            .root_source_file = b.path(b.fmt("examples/{s}.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "ztls", .module = mod }},
        });
        if (txtar_mod) |tm| exe_mod.addImport("txtar", tm);
        const exe = b.addExecutable(.{ .name = name, .root_module = exe_mod });
        const run = b.addRunArtifact(exe);
        const step = b.step(b.fmt("example-{s}", .{name}), b.fmt("Run {s} example", .{name}));
        step.dependOn(&run.step);

        const asm_step = b.step(b.fmt("example-{s}-asm", .{name}), b.fmt("Emit asm for {s} example", .{name}));
        const asm_exe = b.addExecutable(.{
            .name = name,
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("examples/{s}.zig", .{name})),
                .target = target,
                .optimize = .ReleaseFast,
                .imports = &.{.{ .name = "ztls", .module = mod }},
            }),
        });
        _ = asm_exe.getEmittedAsm();
        asm_step.dependOn(&asm_exe.step);
    }
}
