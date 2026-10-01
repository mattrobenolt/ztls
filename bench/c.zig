// #145 — the translated C API now comes from the shared openssl_c module
// (wrapper header src/crypto/openssl_c.h): this bench lane's header set is a
// subset of the library's.
pub const openssl = @import("openssl_c");
