# Performance benchmarking plan

ztls is a no-I/O TLS 1.3 state machine, so the benchmark harness should not
invent sockets just to measure them. The useful model is the one rustls uses:
scenario benchmarks over deterministic in-memory transports, with wall-time for
local development and instruction counts later for regression detection.

## Prior art

rustls has two useful generations of benchmarking:

- `examples/internal/bench.rs` measures handshakes and bulk transfer using an
  in-memory `transfer(left, right)` loop. It reports handshake/s and MB/s, and
  separates client-side and server-side timing.
- `ci-bench` is the mature setup. It runs the same scenarios in two modes:
  wall-time and callgrind instruction counts. Wall-time is noisy but reflects
  cache/branch behavior; instruction count is stable enough for regression
  detection. Their scenarios are handshake without resumption, resumed
  handshakes, and transfer of 1 MiB, crossed with TLS version, certificate key
  type, cipher suite, and side (client/server).

BoringSSL's `bssl speed` is lower-level. It times primitive chunks (AEAD,
hashes, ECDH, signatures) over fixed durations and reports operations/sec and
MB/s. That is useful for isolating crypto backend behavior, but it misses TLS
record overhead and state-machine costs. ztls mirrors this with
`zig build bench-evp`, an OpenSSL EVP-only AEAD harness.

Go's `crypto/tls` tests and benchmarks use local in-memory pipes and recorded
reference handshakes. The important lesson for ztls is the same: keep benchmark
I/O deterministic, and separate harness overhead from TLS work.

## What ztls should measure

Start with layers that exist today:

1. **Record protection throughput**

   Measure encrypt and decrypt separately for each mandatory TLS 1.3 AEAD:

   - TLS_AES_128_GCM_SHA256
   - TLS_AES_256_GCM_SHA384
   - TLS_CHACHA20_POLY1305_SHA256

   Use realistic record sizes: 16 bytes, 128 bytes, 1350 bytes, 8192 bytes,
   and 16384 bytes. BoringSSL uses similar chunk-size sweeps because small
   records measure per-record overhead while large records measure primitive
   throughput.

2. **Parser/framing throughput**

   Measure `frame.parseHeader`, `RecordBuffer.next`, `server_hello.parse`, and
   certificate parsing separately. These are attacker-controlled input surfaces
   and hot enough to track regressions, but they should not be mixed into crypto
   throughput numbers.

3. **Client handshake replay**

   Use RFC 8448 / generated OpenSSL fixture bytes to drive `ClientHandshake`
   through a deterministic client-side handshake. This measures exactly the
   client work we own today: transcript hashing, key schedule, certificate
   parse, signature verify, Finished validation, and client Finished generation.
   Keep this row separate from full client/server benchmarks so the measurement
   boundary stays explicit.

4. **Full in-memory connection**

   Use rustls-style no-I/O scenarios over in-memory client/server state machines:
   full authenticated handshake, client-to-server application data,
   server-to-client application data, and ping/pong small-record loops.
   Keep OpenSSL/libssl memory-BIO and rustls rows in separate harnesses so each
   comparison names its measurement boundary.

## Equivalence methodology

Benchmark rows are only comparable when the row names describe the same TLS
work, not just when `benchstat` can place them in adjacent columns. The analysis
script normalizes ztls, libssl, rustls, and EVP output into labeled tables:
comparable TLS rows, crypto-floor rows, and ztls-only diagnostics. This section
defines which normalized rows are legitimate apples-to-apples comparisons.

A comparable row must have the same protocol phase, the same cipher suite, the
same payload size when payload exists, and no kernel I/O in the timed path. The
transport model differs by implementation — caller-owned buffers for ztls,
memory BIOs for libssl, and in-memory `Vec<u8>` transfer buffers for rustls —
but every comparable row measures TLS work over deterministic memory transport,
not sockets.

