const std = @import("std");
const Build = std.Build;

pub fn addSteps(b: *Build, opts: struct {
    test_mod: *Build.Module,
}) void {
    const mod_tests = b.addTest(.{ .root_module = opts.test_mod });
    const run_tests = b.addRunArtifact(mod_tests);
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_tests.step);
}
