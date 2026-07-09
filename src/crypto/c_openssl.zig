const build_options = @import("build_options");

// FIPS identities share their parent backend's libcrypto headers: aws-lc-fips
// uses AWS-LC headers (no openssl/core.h), so it must be treated as
// BoringSSL-family for the c_import the same as aws-lc. Otherwise the
// aws-lc-fips build tries to include openssl/core.h under the AWS-LC devshell
// and fails (core.h is absent from AWS-LC).
const is_aws_lc_backend = build_options.crypto_backend == .@"aws-lc" or
    build_options.crypto_backend == .@"aws-lc-fips";
const is_boringssl_backend = build_options.crypto_backend == .boringssl;

// AWS-LC and BoringSSL are both BoringSSL-family: they share the flat
// curve25519.h X25519 API and the EVP_AEAD one-shot AEAD API, and neither
// exposes the OpenSSL 3.x provider API (core.h, core_names.h). BoringSSL
// does ship openssl/params.h but the provider symbols (OSSL_PARAM,
// EVP_PKEY_fromdata, EVP_PKEY_CTX_new_from_name) are absent, so we exclude
// it the same as AWS-LC — the legacy EC_KEY/EVP_DigestSign path is the only
// key-construction/signature path.
const is_boringssl_family = is_aws_lc_backend or is_boringssl_backend;

pub const openssl = @cImport({
    if (is_boringssl_family) @cInclude("openssl/base.h");
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
});

comptime {
    if (is_aws_lc_backend and !@hasDecl(openssl, "OPENSSL_IS_AWSLC")) {
        @compileError("-Dcrypto-backend=aws-lc requires AWS-LC libcrypto headers");
    }
    if (is_boringssl_backend and !@hasDecl(openssl, "OPENSSL_IS_BORINGSSL")) {
        @compileError("-Dcrypto-backend=boringssl requires BoringSSL libcrypto headers");
    }
}
