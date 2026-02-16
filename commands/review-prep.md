---
description: Generate a context-aware self-review checklist before code review
allowed-tools: Read, Glob, Grep, Bash
---

## Summary

**Prepare for code review with a tailored self-review checklist.** Analyzes recent changes, classifies the type of work, and generates a checklist drawing from the code-review and code-antipatterns skills.

**Arguments:** `$ARGUMENTS` (optional) - Git ref range (e.g., `HEAD~5..HEAD`). Defaults to uncommitted + last 3 commits.

---

## Process

### Step 1: Collect Changes

**If the user provided a ref range in `$ARGUMENTS`:**
- Use that range directly with `git diff`

**Otherwise**, collect recent changes:

```bash
# Uncommitted changes (staged + unstaged)
git diff --name-only HEAD 2>/dev/null
git diff --name-only --cached 2>/dev/null

# Recent commits
git diff --name-only HEAD~3..HEAD 2>/dev/null
```

Merge and deduplicate the file lists. Filter to source code files only (skip binaries, lock files, generated files).

Also capture the diff content for classification:

```bash
# Summary of changes for classification
git diff --stat HEAD 2>/dev/null
git diff --stat --cached 2>/dev/null
git log --oneline HEAD~3..HEAD 2>/dev/null
```

If no changes are found, inform the user:
```
No recent changes detected. Specify a ref range:
  /code:review-prep HEAD~5..HEAD
  /code:review-prep main..feature-branch
```

### Step 2: Read Changed Files

Read each changed file using the Read tool. For large files (>500 lines), focus on the changed regions using git diff line numbers.

Note the file path, language, and approximate scope of changes (additions, modifications, deletions).

### Step 3: Classify Change Categories

Examine the changes and classify into one or more categories:

| Category | Signals | Example |
|----------|---------|---------|
| **New code** | New files, new functions/classes, no prior version | Adding a new API endpoint |
| **Refactoring** | Renamed symbols, moved code, same behavior | Extracting a helper function |
| **Bug fix** | Small targeted change, fixes incorrect behavior | Null check, off-by-one fix |
| **Feature enhancement** | Extends existing functionality, new parameters/options | Adding filter to existing search |
| **Test changes** | Test files added/modified | New test cases, test refactoring |
| **Configuration** | Config files, build scripts, CI/CD | Updating dependencies, build flags |

A change set can have multiple categories (e.g., "Feature enhancement" + "Test changes").

### Step 4: Build the Checklist

Generate a checklist with three sections: **Universal items** (always included), **Category-specific items** (based on Step 3), and **Antipattern scan items** (from skills).

#### Universal Items (always included)

From the **code-review** skill and **code-quality-foundations** skill — Code Quality Self-Review checklist `(see code-review -> Review Checklist)` `(see code-quality-foundations -> Code Quality Self-Review)`:

```
UNIVERSAL CHECKS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [ ] Functions translate to single sentences
  [ ] No surprises: behavior matches names and types
  [ ] Hard to misuse: invalid states are unrepresentable where possible
  [ ] Modular: changes are localized, not scattered
  [ ] Testable: can be unit tested without complex setup
  [ ] Clean abstractions: API doesn't leak implementation details
```

#### Category-Specific Items

**If "New code":**
```
NEW CODE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [ ] Naming is clear and consistent with surrounding code
  [ ] Public API is documented (parameters, return types, errors)
  [ ] Edge cases handled (empty inputs, nulls, boundaries)
  [ ] Error paths are explicit, not silent
  [ ] No premature abstraction (single implementation doesn't need an interface)
  [ ] Tests cover the happy path and at least one error path
```

**If "Refactoring":**
```
REFACTORING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [ ] Behavior is preserved (no unintended changes)
  [ ] Callers updated consistently (no stale references)
  [ ] Dead code removed (no orphaned functions/imports)
  [ ] Tests still pass without modification (or updated intentionally)
  [ ] Commit is separable from feature work
```

**If "Bug fix":**
```
BUG FIX
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [ ] Root cause identified (not just symptom patched)
  [ ] Fix is minimal and targeted
  [ ] Regression test added for the specific bug
  [ ] Similar code checked for the same pattern
  [ ] No new edge cases introduced by the fix
```

**If "Feature enhancement":**
```
FEATURE ENHANCEMENT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [ ] Backwards compatible (existing callers unaffected)
  [ ] New parameters have sensible defaults
  [ ] Feature discoverable (documented, good naming)
  [ ] Tests cover new behavior and interaction with existing behavior
  [ ] No feature creep beyond the stated requirement
```

**If "Test changes":**
```
TEST CHANGES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [ ] Tests are isolated (no shared mutable state between tests)
  [ ] Test names describe the scenario and expected outcome
  [ ] Tests verify behavior, not implementation details
  [ ] No flaky patterns (timing, ordering, external dependencies)
  [ ] Assertions have clear failure messages
```

**If "Configuration":**
```
CONFIGURATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [ ] No secrets or credentials committed
  [ ] Changes are environment-appropriate (dev/staging/prod)
  [ ] Backwards compatible with existing deployments
  [ ] Documented if non-obvious
```

#### Antipattern Scan Items

From the **code-antipatterns** skill `(see code-antipatterns -> Pattern Recognition)`, check for the most common patterns relevant to the change categories:

**For any code changes (New code, Bug fix, Feature enhancement):**
```
ANTIPATTERN SCAN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [ ] No magic return values masking errors (Surprise)
  [ ] No hidden side effects in public functions (Surprise)
  [ ] No silent exception swallowing (Surprise)
  [ ] No primitive obsession for domain concepts (Misuse)
  [ ] No boolean blindness in function signatures (Misuse)
  [ ] No deep nesting (4+ levels) (Complexity)
  [ ] No god functions handling multiple concerns (Complexity)
  [ ] No premature abstractions with single implementations (Premature)
```

### Step 5: Present the Checklist

```
╔══════════════════════════════════════════════════════════════╗
║  REVIEW PREP CHECKLIST                                       ║
╚══════════════════════════════════════════════════════════════╝

CHANGE SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Files changed: <count>
  Source: <ref range or "uncommitted + recent commits">
  Categories: <New code, Refactoring, Bug fix, etc.>

  Changed files:
    M <file1>
    A <file2>
    D <file3>

<Universal Items section>

<Category-Specific Items sections — one per detected category>

<Antipattern Scan Items section — if code changes present>

SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Total items: <count>
  Categories: <list>

  Tip: Run /code:smell for automated antipattern detection.
```

If no changes are found:
```
╔══════════════════════════════════════════════════════════════╗
║  REVIEW PREP CHECKLIST                                       ║
╚══════════════════════════════════════════════════════════════╝

  No changes detected. Nothing to review.

  Specify a ref range:
    /code:review-prep HEAD~5..HEAD
    /code:review-prep main..feature-branch
```

---

## Example Usage

```
/code:review-prep
/code:review-prep HEAD~5..HEAD
/code:review-prep main..feature-branch
```
