---
name: code-scope-boundaries
description: Project-level scope analysis for evaluating whether a project has exceeded its useful boundaries, needs splitting, or is experiencing scope creep. Use when evaluating project structure, considering whether to split a project, assessing feature belonging, or when projects feel too large or unfocused during brainstorm, scope, or architecture review. Covers cohesion test at project level, feature belonging assessment, scope creep detection, split-vs-keep decision framework, and safe splitting patterns.
---

# Code Scope Boundaries

Frameworks for answering the project-level question: "Has this project outgrown its useful boundaries?" Extends YAGNI thinking from individual features to entire project scope — when adding more features makes the whole less coherent, and when splitting creates more value than staying together.

## Quick Reference

### Scope Health Checklist

Run this during architecture review or when scope feels unclear:

- [ ] **Single mission** — Can you describe the project's purpose in one sentence without "and"?
- [ ] **Cohesive audience** — Do all features serve the same primary user group?
- [ ] **Aligned cadence** — Do features change at roughly the same rate for the same reasons?
- [ ] **Shared deployment** — Do all features benefit from deploying together?
- [ ] **Bounded utils** — Is `utils/`, `helpers/`, or `common/` smaller than any domain folder?
- [ ] **Onboarding stable** — Can a new developer understand the project's scope in their first week?
- [ ] **No orphan features** — Does every feature have an active user or measured usage data?

**If 3+ items fail:** The project may have outgrown its boundaries. Run the split-vs-keep framework below.

### Feature Belonging Quick Test

For any proposed feature:

| Question | Belongs | Doesn't Belong |
|----------|---------|----------------|
| Who uses it? | Same users as existing features | Different user group entirely |
| When does it change? | Same triggers as the core product | Independent triggers, different release cycle |
| How is it deployed? | Same deployment artifact and cadence | Needs separate scaling, uptime, or infrastructure |
| What data does it use? | Same domain entities | Different data domain with minimal overlap |
| Who maintains it? | Same team with shared context | Different team or skill set required |

**If 3+ answers land in "Doesn't Belong":** The feature is a candidate for extraction into a separate project.

## The Cohesion Test

SRP (Single Responsibility Principle) applies at the project level, not just classes. A cohesive project has one reason to exist and one primary axis of change.

### Applying SRP to Projects

| Class-Level SRP | Project-Level SRP |
|-----------------|-------------------|
| "A class should have one reason to change" | "A project should have one mission to serve" |
| Multiple responsibilities → Extract Class | Multiple missions → Extract Project |
| God class antipattern | Kitchen sink project antipattern |
| Single axis of change | Unified user need and deployment model |

### The One-Sentence Test

Describe your project's purpose in a single sentence. If the sentence contains "and" connecting unrelated capabilities, that conjunction is a potential split point.

**Passing examples:**
- "An API gateway that routes, rate-limits, and authenticates incoming requests" (one mission: request handling)
- "A CLI tool that manages dotfiles across platforms" (one mission: configuration management)

**Failing examples:**
- "A platform that handles user authentication **and** generates analytics reports **and** sends marketing emails" (three unrelated missions)
- "A library for parsing CSV files **and** a web dashboard for visualizing the results" (two distinct products)

Each "and" connecting unrelated capabilities is a candidate split point. Not every "and" requires splitting — related capabilities often belong together. The question is whether the capabilities share users, data, and deployment needs.

### Cohesion Dimensions

| Dimension | High Cohesion | Low Cohesion |
|-----------|---------------|--------------|
| **Domain** | All features model the same business domain | Features span unrelated business domains |
| **Data** | Features share the same core entities | Features use independent data sets |
| **User** | One primary user persona | Multiple distinct user groups |
| **Temporal** | Features change together | Features change independently |
| **Deployment** | One deployment unit serves all features | Features need different scaling or uptime guarantees |

**When dimensions diverge:** A project where domain cohesion is high but temporal cohesion is low (features change at different rates) may benefit from splitting. Weigh all five dimensions — no single dimension is decisive.

## Feature Belonging Assessment

When a new feature is proposed, assess whether it belongs in the current project or should be a separate project.

### The Three Lenses

#### 1. Audience Lens

```
Who is the primary user of this feature?
├── Same users as existing features → Likely belongs
├── Subset of current users → Probably belongs, monitor for divergence
├── Different users entirely → Strong signal for separate project
└── No identified users → Stop. Apply YAGNI first.
```

`(see code-yagni -> Step 1: Requirement Concreteness)`

