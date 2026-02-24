---
name: code-antipatterns
description: Antipattern catalog with categorized patterns, symptoms, examples, and fixes. Use when reviewing code for quality issues, detecting bad patterns during plan-audit or scope, evaluating whether a pattern is an antipattern or acceptable tradeoff, or fixing existing code smells. Covers surprise, misuse, complexity, and premature antipattern categories with severity classification.
---

# Code Antipatterns

## Top 10 Code Antipatterns

| # | Antipattern | Category | Severity | One-Line Summary |
|---|-------------|----------|----------|-----------------|
| 1 | Silent Failure | Surprise | Critical | Swallowing errors hides bugs until production |
| 2 | Mutable Shared State | Misuse | Critical | Shared mutation causes race conditions and data corruption |
| 3 | Primitive Obsession | Misuse | Warning | Using `String` where `EmailAddress` would prevent invalid data |
| 4 | Magic Values | Surprise | Warning | Unexplained literals obscure intent and invite inconsistency |
| 5 | God Object | Complexity | Warning | One class that knows and does everything |
| 6 | Premature Abstraction | Premature | Warning | Interfaces and factories before the second use case exists |
| 7 | Leaky Abstraction | Complexity | Warning | Callers must understand implementation details to use the API |
| 8 | Shotgun Surgery | Complexity | Warning | One logical change touches many files |
| 9 | Premature Optimization | Premature | Warning | Optimizing without profiling first |
| 10 | Cargo Cult Code | Premature | Note | Copying patterns without understanding why they exist |

## Severity Classification

| Severity | Meaning | Action | Examples |
|----------|---------|--------|----------|
| **Critical** | Active risk of data loss, security breach, or production failure | Fix immediately | Silent failure, mutable shared state |
| **Warning** | Ongoing cost in maintainability, reliability, or team velocity | Fix soon or create a ticket | God object, primitive obsession, magic values |
| **Note** | Code smell that may not warrant immediate action | Consider during refactoring | Cargo cult code, lava flow, boolean blindness |

## Antipattern or Acceptable Tradeoff?

| Signal | Antipattern | Acceptable Tradeoff |
|--------|-------------|---------------------|
| Duplicate code in two places | Wait — under threshold | Fix if three or more occurrences |
| Function takes a boolean param | Antipattern if unclear at call site | Acceptable if only one boolean and meaning is obvious |
| No interface for a dependency | Fine — add when second impl arrives | Antipattern if you need it for testing now |
| Global mutable state | Almost always an antipattern | Acceptable for true singletons (logger, config) with thread safety |
| Magic number | Antipattern if meaning is unclear | Acceptable for universally known values (0, 1, 100%) |
| Complex optimization | Antipattern without profiling evidence | Acceptable in measured hot paths with benchmarks |
| Dead code / commented blocks | Antipattern — delete it | Acceptable as temporary scaffold during active development |
| God object | Antipattern in production code | Acceptable in prototypes and spikes (plan to refactor) |

## Context-Dependent Evaluation

| Context | Lean Toward | Rationale |
|---------|-------------|-----------|
| Prototype / spike | Tolerance — focus on validation | You'll rewrite anyway |
| Shared library / public API | Strict — fix misuse and surprise patterns | Consumers can't easily work around your mistakes |
| Hot path (measured) | Allow optimization complexity | Performance justifies readability tradeoff |
| Security boundary | Strict on all categories | Security antipatterns compound |
| Greenfield project | Moderate — invest in structure early | Foundation decisions compound over time |
| Legacy codebase | Prioritize critical severity only | Don't boil the ocean; fix what matters |

## Code Review Antipattern Scan

- [ ] No silent failures — errors either propagate or are explicitly handled
- [ ] No magic values — all non-obvious literals are named constants
- [ ] No unexpected side effects — query functions don't modify state
- [ ] No mutable shared state without explicit thread safety
- [ ] No primitive obsession — domain values have domain types where appropriate
- [ ] No god objects — each class has a single clear responsibility
- [ ] No premature abstraction — interfaces have or will soon have multiple implementations
- [ ] No shotgun surgery — related logic is centralized

## "Should I Fix This Now?"

| Situation | Action |
|-----------|--------|
| Critical severity in production code | Fix now |
| Warning severity blocking current task | Fix now |
| Warning severity in adjacent code | Create a ticket |
| Note severity | Consider during next refactoring pass |
| Any severity in prototype/spike code | Note for later — don't gold-plate throwaway work |
