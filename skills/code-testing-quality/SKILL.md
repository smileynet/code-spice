---
name: code-testing-quality
description: Unit testing principles, test structure patterns, test doubles strategy, naming conventions, testing antipatterns, and coverage guidance. Use when writing tests, reviewing test quality, evaluating test coverage, choosing test doubles, fixing flaky tests, or assessing test structure during cook and serve phases. Enhances taster agent during TDD cycle.
---

# Code Testing Quality

Principles and practices for writing tests that are reliable, maintainable, and actually catch bugs.

## Quick Reference

### Testing Quality Checklist

Use during code review and the taster agent's RED phase:

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

### The Three Properties of Good Tests

| Property | Meaning | Violation Signal |
|----------|---------|-----------------|
| **Isolated** | No test affects another; runs alone or in any order | Tests pass individually but fail together |
| **Repeatable** | Same result every time, on any machine | "Works on my machine," intermittent failures |
| **Clear** | Failure message pinpoints the problem | Must read test code to understand what broke |

## Test Strategy

### Planning Your Testing Approach

Before writing tests, decide *what* to test and *at what level*. A test strategy answers three questions:

1. **Where does the risk live?** — Focus testing effort on code where failures cost the most (business logic, data integrity, security boundaries)
2. **What level of test gives the best signal?** — Match test type to what you're verifying (see Test Pyramid below)
3. **What's the test double strategy?** — Real objects internally, fakes/mocks at architectural boundaries

### Applying the Test Pyramid

| Layer | What to Test Here | Signal It Provides |
|-------|------------------|--------------------|
| **Unit** | Pure logic, calculations, transformations, domain rules | Fast, precise — "this function is correct" |
| **Integration** | Database queries, API clients, service wiring, middleware | Realistic — "these components work together" |
| **E2E** | Critical user journeys (login, checkout, data export) | Confidence — "the system works end-to-end" |

**Strategy heuristic:** Start with unit tests for business logic. Add integration tests at boundaries where bugs actually happen. Add E2E tests only for the critical paths that must never break.

### TDD as a Design Tool

Test-driven development isn't just a testing technique — it's a design feedback loop:

1. **RED** — Write a failing test that describes the next behavior
2. **GREEN** — Write the minimum code to pass
3. **REFACTOR** — Clean up while tests protect you

**When TDD helps most:** New features with clear behavior, complex algorithms, code you need to understand before changing. **When to skip strict TDD:** Exploratory prototypes, UI layout, glue code with obvious implementations.

### Choosing Test Types by Situation

| Situation | Test Type | Why |
|-----------|----------|-----|
| Pure function with clear inputs/outputs | Unit test | Fast, precise feedback |
| Database query or ORM logic | Integration test with real/fake DB | Verifies query correctness |
| API endpoint handler | Integration test | Tests routing, serialization, middleware |
| Complex business rule with many cases | Parameterized unit test | Covers combinations efficiently |
| Critical user journey (login, checkout) | E2E test | Validates full stack works together |
| Service-to-service communication | Contract test | Catches interface drift early |
| Function with mathematical invariants | Property-based test | Finds edge cases humans miss |

## Unit Testing Principles

### Primary Function: Detect Broken Code

Tests exist to catch regressions. A test suite that passes after breaking production code is worse than no tests — it provides false confidence.

**The litmus test:** If you introduce a bug, does a test fail? If not, your tests aren't testing the right things.

### What to Test vs. What Not to Test

| Test Thoroughly | Skip or Test Lightly |
|----------------|---------------------|
| Business logic and domain rules | Simple getters/setters with no logic |
| Edge cases and boundary conditions | Framework-generated boilerplate |
| Error handling and recovery paths | Third-party library internals |
| State transitions and workflows | Private methods (test through public API) |
| Input validation at system boundaries | Configuration constants |
| Code with high cyclomatic complexity | One-line delegation methods |

**Rule:** Test behavior at the public API boundary. Private methods are implementation details — testing them couples tests to structure, not behavior.