| Row group | ztls row | libssl memory-BIO row | rustls row | Comparison status |
| --- | --- | --- | --- | --- |
| Full handshake | `Handshake` | `Handshake` | `rustls_handshake` | **Non-equivalent across implementations; reported separately from comparable TLS rows.** Full TLS 1.3 handshake, no resumption, X25519, server-only EC P-256 certificate, in-memory transport, but the auth work differs: ztls skips chain-anchor trust verification (`insecure_no_chain_anchor = true`) while still performing CertificateVerify signature verification, hostname verification for `ztls.server.test`, and leaf policy checks; rustls `NoVerifier` skips chain policy and `verify_tls13_signature`; libssl `SSL_VERIFY_NONE` skips trust-store validation and hostname checking, and its CertificateVerify behavior is partly opaque. `bench-analyze` emits this row in a non-equivalent handshake section; do not use it for apples-to-apples claims. |
| ClientHello construction | `HandshakeClientStart` | — | `rustls_handshake_client_start` | Diagnostic until audited. libssl does not expose this split below `SSL_do_handshake`, and ztls/rustls key-generation boundaries must be proven before comparison. |
| Server accepts ClientHello | `HandshakeServerAccept` | — | `rustls_handshake_server_accept` | Diagnostic until audited. Both names refer to the ClientHello consumption point, but the exact timed construction/processing boundary still needs proof. |
| Client processes ServerHello | `HandshakeClientServerHello` | — | — | ztls-only profiling row. rustls processes more of the encrypted server flight in the next client step, so there is no honest rustls peer. |
| Server authenticated flight | `HandshakeServerFlight` | — | `rustls_handshake_server_flight` | Diagnostic until audited. ztls includes certificate/signature/encryption work; rustls boundary must be proven before comparison. |
| Client Finished flight | `HandshakeClientFlight` | — | `rustls_handshake_client_flight` | Diagnostic until audited. Both consume the encrypted server flight and emit client Finished, but certificate policy and verification work differ. |
| Server verifies client Finished | `HandshakeServerFinished` | — | `rustls_handshake_server_finished` | Diagnostic until audited. Both complete the server side of the handshake, but libssl is opaque and rustls boundary still needs proof. |
| App data client→server | `AppClientToServer` | `AppClientToServer` | `rustls_app_client_to_server` | Comparable across all three. Each iteration writes one application payload from client to server and reads the same plaintext on the server side over memory transport. |
| App data server→client | `AppServerToClient` | `AppServerToClient` | `rustls_app_server_to_client` | Comparable across all three. Same as client→server with direction reversed. |
| App data ping-pong | `AppPingPong` | `AppPingPong` | `rustls_app_ping_pong` | Comparable across all three. One client→server payload and one server→client payload per iteration; bytes/op is doubled. |
| Prepared app data | `AppPreparedClientToServer` | — | — | ztls-only optimization row for the caller-owned prepared-send path. No cross-implementation peer. |
| Prepared record encrypt | `RecordEncryptPrepared` | — | — | ztls-only optimization row for `RecordLayer.encryptPrepared`. No cross-implementation peer. |

The application-data rows use the shared payload sizes `16`, `128`, `1350`,
`8192`, and `16384` bytes across ztls, libssl, and rustls. The suite names are
normalized as TLS 1.3 suite names in every harness: `TLS_AES_128_GCM_SHA256`,
`TLS_AES_256_GCM_SHA384`, and `TLS_CHACHA20_POLY1305_SHA256`. Session tickets
and resumption are disabled for comparison rows: ztls does not implement
resumption yet, libssl calls `SSL_CTX_set_num_tickets(server_ctx, 0)`, and
rustls sets `server.send_tls13_tickets = 0`.

## Per-row timed-work inventories

These inventories document the exact work each harness performs inside the
timed loop for the four comparable TLS row groups. They exist so that a
wall-time delta can be tied to specific work, not just to adjacent `benchstat`
columns. Where harnesses differ, the difference is called out explicitly rather
than papered over.

### `Handshake` — full TLS 1.3 handshake, no resumption

**ztls** (`benchZtlsHandshake` in `src/bench/record_protection.zig`):

- Setup outside loop: one warm-up `connectPair` call (full handshake, then
  `deinit`). Deterministic X25519 client and server keypairs are generated
  once via `deterministicClientKeypair` / `deterministicServerKeypair`. Server
  certificate DER and P-256 scalar are `embed`-loaded at comptime.
