---
name: code-antipatterns
description: Antipattern catalog with categorized patterns, symptoms, examples, and fixes. Use when reviewing code for quality issues, detecting bad patterns during plan-audit or scope, evaluating whether a pattern is an antipattern or acceptable tradeoff, or fixing existing code smells. Covers surprise, misuse, complexity, and premature antipattern categories with severity classification.
---

# Code Antipatterns

How to recognize, classify, and fix the patterns that make code fragile, surprising, or hard to maintain.

## Quick Reference

### Top 10 Code Antipatterns

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

## Surprise Antipatterns

Patterns that violate the Principle of Least Astonishment (POLA) — behavior doesn't match what a reasonable caller would expect.

### Silent Failure

**Severity:** Critical

**Symptoms:** Empty catch blocks. Errors caught but not logged. Functions return default values on failure. Bugs discovered in production, not development.

**Before:**
```python
def get_user(id):
    try:
        return db.query(User, id)
    except DatabaseError:
        return None  # Caller has no idea the DB is down
```

**After:**
```python
def get_user(id) -> User | None:
    """Returns None if user doesn't exist. Raises on DB failure."""
    try:
        return db.query(User, id)
    except RecordNotFound:
        return None
    # DatabaseError propagates — callers must handle infrastructure failures
```

**Prevention:** Distinguish "not found" (expected) from "system failure" (unexpected). Only catch exceptions you can meaningfully handle. Let everything else propagate.

### Magic Values

**Severity:** Warning

**Symptoms:** Literal numbers or strings with special meaning scattered through code. Same value repeated in multiple places. Meaning unclear without reading surrounding context.

**Before:**
```python
if user.role == 2:        # What is 2?
    timeout = 86400       # What is 86400?
    retry_after = -1      # Means "don't retry"? Or error?
```

**After:**
```python
ADMIN_ROLE = 2
ONE_DAY_SECONDS = 86400
NO_RETRY = -1

if user.role == ADMIN_ROLE:
    timeout = ONE_DAY_SECONDS
    retry_after = NO_RETRY
```

**Prevention:** Extract every non-obvious literal into a named constant. If the value's meaning isn't obvious from its usage (0, 1, empty string), it needs a name.

### Unexpected Side Effects

**Severity:** Warning

**Symptoms:** Functions named as queries that modify state. Getters that trigger writes. Input parameters mutated by called function.

**Before:**
```python
def get_total(items):
    items.sort()                    # Mutates the caller's list!
    return sum(i.price for i in items)
```

**After:**
```python
def get_total(items):
    return sum(i.price for i in sorted(items))  # Sorted copy, original untouched
```

**Prevention:** Functions that read should not write. If mutation is necessary, name it explicitly (`sort_and_total`) or accept that the caller knows to expect it.

`(see code-quality-foundations -> Avoid Surprises)`

## Misuse Antipatterns

Patterns that make APIs easy to use incorrectly — invalid states are representable and wrong usage compiles cleanly.

### Mutable Shared State

**Severity:** Critical

**Symptoms:** Race conditions. Non-deterministic behavior. Data corruption under concurrency. Tests pass alone but fail together.

**Before:**
```python
class RateLimiter:
    count = 0  # Shared across all instances and threads

    def allow(self):
        self.count += 1          # Race condition: read-modify-write
        return self.count <= 100
```

**After:**
```python
class RateLimiter:
    def __init__(self):
        self._count = threading.atomic_int(0)  # Thread-safe counter

    def allow(self):
        return self._count.increment() <= 100
```

**Prevention:** Default to immutable data. When mutation is required, confine it to a single owner or use thread-safe primitives. Shared mutable state should be an explicit design decision, never accidental.

### Primitive Obsession

**Severity:** Warning

**Symptoms:** Functions accepting `str` for email, phone, URL. Validation scattered across callers. Invalid values pass through the system until they cause failures far from their origin.

**Before:**
```python
def send_invoice(email: str, amount: float, currency: str):
    # Any string passes type checking — "not-an-email" compiles fine
    ...
```

