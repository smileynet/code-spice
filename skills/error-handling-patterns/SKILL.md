---
name: error-handling-patterns
description: Error handling strategy selection, recoverability analysis, and signaling techniques. Use when choosing between exceptions, result types, error codes, or other error handling approaches, designing error-handling APIs, wrapping third-party library errors, or evaluating whether errors should be explicit or implicit. Covers recoverability, fail fast/loudly, explicit vs implicit signaling, exception antipatterns, and modern errors-as-values patterns.
---

# Error Handling Patterns

How to recognize, signal, and handle errors effectively. Every error handling decision involves choosing how visible errors should be to callers and how much control callers should have over recovery.

## Quick Reference

### The Error Strategy Decision Table

| You're handling... | Recommended Strategy | Why |
|--------------------|---------------------|-----|
| **Invalid user input** | Explicit: Result type or checked exception | Caller can recover by showing a message |
| **Programming error** (wrong argument, bad state) | Implicit: unchecked exception, panic, assertion | No realistic recovery; fail fast to surface the bug |
| **External system failure** (network, disk, DB) | Explicit: Result type or checked exception | Caller decides: retry, fallback, or propagate |
| **Missing optional value** | Nullable/Optional return type | Absence is expected, not an error |
| **Async operation failure** | Result inside Promise, or explicit async error type | Caller must handle both fulfillment and rejection |
| **Third-party library error** | Wrap in domain-specific exception | Prevents leaking implementation details |
| **Resource exhaustion** (OOM, disk full) | Implicit: let it crash, supervisor restarts | Typically unrecoverable at the application level |

### The Recoverability Framework

Every error falls somewhere on the recoverability spectrum. The *caller* — not the author — determines whether an error is recoverable, because context decides what recovery means.

```
Can the caller realistically recover?
├── Yes → Use an explicit signaling technique
│         (checked exception, Result type, nullable return)
│         so the caller is forced to acknowledge the error.
└── No  → Use an implicit technique
          (unchecked exception, panic, assertion)
          so the error fails fast and loudly.
```

**Key insight:** The same error can be recoverable in one context and unrecoverable in another. An invalid phone number from user input is recoverable (show an error message). The same invalid phone number hard-coded in source code is a programming bug (fail fast).

### Explicit vs. Implicit Signaling

|  | Explicit | Implicit |
|--|----------|----------|
| **Location in code's contract** | Unmistakable part | Small print, if documented at all |
| **Caller aware error can happen?** | Yes — compiler or type system enforces it | Maybe — depends on reading docs or code |
| **Examples** | Checked exceptions, nullable return type (with null safety), Result/Either type, Swift `throws` | Unchecked exceptions, magic values, promises (without explicit error types), assertions |
| **Risk** | Verbosity; callers may take shortcuts to suppress | Silent failures; errors go unnoticed |

## Recoverability

### Recoverable vs. Unrecoverable Errors

Not all errors are equal. Recoverable errors allow the system to continue meaningfully (retry, show a message, fall back). Unrecoverable errors indicate bugs or catastrophic failures where the only sensible response is to stop and surface the problem.

| Type | Examples | Appropriate Response |
|------|---------|---------------------|
| **Recoverable** | Invalid user input, network timeout, file not found | Show error message, retry with backoff, use cached data |
| **Unrecoverable** | Missing required resource, invalid state, null dereference | Fail fast, crash the process, log and alert |
| **Context-dependent** | Invalid phone number, parse failure | Recoverable if from user input; unrecoverable if hard-coded |

### The Caller Determines Recoverability

Low-level code often can't know whether an error is recoverable. A phone number parser that encounters an invalid number doesn't know if the number came from user input (recoverable — ask for a correct one) or from a hard-coded constant (unrecoverable — programming bug). The function should assume the caller *might* want to recover, and signal the error explicitly.

**Rules of thumb for when to assume recoverability:**
- We don't have exact knowledge of everywhere the function is called from
- There's even a slim chance the code will be reused in a new context
- The error is caused by something supplied to the function (not internal state)

### Make Callers Aware

