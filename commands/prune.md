---
name: prune
description: Interactive codebase pruning analysis — dead code, unused dependencies, speculative abstractions, scope boundaries, and prioritized removal plan
allowed-tools: Read, Glob, Grep, Bash, AskUserQuestion
---

## Summary

**Analyze a codebase for pruning opportunities.** References `code-pruning` for detection strategies and SCARF process, `code-yagni` for speculative generality signals, and `code-scope-boundaries` for scope health assessment.

**Arguments:** `$ARGUMENTS` (optional) - Path to analyze. Defaults to current working directory.

---

## Process

### Step 1: Gather Codebase Context

Use **AskUserQuestion** to collect context:

1. **Languages/frameworks** (multiple select): JS/TS, Python, Go, Java/Kotlin
2. **Project situation:** Active development, Mature/stable, Legacy, Post-migration
3. **Biggest concern:** Build/test times growing, Hard to understand what's used, Scope too broad, General health check

### Step 2: Dead Code Scan

Use language-appropriate tools from `code-pruning` skill's tool table. Scan for:
- **Unused files** — zero inbound imports/requires
- **Unreachable code** — disabled conditionals, post-return code

For each candidate, record: file/location, confidence (High/Medium/Low), type.

### Step 3: Unused Dependency Check

Find dependency manifests. Cross-reference each declared dependency against source imports. Check for false positives per `code-pruning` skill's false positive table.

### Step 4: Speculative Abstraction Detection

Apply signals from `code-yagni` skill's Speculative Generality Detection:
- Single-implementation interfaces
- Unused extension points
- Future-oriented naming

### Step 5: Scope Boundary Analysis

Apply `code-scope-boundaries` skill's frameworks:
- Utils/helpers ratio (<10% healthy, 10-25% warning, >25% critical)
- One-sentence test for project cohesion
- Cross-feature dependency check

### Step 6: Commented-Out Code Review

Scan for commented code blocks. Check age via git blame.

### Step 7: Produce Prioritized Removal Plan

Classify each finding by safety (Safe/Moderate/Risky) and effort (Quick/Medium/Major).

```
╔══════════════════════════════════════════════════════════════╗
║  PRUNING ANALYSIS REPORT                                     ║
╚══════════════════════════════════════════════════════════════╝

PROJECT CONTEXT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Languages: <detected>
  Situation: <from Step 1>
  Focus: <from Step 1>

FINDINGS SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
| Category                 | Found | High Conf | Action Items |
|--------------------------|-------|-----------|-------------|

PRIORITIZED REMOVAL PLAN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Start here (Safe + Quick):
  1. ...

Then (Safe + Medium effort):
  2. ...

Investigate further (Moderate safety):
  3. ...

Defer or instrument (Risky or Major effort):
  4. ...

SCOPE HEALTH
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Utils ratio: <n>% (<assessment>)
  Cohesion: <pass/warning/fail>

RECOMMENDED TOOLS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  <from code-pruning skill>

RECOVERY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  All removals recoverable via git:
    git log -G "function_name" --all
    git show <commit>~1:path/to/file
```

**Ordering:** Safe+Quick first (commented-out code, unused private functions, unused dev deps) → Safe+Medium → Moderate+Quick → Risky/Major.

---

## Example Usage

```
/code:prune
/code:prune src/
/code:prune packages/legacy-module
```
