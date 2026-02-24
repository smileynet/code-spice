# Brainstorm: yagni-pruning

> Exploration document from `/line:brainstorm` phase.

**Created:** 2026-02-15
**Status:** Ready for Planning

---

## Problem Statement

### What pain point are we solving?

Codebases accumulate dead weight over time — unused code, speculative features, over-engineered abstractions, and scope that has grown beyond what the project actually needs. Developers (and AI assistants) are biased toward *adding* code but rarely toward *removing* it. There is no structured, curated guidance for identifying and safely eliminating this bloat, nor for preventing it from accumulating in the first place.

Code Spice currently plans skills for building *good* code (quality foundations, readability, refactoring patterns, error handling), but lacks complementary guidance for *removing bad or unnecessary* code. YAGNI is one of the most-cited software principles, yet it's rarely operationalized into actionable detection patterns and removal workflows.

### Who experiences this pain?

- **Developers maintaining growing codebases** — they notice builds getting slower, features taking longer to ship, and new team members taking longer to onboard
- **AI coding assistants** — they lack frameworks to recommend deletion, splitting, or scope reduction; their bias is always to add
- **Tech leads and architects** — they need to make decisions about when a project has outgrown its boundaries and should be split
- **Solo developers** — they lack a second pair of eyes to challenge "do we actually need this?"

### What happens if we don't solve it?

Code Spice teaches developers how to write good code but never how to recognize and remove unnecessary code. This is like teaching someone to cook but never how to clean the kitchen. Without pruning guidance:
- Codebases accumulate "lava flow" — layers of dead code nobody dares touch
- Projects grow in scope until they become unmaintainable monoliths
- Developers spend 15-50% of maintenance effort on code that delivers no value
- AI assistants continue the bias of always adding, never questioning what should be removed

---

## User Perspective

### Primary User

Software developers using Line Cook with Claude Code who want help identifying and safely removing unnecessary code, features, and dependencies from their projects.

### User Context

- Working on codebases that have been growing for months or years
- May have features that were added "just in case" but never used
- May have dead code left over from removed features or refactors
- May have a project whose scope has grown beyond its original purpose
- Want actionable guidance, not just "follow YAGNI" platitudes

### Success Criteria (User's View)

- During `/line:brainstorm`, Claude asks probing questions about whether proposed features are actually needed and whether the project's scope is appropriate
- During `/line:scope`, Claude identifies speculative features and suggests deferring them
- During `/line:architecture-audit`, Claude has concrete checklists for detecting scope bloat, dead code, unnecessary abstractions, and features that should be split into separate projects
- A `/code:prune` command provides interactive, structured analysis of a codebase for removal candidates
- Skills activate automatically when planning involves refactoring, cleanup, maintenance, or scope reduction

---

## Technical Exploration

### Existing Patterns in Code Spice

| Pattern | Location | Relevance |
|---------|----------|-----------|
| `code-antipatterns` skill (planned) | Phase 3 | Overlaps with antipatterns that cause bloat (speculative generality, premature abstraction) |
| `code-deletion-safety` skill (future v0.2.0) | Deferred items in brainstorm | Directly related — covers *when/how* to safely delete code |
| `refactoring-patterns` skill (planned) | Phase 2 | Refactoring sometimes means removing, not just restructuring |
| `software-tradeoffs` skill (planned) | Phase 2 | Tradeoff frameworks apply to build-vs-not-build decisions |
| `/code:smell` command (planned) | Phase 4 | Could detect bloat-related code smells |

### How This Relates to Existing MLP

The YAGNI/pruning epic extends Code Spice in a direction the current MLP doesn't cover. The existing plan focuses on *constructive* guidance (how to build well). This epic adds *subtractive* guidance (what to remove, when to stop building, when to split).

Key relationship decisions:
- **Complements `code-antipatterns`** — antipatterns cause bloat; this epic detects and removes the result
- **Subsumes `code-deletion-safety` (v0.2.0 deferred item)** — deletion safety becomes a component of this broader epic
- **Extends `software-tradeoffs`** — adds "build vs. not build" and "keep vs. remove" as first-class tradeoff categories

