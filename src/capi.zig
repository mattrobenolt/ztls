//! C ABI shims for the ztls TLS 1.3 client lifecycle (#30).
//!
//! This module exports a C-callable surface for the client-side handshake.
//! The internal layout of the client handle is opaque: the C consumer
//! allocates `ztls_client_size()` bytes with alignment `ztls_client_align()`
//! and passes the pointer to `ztls_client_init_insecure`. Layout is unstable; the
//! consumer must not access the memory directly.
//!
//! The opaque-sized approach is used because `ClientHandshake.Suite` is a
//! `union(enum)` that cannot be C-represented honestly, and the security
//! review (docs/research/security/C_ABI_SECURITY_REVIEW.md) found that
//! transparent structs leak secrets and backend pointers across C struct
//! copies. Opaque-sized handles avoid that class of bug.
//!
//! Scope: client lifecycle only. Server-side shims, RecordBuffer C ABI,
//! certificate verification, KeyUpdate initiation, PSK/resumption, and
//! dynamic linking are deferred per #30.

const CApi = @This();
const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;

const ztls = @import("root.zig");
const ClientHandshake = ztls.ClientHandshake;
const ServerHandshake = ztls.ServerHandshake;
const Config = ClientHandshake.Config;
const frame = ztls.frame;

// C-facing types
pub const ZtlsResult = enum(c_int) {
    ok = 0,
    err_null_parameter = 1,
    err_buffer_too_short = 2,
    err_pending_write = 3,
    err_not_connected = 4,
    err_handshake_failure = 5,
    err_peer_alert = 6,
    err_identity_element = 7,
    err_invalid_state = 8,
    err_internal = 9,
};

pub const ZtlsEventType = enum(c_int) {
    none = 0,
    application_data = 1,
    write = 2,
    closed = 3,
};

pub const ZtlsEvent = extern struct {
    type: ZtlsEventType,
    data: ?[*]const u8,
    data_len: usize,
};

// Version
fn versionImpl() callconv(.c) [*:0]const u8 {
    return "0.1.0";
}

// Size / alignment
fn clientSizeImpl() callconv(.c) usize {
    return @sizeOf(ClientHandshake);
}

fn clientAlignImpl() callconv(.c) usize {
    return @alignOf(ClientHandshake);
}

// Helpers
/// Cast the opaque C pointer to a typed client pointer. The caller is
/// responsible for having allocated enough storage with correct alignment.
fn asClient(ptr: ?*anyopaque) ?*ClientHandshake {
    const p = ptr orelse return null;
    return @as(*ClientHandshake, @ptrCast(@alignCast(p)));
}

/// Map a Zig error to the closest C result enum value. Unmapped errors fall
/// back to ZTLS_ERR_HANDSHAKE_FAILURE for protocol errors, or a more specific
/// code where the semantic is clear.
fn mapError(err: anyerror) ZtlsResult {
    return switch (err) {
        error.PendingWrite => .err_pending_write,
        error.BufferTooShort => .err_buffer_too_short,
        error.PeerAlert => .err_peer_alert,
        error.IdentityElement => .err_identity_element,

        // Crypto / AEAD failures.
        error.AuthenticationFailed,
        error.AeadSetupFailed,
        error.AeadEncryptFailed,
        => .err_handshake_failure,

        // Parse / framing errors.
        error.UnexpectedEof,
        error.IncompleteRecord,
        error.UnexpectedRecord,
        error.UnexpectedMessage,
        error.IllegalParameter,
        error.UnsupportedCipherSuite,
        error.UnsupportedKeyShareGroup,
        error.HandshakeBufferTooShort,
        error.CertificateKeyTooLarge,
        error.TooManyKeyUpdates,
        => .err_handshake_failure,

        // Certificate / verification.
        error.SignatureVerificationFailed,
        error.SignatureSchemeNotOffered,
        => .err_handshake_failure,

        // Server name.
        error.ServerNameTooLong => .err_handshake_failure,

        // ALPN.
        error.TooManyAlpnBytes,
        error.EmptyAlpnProtocol,
        error.AlpnProtocolTooLong,
        => .err_handshake_failure,

        // Backend / libcrypto.
        error.LibcryptoFailed => .err_handshake_failure,

        // Catch-all: anything unmapped is a handshake failure.
        else => .err_handshake_failure,
    };
}

