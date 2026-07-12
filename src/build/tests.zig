const std = @import("std");
const Build = std.Build;

pub fn addSteps(b: *Build, opts: struct {
    test_mod: *Build.Module,
}) void {
    const mod_tests = b.addTest(.{ .root_module = opts.test_mod });
    const run_tests = b.addRunArtifact(mod_tests);
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_tests.step);

    // Install the test binary so it can be run under valgrind/external tools:
    //   zig build install
    //   valgrind --leak-check=no --error-exitcode=1 ./zig-out/bin/test
    const install_tests = b.addInstallArtifact(mod_tests, .{});
    const valgrind_step = b.step("test-bin", "Install the test binary for external tooling (valgrind, etc.)");
    valgrind_step.dependOn(&install_tests.step);
}