#### 2. Cadence Lens

```
How often and why does this feature change?
├── Same triggers as the core (user feedback, compliance, seasonal)
│   → Belongs — shared rhythm
├── Independent triggers (different market, separate regulations)
│   → Extraction candidate — different rhythm
└── Rarely changes while core changes often (or vice versa)
    → Extraction candidate — mismatched velocity
```

**Why cadence matters:** Features with different change rates impose coordination overhead. The fast-changing feature blocks on the slow one's release cycle, or the stable feature gets destabilized by the active one's changes.

#### 3. Deployment Lens

```
How does this feature need to run?
├── Same infrastructure, same scale → Belongs
├── Needs different scaling (CPU-heavy vs. I/O-heavy) → Extraction candidate
├── Needs different uptime guarantees → Extraction candidate
└── Needs different security boundaries → Extraction candidate
```

### Assessment Matrix

| Audience | Cadence | Deployment | Verdict |
|----------|---------|------------|---------|
| Same | Same | Same | **Belongs** — keep together |
| Same | Different | Same | **Monitor** — may diverge |
| Same | Same | Different | **Extract** — operational needs differ |
| Different | Same | Same | **Extract** — separate user base |
| Different | Different | Different | **Definitely extract** — nothing is shared |

## Scope Creep Warning Signs

Scope creep doesn't announce itself. It accumulates through individually reasonable decisions that collectively blur project boundaries.

### Early Warning Signals

| Signal | What It Looks Like | Why It's Dangerous |
|--------|-------------------|-------------------|
| **"While we're at it"** | Adding features because you're already touching nearby code | Each addition makes the project slightly less focused |
| **Growing utils folder** | `utils/`, `helpers/`, `common/` becomes the largest directory | Shared code that doesn't belong to any domain is a cohesion smell |
| **Expanding audience** | "Sales wants it too" or "let's make it work for partners" | Different users have different needs that pull the project apart |
| **Feature matrix explosion** | Every feature must work with every other feature in every configuration | Combinatorial complexity grows faster than feature count |
| **Onboarding inflation** | New developers need more context each quarter to be productive | The project's mental model exceeds what one person can hold |
| **Deployment coupling** | "We can't release X without also releasing Y" | Unrelated features entangled through shared state or code |

### The Boiling Frog Pattern

Scope creep follows a predictable progression:

1. **Phase 1:** Core product solves one problem well
2. **Phase 2:** Adjacent features added ("natural extensions")
3. **Phase 3:** Unrelated features added ("while we're at it")
4. **Phase 4:** Features serve different users with different needs
5. **Phase 5:** The project has become a platform — intentional or not

Each phase transition feels small. The cumulative effect is a project that serves no audience optimally. Monitor for phase transitions and make conscious decisions about whether to accept them.

### Measurement Heuristics

| Metric | Healthy | Warning | Critical |
|--------|---------|---------|----------|
| **Utils/helpers ratio** | <10% of codebase | 10-25% | >25% — domain boundaries unclear |
| **Cross-feature dependencies** | Rare, well-defined interfaces | Growing, some circular | Pervasive — features can't change independently |
| **New developer productivity** | Productive in days | Productive in weeks | Months before meaningful contributions |
| **Unrelated issue coupling** | Issues affect one feature | Issues span 2-3 features | Most issues touch 4+ features |

## Split-vs-Keep Decision Framework

Splitting a project is expensive. Keeping a bloated project is expensive too. The question is which cost you'd rather pay.

### When to Split

Split when **three or more** of these conditions hold:

| Condition | Evidence |
|-----------|----------|
| **Different teams** own different parts | Code ownership data, PR authors cluster by feature |
| **Different release cadences** | One area deploys daily, another monthly |
| **Independent scaling needs** | One component is CPU-bound, another is I/O-bound |
| **Cascading failures** | A bug in feature A takes down unrelated feature B |
| **Conway's Law misalignment** | Team structure doesn't match code structure |

### When NOT to Split

Do **not** split when:

| Condition | Why Splitting Hurts |
|-----------|-------------------|
| **Shared transactions** | Distributed transactions are orders of magnitude harder than local ones |
| **Tight data coupling** | If features constantly query each other's data, splitting creates a distributed monolith |
| **Small team** | Two people managing two projects adds overhead without autonomy benefit |
| **Premature** | You suspect the boundary but haven't measured the pain |
| **Resume-driven** | "Microservices look good on LinkedIn" is not an architecture decision |

