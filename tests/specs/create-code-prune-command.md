# Test Specification: Create /code:prune command

## Tracer
Interactive pruning — applies all three skills' knowledge to a real codebase

## Context
- References: code-yagni, code-pruning, code-scope-boundaries skills
- Deliverable: commands/prune.md
- Pattern: Interactive analysis dialog (like /code:tradeoff)

## Validation Criteria

| Check | Expected | Notes |
|-------|----------|-------|
| Command file exists | Valid markdown with YAML frontmatter | commands/prune.md |
| Frontmatter name | "prune" or "code:prune" | Matches command invocation |
| Frontmatter description | Describes pruning analysis | Clear purpose statement |
| Allowed tools | Bash (git), Read, Grep, Glob | Tools needed for analysis |
| Context questions | Asks about languages, project age, team size, pain points | Step 1 of process |
| Dead code scan | Recommends language-appropriate tools | From code-pruning skill |
| Dependency check | Analyzes dependency manifests | From code-pruning skill |
| Speculative abstraction | Searches for one-impl interfaces, unused extensions | From code-yagni skill |
| Scope analysis | Applies cohesion test to modules | From code-scope-boundaries skill |
| Commented-out code | Greps for disabled code blocks | From code-pruning skill |
| Prioritized output | Safety x effort matrix | Safe/Moderate/Risky × Quick/Medium/Major |
| Removal order | Recommends safe + quick wins first | Practical prioritization |
| Skill references | References all three YAGNI/pruning skills | Cross-skill integration |

## Content Quality
- [ ] Process steps are concrete and ordered
- [ ] References specific frameworks from each skill
- [ ] Output format is structured and actionable
- [ ] Handles multiple languages gracefully
