# Test Specification: Create code-pruning skill

## Tracer
Removal process — the cure that complements YAGNI's prevention

## Context
- Sources: FLoC Ch 9, 12; GC/BC Ch 6-7; Meta SCARF; Goldman Sachs; Kent C. Dodds; language-specific tools
- Deliverable: skills/code-pruning/SKILL.md
- Target: 300-400 lines

## Validation Criteria

| Check | Expected | Notes |
|-------|----------|-------|
| SKILL.md exists | Valid markdown with YAML frontmatter | Must have name and description fields |
| Frontmatter name | "code-pruning" | Matches skill directory name |
| Frontmatter description | Contains activation keywords | "dead code", "pruning", "unused", "cleanup", "removal" |
| Quick Reference section | Pruning checklist and detection approach table | Scannable summary |
| Static analysis | Description of AST/dependency graph approach | Include limitations (reflection, eval) |
| Dynamic analysis | Description of runtime instrumentation approach | Include limitations (coverage) |
| Combined approach | Meta SCARF pattern described | Static + runtime + textual search |
| Tool recommendations | Language-specific tools with date stamps | Python (Vulture), JS/TS (Knip), Java (PMD), Go, multi-lang |
| Safe removal process | Multi-step process present | Identify → verify → deprecate → delete → test → audit |
| Dependency pruning | Unused deps, transitive awareness, false positives | Three aspects covered |
| Commented-out code | Elimination guidance present | Version control as safety net |
| Bloat metrics | At least 4 metrics listed | Dead code %, dep count, churn rate, build time |
| Lava flow antipattern | Description and detection | Code nobody is sure if it's still needed |
| Cross-references | Links to code-yagni, refactoring-patterns, code-antipatterns | (see code-X -> Section) format |
| Line count | 300-400 lines | Within target range |
| Progressive disclosure | Uses `<details>` tags | For expandable sections |

## Content Quality
- [ ] Synthesizes across books (FLoC, GC/BC) and research (Meta, Goldman Sachs)
- [ ] Tool recommendations are practical and dated (acknowledge tools change)
- [ ] Safe removal process is concrete and actionable
- [ ] Addresses false positive risk in dead code detection
