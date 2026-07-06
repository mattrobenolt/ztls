//! Hash-parameterized TLS 1.3 traffic-secret state shared by client and server.
const std = @import("std");
const mem = std.mem;
const crypto = std.crypto;

const aead = @import("aead.zig");
const CipherSuite = @import("cipher_suite.zig").CipherSuite;
const RecordLayer = @import("RecordLayer.zig");

pub fn HashArm(comptime Hkdf_: type, comptime Hash: type) type {
    return struct {
        const Self = @This();
        pub const Hkdf = Hkdf_;

        transcript: Hash,
        aead: CipherSuite,
        handshake_secret: Hkdf.Prk = undefined,
        client_finished_key: Hkdf.FinishedKey = undefined,
        server_finished_key: Hkdf.FinishedKey = undefined,
        client_app_secret: Hkdf.TrafficSecret = undefined,
        server_app_secret: Hkdf.TrafficSecret = undefined,
        /// RFC 8446 §7.5 — resumption_master_secret, derived from the master
        /// secret and the transcript through the client Finished. Retained
        /// post-handshake so the client can derive per-ticket PSKs from
        /// NewSessionTicket nonces. NOT in the forgetHandshakeSecrets range.
        resumption_master: Hkdf.Prk = undefined,
        resumption_master_valid: bool = false,

        pub inline fn secureZero(self: *Self) void {
            crypto.secureZero(u8, mem.asBytes(self));
        }

        pub fn forgetHandshakeSecrets(self: *Self) void {
            // These three values are only needed through Finished verification
            // and application-secret derivation. Keep them adjacent so they can
            // be wiped with one volatile zeroing operation instead of three
            // separate calls.
            //
            // The offset checks make the layout dependency explicit: if someone
            // inserts a field into this range later, the build fails rather than
            // silently leaving part of the handshake secret state uncleared.
            comptime {
                const handshake_end = @offsetOf(Self, "handshake_secret") +
                    @sizeOf(Hkdf.Prk);
                const client_finished_end = @offsetOf(Self, "client_finished_key") +
                    @sizeOf(Hkdf.FinishedKey);
                if (@offsetOf(Self, "client_finished_key") != handshake_end)
                    @compileError("handshake secrets must stay contiguous");
                if (@offsetOf(Self, "server_finished_key") != client_finished_end)
                    @compileError("handshake secrets must stay contiguous");
            }

            const start = @offsetOf(Self, "handshake_secret");
            const end = @offsetOf(Self, "server_finished_key") + @sizeOf(Hkdf.FinishedKey);
            crypto.secureZero(u8, mem.asBytes(self)[start..end]);
        }

        pub fn ratchetClientKey(self: *Self) aead.Error!RecordLayer {
            var next_secret = Hkdf.nextTrafficSecret(self.client_app_secret);
            defer next_secret.secureZero();
            self.client_app_secret.secureZero();
            self.client_app_secret = next_secret;
            return Hkdf.makeRecordLayer(self.aead, self.client_app_secret);
        }

        pub fn ratchetServerKey(self: *Self) aead.Error!RecordLayer {
            var next_secret = Hkdf.nextTrafficSecret(self.server_app_secret);
            defer next_secret.secureZero();
            self.server_app_secret.secureZero();
            self.server_app_secret = next_secret;
            return Hkdf.makeRecordLayer(self.aead, self.server_app_secret);
        }
    };
}
