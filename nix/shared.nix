# Shared helpers for the ztls devShells, extracted from flake.nix.
#
# This is a plain function file (NOT a flake-parts module): it takes the
# overlay-configured `pkgs` and `lib` and returns the interdependent helpers as
# a `rec` attrset. flake.nix imports it once and inherits what it needs.
# Keeping the helpers here is the actual cleanup — the shell list in flake.nix
# is already short and readable; the helper `let` block was the mess.
#
# `pkgs` must already carry the mattware + rust-overlay overlays (applied in
# flake.nix) so pkgs.rust-bin / pkgs.zig_0_16 / pkgs.ast-grep resolve. This file
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
    exec env NPM_CONFIG_MIN_RELEASE_AGE=0 ${pkgs.nodejs}/bin/npx wrangler@4.148.0 "$@"
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

  # nixpkgs-unstable flipped the default openssl to the 3.5 LTS line (2026-10-06);
  # ztls pins the 3.6 line so the default backend, the CLI interop peer, and the
  # #121 memcheck diagnostic do not silently hop lines with a lockfile refresh.
  # The name intentionally shadows pkgs.openssl below (the ast-grep pattern).
  openssl = pkgs.openssl_3_6;

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
    export ZTLS_OPENSSL_PKG_CONFIG_PATH=${openssl.dev}/lib/pkgconfig
    export ZTLS_OPENSSL_LIB_DIR=${openssl.out}/lib
    export ZTLS_AWS_LC_PKG_CONFIG_PATH=${pkgs.aws-lc.dev}/lib/pkgconfig
    export ZTLS_AWS_LC_LIB_DIR=${pkgs.aws-lc}/lib
    export ZTLS_BORINGSSL_PKG_CONFIG_PATH=${boringsslPc}
    export ZTLS_BORINGSSL_LIB_DIR=${pkgs.boringssl}/lib
    # Some devShell packages propagate the nixpkgs default-line openssl into
    # PATH ahead of the pinned one. Prepend so the CLI interop peer rides the
    # pinned 3.6 line, not whatever the default propagates.
    export PATH=${openssl.bin}/bin:$PATH
  '';

  # commonPackages takes the Zig toolchain pair. ztls is Zig 0.16-only.
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

  zig = {
    zig = pkgs.zig_0_16;
    zls = pkgs.zls_0_16;
  };

  # The OpenSSL package paths shared by the openssl and docs shells
  # (previously triplicated in flake.nix).
  opensslBackend = {
    pkgConfigPath = "${openssl.dev}/lib/pkgconfig";
    packages = [
      openssl.dev
      openssl.out
    ];
  };

  backendShell =
    {
      name,
      pkgConfigPath,
      packages,
      zig-tools ? zig,
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
