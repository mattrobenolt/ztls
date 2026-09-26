//! #114 — encrypted-PEM non-interaction check.
//!
//! `PrivateKey.fromPem` / `PrivateKey.fromPemAuto` must reject encrypted PEM
//! input without prompting on a terminal and without reading process stdin.
//! That invariant needs the loaders' own standard streams replaced, which the
//! shared test binary cannot do to itself, and a prompting regression must
//! fail as a bounded error instead of wedging the suite. Hence a dedicated
//! executable wired into `zig build test` next to errq-alloc-check, running
//! two probes over both APIs and both encrypted containers:
//!
//!   1. `pipe` — stdin is a pipe holding the passphrase sentinel, stdout and
//!      stderr are pipes as well. OpenSSL 3.6.4 and AWS-LC 5.5.0 reach their
//!      prompt path here (measured: both print `Enter PEM pass phrase:` on
//!      stderr and consume the input), and this is the daemon shape the issue
//!      describes: process-global stdin with no terminal attached.
//!   2. `terminal` — stdin, stdout, and stderr are a PTY slave, so `isatty`
//!      is true and the provider's terminal prompt path is reachable.
//!
//! Each probe asserts three things: every encrypted fixture fails with the
//! backend load error, the seeded sentinel is byte-for-byte intact on the
//! loader's stdin, and the provider wrote no prompt text. The sentinel is two
//! complete passphrase lines, so a prompting regression consumes input
//! instead of blocking, and every fd the probe reads is non-blocking, so a
//! provider that keeps reading cannot hang either.
//!
//! Boundedness: there is no child process and no wait — the probes run
//! in-process (Zig 0.16 dropped `std.posix.fork`, so a subprocess harness
//! would need a second, version-specific spawn path). One SIGALRM window,
//! armed in `main` before the first probe, covers PTY setup, the loader calls,
//! and both post-load observations; the handler reports on the pre-redirect
//! stderr and exits nonzero, so a wedged probe fails the check instead of
//! wedging the suite. An earlier revision cancelled the alarm after the
//! loader calls, which left a blocking observation read unbounded — the whole
//! window is the point.
//!
//! fd plumbing that `std.posix` dropped in Zig 0.16 (`pipe`, `dup2`, `fcntl`,
//! `alarm`) goes through libc on Linux and macOS; reads use `std.posix.read`,
//! whose `error.WouldBlock` is the typed form of "this non-blocking fd is
//! empty".
const std = @import("std");
const ztls = @import("ztls");
const fixtures = @import("fixtures");

const c = @cImport({
    // POSIX.1-2001 exposes the PTY allocation calls (`posix_openpt`,
    // `grantpt`, `unlockpt`, `ptsname`) on glibc and Darwin alike.
    @cDefine("_XOPEN_SOURCE", "700");
    @cInclude("fcntl.h");
    @cInclude("signal.h");
    @cInclude("stdlib.h");
    @cInclude("termios.h");
    @cInclude("unistd.h");
});

const PrivateKey = ztls.signature.PrivateKey;

/// File descriptors are C `int` here: everything that creates, dupes, or
/// closes one goes through libc. On Linux and macOS `fd_t` is the same type,
/// so these interoperate with `std.posix.read`.
const Fd = c_int;

/// Passphrase sentinel seeded into the loader's stdin. Two full lines so a
/// prompting provider consumes input rather than blocking, and any
/// consumption shows up as a shortfall against this exact byte sequence. The
/// text deliberately avoids the prompt marker.
const sentinel = "ztls-sentinel-do-not-read\nztls-sentinel-do-not-read\n";

/// Prompt text is the one thing the loaders must never emit. All three
/// provider families spell their prompt with "phrase" ("Enter PEM pass
/// phrase:", "Enter PEM passphrase:").
const prompt_marker = "phrase";

/// Bound for the whole check, armed in `main` before the first probe. Healthy
/// runs finish in single-digit milliseconds; non-blocking fds already remove
/// the block-on-read case, so this backstop catches a provider that loops, or
/// a future probe step that forgets to stay non-blocking.
const check_timeout_seconds = 10;

