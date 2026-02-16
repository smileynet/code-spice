---
name: code-plan-audit
description: Plan quality auditing with completeness scorecard, antipattern risk detection, and readiness checks. Use when auditing implementation plans, evaluating plan completeness, checking error handling strategy, assessing naming and readability pre-checks, reviewing testing strategy, evaluating tradeoff documentation, or running plan-audit on a software project. Covers the 10-point completeness scorecard, code quality pre-checks, antipattern risk assessment, and build-readiness decision.
---

# Code Plan Audit

Audit implementation plans for completeness, quality risks, and build readiness. Catches gaps that lead to rework, missed requirements, and architectural dead ends.

## Quick Reference

### Plan Completeness Scorecard

| # | Check | Severity | Cross-Reference |
|---|-------|----------|-----------------|
| 1 | Problem clearly stated with concrete requirements | Critical | `(see code-quality-foundations -> Code Should Work)` |
| 2 | Acceptance criteria are testable (not vague adjectives) | Critical | `(see code-testing-quality -> What to Test vs. What Not to Test)` |
| 3 | Error handling strategy defined (propagate, recover, or fail) | Critical | `(see code-antipatterns -> Silent Failure)` |
| 4 | Key tradeoffs identified and documented | Warning | `(see code-quality-foundations -> Tradeoff Thinking)` |
| 5 | Testing strategy chosen (unit/integration/E2E proportions) | Warning | `(see code-testing-quality -> The Test Pyramid)` |
| 6 | Dependencies and integration points identified | Warning | `(see code-quality-foundations -> Make Code Modular)` |
| 7 | Naming conventions and readability approach consistent | Warning | `(see code-quality-foundations -> Make Code Readable)` |
| 8 | Security boundaries identified (input validation, auth, data exposure) | Warning | `(see code-review -> Review Goals)` |
| 9 | Scope bounded — deferred items explicitly listed | Note | `(see code-antipatterns -> Premature Abstraction)` |
| 10 | Existing solutions checked (libraries, shared code, prior art) | Note | `(see code-quality-foundations -> Code Should Not Reinvent the Wheel)` |

**Scoring:** 10/10 = ready to build. 7-9 = minor gaps, address before starting. 4-6 = return to planning. <4 = needs fundamental design work.

### Actionability Tests

Five tests every plan item must pass before implementation:

| Test | Method | Pass Criteria |
|------|--------|---------------|
| **Verb Test** | Does every task contain implementation verbs? | Active verbs (create, validate, transform), not vague ("handle", "manage", "deal with") |
| **Scope Test** | Can you estimate effort for each task? | Clear boundaries — you know when each task is done |
| **Test Test** | Can you write a test from the description? | Testable acceptance criteria, not adjectives ("fast", "clean", "robust") |
| **Dependency Test** | Are inter-task dependencies explicit? | Clear ordering — no hidden assumptions about what runs first |
| **Edge Case Test** | Are boundary conditions and error paths mentioned? | At least: empty input, invalid input, concurrent access (if applicable) |

## Code Quality Pre-Checks

Evaluate the plan against quality pillars before writing code. These checks are faster and cheaper than fixing quality failures after implementation.

### Readability Pre-Check

| Signal | Question | If No -> |
|--------|----------|---------|
| Naming intent | Does the plan use domain-specific names (not generic "data", "item", "thing")? | Clarify domain vocabulary before coding |
| Layer clarity | Are abstraction layers described (API, business logic, data access)? | Define boundaries before coding |
| Single responsibility | Can each component be described in one sentence without "and"? | Split components |

`(see code-quality-foundations -> Make Code Readable, Layers of Abstraction)`

### Error Handling Strategy Check

| Question | If Missing -> |
|----------|-------------|
| Which errors are expected vs. unexpected? | Define: "not found" is expected; "DB down" is unexpected |
| Where are system boundaries (user input, external APIs, file I/O)? | Map validation points |
| What's the recovery strategy for each failure mode? | Decide: retry, fallback, propagate, or fail fast |
| Are error messages actionable for the caller? | Plan error types and messages |

`(see code-antipatterns -> Silent Failure, Unexpected Side Effects)`

### Modularity Pre-Check

| Signal | Question | If No -> |
|--------|----------|---------|
| Single concern | Does each module/class handle one distinct problem? | Reassess responsibilities |
| Dependency direction | Do dependencies flow one way (high-level -> low-level)? | Identify circular risks |
| Interface boundaries | Are public APIs defined separately from implementation? | Design contracts first |
| Testability | Can each component be tested without complex setup? | Redesign for dependency injection |

`(see code-quality-foundations -> Make Code Modular, Make Code Testable)`

## Antipattern Risk Assessment

Scan the plan for patterns that predict quality failures during implementation.

### Plan-Level Antipatterns

| Antipattern | Symptom in Plan | Severity | Fix |
|-------------|----------------|----------|-----|
| **The Fog** | Adjectives without verbs ("robust auth", "clean API") | Critical | Every feature needs concrete implementation verbs |
| **The Wishlist** | Describes the final vision, no phased delivery | Warning | Define what's built first, park the rest |
| **The Monolith** | Everything in one component, no separation | Warning | Identify distinct concerns and boundaries |
| **The Oracle** | Assumes perfect knowledge of future requirements | Warning | Design for current needs with generally applicable techniques |
| **The Clone** | "Like X but..." without understanding X's design decisions | Warning | Identify specific patterns to adopt, not just the product |
| **Missing Error Story** | Happy path only — no error handling, no edge cases | Critical | Add error scenarios for each integration point |

### Implementation Risk Signals

Scan the plan for these signals that predict specific antipatterns during coding:

