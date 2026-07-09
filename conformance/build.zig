const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const env_map = if (@hasField(@TypeOf(b.graph.*), "environ_map"))
        b.graph.environ_map
    else
        b.graph.env_map;
    const env_crypto_backend = env_map.get("ZTLS_CRYPTO_BACKEND") orelse "";
    const crypto_backend = b.option(
        []const u8,
        "crypto-backend",
        "libcrypto-family backend to compile: openssl, aws-lc, boringssl, " ++
            "openssl-fips, aws-lc-fips",
    ) orelse if (env_crypto_backend.len > 0) env_crypto_backend else "openssl";

    const ztls_dep = b.dependency("ztls", .{
        .target = target,
        .optimize = optimize,
        .@"crypto-backend" = crypto_backend,
    });
    const ztls_mod = ztls_dep.module("ztls");

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
        exe_mod.link_libc = true;
        const exe = b.addExecutable(.{
            .name = entry.name,
            .root_module = exe_mod,
        });
        b.installArtifact(exe);
    }
}
