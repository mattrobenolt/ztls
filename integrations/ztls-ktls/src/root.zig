//! Linux kTLS data-plane integration for ztls.
//!
//! The caller drives a ztls handshake in userspace, drains every byte already
//! read into its `RecordBuffer`, then calls `Client.activate` or
//! `Server.activate`. The handshake object and socket outlive the returned
//! connection. After activation, all record operations go through this package;
//! calling record-layer methods on the borrowed handshake can desynchronize the
//! kernel epochs. Every socket read uses `read` so control metadata is preserved.
const std = @import("std");
const testing = std.testing;
const builtin = @import("builtin");
const posix = std.posix;
const linux = std.os.linux;
const ztls = @import("ztls");
const sys = @import("syscall.zig");

comptime {
    if (builtin.os.tag != .linux) @compileError("ztls-ktls supports Linux only");
}

pub const KeyUpdateRequest = ztls.ClientHandshake.KeyUpdateRequest;

pub const RekeySupport = enum {
    supported,
    unsupported,
};

pub const ActivateError = error{
    NotConnected,
    PendingWrite,
    PendingKeyUpdateResponse,
    BufferedCiphertext,
    KtlsUnavailable,
    KtlsInstallFailed,
};

pub const WriteError = sys.SendError || error{Closed};
pub const ControlWriteError = sys.ControlSendError || error{ Closed, InterruptedTooOften };
pub const UpdateError = ControlWriteError || ztls.ClientHandshake.SendError ||
    ztls.ServerHandshake.SendError || error{
    KtlsRekeyUnsupported,
    KtlsRekeyFailed,
};

pub const CoreReceiveError = ztls.ClientHandshake.ReceiveError ||
    ztls.ServerHandshake.ReceiveError;
pub const ReadError = CoreReceiveError || error{
    Closed,
    WouldBlock,
    Truncated,
    InvalidControlMessage,
    UnexpectedSystemError,
    InterruptedTooOften,
    KtlsEpochDesync,
    KtlsRekeyUnsupported,
    KtlsRekeyFailed,
    FragmentedKeyUpdate,
    ControlRecordFlood,
    BufferTooShort,
};

pub const Client = Connection(ztls.ClientHandshake);
pub const Server = Connection(ztls.ServerHandshake);

const max_records_per_read = 65;

const StateFlag = enum {
    rx_closed,
    tx_closed,
    failed,
};

