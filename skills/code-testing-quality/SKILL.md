---
name: code-testing-quality
description: Unit testing principles, test structure patterns, test doubles strategy, naming conventions, testing antipatterns, and coverage guidance. Use when writing tests, reviewing test quality, evaluating test coverage, choosing test doubles, fixing flaky tests, or assessing test structure during cook and serve phases. Enhances taster agent during TDD cycle.
---

# Code Testing Quality

## Testing Quality Checklist

- [ ] Each test verifies one behavior (single assertion theme)
- [ ] Tests are independent — no shared mutable state, runs in any order
- [ ] Test names describe the scenario and expected outcome
- [ ] Arrange/Act/Assert sections are visually distinct
- [ ] No logic in tests (no conditionals, loops, or try-catch)
- [ ] Test doubles used only at architectural boundaries
- [ ] Flaky indicators absent (sleeps, real clocks, network calls, file I/O)
- [ ] Edge cases covered (nulls, empty collections, boundaries, error paths)
- [ ] Tests verify behavior, not implementation details
- [ ] Refactoring production code doesn't break tests (unless behavior changes)

## Three Properties of Good Tests

| Property | Meaning | Violation Signal |
|----------|---------|-----------------|
| **Isolated** | No test affects another; runs alone or in any order | Tests pass individually but fail together |
| **Repeatable** | Same result every time, on any machine | "Works on my machine," intermittent failures |
| **Clear** | Failure message pinpoints the problem | Must read test code to understand what broke |

## Test Doubles Decision Table

| Situation | Recommended Double | Why |
|-----------|--------------------|-----|
| External API or network call | **Stub** | Isolation from external non-determinism |
| Database in integration test | **Fake** (in-memory DB) | Realistic behavior, fast execution |
| Verifying a notification was sent | **Mock** | The side effect *is* the behavior |
| Complex collaborator with state | **Fake** | Maintains realistic internal consistency |
| Legacy code you can't refactor yet | **Spy** | Observe without modifying production code |
| Internal collaborator (same module) | **Real object** | Prefer real dependencies for internal code |

**Rule of thumb:** Mock at architectural boundaries (network, database, filesystem, external services). Use real objects for internal collaborators.

## Test Naming Patterns

| Pattern | Example | Best For |
|---------|---------|----------|
| `method_scenario_expectedResult` | `withdraw_insufficientFunds_throwsException` | Unit tests with clear method focus |
| `should [outcome] when [condition]` | `should reject withdrawal when funds insufficient` | Behavior-focused tests |
| `given_when_then` | `givenInsufficientFunds_whenWithdraw_thenThrows` | BDD-style tests |

**The failure message test:** When a test fails, can you understand the bug from the test name alone? If yes, the name is good.

## Testing Antipatterns

| Antipattern | Symptom | Severity | Fix |
|-------------|---------|----------|-----|
| **Flaky tests** | Pass/fail without code changes | Critical | Remove non-determinism: no sleeps, no real clocks, no shared state |
| **Test interdependence** | Tests pass alone, fail together | Critical | Each test creates/destroys its own data |
| **Testing implementation** | Refactoring breaks tests | Major | Assert on outputs and side effects, not internal method calls |
| **Logic in tests** | Conditionals, loops, try-catch in test code | Major | Tests should be straight-line code |
| **Slow tests** | Suite takes minutes, developers skip it | Major | Isolate from I/O; use fakes; parallelize |
| **Obscure tests** | Must read full test to understand intent | Moderate | Descriptive names, visible AAA structure |
| **Fragile assertions** | Tests break on irrelevant output changes | Moderate | Assert on relevant fields only |
| **Liar tests** | Tests that always pass regardless of behavior | Critical | Verify tests fail when behavior is wrong (mutation testing) |
| **Giant arrange** | 50 lines of setup, 1 line of act | Moderate | Use builders/factories; consider whether unit is too large |
| **Snapshot abuse** | Blindly approving snapshot updates | Moderate | Prefer explicit assertions for logic |

## Coverage Guidance

| Coverage Target | Context | Rationale |
|----------------|---------|-----------|
| >80% of critical paths | Most projects | Balances thoroughness with diminishing returns |
| >90% | Safety-critical, financial | Higher stakes justify investment |
| 60-70% | Early-stage, prototypes | Focus on core behavior first |

**Beyond line coverage:** Branch coverage is more meaningful. Mutation testing reveals "liar tests" — tests that run code but don't verify it. A high mutation score (>80%) indicates tests that actually catch defects.

## "Why Is This Test Bad?"

| Symptom | Likely Antipattern | Action |
|---------|-------------------|--------|
| Test breaks after refactoring (behavior unchanged) | Testing implementation | Assert on outputs, not method calls |
| Test fails intermittently | Flaky test | Remove non-determinism (time, state, I/O) |
| Can't understand failure from test name | Obscure test | Rename to describe scenario + expected outcome |
| 50+ lines of setup | Giant arrange | Use builders; consider splitting the unit |
| Tests pass but bugs ship | Liar test / weak assertions | Add mutation testing |
| Test suite takes >5 minutes | Slow tests | Replace I/O with fakes; parallelize |

## Checklists

### Before Writing a Test

- [ ] Identify the specific behavior to verify (not the implementation)
- [ ] Determine test level: unit, integration, or E2E
- [ ] Choose test double strategy (prefer real objects; mock at boundaries)
- [ ] Plan for edge cases and error paths

### Test Quality Self-Review

- [ ] Each test has one clear reason to fail
- [ ] Test names describe scenario and expected outcome
- [ ] No shared mutable state between tests
- [ ] No non-determinism (time, randomness, network, filesystem)
- [ ] Assertions verify behavior, not implementation
- [ ] Test fails when the behavior it guards is broken
