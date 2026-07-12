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
          rustToolchain = pkgs.rust-bin.fromRustupToolchainFile ./bench/rustls/rust-toolchain.toml;
          wrangler = pkgs.writeShellScriptBin "wrangler" ''
            exec ${pkgs.nodejs}/bin/npx wrangler@4.107.0 "$@"
          '';
          # commonPackages takes the Zig toolchain pair so the same package
          # list can target either Zig 0.15 (default) or Zig 0.16 (#61).
          commonPackages =
            zig-tools:
            (with pkgs; [
              ast-grep
              benchstat
              binutils
              curl
              fd
              git
              go
              jdk
              just
              llvm
              openssl.bin
              pinact
              pkg-config
              rustToolchain
              shellcheck
              uv
              opentofu
              rsync
              txtar
              zig-tools.zig
              zigdoc
              zizmor
              ziglint
              zig-tools.zls
            ])
            ++ lib.optionals stdenv.isLinux (
              with pkgs;
              [
                perf
                valgrind
              ]
            );
          zig0_15 = {
            zig = pkgs.zig_0_15;
            zls = pkgs.zls_0_15;
          };
          zig0_16 = {
            zig = pkgs.zig_0_16;
            zls = pkgs.zls_0_16;
          };
          commonHook = ''
            unset NIX_CFLAGS_COMPILE
            unset PKG_CONFIG_PATH
            unset ZIG_GLOBAL_CACHE_DIR
            unset ZTLS_CRYPTO_BACKEND
            unset ZTLS_CRYPTO_PKG_CONFIG_PATH
            unset ZTLS_CRYPTO_LIB_DIR
            export ZTLS_OPENSSL_PKG_CONFIG_PATH=${pkgs.openssl.dev}/lib/pkgconfig
            export ZTLS_OPENSSL_LIB_DIR=${pkgs.openssl.out}/lib
            export ZTLS_AWS_LC_PKG_CONFIG_PATH=${pkgs.aws-lc.dev}/lib/pkgconfig
            export ZTLS_AWS_LC_LIB_DIR=${pkgs.aws-lc}/lib
            export ZTLS_BORINGSSL_PKG_CONFIG_PATH=${boringsslPc}
            export ZTLS_BORINGSSL_LIB_DIR=${pkgs.boringssl}/lib
          '';
          # nixpkgs boringssl ships headers (dev) and libcrypto/libssl .so
          # (out) but no pkg-config files. Synthesize minimal libcrypto.pc
          # and libssl.pc so the existing linkSystemLibrary paths resolve
          # BoringSSL, and benchmark baselines can link BoringSSL libssl.
          boringsslPc = pkgs.symlinkJoin {
            name = "boringssl-pkgconfig";
            paths = [
              (pkgs.writeTextDir "libcrypto.pc" ''
                prefix=${pkgs.boringssl.dev}
                exec_prefix=${pkgs.boringssl}
                libdir=${pkgs.boringssl}/lib
                includedir=${pkgs.boringssl.dev}/include

                Name: libcrypto
                Description: BoringSSL libcrypto
                Version: ${pkgs.boringssl.version}
                Libs: -L''${libdir} -lcrypto
                Cflags: -I''${includedir}
              '')
              (pkgs.writeTextDir "libssl.pc" ''
                prefix=${pkgs.boringssl.dev}
                exec_prefix=${pkgs.boringssl}
                libdir=${pkgs.boringssl}/lib
                includedir=${pkgs.boringssl.dev}/include

                Name: libssl
                Description: BoringSSL libssl
                Version: ${pkgs.boringssl.version}
                Libs: -L''${libdir} -lssl
                Cflags: -I''${includedir}
              '')
            ];
          };
          backendShell =
            {
              name,
              backend,
              pkgConfigPath,
              libDir,
              packages,
              zig-tools ? zig0_15,
            }:
            pkgs.mkShell {
              inherit name;
              packages = commonPackages zig-tools ++ packages;
              shellHook = ''
                ${commonHook}
                export ZTLS_CRYPTO_BACKEND=${backend}
                export ZTLS_CRYPTO_PKG_CONFIG_PATH=${pkgConfigPath}
                export ZTLS_CRYPTO_LIB_DIR=${libDir}
                export PKG_CONFIG_PATH=${pkgConfigPath}''${PKG_CONFIG_PATH:+:''${PKG_CONFIG_PATH}}
              '';
            };
        in
        {
          formatter = pkgs.nixfmt;

          devShells = rec {
            base = pkgs.mkShell {
              name = "ztls-base";
              packages = commonPackages zig0_15;
              shellHook = commonHook;
            };

            openssl = backendShell {
              name = "ztls-openssl";
              backend = "openssl";
              pkgConfigPath = "${pkgs.openssl.dev}/lib/pkgconfig";
              libDir = "${pkgs.openssl.out}/lib";
              packages = [
                pkgs.openssl.dev
                pkgs.openssl.out
              ];
            };

            # Zig 0.16 lane: same OpenSSL backend as the default shell but
            # with the 0.16 toolchain. CI uses this to prove 0.16 support is
            # real, not a local spot-check (#61).
            zig-0_16 = backendShell {
              name = "ztls-zig-0_16";
              backend = "openssl";
              pkgConfigPath = "${pkgs.openssl.dev}/lib/pkgconfig";
              libDir = "${pkgs.openssl.out}/lib";
              packages = [
                pkgs.openssl.dev
                pkgs.openssl.out
              ];
              zig-tools = zig0_16;
            };

            aws-lc = backendShell {
              name = "ztls-aws-lc";
              backend = "aws-lc";
              pkgConfigPath = "${pkgs.aws-lc.dev}/lib/pkgconfig";
              libDir = "${pkgs.aws-lc}/lib";
              packages = [
                pkgs.aws-lc.dev
                pkgs.aws-lc
              ];
            };

            boringssl = backendShell {
              name = "ztls-boringssl";
              backend = "boringssl";
              pkgConfigPath = "${boringsslPc}";
              libDir = "${pkgs.boringssl}/lib";
              packages = [
                pkgs.boringssl.dev
                pkgs.boringssl
              ];
            };

            # Docs site tooling: Zig autodoc build (needs the crypto backend
            # env) plus mdBook and wrangler for building and publishing the
            # Cloudflare site. Built on the OpenSSL backend shell.
            docs = backendShell {
              name = "ztls-docs";
              backend = "openssl";
              pkgConfigPath = "${pkgs.openssl.dev}/lib/pkgconfig";
              libDir = "${pkgs.openssl.out}/lib";
              packages = [
                pkgs.openssl.dev
                pkgs.openssl.out
                pkgs.mdbook
                pkgs.nodejs
                wrangler
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
