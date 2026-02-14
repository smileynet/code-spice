# Test Specification: Scaffold plugin directory structure

## Tracer
Foundation — proves plugin structure is valid for Claude Code

## Context
- Create .claude-plugin/plugin.json following game-spice pattern
- Set name: code, version: 0.1.0
- Create skills/, commands/, agents/ directories
- Create docs/language-backfill.md

## Validation Criteria

| Check | Expected | Notes |
|-------|----------|-------|
| .claude-plugin/plugin.json exists | Valid JSON | Must parse without errors |
| plugin.json name field | "code" | Not "code-spice" |
| plugin.json version field | "0.1.0" | Semantic versioning |
| plugin.json keywords | Array with code quality terms | At minimum: "code-quality", "spice", "line-cook" |
| skills/ directory exists | Directory created | Will hold SKILL.md files |
| commands/ directory exists | Directory created | Will hold command markdown files |
| agents/ directory exists | Directory created | Will hold agent markdown files |
| docs/language-backfill.md exists | File with tracking table | Lists target languages |

## Edge Cases
- [ ] plugin.json validates against Claude Code plugin schema
- [ ] Keywords cover all major skill topics for discoverability
- [ ] language-backfill.md lists all 4 source book languages + backfill targets
