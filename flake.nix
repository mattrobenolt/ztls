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
        { system, lib, ... }:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              mattware.overlays.default
              rust-overlay.overlays.default
            ];
          };
          shared = import ./nix/shared.nix { inherit pkgs lib; };
          inherit (shared)
            commonPackages
            commonHook
            boringsslPc
            backendShell
            zig
            opensslBackend
            ;
        in
        {
          formatter = pkgs.nixfmt;

          # Diagnostic provider for #121. Production keeps the optimized build.
          # GCC vector scans trigger Memcheck reports after valid NUL terminators.
          packages.openssl-memcheck = pkgs.openssl.overrideAttrs (old: {
            configureFlags = old.configureFlags ++ [ "-fno-tree-vectorize" ];
          });

          devShells = rec {
            base = pkgs.mkShell {
              name = "ztls-base";
              packages = commonPackages zig;
              shellHook = commonHook zig;
            };

            openssl = backendShell {
              name = "ztls-openssl";
              pkgConfigPath = opensslBackend.pkgConfigPath;
              packages = opensslBackend.packages;
            };

            aws-lc = backendShell {
              name = "ztls-aws-lc";
              pkgConfigPath = "${pkgs.aws-lc.dev}/lib/pkgconfig";
              packages = [
                pkgs.aws-lc.dev
                pkgs.aws-lc
              ];
            };

            boringssl = backendShell {
              name = "ztls-boringssl";
              pkgConfigPath = "${boringsslPc}";
              packages = [
                pkgs.boringssl.dev
                pkgs.boringssl
              ];
            };

            # Docs site tooling: Zig autodoc build plus mdBook and wrangler
            # for building and publishing the Cloudflare site. Built on the
            # OpenSSL backend shell.
            docs = backendShell {
              name = "ztls-docs";
              pkgConfigPath = opensslBackend.pkgConfigPath;
              packages = opensslBackend.packages ++ [
                pkgs.mdbook
                pkgs.nodejs
                shared.wrangler
              ];
            };

            # Brand asset tooling (wordmark/logo generation). Kept out of the
            # common dev shell so ztls devs don't carry font/Python deps.
            brand = pkgs.mkShell {
              name = "ztls-brand";
              packages = [
                (pkgs.python3.withPackages (ps: [ ps.fonttools ]))
                pkgs.jetbrains-mono
                pkgs.just
              ];
              shellHook = ''
                export ZTLS_BRAND_FONT_DIR=${pkgs.jetbrains-mono}/share/fonts
              '';
            };

            default = openssl;
          };
        };
    };
}
