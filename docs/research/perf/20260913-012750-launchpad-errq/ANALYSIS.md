# #88 acceptance measurement: unconditional ERR_set_mark/ERR_pop_to_mark record-path cost

LOCAL within-host acceptance measurement on `launchpad` (aarch64 Neoverse-V3, 4-core
shared dev box). NOT an EC2 production comparison. Scope: existing ztls-only
`RecordEncrypt`/`RecordDecrypt` rows, {TLS_AES_128_GCM_SHA256,
TLS_CHACHA20_POLY1305_SHA256} x {16, 1350, 16384} bytes. No other rows; no
cross-implementation numbers. Row class: ztls-only (record framing + AEAD via
libcrypto EVP); the AEAD primitive work itself is backend(libcrypto)-bound.

- baseline = ba4a10f67045b829a8f18be7ae716c7dcb61bfb0 (no err-queue guard)
- candidate = da799269498a02a4befc25da90ba01865070cf78 (#88 fix: unified
  unconditional `errqEnter`/`errqExit` = `ERR_set_mark`/`ERR_pop_to_mark` on
  every outermost backend wrapper, including per-record `aeadEncrypt`/`aeadDecrypt`)
- same host, same devshell, libcrypto OpenSSL 3.6.4 (sha256 in metadata.txt),
  zig 0.15.2, `-Doptimize=ReleaseFast`, cpu=apple_m1, both binaries pinned
  `taskset -c 3`, ABBA-alternated. See metadata.txt and run.sh for commands.

## Timed-work equivalence

Both binaries run the identical harness (`src/bench/record_protection.zig`,
unchanged between revisions): per iteration one `RecordLayer.encrypt`
(header write + content memcpy + nonce XOR + one AEAD seal) or one
`RecordLayer.decrypt` (header parse + nonce XOR + one AEAD open + inner
content-type scan). The only record-path code delta is the guard pair
(verified in disasm-*.txt: candidate adds `bl ERR_set_mark@plt` on entry and
`bl ERR_pop_to_mark@plt` on success + error exits of
`RecordLayer.encryptPrepared`/`RecordLayer.decrypt`; +1 callee-saved x25,
frame 0x60 -> 0x70; EVP call sequence otherwise identical).

## Results (30 wall samples/row/binary; instruction counts are exact)

Wall ns/op, median of 30 (candidate - baseline):

| row | base | cand | d ns | d % |
| --- | --- | --- | --- | --- |
| RecordEncrypt/AES128/16 | 97.19 | 118.05 | +20.9 | +21.5% |
| RecordEncrypt/AES128/1350 | 269.60 | 288.75 | +19.2 | +7.1% |
| RecordEncrypt/AES128/16384 | 2100.5 | 2118.0 | +17.5 | +0.8% |
| RecordEncrypt/ChaCha/16 | 294.85 | 313.45 | +18.6 | +6.3% |
| RecordEncrypt/ChaCha/1350 | 1106.0 | 1128.5 | +22.5 | +2.0% |
| RecordEncrypt/ChaCha/16384 | 9060.5 | 9084.0 | +23.5 | +0.3% |
| RecordDecrypt/AES128/16 | 109.65 | 130.20 | +20.6 | +18.7% |
| RecordDecrypt/AES128/1350 | 266.75 | 289.70 | +23.0 | +8.6% |
| RecordDecrypt/AES128/16384 | 2170.0 | 2207.0 | +37.0 | +1.7% |
| RecordDecrypt/ChaCha/16 | 297.80 | 319.75 | +22.0 | +7.4% |
| RecordDecrypt/ChaCha/1350 | 1102.5 | 1124.0 | +21.5 | +2.0% |
| RecordDecrypt/ChaCha/16384 | 8965.0 | 9000.0 | +35.0 | +0.4% |

Instructions/op (perf stat instructions:u, fixed iterations, 3 reps agreeing
to <0.001%; decrypt corrected for the harness's 4096-record setup loop, which
itself runs guarded encrypts in the candidate: leak = 4096 x 526 / iters):

- RecordEncrypt: +526.0 instructions/record, constant across suites/sizes.
- RecordDecrypt: +523.0 instructions/record, constant across suites/sizes.
- Cycles: +60..+83 cycles/op on <=1350B rows (perf multiplexed; noisier).
  At the observed ~3.26 GHz, +70 cycles ~= +21 ns = the wall delta.
- Branch-misses delta ~0 (+-0.4/op, sign-inconsistent): the cost is straight
  dependent-load work, not mispredicts.

## Attribution (perf record, candidate, AES128/16 rows)

Direct samples in guard-attributable symbols: encrypt 8.6%, decrypt 7.4%
(ERR_set_mark 2.0/1.6%, ERR_pop_to_mark 0.9/0.5%, ossl_err_get_state_int
1.6/1.8%, CRYPTO_THREAD_get_local{,_ex} 2.6/1.4%, pthread_getspecific 1.4/1.9%,
PLT stubs 0.2/0.3%). `OPENSSL_init_crypto` (3.25%) is shared with EVP paths
and only partly guard-attributable. The guard cost is two per-record
thread-local err-state lookups + mark/pop entry-flag work.

## Conclusion (measurement, scope-limited)

The unified unconditional guard costs a fixed ~525 retired instructions /
~70 cycles / ~18-23 ns per record, independent of suite and payload size.
Relative impact: up to +21% on the smallest AES-128-GCM row (97 ns baseline),
+7-9% on 16-byte ChaCha / 1350-byte AES rows, <=2% at 1350 ChaCha and 16 KiB.
Whether ~20 ns/record needs a cheaper equally-correct design (e.g. lazy
queue-empty check, or guard only on failure paths) is the parent's call; the
cost is quantified, constant, and instruction-explained.

## Validity notes

- First wall-time attempt (2026-09-12 18:30-18:33 PDT) ran concurrently with
  another session's TLS-Anvil campaign; those samples are quarantined under
  invalid-contaminated/ and excluded. Valid run started 18:38:33 PDT after
  the campaign was terminated and the box verified quiet (no java/anvil_client,
  load 0.45-1.29 ambient).
- perf_event_paranoid=2: per-process user-space events only; no privileged
  config was changed. cache-misses and kernel events not collected.
- Shared dev box: ambient syncthing/pi processes remained; ABBA alternation +
  30 samples/row bound drift. 16 KiB rows show higher variance (sd ~20-25 ns);
  their deltas are directionally consistent but the least precise.
- This is single-host local evidence; per repo policy it is not an EC2
  production comparison and should not be cited as one.
