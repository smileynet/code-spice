---
name: refactoring-patterns
description: Refactoring patterns, techniques, and decision frameworks. Use when improving existing code structure, reducing complexity, eliminating code smells, choosing between refactoring approaches, or deciding when refactoring is worthwhile. Covers extraction, encapsulation, type-based refactoring, strategy patterns, modularity improvements, and compiler-guided transformation.
---

# Refactoring Patterns

Systematic techniques for improving code structure without changing behavior. Refactoring is not cleanup — it is a disciplined practice of making code easier to understand, change, and extend by applying small, verifiable transformations.

## Quick Reference

### The Refactoring Pattern Catalog

| Pattern | What It Does | When to Use | Risk |
|---------|-------------|-------------|------|
| **Extract Method** | Break long function into named steps | Function exceeds 5-7 lines or mixes abstraction levels | Low |
| **Inline Method** | Remove unnecessary indirection | Method adds no clarity; just delegates | Low |
| **Replace Type Code with Classes** | Turn enums/constants into class hierarchies | if/else or switch on type codes | Medium |
| **Push Code into Classes** | Move logic from callers into the class it belongs to | Logic about a class lives outside it | Medium |
| **Specialize Method** | Create focused versions of overly general methods | Method has parameters used only in some call sites | Low |
| **Try Delete Then Compile** | Delete code and let the compiler verify safety | Suspected dead code, unused parameters | Low |
| **Unify Similar Classes** | Merge classes that differ only in constants | Near-duplicate classes with identical structure | Medium |
| **Combine Ifs** | Merge consecutive ifs with identical bodies | Repeated conditional blocks | Low |
| **Introduce Strategy Pattern** | Extract varying behavior into strategy objects | Multiple classes share structure but differ in behavior | High |
| **Extract Interface** | Create interface from existing implementation | Need to decouple consumers from concrete class | Medium |
| **Eliminate Getter/Setter** | Move behavior to where the data lives | External code pulls data, operates, pushes back | Medium |
| **Encapsulate Data** | Wrap related variables in a class | Loose variables travel together across functions | Medium |
| **Enforce Sequence** | Use constructors to guarantee operation ordering | Methods must be called in a specific order | Medium |

### When to Refactor

```
Is there a concrete problem?
├── No → Don't refactor. "If it ain't broke, don't fix it."
└── Yes → What kind of problem?
    ├── Hard to understand → Extract Method, rename, Encapsulate Data
    ├── Hard to change → Push Code into Classes, Extract Interface
    ├── Duplicated logic → Unify Similar Classes, Introduce Strategy
    ├── Scattered conditionals → Replace Type Code with Classes
    ├── Wrong abstraction level → Inline Method, Specialize Method
    └── Dead or unused code → Try Delete Then Compile
```

## Code Smell Triggers

Refactoring is triggered by recognizable structural problems. These rules identify when code needs transformation.

### Structural Smells

| Smell | Signal | Refactoring Response |
|-------|--------|---------------------|
| **Long method** | Function exceeds 5-7 lines of logic | Extract Method |
| **Mixed abstraction levels** | Function both calls methods and does low-level work | Extract Method — either call or pass, don't do both |
| **Deep nesting** | Conditionals nested 3+ levels | Extract Method, restructure conditionals to top of function |
| **if/else chains** | Type-checking with if/else on enums or type codes | Replace Type Code with Classes, Push Code into Classes |
| **switch statements** | Switching on type codes | Replace Type Code with Classes (switch is if/else in disguise) |
| **Getters and setters** | External code pulls data, transforms it, pushes it back | Eliminate Getter/Setter, Push Code into Classes |
| **Common prefixes/suffixes** | Multiple functions share a prefix like `player_*` | Encapsulate Data — the prefix names the missing class |
| **Primitive obsession** | Related primitives passed together (`x, y` instead of `Point`) | Encapsulate Data |

### Dependency Smells

| Smell | Signal | Refactoring Response |
|-------|--------|---------------------|
| **Hard-coded dependencies** | Constructor creates its own collaborators via `new` | Inject dependencies through constructor parameters |
| **Concrete class coupling** | Code depends on implementation, not interface | Extract Interface, depend on abstraction |
| **Inheritance hierarchies** | Deep inheritance tree, fragile base class | Replace inheritance with composition; use interfaces for type hierarchies |
| **Feature envy** | Method uses another class's data more than its own | Push Code into Classes — move logic to where data lives |
| **Leaking implementation details** | Return types or exceptions expose internal layers | Wrap returns/exceptions in domain-appropriate types |
| **Global state** | Shared mutable state makes code unsafe to reuse | Inject shared state as explicit dependency |

## Pattern Details

### Extract Method

Break a long function into smaller, named functions where each reads like a single sentence.