**After:**
```python
def send_invoice(email: EmailAddress, amount: Money):
    # EmailAddress validates on construction; Money pairs amount + currency
    # Invalid data can't reach this function
    ...
```

**Prevention:** Wrap primitives in domain types when the value has constraints (format, range, valid combinations). Validate at construction so invalid instances can't exist.

### Boolean Blindness

**Severity:** Note

**Symptoms:** Functions with boolean parameters that change behavior. Call sites read as `process(data, True, False)` — meaning unclear without checking the signature.

**Before:**
```python
def export(data, compress, include_headers, overwrite):
    ...
export(data, True, False, True)  # What does True, False, True mean?
```

**After:**
```python
def export(data, format: ExportFormat):
    ...
export(data, ExportFormat(compress=True, headers=False, overwrite=True))
```

**Prevention:** Replace boolean parameters with enums or configuration objects. If a function takes more than one boolean, callers will always get confused.

`(see code-quality-foundations -> Make Code Hard to Misuse)`

## Complexity Antipatterns

Patterns that add unnecessary structural complexity, making code hard to understand, navigate, and change.

### God Object

**Severity:** Warning

**Symptoms:** Single class with hundreds of lines. Many unrelated responsibilities. Most other classes depend on it. Changes to one feature risk breaking others.

**Before:**
```python
class Application:
    def authenticate(self): ...
    def send_email(self): ...
    def calculate_tax(self): ...
    def render_report(self): ...
    def migrate_database(self): ...
```

**After:** Split by responsibility — `AuthService`, `EmailService`, `TaxCalculator`, `ReportRenderer`, `MigrationRunner`. Each class handles one concern and can be tested independently.

**Prevention:** Apply the one-sentence test: if you can't describe what a class does in one sentence without "and," it needs splitting.

### Leaky Abstraction

**Severity:** Warning

**Symptoms:** Callers must understand internals to use the API correctly. Performance requires knowledge of underlying implementation. ORM queries need SQL tuning.

**Before:**
```python
# Caller must know the ORM batches in groups of 1000
for user in get_all_users():       # Loads 1M rows into memory
    process(user)
```

**After:**
```python
for batch in get_users_paginated(size=100):  # Abstraction manages pagination
    for user in batch:
        process(user)
```

**Prevention:** Design APIs so callers don't need to know how the abstraction works internally. When leaks are unavoidable (performance boundaries), document them explicitly.

### Shotgun Surgery

**Severity:** Warning

**Symptoms:** A single logical change requires edits in 5+ files. Related logic scattered across unrelated modules. High risk of missing one location during changes.

**Before:** Adding a new user role requires changes in `auth.py`, `permissions.py`, `ui_menu.py`, `report_filter.py`, `admin_panel.py`, and `api_serializer.py`.

**After:** Consolidate role-related logic into a `Role` type that carries its own permissions, UI visibility, and serialization rules. Adding a role means adding one enum value.

**Prevention:** When the same concept is referenced in many places, centralize it. The concept should live in one place and other code should depend on that single source of truth.

### Lava Flow

**Severity:** Note

**Symptoms:** Dead code that nobody dares delete. Commented-out blocks from years ago. Functions with names like `processV2` alongside `process`. TODO markers without tickets.

**Prevention:** Delete dead code — version control remembers it. If code is disabled, remove it entirely rather than commenting it out. Track technical debt in issue trackers, not in code comments.

## Premature Antipatterns

Patterns where developers invest effort before evidence justifies it — solving problems that don't exist yet.

### Premature Abstraction

**Severity:** Warning

**Symptoms:** Interfaces with exactly one implementation. Factory patterns for objects created in one place. Generic frameworks for a single use case. Abstract base classes before the second concrete class exists.

**Before:**
```python
class IUserRepository(ABC): ...
class UserRepositoryImpl(IUserRepository): ...
class UserRepositoryFactory:
    def create(self) -> IUserRepository:
        return UserRepositoryImpl()
```

**After:**
```python
class UserRepository:  # Direct implementation — add interface when needed
    ...
```

