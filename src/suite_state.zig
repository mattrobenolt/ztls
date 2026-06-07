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
        client_finished_key: Hkdf.Prk = undefined,
        server_finished_key: Hkdf.Prk = undefined,
        client_app_secret: Hkdf.Prk = undefined,
        server_app_secret: Hkdf.Prk = undefined,

        pub inline fn secureZero(self: *Self) void {
            std.crypto.secureZero(u8, mem.asBytes(self));
        }

        pub fn ratchetClientKey(self: *Self) aead.Error!RecordLayer {
            self.client_app_secret = Hkdf.nextTrafficSecret(self.client_app_secret);
            return Hkdf.makeRecordLayer(self.aead, self.client_app_secret);
        }

        pub fn ratchetServerKey(self: *Self) aead.Error!RecordLayer {
            self.server_app_secret = Hkdf.nextTrafficSecret(self.server_app_secret);
            return Hkdf.makeRecordLayer(self.aead, self.server_app_secret);
        }
    };
}
