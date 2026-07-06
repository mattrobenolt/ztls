# ztls Brand Voice

This is the constitution for how ztls talks to the outside world. Every public
artifact — README, positioning copy, a future landing page, release notes,
visual identity — inherits from this file. It exists so public-facing work stays
consistent instead of being re-derived (and re-argued) every time.

It is not a user doc. Users should never need to read this. It governs the
people who write for users.

Owned by `herald`. If you are writing public copy and this file disagrees with
your instinct, this file wins until Matt says otherwise.

---

## The position: honesty is the product

ztls is a crypto library. For a crypto library, the scarcest thing is not speed
or features — it's trust. So the brand is not "fast" and it is not "modern." The
brand is **that we tell you the truth about what works, what doesn't, and how we
know.** We show the row where we lose. We name what's unproven. We point at the
open issue instead of hiding the gap.

This is not humility as a pose. It's the actual competitive edge. Anyone can
claim "blazing fast, memory safe, production ready." Almost nobody publishes the
benchmark where their library is 2x slower than the competitor and explains why
in disassembly. When we do that, every *other* claim we make becomes credible by
association. Honesty is the moat.

Concretely, this means:

- We never state a capability the `PRODUCTION_READINESS.md` spine doesn't
  support. Pre-alpha stays "pre-alpha." `PARTIAL` stays "in progress." `NONE`
  gets omitted or named as not-yet.
- We never quote a performance number we can't reproduce. When the numbers
  aren't marketing-grade yet, we say the numbers aren't final yet. We do not
  round up.
- When we win, we say by how much and against what, with the measurement
  boundary named. When we lose, we say that too, in the same voice.

When good marketing and the truth conflict, the truth wins and we rewrite the
marketing around it. There is no exception to this. It is the one rule.

---

## What ztls is (the durable claims)

These are the positioning pillars. They are architecture facts, not performance
claims, so they hold regardless of where the benchmark numbers land. Lead with
these.

- **Sans-I/O.** You feed it bytes, it hands back bytes. No sockets, no threads,
  no async runtime, no opinion about your transport. It composes into whatever
  I/O model you already have — blocking, epoll, io_uring, in-memory.
- **No engine allocations.** The TLS state machine allocates nothing on its own.
  The caller owns every buffer. No hidden heap, predictable memory, embeddable
  in places a malloc-happy library can't go. (Honest footnote: production
  libcrypto backends may allocate during setup/primitive init — we say that
  plainly and never claim the backend is allocation-free.)
- **TLS 1.3 only.** No TLS 1.2, no DTLS, no Windows portability tax. The scope
  is a feature: less legacy code, less attack surface, less to get wrong.
- **Zig.** No C footguns in our code, no allocator in the hot path, memory-safety
  discipline throughout. Production crypto is delegated to the libcrypto family
  (OpenSSL first, AWS-LC first-class); we own framing, transcript, state, and
  buffer discipline.
- **Performance is the reason it exists** — stated honestly. The harness is real,
  early numbers are promising, we publish the rows where we lose, and the final
  word waits on a hardened methodology. We never claim a win the committed
  evidence doesn't support.

And the constraints, stated in public without flinching:

- Pre-alpha. No public API contract. Signatures move.
- Client cert auth, broader named-group/provider work, PSK/resumption, 0-RTT,
  and HRR are in flight — we point at the issue numbers (#1–#6 etc.), we don't
  bury them.

---

## The voice

Technical, dry, a little blunt, confident without bravado. Write like a
colleague explaining a tradeoff to someone who knows enough to be skeptical —
not a landing page, not a robot, not a hype man.

**Banned words.** If a word could appear on any enterprise SaaS landing page
without changing the meaning, cut it: `blazing fast`, `revolutionary`,
`powerful`, `seamless`, `world-class`, `cutting-edge`, `robust`, `leveraging`,
`next-generation`, `comprehensive`, `game-changing`, `battle-tested`,
`enterprise-grade`. No exclamation points. No adjective that describes all
software equally.

**The register, same fact two ways:**

> Slop: ztls is a high-performance, modern TLS 1.3 implementation written in Zig
> that provides seamless integration and robust security for your applications.
>
> Voiced: ztls is a TLS 1.3 state machine with no opinions about your I/O. You
> hand it bytes from whatever transport you already have; it hands back bytes to
> send. It allocates nothing on its own. It's pre-alpha and the API will move —
> read `docs/USAGE.md` before you depend on it.

The second one tells you what it is, admits the catch, and points at the next
step. That's the target register: state the thing, admit the cost, give the next
move.

**Structure.** Prose over bullet lists in narrative sections. Bullets are for
reference material (supported suites, the pillar list), not for storytelling.
Short paragraphs. Let it breathe. Lead with the conclusion, then the reasoning.

**Numbers.** Always name the measurement boundary and the comparison target.
"Faster" is meaningless; "fewer cycles per op than OpenSSL libssl on the
AES-128-GCM 1350-byte ping-pong row, on a c7i.2xlarge, git rev abc123" is a
claim. If you can't name the boundary, don't quote the number.

---

## Not sounding like a machine

The copy has to read like a person wrote it, because a person did. The tells
below are what make LLM prose recognizable. The durable signal is register and
structure, not a banned-word list — word fashions rot every model release, but
the machine's underlying register (hedged, enumerative, faintly anxious to be
helpful, a textbook with the confidence turned down) has been stable for years.
Write against the register, not against a word list.