- Setup inside loop: `connectPair` constructs a fresh `ClientHandshake` and
  `ServerHandshake`, then drives the full handshake: `client.start` (ClientHello
  construction + X25519 keygen), `server.acceptClientHello` (ServerHello + key
  share processing), `server.sendPreparedAuthenticatedFlight` (server cert
  parse + ECDSA P-256 sign for CertificateVerify + record encryption of the
  server flight), `client.handleRecord` (record decrypt + cert parse +
  CertificateVerify **signature verification** against the cert public key +
  transcript hash + key schedule + client Finished MAC), `server.processClientFinished`
  (client Finished MAC verify + server key schedule promotion), then
  `pair.client.deinit()` and `pair.server.deinit()` secure-zero TLS state and
  key material before the iteration ends.
- Cert/signature/policy work: chain-anchor trust check skipped
  (`insecure_no_chain_anchor = true`); CertificateVerify ECDSA P-256 signature
  **verification** is performed; hostname verification runs against
  `ztls.server.test`; leaf policy checks still run for X.509v3 version,
  KeyUsage.digitalSignature, EKU serverAuth, and certificate signature algorithm.
- Transcript/key-schedule: full HKDF/HMAC/SHA transcript hash and key schedule,
  both client and server sides.
- Record framing: real record headers, AAD, nonce construction, AEAD
  encrypt/decrypt for the encrypted handshake flights.
- Memory transport: caller-owned stack buffers (`[4096]u8`, `[8192]u8`);
  `completeWrite()` advances the write cursor. No heap allocation in the TLS
  engine path.
- Allocation: zero ztls-owned heap allocation. `deinit` performs secure-zeroing
  of AEAD contexts, transcript state, and key material (no heap free) inside the
  timed loop.
- Ticket/resumption: disabled (ztls does not implement resumption; NewSessionTicket
  is parsed and discarded).
- ALPN/SNI: SNI hostname string is set (`ztls.server.test`) but no ALPN
  negotiation in the benchmark harness.
- Measurement shape: Go-bench-style per-iteration timing via `b.loop()`,
  producing per-iteration variance.

**libssl** (`benchHandshake` in `bench/bio.zig`):

- Setup outside loop: `makeContexts` creates `SSL_CTX` pair, sets TLS 1.3 min/max,
  cipher suite, X25519 group, `SSL_VERIFY_NONE` on both sides, `SSL_CTX_set_num_tickets(0)`,
  loads server cert/key PEM files. One warm-up `connected` call (full handshake
  + `freeConn`).
- Setup inside loop: `connected` calls `makeConn` (`SSL_new` for client and
  server, `BIO_new_bio_pair` for both directions, `SSL_set_bio`,
  `SSL_set_connect_state` / `SSL_set_accept_state`) then `doHandshake` (a
  poll loop calling `SSL_do_handshake` on each side until both report
  `SSL_is_init_finished`). After the loop body: `freeConn` (`SSL_free` on
  both).
- Cert/signature/policy work: `SSL_VERIFY_NONE` skips trust-store validation
  and hostname checking. libssl internally processes the CertificateVerify
  message as protocol; whether it verifies the signature without a trust store
  is opaque and version-dependent.
- Transcript/key-schedule: internal to libssl; opaque but includes HKDF/HMAC/SHA.
- Record framing: internal to libssl; includes record headers, AAD, nonce, AEAD.
- Memory transport: BIO memory pairs (`BIO_new_bio_pair`); `SSL_write` / `SSL_read`
  over the BIO pair. No kernel sockets.
- Allocation: `SSL_new` and `BIO_new_bio_pair` allocate heap objects per
  iteration. `SSL_free` deallocates. This is per-connection allocation overhead
  that ztls does not have.
- Ticket/resumption: disabled (`SSL_CTX_set_num_tickets(server_ctx, 0)`).
- ALPN/SNI: no SNI or ALPN is configured in the libssl memory-BIO harness.
- Measurement shape: Go-bench-style per-iteration timing via `b.loop()`.

**rustls** (`rustls_handshake` in `bench/rustls/src/main.rs`):

- Setup outside loop: `load_config` creates `ClientConfig` and `ServerConfig`
  from PEM files, `NoVerifier` as the client cert verifier,
  `server.send_tls13_tickets = 0`.
- Setup inside loop: `connected` calls `make_conn` (`ClientConnection::new` +
  `ServerConnection::new` + fresh `Vec` transfer buffers) then `transfer` (a
  loop calling `transfer_step` which does `write_tls` / `read_tls` /
  `process_new_packets` on both sides until neither is handshaking).
