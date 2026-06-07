{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    mattware = {
      url = "github:mattrobenolt/nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      flake-parts,
      nixpkgs,
      mattware,
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
            overlays = [ mattware.overlays.default ];
          };
          ast-grep = pkgs.ast-grep {
            languages.zig = {
              grammar = pkgs.tree-sitter-grammars.tree-sitter-zig;
              extensions = [ "zig" ];
            };
          };
          inherit (pkgs) lib stdenv;
        in
        {
          devShells.default = pkgs.mkShell {
            packages =
              (with pkgs; [
                ast-grep
                just
                nushell
                openssl
                pinact
                pkg-config
                python3
                uv
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
