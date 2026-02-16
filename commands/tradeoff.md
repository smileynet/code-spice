---
description: Systematic tradeoff analysis for design decisions
allowed-tools: Read, Glob, Grep, AskUserQuestion, Skill
---

## Summary

**Walk through a structured tradeoff analysis for a design decision.** Uses dimensions from the software-tradeoffs skill and code-quality-foundations to help you evaluate options systematically.

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

From the **software-tradeoffs** skill, select which dimensions are relevant to this decision. Not every dimension applies to every decision — pick the ones that create real tension.

**Tradeoff Dimensions Catalog:**

| Dimension | Tension | When It Matters |
|-----------|---------|-----------------|
| **Duplication vs DRY** | Removing duplication vs avoiding wrong abstractions | Shared logic across modules, utility extraction |
| **Flexibility vs complexity** | Supporting future changes vs keeping code simple now | Extension points, plugin systems, configuration |
| **Simplicity vs extensibility** | Minimal code vs designing for growth | New features, API design, data models |
| **Performance vs readability** | Optimized execution vs clear intent | Hot paths, data processing, algorithms |
| **Build vs buy** | Custom solution vs third-party dependency | Libraries, services, infrastructure |
| **Consistency vs availability** | Data correctness vs system uptime | Distributed systems, caching, eventual consistency |

Use **AskUserQuestion** to confirm which dimensions apply:

**Question:** "Which tradeoff dimensions are relevant to this decision?"
Present the dimensions with descriptions, allowing multiple selection.

### Step 3: Walk Through Each Dimension

For each selected dimension, ask targeted questions to surface the tradeoff:

**Template per dimension:**

1. **State the tension:** Explain what pulls in each direction for this specific decision
2. **Ask:** "For [dimension], which direction does your context favor?"
   - Option A (one side of the tradeoff) — with brief rationale
   - Option B (other side) — with brief rationale
   - "It's a wash" — this dimension doesn't differentiate the options
3. **Note the answer** and any reasoning the user provides

Reference the **code-quality-foundations** skill for quality pillar impacts — how does each direction affect readability, modularity, testability, etc.

### Step 4: Present Structured Analysis

After walking through all relevant dimensions, produce the analysis with pros and cons for each option:

```
╔══════════════════════════════════════════════════════════════╗
║  TRADEOFF ANALYSIS                                          ║
╚══════════════════════════════════════════════════════════════╝

DECISION: <brief description of the decision>

OPTIONS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Option A: <name>
  Pros:
    + <advantage 1>
    + <advantage 2>
  Cons:
    - <disadvantage 1>
    - <disadvantage 2>

Option B: <name>
  Pros:
    + <advantage 1>
    + <advantage 2>
  Cons:
    - <disadvantage 1>
    - <disadvantage 2>

DIMENSION ANALYSIS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

| Dimension              | Favors     | Rationale                    |
|------------------------|------------|------------------------------|
| <dimension 1>          | Option A/B | <why>                        |
| <dimension 2>          | Option A/B | <why>                        |
| <dimension 3>          | Neutral    | <why>                        |

RECOMMENDATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

<Which option and why, given the context and constraints>

Confidence: <High/Medium/Low>
Key risk: <the main thing that could make this the wrong choice>

QUALITY IMPACT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

| Pillar        | Impact of recommendation |
|---------------|--------------------------|
| Readable      | <positive/neutral/negative — brief note> |
| Modular       | <positive/neutral/negative — brief note> |
| Testable      | <positive/neutral/negative — brief note> |
```

### Step 5: Offer to Record Decision

After presenting the analysis, offer to persist the decision:

Use **AskUserQuestion**:

**Question:** "Would you like to record this as an architecture decision?"
**Options:**
- "Yes, record via /line:decision" — Invoke `/line:decision` to create an ADR
- "No, analysis is sufficient" — Stop here

If the user chooses to record, invoke `Skill(skill="line:decision")` with the decision context pre-filled from the analysis.

---

## Example Usage

```
/code:tradeoff
/code:tradeoff Should we use Redis or in-memory caching for session storage?
/code:tradeoff Monorepo vs multi-repo for our microservices
```
