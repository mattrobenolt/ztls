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
script normalizes ztls, libssl, rustls, and EVP output into one table; this
section defines which normalized rows are legitimate apples-to-apples
comparisons.

A comparable row must have the same protocol phase, the same cipher suite, the
same payload size when payload exists, and no kernel I/O in the timed path. The
transport model differs by implementation — caller-owned buffers for ztls,
memory BIOs for libssl, and in-memory `Vec<u8>` transfer buffers for rustls —
but every comparable row measures TLS work over deterministic memory transport,
not sockets.

| Row group | ztls row | libssl memory-BIO row | rustls row | Comparison status |
| --- | --- | --- | --- | --- |
| Full handshake | `Handshake` | `Handshake` | `rustls_handshake` | Comparable across all three. Full TLS 1.3 handshake, no resumption, X25519, server-only EC P-256 certificate, in-memory transport, no certificate-chain policy in ztls/rustls and `SSL_VERIFY_NONE` for libssl. |
| ClientHello construction | `HandshakeClientStart` | — | `rustls_handshake_client_start` | Comparable between ztls and rustls only. Both measure initial ClientHello construction and key-share generation. libssl does not expose this split below `SSL_do_handshake`. |
| Server accepts ClientHello | `HandshakeServerAccept` | — | `rustls_handshake_server_accept` | Comparable between ztls and rustls only. Both consume the ClientHello and construct the ServerHello-side response point. libssl is opaque here. |
| Client processes ServerHello | `HandshakeClientServerHello` | — | — | ztls-only profiling row. rustls processes more of the encrypted server flight in the next client step, so there is no honest rustls peer. |
| Server authenticated flight | `HandshakeServerFlight` | — | `rustls_handshake_server_flight` | Comparable between ztls and rustls only. Both construct the encrypted server handshake flight. libssl is opaque here. |
| Client Finished flight | `HandshakeClientFlight` | — | `rustls_handshake_client_flight` | Comparable with a documented caveat: both consume the encrypted server flight and emit the client Finished flight, but rustls performs certificate verification policy in this phase while ztls deliberately keeps certificate-chain policy outside the core engine. |
| Server verifies client Finished | `HandshakeServerFinished` | — | `rustls_handshake_server_finished` | Comparable between ztls and rustls only. Both consume the client's Finished flight and complete the server side of the handshake. libssl is opaque here. |
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
with labels that describe their narrower boundary.

## Methodology

- Build benchmarks with `-Doptimize=ReleaseFast` and a native CPU target. The
  build defaults benchmark/test artifacts to native CPU now; generic AArch64
  silently selects std.crypto's software AES/GHASH paths and is not a useful
  performance target.
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
just bench-capture --count=5
```

Each capture writes one run directory under `zig-out/perf/<timestamp>/` with
`metadata.txt`, `ztls.txt`, `evp.txt`, `libssl.txt`, and `rustls.txt`. This shape
is intended for remote benchmark hosts: rsync the run directory back, then run
`just bench-analyze zig-out/perf/<timestamp>` to compare the captured files with
`benchstat`.

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
zig-out/bin/openssl_evp_bench --filter aes_128
```

These EVP rows are not a TLS comparison. They isolate OpenSSL's AEAD
implementation and EVP setup/update/final overhead so ztls record numbers can
be interpreted against the crypto floor. The `openssl_evp_reuse_*` rows keep the
EVP context and cipher/key setup alive across iterations, resetting only the IV
per operation; use those rows to avoid over-crediting ztls on tiny records where
full EVP setup dominates. This still does not make EVP a no-allocation ztls core
backend — OpenSSL 3 provider contexts allocate behind the API.

For libssl machinery without kernel sockets:

```sh
zig build bench-openssl
zig build bench-openssl-bin
zig-out/bin/openssl_bio_bench --filter handshake
zig-out/bin/openssl_bio_bench --filter ping_pong
```

The memory-BIO rows include libssl and BIO overhead but exclude TCP/syscall
noise. That is the closest current comparison to ztls' no-I/O state-machine
model.
