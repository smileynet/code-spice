---
name: code-yagni
description: YAGNI decision frameworks for evaluating whether to build a feature, detecting speculative generality, and preventing unnecessary feature bloat. Use when planning involves new features, design decisions, or "should we build this" questions during brainstorm, scope, or architecture review. Covers four costs of presumptive features, build-vs-not-build decision framework, speculative generality detection, and bloat antipatterns.
---

# Code YAGNI

## "Should I Build This?" Decision Table

| Evidence | Build It | Don't Build It |
|----------|----------|----------------|
| Concrete user request with measured demand | Yes | — |
| Speculative ("we might need it") | — | Wait for evidence |
| One stakeholder's opinion, no data | — | Validate first |
| Enables a committed near-term deliverable | Yes | — |
| "While we're at it" during adjacent work | — | Separate ticket; evaluate independently |
| Framework/library code (multiple consumers) | Yes (interfaces expected) | — |

## Four Costs of Presumptive Features

| Cost | What It Means | Why It Matters |
|------|--------------|---------------|
| **Build** | Time and effort to implement now | Diverts resources from confirmed requirements |
| **Delay** | Opportunity cost — what else could ship instead | Features have time value; delay erodes ROI |
| **Carry** | Ongoing maintenance, testing, documentation | Every feature is a liability until proven valuable |
| **Repair** | Refactoring when assumptions prove wrong | Wrong abstractions are harder to fix than missing ones |

## Statistical Case Against Speculation

At Microsoft, Kohavi et al. found:
- **~1/3** of features succeeded in improving their target metric
- **~1/3** had neutral results (no measurable impact)
- **~1/3** actually *hurt* the metric they were designed to improve

Similar results at Amazon, Netflix, and other companies with rigorous A/B testing. **The default assumption should be that a feature will fail to deliver value until measured otherwise.**

## Speculative Generality Detection Signals

| Signal | What It Looks Like | Action |
|--------|-------------------|--------|
| Single-implementation interface | `IFooService` with only `FooServiceImpl` | Inline; extract interface when second impl arrives |
| Unused extension points | Plugin registry with one plugin | Remove the registry; add when needed |
| Test-only consumers | Code used only in tests, not production | Likely dead; verify and remove |
| One-type factory | Factory that only creates one type | Replace with direct construction |
| Unused parameters | Parameters passed but never read | Delete (Try Delete Then Compile) |
| Unnecessary delegation | Wrapper that just calls through | Inline the wrapper |
| Future-oriented naming | `V2`, `New`, `Enhanced` prefix/suffix | Rename to describe current behavior |

## Build-vs-Not-Build Decision Framework

```
Step 1: Requirement Concreteness
├── Concrete (user stories, measured demand, committed deliverable)
│   → Proceed to Step 2
├── Speculative ("might need", "just in case", single opinion)
│   → STOP. Don't build. Revisit when evidence appears.
└── No identified users
    → STOP. Apply YAGNI.

Step 2: Cost of Deferral
├── High (security, data integrity, architectural foundation)
│   → Build now — deferral creates larger problems
├── Medium (performance, UX polish)
│   → Build if within current sprint scope; otherwise defer
└── Low (convenience features, edge cases)
    → Defer — build when concrete demand materializes

Step 3: Codebase Malleability
├── Easy to add later (modular, well-tested, clean interfaces)
│   → Defer — you can add it cheaply when needed
└── Hard to add later (tightly coupled, no tests, deep integration)
    → Consider building now if Steps 1-2 support it
```

## "Is This YAGNI or Good Design?"

| Situation | YAGNI (Don't Build) | Good Design (Do Build) |
|-----------|---------------------|----------------------|
| Interface with no second implementation | YAGNI — inline it | Good design if needed for testing now |
| Error handling for unlikely scenario | YAGNI if truly unlikely | Good design if failure is catastrophic |
| Configuration for values that never change | YAGNI — hardcode it | Good design if ops needs runtime control |
| Abstraction over a single dependency | YAGNI if dependency is stable | Good design if dependency may change |
| Performance optimization | YAGNI without profiling data | Good design if measured hot path |

## "How Likely Is This Feature to Succeed?"

| Evidence Level | Estimated Success Rate | Action |
|----------------|----------------------|--------|
| A/B tested with positive results | ~70-80% | Build with confidence |
| Requested by multiple users with data | ~50-60% | Build, but measure |
| Requested by one stakeholder | ~30-40% | Prototype first, validate |
| "We think users will want this" | ~15-25% | Don't build; gather evidence |
| "We might need this someday" | <10% | YAGNI — park it |

## Checklists

### Planning Phase YAGNI Check

- [ ] Every feature has an identified user or measured demand
- [ ] No "just in case" abstractions without a second use case
- [ ] Deferred items are explicitly listed with revisit criteria
- [ ] Build-vs-not-build decision is documented for non-obvious choices

### Code Review YAGNI Check

- [ ] No single-implementation interfaces (unless needed for testing)
- [ ] No unused parameters or extension points
- [ ] No future-oriented naming (`V2`, `New`, `Enhanced`)
- [ ] No factory/registry patterns with a single consumer