### The Test Pyramid

| Level | Scope | Speed | When to Use |
|-------|-------|-------|-------------|
| **Unit** | Single function/class | Milliseconds | Business logic, algorithms, data transformations |
| **Integration** | Component interactions | Seconds | Database queries, API clients, service boundaries |
| **E2E** | Full user journeys | Minutes | Critical paths, smoke tests, deployment verification |

Many unit tests, fewer integration tests, fewest E2E tests. Each level trades speed for integration confidence.

<details>
<summary>Test Pyramid vs. Test Trophy</summary>

The **Test Trophy** (Kent C. Dodds, frontend-oriented) emphasizes integration tests as the largest layer, with static analysis as the foundation. The rationale: for UI-heavy applications, integration tests provide the best return on investment because they test realistic user interactions.

| Shape | Largest Layer | Best For |
|-------|--------------|----------|
| **Pyramid** | Unit tests | Backend, algorithmic, library code |
| **Trophy** | Integration tests | Frontend, full-stack applications |

Both are heuristics. Choose based on where your business logic lives and what gives your team the most confidence per test-minute invested.
</details>

## Test Structure

### Arrange-Act-Assert (AAA)

The standard unit test structure. Each section should be visually distinct:

```
// Arrange — set up preconditions
val account = Account(balance = 100)
val withdrawal = Withdrawal(amount = 30)

// Act — execute the behavior under test
val result = account.process(withdrawal)

// Assert — verify the outcome
assertEquals(70, result.balance)
```

**Rules:**
- **One Act per test** — multiple acts mean multiple tests hiding in one
- **No logic in Arrange** — use builders or factories for complex setup
- **Assert on behavior** — verify what happened, not how it happened

### Given-When-Then (GWT)

Semantically identical to AAA but emphasizes behavior from the user's perspective. Preferred for acceptance tests and BDD:

```
// Given a customer with a valid discount code
// When they apply the code at checkout
// Then the total is reduced by the discount percentage
```

**When to use which:** AAA for technical unit tests; GWT for behavior-focused and acceptance tests. Consistency within a codebase matters more than the choice itself.

### Parameterized / Table-Driven Tests

When multiple inputs exercise the same logic, use parameterized tests instead of copy-pasting:

```
// Table-driven: define logic once, vary the data
testCases = [
    { input: 0,   expected: "zero" },
    { input: 1,   expected: "one"  },
    { input: -1,  expected: "negative" },
    { input: 999, expected: "large" },
]
for each case in testCases:
    assertEquals(case.expected, classify(case.input))
```

**Benefits:** Easy to add cases (add a row, not a test), less duplication, better boundary coverage. Name each case for clear failure output.

## Test Naming

### Convention: Describe Scenario and Outcome

Good test names are sentences that describe what's being tested:

| Pattern | Example | Best For |
|---------|---------|----------|
| `method_scenario_expectedResult` | `withdraw_insufficientFunds_throwsException` | Unit tests with clear method focus |
| `should [outcome] when [condition]` | `should reject withdrawal when funds insufficient` | Behavior-focused tests |
| `given_when_then` | `givenInsufficientFunds_whenWithdraw_thenThrows` | BDD-style tests |

**Antipattern:** `test1`, `testWithdraw`, `testHappyPath` — these names tell you nothing when they fail.

**The failure message test:** When a test fails, can you understand the bug from the test name alone, without reading the test body? If yes, the name is good.

## Test Doubles

### Types and When to Use Each

| Double | What It Does | Use When |
|--------|-------------|----------|
| **Stub** | Returns canned responses | Replacing slow or non-deterministic dependencies |
| **Mock** | Verifies interactions occurred | Checking side effects (email sent, event published) |
| **Fake** | Working shortcut implementation | Need realistic behavior without production overhead |
| **Spy** | Records calls for later inspection | Observing behavior in legacy code |

### Decision Table: Choosing a Test Double

