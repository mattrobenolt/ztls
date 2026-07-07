const build_options = @import("build_options");

const is_aws_lc_backend = build_options.crypto_backend == .@"aws-lc";

pub const openssl = @cImport({
    if (is_aws_lc_backend) @cInclude("openssl/base.h");
    if (is_aws_lc_backend) @cInclude("openssl/aead.h");
    if (is_aws_lc_backend) @cInclude("openssl/curve25519.h");
    if (!is_aws_lc_backend) @cInclude("openssl/core.h");
    if (!is_aws_lc_backend) @cInclude("openssl/core_names.h");
    @cInclude("openssl/bio.h");
    @cInclude("openssl/bn.h");
    @cInclude("openssl/ec.h");
    @cInclude("openssl/err.h");
    @cInclude("openssl/evp.h");
    if (!is_aws_lc_backend) @cInclude("openssl/params.h");
    @cInclude("openssl/obj_mac.h");
    @cInclude("openssl/pem.h");
    @cInclude("openssl/rsa.h");
});

comptime {
    if (is_aws_lc_backend and !@hasDecl(openssl, "OPENSSL_IS_AWSLC")) {
        @compileError("-Dcrypto-backend=aws-lc requires AWS-LC libcrypto headers");
    }
}
