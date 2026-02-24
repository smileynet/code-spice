# Code Spice

Code quality spice for [Line Cook](https://github.com/smileynet/line-cook) — decision frameworks, antipattern detection, refactoring patterns, tradeoff analysis, YAGNI guidance, dead code pruning, plan auditing, and a code quality critic agent.

## Quick Start

After [installing Line Cook](https://github.com/smileynet/line-cook#installation):

```bash
/plugin marketplace add smileynet/line-cook
/plugin install code@line-cook
/line:mise                                    # Plan a project
```

Update: `/plugin update code`

## What It Looks Like

Here's a scoping session with code-spice active. The skills inject code-quality-specific questions and frameworks automatically:

```
You: I need to add a payment processing module.

Claude: Let's think through the quality dimensions:

**What error handling strategy fits this module?**           ← error-handling-patterns
Payments are critical — errors must be explicit.
┌──────────────────┬─────────────────────────────────┐
│ Exceptions       │ Good for truly exceptional cases │
│ Result types     │ Best for expected failures       │
│ Error codes      │ Low-level, C-style APIs          │
│ Nullable         │ Avoid for critical paths          │
└──────────────────┴─────────────────────────────────┘
For payment processing, Result types make failures
explicit and force callers to handle them.

You: Result types. What about the API design?

Claude: Good. Now let's evaluate the tradeoffs:

**How flexible should the payment API be?**                  ← software-tradeoffs
┌─────────────────────┬──────────────────────────────┐
│ Simple & rigid      │ Fast to build, hard to extend │
│ Flexible & complex  │ Handles edge cases, more code │
│ Plugin-based        │ Extensible but over-engineered │
└─────────────────────┴──────────────────────────────┘
YAGNI says start simple. But payment providers change —
a thin adapter layer gives flexibility without complexity.
```

Each question comes from a different skill, but they flow as a natural conversation.

## When to Use

**Use code-spice when:**
- Planning a software project with `/line:mise`
- Making design decisions about error handling, API shape, or abstractions
- Implementing code during `/line:cook`
- Running `/line:plan-audit` to check plan quality
- Running `/line:serve` for enhanced code review with quality criteria
- Running `/code:tradeoff`, `/code:smell`, `/code:review-prep`, or `/code:prune`

**Skip it when:**
- Building a game (use [game-spice](https://github.com/smileynet/game-spice) instead)
- Working on infrastructure or ops tasks

## Commands

| Command | Description | When to Use |
|---------|-------------|-------------|
| `/code:tradeoff` | Systematic tradeoff analysis for design decisions | Evaluating competing approaches |
| `/code:smell` | Structured code smell detection on recent changes | Catching antipatterns before review |
| `/code:review-prep` | Context-aware self-review checklist | Preparing for code review |
| `/code:prune` | Interactive codebase pruning analysis | Dead code, unused deps, safe removal |

## Agents

| Agent | Description |
|-------|-------------|
| **code-quality-critic** | Reviews code quality against six pillars during `/line:serve`. |

## What's Inside

| Skill | Activates During | Key Content |
|-------|-------------------|------------|
| **code-quality-foundations** | `/brainstorm`, `/scope` | 4 goals table, 6 pillars table, abstraction/investment decision tables |
| **code-readability** | `/scope`, `/cook` | Comment decision table, readability checklist, documentation hierarchy |
| **code-naming** | `/scope`, `/cook` | Naming decision table, three questions test, antipattern tables |
| **refactoring-patterns** | `/scope`, `/cook` | 13-pattern catalog, smell-to-pattern mapping, invariant hierarchy |
| **error-handling-patterns** | `/scope`, `/cook` | Strategy decision table, recoverability framework, signaling comparison |
| **code-antipatterns** | `/scope`, `/plan-audit` | Top-10 severity table, antipattern-or-tradeoff table, context evaluation |
| **code-review** | `/serve`, `/cook` | Review goals, Triple-R pattern, severity labels, TWA template, 8 antipatterns |
| **code-testing-quality** | `/cook` | Quality checklist, test doubles table, antipattern catalog, coverage guidance |
| **software-tradeoffs** | `/brainstorm`, `/scope` | Tradeoff matrix, "which tradeoff?" table, "chose wrong?" diagnostics |
| **code-plan-audit** | `/plan-audit` | 10-point scorecard, actionability tests, plan-level antipatterns |
| **code-yagni** | `/brainstorm`, `/scope` | Build decision table, Kohavi stats, speculative generality signals |
| **code-scope-boundaries** | `/brainstorm`, `/scope` | Scope health checklist, feature belonging test, split-vs-keep tree |
| **code-pruning** | `/cook`, `/architecture-audit` | SCARF pattern, tool table, safe removal process, bloat metrics |

13 skills (~1,200 lines), 4 commands, 1 agent. Each skill is under 110 lines — focused on decision tables and checklists that change Claude's behavior, not prose Claude already knows.

## How It Works

Skills load automatically when Line Cook commands detect code project context.

```
 /brainstorm               /scope                        /plan-audit
┌────────────────────┐    ┌──────────────────────────┐    ┌──────────────────┐
│ code-quality-      │    │ code-readability         │    │ code-antipatterns │
│   foundations      │    │ code-naming              │    │ code-plan-audit   │
│ software-tradeoffs │───>│ refactoring-patterns     │───>│                   │
│ code-yagni         │    │ error-handling-patterns   │    └──────────────────┘
│ code-scope-        │    │ code-antipatterns         │
│   boundaries       │    │ software-tradeoffs        │
│                    │    │ code-yagni               │
│                    │    │ code-scope-boundaries    │
└────────────────────┘    └──────────────────────────┘

 /line:cook                 /line:serve
┌────────────────────┐    ┌──────────────────────────┐
│ code-readability   │    │ code-review              │
│ code-naming        │    │ code-quality-critic      │
│ refactoring-       │    │   (agent)                │
│   patterns         │    └──────────────────────────┘
│ error-handling-    │
│   patterns         │
│ code-review        │
│ code-testing-      │
│   quality          │
│ code-pruning       │
└────────────────────┘
```

## Source Material

Knowledge synthesized from four code quality books:

| Book | Key Contributions |
|------|-------------------|
| **Good Code, Bad Code** (Tom Long, 2021) | Quality pillars, error handling, antipatterns |
| **Five Lines of Code** (Christian Clausen, 2021) | Refactoring catalog, rule-based triggers |
| **Software Mistakes and Tradeoffs** (Lelek & Skeet, 2022) | Tradeoff frameworks, API design |
| **Looks Good to Me** (Braganza, 2025) | Code review process, AI-augmented review |

## FAQ

**Do I need to configure anything?**
No. Install the plugin and plan a project. Skills activate automatically.

**Does code-spice work without Line Cook?**
The skills are designed for Line Cook's `/mise` workflow. Without Line Cook, Claude won't have the planning commands that trigger these skills.

**What languages does it cover?**
The guidance is language-agnostic. Principles apply to any language.

**Can I use code-spice with game-spice?**
Yes. They cover different domains and activate on different keywords.

## Learn More

- [Changelog](CHANGELOG.md) — Version history
- [Skill Content Guide](docs/skill-content-guide.md) — What to put in a skill (and what to leave out)

## Local Development

```bash
/plugin marketplace add /home/sam/code/code-spice
```

## Requirements

- Claude Code >= 1.0.33
- [Line Cook](https://github.com/smileynet/line-cook) plugin

## License

MIT