| Plan Signal | Predicts | Prevention |
|-------------|----------|------------|
| No domain types mentioned | Primitive obsession | Plan dedicated types for constrained values |
| "Handle errors" without specifics | Silent failure | Define error categories and recovery per boundary |
| Single class/module for multiple concerns | God object | Split responsibilities before coding |
| "Optimize for performance" without metrics | Premature optimization | Define performance targets with measurement plan |
| Interface defined before second use case | Premature abstraction | Start concrete, extract interface when needed |
| Same logic referenced in multiple plan sections | Shotgun surgery risk | Centralize into single source of truth |

`(see code-antipatterns -> Severity Classification, Pattern Recognition)`

## Testing Strategy Evaluation

Verify the plan includes a testing approach proportional to the risk.

### Test Strategy Completeness

| Check | Question | If Missing -> |
|-------|----------|-------------|
| Test level | Unit, integration, or E2E — which and why? | Default: unit for logic, integration for boundaries |
| Test double strategy | Real objects, stubs, mocks, or fakes — where? | Default: real objects internal, fakes at boundaries |
| Edge cases | Nulls, empty collections, boundaries, error paths? | List at least 3 edge cases per public function |
| Coverage target | What percentage, and of what? | Default: >80% of critical business logic paths |
| Regression plan | How do you verify existing behavior still works? | Run full test suite; add tests for touched code |

### Test Strategy Red Flags

| Red Flag | Problem | Fix |
|----------|---------|-----|
| "We'll add tests later" | Tests never get added; untested code ships | Write test plan alongside implementation plan |
| "100% coverage" as goal | Leads to testing trivial code, missing meaningful coverage | Target critical paths, not line count |
| No integration tests planned | Unit tests pass but components don't work together | Plan integration tests at every boundary |
| Mock-heavy strategy | Tests coupled to implementation, break on refactoring | Prefer real objects internal, fakes at boundaries |
| No test for error paths | Happy path works, errors silently fail | Every error handling branch needs a test |

`(see code-testing-quality -> The Test Pyramid, Testing Antipatterns)`

## Tradeoff Documentation Check

Plans that don't document tradeoffs create knowledge silos — future developers (including your future self) won't understand *why* decisions were made.

### Minimum Tradeoff Documentation

For each significant design decision, the plan should include:

| Element | Question | Example |
|---------|----------|---------|
| **Decision** | What was decided? | "Use PostgreSQL for persistence" |
| **Context** | What constraints drive this? | "Need ACID transactions, team has PG experience" |
| **Alternatives** | What else was considered? | "MongoDB (flexible schema) and SQLite (simpler)" |
| **Consequences** | What are the accepted downsides? | "Schema migrations needed; more operational overhead than SQLite" |

**Minimum bar:** At least one documented tradeoff per plan. If there are zero documented tradeoffs, the planner either hasn't considered alternatives or hasn't recorded their reasoning — both are risks.

`(see code-quality-foundations -> Every Decision Has Consequences)`

## Decision Tables

### "Is This Plan Ready to Build?"

| # | Question | If No -> |
|---|----------|---------|
| 1 | Can you state what the code does in one sentence? | **STOP** — Define the problem and deliverable |
| 2 | Do acceptance criteria pass the Test Test (testable, not adjectives)? | **STOP** — Rewrite criteria as verifiable assertions |
| 3 | Is error handling strategy defined for each system boundary? | **STOP** — Map boundaries and failure modes |
| 4 | Is the testing approach proportional to the risk? | **STOP** — Define test levels and critical paths |
| 5 | Is at least one design tradeoff documented with alternatives? | **STOP** — Record reasoning for key decisions |

All five "Yes" -> **READY TO BUILD.** Start with the highest-risk component.

### "Where Should I Focus Audit Effort?"

| Context | Focus On | Rationale |
|---------|----------|-----------|
| Greenfield project | Scorecard completeness, modularity pre-check | Foundation decisions compound |
| Adding to existing codebase | Antipattern risk, naming consistency, integration points | Must fit existing patterns |
| Security-sensitive feature | Error handling, security boundaries, input validation | Breaches are catastrophic |
| Performance-critical path | Tradeoff documentation, testing strategy, measurement plan | Optimizations need evidence |
| Prototype / spike | Problem statement, scope boundaries only | Don't over-plan throwaway work |
| Shared library / public API | Hard-to-misuse check, error handling, modularity | Consumers can't easily work around design mistakes |

## Checklists

### Plan Audit Checklist

- [ ] Completeness Scorecard ≥7/10
- [ ] All plan items pass the 5 Actionability Tests
- [ ] Readability pre-check: naming, layers, single responsibility
- [ ] Error handling strategy defined for each system boundary
- [ ] No plan-level antipatterns present (The Fog, The Wishlist, Missing Error Story)
- [ ] Implementation risk signals addressed
- [ ] Testing strategy complete (levels, doubles, edge cases, coverage)
- [ ] No test strategy red flags
- [ ] At least one design tradeoff documented with alternatives and consequences
- [ ] Scope bounded — deferred items explicitly listed

### Quick Pre-Implementation Gate

Run this 60-second check before writing any code:

- [ ] I can state the deliverable in one sentence
- [ ] I know the first test I'll write
- [ ] I know what errors I'll handle and how
- [ ] I know what I'm *not* building (scope boundary)

## See Also

- **code-quality-foundations** — Quality pillars and goals that plans should target `(see code-quality-foundations -> The Four Goals, The Six Pillars)`
- **code-antipatterns** — Antipattern catalog for risk assessment during audit `(see code-antipatterns -> Pattern Recognition, Severity Classification)`
- **code-testing-quality** — Test strategy and quality evaluation `(see code-testing-quality -> The Test Pyramid, Testing Antipatterns)`
- **code-review** — Review process that validates plan execution `(see code-review -> Review Goals, Reviewer Checklist)`
