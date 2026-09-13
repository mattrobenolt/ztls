# Error-queue capture audit and acceptance — #88

This addendum corrects the interpretation of
`../20260913-012750-launchpad-errq/` without rewriting its outputs.
The capture compares `ba4a10f` with `da79926`: identical record benchmark
harnesses, OpenSSL 3.6.4, Zig 0.15.2 ReleaseFast, and the recorded
`cpu=apple_m1` target on the Linux aarch64 Neoverse-V3 host `launchpad`.
These are local, ztls-only microbenchmarks, not an EC2 production comparison
or a measurement of connection-level throughput.

## Audit corrections

- **10 of 12**, not 11 of 12, wall-time rows have approximately 17.5–23.5 ns
  added per record. The two 16 KiB decrypt rows add approximately 34–37 ns
  and are the noisiest (standard deviation about 20–25 ns).
- Wall medians use the average of the middle two of 30 samples. The largest
  relative changes are approximately 21% for 16-byte AES-GCM encryption and
  19% for decryption; 1350-byte AES-GCM adds about 7–9%. The ChaCha20-Poly1305
  1350-byte rows and the 16 KiB rows add approximately 2% or less.
- Process-wide instruction counts include setup outside the timed loop.
  To obtain the approximately **526 extra instructions/encrypt** and
  **523/decrypt**, subtract both the encrypt warmup contribution
  (`32 × 526 / iterations`) and the decrypt setup contribution
  (`4096 × 526 / iterations`). The original summary described only the latter.
  The inverse-iteration scaling of the raw offsets supports these corrections.
- Wall samples use ABBA ordering. The instruction/cycle repetitions instead
  run baseline then candidate in each pair. Instruction repetitions agree
  within 0.001%; this is not a claim of equivalent timing stability.
- Cycle deltas on rows up to 1350 bytes range approximately 55–86 per operation,
  not 60–83. Counters were multiplexed. The 16 KiB cycle deltas are noisy,
  including one negative repetition. Two 16 KiB ChaCha decrypt branch-miss
  deltas exceed the original stated bound, at approximately 0.5 and 1.1/op.
- Disassembly confirms one executed `ERR_set_mark` and one executed
  `ERR_pop_to_mark` per record. Direct guard symbols account for about
  8.6%/7.4% of candidate encrypt/decrypt samples. That accounts for roughly
  half the wall-time delta; shared initialization and call/PLT overhead are
  plausible additional contributors, not a fully itemized explanation.

The audit recomputed wall medians, all 36 instruction pairs with both setup
corrections, all 36 cycle pairs, and the text profile symbol totals. Binary
and library hashes matched the recorded provenance. No new measurements were
needed. The first attempt remains archived under `invalid-contaminated/` for
provenance only: those samples overlap a TLS-Anvil campaign and are excluded
from every accepted result.

## Design acceptance

The parent accepts this guard for #88: it cleans handled failures while
retaining cleanup on successful returns, subject to the documented backend
limits on caller entries and marks. The measured cost is explicit; this
capture does **not** establish that the cost is unavoidable or minimal.
Skipping success cleanup or changing guard granularity would need its own
correctness review and measurement. No faster alternative is claimed here.

The allocation-count check and its mutations establish retention behavior
on exercised paths, not recovery from allocator exhaustion. Project status
and the remaining embedder retest requirement live in
[PRODUCTION_READINESS.md](../../../../PRODUCTION_READINESS.md).

## Lossless packaging

The two original `perf-record-*.data` files are stored as `.data.xz` to avoid
adding approximately 37 MB of uncompressed profiling data. Decompression was
verified byte-for-byte against the original files. `archive-manifest.json`
records both original and compressed SHA-256 hashes. Use `xz -dk` on an
archive to restore the filename expected by `perf report` and the recorded
commands. All other capture files are copied without changes.
