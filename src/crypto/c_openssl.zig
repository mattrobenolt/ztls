pub const Family = enum {
    openssl,
    @"aws-lc",
    boringssl,
};

// opensslv.h is common to all three supported families. AWS-LC and BoringSSL
// reach their base.h identity macros through crypto.h, so the selected headers
// are the compile-time source of truth for the backend family.
const identity = @cImport({
    @cInclude("openssl/opensslv.h");
});

pub const family: Family = if (@hasDecl(identity, "OPENSSL_IS_AWSLC"))
    .@"aws-lc"
else if (@hasDecl(identity, "OPENSSL_IS_BORINGSSL"))
    .boringssl
else
    .openssl;

// AWS-LC and BoringSSL are both BoringSSL-family: they share the flat
// curve25519.h X25519 API and the EVP_AEAD one-shot AEAD API, and neither
// exposes the OpenSSL 3.x provider API (core.h, core_names.h). BoringSSL
// does ship openssl/params.h but the provider symbols (OSSL_PARAM,
// EVP_PKEY_fromdata, EVP_PKEY_CTX_new_from_name) are absent, so we exclude
// it the same as AWS-LC — the legacy EC_KEY/EVP_DigestSign path is the only
// key-construction/signature path. Pub so backend code can comptime-gate
// provider-parameter features (e.g. the RFC 6979 nonce-type,
// mattrobenolt/ztls#82).
pub const is_boringssl_family = family != .openssl;

pub const openssl = @cImport({
    if (family == .boringssl) {
        @cInclude("openssl/base.h");
        // Zig 0.16 translate-c emits BoringSSL's expanded _Pragma tokens as C
        // declarations. These macros only suppress C compiler warnings.
        @cUndef("OPENSSL_BEGIN_ALLOW_DEPRECATED");
        @cDefine("OPENSSL_BEGIN_ALLOW_DEPRECATED", "");
        @cUndef("OPENSSL_END_ALLOW_DEPRECATED");
        @cDefine("OPENSSL_END_ALLOW_DEPRECATED", "");
        @cUndef("OPENSSL_GNUC_CLANG_PRAGMA");
        @cDefine("OPENSSL_GNUC_CLANG_PRAGMA(arg)", "");
        @cUndef("OPENSSL_CLANG_PRAGMA");
        @cDefine("OPENSSL_CLANG_PRAGMA(arg)", "");
    } else if (is_boringssl_family) {
        @cInclude("openssl/base.h");
    }
    if (is_boringssl_family) @cInclude("openssl/aead.h");
    if (is_boringssl_family) @cInclude("openssl/curve25519.h");
    if (!is_boringssl_family) @cInclude("openssl/core.h");
    if (!is_boringssl_family) @cInclude("openssl/core_names.h");
    @cInclude("openssl/bio.h");
    @cInclude("openssl/bn.h");
    @cInclude("openssl/ec.h");
    @cInclude("openssl/err.h");
    @cInclude("openssl/evp.h");
    if (!is_boringssl_family) @cInclude("openssl/params.h");
    @cInclude("openssl/obj_mac.h");
    @cInclude("openssl/pem.h");
    @cInclude("openssl/rsa.h");
    @cInclude("openssl/sha.h");
});
