# cryptox

`cryptox` contains crypto-adjacent code derived from upstream implementations
when ztls needs a narrow local variant.

## `Certificate.zig`

`Certificate.zig` is derived from Zig 0.15.2's `std.crypto.Certificate`:

<https://github.com/ziglang/zig/blob/0.15.2/lib/std/crypto/Certificate.zig>

The vendored copy keeps the parser and verification code local while leaving OS
trust-store handling in std via `std.crypto.Certificate.Bundle`.

Local mechanical changes from upstream are intentionally small:

- import `std` as a package module (`@import("std")`) instead of std-internal
  relative paths;
- alias `Bundle` to `std.crypto.Certificate.Bundle` instead of vendoring OS
  trust-store code.

The file keeps Zig's MIT/Expat license attribution. See `LICENSE-ZIG` in this
directory. The rest of ztls remains under the repository's Apache-2.0 license.
