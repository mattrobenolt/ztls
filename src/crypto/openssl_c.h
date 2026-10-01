// #145 — translate-c wrapper for the libcrypto-family C API (b.addTranslateC
// replaces @cImport in Zig 0.16). One wrapper serves the ztls module, the
// test module, the #88 errq check, and the bench/c.zig C-API baseline.
//
// opensslv.h is common to all three supported families. AWS-LC and BoringSSL
// reach their base.h identity macros through crypto.h, so the selected headers
// are the compile-time source of truth for the backend family. The family
// dispatch happens here in the C preprocessor: the macros the preprocessor
// sees are the same ones translate-c emits, so c_openssl.zig's @hasDecl
// detection stays in lockstep with this #if.
#include <openssl/opensslv.h>

#if defined(OPENSSL_IS_AWSLC) || defined(OPENSSL_IS_BORINGSSL)
#include <openssl/base.h>
// Zig 0.16 translate-c emits BoringSSL's expanded _Pragma tokens as C
// declarations. These macros only suppress C compiler warnings. They are
// defined by base.h above; neutered here, before any header that uses them.
#undef OPENSSL_BEGIN_ALLOW_DEPRECATED
#define OPENSSL_BEGIN_ALLOW_DEPRECATED
#undef OPENSSL_END_ALLOW_DEPRECATED
#define OPENSSL_END_ALLOW_DEPRECATED
#undef OPENSSL_GNUC_CLANG_PRAGMA
#define OPENSSL_GNUC_CLANG_PRAGMA(arg)
#undef OPENSSL_CLANG_PRAGMA
#define OPENSSL_CLANG_PRAGMA(arg)
#include <openssl/aead.h>
#include <openssl/curve25519.h>
#else
#include <openssl/core.h>
#include <openssl/core_names.h>
#include <openssl/params.h>
#endif

#include <openssl/bio.h>
#include <openssl/bn.h>
#include <openssl/ec.h>
#include <openssl/err.h>
#include <openssl/evp.h>
#include <openssl/obj_mac.h>
#include <openssl/pem.h>
#include <openssl/rsa.h>
#include <openssl/sha.h>
