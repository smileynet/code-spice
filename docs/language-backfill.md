# Language Backfill Tracking

Code Spice skills are synthesized from books that use specific languages for examples. This table tracks which skills need language-specific supplemental files to serve developers working in other languages.

## Source Book Languages

| Book | Primary Language |
|------|-----------------|
| Good Code, Bad Code | Java-like pseudocode |
| Five Lines of Code | TypeScript |
| Software Mistakes and Tradeoffs | Java |
| Looks Good to Me | Language-agnostic |

## Backfill Targets

| Language | Priority | Rationale |
|----------|----------|-----------|
| Python | High | Most common scripting language, different idioms from Java/TS |
| Rust | Medium | Ownership model changes error handling and refactoring patterns |
| Go | Medium | Simplicity-first philosophy, different error handling conventions |
| C++ | Low | Memory management adds unique antipatterns and tradeoffs |

## Skill Coverage Matrix

| Skill | Core Language | Python | Rust | Go | C++ |
|-------|--------------|--------|------|-----|-----|
| code-quality-foundations | Java-like | - | - | - | - |
| code-readability | Java-like/TS | - | - | - | - |
| code-naming | Java-like/TS | - | - | - | - |
| refactoring-patterns | TypeScript | - | - | - | - |
| error-handling-patterns | Java-like | - | - | - | - |
| code-antipatterns | Mixed | - | - | - | - |
| code-review | Agnostic | n/a | n/a | n/a | n/a |
| software-tradeoffs | Java | - | - | - | - |
| code-testing-quality | Java-like | - | - | - | - |
| code-plan-audit | Synthesized | - | - | - | - |

**Legend:** n/a = language-agnostic (no backfill needed), `-` = not yet created
