# Brainstorm: code-spice

> Exploration document from `/line:brainstorm` phase.

**Created:** 2026-02-13
**Status:** Ready for Planning

---

## Problem Statement

### What pain point are we solving?

AI coding assistants (Claude Code, etc.) lack structured, curated knowledge about software engineering best practices and antipatterns. When planning or reviewing code, they rely on general training data rather than distilled, book-quality expertise. There's no mechanism to inject domain-specific coding wisdom into the Line Cook planning workflow the way game-spice injects game design expertise.

### Who experiences this pain?

Developers using Line Cook for AI-assisted development. They benefit from the workflow guardrails but miss out on deep code quality guidance during brainstorm, scope, and audit phases. Both junior developers (who don't know the patterns) and senior developers (who want a structured checklist) benefit.

### What happens if we don't solve it?

Line Cook's planning phases remain generic for software projects. Developers don't get prompted about refactoring patterns, error handling strategies, code review practices, or common software tradeoffs during planning. The `/line:architecture-audit` and `/line:plan-audit` commands lack code-quality-specific guidance.

---

## User Perspective

### Primary User

Software developers using Line Cook with Claude Code for any non-game coding project. The broadest possible audience within the Line Cook ecosystem.

### User Context

- Working on codebases in various languages (TypeScript, Python, Rust, Java, Go, etc.)
- Using Line Cook's planning workflow (`/mise` -> `/prep` -> `/cook` -> `/serve` -> `/tidy`)
- May or may not have read the source books
- Want actionable guidance, not academic theory

### Success Criteria (User's View)

- During `/line:brainstorm`, Claude surfaces relevant code quality frameworks and asks better questions about error handling strategies, abstraction layers, and design tradeoffs
- During `/line:scope`, Claude applies refactoring patterns and identifies antipatterns in proposed designs
- During `/line:plan-audit` and `/line:architecture-audit`, Claude has concrete checklists and scorecards for code quality assessment
- Skills activate automatically based on project context (e.g., "refactoring", "API design", "error handling")

---

## Technical Exploration

### Existing Patterns in Codebase

| Pattern | Location | Relevance |
|---------|----------|-----------|
| Spice plugin structure | `game-spice/.claude-plugin/plugin.json` | Exact template to follow |
| SKILL.md format | `game-spice/skills/*/SKILL.md` | Frontmatter + markdown knowledge |
| Keyword activation | SKILL.md description fields | How skills get loaded during workflow |
| Supplemental files | `game-spice/skills/game-plan-audit/questionnaires.md` | Pattern for splitting large skills |
| Cross-skill references | `(see game-X -> Section)` format | Consistent linking pattern |
| `<details>` progressive disclosure | All game-spice skills | Pattern for keeping skills scannable |
| Decision tables | Multiple game-spice skills | Actionable quick-reference format |
| Marketplace registration | `line-cook/.claude-plugin/marketplace.json` | How spices are discovered |

### External Approaches Researched

| Approach | Source | Trade-offs |
|----------|--------|------------|
| Book-per-skill | One skill per book | Simple but loses cross-cutting themes |
| Topic-per-skill | One skill per topic area | Better synthesis, matches user mental model |
| Workflow-per-skill | One skill per Line Cook phase | Mirrors game-spice but forces artificial grouping |

### Constraints from Architecture

- Skills must fit within Claude's context window (~800 token target per skill when loaded during `/cook`)
- SKILL.md frontmatter `description` field controls keyword activation
- Skills are pure knowledge (no commands, no agents)
- Cross-references use `(see code-X -> Section)` format
- Plugin requires `.claude-plugin/plugin.json` with name `code-spice`

---

## Source Material Analysis

### Priority Books (MLP)

**1. Good Code, Bad Code** (Tom Long, 2021) - Java-like pseudocode
- Part 1 (Theory): Code quality pillars, layers of abstraction, code contracts, error handling
- Part 2 (Practice): Readability, avoid surprises, make code hard to misuse, modularity, reusability
- Part 3: Unit testing principles and practices
- **Key contribution:** Foundational quality pillars, practical "do this, not that" guidance

**2. Five Lines of Code** (Christian Clausen, 2021) - TypeScript
- Part 1: Refactoring through a game project (functions, type codes, duplication, data defense)
- Part 2: Real-world refactoring philosophy (compiler collaboration, deleting code, avoiding premature optimization, making bad code look bad)
- Catalog: 13 named refactoring patterns with identifiers (P3.2.1, P4.1.3, etc.)
- **Key contribution:** Concrete refactoring catalog, rule-based refactoring triggers

**3. Software Mistakes and Tradeoffs** (Lelek & Skeet, 2022) - Java
- Duplication vs flexibility, exceptions vs other error patterns, flexibility vs complexity
- Premature optimization vs hot path, API simplicity vs maintenance
- Date/time, data locality, third-party libraries, distributed systems
- Versioning, consistency, delivery semantics
- **Key contribution:** Tradeoff decision frameworks, "it depends" with structured reasoning

**4. Looks Good to Me** (Braganza, 2025) - Language-agnostic
- Part 1: Code review foundations, dissecting reviews, building processes
- Part 2: Team Working Agreements, automation, effective comments
- Part 3: Review dilemmas (delays, loopholes, emergencies)
- Part 4: Reviews + pair programming, mob programming, AI
- **Key contribution:** Code review as a practice, modern AI-augmented review

### Language Coverage Reference

| Book | Primary Language | Other Languages Shown |
|------|-----------------|----------------------|
| Good Code, Bad Code | Java-like pseudocode | C#, Kotlin (mentioned) |
| Five Lines of Code | TypeScript | N/A |
| Software Mistakes and Tradeoffs | Java | SQL, distributed systems concepts |
| Looks Good to Me | Language-agnostic | Various in examples |

**Backfill targets (future versions):** Python, Rust, Go, C++

---

## Proposed Skill Organization

### MLP Skills (v0.1.0) - 10 topic-based skills

| Skill | Primary Sources | Workflow Activation |
|-------|----------------|---------------------|
| `code-quality-foundations` | GC/BC Ch 1-2, SM&T Ch 1 | Brainstorm, Scope |
| `code-readability` | GC/BC Ch 5, FLoC Ch 8,13 | Scope, Cook |
| `code-naming` | GC/BC Ch 5.1,5.6-5.7, FLoC Ch 8, SM&T | Scope, Cook |
| `refactoring-patterns` | FLoC entire book (core) | Scope, Cook |
| `error-handling-patterns` | GC/BC Ch 4, SM&T Ch 3 | Scope, Cook |
| `code-antipatterns` | GC/BC Ch 6-7, FLoC Ch 12, SM&T | Scope, Plan-Audit |
| `code-review` | LGTM entire book | Serve, Cook |
| `software-tradeoffs` | SM&T entire book | Brainstorm, Scope |
| `code-testing-quality` | GC/BC Ch 10-11 | Cook (enhances taster agent) |
| `code-plan-audit` | Synthesized from all books | Plan-Audit |

### MLP Commands (v0.1.0) - 3 new commands

| Command | Description | Source Material |
|---------|-------------|---------------|
| `/code:tradeoff` | Interactive tradeoff analysis dialog. Walk through structured decision framework for design choices (duplication vs flexibility, simplicity vs extensibility, etc.) | SM&T entire book |
| `/code:smell` | Structured code smell detection on recent changes. Implementation-level antipattern scan with book-sourced checklist | GC/BC Ch 6-7, FLoC Ch 12, SM&T |
| `/code:review-prep` | Self-review preparation before `/serve`. Generate a context-aware checklist from code review best practices | LGTM entire book |

### MLP Agent (v0.1.0) - 1 new agent

| Agent | Phase | Role |
|-------|-------|------|
| **code-quality-critic** | Serve | Enhanced reviewer that applies book-sourced antipattern detection and code quality checklists during `/line:serve` |

### Future (v0.2.0+)

| Item | Type | Sources | Notes |
|------|------|---------|-------|
| `code-architecture-audit` | Skill | SM&T architecture chapters | Architecture review |
| `api-design` | Skill | SM&T Ch 6, 12 + GC/BC Ch 2-3 | API contracts and versioning |
| `code-modularity` | Skill | GC/BC Ch 2, 8 + SM&T Ch 4 | Abstraction layers, modularity |
| `code-deletion-safety` | Skill | FLoC Ch 9 | When/how to safely delete code |
| `dependency-decisions` | Skill | SM&T Ch 9, 13 | Third-party library evaluation |
| Language-specific supplementals | Files | All books | `typescript.md`, `java.md`, etc. |

---

## Technical Approaches Considered

### Option A: Topic-based skills (Recommended)

**Description:** Organize skills by topic area (readability, refactoring, error handling, etc.), synthesizing across all source books for each topic.

**Pros:**
- Matches how developers think about problems ("I need help with error handling")
- Avoids duplication when multiple books cover the same topic
- Natural keyword activation (topic names are searchable terms)
- Each skill is self-contained for its domain

**Cons:**
- Requires careful synthesis across books (more authoring effort)
- May lose some book-specific nuance

**Effort:** Medium

### Option B: Book-per-skill

**Description:** One skill per source book, preserving each book's structure and perspective.

**Pros:**
- Simpler to create (extract from one source)
- Preserves author's original structure and voice

**Cons:**
- Massive overlap between skills (multiple books cover readability, errors, etc.)
- Skills would be too large (an entire book's knowledge in one file)
- Doesn't match how users think about problems

**Effort:** Low (but lower quality)

### Option C: Workflow-phase-per-skill

**Description:** Organize skills by Line Cook workflow phase (brainstorm knowledge, scope knowledge, audit knowledge).

**Pros:**
- Direct mapping to when skills activate
- Mirrors game-spice organization somewhat

**Cons:**
- Forces artificial grouping (readability matters in scope AND audit)
- Many topics span multiple phases
- Harder to find specific knowledge

**Effort:** Medium

---

## Risks and Unknowns

### Technical Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Skills too large for context window | M | H | Target ~200-400 lines per skill, use `<details>` for progressive disclosure |
| Poor keyword activation | M | M | Test activation during real workflows, iterate on descriptions |
| Content overlap between skills | L | M | Explicit cross-references, clear scope boundaries per skill |
| PDF extraction misses key content | M | M | Multiple reading passes, supplement with epub and research |

### Dependency Risks

- Depends on Line Cook's plugin system remaining stable
- Marketplace registration requires PR to line-cook repo (separate step)

### Scope Risks

- 12+ books in uploads folder could tempt scope creep beyond MLP
- "Validate + fill gaps" research could expand indefinitely per topic
- Some books (SICP, CSAPP) are very different in nature from the code quality focus

### Open Questions

- [x] Organization approach: **Topic-based** (decided)
- [x] MLP scope: **4 code quality books** (decided)
- [x] Language approach: **Capture from books + reference file for backfill** (decided)
- [x] Research depth: **Validate + fill gaps** (decided)
- [ ] Should `code-review` skill include AI-specific review guidance from LGTM Ch 13? (likely yes, very relevant to Line Cook users)
- [ ] Should `software-tradeoffs` include distributed systems chapters from SM&T, or save for a future `distributed-systems` skill?

---

## Recommended Direction

### Chosen Approach

**Topic-based skills (Option A)**, starting with 8 skills synthesized from 4 code quality books, augmented with web research to validate concepts and fill gaps.

### Rationale

Topic-based organization best matches the developer mental model. When a user is planning error handling for their project, they want all the error handling knowledge in one place, not scattered across four book-specific skills. This mirrors how game-spice organizes by topic (economy design, difficulty design) rather than by source material.

### Suggested Scope

| Scope | Recommendation |
|-------|----------------|
| MLP (v0.1.0) | 10 skills + 3 commands + 1 agent from 4 code quality books. Full plugin (not just spice). Language examples from books + backfill reference file |
| Full Feature (v0.2.0) | Add architecture-audit, api-design, modularity, deletion-safety, dependency-decisions skills; begin language-specific supplemental files |
| Epic (v0.3.0+) | Incorporate remaining 8+ books (SICP, Grokking series, Vibe Coding, etc.); full language coverage |

### Deferred Items

- Books outside MLP scope (Grokking series, SICP, CSAPP, C++ Crash Course, Hands-On Rust, Think Like a Programmer, The Creative Programmer, Vibe Coding)
- Language-specific supplemental files (beyond what's in the source books)
- Tutorial/walkthrough document (like game-spice's `docs/tutorial.md`)
- Release automation (dev/release.py, GitHub Actions)

---

## Next Steps

- [ ] Proceed to `/line:scope` to create structured breakdown
- [ ] Deep-read each book's key chapters for content extraction
- [ ] Research current industry practices to validate and supplement
