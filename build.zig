const std = @import("std");
const Build = std.Build;
const Target = std.Target;
const builtin = @import("builtin");

fn nativeTarget() Target.Query {
    var query: Target.Query = .{ .cpu_model = .native };
    // Zig's native CPU detection reports generic under some Apple-Silicon Linux
    // VMs despite /proc/cpuinfo exposing aes/pmull. For performance work that
    // silently selects std.crypto's soft AES path, which is not a useful target.
    if (builtin.cpu.arch == .aarch64 and builtin.os.tag == .linux) {
        query.cpu_model = .{ .explicit = &Target.aarch64.cpu.apple_m1 };
    }
    return query;
}

pub fn build(b: *Build) void {
    const target = b.standardTargetOptions(.{
        .default_target = nativeTarget(),
    });
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.addModule("ztls", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    mod.link_libc = true;
    mod.linkSystemLibrary("crypto", .{});

    // Tests get their own module so the txtar dependency (used only to decode
    // the RFC 8448 fixture archive) never leaks into the public ztls module.
    const test_mod = b.createModule(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    test_mod.link_libc = true;
    test_mod.linkSystemLibrary("crypto", .{});
    // txtar decodes the RFC 8448 fixture archive. Lazy: only fetched when a
    // step that needs it (tests, the full_handshake example) is built.
    const txtar_mod: ?*Build.Module = if (b.lazyDependency("txtar", .{
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

    const server_interop_exe = b.addExecutable(.{
        .name = "openssl_server_interop",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/test/openssl_server_interop.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "ztls", .module = mod }},
        }),
    });
    const run_server_interop = b.addRunArtifact(server_interop_exe);
    const server_interop_step = b.step(
        "test-openssl-server",
        "Run the openssl s_client interop test",
    );
    server_interop_step.dependOn(&run_server_interop.step);

    const tlsfuzzer_server_exe = b.addExecutable(.{
        .name = "ztls_tlsfuzzer_server",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/test/tlsfuzzer_server.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "ztls", .module = mod }},
        }),
    });
    const install_tlsfuzzer_server = b.addInstallArtifact(tlsfuzzer_server_exe, .{});
    const tlsfuzzer_server_step = b.step("tlsfuzzer-server", "Build the tlsfuzzer TCP server");
    tlsfuzzer_server_step.dependOn(&install_tlsfuzzer_server.step);

    const tls_anvil_client_exe = b.addExecutable(.{
        .name = "ztls_tls_anvil_client",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/test/tls_anvil_client.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "ztls", .module = mod }},
        }),
    });
    const install_tls_anvil_client = b.addInstallArtifact(tls_anvil_client_exe, .{});
    const tls_anvil_client_step = b.step("tls-anvil-client", "Build the TLS-Anvil TCP client");
    tls_anvil_client_step.dependOn(&install_tls_anvil_client.step);

    const bogo_shim_exe = b.addExecutable(.{
        .name = "ztls_bogo_shim",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/test/bogo_shim.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "ztls", .module = mod }},
        }),
    });
    const install_bogo_shim = b.addInstallArtifact(bogo_shim_exe, .{});
    const bogo_shim_step = b.step("bogo-shim", "Build the BoGo shim");
    bogo_shim_step.dependOn(&install_bogo_shim.step);

    const wycheproof_tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/test/wycheproof_smoke.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "ztls", .module = mod }},
        }),
    });
    const run_wycheproof = b.addRunArtifact(wycheproof_tests);
    const wycheproof_step = b.step("test-wycheproof", "Run Wycheproof boundary smoke vectors");
    wycheproof_step.dependOn(&run_wycheproof.step);

    const replay_fixtures_exe = b.addExecutable(.{
        .name = "generate_replay_fixtures",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/test/generate_replay_fixtures.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "ztls", .module = mod }},
        }),
    });
    const run_replay_fixtures = b.addRunArtifact(replay_fixtures_exe);
    const replay_fixtures_step = b.step(
        "generate-replay-fixtures",
        "Generate OpenSSL replay fixtures for benchmarks",
    );
    replay_fixtures_step.dependOn(&run_replay_fixtures.step);

    // --- zig-benchmark integration ---
    const benchmark_dep: *Build.Dependency = b.dependency("benchmark", .{
        .target = target,
        .optimize = optimize,
    });
    const benchmark = @import("benchmark");
    const c_mod = b.createModule(.{
        .root_source_file = b.path("bench/c.zig"),
        .target = target,
        .optimize = optimize,
    });
    c_mod.link_libc = true;
    c_mod.linkSystemLibrary("crypto", .{});
    const c_ssl_mod = b.createModule(.{
        .root_source_file = b.path("bench/c_ssl.zig"),
        .target = target,
        .optimize = optimize,
    });
    c_ssl_mod.link_libc = true;
    c_ssl_mod.linkSystemLibrary("ssl", .{});
    c_ssl_mod.linkSystemLibrary("crypto", .{});

    // record-protection benchmarks
    const record_bench_root = b.createModule(.{
        .root_source_file = b.path("bench/record_protection.zig"),
        .target = target,
        .optimize = .ReleaseFast,
        .imports = &.{
            .{ .name = "ztls", .module = mod },
            .{ .name = "c", .module = c_mod },
        },
    });
    if (txtar_mod) |tm| record_bench_root.addImport("txtar", tm);
    const record_bench_test = benchmark.addTest(b, .{
        .name = "record_protection_bench",
        .dependency = benchmark_dep,
        .root_module = record_bench_root,
    });
    const run_record_bench = b.addRunArtifact(record_bench_test);
    if (b.args) |args| run_record_bench.addArgs(args);
    const bench_step = b.step("bench", "Run performance benchmarks");
    bench_step.dependOn(&run_record_bench.step);
    const record_bench_install = b.addInstallArtifact(record_bench_test, .{});
    const bench_bin_step = b.step("bench-bin", "Build the benchmark binary for profiling");
    bench_bin_step.dependOn(&record_bench_install.step);

    // micro-benchmarks
    const micro_bench_root = b.createModule(.{
        .root_source_file = b.path("src/micro_bench.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    micro_bench_root.link_libc = true;
    micro_bench_root.linkSystemLibrary("crypto", .{});
    const micro_bench_test = benchmark.addTest(b, .{
        .name = "micro_bench",
        .dependency = benchmark_dep,
        .root_module = micro_bench_root,
    });
    const run_micro_bench = b.addRunArtifact(micro_bench_test);
    if (b.args) |args| run_micro_bench.addArgs(args);
    const micro_bench_step = b.step("bench-micro", "Run Go-style ztls microbenchmarks");
    micro_bench_step.dependOn(&run_micro_bench.step);
    const micro_bench_install = b.addInstallArtifact(micro_bench_test, .{});
    const micro_bench_bin_step = b.step("bench-micro-bin", "Build the microbenchmark binary for profiling");
    micro_bench_bin_step.dependOn(&micro_bench_install.step);
    const micro_bench_disasm = b.addSystemCommand(&.{
        "sh",
        "-c",
        "mkdir -p zig-out/bench && objdump -d zig-out/bin/micro_bench > zig-out/bench/micro_bench.asm",
    });
    micro_bench_disasm.step.dependOn(&micro_bench_install.step);
    const micro_bench_disasm_step = b.step("bench-micro-disasm", "Write microbenchmark disassembly to zig-out/bench/micro_bench.asm");
    micro_bench_disasm_step.dependOn(&micro_bench_disasm.step);

    // OpenSSL EVP benchmarks
    const evp_bench_root = b.createModule(.{
        .root_source_file = b.path("bench/evp.zig"),
        .target = target,
        .optimize = .ReleaseFast,
        .imports = &.{
            .{ .name = "ztls", .module = mod },
            .{ .name = "c", .module = c_mod },
        },
    });
    const evp_bench_test = benchmark.addTest(b, .{
        .name = "evp_bench",
        .dependency = benchmark_dep,
        .root_module = evp_bench_root,
    });
    const run_evp_bench = b.addRunArtifact(evp_bench_test);
    if (b.args) |args| run_evp_bench.addArgs(args);
    const evp_bench_step = b.step("bench-evp", "Run OpenSSL EVP AEAD benchmarks");
    evp_bench_step.dependOn(&run_evp_bench.step);
    const install_evp_bench = b.addInstallArtifact(evp_bench_test, .{});
    const evp_bench_bin_step = b.step("bench-evp-bin", "Build the OpenSSL EVP benchmark binary");
    evp_bench_bin_step.dependOn(&install_evp_bench.step);

    // OpenSSL BIO (libssl) benchmarks
    const bio_bench_root = b.createModule(.{
        .root_source_file = b.path("bench/bio.zig"),
        .target = target,
        .optimize = .ReleaseFast,
        .imports = &.{
            .{ .name = "ztls", .module = mod },
            .{ .name = "c", .module = c_mod },
            .{ .name = "c_ssl", .module = c_ssl_mod },
        },
    });
    const bio_bench_exe = benchmark.addTest(b, .{
        .name = "bio_bench",
        .dependency = benchmark_dep,
        .root_module = bio_bench_root,
    });
    bio_bench_exe.linkLibC();
    bio_bench_exe.linkSystemLibrary("ssl");
    bio_bench_exe.linkSystemLibrary("crypto");
    const run_bio_bench = b.addRunArtifact(bio_bench_exe);
    if (b.args) |args| run_bio_bench.addArgs(args);
    const bio_bench_step = b.step("bench-openssl", "Run OpenSSL libssl memory BIO benchmarks");
    bio_bench_step.dependOn(&run_bio_bench.step);
    const install_bio_bench = b.addInstallArtifact(bio_bench_exe, .{});
    const bio_bench_bin_step = b.step(
        "bench-openssl-bin",
        "Build the OpenSSL memory BIO benchmark binary",
    );
    bio_bench_bin_step.dependOn(&install_bio_bench.step);

    const rustls_bench = b.addSystemCommand(
        &.{ "cargo", "run", "--release", "--manifest-path", "bench/rustls/Cargo.toml", "--" },
    );
    if (b.args) |args| rustls_bench.addArgs(args);
    const rustls_bench_step = b.step("bench-rustls", "Run rustls in-memory benchmarks");
    rustls_bench_step.dependOn(&rustls_bench.step);

    const rustls_bench_build = b.addSystemCommand(
        &.{ "cargo", "build", "--release", "--manifest-path", "bench/rustls/Cargo.toml" },
    );
    const rustls_bench_install = b.addSystemCommand(&.{
        "sh",
        "-c",
        "mkdir -p zig-out/bin && " ++
            "cp bench/rustls/target/release/rustls_bench zig-out/bin/rustls_bench",
    });
    rustls_bench_install.step.dependOn(&rustls_bench_build.step);
    const rustls_bench_bin_step = b.step("bench-rustls-bin", "Build the rustls benchmark binary");
    rustls_bench_bin_step.dependOn(&rustls_bench_install.step);

    const examples = [_][]const u8{
        "full_handshake",
        "handshake_keys",
        "https_client",
        "https_server",
        "in_memory_handshake",
        "key_schedule",
        "tcp_loopback",
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

        const asm_step = b.step(
            b.fmt("example-{s}-asm", .{name}),
            b.fmt("Emit asm for {s} example", .{name}),
        );
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

    if (target.result.os.tag == .linux) {
        const exe_mod = b.createModule(.{
            .root_source_file = b.path("examples/iouring_client.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "ztls", .module = mod }},
        });
        const exe = b.addExecutable(.{ .name = "iouring_client", .root_module = exe_mod });
        const run = b.addRunArtifact(exe);
        const step = b.step("example-iouring_client", "Run Linux io_uring client example");
        step.dependOn(&run.step);
    }
}