### Source Material

**From existing Code Spice books:**
- Five Lines of Code Ch 9 — "Deleting code" (when and how to safely remove code)
- Five Lines of Code Ch 12 — "Making bad code look bad" (identifying code that should be removed)
- Software Mistakes and Tradeoffs Ch 1 — "Code duplication is not always bad" (when NOT to abstract)
- Software Mistakes and Tradeoffs Ch 4 — "Flexibility vs. complexity" (cost of speculative design)
- Good Code, Bad Code Ch 6-7 — Avoiding surprise and misuse (antipatterns that lead to bloat)

**From research (new sources for this epic):**
- Martin Fowler — YAGNI: The four costs of presumptive features (build, delay, carry, repair)
- Meta Engineering — SCARF: Automating dead code cleanup at scale (100M+ lines removed)
- Goldman Sachs — Code relevance management as an organizational practice
- Kent C. Dodds — "Please don't commit commented out code"
- Kohavi et al. — Only 1/3 of planned features actually improve their intended metrics

---

## Research: Best Practices and Antipatterns

### The YAGNI Principle in Practice

**Core insight (Fowler):** Every presumptive feature imposes four costs:
1. **Cost of Build** — Effort spent on a capability that may never be used
2. **Cost of Delay** — Opportunity cost; you're not building the feature that would generate value today
3. **Cost of Carry** — Added complexity that makes *every subsequent change* harder (compounds over time)
4. **Cost of Repair** — When the real requirement arrives, the speculative implementation is almost never right

**Critical distinction:** YAGNI does not mean "skip tests" or "avoid clean code." It applies to *capabilities built for presumptive features*, not to *practices that make code easier to modify* (refactoring, testing, CI). Without malleable code, you'd need to build speculatively because future changes would be too expensive.

**Statistical case:** Research by Kohavi et al. found that even with careful analysis, only one-third of planned features actually improve their intended metrics. Two-thirds are wasted effort or actively harmful.

### Dead Code Detection Approaches

**Static analysis** examines code without running it — builds ASTs/dependency graphs to find definitions with no references. Limitation: cannot detect dynamically invoked code (reflection, eval, string-based dispatch), leading to false positives.

**Dynamic analysis** instruments running code to record which paths are actually executed. Limitation: only observes paths triggered by tests or production traffic; rarely-used code may appear dead.

**Best practice: Combine both.** Meta's SCARF framework deleted 100M+ lines of code by combining static dependency graphs (Glean), runtime logs, and textual reference searches (BigGrep) as a safety net. Key insight: transitioning from individual symbol analysis to complete graph analysis yielded a 50% increase in dead code removed.

### Language-Specific Tools

| Language | Tool | What It Finds |
|----------|------|---------------|
| Python | Vulture, deadcode | Unused imports, variables, functions, classes |
| JS/TS | Knip | Unused files, dependencies, exports, types, enum members |
| JS/TS | depcheck | Unused npm dependencies |
| Java | PMD, Code Inventory | Unused variables, dead methods, runtime-confirmed dead code |
| Go | Grind | Dead code in Go codebases |
| Multi-lang | SonarQube | Code smells, dead code, complexity (35+ languages) |

### Feature Bloat Warning Signs

- Scope keeps expanding beyond the original roadmap without schedule adjustments
- "While we're at it" additions accumulate in MVPs
- No feature ever gets rejected — everything sounds reasonable in isolation
- Users complain about complexity rather than missing features
- Release dates keep slipping with no clear end
- The `utils/` or `helpers/` folder is the largest in the project
- New developers take increasingly longer to become productive

### The Cohesion Test for Project Scope

Apply the Single Responsibility Principle at the *project* level: "Gather together things that change for the same reasons. Separate things that change for different reasons." If a feature serves a different audience, changes on a different cadence, or has a fundamentally different deployment model, it probably does not belong in the same project.

### Antipatterns That Cause Bloat

