# Candidate and resource capture: 2026-09-20

Project status lives in [PRODUCTION_READINESS.md](../../../../PRODUCTION_READINESS.md).
This archive records the inputs, results, controls, and limits for one candidate.

## Immutable inputs

- ztls: `8814f1e55642a7ce73841779ca0b25e530d31ef8`.
- Package hash: `ztls-0.0.0-SHHDXrSfIgAt79mZaiELvsf6SMaWI9Z-UxL0eTwGV85r`.
- handoff: `bc3567bd94695084cd30ec12226e28256a740732`.
- z53: `4f63930672a3af9cec53c8588007ec566886847d`.
- Resource host: launchpad, Linux aarch64, kernel 7.2.3.
- Consumer compiler: Zig 0.16.0.

handoff uses AWS-LC 5.5.0. Its pkg-config compatibility version is `1.1.1`.
z53 uses OpenSSL 3.6.4.
The diagnostic memory profile substitutes the documented OpenSSL build without C vectorization.
Production keeps the normal provider.

## Compatibility and controls

`upgrade-consumers-8814` replaces the original consumer dependency pins with the candidate.
The original handoff revision is `557ba42de1e4aa3f16e3cff0c7ed6bb885fddebd`.
The original z53 revision is `499c41abab505d72d9611f5fbb3cebfc91d90058`.
That gate returns green with a full classification.
It passes 63 handoff tests, four handoff builds, four portable z53 tests, and 99 native z53 tests with one skip.

`consumers-locked-final` checks the updated immutable consumer revisions.
It passes 66 handoff tests, four handoff builds, four portable z53 tests, and 100 native z53 tests with one skip.
The manifest retains its partial classification because both consumers already pin the candidate.
This is pin revalidation, not independent evidence of a pin change.
The separate upgrade capture supplies that evidence.

The broken-import control fails both consumers at the deliberate ztls compiler error.
`negative-import-8814-final` contains the handoff control and an earlier z53 control at `25da337b`.
`z53-negative-import-final` repeats the z53 control at the final revision.
`z53-negative-hostname-final` fails exactly two authentication tests at the final revision.
The source mutations are under `controls/`.
No mutation reaches a release branch.

## Ownership of private records

handoff is private. Its source and raw traces remain in its owning repository.
The immutable archive is [planetscale/handoff at 4e97999](https://github.com/planetscale/handoff/tree/4e9799904b0e96f42e9aeae452733fadc88cc6c6/docs/qualification/20260920-8814f1e).
That evidence branch is separate from the qualified source branch.

The three combined-consumer `summary.json` files are derived records, not raw manifests.
They omit private source locations and commit subjects.
They retain commands, revisions, dependency pins, toolchains, outcomes, and the original manifest hashes.
The private archive contains the full manifests and handoff command logs.
Public z53 command logs remain alongside the summaries.
`handoff-summary/summary.json` binds the private archive and its individual files by hash.
No private source or private traceback appears in this public archive.

## Bounded handoff checks

Eight phases cover the selected one-worker, 32-slot profile:

- Byte-exact TLS echoes and 130 connections at concurrency 16.
- Twenty KeyUpdates and byte-exact replies.
- PostgreSQL STARTTLS and PROXY v2.
- Client and backend half-close behavior.
- Thirty-two incomplete handshakes, overflow refusal, reset/EOF cleanup, and authenticated reconnect.
- Wrong-hostname rejection.
- Owned-backend restart and recovery.
- Actual five-minute certificate rotation, replacement-certificate authentication, and continued traffic on the existing connection.

The raw OpenSSL KeyUpdate and half-close clients do not authenticate the peer.
Python TLS clients verify the certificate and hostname.
The proxy holds 74 descriptors at the full 32-slot boundary.
After every phase, proxy/backend counts return to 10/4.
The maximum final proxy sample is 9,812 KiB, below the predefined 65,536 KiB bound.

The pool regression checks four high-water reuse cycles without further pool allocation.
Removal of either pool-return operation fails the intended assertion.
Two certificate reload regressions fail before their fixes.
The private archive preserves both red tests and the runtime rotation capture.

The first runtime attempt sampled a transient readiness descriptor as its baseline.
The revised sampler waits for the selected quiescent counts.
Its first-snapshot mutation fails. The failed original capture remains private and unchanged.

## Memory classification

The final handoff proxy executable passes 62 assertions under Memcheck.
It allocates 815,838 bytes across 7,818 allocations and retains 1,232 reachable bytes in five AWS-LC blocks.
It reports no definitely, indirectly, or possibly lost bytes.
Its all-leak-kinds command exits 99 with five reachability contexts and no suppressions.
Eight `close(-1)` warnings remain in its raw log.
The backend executable passes four tests with zero errors and zero live bytes.

`aws-lc-thread-cache/` contains independently authored provider probes.
One call and 512 calls on the main thread retain the same five blocks.
Their sizes are 24, 64, 344, 400, and 400 bytes.
A joined worker that makes 512 calls frees every allocation and reports zero errors.
The allocation stacks identify fixed thread, error-queue, entropy, and RNG state.
This classification applies to those stacks and counts, not arbitrary reachable memory.

The final z53 memory capture uses clean source at `4f63930672a3af9cec53c8588007ec566886847d`.
Four authenticated reset/reconnect cycles preserve the descriptor baseline and return TLS and transaction ownership to their expected states.
The test reports zero runtime allocator growth.
Memcheck records 13,629 allocations and 13,629 frees, with zero errors and zero live bytes.
Only three inherited descriptors remain at exit. No suppressions apply.

The ownership-removal mutation fails with `TlsOwnershipNotReleased`.
A retained-descriptor mutation fails with `expected 9, found 10`.
Earlier diagnostic and mutation logs remain under `z53-regressions/`.
Their source revisions do not replace the final capture metadata.

## CI and limits

Candidate CI `35504413278` passes both Zig lanes and the platform/provider jobs.
The handoff source passes all four jobs in `35508762043`.
z53 source CI `35509559619` passes Linux aarch64, Linux x86_64, and macOS aarch64.
The public workflow metadata and downloaded-log hashes are under `ci/`.
The downloaded logs remain outside Git.
The handoff workflow record remains in the private archive.

These are bounded functional and diagnostic checks, not performance measurements or proof of indefinite stability.
Memory instrumentation uses baseline CPU code to avoid unsupported SVE instructions in Valgrind.
The selected consumers use only their recorded provider profiles.
Other provider/platform combinations lack these complete operational and memory captures.
z53 does not expose in-process certificate rotation in this profile.
Kafka and the C ABI are outside this qualification.
No live service changed. No minimum-duration gate applies.

`SHA256SUMS` binds every other file in this archive.
