<p align="center">
  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="72" height="72" fill="none" role="img" aria-label="ztls">
    <path d="M24 28 H76 L24 72 H76" stroke="currentColor" stroke-width="6" stroke-linecap="round" stroke-linejoin="round"/>
    <circle cx="24" cy="28" r="7.5" fill="currentColor"/>
    <circle cx="76" cy="72" r="7.5" fill="currentColor"/>
  </svg>
</p>

# ztls

ztls is a TLS 1.3 library that does no I/O. You feed it the bytes you read off
the wire; it hands you back the bytes to write. Your socket, your event loop,
your buffers. ztls just does the protocol.

It's pre-alpha. The API will change out from under you. Read the guide before you
build on it.

This site has four parts:

- **[Why ztls](why.md)** — what it's for, when to reach for it, and when to use
  something mature instead.
- **[Guide](guide.md)** — the buffer-ownership model, the drive loop, and
  working client and server code.
- **[API reference](api.md)** — the generated Zig documentation for every public
  declaration.
- **[Security](security.md)** — status, scope, and how to report a vulnerability.

The source, issues, and status dashboard live on
[GitHub](https://github.com/mattrobenolt/ztls).
