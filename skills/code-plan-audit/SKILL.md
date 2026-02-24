---
name: code-plan-audit
description: Plan quality auditing with completeness scorecard, antipattern risk detection, and readiness checks. Use when auditing implementation plans, evaluating plan completeness, checking error handling strategy, assessing naming and readability pre-checks, reviewing testing strategy, evaluating tradeoff documentation, or running plan-audit on a software project. Covers the 10-point completeness scorecard, code quality pre-checks, antipattern risk assessment, and build-readiness decision.
---

# Code Plan Audit

## Plan Completeness Scorecard

| # | Check | Severity |
|---|-------|----------|
| 1 | Problem clearly stated with concrete requirements | Critical |
| 2 | Acceptance criteria are testable (not vague adjectives) | Critical |
| 3 | Error handling strategy defined (propagate, recover, or fail) | Critical |
| 4 | Key tradeoffs identified and documented | Warning |
| 5 | Testing strategy chosen (unit/integration/E2E proportions) | Warning |
| 6 | Dependencies and integration points identified | Warning |
| 7 | Naming conventions and readability approach consistent | Warning |
| 8 | Security boundaries identified (input validation, auth, data exposure) | Warning |
| 9 | Scope bounded — deferred items explicitly listed | Note |
| 10 | Existing solutions checked (libraries, shared code, prior art) | Note |

**Scoring:** 10/10 = ready to build. 7-9 = minor gaps, address before starting. 4-6 = return to planning. <4 = needs fundamental design work.

## Actionability Tests

Five tests every plan item must pass before implementation:

| Test | Pass Criteria |
|------|---------------|
| **Verb Test** | Active verbs (create, validate, transform), not vague ("handle", "manage", "deal with") |
| **Scope Test** | Clear boundaries — you know when each task is done |
| **Test Test** | Testable acceptance criteria, not adjectives ("fast", "clean", "robust") |
| **Dependency Test** | Clear ordering — no hidden assumptions about what runs first |
| **Edge Case Test** | At least: empty input, invalid input, concurrent access (if applicable) |

## Code Quality Pre-Checks

### Readability Pre-Check

| Signal | Question | If No |
|--------|----------|-------|
| Naming intent | Does the plan use domain-specific names? | Clarify domain vocabulary before coding |
| Layer clarity | Are abstraction layers described? | Define boundaries before coding |
| Single responsibility | Can each component be described in one sentence without "and"? | Split components |

### Error Handling Strategy Check

| Question | If Missing |
|----------|-----------|
| Which errors are expected vs. unexpected? | Define: "not found" is expected; "DB down" is unexpected |
| Where are system boundaries? | Map validation points |
| What's the recovery strategy for each failure mode? | Decide: retry, fallback, propagate, or fail fast |
| Are error messages actionable for the caller? | Plan error types and messages |

### Modularity Pre-Check

| Signal | Question | If No |
|--------|----------|-------|
| Single concern | Does each module handle one distinct problem? | Reassess responsibilities |
| Dependency direction | Do dependencies flow one way? | Identify circular risks |
| Interface boundaries | Are public APIs defined separately from implementation? | Design contracts first |
| Testability | Can each component be tested without complex setup? | Redesign for dependency injection |

## Plan-Level Antipatterns

| Antipattern | Symptom in Plan | Severity |
|-------------|----------------|----------|
| **The Fog** | Adjectives without verbs ("robust auth", "clean API") | Critical |
| **The Wishlist** | Describes the final vision, no phased delivery | Warning |
| **The Monolith** | Everything in one component, no separation | Warning |
| **The Oracle** | Assumes perfect knowledge of future requirements | Warning |
| **The Clone** | "Like X but..." without understanding X's design decisions | Warning |
| **Missing Error Story** | Happy path only — no error handling, no edge cases | Critical |

## Implementation Risk Signals

| Plan Signal | Predicts | Prevention |
|-------------|----------|------------|
| No domain types mentioned | Primitive obsession | Plan dedicated types for constrained values |
| "Handle errors" without specifics | Silent failure | Define error categories and recovery per boundary |
| Single class/module for multiple concerns | God object | Split responsibilities before coding |
| "Optimize for performance" without metrics | Premature optimization | Define performance targets with measurement plan |
| Interface defined before second use case | Premature abstraction | Start concrete, extract interface when needed |

## "Is This Plan Ready to Build?"

| # | Question | If No |
|---|----------|-------|
| 1 | Can you state what the code does in one sentence? | **STOP** — Define the problem and deliverable |
| 2 | Do acceptance criteria pass the Test Test? | **STOP** — Rewrite criteria as verifiable assertions |
| 3 | Is error handling strategy defined for each system boundary? | **STOP** — Map boundaries and failure modes |
| 4 | Is the testing approach proportional to the risk? | **STOP** — Define test levels and critical paths |
| 5 | Is at least one design tradeoff documented with alternatives? | **STOP** — Record reasoning for key decisions |

All five "Yes" -> **READY TO BUILD.** Start with the highest-risk component.

## Quick Pre-Implementation Gate

Run this 60-second check before writing any code:

- [ ] I can state the deliverable in one sentence
- [ ] I know the first test I'll write
- [ ] I know what errors I'll handle and how
- [ ] I know what I'm *not* building (scope boundary)
