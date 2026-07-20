# C ABI conformance plan

The C ABI surface tracked by #30 lands `ztls_client_*`, `ztls_server_*`, and
`ztls_record_buffer_*` symbols as `extern struct` types with a fixed-size
opaque-byte region for internal state. The packaging step in #30's plan —
"build the C ABI and compile + run the C example" — produces the static
`libztls.a` archive and proves one C example can link it with a compatible
libcrypto-family library (`-lcrypto`); it does not prove the C ABI as an
external conformant boundary. This note describes how the conformance harness
extends to drive that boundary end-to-end through TLS-Anvil, what the
before-close acceptance gate looks like, and what a C harness deliberately
does not cover.

## Why the C ABI needs a C harness for conformance

The current `conformance/src/anvil_client.zig` and `tlsfuzzer_server.zig`
import `@import("ztls")` directly and use `ClientHandshake` /
`ServerHandshake` with their internal types in-place. The Zig harness goes
around the deliverable surface from #30 entirely: layout bugs in the C view
(wrong `extern struct` field offsets, wrong `callconv(.c)` argument sizes,
wrong buffer-decoration semantics, wrong flattening of the Zig `Event` union
into the `ztls_event` flat struct, wrong opaque-byte sizing for
`ztls_record_layer`'s AEAD region) would not show up in a Zig test path,
because the Zig path sees the underlying Zig type.

A layout or buffer-ownership bug that survives the Zig harness is invisible
to the existing TLS-Anvil evidence. The static archive can build, the C example
can link it with `-lcrypto` and echo a single byte, and a real conversation can
still corrupt handshake state two flights later. The smallest honest slice that
surfaces that class of bug is a TLS-Anvil trigger script driving a C harness
through the published `libztls.a`. A future dynamic-library deliverable could
instead use `libztls.so` / `libztls.dylib` without changing the evidence weight.

## Before-close acceptance gate

The acceptance gate for #30 is a strict TLS-Anvil client capture, re-run
through the C harness, against the same TLS-Anvil jar and the same
sequential settings used for the existing strict Zig capture. The reference
capture for evidence is the one cited from `PRODUCTION_READINESS.md` and
`docs/research/TLS_ANVIL_NOT_ATTEMPTED.md`: `Running: false`,
`FinishedTests: 437`, `TotalTests: 437`, six visible #52-class
`expected_failed` rows under `anvil_report.py:qualifies_dsa_root_expected_fail`,
and the `not_attempted` split fixed at `205` for the strict client-side
capture. The same gate shape applies to a strict server capture through the
C-driven server harness when the C server side lands.

The harness can be one of:

- `conformance/c_anvil_client.c` — a C-language harness that drives
  `ztls_client_init_insecure`, `ztls_client_start`, `ztls_client_handle_record` (and
  the matching `ztls_server_*` for the server direction once #30 server
  lands), with `ztls_record_buffer_next` for record framing. Driven under
  TLS-Anvil by `scripts/anvil_client.py` — only the `--trigger-script`
  binary target changes; no schema change to the runner.

- `conformance/src/c_anvil_client.zig` — a Zig driver built against the
  published `libztls.a` via `@cImport("ztls.h")`, with a compatible
  libcrypto-family library linked by the consumer. A future dynamic-library
  lane could use `libztls.so` / `libztls.dylib`. This is valid only as an
  evidence lane if it links against the published library artifact (not the
  in-tree module). This satisfies the acceptance gate without
  forcing a C toolchain into the CI matrix. A real `conformance/c_anvil_client.c`
  is still wanted as a deliverable so C consumers have a complete
  driver reference.

The capture must reproduce on three libcrypto-family backends:

- OpenSSL (`-Dcrypto-backend=openssl`, the default), the same backend the
  Zig harness capture was taken on;
- AWS-LC (`-Dcrypto-backend=aws-lc`, `check-backend-aws-lc` recipe path);
- BoringSSL (`-Dcrypto-backend=boringssl`, `.#boringssl` devshell and the
  `just/check.just:check-backend-boringssl` PKG_CONFIG path). The same
  backend-bind surfaces as a layout leak between the C ABI and one backend;
  the same backends are what ztls targets for production.

The gate thresholds, applied independently per backend:

- `Running: false`, `FinishedTests: 437`, `TotalTests: 437` — the strict
  parent report is finished, not partial. `anvil_adapter.py` continues to
  reject partial raw TLS-Anvil runs by default.
- `not_attempted` client-side split equal to `205`; `not_attempted`
  server-side equal to `157` once the server harness is exercised.
- `expected_failed` count equal to `6` (under the same `qualifies_dsa_root_expected_fail`
  test-id-suffix and DSA-root-RSA-leaf gate). Any deviation here is
  regex/classifier drift, not conformance evidence.
- `unexpected_pass`, `unexpected_fail`, `unexpected_skipped`, `errored`,
  and `timeout` all zero. A regression that shows up only on the C run is a
  C-ABI regression, not a feature regression.

Evidence-blocker checks stay enforced: `adapter_allow_partial: true` and
`report.complete != true` are recorded as blockers in `summary.json` and
exit 1 from `anvil_report.py`. `just anvil-report-dir` is the production
recipe; `--allow-partial` stays reserved for local audit, the same as for
the Zig-harness captures.

## Skip-list inheritance and the no-new-skips rule

The C harness inherits the existing classification surface unchanged. The
boundary language changing is not a feature change, and adding skip patterns
to absorb C-ABI-specific failures would hide exactly the regression the
harness exists to surface.

`expected_skipped` carries forward the patterns in
`conformance/anvil-skip-list.json` for HelloRetryRequest, PSK/resumption,
0-RTT, RecordSizeLimit, MaxFragmentLength, DTLS, TLS 1.2, FFDHE and other
un-supported named groups, sender-restriction tests, and the TLS 1.2/DTLS
configuration-option rows. Coverage of those tests does not change whether
the trigger process is Zig or C.

The six `expected_failed` rows stay visible. The classifier in
`scripts/anvil_report.py:DSA_ROOT_EXPECTED_FAIL_IDS` and
`qualifies_dsa_root_expected_fail` is gated by exact test-id suffix and the
additional condition that every `FailureInducingCombinations` triple is a
DSA-root RSA-leaf shape (`ROOT=DSA`, `LEAF.keyType=RSA`,
`LEAF.keySize ∈ {1024, 2048, 4096}`). The C harness capture must reproduce
the same six rows under the same classifier; a regression that surfaces
as `unexpected_fail` in the C run while the Zig run shows `expected_failed`
is C-ABI evidence, not feature evidence. The classifier's gating is narrow
on purpose: it must not absorb unrelated `FULLY_FAILED`/`PARTIALLY_FAILED`
tests into `expected_failed`, and a `FailureInducingCombinations` entry
under a different root key or leaf key type returns the test to
`unexpected_fail`. Doing otherwise would hide the very regression a
non-Zig harness exists to find.

`not_attempted` rows stay `not_attempted` for the C harness run exactly as
classified in `docs/research/TLS_ANVIL_NOT_ATTEMPTED.md`: 157 server-side
and 205 client-side endpoint-mode rows from TLS-Anvil's own
`disabled_reason == "TestEndpointMode doesn't match"` annotation. A C ABI
run does not create new `not_attempted` evidence without a different
protocol-version or direction range; the adapter remains strict and exits 1
on a partial capture. `docs/research/TLS_ANVIL_NOT_ATTEMPTED.md`'s
guardrail — do not add a skip-list pattern that absorbs endpoint-mode
mismatches — applies unchanged.

The lint-markdown and lint-rules pipeline already rejects
reason-overbroad patterns: `just lint-markdown` blocks
`docs/research/` files that carry status-language drift, and the
`scripts/anvil_report.py` classifier gates on result+combination shape.
A new pattern that intends to absorb `FULLY_FAILED`/`PARTIALLY_FAILED` on
a C ABI row would either be filtered by these gates or visibly fail them.

## New surface that #30 introduces

The C ABI exposes a derived view of the existing client/server types, but
the act of exposing it changes the conformance surface in four places the
Zig harness does not test:

**Handshake round-trip through C-owned buffers.** A TLS 1.3 handshake
driven end-to-end by `ztls_client_init_insecure` → `ztls_client_start` →
`ztls_client_handle_record` (with `ztls_record_buffer_next` for record
framing), in both client and server directions, against a real libcrypto-
backed server (openssl `s_server`, AWS-LC `s_client`/`s_server`, BoringSSL
`bssl s_server`). The C-side mutable record buffer contract and the
`ztls_event` flat struct replacement for the Zig `Event` tagged union
must produce the same byte sequence the Zig harness produces. A
`ztls_event.type` misencoding (forgetting that `.application_data` and
`.closed` map to different `ztls_event_type` values, or that `.key_update`
flattens to `ZTLS_EVENT_WRITE`) shows up here.

**Alert emission and detection through the C exit path.**
`ztls_client_send_alert(description, out)` from a `ZTLS_ERR_*` path, and
`ztls_client_handle_record` returning `ZTLS_ERR_PEER_ALERT` for peer
alerts, must encode the alert description byte exactly as the Zig
`alert.Description` enum encodes it. The Zig reference is the
`sendAlertAndReturnError` shape in `conformance/src/anvil_client.zig`. A
C harness that drops the description byte or mistranslates the
fatal/non-fatal `level` byte is a hidden compliance regression.

**KeyUpdate via C events.** Peer-initiated KeyUpdate returns `ZTLS_EVENT_WRITE`
through the flattened struct, with the response buffer carrying the
sequence-number bump under the new epoch. The Zig path returns
`.key_update => |ku|` and reads `ku.response` directly; the C ABI must
flatten that to `ztls_event.data`/`data_len` without losing the response
slice or the implicit epoch transition. Round-trip equivalence through
that flattening is a new conformance row the Zig harness does not check.

**PSK / 0-RTT scope extends only if it lands.** #30 marks resumption/PSK
and 0-RTT as out of scope, so PSK and 0-RTT inherit the existing
`expected_skipped` patterns (`*SUT does not support PSK handshakes*`,
`*Server does not issue Session Tickets*`, `*0Rtt*`, the server-side
EarlyData row, `*PSKModeExtension is not supported*`). If PSK or 0-RTT
ships post-#30 through additional `ztls_*` verbs or an extended
header, the conformance surface picks up additional skip-list removals,
not additional skips. A C-ABI-specific failure on those rows stays
`unexpected_fail` until the underlying feature and the C ABI verb both
land and a strict capture is re-run.

## What a C harness does not prove

A C harness built with GCC on Linux, written against the public
`include/ztls.h`, with explicit `extern struct` alignment and no
aliasing surprises, proves the C ABI as seen by GCC-on-Linux. It does
not consider:

**Python ctypes / cffi consumption.** `ctypes` reads the layout via its
own ABI derivation (`sizeof`, `Structure._fields_`) and does not honor
`extern struct` semantics the way C does; `cffi` requires its own ABI
mode and re-aligns fields per its own conventions. A small Python smoke
that catches layout offsets via `sizeof` is one afternoon of work and a
follow-up, not the posted gate.

**Ruby FFI.** Ruby FFI has its own alignment and platform shim, and the
combination of `extern struct` and Ruby's variadic pointer handling
surfaces constraints GCC does not.

**Rust `bindgen`.** `bindgen` generates Rust struct definitions from a C
header and has its own opinions about layout, alignment, zero-length
arrays, and anonymous unions. A bindgen-derived smoke is a future
follow-up.

**Windows / MSVC ABI differences.** ztls targets Linux and macOS only.
The cross-compiler matrix is intentionally narrow; a Windows consumer of
the C ABI is a separate product target.

The acceptance gate is "GCC-on-Linux and `clang`-on-macOS at the same
ABI shape TLS-Anvil drives on the Zig harness, against a libcrypto-
family backend, with the strict run adapter accepting the parent report."
That is a real signal for the C ABI as a contract. It is not a claim
that every consumer of every FFI is exercised — claim it as that, and
the residual gap gets silently treated as covered. Flag the FFI
residual in the same comment that closes #30, so the FFI consumers are
on the map and the bid to GSoC-style "interop with everything" is not
made on this evidence.

## BoGo deferral: re-evaluation trigger note

`docs/research/BOGO_DEFERRED.md` lists four re-open criteria for the
BoringSSL BoGo runner integration. The first — "BoringSSL becomes an
actual `crypto-backend` target in `PROVIDER_INTERFACE.md`, with a
matching `flake.nix` derivation or pinned dependency path" — has been
met:

- `zig build -Dcrypto-backend=boringssl` produces a ztls binary;
  `just/check.just:check-backend-boringssl` covers the AWS-LC and
  BoringSSL parity path, including the conformance subproject build and
  the local pytest tlsfuzzer smoke.
- the devshell `.#boringssl` exposes `ZTLS_BORINGSSL_PKG_CONFIG_PATH`
  to the test/build/bench/example pipeline.
- a strict TLS-Anvil client capture on BoringSSL provider reproduces
  the same `157`/`205` endpoint-mode `not_attempted` split as the
  OpenSSL and AWS-LC strict captures.

A BoGo re-evaluation decision belongs in its own GitHub issue, separate
from #30 close. The C harness re-running the strict capture against
BoringSSL is a smaller, more direct signal: a layout bug or
backend-binding regression through the C ABI is observable on the same
BoringSSL libcrypto the Zig harness already exercises. Re-vendoring the
BoringSSL Go runner is a much larger slice than re-running the existing
TLS-Anvil captures through a C harness. File the BoGo re-decision as a
follow-up that references `docs/research/BOGO_DEFERRED.md`'s re-entry
list and the evidence from the C-harness acceptance gate, then decide
there whether the runner cost has paid off.

## Files this plan touches

- `docs/research/C_ABI_CONFORMANCE.md` — this document (new).
- `docs/research/README.md` — link the new document from the conformance
  suite scope section so the index matches the filesystem
  (`just/check.just:lint-readme-index`).
- `conformance/c_anvil_client.c` — proposed C harness (new). The new
  client-binary target for `scripts/anvil_client.py`'s `--trigger-script`
  argument; identical envelope to the existing Zig harness.
- `conformance/build.zig` — extension point for emitting the C harness
  binary on `just conformance/build`. Shape mirrors the Zig harnesses.
- `examples/c_client.c` — minimal bidirectional C example from #30
  step 4. The conformance harness can reference this or duplicate its
  surface deliberately; the goal is the strict client capture, not a
  new example surface.
- `include/ztls.h`, `src/capi.zig`, the `capi` build option in the
  root `build.zig` — the surface itself; #30 owns these. This plan
  defines how conformance flows through them once they exist; it does
  not change them.
- `conformance/anvil-skip-list.json` — unchanged unless a new pattern is
  justified by an unrelated feature or protocol-version change. The C
  ABI acceptance gate reuses the existing patterns as-is.

## Acceptance contract, restated for the issue comment

The before-close acceptance gate for #30 is:

1. `conformance/c_anvil_client.c` (or the Zig-vs-C-ABI alternative) drives
   a TLS 1.3 client handshake through the published `libztls.a`, linked by the
   consumer with a compatible libcrypto-family library, for every TLS-Anvil
   client case the existing strict client capture exercises.
2. The resulting `report.normalized.json` matches the existing strict
   Zig capture on every count bucket: `passed`, `expected_failed == 6`,
   `not_attempted == 205`, `unexpected_pass`/`unexpected_fail`/
   `unexpected_skipped`/`errored`/`timeout` all zero.
3. `Running: false`, `FinishedTests == 437`, `TotalTests == 437`. The
   adapter and report remain strict (no `--allow-partial`); a partial
   capture is an evidence blocker, not conformance evidence.
4. The capture reproduces on OpenSSL, AWS-LC, and BoringSSL backends
   against the same `not_attempted` split per backend.
5. The FFI-residual gap (Python ctypes, Ruby FFI, Rust bindgen, MSVC)
   stays flagged in the closing comment and is not claimed as covered.
6. The BoGo re-decision follows in a separate GitHub issue rather
   than inline with #30 close.