/// Upper bound on captured prompt output: real prompts are ~30 bytes.
const output_capacity = 512;

var captured_output: [output_capacity]u8 = undefined;

/// The check's real stderr, saved before any probe redirects fd 2, so the
/// timeout handler can report after stdout and stderr belong to a probe.
var real_stderr: Fd = -1;

const Failure = error{
    ProbePipeFailed,
    ProbeRedirectFailed,
    ProbeSeedFailed,
    ProbeReadFailed,
    TerminalUnavailable,
    /// An encrypted fixture loaded: the loaders accept password input.
    EncryptedKeyLoaded,
    /// A loader failed with something other than the backend load error, or
    /// the plaintext positive control failed to load.
    UnexpectedLoadOutcome,
    /// A loader consumed the stdin sentinel.
    StdinConsumed,
    /// A loader wrote a provider password prompt.
    PromptWritten,
    /// A loader wrote to stdout/stderr at all.
    UnexpectedOutput,
};

const Kind = enum { pipe, terminal };

/// A probe environment: the sentinel attached to the loader's stdin, plus the
/// handle needed to see whether anything was consumed or written.
const Probe = struct {
    /// Copies of the process's real stdin/stdout/stderr, `-1` once restored.
    saved: [3]Fd = .{ -1, -1, -1 },
    /// Where the probe's stdout and stderr land.
    observer: Fd = -1,
    /// Read end the sentinel sits on; `-1` for the terminal probe, which reads
    /// the sentinel back through fd 0 (the PTY slave).
    stdin_pipe: Fd = -1,
    /// Write ends kept open so the copies the loader inherited stay valid, and
    /// the PTY slave handed to fd 0..2 (held so `detach` can close it).
    input_write: Fd = -1,
    output_write: Fd = -1,
    terminal_slave: Fd = -1,

    /// Replace fd 0..2 with the probe's streams and seed the sentinel. On
    /// failure every fd this opened is closed again and the real streams are
    /// restored.
    fn attach(kind: Kind) Failure!Probe {
        var probe: Probe = .{};
        errdefer probe.detach();

        for (0..3) |fd| {
            probe.saved[fd] = c.dup(@intCast(fd));
            if (probe.saved[fd] < 0) return error.ProbeRedirectFailed;
        }
        switch (kind) {
            .pipe => try probe.attachPipe(),
            .terminal => try probe.attachTerminal(),
        }
        return probe;
    }

    /// fd 0 reads the sentinel from a pipe; fd 1 and fd 2 write prompt text
    /// into a second pipe. Both read ends are non-blocking, so no loader can
    /// wedge the probe waiting for input.
    fn attachPipe(self: *Probe) Failure!void {
        var input: [2]Fd = .{ -1, -1 };
        if (c.pipe(&input) != 0) return error.ProbePipeFailed;
        self.stdin_pipe = input[0];
        self.input_write = input[1];

        var output: [2]Fd = .{ -1, -1 };
        if (c.pipe(&output) != 0) return error.ProbePipeFailed;
        self.observer = output[0];
        self.output_write = output[1];

        if (c.write(self.input_write, sentinel.ptr, sentinel.len) != sentinel.len)
            return error.ProbeSeedFailed;
        if (c.fcntl(self.stdin_pipe, c.F_SETFL, c.O_NONBLOCK) < 0) return error.ProbeSeedFailed;
        if (c.fcntl(self.observer, c.F_SETFL, c.O_NONBLOCK) < 0) return error.ProbeSeedFailed;

        if (c.dup2(self.stdin_pipe, 0) < 0) return error.ProbeRedirectFailed;
        if (c.dup2(self.output_write, 1) < 0) return error.ProbeRedirectFailed;
        if (c.dup2(self.output_write, 2) < 0) return error.ProbeRedirectFailed;
    }

    /// fd 0..2 are one PTY slave, so a provider that checks `isatty` takes its
    /// terminal path; the sentinel sits in the tty input queue, and the master
    /// is where a prompt would surface.
    fn attachTerminal(self: *Probe) Failure!void {
        const master = c.posix_openpt(c.O_RDWR | c.O_NOCTTY);
        if (master < 0) return error.TerminalUnavailable;
        if (c.grantpt(master) != 0) return error.TerminalUnavailable;
        if (c.unlockpt(master) != 0) return error.TerminalUnavailable;
        self.observer = master;

        const slave = c.open(c.ptsname(master), c.O_RDWR | c.O_NOCTTY);
        if (slave < 0) return error.TerminalUnavailable;
        self.terminal_slave = slave;
        if (c.fcntl(slave, c.F_SETFL, c.O_NONBLOCK) < 0) return error.TerminalUnavailable;
        if (c.fcntl(master, c.F_SETFL, c.O_NONBLOCK) < 0) return error.TerminalUnavailable;
        try terminalEchoOff(slave);

        if (c.write(master, sentinel.ptr, sentinel.len) != sentinel.len)
            return error.ProbeSeedFailed;
        for (0..3) |fd| {
            if (c.dup2(slave, @intCast(fd)) < 0) return error.ProbeRedirectFailed;
        }
    }

    /// Restore the real streams and close every fd this probe opened.
    /// Idempotent: `attach`'s errdefer and `runProbe`'s defer both call it, and
    /// the failure path calls it before reporting so the report reaches the
    /// real stderr. The alarm window is `main`'s, so this does not touch it.
    fn detach(self: *Probe) void {
        for (0..3) |fd| {
            if (self.saved[fd] < 0) continue;
            _ = c.dup2(self.saved[fd], @intCast(fd));
            closeFd(self.saved[fd]);
            self.saved[fd] = -1;
        }
        closeFd(self.stdin_pipe);
        closeFd(self.input_write);
        closeFd(self.output_write);
        closeFd(self.terminal_slave);
        closeFd(self.observer);
        self.stdin_pipe = -1;
        self.input_write = -1;
        self.output_write = -1;
        self.terminal_slave = -1;
        self.observer = -1;
    }

    /// Whether the sentinel is still readable, byte for byte, on the loader's
    /// stdin: the negative space is a shortfall (a loader consumed part of a
    /// passphrase line) or an empty read (it consumed everything).
    fn stdinSentinelIntact(self: *const Probe) Failure!bool {
        const fd = if (self.stdin_pipe >= 0) self.stdin_pipe else 0;
        var seen: [sentinel.len]u8 = undefined;
        var count: usize = 0;
        while (count < seen.len) {
            const read = std.posix.read(fd, seen[count..]) catch |err| switch (err) {
                error.WouldBlock => return false,
                else => return error.ProbeReadFailed,
            };
            if (read == 0) return false;
            count += read;
        }
        return std.mem.eql(u8, &seen, sentinel);
    }

    /// Whatever the probe's stdout and stderr received. Empty is the expected
    /// outcome; prompt text is the failure this check exists to catch.
    fn capturedOutput(self: *const Probe) Failure![]const u8 {
        var count: usize = 0;
        while (count < captured_output.len) {
            const read = std.posix.read(self.observer, captured_output[count..]) catch |err|
                switch (err) {
                    error.WouldBlock => break,
                    else => return error.ProbeReadFailed,
                };
            if (read == 0) break;
            count += read;
        }
        return captured_output[0..count];
    }
};

fn closeFd(fd: Fd) void {
    if (fd >= 0) _ = c.close(fd);
}

/// Silence terminal echo on the probe's PTY. The sentinel sits in the input
/// queue, so without this the line discipline would echo it straight back to
/// the observer and "nothing was written" could not tell a prompt from the
/// seed. Termios through libc, not `std.posix`: Zig models Linux's `lflag` as
/// a packed struct of bitfields, so one expression would not compile on both
/// targets.
fn terminalEchoOff(slave: Fd) Failure!void {
    var tty: c.struct_termios = undefined;
    if (c.tcgetattr(slave, &tty) != 0) return error.TerminalUnavailable;
    tty.c_lflag &= ~@as(@TypeOf(tty.c_lflag), c.ECHO);
    if (c.tcsetattr(slave, c.TCSANOW, &tty) != 0) return error.TerminalUnavailable;
}

pub fn main() void {
    real_stderr = c.dup(2);
    _ = c.signal(c.SIGALRM, onProbeTimeout);
    _ = c.alarm(check_timeout_seconds);

    runProbes() catch |err| {
        std.debug.print("encrypted-pem-check: FAILED ({s})\n", .{@errorName(err)});
        std.process.exit(1);
    };

    _ = c.alarm(0);
    std.debug.print("encrypted-pem-check: ok (pipe, terminal)\n", .{});
}

fn runProbes() Failure!void {
    for ([_]Kind{ .pipe, .terminal }) |kind| {
        runProbe(kind) catch |err| {
            std.debug.print(
                "encrypted-pem-check: {s} probe failed ({s})\n",
                .{ @tagName(kind), @errorName(err) },
            );
            return err;
        };
    }
}

/// One probe: attach the streams, run every loader against the sentinel, and
/// assert the loaders neither read the sentinel nor wrote a prompt. The whole
/// probe runs inside `main`'s alarm window.
fn runProbe(kind: Kind) Failure!void {
    var probe: Probe = try .attach(kind);
    defer probe.detach();

    try expectDeclinedLoads();

    const output = try probe.capturedOutput();
    const prompt_written = std.mem.indexOf(u8, output, prompt_marker) != null;
    const stdin_consumed = !try probe.stdinSentinelIntact();
    if (prompt_written or stdin_consumed) {
        // Report both observations on the real stderr; detach is idempotent.
        probe.detach();
        if (prompt_written) {
            std.debug.print(
                "encrypted-pem-check: {s} probe: provider prompt written to the loader's stderr\n",
                .{@tagName(kind)},
            );
        }
        if (stdin_consumed) {
            std.debug.print(
                "encrypted-pem-check: {s} probe: loader consumed stdin\n",
                .{@tagName(kind)},
            );
        }
        return if (prompt_written) error.PromptWritten else error.StdinConsumed;
    }
    if (output.len != 0) return error.UnexpectedOutput;
}

/// Every encrypted fixture must fail at load through both APIs, while the
/// plaintext container of the same key still loads — the probe cannot pass
/// because the loader is broken for everything.
fn expectDeclinedLoads() Failure!void {
    const containers = [_][]const u8{
        fixtures.rsa_pss_key_encrypted_pkcs8_pem,
        fixtures.rsa_pss_key_encrypted_legacy_pem,
    };
    for (containers) |pem| {
        try expectDecline(PrivateKey.fromPem(.rsa_pss_rsae_sha256, pem));
        try expectDecline(PrivateKey.fromPemAuto(pem));
    }

    var plaintext: PrivateKey = PrivateKey.fromPem(
        .rsa_pss_rsae_sha256,
        fixtures.rsa_pss_key_pem,
    ) catch return error.UnexpectedLoadOutcome;
    plaintext.deinit();
}

/// One loader call under the probe: the backend load error is the only
/// acceptable outcome.
fn expectDecline(result: anytype) Failure!void {
    if (result) |key| {
        var loaded = key;
        loaded.deinit();
        return error.EncryptedKeyLoaded;
    } else |err| {
        if (err != error.LibcryptoFailed) return error.UnexpectedLoadOutcome;
    }
}

/// SIGALRM backstop for `check_timeout_seconds`: a provider that blocks on
/// input must fail the check, not wedge the suite.
fn onProbeTimeout(_: c_int) callconv(.c) void {
    const message = "encrypted-pem-check: FAILED (timed out: a probe step blocked on input)\n";
    if (real_stderr >= 0) _ = c.write(real_stderr, message.ptr, message.len);
    c._exit(1);
}
