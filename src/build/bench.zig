const std = @import("std");
const Build = std.Build;

const benchmark = @import("benchmark");

pub const Options = struct {
    target: Build.ResolvedTarget,
    ztls_mod: *Build.Module,
    c_mod: *Build.Module,
    c_ssl_mod: *Build.Module,
    benchmark_dep: *Build.Dependency,
    txtar_mod: ?*Build.Module,
};

pub fn addSteps(b: *Build, opts: Options) void {
    addZtlsBenchmarks(b, opts);
    addEvpBenchmarks(b, opts);
    addLibsslBenchmarks(b, opts);
    addReplayFixtureGenerator(b, opts);
}

fn addZtlsBenchmarks(b: *Build, opts: Options) void {
    const mod = b.createModule(.{
        .root_source_file = b.path("src/bench.zig"),
        .target = opts.target,
        .optimize = .ReleaseFast,
        .link_libc = true,
        .imports = &.{
            .{ .name = "ztls", .module = opts.ztls_mod },
            .{ .name = "txtar", .module = opts.txtar_mod.? },
        },
    });
    mod.linkSystemLibrary("crypto", .{});

    const exe = benchmark.addTest(b, .{
        .dependency = opts.benchmark_dep,
        .root_module = mod,
    });

    const run = b.addRunArtifact(exe);
    if (b.args) |args| run.addArgs(args);

    const run_step = b.step("bench", "Run performance benchmarks");
    run_step.dependOn(&run.step);

    const install = b.addInstallArtifact(exe, .{});
    const install_step = b.step("bench-bin", "Build the benchmark binary for profiling");
    install_step.dependOn(&install.step);
}

fn addReplayFixtureGenerator(b: *Build, opts: Options) void {
    const exe = b.addExecutable(.{
        .name = "generate_replay_fixtures",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/bench/generate_replay_fixtures.zig"),
            .target = opts.target,
            .optimize = .ReleaseFast,
            .imports = &.{.{ .name = "ztls", .module = opts.ztls_mod }},
        }),
    });
    const run = b.addRunArtifact(exe);
    const step = b.step(
        "generate-replay-fixtures",
        "Generate OpenSSL replay fixtures for ztls benchmarks",
    );
    step.dependOn(&run.step);
}

fn addEvpBenchmarks(b: *Build, opts: Options) void {
    const evp_bench_root = b.createModule(.{
        .root_source_file = b.path("bench/evp.zig"),
        .target = opts.target,
        .optimize = .ReleaseFast,
        .imports = &.{
            .{ .name = "ztls", .module = opts.ztls_mod },
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
}

fn addLibsslBenchmarks(b: *Build, opts: Options) void {
    const bio_bench_root = b.createModule(.{
        .root_source_file = b.path("bench/bio.zig"),
        .target = opts.target,
        .optimize = .ReleaseFast,
        .imports = &.{
            .{ .name = "ztls", .module = opts.ztls_mod },
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
}
