# Kqueue deletion-flush experiment (#83)

Project status and remaining scope live in
[PRODUCTION_READINESS.md](../../../../PRODUCTION_READINESS.md).
This directory preserves one baseline and one candidate macOS CI job log.
`SHA256SUMS` covers the losslessly compressed logs; both decompressed files were
compared byte-for-byte with the original downloads.

## Provenance

Both jobs use `macos-15`, Zig 0.16.0, and `just integrations-ci`.
The common main revision is `ce434db9b29a1fc51034de66241d9ed0c2e4f6b0`.
GitHub tests synthetic merge commits; each complete job log includes its
checkout line, not merely the test output.

- Baseline: [run 34742256947](https://github.com/mattrobenolt/ztls/actions/runs/34742256947),
  job `103683823687`, branch revision
  `f3d0a0e67e1c8027a5b382be44da003453c887af`, merge checkout `5583296`.
- Candidate: [run 34742815211](https://github.com/mattrobenolt/ztls/actions/runs/34742815211),
  job `103685296932`, branch revision
  `7715eb57c9f81711ccf687eabc8cee759624773a`, merge checkout `85bd368`.
- Diagnostic branch: [PR #97](https://github.com/mattrobenolt/ztls/pull/97).
  The baseline changes one line: it enables the existing abortive-read test on
  kqueue. The candidate adds a macOS-only preparation step and patch files.
  Neither changes the test timing, assertions, callbacks, or write skips.
- libxev pin: `9ce8e8e6ff89e583258a7f8e7adeeeaeae8611bf`, package
  `libxev-0.0.0-86vtcwIRFADbH4hk-EjROXxlrKIRPQdA41XiTSytYO-F`.
  The candidate modifies only its checkout-local `src/backend/kqueue.zig`:

  ```diff
  -            if (wait == 0) break;
  +            if (wait == 0 and changes == 0) break;
  ```

  This is the deletion-flush hunk from
  [mitchellh/libxev#224](https://github.com/mitchellh/libxev/pull/224),
  inspected at `7497c85dfc3ae5141308944f2cd47c836772c300`.
  No other hunk is applied. The script verifies the pristine file hash before
  applying the patch, then prints the changed hash before the integration gate:

  - Before: `01c0c18f47f81b718f03c4d15279c88852ad148a423fa08d5b3f128cfd9db069`
  - After: `de8b5fcdec908f9e0766bb711ad26d81dce18d7deaca26d8d84740e7ada948bc`

The cache mutation is an isolated diagnostic technique, not a production
installation method. No dependency override or CI patch is adopted on main.

## Observations

The baseline's enabled abortive-read test returns `error.LoopStalled`:

```text
stalled on kqueue: srv=.{ .state = .closed, .wait = .idle, .phase = .released }
  cli=closing/idle/released active=0 events={ .read_canceled, .closed }
```

The candidate executes that same test and reports `PASS`. The orderly-read test
also passes in both logs. The two write-test `PASS` lines are empty conditional
bodies on kqueue: they are not evidence of write cancellation coverage.

## Source analysis and limits

In pinned libxev `Loop.tick`, `changes` and the deletion buffer are local.
The kevent event path stages a deletion after a `.disarm` callback, then the
unconditional `wait == 0` break discards it. A level-triggered EOF can therefore
re-fire for the retired read. Unlike the completions-queue path, the event path
unconditionally decrements `active` after `.disarm`.

The client read callback requests its thread-pool socket close. If the stale
read event is reaped before the worker closes the fd, that extra decrement can
consume the close operation's active count. At zero, the loop gate excludes
entry to the thread-pool completion migration, so the close callback remains
undelivered. This explains the observed state without a missing cancel.
The changed condition keeps the tick alive to submit its staged deletion.

The source analysis and isolated red/green experiment support attribution of
this abortive-read stall to the dropped deletion. The logs are not per-event
traces; they do not directly record each intermediate callback or worker
interleaving. One green run does not establish deterministic behavior or validate
all upstream PR hunks. The separate `two_conn_cancel` EBADF probe was not run
in this experiment, and its relationship to this stall remains unestablished.
