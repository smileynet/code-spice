# Planning Context: yagni-pruning

**Status:** archived
**Epic:** cs-bqx (Phase 6)
**Created:** 2026-02-15

## Problem

Codebases accumulate dead weight — unused code, speculative features, over-engineered abstractions, and scope creep — but developers and AI assistants are biased toward adding code, not removing it. Code Spice teaches how to write good code but lacks guidance for identifying and safely removing unnecessary code, features, and dependencies.

## Approach

Create a "subtractive" complement to Code Spice's existing "constructive" skills. Three new skills (`code-yagni`, `code-pruning`, `code-scope-boundaries`) and one new command (`/code:prune`) provide structured frameworks for detecting bloat, making build-vs-not-build decisions, safely removing dead code, and evaluating whether project scope has exceeded its useful boundaries.

## Key Decisions

- Separate Phase 6 epic rather than integrating into existing Phases 2-4 (avoids re-scoping finalized work)
- Three skills covering distinct aspects: decision framework (YAGNI), removal process (pruning), project-level analysis (scope boundaries)
- Subsumes the deferred `code-deletion-safety` skill from v0.2.0
- Synthesizes from existing book content (FLoC Ch 9/12, SM&T Ch 1/4) plus new research sources (Fowler, Meta SCARF, Goldman Sachs)
- `/code:prune` provides guidance and decision trees, not automated tool invocation
- Sequential feature dependencies: YAGNI skills first → Pruning skill → Prune command

## Artifacts

- Brainstorm: docs/planning/brainstorm-yagni-pruning.md
- Menu plan: docs/planning/menu-plan-yagni-pruning.yaml
- Architecture: docs/planning/context-yagni-pruning/architecture.md
- Decisions: docs/planning/context-yagni-pruning/decisions.log

## Scope

**Phases: 1, Features: 3, Tasks: 4**

- Phase 6: YAGNI & Code Pruning (3-4 sessions)
  - Feature 6.1: YAGNI and scope analysis during planning phases (2 tasks)
    - Create code-yagni skill
    - Create code-scope-boundaries skill
  - Feature 6.2: Dead code pruning guidance during maintenance (1 task)
    - Create code-pruning skill
  - Feature 6.3: Interactive pruning analysis command (1 task)
    - Create /code:prune command