**Process:**
1. Identify a block of code that does one coherent thing
2. Extract it into a new function with a descriptive name
3. Pass needed variables as parameters, return results
4. Verify behavior is unchanged

**Key insight:** The name of the extracted function is more valuable than the code inside it. If you can't name the extraction clearly, the boundary is wrong.

**Inverse:** Inline Method — when an extracted function adds indirection without adding clarity, fold it back into the caller.

`(see code-quality-foundations -> The One-Sentence Test)`

### Inline Method

Remove a method that no longer adds clarity by folding its body back into the caller. The inverse of Extract Method.

**Process:**
1. Identify a method whose name adds no information beyond what the code itself says
2. Copy the method body into each call site
3. Replace the method call with the inlined code
4. Delete the now-unused method

**When to use:** After other refactorings, methods sometimes become trivial one-liners that just delegate. If the method name doesn't improve readability over the code itself, inline it. Unnecessary indirection is a form of complexity.

### Replace Type Code with Classes

Eliminate if/else and switch statements by converting type codes (enums, string constants, integers) into class hierarchies where behavior varies by type.

**Process:**
1. Create a class for each value of the type code
2. Move the type-specific behavior into each class as a method
3. Replace conditionals with polymorphic method calls
4. Delete the original type code and conditionals

**Why it matters:** Adding a new type with if/else means finding and updating every switch point. With classes, you add a new class — existing code is untouched. This is change by addition, not modification.

**Guard:** Only apply when behavior genuinely varies by type. If the conditional is a one-off check, a simple if is fine.

`(see code-quality-foundations -> Make Code Hard to Misuse)`

### Push Code into Classes

Move logic from external functions into the class that owns the data. This is the most impactful everyday refactoring — it transforms procedural code into object-oriented code.

**Process:**
1. Identify logic that operates on a class's data from outside
2. Create a method on the class that performs that logic
3. Replace external code with a call to the new method
4. If the method uses getters, make them private or eliminate them

**The principle:** Classes should care about themselves. When external code reaches into a class to get data, transforms it, and pushes it back, the logic belongs inside the class.

`(see code-naming -> Functions: Verb + Noun)`

### Specialize Method

Create less-general versions of a method by removing parameters that aren't needed by specific call sites.

**Process:**
1. Identify a method where some callers always pass the same value for a parameter
2. Create a new method without that parameter, hard-coding the constant value
3. Update callers to use the specialized version
4. If no callers remain for the general version, delete it

**When to use:** A method that takes 5 parameters but most callers only vary 2 of them is a candidate. Specialization makes the common case simple.

### Try Delete Then Compile

Delete suspicious code, then let the compiler tell you if anything depends on it. The compiler is a better judge of dead code than human intuition.

**Process:**
1. Delete the code (method, parameter, class, import)
2. Compile / run type checker
3. If it compiles cleanly — the code was dead. Commit the deletion
4. If it fails — restore and investigate the dependencies

**Philosophy:** Developers are afraid to delete code because they can't be sure it's unused. The compiler *can* be sure. Collaborate with the compiler — let it do what it's good at (exhaustive analysis) while you do what you're good at (judgment about design).

**Limitation:** Only works for statically verifiable dependencies. Won't catch reflection, dynamic dispatch, or runtime-only references. For those, use coverage tools or feature flags.

### Unify Similar Classes

Merge near-duplicate classes that share the same structure but differ only in constant values.

**Process:**
1. Identify two or more classes with identical method signatures
2. Find methods that differ — they should differ only in returned constants
3. Introduce a field (basis) to hold the varying value
4. Merge the classes into one, parameterized by the field
5. Delete the now-redundant classes

**Guard:** Only unify when the classes are *genuinely* similar — same structure, same behavior, different constants. If behavior will diverge in the future, keep them separate.

`(see software-tradeoffs -> Duplication vs. Coupling)`

### Combine Ifs

Merge consecutive if statements that have identical bodies into a single if using `||`. This simplifies control flow and enables further simplification through boolean arithmetic.

**Process:**
1. Identify consecutive if blocks with the same body
2. Combine their conditions with `||`
3. Simplify the resulting boolean expression if possible
4. Verify behavior is unchanged

