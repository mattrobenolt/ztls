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
            zig0_15
            zig0_16
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
              packages = commonPackages zig0_15;
              shellHook = commonHook zig0_15;
            };

            openssl = backendShell {
              name = "ztls-openssl";
              pkgConfigPath = opensslBackend.pkgConfigPath;
              packages = opensslBackend.packages;
            };

            # Zig 0.16 lane: same OpenSSL backend as the default shell but
            # with the 0.16 toolchain. CI uses this to prove 0.16 support is
            # real, not a local spot-check (#61).
            zig-0_16 = backendShell {
              name = "ztls-zig-0_16";
              pkgConfigPath = opensslBackend.pkgConfigPath;
              packages = opensslBackend.packages;
              zig-tools = zig0_16;
            };

            # ztls-std integration (#77): Zig 0.16 + OpenSSL backend. The
            # integration builds against the ztls core via an in-tree path dep
            # (integrations/ztls-std/build.zig.zon). Reuses shared helpers.
            ztls-std = backendShell {
              name = "ztls-std";
              pkgConfigPath = opensslBackend.pkgConfigPath;
              packages = opensslBackend.packages;
              zig-tools = zig0_16;
            };

            # ztls-xev integration (#76): Zig 0.16 + OpenSSL backend. libxev is a
            # pure-Zig dependency fetched by the package, so this shell is the
            # same shape as ztls-std.
            ztls-xev = backendShell {
              name = "ztls-xev";
              pkgConfigPath = opensslBackend.pkgConfigPath;
              packages = opensslBackend.packages;
              zig-tools = zig0_16;
            };

            # ztls-ktls integration (#78): Zig 0.16 + OpenSSL backend. The
            # package itself is Linux-only and root CI skips it on macOS.
            ztls-ktls = backendShell {
              name = "ztls-ktls";
              pkgConfigPath = opensslBackend.pkgConfigPath;
              packages = opensslBackend.packages;
              zig-tools = zig0_16;
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
