const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const crypto_fips = b.option(
        bool,
        "crypto-fips",
        "Narrow the inferred libcrypto backend to its FIPS capability identity",
    ) orelse false;

    const ztls_dep = b.dependency("ztls", .{
        .target = target,
        .optimize = optimize,
        .@"crypto-fips" = crypto_fips,
    });
    const ztls_mod = ztls_dep.module("ztls");

    // Shared networking helpers — same module as the examples.

    // Test fixtures module — same module as the root build.
    const fixtures_mod = b.createModule(.{
        .root_source_file = b.path("../tests/fixtures/fixtures.zig"),
        .target = target,
        .optimize = optimize,
    });

    {
        const dep = b.dependency("tlsanvil", .{});
        const jar = dep.path("TLS-Anvil.jar");
        const install_jar = b.addInstallFile(jar, "tools/TLS-Anvil.jar");
        // TLS-Anvil's manifest references adjacent lib/*.jar entries; install
        // them with the main jar so `java -jar zig-out/tools/TLS-Anvil.jar`
        // reaches the CLI instead of failing during class loading.
        const install_lib = b.addInstallDirectory(.{
            .source_dir = dep.path("lib"),
            .install_dir = .{ .custom = "tools" },
            .install_subdir = "lib",
        });
        b.getInstallStep().dependOn(&install_jar.step);
        b.getInstallStep().dependOn(&install_lib.step);
        // #91: repair missing CA constraints and DateTime serialization in
        // the installed fixture jars, leaving the pinned dependencies intact.
        const patch_chain_provider = b.addSystemCommand(&.{
            "bash",
        });
        patch_chain_provider.addFileArg(b.path("scripts/anvil-chain-provider-patch/apply.sh"));
        patch_chain_provider.addArg(b.getInstallPath(.{ .custom = "tools" }, "lib"));
        patch_chain_provider.step.dependOn(&install_jar.step);
        patch_chain_provider.step.dependOn(&install_lib.step);
        b.getInstallStep().dependOn(&patch_chain_provider.step);
    }

    inline for (.{
        .{ .name = "tlsfuzzer_server", .src = "src/tlsfuzzer_server.zig" },
        .{ .name = "anvil_client", .src = "src/anvil_client.zig" },
    }) |entry| {
        const exe_mod = b.createModule(.{
            .root_source_file = b.path(entry.src),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "ztls", .module = ztls_mod }},
        });
        exe_mod.addImport("fixtures", fixtures_mod);
        exe_mod.link_libc = true;
        const exe = b.addExecutable(.{
            .name = entry.name,
            .root_module = exe_mod,
        });
        b.installArtifact(exe);
    }

    // Harness unit tests (#91 diagnostics probe: record reconstruction and
    // source-port lookup). Run with `zig build test` inside conformance/.
    const test_step = b.step("test", "Run conformance harness unit tests");
    {
        const mod = b.createModule(.{
            .root_source_file = b.path("src/anvil_client.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "ztls", .module = ztls_mod }},
        });
        mod.addImport("fixtures", fixtures_mod);
        mod.link_libc = true;
        const unit_tests = b.addTest(.{ .root_module = mod });
        const run_tests = b.addRunArtifact(unit_tests);
        run_tests.has_side_effects = true;
        test_step.dependOn(&run_tests.step);
    }
}
