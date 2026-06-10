pub const openssl = @cImport({
    @cInclude("openssl/bio.h");
    @cInclude("openssl/bn.h");
    @cInclude("openssl/ec.h");
    @cInclude("openssl/err.h");
    @cInclude("openssl/evp.h");
    @cInclude("openssl/obj_mac.h");
    @cInclude("openssl/pem.h");
    @cInclude("openssl/rsa.h");
});
