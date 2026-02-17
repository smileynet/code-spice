# Changelog

All notable changes to Code Spice will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **code-yagni** skill (cs-yqn) — YAGNI decision frameworks: four costs of presumptive features, speculative generality detection, build-vs-not-build decision framework, bloat antipatterns. Activates during `/brainstorm` and `/scope`.
- **code-scope-boundaries** skill (cs-iac) — Project-level scope analysis: cohesion test, feature belonging assessment, scope creep warning signs, split-vs-keep decision framework, safe splitting patterns. Activates during `/architecture-audit`.

## [0.1.0] - 2026-02-15

### Launch

Code quality spice for Line Cook — 10 skills, 3 commands, 1 agent. Synthesized from four code quality books.

### Knowledge Skills

- **code-quality-foundations** — Quality pillars, abstraction layers, tradeoff thinking, and the four goals of high-quality code. Activates during `/brainstorm` and `/scope`.
- **code-readability** — Comments, function decomposition, nesting depth, code structure, and readability practices. Activates during `/scope` and `/cook`.
- **code-naming** — Descriptive naming, naming as documentation, conventions, and naming antipatterns. Activates during `/scope` and `/cook`.
- **refactoring-patterns** — Named refactoring catalog with trigger rules, decision frameworks, and before/after examples. Activates during `/scope` and `/cook`.
- **error-handling-patterns** — Exceptions vs Result types, recoverability framework, fail fast vs robustness. Activates during `/scope` and `/cook`.
- **code-antipatterns** — Categorized antipattern catalog with symptoms, examples, fixes, and severity classification. Activates during `/scope` and `/plan-audit`.
- **code-review** — Review process, effective feedback, PR best practices, and AI-augmented review. Activates during `/serve` and `/cook`.
- **code-testing-quality** — Unit testing principles, test doubles, test structure, and testing antipatterns. Activates during `/cook`.
- **software-tradeoffs** — Duplication vs DRY, flexibility vs complexity, performance vs readability, build vs buy. Activates during `/brainstorm` and `/scope`.
- **code-plan-audit** — Plan quality scorecard, completeness checks, antipattern risk, and readiness assessment. Activates during `/plan-audit`.

### Interactive Commands

- **`/code:tradeoff`** — Systematic tradeoff analysis for design decisions. Walks through a structured decision framework for competing approaches.
- **`/code:smell`** — Structured code smell detection on recent changes. Scans git diff for antipatterns with severity-categorized findings.
- **`/code:review-prep`** — Context-aware self-review checklist generation before `/line:serve` or manual code review.

### Automated Code Review

- **code-quality-critic** agent — Reviews code quality using pillar-based criteria during `/line:serve`. Covers readability, naming, error handling, antipatterns, and testability.

### Source Material

Knowledge synthesized from: Good Code, Bad Code (Tom Long, 2021), Five Lines of Code (Christian Clausen, 2021), Software Mistakes and Tradeoffs (Lelek & Skeet, 2022), Looks Good to Me (Braganza, 2025).

[0.1.0]: https://github.com/smileynet/code-spice/releases/tag/v0.1.0