If callers aren't aware an error can happen, they won't write code to handle it. An unhandled error that a caller *would have wanted* to recover from leads to user-visible bugs or failures in business-critical logic. Use explicit signaling techniques to make errors part of the unmistakable contract.

## Core Principles

### Fail Fast

Signal errors as close to their source as possible. When code doesn't fail fast, the error manifests far from its origin — an invalid input accepted in one class may only cause a crash three layers deeper, requiring significant debugging effort to trace back.

**Fail fast means:** Throw an error or return a failure as soon as invalid state is detected. Don't carry invalid data through multiple function calls hoping it works out.

### Fail Loudly

If an error can't be recovered from, make sure someone notices. The loudest approach is crashing the program. A weaker alternative is logging, though logs are often ignored. The goal: unrecoverable errors should never pass silently.

**The robustness tension:** Crashing a server because of one bad request is too aggressive. The solution is *scope of recoverability* — fail the individual request (log, monitor, alert), but keep the server running. Most server frameworks handle this by catching exceptions at the request boundary.

### Checks and Assertions

When you can't make misuse impossible through the type system, use runtime checks to enforce contracts:

- **Precondition checks** — Validate inputs and state before running logic. If the check fails, throw an error immediately (fail fast).
- **Postcondition checks** — Validate results after running logic. Less common, but useful for complex transformations.
- **Assertions** — Similar to checks, but typically compiled out in release builds. Use for conditions that "should never happen" during development. Leave assertions enabled in production unless performance demands otherwise.

**Prefer compile-time enforcement.** Making invalid states unrepresentable (private constructors, factory methods, dedicated types) is always better than runtime checks. When that's not possible, a runtime check that fails loudly beats documentation that goes unread.

### Don't Hide Errors

Hiding errors is almost never a good idea. Common ways errors get hidden:

| Hiding Technique | Problem | Example |
|-----------------|---------|---------|
| **Returning a default value** | Error is indistinguishable from a valid value | Returning `0.0` for a failed balance lookup — is the balance really zero? |
| **Returning an empty collection** | Caller thinks "no results" instead of "lookup failed" | Empty invoice list when the database is down |
| **Doing nothing** | Caller assumes the action succeeded | Silently dropping an item that can't be added to an invoice |
| **Suppressing an exception** | `catch (Exception e) {}` swallows all evidence | Email fails to send but caller thinks it succeeded |
| **Catching and only logging** | Caller still thinks the action succeeded | Logging the error but returning success to the caller |

**Suppressing exceptions is the worst form.** Even logging the error doesn't help callers — they still believe the action succeeded. If you must catch an exception, re-signal the failure to the caller in some form.

## Signaling Techniques

### Checked Exceptions

The compiler forces the caller to acknowledge the error — either by catching it or declaring it in their own signature. Available in Java; other languages achieve similar explicitness through Result types.

**Strengths:** Errors can't be accidentally ignored. The API contract is explicit and compiler-enforced.

**Weaknesses:** Can become verbose when exceptions propagate through many layers, encouraging engineers to hide errors rather than handle them. Adding a new checked exception to a method is a breaking change for all callers.

### Unchecked Exceptions

Callers are free to be completely unaware that an error might occur. Documentation may mention them, but nothing enforces handling.

**Strengths:** Cleaner code structure — error handling concentrates in a few layers rather than polluting every function. Doesn't force cascading signature changes.

**Weaknesses:** Callers can be completely oblivious to error scenarios. Undocumented exceptions turn catching them into a "whack-a-mole" game. Not handling an error happens by default rather than by active decision.

### Result / Either Types

