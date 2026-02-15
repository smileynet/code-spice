# Architecture: yagni-pruning

> Technical patterns, constraints, and conventions for the YAGNI & Pruning epic.

## Skill Structure

All skills follow the established Code Spice patterns (see `context-code-spice/architecture.md`):
- YAML frontmatter (`name`, `description`) with keyword activation
- 200-400 lines per SKILL.md
- Progressive disclosure via `<details><summary>`
- Cross-references via `(see code-X -> Section)` format
- Decision tables for actionable guidance

## Skill Boundaries

### `code-yagni`
- **Focus:** Decision frameworks for "build vs. not build"
- **Scope:** YAGNI principle, four costs of presumptive features, speculative generality detection, scope boundary questioning during planning
- **Activation:** Brainstorm, Scope
- **Cross-refs:** `code-antipatterns` (implementation-level antipatterns), `software-tradeoffs` (build vs. not build as tradeoff category)

### `code-pruning`
- **Focus:** Detection and safe removal of existing dead weight
- **Scope:** Dead code detection strategies (static + dynamic), safe removal process, dependency pruning, commented-out code elimination, tool recommendations by language
- **Activation:** Architecture-Audit, Cook
- **Cross-refs:** `refactoring-patterns` (removal as refactoring), `code-yagni` (prevention vs. cure)

### `code-scope-boundaries`
- **Focus:** Project-level scope analysis
- **Scope:** Cohesion test at project level, split-vs-keep decision framework, feature belonging assessment, scope creep warning signs, Strangler Fig pattern for safe splitting
- **Activation:** Brainstorm, Architecture-Audit
- **Cross-refs:** `code-yagni` (feature-level scope), `software-tradeoffs` (monolith vs. split tradeoff)

## Command Structure

### `/code:prune`
- **Type:** Interactive analysis dialog (like `/code:tradeoff`)
- **Flow:** Walks user through structured detection checklist → produces prioritized removal candidates
- **Sections:** Dead code scan guidance, unused dependency check, speculative abstraction detection, scope boundary analysis, commented-out code review
- **Output:** Prioritized list of removal candidates with safety assessment and recommended approach

## Constraints

- Skills provide frameworks and decision guidance, not automated tool execution
- Tool recommendations are language-tagged and date-stamped (tools change frequently)
- Scope boundaries are clear: YAGNI = prevention, Pruning = cure, Scope Boundaries = project-level
- No overlap with `code-antipatterns` — that skill covers implementation antipatterns (surprise, misuse, complexity); YAGNI skills cover architectural/feature-level antipatterns
