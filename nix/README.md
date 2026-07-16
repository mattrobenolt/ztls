# nix

DevShell helpers for the ztls flake.

## Layout

- `shared.nix` — a plain function `{ pkgs, lib }: rec { ... }` holding the
  interdependent devShell helpers (`commonPackages`, `commonHook`,
  `boringsslPc`, `backendShell`, the zig 0.15/0.16 tool sets, `ast-grep`,
  `rustToolchain`, `wrangler`, and the shared `opensslBackend` literal).
  `flake.nix` imports it once and inherits what it needs. `pkgs` must already
  carry the mattware + rust-overlay overlays (applied in `flake.nix`); this file
  never touches `inputs` (which is unavailable inside `perSystem`).

`flake.nix` keeps a single `perSystem` with the `devShells = rec { ... }` list
inline. The helpers were the mess; the shell list is short and readable. Adding
a shell is adding an entry to the `rec` block (and, if it needs a new input or
overlay, a line in `flake.nix`).

## Path relativity

Path literals in `shared.nix` are relative to this file (`nix/`), so they use
`../rules` and `../bench/rustls/rust-toolchain.toml` — not the repo-root
relative paths `flake.nix` used before extraction.
