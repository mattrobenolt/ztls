pub const Family = enum {
    openssl,
    @"aws-lc",
    boringssl,
};

// #145 — the translated decls come from the openssl_c module (wrapper
// header src/crypto/openssl_c.h, b.addTranslateC in src/build/translate_c.zig).
// The wrapper's family dispatch happens in the C preprocessor over the same
// identity macros checked here: opensslv.h is common to all three supported
// families, and AWS-LC and BoringSSL reach their base.h identity macros
// through crypto.h, so translate-c emits OPENSSL_IS_AWSLC /
// OPENSSL_IS_BORINGSSL exactly when the wrapper took the BoringSSL-family
// branch. translate-c renders a valueless #define as an empty-string const,
// so @hasDecl keeps working as the Zig-side mirror of that dispatch.
const translated = @import("openssl_c");

pub const family: Family = if (@hasDecl(translated, "OPENSSL_IS_AWSLC"))
    .@"aws-lc"
else if (@hasDecl(translated, "OPENSSL_IS_BORINGSSL"))
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

pub const openssl = translated;
