---
name: code-naming
description: Naming decisions for variables, functions, classes, constants, and APIs. Use when choosing names, reviewing naming quality, refactoring unclear names, or establishing naming conventions. Covers descriptive naming, naming as documentation, language-specific conventions, and common naming antipatterns.
---

# Code Naming

Names are the primary interface between humans and code. A well-chosen name eliminates the need for comments, prevents misuse, and makes code self-documenting. A poor name creates confusion that compounds with every reader.

## Quick Reference

### The Naming Decision Table

| You're naming a... | It should read like... | Form | Examples |
|---------------------|----------------------|------|----------|
| **Class / Type** | A noun or noun phrase | PascalCase (most langs) | `UserProfile`, `HttpClient`, `InvoiceParser` |
| **Function / Method** | A verb or verb phrase | camelCase or snake_case | `validateEmail`, `send_invoice`, `calculateTotal` |
| **Boolean** | A yes/no question | `is`/`has`/`can`/`should` prefix | `isActive`, `hasPermission`, `canRetry` |
| **Collection** | A plural noun | Plural form | `users`, `pendingOrders`, `activeConnections` |
| **Constant** | A named fact | UPPER_SNAKE_CASE (most langs) | `MAX_RETRY_COUNT`, `DEFAULT_TIMEOUT_MS` |
| **Interface** | A capability or contract | Language-specific | `Serializable`, `IDisposable`, `Reader` |
| **Enum** | A set of named options | PascalCase values | `Color.Red`, `RetryPolicy.ALLOW_RETRY` |
| **Event / Callback** | What happened or will happen | Past/present tense | `onClick`, `onUserCreated`, `handleSubmit` |

### The Three Questions Test

Before committing to a name, verify it answers all three:

1. **What is it?** — The name identifies what the thing represents
2. **What does it do?** — For functions: the action is clear from the name alone
3. **What are the boundaries?** — The name hints at scope, lifetime, or constraints

If a name requires a comment to be understood, the name is wrong.

## Core Principles

### Names Replace Comments

Comments explaining *what* code does are a naming failure. If you need a comment like `// check if user has permission`, the function should be named `hasPermission()`.

Comments that explain *why* remain valuable — naming cannot capture historical context, business decisions, or non-obvious constraints. But every "what" comment is an opportunity to improve a name instead.

```
// Bad: comment explains what the code does
int d; // elapsed time in days

// Good: name explains itself
int elapsedDays;
```

When you see `data[0]` and `data[1]` with a comment explaining which is first name and which is last name, extract `firstName(data)` and `lastName(data)` functions instead.

### Descriptive Beats Short

Nondescriptive names force readers to hold a mental lookup table. Names like `T`, `pns`, `s`, and `f()` make code opaque — you can't understand what the code does without reading every implementation detail.

**Length should match scope.** A loop counter `i` in a 3-line loop is fine. A variable used across 50 lines or a public API needs a full descriptive name. The wider the scope, the more descriptive the name must be.

```
// Bad: reader has no idea what this does
Int? s(List<T> ts, String n) {
  for (T t in ts) {
    if (t.f(n)) { return t.getS(); }
  }
  return null;
}

// Good: the code reads like prose
Int? findScore(List<Team> teams, String playerName) {
  for (Team team in teams) {
    if (team.hasPlayer(playerName)) { return team.getScore(); }
  }
  return null;
}
```

### One Word Per Concept

Pick one term for each concept and use it everywhere. Don't mix `fetch`, `retrieve`, and `get` for the same operation. Don't alternate between `controller`, `manager`, and `driver` for the same architectural role.

Consistency enables pattern recognition. When a reader sees `getUserById`, they should be able to predict `getOrderById` exists — not wonder whether it's called `fetchOrder` or `retrieveOrder`.

### Use Domain Language

Names should use the vocabulary of the problem domain. Accountants understand `ledger`, `journal`, `posting`. Use those terms, not generic substitutes like `dataStore` or `recordList`.

When the domain doesn't apply, use well-known computer science terms: `queue`, `stack`, `factory`, `registry`, `cache`.

## Naming Patterns

### Functions: Verb + Noun

Functions perform actions. Name them as verb phrases that describe the action and its target.

| Pattern | When to Use | Examples |
|---------|------------|---------|
| `verb + noun` | General actions | `sendMessage`, `validateInput`, `parseConfig` |
| `is/has/can + adjective` | Boolean queries | `isValid`, `hasPermission`, `canRetry` |
| `to + target` | Conversions | `toString`, `toJson`, `toCelsius` |
| `from + source` | Factory methods | `fromJson`, `fromString`, `fromMap` |
| `on + event` | Event handlers | `onClick`, `onError`, `onTimeout` |

### Classes: Noun + Role

Classes represent things. Their names should be nouns that indicate what they model and optionally their architectural role.

| Pattern | Examples | Note |
|---------|---------|------|
| Domain concept | `Invoice`, `User`, `ShoppingCart` | Preferred — maps to the domain |
| Concept + role | `UserRepository`, `InvoiceParser` | When role adds clarity |
| Pattern name | `ConnectionFactory`, `EventBus` | When implementing a known pattern |
| Adjective + concept | `CachedWordService`, `ReadOnlyCollection` | Decorators and variants |

### Constants: Named Facts

Every hard-coded value in code carries two pieces of information: *what the value is* (the computer needs this) and *what the value means* (engineers need this). Named constants provide the meaning.