| Situation | Recommended Double | Why |
|-----------|--------------------|-----|
| External API or network call | **Stub** | Isolation from external non-determinism |
| Database in integration test | **Fake** (in-memory DB) | Realistic behavior, fast execution |
| Verifying a notification was sent | **Mock** | The side effect *is* the behavior |
| Complex collaborator with state | **Fake** | Maintains realistic internal consistency |
| Legacy code you can't refactor yet | **Spy** | Observe without modifying production code |
| Internal collaborator (same module) | **Real object** | Prefer real dependencies for internal code |

### The Mock Overuse Problem

Over-mocking creates tests coupled to implementation, not behavior:

| Signal | Problem | Fix |
|--------|---------|-----|
| Refactoring breaks tests but behavior unchanged | Tests verify *how*, not *what* | Test through public API with real collaborators |
| Mock setup is longer than the test | Too many seams mocked | Use fakes or test larger units |
| Tests pass but bugs ship | Mocks don't behave like real dependencies | Use fakes or integration tests at boundaries |

**Rule of thumb:** Mock at architectural boundaries (network, database, filesystem, external services). Use real objects for internal collaborators.

<details>
<summary>London vs. Detroit school</summary>

Two schools of thought on test isolation:

| School | Approach | Tradeoff |
|--------|----------|----------|
| **London (Mockist)** | Mock all collaborators; test classes in pure isolation | Strong design feedback (forces interfaces); brittle to refactoring |
| **Detroit (Classicist)** | Use real objects; only mock external boundaries | Resilient to refactoring; less design pressure; wider blast radius on failure |

**Modern consensus (2025):** The industry leans toward the Detroit school — mock less, use fakes at boundaries, test behavior not structure. Pure London-style mocking produces test suites that resist every refactoring, regardless of whether behavior changed.

The pragmatic approach: use real objects for internal collaborators, fakes for infrastructure boundaries, and mocks only when verifying side effects is the point of the test.
</details>

## Testing Antipatterns

### Antipattern Catalog

| Antipattern | Symptom | Severity | Fix |
|-------------|---------|----------|-----|
| **Flaky tests** | Pass/fail without code changes | Critical | Remove non-determinism: no sleeps, no real clocks, no shared state |
| **Test interdependence** | Tests pass alone, fail together | Critical | Each test creates/destroys its own data; no execution-order assumptions |
| **Testing implementation** | Refactoring breaks tests | Major | Assert on outputs and side effects, not internal method calls |
| **Logic in tests** | Conditionals, loops, try-catch in test code | Major | Tests should be straight-line code; extract complexity to helpers |
| **Slow tests** | Suite takes minutes, developers skip it | Major | Isolate from I/O; use fakes; parallelize; move slow tests to CI |
| **Obscure tests** | Must read full test to understand intent | Moderate | Descriptive names, visible AAA structure, minimal setup |
| **Fragile assertions** | Tests break on irrelevant output changes | Moderate | Assert on relevant fields only, not entire serialized objects |
| **Liar tests** | Tests that always pass regardless of behavior | Critical | Verify tests fail when behavior is wrong (mutation testing) |
| **Giant arrange** | 50 lines of setup, 1 line of act | Moderate | Use builders/factories; consider whether unit is too large |
| **Snapshot abuse** | Blindly approving snapshot updates | Moderate | Use snapshots only for presentational output; prefer explicit assertions |

### The Flaky Test Problem

Flaky tests are the most damaging antipattern — they erode trust in the entire suite. Common causes:

| Cause | Example | Solution |
|-------|---------|----------|
| **Time dependency** | Test uses `Date.now()` | Inject clock; use deterministic time |
| **Shared state** | Tests share a database row | Unique test data per test; cleanup in teardown |
| **Race conditions** | Async operation not awaited | Use proper async/await; avoid sleep-based waits |
| **Environment dependency** | Assumes specific OS, timezone, locale | Explicit environment setup in test; containerize |
| **Order dependency** | Test B needs Test A to run first | Each test is self-contained with own setup |