**Prevention:** Wait for the second use case before abstracting. The Rule of Three: tolerate duplication until you see the pattern three times, then abstract with confidence.

### Premature Optimization

**Severity:** Warning

**Symptoms:** Complex caching without measured performance problems. Hand-rolled data structures replacing standard ones. Unreadable micro-optimizations in non-hot paths. No profiling data to justify the complexity.

**Prevention:** Profile first, optimize second. Measure before and after. Most performance problems are in 5% of the code — find that 5% with data, not guesses.

### Cargo Cult Code

**Severity:** Note

**Symptoms:** Design patterns applied without understanding the problem they solve. Boilerplate copied from other projects. Code that "works" but nobody can explain why. Over-engineered solutions mimicking enterprise patterns in simple applications.

**Prevention:** For every pattern you apply, articulate the specific problem it solves in your context. If you can't explain why the pattern helps, you probably don't need it.

`(see code-quality-foundations -> Code Should Be Adaptable)`

## Pattern Recognition

Use these tables when evaluating code during review, plan-audit, or refactoring decisions.

### Severity Classification

| Severity | Meaning | Action | Examples |
|----------|---------|--------|----------|
| **Critical** | Active risk of data loss, security breach, or production failure | Fix immediately | Silent failure, mutable shared state |
| **Warning** | Ongoing cost in maintainability, reliability, or team velocity | Fix soon or create a ticket | God object, primitive obsession, magic values |
| **Note** | Code smell that may not warrant immediate action | Consider during refactoring | Cargo cult code, lava flow, boolean blindness |

### Decision Table: Antipattern or Acceptable Tradeoff?

Not every pattern match is a problem. Context determines whether a pattern is harmful.

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

### Context-Dependent Evaluation

| Context | Lean Toward | Rationale |
|---------|-------------|-----------|
| Prototype / spike | Tolerance — focus on validation | You'll rewrite anyway |
| Shared library / public API | Strict — fix misuse and surprise patterns | Consumers can't easily work around your mistakes |
| Hot path (measured) | Allow optimization complexity | Performance justifies readability tradeoff |
| Security boundary | Strict on all categories | Security antipatterns compound |
| Greenfield project | Moderate — invest in structure early | Foundation decisions compound over time |
| Legacy codebase | Prioritize critical severity only | Don't boil the ocean; fix what matters |

## Checklists

### Code Review Antipattern Scan

- [ ] No silent failures — errors either propagate or are explicitly handled
- [ ] No magic values — all non-obvious literals are named constants
- [ ] No unexpected side effects — query functions don't modify state
- [ ] No mutable shared state without explicit thread safety
- [ ] No primitive obsession — domain values have domain types where appropriate
- [ ] No god objects — each class has a single clear responsibility
- [ ] No premature abstraction — interfaces have or will soon have multiple implementations
- [ ] No shotgun surgery — related logic is centralized

### "Should I Fix This Now?"

| Situation | Action |
|-----------|--------|
| Critical severity in production code | Fix now |
| Warning severity blocking current task | Fix now |
| Warning severity in adjacent code | Create a ticket |
| Note severity | Consider during next refactoring pass |
| Any severity in prototype/spike code | Note for later — don't gold-plate throwaway work |

## See Also

- **code-quality-foundations** — The six pillars that antipatterns violate `(see code-quality-foundations -> The Six Pillars)`
- **code-review** — Applying antipattern detection during review `(see code-review -> Review Goals)`
- **code-testing-quality** — Testing antipatterns and test quality `(see code-testing-quality -> Testing Antipatterns)`
- **refactoring-patterns** — Techniques for fixing detected antipatterns `(see refactoring-patterns -> When to Refactor)`
- **software-tradeoffs** — When a "pattern" is actually a context-dependent tradeoff `(see software-tradeoffs -> Analysis Framework)`
- **code-yagni** — Detecting speculative generality and evaluating premature features `(see code-yagni -> Speculative Generality Detection)`
- **code-pruning** — Safe removal process for lava flow and dead code detection strategies `(see code-pruning -> The Lava Flow Antipattern)`
