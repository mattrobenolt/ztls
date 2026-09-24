//! SHA-256 and SHA-384 over the linked libcrypto (#138).
//!
//! `std.crypto.hash.sha2` picks its compression code at compile time from the
//! target CPU features, so a `-Dcpu=baseline` build runs the software path on
//! a host with SHA extensions. The libcrypto family picks its code at run time
//! (`OPENSSL_armcap`, `OPENSSL_ia32cap`). These types put the handshake
//! transcript, HMAC, and HKDF on that runtime-dispatched code.
//!
//! The types follow the `std.crypto.hash` interface, so hmac.zig and the std
//! HMAC and HKDF generics instantiate over them unchanged. They are copyable
//! value types: the context is the backend's plain stack struct
//! (`SHA256_CTX`, `SHA512_CTX`), which holds no pointers and allocates
//! nothing. A copy is an independent snapshot of the running hash, which the
//! transcript uses for Transcript-Hash values (RFC 8446 §4.4.1).
//!
//! OpenSSL 3 declares these low-level functions under
//! `OPENSSL_NO_DEPRECATED_3_0`. translate-c ignores the deprecation
//! attribute, so a default OpenSSL build compiles. An OpenSSL built with
//! `no-deprecated` omits the declarations, and this file then fails to
//! compile on the missing `SHA256_Init`. The OpenSSL in the flake ships them.
//!
//! Return codes: `SHA*_Init` and `SHA*_Update` always return 1 in OpenSSL 3,
//! AWS-LC, and BoringSSL. `SHA*_Final` is documented to return 0 only on
//! programmer error. In OpenSSL that is a context `md_len` outside the
//! supported digest lengths. `md_len` comes from `Init`, and `SHA384_Final`
//! and `SHA512_Final` are one function that selects the output length by
//! `md_len`. So a mismatched `Init`/`Final` pair would not return 0: it would
//! write the wrong length. Each type here fixes its pair at comptime, and
//! nothing else writes the context, so neither failure can occur. The std
//! interface has no error channel, so a 0 panics: a silent wrong digest would
//! corrupt the key schedule. None of these functions pushes onto the
//! libcrypto error queue, so they take no `errqEnter` / `errqExit` guard
//! (#88).
//!
//! These types do not run at comptime. Comptime-constant digests (for
//! example `Hash("")` in hkdf.zig) stay on std.
const c = @import("c_openssl.zig").openssl;

pub const Sha256 = Sha2(.{
    .Context = c.SHA256_CTX,
    .digest_length = 32,
    .block_length = 64,
    .init = c.SHA256_Init,
    .update = c.SHA256_Update,
    .final = c.SHA256_Final,
});

pub const Sha384 = Sha2(.{
    .Context = c.SHA512_CTX,
    .digest_length = 48,
    .block_length = 128,
    .init = c.SHA384_Init,
    .update = c.SHA384_Update,
    .final = c.SHA384_Final,
});

fn Sha2(comptime f: anytype) type {
    return struct {
        const Self = @This();
        pub const digest_length = f.digest_length;
        pub const block_length = f.block_length;
        pub const Options = struct {};

        context: f.Context,

        pub fn init(options: Options) Self {
            _ = options;
            var self: Self = undefined;
            check(f.init(&self.context));
            return self;
        }

        pub fn hash(b: []const u8, out: *[digest_length]u8, options: Options) void {
            var d: Self = .init(options);
            d.update(b);
            d.final(out);
        }

        pub fn update(d: *Self, b: []const u8) void {
            check(f.update(&d.context, b.ptr, b.len));
        }

        pub fn final(d: *Self, out: *[digest_length]u8) void {
            check(f.final(out, &d.context));
        }

        pub fn finalResult(d: *Self) [digest_length]u8 {
            var out: [digest_length]u8 = undefined;
            d.final(&out);
            return out;
        }

        /// Digest of the input so far. `d` keeps running.
        pub fn peek(d: Self) [digest_length]u8 {
            var copy = d;
            return copy.finalResult();
        }
    };
}

inline fn check(rc: c_int) void {
    if (rc != 1) @panic("libcrypto SHA-2 call failed");
}
