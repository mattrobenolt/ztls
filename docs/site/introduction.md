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