// Client lifecycle
fn clientInitInsecureImpl(
    client: ?*anyopaque,
    x25519_pub: ?[*]const u8,
    x25519_sec: ?[*]const u8,
    host_name: ?[*:0]const u8,
    random: ?[*]const u8,
) callconv(.c) ZtlsResult {
    if (client == null) return .err_null_parameter;
    if (x25519_pub == null or x25519_sec == null or random == null) return .err_null_parameter;

    const c = asClient(client) orelse return .err_null_parameter;

    // Copy the key material into local arrays — the caller may free or
    // overwrite the input arrays after init returns (RECON-FFI.md F1 lifetime).
    var pub_key: [32]u8 = undefined;
    @memcpy(&pub_key, x25519_pub.?[0..32]);
    var sec_key: [32]u8 = undefined;
    @memcpy(&sec_key, x25519_sec.?[0..32]);
    var random_bytes: [32]u8 = undefined;
    @memcpy(&random_bytes, random.?[0..32]);

    const host: ?[]const u8 = if (host_name) |hn| std.mem.span(hn) else null;

    const keypair: ztls.x25519.KeyPair = .{
        .public_key = .{ .data = pub_key },
        .secret_key = .{ .data = sec_key },
    };

    const config: Config = .{
        .keypairs = .init(keypair),
        .host_name = host,
        .now_sec = 0,
        .random = .{ .data = random_bytes },
        // The exported name makes this explicit until verified init lands in #30.
        .insecure_no_chain_anchor = true,
    };

    c.* = ClientHandshake.init(config);
    return .ok;
}

fn clientDeinitImpl(client: ?*anyopaque) callconv(.c) ZtlsResult {
    const c = asClient(client) orelse return .err_null_parameter;
    ClientHandshake.deinit(c);
    return .ok;
}

fn clientStartImpl(
    client: ?*anyopaque,
    out: ?[*]u8,
    out_len: usize,
    out_written: ?*usize,
) callconv(.c) ZtlsResult {
    const c = asClient(client) orelse return .err_null_parameter;
    if (out == null and out_len > 0) return .err_null_parameter;
    if (out_len == 0) return .err_buffer_too_short;

    const out_slice = out.?[0..out_len];
    const record = ClientHandshake.start(c, out_slice) catch |err| return mapError(err);
    if (out_written) |w| w.* = record.len;
    return .ok;
}

fn clientHandleRecordImpl(
    client: ?*anyopaque,
    record: ?[*]u8,
    record_len: usize,
    out: ?[*]u8,
    out_len: usize,
    event: ?*ZtlsEvent,
) callconv(.c) ZtlsResult {
    const c = asClient(client) orelse return .err_null_parameter;
    if (record == null and record_len > 0) return .err_null_parameter;
    if (record_len == 0) return .err_buffer_too_short;
    if (out == null and out_len > 0) return .err_null_parameter;
    if (event == null) return .err_null_parameter;

    const record_slice: []u8 = record.?[0..record_len];
    const empty_out: [0]u8 = .{};
    const out_slice: []u8 = if (out) |o| o[0..out_len] else &empty_out;

    const ev = ClientHandshake.handleRecord(c, record_slice, out_slice) catch |err|
        return mapError(err);

    const e = event.?;
    switch (ev) {
        .application_data => |data| {
            e.* = .{
                .type = .application_data,
                .data = data.ptr,
                .data_len = data.len,
            };
        },
        .write => |data| {
            e.* = .{
                .type = .write,
                .data = data.ptr,
                .data_len = data.len,
            };
        },
        .closed => {
            e.* = .{ .type = .closed, .data = null, .data_len = 0 };
        },
        .none => {
            e.* = .{ .type = .none, .data = null, .data_len = 0 };
        },
        .key_update => |key_update| {
            if (key_update.response) |response| {
                e.* = .{
                    .type = .write,
                    .data = response.ptr,
                    .data_len = response.len,
                };
            } else {
                e.* = .{ .type = .none, .data = null, .data_len = 0 };
            }
        },
        .new_session_ticket => {
            e.* = .{ .type = .none, .data = null, .data_len = 0 };
        },
    }
    return .ok;
}

