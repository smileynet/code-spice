---
name: tradeoff
description: Systematic tradeoff analysis for design decisions
allowed-tools: Read, Glob, Grep, AskUserQuestion, Skill
---

## Summary

**Walk through a structured tradeoff analysis for a design decision.** References the `software-tradeoffs` and `code-quality-foundations` skills for evaluation frameworks.

**Arguments:** `$ARGUMENTS` (optional) - Brief description of the design decision

---

## Process

### Step 1: Understand the Decision

**If the user provided a description in `$ARGUMENTS`:**
- Use it as the decision context
- Skip directly to the follow-up questions below

**Otherwise**, use **AskUserQuestion** to gather the decision context:

**Question:** "What design decision are you evaluating?"
**Options:**
- "Architecture choice" — Choosing between patterns, structures, or technologies
- "Implementation approach" — Deciding how to build a specific feature
- "Refactoring direction" — Choosing how to restructure existing code

**Then, in both cases**, ask conversationally:
1. What are the options you're considering? (at least two)
2. What constraints matter most? (team size, timeline, performance, maintainability)
3. What's the expected lifespan of this code? (prototype, long-lived, library)

### Step 2: Identify Relevant Tradeoff Dimensions

From the **software-tradeoffs** skill's Tradeoff Decision Matrix, select which dimensions create real tension for this decision. Not every dimension applies — pick the relevant ones.

Use **AskUserQuestion** to confirm which dimensions apply (multiple selection).

### Step 3: Walk Through Each Dimension

For each selected dimension:

1. **State the tension** for this specific decision
2. **Ask** which direction the context favors (Option A / Option B / "It's a wash")
3. **Note** the answer and reasoning

Reference the **code-quality-foundations** skill for quality pillar impacts.

### Step 4: Present Structured Analysis

```
╔══════════════════════════════════════════════════════════════╗
║  TRADEOFF ANALYSIS                                          ║
╚══════════════════════════════════════════════════════════════╝

DECISION: <brief description>

OPTIONS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Option A: <name>
  Pros:  + ...
  Cons:  - ...

Option B: <name>
  Pros:  + ...
  Cons:  - ...

DIMENSION ANALYSIS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
| Dimension | Favors | Rationale |
|-----------|--------|-----------|

RECOMMENDATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
<Which option and why>
Confidence: <High/Medium/Low>
Key risk: <main thing that could make this wrong>

QUALITY IMPACT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
| Pillar | Impact |
|--------|--------|
```

### Step 5: Offer to Record Decision

Use **AskUserQuestion** to offer recording via `/line:decision`. If yes, invoke `Skill(skill="line:decision")` with context pre-filled.

---

## Example Usage

```
/code:tradeoff
/code:tradeoff Should we use Redis or in-memory caching for session storage?
/code:tradeoff Monorepo vs multi-repo for our microservices
```