```
// Bad: what do these numbers mean?
return 0.5 * mass * 907.1847 * Math.pow(speed * 0.44704, 2);

// Good: constants explain the domain
private const KILOGRAMS_PER_US_TON = 907.1847;
private const METERS_PER_SECOND_PER_MPH = 0.44704;
return 0.5 * mass * KILOGRAMS_PER_US_TON *
    Math.pow(speed * METERS_PER_SECOND_PER_MPH, 2);
```

An alternative to named constants is a well-named helper function: `toKilograms(massInUsTons)` is even more readable and can be reused.

### Parameters: Make Calls Readable

Function calls should be understandable at the call site, without looking up the definition.

```
// Bad: what do 1 and true mean?
sendMessage("hello", 1, true);

// Better: descriptive types
sendMessage("hello", new MessagePriority(1), RetryPolicy.ALLOW_RETRY);

// Also better: named arguments (where supported)
sendMessage(message: "hello", priority: 1, allowRetry: true);
```

When a language doesn't support named arguments, consider using descriptive types (enums, wrapper classes) or builder patterns to make call sites readable.

## Naming Antipatterns

### Names That Lie

| Antipattern | Problem | Fix |
|-------------|---------|-----|
| `accountList` when it's a Set | Wrong data structure in name | `accounts` (just use plural) |
| `processData_v2` | Version control in names | Use version control, not naming |
| `getUser()` that also logs and caches | Name doesn't reveal side effects | `fetchAndCacheUser()` or split |
| `isEnabled` that modifies state | Query name hides a command | Separate query from mutation |

### Names That Don't Try

| Antipattern | Problem | Fix |
|-------------|---------|-----|
| `data`, `info`, `item`, `thing` | Generic to the point of meaningless | Use domain-specific terms |
| `tmp`, `val`, `x` beyond tiny scope | Forces reader to track mentally | `currentTemperature`, `retryCount` |
| `manager`, `handler`, `processor` | Vague role descriptions | Describe *what* it manages |
| `utils`, `helpers`, `misc` | Grab-bag namespaces | Group by domain or operation |

### Names That Mislead

| Antipattern | Problem | Fix |
|-------------|---------|-----|
| Inconsistent casing (`connectionManager` for a class) | Readers assume variables are lowercase | Follow language conventions exactly |
| Abbreviations (`usrRepo`, `passwd`, `calc`) | Ambiguous unless universally known | Spell it out: `userRepository`, `password` |
| Noise words (`UserData` vs `UserInfo`) | Indistinguishable without reading code | Pick one and be consistent |
| Negated booleans (`isNotActive`, `disableCheck`) | Double negatives in conditions | Use positive: `isActive`, `enableCheck` |

### Names That Over-Specify

| Antipattern | Problem | Fix |
|-------------|---------|-----|
| Hungarian notation (`strName`, `iCount`) | Type system already encodes types | Just `name`, `count` |
| Gratuitous prefix (`GSDAccountService`) | Every class in app has same prefix | Use namespaces/packages |
| `AbstractBase` + `Impl` suffix | Naming the pattern not the concept | `UserService` (interface) + `DefaultUserService` |

## Language Convention Quick Reference

| Convention | Languages | Variables | Functions | Classes | Constants |
|-----------|-----------|-----------|-----------|---------|-----------|
| **camelCase + PascalCase** | Java, JS/TS, Kotlin, Swift | camelCase | camelCase | PascalCase | UPPER_SNAKE |
| **snake_case + PascalCase** | Python, Ruby | snake_case | snake_case | PascalCase | UPPER_SNAKE |
| **PascalCase exports** | Go | camelCase | PascalCase (exported) | PascalCase | PascalCase |
| **snake_case + PascalCase** | Rust | snake_case | snake_case | PascalCase | SCREAMING_SNAKE |
| **PascalCase public** | C# | camelCase | PascalCase | PascalCase | PascalCase |
| **Mixed** | C++ (Google) | snake_case | PascalCase | PascalCase | kPascalCase |

**Acronym handling varies:**
- Java/C#: Preserve uppercase (`URL`, `HTTP`) — `loadHTTPURL`
- Go/Rust: Treat as word (`Url`, `Http`) — `LoadHttpUrl`
- Most style guides: camelCase acronyms in mid-word (`loadHttpUrl`)

**Follow your team's style guide.** Consistency within a codebase matters more than any universal convention.

## Naming as Code Contract

Names are the first thing engineers look at when figuring out how to use code. The typical reading order:

1. **The names of things** — classes, functions, parameters
2. **The data types** — what goes in, what comes out
3. **The documentation** — if they're still confused
4. **The code itself** — last resort

This means names carry the heaviest communication burden. A function named `processData()` says almost nothing about its contract. A function named `validateAndNormalizeEmail(rawInput: String) -> EmailAddress` communicates input expectations, transformation behavior, and output guarantees — all from the signature alone.

## Decision Checklist

When naming or renaming, verify:

- [ ] Name reveals intent without needing a comment
- [ ] Name uses domain vocabulary where applicable
- [ ] Name follows language/project conventions
- [ ] Name is distinguishable from similar names nearby
- [ ] Name is pronounceable (can be discussed verbally)
- [ ] Name is searchable (not a single letter or common word in wide scope)
- [ ] Boolean names read as yes/no questions
- [ ] Function names describe the action (verb phrases)
- [ ] Class names describe the thing (noun phrases)
- [ ] No abbreviations unless universally understood (`URL`, `HTTP`, `API`)

## See Also

- **code-quality-foundations** — Readability pillar, the one-sentence test for functions `(see code-quality-foundations -> Make Code Readable)`
- **code-readability** — Comment strategy, function decomposition `(see code-readability -> Naming and Structure)`
- **code-antipatterns** — Surprise antipatterns caused by misleading names `(see code-antipatterns -> Surprise Antipatterns)`
