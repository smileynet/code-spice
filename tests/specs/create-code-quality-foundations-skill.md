# Test Specification: Create code-quality-foundations skill

## Tracer
First skill — proves content extraction and SKILL.md format work end-to-end

## Context
- Source: Good Code Bad Code Ch 1-2, Software Mistakes & Tradeoffs Ch 1
- Deliverable: skills/code-quality-foundations/SKILL.md
- Target: 200-400 lines

## Validation Criteria

| Check | Expected | Notes |
|-------|----------|-------|
| SKILL.md exists | Valid markdown with YAML frontmatter | Must have name and description fields |
| Frontmatter name | "code-quality-foundations" | Matches skill directory name |
| Frontmatter description | Contains activation keywords | "quality", "abstraction", "code goals", "pillars" |
| Quick Reference section | Present with quality pillars table | Scannable summary |
| Quality pillars covered | Works, keeps working, adaptable, doesn't reinvent | From Good Code Bad Code |
| Layers of abstraction | Guidance on abstraction layers | From Good Code Bad Code Ch 2 |
| Decision tables | At least one decision table | Actionable guidance format |
| Cross-references | Links to other code-spice skills | (see code-X -> Section) format |
| Line count | 200-400 lines | Within target range |
| Progressive disclosure | Uses `<details>` tags | For expandable sections |

## Content Quality
- [ ] Synthesizes across books (not just one source)
- [ ] Research augmentation validates key claims
- [ ] Language-specific examples preserved from source books
- [ ] Actionable, not academic
