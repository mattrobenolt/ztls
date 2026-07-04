# Benchmark row explanation template

Use this template when writing up a benchmark row result with perf and
disassembly evidence. The goal is to tie a wall-time delta to specific
instruction/branch/cache behavior so the comparison is an explained
measurement, not just a number next to another number.

Copy this file, name it after the row and capture it explains, and fill in
every section. If a section is not applicable, say why explicitly — do not
delete it.

---

## Row and equivalence inventory

**Row name:** (e.g. `AppPingPong`)

**Cipher suite:** (e.g. `TLS_AES_128_GCM_SHA256`)

**Payload size:** (e.g. `1350` bytes, or `1` for handshake rows)

**Implementations compared:** (e.g. ztls, libssl, rustls)

**Equivalence status:** (Comparable / Usable with caveats / Diagnostic)

**Timed-work summary per implementation:**

For each implementation, list what happens inside the timed loop. Reference
the per-row timed-work inventory in `docs/research/PERFORMANCE.md` and note
any deviations from the documented inventory for this specific capture.

- ztls: ...
- libssl: ...
- rustls: ...

**Known asymmetries for this row:** (e.g. signature verification present in
ztls but not rustls; per-iteration allocation in libssl/rustls but not ztls;
warm-up present in libssl but not ztls/rustls; measurement shape difference)

## Raw timing table

Paste the `benchstat` output for this row from the capture's `benchstat.txt`.
Include the sample counts (`n=`) for each implementation.

```text
<benchstat output for this row>
```

**Capture provenance:**

- Capture directory: `docs/research/perf/<timestamp-host>/`
- Git revision: ...
- Git dirty: ...
- Host: (e.g. EC2 c7i.large, Intel Xeon 8488C)
- Kernel: ...
- Zig version: ...
- Optimization mode: ReleaseFast
- Crypto backend: (e.g. openssl 3.6.2)
- rustls version: ...
- Linked libcrypto: ...
- Linked libssl: ...
- Capture command: (e.g. `just bench-capture-default`)

## Perf summary

For each implementation, paste the `perf stat` counter summary from the
row-specific perf capture. Include cycles, instructions, branches,
branch-misses, cache-misses, and any other events collected.

Raw counter totals are not comparable until they are normalized. Record the
iteration count from each row capture's `metadata.txt` (`stat_iteration_counts`
and `record_iteration_counts`) and divide counters by operations before drawing
cross-implementation conclusions. For app-data rows, also show counters per
payload byte when that is the more useful boundary; for `AppPingPong`, remember
that each operation moves one payload in each direction.

### ztls

```text
<perf stat output>
```

### libssl

```text
<perf stat output>
```

### rustls

```text
<perf stat output>
```

**Counter normalization:**

| Implementation | stat iteration count(s) | record iteration count(s) | bytes/op for row | Normalization used |
| --- | --- | --- | --- | --- |
| ztls | ... | ... | ... | counters/op or counters/byte |
| libssl | ... | ... | ... | counters/op or counters/byte |
| rustls | ... | ... | ... | counters/op or counters/byte |

**Normalized counter comparison:**

| Metric | ztls | libssl | rustls | Delta (ztls vs libssl) | Delta (ztls vs rustls) |
| --- | --- | --- | --- | --- | --- |
| cycles/op | ... | ... | ... | ... | ... |
| instructions/op | ... | ... | ... | ... | ... |
| branches/op | ... | ... | ... | ... | ... |
| branch-misses/op | ... | ... | ... | ... | ... |
| cache-misses/op | ... | ... | ... | ... | ... |

## Hot symbols and disassembly notes

For each implementation, list the top hot symbols from `perf report` and
annotate them with disassembly observations. Reference the disassembly
artifacts committed alongside this explanation.

### ztls

Top symbols from `perf-report.txt`:

1. `...` — (e.g. `RecordLayer.encrypt` / `Aead.encrypt`)
2. `...`
3. `...`

Disassembly observations (from `binary.asm` / `libcrypto.asm`):

- ...
- ...

### libssl

Top symbols from `perf-report.txt`:

1. `...` — (e.g. `aesni_gcm_encrypt` / `EVP_EncryptUpdate`)
2. `...`
3. `...`

Disassembly observations:

- ...
- ...

### rustls

Top symbols from `perf-report.txt`:

1. `...` — (e.g. ring AES-GCM / `chacha20_poly1305::seal_in_place`)
2. `...`
3. `...`

Disassembly observations:

- ...
- ...

## Copy and allocation behavior

Document what memory operations each implementation performs inside the timed
loop. This is where the Sans-I/O / caller-owned-buffer design claim is tested.

- ztls: (e.g. zero heap allocation; all buffers stack-resident; no memcpy
  beyond the AEAD encrypt/decrypt itself; `completeWrite` is a cursor advance)
- libssl: (e.g. `SSL_write` copies into the SSL internal send buffer; BIO
  layer copies between SSL buffers and BIO memory; no per-iteration heap
  alloc for app-data rows since the `SSL` objects are reused)
- rustls: (e.g. `writer().write_all` copies into the rustls internal buffer;
  `transfer` copies through `Vec<u8>`; `process_new_packets` dispatches;
  no per-iteration heap alloc for app-data rows since `Conn` is reused)

## Conclusion

State the explained measurement: what causes the wall-time delta, tied to the
perf counters and disassembly above. If the delta cannot be fully explained,
say so and list what additional evidence is needed.

- ztls vs libssl: (e.g. ztls is faster because it avoids BIO buffering and
  `SSL_write`/`SSL_read` internal dispatch, calling `EVP_CipherUpdate`
  directly with less wrapper code. The instruction count delta is X% and the
  cache-miss delta is Y%, consistent with fewer intermediate copies.)
- ztls vs rustls: (e.g. ...)

Do not claim equivalence if the harnesses perform different amounts of work.
If the row has a known asymmetry (e.g. the `Handshake` auth-policy gap),
restate it here and explain how it affects the conclusion.

## Caveats and residual risks

List anything that weakens the explanation or limits its generality.

- Sample count: (e.g. rustls n=1 in the committed capture makes the ztls-vs-
  rustls comparison statistically meaningless until re-captured with n>=5)
- Architecture: (e.g. perf data is x86_64 sapphirerapids; do not generalize
  to aarch64 or AMD without re-capture)
- Auth-policy asymmetry: (e.g. the Handshake row has ztls doing ECDSA P-256
  verify that rustls does not; the delta includes this work)
- Measurement shape: (e.g. rustls uses aggregate batch timing while
  ztls/libssl use per-iteration timing)
- Missing perf evidence: (e.g. no perf data was available for this row; the
  conclusion is based on disassembly analysis only, not measured counters)
- Unexplained residual: (e.g. the ChaCha20-Poly1305 delta at 16 bytes is not
  fully explained by the disassembly; the per-record overhead hypothesis needs
  confirmation with a perf annotate of the specific path)
