# API reference

The full API reference is generated from the source with Zig's documentation
tooling, so it never drifts from the code:

**[Browse the ztls API docs →](zig-docs/index.html)**

Every public declaration in `src/root.zig` and its imports is listed there with
its doc comments, types, and signatures. Start from the top-level `ztls` module
and drill into `ClientHandshake`, `ServerHandshake`, `RecordBuffer`, `Outbox`,
`signature`, and the key-exchange modules.

The [Guide](guide.md) is the prose companion: it explains the drive loop and
buffer ownership that the type signatures alone don't convey.