/// A single-threaded kTLS data plane bound to one live handshake object.
/// The package retains no key snapshots: every install exports and zeroes a
/// fresh immediate-use copy. Concurrent calls are unsupported.
pub fn Connection(comptime Handshake: type) type {
    const is_client = Handshake == ztls.ClientHandshake;
    if (!is_client and Handshake != ztls.ServerHandshake) {
        @compileError("Connection requires ClientHandshake or ServerHandshake");
    }

    return struct {
        const Self = @This();

        fd: posix.socket_t,
        handshake: *Handshake,
        rekey_support: RekeySupport,
        state: std.EnumSet(StateFlag) = .initEmpty(),

        /// Atomically crosses the userspace/kernel record-layer boundary.
        /// The socket remains caller-owned. If installation partially succeeds,
        /// the socket is shut down and cannot return to userspace TLS.
        pub fn activate(
            fd: posix.socket_t,
            handshake: *Handshake,
            buffered: *const ztls.RecordBuffer,
        ) ActivateError!Self {
            if (!handshake.isConnected()) return error.NotConnected;
            if (handshake.hasPendingWrite()) return error.PendingWrite;
            if (handshake.hasPendingKeyUpdateResponse()) {
                return error.PendingKeyUpdateResponse;
            }
            if (!buffered.isEmpty()) return error.BufferedCiphertext;

            ztls.ktls.ulpInstall(fd) catch |err| switch (err) {
                error.Unavailable => return error.KtlsUnavailable,
                error.Busy, error.Failed => return error.KtlsInstallFailed,
            };

            var tx_info = handshake.txKtlsInfo();
            defer tx_info.secureZero();
            var rx_info = handshake.rxKtlsInfo();
            defer rx_info.secureZero();

            installInfo(fd, ztls.ktls.TLS_TX, &tx_info) catch |err| {
                shutdown(fd, linux.SHUT.RDWR);
                return switch (err) {
                    error.Unavailable => error.KtlsUnavailable,
                    error.Busy, error.Failed => error.KtlsInstallFailed,
                };
            };
            installInfo(fd, ztls.ktls.TLS_RX, &rx_info) catch {
                shutdown(fd, linux.SHUT.RDWR);
                return error.KtlsInstallFailed;
            };

            // No kernel TX can occur between the initial install and this
            // identical reinstall. EBUSY is the runtime capability probe for
            // kernels predating TLS 1.3 live rekey support.
            const rekey_support: RekeySupport = if (installInfo(
                fd,
                ztls.ktls.TLS_TX,
                &tx_info,
            )) |_|
                .supported
            else |err| switch (err) {
                error.Busy => .unsupported,
                error.Unavailable, error.Failed => {
                    shutdown(fd, linux.SHUT.RDWR);
                    return error.KtlsInstallFailed;
                },
            };

            return .{
                .fd = fd,
                .handshake = handshake,
                .rekey_support = rekey_support,
            };
        }

        pub fn rekeySupport(self: *const Self) RekeySupport {
            return self.rekey_support;
        }

        pub fn lastPeerAlert(self: *const Self) ?ztls.alert.Alert {
            return self.handshake.lastPeerAlert();
        }

        /// Send application bytes through the kernel record layer. A successful
        /// return reports the exact number consumed; callers handle short sends.
        pub fn write(self: *Self, bytes: []const u8) WriteError!usize {
            if (self.state.contains(.failed) or self.state.contains(.tx_closed)) {
                return error.Closed;
            }
            return sys.sendData(self.fd, bytes);
        }

        /// Initiate a TLS 1.3 KeyUpdate. The control record is sent under the
        /// old key; no application write can interpose before the new key is
        /// installed because the operation is synchronous and single-threaded.
        pub fn update(self: *Self, request: KeyUpdateRequest) UpdateError!void {
            if (self.state.contains(.failed) or self.state.contains(.tx_closed)) {
                return error.Closed;
            }
            if (self.rekey_support == .unsupported) return error.KtlsRekeyUnsupported;
            try self.sendKeyUpdate(request);
        }

        /// Receive application data while transparently consuming alerts,
        /// tickets, and KeyUpdates. `bytes` must hold one maximum TLS plaintext
        /// record so control-record boundaries cannot be truncated. Zero means
        /// a verified peer close_notify; bare TCP FIN is `error.Truncated`.
        pub fn read(self: *Self, bytes: []u8) ReadError!usize {
            if (self.state.contains(.failed)) return error.Closed;
            if (self.state.contains(.rx_closed)) return 0;
            if (bytes.len < ztls.frame.max_plaintext_len) return error.BufferTooShort;

            // The client core permits 32 tickets and 16 KeyUpdates before
            // application data. One extra pass lets that data satisfy read().
            for (0..max_records_per_read) |_| {
                const received = self.recv(bytes) catch |err| switch (err) {
                    error.Interrupted => continue,
                    error.ConnectionClosed => return self.fail(error.Truncated),
                    error.KeyExpired => {
                        self.sendFailureAlert(.internal_error);
                        return self.fail(error.KtlsEpochDesync);
                    },
                    error.BadRecord => {
                        self.sendFailureAlert(.bad_record_mac);
                        return self.fail(error.AuthenticationFailed);
                    },
                    error.RecordTooLarge => {
                        self.sendFailureAlert(.record_overflow);
                        return self.fail(error.RecordTooLarge);
                    },
                    error.InvalidRecord => {
                        self.sendFailureAlert(.unexpected_message);
                        return self.fail(error.UnexpectedRecord);
                    },
                    error.InvalidControlMessage => {
                        self.sendFailureAlert(.internal_error);
                        return self.fail(error.InvalidControlMessage);
                    },
                    else => |other| return other,
                };
                const content_type = recordContentType(received) catch |err| switch (err) {
                    error.Truncated => return self.fail(err),
                    error.InvalidControlMessage => {
                        self.sendFailureAlert(.internal_error);
                        return self.fail(err);
                    },
                };
                const content = bytes[0..received.len];

                if (content_type == .handshake and content.len < 5 and
                    content.len != 0 and
                    content[0] == @intFromEnum(ztls.ClientHandshake.HandshakeType.key_update))
                {
                    self.sendFailureAlert(.unexpected_message);
                    return self.fail(error.FragmentedKeyUpdate);
                }

                const event = self.handshake.receiveKtlsRecord(content_type, content) catch |err| {
                    if (err != error.PeerAlert) {
                        self.sendFailureAlert(ztls.alert.alertForError(err));
                    }
                    return self.fail(err);
                };

                if (comptime is_client) {
                    switch (event) {
                        .application_data => |data| {
                            if (applicationLength(data)) |len| return len;
                            continue;
                        },
                        .new_session_ticket, .none => continue,
                        .closed => {
                            self.state.insert(.rx_closed);
                            return 0;
                        },
                        .key_update => |request| try self.finishPeerKeyUpdate(request),
                    }
                } else {
                    switch (event) {
                        .application_data => |data| {
                            if (applicationLength(data)) |len| return len;
                            continue;
                        },
                        .none => continue,
                        .closed => {
                            self.state.insert(.rx_closed);
                            return 0;
                        },
                        .key_update => |request| try self.finishPeerKeyUpdate(request),
                    }
                }
            }
            self.sendFailureAlert(.unexpected_message);
            return self.fail(error.ControlRecordFlood);
        }

        /// Send close_notify as a kernel alert record, then half-close TX. The
        /// caller still owns and eventually closes the file descriptor.
        pub fn closeWrite(self: *Self) ControlWriteError!void {
            if (self.state.contains(.failed)) return error.Closed;
            if (self.state.contains(.tx_closed)) return;
            const close_notify = [_]u8{
                @intFromEnum(ztls.alert.Level.warning),
                @intFromEnum(ztls.alert.Description.close_notify),
            };
            self.sendControl(.alert, &close_notify) catch |err| {
                self.poison();
                return err;
            };
            shutdown(self.fd, linux.SHUT.WR);
            self.state.insert(.tx_closed);
        }

        /// Abort transport I/O without pretending a TLS closure alert was sent.
        pub fn abort(self: *Self) void {
            self.poison();
        }

        fn recv(
            self: *Self,
            bytes: []u8,
        ) (sys.RecvError || error{InterruptedTooOften})!sys.Received {
            var interruptions: u8 = 0;
            while (interruptions < 16) : (interruptions += 1) {
                return sys.recvRecord(self.fd, bytes) catch |err| {
                    if (err == error.Interrupted) continue;
                    return err;
                };
            }
            return error.InterruptedTooOften;
        }

        fn finishPeerKeyUpdate(
            self: *Self,
            request: KeyUpdateRequest,
        ) ReadError!void {
            if (self.rekey_support == .unsupported) {
                self.sendFailureAlert(.unexpected_message);
                return self.fail(error.KtlsRekeyUnsupported);
            }

            var rx_info = self.handshake.rxKtlsInfo();
            defer rx_info.secureZero();
            installInfo(self.fd, ztls.ktls.TLS_RX, &rx_info) catch |err| switch (err) {
                error.Busy => {
                    self.sendFailureAlert(.internal_error);
                    return self.fail(error.KtlsRekeyUnsupported);
                },
                error.Unavailable, error.Failed => {
                    self.sendFailureAlert(.internal_error);
                    return self.fail(error.KtlsRekeyFailed);
                },
            };
            if (request == .update_requested and !self.state.contains(.tx_closed)) {
                self.sendKeyUpdate(.update_not_requested) catch |err| switch (err) {
                    error.KtlsRekeyUnsupported => return self.fail(error.KtlsRekeyUnsupported),
                    else => return self.fail(error.KtlsRekeyFailed),
                };
            }
        }

        fn sendKeyUpdate(
            self: *Self,
            request: KeyUpdateRequest,
        ) UpdateError!void {
            const update_msg = [_]u8{
                @intFromEnum(ztls.ClientHandshake.HandshakeType.key_update),
                0,
                0,
                1,
                @intFromEnum(request),
            };
            self.sendControl(.handshake, &update_msg) catch |err| {
                if (err == error.WouldBlock or err == error.InterruptedTooOften) return err;
                self.poison();
                return err;
            };

            self.handshake.ratchetKtlsTx(request) catch |err| {
                self.poison();
                return err;
            };
            var tx_info = self.handshake.txKtlsInfo();
            defer tx_info.secureZero();
            installInfo(self.fd, ztls.ktls.TLS_TX, &tx_info) catch |err| switch (err) {
                error.Busy => {
                    self.poison();
                    return error.KtlsRekeyUnsupported;
                },
                error.Unavailable, error.Failed => {
                    self.poison();
                    return error.KtlsRekeyFailed;
                },
            };
        }

        fn sendControl(
            self: *Self,
            content_type: ztls.frame.ContentType,
            bytes: []const u8,
        ) ControlWriteError!void {
            var interruptions: u8 = 0;
            while (interruptions < 16) : (interruptions += 1) {
                return sys.sendControl(
                    self.fd,
                    @intFromEnum(content_type),
                    bytes,
                ) catch |err| {
                    if (err == error.Interrupted) continue;
                    return err;
                };
            }
            return error.InterruptedTooOften;
        }

        fn sendFailureAlert(self: *Self, description: ztls.alert.Description) void {
            if (self.state.contains(.tx_closed) or self.state.contains(.failed)) return;
            const msg = [_]u8{
                @intFromEnum(ztls.alert.Level.fatal),
                @intFromEnum(description),
            };
            self.sendControl(.alert, &msg) catch return;
        }

        fn fail(self: *Self, err: ReadError) ReadError {
            self.poison();
            return err;
        }

        fn poison(self: *Self) void {
            shutdown(self.fd, linux.SHUT.RDWR);
            self.state.insert(.failed);
        }
    };
}

