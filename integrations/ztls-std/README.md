# ztls-std

Opinionated TLS 1.3 stream wrapper over `std.Io.net` — Zig 0.16 only.

Converts a connected `std.Io.net` stream into a TLS connection so a caller can
`connect`/`read`/`writeAll`/`close` without writing a Sans-I/O drive loop. The
reference integration; `ztls-xev` and `ztls-ktls` adapt its handshake-to-
completion loop. See [the roadmap](../../docs/research/STD_IO_ROADMAP.md) and
[#77](https://github.com/mattrobenolt/ztls/issues/77).

## Status

Scaffold. The wrapper API, system-bundle cert verification by default, and the
byte-stream buffering layer are the implementation work tracked by #77.

## Build

In-tree, the package depends on the ztls core via a path dep (`../..`), the same
pattern `conformance/` uses. From the repo root devshell:

```
cd integrations/ztls-std
zig build          # build the smoke executable
zig build test     # run scaffold tests
zig build run      # run the smoke executable
```

Devshell: `nix develop .#ztls-std` (Zig 0.16 + OpenSSL backend, reuses the
shared `nix/shared.nix` helpers).

Distribution as an independently `zig fetch`-able package is tracked by #79.
