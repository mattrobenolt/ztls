# Research

Design notes, RFC references, and prior art for ztls.

- [`DESIGN.md`](DESIGN.md) — architecture, goals, API sketch, build order
- [`NEGATIVE_SPACE.md`](NEGATIVE_SPACE.md) — malformed/malicious peer input inventory
- [`rfcs/`](rfcs/) — full RFC text files for offline reference
  - `rfc8446-tls13.txt` — TLS 1.3 (the main one)
  - `rfc5869-hkdf.txt` — HKDF
  - `rfc8439-chacha20-poly1305.txt` — ChaCha20-Poly1305
  - `rfc7748-x25519-x448.txt` — X25519/X448 key exchange
  - `rfc8032-eddsa.txt` — EdDSA / Ed25519
  - `rfc8448-tls13-examples.txt` — TLS 1.3 example handshake traces with known numerical test vectors
- [`references/`](references/) — notes on Go, BearSSL, rustls source
