# Why ztls

The README tells you what ztls is. This is the longer answer to why it exists and
when you'd reach for it over the library you already have.

Short version: ztls is a TLS 1.3 state machine that does no I/O and allocates
nothing of its own, aimed at people who want to own their event loop and their
memory. If that's not you, one of the mature libraries is the right call, and
this page will tell you so.

## The problem with a TLS library that owns its sockets

Most TLS libraries come welded to an I/O model. OpenSSL wants its BIOs. A typical
language-native library wants a blocking stream, or its async runtime, or a
callback shape it defines. The moment you pull it in, its assumptions about how
bytes move become your assumptions.

That's fine until it isn't. If you're writing an io_uring server, or running on a
custom event loop, or building something where every allocation is accounted for,
a library that owns its sockets fights you the whole way. You end up wrapping,
shimming, and working around a design that assumed it was in charge.

Sans-I/O flips that. The protocol is a pure function of bytes: you give it what
came off the wire, it tells you what to send back and hands you decrypted
application data. It never touches a socket. It never blocks. It has no thread of
its own. Where the bytes come from and where they go is entirely yours.

rustls proved this model works in production. ztls takes it further on memory: no
allocator in the engine at all.

## What ztls is for

Reach for ztls when:

- You own your I/O and want to keep owning it. epoll, io_uring, a green-thread
  scheduler, an in-memory test harness — ztls slots into any of them because it
  has no opinion about how you run.
- You care about allocation. The engine holds no heap state and never calls an
  allocator. You give it buffers; it uses exactly those. That makes memory
  behavior something you can reason about instead of profile after the fact.
- You're on Zig and don't want to drag a C library's I/O assumptions into your
  build, even though the primitive crypto underneath is still battle-tested
  libcrypto.
- You want TLS 1.3 and nothing else. No 1.2 downgrade paths, no DTLS, no
  Windows portability layer diluting the code you're trusting with your traffic.

## What ztls is not for, yet

Being honest about this is the whole brand, so here it is straight:

- **Anything in production.** It's pre-alpha and unaudited.
  [`SECURITY.md`](https://github.com/mattrobenolt/ztls/blob/main/SECURITY.md)
  says this plainly.
- **A drop-in OpenSSL replacement.** ztls does the TLS state machine. It does
  not manage sockets, load OS trust stores, or hand you a `connect()`. You write
  the drive loop. The examples show how, but it's your code.
- **The full TLS feature set.** Server auth works today. Client certificates,
  session resumption, 0-RTT, and HelloRetryRequest are tracked as open issues,
  not shipped.
- **A guaranteed-stable API.** Signatures move. Pin a commit if you build on it.

If you need a mature, audited, drop-everything-in TLS stack right now, use
rustls or OpenSSL. That's not a dodge — it's the correct answer for most people
today, and ztls will tell you when that changes.

## The performance argument

Performance is the reason ztls is being built rather than the reason to adopt it
today. The claim is narrow and evidence-backed: on in-memory application-data
benchmarks, ztls does less work per record than libssl across the board, and less
than rustls on AES-GCM. It loses to rustls on small ChaCha20-Poly1305 records,
and that row is published with the disassembly that explains why.

The honest caveats are in the
[README](https://github.com/mattrobenolt/ztls/blob/main/README.md) and in
[`docs/research/PERFORMANCE.md`](https://github.com/mattrobenolt/ztls/blob/main/docs/research/PERFORMANCE.md): two
x86_64 EC2 shapes so far, no repetition or threshold policy yet, and a
measurement-shape difference between the harnesses. So the current numbers are
measurements, not a marketing headline. When the methodology is hardened enough
to make a headline claim, we'll make it, and it'll point at reproducible numbers.

Until then the argument for ztls is architectural: the Sans-I/O, zero-allocation
design is what makes the performance ceiling high. The numbers are catching up to
the design, in the open, with the losses shown.

## Where to go next

- [`README.md`](https://github.com/mattrobenolt/ztls/blob/main/README.md) — what it is and how to start.
- [`docs/USAGE.md`](https://github.com/mattrobenolt/ztls/blob/main/docs/USAGE.md) — the API guide and drive-loop patterns.
- [`docs/research/PERFORMANCE.md`](https://github.com/mattrobenolt/ztls/blob/main/docs/research/PERFORMANCE.md) — benchmark methodology and the raw captures.
- [`docs/research/THREAT_MODEL.md`](https://github.com/mattrobenolt/ztls/blob/main/docs/research/THREAT_MODEL.md) — the attacker model and the caller/engine line.
- [`PRODUCTION_READINESS.md`](https://github.com/mattrobenolt/ztls/blob/main/PRODUCTION_READINESS.md) — what's proven, what isn't, and how we know.
