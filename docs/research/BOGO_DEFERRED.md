# BoGo runner integration — durable deferral

This note records why ztls does not carry a BoringSSL BoGo runner integration at this stage. It is referenced from `CONFORMANCE_ROADMAP.md`, `PRODUCTION_READINESS.md`, and GitHub issue #50.

Status claims still live in `PRODUCTION_READINESS.md`; this file is only the decision record and re-entry bar.

## Scope

The candidate integration would run BoringSSL's `ssl/test/runner` against a ztls shim binary that behaves like `bssl_shim`. The useful version is dual-role: server and client, real cert/key loading, `-shim-writes-first`, supported named groups and signature schemes, strict output normalization, and a skip list tied to GitHub issues.

## Paths considered

1. **Vendor BoringSSL's runner and patch the shim path.** BoringSSL's Go runner expects its build-tree layout and a `bssl_shim` path under `../../../build/ssl/test/bssl_shim`. Vendoring or sparse-checking the runner, pinning a BoringSSL revision, patching the shim path, and maintaining that fork is the only honest BoGo execution path.

2. **Recreate enough of the BoringSSL tree layout.** This avoids editing the runner but still needs a pinned BoringSSL checkout, a ztls shim that satisfies the runner contract, and build-tree fakery. It saves little and hides the same maintenance cost behind directory layout tricks.

3. **Defer deliberately.** This document chooses that path.

The earlier `conformance/src/bogo.zig`, `bogo-fetch.sh`, `run_bogo.sh`, and `bogo-skip-list.json` scaffolding was removed in PR #21 / commit `838eb92` because it was a non-functional stub: server-only, fixture-key-only, no real runner invocation, no `-shim-writes-first`, no client role, and skip reasons tied to pi TODO IDs rather than GitHub issues. Reintroducing that shape would be worse than having no BoGo integration.

## Upstream reconfirmation

Reconfirmed on 2026-07-04 against BoringSSL `HEAD` `1c7d52ef3e3f373302cb957089fa783d1e5fd8cd`:

```text
$ git ls-remote https://github.com/google/boringssl.git HEAD
1c7d52ef3e3f373302cb957089fa783d1e5fd8cd	HEAD
$ grep -n 'shimPath.*bssl_shim\|func newShimProcess\|-port\|-shim-id' ssl/test/runner/runner.go | head -8
67:	shimPath           = flag.String("shim-path", "../../../build/ssl/test/bssl_shim", "The location of the shim binary.")
1368:// environment. It internally creates a TCP listener and adds the -port
1370:func newShimProcess(dispatcher *shimDispatcher, shimPath string, flags []string, env []string) (*shimProcess, error) {
1378:		"-port", strconv.Itoa(listener.Port()),
1379:		"-shim-id", strconv.FormatUint(listener.ShimID(), 10),
```

The runner has a configurable `-shim-path`, but the default remains the BoringSSL build-tree `bssl_shim` location and each test invocation still adds runner-owned `-port` / `-shim-id` arguments to the shim process. A ztls integration therefore still needs pinned runner source plus a shim that implements the current BoringSSL CLI contract; it is not just a `go test` binary dropped into `just`.

## Why the real runner path is deferred

The honest path has fixed costs that are large relative to the signal it adds before the remaining external-conformance work lands:

- A pinned BoringSSL runner source strategy, not `git clone --depth 1` from a floating branch.
- A patch or wrapper for the runner's hardcoded `bssl_shim` path.
- A real ztls shim with both endpoint roles, `-shim-writes-first`, multi-curve behavior, cert/key file plumbing through the libcrypto-backed signer path, and the CLI surface the runner expects.
- BoGo-name skip accounting with GitHub issue references, not copied TLS-Anvil names and not pi TODOs.
- Strict provenance and report gating equivalent to the TLS-Anvil report path: no partial-output acceptance evidence.
- A manual/scheduled workflow outside PR `just ci`.

The prior blocker around PEM/PKCS#8 key loading has been reduced by the libcrypto signer path; the remaining runner, fork, shim, and workflow maintenance cost has not. TLS-Anvil and tlsfuzzer carry the higher-value conformance work first: the now-closed TLS-Anvil client execution (#48), now-closed both-endpoint TLS-Anvil accounting (#49), and the existing tlsfuzzer lockstep gate. BoGo's unique value becomes more compelling after BoringSSL-specific compatibility becomes a product target or TLS-Anvil/tlsfuzzer stop being the main external-runner signal.

## Re-open criteria

Lift this deferral and implement the vendored-runner path when any one of these is true:

- A BoringSSL backend becomes an actual `crypto-backend` target in `PROVIDER_INTERFACE.md`, with a matching `flake.nix` derivation or pinned dependency path.
- A BoGo-specific failure class is found against another TLS stack and cannot be reproduced through TLS-Anvil or tlsfuzzer; the issue must cite the upstream BoGo test or peer reproduction.
- A downstream user or reviewer asks for BoGo specifically for cross-implementation coverage, FIPS/regulatory review, or BoringSSL compatibility.
- TLS-Anvil client and both-endpoint coverage reach strict normalized evidence, leaving BoGo as second-source breadth rather than the first missing external-runner lane.

## Future acceptance bar

A future BoGo implementation is acceptable only if it includes all of this:

- Pinned BoringSSL runner source or fork, with the selected revision recorded in the repo.
- A real dual-role ztls shim, not the removed server-only stub.
- Feature-justified skip list whose reasons cite GitHub issues such as #1, #2, #3, #4, and #6.
- Parser/report tests proving unexpected pass/fail/skip and partial output cannot exit cleanly.
- Manual/scheduled GitHub workflow artifacts: summary, normalized report, run metadata, command log, stdout/stderr, and runner logs.
- No PR `just ci` gating until runtime and flake dependency cost are proven acceptable.

Until those conditions are worth paying for, BoGo stays explicitly deferred rather than half-wired.
