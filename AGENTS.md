# Agent Instructions

This project uses **bd** (beads) for issue tracking. Run `bd onboard` to get started.

## Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --status in_progress  # Claim work
bd close <id>         # Complete work
bd sync               # Sync with git
```

## Development Workflow

1. **Find work:** `bd ready` to see unblocked tasks
2. **Claim it:** `bd update <id> --status in_progress`
3. **Implement:** Follow TDD — write test, make it pass, refactor
4. **Verify:** Run smoke tests (see below), check skill activates correctly
5. **Close:** `bd close <id>` with semantic context comment
6. **Push:** `bd sync && git push`

### Smoke Testing

No automated test runner. Validate manually:

```bash
# Plugin structure
test -f .claude-plugin/plugin.json && echo "OK: plugin.json exists"
python3 -c "import json; json.load(open('.claude-plugin/plugin.json'))" && echo "OK: valid JSON"

# Skill validation (replace <skill-name>)
test -f skills/<skill-name>/SKILL.md && echo "OK: SKILL.md exists"
head -1 skills/<skill-name>/SKILL.md | grep -q "^---" && echo "OK: has frontmatter"
```

### Local Development Install

```bash
/plugin marketplace add /home/sam/code/code-spice
```

## Skill Authoring Conventions

### File Structure

Each skill lives in `skills/<skill-name>/SKILL.md` with YAML frontmatter:

```yaml
---
name: <skill-name>
description: <keyword-rich description that triggers activation during Line Cook phases>
---
```

### Naming

- Prefix skill directories with `code-` (e.g., `code-readability`, `code-antipatterns`)
- Exceptions: `software-tradeoffs`, `refactoring-patterns`, and `error-handling-patterns` use their domain name directly

### Size Target

200-400 lines per SKILL.md. Use `<details><summary>` for progressive disclosure when content would exceed the target.

### Content Patterns

- **Quick Reference** section at top with decision tables
- **Cross-references** between skills: `(see code-X -> Section)`
- **Before/After examples** for antipatterns and refactoring
- **Decision tables** for actionable guidance
- Synthesized knowledge, not copied text from source material

### Keyword Activation

The `description` field in frontmatter controls when Claude loads the skill. Include terms matching what users discuss during each Line Cook phase:

| Phase | Example Keywords |
|-------|-----------------|
| `/brainstorm` | quality, tradeoffs, design decisions |
| `/scope` | readability, naming, error handling, antipatterns |
| `/cook` | refactoring, testing, implementation |
| `/plan-audit` | antipatterns, plan quality, audit |
| `/serve` | code review, feedback |

### Command Authoring

Commands live in `commands/<name>.md` with YAML frontmatter specifying `name`, `description`, and `allowed-tools`. They provide interactive workflows that reference skill knowledge.

### Agent Authoring

Agents live in `agents/<name>.md` with YAML frontmatter specifying `name`, `description`, and `tools`. Agents act as subagents during Line Cook phases (e.g., `/line:serve`).

## Landing the Plane (Session Completion)

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:
   ```bash
   git pull --rebase
   bd sync
   git push
   git status  # MUST show "up to date with origin"
   ```
5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

**CRITICAL RULES:**
- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds
