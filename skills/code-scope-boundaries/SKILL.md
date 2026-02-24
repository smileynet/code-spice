---
name: code-scope-boundaries
description: Project-level scope analysis for evaluating whether a project has exceeded its useful boundaries, needs splitting, or is experiencing scope creep. Use when evaluating project structure, considering whether to split a project, assessing feature belonging, or when projects feel too large or unfocused during brainstorm, scope, or architecture review. Covers cohesion test at project level, feature belonging assessment, scope creep detection, split-vs-keep decision framework, and safe splitting patterns.
---

# Code Scope Boundaries

## Scope Health Checklist

Run this during architecture review or when scope feels unclear:

- [ ] **Single mission** — Can you describe the project's purpose in one sentence without "and"?
- [ ] **Cohesive audience** — Do all features serve the same primary user group?
- [ ] **Aligned cadence** — Do features change at roughly the same rate for the same reasons?
- [ ] **Shared deployment** — Do all features benefit from deploying together?
- [ ] **Bounded utils** — Is `utils/`, `helpers/`, or `common/` smaller than any domain folder?
- [ ] **Onboarding stable** — Can a new developer understand the project's scope in their first week?
- [ ] **No orphan features** — Does every feature have an active user or measured usage data?

**If 3+ items fail:** The project may have outgrown its boundaries. Run the split-vs-keep framework below.

## Feature Belonging Quick Test

| Question | Belongs | Doesn't Belong |
|----------|---------|----------------|
| Who uses it? | Same users as existing features | Different user group entirely |
| When does it change? | Same triggers as the core product | Independent triggers, different release cycle |
| How is it deployed? | Same deployment artifact and cadence | Needs separate scaling, uptime, or infrastructure |
| What data does it use? | Same domain entities | Different data domain with minimal overlap |
| Who maintains it? | Same team with shared context | Different team or skill set required |

**If 3+ answers land in "Doesn't Belong":** The feature is a candidate for extraction.

## The One-Sentence Test

Describe your project's purpose in a single sentence. If the sentence contains "and" connecting unrelated capabilities, that conjunction is a potential split point. Related capabilities often belong together — the question is whether they share users, data, and deployment needs.

## The Boiling Frog Pattern

Scope creep follows a predictable progression:

1. **Phase 1:** Core product solves one problem well
2. **Phase 2:** Adjacent features added ("natural extensions")
3. **Phase 3:** Unrelated features added ("while we're at it")
4. **Phase 4:** Features serve different users with different needs
5. **Phase 5:** The project has become a platform — intentional or not

Each phase transition feels small. Monitor for transitions and make conscious decisions about whether to accept them.

## Scope Creep Measurement

| Metric | Healthy | Warning | Critical |
|--------|---------|---------|----------|
| **Utils/helpers ratio** | <10% of codebase | 10-25% | >25% — domain boundaries unclear |
| **Cross-feature dependencies** | Rare, well-defined interfaces | Growing, some circular | Pervasive — features can't change independently |
| **New developer productivity** | Productive in days | Productive in weeks | Months before meaningful contributions |
| **Unrelated issue coupling** | Issues affect one feature | Issues span 2-3 features | Most issues touch 4+ features |

## Split-vs-Keep Decision Tree

```
Are different teams blocked by shared codebase?
├── Yes → Split along team boundaries (Conway's Law)
└── No
    Does the project need different scaling for different features?
    ├── Yes → Extract the differently-scaled component
    └── No
        Are cascading failures affecting unrelated features?
        ├── Yes → Split to isolate failure domains
        └── No
            Is onboarding time growing beyond acceptable?
            ├── Yes → Consider splitting, but check if better
            │         internal organization helps first
            └── No → Don't split. Improve internal boundaries instead.
```

## "Should I Split This Project?"

| Your situation | Recommendation |
|---------------|----------------|
| One team, features cohesive, shared data | **Don't split** — improve internal organization |
| One team, features diverging, shared deployment | **Internal boundaries** — modules or packages, not projects |
| Multiple teams, shared codebase friction | **Split along team boundaries** — Conway's Law |
| Independent scaling needs | **Extract the bottleneck** — Strangler Fig pattern |
| Cascading failures across features | **Isolate failure domains** — split for resilience |
| "It's getting big" but no measured pain | **Don't split** — size alone is not a reason |

## "Is This Scope Creep or Natural Growth?"

| Indicator | Natural Growth | Scope Creep |
|-----------|---------------|-------------|
| **User request** | From primary audience | From a different user group |
| **Domain fit** | Same business domain | Adjacent or unrelated domain |
| **Data model** | Uses existing entities | Requires new, unrelated entities |
| **Team expertise** | Existing team can build it | Requires different skill set |
| **Deployment** | Ships with existing cadence | Needs different infrastructure |