## Coverage

### Meaningful Coverage vs. Metric Gaming

Coverage measures which code *runs* during tests — not whether tests *verify* correct behavior. A test with no assertions has 100% coverage and catches zero bugs.

| Coverage Target | Context | Rationale |
|----------------|---------|-----------|
| >80% of critical paths | Most projects | Balances thoroughness with diminishing returns |
| >90% | Safety-critical, financial | Higher stakes justify investment |
| 60-70% | Early-stage, prototypes | Focus on core behavior first |

**Goodhart's Law applies:** When coverage becomes a target, developers write trivial tests to hit the number. 100% coverage of getters is worse than 80% coverage of business logic.

### Beyond Line Coverage

| Metric | What It Measures | Value |
|--------|-----------------|-------|
| **Branch coverage** | Decision paths exercised | More meaningful than line coverage |
| **Mutation testing** | Whether tests catch injected bugs | Reveals "liar tests" that run code but don't verify it |
| **Critical path coverage** | High-risk code paths tested | Focus effort where failures cost the most |

**Mutation testing** introduces small bugs (mutants) into production code and checks whether tests fail. A high mutation score (>80%) indicates tests that actually catch defects, not just execute lines.

<details>
<summary>Property-based testing</summary>

Property-based testing (PBT) complements example-based tests by generating random inputs and checking that invariant properties hold:

**Example:** Instead of testing `sort([3,1,2]) == [1,2,3]`, define properties:
- Output length equals input length
- Every element in output was in input
- Each element is less than or equal to the next

The framework generates hundreds of random inputs and finds the smallest failing case (shrinking).

**When to use PBT:**
- Functions with clear invariants (sorting, encoding/decoding, serialization)
- Complex domain logic where edge cases are hard to enumerate
- Security-sensitive code (parsing, validation, protocol handling)

**When to skip PBT:**
- Simple CRUD operations
- UI behavior tests
- When properties are harder to express than example tests

**Frameworks:** Hypothesis (Python), fast-check (TypeScript/JS), jqwik (JVM).
</details>

<details>
<summary>Contract testing for service boundaries</summary>

Contract testing verifies that services agree on their communication interface without running full integration tests:

- **Consumer-driven:** The consumer defines expected requests/responses; the provider verifies it meets them
- **Independent deployment:** Teams ship without waiting for full integration environments
- **Catches integration drift:** Detects breaking changes before they hit production

Use contract testing when: microservices, API-first products, multiple teams consuming the same service. Tools: Pact (most mature), Spring Cloud Contract (JVM).

Contract tests complement, not replace, integration and E2E tests.
</details>

## Decision Tables

### "Why Is This Test Bad?"

| Symptom | Likely Antipattern | Action |
|---------|-------------------|--------|
| Test breaks after refactoring (behavior unchanged) | Testing implementation | Assert on outputs, not method calls |
| Test fails intermittently | Flaky test | Remove non-determinism (time, state, I/O) |
| Can't understand failure from test name | Obscure test | Rename to describe scenario + expected outcome |
| 50+ lines of setup | Giant arrange | Use builders; consider splitting the unit |
| Tests pass but bugs ship | Liar test / weak assertions | Add mutation testing; verify tests fail correctly |
| Test suite takes >5 minutes | Slow tests | Replace I/O with fakes; parallelize; split suites |

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
- [ ] Setup is minimal and relevant (no "just in case" data)
- [ ] Test fails when the behavior it guards is broken

## See Also

- **code-quality-foundations** — Testability as a design pillar `(see code-quality-foundations -> Make Code Testable)`
- **code-review** — Evaluating test quality during review `(see code-review -> Reviewer Checklist)`
- **code-antipatterns** — Quality failures that make code untestable `(see code-antipatterns -> Pattern Recognition)`
- **refactoring-patterns** — Making untestable code testable `(see refactoring-patterns -> When to Refactor)`
