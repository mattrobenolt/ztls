//! Hash-parameterized TLS 1.3 traffic-secret state shared by client and server.
const std = @import("std");
const mem = std.mem;

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

        pub inline fn secureZero(self: *Self) void {
            std.crypto.secureZero(u8, mem.asBytes(self));
        }

        pub fn forgetHandshakeSecrets(self: *Self) void {
            self.handshake_secret.secureZero();
            self.client_finished_key.secureZero();
            self.server_finished_key.secureZero();
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
