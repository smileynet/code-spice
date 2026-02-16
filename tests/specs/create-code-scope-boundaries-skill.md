# Test Specification: Create code-scope-boundaries skill

## Tracer
Project-level analysis — extends YAGNI from features to project scope

## Context
- Sources: SM&T Ch 4; Fowler (breaking monoliths); SRP at project level; Strangler Fig pattern
- Deliverable: skills/code-scope-boundaries/SKILL.md
- Target: 250-350 lines

## Validation Criteria

| Check | Expected | Notes |
|-------|----------|-------|
| SKILL.md exists | Valid markdown with YAML frontmatter | Must have name and description fields |
| Frontmatter name | "code-scope-boundaries" | Matches skill directory name |
| Frontmatter description | Contains activation keywords | "scope", "boundaries", "split", "monolith", "cohesion" |
| Quick Reference section | Scope health checklist | Scannable summary |
| Cohesion test | SRP applied at project level | "Gather things that change for the same reasons" |
| Feature belonging | Assessment criteria present | Audience, cadence, deployment model |
| Scope creep warning signs | At least 5 warning signs listed | Including expanding scope, utils growth, no feature rejection |
| Split-vs-keep framework | Decision criteria for when to split and when NOT to split | Both directions covered |
| Safe splitting patterns | Strangler Fig, domain modeling, Conway's Law | At least 3 patterns |
| Cross-references | Links to code-yagni, software-tradeoffs | (see code-X -> Section) format |
| Line count | 250-350 lines | Within target range |
| Progressive disclosure | Uses `<details>` tags | For expandable sections |

## Content Quality
- [ ] Research-grounded (Fowler, Conway's Law references)
- [ ] Includes both "when to split" and "when NOT to split" (avoids bias toward splitting)
- [ ] Actionable checklists, not abstract principles
- [ ] Clear scope boundary with code-yagni (project-level vs feature-level)