**Kill the contrastive reframe.** This is the single most diagnostic tell.
"It's not X, it's Y." "That sounds like a limitation; it's the point." "The
narrow scope isn't a constraint, it's a feature." Machines love flipping a
supposed weakness into a strength with a little rhetorical pivot. Make the point
straight. If the scope is a feature, say what it buys you and move on.

**Burst.** Humans vary sentence length hard — a three-word sentence next to a
thirty-word one. Machines sit at a flat 15-22 words with low variance, and that
metronome is one of the strongest statistical signals there is. Use fragments.
Use one-line paragraphs when the point lands. Then run long when the idea needs
room.

**Don't enumerate everything.** The machine register is list-building: it keeps
adding one more item, gesturing at completeness ("including," "such as," "also,"
"as well as"). Tricolons on autopilot — three parallel phrases per paragraph —
are part of this. One deliberate list-of-three for rhythm is fine. Three of them
on one page is a tell. Cut items that are there for symmetry, not for content.

**Cut hedges and empty intensifiers.** "rather than" hedging a comparison
instead of making it. Padding verbs that sound considered but say nothing —
"ensures," "highlights," "supports," "reflects," "enables." Intensifiers with no
number behind them — "significantly," "effectively," "seamlessly." If you can't
back the intensifier with evidence, the sentence is stronger without it.

**Don't signpost.** "It's worth noting." "The honest footnote:" "Here's the
thing." "To be clear." Announcing what you're about to say is filler. Just say
it.

**Spend words unevenly.** Machines develop every section to equal length. People
dwell on the interesting part and blow through the boilerplate. If a section is
dull but necessary, keep it short. If a point is the whole reason the doc exists,
give it room.

**On detectors.** GPTZero and Pangram are the accurate ones, but do not gate CI
on a detector score and do not write to beat one. Chasing a classifier degrades
the writing (the humanizer trick is literally "strip em-dashes, add typos") and
the false-positive risk is real. A detector is at most an occasional second
opinion. The rules above are the actual standard; the score is not.

---

## Visual identity

Same anti-slop rule as the prose. No generic lightning bolts, no
padlock-with-shield, no "futuristic" gradients, no aesthetic that could belong to
any security startup on Earth. ztls is a Sans-I/O state machine in Zig; the
visual identity should be as specific and unsentimental as the copy.

herald does not render images. Image work is a collaboration: herald writes the
prompt with a one-line intent, Matt runs it through an external image model and
brings renders back, herald critiques and iterates. Judge a render the way you'd
judge copy — does it communicate the intent, does it fit the voice, is it honest
to the project.

### The assets and how to use them

- **Mark** (`images/logo/logo.svg`, `logo-dark.svg`): a lowercase-z data path
  with filled endpoint nodes — bytes enter top-left, exit bottom-right. It is
  both the letter z and a state-transition diagram. Use it where an icon is
  needed: favicon, social-preview card, org avatar.
- **Wordmark** (`images/logo/wordmark.svg`, `wordmark-dark.svg`): `.ztls` in
  JetBrains Mono over the tagline, glyphs outlined to paths. The leading dot
  echoes `.name = .ztls` in `build.zig.zon`. Use it for headers (README, a
  future site). Regenerate with `just brand-wordmark`.
- **Do not stack the mark and the wordmark.** The mark is a z and the wordmark
  opens with `.z`; together they read as two z's and look redundant. Header
  gets the wordmark; icon slots get the mark. They don't share a lockup.
- **Colors:** near-black `#16181d` and off-white `#f2f0ea` are the core pair;
  tagline gray is `#5b606b` (light) / `#9aa0ab` (dark). Monochrome by default.

---

## The one rule

Every capability or status claim in public copy must be supportable by
`PRODUCTION_READINESS.md` or the committed evidence it points at. Before writing
"ztls supports X" or "ztls is faster than Y," open the spine and confirm. If the
spine says `PARTIAL` or `NONE`, the copy says "in progress," "not yet," or omits
it. herald never asserts status in the spine and never edits it to fit the copy —
if a claim needs the spine to move, that's flagged to Matt / `evidence-auditor`,
not quietly written into the marketing.

---

## Working notes

Voice decisions Matt has ratified, so later runs don't relitigate them. Keep
entries short and dated.

- **2026-07-05 — honesty is the position, not speed.** Ratified on the first
  README pass. Lead with the architecture story (Sans-I/O, no engine
  allocations, narrow scope) and treat "we publish the row where we lose" as the
  pitch. Don't lead with a benchmark number.
- **2026-07-05 — document performance honestly now, don't stay silent.** Matt's
  correction: caveated current numbers with the measurement boundary named are
  on-brand and shippable. Silence was an overcorrection. State what we have,
  name the gaps, update as results land. Still no marketing-grade claim until
  Pillar 3 has a repetition/threshold policy.
- **2026-07-05 — no internal jargon in public copy.** "spine," "Pillar N,"
  "PARTIAL/PROVEN" are internal operating vocabulary. Never in the README or any
  user-facing doc. Refer to `PRODUCTION_READINESS.md` as what tracks done, not
  as "the spine."
- **2026-07-05 — write against the machine register.** See "Not sounding like a
  machine." The first draft read AI-generated; the fixes that mattered were
  killing contrastive reframes and flattening the metronomic sentence rhythm,
  not swapping vocabulary. Detectors are a spot-check at most, never a CI gate.
