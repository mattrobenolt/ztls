const std = @import("std");
const Build = std.Build;

pub fn addSteps(b: *Build, opts: struct {
    test_mod: *Build.Module,
    /// When true, use the default test runner (needed for `--fuzz`, which
    /// requires the server protocol that ztest's `.mode = .simple` skips).
    fuzz: bool = false,
    /// ztest dependency — a plain-text test runner that writes one line per
    /// test to stderr instead of Zig's TUI. Null when the lazy dependency has
    /// not been fetched (e.g. when building non-test steps).
    ztest: ?*Build.Dependency = null,
}) void {
    const mod_tests = b.addTest(.{
        .root_module = opts.test_mod,
        .test_runner = if (opts.fuzz) null else if (opts.ztest) |z|
            .{ .path = z.path("src/test_runner.zig"), .mode = .simple }
        else
            null,
    });
    const run_tests = b.addRunArtifact(mod_tests);
    run_tests.has_side_effects = true; // always run tests, don't cache
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_tests.step);

    // Install the test binary so it can be run under valgrind/external tools:
    //   zig build install
    //   valgrind --leak-check=no --error-exitcode=1 ./zig-out/bin/test
    const install_tests = b.addInstallArtifact(mod_tests, .{});
    const valgrind_step = b.step(
        "test-bin",
        "Install the test binary for external tooling (valgrind, etc.)",
    );
    valgrind_step.dependOn(&install_tests.step);
}
