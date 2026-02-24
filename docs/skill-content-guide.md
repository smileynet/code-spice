# What to Put in a Skill (and What to Leave Out)

Skills inject knowledge into Claude's context window during specific workflow phases. But Claude already knows most software engineering concepts from training data. This guide explains what actually changes Claude's behavior when loaded as a skill, and what wastes tokens.

## The Core Principle

> "Claude is already very smart. Only add information Claude doesn't already have."
> — Anthropic skill authoring documentation

A focused 300-token context often outperforms an unfocused 113,000-token context. Every line in a SKILL.md competes with the user's conversation, system prompts, other skills, and Claude's own reasoning space. The question isn't "is this true?" — it's "does loading this change what Claude produces?"

## Five Types of High-Value Content

### 1. Decision Frameworks

Structured evaluation protocols with specific steps, criteria, and thresholds that force consistent reasoning.

**Why they work:** Claude can reason about any topic, but it won't spontaneously apply the *same* structured evaluation every time. A decision framework makes output predictable across sessions.

**Example — `code-plan-audit`'s 10-point scorecard:**

| Check | Severity | What Claude Evaluates |
|---|---|---|
| Has a clear goal statement | Blocker | Is the objective measurable? |
| Error paths identified | Warning | Are failure modes documented? |
| Dependencies listed | Warning | Are blockers and prerequisites named? |
| Test strategy defined | Blocker | Can you write tests from this? |

Without this skill loaded, Claude gives general "looks good" feedback. With it loaded, Claude audits against these exact checks in order with severity levels.

**The test:** Would Claude produce this exact evaluation structure unprompted? If not — it's high-value.

**Write:** Decision tables with columns. Flowcharts with branch points. Numbered checklists with severity/priority.

**Don't write:** Explanations of *why* each criterion matters.

### 2. Behavioral Anchoring

Consistent classification schemes, severity levels, category taxonomies, and output format specifications that make Claude apply the same labels and structure every time.

**Why it works:** Without anchoring, Claude might classify a code smell as "concerning" in one session and "critical" in another. Anchoring ensures consistent labels.

**Example — `code-antipatterns`'s severity classification:**

| Severity | Meaning | Action |
|---|---|---|
| **Critical** | Active risk of data loss, security breach, or production failure | Fix immediately |
| **Warning** | Ongoing cost in maintainability, reliability, or team velocity | Fix soon or create a ticket |
| **Note** | Code smell that may not warrant immediate action | Consider during refactoring |

**The test:** Does this content make Claude's output consistent across sessions? If removing it would cause different labels each time — keep it.

**Write:** Category taxonomies. Severity scales with definitions. Output format templates. Classification lookup tables.

**Don't write:** Explanations of each category member. Claude knows what "Silent Failure" is — it just needs to know you want it classified as Critical/Surprise.

### 3. Empirical Data

Specific statistics, research findings, and named frameworks from industry that Claude may know but won't reliably cite or apply unprompted.

**Why it works:** Empirical data anchors decisions in evidence. "Roughly 2/3 of features fail to improve their target metric (Kohavi et al., Microsoft)" carries more weight than "many features don't succeed."

**Example — `code-yagni`'s Kohavi statistics:**

> At Microsoft, only ~1/3 of features succeeded in improving their target metric. ~1/3 had neutral results. ~1/3 actually *hurt* the metric they were designed to improve.

**The test:** Would Claude cite this specific statistic unprompted, with source attribution? If not — keep it.

**Write:** Named statistics with sources. Research findings with context. Industry benchmarks. Named frameworks from specific companies.

**Don't write:** General industry wisdom. "Most projects fail" is common knowledge.

### 4. Operational Protocols

Step-by-step procedures with specific phases, checkpoints, and named stages that ensure nothing is skipped during a multi-step process.

**Why they work:** Without a protocol, Claude may skip steps, reorder phases, or miss checkpoints. A named protocol gives Claude a concrete procedure to follow.

**Example — `code-pruning`'s SCARF pattern (from Meta):**

| Phase | Action | Checkpoint |
|---|---|---|
| **S**urvey | Identify candidates via static analysis tools | List of candidates generated |
| **C**lassify | Categorize: dead, dormant, speculative, deprecated | Each candidate classified |
| **A**nnounce | Deprecation warnings, team notification | Stakeholders notified |
| **R**emove | Delete with tests verifying no breakage | All tests pass |
| **F**ollow-up | Monitor for regressions post-removal | No production issues after 1 week |

**The test:** Would Claude spontaneously produce this exact multi-step procedure with these specific phase names? If not — keep it.

**Write:** Named multi-step processes. Phase definitions with entry/exit criteria. Verification checkpoints.

**Don't write:** Motivation for why the process matters.

### 5. Current Tool Knowledge

Specific tool recommendations, version information, and ecosystem changes that may post-date Claude's training cutoff or be too niche for reliable recall.

**Example — `code-pruning`'s tool table:**

| Language | Tool | Notes |
|---|---|---|
| TypeScript | Knip | Supersedes ts-prune; handles re-exports |
| Python | Vulture | AST-based; configure min confidence |
| Go | deadcode | Official Go team tool (1.22+) |

**The test:** Is this information likely to be current and specific enough that Claude's training data might be outdated? If yes — keep it.

**Write:** Specific tool names with versions. "X supersedes Y" migration notes. Ecosystem-specific gotchas.

**Don't write:** General tool categories ("use a linter").

## What Wastes Tokens

### Textbook Explanations
Claude's training data includes every major software engineering textbook. Lines like "Readability is the foundation of code quality" add zero behavioral delta.

**Instead of** a paragraph about the test pyramid, **write:**

| Level | Count | Speed | Scope |
|---|---|---|---|
| Unit | Many | Fast | Single function/class |
| Integration | Some | Medium | Component boundaries |
| E2E | Few | Slow | User journeys |

The table is a behavioral anchor. The prose is a textbook excerpt Claude already has.

### Before/After Code Examples
Claude can generate equivalent examples on demand for any antipattern. Loading 20 lines showing "Silent Failure before/after" doesn't change behavior.

**Exception:** Examples showing a *non-obvious* transformation or language-specific idiom Claude might get wrong.

### Language-Specific Conventions
Claude knows camelCase vs snake_case, Go error patterns, TypeScript discriminated unions. A table mapping languages to naming conventions adds no value.

**Exception:** Tool-specific conventions (this project's `code-` naming prefix) or genuinely niche ecosystem patterns.

### General Best Practices
"Code is read more than written." "Keep functions small." "Avoid deep nesting." Universal knowledge — wasting tokens.

## The Litmus Test

For every section in a SKILL.md:

1. **Would Claude produce equivalent output without this loaded?** If yes — cut it.
2. **Does this make output more consistent across sessions?** If yes — keep it.
3. **Does this contain specific data, tools, or protocols Claude wouldn't spontaneously produce?** If yes — keep it.
4. **Is this a decision table or checklist?** Probably keep — tables are token-efficient behavioral anchors.
5. **Is this a prose paragraph explaining a concept?** Probably cut — Claude already knows the concept.

## Relationship to AGENTS.md

AGENTS.md covers **structural conventions** — file layout, naming, size targets, frontmatter format. This guide covers **content philosophy** — what goes inside those files to maximize behavioral delta per token.