fn clientCompleteWriteImpl(client: ?*anyopaque) callconv(.c) ZtlsResult {
    const c = asClient(client) orelse return .err_null_parameter;
    ClientHandshake.completeWrite(c);
    return .ok;
}

fn clientSendApplicationDataImpl(
    client: ?*anyopaque,
    plaintext: ?[*]const u8,
    plaintext_len: usize,
    out: ?[*]u8,
    out_len: usize,
    out_written: ?*usize,
) callconv(.c) ZtlsResult {
    const c = asClient(client) orelse return .err_null_parameter;
    if (plaintext == null and plaintext_len > 0) return .err_null_parameter;
    if (out == null and out_len > 0) return .err_null_parameter;
    if (out_len == 0) return .err_buffer_too_short;
    if (!ClientHandshake.isConnected(c)) return .err_not_connected;

    const pt_slice = if (plaintext) |p| p[0..plaintext_len] else &[_]u8{};
    const out_slice = out.?[0..out_len];

    const record = ClientHandshake.sendApplicationData(c, pt_slice, out_slice) catch |err|
        return mapError(err);
    if (out_written) |w| w.* = record.len;
    return .ok;
}

fn clientIsConnectedImpl(client: ?*anyopaque) callconv(.c) bool {
    const c = asClient(client) orelse return false;
    return ClientHandshake.isConnected(c);
}

fn clientSelectedAlpnImpl(
    client: ?*anyopaque,
    out_ptr: ?*[*]const u8,
    out_len: ?*usize,
) callconv(.c) ZtlsResult {
    const c = asClient(client) orelse return .err_null_parameter;
    if (out_ptr == null or out_len == null) return .err_null_parameter;

    const alpn = ClientHandshake.selectedAlpnProtocol(c) orelse return .err_not_connected;
    out_ptr.?.* = alpn.ptr;
    out_len.?.* = alpn.len;
    return .ok;
}

// Exports
comptime {
    @export(&versionImpl, .{ .name = "ztls_version" });
    @export(&clientSizeImpl, .{ .name = "ztls_client_size" });
    @export(&clientAlignImpl, .{ .name = "ztls_client_align" });
    @export(&clientInitInsecureImpl, .{ .name = "ztls_client_init_insecure" });
    @export(&clientDeinitImpl, .{ .name = "ztls_client_deinit" });
    @export(&clientStartImpl, .{ .name = "ztls_client_start" });
    @export(&clientHandleRecordImpl, .{ .name = "ztls_client_handle_record" });
    @export(&clientCompleteWriteImpl, .{ .name = "ztls_client_complete_write" });
    @export(&clientSendApplicationDataImpl, .{ .name = "ztls_client_send_application_data" });
    @export(&clientIsConnectedImpl, .{ .name = "ztls_client_is_connected" });
    @export(&clientSelectedAlpnImpl, .{ .name = "ztls_client_selected_alpn" });
}

// Tests
//
// The tests drive a FULL client handshake against an in-memory ServerHandshake
// through the C ABI shims on the client side, mirroring the pattern in
// examples/in_memory_handshake.zig. The server side uses the native Zig API
// directly (server-side C ABI is deferred per #30).

const fixtures = @import("fixtures");

test "capi: ztls_version returns a non-empty string" {
    const v = versionImpl();
    try testing.expect(v[0] != 0);
}

test "capi: insecure client init is explicitly named" {
    try testing.expect(@hasDecl(CApi, "clientInitInsecureImpl"));
    try testing.expect(!@hasDecl(CApi, "clientInitImpl"));
}

test "capi: size and alignment are non-zero and sane" {
    const sz = clientSizeImpl();
    const al = clientAlignImpl();
    try testing.expect(sz > 0);
    try testing.expect(al > 0);
    try testing.expect(al <= @alignOf(ClientHandshake));
    // Alignment must be a power of two.
    try testing.expect(al & (al - 1) == 0);
}