**Why it matters:** Repeated conditional blocks obscure the underlying logic. Combining them reveals the true condition, which is often simpler than it appeared. Once combined, boolean algebra (De Morgan's laws, double negation elimination) may simplify further.

### Introduce Strategy Pattern

Extract varying behavior from similar classes into strategy objects, enabling composition over inheritance.

**Process:**
1. Identify classes that share structure but differ in specific behaviors
2. Define an interface for the varying behavior (the strategy)
3. Create concrete strategy implementations for each variant
4. Replace the varying behavior in the original classes with a strategy field
5. Inject the appropriate strategy at construction time

**Key distinction:** This is the most sophisticated pattern — it converts inheritance-based variation into composition-based variation. The result is more flexible (strategies can be swapped at runtime) but more complex (more classes, more indirection).

**Guard:** Only introduce when you have 3+ variants or need runtime flexibility. For 2 variants, a simple if may be clearer.

`(see software-tradeoffs -> Flexibility vs. Complexity)`

### Extract Interface

Create an interface from an existing concrete class to decouple consumers from implementation.

**Process:**
1. Identify consumers that depend on a concrete class
2. Create an interface with the methods consumers actually use
3. Make the concrete class implement the interface
4. Update consumers to depend on the interface

**Timing:** Don't create interfaces preemptively. Wait until you have a concrete reason — a second implementation, a testing need, or a consumer that shouldn't know the implementation details. An interface with only one implementation is overhead, not abstraction.

`(see code-quality-foundations -> Should I Abstract This?)`

### Eliminate Getter/Setter

Replace data-pulling patterns with behavior-pushing patterns. Instead of asking an object for its data and operating on it externally, tell the object what to do.

**Process:**
1. Make the getter private
2. Compiler errors reveal external code that depends on the data
3. Move that logic into the class as a new method (Push Code into Classes)
4. Once no external code needs the getter, delete it

**Why it matters:** Getters expose internal representation. Once exposed, every consumer couples to the data format. Eliminating getters forces behavior to live where the data lives, improving encapsulation and enabling internal changes without breaking callers.

### Encapsulate Data

Wrap related variables and the functions that operate on them into a class.

**Process:**
1. Identify variables that always travel together (common parameter groups, shared prefixes)
2. Create a class with those variables as private fields
3. Add getters/setters initially to avoid breaking callers
4. Move logic that operates on the data into the class
5. Eliminate getters/setters as logic moves inward

**The signal:** When multiple functions share a common prefix (`player_move`, `player_score`, `player_health`), the prefix names the missing class (`Player`).

`(see code-naming -> Classes: Noun + Role)`

### Enforce Sequence

Use constructors to guarantee that operations happen in the correct order, making invalid sequences unrepresentable.

**Process:**
1. Encapsulate the method that must run last into a class
2. Make the constructor call the method that must run first
3. The object cannot exist without the sequence having been followed

**Example:** If `initialize()` must be called before `process()`, make the constructor call `initialize()` and expose only `process()` publicly. A caller cannot forget the initialization step because the constructor enforces it.

**Broader principle:** Localizing invariants. Instead of documenting "you must call A before B" and hoping callers comply, make the compiler enforce it structurally.

`(see code-quality-foundations -> Make Code Hard to Misuse)`

## Refactoring Philosophy

### Collaborate with the Compiler

The compiler is your most reliable refactoring partner. Its strengths complement yours:

| Compiler Strengths | Human Strengths |
|-------------------|-----------------|
| Exhaustive analysis (checks every path) | Judgment about design and intent |
| Never forgets a reference | Understanding business context |
| Catches type mismatches instantly | Recognizing patterns across domains |
| Tireless — checks millions of lines | Creativity in naming and structure |

**The invariant hierarchy** (ordered by reliability):
1. **Eliminate the invariant** — redesign so the problem can't occur
2. **Compiler-enforced** — type system prevents violations
3. **Runtime-enforced** — assertions, guards, validation
4. **Documented** — comments, README, wiki
5. **Verbal** — told during onboarding
6. **Hoped for** — undocumented assumption

Push invariants as high up this hierarchy as possible. Levels 1-2 are dramatically more reliable than 3-6.

### Prefer Change by Addition

When adding new behavior, prefer adding new code over modifying existing code. Replace Type Code with Classes exemplifies this — adding a new type means adding a new class, not editing switch statements. Existing code that works continues to work; new code is isolated and testable.

### Love Deleting Code

Every line of code is a liability. Code must be understood, tested, maintained, and debugged. Less code means fewer bugs, faster onboarding, and easier changes.

**Practices:**
- Use Try Delete Then Compile regularly
- After refactoring, look for code that became unnecessary
- Don't comment out code — delete it (version control remembers)
- Resist adding code "just in case"

### Composition over Inheritance

Inheritance creates tight coupling — the child inherits the parent's entire public API, creating an implicit contract that's hard to change. Problems include fragile base class, diamond problem, leaked abstraction layers, and inability to swap implementations.

**Prefer:** Composition (containing instances) + interfaces (defining contracts). Use Introduce Strategy Pattern or Extract Interface to migrate from inheritance to composition.

`(see software-tradeoffs -> Flexibility vs. Complexity)`

### Modularity through Injection

Hard-coded dependencies make code untestable and rigid. Dependency injection — passing collaborators through constructors rather than creating them internally — is the foundational technique for modularity.

**Injection enables:**
- Testing with mocks/stubs
- Swapping implementations without modifying the class
- Making dependencies explicit and visible

**Keep functions focused:** Functions should take only the parameters they need. A function that accepts a `User` object but only uses `user.email` should take an email string instead — this makes it reusable in contexts where no `User` exists.

`(see code-quality-foundations -> Make Code Modular)`

## Modern Refactoring Support (2024-2026)

| Tool Category | Examples | Best For |
|--------------|---------|----------|
| **IDE-native** | IntelliJ, WebStorm, PyCharm | Mechanical transformations (Extract, Rename, Move, Inline) — compiler-verified, atomic |
| **AI-assisted** | Copilot, Cursor, Claude Code | Multi-file structural changes, pattern migrations, design-level refactoring |
| **Static analysis** | SonarQube, ESLint, language linters | Identifying code smells as a refactoring backlog |

**Best practice:** Always use IDE refactoring over manual edits when available — automated tools update all references atomically, eliminating human error. Use AI tools for structural changes that span multiple files. Treat static analysis warnings as signals, not mandates.

## Decision Tables

### "Which refactoring do I need?"

| You're struggling with... | Primary Pattern | Supporting Pattern |
|--------------------------|----------------|-------------------|
| Function too long to understand | Extract Method | Specialize Method |
| if/else chains on type codes | Replace Type Code with Classes | Push Code into Classes |
| Changing one thing breaks another | Extract Interface | Dependency injection |
| Duplicated code across classes | Unify Similar Classes | Introduce Strategy Pattern |
| Data exposed through getters | Eliminate Getter/Setter | Push Code into Classes |
| Related variables scattered | Encapsulate Data | Enforce Sequence |
| Suspected dead code | Try Delete Then Compile | — |
| Methods must be called in order | Enforce Sequence | Encapsulate Data |
| Deep inheritance tree | Extract Interface + composition | Introduce Strategy Pattern |

### "How do I know the refactoring worked?"

| Symptom Before | Expected After | If Not Improved |
|---------------|---------------|-----------------|
| Long methods requiring scrolling | Methods fit on screen, read as sentences | Extract more aggressively, or check abstraction levels |
| Scattered conditionals for same type | One class per type, behavior is polymorphic | Ensure all switch/if-else points were converted |
| External code manipulates class internals | Class methods handle their own behavior | Look for remaining getters revealing internal state |
| Changes require editing many files | Changes localized to one class or module | Check for remaining coupling or shared assumptions |
| Hard to write tests | Dependencies injectable, functions focused | Look for remaining static methods, global state, or hidden I/O |

## Refactoring Checklist

Before refactoring:
- [ ] **Tests exist** for the code being refactored (or write them first)
- [ ] **Problem is concrete** — not refactoring for aesthetics
- [ ] **Scope is bounded** — refactoring one thing at a time

During refactoring:
- [ ] **One pattern at a time** — apply, verify, commit, then next
- [ ] **Tests pass after each step** — never batch multiple transformations
- [ ] **Behavior unchanged** — refactoring changes structure, not behavior

After refactoring:
- [ ] **All tests still pass** — including integration and E2E
- [ ] **Code is simpler** — if complexity increased, reconsider the refactoring
- [ ] **Names updated** — new structure deserves new names that reflect it
- [ ] **Dead code deleted** — refactoring often reveals unnecessary code

## Common Mistakes

### Refactoring Without Tests

Refactoring without tests is rewriting. You have no way to verify that behavior is preserved. Write characterization tests first — tests that capture current behavior, even if that behavior is imperfect.

### Refactoring Everything at Once

Large refactorings fail because they change too many things simultaneously. When something breaks, you can't isolate the cause. Apply one pattern, verify, commit. Then apply the next.

### Premature Abstraction

Extracting an interface before you have two implementations, creating a strategy before you have three variants, or building a plugin system for one plugin. Wait for the concrete need.

`(see software-tradeoffs -> Flexibility vs. Complexity)`

### Refactoring as a Substitute for Understanding

If you don't understand what the code does, refactoring won't help — you'll just rearrange the confusion. Read, trace, and understand first. Refactoring is for code you understand but want to restructure.

## See Also

- **code-quality-foundations** — Quality pillars that refactoring serves, the one-sentence test, abstraction decisions `(see code-quality-foundations -> Pillars in Detail)`
- **software-tradeoffs** — DRY vs. coupling, flexibility vs. complexity, when duplication beats abstraction `(see software-tradeoffs -> Core Tradeoffs)`
- **code-naming** — Naming refactored code, naming as documentation `(see code-naming -> Core Principles)`
- **code-antipatterns** — Patterns that indicate refactoring is needed `(see code-antipatterns -> Pattern Recognition)`
- **code-readability** — Readability as the primary goal of most refactoring `(see code-readability -> Naming and Structure)`
