# Security Policy

ztls is a TLS 1.3 library. Security is the whole job. Read this before you rely
on it for anything.

## Status: pre-alpha, unaudited

ztls has not had an external security audit. The API is not stable. It has not
been deployed anywhere that matters. Do not put it in front of real traffic or
real secrets yet.

That is not false modesty. `PRODUCTION_READINESS.md` tracks exactly what is
proven and what isn't, with the evidence behind each claim. If you're weighing
ztls for anything security-sensitive, read that first, then decide.

What ztls does have: RFC-cited tests, RFC 8448 known-answer vectors, OpenSSL
interop in both directions, tlsfuzzer and TLS-Anvil conformance runs, Wycheproof
boundary vectors at the crypto seam, fuzzing on the parser and record-decrypt
surfaces, and a documented threat model at `docs/research/THREAT_MODEL.md`. That
is real evidence. It is not a substitute for an audit.

## Reporting a vulnerability

Report privately. Do not open a public issue for a security bug.

Use GitHub's private vulnerability reporting: go to the **Security** tab of this
repository and click **Report a vulnerability**. That opens a private advisory
visible only to the maintainer.

Please include what you'd want if the roles were reversed: affected version or
commit, a description of the flaw, and a reproduction — a failing test, a fuzz
input, a packet capture, or a proof-of-concept. If you have a suggested fix,
even better.

## What's in scope

The TLS 1.3 protocol implementation ztls owns: record framing, the handshake
state machine, transcript hashing, key schedule, alert handling, certificate
path validation and hostname verification, and the parser surfaces that consume
attacker-controlled bytes.

Out of scope:

- The libcrypto backend itself (OpenSSL, AWS-LC). Report primitive crypto bugs
  upstream. Report *misuse* of the backend by ztls here.
- Anything the caller owns: transport I/O, buffer lifetime, trust-store
  provisioning, the drive loop. `docs/research/THREAT_MODEL.md` draws the line
  between ztls's responsibilities and the caller's.
- Features that don't exist yet (client cert auth, PSK/resumption, 0-RTT). Those
  are tracked as open issues, not vulnerabilities.

## Expectations

This is pre-alpha software maintained in the open. There is no response-time SLA.
Reports are read and taken seriously, but fixes land on a best-effort basis until
the project reaches a stage where it can promise more. When ztls is ready to make
security commitments it can keep, this file will say so.
