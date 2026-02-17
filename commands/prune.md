---
name: prune
description: Interactive codebase pruning analysis — dead code, unused dependencies, speculative abstractions, scope boundaries, and prioritized removal plan
allowed-tools: Read, Glob, Grep, Bash, AskUserQuestion
---

## Summary

**Analyze a codebase for pruning opportunities.** Walks through dead code detection, unused dependencies, speculative abstractions, scope boundary issues, and commented-out code — then produces a prioritized removal plan.

**Arguments:** `$ARGUMENTS` (optional) - Path to analyze. Defaults to current working directory.

---

## Process

### Step 1: Gather Codebase Context

Use **AskUserQuestion** to collect essential context before scanning:

**Question 1:** "What languages and frameworks does this project use?"
**Options:**
- "JavaScript/TypeScript (Node, React, etc.)"
- "Python (Django, Flask, FastAPI, etc.)"
- "Go"
- "Java/Kotlin (Spring, etc.)"

Allow multiple selection.

**Question 2:** "What best describes this project's situation?"
**Options:**
- "Active development — features shipping regularly"
- "Mature/stable — mostly maintenance and bug fixes"
- "Legacy — inherited or long-running with unclear ownership"
- "Post-migration — recently moved platforms or frameworks"

**Question 3:** "What's your biggest concern?"
**Options:**
- "Build/test times are growing" — Focus on dependency and dead code weight
- "Hard to understand what code is still used" — Focus on dead code and lava flow
- "Project scope feels too broad" — Focus on scope boundaries and feature belonging
- "General health check" — Run all categories equally

Note the answers for use throughout the analysis.

### Step 2: Dead Code Scan

Scan for unreachable and unused code using static analysis techniques.

`(see code-pruning -> Dead Code Detection)`

#### 2a: Unused Files

```bash
# Find files not imported/required by anything else
# Adapt pattern to detected language(s)
git ls-files --cached | head -200
```

Use Grep to search for import/require references to each source file. Files with zero inbound references are candidates.

**For JS/TS projects:**
```bash
# Check for unused exports — recommend Knip for thorough analysis
npx knip --no-exit-code 2>/dev/null || echo "Knip not installed — recommend: npx knip for comprehensive unused export detection"
```

**For Python projects:**
```bash
# Check for unused code — recommend Vulture
python3 -m vulture . --min-confidence 80 2>/dev/null || echo "Vulture not installed — recommend: pip install vulture"
```

**For Go projects:**
```bash
# Official Go dead code tool
go run golang.org/x/tools/cmd/deadcode ./... 2>/dev/null || echo "Try: go install golang.org/x/tools/cmd/deadcode@latest"
```

If tools aren't installed, fall back to manual heuristics:
- Use Grep to find functions/classes defined but never referenced elsewhere
- Check for files not imported by any other file

#### 2b: Unreachable Code

Use Grep to scan for common unreachable patterns (heuristic — verify each match manually):

Disabled conditionals:
```
Grep(pattern="if\s+(false|False|0)\s*[:{]")
Grep(pattern="if\s+\(false\)")
```

#### 2c: Record Findings

For each candidate, note:
- **File and location**
- **Confidence**: High (zero references), Medium (possible dynamic use), Low (needs verification)
- **Type**: Unused function, unreachable code, dead file, orphaned export

### Step 3: Unused Dependency Check

Analyze dependency manifests against actual usage.

`(see code-pruning -> Dependency Pruning)`

#### 3a: Identify Manifests

```
Glob(pattern="**/package.json")
Glob(pattern="**/requirements*.txt")
Glob(pattern="**/pyproject.toml")
Glob(pattern="**/go.mod")
Glob(pattern="**/pom.xml")
Glob(pattern="**/build.gradle*")
```

Read the primary manifest file(s).

#### 3b: Cross-Reference Imports

For each declared dependency, search the source code for actual usage:

```
# For each dependency in the manifest
Grep(pattern="<dependency-name>", glob="*.{ts,tsx,js,jsx,py,go,java}")
```

A dependency with zero source-code matches is a removal candidate — but check for false positives first:

| False Positive | How to Verify |
|----------------|---------------|
| Peer dependency | Check if required by another installed package |
| CLI tool | Check npm scripts, Makefile, CI config |
| Plugin/loader | Check config files (webpack, babel, pytest, etc.) |
| Type-only import | Check `.d.ts` files and type annotations |

#### 3c: Record Findings

For each unused dependency:
- **Name and version**
- **Confidence**: High (zero references anywhere), Medium (only in config/scripts)
- **Risk**: Low (dev dependency), Medium (runtime dependency), High (transitive consumers)

### Step 4: Speculative Abstraction Detection

Search for code built for futures that never arrived.

`(see code-yagni -> Speculative Generality Detection)`

#### 4a: Single-Implementation Interfaces

Adapt to detected language:

**JS/TS:**
```
Grep(pattern="^(export\s+)?(interface|abstract class)\s+", glob="*.{ts,tsx}")
```
For each interface/abstract class found, search for implementations:
```
Grep(pattern="implements <InterfaceName>|extends <AbstractName>")
```
Flag any with exactly one implementation.

**Python:**
```
Grep(pattern="class\s+\w+\(ABC\)|@abstractmethod", glob="*.py")
```

**Go:**
```
Grep(pattern="type\s+\w+\s+interface\s*\\{", glob="*.go")
```

**Java:**
```
Grep(pattern="^public\s+(abstract\s+)?interface\s+", glob="*.java")
```

#### 4b: Unused Extension Points

Search for patterns suggesting unused flexibility:

```
# Plugin/hook registries
Grep(pattern="register(Plugin|Hook|Handler|Listener|Callback)", glob="*.{ts,js,py,go,java}")

# Event emitters with no listeners (or vice versa)
Grep(pattern="\.on\(|\.emit\(|addEventListener", glob="*.{ts,js}")

# Factory methods
Grep(pattern="create\w+Factory|Factory\.create|factory_method", glob="*.{ts,js,py}")
```

Cross-reference: if a registration mechanism exists but has only one registration, it's a speculative generality signal.

#### 4c: Future-Oriented Naming

```
Grep(pattern="Manager|Handler|Processor|Strategy|Factory|Provider|Registry", glob="*.{ts,js,py,go,java}")
```

For each match, check: does the name promise generality the code doesn't deliver? A `UserManager` with no management beyond CRUD is a naming smell, not an architecture.

#### 4d: Record Findings

For each speculative abstraction:
- **File, name, and type** (single-impl interface, unused extension, future-naming)
- **Recommendation**: Collapse Hierarchy, Inline Method, Inline Class, or Rename

### Step 5: Scope Boundary Analysis

Evaluate whether modules or the project itself has outgrown its boundaries.

`(see code-scope-boundaries -> The Cohesion Test)`

#### 5a: Utils/Helpers Ratio

```bash
# Count lines in utils/helpers/common vs domain folders
find . -path '*/utils/*' -o -path '*/helpers/*' -o -path '*/common/*' -o -path '*/shared/*' | head -100
```

```
Glob(pattern="**/utils/**/*.{ts,js,py,go,java}")
Glob(pattern="**/helpers/**/*.{ts,js,py,go,java}")
Glob(pattern="**/common/**/*.{ts,js,py,go,java}")
Glob(pattern="**/shared/**/*.{ts,js,py,go,java}")
```

Compare to total source file count. A ratio above 25% signals unclear domain boundaries.

| Ratio | Assessment |
|-------|-----------|
| <10% | Healthy — utils are incidental |
| 10-25% | Warning — growing catch-all |
| >25% | Critical — domain boundaries unclear |

#### 5b: Feature Cohesion Check

Apply the one-sentence test: can the project's purpose be described in one sentence without "and" connecting unrelated capabilities?

Examine the top-level directory structure and identify distinct feature areas. For each area, ask:
- Does it serve the same user group?
- Does it change at the same cadence?
- Could it deploy independently?

#### 5c: Cross-Feature Dependencies

```
Grep(pattern="from\s+\.\./|require\(\s*['\"]\.\.\/", glob="*.{ts,js,py}")
```

High ratios of upward/cross-module imports suggest coupled features that should be either merged or given a clean interface.

#### 5d: Record Findings

