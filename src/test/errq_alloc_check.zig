//! #88 finding 2 — allocation-count evidence for the error-queue guards.
//!
//! A dedicated executable, not a test in the shared binary:
//! CRYPTO_set_mem_functions must be installed before the first libcrypto
//! allocation, and the shared test binary has already called libcrypto by
//! the time any test runs. Counting hooks are installed as the first
//! statement of main.
//!
//! What this proves, and what it does not: the hooks count allocations —
//! they never fail, so allocator *exhaustion* and recovery-after-exhaustion
//! (the reporter's symptom class) are NOT reproduced here; that remains
//! embedder-confirmed (#88 open). What is asserted is allocation-count
//! retention: after fully warming the exact failing operation (so the
//! per-thread ERR_STATE and queue-slot caches exist) and explicitly clearing
//! the warmup errors, each further failing guarded call must return the
//! live-allocation count to the baseline snapshot — the memory assertion
//! runs BEFORE the queue assertion so a guard regression that leaves
//! allocated entries queued fails on the memory axis first.
//!
//! The measured operations cover these paths:
//! - Malformed EC public-key rejection.
//! - Per-record AEAD tag rejection.
//! - Encrypted PEM rejection (#114).
//! - Client cleanup before ServerHello after an early-data offer (#121).
//! - Server cleanup after PSK admission and rejected key exchange (#121).
//!
//! Blind spots, explicit: liveCount tracks allocation counts, not bytes —
//! a leak that grows an existing buffer through realloc (same count, more
//! bytes) is invisible; resizing a live allocation changes neither count.
//! The AEAD section exercises the per-record guard on the
//! OpenSSL lane, where EVP pushes nothing on a bad tag, so both its
//! assertions are vacuous there by construction; it exists to catch a
//! future guard change that allocates per record.
//!
//! No ztls-owned allocation is involved: the hooks are libc pass-throughs
//! that count, and all buffers are stack-owned. BoringSSL builds skip at
//! comptime because the API is absent. Its err.c uses system malloc directly;
//! queue hygiene still applies there.
const std = @import("std");
const mem = std.mem;
const ztls = @import("ztls");
const fixtures = @import("fixtures");

/// #114 — the PKCS#8-encrypted form of the RSA fixture key, re-loaded under
/// the counting hooks to measure the declined path.
const encrypted_pkcs8_pem = fixtures.rsa_pss_key_encrypted_pkcs8_pem;

const c = @cImport({
    @cInclude("openssl/crypto.h");
    @cInclude("openssl/err.h");
});

/// Plain globals, not thread-locals: this executable is single-threaded, and
/// the counters only exist to observe libcrypto's allocation behavior here.
var alloc_count: usize = 0;
var free_count: usize = 0;

fn hookMalloc(num: usize, file: ?[*:0]const u8, line: c_int) callconv(.c) ?*anyopaque {
    _ = file;
    _ = line;
    const ptr = std.c.malloc(num) orelse return null;
    alloc_count += 1;
    return ptr;
}

fn hookRealloc(
    addr: ?*anyopaque,
    num: usize,
    file: ?[*:0]const u8,
    line: c_int,
) callconv(.c) ?*anyopaque {
    if (num == 0) {
        hookFree(addr, file, line);
        return null;
    }
    if (addr == null) return hookMalloc(num, file, line);
    // Resizing a live allocation does not change its count.
    return std.c.realloc(addr, num);
}

fn hookFree(addr: ?*anyopaque, file: ?[*:0]const u8, line: c_int) callconv(.c) void {
    _ = file;
    _ = line;
    if (addr != null) free_count += 1;
    std.c.free(addr);
}

fn liveCount() i64 {
    return @as(i64, @intCast(alloc_count)) - @as(i64, @intCast(free_count));
}

const CheckError = error{
    MemHooksRejected,
    HooksNeverObservedAllocation,
    QueueResidue,
    AllocationGrowth,
    UnexpectedBackendResult,
};

/// Run the guarded-EC path: a malformed uncompressed P-256 point
/// (0x04 || 0xff×64), the shape an attacker sends in a bad key_share.
fn failMalformedKeyShare() CheckError!void {
    const secret: ztls.p256.SecretKey = .init(@splat(0x01));
    var peer: ztls.p256.PublicKey = .{ .data = @splat(0xff) };
    peer.data[0] = 0x04;

    _ = ztls.p256.sharedSecret(secret, peer) catch |err| return switch (err) {
        error.IdentityElement => {},
        error.LibcryptoFailed => error.UnexpectedBackendResult,
    };
    return error.UnexpectedBackendResult;
}

/// Run the per-record AEAD guard path: one good record, then a record with a
/// corrupted tag.
fn failBadTagRecord() CheckError!void {
    const aead: ztls.aead.Aead = .{ .aes_128_gcm_sha256 = .init(@splat(0xab)) };
    var ctx: ztls.aead.Context = ztls.aead.Context.init(aead) catch
        return error.UnexpectedBackendResult;
    defer ctx.deinit();

    const nonce: ztls.aead.Nonce = .init(@splat(0xcd));
    const plaintext = "errq-alloc-check";
    var ciphertext: [plaintext.len]u8 = undefined;
    var tag: ztls.aead.Tag = undefined;
    aead.encrypt(&ctx, &ciphertext, &tag, plaintext, "record-header", &nonce) catch
        return error.UnexpectedBackendResult;

    tag.data[0] ^= 0xff;
    var decrypted: [plaintext.len]u8 = undefined;
    _ = aead.decrypt(&ctx, &decrypted, &ciphertext, &tag, "record-header", &nonce) catch |err|
        return switch (err) {
            error.AuthenticationFailed => {},
            else => error.UnexpectedBackendResult,
        };
    return error.UnexpectedBackendResult;
}

/// Run the #114 declined encrypted-PEM load path: an encrypted PKCS#8 fixture
/// with no password input, so the callback declines before any decryption.
fn failEncryptedPemLoad() CheckError!void {
    _ = ztls.signature.PrivateKey.fromPem(.rsa_pss_rsae_sha256, encrypted_pkcs8_pem) catch |err|
        return switch (err) {
            error.LibcryptoFailed => {},
            else => error.UnexpectedBackendResult,
        };
    return error.UnexpectedBackendResult;
}

const abort_psk: [32]u8 = @splat(0x42);

fn abortKeyPairs() CheckError!ztls.ClientHandshake.KeyPairs {
    return ztls.ClientHandshake.KeyPairs.init(.generate()) catch error.UnexpectedBackendResult;
}

fn initAbortTicket(ticket: *ztls.ClientHandshake.SessionTicket) void {
    ticket.* = .{
        .ticket_age_add = 0,
        .cipher_suite = .aes_128_gcm_sha256,
        .max_early_data_size = 1024,
    };
    ticket.identity.appendSliceAssumeCapacity("cleanup-ticket");
    ticket.psk.appendSliceAssumeCapacity(&abort_psk);
}

