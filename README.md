# Code Spice

Code quality spice for [Line Cook](https://github.com/smileynet/line-cook) — quality pillars, readability patterns, refactoring catalog, error handling strategies, antipattern detection, code review practices, testing guidance, tradeoff analysis, plan auditing, and a code quality critic agent.

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

You: Adapter layer, minimal interface.

Claude: Smart. Let me check for antipatterns in this design:

**Any naming or readability concerns?**                      ← code-naming
Your adapter interface should use domain language:
  ChargeResult, not PaymentResponse
  PaymentGateway, not Adapter
  amount_cents, not val
Names should make the payment domain obvious.
```

Each question comes from a different skill, but they flow as a natural conversation. Code-spice doesn't change what Line Cook does — it changes what Claude *knows to ask about* during planning and implementation.

## When to Use

**Use code-spice when:**
- Planning a software project with `/line:mise`
- Scoping features and need quality-focused guidance
- Making design decisions about error handling, API shape, or abstractions
- Implementing code during `/line:cook` and want refactoring or naming guidance
- Running `/line:plan-audit` to check plan quality
- Running `/line:serve` for enhanced code review with quality criteria
- Running `/code:tradeoff` to systematically evaluate design alternatives
- Running `/code:smell` to detect antipatterns in recent changes
- Running `/code:review-prep` to prepare a self-review checklist

**Skip it when:**
- Building a game (use [game-spice](https://github.com/smileynet/game-spice) instead)
- Working on infrastructure or ops tasks (code-spice focuses on application code quality)

## Commands

| Command | Description | When to Use |
|---------|-------------|-------------|
| `/code:tradeoff` | Systematic tradeoff analysis for design decisions | Evaluating competing approaches (DRY vs duplication, flexibility vs simplicity, build vs buy) |
| `/code:smell` | Structured code smell detection on recent changes | Catching antipatterns before code review |
| `/code:review-prep` | Generate a context-aware self-review checklist | Preparing for `/line:serve` or manual code review |

## Agents

| Agent | Description |
|-------|-------------|
| **code-quality-critic** | Reviews code quality using pillar-based criteria — readability, naming, error handling, antipatterns, and testability. Activates during `/line:serve` for enhanced quality feedback beyond structural review. |

## What's Inside

| Skill | Activates During | Key Topics |
|-------|-------------------|------------|
| **code-quality-foundations** | `/brainstorm`, `/scope` | Quality pillars, abstraction layers, tradeoff thinking, four goals of high-quality code |
| **code-readability** | `/scope`, `/cook` | Comments, function decomposition, nesting depth, code structure |
| **code-naming** | `/scope`, `/cook` | Descriptive naming, naming as documentation, conventions, naming antipatterns |
| **refactoring-patterns** | `/scope`, `/cook` | Refactoring catalog, trigger rules, decision frameworks, before/after examples |
| **error-handling-patterns** | `/scope`, `/cook` | Exceptions vs Result types, recoverability, fail fast vs robustness |
| **code-antipatterns** | `/scope`, `/plan-audit` | Categorized antipattern catalog, symptoms, examples, fixes, severity classification |
| **code-review** | `/serve`, `/cook` | Review process, effective feedback, PR best practices, AI-augmented review |
| **code-testing-quality** | `/cook` | Unit testing principles, test doubles, test structure, testing antipatterns |
| **software-tradeoffs** | `/brainstorm`, `/scope` | Duplication vs DRY, flexibility vs complexity, performance vs readability, build vs buy |
| **code-plan-audit** | `/plan-audit` | Plan quality scorecard, completeness checks, antipattern risk, readiness assessment |

10 skills, 3 commands, 1 agent.

## How It Works

Skills load automatically when Line Cook commands detect code project context. No configuration needed — skill descriptions contain trigger keywords that Claude matches against.

```
 /brainstorm               /scope                        /plan-audit
┌────────────────────┐    ┌──────────────────────────┐    ┌──────────────────┐
│ code-quality-      │    │ code-readability         │    │ code-antipatterns │
│   foundations      │    │ code-naming              │    │ code-plan-audit   │
│ software-tradeoffs │───>│ refactoring-patterns     │───>│                   │
│                    │    │ error-handling-patterns   │    └──────────────────┘
│                    │    │ code-antipatterns         │
│                    │    │ software-tradeoffs        │
└────────────────────┘    └──────────────────────────┘

 /line:cook                 /line:serve
┌────────────────────┐    ┌──────────────────────────┐
│ code-readability   │    │ code-review              │
│ code-naming        │    │ code-quality-critic      │
│ refactoring-       │    │   (agent)                │
│   patterns         │    └──────────────────────────┘
│ error-handling-    │
│   patterns         │     /code:tradeoff
│ code-review        │    ┌──────────────────────────┐
│ code-testing-      │    │ Tradeoff analysis dialog  │
│   quality          │    └──────────────────────────┘
└────────────────────┘
                           /code:smell
                          ┌──────────────────────────┐
                          │ Antipattern scan on diff  │
                          └──────────────────────────┘

                           /code:review-prep
                          ┌──────────────────────────┐
                          │ Self-review checklist      │
                          └──────────────────────────┘
```

Skills can activate in multiple phases — `code-antipatterns` appears in both scope and plan-audit because antipattern awareness matters during design and during review.

## Source Material

Knowledge is synthesized from four code quality books:

| Book | Key Contributions |
|------|-------------------|
| **Good Code, Bad Code** (Tom Long, 2021) | Quality pillars, abstraction layers, error handling, readability, antipatterns, testing |
| **Five Lines of Code** (Christian Clausen, 2021) | Refactoring catalog, rule-based triggers, code structure |
| **Software Mistakes and Tradeoffs** (Lelek & Skeet, 2022) | Tradeoff frameworks, duplication vs flexibility, API design |
| **Looks Good to Me** (Braganza, 2025) | Code review process, effective feedback, AI-augmented review |

Content is synthesized and augmented with research — not copied. Each skill cross-references related skills for comprehensive coverage.

## FAQ

**Do I need to configure anything?**
No. Install the plugin and plan a project. Skills activate automatically based on what you're discussing.

**Does code-spice work without Line Cook?**
The skills are designed for Line Cook's `/mise` workflow (brainstorm → scope → finalize). Without Line Cook, Claude won't have the planning commands that trigger these skills.

**What languages does it cover?**
The guidance is language-agnostic. Examples from source books use Java-like pseudocode, TypeScript, and Java, but the principles apply to any language.

**Can I use code-spice with game-spice?**
Yes. They cover different domains (code quality vs game design) and activate on different keywords. Both can be installed simultaneously.

## Learn More

- [Changelog](CHANGELOG.md) — Version history

## Local Development

```bash
/plugin marketplace add /home/sam/code/code-spice
```

## Requirements

- Claude Code >= 1.0.33
- [Line Cook](https://github.com/smileynet/line-cook) plugin (for mise workflow integration)

## License

MIT
