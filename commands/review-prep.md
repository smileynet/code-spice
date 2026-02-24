---
description: Generate a context-aware self-review checklist before code review
allowed-tools: Read, Glob, Grep, Bash
---

## Summary

**Prepare for code review with a tailored self-review checklist.** References the `code-review`, `code-quality-foundations`, and `code-antipatterns` skills for checklist items.

**Arguments:** `$ARGUMENTS` (optional) - Git ref range (e.g., `HEAD~5..HEAD`). Defaults to uncommitted + last 3 commits.

---

## Process

### Step 1: Collect Changes

**If the user provided a ref range in `$ARGUMENTS`:** use it directly.

**Otherwise:**

```bash
git diff --name-only HEAD 2>/dev/null
git diff --name-only --cached 2>/dev/null
git diff --name-only HEAD~3..HEAD 2>/dev/null
```

Also capture: `git diff --stat`, `git log --oneline HEAD~3..HEAD`

If no changes found, inform the user to specify a ref range.

### Step 2: Read Changed Files

Read each changed file. For large files (>500 lines), focus on changed regions.

### Step 3: Classify Change Categories

| Category | Signals |
|----------|---------|
| **New code** | New files, new functions/classes |
| **Refactoring** | Renamed symbols, moved code, same behavior |
| **Bug fix** | Small targeted change, fixes incorrect behavior |
| **Feature enhancement** | Extends existing functionality |
| **Test changes** | Test files added/modified |
| **Configuration** | Config files, build scripts, CI/CD |

### Step 4: Build the Checklist

**Universal Items** — always included, from `code-quality-foundations` Code Quality Self-Review and `code-review` Reviewer Checklist.

**Category-Specific Items** — based on detected categories:
- **New code:** Naming, public API docs, edge cases, error paths, no premature abstraction, tests
- **Refactoring:** Behavior preserved, callers updated, dead code removed, tests pass
- **Bug fix:** Root cause identified, minimal fix, regression test, similar code checked
- **Feature enhancement:** Backwards compatible, sensible defaults, tests cover new + existing
- **Test changes:** Isolated, descriptive names, verify behavior not implementation, no flaky patterns
- **Configuration:** No secrets, environment-appropriate, backwards compatible

**Antipattern Scan** — from `code-antipatterns` Code Review Antipattern Scan checklist.

### Step 5: Present the Checklist

```
╔══════════════════════════════════════════════════════════════╗
║  REVIEW PREP CHECKLIST                                       ║
╚══════════════════════════════════════════════════════════════╝

CHANGE SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Files changed: <count>
  Categories: <list>

<Universal Items>
<Category-Specific Items — one per detected category>
<Antipattern Scan — if code changes present>

SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Total items: <count>
  Tip: Run /code:smell for automated antipattern detection.
```

---

## Example Usage

```
/code:review-prep
/code:review-prep HEAD~5..HEAD
/code:review-prep main..feature-branch
```
