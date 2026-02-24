# Planning Context: code-spice

**Status:** archived
**Epic:** cs-jwh (Phase 1), cs-ilx (Phase 2), cs-n4l (Phase 3), cs-hdb (Phase 4), cs-hkf (Phase 5)
**Created:** 2026-02-13

## Problem

AI coding assistants lack structured, curated knowledge about software engineering best practices and antipatterns. Line Cook's planning and audit phases have no code-quality-specific expertise to inject during workflows, unlike game-spice for game projects.

## Approach

Create a topic-based spice addon (code-spice) that synthesizes knowledge from curated coding books into SKILL.md files. Start with 4 code quality books (Good Code Bad Code, Five Lines of Code, Software Mistakes and Tradeoffs, Looks Good to Me) and produce 8 skills covering quality foundations, readability, refactoring, error handling, antipatterns, code review, software tradeoffs, and plan auditing. Augment book knowledge with web research to validate and fill gaps.

## Key Decisions

- Topic-based skill organization (not book-per-skill or workflow-phase-based)
- Full plugin (not just spice) — includes commands and an agent alongside skills
- MLP scoped to 4 code quality books, not all 12+ uploads
- 10 skills + 3 commands + 1 agent for MLP
- Language-specific examples captured as-is from books; maintain a reference file of languages to backfill later
- Research augments books (validate + fill gaps), not books-only or deep-research

## Artifacts

- Brainstorm: docs/planning/brainstorm-code-spice.md
- Menu plan: docs/planning/menu-plan.yaml
- Architecture: docs/planning/context-code-spice/architecture.md
- Decisions: docs/planning/context-code-spice/decisions.log

## Scope

**Phases: 5, Features: 8, Tasks: 17**

- Phase 1: Plugin Foundation & Tracer (1-2 sessions)
  - Feature 1.1: Installable plugin with first knowledge skill (2 tasks)
- Phase 2: Code Fundamentals Knowledge (4-5 sessions)
  - Feature 2.1: Code quality guidance for brainstorm/scope (3 tasks)
  - Feature 2.2: Implementation guidance for cook (2 tasks)
- Phase 3: Review & Audit Knowledge (3-4 sessions)
  - Feature 3.1: Antipattern detection for plan-audit (2 tasks)
  - Feature 3.2: Code review & testing guidance for serve/cook (2 tasks)
- Phase 4: Interactive Commands & Agent (3-4 sessions)
  - Feature 4.1: Tradeoff analysis command (1 task)
  - Feature 4.2: Code smell detection command (1 task)
  - Feature 4.3: Review preparation & quality critic (2 tasks)
- Phase 5: Documentation & Release (1-2 sessions)
  - Feature 5.1: Plugin documented and marketplace-ready (3 tasks)