| Antipattern | Description | Detection Signal |
|-------------|-------------|------------------|
| **Gold Plating** | Polishing or adding features past the point where effort adds value | Features with no user request or business case |
| **Speculative Generality** | Abstractions, interfaces, or extension points "just in case" | Classes/functions whose only consumers are test cases |
| **Premature Abstraction** | Creating interfaces/factories before having two implementations | One-implementation interfaces, factory methods that build one type |
| **Kitchen Sink / Swiss Army Knife** | A module that tries to do everything | `utils.js`, `helpers.py`, `common/` folders that grow without bound |
| **Lava Flow** | Retaining code "nobody is sure if it's still needed" | Code with no recent commits, no test coverage, no documentation |
| **Copy-Paste Divergence** | Duplicated code that evolves independently | Multiple near-identical implementations with slight variations |
| **Commented-Out Code** | Dead code preserved "just in case" | Commented blocks with no accompanying TODO or explanation |

### Metrics and Signals for Bloat

**Quantitative:**
| Metric | What It Indicates |
|--------|-------------------|
| Dead code percentage | Ratio of unreachable/unused code to total |
| Dependency count | Raw number of direct + transitive deps; more = more maintenance + security surface |
| Code coverage (inverse) | Consistently 0% coverage across releases is a strong dead code signal |
| Churn rate (inverse) | Files that never change may be dead or over-abstracted |
| Build/test time trends | Steadily increasing times suggest accumulating unnecessary code |

**Qualitative:**
- "Nobody knows what this does" blocks proliferate
- Features take longer and longer to ship (even with stable team size)
- Bug fixes in one area break unrelated areas (coupling exceeds architecture)
- Multiple features share DB tables or config in ways that create implicit coupling

### Safe Removal Process

1. **Identify candidates** — Static analysis + code coverage + production monitoring
2. **Verify with dynamic data** — Log calls to suspected dead code in production (1-4 weeks, covering monthly/quarterly cycles)
3. **Mark for deprecation** — Use `@Deprecated` annotations or equivalent; build tools alert consumers
4. **Delete, don't comment out** — Version control is your safety net; `git log -G "pattern"` retrieves deleted code
5. **Run tests after removal** — Automated + manual verification
6. **Schedule periodic audits** — Regular dependency and dead code audits, not one-time events

### When to Split a Project

**Split when:**
- Different teams own different parts and step on each other
- Different release cadences (one part needs daily deploys, another is quarterly)
- Different technology requirements (runtimes, languages, scaling)
- Low cohesion — features serve different user personas or business domains
- Build/test times become prohibitive from unrelated changes
- Deployment coupling — deploying a CSS fix requires deploying the DB migration layer

**Don't split when:**
- The project is small and not expected to grow significantly
- A single team owns everything and communicates well
- Boundaries are unclear — premature splitting creates distributed monoliths
- Splitting for ideology rather than concrete pain

