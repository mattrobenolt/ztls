# Shared helpers for the ztls devShells, extracted from flake.nix.
#
# This is a plain function file (NOT a flake-parts module): it takes the
# overlay-configured `pkgs` and `lib` and returns the interdependent helpers as
# a `rec` attrset. flake.nix imports it once and inherits what it needs.
# Keeping the helpers here is the actual cleanup — the shell list in flake.nix
# is already short and readable; the helper `let` block was the mess.
#
# `pkgs` must already carry the mattware + rust-overlay overlays (applied in
# flake.nix) so pkgs.rust-bin / pkgs.zig_0_15 / pkgs.ast-grep resolve. This file
# never touches `inputs` (which is unavailable inside perSystem anyway).
{ pkgs, lib }:
rec {
  ast-grep = pkgs.ast-grep {
    ruleDirs = [ ../rules ];
    languages.zig = {
      grammar = pkgs.tree-sitter-grammars.tree-sitter-zig;
      extensions = [ "zig" ];
    };
  };

  rustToolchain = pkgs.rust-bin.fromRustupToolchainFile ../bench/rustls/rust-toolchain.toml;

  wrangler = pkgs.writeShellScriptBin "wrangler" ''
    exec ${pkgs.nodejs}/bin/npx wrangler@4.107.0 "$@"
  '';

  # nixpkgs boringssl ships headers (dev) and libcrypto/libssl .so (out) but no
  # pkg-config files. Synthesize minimal libcrypto.pc and libssl.pc so the
  # existing linkSystemLibrary paths resolve BoringSSL, and benchmark baselines
  # can link BoringSSL libssl.
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

  # commonHook is interpolated into backendShell's shellHook and used directly
  # by the base shell. It isolates both Zig caches by compiler version. The
  # BoringSSL path references boringsslPc when a shell calls commonHook.
  commonHook = zig-tools: ''
    unset NIX_CFLAGS_COMPILE
    unset PKG_CONFIG_PATH
    unset ZIG_LOCAL_CACHE_DIR
    unset ZIG_GLOBAL_CACHE_DIR
    export ZIG_LOCAL_CACHE_DIR=.zig-cache/${zig-tools.zig.version}
    export ZIG_GLOBAL_CACHE_DIR="''${XDG_CACHE_HOME:-$HOME/.cache}/zig/${zig-tools.zig.version}"
    export ZTLS_OPENSSL_PKG_CONFIG_PATH=${pkgs.openssl.dev}/lib/pkgconfig
    export ZTLS_OPENSSL_LIB_DIR=${pkgs.openssl.out}/lib
    export ZTLS_AWS_LC_PKG_CONFIG_PATH=${pkgs.aws-lc.dev}/lib/pkgconfig
    export ZTLS_AWS_LC_LIB_DIR=${pkgs.aws-lc}/lib
    export ZTLS_BORINGSSL_PKG_CONFIG_PATH=${boringsslPc}
    export ZTLS_BORINGSSL_LIB_DIR=${pkgs.boringssl}/lib
  '';

  # commonPackages takes the Zig toolchain pair so the same package list can
  # target either Zig 0.15 (default) or Zig 0.16 (#61).
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
      jq
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
    ++ lib.optionals pkgs.stdenv.isLinux (
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

  # The OpenSSL package paths shared by the openssl, zig-0_16, and docs
  # shells (previously triplicated in flake.nix).
  opensslBackend = {
    pkgConfigPath = "${pkgs.openssl.dev}/lib/pkgconfig";
    packages = [
      pkgs.openssl.dev
      pkgs.openssl.out
    ];
  };

  backendShell =
    {
      name,
      pkgConfigPath,
      packages,
      zig-tools ? zig0_15,
    }:
    pkgs.mkShell {
      inherit name;
      packages = commonPackages zig-tools ++ packages;
      shellHook = ''
        ${commonHook zig-tools}
        export PKG_CONFIG_PATH=${pkgConfigPath}''${PKG_CONFIG_PATH:+:''${PKG_CONFIG_PATH}}
      '';
    };
}
