---
description: Structured code smell detection on recent changes
allowed-tools: Read, Glob, Grep, Bash
---

## Summary

**Scan code for antipatterns and code smells.** Applies pattern knowledge from the code-antipatterns skill to detect Surprise, Misuse, Complexity, and Premature antipatterns in real code.

**Arguments:** `$ARGUMENTS` (optional) - File paths or glob patterns to scan. Defaults to recent git changes.

---

## Process

### Step 1: Collect Target Code

**If the user provided file paths in `$ARGUMENTS`:**
- Use those paths directly
- Expand glob patterns via Glob tool

**Otherwise**, collect recent changes:

```bash
# Get changed files (staged + unstaged + untracked)
git diff --name-only HEAD 2>/dev/null
git diff --name-only --cached 2>/dev/null
git diff --name-only HEAD~3..HEAD 2>/dev/null
```

Merge and deduplicate the file lists. Filter to source code files only (skip binaries, lock files, generated files, `.md` documentation).

If no changes are found, inform the user:
```
No recent changes detected. Specify files to scan:
  /code:smell src/auth.ts src/db.ts
  /code:smell "src/**/*.py"
```

### Step 2: Read Target Files

Read each target file using the Read tool. For large files (>500 lines), focus on the changed regions using git diff line numbers.

Note the file path, language, and line count for each file.

### Step 3: Scan for Antipatterns

Apply the four antipattern categories from the **code-antipatterns** skill to each file. For each category, check the patterns below.

#### Surprise Antipatterns (POLA violations)

| Pattern | What to Look For |
|---------|-----------------|
| **Magic return values** | Returning `-1`, `null`, `""` to signal errors instead of exceptions/Result types |
| **Hidden side effects** | Functions that modify global state, write files, or make network calls unexpectedly |
| **Silent failures** | Catching exceptions and doing nothing, ignoring error returns |
| **Misleading names** | Function behavior doesn't match its name (e.g., `getUser` that also updates last-login) |
| **Implicit ordering** | Code that only works if called in a specific undocumented sequence |

#### Misuse Antipatterns (easy to use incorrectly)

| Pattern | What to Look For |
|---------|-----------------|
| **Primitive obsession** | Using `string` for emails, URLs, IDs; `int` for timestamps, currencies |
| **Mutable shared state** | Public mutable fields, shared collections without synchronization |
| **Boolean blindness** | Functions taking multiple boolean parameters (`process(true, false, true)`) |
| **Stringly-typed code** | Using strings where enums, constants, or types would prevent errors |
| **Unvalidated construction** | Objects that can exist in invalid states after construction |

#### Complexity Antipatterns (unnecessarily complex)

| Pattern | What to Look For |
|---------|-----------------|
| **Deep nesting** | 4+ levels of indentation from nested conditionals/loops |
| **God class/function** | Single unit handling multiple unrelated concerns |
| **Shotgun surgery** | One change requiring edits across many unrelated files |
| **Feature envy** | Method that uses more data from another class than its own |
| **Long parameter list** | Functions taking 5+ parameters |

#### Premature Antipatterns (optimizing/abstracting too early)

| Pattern | What to Look For |
|---------|-----------------|
| **Premature abstraction** | Interfaces/generics with only one implementation and no planned variation |
| **Speculative generality** | Config flags, extension points, or parameters "just in case" |
| **Premature optimization** | Complex caching, bit manipulation, or inlining without profiling evidence |
| **Over-engineering** | Factory-of-factory, strategy-of-strategy patterns for simple operations |
| **Dead flexibility** | Abstract base classes or plugin systems never extended |

### Step 4: Categorize Findings

Classify each finding by severity:

| Severity | Criteria | Action |
|----------|----------|--------|
| **Critical** | Likely to cause bugs, data loss, or security issues | Fix before merging |
| **Warning** | Makes code harder to maintain or extend | Fix if touching this code |
| **Note** | Style issue or minor improvement opportunity | Consider when convenient |

**Severity assignment guidance:**
- Magic return values masking errors → Critical
- Hidden side effects in public APIs → Critical
- Primitive obsession for security-sensitive data (passwords, tokens) → Critical
- Deep nesting reducing readability → Warning
- Boolean blindness in internal code → Warning
- Premature abstraction with single implementation → Note
- Long parameter lists in internal helpers → Note

### Step 5: Present Findings

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

[Warning] <pattern-name>
  File: <file:line>
  Category: <Surprise|Misuse|Complexity|Premature>
  Description: <what the problem is>
  Suggested fix: <how to address it>

[Note] <pattern-name>
  File: <file:line>
  Category: <Surprise|Misuse|Complexity|Premature>
  Description: <what the problem is>
  Suggested fix: <how to address it>

SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

| Category   | Critical | Warning | Note   |
|------------|----------|---------|--------|
| Surprise   |    <n>   |   <n>   |  <n>   |
| Misuse     |    <n>   |   <n>   |  <n>   |
| Complexity |    <n>   |   <n>   |  <n>   |
| Premature  |    <n>   |   <n>   |  <n>   |
| **Total**  |  **<n>** | **<n>** |**<n>** |

Verdict: <CLEAN | HAS_WARNINGS | HAS_CRITICAL>
```

**Verdict logic:**
- `CLEAN` — No findings, or only Notes
- `HAS_WARNINGS` — Warnings but no Critical findings
- `HAS_CRITICAL` — One or more Critical findings that should be addressed

If no findings are detected:
```
╔══════════════════════════════════════════════════════════════╗
║  CODE SMELL REPORT                                          ║
╚══════════════════════════════════════════════════════════════╝

  Files scanned: <count>
  Findings: None detected

  Verdict: CLEAN
```

---

## Example Usage

```
/code:smell
/code:smell src/auth/login.ts src/auth/session.ts
/code:smell "src/**/*.py"
```