**How to split safely:**
1. Model domains first — identify bounded contexts before extraction
2. Use the Strangler Fig pattern — extract least-coupled pieces first, one at a time
3. Minimize cross-boundary dependencies — each piece must be independently releasable
4. Align splits with team boundaries (Conway's Law)

---

## Proposed Skill Organization for This Epic

### New Skills

| Skill | Description | Activation |
|-------|-------------|------------|
| `code-yagni` | YAGNI principle operationalized: the four costs of presumptive features, decision framework for "build vs. not build," speculative generality detection, scope boundary analysis | Brainstorm, Scope |
| `code-pruning` | Dead code detection strategies, safe removal process, dependency pruning, commented-out code elimination, tool recommendations by language | Architecture-Audit, Cook |
| `code-scope-boundaries` | Project scope analysis: cohesion test, split-vs-keep decision framework, feature belonging assessment, scope creep warning signs, project splitting patterns | Brainstorm, Architecture-Audit |

### New Command

| Command | Description | Source Material |
|---------|-------------|----------------|
| `/code:prune` | Interactive codebase pruning analysis. Walks through structured detection of dead code, unused dependencies, speculative abstractions, scope boundary violations, and features that may not belong. Produces a prioritized removal plan. | All YAGNI/pruning skills |

### Relationship to Existing MLP

- **`code-antipatterns` (Phase 3):** Cross-references to YAGNI antipatterns but does not duplicate them. `code-antipatterns` covers implementation-level antipatterns (surprise, misuse, complexity); YAGNI skills cover architectural-level and feature-level antipatterns.
- **`code-deletion-safety` (deferred v0.2.0):** Subsumed by `code-pruning`. No longer a separate future item.
- **`software-tradeoffs` (Phase 2):** Add "build vs. not build" as a referenced tradeoff category via cross-reference to `code-yagni`.
- **`/code:smell` (Phase 4):** Can detect bloat smells; `/code:prune` is the deeper, dedicated analysis.

---

## Risks and Unknowns

### Technical Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Overlap with `code-antipatterns` skill | M | M | Clear scope boundaries; antipatterns = implementation-level, YAGNI = feature/architectural-level |
| `/code:prune` command scope too broad | M | H | Start with static analysis guidance + decision trees; don't try to automate tool invocation in v1 |
| Language-specific tool recommendations go stale | H | L | Keep tool lists as reference, not endorsement; date-stamp recommendations |
| Users expect automated dead code detection | M | M | Be explicit that skills provide frameworks and guidance, not automation |

### Scope Risks

- "Pruning" could expand to cover dependency management, security auditing, performance optimization — needs clear boundaries
- Project splitting guidance could become its own entire skill set — keep it to decision frameworks, not implementation playbooks
- Could tempt adding CI/CD integration for automated pruning — out of scope for a knowledge plugin

### Open Questions

- [ ] Should this be Phase 6 (after existing MLP) or integrated into Phases 2-4 alongside related skills?
- [ ] Should `code-scope-boundaries` be a standalone skill or folded into `code-yagni`?
- [ ] Does the `/code:prune` command belong in this epic or in Phase 4 with other commands?
- [ ] How much language-specific tool guidance should be included vs. kept generic?

---

## Recommended Direction

### Chosen Approach

Create a **new Phase 6: YAGNI & Code Pruning** epic with 3 skills and 1 command, positioned as the "subtractive" complement to the existing "constructive" MLP. This keeps it cleanly separated from the existing plan while establishing cross-references.

### Rationale

The existing MLP (Phases 1-5) is already scoped and partially underway. Adding YAGNI content into existing phases would require re-scoping work that's been finalized. A separate phase:
- Doesn't disrupt the existing plan
- Can be prioritized independently (could be done after Phase 3, before Phase 4, etc.)
- Maintains clear skill boundaries
- Establishes Code Spice's unique value — most code quality tools teach how to write; few teach how to prune

### Suggested Scope

| Scope | Recommendation |
|-------|----------------|
| This epic (Phase 6) | 3 skills (`code-yagni`, `code-pruning`, `code-scope-boundaries`) + 1 command (`/code:prune`). Synthesize from existing book content + research sources |
| Integration | Cross-references to `code-antipatterns`, `software-tradeoffs`, `refactoring-patterns`. Update those skills to point back |
| Deferred | Automated tool integration, CI/CD pipeline recommendations, language-specific supplemental files for pruning tools |

### Source Material Plan

| Source | Content to Extract |
|--------|-------------------|
| Five Lines of Code Ch 9, 12 | Deletion safety, making bad code visible |
| Software Mistakes and Tradeoffs Ch 1, 4 | When not to abstract, flexibility vs. complexity |
| Fowler (YAGNI article) | Four costs framework, YAGNI vs. good design distinction |
| Meta Engineering (SCARF) | Industrial-scale dead code detection approach |
| Goldman Sachs (code relevance) | Organizational practices for code pruning |
| Kent C. Dodds | Commented-out code antipattern |
| Kohavi et al. | Statistical case for YAGNI |
| SRP at project level | Cohesion test for scope boundaries |
| Strangler Fig pattern | Safe project splitting approach |

---

## Next Steps

- [ ] Proceed to `/line:scope` to create structured breakdown
- [ ] Determine phase ordering relative to existing MLP
- [ ] Define skill boundaries between `code-yagni`, `code-pruning`, and `code-scope-boundaries`
- [ ] Identify cross-reference points with existing planned skills
