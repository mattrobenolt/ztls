# Resource ownership diagnosis (#121)

[PRODUCTION_READINESS.md](../../../../PRODUCTION_READINESS.md) owns project status.
These records describe ownership fixes and diagnostic controls, not final candidate qualification.
The base revision is `b0631d020e19419d7af60ddd5935dc76f3fb536b`.
The captured patches identify the changes for each diagnostic binary.

## Abort cleanup

The client allocated early traffic keys before ServerHello.
Its destructor skipped those keys in `wait_sh`.
The server allocated early receive keys after PSK admission, before key exchange completed.
Its destructor skipped those keys when key exchange rejected the peer and left the state at `wait_ch`.

The new allocation-count checks exercise both paths through public handshake APIs.
Each check compares live allocations against a warm baseline for 100 repetitions.
The client check first failed with `AllocationGrowth`.
After the client fix, the server check failed with the same error.
Both checks then passed.
The hooks count allocations, not bytes, and do not inject allocation failures.
BoringSSL lacks the required hook API.

The unit, fuzz, and interoperability helpers also omitted owned-resource cleanup.
The replay benchmark omitted handshake cleanup inside its measured loop.
Its baseline lost 4,608 direct bytes and 23,687 indirect bytes across the three cipher-suite rows.
Historical replay timings therefore describe a different cleanup boundary.
The raw baseline remains unchanged.

## Optimized-provider reports

The revised Debug and ReleaseFast unit runs each passed 849 tests and skipped one.
Both runs freed every heap allocation.
Both also reported 6,583 conditional-undefined events across 57 contexts in optimized OpenSSL 3.6.4.
The runs used Valgrind 3.27.1 on Linux aarch64.

Every reported instruction maps to one of seven branches in five provider functions:

- `OPENSSL_strlcpy`.
- `OPENSSL_strlcat`.
- `OPENSSL_strnlen`.
- `ossl_namemap_name2num`.
- `namemap_add_name`.

The disassembly shows the same sequence before each branch: byte comparisons against zero, `umaxp`, and a register transfer.
A valid NUL terminator guarantees a nonzero reduction result.
Memcheck loses that guarantee when other vector lanes contain undefined bytes after the terminator.
`metadata.json` records the instruction offsets and the common-load-base cross-check.

The standalone `vector_scan_probe.zig` reproduces this instruction sequence without OpenSSL or ztls.
It tests all sixteen terminator positions within an allocated sixteen-byte array.
All three controls detect every terminator:

| Control | Memcheck exit |
|---|---:|
| Undefined bytes after NUL, pairwise maximum | 99 |
| Initialized tail, pairwise maximum | 0 |
| Undefined tail, equivalent bitwise OR | 0 |

The public OpenSSL string probe provides another control with valid NUL-terminated strings.
Its undefined-tail run reports errors, while its initialized-tail run does not.

## Diagnostic provider

The flake exports `openssl-memcheck` from the same OpenSSL package with the additional configure flag `-fno-tree-vectorize`.
Production builds retain the normal optimized provider.
The dynamic-loader log confirms that the diagnostic run loads the intended library.

The same ReleaseFast unit binary passes all 849 tests, skips one, frees every allocation, and reports zero Memcheck errors with this provider.
The runs use no suppressions and retain undefined-value checks.
The diagnostic build does not replace optimized-provider qualification.
The classification applies to the recorded reports, not arbitrary future warnings inside these functions.

## Repeat the gate

Run `just check-memory` inside the Nix development shell on Linux.
Read the artifact directory printed by the command.

The gate runs the full ReleaseFast unit suite and all three client-handshake replay rows.
It checks the loaded provider path and rejects empty test or replay results.
Every leak category and every Memcheck error causes failure.
An optional argument names a new output directory.
The gate rejects an existing directory and retains failed reports.
The Zig 0.15 Linux CI recipe invokes this gate.
The Zig 0.16 Linux recipe uses `just check-memory-units` because the benchmark driver depends on Zig 0.15 APIs.
The initial Zig 0.16 attempt failed at that benchmark compilation boundary.

The replay output under Valgrind is ownership evidence, not performance evidence.
The records do not measure consumer pool occupancy or transport recovery.
