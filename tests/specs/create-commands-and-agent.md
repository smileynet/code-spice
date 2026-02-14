# Test Specification: Commands and Agent

## Common Validation Criteria for Commands

Every command markdown must pass these checks:

| Check | Expected | Notes |
|-------|----------|-------|
| YAML frontmatter | Valid with name, description | Following line-cook command format |
| Allowed tools listed | Appropriate tools for the command | Bash, Read, Grep, etc. |
| Process steps | Clear numbered steps | Each step actionable |
| Skill references | References relevant code-spice skills | Leverages knowledge base |
| Output format | Structured output defined | Users know what to expect |

## /code:tradeoff Command
- [ ] Asks user to describe design decision
- [ ] Catalogs tradeoff dimensions (6+)
- [ ] Walks through relevant dimensions with questions
- [ ] Produces structured analysis with recommendation
- [ ] Optionally integrates with /line:decision

## /code:smell Command
- [ ] Collects changes via git diff
- [ ] References code-antipatterns skill catalog
- [ ] Scans for 4 antipattern categories
- [ ] Categorizes findings (Critical/Warning/Note)
- [ ] Reports with pattern name, location, suggested fix

## /code:review-prep Command
- [ ] Analyzes git diff
- [ ] Identifies change categories (new/refactor/bugfix/feature)
- [ ] Generates tailored checklist
- [ ] References code-review and code-antipatterns skills

## code-quality-critic Agent
- [ ] Valid agent frontmatter (name, description, tools)
- [ ] Reads changed files
- [ ] Applies 5 quality criteria from skills
- [ ] Categorizes findings by severity
- [ ] Suggests fixes referencing refactoring-patterns
- [ ] Complements (not replaces) sous-chef agent