- Cert/signature/policy work: `NoVerifier.verify_server_cert` returns `Ok(())`;
  `NoVerifier.verify_tls13_signature` returns `Ok(())`. **No signature
  verification is performed.** rustls internally parses the certificate and
  CertificateVerify messages (parsing overhead present) but does no signature
  math.
- Transcript/key-schedule: internal to rustls; includes HKDF/HMAC/SHA via the
  configured crypto provider (ring).
- Record framing: internal to rustls; includes record headers, AAD, nonce, AEAD.
- Memory transport: `Vec<u8>` transfer buffers with `Cursor`; `write_tls` /
  `read_tls` / `process_new_packets`.
- Allocation: `ClientConnection::new` and `ServerConnection::new` allocate
  heap objects per iteration. `Vec` transfer buffers are dropped per iteration.
- Ticket/resumption: disabled (`server.send_tls13_tickets = 0`).
- ALPN/SNI: `ServerName::try_from("test.local")` is set; no ALPN in the
  benchmark.
- Measurement shape: **fundamentally different.** rustls times
  `HANDSHAKE_ITERATIONS` (256) handshakes as one aggregate wall-clock sample
  and emits the per-op average. This produces one sample with no
  per-iteration variance. The Go-bench approach (ztls/libssl) produces
  per-iteration variance. With `--samples N`, rustls emits N independent
  aggregate samples, but each sample still covers 256 internal handshakes.

**Why the `Handshake` row is not a comparable TLS row:**

1. **Signature verification:** ztls does real ECDSA P-256 verify; rustls does
   none; libssl is opaque. This is the most important work asymmetry.
2. **Hostname and leaf policy checks:** ztls verifies `ztls.server.test` and
   still runs leaf policy checks for X.509v3 version, KeyUsage.digitalSignature,
   EKU serverAuth, and certificate signature algorithm. rustls `NoVerifier` and
   libssl `SSL_VERIFY_NONE` skip this policy work.
3. **Per-iteration allocation and cleanup:** libssl and rustls allocate and free
   connection objects per iteration; ztls uses stack-resident state machines but
   does secure-zero AEAD contexts, transcript state, and key material during
   `deinit`. The row measures different amounts of allocator and cleanup work.
4. **Measurement shape:** ztls/libssl use per-iteration Go-bench timing;
   rustls uses aggregate 256-handshake batches. The statistics are not directly
   comparable until rustls `--samples` is high enough for benchstat.
5. **Cert loading:** ztls loads cert DER at comptime; libssl/rustls load PEM
   files at runtime in setup (outside the loop). This does not affect the
   timed region but affects startup cost.

### `AppClientToServer` — one record encrypt (client) + one record decrypt (server)

**ztls** (`benchZtlsAppData` with `.client_to_server`):

- Setup outside loop: one `connectPair` (full handshake) to get a connected
  client/server pair. Connection is reused across all iterations. `payload`
  is a stack array filled with `0xa5`.
- Work inside loop: `client.sendApplicationData(&payload, &wire)` (record
  framing + nonce + AAD + AEAD encrypt), `client.completeWrite()`,
  `server.receiveApplicationData(wire[0..record.len])` (record parse + AEAD
  decrypt + inner content-type check). `b.setBytes(size)`.
- Connection reuse: one pair for all iterations. No per-iteration connection
  setup.
- Allocation: zero. All buffers are stack arrays.
- Warm-up: the `connectPair` call is setup, not a warm-up write. No explicit
  warm-up write/read before the timed loop.

**libssl** (`benchApp` with `.client_to_server`):

- Setup outside loop: `makeContexts` + one `connected` pair. One warm-up
  write/read (`sslWriteAll` client, `sslReadExact` server) before the timed
  loop.
- Work inside loop: `sslWriteAll(conn.client, payload[0..size])` (may loop
  internally if `SSL_write` returns short), `sslReadExact(conn.server,
  recvbuf[0..size])` (may loop internally on short reads).
- Connection reuse: one connected `SSL` pair for all iterations.
- Allocation: no per-iteration allocation; the `SSL` objects and BIOs are
  reused.
- Transport: `SSL_write` / `SSL_read` over the BIO pair. The BIO layer copies
  bytes between the SSL internal buffers and the BIO memory buffers.

