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
        in
        {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              just
              openssl
              pkg-config
              python3
              zig_0_15
              zigdoc
              ziglint
              zls_0_15
            ];

            shellHook = ''
              unset NIX_CFLAGS_COMPILE
              unset ZIG_GLOBAL_CACHE_DIR
            '';
          };
        };
    };
}