// RFC 8446 §4.2.10 — early traffic keys exist before any ServerHello arrives.
fn abortEarlyClient() CheckError!void {
    var ticket: ztls.ClientHandshake.SessionTicket = undefined;
    initAbortTicket(&ticket);
    defer ticket.secureZero();
    var client: ztls.ClientHandshake = .init(.{
        .keypairs = try abortKeyPairs(),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    defer client.deinit();
    var wire: [4096]u8 = undefined;
    _ = client.startWithPsk(&ticket, &wire, true) catch return error.UnexpectedBackendResult;
    if (client.state != .wait_sh or client.early_tx == null) return error.UnexpectedBackendResult;
}

fn lookupAbortPsk(context: *anyopaque, identity: []const u8) ?ztls.ServerHandshake.PskEntry {
    const ticket: *const ztls.ClientHandshake.SessionTicket = @ptrCast(@alignCast(context));
    if (!mem.eql(u8, identity, ticket.identity.constSlice())) return null;
    return .{
        .psk = ticket.psk.constSlice(),
        .cipher_suite = ticket.cipher_suite,
        .max_early_data_size = ticket.max_early_data_size,
    };
}

// RFC 8446 §4.2.10, §7.4.2 — reject an all-zero shared secret after PSK admission.
fn abortEarlyServer() CheckError!void {
    var ticket: ztls.ClientHandshake.SessionTicket = undefined;
    initAbortTicket(&ticket);
    defer ticket.secureZero();
    var client: ztls.ClientHandshake = .init(.{
        .keypairs = try abortKeyPairs(),
        .host_name = null,
        .now_sec = 0,
        .random = .zero,
    });
    defer client.deinit();
    client.keypairs.x25519.public_key = .zero;
    var client_wire: [4096]u8 = undefined;
    const hello = client.startWithPsk(&ticket, &client_wire, true) catch
        return error.UnexpectedBackendResult;
    var server: ztls.ServerHandshake = .init(.{
        .keypairs = try abortKeyPairs(),
        .random = .zero,
        .psk_lookup = .{ .context = &ticket, .lookup = lookupAbortPsk },
    });
    defer server.deinit();
    var server_wire: [4096]u8 = undefined;
    _ = server.acceptClientHello(hello, &server_wire) catch |err| {
        if (err != error.IdentityElement or server.state != .wait_ch or server.early_rx == null)
            return error.UnexpectedBackendResult;
        return;
    };
    return error.UnexpectedBackendResult;
}

/// One measured round of `op`: memory back to baseline first (the
/// load-bearing axis — entries left queued hold their allocations), queue
/// empty second.
fn checkRound(op: fn () CheckError!void, baseline: i64) CheckError!void {
    try op();
    if (liveCount() != baseline) return error.AllocationGrowth;
    if (c.ERR_peek_error() != 0) return error.QueueResidue;
}

// BoringSSL must return from main at comptime before this function is analyzed.
// Its headers do not declare CRYPTO_set_mem_functions.
fn runChecks() CheckError!void {
    // Hooks first, before any libcrypto call can allocate.
    if (c.CRYPTO_set_mem_functions(hookMalloc, hookRealloc, hookFree) != 1)
        return error.MemHooksRejected;

    // Warm the exact EC failing operation past the ring size (16 slots) so
    // the ERR_STATE and every queue-slot cache exist, then explicitly clear
    // the warmup errors and snapshot the baseline.
    var round: usize = 0;
    while (round < 20) : (round += 1) try failMalformedKeyShare();
    if (alloc_count == 0) return error.HooksNeverObservedAllocation;
    c.ERR_clear_error();
    const ec_baseline = liveCount();

    round = 0;
    while (round < 100) : (round += 1) try checkRound(failMalformedKeyShare, ec_baseline);

    // Same shape for the per-record AEAD guard path: one warmup round
    // absorbs first-use lazy initialization inside libcrypto, clear, then
    // measured rounds.
    try failBadTagRecord();
    c.ERR_clear_error();
    const aead_baseline = liveCount();

    round = 0;
    while (round < 100) : (round += 1) try checkRound(failBadTagRecord, aead_baseline);

    // #114 — the declined encrypted-PEM load parses and then abandons libcrypto
    // state, so repeated failures must not grow the live-allocation count
    // either. A handful of warmup rounds, because this path allocates more
    // than the primitives above.
    round = 0;
    while (round < 5) : (round += 1) try failEncryptedPemLoad();
    c.ERR_clear_error();
    const pem_baseline = liveCount();

    round = 0;
    while (round < 100) : (round += 1) try checkRound(failEncryptedPemLoad, pem_baseline);

    try abortEarlyClient();
    const client_baseline = liveCount();
    std.debug.print("errq-alloc-check: early client abort\n", .{});
    for (0..100) |_| try checkRound(abortEarlyClient, client_baseline);

    try abortEarlyServer();
    const server_baseline = liveCount();
    std.debug.print("errq-alloc-check: early server abort\n", .{});
    for (0..100) |_| try checkRound(abortEarlyServer, server_baseline);
}

pub fn main() void {
    const active = ztls.capabilities.active_backend;
    if (comptime active == .boringssl) {
        std.debug.print("errq-alloc-check: skipped for {s}\n", .{@tagName(active)});
        return;
    }

    runChecks() catch |err| {
        std.debug.print("errq-alloc-check: FAILED: {s}\n", .{@errorName(err)});
        std.process.exit(1);
    };

    std.debug.print(
        "errq-alloc-check: ok (allocs {d}, frees {d}, live {d})\n",
        .{ alloc_count, free_count, liveCount() },
    );
}
