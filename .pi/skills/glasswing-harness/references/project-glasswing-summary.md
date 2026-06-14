# Project Glasswing: what Mythos showed us

Source: Cloudflare blog, 2026-05-18. This is the original research that produced the Glasswing harness.

## What changed with Mythos Preview

Mythos Preview is a security-focused frontier model from Anthropic, used by Cloudflare as part of Project Glasswing. Two capabilities stood out:

- **Exploit chain construction**: it can take several low-severity primitives and reason about how to combine them into a working exploit, showing reasoning that looks like a senior researcher rather than a scanner.
- **Proof generation**: it writes code that triggers the suspected bug, compiles and runs it in a scratch environment, reads failures, adjusts the hypothesis, and tries again. A suspected flaw without a working proof is speculation; Mythos Preview closes that gap on its own.

Other frontier models found the same underlying bugs but often stopped at the description, leaving the chain unfinished. Mythos Preview's difference was stitching low-severity bugs into a single, more severe exploit.

## Model refusals in legitimate research

Even in a controlled research context with reduced safeguards, the model organically pushed back on certain requests. These refusals were inconsistent: the same task, framed differently or presented in a different context, could produce opposite outcomes. This means organic model refusals are real but not reliable enough to be the only safety boundary for a generally available cyber frontier model.

## The signal-to-noise problem

Two factors dominate false positives:

1. **Programming language**: C and C++ produce more false positives because of direct memory-control bug classes that memory-safe languages eliminate at compile time.
2. **Model bias**: ask a model to find bugs and it will find them, whether they exist or not. Findings come back hedged with "possibly," "potentially," "could in theory." A finding that arrives with a PoC is actionable; hedged findings waste triage time.

Mythos Preview improved this by chaining primitives into proofs with clearer reproduction steps.

## Why a generic coding agent does not work

Two problems:

- **Context**: coding agents are tuned for one focused stream of work, but vulnerability research is narrow and parallel. A single agent session against a large codebase covers a tiny fraction usefully before context compaction discards earlier findings.
- **Throughput**: real codebases need many hypotheses against many components at once, with further fan-out when something interesting appears. A single-stream agent becomes the bottleneck regardless of model quality.

The model is better used as a component in a harness than as the entire tool.

## What the harness fixes

Four lessons shaped the harness:

1. **Narrow scope produces better findings**: "Find vulnerabilities in this repo" makes the model wander. "Look for command injection in this specific function, with this trust boundary, architecture doc attached" makes it behave like a researcher.
2. **Adversarial review reduces noise**: a second agent with a different prompt and no ability to generate findings catches noise the first agent misses when checking its own work.
3. **Splitting the chain across agents produces better reasoning**: "Is this buggy?" and "Can an attacker reach it from outside?" are separate questions; the model answers each better when asked separately.
4. **Parallel narrow tasks beat one exhaustive agent**: many agents working on tightly scoped questions, with deduplication afterward, improves coverage.

## The original Cloudflare harness stages

| Stage | What it does | Why it matters |
|-------|--------------|----------------|
| **Recon** | Agent reads repo top-down, fans out to subagents per subsystem, produces architecture doc (build commands, trust boundaries, entry points, attack surface) and initial hunt queue. | Shared context for downstream agents; cuts the wander problem. |
| **Hunt** | Each task is one attack class + scope hint. Hunters run concurrently (about fifty at once), each fanning out to a few exploration subagents. Hunters can compile and run PoC code in a per-task scratch directory. | Most of the work happens here; many narrow tasks in parallel instead of one exhaustive agent. |
| **Validate** | Independent agent re-reads code and tries to disprove the finding. Uses a different prompt and cannot emit new findings. | Catches noise the hunter would miss when reviewing its own work. |
| **Gapfill** | Hunters flag areas touched but not thoroughly covered. Those areas are re-queued for another pass. | Counteracts drift toward already-successful attack classes. |
| **Dedupe** | Findings sharing the same root cause collapse into one record. | Variant analysis is useful; duplicate queue entries are not. |
| **Trace** | For each confirmed finding in a shared library, a tracer agent fans out (one per consumer repo), uses a cross-repo symbol index, and decides whether attacker-controlled input reaches the bug from outside. | Turns "there is a flaw" into "there is a reachable vulnerability." |
| **Feedback** | Reachable traces become new hunt tasks in consumer repos where the bug is exposed. | Closes the loop; the pipeline improves as it runs. |
| **Report** | Agent writes a structured report against a predefined schema, fixes schema validation errors, and submits to an ingest API. | Output is queryable data, not free-form prose. |

## What this means for security teams

Speed of patching is not enough. The architecture around the vulnerability matters more: defenses that block the bug from being reached, compartmentalization so a flaw in one part cannot access others, and the ability to roll out a fix everywhere at once. The same capabilities that help defenders find bugs can also accelerate attackers, so safeguards and controlled environments matter.

## Source note

Cloudflare's research was conducted in a controlled environment against their own code. Every vulnerability was triaged, validated, and remediated under their formal vulnerability management process. Only run this harness on code you own or have explicit permission to test.