test "capi: NULL parameters are rejected" {
    // ztls_client_init_insecure with NULL client
    var dummy: [32]u8 = @splat(0);
    try testing.expectEqual(.err_null_parameter, clientInitInsecureImpl(
        null,
        &dummy,
        &dummy,
        "test",
        &dummy,
    ));

    // ztls_client_start with NULL client
    var out: [1024]u8 = undefined;
    var written: usize = 0;
    try testing.expectEqual(.err_null_parameter, clientStartImpl(
        null,
        &out,
        out.len,
        &written,
    ));

    // ztls_client_deinit with NULL
    try testing.expectEqual(.err_null_parameter, clientDeinitImpl(null));

    // ztls_client_is_connected with NULL returns false
    try testing.expect(!clientIsConnectedImpl(null));
}

// RFC 8446 §4.1.2 — ClientHello with a valid keypair and random.
test "capi: full client handshake through the C ABI" {
    // Server setup (native Zig API — server-side C ABI deferred per #30).
    const cert_der: []const u8 = &fixtures.server_ecdsa_cert_der;
    const scalar: []const u8 = &fixtures.server_ecdsa_scalar;

    var signer: ztls.signature.PrivateKey = try .fromP256Scalar(scalar[0..32]);
    defer signer.deinit();
    const signer_api = signer.signer();

    const server_keypair: ztls.x25519.KeyPair = .generate();
    const client_keypair: ztls.x25519.KeyPair = .generate();

    const client_random: ztls.Random = .{ .data = @splat(0x42) };
    const server_random: ztls.Random = .{ .data = @splat(0x37) };

    // Client setup via C ABI
    var client_storage: [@sizeOf(ClientHandshake)]u8 align(@alignOf(ClientHandshake)) = undefined;

    const init_result = clientInitInsecureImpl(
        &client_storage,
        &client_keypair.public_key.data,
        &client_keypair.secret_key.data,
        "ztls.server.test",
        &client_random.data,
    );
    try testing.expectEqual(.ok, init_result);

    // deinit via C ABI on cleanup
    defer {
        _ = clientDeinitImpl(&client_storage);
    }

    // Server setup (native Zig)
    var server: ServerHandshake = .init(.{
        .keypairs = .init(server_keypair),
        .random = server_random,
    });
    defer server.deinit();
    server.setCredentials(&.{cert_der}, signer_api);

    var server_out: ServerHandshake.OutBuffer = .empty;
    var flight: ServerHandshake.FlightBuffer = .empty;

    // 1. ClientHello via C ABI
    var client_out: [frame.max_wire_record_len]u8 = undefined;
    var out_written: usize = 0;
    try testing.expectEqual(.ok, clientStartImpl(
        asClient(&client_storage) orelse unreachable,
        &client_out,
        client_out.len,
        &out_written,
    ));
    const ch_record = client_out[0..out_written];
    try testing.expect(out_written > 0);
    // RFC 8446 §5.1 — record header: content_type=handshake(0x16),
    // legacy_version=0x0303.
    try testing.expectEqual(@as(u8, 0x16), ch_record[0]);
    try testing.expectEqual(@as(u8, 0x03), ch_record[1]);
    try testing.expectEqual(@as(u8, 0x03), ch_record[2]);

    _ = clientCompleteWriteImpl(&client_storage);

    // 2. ServerHello (server consumes ClientHello)
    const sh_record = try server.acceptClientHello(ch_record, &server_out.buffer);
    server.completeWrite();

    // 3. Client installs handshake keys from ServerHello
    // processServerHello is not exposed through the C ABI in this slice;
    // it's an intermediate step that the full handle_record path handles
    // internally. But in the in_memory_handshake example, the client calls
    // processServerHello directly. The C ABI's handle_record expects a
    // full record, and the client is in wait_sh state — so we feed the
    // ServerHello record through handle_record.
    //
    // However, processServerHello is a separate call in the Zig API, and
    // the C ABI handle_record does NOT call processServerHello — it calls
    // processHandshakeRecord which handles the wait_sh state by parsing
    // ServerHello directly. Let's verify this works.
    var event: ZtlsEvent = undefined;
    var client_out2: [frame.max_wire_record_len]u8 = undefined;

    // Copy sh_record into a mutable buffer for handle_record.
    var sh_buf: [frame.max_wire_record_len]u8 = undefined;
    @memcpy(sh_buf[0..sh_record.len], sh_record);

    try testing.expectEqual(.ok, clientHandleRecordImpl(
        &client_storage,
        &sh_buf,
        sh_record.len,
        &client_out2,
        client_out2.len,
        &event,
    ));
    // After ServerHello, the client should be in wait_ee (no event to surface).
    try testing.expectEqual(ZtlsEventType.none, event.type);

    // 4. Server sends authenticated flight
    const flight_record = (try server.sendServerFlightBuffered(&flight)).?;
    server.completeWrite();

    // 5. Client processes the encrypted flight
    var flight_buf: [frame.max_wire_record_len]u8 = undefined;
    @memcpy(flight_buf[0..flight_record.len], flight_record);

    var event2: ZtlsEvent = undefined;
    var client_out3: [frame.max_wire_record_len]u8 = undefined;
    try testing.expectEqual(.ok, clientHandleRecordImpl(
        &client_storage,
        &flight_buf,
        flight_record.len,
        &client_out3,
        client_out3.len,
        &event2,
    ));
    // The client should emit its Finished as a write event.
    try testing.expectEqual(ZtlsEventType.write, event2.type);
    try testing.expect(event2.data_len > 0);

    const client_finished_len = event2.data_len;
    _ = clientCompleteWriteImpl(&client_storage);

    // 6. Server verifies client Finished.
    // The client Finished is in client_out3 (the out buffer); event.data
    // also points into that buffer.
    const client_finished_record = client_out3[0..client_finished_len];
    try server.processClientFinished(client_finished_record);

    // 7. Verify handshake completed
    try testing.expect(clientIsConnectedImpl(&client_storage));
    try testing.expect(server.isConnected());

    // ALPN: the client does not offer ALPN through the C ABI in this slice
    // (ALPN offering from C requires a string-array parameter on init, which
    // is deferred). The server offered h2 but the client didn't offer it, so
    // no ALPN was negotiated. Verify selected_alpn returns not_connected.
    var alpn_ptr: [*]const u8 = undefined;
    var alpn_len: usize = 0;
    try testing.expectEqual(.err_not_connected, clientSelectedAlpnImpl(
        &client_storage,
        &alpn_ptr,
        &alpn_len,
    ));

    // 8. Application-data round trip
    // Client sends "ping" via C ABI.
    var app_out: [frame.max_wire_record_len]u8 = undefined;
    var app_written: usize = 0;
    try testing.expectEqual(.ok, clientSendApplicationDataImpl(
        &client_storage,
        "ping",
        4,
        &app_out,
        app_out.len,
        &app_written,
    ));
    try testing.expect(app_written > 0);
    _ = clientCompleteWriteImpl(&client_storage);

    const ping_record = app_out[0..app_written];
    try testing.expectEqualStrings("ping", try server.receiveApplicationData(ping_record));

    // Server sends "pong" (native Zig API).
    const pong_record = try server.sendApplicationData("pong", &server_out.buffer);
    server.completeWrite();

    // Client receives "pong" via C ABI.
    var pong_buf: [frame.max_wire_record_len]u8 = undefined;
    @memcpy(pong_buf[0..pong_record.len], pong_record);

    var app_event: ZtlsEvent = undefined;
    var app_out2: [frame.max_wire_record_len]u8 = undefined;
    try testing.expectEqual(.ok, clientHandleRecordImpl(
        &client_storage,
        &pong_buf,
        pong_record.len,
        &app_out2,
        app_out2.len,
        &app_event,
    ));
    try testing.expectEqual(ZtlsEventType.application_data, app_event.type);
    try testing.expectEqualStrings("pong", app_event.data.?[0..app_event.data_len]);
}

