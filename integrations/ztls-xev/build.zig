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

    const xev_mod = b.dependency("libxev", .{
        .target = target,
        .optimize = optimize,
    }).module("xev");

    // Fixtures module (ECDSA P-256 test cert + scalar). Test-only: wired into
    // the round-trip test module, never into the library module, so consumers
    // do not inherit a dependency on test fixtures.
    const fixtures_mod = b.addModule("fixtures", .{
        .root_source_file = ztls_dep.path("tests/fixtures/fixtures.zig"),
        .target = target,
        .optimize = optimize,
    });

    // The ztls-xev library module. Consumers import this as
    // `@import("ztls_xev")`.
    // link_libc is needed because ztest's runner uses libc for getenv/isatty.
    const mod = b.addModule("ztls_xev", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .link_libc = true,
        .imports = &.{
            .{ .name = "ztls", .module = ztls_mod },
            .{ .name = "xev", .module = xev_mod },
        },
    });

    const Example = struct {
        name: []const u8,
        /// Examples that present a certificate need the test fixtures.
        needs_fixtures: bool = false,
    };
    const examples = [_]Example{
        .{ .name = "xev_client" },
        .{ .name = "xev_server", .needs_fixtures = true },
    };
    var example_test_runs: [examples.len]*std.Build.Step.Run = undefined;
    const build_examples_step = b.step(
        "build-examples",
        "Compile every example (no peer required)",
    );
    for (examples, &example_test_runs) |example, *test_run| {
        const name = example.name;
        const exe_mod = b.createModule(.{
            .root_source_file = b.path(b.fmt("examples/{s}.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "ztls_xev", .module = mod },
                .{ .name = "ztls", .module = ztls_mod },
                .{ .name = "xev", .module = xev_mod },
            },
        });
        if (example.needs_fixtures) exe_mod.addImport("fixtures", fixtures_mod);
        const example_exe = b.addExecutable(.{ .name = name, .root_module = exe_mod });
        const run = b.addRunArtifact(example_exe);
        if (b.args) |args| run.addArgs(args);
        const step = b.step(
            b.fmt("example-{s}", .{name}),
            b.fmt("Run {s} example", .{name}),
        );
        step.dependOn(&run.step);
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

    // Standalone libxev behaviour probe. Not a test: it answers questions about
    // the event loop itself, and its output is meant to be read, not asserted.
    const probe_exe = b.addExecutable(.{
        .name = "cancel_accounting",
        .root_module = b.createModule(.{
            .root_source_file = b.path("probe/cancel_accounting.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "xev", .module = xev_mod }},
            .link_libc = true,
        }),
    });
    const probe_run = b.addRunArtifact(probe_exe);
    const probe_step = b.step("probe-cancel", "Probe libxev cancel/close accounting on this host");
    probe_step.dependOn(&probe_run.step);

    const two_exe = b.addExecutable(.{
        .name = "two_conn_cancel",
        .root_module = b.createModule(.{
            .root_source_file = b.path("probe/two_conn_cancel.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "xev", .module = xev_mod }},
            .link_libc = true,
        }),
    });
    probe_step.dependOn(&b.addRunArtifact(two_exe).step);

    // Tests: unit tests inside the library module, plus the fixture-backed
    // round-trip suite driving a real event loop.
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
                .{ .name = "ztls_xev", .module = mod },
                .{ .name = "ztls", .module = ztls_mod },
                .{ .name = "xev", .module = xev_mod },
                .{ .name = "fixtures", .module = fixtures_mod },
            },
        }),
        .test_runner = test_runner,
    });
    const run_roundtrip_tests = b.addRunArtifact(roundtrip_tests);
    run_roundtrip_tests.has_side_effects = true;

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_mod_tests.step);
    test_step.dependOn(&run_roundtrip_tests.step);
    for (example_test_runs) |run| test_step.dependOn(&run.step);
}
