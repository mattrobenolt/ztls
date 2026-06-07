const std = @import("std");
const ascii = std.ascii;
const mem = std.mem;
const time = std.time;
const builtin = @import("builtin");

pub const BenchFn = *const fn (*B) void;

pub const Case = struct {
    name: []const u8,
    func: BenchFn,
};

pub fn case(name: []const u8, func: BenchFn) Case {
    return .{ .name = name, .func = func };
}

pub const Config = struct {
    pkg: []const u8,
    cases: []const Case,
};

const Args = struct {
    filter: ?[]const u8 = null,
    count: usize = 1,
    benchtime_ns: u64 = time.ns_per_s,
    list: bool = false,
};

pub const B = struct {
    n: usize,
    i: usize = 0,
    timer: time.Timer,
    elapsed_ns: u64 = 0,
    running: bool = true,

    pub fn init(n: usize) B {
        return .{ .n = n, .timer = time.Timer.start() catch unreachable };
    }

    pub fn next(self: *B) bool {
        if (self.i >= self.n) return false;
        self.i += 1;
        return true;
    }

    pub fn resetTimer(self: *B) void {
        self.timer.reset();
        self.elapsed_ns = 0;
        self.running = true;
    }

    pub fn stopTimer(self: *B) void {
        if (!self.running) return;
        self.elapsed_ns += self.timer.read();
        self.running = false;
    }

    pub fn startTimer(self: *B) void {
        if (self.running) return;
        self.timer.reset();
        self.running = true;
    }

    fn finish(self: *B) u64 {
        self.stopTimer();
        return self.elapsed_ns;
    }
};

pub fn run(config: Config) !void {
    const args = try parseArgs();

    var stdout_buf: [4096]u8 = undefined;
    var stdout_file = std.fs.File.stdout().writer(&stdout_buf);
    const stdout = &stdout_file.interface;
    defer stdout.flush() catch {};

    if (args.list) {
        for (config.cases) |c| try stdout.print("{s}\n", .{c.name});
        return;
    }

    try stdout.print("goos: {s}\n", .{@tagName(builtin.os.tag)});
    try stdout.print("goarch: {s}\n", .{@tagName(builtin.cpu.arch)});
    try stdout.print("pkg: {s}\n", .{config.pkg});
    try stdout.print("cpu: {s}\n", .{builtin.cpu.model.name});

    for (config.cases) |c| {
        if (!matches(args, c.name)) continue;
        for (0..args.count) |_| {
            const result = runCase(c.func, args.benchtime_ns);
            const ns_per_op = @as(f64, @floatFromInt(result.ns)) /
                @as(f64, @floatFromInt(result.n));
            try stdout.print("{s}-{d}\t{d}\t{d:.2} ns/op\n", .{
                c.name,
                threadCount(),
                result.n,
                ns_per_op,
            });
            try stdout.flush();
        }
    }
}

const Result = struct {
    n: usize,
    ns: u64,
};

fn runCase(func: BenchFn, target_ns: u64) Result {
    var n: usize = 1;
    while (true) {
        var b: B = .init(n);
        func(&b);
        const ns = @max(b.finish(), 1);
        if (ns >= target_ns or n >= std.math.maxInt(usize) / 100) return .{ .n = n, .ns = ns };

        const scale = @max(@min(target_ns / ns, 100), 2);
        n *= scale;
    }
}

fn matches(args: Args, name: []const u8) bool {
    const f = args.filter orelse return true;
    return ascii.indexOfIgnoreCase(name, f) != null;
}

fn threadCount() usize {
    return 1;
}

fn parseArgs() !Args {
    var result: Args = .{};
    var it = std.process.args();
    _ = it.next();
    while (it.next()) |arg| {
        if (mem.eql(u8, arg, "--list")) {
            result.list = true;
        } else if (mem.eql(u8, arg, "--filter")) {
            result.filter = it.next() orelse return error.MissingFilter;
        } else if (mem.startsWith(u8, arg, "--filter=")) {
            result.filter = arg["--filter=".len..];
        } else if (mem.eql(u8, arg, "--count")) {
            result.count = try parseCount(it.next() orelse return error.MissingCount);
        } else if (mem.startsWith(u8, arg, "--count=")) {
            result.count = try parseCount(arg["--count=".len..]);
        } else if (mem.eql(u8, arg, "--benchtime")) {
            result.benchtime_ns = try parseDuration(it.next() orelse return error.MissingBenchtime);
        } else if (mem.startsWith(u8, arg, "--benchtime=")) {
            result.benchtime_ns = try parseDuration(arg["--benchtime=".len..]);
        } else {
            return error.UnknownArgument;
        }
    }
    return result;
}

fn parseCount(s: []const u8) !usize {
    const n = try std.fmt.parseInt(usize, s, 10);
    if (n == 0) return error.InvalidCount;
    return n;
}

fn parseDuration(s: []const u8) !u64 {
    if (mem.endsWith(u8, s, "ms")) {
        const n = try std.fmt.parseInt(u64, s[0 .. s.len - 2], 10);
        return n * time.ns_per_ms;
    }
    if (mem.endsWith(u8, s, "s")) {
        const n = try std.fmt.parseInt(u64, s[0 .. s.len - 1], 10);
        return n * time.ns_per_s;
    }
    return std.fmt.parseInt(u64, s, 10);
}