test "capi: send_application_data before connected fails" {
    var client_storage: [@sizeOf(ClientHandshake)]u8 align(@alignOf(ClientHandshake)) = undefined;
    const kp: ztls.x25519.KeyPair = .generate();
    var rand: ztls.Random = .{ .data = @splat(0x55) };

    _ = clientInitInsecureImpl(
        &client_storage,
        &kp.public_key.data,
        &kp.secret_key.data,
        "x",
        &rand.data,
    );
    defer _ = clientDeinitImpl(&client_storage);

    var out: [1024]u8 = undefined;
    var written: usize = 0;
    const result = clientSendApplicationDataImpl(
        &client_storage,
        "test",
        4,
        &out,
        out.len,
        &written,
    );
    // Not connected — should fail with handshake_failure or not_connected.
    try testing.expect(result != .ok);
}

fn connectClientAndServerForTest(
    client_storage: *[@sizeOf(ClientHandshake)]u8,
    server: *ServerHandshake,
) !void {
    var signer: ztls.signature.PrivateKey = try .fromP256Scalar(
        fixtures.server_ecdsa_scalar[0..32],
    );
    defer signer.deinit();

    const client_keypair: ztls.x25519.KeyPair = .generate();
    const client_random: ztls.Random = .{ .data = @splat(0x42) };
    const init_result = clientInitInsecureImpl(
        client_storage,
        &client_keypair.public_key.data,
        &client_keypair.secret_key.data,
        "ztls.server.test",
        &client_random.data,
    );
    try testing.expectEqual(.ok, init_result);

    server.* = .init(.{
        .keypairs = .init(ztls.x25519.KeyPair.generate()),
        .random = .{ .data = @splat(0x37) },
    });
    server.setCredentials(&.{&fixtures.server_ecdsa_cert_der}, signer.signer());

    var client_out: [frame.max_wire_record_len]u8 = undefined;
    var client_written: usize = 0;
    try testing.expectEqual(.ok, clientStartImpl(
        client_storage,
        &client_out,
        client_out.len,
        &client_written,
    ));
    _ = clientCompleteWriteImpl(client_storage);

    try finishHandshakeForTest(
        client_storage,
        server,
        client_out[0..client_written],
        &client_out,
    );
}

