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
    /// The ztls library module, for standalone check executables that must
    /// control the process environment before any libcrypto call.
    ztls_mod: *Build.Module,
    /// Build target for standalone check executables. Required: the only
    /// caller (build.zig) always passes it.
    target: Build.ResolvedTarget,
    /// Optimization mode for standalone check executables. Required: the
    /// only caller (build.zig) always passes it.
    optimize: std.builtin.OptimizeMode,
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

    // #88 finding 2 — allocation-count evidence for the error-queue guards.
    // CRYPTO_set_mem_functions must be installed before the first libcrypto
    // allocation, so this check is a standalone executable with its own build
    // step. BoringSSL builds compile a no-op main because the API is absent;
    // queue hygiene still applies on that lane.
    const errq_mod = b.createModule(.{
        .root_source_file = b.path("src/test/errq_alloc_check.zig"),
        .target = opts.target,
        .optimize = opts.optimize,
    });
    errq_mod.addImport("ztls", opts.ztls_mod);
    errq_mod.link_libc = true;
    errq_mod.linkSystemLibrary("crypto", .{});

    const errq_exe = b.addExecutable(.{
        .name = "errq-alloc-check",
        .root_module = errq_mod,
    });
    const run_errq = b.addRunArtifact(errq_exe);
    run_errq.has_side_effects = true;
    test_step.dependOn(&run_errq.step);
    const errq_step = b.step(
        "errq-alloc-check",
        "Run the #88 error-queue allocation-count check (OpenSSL and AWS-LC)",
    );
    errq_step.dependOn(&run_errq.step);
}
