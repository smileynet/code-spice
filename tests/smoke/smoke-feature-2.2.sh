#!/usr/bin/env bash
# Smoke test for Feature 2.2: Implementation guidance activates during cook
# Validates refactoring-patterns and error-handling-patterns skills
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
PASS=0
FAIL=0
WARN=0

pass() { echo "  [PASS] $1"; PASS=$((PASS + 1)); }
fail() { echo "  [FAIL] $1"; FAIL=$((FAIL + 1)); }
warn() { echo "  [WARN] $1"; WARN=$((WARN + 1)); }

echo "Feature 2.2 Smoke Test"
echo "━━━━━━━━━━━━━━━━━━━━━━"

# --- Refactoring Patterns Skill ---
echo ""
echo "Refactoring Patterns Skill:"

REFACTOR="$REPO_ROOT/skills/refactoring-patterns/SKILL.md"

if [ -f "$REFACTOR" ]; then
  pass "SKILL.md exists"
else
  fail "SKILL.md missing"
fi

# YAML frontmatter
if head -1 "$REFACTOR" | grep -q "^---"; then
  pass "YAML frontmatter present"
else
  fail "YAML frontmatter missing"
fi

FM_NAME=$(sed -n '/^---$/,/^---$/p' "$REFACTOR" | grep "^name:" | sed 's/name: *//')
if [ "$FM_NAME" = "refactoring-patterns" ]; then
  pass "frontmatter name matches directory"
else
  fail "frontmatter name is '$FM_NAME' (expected 'refactoring-patterns')"
fi

# Activation keywords in description
FM_DESC=$(sed -n '/^---$/,/^---$/p' "$REFACTOR" | grep "^description:" | head -1)
for kw in "refactoring" "code structure" "code smells" "complexity"; do
  if echo "$FM_DESC" | grep -qi "$kw"; then
    pass "activation keyword '$kw' in description"
  else
    fail "activation keyword '$kw' missing from description"
  fi
done

# Pattern catalog
CATALOG_PATTERNS=$(sed -n '/The Refactoring Pattern Catalog/,/### When to Refactor/p' "$REFACTOR" | grep -c "^\| \*\*" || true)
if [ "$CATALOG_PATTERNS" -ge 10 ]; then
  pass "pattern catalog has $CATALOG_PATTERNS entries (>= 10)"
else
  fail "pattern catalog has only $CATALOG_PATTERNS entries (need >= 10)"
fi

# Code smell triggers
if grep -q "## Code Smell Triggers" "$REFACTOR"; then
  pass "Code Smell Triggers section present"
else
  fail "Code Smell Triggers section missing"
fi

if grep -q "5-7 lines" "$REFACTOR"; then
  pass "five-line rule present"
else
  fail "five-line rule missing"
fi

if grep -q "type code" "$REFACTOR" || grep -q "Type Code" "$REFACTOR"; then
  pass "type code smell detection present"
else
  fail "type code smell detection missing"
fi

# Required sections
for section in "Quick Reference" "Pattern Details" "Decision Tables" "Refactoring Philosophy"; do
  if grep -q "## $section" "$REFACTOR"; then
    pass "section '$section' present"
  else
    fail "section '$section' missing"
  fi
done

# Cross-references
if grep -q "## See Also" "$REFACTOR"; then
  pass "See Also cross-references present"
else
  fail "See Also cross-references missing"
fi

# Line count
LINES=$(wc -l < "$REFACTOR")
if [ "$LINES" -ge 200 ] && [ "$LINES" -le 500 ]; then
  pass "line count $LINES within target range (200-500)"
else
  fail "line count $LINES outside target range (200-500)"
fi

# --- Error Handling Patterns Skill ---
echo ""
echo "Error Handling Patterns Skill:"

ERRHAND="$REPO_ROOT/skills/error-handling-patterns/SKILL.md"

if [ -f "$ERRHAND" ]; then
  pass "SKILL.md exists"
else
  fail "SKILL.md missing"
fi

# YAML frontmatter
if head -1 "$ERRHAND" | grep -q "^---"; then
  pass "YAML frontmatter present"
else
  fail "YAML frontmatter missing"
fi

FM_NAME=$(sed -n '/^---$/,/^---$/p' "$ERRHAND" | grep "^name:" | sed 's/name: *//')
if [ "$FM_NAME" = "error-handling-patterns" ]; then
  pass "frontmatter name matches directory"
else
  fail "frontmatter name is '$FM_NAME' (expected 'error-handling-patterns')"
fi

# Activation keywords in description
FM_DESC=$(sed -n '/^---$/,/^---$/p' "$ERRHAND" | grep "^description:" | head -1)
for kw in "error handling" "exceptions" "result types" "error codes"; do
  if echo "$FM_DESC" | grep -qi "$kw"; then
    pass "activation keyword '$kw' in description"
  else
    fail "activation keyword '$kw' missing from description"
  fi
done

# Error strategy decision table
if grep -q "Error Strategy Decision Table" "$ERRHAND"; then
  pass "error strategy decision table present"
else
  fail "error strategy decision table missing"
fi

# Recoverability framework
if grep -q "Recoverability" "$ERRHAND"; then
  pass "recoverability framework present"
else
  fail "recoverability framework missing"
fi

# Multiple strategies covered
STRATEGIES=0
grep -qi "Checked Exception" "$ERRHAND" && STRATEGIES=$((STRATEGIES+1))
grep -qi "Unchecked Exception" "$ERRHAND" && STRATEGIES=$((STRATEGIES+1))
grep -qi "Result.*type\|Result / Either" "$ERRHAND" && STRATEGIES=$((STRATEGIES+1))
grep -qi "Error Codes\|Magic Values" "$ERRHAND" && STRATEGIES=$((STRATEGIES+1))
grep -qi "Nullable.*Optional\|Optional.*Return" "$ERRHAND" && STRATEGIES=$((STRATEGIES+1))
if [ "$STRATEGIES" -ge 4 ]; then
  pass "covers $STRATEGIES error handling strategies (>= 4)"
else
  fail "only $STRATEGIES strategies covered (need >= 4)"
fi

# Fail-fast vs robustness
if grep -q "Fail Fast" "$ERRHAND" && grep -q "Fail Loudly" "$ERRHAND"; then
  pass "fail-fast and fail-loudly principles present"
else
  fail "fail-fast/fail-loudly principles missing"
fi

# Required sections
for section in "Quick Reference" "Signaling Techniques" "Decision Tables" "Core Principles"; do
  if grep -q "## $section" "$ERRHAND"; then
    pass "section '$section' present"
  else
    fail "section '$section' missing"
  fi
done

# Modern language patterns
if grep -q "Go: Errors as Values\|TypeScript: Discriminated" "$ERRHAND"; then
  pass "modern language-specific patterns present"
else
  fail "modern language-specific patterns missing"
fi

# Cross-references
if grep -q "## See Also" "$ERRHAND"; then
  pass "See Also cross-references present"
else
  fail "See Also cross-references missing"
fi

# Line count
LINES=$(wc -l < "$ERRHAND")
if [ "$LINES" -ge 200 ] && [ "$LINES" -le 500 ]; then
  pass "line count $LINES within target range (200-500)"
else
  fail "line count $LINES outside target range (200-500)"
fi

# --- Summary ---
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━"
echo "Results: $PASS passed, $FAIL failed, $WARN warnings"

if [ "$FAIL" -gt 0 ]; then
  echo "STATUS: FAILED"
  exit 1
else
  echo "STATUS: PASSED"
  exit 0
fi
