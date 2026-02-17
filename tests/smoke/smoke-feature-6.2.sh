#!/usr/bin/env bash
# Smoke test for Feature 6.2: Dead code pruning guidance during maintenance
# Validates code-pruning skill content
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
PASS=0
FAIL=0
WARN=0

pass() { echo "  [PASS] $1"; PASS=$((PASS + 1)); }
fail() { echo "  [FAIL] $1"; FAIL=$((FAIL + 1)); }
warn() { echo "  [WARN] $1"; WARN=$((WARN + 1)); }

echo "Feature 6.2 Smoke Test"
echo "━━━━━━━━━━━━━━━━━━━━━━"

SKILL="$REPO_ROOT/skills/code-pruning/SKILL.md"

# --- File exists ---
if [ -f "$SKILL" ]; then
  pass "SKILL.md exists"
else
  fail "SKILL.md missing"
fi

# --- YAML frontmatter ---
if head -1 "$SKILL" | grep -q "^---"; then
  pass "YAML frontmatter present"
else
  fail "YAML frontmatter missing"
fi

FM_NAME=$(sed -n '/^---$/,/^---$/p' "$SKILL" | grep "^name:" | sed 's/name: *//')
if [ "$FM_NAME" = "code-pruning" ]; then
  pass "frontmatter name matches directory"
else
  fail "frontmatter name is '$FM_NAME' (expected 'code-pruning')"
fi

# --- Activation keywords ---
FM_DESC=$(sed -n '/^---$/,/^---$/p' "$SKILL" | grep "^description:" | head -1)
for kw in "architecture-audit" "cook" "dead code" "pruning" "removal"; do
  if echo "$FM_DESC" | grep -qi "$kw"; then
    pass "frontmatter description contains '$kw'"
  else
    fail "frontmatter description missing '$kw'"
  fi
done

# --- Line count (200-400) ---
LINES=$(wc -l < "$SKILL")
if [ "$LINES" -ge 200 ] && [ "$LINES" -le 400 ]; then
  pass "line count $LINES (within 200-400)"
else
  fail "line count $LINES (expected 200-400)"
fi

# --- Progressive disclosure ---
DETAILS_COUNT=$(grep -c "<details>" "$SKILL" || echo "0")
if [ "$DETAILS_COUNT" -ge 1 ]; then
  pass "progressive disclosure present ($DETAILS_COUNT <details> tags)"
else
  fail "no <details> tags for progressive disclosure"
fi

# --- Tool recommendation table with date stamps ---
if grep -q "February 2026\|2026-02" "$SKILL"; then
  pass "tool recommendations include date stamps"
else
  fail "tool recommendations missing date stamps"
fi

TOOL_TABLE_ROWS=$(grep -c "^\| \*\*" "$SKILL" || echo "0")
if [ "$TOOL_TABLE_ROWS" -ge 5 ]; then
  pass "tool recommendation table has $TOOL_TABLE_ROWS language entries (≥5)"
else
  fail "tool recommendation table has $TOOL_TABLE_ROWS entries (expected ≥5)"
fi

# --- Safe removal process steps ---
for step in "Step 1" "Step 2" "Step 3" "Step 4" "Step 5" "Step 6"; do
  if grep -q "### $step" "$SKILL"; then
    pass "safe removal '$step' present"
  else
    fail "safe removal '$step' missing"
  fi
done

# --- Key content sections ---
for section in "Static Analysis" "Dynamic Analysis" "Dependency Pruning" "Commented-Out Code" "Bloat Metrics" "Lava Flow"; do
  if grep -q "$section" "$SKILL"; then
    pass "section '$section' present"
  else
    fail "section '$section' missing"
  fi
done

# --- Cross-references ---
for ref in "code-yagni" "refactoring-patterns" "code-antipatterns" "code-scope-boundaries"; do
  if grep -q "(see $ref" "$SKILL"; then
    pass "cross-reference to '$ref' present"
  else
    fail "cross-reference to '$ref' missing"
  fi
done

# --- Decision tables ---
if grep -q "Decision Tables" "$SKILL"; then
  pass "decision tables section present"
else
  fail "decision tables section missing"
fi

# --- Common mistakes ---
if grep -q "Common Mistakes" "$SKILL"; then
  pass "common mistakes section present"
else
  fail "common mistakes section missing"
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
