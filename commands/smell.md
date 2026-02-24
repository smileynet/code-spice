---
description: Structured code smell detection on recent changes
allowed-tools: Read, Glob, Grep, Bash
---

## Summary

**Scan code for antipatterns and code smells.** References the `code-antipatterns` skill for pattern categories and severity classification.

**Arguments:** `$ARGUMENTS` (optional) - File paths or glob patterns to scan. Defaults to recent git changes.

---

## Process

### Step 1: Collect Target Code

**If the user provided file paths in `$ARGUMENTS`:**
- Use those paths directly; expand glob patterns via Glob tool

**Otherwise**, collect recent changes:

```bash
git diff --name-only HEAD 2>/dev/null
git diff --name-only --cached 2>/dev/null
git diff --name-only HEAD~3..HEAD 2>/dev/null
```

Merge and deduplicate. Filter to source code files only (skip binaries, lock files, generated files, `.md` documentation).

If no changes found, inform the user to specify files.

### Step 2: Read Target Files

Read each target file using the Read tool. For large files (>500 lines), focus on changed regions.

### Step 3: Scan for Antipatterns

Apply the four antipattern categories from the **code-antipatterns** skill to each file:

- **Surprise** — Magic return values, hidden side effects, silent failures, misleading names, implicit ordering
- **Misuse** — Primitive obsession, mutable shared state, boolean blindness, stringly-typed code, unvalidated construction
- **Complexity** — Deep nesting (4+), god class/function, shotgun surgery, feature envy, long parameter lists (5+)
- **Premature** — Premature abstraction, speculative generality, premature optimization, over-engineering, dead flexibility

Use the severity classification from the **code-antipatterns** skill (Critical / Warning / Note).

### Step 4: Present Findings

```
╔══════════════════════════════════════════════════════════════╗
║  CODE SMELL REPORT                                          ║
╚══════════════════════════════════════════════════════════════╝

SCAN SCOPE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Files scanned: <count>
  Source: <git changes | specified files>

FINDINGS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Critical] <pattern-name>
  File: <file:line>
  Category: <Surprise|Misuse|Complexity|Premature>
  Description: <what the problem is>
  Suggested fix: <how to address it>

SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
| Category   | Critical | Warning | Note   |
|------------|----------|---------|--------|

Verdict: <CLEAN | HAS_WARNINGS | HAS_CRITICAL>
```

**Verdict logic:**
- `CLEAN` — No findings, or only Notes
- `HAS_WARNINGS` — Warnings but no Critical findings
- `HAS_CRITICAL` — One or more Critical findings

---

## Example Usage

```
/code:smell
/code:smell src/auth/login.ts src/auth/session.ts
/code:smell "src/**/*.py"
```
