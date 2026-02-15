# Test Specification: Create code-yagni skill

## Tracer
Prevention framework — proves YAGNI can be operationalized into actionable skill

## Context
- Sources: FLoC Ch 9, 12; SM&T Ch 1, 4; Fowler YAGNI article; Kohavi et al.
- Deliverable: skills/code-yagni/SKILL.md
- Target: 250-350 lines

## Validation Criteria

| Check | Expected | Notes |
|-------|----------|-------|
| SKILL.md exists | Valid markdown with YAML frontmatter | Must have name and description fields |
| Frontmatter name | "code-yagni" | Matches skill directory name |
| Frontmatter description | Contains activation keywords | "YAGNI", "build", "feature", "speculative", "unnecessary" |
| Quick Reference section | "Should I build this?" decision table | Primary actionable guidance |
| Four costs framework | Build, delay, carry, repair | From Fowler's YAGNI article |
| YAGNI vs good design | Clear distinction present | YAGNI ≠ skip tests or avoid clean code |
| Speculative generality | Detection signals listed | One-impl interfaces, unused extensions, test-only consumers |
| Build-vs-not-build | Decision framework with criteria | Concrete requirement, cost of later, codebase malleability |
| Bloat antipatterns | Gold plating, premature abstraction, kitchen sink | Catalog of prevention targets |
| Statistical case | 2/3 of features don't improve metrics | Kohavi et al. reference |
| Cross-references | Links to code-antipatterns, software-tradeoffs, refactoring-patterns | (see code-X -> Section) format |
| Line count | 250-350 lines | Within target range |
| Progressive disclosure | Uses `<details>` tags | For expandable sections |

## Content Quality
- [ ] Synthesizes across FLoC and SM&T (not just one source)
- [ ] Research augmentation (Fowler, Kohavi) validates key claims
- [ ] Actionable decision tables, not academic theory
- [ ] Clear scope boundary with code-antipatterns (feature-level vs implementation-level)