**rustls** (`bench_app` with dir=0):

- Setup outside loop: `load_config` + one `connected` pair. No explicit
  warm-up write/read before the timed loop (the first iteration is in the
  timed region).
- Work inside loop: `conn.client.writer().write_all(&payload[..size])`,
  `transfer(&mut conn)` (flushes `write_tls` and feeds `read_tls` +
  `process_new_packets` on both sides), `read_exact_app(conn.server.reader(),
  size, recv)`. `iters = max(TARGET_BYTES / size, 256)`.
- Connection reuse: one connected pair for all iterations.
- Allocation: no per-iteration allocation; `Conn` and its `Vec` buffers are
  reused.
- Measurement shape: aggregate — one wall-clock sample covering `iters`
  iterations, emitted as per-op average. With `--samples N`, N independent
  samples.

**Key asymmetries for app-data rows:**

1. **Warm-up:** libssl does one warm-up write/read; ztls and rustls do not.
   This may cause the first timed iteration to include cold-cache effects for
   ztls/rustls but not for libssl.
2. **Transport overhead:** libssl's BIO layer and `SSL_write`/`SSL_read`
  internal dispatch add wrapper overhead that ztls's direct `sendApplicationData`/
  `receiveApplicationData` API avoids. rustls's `writer().write_all` + `transfer` +
  `reader().read` + `process_new_packets` is a different wrapper shape. These
  wrappers are part of what the row measures; the delta is explainable only
  with perf/disassembly evidence.
3. **Measurement shape:** ztls/libssl use per-iteration Go-bench timing;
  rustls uses aggregate batches. The inner iteration count for rustls is
  `max(TARGET_BYTES / size, 256)`, which is large for small sizes and 256 for
  large sizes.

### `AppServerToClient` — one record encrypt (server) + one record decrypt (client)

Same structure as `AppClientToServer` with direction reversed. ztls uses
`server.sendApplicationData` + `client.handleRecord` (the server-to-client path
uses `handleRecord` rather than `receiveApplicationData` because the client
dispatches through the event union). libssl uses `sslWriteAll(conn.server, ...)` +
`sslReadExact(conn.client, ...)`. rustls uses `conn.server.writer().write_all` +
`transfer` + `read_exact_app(conn.client.reader(), ...)`. The same warm-up,
transport, and measurement-shape asymmetries apply.

### `AppPingPong` — one client→server + one server→client per iteration

**ztls** (`benchZtlsPingPong`): per iteration, `client.sendApplicationData` +
`client.completeWrite` + `server.receiveApplicationData` +
`server.sendApplicationData` + `server.completeWrite` + `client.handleRecord`.
`b.setBytes(size * 2)`. One connected pair reused. No explicit warm-up.

**libssl** (`benchApp` with `.ping_pong`): per iteration, `sslWriteAll(client)` +
`sslReadExact(server)` + `sslWriteAll(server)` + `sslReadExact(client)`. One
warm-up round before the timed loop. `b.setBytes(size * 2)`.

**rustls** (`bench_app` with dir=2): per iteration, `client.writer().write_all` +
`transfer` + `server.reader().read_exact` + `server.writer().write_all` +
`transfer` + `client.reader().read_exact`. No explicit warm-up.
`b.setBytes(size * 2)` equivalent (bytes column = `iters * size`).

The same transport and measurement-shape asymmetries apply. The `bytes/op` is
doubled for all three, so throughput columns are directly comparable if the
measurement shape caveat is accepted.

EVP rows are deliberately not TLS-to-TLS rows. `RecordEncrypt` /
`RecordDecrypt` in ztls include TLS record framing, the inner content-type byte,
AAD construction, sequence-number-to-nonce construction, and AEAD
encrypt/decrypt. EVP `Encrypt` / `Decrypt` and `BulkEncryptOnce` /
`BulkDecryptOnce` measure only the raw OpenSSL AEAD primitive boundary with a
hard-coded AAD shape. They are useful as a crypto floor for interpreting ztls
record overhead, but they must not be presented as libssl or rustls equivalents.

