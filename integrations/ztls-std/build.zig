const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Mirror the ztls core's crypto-backend option so this package builds
    // against the same libcrypto the devshell selects (OpenSSL default).
    const crypto_backend = b.option(
        []const u8,
        "crypto-backend",
        "libcrypto backend: openssl | aws-lc | boringssl",
    ) orelse "openssl";

    const ztls_dep = b.dependency("ztls", .{
        .target = target,
        .optimize = optimize,
        .@"crypto-backend" = crypto_backend,
    });
    const ztls_mod = ztls_dep.module("ztls");

    // ztest: plain-text test runner. Lazy — only fetched when the test step
    // is built, not when consumers use this package as a dependency.
    const ztest_dep = b.lazyDependency("ztest", .{});
    const test_runner: ?std.Build.Step.Compile.TestRunner = if (ztest_dep) |z|
        .{ .path = z.path("src/test_runner.zig"), .mode = .simple }
    else
        null;

    // Fixtures module (ECDSA P-256 test cert + scalar). Test-only: it is wired
    // into the round-trip test module below, never into the library module, so
    // consumers of ztls_std do not inherit a dependency on test fixtures.
    const fixtures_mod = b.addModule("fixtures", .{
        .root_source_file = ztls_dep.path("tests/fixtures/fixtures.zig"),
        .target = target,
        .optimize = optimize,
    });

    // The ztls-std library module: exposes the opinionated std.Io.net TLS
    // stream wrapper. Consumers import this as `@import("ztls_std")`.
    // link_libc is needed because ztest's runner uses libc for getenv/isatty.
    const mod = b.addModule("ztls_std", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .link_libc = true,
        .imports = &.{
            .{ .name = "ztls", .module = ztls_mod },
        },
    });

    // Smoke executable: proves the ztls-std + ztls wiring builds and runs.
    const exe = b.addExecutable(.{
        .name = "ztls_std",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "ztls_std", .module = mod },
            },
        }),
    });
    b.installArtifact(exe);

    const build_examples_step = b.step(
        "build-examples",
        "Compile every example (no peer required)",
    );

    const run_step = b.step("run", "Run the smoke executable");
    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| run_cmd.addArgs(args);

    // Examples: runnable programs that exercise the higher-order ztls-std
    // API (Client.connect / Server.accept / Stream.reader / writer). Each is
    // wired as `zig build example-<name>`.
    const Example = struct {
        name: []const u8,
        /// Examples that drive ztls-std on a third-party `std.Io` runtime pull
        /// that runtime in lazily, so it is fetched only when the example is
        /// actually built.
        needs_zio: bool = false,
    };
    const examples = [_]Example{
        .{ .name = "tls_client" },
        .{ .name = "zio_client", .needs_zio = true },
    };
    var example_test_runs: [examples.len]?*std.Build.Step.Run = @splat(null);
    for (examples, &example_test_runs) |example, *test_run| {
        const name = example.name;
        const exe_mod = b.createModule(.{
            .root_source_file = b.path(b.fmt("examples/{s}.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "ztls_std", .module = mod },
                .{ .name = "ztls", .module = ztls_mod },
            },
        });
        if (example.needs_zio) {
            const zio_dep = b.lazyDependency("zio", .{
                .target = target,
                .optimize = optimize,
            }) orelse continue;
            exe_mod.addImport("zio", zio_dep.module("zio"));
        }
        const example_exe = b.addExecutable(.{
            .name = name,
            .root_module = exe_mod,
        });
        const run = b.addRunArtifact(example_exe);
        if (b.args) |args| run.addArgs(args);
        const step = b.step(
            b.fmt("example-{s}", .{name}),
            b.fmt("Run {s} example", .{name}),
        );
        step.dependOn(&run.step);

        // Examples carry unit tests for their own helpers; `zig build test`
        // runs them, and `build-examples` proves every example still compiles
        // without needing a peer to talk to.
        exe_mod.link_libc = true;
        const example_tests = b.addTest(.{
            .root_module = exe_mod,
            .test_runner = test_runner,
        });
        const run_example_tests = b.addRunArtifact(example_tests);
        run_example_tests.has_side_effects = true;
        test_run.* = run_example_tests;
        build_examples_step.dependOn(&b.addInstallArtifact(example_exe, .{}).step);
    }

    // Tests: unit tests inside the library module, plus the fixture-backed
    // round-trip suite that exercises only the public API.
    const mod_tests = b.addTest(.{
        .root_module = mod,
        .test_runner = test_runner,
    });
    const run_mod_tests = b.addRunArtifact(mod_tests);
    run_mod_tests.has_side_effects = true;

    const roundtrip_tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/tests.zig"),
            .target = target,
            .optimize = optimize,
            .link_libc = true,
            .imports = &.{
                .{ .name = "ztls_std", .module = mod },
                .{ .name = "ztls", .module = ztls_mod },
                .{ .name = "fixtures", .module = fixtures_mod },
            },
        }),
        .test_runner = test_runner,
    });
    const run_roundtrip_tests = b.addRunArtifact(roundtrip_tests);
    run_roundtrip_tests.has_side_effects = true;

    const exe_tests = b.addTest(.{
        .root_module = exe.root_module,
        .test_runner = test_runner,
    });
    const run_exe_tests = b.addRunArtifact(exe_tests);
    run_exe_tests.has_side_effects = true;

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_mod_tests.step);
    test_step.dependOn(&run_roundtrip_tests.step);
    test_step.dependOn(&run_exe_tests.step);
    for (example_test_runs) |maybe_run| {
        if (maybe_run) |test_run| test_step.dependOn(&test_run.step);
    }
}
