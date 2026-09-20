# Secret lifetime and erasure

Readiness status lives in [PRODUCTION_READINESS.md](../../../PRODUCTION_READINESS.md).
This report describes the #125 source audit and its [raw captures](zeroization-20260920/).
The observations do not demonstrate secret disclosure.

## Scope and provenance

The static matrix contains six runtime-input probes for each of eight compiler and target combinations:

- Zig 0.15.2 and 0.16.0.
- aarch64 and x86_64.
- Linux and macOS.

Each probe uses `ReleaseFast` and the baseline CPU target.
The probes call these actual SHA-256 and SHA-384 HKDF helpers:

- `handshakeSecret`
- `masterSecret`
- `trafficKey`

Cross-target objects establish code generation, not execution on those targets.

The clean probe baseline is `6d73a0a12fad3f1703870138d44aff6668341f89`.
The post-change manifests identify the staged tree and source hashes.
Native captures contain the revision and source patch recorded by their memory gate.
The native baseline records `57169a1` plus the #124 fixture/test patch, before the secret-lifetime changes.

The native binaries target Linux aarch64 and use the diagnostic OpenSSL provider from the memory gate.
Those builds also use `ReleaseFast` and `-Dcpu=baseline`.
`manifest.json` identifies executable hashes and disassembly commands.
Original memory-gate files identify compiler versions and provider bindings.
Object and executable hashes identify the examined builds. The archive excludes the binaries themselves.
The analysis comes from parent execution, not an independent reviewer.

## Source boundaries

`HashArm.forgetHandshakeSecrets` clears the obsolete handshake and Finished fields.
It preserves the live application and resumption fields.
`HashArm.secureZero` clears the owned secret fields and the resumption-valid flag.
These operations do not describe every physical copy of those values.

`handshakeSecret` and `masterSecret` erase their local derived salts after extraction.
`makeRecordLayer` derives the traffic key directly into its local `Aead` storage and erases that storage.
Construction of the returned record layer still creates additional copies in the captured binaries.

The classical `sharedSecret` functions write into caller-owned output arrays.
Both handshake roles and the hybrid helper pass their existing secret buffers directly.
The functions clear their output on error. Successful callers own the later erasure.
These paths use pointers for P-384 keypair access.

Zig supplies SHA, HMAC, and HKDF under the architecture's existing crypto boundary.
The standard-library HMAC contexts and HKDF scratch do not provide comprehensive erasure.
Backend providers control the erasure of backend-owned memory.

## Derived salt versus returned value

All eight post-change `audit_handshake256` probes erase the derived salt.
All eight retain an extracted return-value copy outside that erased range.
The following locations refer to each probe's stack frame:

| Target | Compiler | Erased salt | Retained output copy |
|---|---|---|---|
| aarch64 Linux | 0.15.2 / 0.16.0 | `sp+0x20`, 32 bytes | `sp`, 32 bytes |
| aarch64 macOS | 0.15.2 / 0.16.0 | `sp+0x20`, 32 bytes | `sp`, 32 bytes |
| x86_64 Linux | 0.15.2 / 0.16.0 | `rbp-0x40`, 32 bytes | `rbp-0x60`, 32 bytes |
| x86_64 macOS | 0.15.2 / 0.16.0 | `rbp-0x60`, 32 bytes | `rbp-0x38`, 32 bytes |

The aarch64 0.16.0 probes also copy the input early secret to `sp+0x150` without a corresponding wipe.
The raw matrix also contains the SHA-384, master-secret, and traffic-key probes.
Symbol tables identify exported functions where Mach-O disassembly uses a local alias such as `ltmp0`.

## Why a named wipe was insufficient

The rejected error-union experiment retained the original X25519 return payload at `sp+0x70e` in the native 0.15.2 client.
Its deferred wipe targeted a different local slot at `sp+0x6e0`.
Pointer capture of the success payload did not remove that separate return slot.
The archive preserves the source patch and disassembly under `rejected-result-slot-wipe/`.

The rejected `Aead` experiment erased a local slot without erasing the original traffic-key output.
The archive preserves that version under `rejected-aead-local-wipe/`.
Direct derivation into the local union makes the output storage and wipe coincide.
The native post-change constructors erase the local key at `sp+0x2`, but retain other constructor copies.

The post-change native 0.15.2 client passes `sp+0x69c` directly to all three classical shared-secret functions.
Its later DHE cleanup erases that same buffer.
The server passes `sp+0x15b0` and later erases that buffer.
The 0.16.0 native captures preserve the corresponding caller/output traces with their own stack layouts.

These examples distinguish three separate properties:

- A source variable has a deferred wipe.
- The producing write and wipe target the same physical storage.
- Every copy of the secret disappears.

The first property does not establish the second or third.
The changes target identified storage and copies, not complete physical erasure.

## Runtime evidence

The SHA-256/SHA-384 lifecycle test checks obsolete-field erasure and preservation of live epochs.
Separate mutations remove the handshake-field wipe and the full owned-field wipe.
Both mutations fail `TestUnexpectedResult` at the corresponding field assertions.

The P-256 and P-384 malformed-point tests check that failed derivation clears the caller's output.
Each output starts with `0xa5`. Removal of its error-path wipe fails `TestUnexpectedResult`.
The X25519 rejection tests also check cleared output, but do not independently isolate the wrapper wipe from provider behavior.

The failed-Finished operation uses an undersized output buffer after server Finished verification.
It checks the retained handshake state and repeats the operation 100 times under allocation hooks.
Removal of the temporary record-layer cleanup fails `AllocationGrowth`.
An earlier cleanup-order mutation also fails, but belongs to the rejected named-wipe experiment.

The native memory logs record zero Memcheck errors for both compiler versions.
Zig 0.15.2 covers units and the three replay rows. Zig 0.16.0 covers units only.
These checks establish memory-access and allocation properties, not complete secret erasure.
The replay timings under Memcheck are not performance evidence.

## Guarantees and limits

The engine erases designated owned secret fields and buffers at their specified lifecycle boundaries.
Callers own erasure of caller-visible output and borrowed storage.
Neither contract promises erasure of:

- Compiler-generated copies.
- Registers.
- Standard-library scratch.
- Backend-internal memory.

The captures establish specific code-generation behavior for the recorded sources and toolchains.
They do not establish every production call site or future compiler behavior.
No throughput or latency claim follows from this audit.
