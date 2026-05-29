const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.addModule("ztls", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const mod_tests = b.addTest(.{ .root_module = mod });
    const run_tests = b.addRunArtifact(mod_tests);
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_tests.step);

    const examples = [_][]const u8{
        "full_handshake",
        "handshake_keys",
        "key_schedule",
        "record_protection",
    };
    for (examples) |name| {
        const exe = b.addExecutable(.{
            .name = name,
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("examples/{s}.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "ztls", .module = mod }},
            }),
        });
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
