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
record overhead and state-machine costs.

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

   Use realistic record sizes: 16 bytes, 1350 bytes, 8192 bytes, and 16384
   bytes. BoringSSL uses similar chunk-size sweeps because small records measure
   per-record overhead while large records measure primitive throughput.

2. **Parser/framing throughput**

   Measure `frame.parseHeader`, `RecordBuffer.next`, `server_hello.parse`, and
   certificate parsing separately. These are attacker-controlled input surfaces
   and hot enough to track regressions, but they should not be mixed into crypto
   throughput numbers.

3. **Client handshake replay**

   Use RFC 8448 / OpenSSL fixture bytes to drive `ClientHandshake` through a
   deterministic client-side handshake. This measures exactly the client work we
   own today: transcript hashing, key schedule, certificate parse, signature
   verify, Finished validation, and client Finished generation. It is not a full
   client/server benchmark until ztls has a server.

4. **Full in-memory connection**

   Once a ztls server exists, add rustls-style scenario benchmarks: full
   handshake, resumed handshake if implemented, and transfer of 1 MiB over an
   in-memory transport. Measure client and server sides separately.

## Methodology

- Build benchmarks with `-Doptimize=ReleaseFast`.
- Print machine/build metadata with each run: target, CPU model if available,
  Zig version, optimization mode, git revision.
- Output machine-readable rows (`csv`-ish is enough): benchmark name, bytes,
  iterations, elapsed ns, throughput/op rate.
- Warm up before measuring where branch/cache effects matter.
- Avoid claiming performance from one local run. Commit the harness first; use
  `perf`, Instruments, or callgrind to explain results after they exist.
- Prefer instruction-count regression tracking later. Wall-time in containers or
  laptops is useful for development, not for 1% claims.

## Initial harness scope

The first `zig build bench` should be deliberately boring:

- record encrypt/decrypt throughput for all three AEADs at fixed record sizes;
- no network;
- no allocations in library code; benchmark-only scratch allocation is fine;
- CSV rows written to stdout.

After that exists, add handshake replay and parser/framing scenarios as separate
named benchmarks instead of stuffing everything into one timing loop.
