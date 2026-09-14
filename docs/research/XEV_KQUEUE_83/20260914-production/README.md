# Kqueue cancellation acceptance (#83)

Project status lives in
[PRODUCTION_READINESS.md](../../../../PRODUCTION_READINESS.md).
This directory preserves the macOS evidence for the libxev update and the
kqueue cancellation gates.

`SHA256SUMS` covers five losslessly compressed job logs. Each decompressed file
matched its original download byte-for-byte after archive creation.

## Dependency

The ztls-xev dependency moves from libxev
`9ce8e8e6ff89e583258a7f8e7adeeeaeae8611bf` to
`7497c85dfc3ae5141308944f2cd47c836772c300`.
The new revision is the exact head of
[mitchellh/libxev#224](https://github.com/mitchellh/libxev/pull/224).
Its Zig package hash is
`libxev-0.0.0-86vtc6BWFAAs_tGsasNfjQsxSsElhddIUnqVwGhwdnsu`.

The dependency revision contains three code changes:

- It flushes callback-staged `EV_DELETE` changes before `tick(0)` returns.
- It sets `.adding` before a completion-queue rearm.
- It clears `c.next` before a kevent result enters the completion queue.

The first change fixes the ztls cancellation tests. The other changes are part
of the pinned revision, but they are not load-bearing for those tests.
The upstream revision adds ten kqueue regression tests.
On Linux with Zig 0.16.0, its suite reports 146 passes and three platform skips.

## Write-test mutation

The diagnostic branch is
[mattrobenolt/ztls#97](https://github.com/mattrobenolt/ztls/pull/97).
Its candidate modifies only the checkout-local pinned kqueue source:

```diff
-if (wait == 0) break;
+if (wait == 0 and changes == 0) break;
```

Run `34819771384` tests branch revision `8d2d389`. It enables the abortive-read
and both write tests with that one hunk. All three tests execute and pass.

Run `34818559733` tests mutation revision `380203d`. It removes the hunk while
all three tests remain enabled. The abortive-read test returns `LoopStalled`.
The abortive-write test then panics on an integer overflow in `Loop.active`.
That panic prevents the orderly-write test from execution.

Run `34819179101` tests mutation revision `315d76f`. It skips the two earlier
failures and enables only the orderly-write test on kqueue. That test panics on
the same integer overflow.

The mutation results establish that both write tests depend on the deletion
flush. The integer-overflow result is consistent with an active-count underflow.
The runner reports only the panic address, so it does not prove the source line.

## Production pin

Run `34820944089` tests ztls revision `ac61b53` with the full upstream revision.
The macOS integration suite executes all four cancellation variants:

```text
PASS: close: closeReset with a read in flight cancels it, then closes
PASS: close: orderly close with a read in flight still sends close_notify
PASS: close: closeReset with a write in flight cancels it, then closes
PASS: close: orderly close with a write in flight abandons close_notify
```

The complete ztls-xev suite reports nine passes and zero skips.
The main CI gate retains this coverage on `macos-15` with Zig 0.16.

## Pure-libxev probes

Run `34822029923` adds the existing `probe-cancel` build step temporarily.
The integration suite passes before the probes start.

The single-connection control reports all callbacks, peer EOF, and `active=0`.
The earlier `two_conn_cancel` EBADF reproduction also completes:

```text
steps={ .a_cancel, .a_read, .a_close, .b_read, .b_close }
active=0 spins=4 a_err=error.Canceled b_err=error.EOF
```

The combined step then enters `stuck_write_cancel` and prints
`kqueue/cancel    :`. It emits no later probe event. The CI operator canceled the runner
after 30 minutes.

The stuck-write probe socket lacks `O_NONBLOCK`, and the probe calls
`loop.run(.no_wait)`. Its outer spin count does not bound that loop call. Therefore, this run provides
no kqueue write-cancel result from that probe. The temporary workflow step was
removed. The integration write tests provide the accepted wrapper evidence.
