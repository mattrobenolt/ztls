{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    mattware = {
      url = "github:mattrobenolt/nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      flake-parts,
      nixpkgs,
      mattware,
      rust-overlay,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        { system, ... }:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              mattware.overlays.default
              rust-overlay.overlays.default
            ];
          };
          inherit (pkgs) lib stdenv;
          ast-grep = pkgs.ast-grep {
            ruleDirs = [ ./rules ];
            languages.zig = {
              grammar = pkgs.tree-sitter-grammars.tree-sitter-zig;
              extensions = [ "zig" ];
            };
          };
          rustToolchain = pkgs.rust-bin.stable.latest.default;
        in
        {
          devShells.default = pkgs.mkShell {
            packages =
              (with pkgs; [
                ast-grep
                benchstat
                curl
                fd
                git
                go
                jdk
                just
                openssl
                pinact
                pkg-config
                rustToolchain
                uv
                opentofu
                rsync
                txtar
                zig_0_15
                zigdoc
                zizmor
                ziglint
                zls_0_15
              ])
              ++ lib.optionals stdenv.isLinux (
                with pkgs;
                [
                  perf
                  valgrind
                ]
              );

            shellHook = ''
              unset NIX_CFLAGS_COMPILE
              unset ZIG_GLOBAL_CACHE_DIR
            '';
          };
        };
    };
}
