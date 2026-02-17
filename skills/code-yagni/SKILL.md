---
name: code-yagni
description: YAGNI decision frameworks for evaluating whether to build a feature, detecting speculative generality, and preventing unnecessary feature bloat. Use when planning involves new features, design decisions, or "should we build this" questions during brainstorm, scope, or architecture review. Covers four costs of presumptive features, build-vs-not-build decision framework, speculative generality detection, and bloat antipatterns.
---

# Code YAGNI

Decision frameworks for the hardest question in software: "Should we build this?" YAGNI (You Aren't Gonna Need It) turned into actionable guidance for preventing feature bloat and speculative complexity.

## Quick Reference

### "Should I Build This?" Decision Table

| Question | Yes → Build | No → Defer |
|----------|-------------|------------|
| Is there a concrete requirement from a real user today? | Specific user story with acceptance criteria | "Someone might want this someday" |
| Will deferring cost significantly more later? | Database schema change on a live system with migrations | Adding a function to a well-structured module |
| Is the codebase too rigid to add this later? | Tightly coupled monolith with no tests | Clean architecture with dependency injection and good test coverage |
| Does data support this feature's value? | A/B test results, user research, support ticket patterns | Gut feeling, competitor feature list, HiPPO decision |
| Is there a second use case? | Two concrete consumers exist today | "We'll probably need this for the API too" |

**If 3+ answers land in "No → Defer"**: Don't build it. Revisit when concrete need emerges.

### The Four Costs of Presumptive Features

Every feature built "just in case" incurs four costs, even if the feature is never used:

| Cost | What You Pay | Example |
|------|-------------|---------|
| **Build** | Analysis, programming, and testing effort for a feature that may never be needed | Two sprints building a plugin system no one requests |
| **Delay** | Opportunity cost — revenue or value foregone while building the wrong thing | Piracy-pricing module delays storm-risk sales by two months (Fowler) |
| **Carry** | Ongoing complexity tax on every future change — code that every developer must understand and work around | "A couple of weeks" added to each subsequent feature because of dead-weight code paths |
| **Repair** | Rework when the presumptive feature doesn't match actual requirements that eventually emerge | Assumptions baked into the architecture require refactoring when real needs differ |

Build cost is visible. Delay, carry, and repair costs are hidden — which is why presumptive features feel cheap but compound relentlessly.

## YAGNI vs. Good Design

YAGNI is frequently misunderstood. It does **not** mean:

| YAGNI Does NOT Mean | YAGNI DOES Mean |
|---------------------|-----------------|
| Skip writing tests | Don't build features without concrete requirements |
| Write messy code | Don't add capabilities for hypothetical future needs |
| Avoid clean architecture | Don't invest in extension points nobody uses |
| Ignore maintainability | Don't build abstractions before the second use case |
| Ship technical debt | Don't let speculation drive the backlog |

**The critical distinction (Fowler):** YAGNI applies to *capabilities built to support a presumptive feature*. It does **not** apply to effort that makes software easier to modify — refactoring, self-testing code, continuous delivery, and clean architecture. These enabling practices are preconditions for YAGNI to work. Without malleable code, you cannot safely defer decisions, and the practice collapses.

**In short:** Keep the code clean so you *can* add features later. Don't add the features themselves until you need them.

`(see software-tradeoffs -> Flexibility vs. Complexity)`

## The Statistical Case Against Speculation

The strongest argument for YAGNI is empirical: most features fail to deliver value.

**Kohavi et al. (Microsoft, 2009):** Of well-designed, well-executed controlled experiments at Microsoft — features specifically designed to improve a key metric — roughly **one-third succeeded**. Two-thirds of planned features failed to move their target metric in the intended direction.

This pattern holds across companies:
- **Microsoft**: ~1/3 of features improve their target metric
- **Netflix, Etsy, Booking.com**: 10-33% feature success rate across experimentation programs
- **Quicken Loans**: After five years of A/B testing, experts predict test outcomes correctly only ~33% of the time

**The implication:** If features built with data and intent fail two-thirds of the time, features built on speculation have even worse odds. Every presumptive feature is a bet — and the house odds are against you.

> "Experiment often, because under objective measures most ideas fail to improve the key metrics they were designed to improve." — Kohavi et al.

## Speculative Generality Detection

Speculative generality (Fowler/Beck, *Refactoring*) is the code-level manifestation of YAGNI violations. These signals indicate code built for futures that never arrived:

### Detection Signals

| Signal | What to Look For | Refactoring |
|--------|-----------------|-------------|
| **Single-implementation interface** | Interface or abstract class with exactly one concrete implementation | Collapse Hierarchy — inline the interface |
| **Unused extension points** | Hooks, plugin slots, event callbacks wired in but never invoked by production code | Remove Dead Code |
| **Test-only consumers** | Class or method called exclusively from tests, no production path uses it | Delete test, then Remove Dead Code |
| **One-type factory** | Factory method parameterized for multiple types but only ever builds one | Inline Method — call the constructor directly |
| **Unused parameters** | Method parameters never read in the method body | Remove Parameter |
| **Unnecessary delegation** | Class exists solely to pass calls through to another class | Inline Class |
| **Future-oriented naming** | `*Manager`, `*Handler`, `*Processor`, `*Strategy`, `*Factory` where no actual variation exists | Rename or Inline — the name promises generality the code doesn't deliver |

<details>
<summary>Exception: framework and library code</summary>

The single-implementation test does not apply when external extension is the explicit contract. A framework's `Plugin` interface with one built-in implementation is fine — external consumers are the expected second implementation.

Apply the speculative generality test only to application code where you control both the abstraction and all its consumers.
</details>

`(see code-antipatterns -> Premature Antipatterns)`
`(see refactoring-patterns -> Try Delete Then Compile)`

## Build-vs-Not-Build Decision Framework

When someone proposes a new feature, capability, or abstraction, evaluate with this framework:

### Step 1: Requirement Concreteness

```
Is there a concrete requirement today?
├── Yes, from a real user or measured need → Continue to Step 2
├── "We'll probably need it" → STOP. Defer.
├── "Competitor has it" → STOP. Validate with your users first.
└── "It would be cool" → STOP. Build what's needed.
```

### Step 2: Cost of Deferral

```
What's the cost of adding this later?
├── High (schema migration, breaking API change, data loss risk) → Consider building now
├── Medium (refactoring needed but safe with tests) → Defer — the cost is manageable
└── Low (add a function, extend a config) → Definitely defer
```

### Step 3: Codebase Malleability

```
Can the codebase accommodate this change later?
├── Yes (clean architecture, good tests, CI/CD) → Defer safely
├── Partially (some areas rigid, some flexible) → Defer, but invest in enabling practices
└── No (brittle, untested, tightly coupled) → Fix the malleability problem first
```

**If you reach "Consider building now":** You still need data. A concrete requirement + high deferral cost + malleable codebase = build. Anything less = defer and revisit.

## Bloat Antipatterns

Three patterns that produce YAGNI violations at scale:

### Gold Plating

Adding features, polish, or complexity beyond what requirements specify. The developer builds what they find technically interesting rather than what users need.

**Signals:**
- "Just one more feature" that extends into hours of unrequested work
- Spending days making an internal tool look production-quality when two people use it
- Adopting a complex framework for a problem a simple solution would handle
- Unrequested configuration options, UI animations, or visual polish

**Root cause:** Perfectionism or technical curiosity substituting for user requirements.

### Premature Abstraction

Creating interfaces, factories, and extension points before the second use case exists. The abstraction adds indirection with no polymorphism benefit.

**Signals:**
- Every class has a matching interface
- Factory pattern used where direct construction would suffice
- Generic framework built for a single consumer
- Abstract base classes before the second concrete class exists

**The Rule of Three:** Tolerate duplication until you see the pattern three times. Then abstract with confidence — you've seen enough variation to know what the right abstraction looks like.

`(see refactoring-patterns -> Extract Interface)`

### Kitchen Sink

Accumulating features without pruning, so the product grows in every direction without coherence. Every feature request gets a "yes" because saying "no" feels risky.

**Signals:**
- No feature ever gets rejected or deferred
- Feature list grows every sprint, nothing gets removed
- Users struggle to find the features they actually need
- New developer onboarding time increases every quarter
- The "utils" or "helpers" folder is the largest in the project

**Root cause:** Fear of saying "no" combined with lack of data on feature usage.

<details>
<summary>The HiPPO problem</summary>

HiPPO (Highest Paid Person's Opinion) is the failure mode where features are built because a senior stakeholder wants them, not because data supports them. Kohavi et al. found this is the primary driver of wasted feature work. The antidote: run experiments, measure outcomes, let data override authority.

Without experimentation infrastructure, every feature decision is a HiPPO decision — and two-thirds of those decisions produce features that don't move the needle.
</details>

## Checklists

### Planning Phase YAGNI Check

Before adding a feature to the backlog:

- [ ] **Concrete requirement** — A real user needs this, documented with acceptance criteria
- [ ] **Data support** — User research, support tickets, or A/B test results justify the investment
- [ ] **Second use case** — At least two concrete consumers exist or are certain
- [ ] **Cost of deferral assessed** — Adding this later would be significantly harder
- [ ] **Scope bounded** — The feature has clear boundaries, not open-ended

### Code Review YAGNI Check

When reviewing new code:

- [ ] **No single-implementation interfaces** — Every interface has or will soon have multiple implementations
- [ ] **No unused extension points** — Every hook, callback, or plugin slot has a production consumer
- [ ] **No speculative parameters** — Every parameter is used in the method body
- [ ] **No "just in case" code** — Every code path serves a concrete, tested scenario
- [ ] **Abstractions justified** — Each abstraction serves a current need, not a hypothetical one

### "But We Might Need It Later" Response

When someone argues for building speculatively:

1. **Acknowledge** — "That's a valid future scenario"
2. **Quantify** — "What's the probability we'll need it in the next 6 months?"
3. **Cost** — "What does it cost to build now vs. add later?"
4. **Defer** — "Let's document the idea and revisit when we have a concrete trigger"
5. **Enable** — "Let's keep the code clean so adding it later is cheap"

## Decision Tables

### "Is This YAGNI or Good Design?"

| You're considering... | YAGNI violation (don't do it) | Good design (do it) |
|-----------------------|-------------------------------|---------------------|
| Adding an interface | No second implementation exists or is planned | Need testing isolation or a second consumer exists |
| Writing tests | Never a YAGNI violation | Always write tests — tests enable future YAGNI |
| Adding error handling | Handling errors that can't occur in current usage | Handling errors at system boundaries (user input, APIs) |
| Creating an abstraction layer | Wrapping a stable dependency "just in case" | Wrapping a dependency you're likely to replace |
| Adding configuration | Making things configurable that nobody asked to configure | Externalizing values that differ across environments |
| Building a framework | Generalizing before the second use case | Extracting a pattern after seeing it three times |

### "How Likely Is This Feature to Succeed?"

Directional estimates informed by experimentation literature. The ~33% baseline (Kohavi) is measured; other values are heuristic extrapolations.

| Evidence Level | Success Probability | Action |
|---------------|--------------------:|--------|
| A/B test validates the hypothesis | ~60-70% | Build with confidence |
| User research + prototype testing | ~40-50% | Build minimum version, measure |
| Support tickets or direct requests | ~30-40% | Validate with prototype first |
| Competitor has it | ~15-25% | Validate with your users — their needs may differ |
| Internal intuition or HiPPO | ~10-33% | Run an experiment before committing |
| "Someone might want this" | <10% | Don't build. Document and revisit. |

## Common Mistakes

### Confusing YAGNI with Laziness

YAGNI is a discipline, not an excuse. Skipping error handling, avoiding tests, or writing unmaintainable code is not YAGNI — it's negligence. YAGNI says "don't build features you don't need yet." It says nothing about cutting corners on the features you *are* building.

### Applying YAGNI to Enabling Practices

Refactoring, testing, CI/CD, and clean architecture are not features — they're the infrastructure that makes YAGNI possible. Deferring these practices doesn't save time; it makes future additions expensive, which undermines the entire premise of "we can add it later."

### Using YAGNI to Kill Good Ideas

YAGNI is a timing tool, not a rejection tool. "Not now" is different from "never." When you defer a feature, document the idea and its trigger condition. Revisit when concrete evidence arrives. The goal is to build the right thing at the right time, not to build nothing.

## See Also

- **code-antipatterns** — Implementation-level antipatterns (premature abstraction, cargo cult code) that overlap with YAGNI at the code level `(see code-antipatterns -> Premature Antipatterns)`
- **software-tradeoffs** — Build-vs-not-build as a tradeoff category; flexibility vs. complexity as the core YAGNI tension `(see software-tradeoffs -> Core Tradeoffs)`
- **refactoring-patterns** — Techniques for removing speculative generality after detection `(see refactoring-patterns -> Try Delete Then Compile)`
