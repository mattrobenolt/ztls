# cryptox

`cryptox` contains small crypto-adjacent patches that ztls needs before the
corresponding behavior is available from Zig's standard library.

## `Certificate.zig`

`Certificate.zig` is derived from Zig 0.15.2's `std.crypto.Certificate`:

<https://github.com/ziglang/zig/blob/0.15.2/lib/std/crypto/Certificate.zig>

It is vendored because `std.crypto.Certificate.der.Element.parse` indexes into
DER input before checking that the requested offset is inside the certificate
buffer. Fuzzing `ztls.certificate.parse` found malformed Certificate messages
that panic in std with an out-of-bounds access instead of returning a parse
error. Since server certificates are network-controlled input, that is a remote
DoS path for a TLS client.

Local changes are intentionally narrow:

- import `std` as a package module (`@import("std")`) instead of std-internal
  relative paths;
- keep OS trust-store handling std-owned by aliasing `Bundle` to
  `std.crypto.Certificate.Bundle`;
- bounds-check DER element parsing so malformed lengths return
  `error.CertificateFieldHasInvalidLength` instead of panicking.

The file keeps Zig's MIT/Expat license attribution. See `LICENSE-ZIG` in this
directory. The rest of ztls remains under the repository's Apache-2.0 license.

Remove this copy once the Zig version used by ztls has equivalent DER bounds
checks in `std.crypto.Certificate` and the certificate fuzz target stays clean
against std directly.
