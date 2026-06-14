---
name: glasswing-harness
description: Run the Cloudflare Project Glasswing vulnerability-discovery harness on a codebase. Use when asked to find security bugs at scale, run a recon/hunt/validate/dedupe/trace loop, set up a cyber-frontier model security sweep, or structure parallel vulnerability research with adversarial review and proof-of-concept validation.
---

# Glasswing Harness

This is Cloudflare's Project Glasswing workflow adapted for pi. It replaces the naive "point one coding agent at a repo and ask for vulnerabilities" approach with a parallel, narrow-scoped pipeline that generates proofs instead of speculation.

Use it for legitimate security research on code you own or have permission to test.

## Core idea

A single agent trying to be exhaustive across a large codebase will wander and run out of context. Better results come from:

- Narrowing each task to one attack class + one scope hint.
- Running many narrow tasks in parallel, then deduplicating.
- Adding an adversarial validator that can only disprove, not find new bugs.
- Requiring a working proof of concept (compile + run) before a finding counts.
- Tracing reachability from attacker-controlled input across repo boundaries.
- Closing the loop so confirmed reachable bugs spawn new hunt tasks in consumer code.

## The pipeline

Run the stages in order. Each stage feeds the next. Keep output structured and machine-readable.

```
Recon → Hunt → Validate → Gapfill → Dedupe → Trace → Feedback → Report
```

### 1. Recon

Read the repository from the top down. Fan out to subagents, one per subsystem or module. Produce a single architecture document that covers:

- Build commands and how to compile/run tests.
- Trust boundaries (network, privilege, file-system, user input).
- Entry points and data flows.
- Likely attack surface per subsystem.
- An initial queue of scoped hunt tasks.

Each downstream task should reference the architecture doc, not re-read the whole repo.

### 2. Hunt

Each task is one attack class paired with one scope hint. Examples:

- "Command injection in shell-call sites under `src/cli/`, with untrusted input from `argv` or env."
- "Use-after-free in `conn_pool` lifetime transitions, reachable from the public API."
- "Integer overflow in length parsing in `src/protocol/` on untrusted wire bytes."

Run hunters concurrently. Each hunter may fan out to a few exploration subagents, but keep the scope tight. Every hunter has:

- The architecture doc from Recon.
- A scratch directory where it can compile and run PoC code.
- Tools to build, run, and observe the result.

A finding is not a finding until it includes a minimal reproducer or PoC that compiles and demonstrates the behavior. If the model only says "possibly" or "potentially", treat it as noise until it proves it.

### 3. Validate

Pass each candidate finding to an independent agent with a different prompt and no ability to emit new findings. Its only job is to disprove the original finding by reading the same code, checking assumptions, and trying to break the PoC.

Validation must be adversarial: the validator is not helping the hunter, it is trying to show the hunter is wrong. This catches more noise than asking the hunter to double-check itself.

### 4. Gapfill

Hunters flag areas they touched but did not cover thoroughly. Re-queue those areas for another pass with a tighter scope or a different attack class. This counteracts the model's tendency to drift toward classes where it has already found success.

### 5. Dedupe

Collapse findings that share the same root cause into a single record. Variant analysis is useful; duplicate queue entries are not. Store each finding with:

- Root cause location and commit/version.
- Attack class.
- Proof-of-concept code and how to run it.
- Reachability notes (updated by Trace).
- Severity and confidence.

### 6. Trace

For each confirmed finding in a shared library or utility, trace whether attacker-controlled input can actually reach it from outside the system. Use a cross-repo symbol index if the code is consumed elsewhere. One tracer agent per consumer repository, checking the public API surface.

A finding that is not reachable is a bug. A finding that is reachable is a vulnerability. Severity follows reachability.

### 7. Feedback

Turn reachable traces into new hunt tasks in the consumer repositories where the bug is exposed. Feed those tasks back into the Hunt stage. This closes the loop and improves coverage as the pipeline runs.

### 8. Report

Write a structured report against a predefined schema. Validate the report against the schema before submission. Output should be queryable data, not free-form prose. Include at minimum:

- Finding ID and title.
- Root cause location.
- Attack class and impact.
- Reachability verdict.
- PoC code and reproduction steps.
- Suggested fix or mitigation.
- Confidence level and validator notes.

## Mapping to existing project agents

When this project already defines role agents, prefer them:

- **Recon / Trace / Gapfill**: `evidence-auditor` for structured status and reachability review.
- **Hunt**: `whitehat-hacker` for hostile-input, parser-abuse, and memory-corruption hunts.
- **Validate**: `vuln-validator` for independent disproof of a candidate finding.
- **Implementation review**: `implementation-reviewer` for API and test review after fixes.
- **Security review**: `security-reviewer` for adversarial TLS/crypto review on protocol code.

See `.pi/agents/` for the current prompts. If an agent is missing, define a narrow one rather than broadening an existing role.

## Practical prompt template

Use this shape for each hunt task. Keep it one attack class, one scope, one proof.

```markdown
You are a security researcher hunting for {attack_class} in {scope}.

Context:
- See {architecture_doc_path} for the subsystem layout, trust boundaries, and entry points.
- Focus on code that handles untrusted input from {entry_point}.
- Do not report speculative findings. A finding must include a minimal PoC that compiles and runs.

Your task:
1. Identify the most likely {attack_class} bugs in this scope.
2. For each, write a minimal proof-of-concept in {scratch_dir}.
3. Compile and run the PoC. If it fails, adjust the hypothesis and retry.
4. Return a structured finding with: location, root cause, PoC code, reproduction steps, observed behavior, and impact.

Constraints:
- Do not change production code.
- Do not run untrusted binaries outside the scratch directory.
- If the scope is too large, stop and ask for a narrower slice instead of guessing.
```

## Anti-patterns

- Do not point a single generic coding agent at an entire repo and ask it to "find vulnerabilities." It will produce noise and exhaust context.
- Do not accept hedged findings ("possibly," "could in theory") as queue entries. Demand proof.
- Do not let the same model both find and validate its own findings. Use an independent agent.
- Do not skip the Trace stage. A bug that is not reachable is a much lower priority than a reachable vulnerability.
- Do not let the model write and deploy patches without regression testing. The harness finds bugs; the normal engineering process fixes them.

## Reference

For the full background, methodology, and Cloudflare's original observations, read [references/project-glasswing-summary.md](references/project-glasswing-summary.md).
