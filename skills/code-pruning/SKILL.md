---
name: code-pruning
description: Dead code detection strategies, safe removal processes, dependency pruning, and bloat metrics for systematically reducing codebase dead weight. Use when evaluating codebase health during architecture-audit, performing cleanup during cook, reviewing unused dependencies, removing commented-out code, or measuring code bloat.
---

# Code Pruning

## Pruning Checklist

- [ ] Static analysis tools run for all project languages
- [ ] SCARF phases followed (Survey → Classify → Announce → Remove → Follow-up)
- [ ] Each removal verified by test suite
- [ ] Dependency manifest audited for unused packages
- [ ] Commented-out code deleted (version control remembers)
- [ ] Bloat metrics captured before and after

## Detection Approaches

| Approach | How It Works | Confidence | Limitation |
|----------|-------------|------------|------------|
| **Static analysis** | Parse AST, trace references | High for unused exports/functions | Misses dynamic dispatch, reflection |
| **Dynamic analysis** | Runtime instrumentation, coverage | High for executed paths | Misses rarely-used paths (disaster recovery, seasonal) |
| **Combined (SCARF)** | Static + dynamic + team review | Highest | Requires team coordination |
| **Manual review** | Human inspection, git blame | Variable | Doesn't scale; subjective |

## SCARF Pattern (from Meta)

| Phase | Action | Checkpoint |
|-------|--------|------------|
| **S**urvey | Run static analysis tools; identify candidates | Candidate list generated |
| **C**lassify | Categorize each: dead, dormant, speculative, deprecated | Each candidate classified |
| **A**nnounce | Deprecation warnings; notify stakeholders | Team aware of pending removals |
| **R**emove | Delete with tests verifying no breakage | All tests pass after removal |
| **F**ollow-up | Monitor production for regressions; verify no side effects | No production issues after 1 week |

**For smaller teams:** Compress Announce into a PR description or commit message. The key phases are Survey, Classify, and Remove-with-tests.

## Language-Specific Tools (current as of Feb 2026)

| Language | Tool | Notes |
|----------|------|-------|
| JS/TS | **Knip** | Supersedes ts-prune; handles re-exports, dependencies, and unused files |
| JS/TS | depcheck | Focused on unused npm dependencies |
| Python | **Vulture** | AST-based dead code detection; configure `--min-confidence 80` |
| Python | autoflake | Removes unused imports and variables |
| Java | PMD | Static analysis rules for unused code |
| Go | **deadcode** | Official Go team tool (1.22+); superior to `unused` |
| Multi | SonarQube | Cross-language; includes unused code rules |

## Safe Removal Process (6 Steps)

1. **Identify** — Run static analysis; flag zero-reference code
2. **Verify with dynamic data** — Check code coverage, production logs, feature flags
3. **Deprecate** — Add deprecation warnings; set removal date
4. **Delete** — Remove code in atomic, single-concern commits
5. **Test** — Full test suite passes; no integration regressions
6. **Audit** — Post-removal monitoring for 1 week; check error rates

## Dependency Pruning

### Common False Positives

| False Positive | How to Verify |
|----------------|---------------|
| Peer dependency | Check if required by another installed package |
| CLI tool | Check npm scripts, Makefile, CI config |
| Plugin/loader | Check config files (webpack, babel, pytest, etc.) |
| Type-only import | Check `.d.ts` files and type annotations |

## Bloat Metrics

| Indicator | Healthy | Warning | Critical |
|-----------|---------|---------|----------|
| Unreachable code ratio | <5% | 5-15% | >15% |
| Unused dependency count | 0-2 | 3-5 | >5 |
| Commented-out code blocks | 0 | 1-5 | >5 |
| Single-implementation interfaces | <3 | 3-10 | >10 |

## Decision Tables

### "How confident am I that this code is dead?"

| Evidence | Confidence | Action |
|----------|-----------|--------|
| Zero static references + zero runtime coverage | High | Delete (with tests) |
| Zero static refs but in error/recovery path | Medium | Verify with team before deleting |
| Referenced only by tests | Medium | Delete code and tests together |
| Referenced by commented-out code only | High | Delete both |
| Dynamic dispatch possible (reflection, eval) | Low | Instrument before deleting |

### "Should I prune this dependency?"

| Signal | Action |
|--------|--------|
| Zero imports in source code | Remove (check for false positives first) |
| Only in devDependencies, not used in scripts | Remove |
| Imported but functionality is unused | Replace with lighter alternative or remove |
| Peer dependency of another package | Keep — removing breaks the dependent |
| Last updated >2 years, no maintained fork | Plan migration to maintained alternative |
