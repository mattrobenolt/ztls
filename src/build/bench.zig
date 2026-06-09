const std = @import("std");
const Build = std.Build;
const benchmark = @import("benchmark");

pub fn addSteps(b: *Build, opts: struct {
    target: Build.ResolvedTarget,
    ztls_mod: *Build.Module,
    c_mod: *Build.Module,
    c_ssl_mod: *Build.Module,
    benchmark_dep: *Build.Dependency,
    txtar_mod: ?*Build.Module,
}) void {
    const mod = opts.ztls_mod;

    // --- ztls record-protection benchmarks ---
    const record_bench_root = b.createModule(.{
        .root_source_file = b.path("bench/record_protection.zig"),
        .target = opts.target,
        .optimize = .ReleaseFast,
        .imports = &.{
            .{ .name = "ztls", .module = mod },
            .{ .name = "c", .module = opts.c_mod },
        },
    });
    if (opts.txtar_mod) |tm| record_bench_root.addImport("txtar", tm);
    const record_bench_test = benchmark.addTest(b, .{
        .name = "record_protection_bench",
        .dependency = opts.benchmark_dep,
        .root_module = record_bench_root,
    });
    const run_record_bench = b.addRunArtifact(record_bench_test);
    if (b.args) |args| run_record_bench.addArgs(args);
    const bench_step = b.step("bench", "Run performance benchmarks");
    bench_step.dependOn(&run_record_bench.step);
    const record_bench_install = b.addInstallArtifact(record_bench_test, .{});
    const bench_bin_step = b.step("bench-bin", "Build the benchmark binary for profiling");
    bench_bin_step.dependOn(&record_bench_install.step);

    // --- micro-benchmarks ---
    const micro_bench_root = b.createModule(.{
        .root_source_file = b.path("src/micro_bench.zig"),
        .target = opts.target,
        .optimize = .ReleaseFast,
    });
    micro_bench_root.link_libc = true;
    micro_bench_root.linkSystemLibrary("crypto", .{});
    const micro_bench_test = benchmark.addTest(b, .{
        .name = "micro_bench",
        .dependency = opts.benchmark_dep,
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
    const micro_bench_disasm_step = b.step(
        "bench-micro-disasm",
        "Write microbenchmark disassembly to zig-out/bench/micro_bench.asm",
    );
    micro_bench_disasm_step.dependOn(&micro_bench_disasm.step);

    // --- OpenSSL EVP benchmarks ---
    const evp_bench_root = b.createModule(.{
        .root_source_file = b.path("bench/evp.zig"),
        .target = opts.target,
        .optimize = .ReleaseFast,
        .imports = &.{
            .{ .name = "ztls", .module = mod },
            .{ .name = "c", .module = opts.c_mod },
        },
    });
    const evp_bench_test = benchmark.addTest(b, .{
        .name = "evp_bench",
        .dependency = opts.benchmark_dep,
        .root_module = evp_bench_root,
    });
    const run_evp_bench = b.addRunArtifact(evp_bench_test);
    if (b.args) |args| run_evp_bench.addArgs(args);
    const evp_bench_step = b.step("bench-evp", "Run OpenSSL EVP AEAD benchmarks");
    evp_bench_step.dependOn(&run_evp_bench.step);
    const install_evp_bench = b.addInstallArtifact(evp_bench_test, .{});
    const evp_bench_bin_step = b.step("bench-evp-bin", "Build the OpenSSL EVP benchmark binary");
    evp_bench_bin_step.dependOn(&install_evp_bench.step);

    // --- OpenSSL BIO (libssl) benchmarks ---
    const bio_bench_root = b.createModule(.{
        .root_source_file = b.path("bench/bio.zig"),
        .target = opts.target,
        .optimize = .ReleaseFast,
        .imports = &.{
            .{ .name = "ztls", .module = mod },
            .{ .name = "c", .module = opts.c_mod },
            .{ .name = "c_ssl", .module = opts.c_ssl_mod },
        },
    });
    const bio_bench_exe = benchmark.addTest(b, .{
        .name = "bio_bench",
        .dependency = opts.benchmark_dep,
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

    // --- rustls benchmarks ---
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
}
