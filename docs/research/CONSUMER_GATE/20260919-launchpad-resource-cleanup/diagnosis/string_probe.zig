const std = @import("std");
const c = @cImport({ @cInclude("openssl/crypto.h"); });
pub fn main() !void {
    try probe(std.posix.getenv("INITIALIZE") != null);
}
noinline fn probe(initialize: bool) !void {
    var source: [64]u8 align(16) = undefined;
    var dest: [128]u8 align(16) = undefined;
    if (initialize) {
        @memset(&source, 0);
        @memset(&dest, 0);
    }
    @memcpy(source[0..5], "test\x00");
    const copied = c.OPENSSL_strlcpy(&dest, &source, dest.len);
    if (copied != 4 or !std.mem.eql(u8, dest[0..5], "test\x00")) return error.WrongCopy;
    const measured = c.OPENSSL_strnlen(&source, source.len);
    if (measured != 4) return error.WrongLength;
    const appended = c.OPENSSL_strlcat(&dest, &source, dest.len);
    if (appended != 8 or !std.mem.eql(u8, dest[0..9], "testtest\x00")) return error.WrongAppend;
}