fn finishHandshakeForTest(
    client_storage: *[@sizeOf(ClientHandshake)]u8,
    server: *ServerHandshake,
    client_hello: []const u8,
    client_out: []u8,
) !void {
    var server_out: ServerHandshake.OutBuffer = .empty;
    const server_hello = try server.acceptClientHello(client_hello, &server_out.buffer);
    server.completeWrite();

    var record: [frame.max_wire_record_len]u8 = undefined;
    @memcpy(record[0..server_hello.len], server_hello);
    var event: ZtlsEvent = undefined;
    try testing.expectEqual(.ok, clientHandleRecordImpl(
        client_storage,
        &record,
        server_hello.len,
        client_out.ptr,
        client_out.len,
        &event,
    ));

    var flight: ServerHandshake.FlightBuffer = .empty;
    const server_flight = (try server.sendServerFlightBuffered(&flight)).?;
    server.completeWrite();
    @memcpy(record[0..server_flight.len], server_flight);
    try testing.expectEqual(.ok, clientHandleRecordImpl(
        client_storage,
        &record,
        server_flight.len,
        client_out.ptr,
        client_out.len,
        &event,
    ));
    try testing.expectEqual(ZtlsEventType.write, event.type);
    _ = clientCompleteWriteImpl(client_storage);
    try server.processClientFinished(client_out[0..event.data_len]);
    try testing.expect(clientIsConnectedImpl(client_storage));
    try testing.expect(server.isConnected());
}

// RFC 8446 §4.6.3 — a requested peer KeyUpdate produces a response record
// that the C caller must write and acknowledge before continuing.
test "capi: KeyUpdate response is surfaced as a write event" {
    var client_storage: [@sizeOf(ClientHandshake)]u8 align(@alignOf(ClientHandshake)) = undefined;
    var server: ServerHandshake = undefined;
    try connectClientAndServerForTest(&client_storage, &server);
    defer _ = clientDeinitImpl(&client_storage);
    defer server.deinit();

    var server_out: [128]u8 = undefined;
    const update = try server.sendKeyUpdate(&server_out, .update_requested);
    server.completeWrite();
    var update_record: [128]u8 = undefined;
    @memcpy(update_record[0..update.len], update);

    var client_out: [128]u8 = undefined;
    var event: ZtlsEvent = undefined;
    try testing.expectEqual(.ok, clientHandleRecordImpl(
        &client_storage,
        &update_record,
        update.len,
        &client_out,
        client_out.len,
        &event,
    ));
    try testing.expectEqual(ZtlsEventType.write, event.type);
    try testing.expect(event.data_len > 0);
    try testing.expectEqualSlices(
        u8,
        client_out[0..event.data_len],
        event.data.?[0..event.data_len],
    );

    var response_record: [128]u8 = undefined;
    @memcpy(response_record[0..event.data_len], event.data.?[0..event.data_len]);
    _ = clientCompleteWriteImpl(&client_storage);
    const server_event = try server.handleRecord(
        response_record[0..event.data_len],
        &server_out,
    );
    try testing.expect(server_event == .key_update);

    const after = try server.sendApplicationData("after", &server_out);
    server.completeWrite();
    @memcpy(update_record[0..after.len], after);
    try testing.expectEqual(.ok, clientHandleRecordImpl(
        &client_storage,
        &update_record,
        after.len,
        &client_out,
        client_out.len,
        &event,
    ));
    try testing.expectEqual(ZtlsEventType.application_data, event.type);
    try testing.expectEqualStrings("after", event.data.?[0..event.data_len]);
}

