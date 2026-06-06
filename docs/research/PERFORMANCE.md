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
   It is not a full client/server benchmark until ztls has a server.
   Implemented today for all three mandatory suites as `client_handshake_replay`.

4. **Full in-memory connection**

   ztls now has a server-side skeleton, so `zig build bench` includes
   rustls-style no-I/O scenarios over in-memory client/server state machines:
   full authenticated handshake, client-to-server application data,
   server-to-client application data, and ping/pong small-record loops. These
   rows are still ztls-only; comparable OpenSSL/rustls harnesses are separate
   follow-up work.

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

## Initial harness scope

The first `zig build bench` is deliberately boring:

- record encrypt/decrypt throughput for all three AEADs at fixed record sizes;
- record framing/parser rows for cheap non-crypto surfaces;
- deterministic generated-OpenSSL client handshake replay for all three suites;
- ztls in-memory authenticated client/server handshake and app-data rows;
- OpenSSL EVP raw AEAD rows via `zig build bench-evp`;
- OpenSSL/libssl memory-BIO rows via `zig build bench-openssl`;
- no network;
- no allocations in library code; benchmark-only scratch allocation is fine;
- CSV rows written to stdout.

Future benchmark additions should stay as separate named rows instead of
stuffing unrelated work into one timing loop. The current full-suite target is
small enough for routine checks; use `--filter`/`bench-bin` for profiling-grade
single-scenario runs.

## Profiling tools

The devshell includes Linux-only `perf` and `valgrind`/`callgrind_annotate`.
Use wall-time benchmark output to choose a suspicious scenario, then profile the
compiled benchmark binary rather than adding timing probes to library code.
Containerized Linux may expose only a subset of perf events; if hardware cycles
show as unsupported, use callgrind for instruction counts or rerun on bare
metal.

Typical local flow:

```sh
just bench-capture
just bench-analyze
just bench-compare aes_128
just bench-bins
just bench-disasm record_protection_bench zig-out/record_protection_bench.asm
just bench-disasm-libcrypto record_protection_bench zig-out/libcrypto.asm
just bench-perf record_protection_bench --filter record_encrypt --filter aes_128
perf report --input zig-out/record_protection_bench.perf.data
```

`bench-capture` writes timestamped CSV-ish files under `zig-out/perf/` for
ztls, OpenSSL EVP, and OpenSSL memory BIO. `bench-analyze` consumes the latest
capture by default and emits structured ratios for ztls-vs-BIO app data,
ztls-vs-EVP-reuse record crypto, handshake ops/sec, and split handshake timing.
Pass explicit files with `--ztls`, `--evp`, and `--bio` when comparing older runs.

The raw Zig build steps remain available when you want to bypass `just`:

```sh
zig build bench
zig build bench-bin
perf record --call-graph dwarf ./zig-out/bin/record_protection_bench
perf report
```

For instruction counts, use `--filter` to avoid running callgrind over the full
suite; callgrind is deterministic but slow.

```sh
zig build bench-bin
valgrind --tool=callgrind --callgrind-out-file=callgrind.out \
  ./zig-out/bin/record_protection_bench --filter chacha20
callgrind_annotate callgrind.out
```

For raw OpenSSL crypto comparison:

```sh
just bench-compare aes_128
# or only the raw EVP harness:
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