A return type that encapsulates either a success value or an error value. Built into Rust (`Result<T, E>`), Swift (`Result`), Kotlin (`Result`), and available as libraries in other languages (neverthrow for TypeScript, Vavr's `Try` for Java).

**Strengths:** Errors are values, not control flow. The type system enforces handling. Composable — results can be chained with `map`, `flatMap`, and similar operations. No invisible stack unwinding.

**Weaknesses:** Can be verbose in languages without built-in syntax support. Custom Result types rely on other engineers knowing the convention. Mixing with exception-based code creates inconsistency.

### Nullable / Optional Return Types

Returning null (or Optional/Option) signals that a value couldn't be produced. With null safety enabled, the compiler forces the caller to check for null before using the value.

**Strengths:** Simple, well-understood. With null safety, provides explicit error signaling. Lightweight for "no value" scenarios.

**Weaknesses:** Conveys no information about *why* the value is absent. Without null safety, null returns are implicit and easily ignored. Null can be overloaded to mean multiple things (error vs. genuinely absent).

### Magic Values / Error Codes

A special value within the normal return type signals an error (e.g., returning -1, or a status code). The caller must know to check for the magic value by reading documentation.

**Strengths:** Simple, zero overhead. Common in C and system-level APIs.

**Weaknesses:** Nothing in the type system prevents callers from using the magic value as a real value. Easy to forget. Implicit — a major source of bugs.

**Recommendation:** Avoid magic values in modern code. Use nullable types, Result types, or exceptions instead.

### Outcome Return Types

Some functions don't return a value — they *do* something (send a message, write to disk). For these, an outcome return type (Boolean, enum, or status object) signals whether the action succeeded. This is explicit only if callers are forced to check the return value.

**The ignorability problem:** Unlike Result types, outcome return values can easily be ignored — callers can call `sendMessage(channel, "hello")` without checking the Boolean return. In languages that support it, use annotations like `@CheckReturnValue` (Java), `[[nodiscard]]` (C++), or `#[must_use]` (Rust) to generate compiler warnings when the return value is ignored.

### Signaling Technique Comparison

| Technique | Explicit? | Error Info | Composable | Language Support |
|-----------|-----------|------------|------------|----------------|
| Checked exception | Yes | Full (type + message + stack trace) | No | Java |
| Unchecked exception | No | Full (type + message + stack trace) | No | Most languages |
| Result / Either | Yes | Custom (error type) | Yes (`map`, `flatMap`) | Rust, Swift, Kotlin, TS (libraries) |
| Nullable / Optional | Yes (with null safety) | None (just "absent") | Limited | Kotlin, Swift, Java, TS |
| Outcome (Boolean/enum) | Partial (can be ignored) | Minimal | No | Any language |
| Error codes / magic values | No | Minimal | No | C, legacy APIs |
| Promise / Future | No (implicit) | Varies | Yes (`.then`, `.catch`) | JS/TS, Java, most async languages |

## The Debate: Unchecked vs. Explicit

Engineers disagree on whether recoverable errors should use unchecked exceptions or explicit techniques. Both sides have valid arguments.

### Arguments for Unchecked Exceptions

| Argument | Reasoning |
|----------|-----------|
| **Cleaner code structure** | Error handling concentrates in a few distinct layers rather than cluttering every function |
| **Pragmatism** | With explicit techniques, engineers overwhelmed by cascading error handling may take shortcuts (catching and ignoring, casting nullable to non-null) |
| **Less coupling** | Adding a new error case doesn't require changing every caller's signature |

### Arguments for Explicit Techniques

| Argument | Reasoning |
|----------|-----------|
| **Errors can't be accidentally ignored** | Not handling an error is an active, visible decision rather than a silent default |
| **Graceful error handling** | Each layer can provide context-appropriate recovery (specific UI messages vs. generic "something went wrong") |
| **Code review catches omissions** | With explicit techniques, missing error handling is a blatant transgression in the code — easy to spot during review |

### Practical Guidance

What matters most is that your team agrees on a philosophy and applies it consistently. Half the codebase using explicit techniques and the other half using implicit is the worst outcome.

**The modern consensus (2024-2026):** The industry has shifted toward explicit, value-based error handling. Languages designed since 2010 (Rust, Go, Swift, Kotlin) all favor making errors visible in the type system. Even in traditionally exception-heavy ecosystems (TypeScript, Java), libraries like neverthrow, Effect-TS, and Vavr's Try are gaining adoption. The core insight driving this shift: *errors are not exceptional — they are inevitable*, and explicit handling produces more reliable code.

## Wrapping Third-Party Errors

When your API uses a third-party library, propagating the library's exceptions leaks implementation details and creates coupling. If you later swap the library, all callers break.

**The wrapping pattern:**
1. Create a domain-specific exception (e.g., `PersonCatalogException` instead of `FileExistsException`)
2. Catch the library exception internally
3. Wrap it in your domain exception, preserving the original as the cause
4. Throw the domain exception from your public API

**When to wrap:**
- Public APIs consumed by other teams or external users — always wrap
- Internal APIs within the same team — wrap if the library might change
- Private implementation code — wrapping adds overhead for little benefit

**Exception messages matter.** Combine the exception type, a descriptive message, and the original stack trace. These three pieces together make debugging significantly easier.

## Error Handling in Special Contexts

### Multithreaded / Async Code

Errors in background threads or async operations can silently disappear. Fire-and-forget patterns (`execute()` without checking the result) risk silent failures that kill threads and leak resources.

**Key rules:**
- Always capture the Future/Promise result if the operation can fail
- Register global exception handlers for uncaught thread exceptions
- In async workflows, wrap exceptions into the Promise/CompletableFuture rather than throwing them — mixing promise-based and exception-based error handling creates confusing stack traces

### Functional Error Handling (Try / Either)

The functional approach models every possible outcome as a type. A `Try` monad carries either a success value or a failure (exception), allowing callers to chain processing with `map` and `flatMap` without try-catch blocks.

**Tension with OOP:** Mixing functional error handling (`Try`, `Either`) with object-oriented exception throwing creates inconsistency. If part of the codebase uses Try and another part throws exceptions, the boundaries become confusing. Pick one approach per component and be consistent.

## Modern Language-Specific Patterns

### Go: Errors as Values

Go treats errors as ordinary values rather than special control flow. Functions return an `error` alongside their result, and callers check it explicitly. This makes error handling visible at every call site — nothing is implicit.

**The `error` interface:** Go's `error` is a simple interface with one method: `Error() string`. Any type implementing this interface is an error. This simplicity enables custom error types with additional context (error codes, metadata, nested causes).

**Sentinel errors vs. custom types:**

| Approach | When to Use | Example |
|----------|-------------|---------|
| **Sentinel errors** (`var ErrNotFound = errors.New(...)`) | Well-known, stable error conditions | `io.EOF`, `sql.ErrNoRows` |
| **Custom error types** (`type ValidationError struct{...}`) | Errors that carry structured context | Field name, invalid value, constraint violated |

**Error wrapping (`fmt.Errorf` with `%w`):** Wrapping adds context as errors propagate up the call stack without losing the original cause. Each layer adds its own context: `fmt.Errorf("loading user %d: %w", id, err)` produces a chain like `"loading user 42: querying database: connection refused"`.

**Error inspection:**
- `errors.Is(err, target)` — checks if any error in the chain matches a sentinel value. Use for "is this a not-found error?" checks.
- `errors.As(err, &target)` — checks if any error in the chain matches a type, and unwraps it. Use for "get me the validation details" checks.

**Go's tradeoff:** Explicit error checking at every call site produces verbose code (`if err != nil` appears frequently). The benefit is that no error path is hidden — every failure is visible in the code. The cost is boilerplate. This is a deliberate design choice: Go prioritizes clarity over brevity.

### TypeScript: Discriminated Unions

TypeScript's type system enables errors-as-values through discriminated unions — a union type where each variant has a literal `type` (or `kind`) field that TypeScript can narrow on.

**The pattern:**

```typescript
type Result<T> =
  | { ok: true; value: T }
  | { ok: false; error: ErrorDetail }

// Caller must check the discriminant before accessing the value
function getUser(id: string): Result<User> { ... }

const result = getUser("123");
if (result.ok) {
  result.value  // TypeScript knows this is User
} else {
  result.error  // TypeScript knows this is ErrorDetail
}
```

**Why discriminated unions over thrown errors:** TypeScript's `throw` is untyped — `catch (e)` gives you `unknown`, and nothing in the type system tells callers what a function might throw. Discriminated unions make error types explicit in the function signature, just like Rust's `Result<T, E>`.

**Typed error variants:** Discriminated unions shine when different errors need different handling:

```typescript
type FetchError =
  | { type: "network"; retryable: true }
  | { type: "auth"; expired: boolean }
  | { type: "notFound" }
```

TypeScript's exhaustive `switch` on the `type` field ensures every variant is handled. Adding a new variant causes a compile error at every unhandled switch — the same benefit as checked exceptions, without the verbosity.

**Libraries:** neverthrow and Effect-TS provide `Result` types with `map`, `flatMap`, and railway-oriented composition, bringing Rust-style ergonomics to TypeScript.

## Error Handling Antipatterns

| Antipattern | Problem | Fix |
|-------------|---------|-----|
| **Catching `Exception` (catch-all)** | Hides programming errors alongside expected failures | Catch specific exception types |
| **Swallowing exceptions** (`catch (e) {}`) | Silent failure; bugs become invisible | At minimum, log with full context; prefer re-signaling |
| **Exceptions for control flow** | Expensive, hard to reason about, violates Principle of Least Astonishment | Use conditional logic or Result types for expected cases |
| **Printing stack trace to stdout** | Output may be lost; not captured by logging systems | Use a logging framework that captures context |
| **Logging PII in error messages** | Privacy violations; regulatory risk | Sanitize error context before logging |
| **Ignoring compiler warnings** | Missed opportunities to catch errors at compile time | Treat warnings as errors in CI |

## Decision Tables

### "Which error signaling technique should I use?"

| Situation | Choose | Because |
|-----------|--------|---------|
| Caller can and should recover | Explicit (Result, checked exception) | Forces caller to acknowledge the error |
| Caller can't possibly recover | Implicit (unchecked exception, panic) | No point burdening callers with unrecoverable errors |
| Value may be absent (not an error) | Optional/nullable return type | Simpler than Result when "why" doesn't matter |
| Public API consumed by others | Explicit technique + domain exceptions | Callers need clear contracts; don't leak implementation |
| Internal code, same team | Either — team convention wins | Consistency matters more than the specific technique |
| Performance-critical hot path | Error codes or Result types | Exception stack traces are expensive (~10x); logging is ~30x |

### "How do I know my error handling is wrong?"

| Symptom | Likely Problem | Fix |
|---------|---------------|-----|
| Bugs manifest far from their cause | Not failing fast | Add input validation and precondition checks earlier |
| Errors go unnoticed for weeks | Hiding errors or not monitoring | Add alerting on error rates; stop suppressing exceptions |
| Error handling code is everywhere | Over-using explicit techniques | Consolidate handling into distinct layers |
| Callers don't know errors can happen | Using implicit techniques without documentation | Switch to explicit techniques or improve docs |
| Changing a library breaks callers | Leaking third-party exceptions | Wrap library exceptions in domain-specific types |
| Same error means different things | Overloading null or magic values | Use Result types with specific error variants |

## Checklist

Before shipping error handling code:

- [ ] **Recoverability assessed:** Each error classified as recoverable or not, from the caller's perspective
- [ ] **Explicit where needed:** Recoverable errors use techniques that force caller awareness
- [ ] **No hidden errors:** No default values, empty collections, or suppressed exceptions masking failures
- [ ] **Fail fast:** Invalid state detected and signaled at the earliest point
- [ ] **Third-party errors wrapped:** Public APIs don't leak library-specific exceptions
- [ ] **Async errors captured:** No fire-and-forget patterns that silently swallow failures
- [ ] **Error messages useful:** Type + message + stack trace provide enough context to debug
- [ ] **Team consistency:** Error handling approach matches the rest of the codebase

## See Also

- **software-tradeoffs** — Error handling strategy comparison table, exception wrapping tradeoffs `(see software-tradeoffs -> Error Handling: Exceptions vs. Alternatives)`
- **code-quality-foundations** — Reliability pillar, making code hard to misuse `(see code-quality-foundations -> Make Code Hard to Misuse)`
- **code-antipatterns** — Surprise antipatterns from hidden errors `(see code-antipatterns -> Surprise Antipatterns)`
- **refactoring-patterns** — Techniques for improving error handling in existing code `(see refactoring-patterns -> When to Refactor)`