Parser and framing microbenchmarks are also intentionally non-comparable:
`frame.parseHeader`, `RecordBuffer.next`, `server_hello.parse`, certificate
parsing, `WireReader`, `NewSessionTicket.parse`, nonce construction, and
SIMD/memory helper rows are ztls regression signals, not external TLS library
comparisons.

When publishing numbers, include only the comparable row groups in
ztls-vs-libssl-vs-rustls tables. Put ztls-only and EVP rows in separate tables
with labels that describe their narrower boundary. Do not quote mixed geomeans;
`bench-analyze` strips benchstat geomean rows so result review stays row-level.

## Methodology

- Build benchmarks with `-Doptimize=ReleaseFast` and a native CPU target. The
  build's default is native CPU; generic AArch64 silently selects std.crypto's
  software AES/GHASH paths and is not a useful performance target.
- Print machine/build metadata with each run: target, CPU model if available,
  Zig version, optimization mode, git revision. If a benchmark says
  `cpu generic`, do not use it for OpenSSL comparisons.
- Output machine-readable rows (`csv`-ish is enough): benchmark name, bytes,
  iterations, elapsed ns, throughput/op rate.
- Warm up before measuring where branch/cache effects matter.
- Avoid claiming performance from one local run. Commit the harness first; use
  `perf`, Instruments, or callgrind to explain results after they exist.
- Prefer instruction-count regression tracking later. Wall-time in containers or
  laptops is useful for development, not for 1% claims.

## Profiling tools

The devshell includes Linux-only `perf` and `valgrind`/`callgrind_annotate`.
Use wall-time benchmark output to choose a suspicious scenario, then profile the
compiled benchmark binary rather than adding timing probes to library code.
Containerized Linux may expose only a subset of perf events; if hardware cycles
show as unsupported, use callgrind for instruction counts or rerun on bare
metal.

Typical local development flow:

```sh
just bench --filter RecordEncrypt/TLS_AES_128_GCM_SHA256/1350
just bench-disasm
just bench-disasm-libcrypto
just bench-perf --filter record_encrypt --filter aes_128
perf report --input zig-out/benchmark.perf.data
```

Full comparison captures are a separate workflow:

```sh
just bench-capture-default
```

Each capture writes one run directory under `zig-out/perf/<timestamp>/` with
`metadata.txt`, `ztls.txt`, `evp.txt`, `libssl.txt`, and `rustls.txt`. This shape
is intended for remote benchmark hosts: rsync the run directory back, then run
`just bench-analyze zig-out/perf/<timestamp>` to compare the captured files with
`benchstat`. `bench-capture` maps `--count=N` to rustls `--samples=N` so rustls
emits independent outer samples; the analyzer excludes rustls groups with fewer
than two samples instead of producing fake `n=1` comparisons.

Committed capture evidence lives under `docs/research/perf/`. The historical
first EC2 result set is `docs/research/perf/20260613-182405-ec2-c7i-large/`.
The #11 remote-runner evidence is
`docs/research/perf/20260705-183821-ec2-c7i-large/` and
`docs/research/perf/20260705-194022-ec2-c7i-2xlarge/`, captured on clean EC2
hosts with raw ztls/EVP/libssl/rustls outputs, full metadata, and benchstat
analysis committed together. The first #31 row-level perf/disassembly evidence
is `docs/research/perf/20260705-215953-ec2-c7i-2xlarge-row-perf/`, captured on a
clean pinned `c7i.2xlarge` host for selected AES-GCM and ChaCha20-Poly1305
application-data rows. The non-equivalent full-handshake row has separate
transparency evidence in
`docs/research/perf/20260706-000535-ec2-c7i-2xlarge-handshake-row-perf/`.

All benchmark binaries accept fuzzy `--filter` plus structured filters:
`--bench <name>`, `--suite <substring>`, and `--size <bytes>`. `--bench` is an
exact row-name match; suite remains substring-based for convenience. Use the
structured filters for perf/disassembly work so one profile means one scenario,
not a whole family of rows.

The `record_encrypt_prepared` and `ztls_app_prepared_client_to_server` rows use
`RecordLayer.encryptPrepared` / `sendPreparedApplicationData`, where the caller
has already serialized plaintext into `out[5..]`. These rows measure the
copy-avoiding send path separately from the normal slice-to-record API.

The raw Zig build steps remain available when you want to bypass `just`:

