---
name: refactoring-patterns
description: Refactoring patterns, techniques, and decision frameworks. Use when improving existing code structure, reducing complexity, eliminating code smells, choosing between refactoring approaches, or deciding when refactoring is worthwhile. Covers extraction, encapsulation, type-based refactoring, strategy patterns, modularity improvements, and compiler-guided transformation.
---

# Refactoring Patterns

## The Refactoring Pattern Catalog

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

## When to Refactor

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

## Smell-to-Pattern Mapping

### Structural Smells

| Smell | Signal | Refactoring Response |
|-------|--------|---------------------|
| **Long method** | Function exceeds 5-7 lines of logic | Extract Method |
| **Mixed abstraction levels** | Function both calls methods and does low-level work | Extract Method |
| **Deep nesting** | Conditionals nested 3+ levels | Extract Method, guard clauses |
| **if/else chains** | Type-checking with if/else on enums | Replace Type Code with Classes |
| **Getters and setters** | External code pulls data, transforms, pushes back | Eliminate Getter/Setter |
| **Common prefixes/suffixes** | Multiple functions share a prefix like `player_*` | Encapsulate Data |
| **Primitive obsession** | Related primitives passed together | Encapsulate Data |

### Dependency Smells

| Smell | Signal | Refactoring Response |
|-------|--------|---------------------|
| **Hard-coded dependencies** | Constructor creates its own collaborators | Inject dependencies through constructor |
| **Concrete class coupling** | Code depends on implementation, not interface | Extract Interface |
| **Feature envy** | Method uses another class's data more than its own | Push Code into Classes |
| **Leaking implementation details** | Return types expose internal layers | Wrap in domain-appropriate types |
| **Global state** | Shared mutable state makes code unsafe | Inject shared state as explicit dependency |

## The Invariant Hierarchy

Push invariants as high up this hierarchy as possible. Levels 1-2 are dramatically more reliable than 3-6.

| Level | Mechanism | Reliability |
|-------|-----------|-------------|
| 1. **Eliminate the invariant** | Redesign so the problem can't occur | Highest |
| 2. **Compiler-enforced** | Type system prevents violations | High |
| 3. **Runtime-enforced** | Assertions, guards, validation | Medium |
| 4. **Documented** | Comments, README, wiki | Low |
| 5. **Verbal** | Told during onboarding | Very low |
| 6. **Hoped for** | Undocumented assumption | None |

## "Which refactoring do I need?"

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

## Refactoring Checklist

Before:
- [ ] Tests exist for the code being refactored (or write them first)
- [ ] Problem is concrete — not refactoring for aesthetics
- [ ] Scope is bounded — refactoring one thing at a time

During:
- [ ] One pattern at a time — apply, verify, commit, then next
- [ ] Tests pass after each step
- [ ] Behavior unchanged — refactoring changes structure, not behavior

After:
- [ ] All tests still pass
- [ ] Code is simpler — if complexity increased, reconsider
- [ ] Names updated — new structure deserves new names
- [ ] Dead code deleted — refactoring often reveals unnecessary code