`(see software-tradeoffs -> Architecture: Monolith vs. Microservices)`

### The Split Decision Tree

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

## Safe Splitting Patterns

When the decision is to split, how you split matters as much as whether you split.

### Strangler Fig Pattern

Incrementally replace functionality in the original project by routing traffic to the new project, one feature at a time. Named after the strangler fig tree that grows around its host.

**The process:**
1. **Identify the boundary** — Pick a feature with clear inputs and outputs
2. **Build the replacement** — New project implements the feature independently
3. **Route incrementally** — Redirect traffic or requests to the new project
4. **Verify** — Confirm the new project handles all cases
5. **Remove the original** — Delete the feature from the old project

**Why it works:** No big-bang migration. Each step is reversible. The old system continues to serve requests until the new one proves itself.

**When to use:** Large projects where a full rewrite is too risky. The alternative (rewrite from scratch) fails more often than it succeeds.

### Domain-Driven Splitting

Split along domain boundaries, not technical layers. A split that separates "users" from "orders" is more stable than one that separates "frontend" from "backend."

**Identifying domain boundaries:**
- **Bounded contexts** — Areas where terms have distinct meanings (a "user" in auth vs. billing)
- **Aggregate roots** — Entities that are always loaded together
- **Event boundaries** — Where synchronous calls can become asynchronous events

**Why technical-layer splits fail:** Separating "frontend" from "backend" or "API" from "database" creates tight coupling across the split. A feature change requires coordinating across both projects. Domain splits keep each project self-contained for its business area.

### Conway's Law Alignment

> "Organizations which design systems are constrained to produce designs which are copies of the communication structures of these organizations." — Melvin Conway

**Use Conway's Law deliberately:**
- **Team per project** — If you split a project, ensure each part has a dedicated team
- **Communication structure = API** — The interfaces between projects mirror the communication between teams
- **Inverse Conway Maneuver** — Restructure teams to get the architecture you want

**Warning:** Splitting a project without splitting the team creates a distributed monolith — the worst of both worlds. Same coordination overhead, plus network latency and partial failure modes.

## Decision Tables

### "Should I Split This Project?"

| Your situation | Recommendation |
|---------------|----------------|
| One team, features cohesive, shared data | **Don't split** — improve internal organization |
| One team, features diverging, shared deployment | **Internal boundaries** — modules or packages, not projects |
| Multiple teams, shared codebase friction | **Split along team boundaries** — Conway's Law |
| Independent scaling needs | **Extract the bottleneck** — Strangler Fig pattern |
| Cascading failures across features | **Isolate failure domains** — split for resilience |
| "It's getting big" but no measured pain | **Don't split** — size alone is not a reason |

### "Is This Scope Creep or Natural Growth?"

| Indicator | Natural Growth | Scope Creep |
|-----------|---------------|-------------|
| **User request** | From primary audience | From a different user group |
| **Domain fit** | Same business domain | Adjacent or unrelated domain |
| **Data model** | Uses existing entities | Requires new, unrelated entities |
| **Team expertise** | Existing team can build it | Requires different skill set |
| **Deployment** | Ships with existing cadence | Needs different infrastructure |

## Common Mistakes

### Splitting Too Early

The most expensive mistake is splitting before you understand the domain. Getting boundaries wrong means either merging projects later (painful, politically difficult) or living with the wrong boundaries (distributed monolith).

**Guideline:** If you can't clearly name each project's single responsibility, you don't know enough to split.

### Splitting Along Technical Layers

Separating "frontend" from "backend" or "API" from "database" creates tight coupling across the split. A feature change requires coordinating across both projects. Split along domain boundaries instead — each project owns its full technical stack for its domain.

### Ignoring Data Coupling

Two projects that constantly query each other's databases are a distributed monolith with extra latency. Before splitting, map the data access patterns. If features share the same core tables, they probably belong together.

### Using Size as the Only Signal

A large, cohesive project is better than three small, tightly coupled ones. Size correlates with scope problems but doesn't cause them. A 100k-line project with clear internal boundaries and one mission is healthier than a 20k-line project serving three different user groups.

## See Also

- **code-yagni** — Feature-level YAGNI decisions that prevent scope creep at the source `(see code-yagni -> Build-vs-Not-Build Decision Framework)`
- **software-tradeoffs** — Monolith vs. microservices tradeoff analysis for when you're considering splitting `(see software-tradeoffs -> Architecture: Monolith vs. Microservices)`