fn applicationLength(data: []const u8) ?usize {
    return if (data.len == 0) null else data.len;
}

fn recordContentType(
    received: sys.Received,
) error{ Truncated, InvalidControlMessage }!ztls.frame.ContentType {
    const raw = received.content_type orelse {
        if (received.len == 0) return error.Truncated;
        return error.InvalidControlMessage;
    };
    return @enumFromInt(raw);
}

fn installInfo(
    fd: posix.socket_t,
    direction: u32,
    info: *const ztls.RecordLayer.KtlsInfo,
) ztls.ktls.InstallError!void {
    switch (info.cipher_type) {
        .aes_gcm_128 => {
            var crypto_info = ztls.ktls.packAesGcm128(info.*) catch return error.Failed;
            defer crypto_info.secureZero();
            return ztls.ktls.installCryptoInfo(fd, direction, std.mem.asBytes(&crypto_info));
        },
        .aes_gcm_256 => {
            var crypto_info = ztls.ktls.packAesGcm256(info.*) catch return error.Failed;
            defer crypto_info.secureZero();
            return ztls.ktls.installCryptoInfo(fd, direction, std.mem.asBytes(&crypto_info));
        },
        .chacha20_poly1305 => {
            var crypto_info = ztls.ktls.packChaCha20Poly1305(info.*) catch return error.Failed;
            defer crypto_info.secureZero();
            return ztls.ktls.installCryptoInfo(fd, direction, std.mem.asBytes(&crypto_info));
        },
    }
}

fn shutdown(fd: posix.socket_t, how: i32) void {
    _ = linux.shutdown(fd, how);
}

test "empty application data is not a clean TLS close" {
    try testing.expectEqual(@as(?usize, null), applicationLength(""));
    try testing.expectEqual(@as(?usize, 1), applicationLength("x"));
}

// Linux kTLS must supply TLS_GET_RECORD_TYPE for every record. No bytes and no
// metadata is a bare FIN; bytes without metadata violate the kernel contract.
test "received bytes require kTLS record metadata" {
    try testing.expectError(
        error.Truncated,
        recordContentType(.{ .len = 0, .content_type = null }),
    );
    try testing.expectError(
        error.InvalidControlMessage,
        recordContentType(.{ .len = 1, .content_type = null }),
    );
    try testing.expectEqual(
        ztls.frame.ContentType.application_data,
        try recordContentType(.{
            .len = 0,
            .content_type = @intFromEnum(ztls.frame.ContentType.application_data),
        }),
    );
}

test {
    _ = @import("syscall.zig");
    _ = @import("tests.zig");
}