// RFC 8446 §4.6.3 — update_not_requested has no response and therefore must
// not set the pending-write interlock.
test "capi: KeyUpdate without response maps to none without pending write" {
    var client_storage: [@sizeOf(ClientHandshake)]u8 align(@alignOf(ClientHandshake)) = undefined;
    var server: ServerHandshake = undefined;
    try connectClientAndServerForTest(&client_storage, &server);
    defer _ = clientDeinitImpl(&client_storage);
    defer server.deinit();

    var server_out: [128]u8 = undefined;
    const update = try server.sendKeyUpdate(&server_out, .update_not_requested);
    server.completeWrite();
    var input: [128]u8 = undefined;
    @memcpy(input[0..update.len], update);

    var client_out: [128]u8 = undefined;
    var event: ZtlsEvent = undefined;
    try testing.expectEqual(.ok, clientHandleRecordImpl(
        &client_storage,
        &input,
        update.len,
        &client_out,
        client_out.len,
        &event,
    ));
    try testing.expectEqual(ZtlsEventType.none, event.type);

    const still_open = try server.sendApplicationData("open", &server_out);
    server.completeWrite();
    @memcpy(input[0..still_open.len], still_open);
    try testing.expectEqual(.ok, clientHandleRecordImpl(
        &client_storage,
        &input,
        still_open.len,
        &client_out,
        client_out.len,
        &event,
    ));
    try testing.expectEqual(ZtlsEventType.application_data, event.type);
    try testing.expectEqualStrings("open", event.data.?[0..event.data_len]);
}

// RFC 8446 §4.6.1 — an ignored NewSessionTicket has no write response and
// must not leave the C client blocked by the pending-write interlock.
test "capi: NewSessionTicket maps to none without pending write" {
    var client_storage: [@sizeOf(ClientHandshake)]u8 align(@alignOf(ClientHandshake)) = undefined;
    var server: ServerHandshake = undefined;
    try connectClientAndServerForTest(&client_storage, &server);
    defer _ = clientDeinitImpl(&client_storage);
    defer server.deinit();

    const ticket = [_]u8{
        0x04, 0x00, 0x00, 0x0f,
        0x00, 0x00, 0x0e, 0x10,
        0x12, 0x34, 0x56, 0x78,
        0x01, 0xaa, 0x00, 0x01,
        0xbb, 0x00, 0x00,
    };
    var server_out: [128]u8 = undefined;
    const ticket_record = try server.tx.encrypt(.handshake, &ticket, &server_out);
    var input: [128]u8 = undefined;
    @memcpy(input[0..ticket_record.len], ticket_record);

    var client_out: [128]u8 = undefined;
    var event: ZtlsEvent = undefined;
    try testing.expectEqual(.ok, clientHandleRecordImpl(
        &client_storage,
        &input,
        ticket_record.len,
        &client_out,
        client_out.len,
        &event,
    ));
    try testing.expectEqual(ZtlsEventType.none, event.type);

    const after = try server.sendApplicationData("after", &server_out);
    server.completeWrite();
    @memcpy(input[0..after.len], after);
    try testing.expectEqual(.ok, clientHandleRecordImpl(
        &client_storage,
        &input,
        after.len,
        &client_out,
        client_out.len,
        &event,
    ));
    try testing.expectEqual(ZtlsEventType.application_data, event.type);
    try testing.expectEqualStrings("after", event.data.?[0..event.data_len]);
}
