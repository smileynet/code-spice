# Architecture: code-spice

> Technical patterns, constraints, and conventions discovered during planning.
> Loaded by `/cook` for design context (~800 tokens target).
>
> code-spice is an **enhanced spice** — a domain knowledge addon for Line Cook that
> provides skills (like game-spice) AND additive commands + an agent. It enhances
> Line Cook's existing workflow, not replaces it.

## Layers

- **Plugin layer:** `.claude-plugin/plugin.json` — plugin metadata and registration
- **Skills layer:** `skills/<topic>/SKILL.md` — topic-based knowledge files with YAML frontmatter
- **Commands layer:** `commands/<name>.md` — slash commands with YAML frontmatter
- **Agents layer:** `agents/<name>.md` — subagent definitions with YAML frontmatter
- **Supplemental layer:** `skills/<topic>/<lang>.md` — language-specific examples (future)
- **Reference layer:** `docs/language-backfill.md` — tracking which languages need supplemental files

## Patterns

- **SKILL.md format:** YAML frontmatter (`name`, `description`) + markdown content
- **Keyword activation:** Description field in SKILL.md triggers loading during Line Cook phases
- **Progressive disclosure:** Use `<details><summary>` for expandable sections
- **Cross-references:** Use `(see code-X -> Section)` format between skills
- **Decision tables:** Quick-reference grids for actionable guidance
- **Before/After examples:** Show antipattern then fix
- **Skill size target:** 200-400 lines per SKILL.md (fits context window)

## Constraints

- No commands or agents — spices are pure knowledge
- Skills must activate via keyword matching in description field
- Must follow game-spice's established plugin.json format
- Content is synthesized knowledge, not copied text
- Each skill should be self-contained while cross-referencing related skills

## Conventions

- Skill names prefixed with `code-` (e.g., `code-readability`, `code-antipatterns`)
- Plugin name: `code-spice`
- Marketplace category: `domain-knowledge`
- Tags: `code-quality`, `spice`, `line-cook`, etc.