```sh
zig build bench
zig build bench-bin
perf record --call-graph dwarf ./zig-out/bin/benchmark
perf report
```

For instruction counts, use `--filter` to avoid running callgrind over the full
suite; callgrind is deterministic but slow.

```sh
zig build bench-bin
valgrind --tool=callgrind --callgrind-out-file=callgrind.out \
  ./zig-out/bin/benchmark --filter chacha20
callgrind_annotate callgrind.out
```

For raw OpenSSL crypto comparison:

```sh
zig build bench-evp
zig build bench-evp-bin
zig-out/bin/evp_bench --filter aes_128
```

These EVP rows are not a TLS comparison. They isolate OpenSSL's AEAD
implementation and EVP setup/update/final overhead so ztls record numbers can
be interpreted against the crypto floor. The `Encrypt` / `Decrypt` rows keep the
EVP context and cipher/key setup alive across iterations, resetting only the IV
per operation; `BulkEncryptOnce` / `BulkDecryptOnce` create and initialize a new
EVP context inside each timed operation. This still does not make EVP a
no-allocation ztls core backend — OpenSSL 3 provider contexts allocate behind
the API.

For libssl machinery without kernel sockets:

```sh
zig build bench-openssl
zig build bench-openssl-bin
zig-out/bin/bio_bench --filter handshake
zig-out/bin/openssl_bio_bench --filter ping_pong
```

The memory-BIO rows include libssl and BIO overhead but exclude TCP/syscall
noise. That is the closest current comparison to ztls' no-I/O state-machine
model.

## Row-oriented perf and disassembly tooling

For explaining a wall-time delta on a specific row, the blunt `bench-perf` /
`bench-disasm` recipes above are not enough — they profile the entire binary.
The row-oriented tooling captures perf and disassembly for one implementation
and one row at a time, with stable output paths and metadata. `bench-perf-row`
accepts only ztls, libssl, and rustls TLS rows; EVP rows are raw-crypto floor
measurements and stay out of TLS row perf comparisons.

```sh
# Capture perf stat + perf record for one row (Linux only):
just bench-perf-row impl=ztls bench=AppPingPong suite=TLS_AES_128_GCM_SHA256 size=1350
just bench-perf-row impl=openssl bench=AppPingPong suite=TLS_AES_128_GCM_SHA256 size=1350
just bench-perf-row impl=rustls bench=AppPingPong suite=TLS_AES_128_GCM_SHA256 size=1350

# Disassemble a benchmark binary and its linked libraries (any host):
just bench-disasm-row impl=ztls
just bench-disasm-row impl=openssl
just bench-disasm-row impl=rustls
```

Output goes under `zig-out/perf/<timestamp>/` with row-specific subdirectories:

```text
zig-out/perf/<timestamp>/
  perf-row-<impl>-<bench>-<suite>-<size>/
    metadata.txt          # git rev, CPU, kernel, command line, linked libs,
                          # iteration counts for stat/record normalization
    perf.data             # raw perf record output
    perf-stat.txt         # perf stat counter summary
    perf-report.txt       # top symbols from perf report
    bench-output-stat.txt # benchmark stdout from the perf stat run
    bench-output-record.txt # benchmark stdout from the perf record run
  disasm-<impl>/
    metadata.txt
    binary.asm            # full disassembly of the benchmark binary
    symbols.txt           # nm symbol table
    libcrypto.asm         # if dynamically linked
    libssl.asm            # if dynamically linked (libssl binary only)
```

`zig-out/perf/` is local staging. Durable evidence is committed under
`docs/research/perf/<timestamp-host>/` alongside the wall-time capture and
benchstat analysis. Perf data is binary and large; commit it only for selected
durable rows. Disassembly text and annotated symbol output should be committed
for durable rows.

These scripts refuse to run `perf` on non-Linux hosts. Disassembly works on
any host via `objdump` (Linux) or `otool` (macOS fallback), but disassembly
produced on the wrong architecture (e.g. aarch64 when the committed capture is
x86_64) is not useful for explaining that capture. Use the row tooling on the
same host class as the wall-time capture you want to explain.

No committed perf/disassembly artifacts exist yet. Producing durable Linux
x86_64 perf evidence requires the EC2 workflow (#11) or equivalent bare-metal
access. The tooling is methodology progress, not committed evidence.