Note any scope concerns:
- Utils ratio and assessment
- Features that may not belong
- Cross-module coupling hotspots

### Step 6: Commented-Out Code Review

Search for code that's been disabled but not deleted.

`(see code-pruning -> Commented-Out Code)`

#### 6a: Scan for Commented Code Blocks

```
# Multi-line comment blocks that look like code (language-adaptive)
Grep(pattern="^(\s*)//\s*(function|const|let|var|class|import|export|return|if|for|while)\b", glob="*.{ts,js,tsx,jsx}")
Grep(pattern="^(\s*)#\s*(def |class |import |from |return |if |for |while )", glob="*.py")
Grep(pattern="^(\s*)//\s*(func |type |var |const |return |if |for |range )", glob="*.go")
```

#### 6b: Check Age via Git Blame

For each commented block found:

```bash
# How old is this commented code?
git blame -L <start>,<end> --date=relative <file>
```

Older commented code (>3 months) is almost certainly dead. Recent comments (<1 week) might be active debugging.

| Age | Recommendation |
|-----|---------------|
| >6 months | Delete — if it was needed, it would have been uncommented by now |
| 1-6 months | Likely dead — verify with the team, then delete |
| <1 month | May be active work — check if there's a related branch or issue |

#### 6c: Record Findings

For each commented block:
- **File and line range**
- **Age** (from git blame)
- **Recommendation**: Delete (with git recovery command if needed)

### Step 7: Produce Prioritized Removal Plan

Combine all findings into a prioritized action plan using a safety x effort matrix.

#### 7a: Classify Each Finding

| Safety | Criteria |
|--------|----------|
| **Safe** | High confidence dead, no dynamic dispatch, good test coverage |
| **Moderate** | Medium confidence, some dynamic patterns, partial test coverage |
| **Risky** | Low confidence, reflection/eval involved, no tests |

| Effort | Criteria |
|--------|----------|
| **Quick** | Delete a file or function, remove a dependency — minutes |
| **Medium** | Refactor callers, update tests, verify integrations — hours |
| **Major** | Architectural change, data migration, API deprecation — days+ |

#### 7b: Build the Matrix

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
| Dead code                |  <n>  |    <n>    |     <n>     |
| Unused dependencies      |  <n>  |    <n>    |     <n>     |
| Speculative abstractions |  <n>  |    <n>    |     <n>     |
| Scope boundary issues    |  <n>  |    <n>    |     <n>     |
| Commented-out code       |  <n>  |    <n>    |     <n>     |

PRIORITIZED REMOVAL PLAN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Start here (Safe + Quick):
  1. <finding> — <file:line> — <action>
  2. <finding> — <file:line> — <action>
  3. <finding> — <file:line> — <action>

Then (Safe + Medium effort):
  4. <finding> — <file:line> — <action>
  5. <finding> — <file:line> — <action>

Investigate further (Moderate safety):
  6. <finding> — <file:line> — <action>
  7. <finding> — <file:line> — <action>

Defer or instrument (Risky or Major effort):
  8. <finding> — <description> — <recommended verification>

SCOPE HEALTH
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Utils ratio: <n>% (<assessment>)
  Cohesion: <pass/warning/fail>
  Cross-module coupling: <low/medium/high>

RECOMMENDED TOOLS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  <language-specific tool recommendations from code-pruning skill>

RECOVERY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  All removals are recoverable via git:
    git log -G "function_name" --all
    git show <commit>~1:path/to/file

  Tip: Delete atomically — one concern per commit.
```

#### 7c: Ordering Logic

Present findings in this order:
1. **Safe + Quick** — Commented-out code, clearly unused private functions, unused dev dependencies
2. **Safe + Medium** — Unused files, unused runtime dependencies with no dynamic patterns
3. **Moderate + Quick** — Single-implementation interfaces, future-oriented naming
4. **Moderate + Medium** — Speculative abstractions requiring caller updates
5. **Risky or Major** — Anything involving reflection, dynamic dispatch, or architectural changes

This ordering maximizes early wins and builds confidence before tackling harder removals.

---

## Example Usage

```
/code:prune
/code:prune src/
/code:prune packages/legacy-module
```
