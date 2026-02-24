# Changelog

All notable changes to Code Spice will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.3.0] - 2026-02-24

### Changed

- **Right-sizing review**: Trimmed all 13 skills from ~4,200 to ~1,200 lines (-72%). Cut prose explanations, before/after code examples, and standard knowledge Claude already has. Kept decision tables, checklists, severity frameworks, and operational protocols — content that actually changes Claude's behavior when loaded.
- **Commands refactored**: All 4 commands now reference skills for knowledge instead of inlining duplicate content. Commands define workflow, skills define knowledge. (~960 to ~400 lines, -58%)
- **Agent simplified**: `code-quality-critic` stripped of pillar explanations. Keeps output format spec and lane definition. (~188 to ~80 lines)

### Added

- `docs/skill-content-guide.md` — User-facing guide explaining what provides value in LLM skills (decision frameworks, behavioral anchoring, empirical data, operational protocols, tool knowledge) vs. what wastes tokens (textbook explanations, before/after examples, language conventions, general best practices)
- `tests/smoke/validate.sh` — Consolidated validation script replacing 7 individual smoke tests. Checks all 13 skills, 4 commands, 1 agent, plugin structure, and content duplication

### Removed

- `tests/specs/` — Build specifications for skill creation (skills are built; spent instructions)
- `tests/features/` — BDD .feature files (can't meaningfully automate qualitative skill testing)
- 7 individual smoke test scripts (replaced by `validate.sh`)

### Moved

- `docs/planning/` → `docs/_archive/planning/` (build-time artifacts, useful history)
- `docs/features/` → `docs/_archive/features/` (acceptance criteria for completed features)

## [0.2.0] - 2026-02-18

### Added

- **Phase 6: YAGNI & Code Pruning** (cs-bqx) — "Subtractive" complement to the constructive MLP (Phases 1-5). Three knowledge skills and one interactive command for preventing feature bloat, detecting dead code, and evaluating project scope boundaries.
  - **code-yagni** skill — YAGNI decision frameworks: four costs of presumptive features, speculative generality detection, build-vs-not-build decision framework, bloat antipatterns
  - **code-scope-boundaries** skill — Project-level scope analysis: cohesion test, feature belonging assessment, scope creep warning signs, split-vs-keep decision framework
  - **code-pruning** skill — Dead code detection and safe removal: static/dynamic/combined (SCARF) analysis, language-specific tool recommendations, 6-step safe removal process, dependency pruning
  - **`/code:prune`** command — Interactive 7-step codebase pruning analysis with safety x effort prioritized removal plan

## [0.1.0] - 2026-02-15

### Added

Code quality spice for Line Cook — 10 knowledge skills, 3 interactive commands, and 1 automated review agent. Synthesized from four code quality books.

**Knowledge Skills**

- **code-quality-foundations** — Quality pillars, abstraction layers, tradeoff thinking, and the four goals of high-quality code.
- **code-readability** — Comments, function decomposition, nesting depth, code structure, and readability practices.
- **code-naming** — Descriptive naming, naming as documentation, conventions, and naming antipatterns.
- **refactoring-patterns** — Named refactoring catalog with trigger rules, decision frameworks, and before/after examples.
- **error-handling-patterns** — Exceptions vs Result types, recoverability framework, fail fast vs robustness.
- **code-antipatterns** — Categorized antipattern catalog with symptoms, examples, fixes, and severity classification.
- **code-review** — Review process, effective feedback, PR best practices, and AI-augmented review.
- **code-testing-quality** — Unit testing principles, test doubles, test structure, and testing antipatterns.
- **software-tradeoffs** — Duplication vs DRY, flexibility vs complexity, performance vs readability, build vs buy.
- **code-plan-audit** — Plan quality scorecard, completeness checks, antipattern risk, and readiness assessment.

**Interactive Commands**

- **`/code:tradeoff`** — Systematic tradeoff analysis for design decisions. Walks through a structured decision framework for competing approaches.
- **`/code:smell`** — Structured code smell detection on recent changes. Scans git diff for antipatterns with severity-categorized findings.
- **`/code:review-prep`** — Context-aware self-review checklist generation before `/line:serve` or manual code review.

**Automated Review**

- **code-quality-critic** agent — Automatically reviews code quality during `/line:serve`, covering readability, naming, error handling, antipatterns, and testability.

[Unreleased]: https://github.com/smileynet/code-spice/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/smileynet/code-spice/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/smileynet/code-spice/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/smileynet/code-spice/releases/tag/v0.1.0
