# Multi-Course Meal Acceptance Report

**Feature:** Code smell detection command
**Bead ID:** cs-hdb.2
**Plated:** 2026-02-15
**Parent Menu:** cs-hdb - Phase 4: Interactive Commands & Agent

---

## Chef's Selection (User Story)

As a **developer**, I want **to run /code:smell on my recent changes** so that **I can detect implementation-level antipatterns before code review**.

---

## Tasting Notes (Acceptance Criteria)

Each course (task) in this feature has been verified against acceptance criteria:

### Course 1: /code:smell command scans recent changes (git diff) for code antipatterns

- **Status:** Served
- **Verification:** Smoke test validates git diff collection and file reading steps; command file defines 3-step input collection (staged, unstaged, recent commits)
- **Evidence:** `tests/smoke/smoke-smell-command.sh` — 2/2 input collection checks pass (git diff usage, file path argument support)

### Course 2: Detection references patterns from code-antipatterns skill

- **Status:** Served
- **Verification:** Smoke test validates code-antipatterns skill reference and all four antipattern categories present with 13+ individual patterns
- **Evidence:** `tests/smoke/smoke-smell-command.sh` — 5/5 antipattern checks pass (4 categories + 13 patterns cataloged); `commands/smell.md` Step 3 defines 20-pattern catalog across Surprise (5), Misuse (5), Complexity (5), and Premature (5) categories

### Course 3: Output categorizes findings by severity (critical, warning, note)

- **Status:** Served
- **Verification:** Smoke test validates all three severity levels present with clear criteria and verdict logic
- **Evidence:** `tests/smoke/smoke-smell-command.sh` — 7/7 severity and output checks pass (3 severity categories, report format, summary, verdict, verdict levels CLEAN/HAS_WARNINGS/HAS_CRITICAL)

### Course 4: Each finding includes the antipattern name, location, and suggested fix

- **Status:** Served
- **Verification:** Command defines structured finding format with pattern name, file:line reference, category, description, and suggested fix
- **Evidence:** `commands/smell.md` Step 5 output template includes `[Severity] <pattern-name>`, `File: <file:line>`, `Category: <type>`, `Description:`, and `Suggested fix:` fields

---

## Quality Checks (BDD Tests)

### Feature Test: `feature-4.2-smell-command.feature`

**Purpose:** Validate command structure, antipattern detection, severity categorization, output format, edge cases, and error handling

**Scenarios:**
| Scenario | Status | Description |
|----------|--------|-------------|
| Command scans recent changes | Passed | File exists, collects changes via git diff, reads changed files |
| Detection references antipattern catalog | Passed | References code-antipatterns skill, scans all 4 categories |
| Output categorized by severity | Passed | Findings categorized as Critical, Warning, or Note |
| Findings include name, location, category, and fix | Passed | Each finding has antipattern name, file:line, category, description, fix |
| Command supports explicit file path arguments | Passed | Accepts file paths and glob patterns as arguments |
| Clean scan produces CLEAN verdict | Passed | No-findings output with CLEAN verdict |
| Verdict reflects severity of findings | Passed | CLEAN/HAS_WARNINGS/HAS_CRITICAL logic verified |
| No recent changes detected should inform the user | Passed | Error path: informs user and suggests file arguments |
| Command without YAML frontmatter should fail validation | Passed | Error path: missing frontmatter detected |

**Results:** All 9 scenarios passing

### Smoke Tests

End-to-end validation from user perspective:

| Test | Status | Notes |
|------|--------|-------|
| File structure (1 check) | Passed | commands/smell.md exists |
| YAML frontmatter (5 checks) | Passed | Frontmatter present, description, allowed-tools, Read, Grep |
| Antipattern categories (4 checks) | Passed | Surprise, Misuse, Complexity, Premature |
| Antipattern patterns (1 check) | Passed | 13 patterns found (threshold: 10+) |
| Severity categories (3 checks) | Passed | Critical, Warning, Note |
| Input collection (2 checks) | Passed | git diff usage, file path arguments |
| Output format (4 checks) | Passed | Report header, summary, verdict, verdict levels |
| Skill references (1 check) | Passed | code-antipatterns referenced |

**Results:** All 21 smoke test checks passing

---

## Kitchen Staff Sign-Off

Quality assurance by Line Cook agents:

| Agent | Role | Status |
|-------|------|--------|
| **Sous-Chef** | Code review (cs-hdb.2.1) | Approved (3 minor, 3 nits — 1 auto-fixed by polisher) |
| **Polisher** | Code polish (cs-hdb.2.1) | 1 fix applied (minor alignment) |
| **Maitre** | BDD test quality (1st pass) | Returned for changes (missing error scenarios, edge cases) |
| **Maitre** | BDD test quality (2nd pass) | Approved (all issues resolved) |

---

## Guest Experience

How users can verify this feature works:

```bash
# 1. Run smoke test
bash tests/smoke/smoke-smell-command.sh

# 2. Verify command structure
head -4 commands/smell.md

# 3. Manual: Invoke the smell command
# /code:smell                              # Scan recent git changes
# /code:smell src/auth.ts src/db.ts        # Scan specific files
# /code:smell "src/**/*.py"                # Scan with glob pattern
```

**Expected Outcome:** The /code:smell command scans target files for 20 antipatterns across 4 categories (Surprise, Misuse, Complexity, Premature), classifies findings by severity (Critical/Warning/Note), and produces a structured report with pattern name, file location, description, and suggested fix for each finding.

---

## Kitchen Notes

### Known Limitations

- The code-antipatterns skill is referenced but not yet a separate skill file; antipattern patterns are embedded inline in the command
- Detection quality depends on Claude's ability to recognize antipatterns in the scanned code
- Command is a prompt-based tool — it guides Claude's analysis rather than running static analysis

### Future Enhancements

- Create standalone code-antipatterns skill for reuse across commands
- Add language-specific antipattern patterns (e.g., Python-specific, Rust-specific)
- Add auto-fix suggestions that can be applied directly
- Integration with /code:tradeoff for antipatterns that involve design tradeoffs

### Deployment Notes

- Command is a markdown file, no build or compilation needed
- Requires Claude Code plugin system with command support
- Works with any language — antipattern detection is language-agnostic

---

## Related Orders

### Tasks Completed

| Bead | Title | Status |
|------|-------|--------|
| cs-hdb.2.1 | Create /code:smell command | Closed |

### Related Features

| Bead | Title | Relationship |
|------|-------|--------------|
| cs-hdb.1 | Feature 4.1: Tradeoff analysis command | Dependency (prerequisite) |
| cs-hdb.3 | Feature 4.3: Review preparation command and quality critic agent | Blocked by this feature |
| cs-n4l.2 | Feature 3.2: Code review and testing guidance | Dependency (prerequisite) |

---

**Status:** Feature Complete and Validated
